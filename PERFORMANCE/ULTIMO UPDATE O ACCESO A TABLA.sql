SELECT tab.name AS TableName,
sum(user_seeks) AS user_seeks , 
sum(user_scans) AS user_scans, 
sum(user_lookups) AS user_lookups, 
avg(user_updates) AS user_updates,
max(last_user_seek) AS last_user_seek, 
max(last_user_scan) AS last_user_scan , 
max(last_user_lookup) AS last_user_lookup, 
max(last_user_update) AS last_user_update
FROM sys.dm_db_index_usage_stats ius 
INNER JOIN sys.tables tab ON (tab.object_id = ius.object_id)
WHERE database_id = DB_ID(N'OFIRECA')  
      --AND tab.name = 'TMCLIE'
GROUP BY tab.name
ORDER BY tab.name