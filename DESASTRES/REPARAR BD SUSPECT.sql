--Habilitar modificación en la base de datos master:

USE master
GO
sp_configure 'allow updates', 1
GO
RECONFIGURE WITH OVERRIDE
GO
-- Resetear el estado de suspect:
EXEC sp_resetstatus 'MyDB';

-- Para ejecutar el check de integridad hará falta poner la base de datos en single user
ALTER DATABASE 'MyDB' SET SINGLE_USER;

--En caso que no sea posible sacarla de suspect, es posible pasarla a modo emergency
Alter Database 'MyDB' Set Emergency

--Si esto no funciona es posible que haya que reinicar la instancia entera de SQL Server
--Pasamos integrity check, para reparar sin perdida de datos:

DBCC checkdb('MyDB',REPAIR_REBUILD);

--Para reparar con posible perdida de datos:

DBCC checkdb('MyDB',REPAIR_ALLOW_DATA_LOSS);

--Para volver a dejar la base de datos en modo multiusuario:

ALTER DATABASE 'MyDB' SET MULTI_USER

--Deshabilitar la opción de allow_updates para volver a dejarlo como antes

USE master
GO

sp_configure 'allow updates', 0
GO
RECONFIGURE WITH OVERRIDE
GO

--Ya tendríamos la base de datos lista y reparada para continuar trabajando.