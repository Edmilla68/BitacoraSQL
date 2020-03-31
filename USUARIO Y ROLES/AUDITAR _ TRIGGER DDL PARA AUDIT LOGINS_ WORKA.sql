/*
IF EXISTS (SELECT * FROM sys.server_triggers
    WHERE name = 'ddl_trig_database')

DROP TRIGGER ddl_trig_database
ON ALL SERVER;
GO
*/
--select * from ddl_log
--drop TABLE ddl_log 
--create TABLE ddl_log (PostTime datetime, DB_User nvarchar(100), Event nvarchar(100), TSQL nvarchar(2000), ip varchar(18),LOG_NAME nvarchar(100),HST_NAME nvarchar(100) );
 
 
 
CREATE TRIGGER ddl_trig_logins
ON ALL SERVER 
FOR CREATE_LOGIN, ALTER_LOGIN, DROP_LOGIN
--, ALTER_ROLE, CREATE_USER, ALTER_USER, DROP_USER
AS 
DECLARE @data XML
SET @data = EVENTDATA()
DECLARE @ip   VARCHAR(18)

SELECT  @ip = client_net_address
FROM    sys.sysprocesses AS S
INNER JOIN    sys.dm_exec_connections AS decc ON S.spid = decc.session_id
WHERE   spid = @@SPID


INSERT ddl_log (PostTime, DB_User, Event, TSQL, ip, LOG_NAME, HST_NAME ) 
   VALUES 
   (GETDATE(), 
   CONVERT(nvarchar(100), CURRENT_USER), 
   @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
   @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)'),
   @ip,
   CONVERT(nvarchar(100), SYSTEM_USER), 
   CONVERT(nvarchar(100), HOST_NAME())
   ) ;
/*
    PRINT 'LOGIN EVENTO USADO....'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
*/

GO

/*
DROP TRIGGER ddl_trig_logins
ON ALL SERVER;
GO
*/

