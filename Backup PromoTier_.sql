USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_CekValidBarcode]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin

-- Modified by : Anton
-- Modify date : 11/01/2022
-- Description : Ubah kode store bisa keroyokan

-- Modified by : Felicia
-- Modify date : 17/01/2023
-- Description : Ubah Tanggal Klaim harus hari yang sama

-- Modified by : Felicia
-- Modify date : 23/01/2023
-- Description : Ubah Tanggal Klaim Bisa sampai tanggal promo berakhir (Promo Sony)

-- Modified by : Felicia
-- Modify date : 22/02/2023
-- Description : Ubah Tanggal Klaim Bisa sampai tanggal promo berakhir (Promo Sony Feb)
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_CekValidBarcode]
@KodeBarcode varchar(20)
AS
BEGIN
	IF NOT EXISTS (SELECT a.NoVoucher
					FROM t_PromoTierVoucherHistory a
					JOIN s_PromoTierDetailVoucher b ON b.NoVoucher = a.NoVoucher 
					JOIN TrxFaktur c ON c.NoFaktur = a.NoFaktur AND ((c.KodeStore = b.KodeStore) OR b.KodeStore='00')
				WHERE a.AuthCode=@KodeBarcode)
		SELECT 'Faktur beda toko'
	ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='1' and AuthCode=@KodeBarcode)
		SELECT 'Member sudah Klaim Uang Kaget'
	ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='2' and AuthCode=@KodeBarcode)
		SELECT 'Kode Barcode sudah Tidak Berlaku'
	--ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where CONVERT(VARCHAR(10), TanggalKlaim, 23) <> CONVERT(VARCHAR(10), GETDATE(), 23) and status='0' and AuthCode=@KodeBarcode)
	--	SELECT 'Tanggal klaim melebihi tanggal faktur' -- Felicia 23/01/2023, tutup sementara promo sony 
	ELSE IF NOT EXISTS (select NoVoucher from t_PromoTierVoucherHistory where TanggalKlaim >= '20230223' and TanggalKlaim < '20230306' and status='0' and AuthCode=@KodeBarcode)
		SELECT 'Tanggal klaim melebihi tanggal promo' -- Felicia 23/01/2023, ditamabahkan untuk promo sony 
	ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='0' and AuthCode=@KodeBarcode)
		SELECT '1'
	ELSE
		SELECT 'Kode Barcode Tidak Ditemukan'

END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetVoucherTierBrandPGByNoFaktur]    Script Date: 31/05/2023 10.54.26 ******/
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

-- Modified by
-- Author:		Felicia
-- Create date: 16/01/2023
-- Description:	Promo Imlek 2023

-- Modified by
-- Author:		Felicia
-- Create date: 23/01/2023
-- Description:	Promo Sony Januari 2023

-- Modified by
-- Author:		Felicia
-- Create date: 22/02/2023
-- Description:	Promo Sony Februari 2023
-- =============================================

CREATE PROCEDURE [dbo].[PromoTier_GetVoucherTierBrandPGByNoFaktur]
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
	ELSE IF EXISTS (SELECT KodeJenisPembayaran FROM TrxFakturBayar WHERE NoFaktur=@NoFaktur AND KodeJenisPembayaran IN ('VBB','RPVBB'))
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
					and f.Tanggal >= '20230223' and f.Tanggal < '20230306' -- khusus Promo Sony 3
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

