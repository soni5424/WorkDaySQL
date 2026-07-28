SELECT distinct v_target.working_date,
eo.employee_id, per.person_id, per.display_name as 'employee_name', 
             emp.employee_status, 
             CASE
                    WHEN emp.employee_status = 1 THEN 'Active'
                    WHEN emp.employee_status = 2 THEN 'Inactive'
                    ELSE 'N/A'
             END as employee_status_desc,
             CASE 
                    WHEN emp.employee_status=1 and (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id ) = 1 then 'New Employee'
                    WHEN emp.employee_status=1 and (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id) > 1 then 'Perpanjangan Kontrak'
                    WHEN emp.employee_status=2 and (SELECT COUNT(*) FROM employee_tbl et WHERE et.person_id = emp.person_id) >= 1 then 'Resign'
             END as employee_status_2,
             epd.employee_type, 
             CASE
                    WHEN epd.employee_type = 1 THEN 'Permanent'
                    WHEN epd.employee_type = 2 THEN 'Contract'
                    WHEN epd.employee_type = 3 THEN 'Temporary'
                    ELSE 'N/A'
             END as employee_type_desc,
             
             CONVERT(VARCHAR(10), epd.valid_from, 112) as 'emp_per_valid_from', CONVERT(VARCHAR(10), epd.valid_to, 112) as 'emp_per_valid_to',
             ew.work_location, CONVERT(VARCHAR(10), ew.valid_from, 112) as 'work_location_valid_from', CONVERT(VARCHAR(10), ew.valid_to, 112) as 'work_location_valid_to',
             eco.company_office, CONVERT(VARCHAR(10), eco.valid_from, 112) as 'comp_off_valid_from', CONVERT(VARCHAR(10), eco.valid_to, 112) as 'comp_off_valid_to',
             eav.vendor_no, v.vendor, v.company_id as 'vendor_company_id', CONVERT(VARCHAR(10), eav.valid_from, 112) as 'emp_vendor_valid_from', CONVERT(VARCHAR(10), eav.valid_to, 112) as 'emp_vendor_valid_to', 
             --START : Revisi oleh Jemima (10/08/2023), atas request Bu Rinny (10/08/2023) untuk get vendor id sesuai dengan format SAP
             CASE
                    WHEN eav.vendor_no LIKE 'HE%' THEN 'HSE'
                    WHEN eav.vendor_no LIKE 'HM%' THEN 'HSM'
                    ELSE v.company_id
             END as 'vendor_subcompany_id',
             CASE
                    WHEN (eav.vendor_no LIKE 'HE%') OR (eav.vendor_no LIKE 'HM%') THEN SUBSTRING(eav.vendor_no, 3, LEN(eav.vendor_no)-2)
                    ELSE eav.vendor_no
             END as 'vendor_sap_no',
             --END

             eav.brand_no, sb.brand, eav.brand_no2, sb2.brand as 'brand2', eav.brand_no3, sb3.brand as 'brand3', eav.brand_no4, sb4.brand as 'brand4', eav.brand_no5, sb5.brand as 'brand5', 

             p.company_id as 'pos_company_id', p.company_group as 'pos_company_group',
             upper(ep.position_id) as 'position_id' , p.internal_title as 'pos_internal_title', ep.primary_position as 'pos_primary', 
             p.pos_level_no as 'pos_level_no', pl.name as 'pos_level_name', p.grade_id as 'pos_grade_id', pg.description as 'pos_grade_desc', 
             CONVERT(VARCHAR(10), p.valid_from, 112) as 'pos_valid_from', CONVERT(VARCHAR(10), p.valid_to, 112) as 'pos_valid_to',
             CONVERT(VARCHAR(10), ep.valid_from, 112) as 'emp_pos_valid_from', CONVERT(VARCHAR(10), ep.valid_to, 112) as 'emp_pos_valid_to',
             upper(ps.parent_position_id) as 'parent_position_id' , p1.internal_title as 'parent_pos_internal_title', CONVERT(VARCHAR(10), ps.valid_from, 112) as 'parent_pos_valid_from', CONVERT(VARCHAR(10), ps.valid_to, 112) as 'parent_pos_valid_to',

             ou.company_id as 'org_company_id', ou.company_group as 'org_company_group',
             eo.org_id as 'org_id', ou.name as 'org_name', ou.org_level_no as 'org_level_no', ol.name as 'org_level_name',
             CONVERT(VARCHAR(10), ou.valid_from, 112) as 'org_valid_from', CONVERT(VARCHAR(10), ou.valid_to, 112) as 'org_valid_to',
             CONVERT(VARCHAR(10), eo.valid_from, 112) as 'emp_org_valid_from', CONVERT(VARCHAR(10), eo.valid_to, 112) as 'emp_org_valid_to',

             eav.area_header_no, upper(ah.area_header) as 'area_header',
             eav.area_no, a.area, eav.area_no2, a2.area as 'area2', eav.area_no3, a3.area as 'area3', eav.area_no4, a4.area as 'area4', eav.area_no5, a5.area as 'area5', eav.area_no6, a6.area as 'area6', eav.area_no7, a7.area as 'area7',
             
             '' as 'spv_company_id', '' as 'spv_supervisor_id', '' as 'spv_valid_from', '' as 'spv_valid_to'
             --espv.sup_company_id as 'spv_company_id', espv.supervisor_id as 'spv_supervisor_id', CONVERT(VARCHAR(10), espv.valid_from, 112) as 'spv_valid_from', CONVERT(VARCHAR(10), espv.valid_to, 112) as 'spv_valid_to'


