USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetVoucherTierBrandPGByNoFaktur]    Script Date: 16/01/2023 10.50.24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin

-- Modified by
-- Author:		Anton
-- Create date: 10/01/2022
-- Description:	Promo Angpao

-- Modified by
-- Author:		Anton
-- Create date: 07/07/2022
-- Description:	Promo Kamis

-- Modified by
-- Author:		Anton
-- Create date: 07/08/2022
-- Description:	Promo Merdeka
-- =============================================

ALTER PROCEDURE [dbo].[PromoTier_GetVoucherTierBrandPGByNoFaktur]
@NoFaktur varchar(20),
@KodePromo varchar(20),
@NoMember varchar(20)
AS
BEGIN
DECLARE
@NoVoucher varchar(20),
@Tier varchar(20),
@MaxHargaValid int,
@KodeStore varchar(2),
@NoSO varchar(20),
@Urutan int,
@CekPromoTersedia int,
@KodeBarangDipilih varchar(20),
@KodeGudangDipilih varchar(20),
@AuthCode varchar(20),
@IsUrut int,
@PromoID varchar(20),
@Server varchar(20),
@CekMemberBeda varchar(20),
@KuotaTier int


SET @Server =''
SET @CekMemberBeda=''
SET @PromoID = (select top 1 PromoID from s_PromoTierHeader where KodePromo=@KodePromo)
IF EXISTS(SELECT NoFaktur FROM TrxFaktur where NoFaktur=@NoFaktur and KodeStore <> '07')
BEGIN
	SET @Server='HE'
	SELECT TOP 1 @KodeStore=KodeStore,@NoSO=NoSO FROM TrxFaktur where NoFaktur=@NoFaktur
	IF NOT EXISTS(SELECT NoFaktur FROM TrxFaktur where NoFaktur=@NoFaktur and (PointRewardTo=@NoMember OR NoFaktur='FK-04-K66-54711')) -- Pengecualian Faktur
		SET @CekMemberBeda = '1'
