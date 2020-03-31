
IF OBJECT_ID('tempdb..#TMP_ANALISIS') IS NOT NULL
   DROP TABLE #TMP_ANALISIS

CREATE TABLE #TMP_ANALISIS
	(
   nomserver varchar(256),
   dbname varchar(256),
   TIPO varchar(5),
   VALOR decimal(10,2)
	)


DECLARE @CODIGO    VARCHAR(2048)
--DECLARE @CODIGOTOT VARCHAR(1000)

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

    SELECT @CODIGO  = 'USE ['+@name+']    Insert into #TMP_ANALISIS ' 
    SELECT @CODIGO  = @CODIGO  + '  Select @@SERVERNAME, '''+ @name + ''', type, COUNT(type) from (SELECT distinct a.name, A.type	FROM sysobjects a INNER JOIN syscomments b on a.id = b.id WHERE b.[text] LIKE'+ '''%CALW3BDSGC%'''+')tb001 group by tb001.type'
    print @CODIGO
    exec (@CODIGO)
   END
   FETCH NEXT FROM curDBs INTO @name
END



CLOSE curDBs
DEALLOCATE curDBs


select * from #TMP_ANALISIS


--PRINT  @CODIGOTOT
/*
SET @CODIGO = SUBSTRING ( @CODIGO , 1 , LEN(@CODIGO) - 5 )

PRINT @CODIGO
*/