/****** Object:  StoredProcedure [dbo].[PromoTier_AutoBatalClaimPromo]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	AutoBatalClaimPromo

-- Modified by
-- Author:		Felicia
-- Create date: 16/01/2023
-- Description:	Promo Imlek 2023

-- Modified by
-- Author:		Felicia
-- Create date: 23/01/2023
-- Description:	Promo Sony Januari 2023
-- =============================================

CREATE PROCEDURE [dbo].[PromoTier_AutoBatalClaimPromo]
AS
BEGIN

SELECT  A.NoVoucher, NoFaktur, NoMember, A.Tier
INTO #tempVoucher
from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher 
where StatusTerpakai='0' and StatusKlaim='1' and Status='0'
--and (DATEDIFF(second, TanggalKlaim, getdate()) / 3600.0) >= 2
and (DATEDIFF(second, TanggalKlaim, getdate()) / 3600.0) >= 9999 -- Felicia 23/01/2023, untuk promo sony 

Update s_PromoTierDetailVoucher set StatusKlaim='0' where NoVoucher in (SELECT NoVoucher FROM #tempVoucher)
Update t_PromoTierVoucherHistory set Status='2' where NoVoucher in (SELECT NoVoucher FROM #tempVoucher) and Status=0

-- Reset Tier Promo Merdeka
--Update s_PromoTierDetailVoucher set Tier='Tier', Nominal = '0' where PromoID='PR7' AND StatusKlaim='0' AND StatusTerpakai='0' AND NoVoucher in (SELECT NoVoucher FROM #tempVoucher)

SELECT NoVoucher,NoFaktur,NoMember,Tier from #tempVoucher
drop table #tempVoucher

END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetDataMemberByKodeBarcode]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================
-- =============================================
-- Modified By		: Soni.Gunawan
-- modified date	: 20/01/2023
-- Description		: Promo Imlek
-- =============================================

CREATE PROCEDURE [dbo].[PromoTier_GetDataMemberByKodeBarcode]
	@KodeBarcode varchar(20)
AS
BEGIN
DECLARE
	@NoFaktur varchar(30),
	@Server varchar(10)

	SET @NoFaktur = (select TOP 1 NoFaktur from t_PromoTierVoucherHistory where AuthCode=@KodeBarcode)
	IF EXISTS(SELECT NoFaktur FROM TrxFaktur where NoFaktur=@NoFaktur)
	BEGIN
		SET @Server='HE'
	END
	ELSE IF EXISTS(SELECT NoFaktur FROM [192.168.9.28].Hartono.dbo.TrxFaktur where NoFaktur=@NoFaktur)
	BEGIN
		SET @Server='HM'
	END

	IF(@Server='HE')
	BEGIN
		select AuthCode,A.NoFaktur,CONVERT(varchar(20),C.Tanggal,103)+' '+CONVERT(varchar(20),C.Tanggal,108)TanggalFaktur,
			NoKartuMember,CONVERT(varchar(20),A.TanggalKlaim,103)+' '+CONVERT(varchar(20),A.TanggalKlaim,108) TanggalKlaim,
			NamaMember,NoHP,NoKTP,AttachmentKTP,D.Nominal, (select count(Z.NoVoucher)+1 from t_PromoTierHistoryCetakUlang Z where Z.NoVoucher=A.NoVoucher) JumlahCopy,
			A.NoVoucher,A.NoMember, (select isnull(HeaderPrintOut, '') from s_PromoTierHeader where PROMOID=D.PromoID) HeaderPrintOut,
			(select KodePromo from s_PromoTierHeader where PROMOID=D.PromoID) KodePromo 		
		from t_PromoTierVoucherHistory A
			join MasterMember B on A.NoMember=B.NoMember
			join TrxFaktur C on A.NoFaktur=C.NoFaktur
			join s_PromoTierDetailVoucher D on D.NoVoucher=A.NoVoucher
		where AuthCode=@KodeBarcode
	END
	ELSE IF(@Server='HM')
	BEGIN
		select AuthCode,A.NoFaktur,CONVERT(varchar(20),C.Tanggal,103)+' '+CONVERT(varchar(20),C.Tanggal,108)TanggalFaktur,
			NoKartuMember,CONVERT(varchar(20),A.TanggalKlaim,103)+' '+CONVERT(varchar(20),A.TanggalKlaim,108) TanggalKlaim,
			NamaMember,NoHP,NoKTP,AttachmentKTP,D.Nominal, (select count(Z.NoVoucher)+1 from t_PromoTierHistoryCetakUlang Z where Z.NoVoucher=A.NoVoucher) JumlahCopy,
			A.NoVoucher,A.NoMember, (select isnull(HeaderPrintOut, '') from s_PromoTierHeader where PROMOID=D.PromoID) HeaderPrintOut,
			(select KodePromo from s_PromoTierHeader where PROMOID=D.PromoID) KodePromo 		
		from t_PromoTierVoucherHistory A
			join MasterMember B on A.NoMember=B.NoMember
			join [192.168.9.28].Hartono.dbo.TrxFaktur C on A.NoFaktur=C.NoFaktur
			join s_PromoTierDetailVoucher D on D.NoVoucher=A.NoVoucher
		where AuthCode=@KodeBarcode
	END
END

GO

/****** Object:  StoredProcedure [dbo].[PromoTier_SaveLogAPI]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Create By	: DAvid Christian
-- Create Date	: 10/09/2021
-- Description	: Log API Promo Tier
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_SaveLogAPI]
	@EndPoint	varchar(50)='',
	@Request	varchar(500)='',
	@Response	varchar(MAX)=''
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].t_PromoTierLogAPIHistory (
		[EndPoint]
		,[Request]
		,[Response]
		,[Tanggal]
	) VALUES (
		@EndPoint,
		@Request,
		@Response,
		GETDATE()
	)

END

GO

/****** Object:  StoredProcedure [dbo].[PromoTier_CheckUpdateVoucher]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		|Anton Nyoto|
-- Create date: |07/08/2022|
-- Description: |Check Update Voucher|
-- Project:		|Promo Merdeka Agustus 2022|
-- =============================================

CREATE PROCEDURE [dbo].[PromoTier_CheckUpdateVoucher]
	@KodePromo varchar(20),
    @NoMember varchar(20),
	@NoFaktur varchar(100),
	@NoVoucher varchar(50),
	@Nilai varchar(50)
AS
BEGIN
	DECLARE
		@ExistingStatus VARCHAR(20),
		@Validasi VARCHAR(200),
		@Umur VARCHAR(20),
		@Tier VARCHAR(20),
		@Nominal VARCHAR(50),
		@PromoID VARCHAR(20),
		@JumlahVoucher int

	SET @Validasi = '' -- kurang ini
	SET @PromoID = (select top 1 PromoID from s_PromoTierHeader where KodePromo=@KodePromo)

	SELECT
		@ExistingStatus = Status
	FROM t_PromoTierVoucherHistory a
	JOIN s_PromoTierDetailVoucher b ON a.NoVoucher = b.NoVoucher
	WHERE a.NoMember = @NoMember AND a.NoFaktur = @NoFaktur AND a.NoVoucher = @NoVoucher AND b.PromoID = @PromoID
	
	IF (@ExistingStatus = '0')
		BEGIN
			SET @Umur = DATEDIFF(HOUR, @Nilai ,GETDATE())/8766
			SET @Nominal = 0

			-- Voucher baru per tanggal 18/08/2022
			IF (@Umur >= 20 AND @Umur <= 50)
				BEGIN
					SET @Nominal = 100000
					SET @Tier = 'Tier1-2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 300)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 51 AND @Umur <= 70)
				BEGIN
					SET @Nominal = 200000
					SET @Tier = 'Tier2-2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 200)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 71 AND @Umur <= 80)
				BEGIN
					SET @Nominal = 300000
					SET @Tier = 'Tier3-2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 38)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 81 AND @Umur <= 90)
				BEGIN
					SET @Nominal = 500000
					SET @Tier = 'Tier4-2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 24)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 91)
				BEGIN
					SET @Nominal = 600000
					SET @Tier = 'Tier5-2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 25)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE
				BEGIN
					SET @Validasi = 'Usia tidak sesuai dengan SKB yang berlaku' -- pesan error jika umur < 20
				END

			/* -- Voucher lama stop per tanggal 18/08/2022
			-- Voucher baru per tanggal 16/08/2022
			IF (@Umur >= 20 AND @Umur <= 50)
				BEGIN
					SET @Nominal = 100000
					SET @Tier = 'Tier1-1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 500)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 51 AND @Umur <= 70)
				BEGIN
					SET @Nominal = 300000
					SET @Tier = 'Tier2-1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 200)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 71 AND @Umur <= 80)
				BEGIN
					SET @Nominal = 400000
					SET @Tier = 'Tier3-1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 50)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 81 AND @Umur <= 90)
				BEGIN
					SET @Nominal = 500000
					SET @Tier = 'Tier4-1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 25)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 91)
				BEGIN
					SET @Nominal = 600000
					SET @Tier = 'Tier5-1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 25)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE
				BEGIN
					SET @Validasi = 'Usia tidak sesuai dengan SKB yang berlaku' -- pesan error jika umur < 20
				END
			*/

			/* -- Voucher lama stop per tanggal 16/08/2022
			IF (@Umur >= 20 AND @Umur <= 30)
				BEGIN
					SET @Nominal = 200000
					SET @Tier = 'Tier1'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 430)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 31 AND @Umur <= 40)
				BEGIN
					SET @Nominal = 300000
					SET @Tier = 'Tier2'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 131)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 41 AND @Umur <= 50)
				BEGIN
					SET @Nominal = 400000
					SET @Tier = 'Tier3'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 81)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 51 AND @Umur <= 75)
				BEGIN
					SET @Nominal = 500000
					SET @Tier = 'Tier4'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 51)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE IF (@Umur >= 76)
				BEGIN
					SET @Nominal = 600000
					SET @Tier = 'Tier5'
					SET @JumlahVoucher = (SELECT COUNT(NoVoucher) FROM s_PromoTierDetailVoucher WHERE PromoID = @PromoID AND Tier = @Tier)
					IF (@JumlahVoucher >= 28)
						BEGIN
							SET @Validasi = 'Maaf anda kurang beruntung'
						END
				END
			ELSE
				BEGIN
					SET @Validasi = 'Usia tidak sesuai dengan SKB yang berlaku' -- pesan error jika umur < 20
				END
			*/

			IF(@Validasi = '')
				BEGIN
					UPDATE s_PromoTierDetailVoucher SET Nominal = @Nominal, Tier = @Tier WHERE PromoID = @PromoID AND NoVoucher = @NoVoucher AND StatusKlaim = '1' AND StatusTerpakai = '0'
			
					SELECT a.AuthCode, a.NoVoucher, b.Nominal
					FROM t_PromoTierVoucherHistory a
					JOIN s_PromoTierDetailVoucher b ON a.NoVoucher = b.NoVoucher
					WHERE a.NoMember = @NoMember AND a.NoFaktur = @NoFaktur AND a.NoVoucher = @NoVoucher AND b.PromoID = @PromoID
				END
		END
	ELSE
		BEGIN
			SET @Validasi = 'No Voucher tidak ditemukan'
		END

	IF(@Validasi <> '')
		SELECT @Validasi AS 'ErrMsg'
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetVoucherUlangTierBrandPGByNoFaktur]    Script Date: 31/05/2023 10.54.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================


