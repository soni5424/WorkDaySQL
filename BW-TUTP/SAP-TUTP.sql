SELECT 
    a.NoTandaTerimaUang                           AS FKNumber,
    a.tanggal,
    a.nomember, 
    a.pembeli,
    a.alamat,
    a.telepon,
    -- UPPER(f.platform)                          AS Platform,
    'OFFLINE'                                     AS Platform,
    d.jeniskartu                                  AS PaymentTypeCategory,
    b.kodejenispembayaran                         AS PaymentType,
    (b.SubTotalTerimaUang / 100)                  AS Amount,
    e.bankid                                      AS BankID,
    e.namabank                                    AS BankCard,
    c.nokartumember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.tipekartu)                            AS CardType,
    b.NoJenisPembayaran,
    (b.SubTotalTerimaUang / 100 * c.MDR / 100)    AS MDRAmount
FROM trxtandaterimauang a 
    INNER JOIN trxtandaterimauangdetail b ON a.notandaterimauang = b.notandaterimauang
    LEFT JOIN MB_TrxFakturBayarMember c ON a.NoTandaTerimaUang = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
-- LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.tanggal >= GETDATE() - 4

UNION ALL

SELECT 
    a.NoPelunasan                                 AS FKNumber,
    a.tanggal,
    a.nomember, 
    a.pembeli,
    a.alamat,
    a.telepon,
    -- UPPER(f.platform)                          AS Platform,
    'OFFLINE'                                     AS Platform,
    d.jeniskartu                                  AS PaymentTypeCategory,
    b.kodejenispembayaran                         AS PaymentType,
    (b.NilaiPembayaran / 100)                     AS Amount,
    e.bankid                                      AS BankID,
    e.namabank                                    AS BankCard,
    c.nokartumember                               AS CardNo,
    UPPER(c.ApprovalCode)                         AS ApprovalCode,
    c.MID,
    c.KodeEDC,
    c.MDR,
    UPPER(d.tipekartu)                            AS CardType,
    b.NoJenisPembayaran,
    (b.NilaiPembayaran / 100 * c.MDR / 100)       AS MDRAmount
FROM trxpelunasan a 
    INNER JOIN trxpelunasanbayar b ON a.nopelunasan = b.nopelunasan
    LEFT JOIN MB_TrxFakturBayarMember c ON a.nopelunasan = c.nofaktur AND b.KodeJenisPembayaran = c.KodeJenisPembayaran
    LEFT JOIN CH_SetupBIN d ON SUBSTRING(c.NoKartuMember, 1, 6) = d.bin
    LEFT JOIN CH_MasterBank e ON d.bankid = e.bankid
-- LEFT JOIN [10.50.5.59].hartono.dbo.m_payment_type_hms_pg f ON b.KodeJenisPembayaran = f.payment_type
WHERE a.tanggal >= GETDATE() - 4