declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   PGetTrxFakturDetail       '))
EXEC sp_helptext @NamaSP