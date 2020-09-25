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
		--WHERE (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=A.KodeStore) IN (
		--	CASE WHEN A.Status = 'Submit' THEN (SELECT TOP 1 CASE
		--		WHEN work_location = 'HQ' THEN 'BDB'
		--		WHEN work_location = 'OLD' THEN 'BDB'
		--		ELSE work_location
		--	END AS WorkLocation FROM [192.168.9.109].he_test.dbo.emp_work_location_tbl
		--	WHERE employee_id = @EmployeeID
		--	AND GETDATE() BETWEEN Valid_From AND Valid_To
		--	AND employee_id=@EmployeeID)
		--	ELSE (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=A.KodeStore) END)
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

