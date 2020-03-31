-- INICIOS DE SESION Y USUARIOS

select sid, name
from master..syslogins

select uid, name, sid
from sysusers
where islogin=1