CREATE PROCEDURE [dbo].[PromoTier_GetVoucherUlangTierBrandPGByNoFaktur]
@NoFaktur varchar(20),
@KodePromo varchar(20),
@UserLoginID varchar(20),
@NoMember varchar(20)
AS
BEGIN
DECLARE
@NoVoucher varchar(20),
@Server varchar(20)

SET @Server=''
	IF EXISTS(SELECT NoFaktur FROM TrxFaktur where NoFaktur=@NoFaktur)
	BEGIN
		SET @Server='HE'
	END
	ELSE IF EXISTS(SELECT NoFaktur FROM [192.168.9.28].Hartono.dbo.TrxFaktur where NoFaktur=@NoFaktur)
	BEGIN
		SET @Server='HM'
	END

	IF EXISTS(SELECT AuthCode, A.NoVoucher,NoMember,NoFaktur,Nominal,status,''As MSG from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where B.NoFaktur=@NoFaktur and PromoID=(select top 1 promoid from s_PromoTierHeader where kodepromo=@KodePromo) and statusklaim='1')
		BEGIN

		IF(@Server='HE')
		BEGIN
			IF NOT EXISTS(select * from trxfaktur where NoFaktur=@NoFaktur and PointRewardTo=@NoMember)
				SELECT 'Member di Faktur Berbeda dengan Member di Aplikasi' As MSG
			ELSE
			BEGIN
				SET @NoVoucher = (SELECT TOP 1 A.NoVoucher from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where B.NoFaktur=@NoFaktur and PromoID=(select top 1 promoid from s_PromoTierHeader where kodepromo=@KodePromo))
				SELECT TOP 1 AuthCode, A.NoVoucher,Nominal from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where B.NoFaktur=@NoFaktur and PromoID=(select top 1 promoid from s_PromoTierHeader where kodepromo=@KodePromo)
				--INSERT INTO t_PromoTierHistoryCetakUlang values (@NoVoucher,getdate(),@UserLoginID)
			END
		END
		ELSE IF(@Server='HM')
		BEGIN
			IF NOT EXISTS(select * from [192.168.9.28].Hartono.dbo.trxfaktur where NoFaktur=@NoFaktur and PointRewardTo=@NoMember)
				SELECT 'Member di Faktur Berbeda dengan Member di Aplikasi' As MSG
			ELSE
			BEGIN
				SET @NoVoucher = (SELECT TOP 1 A.NoVoucher from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where B.NoFaktur=@NoFaktur and PromoID=(select top 1 promoid from s_PromoTierHeader where kodepromo=@KodePromo))
				SELECT TOP 1 AuthCode, A.NoVoucher,Nominal from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher where B.NoFaktur=@NoFaktur and PromoID=(select top 1 promoid from s_PromoTierHeader where kodepromo=@KodePromo)
				--INSERT INTO t_PromoTierHistoryCetakUlang values (@NoVoucher,getdate(),@UserLoginID)
			END
		END
	END
	ELSE
		SELECT 'Data Tidak Ditemukan'As MSG
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_HistoryKlaimUangKaget]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 15/09/2021
-- Description:	History Klaim Uang Kaget

