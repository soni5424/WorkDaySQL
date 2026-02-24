SELECT Routine_name, routine_definition, created, last_altered 
  FROM INFORMATION_SCHEMA.ROUTINES
 WHERE ROUTINE_TYPE = 'PROCEDURE' 
   AND LEFT(ROUTINE_NAME, 3) NOT IN ('sp_', 'xp_', 'ms_')
   and routine_definition like '%SAP_VENDOR%'
order by last_altered desc