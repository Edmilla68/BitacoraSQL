--//OCEANICA1
USE [master]
CREATE LOGIN [flmendoza]      WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER LOGIN [flmendoza]      DISABLE
GO


USE Descarga
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE Oceano
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO

USE SPARCS_HOST_VACIOS
GO
CREATE USER [flmendoza]      FOR LOGIN [flmendoza]      WITH DEFAULT_SCHEMA=[flmendoza]     
GO




ALTER LOGIN [flmendoza]      ENABLE
GO
