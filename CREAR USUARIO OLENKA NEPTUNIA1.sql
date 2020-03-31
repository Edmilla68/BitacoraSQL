--//neptunia1
USE [master]
CREATE LOGIN [flmendoza]      WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER LOGIN [flmendoza]      DISABLE
GO

USE [TERMINAL]
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Balanza
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Depositos
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Descarga
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE MANTENIMIENTO
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Logistica
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Oceano
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE SPARCS_HOST
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO


USE Tarifario
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO


ALTER LOGIN [flmendoza]      ENABLE
GO