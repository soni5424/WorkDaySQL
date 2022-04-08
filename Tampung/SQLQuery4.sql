select top 100 b.NoFaktur from TrxFakturDetail A, TrxFaktur B 
where pointredeem > 0 
	and a.nofaktur=b.nofaktur
order by b.tanggal desc
	