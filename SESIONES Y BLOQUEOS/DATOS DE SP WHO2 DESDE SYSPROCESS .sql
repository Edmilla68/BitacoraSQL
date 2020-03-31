sp_who2 active

select spid, status, cmd, *
from master..sysprocesses
where hostname = 'CALLP3592'

--DBCC INPUTBUFFER (spid)

-- ESTA CONSULTA ES EQUIVALENTE A SP_WHO2 ACTIVE
	select hostname,status, * 
	from master..sysprocesses
	where len(hostname) <= 0
	union
	select hostname,status, * 
	from master..sysprocesses
	where len(hostname) > 0
	and status <> 'sleeping'



-- listo para monitorear por CPU

select spid, status, cmd, *
from master..sysprocesses
where status <> 'sleeping'
order by CPU desc

select sum(cpu)
from master..sysprocesses
where status <> 'sleeping'

