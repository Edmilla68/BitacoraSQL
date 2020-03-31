IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_Mirroring')
DROP ENDPOINT Endpoint_Mirroring;
IF EXISTS ( SELECT * FROM sys.certificates WHERE name = 'PRIM_cert' )
DROP CERTIFICATE PRIM_cert;
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] LIKE '%##MS_ServiceMasterKey##%')
DROP MASTER KEY;

//--------------------------------------------------------------------------------------------------------
CREATE ENDPOINT Endpoint_Mirroring  
    STATE=STARTED   
    AS TCP (LISTENER_PORT=5022)   
    FOR DATABASE_MIRRORING (ROLE=PARTNER)  
GO  
--Partners under same domain user; login already exists in master.  

USE master;  
GO  
CREATE LOGIN [MINATORO\admin_mirror] FROM WINDOWS;  
GO 
 
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [MINATORO\admin_mirror]


GO  


//--------------------------------------------------------------------------------------------------------

ANTES :   	REALIZAR BACKUP FULL Y RESTAURAR CON NO RECOVERY	EN SERVER MIRROR
			REALIZAR BACKUP LOG TRANSACCIONES Y RESTAURAR CON NO RECOVERY  EN SERVER MIRROR

//--------------------------------------------------------------------------------------------------------
------------------------------------------------
--comando previo ... solo si no funca.....
--ALTER DATABASE bdpla_andes SET PARTNER OFF;

---  Ojo primero correr en el server de espejo... el script correspondiente... (ver script)

ALTER DATABASE bdpla_andes   
    SET PARTNER = 'TCP://replisvrapp.minatoro.com:5023'  
GO 

ALTER DATABASE bdpla_andes   
    SET WITNESS =   'TCP://TESLISVRAPP.minatoro.com:5024'  
GO  


/* PARA DETENER PAUSAR EL MIRROR CON CODIGO

ALTER DATABASE ACADEMIA SET PARTNER SUSPEND    	--(PAUSA)
ALTER DATABASE ACADEMIA SET RECOVERY SIMPLE		--(REINICIA)

*/



/*   --REDUCIR ARCHIVO LOG CUANDO HAY MIRROR   (CORRER VARIAS VECES)
USE bdpla_andes
GO
DBCC SHRINKFILE(bdpla_roca_Log, 1)
--BACKUP LOG ACADEMIA WITH TRUNCATE_ONLY   --( BORRADA TRUNCATE_ONLY   NO PROBADO)
BACKUP LOG bdpla_andes TO  DISK = N'D:\BKP\bdpla_andes.TLG' WITH NOFORMAT, NOINIT,  NAME = N'bdpla_andes-Transaction Log  Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
DBCC SHRINKFILE(bdpla_roca_Log, 1)
GO
*/