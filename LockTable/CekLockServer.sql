    select  object_name(resource_associated_entity_id) as 'TableName', a.Request_Lifetime, a.Request_Session_Id, b.Client_Net_Address, c.WaitTime, getdate() as 'Tanggal'
	 from   sys.dm_tran_locks a,  sys.dm_exec_connections b, sys.sysprocesses c
	where a.request_session_id = b.session_id
	AND a.request_session_id = c.spid
	and resource_type = 'OBJECT'  and resource_database_id = DB_ID()
	and request_lifetime > 0
	--and Client_Net_Address='192.168.9.29'
	--and object_name(resource_associated_entity_id) = 'h_SAP_PromoPOStoMyHartono'
		order by request_session_id asc

