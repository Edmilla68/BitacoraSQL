--PASO 1 
DROP STATISTICS EDBOOKIN13.Statistic_bookin13
--PASO 2
DROP INDEX [IX_EDBOOKIN13_consultaweb] ON [dbo].[EDBOOKIN13] WITH ( ONLINE = OFF )

--PASO 3
USE [Descarga]
GO
ALTER TABLE dbo.EDBOOKIN13 ALTER COLUMN bookin13 char(25) NOT NULL ;
GO

--PASO 4
USE [Descarga]
GO
CREATE NONCLUSTERED INDEX [IX_EDBOOKIN13_consultaweb] ON [dbo].[EDBOOKIN13] 
(	[navvia11] ASC,
	[bookin13] ASC
)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
GO

