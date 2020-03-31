--SQL Script begin
IF OBJECT_ID('tempdb..#DBTableStats ') IS NOT NULL
DROP TABLE #DBTableStats
GO
CREATE TABLE #DBTableStats
(Tabla NVARCHAR(255), UsrSeeks DEC, UsrScans DEC, UsrUpdates DEC)
INSERT INTO #DBTableStats

EXEC sp_MSForEachDB 'USE [?]; IF DB_ID(''?'') > 4
						BEGIN
						SELECT DB_NAME() + ''.'' + OBJECT_NAME(b.object_id), a.user_seeks, a.user_scans, a.user_updates
						FROM sys.dm_db_index_usage_stats a
						RIGHT OUTER JOIN [?].sys.indexes b ON a.object_id = b.object_id AND a.database_id = DB_ID()
						WHERE b.object_id > 100
						END'
SELECT [Tabla] AS 'Tabla', SUM(UsrSeeks + UsrScans + UsrUpdates) AS 'Total Accesos',
SUM(UsrUpdates) AS 'Escritura',
CONVERT(DEC(25,2),(SUM(UsrUpdates)/SUM(UsrSeeks + UsrScans + UsrUpdates)*100)) AS '% Escritura',
SUM(UsrSeeks + UsrScans) AS 'Lectura',
CONVERT(DEC(25,2),(SUM(UsrSeeks + UsrScans)/SUM(UsrSeeks + UsrScans + UsrUpdates)*100)) AS '% Lectura',
SUM(UsrSeeks) AS 'Seeks', CONVERT(DEC(25,2),(SUM(UsrSeeks)/SUM(UsrSeeks + UsrScans)*100)) AS '% Index Seeks',
SUM(UsrScans) AS 'Scans', CONVERT(DEC(25,2),(SUM(UsrScans)/SUM(UsrSeeks + UsrScans)*100)) AS '% Index Scans'
FROM #DBTableStats
GROUP by [Tabla]
HAVING SUM(UsrSeeks + UsrScans) > 0
ORDER by SUM(UsrSeeks + UsrScans + UsrUpdates) DESC
DROP table #DBTableStats
--SQL Script end