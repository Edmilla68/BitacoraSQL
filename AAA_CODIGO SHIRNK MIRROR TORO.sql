
USE bdpla_andes
GO
DBCC SHRINKFILE(bdpla_roca_Log, 1)
--BACKUP LOG ACADEMIA WITH TRUNCATE_ONLY
BACKUP LOG bdpla_andes TO  DISK = N'D:\BKP\bdpla_andes.TLG' WITH NOFORMAT, NOINIT,  NAME = N'bdpla_andes-Transaction Log  Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
DBCC SHRINKFILE(bdpla_roca_Log, 1)
GO