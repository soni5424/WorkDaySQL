USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[WH_PGetReportHasilAuditScan]    Script Date: 18/08/2020 09.27.01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Daniel
-- Create date: 30/10/2019
-- Description:	View Report Hasil Scan
-- =============================================
ALTER PROCEDURE [dbo].[WH_PGetReportHasilAuditScan]
	-- Add the parameters for the stored procedure here
	@PID varchar(50),
	@SN varchar(50),
	@Date datetime,
	@User varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   if(@Date = '9999-01-01 00:00:00')
   begin
	select PID,SN,convert(varchar(10),(convert(datetime,(convert(varchar(10),Date,103)),103)),103) as Date,convert(varchar(8),Time,111)as Time,UserID as UName 
	from pidscan 
	where
	pid like '%'+@PID+'%'
	and
	sn like '%'+@SN+'%'
	and
	userid like '%'+@User+'%'
	order by PID,convert(datetime,(convert(varchar(10),Date,103)),103),convert(varchar(8),Time,111) asc
   end
   else
   begin
	select PID,SN,convert(varchar(10),(convert(datetime,(convert(varchar(10),Date,103)),103)),103) as Date,convert(varchar(8),Time,111)as Time,UserID as UName 
	from pidscan 
	where
	pid like '%'+@PID+'%'
	and
	sn like '%'+@SN+'%'
	and
	userid like '%'+@User+'%'
	and
	convert(datetime,(convert(varchar(10),Date,103)),103) = convert(datetime,(convert(varchar(10),@Date,103)),103)
	order by PID,convert(datetime,(convert(varchar(10),Date,103)),103),convert(varchar(8),Time,111) ASC
   end
END

GO

