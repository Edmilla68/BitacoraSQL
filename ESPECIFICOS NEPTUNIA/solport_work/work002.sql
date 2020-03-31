select id,
idUsuario, PC, FechaHora,FechaInicioSesion, 
DATEDIFF([minute],FechaInicioSesion,GETDATE()) as minutos, 
DATEDIFF([minute],FechaInicioSesion,GETDATE()) / 60 as horas_aprox
from spsiusuariosconectados