select * from AlertaGPSTemp
where year(fechaenvio) > 2014

select * from dbo.AlertaGPSTemp
where fechaenvio>dateadd(d, -95,getdate())  
