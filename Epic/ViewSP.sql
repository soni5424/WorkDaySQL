declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   HWS_PGetShipPointClearPick       '))
EXEC sp_helptext @NamaSP