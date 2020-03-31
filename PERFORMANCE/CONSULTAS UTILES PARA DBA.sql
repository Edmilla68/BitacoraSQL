-- ———————————-
-- ——- LOG DE TRANSACCIONES —–
-- ———————————-
 
-- —-VERIFICAR USO DEL LOG DE TRANSACCIONES ESPACIOS DISPONIBLES
DBCC SQLPERF( LOGSPACE )
  
-- TRUNCAR EL LOG DE TRANSACCIONES EN SQL SERVER 2000 Y 2005
use DB
CHECKPOINT
GO
BACKUP LOG Exercise WITH
TRUNCATE_ONLY
DBCC SHRINKFILE(‘Exercise_log’, 10) –Dejamos el archivo de log con un tamaño de 10 Mb
DBCC sqlperf(logspace)
 
-- TRUNCAR EL LOG DE TRANSACCION EN SQL SERVER 2008–
USE DB;
GO
ALTER DATABASE AdventureWorks2008R2
SET RECOVERY SIMPLE;
GO
– Deja el log en 1 MB.
DBCC SHRINKFILE(AdventureWorks2008R2_Log, 1);
GO
– Regresar el
modelo de recuperacion a FULL.
ALTER DATABASE DB
SET RECOVERY FULL;
GO
-- ******************************———————–
 
 
--AÑADIR ARCHIVOS LOG A UNA BASE DE DATOS
USE master;
GO
ALTER DATABASE DB
ADD LOG FILE
(
    NAME = DB_test1log2,
    FILENAME = ‘RUTA\DB2log.ldf’,
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
),
(
    NAME = DB_test1log3,
    FILENAME = ‘RUTA\DB3log.ldf’,
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH =
5MB
);
GO
 
 
--VERIFICAR EL ESTATUS DEL LOG DE TRANSACCIONES CUANDO ESTE LLENO
Select name as base_datos,
log_reuse_wait, log_reuse_wait_desc,
case
log_reuse_wait
when 0 then ‘Hay actualmente uno o
más archivos de registro virtual reutilizables.’
when 1 then ‘No se ha producido
ningún punto de comprobación desde el ÚLTIMO AVISO! para Ganar $$$$Se Buscan
Personas para TRABAJAR DESDE sus Casas por Internet – +Infoúltimo truncamiento
o el encabezado del registro no se ha movido más allá de un archivo de registro
virtual (todos los modelos de recuperación). Éste es un motivo habitual para
retrasar el truncamiento.’
when 2 then ‘Se necesita una copia
de seguridad del registro para hacer avanzar el encabezado del registro
(modelos de recuperación completos o registrados de forma masiva sólo). Cuando
se completa la copia de seguridad del registro, se avanza el encabezado del
registro y algún espacio del registro podría convertirse en reutilizable.’
when 3 then ‘Existe una recuperación
o copia de seguridad de datos en curso (todos los modelos de recuperación).
La copia de seguridad
de datos funciona como una transacción activa y, cuando se ejecuta, la copia de
seguridad impide el truncamiento.’
when 4 then ‘Podría existir una
transacción de larga duración en el inicio de la copia de seguridad del
registro. En este caso, para liberar espacio se podría requerir otra copia de
seguridad del registro.
Se difiere una
transacción. Una transacción diferida es efectivamente una transacción activa
cuya reversión se bloquea debido a algún recurso no disponible.’
when 5 then ‘Se realiza una pausa en
la creación de reflejo de la base de datos o, en el modo de alto rendimiento,
la base de datos reflejada está notablemente detrás de la base de datos de la
entidad de seguridad (sólo para el modelo de recuperación completa).’
when 6 then ‘Durante las
replicaciones transaccionales, las transacciones relevante para las
publicaciones no se han entregado aún a la base de datos de distribución (sólo
para el modelo de recuperación completa).’
when 7 then ‘Se está creando una
instantánea de base de datos (todos los modelos de recuperación). Éste es un
motivo habitual, por lo general breve, para retrasar el truncamiento del
registro.’
when 8 then ‘Se está produciendo un
recorrido del registro (todos los modelos de recuperación). Éste es un motivo
habitual, por lo general breve, para retrasar el truncamiento del registro.’
when 9 then ‘No se utiliza este
valor actualmente.’
end as columna,
recovery_model_desc as
modo_recuperacion_log, page_verify_option_desc as page_verify_bbdd,
user_access_desc as user_access,
state_desc as estado_bbdd from sys.databases
 
 
 
 
 
 
-- —————————————————————————
--- - Seguridad (USUARIOS, LOGGINS, PASSWORD, ESQUEMAS, ROLES, PERMISOS–
-- —————————————————————————
 
--DESCRIPCION DE LOS ROLES DE SERVIDOR
sp_helpsrvrole
 
--MIEMBROS QUE PERTENECEN A UN ROL DE SERVIDOR
sp_helpsrvrolemember
 
--ROLES DEFINIDOS EN LA BASE DE DATOS
sp_helprole
 
--MIEMBROS DE LOS ROLES DE BASES DE DATOS
sp_helprolemember
 
--FIXED DATABASE ROLES
sp_helpdbfixedrole
 
--LISTA DE LOGINS POR BASE DE DATOS
sp_helplogins
 
sp_srvrolepermission – permisos que tiene cada rol en el servidor
sp_addsrvrolemember  – agrega un inicio de sesion a un rol
sp_dropsrvrolemember – quita usuario, inicio de sesion o grupo del rol del servidor
sp_helpuser          – informacion de usuarios en el servidor actual
sp_helpntgroup       – Grupos
xp_cmdshell ‘whoami.exe’ –para saber quien tiene permisos de ejecutar xp_cmdshell
 
--ASIGNAR PERMISOS A USUARIOS SOBRE OBJETOS
grant
tipo_de_permiso on objeto to rol   
 
-- CREAR ROLES
CREATE ROLE role_name [ AUTHORIZATION owner_name ]
 
-- INFORMACION DE LOS ROLES
select * from sys.database_role_members 
 
-- INFORMACION DE LOS ROLES
select * from sys.database_principals
  
-- INFORMACION DE LOS ESQUEMAS
select * from sys.schemas 
 
-- INFORMACION DE LOGGINS
SELECT * FROM sys.server_principals
 
-- NOMBRE DE USUARIO ACTUAL
SELECT CURRENT_USER
 
-- NOMBRE DE SYSTEM_USER
SELECT SYSTEM_USER
 
-- USUARIOS HUERFANOS SIN INICIO DE SESION
EXEC sp_change_users_login‘Update_One’, ‘ExistingUser’, ‘NewLogin’
 
 
use master select sid, name from master..syslogins – *** Ver los Inicios de Sesión de la Instancia de SQL
Server ***
use DB select uid, name, sid from sysusers where
islogin=1 – *** Ver los Usuarios de la Base de Datos actual de SQL Server ***
 
 
 
--CAMBIAR DUEÑO DE UN OBJETO
EXEC sp_changeobjectowner‘CurrentOwner.TableName’,
‘newOwner’
 
--CHECAR QUIEN ES DUEÑO DE OBJETOS
select s.name, u.name from sysusers u, sysobjects s
 where s.uid=u.uid and s.uid!=1
 
--LIGAR LOGGIN CON USUARIO
 sp_change_users_login ‘AUTO_FIX’,‘usr_reports’
 
--CAMBIAR PASSWORD SQL SERVER 2000
 sp_password @old = null, @new = ‘pasword’, @loginame = user
 
--CAMBIAR PASSWORD SQL SERVER 2005 y 2008
ALTER LOGIN user WITH PASSWORD = ‘pasword’
 
 
-- LISTAR PERMISOS DE LOS USUARIOS
select dp.NAME usuario, dp.type_desc AS tipo, o.NAME AS nombre_de_objeto,
p.permission_name nombre_de_permiso,
p.state_desc AS permisos from sys.database_permissions p
left    OUTER JOIN sys.all_objects o on p.major_id = o.OBJECT_ID
inner   JOIN sys.database_principals dp on  p.grantee_principal_id
= dp.principal_id
order by
usuario
 
 
-- Estadísticas de inicio de sesión sql server 2008
select * from sys.dm_exec_sessions
 
-- número de sesiones de cada usuario  sql server 2008
SELECT login_name
,COUNT(session_id) AS session_count
FROM sys.dm_exec_sessions
GROUP BY login_name;
 
 
-- Buscar sesiones inactivas que tienen transacciones abiertas sql server 2008
SELECT s.*
FROM sys.dm_exec_sessions AS
s
WHERE EXISTS
    (
    SELECT *
    FROM sys.dm_tran_session_transactions
AS t
    WHERE t.session_id = s.session_id
    )
    AND NOT EXISTS
    (
    SELECT *
    FROM sys.dm_exec_requests AS r
    WHERE r.session_id = s.session_id
    );
 
 
 
-- NUMERO DE CONEXIONES A LA INSTANCIA POR APLICACION
SELECT
     CPU            = SUM(cpu_time)
    ,WaitTime
= SUM(total_scheduled_time)
    ,ElapsedTime
= SUM(total_elapsed_time)
    ,Reads
= SUM(num_reads)
    ,Writes
= SUM(num_writes)
    ,Connections
= COUNT(1)
    ,Program
= program_name
FROM sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions
ses
    ON ses.session_id = con.session_id
GROUP BY program_name
 
 
 
-- NUMERO DE CONEXIONES A LA INSTANCIA POR USUARIO
SELECT
     CPU            = SUM(cpu_time)
    ,WaitTime
= SUM(total_scheduled_time)
    ,ElapsedTime
= SUM(total_elapsed_time)
    ,Reads
= SUM(num_reads)
    ,Writes
= SUM(num_writes)
    ,Connections
= COUNT(1)
    ,[login]
= original_login_name
from sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions
ses
ON ses.session_id = con.session_id
GROUP BY original_login_name
 
 
 
 
 
-- —————————–
--DATA FILES Y FILES GROUPS–
-- —————————–
 
 
sp_helpfilegroup – MOSTRAR FILES Y FILES GROUPS
sp_helpfile       – MOSTRAR INFORMACION DE LOS FILES DE LA BASE DE DATOS ACTUAL
sp_helpdb CICLISMO  –MOSTRAR INFORMACION DE LAS BASES DE DATOS
DBCC
SHRINKDATABASE(DB, 25)– REDUCIR BASE DE DATOS
 
-- Mostrar informacion de los archivos log y mdf de la base de datos actual
select * from sys.database_files
 
-- Añadir datafiles
use master
go
Alter database tempdb add file (name = tempdev1,
filename = ‘G:\MSSQL.2\MSSQL\Data\tempdb1.ndf’)
 
 
-- ESPACIO DISPONIBLE EN DATAFILES  SQL SERVER 2000
use db
select a.FILEID,
[FILE_SIZE_MB] =  convert(decimal(12,2),round(a.size/128.000,2)),
[SPACE_USED_MB] = convert(decimal(12,2),round(fileproperty(a.name,‘SpaceUsed’)/128.000,2)),
[FREE_SPACE_MB] = convert(decimal(12,2),round((a.size-fileproperty(a.name,‘SpaceUsed’))/128.000,2)) ,
NAME = left(a.NAME,15), FILENAME = left(a.FILENAME,30)
from dbo.sysfiles a
 
 
-- ESPACIO DISPONIBLE EN LOS DATA FILES SQL SERVER 2005 – 2008
SELECT name
Nombre_Archivo ,size/128.0
- CAST(FILEPROPERTY(name, ‘SpaceUsed’) AS int)/128.0 AS
EspaciodisponibleMB FROM sys.database_files;
 
 
 
 
 
-- —————-
-- MSSQL Agent–
-- —————-
 
sp_help_job  –lista de jobs en msdb
 
-- LISTA DE JOBS FALLIDOS EN SU ULTIMO INTENTO
SELECT name AS [JOBS FALLIDOS] FROM
msdb.dbo.sysjobs
A, msdb.dbo.sysjobservers B
WHERE A.job_id = B.job_id AND B.last_run_outcome = 0
 
-- INFORMACION DE LOS SCHEDULES DE UN JOB
USe msdb;
GO
 
EXEC dbo.sp_help_jobschedule
    @job_name = N’FTM: ActualizaStatusConvenio’,
    @schedule_name =
N’JobActualizaStatusConvenio’ ,
    @Include_description = 1;
 
GO
 
-- Ver un listado de Jobs Deshabilitados:
SELECT name FROM msdb.dbo.sysjobs
WHERE enabled = 0 ORDER BY name
 
-- Permisos necesarios para crear jobs
USE [msdb]
 GO
 CREATE USER
[MyUser] FOR LOGIN
[MyUser]
 GO
 USE [msdb]
 GO
 EXEC sp_addrolemember‘SQLAgentUserRole’, ‘MyUser’
 GO
 
 
 
 
 
 -- ————————–
 -- BACKUP AND RESTORE  —
 -- ————————–
 
 
-- LISTA DE BACKUPS REALIZADOS EN LA INSTANCIA
Select
database_name,server_Name,Machine_Name,b.[name]as Backup_Name,Backup_Start_Date,Backup_Finish_Date
,Physical_Device_Name
from  master.sys.databases a
Inner Join msdb..backupset
b             on
a.Name = b.Database_Name
Inner Join msdb..backupmediafamily
c     on    c.media_set_id
= b.media_set_id
 
-- LISTA DE ULTIMOS RESTORES HECHOS A LA BASE DE DATOS
USE MSDB
GO
SELECT TOP 5 *
FROM
RESTOREHISTORY WITH (nolock)
WHERE (DESTINATION_DATABASE_NAME =
‘NOMBREBD’)
ORDER BY RESTORE_DATE DESC
 
-- ULTIMO RESPALDO HECHO A LA BASE DE DATOS
select
database_name,
max(backup_start_date) as backup_start_date,
max(backup_finish_date) as backup_finish_date from
msdb..backupset
where
database_name=‘your_database’
group by database_name
 
 
-- ULTIMA RESTAURACION HECHA A LA BASE DE DATOS
select
destination_database_name,max(restore_date) as restore_date from msdb..restorehistory
where
destination_database_name=‘your_database’
group by destination_database_name
 
 
 
 
-- ———–
-- INDICES–
-- ———–
 
DBCC DBREINDEX(“HumanResources.Employee”, PK_Employee_EmployeeID,80); --COMO RECONSTRUIR UN INDICE
 
sp_rename @objname = ‘ciclista.PK_ciclista’
, @newname = ‘PK_ciclistarenombrado’,
@objtype = ‘INDEX’   –COMO RENOMBRAR UN INDICE
 
sp_helpindex Ejemplo – VER INDICES SOBRE LA TABLA
 
sp_help Ejemplo   – MOSTRAR INFORMACION SOBRE EL OBJETO
 
-- DEFRAGMENTAR INDICES EN LINEA SQLSERVER 2000
DBCC
INDEXDEFRAG(CS_PACC, “DBO.sotbl_MultPro”, PK_MultPro)
 
-- COMPROBAR NIVEL DE FRAGMENTACION SQLSERVER 2000
USE CS_PACC
GO
DBCC SHOWCONTIG(‘DBO.sotbl_MultPro’)
GO
 
 
 
 
-- ————————–
--  Reporting services  —
-- ————————–
 
-- LISTADO DE LAS SUSCRIPCIONES EXISTENTES
select ‘SubnDesc’ = s.Description,‘ReportPath’= c.Path,
‘SubnOwner’ = us.UserName,‘LastStatus’= s.LastStatus,
‘LastRun’= s.LastRunTime,‘ReportModifiedBy’= uc.UserName,
‘ScheduleId’= rs.ScheduleId,‘SubscriptionId’= s.SubscriptionID
from
ReportServer.dbo.Subscriptions
s
join
ReportServer.dbo.Catalog c on c.ItemID = s.Report_OID
join
ReportServer.dbo.ReportSchedule
rs on rs.SubscriptionID
= s.SubscriptionID
join
ReportServer.dbo.Users
uc on uc.UserID
= c.ModifiedByID
join
ReportServer.dbo.Users
us on us.UserID
= s.OwnerId
join msdb.dbo.sysjobs j on j.name = CONVERT(nvarchar(128),rs.ScheduleId)
 
 
-- INFORMACION DE LAS SUSCRIPCIONES EN TIEMPO DE EJECUCIÓN
select
‘Report’= c.Path, ‘Subscription’ = s.Description,
‘SubscriptionOwner’= uo.UserName,‘SubscriptionModBy’=
um.UserName,
‘SubscriptionModDate’= s.ModifiedDate,‘ProcessStart’= dateadd(hh,DATEDIFF(hh,Getutcdate(),Getdate()),n.ProcessStart),
‘NotificationEntered’= dateadd(hh,DATEDIFF(hh,Getutcdate(),Getdate()),n.NotificationEntered),
‘ProcessAfter’= dateadd(hh,DATEDIFF(hh,Getutcdate(),Getdate()),n.ProcessAfter), n.Attempt,
‘SubscriptionLastRunTime’= dateadd(hh,DATEDIFF(hh,Getutcdate(),Getdate()),n.SubscriptionLastRunTime),
n.IsDataDriven, ‘ProcessHeartbeat’= dateadd(hh,DATEDIFF(hh,Getutcdate(),Getdate()),n.ProcessHeartbeat), n.Version,n.SubscriptionID
from
Notifications n
join
Subscriptions s on n.SubscriptionID
= s.SubscriptionID
join Catalog c on c.ItemID = n.ReportID
join Users uo on uo.UserID = s.OwnerID
join Users um on um.UserID = s.ModifiedByID
 
 
--- INFORME DE LOS REPORTES QUE MAS SE UTILIZAN EN REPORTING SERVICES
SELECT
ex.UserName, ex.Format, ex.TimeStart, cat.Name, ex.Parameters, CONVERT(nvarchar(10), ex.TimeStart, 101) AS rundate
FROM
ExecutionLog AS ex INNER
JOIN
Catalog AS cat ON ex.ReportID = cat.ItemID
ORDER BY ex.TimeStart DESC
–log de report server
Select * from ExecutionLog3
 
 
 
-- ————————–
--  UTILIDADES Y TRUCOS  –
-- ————————–
 
sp_spaceused –ESPACIO USADO POR UN OBJETO
 
 
/* importantando datos desde Excel*/ 
GO 
SELECT orderId, orderDate,
customerId, employeeId INTO
orders FROM OPENDATASOURCE(‘Microsoft.Jet.OLEDB.4.0′, 
‘Data Source=C:\datos.xls;Extended Properties=Excel
8.0′)…[Sheet2$] 
go

/* importantando
los datos para la tabla [ orders ]*/
 
 GO 
 INSERT  INTO EXPERIMENTO select
ID, NOMBRE,
MATERIA   FROM
OPENDATASOURCE(‘Microsoft.Jet.OLEDB.4.0′, 
 ‘Data Source=C:\Libroimportar.xls;Extended Properties=Excel
8.0′)…[IMPORTAR$] where ID NOT IN
 (select ID from EXPERIMENTO)
 go
 
-- COMO RENOMBRAR SERVIDOR/INSTANCIA SQL SERVER
SELECT @@SERVERNAME
sp_dropserver ‘OLD_SERVER’ 
go sp_addserver ‘NEW_SERVER’, ‘local’  go  – POR ULTIMO REINICIAR SERVIDOR
 
 
--  HABILIDAR XP_CMDSHELL
EXEC sp_configure‘show advanced options’,
1  –Permitir
que las opciones avanzadas puedan ser cambiadas.
GO
RECONFIGURE
GO
EXEC sp_configure‘xp_cmdshell’, 1  –Permitir el uso de SP XP_CMDSHELL.
GO
RECONFIGURE
GO
 
-- Espacio en cada disco para la instancia SQL SERVER
EXEC master..xp_fixeddrives
 
 -- —- Ver que comandos estan corriendo actualmente
select session_id, Text
from
sys.dm_exec_requests r
cross
apply sys.dm_exec_sql_text(sql_handle) t
 
 
-- COMPROBAR ESTADO DE SERVICIOS
exec master.dbo.xp_servicecontrol‘QUERYSTATE’, ‘MSSQLServer’
exec master.dbo.xp_servicecontrol‘QUERYSTATE’, ‘SQLServerAgent’
exec master.dbo.xp_servicecontrol‘QUERYSTATE’, ‘SQLBrowser’
exec master.dbo.xp_servicecontrol‘QUERYSTATE’, ‘ReportServer$CSPDBA’
 
 
-- Ver Información de las transacciones abiertas
select * from sys.dm_tran_database_transactions
 
-- Como resetear la semilla de un identity
DBCC CHECKIDENT(‘dbo.Customers’,
RESEED, 1);
 
 
-- INSERTAR RESULTADO DE UN STORED PROCEDURE EN TABLA TEMPORAL Y EVITAR NESTED
CREATE TABLE #MYTEMPO(spid int, ecid int,[status] varchar(200), loginame varchar(200), hostname varchar(200),blk int,
dbname varchar(200),cmd varchar(200))
INSERT INTO #MYTEMPO
SELECT * FROM OPENQUERY(LOCALSERVER, ‘SET FMTONLY OFF EXEC
msdb..sp_help_job’)
select * from #MYTEMPO
 
 
-- CREAR LINKED SERVER
EXEC sp_addlinkedserver@server
= ‘LOCALSERVER’,  @srvproduct = ”,

@provider = ‘SQLOLEDB’, @datasrc = @@servername
                                              
                       
-- BUSCAR POR NOMBRE DE COLUMNA EN UNA BASE DE DATOS                       
SELECT TABLE_NAME,*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
COLUMN_NAME LIKE ‘%a%’
 
 
-- BUSCAR TEXTO EN STORED PROCEDURE
SELECT
ROUTINE_NAME, ROUTINE_DEFINITION, *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE
ROUTINE_DEFINITION LIKE ‘%BranchConvenio%’
AND
ROUTINE_TYPE=‘PROCEDURE’

