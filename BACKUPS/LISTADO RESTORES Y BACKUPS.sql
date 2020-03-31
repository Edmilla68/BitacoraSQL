
--   // RESTORES

select
Base= b.database_name,
HoraRestauración=rh.restore_date
,TamañoMB=convert(decimal(15,2), b.backup_size /1048576)
,case  b.type
  when 'D' then 'Total'
  when 'L' then 'Log'
  when 'I' then 'Diferencial'
  end as Tipo,
Usuario=rh.user_name ,
ModoRecuperación= b.recovery_model,
RutaOrigen=f.physical_device_name ,
BaseDestino=rh.destination_database_name
from msdb.dbo.backupset  b
inner join msdb.dbo.backupmediaset s on  b.media_set_id = s.media_set_id
inner join msdb.dbo.backupmediafamily f on s.media_set_id = f.media_set_id
inner join msdb.dbo.restorehistory rh on  b.backup_set_id = rh.backup_set_id



--       //  BACKUPS


select
Base= b.database_name,
HoraInicio= b.backup_start_date
,Duracion=convert(varchar,dateadd(ms,DATEDIFF (ms, b.backup_start_date, b.backup_finish_date),'01/01/1900'),108)
,TamañoMB=convert(decimal(15,2), b.backup_size /1048576)
,case  b.type
  when 'D' then 'Total'
  when 'L' then 'Log'
  when 'I' then 'Diferencial'
  end as Tipo,
Usuario= b.user_name,
Servidor= b.server_name,
ModoRecuperación= b.recovery_model,
RutaDestino=f.physical_device_name ,
EsSoloCopia= b.is_copy_only
from msdb.dbo.backupset  b
inner join msdb.dbo.backupmediaset s on  b.media_set_id = s.media_set_id
inner join msdb.dbo.backupmediafamily f on s.media_set_id = f.media_set_id