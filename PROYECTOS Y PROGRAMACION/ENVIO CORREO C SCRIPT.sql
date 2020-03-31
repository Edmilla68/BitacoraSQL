--USE [msdb]
      
      
EXEC msdb.dbo.sp_send_dbmail @profile_name='AdministradorTarjita',    
    @recipients= 'eduardo.milla-lulassystem@neptunia.com.pe; marvin.zambrano@neptunia.com.pe' ,   
    @subject= 'Sitema WMS-FWD TARJA / Finalización de Tarja ',    
    @body= 'Una prueba mas... este es correo a varias cuentas...' 
    
   /* 
    If you're using SQL Server 2008, in Object explorer for SS Management Studio go to your server and go to Management ... 
    Sql Server Logs ... Database Mail and double click to run the Wizard. 
     Select "Manage Profile Security" then check the "public" checkbox by your profile.
     */