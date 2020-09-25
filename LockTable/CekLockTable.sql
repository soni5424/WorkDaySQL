select distinct TableName, Client_Net_Address, WaitTime, Tanggal from Log_TableLock 
where waittime > 5000 -- 5 detik
	and dbo.getonlydate(tanggal) > dbo.getonlydate(getdate()-4)
	and (TableName = 'TrxFaktur' or TableName = 'TrxSO')
order by tanggal desc


select dbo.getonlydate(getdate()-4)

--Exec ceklock

SELECT distinct
	OBJECT_NAME(P.object_id) AS TableName,
	Resource_type,
	request_session_id
FROM
	sys.dm_tran_locks L
	join sys.partitions P ON L.resource_associated_entity_id = p.hobt_id
WHERE OBJECT_NAME(P.object_id) LIKE '%TrxFaktur%' OR OBJECT_NAME(P.object_id) LIKE '%TrxSO%'

--kill 133
