SELECT     TOP (10) A.* into #TFK
FROM         TrxFaktur A
		inner join [192.168.9.28].hartono.dbo.Trxfaktur B on A.nofaktur = b.nofaktur
		inner join 
ORDER BY A.Tanggal DESC

select * from TrxFakturDetail where NoFaktur in (SELECT  NoFaktur from #TFK)

select top 10 * from TrxFakturInsurance where nofaktur in (select NoFaktur from [192.168.9.28].hartono.dbo.TrxFaktur) order by Tanggal desc
