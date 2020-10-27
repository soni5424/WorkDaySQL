declare @NamaSP varchar(100)
select @NamaSP =  RTRIM(LTRIM( '   PGetStatusApprovalCNAdmin       '))
EXEC sp_helptext @NamaSP