sp_configure 'show advanced options', 1
RECONFIGURE
GO

sp_configure 'awe enabled', 1
RECONFIGURE
GO


sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Agent XPs', 1;
GO
RECONFIGURE
GO