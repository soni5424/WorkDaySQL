SELECT j.name 
  FROM msdb.dbo.sysjobs AS j
  WHERE EXISTS 
  (
    SELECT 1 FROM msdb.dbo.sysjobsteps AS s
      WHERE s.job_id = j.job_id
      AND s.command LIKE '%PromoTier_AutoBatalClaimPromo%'
  );

  --use hartono
  --EXEC dbo.sp_help_jobhistory @job_name = N'SC_PUpdateRating'

  --SELECT J.[name] 
  --     ,[step_name]
  --    ,[message]
  --    ,[run_status]
  --    ,[run_date]
  --    ,[run_time]
  --    ,[run_duration]
  --FROM [msdb].[dbo].[sysjobhistory] JH
  --JOIN [msdb].[dbo].[sysjobs] J
  --ON JH.job_id= J.job_id
  --WHERE J.name='SC_PUpdateRating'