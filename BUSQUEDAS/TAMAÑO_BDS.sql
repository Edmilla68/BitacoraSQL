
SELECT SUM(sizeMB)sizeMB, SUM(sizeGB)sizeGB FROM(
	select d.database_id,d.name, a.name as filename,a.physical_name as ubication,
	 a.type_desc,(a.size/128)as sizeMB, (a.size/128) * 0.000976563 as sizeGB, recovery_model_desc,d.state_desc,compatibility_level
	from sys.master_files a inner join sys.databases d on (a.database_id = d.database_id)
)ZZ




select d.database_id,d.name, a.name as filename,a.physical_name as ubication,
 a.type_desc,(a.size/128)as sizeMB, recovery_model_desc,d.state_desc,compatibility_level
from sys.master_files a inner join sys.databases d on (a.database_id = d.database_id)
order by d.database_id
--order by a.type,a.size