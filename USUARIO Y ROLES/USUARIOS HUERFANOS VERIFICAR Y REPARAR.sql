-- *** Identificar Usuarios Huérfanos, dejándolos en tabla temporal ***

CREATE TABLE #TMP_DBUSERS
(
   dbname varchar(256)
   ,dbuser varchar(256)
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
      SELECT @SQLquery = @SQLquery + 'SELECT ''' + @name + ''', name '
      SELECT @SQLquery = @SQLquery + 'FROM [' + @name + '].dbo.sysusers '
      SELECT @SQLquery = @SQLquery + 'where sid NOT IN (SELECT sid FROM master.dbo.syslogins) '
      SELECT @SQLquery = @SQLquery + 'AND islogin=1 '
      SELECT @SQLquery = @SQLquery + 'AND name not in (''INFORMATION_SCHEMA'', '
      SELECT @SQLquery = @SQLquery + '''sys'', ''guest'', ''dbo'', ''system_function_schema'')'

      EXEC(@SQLquery)
   END
   FETCH NEXT FROM curDBs INTO @name
END

CLOSE curDBs
DEALLOCATE curDBs
GO


-- *** Comprobar Usuarios Huérfanos 
-- *** para los que existe un Login con el mismo nombre. 
SELECT * FROM #TMP_DBUSERS
where dbuser in (select name from master..syslogins)

-- *** Comprobar Usuarios Huérfanos
-- *** para los que NO existe un Login con el mismo nombre.
-- *** PD: ostias, pedrín !!!
SELECT * FROM #TMP_DBUSERS
where dbuser not in (select name from master..syslogins)

-- *** Generar sentencias sp_change_users_login
-- *** para corregir los Usuarios Huérfanos con Inicio de Sesión conocido
-- *** PD: La salida de este Script, debe ejecutarse como otra Query
-- *** Revisar antes.
SELECT 'USE [' + dbname + ']; ' + CHAR(13) 
      + 'EXEC sp_change_users_login ''Update_One'', ''' + dbuser + ''', ''' + dbuser + ''';' 
FROM #TMP_DBUSERS
WHERE dbuser IN (select name from master..syslogins)