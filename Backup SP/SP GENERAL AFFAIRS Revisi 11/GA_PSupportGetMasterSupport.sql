USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportGetMasterSupport]    Script Date: 15/06/2020 8:31:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Ferry Hartono>
-- Create date: <Create Date,,02/09/2019>
-- Description:	<Description,,>
-- Project:|GA19-001 Revisi 9|
-- =============================================
ALTER PROCEDURE [dbo].[GA_PSupportGetMasterSupport]
	-- Add the parameters for the stored procedure here
	@TransactionID	VARCHAR(10),
	@KodeStore		VARCHAR(3),
	@EmployeeID		VARCHAR(8),
	@TglAwal		DATETIME,
	@TglAkhir		DATETIME,
	@Subject		VARCHAR(100),
	@Status			VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	SELECT DISTINCT
		COALESCE(b.TrxID, '') AS TrxID,
		COALESCE(c.NamaUser, '') AS NamaUser,
		COALESCE(b.Subject, '') AS Subject,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Submit' ORDER BY Tanggal DESC) AS Submit,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Approve' ORDER BY Tanggal DESC) AS Approve,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'ReadyToStart' ORDER BY Tanggal DESC) AS ReadyToStart,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Pending' ORDER BY Tanggal DESC) AS Pending,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'PendingChecked' ORDER BY Tanggal DESC) AS PendingChecked,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Start' ORDER BY Tanggal DESC) AS 'Start',
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Finish' ORDER BY Tanggal DESC) AS Finish,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Complaint' ORDER BY Tanggal DESC) AS Complaint,
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Close' ORDER BY Tanggal DESC) AS 'Close',
		(SELECT TOP 1 Tanggal FROM GA_Support_History_Status WHERE TrxID = a.TrxID AND StatusNew = 'Reject' ORDER BY Tanggal DESC) AS Reject,
		b.TglDeadLine,
		COALESCE((SELECT TOP 1 KodeStoreGP FROM MasterStore WHERE KodeStore = b.KodeStore), '') AS KodeStoreGP,
		COALESCE(b.FuncLoc, '') AS FuncLoc,
		COALESCE(b.Deskripsi, '') AS Deskripsi,
		COALESCE((SELECT TOP 1 NamaUser FROM MasterUser WHERE UserID = b.UserIDSubmit), '') AS UserIDSubmit,
		COALESCE(b.Status, '') AS Status,
		COALESCE(b.SumberBiaya, '') AS SumberBiaya,
		b.TglDeadlineManager AS DeadlineManager
	FROM GA_Support_History_Status a
	JOIN GA_Support b ON a.TrxID = b.TrxID
	LEFT JOIN MasterUser c ON b.UserIDGA = c.UserID
	WHERE b.TrxID LIKE '%' + @TransactionID + '%'
	AND b.KodeStore LIKE '%' + @KodeStore + '%'
	AND COALESCE(dbo.GA_FSupportGetUserEmployee(b.UserIDGA, ''),'') LIKE '%' + @EmployeeID + '%'
	AND CONVERT(VARCHAR, b.Tanggal, 112) BETWEEN CONVERT(VARCHAR, @TglAwal, 112) AND CONVERT(VARCHAR, @TglAkhir, 112)
	AND b.Subject LIKE '%' + @Subject + '%'
	AND b.Status LIKE '%' + @Status + '%'
END
GO

