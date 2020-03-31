-- 
SELECT users.name Usuario, groups.name Rol
FROM sysmembers membs 
JOIN sysusers users on membs.memberuid = users.uid 
JOIN sysusers groups on membs.groupuid = groups.uid 
order by users.name 
--where users.name = 'gorepositorio'


/*
-- OTRA VERSION

SELECT p.NAME
,m.NAME
FROM sys.database_role_members rm
JOIN sys.database_principals p
ON rm.role_principal_id = p.principal_id
JOIN sys.database_principals m
ON rm.member_principal_id = m.principal_id

*/



/*

-- Y OTRA MAS....

select 
[Login Type]=
case sp.type
when 'u' then 'WIN'
when 's' then 'SQL'
when 'g' then 'GRP'
end,
convert(char(45),sp.name) as srvLogin, 
convert(char(45),sp2.name) as srvRole,
convert(char(25),dbp.name) as dbUser,
convert(char(25),dbp2.name) as dbRole
from 
sys.server_principals as sp join
sys.database_principals as dbp on sp.sid=dbp.sid join
sys.database_role_members as dbrm on dbp.principal_Id=dbrm.member_principal_Id join
sys.database_principals as dbp2 on dbrm.role_principal_id=dbp2.principal_id left join 
sys.server_role_members as srm on sp.principal_id=srm.member_principal_id left join
sys.server_principals as sp2 on srm.role_principal_id=sp2.principal_id

*/