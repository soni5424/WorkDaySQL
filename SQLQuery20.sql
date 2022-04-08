use hartono
SELECT Routine_name, last_altered
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE     
        ROUTINE_DEFINITION LIKE '%%'
        AND ROUTINE_DEFINITION LIKE '%insert into%'
        AND ROUTINE_DEFINITION LIKE '%TrxFakturInsurance%'
        AND ROUTINE_DEFINITION LIKE '%%'
	    --and routine_name not like 'HLS_%'
	    --and routine_name not like 'HWS_%'
	    --AND routine_name like '%%' 
        -- or routine_name like '%%' 
        AND ROUTINE_TYPE='PROCEDURE'
    order by last_altered desc
