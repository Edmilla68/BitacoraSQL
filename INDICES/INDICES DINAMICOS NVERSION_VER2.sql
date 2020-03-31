USE Master;

IF OBJECT_ID('tempdb..#TODO') IS NOT NULL
    DROP TABLE #TODO


CREATE TABLE #TODO
(
SERV	 VARCHAR(25) NULL,
NOMIDX	 VARCHAR(50) NULL,
NOMTABLA VARCHAR(50) NULL,
)


GO
 	DECLARE @CODIGO NVARCHAR(4000)
 
 	DECLARE curDBs CURSOR
	READ_ONLY
	FOR SELECT name, DBID FROM master..sysdatabases WHERE name not in ('master','tempdb','model','msdb')

	DECLARE @name varchar(256)
	DECLARE @DBID INTEGER
	OPEN curDBs

	FETCH NEXT FROM curDBs INTO @name, @DBID
	WHILE (@@fetch_status <> -1)
	BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN
	   set @CODIGO  =			'USE '+@name + CHAR(13)+
								'INSERT #TODO '	+ CHAR(13)+
								'SELECT '''+@name+''',  D.NAME, c.name ' + CHAR(13)+ 
								'FROM sys.dm_db_index_physical_stats ('+convert(varchar,@DBID)+', NULL, NULL, NULL, ''limited'')AS A ' + CHAR(13)+
								'LEFT JOIN SYS.DATABASES B ' + CHAR(13)+
								'ON A.DATABASE_iD = B.DATABASE_ID ' + CHAR(13)+
								'LEFT JOIN SYS.OBJECTS C ' + CHAR(13)+
								'ON A.OBJECT_iD = C.OBJECT_iD ' + CHAR(13)+
								'LEFT JOIN SYS.INDEXES D ' + CHAR(13)+
								'ON A.OBJECT_iD = D.OBJECT_iD AND A.index_id = D.index_id ' + CHAR(13)+
								'WHERE avg_fragmentation_in_percent > 20 ' + CHAR(13)+
								'and index_type_desc <> ''HEAP'' ' + CHAR(13)+
								'and index_level = 0 ' + CHAR(13)+
								'and page_count > 300' + CHAR(13)+
								'order by avg_fragmentation_in_percent desc '
	   
	   exec(@CODIGO)
	   END
	   FETCH NEXT FROM curDBs INTO @name, @DBID
	END
	CLOSE curDBs
	DEALLOCATE curDBs
GO

--SELECT * FROM #TODO
--SELECT 'USE '+SERV+'  ALTER INDEX  '+ NOMIDX +'  ON  ' + NOMTABLA +'  REORGANIZE'+CHAR(13) FROM #TODO


--*****************************************************

 	DECLARE @SCR_FIN NVARCHAR(4000)
 	
 	DECLARE curfin CURSOR
	READ_ONLY
	FOR SELECT serv, nomidx, nomtabla FROM #TODO


	DECLARE @serv varchar(256)
	DECLARE @nomidx varchar(256)
	DECLARE @nomtabla varchar(256)
	
	OPEN curfin

	FETCH NEXT FROM curfin INTO @serv, @nomidx, @nomtabla
	WHILE (@@fetch_status <> -1)
	BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN


		SET @SCR_FIN = 'USE '+@serv+'  ALTER INDEX  '+ @nomidx +'  ON  ' + @nomtabla +'  REORGANIZE'+CHAR(13) 
		PRINT (@SCR_FIN)
		
		END
	   FETCH NEXT FROM curfin INTO @serv, @nomidx, @nomtabla
	END
	CLOSE curfin
	DEALLOCATE curfin







select * from #TODO

--DROP TABLE #TODO