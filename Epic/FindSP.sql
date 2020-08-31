use hartono
SELECT Routine_name, last_altered
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE     
    ROUTINE_DEFINITION LIKE '%B1_OtorisasiReport%' 
    AND ROUTINE_DEFINITION LIKE '%CompanyCode%' 
    --AND ROUTINE_DEFINITION LIKE '%%' 
	AND routine_name not like 'sp_%' 
	--AND routine_name like '%PGet%' -- or routine_name like '%%' 
    AND ROUTINE_TYPE='PROCEDURE'
order by last_altered desc
