--genera bloqueos solo en ambiente alterno
--verifica fragmentación de indices 
SELECT
b.name as 'database',
c.name as 'name',
index_type_desc,
avg_fragmentation_in_percent,
page_count
FROM sys.dm_db_index_physical_stats (9, NULL, NULL, NULL, 'limited')AS A
LEFT JOIN SYS.DATABASES B
ON A.DATABASE_iD = B.DATABASE_ID
LEFT JOIN SYS.OBJECTS C
ON A.OBJECT_iD = C.OBJECT_iD
WHERE avg_fragmentation_in_percent > 20 -- buscando % de fragmentación en este caso > 20
and index_level = 0 --> analizando la rama principal de los índices
and page_count > 1000 --> mas de 1000 hojas

order by name



--REBUILD : Cuando porcentaje de fragmentación es mayor  40% 
		--	ALTER INDEX ALL ON [tabla]
		
--REORGANIZE : Cuando porcentaje de fragmentación está entre 10% y 40%
		--	ALTER INDEX ALL ON [tabla]
		
-----------------------------------------------------------------------------------------------------
--Obtener tabla con mayor número de filas
-----------------------------------------------------------------------------------------------------

SELECT Top 10 OBJECT_SCHEMA_NAME(sysobjects.id), sysobjects.[name], max(sysindexes.[rows]) AS TableRows, 
  CAST( 
    CASE max(sysindexes.[rows]) 
      WHEN 0 THEN -0 
      ELSE LOG10(max(sysindexes.[rows])) 
    END 
    AS NUMERIC(5,2)) 
  AS L10_TableRows 
FROM sysindexes INNER JOIN sysobjects ON sysindexes.[id] = sysobjects.[id] 
WHERE sysobjects.xtype = 'U' 
GROUP BY OBJECT_SCHEMA_NAME(sysobjects.id),sysobjects.[name] 
ORDER BY max(rows) DESC



-----------------------------------------------------------------------------------------------------
--Obtener porcentaje de desfragmentación del indice (Ver valor "Scan Density [Best Count:Actual Count]". 
--Debe ser mayor a 75% y acercarse al 100%)
-----------------------------------------------------------------------------------------------------
DECLARE @ID int
DECLARE @IndexID int
DECLARE @IndexName varchar(128) 

SELECT @IndexName = 'ORD_174_UNIQUE'--Nombre del índice
SET @ID = OBJECT_ID('wmwhse10.ORDERSTATUSHISTORY')--Nombre de la tabla 

SELECT @IndexID = IndID 
FROM sysindexes 
WHERE id = @ID AND name = @IndexName 

--Mostrar la fragmentación
DBCC SHOWCONTIG (@id, @IndexID)

--DBCC SHOW_STATISTICS('wmwhse10.ORDERSTATUSHISTORY','ORD_174_UNIQUE')
/*
IX_vch_CodigoEnvio			35.78% [268:749]
IX_vch_CodigoInterfaz		26.26% [366:1394]
IX_vch_CodigoReceptor		38.87% [274:705]
IX_vch_NumDocumento			12.90% [904:7010]
IX_vch_Tipo					32.65% [351:1075]
XPKTGEN_TB_MATRIZ_INTERFACE	79.38% [20881:26305]
*/

SELECT object_id, index_id, avg_fragmentation_in_percent, page_count 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL);

SELECT object_id, index_id, avg_fragmentation_in_percent, page_count 
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('wmwhse10.ORDERSTATUSHISTORY'), NULL, NULL, NULL);
--sp_help 'wmwhse10.ORDERSTATUSHISTORY'


SELECT 
	ddips.object_id,
	ddips.index_id,
	avg_fragmentation_in_percent,
	page_count,
	DB_NAME([ddips].[database_id]) AS [DatabaseName],
	OBJECT_NAME([ddips].[object_id]) AS [TableName],
	[i].[name] AS [IndexName] 
FROM 
	[sys].[dm_db_index_physical_stats](DB_ID(), OBJECT_ID('wmwhse10.ORDERSTATUSHISTORY'), NULL, NULL, NULL) AS ddips INNER JOIN 
	[sys].[indexes] AS i ON [ddips].[index_id] = [i].[index_id] AND [ddips].[object_id] = [i].[object_id]


/*

Reference Values (in %)							Action						SQL statement
=================================================================================================================
avg_fragmentation_in_percent > 5 AND < 30		Reorganize Index			ALTER INDEX REORGANIZE
avg_fragmentation_in_percent > 30				Rebuild Index				ALTER INDEX REBUILD

*/

-----------------------------------------------------------------------------------------------------
--Hacer un rebuild todos los indices de una tabla
-----------------------------------------------------------------------------------------------------

ALTER INDEX ALL ON  WMPRD.WMWHSE10.ORDERSTATUSHISTORY REBUILD;

