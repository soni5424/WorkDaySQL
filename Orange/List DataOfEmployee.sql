    SELECT 
        w.working_date AS emp_working_period,
        e.employee_id,
        p.person_id,
        p.display_name as display_name,
        e.employee_status,
        case 
            when e.employee_status=1 then 'Active'
            else 'Not Active'
        end employee_status_desc,
        '' AS employee_status_2,
        e.employee_type,
        '' AS employee_type_desc,
        e.first_join_date AS emp_per_valid_from,
        JR.resign_date AS emp_per_valid_to,
        loc.work_location,
        wrkloc.address,
        loc.valid_from as work_location_valid_from,
        loc.valid_to as work_location_valid_to,
        office.company_office,
        office.valid_from AS comp_off_valid_from,
        office.valid_to AS comp_off_valid_to,
        ev.area_no,
        ev.vendor_no,
        vend.vendor,
        vend.company_id AS vendor_company_id,
        ev.valid_from AS emp_vendor_valid_from,
        ev.valid_to AS emp_vendor_valid_to,
        ev.company_id,
        ev.brand_no,
        (select brand from sap_brand_tbl where brand_no=ev.brand_no) AS brand,
        ev.brand_no2,
        (select brand from sap_brand_tbl where brand_no=ev.brand_no2) AS brand2,
        ev.brand_no3,
        (select brand from sap_brand_tbl where brand_no=ev.brand_no3) AS brand3,
        ev.brand_no4,
        (select brand from sap_brand_tbl where brand_no=ev.brand_no4) AS brand4,
        ev.brand_no5,
        (select brand from sap_brand_tbl where brand_no=ev.brand_no5) AS brand5,
        ep.company_id AS pos_company_id,
        ep.position_id,
        pos.internal_title AS pos_internal_title,
        ep.primary_position AS pos_primary,
        pos.pos_level_no AS pos_level_no,
        poslvl.name as pos_level_name,
        pos.grade_id as pos_grade_id,
        empgrd.description as pos_grade_desc,
        ep.valid_from as emp_pos_valid_from,
        ep.valid_to as emp_pos_valid_to,
        ou.org_id,
        ou.name as org_name,
        ou.org_level_no,
        ou.valid_from as org_valid_from,
        ou.valid_to as org_valid_to,
        eo.valid_from as emp_org_valid_from,
        eo.valid_to as emp_org_valid_to,
        ev.area_header_no,
        ev.area_no,
        a.area,
        ev.area_no2,
        (select area from area_tbl where area_no=ev.area_no2) area2,
        ev.area_no3,
        (select area from area_tbl where area_no=ev.area_no3) area3,
        ev.area_no4,
        (select area from area_tbl where area_no=ev.area_no4) area4,
        ev.area_no5,
        (select area from area_tbl where area_no=ev.area_no5) area5,
        ev.area_no6,
        (select area from area_tbl where area_no=ev.area_no6) area6,
        ev.area_no7,
        (select area from area_tbl where area_no=ev.area_no7) area7,
        empspv.company_id AS spv_company_id,
        empspv.supervisor_id AS spv_supervisor_id,
        empspv.valid_from as spv_valid_from,
        empspv.valid_to as spv_valid_to    
    FROM dbo.employee_tbl e
    INNER JOIN dbo.person_tbl p ON e.person_id = p.person_id
    INNER JOIN [dbo].[VBWEmpWorkPeriodForTarget] w ON p.person_id = w.person_id
    LEFT JOIN [dbo].[employee_position_tbl] ep  ON e.employee_id = ep.employee_id AND w.working_date BETWEEN ep.valid_from AND ep.valid_to
    LEFT JOIN [dbo].[position_tbl] pos on pos.company_id=ep.company_id and pos.position_id=ep.position_id
    LEFT JOIN position_level_tbl poslvl on poslvl.company_id=pos.company_id and pos.pos_level_no=poslvl.pos_level_no
    LEFT JOIN employee_grade_tbl empgrd on empgrd.company_id=pos.company_id and empgrd.grade_id=pos.grade_id
    LEFT JOIN [dbo].[employee_organization_tbl] eo ON e.employee_id = eo.employee_id AND w.working_date BETWEEN eo.valid_from AND eo.valid_to
    LEFT JOIN [dbo].[organization_unit_tbl] ou ON eo.org_id = ou.org_id AND w.working_date BETWEEN ou.valid_from AND ou.valid_to
    LEFT JOIN [dbo].[emp_area_vendor_tbl] ev ON e.company_id=ev.company_id and e.employee_id = ev.employee_id and w.working_date BETWEEN ev.valid_from AND ev.valid_to
    LEFT JOIN [dbo].[area_tbl] a ON ev.area_no = a.area_no 
    LEFT JOIN VBWEmpJoinResignDate JR on JR.person_id=p.person_id
    LEFT JOIN [dbo].[emp_work_location_tbl] loc on loc.company_id=e.company_id and loc.employee_id=e.employee_id  and w.working_date BETWEEN loc.valid_from AND loc.valid_to
    LEFT JOIN [dbo].[work_location_tbl] wrkloc on wrkloc.company_id=e.company_id and loc.work_location=wrkloc.work_location
    LEFT JOIN [dbo].[emp_company_office_tbl] office on office.company_id=e.company_id and office.employee_id=e.employee_id and w.working_date BETWEEN office.valid_from AND office.valid_to
    LEFT JOIN [dbo].[vendor_tbl] vend on vend.company_id=e.company_id and ev.vendor_no=vend.vendor_id
    LEFT JOIN [dbo].[employee_supervisor_tbl] empspv on empspv.company_id=e.company_id AND empspv.employee_id=e.employee_id AND w.working_date BETWEEN empspv.valid_from AND empspv.valid_to

    WHERE e.employee_id= '11000080'
    --WHERE p.person_id = '22400030'
    order by emp_working_period
