    select  object_name(resource_associated_entity_id) as 'TableName', a.Request_Lifetime, a.Request_Session_Id, b.Client_Net_Address, c.WaitTime, getdate() as 'Tanggal'
	 from   sys.dm_tran_locks a,  sys.dm_exec_connections b, sys.sysprocesses c
	where a.request_session_id = b.session_id
	AND a.request_session_id = c.spid
	and resource_type = 'OBJECT'  and resource_database_id = DB_ID()
	and request_lifetime > 0
