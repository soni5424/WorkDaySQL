declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   sap_PCheckValidBATASPengirimanStore       '))
EXEC sp_helptext @NamaSP