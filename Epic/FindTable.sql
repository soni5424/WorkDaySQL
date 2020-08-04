declare @NamaTable varchar(100)
select @NamaTable =  RTRIM(LTRIM( '   Trxubahtglpengiriman      '))

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE Table_Type = 'BASE TABLE'
	AND	Table_Name like '%'+@NamaTable+'%'
	
