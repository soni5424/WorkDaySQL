select count(*) from VBWEmpWorkPeriodForTarget where working_Date='20260601'




SELECT count(*)
   -- v_target.working_date,
   -- eo.employee_id, 
   -- per.person_id, 
   -- per.display_name AS 'employee_name', 
   -- emp.employee_status, 
   -- CASE
   --     WHEN emp.employee_status = 1 THEN 'Active'
   --     WHEN emp.employee_status = 2 THEN 'Inactive'
   --     ELSE 'N/A'
   -- END AS employee_status_desc,
   -- CASE 
   --     WHEN emp.employee_status = 1 AND (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id) = 1 THEN 'New Employee'
   --     WHEN emp.employee_status = 1 AND (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id) > 1 THEN 'Perpanjangan Kontrak'
   --     WHEN emp.employee_status = 2 AND (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id) >= 1 THEN 'Resign'
   -- END AS employee_status_2,
   -- epd.employee_type, 
   -- CASE
   --     WHEN epd.employee_type = 1 THEN 'Permanent'
   --     WHEN epd.employee_type = 2 THEN 'Contract'
   --     WHEN epd.employee_type = 3 THEN 'Temporary'
   --     ELSE 'N/A'
   -- END AS employee_type_desc,    
   -- CONVERT(VARCHAR(10), epd.valid_from, 112) AS 'emp_per_valid_from', 
   -- CONVERT(VARCHAR(10), epd.valid_to, 112) AS 'emp_per_valid_to',
   -- ew.work_location, 
   -- CONVERT(VARCHAR(10), ew.valid_from, 112) AS 'work_location_valid_from', 
   -- CONVERT(VARCHAR(10), ew.valid_to, 112) AS 'work_location_valid_to',
   -- eco.company_office, 
   -- CONVERT(VARCHAR(10), eco.valid_from, 112) AS 'comp_off_valid_from', 
   -- CONVERT(VARCHAR(10), eco.valid_to, 112) AS 'comp_off_valid_to',
   -- eav.vendor_no, 
   -- v.vendor, 
   -- v.company_id AS 'vendor_company_id', 
   -- CONVERT(VARCHAR(10), eav.valid_from, 112) AS 'emp_vendor_valid_from', 
   -- CONVERT(VARCHAR(10), eav.valid_to, 112) AS 'emp_vendor_valid_to', 
   -- CASE
   --     WHEN eav.vendor_no LIKE 'HE%' THEN 'HSE'
   --     WHEN eav.vendor_no LIKE 'HM%' THEN 'HSM'
   --     ELSE v.company_id
   -- END AS 'vendor_subcompany_id',
   -- CASE
   --     WHEN (eav.vendor_no LIKE 'HE%') OR (eav.vendor_no LIKE 'HM%') THEN SUBSTRING(eav.vendor_no, 3, LEN(eav.vendor_no)-2)
   --     ELSE eav.vendor_no
   -- END AS 'vendor_sap_no',
   -- eav.brand_no, sb.brand, 
   -- eav.brand_no2, sb2.brand AS 'brand2', 
   -- eav.brand_no3, sb3.brand AS 'brand3', 
   -- eav.brand_no4, sb4.brand AS 'brand4', 
   -- eav.brand_no5, sb5.brand AS 'brand5', 
   -- p.company_id AS 'pos_company_id', 
   -- p.company_group AS 'pos_company_group',
   --UPPER(ep.position_id) AS 'position_id', 
   -- p.internal_title AS 'pos_internal_title', 
   -- ep.primary_position AS 'pos_primary', 
   -- p.pos_level_no AS 'pos_level_no', 
   -- pl.name AS 'pos_level_name', 
   -- p.grade_id AS 'pos_grade_id', 
   -- pg.description AS 'pos_grade_desc', 
   -- CONVERT(VARCHAR(10), p.valid_from, 112) AS 'pos_valid_from', 
   -- CONVERT(VARCHAR(10), p.valid_to, 112) AS 'pos_valid_to',
   -- CONVERT(VARCHAR(10), ep.valid_from, 112) AS 'emp_pos_valid_from', 
   -- CONVERT(VARCHAR(10), ep.valid_to, 112) AS 'emp_pos_valid_to',
   -- UPPER(ps.parent_position_id) AS 'parent_position_id', 
   -- p1.internal_title AS 'parent_pos_internal_title', 
   -- CONVERT(VARCHAR(10), ps.valid_from, 112) AS 'parent_pos_valid_from', 
   -- CONVERT(VARCHAR(10), ps.valid_to, 112) AS 'parent_pos_valid_to',
   -- ou.company_id AS 'org_company_id', 
   -- ou.company_group AS 'org_company_group',
   -- eo.org_id AS 'org_id', 
   -- ou.name AS 'org_name', 
   -- ou.org_level_no AS 'org_level_no', 
   -- ol.name AS 'org_level_name',
   -- CONVERT(VARCHAR(10), ou.valid_from, 112) AS 'org_valid_from', 
   -- CONVERT(VARCHAR(10), ou.valid_to, 112) AS 'org_valid_to',
   -- CONVERT(VARCHAR(10), eo.valid_from, 112) AS 'emp_org_valid_from', 
   -- CONVERT(VARCHAR(10), eo.valid_to, 112) AS 'emp_org_valid_to',
   -- eav.area_header_no, 
   -- UPPER(ah.area_header) AS 'area_header',
   -- eav.area_no, a.area, 
   -- eav.area_no2, a2.area AS 'area2', 
   -- eav.area_no3, a3.area AS 'area3', 
   -- eav.area_no4, a4.area AS 'area4', 
   -- eav.area_no5, a5.area AS 'area5', 
   -- eav.area_no6, a6.area AS 'area6', 
   -- eav.area_no7, a7.area AS 'area7',
   -- espv.company_id AS spv_company_id,
   -- espv.supervisor_id AS spv_supervisor_id,
   -- espv.valid_from AS spv_valid_from,
   -- espv.valid_to AS spv_valid_to 
