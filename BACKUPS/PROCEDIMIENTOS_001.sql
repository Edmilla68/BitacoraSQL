
CREATE PROCEDURE dbo.GetCurrentSessionLocks
AS

SELECT 
	lck.resource_type,
	lck.request_mode,
	lck.request_session_id,
	lck.request_status,
	OBJECT_NAME(ps.object_id) as objectName
FROM sys.dm_tran_locks AS lck
INNER JOIN sys.dm_exec_connections AS conn
		ON conn.session_id = lck.request_session_id
INNER JOIN sys.partitions AS ps		
		ON ps.hobt_id = lck.resource_associated_entity_id
CROSS APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) AS t		
WHERE lck.request_session_id in (
									SELECT distinct session_id
									FROM sys.dm_exec_sessions
									WHERE login_name='sa'
									)
and lck.request_session_id = @@SPID
and resource_type not in ('Database','Object','PAGE')

GO


CREATE PROCEDURE dbo.GetSessionLocks
AS

SELECT 
	lck.resource_type,
	lck.request_mode,
	lck.request_session_id,
	lck.request_status,
	OBJECT_NAME(ps.object_id) as objectName,
	t.text as command
FROM sys.dm_tran_locks AS lck
INNER JOIN sys.dm_exec_connections AS conn
		ON conn.session_id = lck.request_session_id
INNER JOIN sys.partitions AS ps		
		ON ps.hobt_id = lck.resource_associated_entity_id
CROSS APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) AS t		
WHERE lck.request_session_id in (
									SELECT distinct session_id
									FROM sys.dm_exec_sessions
									WHERE login_name='sa'
									)
and lck.request_session_id = @@SPID
and resource_type not in ('Database','Object','PAGE')

GO





CREATE PROCEDURE dbo.GetBlockedProcesses
AS
--CHECK BLOQUED PROCESSES
SELECT
	conn.session_id as blockerSession,
	conn2.session_id as BlockedSession,
	req.wait_time as Waiting_Time_ms,
	cast((req.wait_time/1000.) as decimal(18,2)) as Waiting_Time_secs,
	cast((req.wait_time/1000./60.) as decimal(18,2)) as Waiting_Time_mins,
	t.text as BloquerQuery,
	t2.text as BloquedQuery
FROM sys.dm_exec_request as req
INNER JOIN sys.dm_exec_connections as conn
		ON req.blocking_session_id = conn.session_id
INNER JOIN sys.dm_exec_connections as conn2
		ON req.session_id = conn2.session_id
CROSS APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) as t
CROSS APPLY sys.dm_exec_sql_text(conn2.most_recent_sql_handle) as t2

GO





CREATE PROCEDURE dbo.GetCurrentIsolationLevel
AS

	SELECT
		CASE transaction_isolation_level
		WHEN 0 THEN 'Unspecified'
		WHEN 1 THEN 'ReadUncommitted'
		WHEN 2 THEN 'ReadCommited'
		WHEN 3 THEN 'Repeatable'
		WHEN 4 THEN 'Serializable'
		WHEN 5 THEN 'Snapshot'
		END AS TRANSACTION_ISOLATION_LEVEL
	FROM sys.dm_exec_sessions
	WHERE session_id = @@SPID
GO




CREATE PROCEDURE dbo.GetIsolationLevelBySession
@sessionID int = @@spid
AS

	SELECT
		CASE transaction_isolation_level
		WHEN 0 THEN 'Unspecified'
		WHEN 1 THEN 'ReadUncommitted'
		WHEN 2 THEN 'ReadCommited'
		WHEN 3 THEN 'Repeatable'
		WHEN 4 THEN 'Serializable'
		WHEN 5 THEN 'Snapshot'
		END AS TRANSACTION_ISOLATION_LEVEL
	FROM sys.dm_exec_sessions
	WHERE session_id = @sessionID
GO





-- MONITOR
exec dbo.GetSessionLocks














































