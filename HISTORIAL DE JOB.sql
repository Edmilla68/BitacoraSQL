USE msdb

declare @jobid    varchar(500)
declare @jobname varchar(500)

SET @jobname = 'NOMBRE DEL JOB'

select @jobid  = job_id from dbo.sysjobs
WHERE name = @jobname 


SELECT * FROM sysjobhistory
WHERE job_id = @jobid

SELECT * FROM sysjobactivity
WHERE job_id = @jobid