FROM employee_organization_tbl eo
INNER JOIN VBWEmpWorkPeriodForTarget v_target ON eo.employee_id = v_target.employee_id -- Diubah ke INNER karena working_date wajib ada
LEFT JOIN organization_unit_tbl ou on eo.org_id = ou.org_id and eo.company_id = ou.company_id
LEFT JOIN organization_level_tbl ol on ou.org_level_no = ol.org_level_no
LEFT JOIN employee_position_tbl ep on eo.employee_id = ep.employee_id 
LEFT JOIN position_tbl p on ep.position_id = p.position_id and ep.company_id = p.company_id
LEFT JOIN position_level_tbl pl on p.pos_level_no = pl.pos_level_no 
LEFT JOIN position_grade_tbl pg on p.grade_id = pg.grade_id and p.company_id = pg.company_id
LEFT JOIN employee_tbl emp on eo.employee_id = emp.employee_id and eo.company_id = emp.company_id
LEFT JOIN person_tbl per on emp.person_id = per.person_id 
LEFT JOIN employment_period_tbl epd on eo.employee_id = epd.employee_id and eo.company_id = epd.company_id
LEFT JOIN emp_work_location_tbl ew on emp.company_id=ew.company_id and emp.employee_id = ew.employee_id
LEFT JOIN emp_company_office_tbl eco on eo.employee_id = eco.employee_id and eo.company_id = eco.company_id
LEFT JOIN emp_area_vendor_tbl eav on eo.company_id = eav.company_id and eo.employee_id = eav.employee_id
LEFT JOIN vendor_tbl v on eav.company_id = v.company_id and eav.vendor_no = v.vendor_id
LEFT JOIN sap_brand_tbl sb on eav.brand_no = sb.brand_no
LEFT JOIN sap_brand_tbl sb2 on eav.brand_no2 = sb2.brand_no
LEFT JOIN sap_brand_tbl sb3 on eav.brand_no3 = sb3.brand_no
LEFT JOIN sap_brand_tbl sb4 on eav.brand_no4 = sb4.brand_no
LEFT JOIN sap_brand_tbl sb5 on eav.brand_no5 = sb5.brand_no
LEFT JOIN area_header_tbl ah on eav.company_id = ah.company_id and eav.area_header_no = ah.area_header_no and ah.work_location = ew.work_location
LEFT JOIN area_tbl a on eav.company_id = a.company_id and eav.area_no = a.area_no
LEFT JOIN area_tbl a2 on eav.company_id = a2.company_id and eav.area_no2 = a2.area_no
LEFT JOIN area_tbl a3 on eav.company_id = a3.company_id and eav.area_no3 = a3.area_no
LEFT JOIN area_tbl a4 on eav.company_id = a4.company_id and eav.area_no4 = a4.area_no
LEFT JOIN area_tbl a5 on eav.company_id = a5.company_id and eav.area_no5 = a5.area_no
LEFT JOIN area_tbl a6 on eav.company_id = a6.company_id and eav.area_no6 = a6.area_no
LEFT JOIN area_tbl a7 on eav.company_id = a7.company_id and eav.area_no7 = a7.area_no
LEFT JOIN position_structure_tbl ps on p.position_id = ps.position_id and p.company_id = ps.company_id
LEFT JOIN position_tbl p1 on ps.parent_position_id = p1.position_id and ps.company_id = p1.company_id
--LEFT JOIN employee_supervisor_tbl espv on eo.company_id = espv.company_id and eo.employee_id = espv.employee_id

