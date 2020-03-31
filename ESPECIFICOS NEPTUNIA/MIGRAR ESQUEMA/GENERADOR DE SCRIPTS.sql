

select 'DELETE FROM  wmwhse1.'+name from sys.tables
where schema_id = 13

select 'DBCC CHECKIDENT (''wmwhse1.'+name+''', RESEED,0)' from sys.tables
where schema_id = 13


--DBCC CHECKIDENT ('mi_tabla', RESEED,0)
--select * from sys.schemas

