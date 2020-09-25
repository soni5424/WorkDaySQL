use hartono
go

-- ==============================================================================
-- Stored procedure untuk mengambil semua data dari tabel TrxFaktur bdk kasir
-- Modified By		: David
-- Modified date	: 29/07/2020
-- Description		: tambah Not in CS_TrxPengajuanCNAdmin
-- ==============================================================================
-- ==============================================================================
-- Modified By		: Soni Gunawan
-- Modified date	: 04/09/2020
-- Description		: Handle Case, telah di lakukan PengajuanCNAdmin dan di batalkan
--                    Maka tetap harus bisa diajukan kembali / Harus muncul
-- ==============================================================================

alter PROCEDURE [dbo].[PGetListTrxFakturByCS]
    @NoFaktur varchar(50)
AS
BEGIN
    IF EXISTS(SELECT * FROM TrxReturPenjualan WHERE nofaktur=@NoFaktur)
    BEGIN
        SELECT 
            NoFaktur, 
            'Retur' as JenisFaktur, 
            Tanggal, 
            coalesce(NoMember,'')as NoMember, 
            NamaPembeli,
            NamaPenerima, 
            KodeUserKasir,
            NoSO ,
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
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
            and NoFaktur not in (SELECT A.NoFaktur
                                    FROM CS_TrxPengajuanCNAdmin A
	                                    LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                    WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
    END
    ELSE IF EXISTS(SELECT * FROM trxvoidPenjualan where nofaktur=@NoFaktur)
    BEGIN
        SELECT 
            NoFaktur, 
            'Void' as JenisFaktur, 
            Tanggal, 
            coalesce(NoMember,'')as NoMember, 
            NamaPembeli,
            NamaPenerima, 
            KodeUserKasir,
            NoSO ,
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
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
            and NoFaktur not in (SELECT A.NoFaktur
                                    FROM CS_TrxPengajuanCNAdmin A
	                                    LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                    WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
    END
    ELSE
    BEGIN
        SELECT 
            NoFaktur, 
            JenisFaktur, 
            Tanggal, 
            coalesce(NoMember,'')as NoMember, 
            NamaPembeli,
            NamaPenerima, 
            KodeUserKasir,
            NoSO ,
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
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
            and NoFaktur not in (SELECT A.NoFaktur
                                    FROM CS_TrxPengajuanCNAdmin A
	                                    LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                    WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
    END
END