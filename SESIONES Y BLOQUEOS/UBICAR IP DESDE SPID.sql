
DECLARE @session_id numeric(10,2)
DECLARE @ipPC VARCHAR(50)
DECLARE @nomPC VARCHAR(50)
 
set @session_id = 184

SET @nomPC =	(select hostname
				from master..sysprocesses
				where spid = @session_id)

 
SET @ipPC = (SELECT client_net_address
FROM sys.dm_exec_connections
WHERE session_id = @session_id)
 

SELECT @ipPC AS IPPC, @nomPC AS NOMPC