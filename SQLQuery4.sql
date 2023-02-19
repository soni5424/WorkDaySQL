USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[KPI_PInjectOrangeData]    Script Date: 12/10/2022 11:02:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Jemima|
-- Create date: |05/08/2021|
-- Description:	|Inject Orange Data|
-- Project:		|KPI 2021|

-- Modifier:		|Jemima|
-- Modifiy date:	|18/08/2021|
-- Description:		|Tambah query inject table s_Orange_EmployeePerson, add column person_id di table m_Orange_EmployeePosition|
-- Project:			|KPI 2021|

-- Modifier:		|Jemima|
-- Modifiy date:	|19/08/2021|
-- Description:		|Inject data untuk table s_Orange_EmployeePerson bagian join table employee dan subquery hapus join based on company id|
-- Project:			|KPI 2021|

-- Modifier:		|Jemima|
-- Modifiy date:	|15/09/2021|
-- Description:		|Get data table employee position, join on company id = 'HSE'|
-- Project:			|KPI 2021|

-- Modifier:		|Sisco|
-- Modifiy date:	|16/09/2021|
-- Description:		|Ubah cara untuk isi table m_Orange_EmployeePosition, jadi insert data baru (valid_from = H-1) dan update data lama (valid_to = H-1), add company_group column saat select position_tbl|
-- Project:			|KPI 2021|

-- Modifier:		|Jemima|
-- Modifiy date:	|01/10/2021|
-- Description:		|Tambah query truncate dan insert data m_Orange_EmploymentPeriod|
-- Project:			|KPI 2021|

-- Modifier:		|Jemima|
-- Modifiy date:	|10/01/2022|
-- Description:		|Tambah query truncate dan insert data m_orange_EmployeeDisciplinary|
-- Project:			|KPI 2021|
			
-- Modifier:		|Melita|		
-- Create date:		|29/04/2022|			
-- Description:		|perubahan pengecekan company dari company id jadi company group|		
-- Project:			|KPI 2021|

-- Modifier:		|Melita|
-- Modifiy date:	|12/10/2022|
-- Description:		|Enhance query job m_orange_employeeposition|
-- Project:			|KPI 2021|

-- Modifier:		|Melita|
-- Modifiy date:	|13/10/2022|
-- Description:		|Enhance query job m_Orange_Position, m_Orange_PositionStructure, m_Orange_OrganizationUnit, m_Orange_OrganizationStructure,
--						m_Orange_EmployeeSupervisor, m_Orange_EmployeeWorkLocation, m_Orange_EmployeeOrganization|
-- Project:			|KPI 2021|

