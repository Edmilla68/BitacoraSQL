USE Master;
GO
CREATE PROCEDURE Dinamical_index
WITH ENCRYPTION     
AS 
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
	--	PRINT  @NAME 
	--	PRINT  @DBID
			DECLARE @CODIGO NVARCHAR(4000)
			EXEC ('USE ' +@NAME)
			SET @CODIGO =''
			SELECT   @CODIGO = @CODIGO  + 'ALTER INDEX '+D.name +' ON '+c.name+' REORGANIZE;'+CHAR(13)  --+' GO ' +CHAR(13)
			FROM sys.dm_db_index_physical_stats (@DBID, NULL, NULL, NULL, 'limited')AS A
			LEFT JOIN SYS.DATABASES B
			ON A.DATABASE_iD = B.DATABASE_ID
			LEFT JOIN SYS.OBJECTS C
			ON A.OBJECT_iD = C.OBJECT_iD
			LEFT JOIN SYS.INDEXES D
			ON A.OBJECT_iD = D.OBJECT_iD AND A.index_id = D.index_id
			WHERE avg_fragmentation_in_percent > 20 -- buscando % de fragmentación en este caso > 20
			--and index_type_desc <> 'HEAP'
			and index_level = 0 --> analizando la rama principal de los índices
			and page_count > 50 --> mas de 1000 hojas
			order by avg_fragmentation_in_percent desc
			
			--PRINT  @NAME
			EXEC (@CODIGO)

	   END
	   FETCH NEXT FROM curDBs INTO @name, @DBID
	END
	CLOSE curDBs
	DEALLOCATE curDBs
GO




