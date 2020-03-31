select 
d.name, s.name, s.filename 
from sysaltfiles s 
inner join sysdatabases d
on (s.dbid = d.dbid)
order by 1, 2, 3


select * from sysdatabases