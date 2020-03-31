USE [master]
GO

/****** Object:  StoredProcedure [dbo].[DiskFreeSpaceAlert]    Script Date: 08/21/2017 11:39:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DiskFreeSpaceAlert]
@DriveCBenchmark int= 1024,
@OtherDataDriveBenchmark int= 10240,
@ProfileName sysname='CDCPerfil',
@Recipients NVARCHAR(1000)= 'ggonzales@losandesgold.com; hsuarez@losandesgold.com; mcondor@losandesgold.com; mmaciso@losandesgold.com'

--'falfaro@cdm.pe; mmaciso@losandesgold.com; eduardo.milla@gmail.com'

AS 

BEGIN
--Primer Correo 
IF EXISTS(SELECT * FROM tempdb..sysobjects
WHERE id =object_id(N'[tempdb]..[##disk_free_space]'))
DROP TABLE ##disk_free_space
CREATE TABLE ##disk_free_space(
     DriveLetter CHAR(1) NOT NULL,
     FreeMB INTEGER NOT NULL)
 
DECLARE @DiskFreeSpace INT
DECLARE @DriveLetter CHAR(1)
DECLARE @AlertMessage VARCHAR(500)
DECLARE @MailSubject VARCHAR(100)
 
INSERT INTO ##disk_free_space
EXEC master..xp_fixeddrives
 
SELECT @DiskFreeSpace = FreeMB FROM ##disk_free_space where DriveLetter ='C'
 
SET @MailSubject =''+@@SERVERNAME+' Analisis de discos'
EXEC msdb..sp_send_dbmail @profile_name=@ProfileName,
@recipients = @Recipients,
@subject = @MailSubject,
@query=N'SELECT DriveLetter,CAST(CAST(CAST(FreeMB AS DECIMAL(18,2))/CAST(1024 AS DECIMAL(18,2)) AS DECIMAL(18,2)) AS VARCHAR(20)) +'' GB '' SpaceAvailable FROM ##disk_free_space'

--Segundo Correo 
/* Get db sizes */
DECLARE @dbName sysname
CREATE TABLE ##TempDBNames(
DatabaseName sysname,
DATABASE_SIZE int,
REMARKS varchar(254))
INSERT INTO ##TempDBNames
EXEC sp_databases
 
CREATE TABLE ##DBInfo(
dbName sysname,
name sysname,
filepath sysname,
dbType VARCHAR(10),
dbSize INT,
DataModified DATETIME
)
 
DECLARE dbs CURSOR FOR
SELECT DatabaseName FROM ##TempDBNames WHERE LEN(DatabaseName) < 45 and DatabaseName not in ('master', 'model', 'msdb',  'ReportServer',  'ReportServerTempDB',  'tempdb', 'Sofya Base')
 
open dbs
fetch next from dbs into @dbName
WHILE (@@FETCH_STATUS= 0)
Begin
EXEC ('USE '+ @dbName +' INSERT INTO ##DBInfo SELECT '''+ @dbName +''',name,physical_name,type_desc,size,(SELECT MAX(modify_date) FROM sys.tables) LastModified FROM sys.database_files')
fetch next from dbs into @dbName
End
close dbs
deallocate dbs
 
SET @MailSubject =''+@@SERVERNAME+' Analisis BaseDatos'
EXEC msdb..sp_send_dbmail @profile_name=@ProfileName,
@recipients = @Recipients,
@subject = @MailSubject,
@query=N'SELECT dbName,dbType,(dbSize*8)/1024 dbSize,''MB'', DataModified FROM ##DBInfo'
 
DROP TABLE ##DBInfo
DROP TABLE ##TempDBNames
/* End get dbsizes */

--Tercer Correo  
		IF @DiskFreeSpace < @DriveCBenchmark
		Begin
		SET @MailSubject ='Drive C poco espacio disponible en '+@@SERVERNAME
		SET @AlertMessage ='Drive C en '+@@SERVERNAME+' solo tiene '+  CAST(@DiskFreeSpace AS VARCHAR)+' MB libres. Por favor libere espacio en este Drive. La Unidad C suele tener el SO instalado. Poco espacion en C puede dañar la prformance del servidor'
		 
		EXEC msdb..sp_send_dbmail @profile_name=@ProfileName,
		@recipients = @Recipients,
		@subject = @MailSubject,
		@body = @AlertMessage
		End
 
 
--Cuarto Correo  
DECLARE DriveSpace CURSOR FAST_FORWARD FOR
select DriveLetter, FreeMB from ##disk_free_space where DriveLetter not in('C')
 
open DriveSpace
fetch next from DriveSpace into @DriveLetter,@DiskFreeSpace
 
WHILE (@@FETCH_STATUS= 0)
Begin
if @DiskFreeSpace <@OtherDataDriveBenchmark
Begin
set @MailSubject ='Drive '+ @DriveLetter +' poco espacio libre en '+@@SERVERNAME
set @AlertMessage = @DriveLetter +' solo tiene '+cast(@DiskFreeSpace as varchar)+' MB disponibles. Por favor incremente el espacio disponible para este drive inmediatamente para evitar problemas en produccion'
 
EXEC msdb..sp_send_dbmail @profile_name=@ProfileName,
@recipients = @Recipients,
@subject = @MailSubject,
@body = @AlertMessage
End
fetch next from DriveSpace into @DriveLetter,@DiskFreeSpace
End
close DriveSpace
deallocate DriveSpace
DROP TABLE ##disk_free_space



END
GO