END
--ELSE IF EXISTS(SELECT NoFaktur FROM [192.168.9.28].Hartono.dbo.TrxFaktur where NoFaktur=@NoFaktur)
--BEGIN
--	SET @Server='HM'
--	SELECT TOP 1 @KodeStore=KodeStore,@NoSO=NoSO FROM [192.168.9.28].Hartono.dbo.TrxFaktur where NoFaktur=@NoFaktur
--	IF NOT EXISTS(SELECT NoFaktur FROM [192.168.9.28].Hartono.dbo.TrxFaktur where NoFaktur=@NoFaktur and PointRewardTo=@NoMember)
--		SET @CekMemberBeda = '1'
--END

	
		
	IF(@Server='')
		SELECT 'Nomor Faktur Tidak Ditemukan' As MSG
	ELSE IF(@CekMemberBeda='1')
		SELECT 'Member di Faktur Berbeda dengan Member di Aplikasi' As MSG
	--ELSE IF NOT EXISTS(SELECT NoMember FROM MasterMember where NoMember=@NoMember)
	--	SELECT 'Nomor Member Tidak Ditemukan' As MSG -- dibuka sementara untuk Promo Sony
	ELSE IF EXISTS(SELECT NoMember FROM MasterMember where NoMember=@NoMember and Blacklist=1)
		SELECT 'Member ini telah diblacklist' As MSG
	--ELSE IF NOT EXISTS(SELECT NoMember FROM MasterMember where NoMember=@NoMember and JenisMember='P')  -- dibuka sementara untuk Promo Sony
	--	SELECT 'Member Tidak Bisa mengikuti Promo ini' As MSG
	--ELSE IF (@NoMember = '00-00000001') -- dibuka sementara untuk Promo Sony
	--	SELECT 'Member Tidak Bisa mengikuti Promo ini' As MSG
	ELSE IF EXISTS (select NoMember from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where PromoID=@PromoID and StatusTerpakai = '1' and NoMember=@NoMember)
		SELECT 'Member Sudah Pernah Pakai Promo ini' As MSG
	ELSE IF EXISTS (select NoMember from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where PromoID=@PromoID and StatusKlaim = '1' and NoMember=@NoMember)
		SELECT 'Member Sudah Pernah Klaim Promo ini' As MSG
	ELSE IF (@KodePromo = 'PromoKamis' AND DATENAME(WEEKDAY, GETDATE()) <> 'Thursday')
		SELECT 'Promo hanya berlaku di hari Kamis' As MSG
	ELSE IF EXISTS (SELECT KodeJenisPembayaran FROM TrxFakturBayar WHERE NoFaktur=@NoFaktur AND KodeJenisPembayaran='VBB')
		SELECT 'Tipe Bayar Tidak Memenuhi Syarat Promo' As MSG -- Update check tipe bayar VBB 170822
	ELSE IF NOT EXISTS (SELECT * FROM TrxFaktur WHERE NoFaktur=@NoFaktur AND (StatusPembayaran <> 'Kredit' OR (StatusPembayaran = 'Kredit' AND NoMember IN (SELECT NoMember FROM MasterMemberFinance))))
		SELECT 'Faktur Kredit Tidak Berhak Mengikuti Promo' As MSG -- Update check tipe bayar VBB 170822
	ELSE
	BEGIN
		IF(@Server='HE')
		BEGIN
			select	 
					f.NoFaktur, 
					f.Tanggal, 
					f.NoMember, 
					f.PointRewardTo, 
					f.TotalHarga, 
					f.TotalPembayaran,
					d.KodeBarang,
					a.brand_name,
					d.SubtotalHarga,
					d.Jumlah,
					d.KodeGudang
				INTO #TempFaktur
				from 
					TrxFaktur f,
					TrxFakturDetail d,
					(select distinct material, old_mat_no, matl_group, brand_name, article_type,PUR_GROUP,brand_id from sap_article where DISCNTIN_IDC = 'False') a
				where
					f.NoFaktur = d.NoFaktur
					and d.KodeBarang = a.Old_Mat_No
					and a.article_type = 'HAWA'
					and
					(
						(a.brand_id+a.PUR_GROUP in(select BrandCode+PG from s_PromoTierListBrand where PromoID=@PromoID and status='1' and (Category='-' or Category='')))
						or
						(a.brand_id+a.PUR_GROUP+SUBSTRING(MATL_GROUP,0,5) in(select BrandCode+PG+Category from s_PromoTierListBrand where PromoID=@PromoID and status='1'))
						or
						(a.brand_id+a.PUR_GROUP+SUBSTRING(MATL_GROUP,0,5)+MATL_GROUP in(select BrandCode+PG+Category+Family from s_PromoTierListBrand where PromoID=@PromoID and status='1'))
						or
						(a.old_mat_no IN (select KodeBarang from s_PromoTierListKodeBarang where PromoID=@PromoID and status='1'))
					)
					and f.NoFaktur=@NoFaktur
					--and f.PointRewardTo <> '00-00000001' -- dibuka sementara untuk Promo Sony
					and f.NoFaktur not in (select NoFaktur from TrxReturPenjualan)
					and f.Tanggal >= '20221209' and f.Tanggal < '20221219' -- khusus Promo Sony 3
					--and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0) = DATEADD(dd, DATEDIFF(dd, 0, f.Tanggal), 0)
			END

		IF(@Server='HE')
		BEGIN
			SELECT TOP 1 @KodeBarangDipilih=KodeBarang, @KodeGudangDipilih=KodeGudang FROM #TempFaktur order by SubTotalHarga desc
			SET @MaxHargaValid = (select SUM(SubTotalHarga) from #TempFaktur)
		END
		--ELSE IF(@Server='HM')
		--BEGIN
		--	SELECT TOP 1 @KodeBarangDipilih=KodeBarang, @KodeGudangDipilih=KodeGudang FROM #TempFaktur2 order by SubTotalHarga desc			
		--	SET @MaxHargaValid = (select SUM(SubTotalHarga) from #TempFaktur2)
		--END
		
			IF (@MaxHargaValid is null)
				SELECT 'Faktur Tidak Memenuhi Syarat Promo' As MSG
			ELSE IF (@MaxHargaValid < 5000000)
				SELECT 'Nominal Barang Promo < 5 Juta Rupiah' As MSG
			ELSE
			BEGIN

			select top 1 @Tier=B.Tier,@Urutan=Urut,@IsUrut=IsUrut from s_PromoTierHeader A
			join s_PromoTierDetailTier B on A.PromoID=B.PromoID
			join s_PromoTierListSyaratHarga C on B.PromoID=C.PromoID and B.Tier=C.Tier
			where (DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)>= A.ValidFrom and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)<=A.ValidTo) and A.Status='1'
			and B.Status='1' and (DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)>= B.ValidFrom and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)<=B.ValidTo)
			and C.Status='1' and A.PromoID=@PromoID
			and (@MaxHargaValid>=C.HargaMin and @MaxHargaValid<=C.HargaMax) 
		
			IF(@Tier is null)
				SELECT 'Faktur Tidak Memenuhi Syarat Promo' As MSG
			ELSE
				BEGIN
				SET @CekPromoTersedia=0
				SET @AuthCode=''
				while(@Urutan>0)
					BEGIN
						IF EXISTS(select NoVoucher from s_PromoTierDetailVoucher where isActive='1' and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)>= ValidFrom and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)<=ValidTo and statusklaim='0' and PromoID=@PromoID and Tier=@Tier and statusterpakai='0' and KodeStore=@KodeStore)
							BEGIN
								SET @NoVoucher = (select TOP 1 NoVoucher from s_PromoTierDetailVoucher where isActive='1' and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)>= ValidFrom and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)<=ValidTo and statusklaim='0' and PromoID=@PromoID and Tier=@Tier and statusterpakai='0' and KodeStore=@KodeStore)
									
								UPDATE s_PromoTierDetailVoucher set StatusKlaim='1' where NoVoucher=@NoVoucher
						
								while(@AuthCode='')
								BEGIN
									SET @AuthCode=(SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9))
								END
						
								INSERT INTO t_PromoTierVoucherHistory(NoVoucher,NoMember,NoFaktur,NoSO,KodeBarang,KodeGudang,TanggalKlaim,UserIDKlaim,Status,AuthCode)
								VALUES(@NoVoucher,@NoMember,@NoFaktur,@NoSO,@KodeBarangDipilih,@KodeGudangDipilih,getdate(),'API',0,@AuthCode)
								SET @CekPromoTersedia=1
								SELECT @AuthCode AuthCode, A.NoVoucher, Nominal from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where A.NoVoucher=@NoVoucher and Status='0'
								break;
							END		
			
							IF(@IsUrut='0')
								break;
							SET @Urutan=@Urutan-1
							SET @Tier = (select top 1 Tier from s_PromoTierDetailTier where Urut=@Urutan and PromoID=@PromoID and status='1' and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)>= ValidFrom and DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)<=ValidTo)
					END
				IF(@CekPromoTersedia=0)
					SELECT 'Kuota Promo Tidak Tersedia' As MSG
			END
		END
	END
END



GO

