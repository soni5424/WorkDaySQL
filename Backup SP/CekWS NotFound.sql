select * from TrxSO where KodeWorkStation like '%01A%' order by Tanggal desc
select * from TrxFaktur where NoSO in (select NoSO from TrxSO where KodeWorkStation like '%01A%') order by Tanggal desc


select * from TrxSO where Tanggal > '20201108' and KodeWorkStation = 'A01' order by tanggal desc
select * from TrxFaktur where NoSO in (select NoSO from TrxSO where Tanggal > '20201108' and KodeWorkStation = 'A01')
order by tanggal desc
