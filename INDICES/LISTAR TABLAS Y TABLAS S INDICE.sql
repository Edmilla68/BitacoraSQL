-- LISTAR CANT TABLAS 

SELECT * FROM sys.objects
WHERE TYPE = 'U'          --'F' para FK

-- listar tablas sin indice cluster
select TABS.name 
from sys.tables as TABS 
left outer join sys.indexes AS IDX on (TABS.object_id = IDX.object_id) AND (IDX.type_desc = 'CLUSTERED') 
WHERE IDX.object_id IS NULL 

SELECT OBJECT_NAME(OBJECT_ID) as TableName
FROM SYS.INDEXES
WHERE INDEX_ID = 0
AND OBJECTPROPERTY(OBJECT_ID,'IsUserTable') = 1
ORDER BY TableName