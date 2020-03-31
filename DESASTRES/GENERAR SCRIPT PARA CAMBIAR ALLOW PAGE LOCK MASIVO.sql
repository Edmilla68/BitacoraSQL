-- generate the TSQL Statments to enable page level locking for the required indexes 
SELECT 'ALTER INDEX ' +i.Name+ ' ON [' 
+ts.TABLE_CATALOG+ '].[' +ts.TABLE_SCHEMA+ '].[' +ts.TABLE_NAME+']' 
+' SET (ALLOW_PAGE_LOCKS = On)' as TSQL_Statement 
FROM sys.indexes i LEFT OUTER JOIN sys.tables t 
        ON i.object_id = t.object_id 
    JOIN INFORMATION_SCHEMA.TABLES ts 
        ON ts.TABLE_NAME = t.name 
WHERE i.allow_page_locks = 0 
    AND t.Name IS NOT NULL 