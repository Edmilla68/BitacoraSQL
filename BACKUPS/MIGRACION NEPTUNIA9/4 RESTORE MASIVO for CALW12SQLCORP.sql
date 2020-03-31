USE [master]
--ALTER DATABASE [NPT9_bd_actf] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_actf         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_actf.Bak' WITH  FILE = 1,  
MOVE N'bd_actf_Data'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_actf_Data.mdf',  
MOVE N'bd_actf_Log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_bd_actf_Log.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_actf] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_fulp] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_fulp         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_fulp.Bak' WITH  FILE = 1,  
MOVE N'data_mscc'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_fulp.mdf',  
MOVE N'bd_nept2'      TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_fulp2.mdf',  
MOVE N'log_mscc'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_log_fulp.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_fulp] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_hist_nept] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_hist_nept    FROM DISK = '\\lulas-system001\backup2\NPT9_bd_hist_nept.Bak' WITH  FILE = 1,  
MOVE N'bd_hist_Data'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_hist_Data.mdf',  
MOVE N'bd_hist_Log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_bd_hist_Log.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_hist_nept] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_inst] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_inst         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_inst.Bak' WITH  FILE = 1,  
MOVE N'data_inst'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_data_inst.mdf',  
MOVE N'data_instLog'  TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_log_inst.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_inst] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_kint] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_kint         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_kint.Bak' WITH  FILE = 1,  
MOVE N'bd_kint_Data'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_kint_Data.mdf',  
MOVE N'bd_kint_Log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_bd_kint_Log.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_kint] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_nep2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_nep2         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_nep2.Bak' WITH  FILE = 1,  
MOVE N'data_mscc'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_data_mscc_2.mdf',  
MOVE N'log_mscc'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_log_mscc_2.ldf', 
MOVE N'bd_nept2'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_nept2_2.mdf',  
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_nep2] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_nept] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_nept         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_nept.Bak' WITH  FILE = 1,  
MOVE N'data_mscc'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_data_mscc.mdf',  
MOVE N'log_mscc'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_log_mscc.ldf', 
MOVE N'bd_nept2'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_nept2.mdf',  
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_nept] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_seguridad] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_seguridad    FROM DISK = '\\lulas-system001\backup2\NPT9_bd_seguridad.Bak' WITH  FILE = 1,  
MOVE N'data_seguridad'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_data_seguridad.mdf',  
MOVE N'data_seguridadLog'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_data_seguridadLog.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_seguridad] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_bd_trit] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_bd_trit         FROM DISK = '\\lulas-system001\backup2\NPT9_bd_trit.Bak' WITH  FILE = 1,  
MOVE N'data_mscc'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_trit.mdf',  
MOVE N'log_mscc'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_log_trit.ldf', 
MOVE N'bd_nept2'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_bd_trit2.mdf',  
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_bd_trit] SET MULTI_USER
GO


USE [master]
--ALTER DATABASE [NPT9_Datawarehouse] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_Datawarehouse   FROM DISK = '\\lulas-system001\backup2\NPT9_Datawarehouse.Bak' WITH  FILE = 1,  
MOVE N'Datawarehouse_Data'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_Datawarehouse_Data.mdf',  
MOVE N'Datawarehouse_Log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_Datawarehouse_Log.ldf', 
MOVE N'Datawarehouse_Log2'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_Datawarehouse_Log2.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_Datawarehouse] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_RRHH] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_RRHH            FROM DISK = '\\lulas-system001\backup2\NPT9_RRHH.Bak' WITH  FILE = 1,  
MOVE N'RRHH_dat'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_RRHH_dat.mdf',  
MOVE N'RRHH_log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_RRHH_log.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_RRHH] SET MULTI_USER
GO

USE [master]
--ALTER DATABASE [NPT9_RSCONCAR] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE NPT9_RSCONCAR        FROM DISK = '\\lulas-system001\backup2\NPT9_RSCONCAR.Bak' WITH  FILE = 1,  
MOVE N'RSCONCAR_Data'     TO N'D:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\DATA\NPT9_RSCONCAR_Data.mdf',  
MOVE N'RSCONCAR_Log'      TO N'E:\Microsoft SQL Server\MSSQL11.NPTSQLSERVER\MSSQL\Data\NPT9_RSCONCAR_Log.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [NPT9_RSCONCAR] SET MULTI_USER
GO




