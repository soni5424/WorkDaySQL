use hartono
SELECT Routine_name, last_altered
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE     
        ROUTINE_DEFINITION LIKE '%rewardpoint = %'
        AND ROUTINE_DEFINITION LIKE '%%'
        AND ROUTINE_DEFINITION LIKE '%%'
	    --and routine_name like '%point%'
	    --AND routine_name like 'HLS_%' 
        -- or routine_name like '%%' 
        --AND ROUTINE_TYPE='PROCEDURE'
    order by last_altered desc
