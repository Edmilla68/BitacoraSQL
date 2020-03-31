EXEC msdb.dbo.sp_send_dbmail  
@profile_name = 'Alertas',  
@recipients = 'evelyn.vera@dpworldlogistics.pe; eduardo.milla-lulassystem@dpworldlogistics.pe', 
@body = 'Este es un msj de prueba', 
@subject = 'TEST001',
@file_attachments='\\10.100.16.190\ElvisHuallpa\compartido\OrdenesRetiroPendientes_20191115_101824.xls';