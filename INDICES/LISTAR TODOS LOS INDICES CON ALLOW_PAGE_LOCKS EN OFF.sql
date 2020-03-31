
SELECT OBJECT_NAME(i.object_id) as TableName, name as IndexName, allow_page_locks
FROM sys.indexes as i 
WHERE ALLOW_PAGE_LOCKS = 0 

--Alter Index  PK_Viaje ON ContenedorViaje Set (ALLOW_PAGE_LOCKS = ON )