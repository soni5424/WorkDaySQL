select * from TrxSO 
where Tanggal > '20200915' and KodeStore='07' and KodeWorkStation like 'A%'
order by Tanggal desc