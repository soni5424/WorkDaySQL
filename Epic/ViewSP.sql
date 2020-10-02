declare @NamaSP varchar(100)
select @NamaSP =  
RTRIM(LTRIM( '          '))
EXEC sp_helptext @NamaSP