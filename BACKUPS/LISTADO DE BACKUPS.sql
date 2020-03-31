select
bs.database_name as TargetDatabase
,bs.backup_start_date as Operation_Date
,cast(datediff(minute,bs.backup_start_date,bs.backup_finish_date)/60 as varchar) + ' hours ' +
cast(datediff(minute,bs.backup_start_date,bs.backup_finish_date)%60 as varchar) + ' minutes ' +
cast(datediff(second,bs.backup_start_date,bs.backup_finish_date)%60 as varchar) + ' seconds'
as [Duration]
,cast(bs.backup_size/1024/1024 as decimal(22,2)) as [BackupSize(MB)]
,'BACKUP' as Operation_Type
,case bs.type
when 'D' then 'Database'
when 'L' then 'Log'
when 'I' then 'Differential'
end as BackupType
,bs.user_name as [User]
,bmf.physical_device_name as BackupFile
,bs.server_name as ServerOrigin
,bs.recovery_model
,bs.begins_log_chain
,bs.is_copy_only
,bms.software_name as BackupSoftware
from msdb.dbo.backupset bs
inner join msdb.dbo.backupmediaset bms
on bs.media_set_id = bms.media_set_id
inner join msdb.dbo.backupmediafamily bmf
on bms.media_set_id = bmf.media_set_id
where bs.database_name = db_name()
and bs.server_name = serverproperty('servername')

union all

select
rh.destination_database_name
,rh.restore_date as operation_date
,'Unknown' as [Duration]
,cast(bs.backup_size/1024/1024 as decimal(22,2)) as [BackupSize(MB)]
,'RESTORE' as Operation_Type
,case rh.restore_type
when 'D' then 'Database'
when 'L' then 'Log'
when 'I' then 'Differential'
end as BackupType
,rh.user_name as [User]
,bmf.physical_device_name as BackupFile
,bs.server_name as ServerOrigin
,bs.recovery_model
,bs.begins_log_chain
,bs.is_copy_only
,bms.software_name as BackupSoftware
from msdb.dbo.backupset bs
inner join msdb.dbo.backupmediaset bms
on bs.media_set_id = bms.media_set_id
inner join msdb.dbo.backupmediafamily bmf
on bms.media_set_id = bmf.media_set_id
inner join msdb.dbo.restorehistory rh
on bs.backup_set_id = rh.backup_set_id
where rh.destination_database_name = db_name()
order by 2 desc