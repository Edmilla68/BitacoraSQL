USE master 
GO 
DECLARE @kill varchar(max) = ''; 
SELECT @kill = @kill + 'KILL ' + CONVERT(varchar(10), spid) + '; ' 
FROM master..sysprocesses WHERE spid > 50 AND dbid = DB_ID('max76test') 
EXEC(@kill); 
GO 

SET DEADLOCK_PRIORITY HIGH ALTER DATABASE [max76test] 
SET MULTI_USER WITH NO_WAIT ALTER DATABASE [max76test] 
SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO 