-- TABLAS CON FK RELACION FORANEA
--USE termila;
select COUNT(*) from (
	SELECT distinct OBJECT_NAME(fk.parent_object_id) AS TableName
	FROM sys.foreign_keys AS fk
	INNER JOIN sys.foreign_key_columns AS fc ON fk.OBJECT_ID = fc.constraint_object_id
	union
	SELECT distinct OBJECT_NAME (fk.referenced_object_id) AS TableName
	FROM sys.foreign_keys AS fk
	INNER JOIN sys.foreign_key_columns AS fc ON fk.OBJECT_ID = fc.constraint_object_id
	)t001
	
	