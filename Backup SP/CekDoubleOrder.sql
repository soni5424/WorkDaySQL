declare @KetSO varchar(50)
set @KetSO = '60508 / %'

select NoSO, Tanggal, KeteranganSO, StatusBatal, StatusInvoiced from TrxSO where KeteranganSO like @KetSO
select * from TrxFaktur where NoSO IN (select NoSO from TrxSO where KeteranganSO like @KetSO)
--select * from TrxFakturDetail where NoFaktur IN ('FK-07-B69-00185', 'FK-07-B39-00157')

SELECT * FROM TrxSO A WHERE A.KeteranganSO='60508 / 78233' AND StatusBatal<>'1' OR StatusInvoiced='1')

SELECT NoSO FROM TrxSO A WHERE A.KeteranganSO='60508 / 78233' AND StatusBatal<>'1'
59090
60508