USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportGetRealisasiGAScheduled]    Script Date: 15/06/2020 8:32:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Ferry Hartono>
-- Create date: <Create Date,,29/08/2019>
-- Description:	<Description,,>
-- Project:|GA19-001 Revisi 10|
-- =============================================
ALTER PROCEDURE [dbo].[GA_PSupportGetRealisasiGAScheduled]
	-- Add the parameters for the stored procedure here
	@ScheduledID	VARCHAR(10),
	@TransactionID	VARCHAR(10),
	@KodeStore		VARCHAR(3),
	@EmployeeID		VARCHAR(8),
	@TglAwal		DATETIME,
	@TglAkhir		DATETIME,
	@Task			VARCHAR(100),
	@Status			VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@Task = 'Other') BEGIN
		SELECT A.ScheduledID, b.Task, b.TaskDesc, d.NamaUser, a.Tanggal, c.Tanggal AS TanggalFinish, c.Deskripsi, b.TrxID
		FROM GA_ScheduledDateList a
		LEFT JOIN GA_ScheduledFinish c ON a.ScheduledID = c.ScheduledID AND CONVERT(VARCHAR, a.Tanggal, 103) = CONVERT(VARCHAR, c.Tanggal, 103)
		LEFT JOIN GA_Scheduled b ON a.ScheduledID = b.ScheduledID
		LEFT JOIN MasterUser d ON b.UserIDGA = d.UserID
		WHERE a.ScheduledID LIKE '%' + @ScheduledID + '%'
		AND (b.TrxID LIKE '%' + @TransactionID + '%' OR b.TrxID IS NULL)
		AND b.KodeStore LIKE '%' + @KodeStore + '%'
		AND dbo.GA_FSupportGetUserEmployee(b.UserIDGA, '') LIKE '%' + @EmployeeID + '%'
		AND CONVERT(VARCHAR, a.Tanggal, 112) BETWEEN CONVERT(VARCHAR, @TglAwal, 112) AND CONVERT(VARCHAR, @TglAkhir, 112)
		AND b.Task NOT IN (SELECT Task FROM GA_ScheduledMasterTask WHERE Status = 'Aktif')
		AND CASE WHEN @Status = '' THEN 1 ELSE COALESCE(c.Tanggal, 0) END = CASE
			WHEN @Status = 'Finish' THEN c.Tanggal 
			WHEN @Status = 'Not Finish' THEN 0
			ELSE 1 END
	END
	ELSE BEGIN
		SELECT A.ScheduledID, b.Task, b.TaskDesc, d.NamaUser, a.Tanggal, c.Tanggal AS TanggalFinish, c.Deskripsi, b.TrxID
		FROM GA_ScheduledDateList a
		LEFT JOIN GA_ScheduledFinish c ON a.ScheduledID = c.ScheduledID AND CONVERT(VARCHAR, a.Tanggal, 103) = CONVERT(VARCHAR, c.Tanggal, 103)
		LEFT JOIN GA_Scheduled b ON a.ScheduledID = b.ScheduledID
		LEFT JOIN MasterUser d ON b.UserIDGA = d.UserID
		WHERE a.ScheduledID LIKE '%' + @ScheduledID + '%'
		AND (b.TrxID LIKE '%' + @TransactionID + '%' OR b.TrxID IS NULL)
		AND b.KodeStore LIKE '%' + @KodeStore + '%'
		AND dbo.GA_FSupportGetUserEmployee(b.UserIDGA, '') LIKE '%' + @EmployeeID + '%'
		AND CONVERT(VARCHAR, a.Tanggal, 112) BETWEEN CONVERT(VARCHAR, @TglAwal, 112) AND CONVERT(VARCHAR, @TglAkhir, 112)
		AND b.Task LIKE '%' + @Task + '%'
		AND CASE WHEN @Status = '' THEN 1 ELSE COALESCE(c.Tanggal, 0) END = CASE
			WHEN @Status = 'Finish' THEN c.Tanggal 
			WHEN @Status = 'Not Finish' THEN 0
			ELSE 1 END
	END
END
GO

