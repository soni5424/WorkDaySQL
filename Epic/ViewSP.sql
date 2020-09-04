declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   PGetListTrxFakturByCS       '))
EXEC sp_helptext @NamaSP