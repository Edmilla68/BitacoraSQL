select id, Usuario, Nombre + ' ' + Apellidos, Cancelado  from spsiusuario
select id, Nombre from [dbo].[spsigrupousuarios]


select * from [dbo].[spsigrupousuarios]


select US.Id, GP.Id from spsiusuario US
left join [spsigrupousuarios]  GP ON GP.Id = US.IdGrupo