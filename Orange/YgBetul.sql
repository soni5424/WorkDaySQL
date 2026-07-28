--CREATE VIEW VBWEmpWorkPeriodForTarget2 AS

SELECT employee_id, COUNT(*) AS jumlah_duplikat
FROM (
    SELECT
        eo.employee_id
    FROM employee_organization_tbl eo
    INNER JOIN VBWEmpWorkPeriodForTarget v_target ON eo.employee_id = v_target.employee_id 
    LEFT JOIN employee_position_tbl ep ON eo.employee_id = ep.employee_id
    LEFT JOIN employment_period_tbl epd ON eo.employee_id = epd.employee_id AND eo.company_id = epd.company_id
    LEFT JOIN employee_tbl emp ON eo.employee_id = emp.employee_id AND eo.company_id = emp.company_id
    LEFT JOIN emp_work_location_tbl ew ON emp.company_id = ew.company_id AND emp.employee_id = ew.employee_id
    LEFT JOIN emp_company_office_tbl eco ON eo.employee_id = eco.employee_id AND eo.company_id = eco.company_id
    LEFT JOIN emp_area_vendor_tbl eav ON eo.company_id = eav.company_id AND eo.employee_id = eav.employee_id
    LEFT JOIN position_tbl p ON ep.position_id = p.position_id AND ep.company_id = p.company_id
    LEFT JOIN position_structure_tbl ps ON p.position_id = ps.position_id AND p.company_id = ps.company_id
    WHERE 
        -- Filter iris masa berlaku antar tabel
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
        -- Filter target tanggal kerja
        AND v_target.working_date BETWEEN ep.valid_from AND ep.valid_to
        AND v_target.working_date BETWEEN eo.valid_from AND eo.valid_to
        AND v_target.working_date BETWEEN epd.valid_from AND epd.valid_to
        AND v_target.working_date BETWEEN ew.valid_from AND ew.valid_to
        AND v_target.working_date BETWEEN eco.valid_from AND eco.valid_to
        AND v_target.working_date BETWEEN eav.valid_from AND eav.valid_to
        AND v_target.working_date = '20260601'
) x
GROUP BY employee_id
HAVING COUNT(*) > 1;