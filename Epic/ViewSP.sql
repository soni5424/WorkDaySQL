declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   WEB_PGetBatasHariKirim       '))
EXEC sp_helptext @NamaSP