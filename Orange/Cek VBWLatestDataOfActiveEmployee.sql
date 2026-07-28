select * from dbo.VBWLatestDataOfActiveEmployee where employee_id='11000080'

select * from [dbo].[employee_category_tbl]
select * from [dbo].[employee_supervisor_tbl] where employee_id='11000080'

select * from position_level_tbl
select * from [dbo].[emp_area_vendor_tbl] where employee_id='11000080'
select * from [dbo].[area_tbl] where area_no in (select area_no from [dbo].[emp_area_vendor_tbl] where employee_id='11000080')
select * from [dbo].[employee_organization_tbl] where employee_id='11000080'
select * from [dbo].[organization_unit_tbl] where org_id in (select org_id from [dbo].[employee_organization_tbl] where employee_id='11000080')
select * from dbo.VBWLatestDataOfActiveEmployee where employee_id='11000080'
select * from [dbo].[emp_work_location_tbl] where employee_id='11000080'
select * from [dbo].[emp_company_office_tbl] where employee_id='11000080'

select * from VBWEmpJoinResignDate where person_id='11000080'
select * from [dbo].[emp_agency_tbl]
select * from [dbo].[emp_area_vendor_tbl] where employee_id='11000080'
select * from [dbo].[vendor_tbl]
select * from [dbo].[employee_grade_tbl] 


select * from [dbo].[VBWEmpWorkPeriodForTarget] where person_id='11000080'
select * from dbo.person_tbl where person_id='11000080'
select * from dbo.employee_tbl where person_id='11000080'
select * from dbo.employee_position_tbl where employee_id='11000080' order by valid_from
select * from position_tbl where position_id='FSO0200000'
select * from work_location_tbl
select * from sap_brand_tbl




select distinct working_Date from [VBWEmpWorkPeriodForTarget] order by working_Date


select * from VBWEmpDataEmployee where employee_id='11000080'