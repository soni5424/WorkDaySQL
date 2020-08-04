DECLARE @filename VARCHAR(255) 
SELECT @FileName = SUBSTRING(path, 0, LEN(path)-CHARINDEX('\', REVERSE(path))+1) + '\Log.trc'  
FROM sys.traces   
WHERE is_default = 1;  

SELECT 
	gt.ObjectName, 
	gt.HostName, 
    gt.StartTime, 
    gt.LoginName, 
    gt.DatabaseName,
    gt.ApplicationName, 
    gt.NTUserName, 
    gt.NTDomainName, 
    gt.SPID, 
    gt.EventClass, 
    te.Name AS EventName,
    gt.EventSubClass
FROM [fn_trace_gettable](@filename, DEFAULT) gt 
JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id 
WHERE EventClass in (164) --AND gt.EventSubClass = 2
	--and dbo.getonlydate(starttime)=dbo.getonlydate(getdate())
	and objectname is not null
	and objectname like 'MM_%'
	--and gt.HostName = 'SYSTEM-08236'
ORDER BY StartTime DESC;