ALTER INDEX IDX_ORDERSTATUSHISTORY ON wmwhse10.ORDERSTATUSHISTORY REBUILD;
ALTER INDEX IDX_ORDERSTATUSHISTORY ON wmwhse10.ORDERSTATUSHISTORY REORGANIZE;


-----------------------------------------------------------------------------------------------------
--Actualizar estadísticas de una tabla
-----------------------------------------------------------------------------------------------------

UPDATE STATISTICS WMPRD.WMWHSE1.ORDERSTATUSHISTORY WITH FULLSCAN;

--sp_updatestats --ACtualizar todas las estadísticas

-----------------------------------------------------------------------------------------------------
--Listado de procedimientos almacenados que utilizan una tabla
-----------------------------------------------------------------------------------------------------

DECLARE @tabla VARCHAR(255)
SET @tabla ='fact'
SET @tabla = LTRIM(RTRIM(@tabla))
SELECT DISTINCT
	OBJECT_SCHEMA_NAME(sqlobject.object_id) AS [schema],
	sqlobject.type_desc,
    sqlobject.name AS [Object_Name]
FROM sys.sql_modules modules
    INNER JOIN sys.objects sqlobject ON modules.object_id=sqlobject.object_id
WHERE modules.[definition] Like '%SELECT *%'
ORDER BY sqlobject.type_desc,[Object_Name]


-----------------------------------------------------------------------------------------------------
--Limpieza de buffers y cache del servidor
-----------------------------------------------------------------------------------------------------

DBCC DROPCLEANBUFFERS

DBCC FREEPROCCACHE

-----------------------------------------------------------------------------------------------------
--Actualizar una vista
-----------------------------------------------------------------------------------------------------

sp_refreshview 'wmwhse10.WMSCUS_DatosGuia'

-----------------------------------------------------------------------------------------------------
--Verificar si existen transacciones abiertas
-----------------------------------------------------------------------------------------------------

DBCC OPENTRAN 

-----------------------------------------------------------------------------------------------------
--Obtener el tipo de recuperación
-----------------------------------------------------------------------------------------------------

SELECT DATABASEPROPERTYEX('WMPRD', 'RECOVERY')

----Revisar indices en vistas:
--sp_help 'wmwhse10.WMSCUS_DatosGuia'

-----------------------------------------------------------------------------------------------------
--Consulta de indices automaticos que se superponen con otros
-----------------------------------------------------------------------------------------------------

WITH autostats(object_id, stats_id, name, column_id)
AS 
 ( 
	SELECT
		sys.stats.object_id, 
		sys.stats.stats_id,
		sys.stats.name,
		sys.stats_columns.column_id
	FROM
		sys.stats INNER JOIN 
		sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id AND sys.stats.stats_id = sys.stats_columns.stats_id 
	WHERE    
		sys.stats.auto_created = 1 AND 
		sys.stats_columns.stats_column_id = 1 
)
 
SELECT  
	OBJECT_NAME(sys.stats.object_id) AS [Table], 
	sys.columns.name AS [Column],
	sys.stats.name AS [Overlapped],
	autostats.name AS [Overlapping], 
	'DROP STATISTICS [' + OBJECT_SCHEMA_NAME(sys.stats.object_id) + '].[' + OBJECT_NAME(sys.stats.object_id) + '].['+ autostats.name + ']' 
FROM    
	sys.stats INNER JOIN 
	sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id AND sys.stats.stats_id = sys.stats_columns.stats_id INNER JOIN 
	autostats ON sys.stats_columns.object_id = autostats.object_id AND sys.stats_columns.column_id = autostats.column_id INNER JOIN 
	sys.columns ON sys.stats.object_id = sys.columns.object_id AND sys.stats_columns.column_id = sys.columns.column_id 
WHERE   
	sys.stats.auto_created = 0 
	AND sys.stats_columns.stats_column_id = 1 
	AND sys.stats_columns.stats_id != autostats.stats_id 
	AND OBJECTPROPERTY(sys.stats.object_id, 'IsMsShipped') = 0
	--AND OBJECT_NAME(sys.stats.object_id) IN ('storer')
ORDER BY [Table]


-----------------------------------------------------------------------------------------------------
-- Rebuild a todos los indices de una BBDD
-----------------------------------------------------------------------------------------------------

DECLARE @Database VARCHAR(255)   
DECLARE @Table VARCHAR(255)  
DECLARE @cmd NVARCHAR(500)  
DECLARE @fillfactor INT 

SET @fillfactor = 90 

DECLARE DatabaseCursor CURSOR FOR  
SELECT name FROM master.dbo.sysdatabases   
--WHERE name NOT IN ('master','msdb','tempdb','model','distribution')   
WHERE name IN ('WMPRD')   
ORDER BY 1  

