
SELECT * FROM CALW8IS001.msdb.dbo.sysjobactivity A
					INNER JOIN CALW8IS001.msdb.dbo.sysjobs B ON A.job_id = B.job_id
					WHERE B.name = 'N2_Estado_Carga'	AND stop_execution_date IS NULL
				
				
SELECT * FROM CALW8IS001.msdb.dbo.sysjobactivity A
					INNER JOIN CALW8IS001.msdb.dbo.sysjobs B ON A.job_id = B.job_id
					WHERE B.name = 'N2_Estado_Carga_Lineas'	AND stop_execution_date IS NULL


--delete FROM CALW8IS001.msdb.dbo.sysjobactivity 
--where job_id = '79FF7871-AFE3-4A15-A783-6541D2B1677F'AND stop_execution_date IS NULL

--delete FROM CALW8IS001.msdb.dbo.sysjobactivity 
--where job_id = '56565545-A448-4A64-9D47-BCBAE5A3AB72'AND stop_execution_date IS NULL

					
