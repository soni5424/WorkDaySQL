select distinct A.* from TrxSO A, TrxSODetail B
where Tanggal > '20200915' and A.KodeStore='07' and KodeWorkStation like 'A%'
	and a.NoSO=b.NoSO and PointRedeem > 0
order by Tanggal desc