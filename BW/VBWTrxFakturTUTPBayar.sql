USE [Hartono]
GO

/****** Object:  View [dbo].[VBWTrxFakturTUTPBayar]    Script Date: 21/08/2026 14.40.12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/* ==========================================
   SELECT count(*) FROM VBWTrxFakturTUTPBayar
   SELECT NoJenisPembayaran, LEN(NoJenisPembayaran) FROM VBWTrxFakturTUTPBayar where LEN(NoJenisPembayaran)> 30
   SELECT TOP 10 * FROM VBWTrxFakturTUTPBayar where FKNumber='FK-07-A30-00544'
   select * from VBWTrxFakturTUTPBayar where FKNumber like 'FK-07-A%' and MDR>=50
   ========================================== */

ALTER VIEW [dbo].[VBWTrxFakturTUTPBayar]
AS

/* ==========================================
   1. TRANSAKSI FAKTUR (TRXFAKTUR)
   ========================================== */
-- 1.1 Faktur bukan kodestore 07
SELECT 
    a.NoFaktur                                    AS FKNumber,
    CONVERT(VARCHAR(10), a.Tanggal, 112)          AS Tanggal,
    a.NoMember                                    AS NoMember,
    a.NamaPembeli                                 AS Pembeli,
    a.AlamatPenerima                              AS Alamat, 
    a.TelpPembeli                                 AS Telepon,
    UPPER(f.platform)                             AS Platform,
    f.payment_type_category_name                  AS PaymentTypeCategory,
    b.KodeJenisPembayaran                         AS PaymentType,
    (b.NilaiPembayaran / 100)                     AS Amount,
    e.payment_provider_id                         AS BankID,
    e.payment_provider_name                       AS BankCard,
    c.NoKartuMember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.card_type)                            AS CardType,
    LEFT(b.NoJenisPembayaran,50)                  AS NoJenisPembayaran,
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount,
	g.SALES_OFF,
    'FK'                                          AS DocType
FROM trxfaktur a 
    INNER JOIN trxfakturbayar b ON a.NoFaktur = b.NoFaktur
    INNER JOIN masterstore g ON a.kodestore = g.kodestore
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoFaktur = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.Tanggal >= GETDATE() - 4
--WHERE a.Tanggal >= '20250701' and a.tanggal < '20260101'
    AND a.kodestore <> '07'

UNION ALL

-- 1.2 Faktur dengan kodestore 07 dan MDR < 50
SELECT 
    a.NoFaktur                                    AS FKNumber,
    CONVERT(VARCHAR(10), a.Tanggal, 112)          AS Tanggal,
    a.NoMember                                    AS NoMember,
    a.NamaPembeli                                 AS Pembeli,
    a.AlamatPenerima                              AS Alamat, 
    a.TelpPembeli                                 AS Telepon,
    UPPER(f.platform)                             AS Platform,
    f.payment_type_category_name                  AS PaymentTypeCategory,
    b.KodeJenisPembayaran                         AS PaymentType,
    (b.NilaiPembayaran / 100)                     AS Amount,
    e.payment_provider_id                         AS BankID,
    e.payment_provider_name                       AS BankCard,
    c.NoKartuMember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.card_type)                            AS CardType,
    LEFT(b.NoJenisPembayaran,50)                  AS NoJenisPembayaran,
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount,
    g.SALES_OFF,
    'FK'                                          AS DocType
FROM trxfaktur a 
    INNER JOIN trxfakturbayar b ON a.NoFaktur = b.NoFaktur
    INNER JOIN masterstore g ON a.kodestore = g.kodestore
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoFaktur = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.Tanggal >= GETDATE() - 4
--WHERE a.Tanggal >= '20250701' and a.tanggal < '20260101'
  AND a.kodestore = '07' 
  AND ISNULL(c.MDR, 0) < 50

UNION ALL

