USE [Hartono]
GO

/****** Object:  Table [dbo].[GA_Support_SetupTimProject]    Script Date: 15/06/2020 8:30:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GA_Support_SetupTimProject](
	[EmployeeID] [varchar](20) NOT NULL,
	[NamaUser] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PGetPICUtamaProject]    Script Date: 15/06/2020 8:33:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry
-- Create date: 08/06/2020
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GA_PGetPICUtamaProject]
	-- Add the parameters for the stored procedure here
	@KodeStore	VARCHAR(2) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *, '' AS WorkLocation
	FROM GA_Support_SetupTimProject
END
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PGetPICUtama]    Script Date: 15/06/2020 8:33:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Ferry Hartono>
-- Create date: <Create Date,,02/01/2020>
-- Description:	<Description,,>
-- Project:|GA19-001 Revisi 10|
-- =============================================
ALTER PROCEDURE [dbo].[GA_PGetPICUtama]
	-- Add the parameters for the stored procedure here
	@KodeStore	VARCHAR(2) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT
		UserID AS EmployeeID,
		(SELECT NamaUser FROM MasterUser WHERE KodeBarcode = GA_Support_SetupPICSite.UserID) AS NamaUser,
		'' AS WorkLocation, --(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = GA_Support_SetupPICSite.KodeStore) AS WorkLocation,
		dbo.GA_FSupportGetUserEmployee(UserID, 'User') AS UserID
	FROM GA_Support_SetupPICSite
	WHERE KodeStore LIKE '%' + @KodeStore + '%'

END
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportGetPicBySite]    Script Date: 15/06/2020 8:33:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Ferry Hartono>
-- Create date: <Create Date,,01/10/2019>
-- Description:	<Description,,>
-- Project:|GA19-001 Revisi 10|
-- =============================================
ALTER PROCEDURE [dbo].[GA_PSupportGetPicBySite]
  @KodeStoreGP VARCHAR(4)
AS
BEGIN    
	SELECT
		PICSite.UserID AS employee_id,
		(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = PICSite.KodeStore) AS work_location,
		(SELECT contact_value
        FROM [192.168.9.109].[HE_HRD].dbo.person_contact_method_tbl
        WHERE contact_type=4
        AND person_id = PICSite.UserID) AS EmailTo
	FROM GA_Support_SetupPICSite PICSite
	WHERE (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = PICSite.KodeStore) = @KodeStoreGP
	AND PICSite.UserID NOT IN (SELECT EmployeeID FROM GA_Support_SetupTimProject)
END
GO



USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportGetUrgentList]    Script Date: 15/06/2020 8:33:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Create By    : Soni Gunawan
-- Description  : Init GA19-001
-- Project:|GA19-001 Revisi 9|
-- Project:|GA19-001 Revisi 10|
-- =============================================

ALTER PROCEDURE [dbo].[GA_PSupportGetUrgentList]
	@UserID VARCHAR(8)
AS
BEGIN
	DECLARE @EmployeeID			VARCHAR(8),
			@KodeGrupPermission VARCHAR(50)
	SELECT @EmployeeID = dbo.GA_FSupportGetUserEmployee(@UserID, '')
	SET @KodeGrupPermission = dbo.GA_FSupportGetUserPermission(@UserID)

	IF (@KodeGrupPermission IN ('GAMANAGER'))
		SELECT 
			A.TrxID AS UrgentID,
			A.Tanggal,
			(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=A.KodeStore) AS Store,
			CONVERT(VARCHAR(10),A.TglDeadLine,103) AS TglDeadLine,
			A.Subject AS SubjectPelaporan,
			(SELECT PLTXU FROM GA_FuncLoc WHERE TPLNR=A.FuncLoc) AS DescFuncLoc,
			A.Status,
			A.UserIDSubmit,
			A.UserIDGA,
			dbo.GA_FSupportGetUserEmployee(A.UserIDGA, 'Employee') AS EmployeeIDPICGA,
			(SELECT FlagChecked FROM GA_Support_Request WHERE TrxID=A.TrxID) AS FlagChecked
		FROM GA_Support A
		WHERE A.Status <> 'Close'
		AND A.TrxID LIKE CASE 
			WHEN EXISTS(SELECT EmployeeID FROM GA_Support_SetupTimProject WHERE EmployeeID = @EmployeeID) THEN 'PR%'
			ELSE '%%'
		END
		ORDER BY A.Tanggal ASC, A.KodeStore ASC
	ELSE IF (@KodeGrupPermission IN ('GAUSER', 'GAUSERMANAGER', 'GAUSERSUPER'))
		SELECT 
		  A.TrxID AS UrgentID,
		  A.Tanggal,
		  (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=A.KodeStore) AS Store,
		  CONVERT(VARCHAR(10),A.TglDeadLine,103) AS TglDeadLine,
		  A.Subject AS SubjectPelaporan,
		  (SELECT PLTXU FROM GA_FuncLoc WHERE TPLNR=A.FuncLoc) AS DescFuncLoc,
		  A.Status,
		  A.UserIDSubmit,
		  A.UserIDGA,
		  dbo.GA_FSupportGetUserEmployee(A.UserIDGA, 'Employee') AS EmployeeIDPICGA,
		  (SELECT FlagChecked FROM GA_Support_Request WHERE TrxID=A.TrxID) AS FlagChecked
		FROM GA_Support A
		WHERE A.Status <> 'Close'
		AND A.UserIDSubmit = @UserID
		AND A.TrxID LIKE CASE 
			WHEN EXISTS(SELECT EmployeeID FROM GA_Support_SetupTimProject WHERE EmployeeID = @EmployeeID) THEN 'PR%'
			ELSE '%%'
		END
		ORDER BY A.Tanggal ASC, A.KodeStore ASC
	ELSE
		SELECT
		  A.TrxID AS UrgentID,
		  A.Tanggal,
		  (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=A.KodeStore) AS Store,
		  CONVERT(VARCHAR(10),A.TglDeadLine,103) AS TglDeadLine,
		  A.Subject AS SubjectPelaporan,
		  (SELECT PLTXU FROM GA_FuncLoc WHERE TPLNR=A.FuncLoc) AS DescFuncLoc,
		  A.Status,
		  A.UserIDSubmit,
		  A.UserIDGA,
		  dbo.GA_FSupportGetUserEmployee(A.UserIDGA, 'Employee') AS EmployeeIDPICGA,
		  (SELECT FlagChecked FROM GA_Support_Request WHERE TrxID=A.TrxID) AS FlagChecked
		FROM GA_Support A
		WHERE KodeStore IN (SELECT KodeStore FROM GA_Support_SetupPICSite WHERE UserID = @EmployeeID)
		AND (COALESCE(A.UserIDGA, '') LIKE CASE WHEN A.Status <> 'Submit' THEN @UserID ELSE '%%' END
			OR A.TrxID IN (SELECT TrxID FROM GA_Support_PIC_Tambahan WHERE EmployeeID = @EmployeeID))
		AND A.Status <> 'Close'
		AND A.TrxID LIKE CASE 
			WHEN EXISTS(SELECT EmployeeID FROM GA_Support_SetupTimProject WHERE EmployeeID = @EmployeeID) THEN 'PR%'
			ELSE '%%'
		END
		ORDER BY A.Tanggal ASC, A.KodeStore ASC
END
GO



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



USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportDeleteTimProject]    Script Date: 15/06/2020 8:31:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry Hartono
-- Create date: 13/05/2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GA_PSupportDeleteTimProject]
	-- Add the parameters for the stored procedure here
	@EmployeeID	VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		DELETE FROM GA_Support_SetupTimProject WHERE EmployeeID = @EmployeeID
	END TRY
	BEGIN CATCH
		SELECT 'Data tidak ditemukan' AS ErrorMessage;
	END CATCH
END
GO



USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportInsertTimProject]    Script Date: 15/06/2020 8:30:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry Hartono
-- Create date: 12/15/2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GA_PSupportInsertTimProject]
	-- Add the parameters for the stored procedure here
	@EmployeeID	VARCHAR(20),
	@Nama		VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		INSERT INTO GA_Support_SetupTimProject VALUES(@EmployeeID, @Nama)
	END TRY
	BEGIN CATCH
		SELECT 'Data sudah ada' AS ErrorMessage;
	END CATCH
END
GO

