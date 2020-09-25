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

    -- Insert statements for procedure here
	--SELECT DISTINCT
	--	a.employee_id AS EmployeeID,
	--	CASE
	--		WHEN work_location = 'HQ' THEN 'BDB'
	--		WHEN work_location = 'OLS' THEN 'BDB'
	--		ELSE work_location
	--	END AS WorkLocation,
	--	c.NamaUser,
	--	c.UserID
	--FROM [192.168.9.109].he_test.dbo.emp_work_location_tbl a
	--JOIN [192.168.9.109].he_test.dbo.employee_position_tbl b
	--ON a.employee_id = b.employee_id
	--JOIN MasterUser c
	--ON a.employee_id = c.KodeBarcode
	--WHERE GETDATE() BETWEEN a.valid_from AND a.valid_to
	--AND GETDATE() BETWEEN b.valid_from AND b.valid_to
	--AND b.position_id = '1902010100'
	--AND b.primary_position = 'Y'
	----AND c.UserID NOT IN (SELECT DISTINCT COALESCE(UserIDGA, '') FROM GA_Support WHERE Status = 'Start')

	SELECT DISTINCT
		UserID AS EmployeeID,
		(SELECT NamaUser FROM MasterUser WHERE KodeBarcode = GA_Support_SetupPICSite.UserID) AS NamaUser,
		'' AS WorkLocation, --(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = GA_Support_SetupPICSite.KodeStore) AS WorkLocation,
		dbo.GA_FSupportGetUserEmployee(UserID, 'User') AS UserID
	FROM GA_Support_SetupPICSite
	WHERE KodeStore LIKE '%' + @KodeStore + '%'

	--SELECT *, '' AS WorkLocation
	--FROM GA_Support_SetupTimProject
END
GO

