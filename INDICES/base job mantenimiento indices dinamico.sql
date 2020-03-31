DECLARE @CODIGO NVARCHAR(4000)
USE Neptunia_SGC_PRODUCCION
SET @CODIGO =''
SELECT   @CODIGO = @CODIGO  + 'ALTER INDEX '+D.name +' ON '+c.name+' REORGANIZE;'+CHAR(13)  --+' GO ' +CHAR(13)
/*
b.name as 'database',
c.name as 'tabla',
D.name as 'indice',
index_type_desc,
avg_fragmentation_in_percent,
page_count
*/
FROM sys.dm_db_index_physical_stats (10, NULL, NULL, NULL, 'limited')AS A
LEFT JOIN SYS.DATABASES B
ON A.DATABASE_iD = B.DATABASE_ID
LEFT JOIN SYS.OBJECTS C
ON A.OBJECT_iD = C.OBJECT_iD
LEFT JOIN SYS.INDEXES D
ON A.OBJECT_iD = D.OBJECT_iD AND A.index_id = D.index_id
WHERE avg_fragmentation_in_percent > 20 -- buscando % de fragmentación en este caso > 20
and index_type_desc <> 'HEAP'
and index_level = 0 --> analizando la rama principal de los índices
and page_count > 1000 --> mas de 1000 hojas
order by avg_fragmentation_in_percent desc

EXEC (@CODIGO)

/*
--******************
USE Neptunia_SGC_Produccion; 
GO
*/