-- =============================================
ALTER PROCEDURE [dbo].[KPI_PInjectOrangeData]
AS
BEGIN
	
	TRUNCATE TABLE m_Orange_PositionLevel;
	TRUNCATE TABLE m_Orange_PositionGrade;

	TRUNCATE TABLE m_Orange_OrganizationLevel;

	TRUNCATE TABLE m_Orange_EmployeePerson;
	TRUNCATE TABLE s_Orange_EmployeePerson;

	INSERT INTO m_Orange_PositionLevel
	SELECT company_id, pos_level_no, name, ranking
	FROM [192.168.9.109].HE_HRD.dbo.position_level_tbl;

	INSERT INTO m_Orange_PositionGrade
	SELECT company_id, grade_id, description, ranking
	FROM [192.168.9.109].HE_HRD.dbo.position_grade_tbl
	ORDER BY company_id, ranking;

	INSERT INTO m_Orange_OrganizationLevel
	SELECT company_id, org_level_no, name, ranking
	FROM [192.168.9.109].HE_HRD.dbo.organization_level_tbl;

	INSERT INTO m_Orange_EmployeePerson
	SELECT e.company_id, e.employee_id, e.person_id,
			RTRIM(LTRIM(prs.display_name)) as person_display_name, RTRIM(LTRIM(prs.first_name)) as person_first_name, ISNULL(RTRIM(LTRIM(prs.middle_name)), '') as person_middle_name, ISNULL(RTRIM(LTRIM(prs.last_name)), '') as person_last_name, prs.place_birth as person_place_birth, prs.birth_date as person_birth_date, prs.gender as person_gender
			,pcm.contact_value, e.employee_status
	FROM [192.168.9.109].HE_HRD.dbo.employee_tbl e
	INNER JOIN [192.168.9.109].HE_HRD.dbo.person_tbl prs ON e.person_id = prs.person_id
	LEFT JOIN (
		SELECT person_id, contact_value
		FROM [192.168.9.109].HE_HRD.dbo.person_contact_method_tbl 
		WHERE contact_type = '4' AND default_address = 'Y' 
	) pcm ON e.person_id = pcm.person_id
	ORDER BY e.company_id, e.employee_id;

	WITH EmployeePersonRowSet
	AS (
		SELECT em.company_id, em.person_id, em.employee_id, ROW_NUMBER() OVER (PARTITION BY em.company_id, em.person_id ORDER BY em.company_id, em.person_id, tepos.valid_from DESC) AS row_num
		FROM [192.168.9.109].HE_HRD.dbo.employee_tbl em
		INNER JOIN (
			SELECT e.person_id
			FROM [192.168.9.109].HE_HRD.dbo.employee_tbl e
			INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_position_tbl ep ON e.employee_id = ep.employee_id AND e.company_id = ep.company_id
			WHERE
				ep.valid_from = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) 
		) AS te ON em.person_id = te.person_id
		INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_position_tbl tepos ON em.employee_id = tepos.employee_id AND em.company_id = tepos.company_id
	)
	INSERT INTO s_Orange_EmployeePerson
	SELECT company_id, person_id, employee_id 
	FROM EmployeePersonRowSet
	WHERE row_num <= 2
	GROUP BY company_id, person_id, employee_id;


	-------------------------------- query job m_Orange_Position --------------------------------------------
	DELETE p
	FROM m_Orange_Position p
	INNER JOIN [192.168.9.109].HE_HRD.dbo.position_tbl ps
		ON p.position_id = ps.position_id AND p.company_id = ps.company_id AND p.valid_from = ps.valid_from
	WHERE p.valid_to <> ps.valid_to 
	
	INSERT INTO m_Orange_Position
	SELECT ps.company_id, ps.position_id,
			REPLACE(REPLACE(RTRIM(LTRIM(ps.internal_title)), CHAR(13), ''), CHAR(10), '') as "internal_title", 
			REPLACE(REPLACE(RTRIM(LTRIM(ps.external_title)), CHAR(13), ''), CHAR(10), '') as "external_title", 
			ps.grade_id, ps.pos_level_no, ps.valid_from, ps.valid_to, ps.company_group
	FROM [192.168.9.109].HE_HRD.dbo.position_tbl ps
	LEFT JOIN m_Orange_Position p
		ON p.position_id = ps.position_id AND p.company_id = ps.company_id AND p.valid_from = ps.valid_from
	WHERE p.position_id is null

	------------------------------- query job m_Orange_PositionStructure --------------------------------------
	DELETE ps
	FROM m_Orange_PositionStructure ps
	INNER JOIN [192.168.9.109].HE_HRD.dbo.position_structure_tbl pstbl
		ON pstbl.position_id = ps.position_id AND pstbl.company_id = ps.company_id AND pstbl.valid_from = ps.valid_from
	WHERE pstbl.valid_to <> ps.valid_to 
	
	INSERT INTO m_Orange_PositionStructure
	SELECT pstbl.company_id, pstbl.position_id, pstbl.parent_position_id, pstbl.valid_from, pstbl.valid_to
	FROM [192.168.9.109].HE_HRD.dbo.position_structure_tbl pstbl
	LEFT JOIN m_Orange_PositionStructure ps
		ON pstbl.position_id = ps.position_id AND pstbl.company_id = ps.company_id AND pstbl.valid_from = ps.valid_from
	WHERE ps.position_id is null

	------------------------------- query job m_Orange_OrganizationUnit --------------------------------------
	DELETE ou
	FROM m_Orange_OrganizationUnit ou
	INNER JOIN [192.168.9.109].HE_HRD.dbo.organization_unit_tbl outbl
		ON outbl.org_id = ou.org_id AND outbl.company_id = ou.company_id AND outbl.valid_from = ou.valid_from
	WHERE ou.valid_to <> outbl.valid_to 
	
	INSERT INTO m_Orange_OrganizationUnit
	SELECT outbl.company_id, outbl.org_id, outbl.name, outbl.org_level_no, outbl.valid_from, outbl.valid_to, outbl.company_group
	FROM [192.168.9.109].HE_HRD.dbo.organization_unit_tbl outbl
	LEFT JOIN m_Orange_OrganizationUnit ou
		ON outbl.org_id = ou.org_id AND outbl.company_id = ou.company_id AND outbl.valid_from = ou.valid_from
	WHERE ou.org_id is null and outbl.company_id = 'HSE'

	------------------------------- query job m_Orange_OrganizationStructure --------------------------------------
	DELETE os
	FROM m_Orange_OrganizationStructure os
	INNER JOIN [192.168.9.109].HE_HRD.dbo.organization_structure_tbl ostbl
		ON ostbl.org_id = os.org_id AND ostbl.company_id = os.company_id AND ostbl.valid_from = os.valid_from
	WHERE os.valid_to <> ostbl.valid_to 
	
	INSERT INTO m_Orange_OrganizationStructure
	SELECT ostbl.company_id, ostbl.org_id, ostbl.parent_org_id, ostbl.valid_from, ostbl.valid_to
	FROM [192.168.9.109].HE_HRD.dbo.organization_structure_tbl ostbl
	LEFT JOIN m_Orange_OrganizationStructure os
		ON ostbl.org_id = os.org_id AND ostbl.company_id = os.company_id AND ostbl.valid_from = os.valid_from
	WHERE os.org_id is null
	
	------------------------------- query job m_Orange_EmployeeSupervisor --------------------------------------
	DELETE es 
	FROM m_Orange_EmployeeSupervisor es
	INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_supervisor_tbl espv
		ON espv.employee_id = es.employee_id AND espv.company_id = es.company_id AND espv.valid_from = es.valid_from
	WHERE es.valid_to <> espv.valid_to 

	INSERT INTO m_Orange_EmployeeSupervisor
	SELECT espv.company_id, espv.employee_id, espv.supervisor_id, espv.sup_company_id, espv.valid_from, espv.valid_to
	FROM [192.168.9.109].HE_HRD.dbo.employee_supervisor_tbl espv
	LEFT JOIN m_Orange_EmployeeSupervisor es
		ON espv.employee_id = es.employee_id AND espv.company_id = es.company_id AND espv.valid_from = es.valid_from
	WHERE es.employee_id is null

	------------------------------- query job m_Orange_EmployeeWorkLocation --------------------------------------
	DELETE ewl
	FROM m_Orange_EmployeeWorkLocation ewl
	INNER JOIN [192.168.9.109].HE_HRD.dbo.emp_work_location_tbl ewltbl
		ON ewltbl.employee_id = ewl.employee_id AND ewltbl.work_location = ewl.work_location 
			AND ewltbl.company_id = ewl.company_id AND ewltbl.valid_from = ewl.valid_from
	WHERE ewl.valid_to <> ewltbl.valid_to 

	INSERT INTO m_Orange_EmployeeWorkLocation
	SELECT ewltbl.company_id, ewltbl.employee_id, ewltbl.work_location, ewltbl.valid_from, ewltbl.valid_to
	FROM [192.168.9.109].HE_HRD.dbo.emp_work_location_tbl ewltbl
	LEFT JOIN m_Orange_EmployeeWorkLocation ewl
		ON ewltbl.employee_id = ewl.employee_id AND ewltbl.work_location = ewl.work_location 
			AND ewltbl.company_id = ewl.company_id AND ewltbl.valid_from = ewl.valid_from
	WHERE ewl.employee_id is null

	------------------------------- query job m_Orange_EmployeeOrganization --------------------------------------
	DELETE eo 
	FROM m_Orange_EmployeeOrganization eo
	INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_organization_tbl eotbl
		ON eotbl.employee_id = eo.employee_id AND eotbl.org_id = eo.org_id 
			AND eotbl.company_id = eo.company_id AND eotbl.valid_from = eo.valid_from
	WHERE eo.valid_to <> eotbl.valid_to 

	INSERT INTO m_Orange_EmployeeOrganization
	SELECT eotbl.company_id, eotbl.employee_id, eotbl.org_id, eotbl.valid_from, eotbl.valid_to
	FROM [192.168.9.109].HE_HRD.dbo.employee_organization_tbl eotbl
	LEFT JOIN m_Orange_EmployeeOrganization eo
		ON eotbl.employee_id = eo.employee_id AND eotbl.org_id = eo.org_id 
			AND eotbl.company_id = eo.company_id AND eotbl.valid_from = eo.valid_from
	WHERE eo.employee_id is null

	--############################################################################################
	--UPDATE BY MELITA JOB Employee Position (12/10/2022)
	DELETE em
	FROM m_orange_employeeposition em
	INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_position_tbl empos
		ON em.employee_id = empos.employee_id AND em.company_id = empos.company_id AND empos.valid_from = em.valid_from
	WHERE empos.valid_to <> em.valid_to 

	INSERT INTO m_orange_employeeposition
	SELECT empos.company_id, empos.employee_id, empos.position_id, empos.primary_position, empos.valid_from, empos.valid_to, e.person_id
	FROM [192.168.9.109].HE_HRD.dbo.employee_position_tbl empos
	INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_tbl e ON empos.company_id = e.company_id AND empos.employee_id = e.employee_id
	LEFT JOIN m_orange_employeeposition em
		ON em.employee_id = empos.employee_id AND em.company_id = empos.company_id AND empos.valid_from = em.valid_from
	WHERE em.employee_id is null


	--IF EXISTS (
	--	SELECT TOP 1 * FROM m_Orange_EmployeePosition
	--)
	--BEGIN
	--	declare 
	--	@company_id varchar(10),
	--	@employee_id varchar(20),
	--	@position_id varchar(10),
	--	@primary_position varchar(1),
	--	@valid_from datetime,
	--	@valid_to datetime


	--	declare @date_yesterday datetime
	--	set @date_yesterday = CONVERT(VARCHAR(10), DATEADD(day, -1, getdate()), 111);

	--	INSERT INTO m_Orange_EmployeePosition
	--	SELECT ep.company_id, ep.employee_id, ep.position_id, ep.primary_position, ep.valid_from, ep.valid_to, e.person_id
	--		FROM [192.168.9.109].HE_HRD.dbo.employee_position_tbl ep
	--		INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_tbl e ON ep.company_id = e.company_id AND ep.employee_id = e.employee_id
	--		WHERE 
	--			ep.valid_from = @date_yesterday
	--		ORDER BY ep.company_id, ep.employee_id, ep.position_id, ep.primary_position;

	--	DECLARE db_cursor_oldout CURSOR FOR 
	--	SELECT ep.company_id, ep.employee_id, ep.position_id, ep.primary_position, ep.valid_from, ep.valid_to
	--		FROM [192.168.9.109].HE_HRD.dbo.employee_position_tbl ep
	--		WHERE 
	--			ep.valid_to = @date_yesterday

	--	OPEN db_cursor_oldout

	--	FETCH NEXT FROM db_cursor_oldout INTO @company_id, @employee_id, @position_id, @primary_position, @valid_from, @valid_to 
	--	WHILE @@FETCH_STATUS = 0  
	--		BEGIN  
	--			UPDATE m_Orange_EmployeePosition
	--			SET
	--				valid_to = @valid_to
	--			WHERE
	--				company_id = @company_id AND
	--				employee_id = @employee_id AND
	--				position_id = @position_id AND
	--				valid_from = @valid_from

	--			-- 5 - Fetch the next record from the cursor
 --				FETCH NEXT FROM db_cursor_oldout INTO @company_id, @employee_id, @position_id, @primary_position, @valid_from, @valid_to 
	--		END 

	--	CLOSE db_cursor_oldout  
	--	DEALLOCATE db_cursor_oldout 
	--END
	--ELSE
	--BEGIN
	--	INSERT INTO m_Orange_EmployeePosition
	--	SELECT ep.company_id, ep.employee_id, ep.position_id, ep.primary_position, ep.valid_from, ep.valid_to, e.person_id
	--	FROM [192.168.9.109].HE_HRD.dbo.employee_position_tbl ep
	--	INNER JOIN [192.168.9.109].HE_HRD.dbo.employee_tbl e ON ep.company_id = e.company_id AND ep.employee_id = e.employee_id
	--	WHERE 
	--		ep.valid_from >= CONVERT(DATETIME, '2021-04-01')
	--	ORDER BY ep.company_id, ep.employee_id, ep.position_id, ep.primary_position;
	--END
	--############################################################################################
	

END

--KPI_PInjectOrangeData
GO

