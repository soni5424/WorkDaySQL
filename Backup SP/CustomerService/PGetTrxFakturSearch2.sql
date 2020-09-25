USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PGetTrxFakturSearch2]    Script Date: 03/06/2020 15.11.52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Modified By		: Abednego
-- Modified Date	: 21/12/2017
-- Description		: Tambah Kolom

-- Modified By		: Rini Handini
-- Modified Date	: 04/01/2018
-- Description		: Nama Sales karena sales RBO lama <> POS <> HM

-- Modified By		: Rini Handini
-- Modified Date	: 15/01/2018
-- Description		: Merk dicek by isnull karena mastermerk lama keterangan di null kan

-- Modified By		: Rini Handini
-- Modified date	: 08 Oktober 2018
-- Description		: Cek Alamat dari Alamat 2-4

-- Modified By		: Rio
-- Modified date	: 19/12/2019
-- Description		: Tambah pengecekan '' di where untuk mengurangi proses

-- Modified By		: Rini Handini
-- Modified date	: 07/01/2020
-- Description		: Kolom Sales Pakai Nama (SP beda dengan punya 18.1\SQL2005)

-- Modified By		: Soni Gunawan
-- Modified date	: 24/02/2020
-- Description		: Fix Filter NamaPerima
-- =============================================

ALTER PROCEDURE [dbo].[PGetTrxFakturSearch2] 
	@NoFaktur char(18),
	@Tanggal datetime, --TglAwal
	@TglPengiriman datetime, --TglAkhir
	@KodeBarang char(20),
	@MerkBarang varchar(50),
	@NamaPenerima varchar(50),
	@AlamatPenerima varchar(500),
	@NoSO char(16)
AS

select
	a.NoFaktur, 
	a.Tanggal, 
	a.TglPengiriman, 
	a.NamaPenerima, 
	a.AlamatPenerima 
	+ ' ' +
	coalesce(alamatpenerima2_STR_SUPPL3, '') + ' ' +
	coalesce(alamatpenerima3_LOCATION, '') + ' ' +
	coalesce(alamatpenerima4_STR_SUPPL1, '') + ' ' +
	coalesce(alamatpenerima5_STR_SUPPL2, '') AS AlamatPenerima
	,  
	a.TelpPenerima, 
	a.KodeStore, 
	a.NoSO, 
	a.keteranganSO, 
	b.kodebarang, 
	b.kodegudang, 
	c.namabarang, 
	/*c.merkbarang*/ 
	ISNULL((select m.keterangan from MasterMerk m where m.Merk = c.merkbarang), c.merkbarang) as merkbarang, -- 15/01/2018
	--m.Keterangan as merkbarang, -- 15/01/2018
	c.kodejenis, 
	c.kodegolongan,
	d.NamaMember as NamaPembeli, 
	d.NoTelp as TelpPembeli, 
	d.NoHP as HPPembeli, 
	--a.KodeSales AS Sales -- Rini 04/01/2018
	e.NamaSales as Sales --add by Abednego CCO CSO Tambah Kolom 21/12/2017
from 
	trxfaktur a, 
	trxfakturdetail b, 
	masterbarang c, 
	--mastermerk m, 
	MasterMember d, 
	MasterSales e --add by Abednego CCO CSO Tambah Kolom 21/12/2017
where 
	a.nofaktur=b.nofaktur
	and b.kodebarang=c.kodebarang
	and a.NamaPenerima like '%'+ISNULL(@NamaPenerima,'')+'%'
	--add by Abednego CCO CSO Tambah Kolom 21/12/2017
	AND a.PointRewardTo = d.NoMember
	AND a.KodeSales = e.KodeSales
	--add by Abednego CCO CSO Tambah Kolom 21/12/2017

	and (@NoFaktur = '' OR a.NoFaktur like '%'+rtrim(@NoFaktur)+'%')
	and a.Tanggal >= @Tanggal
	and a.Tanggal <= @TglPengiriman+1
	and (@KodeBarang = '' OR b.KodeBarang like '%'+rtrim(@KodeBarang)+'%')
	--and c.MerkBarang = m.Merk -- 15/01/2018
	and (@MerkBarang = '' OR ISNULL((select m.keterangan from MasterMerk m where m.Merk = c.merkbarang), c.merkbarang) like '%'+@MerkBarang+'%' -- 15/01/2018)
	--and m.Keterangan like '%'+@MerkBarang+'%' -- 15/01/2018
	--and c.MerkBarang like '%'+@MerkBarang+'%'
	-- and (@NamaPenerima = '' OR a.NamaPenerima like '%'+@NamaPenerima+'%')
	and (@AlamatPenerima = '' OR a.AlamatPenerima like '%'+@AlamatPenerima+'%'
	or a.AlamatPenerima2_STR_SUPPL3 like '%'+@AlamatPenerima+'%' -- 08.10.2018
	or a.AlamatPenerima3_LOCATION like '%'+@AlamatPenerima+'%' -- 08.10.2018
	or a.AlamatPenerima4_STR_SUPPL1 like '%'+@AlamatPenerima+'%' -- 08.10.2018
	))
	and (@NoSO = '' OR a.NoSO like '%'+rtrim(@NoSO)+'%')
	
--ORDER BY a.Tanggal, a.NoSO, a.NoFaktur
GO

