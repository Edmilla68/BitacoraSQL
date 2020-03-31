SELECT 
[Table] = OBJECT_NAME(o.parent_obj), 
[Trigger]	= o.[name], 
[Type]		= CASE WHEN ( SELECT cmptlevel FROM master.dbo.sysdatabases WHERE [name] = DB_NAME() ) = 80 THEN CASE WHEN OBJECTPROPERTY(o.[id], 'ExecIsInsteadOfTrigger') = 1 THEN 'Instead Of' ELSE 'After' END ELSE 'After' END, 
[Insert]	= CASE WHEN OBJECTPROPERTY(o.[id], 'ExecIsInsertTrigger') = 1 THEN 'Yes' ELSE 'No' END, 
[Update]	= CASE WHEN OBJECTPROPERTY(o.[id], 'ExecIsUpdateTrigger') = 1 THEN 'Yes' ELSE 'No' END, 
[Delete]	= CASE WHEN OBJECTPROPERTY(o.[id], 'ExecIsDeleteTrigger') = 1 THEN 'Yes' ELSE 'No' END, 
[Enabled?]	= CASE WHEN OBJECTPROPERTY(o.[id], 'ExecIsTriggerDisabled') = 0 THEN 'Enabled' ELSE 'Disabled' END 
FROM sysobjects o WHERE OBJECTPROPERTY(o.[id], 'IsTrigger') = 1 
-- leave out the following clause if you need to -- include system triggers, e.g. those in MSDB AND OBJECTPROPERTY(o.[id], 'IsMSShipped') = 0 ORDER BY 1,2