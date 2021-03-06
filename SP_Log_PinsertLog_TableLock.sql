USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[Log_PinsertLog_TableLock]    Script Date: 09/21/2020 16:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[Log_PinsertLog_TableLock]
as
Begin	
declare @Request_Session_Id int

if exists(
select a.Request_Session_Id
from   sys.dm_tran_locks a,  sys.dm_exec_connections b, sys.sysprocesses c
where a.request_session_id = b.session_id
and a.request_session_id = c.spid
and resource_type = 'OBJECT'  
and resource_database_id = DB_ID()
and request_lifetime >0
--and waittime >= 120000
and waittime >= (select isnull((select nilai from masterparameter where nama = 'WaitTimeLockTable'), 120000))
)
Begin
	select top 1 @Request_Session_Id = a.Request_Session_Id
	from   sys.dm_tran_locks a,  sys.dm_exec_connections b, sys.sysprocesses c
	where a.request_session_id = b.session_id
	and a.request_session_id = c.spid
	and resource_type = 'OBJECT'  
	and resource_database_id = DB_ID()
	and request_lifetime >0
	--and waittime >= 120000
	and waittime >= (select isnull((select nilai from masterparameter where nama = 'WaitTimeLockTable'), 120000))
	order by c.waittime desc

	insert into Log_TableLock
	select  object_name(resource_associated_entity_id) as 'TableName', a.Request_Lifetime, a.Request_Session_Id, b.Client_Net_Address, c.WaitTime, getdate() as 'Tanggal'
	 from   sys.dm_tran_locks a,  sys.dm_exec_connections b, sys.sysprocesses c
	where a.request_session_id = b.session_id
	AND a.request_session_id = c.spid
	and resource_type = 'OBJECT'  and resource_database_id = DB_ID()
	and request_lifetime > 0
	and a.Request_Session_Id = @Request_Session_Id
	
	exec('Log_pInsertLogTableLockDetail')

	--exec('kill ' + @Request_Session_Id)

End




End