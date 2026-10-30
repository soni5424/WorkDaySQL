/* ==========================================
   SELECT count(*) FROM VBWTrxFakturTUTPBayar
   SELECT NoJenisPembayaran, LEN(NoJenisPembayaran) FROM VBWTrxFakturTUTPBayar where LEN(NoJenisPembayaran)> 30
   SELECT TOP 10 * FROM VBWTrxFakturTUTPBayar where FKNumber='FK-07-A30-00544'
   ========================================== */

alter VIEW [dbo].[VBWTrxFakturTUTPBayar]
AS

/* ==========================================
   1. TRANSAKSI FAKTUR (TRXFAKTUR)
   ========================================== */
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
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount
FROM trxfaktur a 
    INNER JOIN trxfakturbayar b ON a.NoFaktur = b.NoFaktur
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoFaktur = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN [10.50.5.59].hartono.dbo.s_bin_pg d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin_number
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_provider_pg e ON d.payment_provider_id = e.payment_provider_id
    LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.Tanggal >= GETDATE() - 4

UNION ALL

/* ==========================================
   3. TANDA TERIMA UANG (TRXTANDATERIMAUANG)
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
    (b.SubTotalTerimaUang / 100 * c.MDR / 100)    AS MDRAmount
FROM trxtandaterimauang a 
    INNER JOIN trxtandaterimauangdetail b ON a.NoTandaTerimaUang = b.NoTandaTerimaUang
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoTandaTerimaUang = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
WHERE a.Tanggal >= GETDATE() - 4

UNION ALL

/* ==========================================
   4. PELUNASAN (TRXPELUNASAN)
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
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount
FROM trxpelunasan a 
    INNER JOIN trxpelunasanbayar b ON a.NoPelunasan = b.NoPelunasan
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoPelunasan = c.NoFaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
WHERE a.Tanggal >= GETDATE() - 4;
GO