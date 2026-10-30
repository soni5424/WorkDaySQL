USE [Hartono]
GO

/****** Object:  View [dbo].[VBWTrxFakturBayar]    Script Date: 21/08/2026 14.40.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/* ==========================================
select count(*) from VBWTrxFakturBayar
Select * from VBWTrxFakturBayar where FKNumber='FK-07-B11-01024'
select * from trxfaktur a 
	INNER JOIN trxfakturbayar b ON a.nofaktur = b.nofaktur
	LEFT JOIN MB_TrxFakturBayarMember c ON a.nofaktur = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
where a.nofaktur = 'FK-07-B11-01024'
   ========================================== */

ALTER VIEW [dbo].[VBWTrxFakturBayar]
AS

    -- 1. Faktur BUKAN KodeStore 07
    SELECT 
        a.NoFaktur                       AS 'FKNumber',
        UPPER(f.platform)                AS 'Platform',
        f.payment_type_category_name     AS 'PaymentTypeCategory',
        b.kodejenispembayaran            AS 'PaymentType',
        (b.nilaipembayaran / 100)        AS 'Amount',
        e.payment_provider_id            AS 'BankID',
        e.payment_provider_name          AS 'BankCard',
        c.nokartumember                  AS 'CardNo',
        UPPER(c.ApprovalCode)            AS 'ApprovalCode',
        c.MID,
        c.KodeEDC,
        c.MDR,
        UPPER(d.card_type)               AS 'CardType',
        b.NoJenisPembayaran,
        (b.nilaipembayaran / 100 * c.MDR / 100) AS 'MDRAmount'
    FROM trxfaktur a 
		INNER JOIN trxfakturbayar b ON a.nofaktur = b.nofaktur
		LEFT JOIN MB_TrxFakturBayarMember c ON a.nofaktur = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran 
		LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
	WHERE a.tanggal >= getdate()-4
    --WHERE a.Tanggal >= '20240101' and a.tanggal < '20240701'
		AND a.KodeStore <> '07'

    UNION ALL

    -- 2. Faktur DENGAN KodeStore 07 DAN MDR < 50
    SELECT 
        a.NoFaktur                       AS 'FKNumber',
        UPPER(f.platform)                AS 'Platform',
        f.payment_type_category_name     AS 'PaymentTypeCategory',
        b.kodejenispembayaran            AS 'PaymentType',
        (b.nilaipembayaran / 100)        AS 'Amount',
        e.payment_provider_id            AS 'BankID',
        e.payment_provider_name          AS 'BankCard',
        c.nokartumember                  AS 'CardNo',
        UPPER(c.ApprovalCode)            AS 'ApprovalCode',
        c.MID,
        c.KodeEDC,
        c.MDR,
        UPPER(d.card_type)               AS 'CardType',
        b.NoJenisPembayaran,
        (b.nilaipembayaran / 100 * c.MDR / 100) AS 'MDRAmount'
    FROM trxfaktur a 
		INNER JOIN trxfakturbayar b ON a.nofaktur = b.nofaktur
		LEFT JOIN MB_TrxFakturBayarMember c ON a.nofaktur = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran 
		LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
	WHERE a.tanggal >= getdate()-4
    --WHERE a.Tanggal >= '20240101' and a.tanggal < '20240701'
	  AND a.KodeStore = '07' 
      AND ISNULL(c.MDR, 0) < 50


    UNION ALL

    -- 3. Faktur DENGAN KodeStore 07 DAN MDR >= 50 (MDR = 0, MDRAmount = MDR / 100)
    SELECT 
        a.NoFaktur                       AS 'FKNumber',
        UPPER(f.platform)                AS 'Platform',
        f.payment_type_category_name     AS 'PaymentTypeCategory',
        b.kodejenispembayaran            AS 'PaymentType',
        (b.nilaipembayaran / 100)        AS 'Amount',
        e.payment_provider_id            AS 'BankID',
        e.payment_provider_name          AS 'BankCard',
        c.nokartumember                  AS 'CardNo',
        UPPER(c.ApprovalCode)            AS 'ApprovalCode',
        c.MID,
        c.KodeEDC,
        0                                AS 'MDR',
        UPPER(d.card_type)               AS 'CardType',
        b.NoJenisPembayaran,
        (ISNULL(c.MDR, 0) / 100.0)       AS 'MDRAmount'
    FROM trxfaktur a 
		INNER JOIN trxfakturbayar b ON a.nofaktur = b.nofaktur
		LEFT JOIN MB_TrxFakturBayarMember c ON a.nofaktur = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran 
		LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
		LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
	WHERE a.tanggal >= getdate()-4
    --WHERE a.Tanggal >= '20240101' and a.tanggal < '20240701'
      AND a.KodeStore = '07' 
      AND ISNULL(c.MDR, 0) >= 50

    UNION ALL

    -- 4. Retur
    SELECT 
        a.NoReturPenjualan               AS 'FKNumber',
        ''                               AS 'Platform',
        ''                               AS 'PaymentTypeCategory',
        'CASH'                           AS 'PaymentType',
        0                                AS 'Amount',
        ''                               AS 'BankID',
        ''                               AS 'BankCard',
        ''                               AS 'CardNo',
        ''                               AS 'ApprovalCode',
        ''                               AS 'MID',
        ''                               AS 'KodeEDC',
        0                                AS 'MDR',
        ''                               AS 'CardType',
        ''                               AS 'NoJenisPembayaran',
        0                                AS 'MDRAmount'
    FROM trxreturpenjualan a 
	WHERE a.tanggal >= getdate()-4
    --WHERE a.Tanggal >= '20240101' and a.tanggal < '20240701'


GO


