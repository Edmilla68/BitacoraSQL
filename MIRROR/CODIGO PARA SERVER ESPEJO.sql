IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_Mirroring')
DROP ENDPOINT Endpoint_Mirroring;
IF EXISTS ( SELECT * FROM sys.certificates WHERE name = 'PRIM_cert' )
DROP CERTIFICATE PRIM_cert;
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] LIKE '%##MS_ServiceMasterKey##%')
DROP MASTER KEY;

//---------------------------------------------------------------------------------------------------------------------------
CREATE ENDPOINT Endpoint_Mirroring  
    STATE=STARTED   
    AS TCP (LISTENER_PORT=5023)   
    FOR DATABASE_MIRRORING (ROLE=ALL)  
GO  
--Partners under same domain user; login already exists in master.  
--Create a login for the witness server instance,  
--which is running as Somedomain\witnessuser:  
--USE master ;  
--GO  
--CREATE LOGIN [Somedomain\witnessuser] FROM WINDOWS ;  
--GO  
--Grant connect permissions on endpoint to login account of witness.  
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [MINATORO\administrator];  
--Grant connect permissions on endpoint to login account of partners.  
--GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [MINATORO\administrator];  
--GO  .bak
--		TESLISVRAPP:5022

//---------------------------------------------------------------------------------------------------------------------------


ANTES :   	REALIZAR BACKUP FULL Y RESTAURAR CON NO RECOVERY	EN SERVER MIRROR
			REALIZAR BACKUP LOG TRANSACCIONES Y RESTAURAR CON NO RECOVERY  EN SERVER MIRROR

//---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------
--comando previo ... solo si no funca.....
--ALTER DATABASE bdpla_andes SET PARTNER OFF;


---  Ojo primero aca... (en el server de espejo)
			
ALTER DATABASE bdpla_andes   
  SET PARTNER =   
    'TCP://lisvrapp.minatoro.com:5022'  
GO