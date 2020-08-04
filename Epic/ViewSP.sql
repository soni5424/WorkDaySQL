declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   SAP_PGetPAPNRStore       '))
EXEC sp_helptext @NamaSP