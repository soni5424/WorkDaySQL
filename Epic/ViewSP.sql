declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '    PInsertTrxFakturInsurance       '))
EXEC sp_helptext @NamaSP