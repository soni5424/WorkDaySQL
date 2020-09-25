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
    --SELECT A.*, B.work_location
    --FROM
    --    (SELECT person_id AS employee_id,
    --        contact_value AS 'EmailTo'
    --    FROM [192.168.9.109].[HE_TEST].dbo.person_contact_method_tbl
    --    WHERE contact_type=4
    --    AND person_id IN (SELECT DISTINCT person_id FROM [192.168.9.109].[HE_TEST].dbo.employee_tbl)) A
    --INNER JOIN
    --    (SELECT DISTINCT employee_id,
    --                    CASE
    --                        WHEN work_location='HQ' THEN 'BDB'
    --                        WHEN work_location='OLS' THEN 'BDB'
    --                        ELSE work_location
    --                    END AS work_location
    --    FROM [192.168.9.109].[HE_TEST].dbo.emp_work_location_tbl
    --    WHERE GETDATE() BETWEEN Valid_From AND Valid_To) B ON 
    --            A.employee_id=B.employee_id
    --INNER JOIN
    --    (SELECT employee_id
    --    FROM [192.168.9.109].[HE_TEST].dbo.employee_position_tbl
    --    WHERE position_id='1902010100' --GA Staff
    --        AND primary_position='Y'
    --        AND GETDATE() BETWEEN valid_from AND valid_to) C ON 
    --            A.employee_id=C.Employee_id
    --WHERE B.employee_id=A.employee_id
    --    AND C.Employee_id=A.employee_id
    --    AND work_location=@KodeStoreGP

	SELECT
		PICSite.UserID AS employee_id,
		(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = PICSite.KodeStore) AS work_location,
		(SELECT contact_value
        FROM [192.168.9.109].[HE_TEST].dbo.person_contact_method_tbl
        WHERE contact_type=4
        AND person_id = PICSite.UserID) AS EmailTo
	FROM GA_Support_SetupPICSite PICSite
	WHERE (SELECT KodeStoreGP FROM MasterStore WHERE KodeStore = PICSite.KodeStore) = @KodeStoreGP
	AND PICSite.UserID NOT IN (SELECT EmployeeID FROM GA_Support_SetupTimProject)
END
GO

