IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_Mirroring')
DROP ENDPOINT Endpoint_Mirroring;
IF EXISTS ( SELECT * FROM sys.certificates WHERE name = 'PRIM_cert' )
DROP CERTIFICATE PRIM_cert;
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] LIKE '%DatabaseMasterKey%')
DROP MASTER KEY;


//----------------------------------------------------------------------------------------------------------

CREATE ENDPOINT Endpoint_Mirroring  
    STATE=STARTED   
    AS TCP (LISTENER_PORT=5024)   
    FOR DATABASE_MIRRORING (ROLE=WITNESS)  
GO  
--Create a login for the partner server instances,  
--which are both running as Mydomain\dbousername:  
--USE master ;  
--GO  
--CREATE LOGIN [Mydomain\dbousername] FROM WINDOWS ;  
--GO  
--Grant connect permissions on endpoint to login account of partners.  
--GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [Mydomain\dbousername];  

USE master;  
GO  
CREATE LOGIN [MINATORO\admin_mirror] FROM WINDOWS;  
GO 
 
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [MINATORO\admin_mirror]
GO 

--GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [MINATORO\administrator];  
--GO  

//----------------------------------------------------------------------------------------------------------


ANTES :   	REALIZAR BACKUP FULL Y RESTAURAR CON NO RECOVERY	EN SERVER MIRROR
			REALIZAR BACKUP LOG TRANSACCIONES Y RESTAURAR CON NO RECOVERY  EN SERVER MIRROR

//---------------------------------------------------------------------------------------------------------------------------

--OJO aca no (correo EN PRINCIPAL)

ALTER DATABASE sofya_CDM15_tst   
    SET WITNESS =   'TCP://TESLISVRAPP.minatoro.com:5024'  
GO  