USE [Hartono]
GO

-- =============================================
-- Author		: Ferry Hartono
-- Description	: Add 11300050
-- =============================================
ALTER PROCEDURE [dbo].[GA_PSupportGetUserRequest]
	@KodeStoreGP	VARCHAR(3)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT x.employee_id, x.namauser, x.grade_id, x.valid_from, x.valid_to, x.work_location
	FROM (
		SELECT DISTINCT a.employee_id, c.namauser, e.grade_id, d.valid_from, d.valid_to,
			CASE WHEN a.work_location = 'HQ' THEN 'BDB'
				 WHEN a.work_location = 'OLS' THEN 'BDB'
				 WHEN a.work_location = 'JKT' THEN 'PIN'
				 WHEN a.work_location = 'DRI' THEN 'DRY'
				 ELSE a.work_location
			END AS work_location
		FROM [192.168.9.109].[HE_HRD].dbo.emp_work_location_tbl a,
			 [192.168.9.109].[HE_HRD].dbo.employee_position_tbl d,
			 [192.168.9.109].[HE_HRD].dbo.position_tbl e,
			 MasterStore b,
			 MasterUser c
		WHERE GETDATE() BETWEEN d.valid_from AND d.valid_to
		AND GETDATE() BETWEEN a.valid_from AND a.valid_to
		AND c.kodebarcode = a.employee_id
		AND a.employee_id = d.employee_id
		AND d.position_id = e.position_id
		AND e.grade_id >= 5
		AND d.primary_position = 'Y'
	) x
	WHERE x.work_location = @KodeStoreGP
	OR x.employee_id = '11300050'
END
GO

