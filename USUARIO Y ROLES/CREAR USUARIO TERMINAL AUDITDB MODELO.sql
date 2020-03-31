USE [AuditDB]
GO
CREATE USER edmilla FOR LOGIN edmilla ;  
GO  
EXEC sp_addrolemember 'db_owner', 'edmilla'  