FROM employee_organization_tbl eo
INNER JOIN VBWEmpWorkPeriodForTarget v_target ON eo.employee_id = v_target.employee_id -- Diubah ke INNER karena working_date wajib ada
LEFT JOIN organization_unit_tbl ou ON eo.org_id = ou.org_id AND eo.company_id = ou.company_id
LEFT JOIN organization_level_tbl ol ON ou.org_level_no = ol.org_level_no
LEFT JOIN employee_position_tbl ep ON eo.employee_id = ep.employee_id
LEFT JOIN position_tbl p ON ep.position_id = p.position_id AND ep.company_id = p.company_id
LEFT JOIN position_level_tbl pl ON p.pos_level_no = pl.pos_level_no 
LEFT JOIN position_grade_tbl pg ON p.grade_id = pg.grade_id AND p.company_id = pg.company_id
LEFT JOIN employee_tbl emp ON eo.employee_id = emp.employee_id AND eo.company_id = emp.company_id
LEFT JOIN person_tbl per ON emp.person_id = per.person_id 
LEFT JOIN employment_period_tbl epd ON eo.employee_id = epd.employee_id AND eo.company_id = emp.company_id
LEFT JOIN emp_work_location_tbl ew ON eo.employee_id = ew.employee_id
LEFT JOIN emp_company_office_tbl eco ON eo.employee_id = eco.employee_id AND eo.company_id = eco.company_id
LEFT JOIN emp_area_vendor_tbl eav ON eo.company_id = eav.company_id AND eo.employee_id = eav.employee_id
LEFT JOIN vendor_tbl v ON eav.company_id = v.company_id AND eav.vendor_no = v.vendor_id
LEFT JOIN sap_brand_tbl sb ON eav.brand_no = sb.brand_no
LEFT JOIN sap_brand_tbl sb2 ON eav.brand_no2 = sb2.brand_no
LEFT JOIN sap_brand_tbl sb3 ON eav.brand_no3 = sb3.brand_no
LEFT JOIN sap_brand_tbl sb4 ON eav.brand_no4 = sb4.brand_no
LEFT JOIN sap_brand_tbl sb5 ON eav.brand_no5 = sb5.brand_no
LEFT JOIN area_header_tbl ah ON eav.company_id = ah.company_id AND eav.area_header_no = ah.area_header_no AND ah.work_location = ew.work_location
LEFT JOIN area_tbl a ON eav.company_id = a.company_id AND eav.area_no = a.area_no
LEFT JOIN area_tbl a2 ON eav.company_id = a2.company_id AND eav.area_no2 = a2.area_no
LEFT JOIN area_tbl a3 ON eav.company_id = a3.company_id AND eav.area_no3 = a3.area_no
LEFT JOIN area_tbl a4 ON eav.company_id = a4.company_id AND eav.area_no4 = a4.area_no
LEFT JOIN area_tbl a5 ON eav.company_id = a5.company_id AND eav.area_no5 = a5.area_no
LEFT JOIN area_tbl a6 ON eav.company_id = a6.company_id AND eav.area_no6 = a6.area_no
LEFT JOIN area_tbl a7 ON eav.company_id = a7.company_id AND eav.area_no7 = a7.area_no
LEFT JOIN position_structure_tbl ps ON p.position_id = ps.position_id AND p.company_id = ps.company_id
LEFT JOIN position_tbl p1 ON ps.parent_position_id = p1.position_id AND ps.company_id = p1.company_id
LEFT JOIN employee_supervisor_tbl espv ON eo.company_id = espv.company_id AND eo.employee_id = espv.employee_id
WHERE       
    -- Menggunakan working_date sebagai jangkar utama pemotongan data (SANGAT OPTIMAL)
    v_target.working_date BETWEEN eo.valid_from AND eo.valid_to
    AND (ep.valid_from IS NULL OR v_target.working_date BETWEEN ep.valid_from AND ep.valid_to)
    AND (epd.valid_from IS NULL OR v_target.working_date BETWEEN epd.valid_from AND epd.valid_to)
    AND (ew.valid_from IS NULL OR v_target.working_date BETWEEN ew.valid_from AND ew.valid_to)
    AND (eco.valid_from IS NULL OR v_target.working_date BETWEEN eco.valid_from AND eco.valid_to)
    AND (eav.valid_from IS NULL OR v_target.working_date BETWEEN eav.valid_from AND eav.valid_to)
    AND (ps.valid_from IS NULL OR v_target.working_date BETWEEN ps.valid_from AND ps.valid_to)
    AND (espv.valid_from IS NULL OR v_target.working_date BETWEEN espv.valid_from AND espv.valid_to)
    AND v_target.working_Date='20260601'


    select 2603-2407
