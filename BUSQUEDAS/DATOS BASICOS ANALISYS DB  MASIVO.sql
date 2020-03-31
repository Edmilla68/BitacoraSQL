-- EXTRER DATOS BASICOS DE DBA ...
USE master
GO
IF OBJECT_ID('tempdb..#TMP_DBUSERS') IS NOT NULL
   DROP TABLE #TMP_DBUSERS

CREATE TABLE #TMP_DBUSERS
	(
   dbname varchar(256),
   TIPO varchar(5),
   VALOR decimal(10,2)
	)

DECLARE curDBs CURSOR
READ_ONLY
FOR SELECT name FROM master..sysdatabases
    where name <> 'master' and name <> 'model' and name <> 'tempdb' and name <> 'msdb' 

DECLARE @name varchar(256)
OPEN curDBs

FETCH NEXT FROM curDBs INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
   IF (@@fetch_status <> -2)
   BEGIN
      --print @name
      DECLARE @SQLquery AS VARCHAR(2048)
       SELECT @SQLquery = 'USE  ' + @name + ' '
       SELECT @SQLquery = @SQLquery + 'INSERT INTO #TMP_DBUSERS '
     --SELECT @SQLquery = @SQLquery + 'SELECT TYPE, count(*) FROM sysobjects group by TYPE having TYPE in ('''+'K'','+   '''TR'','+'''P'','+'''F'','+'''V'''+')'       
       SELECT @SQLquery = @SQLquery + 'SELECT ''' +@name + ''', ' +' TYPE, count(*) FROM sysobjects group by TYPE having TYPE in ('''+'K'','+   '''TR'','+'''P'','+'''F'','+'''V'''+')'
	 --  PRINT @SQLquery 
       EXEC(@SQLquery)
   END
   FETCH NEXT FROM curDBs INTO @name
END

CLOSE curDBs
DEALLOCATE curDBs
GO

select * from #TMP_DBUSERS

