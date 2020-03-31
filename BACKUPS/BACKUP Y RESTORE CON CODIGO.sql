-- Tener cuidado con las rutas y nombres de archivo no avisa para chancar el file

BACKUP DATABASE ofipres  
   TO DISK = '\\lulas-system001\backup2\ofipres.Bak';
GO

				--VARIANTE

				BACKUP DATABASE GNeptuniaCitas  
				   TO DISK = '\\dvw12mgrsql12\bkp\GNeptuniaCitas.Bak';
				GO

				
RESTORE DATABASE OFIPRES
   FROM DISK = '\\lulas-system001\backup\ofipres.Bak';
GO




//***************************************************************************************
//*   RESTORE con archivos fisicos reubicados... porque no tienen la misma ubicacion
//**************************************************************************************
*/

USE [master]
ALTER DATABASE [OCEP1_Descarga_Paita] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE [OCEP1_Descarga_Paita] FROM  DISK = N'\\Lulas-system001\backup\OCEANICAP1_Descarga.Bak' WITH  FILE = 1,  
MOVE N'descargab1_datData'  TO N'D:\DATABASE\OCEP1_Descarga.mdf',  
MOVE N'descargab1_datDatae' TO N'D:\DATABASE\OCEP1_Descargab1.Mdf',  
MOVE N'descargab1_log'      TO N'E:\LOG\OCEP1_Descarga_1.ldf', 
NOUNLOAD,  REPLACE,  STATS = 5

ALTER DATABASE [OCEP1_Descarga_Paita] SET MULTI_USER

GO




//***************************************************************************************
//*   Monitora como va el proceso de BACKUP Y/O RESTORE
//**************************************************************************************
*/


SELECT r.session_id,
		r.database_id,
		d.name,
       r.command Comando,
       CONVERT(NUMERIC(10, 2), r.percent_complete) AS 'Porcentaje',
       CONVERT(NUMERIC(10,2), r.total_elapsed_time / 1000.0 / 60.0) AS 'Tiempo transcurrido',
       CONVERT(VARCHAR(20), Dateadd(ms, r.estimated_completion_time, Getdate()),20) AS 'Estimado finalización',
       CONVERT(NUMERIC(10, 2), r.estimated_completion_time/1000.0/60.0) AS 'Minutos pendientes',
       CONVERT(NUMERIC(10,2), r.estimated_completion_time/1000.0/60.0/60.0) AS 'Horas pendientes'
FROM  sys.dm_exec_requests r
LEFT JOIN sys.databases d
	ON r.database_id = d.database_id
WHERE r.command IN (
         'RESTORE VERIFYON', 'RESTORE DATABASE',
         'BACKUP DATABASE','RESTORE LOG','BACKUP LOG', 
         'RESTORE HEADERON', 'DbccFilesCompact')
         





		 
		 
valor
“HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp -> PathWWWRoot value to 

%SystemDrive%\inetpub\wwwroot		 
		 
--ping de la muerte
-- ping 198.57.163.228 -t -l 1472


CALW8BDFCT001