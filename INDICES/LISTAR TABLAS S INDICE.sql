SELECT * FROM sys.objects 
WHERE TYPE = 'U'          --'F' para FK

select TABS.name 
from sys.tables as TABS 
left outer join sys.indexes AS IDX on (TABS.object_id = IDX.object_id) AND (IDX.type_desc = 'CLUSTERED') 
WHERE IDX.object_id IS NULL

DTS_OFILOGI_04.dtsx