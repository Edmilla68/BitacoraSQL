USE Balanza	;  
GRANT INSERT TO erneyra WITH GRANT OPTION;  
GO  

USE Descarga;  
GRANT INSERT TO erneyra WITH GRANT OPTION;  
GO  

USE Oceano;  
GRANT INSERT TO erneyra WITH GRANT OPTION;  
GO  



--PARA HABILITAR A UN USUARIO QUE HAGA TRAZAS
GRANT ALTER TRACE TO [DOMINIO\GrupoDesarrollo]


/*


RUTA:  https://docs.microsoft.com/es-es/sql/t-sql/statements/grant-database-permissions-transact-sql



Una base de datos es un elemento protegible que contiene el servidor, que es su entidad primaria en la jerarquía de permisos. La mayoría de permisos limitados y específicos que se pueden conceder para una base de datos se muestran en la siguiente tabla, junto con permisos más generales que los incluyen por implicación.

Permiso de base de datos	Implícito en el permiso de base de datos	Implícito en el permiso de servidor
ADMINISTER DATABASE BULK OPERATIONS
Se aplica a: Base de datos SQL.	CONTROL	CONTROL SERVER
ALTER	CONTROL	ALTER ANY DATABASE
ALTER ANY APPLICATION ROLE	ALTER	CONTROL SERVER
ALTER ANY ASSEMBLY	ALTER	CONTROL SERVER
ALTER ANY ASYMMETRIC KEY	ALTER	CONTROL SERVER
ALTER ANY CERTIFICATE	ALTER	CONTROL SERVER
ALTER ANY COLUMN ENCRYPTION KEY	ALTER	CONTROL SERVER
MODIFICAR CUALQUIER DEFINICIÓN DE LA CLAVE MAESTRA DE COLUMNA	ALTER	CONTROL SERVER
ALTER ANY CONTRACT	ALTER	CONTROL SERVER
ALTER ANY DATABASE AUDIT	ALTER	ALTER ANY SERVER AUDIT
ALTER ANY DATABASE DDL TRIGGER	ALTER	CONTROL SERVER
ALTER ANY DATABASE EVENT NOTIFICATION	ALTER	ALTER ANY EVENT NOTIFICATION
ALTER ANY DATABASE EVENT SESSION
Se aplica a: Base de datos SQL.	ALTER	ALTER ANY EVENT SESSION
ALTER ANY DATABASE SCOPED CONFIGURATION
Se aplica a: SQL Server 2016 a través de SQL Server 2017, Base de datos SQL.	CONTROL	CONTROL SERVER
ALTER ANY DATASPACE	ALTER	CONTROL SERVER
ALTER ANY EXTERNAL DATA SOURCE	ALTER	CONTROL SERVER
ALTER ANY EXTERNAL FILE FORMAT	ALTER	CONTROL SERVER
MODIFICAR ALGUNA BIBLIOTECA EXTERNA 
Se aplica a: SQL Server 2017.	CONTROL	CONTROL SERVER
ALTER ANY FULLTEXT CATALOG	ALTER	CONTROL SERVER
ALTER ANY MASK	CONTROL	CONTROL SERVER
ALTER ANY MESSAGE TYPE	ALTER	CONTROL SERVER
ALTER ANY REMOTE SERVICE BINDING	ALTER	CONTROL SERVER
ALTER ANY ROLE	ALTER	CONTROL SERVER
ALTER ANY ROUTE	ALTER	CONTROL SERVER
ALTER ANY SCHEMA	ALTER	CONTROL SERVER
ALTER ANY SECURITY POLICY
Se aplica a: Base de datos SQL de Azure.	CONTROL	CONTROL SERVER
ALTER ANY SERVICE	ALTER	CONTROL SERVER
ALTER ANY SYMMETRIC KEY	ALTER	CONTROL SERVER
ALTER ANY USER	ALTER	CONTROL SERVER
AUTHENTICATE	CONTROL	AUTHENTICATE SERVER
BACKUP DATABASE	CONTROL	CONTROL SERVER
BACKUP LOG	CONTROL	CONTROL SERVER
CHECKPOINT	CONTROL	CONTROL SERVER
CONNECT	CONNECT REPLICATION	CONTROL SERVER
CONNECT REPLICATION	CONTROL	CONTROL SERVER
CONTROL	CONTROL	CONTROL SERVER
CREATE AGGREGATE	ALTER	CONTROL SERVER
CREATE ASSEMBLY	ALTER ANY ASSEMBLY	CONTROL SERVER
CREATE ASYMMETRIC KEY	ALTER ANY ASYMMETRIC KEY	CONTROL SERVER
CREATE CERTIFICATE	ALTER ANY CERTIFICATE	CONTROL SERVER
CREATE CONTRACT	ALTER ANY CONTRACT	CONTROL SERVER
CREATE DATABASE	CONTROL	CREATE ANY DATABASE
CREATE DATABASE DDL EVENT NOTIFICATION	ALTER ANY DATABASE EVENT NOTIFICATION	CREATE DDL EVENT NOTIFICATION
CREATE DEFAULT	ALTER	CONTROL SERVER
CREATE FULLTEXT CATALOG	ALTER ANY FULLTEXT CATALOG	CONTROL SERVER
CREATE FUNCTION	ALTER	CONTROL SERVER
CREATE MESSAGE TYPE	ALTER ANY MESSAGE TYPE	CONTROL SERVER
CREATE PROCEDURE	ALTER	CONTROL SERVER
CREATE QUEUE	ALTER	CONTROL SERVER
CREATE REMOTE SERVICE BINDING	ALTER ANY REMOTE SERVICE BINDING	CONTROL SERVER
CREATE ROLE	ALTER ANY ROLE	CONTROL SERVER
CREATE ROUTE	ALTER ANY ROUTE	CONTROL SERVER
CREATE RULE	ALTER	CONTROL SERVER
CREATE SCHEMA	ALTER ANY SCHEMA	CONTROL SERVER
CREATE SERVICE	ALTER ANY SERVICE	CONTROL SERVER
CREATE SYMMETRIC KEY	ALTER ANY SYMMETRIC KEY	CONTROL SERVER
CREATE SYNONYM	ALTER	CONTROL SERVER
CREATE TABLE	ALTER	CONTROL SERVER
CREATE TYPE	ALTER	CONTROL SERVER
CREATE VIEW	ALTER	CONTROL SERVER
CREATE XML SCHEMA COLLECTION	ALTER	CONTROL SERVER
DELETE	CONTROL	CONTROL SERVER
Ejecute	CONTROL	CONTROL SERVER
EXECUTE ANY EXTERNAL SCRIPT 
Se aplica a: SQL Server 2016.	CONTROL	CONTROL SERVER
INSERT	CONTROL	CONTROL SERVER
KILL DATABASE CONNECTION
Se aplica a: Base de datos SQL de Azure.	CONTROL	ALTER ANY CONNECTION
REFERENCES	CONTROL	CONTROL SERVER
SELECT	CONTROL	CONTROL SERVER
SHOWPLAN	CONTROL	ALTER TRACE
SUBSCRIBE QUERY NOTIFICATIONS	CONTROL	CONTROL SERVER
TAKE OWNERSHIP	CONTROL	CONTROL SERVER
UNMASK	CONTROL	CONTROL SERVER
UPDATE	CONTROL	CONTROL SERVER
VIEW ANY COLUMN ENCRYPTION KEY DEFINITION	CONTROL	VIEW ANY DEFINITION
VIEW ANY COLUMN MASTER KEY DEFINITION	CONTROL	VIEW ANY DEFINITION
VIEW DATABASE STATE	CONTROL	VIEW SERVER STATE
VIEW DEFINITION	CONTROL	VIEW ANY DEFINITION
Permissions
El otorgante del permiso (o la entidad de seguridad especificada con la opción AS) debe tener el permiso con GRANT OPTION, o un permiso superior que implique el permiso que se va a conceder.

Si utiliza la opción AS, se aplican los siguientes requisitos adicionales.

AS granting_principal	Permiso adicional necesario
Usuario de la base de datos	Permiso IMPERSONATE para el usuario, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Usuario de la base de datos asignado a un inicio de sesión de Windows	Permiso IMPERSONATE para el usuario, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Usuario de la base de datos asignado a un grupo de Windows	Pertenencia al grupo de Windows, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Usuario de la base de datos asignado a un certificado	Pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Usuario de la base de datos asignado a una clave asimétrica	Pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Usuario de la base de datos no asignado a una entidad de seguridad del servidor	Permiso IMPERSONATE para el usuario, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Rol de base de datos	Permiso ALTER para el rol, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Rol de aplicación	Permiso ALTER para el rol, pertenencia al rol fijo de base de datos db_securityadmin, pertenencia al rol fijo de base de datos db_owner o pertenencia al rol fijo de servidor sysadmin.
Los propietarios de objetos pueden conceder permisos para los objetos que poseen. Las entidades de seguridad que tienen el permiso CONTROL para un elemento protegible pueden conceder permisos para ese elemento.

Los receptores del permiso CONTROL SERVER como los miembros del rol fijo de servidor sysadmin pueden conceder los permisos sobre cualquier elemento protegible en el servidor.

Ejemplos
A. Conceder el permiso para crear tablas
El siguiente ejemplo se concede CREATE TABLE permiso en el AdventureWorks base de datos de usuario MelanieK.


Copiar
USE AdventureWorks;  
GRANT CREATE TABLE TO MelanieK;  
GO  
B. Conceder el permiso SHOWPLAN para un rol de aplicación
En el siguiente ejemplo se concede el permiso SHOWPLAN para la base de datos AdventureWorks2012 al rol de aplicación AuditMonitor.

Se aplica a: SQL Server 2008 a través de SQL Server 2017, Base de datos SQL

Copiar
USE AdventureWorks2012;  
GRANT SHOWPLAN TO AuditMonitor;  
GO  
C. Conceder CREATE VIEW con GRANT OPTION
En el siguiente ejemplo se concede el permiso CREATE VIEW para la base de datos AdventureWorks2012 al usuario CarmineEs con el derecho para conceder CREATE VIEW a otras entidades de seguridad.


Copiar
USE AdventureWorks2012;  
GRANT CREATE VIEW TO CarmineEs WITH GRANT OPTION;  
GO  


*/