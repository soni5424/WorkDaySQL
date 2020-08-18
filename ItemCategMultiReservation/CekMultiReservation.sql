select KeteranganSO, * from TrxSO where KodeWorkStation like 'A%' order by tanggal desc
select * from TrxSODetail where NoSO='02B-01-A70-00003'


select * from SAP_TrxSOSTO 
where noso in (select top 10 NoSO from TrxSO where KodeWorkStation like 'A%' order by tanggal desc)

