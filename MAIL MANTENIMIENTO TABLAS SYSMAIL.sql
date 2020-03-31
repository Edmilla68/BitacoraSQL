--select * from sysmail_account

--select * from sysmail_profile

--select * from sysmail_event_log
--order by log_date desc

--select * from sysmail_allitems
--order by sent_date desc


declare @FECHA_D datetime
select @FECHA_D  = DATEADD(month,-3,getdate()) ;  

EXECUTE msdb.dbo.sysmail_delete_mailitems_sp   
    @sent_before = @FECHA_D  
GO

--select DATEADD(month,-3,getdate())