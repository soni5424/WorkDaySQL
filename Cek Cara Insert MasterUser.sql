select * from masteruser where kodebarcode like '526%' order by kodebarcode desc
where kodebarcode='52600076' or UserID='52600076'

select * from msdata.dbo.MasterUser_Orange where employee_id='52600076'
select * from [192.168.14.18\SQLPOS].msdata.dbo.MasterUser_Orange where employee_id='52600076'
select * from msdata.dbo.MasterSupirWithEmpId where employee_id='52600076'
select * from [192.168.9.109].HE_HRD.dbo.employee_tbl where employee_id='52600076'
SELECT * from m_Orange_EmployeePerson where employee_id='52600076'

SELECT 
    o.type_desc,
    s.name AS schema_name,
    o.name AS object_name,
    m.definition
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE m.definition LIKE '%192.168.9.109%'
    and m.definition LIKE '% MasterUser%'

ORDER BY o.type_desc, o.name;
