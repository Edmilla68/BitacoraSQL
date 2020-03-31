--**********************************************************************************************************************
--** AUTOR		:   EDUARDO MILLA
--** VERSION	:	3.0
--** NOMBRE		:	Dinamical_index (INCLUYE CREACION DE JOB CON USUARIO sa, se puede comentar si se desea)
--** MANTI001	: 	Debe ser igual al archivo original......
--**
--** ARCHIVO ORIGINAL: 
--**				D:\BITACORA_SQL\INDICES\INDICES DINAMICOS NVERSION_VER3_INC_JOB.sql
--**
--**********************************************************************************************************************

USE Master;
GO
ALTER PROCEDURE Dinamical_index
WITH ENCRYPTION     
AS 
	
IF OBJECT_ID('tempdb..#TODO') IS NOT NULL
    DROP TABLE #TODO
CREATE TABLE #TODO
(
SERV	 VARCHAR(125) NULL,
NOMIDX	 VARCHAR(150) NULL,
NOMTABLA VARCHAR(150) NULL,
)
DECLARE @CODIGO NVARCHAR(4000)

 	DECLARE curDBs CURSOR
	READ_ONLY
	FOR SELECT name, DBID FROM master..sysdatabases WHERE name not in ('master','tempdb','model','msdb','RtcDyn','ReportServer','ReportServerTempDB','Northwind','pubs')

	DECLARE @name varchar(256)
	DECLARE @DBID INTEGER
	OPEN curDBs

	FETCH NEXT FROM curDBs INTO @name, @DBID
	WHILE (@@fetch_status <> -1)
	BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN
	   set @CODIGO  =			'USE '+@name + CHAR(13)+
								'INSERT #TODO '	+ CHAR(13)+
								'SELECT '''+@name+''',  D.NAME, C.name ' + CHAR(13)+ 
								'FROM sys.dm_db_index_physical_stats ('+convert(varchar,@DBID)+', NULL, NULL, NULL, ''limited'')AS A ' + CHAR(13)+
								'LEFT JOIN SYS.DATABASES B ' + CHAR(13)+
								'ON A.DATABASE_iD = B.DATABASE_ID ' + CHAR(13)+
								'LEFT JOIN SYS.OBJECTS C ' + CHAR(13)+
								'ON A.OBJECT_iD = C.OBJECT_iD ' + CHAR(13)+
								'LEFT JOIN SYS.INDEXES D ' + CHAR(13)+
								'ON A.OBJECT_iD = D.OBJECT_iD AND A.index_id = D.index_id ' + CHAR(13)+
								'WHERE avg_fragmentation_in_percent > 20 ' + CHAR(13)+
								'and index_type_desc <> ''HEAP'' ' + CHAR(13)+
								'and index_level = 0 ' + CHAR(13)+
								'and page_count > 300 '  + CHAR(13)+
								'order by avg_fragmentation_in_percent desc '
	   
	   EXEC(@CODIGO)
	   END
	   FETCH NEXT FROM curDBs INTO @name, @DBID
	END
	CLOSE curDBs
	DEALLOCATE curDBs

--*****************************************************
 	DECLARE @SCR_FIN NVARCHAR(4000)
 	
 	DECLARE curfin CURSOR
	READ_ONLY
	FOR SELECT serv, nomidx, nomtabla FROM #TODO


	DECLARE @serv varchar(256)
	DECLARE @nomidx varchar(256)
	DECLARE @nomtabla varchar(256)
	
	OPEN curfin

	FETCH NEXT FROM curfin INTO @serv, @nomidx, @nomtabla
	WHILE (@@fetch_status <> -1)
	BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN

		IF SUBSTRING(@nomidx,1,1) <> '<'
			BEGIN
			SET @SCR_FIN = 'USE '+@serv+'  ALTER INDEX  '+ @nomidx +'  ON  ' + @nomtabla +'  REORGANIZE'+CHAR(13) 
			END

			BEGIN TRY 
				EXEC (@SCR_FIN)
			END TRY
			BEGIN CATCH
				SET @SCR_FIN = 'USE '+@serv+'  ALTER INDEX  '+ @nomidx +'  ON  ' + @nomtabla +'  SET (allow_page_locks = ON)'+CHAR(13)
				EXEC (@SCR_FIN)
			END CATCH
		
		END
	   FETCH NEXT FROM curfin INTO @serv, @nomidx, @nomtabla
	END
	CLOSE curfin
	DEALLOCATE curfin

DROP TABLE #TODO
GO


/*
------------------CREACION DE JOB 
*/


USE [msdb]
GO

/****** Object:  Job [Mant_indices_din]    Script Date: 01/28/2016 09:52:31 ******/
DECLARE  @JOBIDT VARCHAR(50)
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'Mant_indices_din')
	BEGIN
	   SELECT @JOBIDT = job_id FROM msdb.dbo.sysjobs_view WHERE name = N'Mant_indices_din'
		EXEC msdb.dbo.sp_delete_job @job_id= @JOBIDT , @delete_unused_schedule=1
	END 
GO

USE [msdb]
GO

/****** Object:  Job [Mant_indices_din]    Script Date: 01/28/2016 09:52:31 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 01/28/2016 09:52:31 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Mant_indices_din', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Paso1]    Script Date: 01/28/2016 09:52:31 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Paso1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'execute [Dinamical_index]', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CadaDia', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150903, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

