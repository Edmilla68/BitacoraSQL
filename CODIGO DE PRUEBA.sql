--**********************************************************************************************************************************************
--******    CODIGO DE PRUEBA        ************************************************************************************************************
--**********************************************************************************************************************************************
--**********************************************************************************************************************************************
--

DECLARE @PARTE0 NVARCHAR(MAX)
DECLARE @PARTE1 table (Parte1 text)
DECLARE @PARTE2 NVARCHAR(MAX)
DECLARE @PARTEX NVARCHAR(MAX)

SET @PARTE0 = ' DECLARE @tab_script TABLE (  C_SCRIPT NVARCHAR(4000)  )' + CHAR(13) 
print (@PARTE0 )
--PRINT ('DECLARE @tab_script TABLE (  C_SCRIPT NVARCHAR(4000)  )' + CHAR(13) )

SET @PARTEX = ''

DECLARE @tab_script TABLE
(
  C_SERVER NVARCHAR(400),
  C_SCRIPT NVARCHAR(4000)
  )


DECLARE curDBs CURSOR
	READ_ONLY
	FOR SELECT name, DBID FROM master..sysdatabases WHERE name not in ('master','tempdb','model','msdb')

	DECLARE @name varchar(256)
	DECLARE @DBID smallint
	OPEN curDBs

	FETCH NEXT FROM curDBs INTO @name, @DBID
	WHILE (@@fetch_status <> -1)
	BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN
		--PRINT  @NAME 
		--PRINT  @DBID 
			
			
	SET @PARTEX =			' USE ' + @name + CHAR(13) +
							'INSERT INTO @tab_script (C_SCRIPT)' + CHAR(13) +
						   'SELECT '+'''USE ' +@name + ' '' +'+
						   ' 	''ALTER INDEX ''+D.name +'' ON ''+c.name+'' REORGANIZE;''  ' + CHAR(13) +		
						   'FROM sys.dm_db_index_physical_stats ('+CONVERT(NVARCHAR,@DBID)+', NULL, NULL, NULL, ''limited'')AS A
							LEFT JOIN SYS.DATABASES B
								ON A.DATABASE_iD = B.DATABASE_ID
							LEFT JOIN SYS.OBJECTS C
								ON A.OBJECT_iD = C.OBJECT_iD
							LEFT JOIN SYS.INDEXES D
								ON A.OBJECT_iD = D.OBJECT_iD AND A.index_id = D.index_id
							WHERE avg_fragmentation_in_percent > 20 
							and index_type_desc <> ''HEAP''
							and index_level = 0 
							and page_count > 500
							order by avg_fragmentation_in_percent desc' + CHAR(13) 
							
									
	
print (@PARTEX)			
/*			
			INSERT INTO @PARTE1 (Parte1)
			VALUES (@PARTEX)
*/
			
	   END
	   FETCH NEXT FROM curDBs INTO @name, @DBID
	END
	
	
	CLOSE curDBs
	DEALLOCATE curDBs
	--PRINT (@PARTEX)
	
SET @PARTE2 = 'SELECT * FROM @tab_script' + CHAR(13) 
print (@PARTE2  )
--select Parte1  from @PARTE1

 