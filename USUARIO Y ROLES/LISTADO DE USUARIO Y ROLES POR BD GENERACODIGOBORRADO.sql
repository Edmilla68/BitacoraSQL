-- *** LISTADO DE USUARIO Y ROLES POR C/BD   MEJORADO ***

IF OBJECT_ID (N'#TMP_DBUSERS', N'U') IS NULL 
drop table #TMP_DBUSERS;

CREATE TABLE #TMP_DBUSERS
(
   dbname varchar(256)
   ,dbuser varchar(256)
   ,SID varchar(256)
)

DECLARE curDBs CURSOR
READ_ONLY
FOR SELECT name FROM master..sysdatabases

DECLARE @name varchar(256)
OPEN curDBs

FETCH NEXT FROM curDBs INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
   IF (@@fetch_status <> -2)
   BEGIN
      DECLARE @SQLquery AS VARCHAR(2048)
      SELECT @SQLquery = 'INSERT INTO #TMP_DBUSERS '
      SELECT @SQLquery = @SQLquery + 'SELECT ''' + @name + ''', name, SID '
      SELECT @SQLquery = @SQLquery + 'FROM [' + @name + '].dbo.sysusers WHERE'
      --SELECT @SQLquery = @SQLquery + 'where sid NOT IN (SELECT sid FROM master.dbo.syslogins) '
      --SELECT @SQLquery = @SQLquery + 'AND islogin=1 '
      SELECT @SQLquery = @SQLquery + ' name not in (''INFORMATION_SCHEMA'', '
      SELECT @SQLquery = @SQLquery + '''sys'', ''guest'', ''dbo'', ''system_function_schema'')'
      SELECT @SQLquery = @SQLquery + ' AND islogin=1 '
      EXEC(@SQLquery)
   END
   FETCH NEXT FROM curDBs INTO @name
END
CLOSE curDBs
DEALLOCATE curDBs
GO

Declare @UJUARIO varchar(30);
Declare @COMANDO varchar(500);
SET @COMANDO = ''
SET @UJUARIO = 'PERU'

--Usuarios por BD
SELECT dbname, dbuser, 'USE ' + dbname +' DROP USER ['+ dbuser + '] ' FROM #TMP_DBUSERS WHERE dbuser LIKE @UJUARIO 
