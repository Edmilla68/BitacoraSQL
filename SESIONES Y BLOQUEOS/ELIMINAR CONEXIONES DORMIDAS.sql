-- ****************************************************************
-- ******* OJO FALTA PROBAR      **********************************
-- ****************************************************************



USE MASTER
GO
DECLARE @spid SMALLINT
DECLARE @KILL VARCHAR(16)
DECLARE kill_cursor CURSOR FOR
select spid
from master..sysprocesses
where status = 'sleeping'
AND dbid=57
OPEN kill_cursor
FETCH NEXT FROM kill_cursor INTO @spid
WHILE @@FETCH_STATUS = 0
      BEGIN
      SET @KILL= 'kill '+cast(@spid as varchar(5))
      print (@KILL)
FETCH NEXT FROM kill_cursor INTO @spid
END