-- modified : Daniel
-- 27/09/2021
-- Merubah nomember

-- Modified by : Anton
-- Modify date : 11/01/2022
-- Description : Ubah parameter store mengikuti faktur, tanggal klaim mengikuti tanggal redeem di kasir
-- =============================================


CREATE PROCEDURE [dbo].[PromoTier_HistoryKlaimUangKaget]
	@kodestore    varchar(10),
	@TanggalAwal  varchar(50),
	@TanggalAkhir varchar(50),
	@PromoID varchar(40)
AS
BEGIN

	SET NOCOUNT ON;    
	


	SELECT  * 
	FROM 
			(								
				select 	
					convert(varchar(10),c.Tanggal,103)+' '+convert(varchar(10),c.Tanggal,108)  as tgljamFaktur,
					c.nofaktur,
					(select ''''+(select top 1 nokartumember from mastermember where nomember = c.PointRewardTo)) as nokartumember,
					--(select top 1 PointRewardTo from trxfaktur where nofaktur = c.nofaktur)as nokartumember,
					(select top 1 namamember from mastermember where nomember = c.nomember) as namamember,
					convert(varchar(10),TanggalPakai,103) +' '+convert(varchar(10),a.TanggalPakai,108) as TglJamKlaim,
					(select top 1 NIlaiVoucher from s_PromoTierDetailTier where Tier = b.Tier AND PromoID = @PromoID) as NominalVoucher,
					(select top 1 namauser from masteruser where userid = c.kodeuserkasir) as namaksir,
					b.Tier,
					a.AuthCode as Novoucher,
					(select NamaLokasi from masterStore where KodeStore = b.kodestore) as NamaLokasi,
					c.Tanggal
				from 
					t_PromoTierVoucherHistory a inner join s_PromoTierDetailVoucher b on a.NoVoucher = b.Novoucher  and a.Status = 1
					inner join trxfaktur c on  c.nofaktur = a.nofaktur
				where 
					b.StatusTerpakai = 1 
					and 
						b.PromoID = @PromoID
					and
						c.kodestore = @kodestore
					and
						convert(datetime,convert(varchar(10),TanggalPakai,103),103) 
					between 
						convert(datetime,convert(varchar(10),@TanggalAwal,103),103) 
					and 
						convert(datetime,convert(varchar(10),@TanggalAkhir,103),103)
			union all
			select 	
					convert(varchar(10),c.Tanggal,103)+' '+convert(varchar(10),c.Tanggal,108)  as tgljamFaktur,
					c.nofaktur,
					(select top 1 nokartumember from mastermember where nomember = c.PointRewardTo) as nokartumember,
					--(select top 1 PointRewardTo from trxfaktur where nofaktur = c.nofaktur)as nokartumember,
					(select top 1 namamember from mastermember where nomember = c.nomember) as namamember,
					convert(varchar(10),TanggalPakai,103) +' '+convert(varchar(10),a.TanggalPakai,108) as TglJamKlaim,
					(select top 1 NIlaiVoucher from s_PromoTierDetailTier where Tier = b.Tier AND PromoID = @PromoID) as NominalVoucher,
					(select top 1 namauser from masteruser where userid = c.kodeuserkasir) as namaksir,
					b.Tier,
					a.AuthCode as Novoucher,
					(select NamaLokasi from masterStore where KodeStore = b.kodestore) as NamaLokasi,
					c.Tanggal
				from 
					t_PromoTierVoucherHistory a inner join s_PromoTierDetailVoucher b on a.NoVoucher = b.Novoucher  and a.Status = 1
					inner join [192.168.9.28].Hartono.dbo.trxfaktur c on  c.nofaktur = a.nofaktur
				where 
					b.StatusTerpakai = 1 
					and 
						b.PromoID = @PromoID
					and
						c.kodestore = @kodestore
					and
						convert(datetime,convert(varchar(10),TanggalPakai,103),103) 
					between 
						convert(datetime,convert(varchar(10),@TanggalAwal,103),103) 
					and 
						convert(datetime,convert(varchar(10),@TanggalAkhir,103),103)
						) dum
	order by tier,Tanggal asc
END




GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetSaldoAwal]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Daniel
-- Create date: 13/09/2021
-- Description:	PromoTier Saldo Awal

-- Modified by
-- Author:		Anton
-- Create date: 10/01/2021
-- Description:	Promo Angpao
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_GetSaldoAwal]
	-- Add the parameters for the stored procedure here
	@KodeStore varchar(10),
	@Promoid varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 select a.PromoID as Promo,a.Tier,a.Quota,(select Quota * NilaiVoucher from s_PromoTierDetailTier where kodestore = a.kodestore and promoid = a.promoid and tier = a.tier) as SaldoAwal,
(select count(NoVoucher)  from s_PromoTierDetailVoucher where PromoID = a.promoid  and Tier = a.Tier and KodeStore = a.KodeStore and StatusTerpakai = 1 ) as QuotaTerpakai,
(a.NilaiVoucher*(select count(NoVoucher)  from s_PromoTierDetailVoucher where PromoID = a.promoid  and Tier = a.Tier and KodeStore = a.KodeStore and StatusTerpakai = 1 )) as SaldoTerpakai,
(a.Quota-(select count(NoVoucher)  from s_PromoTierDetailVoucher where PromoID = a.promoid  and Tier = a.Tier and KodeStore = a.KodeStore and StatusTerpakai = 1 ))as QuotaSisa,
(a.NilaiVoucher*(a.Quota-(select count(NoVoucher)  from s_PromoTierDetailVoucher where PromoID = a.promoid  and Tier = a.Tier and KodeStore = a.KodeStore and StatusTerpakai = 1 )))as SaldoSisa,
a.KodeStore,(select NamaLokasi from masterStore where KodeStore = a.kodestore) as NamaLokasi,
(select top 1 NilaiVoucher from s_PromoTierDetailTier where kodestore = a.kodestore and promoid = a.promoid and tier = a.tier) as NilaiVoucher
 
from s_PromoTierDetailTier a
where (a.kodestore = @KodeStore OR a.kodestore = '00') and a.promoid = @Promoid  -- ini untuk perstore // Modified by Anton untuk baca voucher all store
--a.promoid = @Promoid 
END


GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetPromoPerhari]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 14/09/2021
-- Description:	Get Promo Terpakai per Hari
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_GetPromoPerhari]
	-- Add the parameters for the stored procedure here
	@KodeStore varchar(20),
	@Tier varchar(50),
	@PromoID varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
  -- 	select a.NoVoucher,a.NoMember,a.NoFaktur,convert(varchar(10),TanggalKlaim,103) as TglKlaim,b.Tier,(select NamaLokasi from masterStore where KodeStore = b.kodestore) as NamaAlamat 
		--from t_PromoTierVoucherHistory a inner join s_PromoTierDetailVoucher b on a.NoVoucher = b.Novoucher  and a.Status = 1
		--where b.Kodestore = @KodeStore and b.StatusTerpakai = 1 and b.Tier = @Tier
		if(@KodeStore = 'ALL Store')
		begin
			select  count(convert(varchar(10),TanggalKlaim,103)) as JumlahKlaim ,
					convert(varchar(10),TanggalKlaim,103) as TglKlaim ,
					b.Tier,
					(select NamaLokasi from masterStore where KodeStore = b.kodestore) as NamaAlamat 
			from t_PromoTierVoucherHistory a inner join s_PromoTierDetailVoucher b on a.NoVoucher = b.Novoucher  and a.Status = 1
			where b.StatusTerpakai = 1   and b.Tier = @Tier AND b.PromoID = @PromoID
			group by convert(varchar(10),TanggalKlaim,103),b.Tier,b.kodestore
		end
		else
		begin
			select  count(convert(varchar(10),TanggalKlaim,103)) as JumlahKlaim ,
					convert(varchar(10),TanggalKlaim,103) as TglKlaim ,
					b.Tier,
					(select NamaLokasi from masterStore where KodeStore = b.kodestore) as NamaAlamat 
			from t_PromoTierVoucherHistory a inner join s_PromoTierDetailVoucher b on a.NoVoucher = b.Novoucher  and a.Status = 1
			where b.StatusTerpakai = 1  and b.KodeStore = @KodeStore and b.Tier = @Tier AND b.PromoID = @PromoID
			group by convert(varchar(10),TanggalKlaim,103),b.Tier,b.kodestore
		end
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GenerateVoucher]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 17/09/2021
-- Description:	Generate Voucher
-- =============================================
Create PROCEDURE [dbo].[PromoTier_GenerateVoucher]
	-- Add the parameters for the stored procedure here
	        @Quota int,
            @PromoID varchar(500),
            @Tier varchar(500),
            @ValiFrom datetime,
            @ValidTo datetime,
            @JenisVoucher varchar(500),
            @Kodestore varchar(500),
			@nominal int,
			@UserID varchar(500)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Counter INT 
	SET @Counter=1
	WHILE ( @Counter <= @Quota)
	BEGIN
		DECLARE
		@count int,
		@GenerateVoucher varchar(100),
		@NoVoucher varchar(200),
		@KodestorePusatUntukGenerateVoucher varchar(100)

		SELECT @count=count(*) FROM s_PromoTierDetailVoucher 
			where PromoID = @PromoID AND --Tier = @Tier and
			KodeStore = @Kodestore
		
		if(@KodestorePusatUntukGenerateVoucher = '--')
		begin
			set @KodestorePusatUntukGenerateVoucher = (select '99')
		end
		else
		begin
			set @KodestorePusatUntukGenerateVoucher = (select @Kodestore)
		end

		IF @count > 0
		begin
			SET @NoVoucher = (SELECT MAX(SUBSTRING(NoVoucher,1,15)) FROM s_PromoTierDetailVoucher where PromoID = @PromoID AND --Tier = @Tier and
			KodeStore = @Kodestore)
			SET @GenerateVoucher = @PromoID+'-'+@KodestorePusatUntukGenerateVoucher+'-'+(SELECT RIGHT(REPLICATE('0', 6) + cast(max(RIGHT(@NoVoucher,6))+1 as varchar(7)), 6))
		end
		ELSE
		begin
			SET @GenerateVoucher = @PromoID+'-'+@KodestorePusatUntukGenerateVoucher+'-'+'000001'
		end
	
		--PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
		INSERT INTO [s_PromoTierDetailVoucher]
           ([NoVoucher]
           ,[Nominal]
           ,[PromoID]
           ,[Tier]
           ,[ValidFrom]
           ,[ValidTo]
           ,[StatusKlaim]
           ,[StatusTerpakai]
           ,[JenisVoucher]
           ,[KodeStore]
           ,[isActive]
           ,[CreatedOn]
           ,[CreatedBy])
     VALUES
           (@GenerateVoucher
           ,@nominal
           ,@PromoID
           ,@Tier
           ,@ValiFrom
           ,@ValidTo
           ,0
           ,0
           ,@JenisVoucher
           ,@Kodestore
           ,1
           ,getdate()
           ,@UserID
          )
		SET @Counter  = @Counter  + 1
	END

	UPDATE [dbo].[s_PromoTierDetailTier]
	   SET
		  [GeneratedVoucher] = '1'
		  
	  where PromoID = @PromoID AND Tier = @Tier and
			KodeStore = @Kodestore
 
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_UpdateDataMemberByKodeBarcode]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_UpdateDataMemberByKodeBarcode]
@KodeBarcode varchar(20),
@UserIDLogin varchar(20)
AS
BEGIN
declare
@NoVoucher varchar(20)

SET @NoVoucher = (select TOP 1 NoVoucher from t_PromoTierVoucherHistory where AuthCode=@KodeBarcode)
UPDATE s_PromoTierDetailVoucher set statusterpakai='1' where NoVoucher=@NoVoucher 
UPDATE t_PromoTierVoucherHistory set status='1',TanggalPakai=getdate(),UserIDPakai=@UserIDLogin  where AuthCode=@KodeBarcode 
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_CekValidBarcodeCetakUlang]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_CekValidBarcodeCetakUlang]
@KodeBarcode varchar(20)
AS
BEGIN

	IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='1' and AuthCode=@KodeBarcode)
		SELECT '1'
	ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='2' and AuthCode=@KodeBarcode)
		SELECT 'Kode Barcode sudah Tidak Berlaku'
	ELSE IF EXISTS (select NoVoucher from t_PromoTierVoucherHistory where status='0' and AuthCode=@KodeBarcode)
		SELECT 'Member Belum Klaim Uang Kaget'
	ELSE
		SELECT 'Kode Barcode Tidak Ditemukan'

END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_CetakUlangKlaimUangPromoVaksin]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_CetakUlangKlaimUangPromoVaksin]
@AuthCode varchar(20),
@UserLoginID varchar(20)
AS
BEGIN
DECLARE
@NoVoucher varchar(20)

SET @NoVoucher = (select TOP 1 NoVoucher from t_PromoTierVoucherHistory where AuthCode=@AuthCode and status='1')
IF(@NoVoucher is not null)
	BEGIN
	INSERT INTO t_PromoTierHistoryCetakUlang values (@NoVoucher,getdate(),@UserLoginID)
	SELECT '1'
	END
ELSE
	SELECT '0'
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetMasterPromo]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 13/09/2021
-- Description:	Promo Tier Master
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_GetMasterPromo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
   select Distinct a.PromoID,a.NamaPromo from s_PromoTierHeader a, s_PromoTierDetailTier b
   where
	a.PromoID = b.PromoID 
END

GO

/****** Object:  StoredProcedure [dbo].[PromoTier_InsertLogHistoryKlaimAPI]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David
-- Create date: 13/09/2021
-- Description:	Get List BrandPG
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_InsertLogHistoryKlaimAPI]
@NoFaktur varchar(50),
@KodePromo varchar(50),
@NoMember varchar(50),
@NoVoucher varchar(50),
@StatusKlaim varchar(50),
@request varchar(MAX),
@response varchar(MAX),
@status varchar(50),
@Message varchar(100)
AS
DECLARE
@Urut int

SET @Urut = (select count(*)+1 from t_PromoTierLogHistoryKlaimAPI)
if(@StatusKlaim='')
SET @StatusKlaim=null

BEGIN
  INSERT into t_PromoTierLogHistoryKlaimAPI(LogID,NoFaktur,KodePromo,NoMember,NoVoucher,StatusKlaim,request,response,status,Message,createdDate) 
  values (@Urut,@NoFaktur,@KodePromo,@NoMember,@NoVoucher,@StatusKlaim,@request,@response,@status,@Message,getdate())
END

GO

/****** Object:  StoredProcedure [dbo].[PromoTier_AddQuotaPromo]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 17/09/2021
-- Description:	Add Quota 
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_AddQuotaPromo]
	@AddQuota int,
	@PromoID varchar(50),
	@Tier varchar(50),
	@KodeStore varchar(50),
	@UserID varchar(50),
	@Pusat varchar(50)
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Declare @QuotaTambah int
   set  @QuotaTambah = (select Quota + @AddQuota  from  s_PromoTierDetailTier where tier = @Tier and KodeStore = @KodeStore and PromoID = @PromoID)

 

   if(@Pusat = 'y')
   begin
	   UPDATE [s_PromoTierDetailTier]
		   SET 
			   [Quota] = @QuotaTambah    
	   where tier = @Tier and KodeStore = @KodeStore and PromoID = @PromoID
	end
	if(@Pusat = 'n')
	begin
		DECLARE @Counter INT 
		SET @Counter=1
		WHILE ( @Counter <= @AddQuota)
		BEGIN
			DECLARE
			@count int,
			@GenerateVoucher varchar(100),
			@NoVoucher varchar(200),
			@JenisVoucher varchar(200),
			@ValiFrom datetime,
			@ValidTo datetime,
			@nominal int
			

		
			SELECT top 1 @nominal=Nominal FROM s_PromoTierDetailVoucher 
				where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore

				select  top 1 @ValiFrom=ValidFrom FROM s_PromoTierDetailVoucher 
				where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore

				select  top 1 @ValidTo = ValidTo FROM s_PromoTierDetailVoucher 
				where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore

				select  top 1 @jenisVoucher = JenisVoucher from s_PromoTierDetailVoucher 
				where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore

			SELECT @count=count(*) FROM s_PromoTierDetailVoucher 
				where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore

			IF @count > 0
			begin
				SET @NoVoucher = (SELECT MAX(SUBSTRING(NoVoucher,1,15)) FROM s_PromoTierDetailVoucher where PromoID = @PromoID AND Tier = @Tier and
				KodeStore = @Kodestore)
				SET @GenerateVoucher = @PromoID+'-'+@Kodestore+'-'+(SELECT RIGHT(REPLICATE('0', 6) + cast(max(RIGHT(@NoVoucher,6))+1 as varchar(7)), 6))
			end
			ELSE
			begin
				SET @GenerateVoucher = @PromoID+'-'+@Kodestore+'-'+'000001'
			end
	
			--PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
			INSERT INTO [s_PromoTierDetailVoucher]
			   ([NoVoucher]
			   ,[Nominal]
			   ,[PromoID]
			   ,[Tier]
			   ,[ValidFrom]
			   ,[ValidTo]
			   ,[StatusKlaim]
			   ,[StatusTerpakai]
			   ,[JenisVoucher]
			   ,[KodeStore]
			   ,[isActive]
			   ,[CreatedOn]
			   ,[CreatedBy])
		 VALUES
			   (@GenerateVoucher
			   ,@nominal
			   ,@PromoID
			   ,@Tier
			   ,@ValiFrom
			   ,@ValidTo
			   ,0
			   ,0
			   ,@jenisVoucher
			   ,@KodeStore
			   ,1
			   ,getdate()
			   ,@UserID
			  )
			SET @Counter  = @Counter  + 1
		END
	end
		
	UPDATE [dbo].[s_PromoTierDetailTier]
	   SET
		  [GeneratedVoucher] = '1'
		  
	  where PromoID = @PromoID AND Tier = @Tier and
			KodeStore = @KodeStore
 

END

GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetKodeStoreByFaktur]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_GetKodeStoreByFaktur]
@NoFaktur varchar(20)
AS
BEGIN
Select top 1 KodeStore from trxfaktur where nofaktur=@NoFaktur
END


GO

/****** Object:  StoredProcedure [dbo].[PromoTier_GetServerPromoTier]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	Promo Vaksin
-- =============================================



CREATE PROCEDURE [dbo].[PromoTier_GetServerPromoTier]
@KodePromo varchar(20)
AS
BEGIN
select Server from s_PromoTierHeader where KodePromo=@KodePromo
END
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_JobGetGagalKirimAPI]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 20/09/2021
-- Description:	Job Get gagal kirim api
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_JobGetGagalKirimAPI] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--declare @dateexpired datetime
	--set @dateexpired = (select convert(datetime,(convert(varchar(10),getdate()+2,103)),103))

 --   select * from t_PromoTierLogHistoryKlaimAPI where  
	--UPDATE [t_PromoTierLogHistoryKlaimAPI]
	--   SET 
	--	   [Status] = 'E'
	--	  ,[ModifiedDate] = getdate()
	-- WHERE (select convert(datetime,(convert(varchar(10),CreateDate,103)),103)) = @dateexpired

	select NoFaktur,KodePromo,NoMember,NoVoucher,StatusKlaim,Status,LogID from t_PromoTierLogHistoryKlaimAPI where status = 'E'

END


GO

/****** Object:  StoredProcedure [dbo].[PromoTier_UpdateKirimUlangAPI]    Script Date: 31/05/2023 10.54.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 21/09/2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PromoTier_UpdateKirimUlangAPI]
	-- Add the parameters for the stored procedure here
	@LogID varchar(50),
	@Status varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE [t_PromoTierLogHistoryKlaimAPI]
	   SET [Status] = @Status           
		  ,[ModifiedDate] = getdate()
	 WHERE LogID = @LogID

END

GO