OPEN DatabaseCursor  

FETCH NEXT FROM DatabaseCursor INTO @Database  
WHILE @@FETCH_STATUS = 0  
BEGIN  

   SET @cmd = 'DECLARE TableCursor CURSOR FOR SELECT ''['' + table_catalog + ''].['' + table_schema + ''].['' + 
  table_name + '']'' as tableName FROM [' + @Database + '].INFORMATION_SCHEMA.TABLES 
  WHERE table_type = ''BASE TABLE'''   

   -- create table cursor  
   EXEC (@cmd)  
   OPEN TableCursor   

   FETCH NEXT FROM TableCursor INTO @Table   
   WHILE @@FETCH_STATUS = 0   
   BEGIN   

       IF (@@MICROSOFTVERSION / POWER(2, 24) >= 9)
       BEGIN
           -- SQL 2005 or higher command 
           SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')' 
           EXEC (@cmd) 
       END
       ELSE
       BEGIN
          -- SQL 2000 command 
          DBCC DBREINDEX(@Table,' ',@fillfactor)  
       END

       FETCH NEXT FROM TableCursor INTO @Table   
   END   

   CLOSE TableCursor   
   DEALLOCATE TableCursor  

   FETCH NEXT FROM DatabaseCursor INTO @Database  
END  
CLOSE DatabaseCursor   
DEALLOCATE DatabaseCursor


-----------------------------------------------------------------------------------------------------
-- Espacio utilizado por una tabla
-----------------------------------------------------------------------------------------------------

EXEC sp_spaceused '[wmwhse10].orders'


-----------------------------------------------------------------------------------------------------
--Duracion de una pagina en buffer. Si tiene mas tiempo, mas rapidas las consultas.
--Debe ser mayor a 1000
-----------------------------------------------------------------------------------------------------
SELECT 
	object_name, counter_name, cntr_value
FROM 
	sys.dm_os_performance_counters
WHERE 
	[object_name] LIKE '%Buffer Manager%'
	AND [counter_name] = 'Page life expectancy'


--EXEC CHECKPOINT

-----------------------------------------------------------------------------------------------------
--Number of times per second SQL Server relocates dirty pages from buffer pool (memory) to disk.
--El limite es 20. Debe de ser menor.
-----------------------------------------------------------------------------------------------------
DECLARE @LazyWrites1 bigint;
SELECT @LazyWrites1 = cntr_value
  FROM sys.dm_os_performance_counters
  WHERE counter_name = 'Lazy writes/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT(cntr_value - @LazyWrites1) / 10 AS 'LazyWrites/sec'
  FROM sys.dm_os_performance_counters
  WHERE counter_name = 'Lazy writes/sec';



SELECT 
	object_name, counter_name, cntr_value
FROM 
	sys.dm_os_performance_counters
WHERE 
	[object_name] LIKE '%Memory Manager%'
	AND [counter_name] = 'Memory Grants Pending'


-----------------------------------------------------------------------------------------------------
--Total Server Memory (KB) debe ser mayor a Target Server Memory (KB)
-----------------------------------------------------------------------------------------------------

SELECT object_name ,counter_name, cntr_value 
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Total Server Memory (KB)' --Memoria asignada a SQL Server



SELECT object_name ,counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Target Server Memory (KB)' --Memoria que SQL Server necesita para funcionar optimamente

---PLE (Page Life Expectancy) debe ser mayor a 300

select Instancename, 
TargetServerMemoryKB/1024 'TargetServerMemoryMB',
TotalServerMemoryKB/1024 as 'TotalServerMemoryMB', 
PLE, (TargetServerMemoryKB/1024)/PLE as 'ChurnMB/sec'
from(
select @@SERVERNAME as 'Instancename',
max(case when counter_name = 'Target Server Memory (KB)' then cntr_value end) as 'TargetServerMemoryKB',
max(case when counter_name = 'Total Server Memory (KB)' then cntr_value end) as 'TotalServerMemoryKB',
max(case when counter_name = 'Page life expectancy'  then cntr_value end) as 'PLE'
from sys.dm_os_performance_counters) 
as p

;with cte as (
select @@SERVERNAME as 'Instancename',
max(case when name = 'min server memory (MB)' then value_in_use end) as 'MinServerMemoryMB',
max(case when name = 'max server memory (MB)' then value_in_use end) as 'MaxServerMemoryMB'
from sys.configurations)
select p.Instancename, 
os.PhysicalCPUCount, os.PhysicalMemoryMB,
c.MinServerMemoryMB,c.MaxServerMemoryMB,
p.TargetServerMemoryKB/1024 as 'TargetServerMemoryMB',
p.TotalServerMemoryKB/1024 as 'TotalServerMemoryMB',
p.PLE , (p.TotalServerMemoryKB)/p.PLE as 'ChurnKB/sec'
from(
select @@SERVERNAME as 'Instancename',
max(case when counter_name = 'Target Server Memory (KB)' then cntr_value end) as 'TargetServerMemoryKB',
max(case when counter_name = 'Total Server Memory (KB)' then cntr_value end) as 'TotalServerMemoryKB',
max(case when counter_name = 'Page life expectancy'  then cntr_value end) as 'PLE'
from sys.dm_os_performance_counters) 
as p
join cte c on p.instancename = c.instancename
join
(SELECT @@SERVERNAME as 'Instancename', cpu_count AS 'LogicalCPUCount', hyperthread_ratio AS 'HyperthreadRatio',
cpu_count/hyperthread_ratio AS 'PhysicalCPUCount', 
physical_memory_in_bytes/1048576 AS 'PhysicalMemoryMB' 
FROM sys.dm_os_sys_info ) as os
on c.instancename=os.instancename

-----------------------------------------------------------------------------------------------------
--Consulta para determinar los bloqueos
-----------------------------------------------------------------------------------------------------


WITH [Blocking]
AS (SELECT w.[session_id]
   ,s.[original_login_name]
   ,s.[login_name]
   ,w.[wait_duration_ms]
   ,w.[wait_type]
   ,r.[status]
   ,r.[wait_resource]
   ,w.[resource_description]
   ,s.[program_name]
   ,w.[blocking_session_id]
   ,s.[host_name]
   ,r.[command]
   ,r.[percent_complete]
   ,r.[cpu_time]
   ,r.[total_elapsed_time]
   ,r.[reads]
   ,r.[writes]
   ,r.[logical_reads]
   ,r.[row_count]
   ,q.[text]
   ,q.[dbid]
   ,p.[query_plan]
   ,r.[plan_handle]
 FROM [sys].[dm_os_waiting_tasks] w
 INNER JOIN [sys].[dm_exec_sessions] s ON w.[session_id] = s.[session_id]
 INNER JOIN [sys].[dm_exec_requests] r ON s.[session_id] = r.[session_id]
 CROSS APPLY [sys].[dm_exec_sql_text](r.[plan_handle]) q
 CROSS APPLY [sys].[dm_exec_query_plan](r.[plan_handle]) p
 WHERE w.[session_id] > 50
  AND w.[wait_type] NOT IN ('DBMIRROR_DBM_EVENT'
      ,'ASYNC_NETWORK_IO'))
SELECT b.[session_id] AS [WaitingSessionID]
      ,b.[blocking_session_id] AS [BlockingSessionID]
      ,b.[login_name] AS [WaitingUserSessionLogin]
      ,s1.[login_name] AS [BlockingUserSessionLogin]
      ,b.[original_login_name] AS [WaitingUserConnectionLogin] 
      ,s1.[original_login_name] AS [BlockingSessionConnectionLogin]
      ,b.[wait_duration_ms] AS [WaitDuration]
      ,b.[wait_type] AS [WaitType]
      ,t.[request_mode] AS [WaitRequestMode]
      ,UPPER(b.[status]) AS [WaitingProcessStatus]
      ,UPPER(s1.[status]) AS [BlockingSessionStatus]
      ,b.[wait_resource] AS [WaitResource]
      ,t.[resource_type] AS [WaitResourceType]
      ,t.[resource_database_id] AS [WaitResourceDatabaseID]
      ,DB_NAME(t.[resource_database_id]) AS [WaitResourceDatabaseName]
      ,b.[resource_description] AS [WaitResourceDescription]
      ,b.[program_name] AS [WaitingSessionProgramName]
      ,s1.[program_name] AS [BlockingSessionProgramName]
      ,b.[host_name] AS [WaitingHost]
      ,s1.[host_name] AS [BlockingHost]
      ,b.[command] AS [WaitingCommandType]
      ,b.[text] AS [WaitingCommandText]
      ,b.[row_count] AS [WaitingCommandRowCount]
      ,b.[percent_complete] AS [WaitingCommandPercentComplete]
      ,b.[cpu_time] AS [WaitingCommandCPUTime]
      ,b.[total_elapsed_time] AS [WaitingCommandTotalElapsedTime]
      ,b.[reads] AS [WaitingCommandReads]
      ,b.[writes] AS [WaitingCommandWrites]
      ,b.[logical_reads] AS [WaitingCommandLogicalReads]
      ,b.[query_plan] AS [WaitingCommandQueryPlan]
      ,b.[plan_handle] AS [WaitingCommandPlanHandle]
FROM [Blocking] b
INNER JOIN [sys].[dm_exec_sessions] s1
ON b.[blocking_session_id] = s1.[session_id]
INNER JOIN [sys].[dm_tran_locks] t
ON t.[request_session_id] = b.[session_id]
WHERE t.[request_status] = 'WAIT'
GO