WHERE
       (ep.valid_from <= eo.valid_to AND ep.valid_to >= eo.valid_from)

       AND (epd.valid_from <= eo.valid_to AND epd.valid_to >= eo.valid_from)
       AND (epd.valid_from <= ep.valid_to AND epd.valid_to >= ep.valid_from)

       AND (ew.valid_from <= eo.valid_to AND ew.valid_to >= eo.valid_from)
       AND (ew.valid_from <= ep.valid_to AND ew.valid_to >= ep.valid_from)
       AND (ew.valid_from <= epd.valid_to AND ew.valid_to >= epd.valid_from)

       AND (eco.valid_from <= eo.valid_to AND eco.valid_to >= eo.valid_from)
       AND (eco.valid_from <= ep.valid_to AND eco.valid_to >= ep.valid_from)
       AND (eco.valid_from <= epd.valid_to AND eco.valid_to >= epd.valid_from)
       AND (eco.valid_from <= ew.valid_to AND eco.valid_to >= ew.valid_from)

       AND (eav.valid_from <= eo.valid_to AND eav.valid_to >= eo.valid_from)
       AND (eav.valid_from <= ep.valid_to AND eav.valid_to >= ep.valid_from)
       AND (eav.valid_from <= epd.valid_to AND eav.valid_to >= epd.valid_from)
       AND (eav.valid_from <= ew.valid_to AND eav.valid_to >= ew.valid_from)
       AND (eav.valid_from <= eco.valid_to AND eav.valid_to >= eco.valid_from)

       AND (ps.valid_from <= eo.valid_to AND ps.valid_to >= eo.valid_from)
       AND (ps.valid_from <= ep.valid_to AND ps.valid_to >= ep.valid_from)
       AND (ps.valid_from <= epd.valid_to AND ps.valid_to >= epd.valid_from)
       AND (ps.valid_from <= ew.valid_to AND ps.valid_to >= ew.valid_from)
       AND (ps.valid_from <= eco.valid_to AND ps.valid_to >= eco.valid_from)
       AND (ps.valid_from <= eav.valid_to AND ps.valid_to >= eav.valid_from)
AND v_target.working_date BETWEEN ep.valid_from AND ep.valid_to
AND v_target.working_date BETWEEN eo.valid_from AND eo.valid_to
AND v_target.working_date BETWEEN epd.valid_from AND epd.valid_to
AND v_target.working_date BETWEEN ew.valid_from AND ew.valid_to
AND v_target.working_date BETWEEN eco.valid_from AND eco.valid_to
AND v_target.working_date BETWEEN eav.valid_from AND eav.valid_to
AND v_target.working_date BETWEEN ps.valid_from AND ps.valid_to



--and emp.employee_id='52400100'
and v_target.working_date='20260501'
--and eo.employee_id in (
----'10100021',
----'10200012',
----'10600002',
----'11800059',
--'12500077' -- select * from employee_position_tbl where employee_id='12500077', apakah perlu di filter primary_position='y'
----'42600021'
----'52500001' -- select * from area_tbl where area_no in ('699', '703')
----'52500008' -- select * from area_tbl where area_no='699' data master area salah
--)
order by v_target.working_date, eo.employee_id
