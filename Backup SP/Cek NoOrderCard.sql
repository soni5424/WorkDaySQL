declare @KetSO varchar(50)
set @KetSO = '55667 / 73020%'

select NoSO, Tanggal from TrxSO where KeteranganSO like @KetSO
select * from TrxFaktur where NoSO IN (select NoSO from TrxSO where KeteranganSO like @KetSO)

