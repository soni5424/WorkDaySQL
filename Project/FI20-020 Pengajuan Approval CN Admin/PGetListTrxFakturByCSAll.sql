USE [Hartono]
GO

-- =============================================
-- Modified By		: Rini Handini
-- Modified date	: 10/10/2018
-- Description		: Add include FK in BLT_TrxOpenLock
-- =============================================
-- =============================================
-- Modified By		: David
-- Modified date	: 29/07/2020
-- Description		: tambah Not in CS_TrxPengajuanCNAdmin
-- =============================================
-- =============================================
-- Modified By		: Soni Gunawan
-- Modified date	: 04/09/2020
-- Description		: Handle Case, telah di lakukan PengajuanCNAdmin dan di batalkan
--                    Maka tetap harus bisa diajukan kembali / Harus muncul
-- =============================================

ALTER PROCEDURE [dbo].[PGetListTrxFakturByCSAll]
	@NoFaktur varchar(50)
AS
BEGIN
    IF EXISTS(SELECT * FROM TrxReturPenjualan WHERE NoFaktur=@NoFaktur)
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
            coalesce(PointRewardTo,'') as PointRewardTo, 
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima,
            StatusPembayaran
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
        WHERE 
            nofaktur like '%'+@NoFaktur+'%'
            and ((NoFaktur not in (select NoFaktur from TrxBLT)
                and NoFaktur not in (select NoFaktur from TrxBLT2)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
                and NoFaktur not in (select NoFaktur from TrxBLT3)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur3)
                and NoFaktur not in (select NoFaktur from TrxBLT4)
                and NoFaktur not in (select NoFaktur from TrxBLT5)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
                and NoFaktur not in (select NoFaktur from TrxBLT6)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur6)
                and NoFaktur not in (select NoFaktur from TrxBLT7)
                and NoFaktur not in (select NoFaktur from TrxBLT8)
                and NoFaktur not in (select NoFaktur from TrxBLT9)
                and NoFaktur not in (select NoFaktur from TrxBLT10)
                and NoFaktur not in (select NoFaktur from TrxBLT11)
                and NoFaktur not in (select NoFaktur from TrxBLT12)
                and NoFaktur not in (SELECT A.NoFaktur
                                        FROM CS_TrxPengajuanCNAdmin A
	                                        LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                        WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
                and NoFaktur not in (select NoFaktur from TrxBLTHistory)
                and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory))
                or NoFaktur in (select NoFaktur from BLT_TrxOpenLock))
    END
    ELSE IF EXISTS(SELECT * FROM TrxVoidPenjualan WHERE NoFaktur=@NoFaktur)
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
            coalesce(PointRewardTo,'') as PointRewardTo, 
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima,
            StatusPembayaran
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
        WHERE nofaktur like '%'+@NoFaktur+'%'
            and ((NoFaktur not in (select NoFaktur from TrxBLT)
                and NoFaktur not in (select NoFaktur from TrxBLT2)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
                and NoFaktur not in (select NoFaktur from TrxBLT3)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur3)
                and NoFaktur not in (select NoFaktur from TrxBLT4)
                and NoFaktur not in (select NoFaktur from TrxBLT5)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
                and NoFaktur not in (select NoFaktur from TrxBLT6)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur6)
                and NoFaktur not in (select NoFaktur from TrxBLT7)
                and NoFaktur not in (select NoFaktur from TrxBLT8)
                and NoFaktur not in (select NoFaktur from TrxBLT9)
                and NoFaktur not in (select NoFaktur from TrxBLT10)
                and NoFaktur not in (select NoFaktur from TrxBLT11)
                and NoFaktur not in (select NoFaktur from TrxBLT12)
                and NoFaktur not in (SELECT A.NoFaktur
                                        FROM CS_TrxPengajuanCNAdmin A
	                                        LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                        WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
                and NoFaktur not in (select NoFaktur from TrxBLTHistory)
                and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory)
            ) or NoFaktur in (select NoFaktur from BLT_TrxOpenLock))
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
            coalesce(PointRewardTo,'') as PointRewardTo,  
            coalesce(b.nama,'Diambil Sendiri') as StatusPenyerahan,
            NamaPenerima,
            AlamatPenerima,
            coalesce(TelpPenerima,'') as TelpPenerima,
            StatusPembayaran
        FROM 
            TrxFaktur a 
            left join (select * from masterpilihan where grup='StatusPenyerahan') b on a.statuspenyerahan=b.nilai
        WHERE 
            nofaktur not in (select nofaktur from trxreturpenjualan)
            and nofaktur not in (select nofaktur from trxvoidPenjualan)
            and nofaktur like '%'+@NoFaktur+'%'
            and ((NoFaktur not in (select NoFaktur from TrxBLT)
                and NoFaktur not in (select NoFaktur from TrxBLT2)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur2)
                and NoFaktur not in (select NoFaktur from TrxBLT3)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur3)
                and NoFaktur not in (select NoFaktur from TrxBLT4)
                and NoFaktur not in (select NoFaktur from TrxBLT5)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur5)
                and NoFaktur not in (select NoFaktur from TrxBLT6)
                and NoFaktur not in (select NoFaktur from TrxBLTFaktur6)
                and NoFaktur not in (select NoFaktur from TrxBLT7)
                and NoFaktur not in (select NoFaktur from TrxBLT8)
                and NoFaktur not in (select NoFaktur from TrxBLT9)
                and NoFaktur not in (select NoFaktur from TrxBLT10)
                and NoFaktur not in (select NoFaktur from TrxBLT11)
                and NoFaktur not in (select NoFaktur from TrxBLT12)
                and NoFaktur not in (SELECT A.NoFaktur
                                        FROM CS_TrxPengajuanCNAdmin A
	                                        LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
                                        WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL)
                and NoFaktur not in (select NoFaktur from TrxBLTHistory)
                and NoFaktur not in (select NoFaktur from TrxBLTFakturHistory)
                ) or NoFaktur in (select NoFaktur from BLT_TrxOpenLock))
    END
END