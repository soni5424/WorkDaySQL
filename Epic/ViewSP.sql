declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( 'PGetTipeInsurance')) 
EXEC sp_helptext @NamaSP