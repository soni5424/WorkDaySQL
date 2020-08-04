--Exec ceklock

SELECT distinct
OBJECT_NAME(P.object_id) AS TableName,
Resource_type,
request_session_id
FROM
sys.dm_tran_locks L
join sys.partitions P
ON L.resource_associated_entity_id = p.hobt_id

--kill 133
