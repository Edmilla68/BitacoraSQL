--************************************************************************************************************
--EN MINUTOS
--************************************************************************************************************

SELECT * from
(
SELECT 
--d.object_id, 
--d.database_id, 
ISNULL(DB.name,'SYSTEM_SP') as Nombre_BD,
OBJECT_NAME(object_id, d.database_id) 'Nombre_Proceso',   
d.cached_time 'EnMemCache', 
d.last_execution_time as 'UltimaEjecucion', 

(d.total_elapsed_time / 1000000)/60							AS Total_tiempo_duracion,  
((d.total_elapsed_time/d.execution_count) / 1000000)/60		AS Promedio_duracion,  
(d.last_elapsed_time / 1000000)/60							AS Ultima_duracion,

d.execution_count  as nro_ejecuciones
FROM sys.dm_exec_procedure_stats AS d  
LEFT JOIN sys.databases DB
	ON DB.database_id = d.database_id
--ORDER BY [total_worker_time] DESC;  
) vw1
--where Nombre_Proceso ='Update_TServidor'
order by ultima_duracion desc


--************************************************************************************************************
--EN SEGUNDOS
--************************************************************************************************************
SELECT * from
(
SELECT 
--d.object_id, 
--d.database_id, 
ISNULL(DB.name,'SYSTEM_SP') as Nombre_BD,
OBJECT_NAME(object_id, d.database_id) 'Nombre_Proceso',   
d.cached_time 'EnMemCache', 
d.last_execution_time as 'UltimaEjecucion', 

(d.total_elapsed_time / 1000000)/60							AS Total_tiempo_duracion,  
((d.total_elapsed_time/d.execution_count) / 1000000)/60		AS Promedio_duracion,  
(d.last_elapsed_time / 1000000)/60							AS Ultima_duracion,

d.execution_count  as nro_ejecuciones
FROM sys.dm_exec_procedure_stats AS d  
LEFT JOIN sys.databases DB
	ON DB.database_id = d.database_id
--ORDER BY [total_worker_time] DESC;  
) vw1
--where Nombre_Proceso ='Update_TServidor'
order by ultima_duracion desc

