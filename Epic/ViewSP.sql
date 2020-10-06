declare @NamaSP varchar(100)
select @NamaSP =  
RTRIM(LTRIM( '   sp_MSupd_dboSAP_ARTICLE       '))
EXEC sp_helptext @NamaSP