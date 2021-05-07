declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '    HLS_PInsertDTShipment      '))
EXEC sp_helptext @NamaSP