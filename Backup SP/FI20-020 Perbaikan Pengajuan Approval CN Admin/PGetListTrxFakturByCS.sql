USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PGetListTrxFakturByCS]    Script Date: 03/08/2020 0:12:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER      PROCEDURE [dbo].[PGetListTrxFakturByCS]
-- ==============================================================================
-- Stored procedure untuk mengambil semua data dari tabel TrxFaktur bdk kasir
-- ==============================================================================
@NoFaktur varchar(50)
-- with encryption
AS

if exists(select * from trxreturpenjualan
where nofaktur=@NoFaktur)
begin
	SELECT 
    NoFaktur, 
    'Retur' as JenisFaktur, 
    Tanggal, 
--     TglPengiriman, 
    coalesce(NoMember,'')as NoMember, 
--     NamaPemesan, 
     NamaPembeli,   -- ADD BY MY AGAR NAMA PEMBELI JUGA TAMPIL
--     AlamatPembeli, 
--     KodeWilayahPembeli, 
--     TelpPembeli, 
     NamaPenerima, 
--     AlamatPenerima, 
--     KodeWilayahPenerima, 
--     TelpPenerima, 
    KodeUserKasir,
--     KodeStore, 
--     KodeWorkStation, 
    NoSO ,
--     RevisionSO, 
--     StatusProses, 
--     JumlahPrint, 
--     JenisTransaksi, 
--     StatusPemasangan, 
--     TotalHarga, 
--     TotalPembayaran, 
--     PointSalesFaktur, 
--     PointRewardMember 
	coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
	NamaPenerima,
	AlamatPenerima,
	coalesce(TelpPenerima,'') as TelpPenerima
FROM TrxFaktur a left join (select * from masterpilihan where grup='StatusPenyerahan') b
on a.statuspenyerahan=b.nilai
WHERE tanggal >= getdate()-7 and nofaktur not in (select nofaktur from trxreturpenjualan)
and nofaktur not in (select nofaktur from trxvoidPenjualan)
and NoFaktur not in (select NoFaktur from TrxBLT)
and NoFaktur not in (select NoFaktur from TrxBLT2)
and NoFaktur not in (select NoFaktur from TrxBLT3)
and NoFaktur not in (select NoFaktur from TrxBLT4)
and NoFaktur not in (select NoFaktur from TrxBLT5)
and NoFaktur not in (select NoFaktur from TrxBLT6)
and NoFaktur not in (select NoFaktur from TrxBLT8)
and NoFaktur not in (select NoFaktur from TrxBLT9)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
and NoFaktur not in (select NoFaktur from TrxBLTHistory)
and NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory)


end
else if exists(select * from trxvoidPenjualan
where nofaktur=@NoFaktur)
begin


SELECT 
    NoFaktur, 
    'Void' as JenisFaktur, 
    Tanggal, 
--     TglPengiriman, 
    coalesce(NoMember,'')as NoMember, 
--     NamaPemesan, 
     NamaPembeli,   -- ADD BY MY AGAR NAMA PEMBELI JUGA TAMPIL
--     AlamatPembeli, 
--     KodeWilayahPembeli, 
--     TelpPembeli, 
     NamaPenerima, 
--     AlamatPenerima, 
--     KodeWilayahPenerima, 
--     TelpPenerima, 
    KodeUserKasir,
--     KodeStore, 
--     KodeWorkStation, 
    NoSO ,
--     RevisionSO, 
--     StatusProses, 
--     JumlahPrint, 
--     JenisTransaksi, 
--     StatusPemasangan, 
--     TotalHarga, 
--     TotalPembayaran, 
--     PointSalesFaktur, 
--     PointRewardMember 
	coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
	NamaPenerima,
	AlamatPenerima,
	coalesce(TelpPenerima,'') as TelpPenerima
FROM TrxFaktur a left join (select * from masterpilihan where grup='StatusPenyerahan') b
on a.statuspenyerahan=b.nilai
WHERE tanggal >= getdate()-7 and nofaktur not in (select nofaktur from trxreturpenjualan)
and nofaktur not in (select nofaktur from trxvoidPenjualan)
and NoFaktur not in (select NoFaktur from TrxBLT)
and NoFaktur not in (select NoFaktur from TrxBLT2)
and NoFaktur not in (select NoFaktur from TrxBLT3)
and NoFaktur not in (select NoFaktur from TrxBLT4)
and NoFaktur not in (select NoFaktur from TrxBLT5)
and NoFaktur not in (select NoFaktur from TrxBLT6)
and NoFaktur not in (select NoFaktur from TrxBLT8)
and NoFaktur not in (select NoFaktur from TrxBLT9)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
and NoFaktur not in (select NoFaktur from TrxBLTHistory)
and NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory)

end
else
begin



SELECT 
    NoFaktur, 
    JenisFaktur, 
    Tanggal, 
--     TglPengiriman, 
    coalesce(NoMember,'')as NoMember, 
--     NamaPemesan, 
     NamaPembeli,   -- ADD BY MY AGAR NAMA PEMBELI JUGA TAMPIL
--     AlamatPembeli, 
--     KodeWilayahPembeli, 
--     TelpPembeli, 
     NamaPenerima, 
--     AlamatPenerima, 
--     KodeWilayahPenerima, 
--     TelpPenerima, 
    KodeUserKasir,
--     KodeStore, 
--     KodeWorkStation, 
    NoSO ,
--     RevisionSO, 
--     StatusProses, 
--     JumlahPrint, 
--     JenisTransaksi, 
--     StatusPemasangan, 
--     TotalHarga, 
--     TotalPembayaran, 
--     PointSalesFaktur, 
--     PointRewardMember 
	coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,

	NamaPenerima,
	AlamatPenerima,
	coalesce(TelpPenerima,'') as TelpPenerima
FROM TrxFaktur a left join (select * from masterpilihan where grup='StatusPenyerahan') b
on a.statuspenyerahan=b.nilai
WHERE tanggal >= getdate()-7 and nofaktur not in (select nofaktur from trxreturpenjualan)
and nofaktur not in (select nofaktur from trxvoidPenjualan)
--and nofaktur='FK-01-F06-00380-01'
and NoFaktur not in (select NoFaktur from TrxBLT)
and NoFaktur not in (select NoFaktur from TrxBLT2)
and NoFaktur not in (select NoFaktur from TrxBLT3)
and NoFaktur not in (select NoFaktur from TrxBLT4)
and NoFaktur not in (select NoFaktur from TrxBLT5)
and NoFaktur not in (select NoFaktur from TrxBLT6)
and NoFaktur not in (select NoFaktur from TrxBLT8)
and NoFaktur not in (select NoFaktur from TrxBLT9)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
and NoFaktur not in (select NoFaktur from TrxBLTHistory)
and NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail)
and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory)

end








GO

