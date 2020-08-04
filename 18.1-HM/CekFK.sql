select * from TrxFaktur where dbo.getonlydate(Tanggal) = dbo.getonlydate(getdate())


select top 10 * from TrxFaktur where KodeWorkStation like '%B' order by tanggal desc