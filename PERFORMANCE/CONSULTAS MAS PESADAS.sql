/*
El código de las 10 consultas con mayor tiempo de consumo de la CPU. 

Los datos se obtienen de la vista sys.dm_exec_query_stats que devuelve estadísticas de rendimiento del agregado para planes de ejecución 
de consultas en caché. La vista contiene una fila por cada plan de ejecución de cada consulta y la duración de la fila está vinculada al plan en sí. 
Cuando se quita un plan de ejecución de la caché, se elimina la fila correspondiente de esta vista.
Recordar que sólo se reutilizan los planes de ejecución en los procedimientos almacenados y las consultas paremetrizadas. 
Las consultas personalizadas (consultas ad-hoc, ejemplo: SELECT nombre, apellidos FROM Alumnos WHERE curso=1) 
se cosideran totalmente diferentes a la hora de asignarles un plan de ejecución si cualquier letrita del mismo cambia 
(los valores de las condiciones del WHERE mismamente Ej: WHERE curso=1 y WHERE curso=2 serian interpretadas como dos consultas totamente diferentes, 
aunque solo se diferencian en un caracter)
*/

USE MASTER
GO
SELECT TOP 10 qs.max_worker_time, qs.execution_count,qs.plan_generation_num, DB_NAME(st.DBID) AS 'DatabaseName', st.ObjectID, SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_worker_time DESC;
GO 

/*
max_worker_time: Tiempo máximo de CPU, en microsegundos, que ha utilizado este plan durante una ejecución.
execution_count: Número de veces que se ha ejecutado el plan desde que se compiló por última vez.
plan_generation_num: Número de veces que este plan se ha vuelto a compilar mientras permanecía en la caché.
Si execution_count y plan_generation_num son igual a 1, podria ser que el sistema no este cacheando este "tipo" de consultas,
o bien que cada vez que se lanza, ha caducado el plan de ejecución por superar el tiempo de vida del plan de ejecución.
Mas información de la tabla en sys.dm_exec_query_stats
http://docentes.uacj.mx/jpaz/W_SQL/tsqlref9_web/html/eb7b58b8-3508-4114-97c2-d877bcb12964.htm
*/


/*
El código de las 10 consultas con mayor tiempo transcurrido para su ejecución.
*/ 

USE MASTER
GO
SELECT TOP 10 qs.max_elapsed_time, DB_NAME(st.DBID) AS 'DataBaseName',
st.ObjectID, SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_elapsed_time DESC;
GO

/*
max_elapsed_time: Tiempo máximo transcurrido, en microsegundos, hasta finalizar cualquier ejecución de este plan.
Mas información de la tabla en sys.dm_exec_query_stats http://docentes.uacj.mx/jpaz/W_SQL/tsqlref9_web/html/eb7b58b8-3508-4114-97c2-d877bcb12964.htm
*/


/*
El código de las 10 consultas con mayor numero de escrituras lógicas.
*/

USE MASTER
GO
SELECT TOP 10 qs.max_logical_writes, DB_NAME(st.DBID) AS 'DatabaseName',
st.ObjectID, SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_logical_writes DESC;
GO

/*
El código de las 10 consultas con mayor número de lecturas físicas.
*/

USE MASTER
GO
SELECT TOP 10 qs.max_physical_reads, DB_NAME(st.DBID) AS 'DatabaseName',
st.ObjectID, SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_physical_reads DESC;
GO