USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[Log_pInsertLogTableLockDetail]    Script Date: 09/21/2020 16:31:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |21/09/2020|
-- Description:	|Get TableLock Detail and insert to table|
-- =============================================
CREATE PROCEDURE [dbo].[Log_pInsertLogTableLockDetail]
AS
BEGIN
	set dateformat dmy
	
	INSERT INTO Log_TableLockDetail
	SELECT DTL.resource_type,  
	   CASE   
		   WHEN DTL.resource_type IN ('DATABASE', 'FILE', 'METADATA') THEN DTL.resource_type  
		   --WHEN DTL.resource_type = 'OBJECT' THEN OBJECT_NAME(DTL.resource_associated_entity_id, SP.[dbid])  
		   WHEN DTL.resource_type IN ('KEY', 'PAGE', 'RID') THEN   
			   (  
			   SELECT OBJECT_NAME([object_id])  
			   FROM sys.partitions  
			   WHERE sys.partitions.hobt_id =   
				 DTL.resource_associated_entity_id  
			   )  
		   ELSE 'Unidentified'  
	   END AS requested_object_name, DTL.request_mode, DTL.request_status,  
	   DEST.TEXT, SP.spid, SP.blocked, SP.status, SP.loginame, GETDATE() as 'created_at'
	FROM sys.dm_tran_locks DTL  
	   INNER JOIN sys.sysprocesses SP  
		   ON DTL.request_session_id = SP.spid   
	   --INNER JOIN sys.[dm_exec_requests] AS SDER ON SP.[spid] = [SDER].[session_id] 
	   CROSS APPLY sys.dm_exec_sql_text(SP.sql_handle) AS DEST  
	WHERE SP.dbid = DB_ID()  
	   AND DTL.[resource_type] <> 'DATABASE' 
	   AND (status = 'sleeping' OR status = 'suspended')
	ORDER BY DTL.[request_session_id];

END
GO

