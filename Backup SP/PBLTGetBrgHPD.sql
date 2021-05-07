USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PBLTGetBrgHPDBDB]    Script Date: 29/10/2020 09.40.03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author			: David Christian H
-- Create date		: 23/10/2020
-- Description		: BLT Promo HPD BDB
-- =============================================

ALTER PROCEDURE [dbo].[PBLTGetBrgHPDBDB]
	@NoFaktur	varchar(18)
as

if exists (
	select 
		h.NoFaktur
	from 
		(
		select 
			f.NoFaktur, 
			f.Tanggal,
			f.NoMember,
			f.PointRewardTo,
			f.TotalHarga,
			f.TotalPembayaran,
			isnull((select 
					count(b.KodeJenisPembayaran) 
				from 
					TrxFakturBayar b, 
					MasterVoucherBuyBack v, 
					TrxFaktur x 
				where 
					b.NoFaktur = f.NoFaktur 
					and b.KodeJenisPembayaran = 'VBB' 
					and b.NoJenisPembayaran = v.NoVoucherBuyBack
					and v.NoFaktur = x.NoFaktur
					and cast(convert(varchar, x.Tanggal, 111) as datetime) <> cast(convert(varchar, v.Tanggal, 111) as datetime)
				), 0) as JumVBB,
			isnull((SELECT count(KodePromo) from PR_TrxSODetailWithPromo where noso=f.NoSO and KodePromo in 
			('100052945-01',
'100052945-02',
'100052945-03',
'100052945-04',
'100052946-01',
'100052946-02',
'100052946-03',
'100052946-04',
'100052946-05',
'100052947-01',
'100052947-02',
'100052949-01',
'100052949-02',
'100052949-03',
'100052949-04',
'100052961-01',
'100052963-01',
'100052963-02',
'100052963-03',
'100052963-04',
'100052963-05',
'100052974-01',
'100052975-01',
'100052975-02',
'100052975-03',
'100052975-04',
'100052975-05',
'100052978-01',
'100052979-01',
'100052979-02',
'100052952-01',
'100052952-02',
'100052952-03',
'100052952-04',
'100052954-01',
'100052956-01',
'100052956-02',
'100052958-01',
'100052964-01',
'100052964-02',
'100052964-03',
'100052966-01',
'100052966-02',
'100052966-03',
'100052966-04',
'100052966-05',
'100052966-06',
'100052966-07',
'100052980-01',
'100052980-02',
'100052980-03',
'100052980-04',
'100052959-01',
'100052960-01',
'100052995-01',
'100052996-01',
'100052997-01',
'100052997-02',
'100052997-03',
'100052997-04',
'100052997-05',
'100052997-06',
'100052997-07',
'100052997-08',
'100053001-01',
'100053001-02',
'100053001-03',
'100053001-04',
'100052962-01',
'100052962-02',
'100052962-03',
'100052965-01',
'100052965-02',
'100052965-03',
'100052967-01',
'100052967-02',
'100052984-01',
'100052985-01',
'100052986-01',
'100052988-01',
'100052989-01',
'100052989-02',
'100052989-03',
'100052991-01',
'100052991-02',
'100052991-03',
'100052991-04',
'100052991-05',
'100052991-06',
'100052991-07',
'100052991-08',
'100052994-01',
'100052994-02',
'100052994-03',
'100052981-01',
'100052981-02',
'100052981-03',
'100052981-04',
'100052981-05',
'100052981-06',
'100052982-01',
'100052983-01',
'100052983-02',
'100052983-03',
'100052983-04',
'100052983-05',
'100052983-06',
'100052983-07',
'100052987-01',
'100052987-02',
'100052987-03',
'100052987-04',
'100052987-05',
'100052987-06',
'100052990-01',
'100052992-01',
'100052993-01',
'100052993-02',
'100052993-03',
'100052993-04',
'100053015-01',
'100053015-02',
'100053016-01',
'100053017-01',
'100053017-02',
'100053017-03',
'100053017-04',
'100053017-05',
'100053018-01',
'100053018-02',
'100053018-03',
'100053018-04',
'100053018-05',
'100053018-06',
'100053018-07',
'100053018-08',
'100053018-09',
'100053018-10',
'100053018-11',
'100053018-12',
'100053018-13',
'100053018-14',
'100053018-15',
'100053018-16',
'100053018-17',
'100053018-18',
'100053019-01',
'100053019-02',
'100053019-03',
'100053019-04',
'100053019-05',
'100053020-01',
'100053020-02',
'100053008-01',
'100053008-02',
'100053008-03',
'100053008-04',
'100053008-05',
'100053008-06',
'100053008-07',
'100053010-01',
'100053025-01',
'100053028-01',
'100053029-01',
'100053029-02',
'100053026-01',
'100053026-02',
'100053026-03',
'100053030-01',
'100053031-01',
'100053031-02',
'100053024-01',
'100053018-19',
'100053018-20',
'100053018-21',
'100053018-22',
'100053018-36',
'100053101-01',
'100053102-01',
'100053102-02',
'100053102-03',
'100053102-04',
'100053102-05',
'100053102-06',
'100053102-07',
'100053102-08',
'100053102-09',
'100053102-10',
'100053102-11',
'100053102-12',
'100053102-13',
'100053102-14',
'100053102-15',
'100053102-16',
'100053105-01'
			)),0) PromoHPDBDB
		from 
			TrxFaktur f,
			TrxFakturDetail d,
			(select distinct old_mat_no, matl_group, brand_name,Article_Type from sap_article where DISCNTIN_IDC = 'False') a
		where
			f.NoFaktur = d.NoFaktur
			and d.KodeBarang = a.Old_Mat_No
			and (subtotalharga/jumlah) >=2000000
			and f.KodeStore='01'
			and a.Article_Type='HAWA'
		UNION
		select 
			f.NoFaktur, 
			f.Tanggal,
			f.NoMember,
			f.PointRewardTo,
			f.TotalHarga,
			f.TotalPembayaran,
			isnull((select 
					count(b.KodeJenisPembayaran) 
				from 
					[192.168.14.18\SQLHM].Hartono.dbo.TrxFakturBayar b, 
					[192.168.14.18\SQLHM].Hartono.dbo.MasterVoucherBuyBack v, 
					[192.168.14.18\SQLHM].Hartono.dbo.TrxFaktur x 
				where 
					b.NoFaktur = f.NoFaktur 
					and b.KodeJenisPembayaran = 'VBB' 
					and b.NoJenisPembayaran = v.NoVoucherBuyBack
					and v.NoFaktur = x.NoFaktur
					and cast(convert(varchar, x.Tanggal, 111) as datetime) <> cast(convert(varchar, v.Tanggal, 111) as datetime)
				), 0) as JumVBB,
			0 as PromoHPDBDB
		from 
			[192.168.14.18\SQLHM].Hartono.dbo.TrxFaktur f,
			[192.168.14.18\SQLHM].Hartono.dbo.TrxFakturDetail d,
			(select distinct old_mat_no, matl_group, brand_name,Article_Type from [192.168.14.18\SQLHM].Hartono.dbo.sap_article where DISCNTIN_IDC = 'False') a
		where
			f.NoFaktur = d.NoFaktur
			and d.KodeBarang = a.Old_Mat_No
			and (subtotalharga/jumlah) >=2000000
			and f.KodeStore='01'
			and a.Article_Type='HAWA'
		) as h
	where 
		h.NoFaktur not in (select NoFaktur from TrxReturPenjualan)
		and h.NoFaktur not in (select NoFaktur from [192.168.14.18\SQLHM].Hartono.dbo.TrxReturPenjualan)
		and h.NoFaktur=@NoFaktur
		and PromoHPDBDB = 0
		and h.Tanggal >= '20201027'
		and h.Tanggal  < '20201102'
--		and DATENAME(dw,h.tanggal) in ('Friday', 'Saturday', 'Sunday')
--		and h.NoFaktur not in (select NoFaktur from [192.168.9.19].Hartono.dbo.TrxPengajuanVoidPenjualan where NoFaktur not in (select NoFaktur from [192.168.9.19].Hartono.dbo.TrxBatalPengajuanVoid))
--		and h.NoFaktur not in (select NoFaktur from [192.168.9.19].Hartono.dbo.TrxVoidPenjualan)
--		and h.NoFaktur not in (select NoFaktur from [192.168.9.19].Hartono.dbo.TrxPengajuanRetur)
--		and h.NoFaktur not in (select NoFaktur from [192.168.9.19].Hartono.dbo.TrxReturPenjualan)
		and cast(convert(varchar, h.Tanggal, 111) as datetime) = cast(convert(varchar, getdate(), 111) as datetime)
		--and h.PointRewardTo <> ''
		--and h.PointRewardTo not in (select f.PointRewardTo from TrxFaktur f, TrxBLT l where f.NoFaktur = l.NoFaktur)
--		and h.JumVBB = 0
		and h.TotalHarga = h.TotalPembayaran
--		and h.PointRewardTo in (select NoMember from MasterMember where jenismember='P' and substring(NoKartuMember,1,6) in (select bin from ch_setupbin where bankid = 'B00004')
		) 
	select '1'
else
	select '0'

GO

