declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '    sap_PCekItemTransport       ')) 
EXEC sp_helptext @NamaSP