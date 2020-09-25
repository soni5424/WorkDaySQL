use hartono
SELECT Routine_name, last_altered
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE     
        ROUTINE_DEFINITION LIKE '%convert%'
        AND ROUTINE_DEFINITION LIKE '%tanggal%'
        AND ROUTINE_DEFINITION LIKE '%%'
	    and routine_name not like 'sp_%'
	    AND routine_name like 'HLS_%' -- or routine_name like '%%' 
        AND ROUTINE_TYPE='PROCEDURE'
    order by last_altered desc