-- 1.3 Faktur dengan kodestore 07 dan MDR >= 50 (MDR diisi 0, MDRAmount diisi MDR / 100)
SELECT 
    a.NoFaktur                                    AS FKNumber,
    CONVERT(VARCHAR(10), a.Tanggal, 112)          AS Tanggal,
    a.NoMember                                    AS NoMember,
    a.NamaPembeli                                 AS Pembeli,
    a.AlamatPenerima                              AS Alamat, 
    a.TelpPembeli                                 AS Telepon,
    UPPER(f.platform)                             AS Platform,
    f.payment_type_category_name                  AS PaymentTypeCategory,
    b.KodeJenisPembayaran                         AS PaymentType,
    (b.NilaiPembayaran / 100)                     AS Amount,
    e.payment_provider_id                         AS BankID,
    e.payment_provider_name                       AS BankCard,
    c.NoKartuMember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    0                                             AS MDR,
    UPPER(d.card_type)                            AS CardType,
    LEFT(b.NoJenisPembayaran,50)                  AS NoJenisPembayaran,
    (c.MDR / 100.0)                               AS MDRAmount,
    g.SALES_OFF,
    'FK'                                          AS DocType
FROM trxfaktur a 
    INNER JOIN trxfakturbayar b ON a.NoFaktur = b.NoFaktur
    INNER JOIN masterstore g ON a.kodestore = g.kodestore
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoFaktur = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.Tanggal >= GETDATE() - 4
--WHERE a.Tanggal >= '20250701' and a.tanggal < '20260101'
  AND a.kodestore = '07' 
  AND c.MDR >= 50

UNION ALL

/* ==========================================
   2. TANDA TERIMA UANG (TRXTANDATERIMAUANG)
   ========================================== */
SELECT 
    a.NoTandaTerimaUang                           AS FKNumber,
    CONVERT(VARCHAR(10), a.Tanggal, 112)          AS Tanggal,
    a.NoMember                                    AS NoMember, 
    a.Pembeli                                     AS Pembeli,
    a.Alamat                                      AS Alamat,
    a.Telepon                                     AS Telepon,
    'OFFLINE'                                     AS Platform,
    d.jeniskartu                                  AS PaymentTypeCategory,
    b.KodeJenisPembayaran                         AS PaymentType,
    (b.SubTotalTerimaUang / 100)                  AS Amount,
    e.bankid                                      AS BankID,
    e.namabank                                    AS BankCard,
    c.NoKartuMember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.tipekartu)                            AS CardType,
    LEFT(b.NoJenisPembayaran, 50)                 AS NoJenisPembayaran,
    (b.SubTotalTerimaUang / 100 * c.MDR / 100)    AS MDRAmount,
	f.SALES_OFF,
    'TU'                                          AS DocType
FROM trxtandaterimauang a 
    INNER JOIN trxtandaterimauangdetail b ON a.NoTandaTerimaUang = b.NoTandaTerimaUang
    INNER JOIN masterstore f ON a.kodestore = f.kodestore
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoTandaTerimaUang = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
WHERE a.Tanggal >= GETDATE() - 4
--WHERE a.Tanggal >= '20250701' and a.tanggal < '20260101'

UNION ALL

/* ==========================================
   3. PELUNASAN (TRXPELUNASAN)
   ========================================== */
SELECT 
    a.NoPelunasan                                 AS FKNumber,
    CONVERT(VARCHAR(10), a.Tanggal, 112)          AS Tanggal,
    a.NoMember                                    AS NoMember, 
    a.Pembeli                                     AS Pembeli,
    a.Alamat                                      AS Alamat,
    a.Telepon                                     AS Telepon,
    'OFFLINE'                                     AS Platform,
    d.jeniskartu                                  AS PaymentTypeCategory,
    b.KodeJenisPembayaran                         AS PaymentType,
    (b.NilaiPembayaran / 100)                     AS Amount,
    e.bankid                                      AS BankID,
    e.namabank                                    AS BankCard,
    c.NoKartuMember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.tipekartu)                            AS CardType,
    LEFT(b.NoJenisPembayaran, 50)                 AS NoJenisPembayaran,
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount,
	f.SALES_OFF,
    'TP'                                          AS DocType
FROM trxpelunasan a 
    INNER JOIN trxpelunasanbayar b ON a.NoPelunasan = b.NoPelunasan
    INNER JOIN masterstore f ON a.kodestore = f.kodestore
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoPelunasan = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
WHERE a.Tanggal >= GETDATE() - 4;
--WHERE a.Tanggal >= '20250701' and a.tanggal < '20260101'



GO


