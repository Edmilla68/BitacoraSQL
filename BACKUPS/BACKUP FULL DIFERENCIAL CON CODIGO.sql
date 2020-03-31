-- Code to backup a database
/*
These statements will create full, diff and log backups of the database to filenames
<dbname>_<type>_yyyymmdd_hhmmss.bak
This makes it easy to restore the correct backups and also to delete out of date files.
*/


-- Full Backup

declare @Path varchar(500) ,
		@DBName varchar(128)

select @DBName = 'msdb'
select @Path = 'c:\backups\'

declare		@FileName varchar(4000)
		select @FileName = @Path + @DBName + '_Full_'
							+ convert(varchar(8),getdate(),112) + '_'
							+ replace(convert(varchar(8),getdate(),108),':','')
							+ '.bak'

			backup database @DBName
				to disk = @FileName


-- Diff Backup


declare @Path varchar(500) ,
		@DBName varchar(128)

select @DBName = 'msdb'
select @Path = 'c:\backups\'

declare		@FileName varchar(4000)
		select @FileName = @Path + @DBName + '_Diff_'
							+ convert(varchar(8),getdate(),112) + '_'
							+ replace(convert(varchar(8),getdate(),108),':','')
							+ '.bak'

			backup database @DBName
				to disk = @FileName
				with differential 


-- Log Backup


declare @Path varchar(500) ,
		@DBName varchar(128)

select @DBName = 'msdb'
select @Path = 'c:\backups\'

declare		@FileName varchar(4000)
		select @FileName = @Path + @DBName + '_Log_'
							+ convert(varchar(8),getdate(),112) + '_'
							+ replace(convert(varchar(8),getdate(),108),':','')
							+ '.bak'

			backup log @DBName
				to disk = @FileName