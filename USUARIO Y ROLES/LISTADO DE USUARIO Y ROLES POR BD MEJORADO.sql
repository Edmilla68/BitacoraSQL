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
SET @UJUARIO = 'yoquispe'

--Usuarios por BD
SELECT dbname, dbuser FROM #TMP_DBUSERS WHERE dbuser LIKE @UJUARIO 

--logins
select name, loginname , DBNAME from master..syslogins where name LIKE @UJUARIO 

-- cruce de ambos
SELECT 
us.dbname, 
dbuser,
LO.name AS LoginName,
ISNULL(CASE WHEN hasaccess		= 1 THEN 'SI'  WHEN hasaccess	 = 0 THEN 'NO'  END ,'NO') AS [public],
ISNULL(CASE WHEN bulkadmin		= 1 THEN 'SI'  WHEN bulkadmin	 = 0 THEN 'NO'  END ,'NO') AS [bulkadmin],
ISNULL(CASE WHEN dbcreator		= 1 THEN 'SI'  WHEN dbcreator	 = 0 THEN 'NO'  END ,'NO') AS [dbcreator],
ISNULL(CASE WHEN diskadmin		= 1 THEN 'SI'  WHEN diskadmin	 = 0 THEN 'NO'  END ,'NO') AS [diskadmin],
ISNULL(CASE WHEN processadmin	= 1 THEN 'SI'  WHEN processadmin = 0 THEN 'NO'  END ,'NO') AS [processadmin],
ISNULL(CASE WHEN setupadmin		= 1 THEN 'SI'  WHEN setupadmin	 = 0 THEN 'NO'  END ,'NO') AS [setupadmin],
ISNULL(CASE WHEN serveradmin	= 1 THEN 'SI'  WHEN serveradmin	 = 0 THEN 'NO'  END ,'NO') AS [serveradmin],
ISNULL(CASE WHEN sysadmin		= 1 THEN 'SI'  WHEN sysadmin	 = 0 THEN 'NO'  END ,'NO') AS [sysadmin]
FROM #TMP_DBUSERS us
LEFT JOIN master..syslogins lo
	ON us.sid = lo.sid
where lo.name LIKE @UJUARIO 
order by lo.name, us.dbname

