USE [EnvioLineas]
GO

/****** Object:  UserDefinedFunction [dbo].[MFTK_Funcion_Formulador]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[MFTK_Funcion_Formulador](@CADENA VARCHAR(100),@CHAR VARCHAR(1))
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL INT, @CONT INT, @CHAR_ VARCHAR(1), @I INT
	SELECT @TOTAL = LEN(@CADENA)
	SET @I = 1
	SET @CONT = 0
	WHILE (@I <= @TOTAL)
	BEGIN
		IF (SUBSTRING(@CADENA,@I,1) = @CHAR)
		BEGIN
			SET @CONT = @CONT + 1
		END
		SET @I = @I + 1
	END
	RETURN @CONT
END
GO
/****** Object:  View [dbo].[LIN_SALIDAS_sinlock]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SELECT * FROM LIN_SALIDAS_sinlock WHERE CONTENEDOR='FSCU3504597'

--ALTER VIEW [dbo].[LIN_SALIDAS_sinlock]    --FMCR  
--AS      
      
----  SELECT TOP 20 * FROM LIN_SALIDAS      
------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
  
----------------------------------------------          
---- EMBARQUES AL PUERTO        
      
--SELECT DISTINCT        
--'COD_INT'=a.genbkg13,                      
--'CONTENEDOR'= D.codcon04,                      
--'FECHA'= CONVERT (char(4), dateadd(dd,0, g.fecsal99), 121 )+                                     
--substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),6,2) +                                    
--substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),9,2) + ' ' +                                    
--substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),12,5)     ,      
--'FEC_SINFORMATO'=g.fecsal99,      
--'LINEA' = 'HLE',          
--'EVENTO'='0715',      
--'GUIA_EIR'=G.nrogui99,      
--'TIPSALIDA'='EMBARQUE'      
--FROM   oceanicap1.DESCARGA.DBO.ADGUIASR99  G , oceanicap1.DESCARGA.DBO.arguicon99 D  , oceanicap1.DESCARGA.DBO.admovctr09 a   
--WHERE  G.nrogui99 = D.nrogui99   and d.codcon04 = a.codcon04 and d.nrosec09 = a.nrosec09 and                      
--d.codarm10='HLE' and                       
----g.fecsal99>=@fecha_ini and g.fecsal99<@fecha_fin and                      
--G.motivo99 in ('E','W')  and                             
--G.status99 = 'E'          
--    --   
--------------------------------------------------------          
--UNION                              
      
---- LLENADOS - ENVIO DE MOVILIZADOS PARA LLENADO SE ENVIAN LUEGO DEL 1ER LLENADO         
--select DISTINCT
--'COD_INT'=b.genbkg13,        
--'CONTENEDOR'=b.codcon04,        
--'FECHA'= min( CONVERT (char(4), r.fecsal18, 121 )+                               --B.feclln16    
--substring(CONVERT (char(20), r.fecsal18, 121 ),6,2) +                                  
--substring(CONVERT (char(20), r.fecsal18, 121 ),9,2) + ' ' +                                  
--substring(CONVERT (char(20), r.fecsal18, 121 ),12,5)     ),    
--'FEC_SINFORMATO'=MIN(r.fecsal18),
--'LINEA' = 'HLE',        
--'EVENTO'='0715', -- Para HLE las movilizaciones salen desde el 1er llenado    
--'GUIA_EIR'='LLENADO',      
--'TIPSALIDA'='MOVILIZACION'    
--from              
--NEPTUNIAP2.DESCARGA.DBO.edllenad16 b     
--inner join NEPTUNIAP2.DESCARGA.DBO.edbookin13 e  on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                          
--inner join NEPTUNIAP2.DESCARGA.DBO.DDTICKET18 r on b.nrotkt18=r.nrotkt18    
--where                 
--e.codarm10 = 'HLE' and     
--r.fecsal18 is not null and    
----r.fecsal18>=@fecha_ini and r.fecsal18<@fecha_fin and               
--b.codemb06<>'CTR'     
----AND B.CODCON04='FSCU3504597'
--group by b.genbkg13,b.codcon04--,r.fecsal18    
      
---------------------------------------------          
      
--union                
      
---- SALIDA A PLANTA CLIENTE: EMITE EIR        
--select distinct    
--'COD_INT'=b.genbkg13,                  
--'CONTENEDOR'= b.codcon04,   -- a.FECMOV09               
--'FECHA'= CONVERT (char(4), isnull(a.tiempoFinal,b.FECMOV09), 121 )+                                 
--substring(CONVERT (char(20), isnull(a.tiempoFinal,b.FECMOV09), 121 ),6,2) +                                
--substring(CONVERT (char(20), isnull(a.tiempoFinal,b.FECMOV09), 121 ),9,2) + ' ' +                                
--substring(CONVERT (char(20), isnull(a.tiempoFinal,b.FECMOV09), 121 ),12,5),  
--'FEC_SINFORMATO'=isnull(a.tiempoFinal,b.FECMOV09),--isnull(b.FECMOV09,b.fecsal09),  
--'LINEA' = 'HLE',      
--'EVENTO'='0715', -- Para HLE 0800 se consideran como 0715    
--'GUIA_EIR'=a.eir,      
--'TIPSALIDA'='CLIENTE'    
--from oceanicap1.DESCARGA.DBO.pdt_asignacion a , oceanicap1.DESCARGA.DBO.admovctr09 b , oceanicap1.DESCARGA.DBO.adconten04 c    
--where                         
--a.contenedor = b.codcon04 and a.booking = b.genbkg13 and                     
--a.contenedor = c.codcon04 and                         
--b.codcon04 = c.codcon04 and                        
--b.codarm10='HLE'                  
----and b.fecSAL09>=@fecha_ini     and b.fecSAL09<@fecha_fin                  
--and a.eir is not null and a.destino = 3       
----and a.contenedor ='CPSU5172664'  
  
---------------------------------------------------------------------------------               
--GO
/****** Object:  View [dbo].[LIN_VALIDA_EVENTOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[LIN_VALIDA_EVENTOS]
AS

	SELECT               
	b.idregistro,          
	d.codigo sCodEve,           
	e.codigo sCodLin,          
	b.contenedor sNroCtr,        
	CONVERT (char(4), B.fechaevento, 121 )+                                 
	substring(CONVERT (char(20), B.fechaevento, 121 ),6,2) +                                
	substring(CONVERT (char(20), B.fechaevento, 121 ),9,2) + ' ' +                                
	substring(CONVERT (char(20), B.fechaevento, 121 ),12,5)    sFecReg ,          
	b.estado          
	FROM LIN_REGISTRO (NOLOCK) b          
	inner join LIN_evento (NOLOCK) d on b.idevento=d.idevento          
	inner join lin_linea (NOLOCK) e on b.idlinea=e.idlinea          
	where          
	--b.contenedor=@sNroCtr    
	b.idregistro is not null    
	AND d.codigo is not null    
	AND e.codigo is not null    
	AND b.contenedor is not null    
	AND B.fechaevento is not null    
	AND b.estado is not null    
GO
/****** Object:  View [dbo].[LIN_VALIDA_EVENTOS_X]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[LIN_VALIDA_EVENTOS_X]
AS

	SELECT               
	b.idregistro,          
	d.codigo sCodEve,           
	e.codigo sCodLin,          
	b.contenedor sNroCtr,        
	CONVERT (char(4), B.fechaevento, 121 )+                                 
	substring(CONVERT (char(20), B.fechaevento, 121 ),6,2) +                                
	substring(CONVERT (char(20), B.fechaevento, 121 ),9,2) + ' ' +                                
	substring(CONVERT (char(20), B.fechaevento, 121 ),12,5)    sFecReg ,          
	b.estado          
	FROM LIN_REGISTRO  b          
	inner join LIN_evento d on b.idevento=d.idevento          
	inner join lin_linea e on b.idlinea=e.idlinea          
	where          
	--b.contenedor=@sNroCtr    
	b.idregistro is not null    
	AND d.codigo is not null    
	AND e.codigo is not null    
	AND b.contenedor is not null    
	AND B.fechaevento is not null    
	AND b.estado is not null    
GO
/****** Object:  View [dbo].[NEP_Evento_0200]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[NEP_Evento_0200]
AS
select distinct 'COD_INT'=a.navvia11, 'CONTENEDOR'=a.codcon04,'ISOCONTENEDOR'= b.isocod04,      
'BOOKING'='00000', 'FECHA'=a.fecing18,'PESO'= b.pesbrt04*1000, 
'CLIENTE'='TO ORDER' ,
'LINEA' = b.codarm10,
case 
when b.codarm10 = 'HSD' then 1
when b.codarm10 = 'HLE' then 2
else null end as IdLinea
from [SP3TDA-DBSQL01].Terminal.dbo.ddticket18 a (nolock)                
inner join [SP3TDA-DBSQL01].Terminal.dbo.ddconten04 b (nolock) on (b.navvia11=a.navvia11 and b.codcon04=a.codcon04)                
where                 
a.tipope18='D' 
--and b.codarm10=@sCodLin                
--and a.fecing18>=@FecInicio and a.fecing18<@FecFin              
and b.transb04 <> '1'
GO
/****** Object:  View [dbo].[NEP_Evento_0230]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[NEP_Evento_0230]
AS
SELECT DISTINCT 'COD_INT'=A.NAVVIA11, 'CONTENEDOR'=B.CODCON04,           
'ISOCONTENEDOR'= C.ISOCOD04, 'BOOKING'='00000', 'FECHA'=A.FECSAL18,          
'PESO'= C.PESBRT04*1000, 'CLIENTE'=E.NOMBRE, 'LINEA' = C.CODARM10, 
case 
when c.codarm10 = 'HSD' then 1
when c.codarm10 = 'HLE' then 2
else null end as IdLinea
       
FROM [SP3TDA-DBSQL01].Terminal.dbo.DDTICKET18 A (NOLOCK)          
INNER JOIN [SP3TDA-DBSQL01].Terminal.dbo.DRBLCONT15 B (NOLOCK) ON (A.NROTKT18=B.NROTKT28)          
INNER JOIN [SP3TDA-DBSQL01].Terminal.dbo.DDCONTEN04 C (NOLOCK) ON (B.NAVVIA11=C.NAVVIA11 AND B.CODCON04=C.CODCON04)          
INNER JOIN [SP3TDA-DBSQL01].Terminal.dbo.DDFACTUR37 D (NOLOCK) ON (B.NAVVIA11=D.NAVVIA11 AND B.NRODET12=D.NRODET12)          
INNER JOIN [SP3TDA-DBSQL01].Terminal.dbo.AACLIENTESAA E (NOLOCK) ON (D.RUCCLI12=E.CONTRIBUY)          
WHERE A.TIPOPE18='R' 
--AND C.CODARM10=@SCODLIN 
AND C.CODBOL03='FC' 
--AND A.FECSAL18>=@FECINICIO 
--AND A.FECSAL18<@FECFIN 
AND D.STATUS37<>'A'  
AND D.CODSER15<>'FFI'  
AND B.CODCON04 IN (SELECT CODCON04_S FROM [SP3TDA-DBSQL01].Terminal.dbo.GDTABEVE_MAIN_01 WHERE FECEVE04_G IS NULL)        
UNION          
SELECT DISTINCT 'COD_INT'=A.NAVVIA11, 'CONTENEDOR'=B.CODCON04,           
'ISOCONTENEDOR'= B.ISOCOD04, 'BOOKING'='00000', 'FECHA'=A.FECSAL63,          
'PESO'= A.PESBRT63*1000, 'CLIENTE'='TO ORDER','LINEA' = A.CODARM10,
case 
when a.codarm10 = 'HSD' then 1
when a.codarm10 = 'HLE' then 2
else null end as IdLinea            
FROM          
[SP3TDA-DBSQL01].Terminal.dbo.DDCONTAR63 A (NOLOCK)          
INNER JOIN [SP3TDA-DBSQL01].Terminal.dbo.DDCONTEN04 B (NOLOCK) ON (A.NAVVIA11=B.NAVVIA11 AND A.CODCON04=B.CODCON04)          
WHERE B.CODBOL03='LC' 
--AND FECSAL63>=@FECINICIO 
--AND A.FECSAL63<@FECFIN          
--AND A.CODARM10=@SCODLIN
GO
/****** Object:  View [dbo].[NEP_Evento_0400_HLE]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_0400_HLE]
--as
--
------ ANTIGUO ---------------------------------
----select codcon04 as Contenedor,fecing09 as Fecha 
----from Oceanica1.Descarga.dbo.admovctr09 
----where codarm10='HLE' and estini09 like 'O%'
--
--select codcon04 as Contenedor,fecing09 as Fecha 
--from Oceanica1.Descarga.dbo.admovctr09 
--where 
----codarm10='HLE' and estini09 like 'O%'
--codarm10='HLE' and not (estini09 like 'D%')    
--GO
/****** Object:  View [dbo].[NEP_Evento_0400_HSD]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_0400_HSD]
--AS
--
--SELECT DISTINCT                               
--'COD_INT'=a.nrosec09,                                        
--'CONTENEDOR'=a.codcon04,                                        
--'BOOKING'='00000',                                       
--'FECHA'= isnull(b.fecins15,a.fecing09)                                         
--FROM                                        
--OCEANICA1.DESCARGA.DBO.ADMOVCTR09 a (nolock)                                          
--inner join OCEANICA1.DESCARGA.DBO.ADREGEIR15 b (nolock) on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09)   
--inner join OCEANICA1.DESCARGA.DBO.adconten04 d (nolock) on (a.codcon04=d.codcon04)                                        
--WHERE                                        
--a.codarm10  in ('HSD','ALI','HSV')                                                    
----and isnull(b.fecins15,a.fecing09)>=@FecInicio  
----and isnull(b.fecins15,a.fecing09)<@FecFin                                        
--and estini09 <> 'SC' and tipmov15='I'                                        
--and estini09 in ('OQ','OS','OK','NA','OX')                                        
--and codtip05 not in ('RH','RF')                                        
--and a.codcon04 not in (                          
--select contenedor from OCEANICA1.DESCARGA.DBO.TD_OPERACIONES_BLOQUEO_CONTENEDOR where estado='B' )
--
--
--UNION
--
--SELECT DISTINCT                               
--'COD_INT'=a.nrosec09,                                        
--'CONTENEDOR'=a.codcon04,                                        
--'BOOKING'='00000',                                       
--'FECHA'= isnull(b.fecins15,a.fecing09)                                         
--FROM                                        
--OCEANICAP1.DESCARGA.DBO.ADMOVCTR09 a (nolock)                                          
--inner join OCEANICAP1.DESCARGA.DBO.ADREGEIR15 b (nolock) on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09)   
--inner join OCEANICAP1.DESCARGA.DBO.adconten04 d (nolock) on (a.codcon04=d.codcon04)                                        
--WHERE                                        
--a.codarm10  in ('HSD','ALI','HSV')                                                    
----and isnull(b.fecins15,a.fecing09)>=@FecInicio  
----and isnull(b.fecins15,a.fecing09)<@FecFin                                        
--and estini09 <> 'SC' and tipmov15='I'                                        
--and estini09 in ('OQ','OS','OK','NA','OX')                                        
--and codtip05 not in ('RH','RF')                                        
--and a.codcon04 not in (                          
--select contenedor from OCEANICAP1.DESCARGA.DBO.TD_OPERACIONES_BLOQUEO_CONTENEDOR where estado='B' )
--GO
/****** Object:  View [dbo].[NEP_Evento_0500_HLE]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_0500_HLE]  --FMCR
--as
--select codcon04 as Contenedor,fecing09 as Fecha from Oceanica1.Descarga.dbo.admovctr09 
--where codarm10='HLE' 
--and estini09 not like 'O%'
--
--UNION
--
--select codcon04 as Contenedor,fecing09 as Fecha from OceanicaP1.Descarga.dbo.admovctr09 
--where codarm10='HLE' 
--and estini09 not like 'O%'
--GO
/****** Object:  View [dbo].[NEP_Evento_0500_HSD]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_0500_HSD]
--AS  
--
--SELECT DISTINCT                                    
--'COD_INT'=a.nrosec09,                                    
--'CONTENEDOR'=a.codcon04,                                    
--'ISOCONTENEDOR'= isnull(ltrim(rtrim(d.isocod04)),''),                                    
--'BOOKING'='00000',                                     
--'FECHA'=                                     
--case when codtip05 in ('RF','RH') then                                    
--case when a.fecpre09 is not null then                                    
--case when e.fechainicio is not null then  -- when a.fecprf09 is not null then                                    
--case when a.fecpre09>e.fechainicio then  -- when a.fecpre09>a.fecprf09 then                                    
--dateadd(minute, -5, e.fechainicio)     -- a.fecprf09                                    
--else                                    
--dateadd(minute, -5, a.fecpre09)     -- a.fecpre09                                    
--end                                    
--else                                    
--case when a.fecpre09>b.fecins15 then                                    
--b.fecins15                                    
--else                                    
--dateadd(minute, -5, a.fecpre09)     -- a.fecpre09                                    
--end                                    
--end                                    
--else                                    
--case                                     
--when e.fechainicio is not null then                                    
--case                                     
--when e.fechainicio>b.fecins15 then                                    
--b.fecins15                                    
--else                                             
--dateadd(minute, -5, e.fechainicio)                                    
--end                                    
--else                                    
--b.fecins15                                    
--end                                    
--end                                    
--else                                    
--b.fecins15                                    
--end                                    
--FROM                                    
--OCEANICAp1.DESCARGA.DBO.ADMOVCTR09 a (nolock)                                    
--inner join OCEANICAp1.DESCARGA.DBO.ADREGEIR15 b (nolock) on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09 and tipmov15='I')                                    
--inner join OCEANICAp1.DESCARGA.DBO.aaclientesaa c (nolock) on (b.codage19=c.contribuy)                                    
--inner join OCEANICAp1.DESCARGA.DBO.adconten04 d (nolock) on (a.codcon04=d.codcon04)                        
--left join OCEANICAp1.DESCARGA.DBO.pdt_pti e (nolock) on (b.nroeir15 = e.eir)                                    
--WHERE                                    
--a.codarm10 in ('HSD','ALI','HSV')                                 
--and b.fecins15>='20110306' and b.fecins15<getdate()                                    
--and estini09 = 'SC' and codtip05 in ('RF','RH')                                    
--
----and a.codcon04 not in (                    
----select contenedor from OCEANICAp1.DESCARGA.DBO.TD_OPERACIONES_BLOQUEO_CONTENEDOR where estado='B' )                    
--
--UNION                                    
--SELECT DISTINCT                                    
--'COD_INT'=a.nrosec09,                                    
--'CONTENEDOR'=a.codcon04,                                    
--'ISOCONTENEDOR'= isnull(ltrim(rtrim(d.isocod04)),''),                                    
--'BOOKING'='00000',                                     
--'FECHA'=                                     
--case                                     
--when codtip05 in ('RF','RH') then                                    
--case                                     
--when a.fecpre09 is not null then                                    
--case                                     
--when e.fechainicio is not null then                                    
--case                                     
--when a.fecpre09>e.fechainicio then                                    
--dateadd(minute, -5, e.fechainicio) --a.fecprf09                                    
--else                                    
--dateadd(minute, -5, a.fecpre09)  --a.fecpre09                                    
--end                                    
--else                                    
--case                                    
--when a.fecpre09>b.fecins15 then                                    
--b.fecins15                                    
--else                                    
--dateadd(minute, -5, a.fecpre09)  --a.fecpre09                                    
--end                                    
--end                                    
--else                                    
--case                                
--when e.fechainicio is not null then                                    
--case                                     
--when e.fechainicio>b.fecins15 then                                    
--b.fecins15                                    
--else                                             
--dateadd(minute, -5, e.fechainicio) -- a.fecprf09                                    
--end                                    
--else                                    
--b.fecins15                                    
--end                                  
--end                                    
--else                                    
--b.fecins15                                    
--end                                                                        
--FROM                                    
--OCEANICAp1.DESCARGA.DBO.ADMOVCTR09 a (nolock)                                    
--inner join OCEANICAp1.DESCARGA.DBO.ADREGEIR15 b (nolock) on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09 and tipmov15='I')                                    
--inner join OCEANICAp1.DESCARGA.DBO.aaclientesaa c (nolock) on (b.codage19=c.contribuy)                                    
--inner join OCEANICAp1.DESCARGA.DBO.adconten04 d (nolock) on (a.codcon04=d.codcon04)                        
--left join OCEANICAp1.DESCARGA.DBO.pdt_pti e (nolock) on (b.nroeir15 = e.eir)                                    
--WHERE                                    
--a.codarm10 in ('HSD','ALI','HSV')                                               
----and b.fecins15>=@FecInicio and b.fecins15<@FecFin                       
--and estini09 <> 'SC' and estini09 not in ('OK','NA','OQ','OS','OX')--20090917 / RTELLO / Se agrego estado OQ, OS ,OX                                    
--
----and a.codcon04 not in (                    
----select contenedor from OCEANICA1.DESCARGA.DBO.TD_OPERACIONES_BLOQUEO_CONTENEDOR where estado='B' )
--GO
--/****** Object:  View [dbo].[NEP_Evento_0600_HSD]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[NEP_Evento_0600_HSD]
-- as
-- select c.codcon04 as Contenedor, fecemi23 as Fecha from Oceanica1.Descarga.dbo.adpresup23 a 
-- inner join Oceanica1.Descarga.dbo.adregeir15 b on (a.nroeir15=b.nroeir15)
-- inner join Oceanica1.Descarga.dbo.admovctr09 c on (b.codcon04=c.codcon04 and b.nrosec09=c.nrosec09)
-- where codarm10='HSD' and nropre23 like '005%'
--GO
--/****** Object:  View [dbo].[NEP_Evento_0601_HSD]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[NEP_Evento_0601_HSD] 
--as
--select c.codcon04 as Contenedor, fecemi23 as Fecha from Oceanica1.Descarga.dbo.adpresup23 a 
--inner join Oceanica1.Descarga.dbo.adregeir15 b on (a.nroeir15=b.nroeir15)
--inner join Oceanica1.Descarga.dbo.admovctr09 c on (b.codcon04=c.codcon04 and b.nrosec09=c.nrosec09)
-- where  codarm10='HSD' and nropre23 like '0003%'
--GO
--/****** Object:  View [dbo].[NEP_Evento_0700_HSD]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[NEP_Evento_0700_HSD]
-- as
-- select c.codcon04 as Contenedor, fecemi23 as  Fecha from Oceanica1.Descarga.dbo.adpresup23 a 
-- inner join Oceanica1.Descarga.dbo.adregeir15 b on (a.nroeir15=b.nroeir15)
-- inner join Oceanica1.Descarga.dbo.admovctr09 c on (b.codcon04=c.codcon04 and b.nrosec09=c.nrosec09)
-- where --fecrep09>=@FecInicio and fecrep09<@FecFin and 
-- codarm10='HSD' and nropre23 like '005%'
--union 
-- select c.codcon04 as Contenedor, fecemi23 as Fecha from Oceanica1.Descarga.dbo.adpresup23 a 
-- inner join Oceanica1.Descarga.dbo.adregeir15 b on (a.nroeir15=b.nroeir15)
-- inner join Oceanica1.Descarga.dbo.admovctr09 c on (b.codcon04=c.codcon04 and b.nrosec09=c.nrosec09)
-- where --fecprf09>=@FecInicio and fecprf09<@FecFin and 
-- codarm10='HSD' and nropre23 like '0003%'
--GO
/****** Object:  View [dbo].[NEP_Evento_0715]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext NEP_Evento_0715 

--ALTER VIEW [dbo].[NEP_Evento_0715]  
--as  

------- EMBARQUES::
----select distinct 'COD_INT'=c.genbkg13, 'CONTENEDOR'=b.codcon04,                   
----'ISOCONTENEDOR'= isnull(ltrim(rtrim(d.isocod04)),''),                   
----'BOOKING' = Case left(e.bookin13,2) when 'BO' then '' else e.nrocon13 End,       
----'FECHA'=a.fecsal99,'PESO'= 0,                   
----'CLIENTE'= Case left(e.bookin13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA'= c.codarm10,      
----'TIPO'='OMT',  
----case   
----when c.codarm10 = 'HSD' then 1  
----when c.codarm10 = 'HLE' then 2  
----else null end as IdLinea      
----from Oceanica1.Descarga.dbo.adguiasr99 a (nolock)                   
----inner join Oceanica1.Descarga.dbo.arguicon99 b (nolock) on (a.nrogui99 = b.nrogui99)                  
----inner join Oceanica1.Descarga.dbo.admovctr09 c (nolock) on (b.nrosec09=c.nrosec09 and b.codcon04=c.codcon04)                  
----inner join Oceanica1.Descarga.dbo.adconten04 d (nolock) on (b.codcon04=d.codcon04)                  
----inner join Oceanica1.Descarga.dbo.edbookin13 e (nolock) on (c.genbkg13=e.genbkg13)                  
----inner join Oceanica1.Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)                  
----inner join Oceanica1.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =m.navvia11)                  
----inner join Oceanica1.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)                  
----where                   
----a.motivo99 in ('E','W')

---- UNION
--------------------------------
---- EVENTOS PAITA -------------
-------------------------------

-- --------------------------------------------  
--	-- SALIDA A PLANTA CLIENTE: EMITE EIR  

--	select distinct  
--	'COD_INT'=b.navvia11,--b.genbkg13,                
--	'CONTENEDOR'= b.codcon04,   -- a.FECMOV09  
--	'ISOCONTENEDOR'='',
--	'BOOKING'= '',
--	'FECHA'= isnull(b.FECMOV09,b.fecsal09),
--	-- 'FECHA'= CONVERT (char(4), isnull(b.FECMOV09,b.fecsal09), 121 )+                               
--	--  substring(CONVERT (char(20), isnull(b.FECMOV09,b.fecsal09), 121 ),6,2) +                              
--	--  substring(CONVERT (char(20), isnull(b.FECMOV09,b.fecsal09), 121 ),9,2) + ' ' +                              
--	--  substring(CONVERT (char(20), isnull(b.FECMOV09,b.fecsal09), 121 ),12,5)     ,                    
--	'PESO'= 0,
--	'CLIENTE'='',
--	'LINEA'= b.codarm10,
--	'TIPO'='',
--	'IdLinea'=2 -- ID HLE
--	-- 'LINEA' = 'HLE',    
--	-- 'EVENTO'='0715' -- Para HLE 0800 se consideran como 0715  
--	--,'EIR: '+a.eir  
--	--,'SALIDA'  
--	from Oceanicap1.Descarga.dbo.pdt_asignacion a (NOLOCK), Oceanicap1.Descarga.dbo.admovctr09 b (NOLOCK), Oceanicap1.Descarga.dbo.adconten04 c  (NOLOCK)                      
--	where                       
--	a.contenedor = b.codcon04 and a.booking = b.genbkg13 and                   
--	a.contenedor = c.codcon04 and                       
--	b.codcon04 = c.codcon04 and                      
--	b.codarm10='HLE'                
--	-- and b.fecSAL09>=@fecha_ini     and b.fecSAL09<@fecha_fin                
--	and a.eir is not null and a.destino = 3 
	
--	---------------------  
--	-- LLENADOS - ENVIO DE MOVILIZADOS PARA LLENADO SE ENVIAN LUEGO DEL 1ER LLENADO    
--	UNION  

--	select --DISTINCT
--	'COD_INT'=B.navvia11, --b.genbkg13,      
--	'CONTENEDOR'=b.codcon04,  
--	'ISOCONTENEDOR'='',
--	'BOOKING'= '',
--	'FECHA'= min(r.fecsal18),
--	-- 'FECHA'= min( CONVERT (char(4), r.fecsal18, 121 )+                               --B.feclln16  
--	-- substring(CONVERT (char(20), r.fecsal18, 121 ),6,2) +                                
--	-- substring(CONVERT (char(20), r.fecsal18, 121 ),9,2) + ' ' +                                
--	-- substring(CONVERT (char(20), r.fecsal18, 121 ),12,5)     ),  
--	'PESO'= 0,
--	'CLIENTE'='',
--	'LINEA'= e.codarm10,
--	'TIPO'='',
--	'IdLinea'=2 -- ID HLE
--	-- 'LINEA' = 'HLE',      
--	-- 'EVENTO'='0715' -- Para HLE las movilizaciones salen desde el 1er llenado  
--	from            
--	NEPTUNIAP2.DESCARGA.DBO.edllenad16 b (NOLOCK)
--	inner join NEPTUNIAP2.DESCARGA.DBO.edbookin13 e (NOLOCK)  on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                        
--	inner join NEPTUNIAP2.DESCARGA.DBO.DDTICKET18 r (NOLOCK) on b.nrotkt18=r.nrotkt18  
--	where               
--	e.codarm10 = 'HLE' and   
--	r.fecsal18 is not null and  
--	-- r.fecsal18>=@fecha_ini and r.fecsal18<@fecha_fin and             
--	b.codemb06<>'CTR'   
--	group by b.navvia11,b.codcon04,e.codarm10 --,r.fecsal18  

--	-------------------------------------------------------------------------------  
--	-- EMBARQUES AL PUERTO  
--	UNION   

--	SELECT DISTINCT  
--	'COD_INT'=A.navvia11,--a.genbkg13,                
--	'CONTENEDOR'= D.codcon04,
--	'ISOCONTENEDOR'='',
--	'BOOKING'= '',
--	'FECHA'= g.fecsal99,
--	-- 'FECHA'= CONVERT (char(4), dateadd(dd,0, g.fecsal99), 121 )+                               
--	-- substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),6,2) +                              
--	-- substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),9,2) + ' ' +                              
--	-- substring(CONVERT (char(20), dateadd(dd,0, g.fecsal99), 121 ),12,5)     ,                    
--	'PESO'= 0,
--	'CLIENTE'='',
--	'LINEA'= d.codarm10,
--	'TIPO'='',
--	'IdLinea'=2 -- ID HLE
--	-- 'LINEA' = 'HLE',    
--	-- 'EVENTO'='0715'  
--	FROM   Oceanicap1.Descarga.dbo.ADGUIASR99  G (NOLOCK), Oceanicap1.Descarga.dbo.arguicon99 D  (NOLOCK), Oceanicap1.Descarga.dbo.admovctr09 a (nolock)                      
--	WHERE  G.nrogui99 = D.nrogui99   and d.codcon04 = a.codcon04 and d.nrosec09 = a.nrosec09 and                
--	d.codarm10='HLE' and                 
--	-- g.fecsal99>=@fecha_ini and g.fecsal99<@fecha_fin and
--	G.motivo99 in ('E','W')  and                       
--	G.status99 = 'E'    


------------------------------------------------------------------
------- SECUENCIA ANTIGUA ---------------------------------------
---- EMBARQUES PAITA
---- select distinct 
----'COD_INT'=c.genbkg13, 
----'CONTENEDOR'=b.codcon04,               
----'ISOCONTENEDOR'= isnull(ltrim(rtrim(d.isocod04)),''),               
----'BOOKING' = Case left(e.bookin13,2) when 'BO' then '' else e.nrocon13 End,   
----'FECHA'=a.fecsal99,'PESO'= 0,               
----'CLIENTE'= Case left(e.bookin13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA'= c.codarm10,  
----'TIPO'='OMT'  ,
----case   
----when c.codarm10 = 'HSD' then 1  
----when c.codarm10 = 'HLE' then 2  
----else null end as IdLinea  
----from Oceanicap1.Descarga.dbo.adguiasr99 a (nolock)               
----inner join Oceanicap1.Descarga.dbo.arguicon99 b (nolock) on (a.nrogui99 = b.nrogui99)              
----inner join Oceanicap1.Descarga.dbo.admovctr09 c (nolock) on (b.nrosec09=c.nrosec09 and b.codcon04=c.codcon04)              
----inner join Oceanicap1.Descarga.dbo.adconten04 d (nolock) on (b.codcon04=d.codcon04)              
----inner join Oceanicap1.Descarga.dbo.edbookin13 e (nolock) on (c.genbkg13=e.genbkg13)              
----inner join Oceanicap1.Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)              
----inner join Oceanicap1.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =m.navvia11)              
----inner join Oceanicap1.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)              
----where               
------1=1
------a.motivo99 in ('E','W') and   
----a.motivo99 in ('E','W')  and a.status99 = 'E'    
----
----UNION              
----
----
------ POSICIONAMIENTO PARA LLENADO
----select distinct              
----'COD_INT'=b.genbkg13,               
----'CONTENEDOR'=c.codcon04,               
----'ISOCONTENEDOR'= isnull(ltrim(rtrim(c.isocod04)),''),               
----'BOOKING' = Case left(b.bookin13,2) when 'BO' then '' else b.nrocon13 End,  
----'FECHA'=e.fecmov09,              
----'PESO'= 0,               
----'CLIENTE'= Case left(b.bookin13,2) when 'BO' then q.desnav08 else d.nombre End ,'LINEA'= b.codarm10,  
----'TIPO'='OBO'  ,
----case   
----when b.codarm10 = 'HSD' then 1  
----when b.codarm10 = 'HLE' then 2  
----else null end as IdLinea  
----from Oceanicap1.Descarga.dbo.pdt_asignacion a (nolock)               
----inner join Oceanicap1.Descarga.dbo.edbookin13 b (nolock) on (a.booking = b.genbkg13)              
----inner join Oceanicap1.Descarga.dbo.adconten04 c (nolock) on (a.contenedor= c.codcon04)              
----inner join Oceanicap1.Descarga.dbo.aaclientesaa d (nolock) on (b.codemc12=d.contribuy)              
----inner join Oceanicap1.Descarga.dbo.admovctr09 e (nolock) on (b.genbkg13=e.genbkg13 and a.contenedor = e.codcon04)              
----inner join Oceanicap1.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =m.navvia11)              
----inner join Oceanicap1.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)              
----where       
----e.fecmov09 is not null and
------a.fecha>=@dFecIni  and    
------a.fecha<@dFecFin  and  
------b.codarm10 = @sCodLin and  
------a.destino in (1,2,3)  and
----a.eir is not null and a.destino = 3  
------e.fecsal09 is  null
----
----
----union
----
----
----
----select distinct              
----'COD_INT'=b.genbkg13,               
----'CONTENEDOR'=c.codcon04,               
----'ISOCONTENEDOR'= isnull(ltrim(rtrim(c.isocod04)),''),               
----'BOOKING' = Case left(b.bookin13,2) when 'BO' then '' else b.nrocon13 End,  
----'FECHA'=e.fecsal09,              
----'PESO'= 0,               
----'CLIENTE'= Case left(b.bookin13,2) when 'BO' then q.desnav08 else d.nombre End ,'LINEA'= b.codarm10,  
----'TIPO'='OMT'  ,
----case   
----when b.codarm10 = 'HSD' then 1  
----when b.codarm10 = 'HLE' then 2  
----else null end as IdLinea  
----from               
----Oceanicap1.Descarga.dbo.pdt_asignacion a (nolock)    
----inner join Oceanicap1.Descarga.dbo.edbookin13 b (nolock) on (a.booking = b.genbkg13)              
----inner join Oceanicap1.Descarga.dbo.adconten04 c (nolock) on (a.contenedor= c.codcon04)              
----inner join Oceanicap1.Descarga.dbo.aaclientesaa d (nolock) on (b.codemc12=d.contribuy)              
----inner join Oceanicap1.Descarga.dbo.admovctr09 e (nolock) on (b.genbkg13=e.genbkg13 and a.contenedor = e.codcon04)              
----inner join Oceanicap1.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =m.navvia11)              
----inner join Oceanicap1.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)              
----left join Oceanicap1.Descarga.dbo.arguicon99 R  (NOLOCK) on R.codcon04=A.contenedor
----where       
------1=2 and
------e.fecsal09>=@dFecIni  and    
------e.fecsal09<@dFecFin  and  
------b.codarm10 = @sCodLin and  
------a.destino in (1,2,3)  and
----A.destino in (1,2,3,5)
----AND a.eir is null and R.nrogui99 is null
------c.codcon04 in () and 
------e.fecsal09 is not null

--GO
/****** Object:  View [dbo].[NEP_Evento_0800A]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[NEP_Evento_0800A]
--
--as
--select distinct                
--'COD_INT'=b.genbkg13,                 
--'CONTENEDOR'=c.codcon04,                 
--'ISOCONTENEDOR'= isnull(ltrim(rtrim(c.isocod04)),''),                 
--'BOOKING' = Case left(b.bookin13,2) when 'BO' then '' else b.nrocon13 End,    
--'FECHA'=a.fecha,                
--'PESO'= 0,                 
--'CLIENTE'= Case left(b.bookin13,2) when 'BO' then q.desnav08 else d.nombre End ,
--'LINEA'= b.codarm10,    
--'TIPO'='OBO',
--case 
--when b.codarm10 = 'HSD' then 1
--when b.codarm10 = 'HLE' then 2
--else null end as IdLinea    
--from                 
--Oceanica1.Descarga.dbo.pdt_asignacion a with (nolock)                 
--inner join Oceanica1.Descarga.dbo.edbookin13 b with (nolock) on (a.booking = b.genbkg13)                
--inner join Oceanica1.Descarga.dbo.adconten04 c with (nolock) on (a.contenedor= c.codcon04)                
--inner join Oceanica1.Descarga.dbo.aaclientesaa d with (nolock) on (b.codemc12=d.contribuy)                
--inner join Oceanica1.Descarga.dbo.admovctr09 e with (nolock) on (b.genbkg13=e.genbkg13 and a.contenedor = e.codcon04)                
--inner join Oceanica1.Descarga.dbo.ddcabman11 m with (nolock) on (e.navvia11 =m.navvia11)                
--inner join Oceanica1.Descarga.dbo.dqnavier08 q with (nolock) on (q.codnav08 = m.codnav08)                
--where         
----a.fecha>='20110701' and      
----a.fecha<@FecFin  and    
----b.codarm10 = @sCodLin and    
--a.destino in (1,2,3)  
--group by  b.genbkg13,b.codarm10,c.codcon04, c.isocod04,Case left(b.bookin13,2) 
--when 'BO' then '' else b.nrocon13 End,a.fecha,
--Case left(b.bookin13,2) 
--when 'BO' then q.desnav08 else d.nombre End
--
--union
--
--select distinct                
--'COD_INT'=b.genbkg13,                 
--'CONTENEDOR'=c.codcon04,                 
--'ISOCONTENEDOR'= isnull(ltrim(rtrim(c.isocod04)),''),                 
--'BOOKING' = Case left(b.bookin13,2) when 'BO' then '' else b.nrocon13 End,    
--'FECHA'=a.fecha,                
--'PESO'= 0,                 
--'CLIENTE'= Case left(b.bookin13,2) when 'BO' then q.desnav08 else d.nombre End ,
--'LINEA'= b.codarm10,    
--'TIPO'='OBO',
--case 
--when b.codarm10 = 'HSD' then 1
--when b.codarm10 = 'HLE' then 2
--else null end as IdLinea    
--from                 
--Oceanica1.Descarga.dbo.pdt_asignacion a with (nolock)                 
--inner join Oceanicap1.Descarga.dbo.edbookin13 b with (nolock) on (a.booking = b.genbkg13)                
--inner join Oceanicap1.Descarga.dbo.adconten04 c with (nolock) on (a.contenedor= c.codcon04)                
--inner join Oceanicap1.Descarga.dbo.aaclientesaa d with (nolock) on (b.codemc12=d.contribuy)                
--inner join Oceanicap1.Descarga.dbo.admovctr09 e with (nolock) on (b.genbkg13=e.genbkg13 and a.contenedor = e.codcon04)                
--inner join Oceanicap1.Descarga.dbo.ddcabman11 m with (nolock) on (e.navvia11 =m.navvia11)                
--inner join Oceanicap1.Descarga.dbo.dqnavier08 q with (nolock) on (q.codnav08 = m.codnav08)                
--where         
----a.fecha>='20110701' and      
----a.fecha<@FecFin  and    
----b.codarm10 = @sCodLin and    
--a.destino in (1,2,3)  
--group by  b.genbkg13,b.codarm10,c.codcon04, c.isocod04,Case left(b.bookin13,2) 
--when 'BO' then '' else b.nrocon13 End,a.fecha,
--Case left(b.bookin13,2) 
--when 'BO' then q.desnav08 else d.nombre End
--GO
--/****** Object:  View [dbo].[NEP_Evento_0800B]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[NEP_Evento_0800B]
--as
--
--select a.codcon04 as Contenedor,c.Fecha, codarm10 as Linea,
--case 
--when codarm10 = 'HSD' then 1
--when codarm10 = 'HLE' then 2
--else null end as IdLinea     
--from oceanica1.Descarga.dbo.admovctr09 a 
--inner join oceanica1.descarga.dbo.adregeir15 b on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09)
--inner join oceanica1.Descarga.dbo.pdt_asignacion c on a.genbkg13 = c.booking and a.codcon04 = c.contenedor
--where --codarm10='HSD' 
----and c.fecha>=@FecInicio 
----and c.fecha<@FecFin
----and 
--tipmov15='O'
--
--
--union
--
--select a.codcon04 as Contenedor,c.Fecha, codarm10 as Linea,
--case 
--when codarm10 = 'HSD' then 1
--when codarm10 = 'HLE' then 2
--else null end as IdLinea     
--from oceanicap1.Descarga.dbo.admovctr09 a 
--inner join oceanicap1.descarga.dbo.adregeir15 b on (a.codcon04=b.codcon04 and a.nrosec09=b.nrosec09)
--inner join oceanicap1.Descarga.dbo.pdt_asignacion c on a.genbkg13 = c.booking and a.codcon04 = c.contenedor
--where --codarm10='HSD' 
----and c.fecha>=@FecInicio 
----and c.fecha<@FecFin
----and 
--tipmov15='O'
--GO
/****** Object:  View [dbo].[NEP_Evento_0900]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_0900]    --FMCR
--as    
--select distinct 'COD_INT'=a.navvia11, 'CONTENEDOR'=b.codcon04,                 
--'ISOCONTENEDOR'= d.codiso03,                 
--'BOOKING' = Case left(e.nrocon13,2) when 'BO' then '' else e.nrocon13 End,     
--'FECHA'=g.fecsal18,                
--'PESO'= g.pesnet18,                
--'CLIENTE'= Case left(e.nrocon13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA' = e.codarm10,  
--case   
--when e.codarm10 = 'HSD' then 1  
--when e.codarm10 = 'HLE' then 2  
--else null end as IdLinea        
--from [SP3TDA-DBSQL01].Descarga.dbo.DRCTRTMC90 a (nolock)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edconten04 c (nolock) on (b.codcon04=c.codcon04)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.DDCNDCTR03 d (nolock) on (c.codtip05=d.codtip05 and c.codtam09=d.codtam09)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =g.navvia11)                
--inner join [SP3TDA-DBSQL01].Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)                
--where       
----e.codarm10 = @sCodLin and      
----g.fecing18>='20110701' and     
----g.fecing18<@FecFin and     
--e.bookin13 not like 'TS%'

--UNION

----select distinct 'COD_INT'=a.navvia11, 'CONTENEDOR'=b.codcon04,                 
----'ISOCONTENEDOR'= d.codiso03,                 
----'BOOKING' = Case left(e.nrocon13,2) when 'BO' then '' else e.nrocon13 End,     
----'FECHA'=g.fecsal18,                
----'PESO'= g.pesnet18,                
----'CLIENTE'= Case left(e.nrocon13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA' = e.codarm10,  
----case   
----when e.codarm10 = 'HSD' then 1  
----when e.codarm10 = 'HLE' then 2  
----else null end as IdLinea        
----from NeptuniaP2.Descarga.dbo.DRCTRTMC90 a (nolock)                
----inner join NeptuniaP2.Descarga.dbo.edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                
----inner join NeptuniaP2.Descarga.dbo.edconten04 c (nolock) on (b.codcon04=c.codcon04)                
----inner join NeptuniaP2.Descarga.dbo.DDCNDCTR03 d (nolock) on (c.codtip05=d.codtip05 and c.codtam09=d.codtam09)                
----inner join NeptuniaP2.Descarga.dbo.edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                
----inner join NeptuniaP2.Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)                
----inner join NeptuniaP2.Descarga.dbo.ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                
----inner join NeptuniaP2.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =g.navvia11)                
----inner join NeptuniaP2.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)                
--where       
----e.codarm10 = @sCodLin and      
----g.fecing18>='20110701' and     
----g.fecing18<@FecFin and     
--e.bookin13 not like 'TS%'
--GO
/****** Object:  View [dbo].[NEP_Evento_1000]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[NEP_Evento_1000] --FMCR
--as
--select distinct 'COD_INT'=a.navvia11, 'CONTENEDOR'=b.codcon04,               
--'ISOCONTENEDOR'= d.codiso03,               
--'BOOKING' = Case left(e.nrocon13,2) when 'BO' then '' else e.nrocon13 End,   
--'FECHA'=g.fecsal18,              
--'PESO'= g.pesnet18,              
--'CLIENTE'= Case left(e.nrocon13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA' = e.codarm10,
--case 
--when e.codarm10 = 'HSD' then 1
--when e.codarm10 = 'HLE' then 2
--else null end as IdLinea      
--from [SP3TDA-DBSQL01].Descarga.dbo.DRCTRTMC90 a (nolock)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edconten04 c (nolock) on (b.codcon04=c.codcon04)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.DDCNDCTR03 d (nolock) on (c.codtip05=d.codtip05 and c.codtam09=d.codtam09)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =g.navvia11)              
--inner join [SP3TDA-DBSQL01].Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)              
--where     
----e.codarm10 = @sCodLin and    
----g.fecing18>='20110701' and   
----g.fecing18<@FecFin and   
--e.bookin13 not like 'TS%'


--UNION

--select distinct 'COD_INT'=a.navvia11, 'CONTENEDOR'=b.codcon04,               
--'ISOCONTENEDOR'= d.codiso03,               
--'BOOKING' = Case left(e.nrocon13,2) when 'BO' then '' else e.nrocon13 End,   
--'FECHA'=g.fecsal18,              
--'PESO'= g.pesnet18,              
--'CLIENTE'= Case left(e.nrocon13,2) when 'BO' then q.desnav08 else f.nombre End,'LINEA' = e.codarm10,
--case 
--when e.codarm10 = 'HSD' then 1
--when e.codarm10 = 'HLE' then 2
--else null end as IdLinea      
--from NeptuniaP2.Descarga.dbo.DRCTRTMC90 a (nolock)              
--inner join NeptuniaP2.Descarga.dbo.edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)              
--inner join NeptuniaP2.Descarga.dbo.edconten04 c (nolock) on (b.codcon04=c.codcon04)              
--inner join NeptuniaP2.Descarga.dbo.DDCNDCTR03 d (nolock) on (c.codtip05=d.codtip05 and c.codtam09=d.codtam09)              
--inner join NeptuniaP2.Descarga.dbo.edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)              
--inner join NeptuniaP2.Descarga.dbo.aaclientesaa f (nolock) on (e.codemc12=f.contribuy)              
--inner join NeptuniaP2.Descarga.dbo.ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)              
--inner join NeptuniaP2.Descarga.dbo.ddcabman11 m (nolock) on (e.navvia11 =g.navvia11)              
--inner join NeptuniaP2.Descarga.dbo.dqnavier08 q (nolock) on (q.codnav08 = m.codnav08)              
--where     
----e.codarm10 = @sCodLin and    
----g.fecing18>='20110701' and   
----g.fecing18<@FecFin and   
--e.bookin13 not like 'TS%'
--GO
/****** Object:  View [dbo].[prueba001]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[prueba001]
AS
SELECT TOP (100) idregistro, SUM(idevento) AS TotalSales
FROM lin_registro(nolock)
--WHERE OrderDate > CONVERT(DATETIME,'20001231',101)
GROUP BY idregistro;
GO
/****** Object:  View [dbo].[VW_PESONETO_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[VW_PESONETO_VGM]
AS
SELECT DISTINCT
GENBKG
,CONTENEDOR
,PESO_CTR
FROM LIN_REGISTRO_VGM WITH (NOLOCK)
GO
/****** Object:  StoredProcedure [dbo].[CON_InsertarActualizarEmailNotificacion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 25/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CON_InsertarActualizarEmailNotificacion]
(
	@EmailNotificacion nvarchar(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	CON_Configuracion
				)
		UPDATE	CON_Configuracion
		SET		EmailNotificacion = @EmailNotificacion
	ELSE
		INSERT INTO	CON_Configuracion
		(EmailNotificacion)
		VALUES
		(@EmailNotificacion)
END
GO
/****** Object:  StoredProcedure [dbo].[CON_ObtenerEmailNotificacion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 25/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CON_ObtenerEmailNotificacion]
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	CON_Configuracion
				)
		SELECT	TOP 1
				EmailNotificacion
		FROM	CON_Configuracion
	ELSE
		SELECT	'' AS EmailNotificacion
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActalizarRegistroDetalleXCampoYIdregistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER PROCEDURE [dbo].[LIN_ActalizarRegistroDetalleXCampoYIdregistro]
  @idregistro int,
  @idcampo int,
  @valor varchar(150)
  as
  
  update lin_registroxcampo set valor = @valor where
  idcampo=@idcampo and IdRegistro=@idregistro
GO
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_HELPTEXT LIN_ACTUALIZA_INGRESOS

--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_INGRESOS]               
--(@sCodLin as char(3),              
--@sEve as char(4),  
--@local as char(5)                 
--)                
--AS                                    
--BEGIN                                   
--                
--declare @ctrr as char(11)                  
--declare @tot as int                  
--declare @id as int                  
--declare @idc as int                  
--DECLARE @LIN AS VARCHAR(2)                  
--                  
-- DECLARE @eventosActuales TABLE (                    
--  [idreg] [int] NOT NULL,                                              
--  [idcont] [int] NOT NULL,                                              
--  [NroCtr] [char] (11) NOT NULL,                  
--  [ok] [char](1) NULL                  
--  )                    
--                  
---------------- 1.ACTUALIZA INGRESOS DE HSD --------------------------------------                  
-- if @sCodLin='HSD'                  
-- BEGIN                  
--	SET @LIN='1'                  
--	--if @sEve='0400' or @sEve='0500'           
--	--BEGIN          
--	--	IF @local='LIMA'      
--	--	begin 
--	--		insert @eventosActuales(idreg,idcont,nroctr)                  
--    --
--	--		select b.idregistro,a.idcontador,b.contenedor                  
--	--		from oceanica1.descarga.dbo.LIN_HSD_INGRESOS A with(nolock)                   
--	--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--	--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--	--		where                   
--	--		a.estado='COM'                  
--	--		and B.estado='ENV'              
--	--		and B.idlinea=@LIN                 
--	--		and @sEve=c.codigo --case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                  
--	--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--	--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--    --
--	--		select @tot=count(*) from @eventosActuales where ok is null                  
--	--		WHILE @tot>0                                       
--	--		BEGIN                     
--	--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--	--			update oceanica1.descarga.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--	--			update @eventosActuales set ok='1' where idreg=@id                  
--	--			select @tot=count(*) from @eventosActuales where ok is null                  
--	--		END
--	--	END
--    --
--	--	IF @local='PAITA'      
--	--	begin 
--	--		insert @eventosActuales(idreg,idcont,nroctr)                  
--    --
--	--		select b.idregistro,a.idcontador,b.contenedor                  
--	--		from oceanicaP1.descarga.dbo.LIN_HSD_INGRESOS A with(nolock)                   
--	--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--	--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--	--		where                   
--	--		a.estado='COM'                  
--	--		and B.estado='ENV'              
--	--		and B.idlinea=@LIN                 
--	--		and @sEve=c.codigo --case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                  
--	--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--	--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--    --
--	--		select @tot=count(*) from @eventosActuales where ok is null                  
--	--		WHILE @tot>0                                       
--	--		BEGIN                     
--	--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--	--			update oceanicaP1.descarga.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--	--			update @eventosActuales set ok='1' where idreg=@id                  
--	--			select @tot=count(*) from @eventosActuales where ok is null                  
--	--		END
--	--	END
--	END          
--  
--	if @sEve='0900'          
--	BEGIN          
--		IF @local='LIMA'      
--		begin 
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'              
--			and B.idlinea=@LIN                 
--			and @sEve=c.codigo          
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve      
--				update @eventosActuales set ok='1' where idcont=@idc                 
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END       
--		END
--		
--		--IF @local='PAITA'      
--		--begin 
--		--	insert @eventosActuales(idreg,idcont,nroctr)                  
--        --
--		--	select b.idregistro,a.idcontador,b.contenedor                  
--		--	from neptuniaP2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--		--	INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--		--	INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--		--	where                   
--		--	a.estado='COM'                  
--		--	and B.estado='ENV'              
--		--	and B.idlinea=@LIN                 
--		--	and @sEve=c.codigo          
--		--	and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--		--	and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--        --
--		--	select @tot=count(*) from @eventosActuales where ok is null                  
--		--	WHILE @tot>0                                       
--		--	BEGIN                     
--		--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--		--		update neptuniaP2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve      
--		--		update @eventosActuales set ok='1' where idcont=@idc                 
--		--		select @tot=count(*) from @eventosActuales where ok is null                  
--		--	END       
--		--END
--
--	END  
--          
--	if @sEve='0200'          
--	BEGIN   
--		PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'          
--		--  insert @eventosActuales(idreg,idcont,nroctr)         
--		--                  
--		--  select b.idregistro,a.idcontador,b.contenedor                  
--		--  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_INGRESOS A with(nolock)                   
--		--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--		--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--		--  where                   
--		--  a.estado='COM'                  
--		--  and B.estado='ENV'              
--		--  and B.idlinea=@LIN                 
--		--  and @sEve=c.codigo          
--		--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--		--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--		--            
--		--  select @tot=count(*) from @eventosActuales where ok is null                  
--		--  WHILE @tot>0                                       
--		--  BEGIN                     
--		--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--		--   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--		--   update @eventosActuales set ok='1' where idreg=@id                  
--		--   select @tot=count(*) from @eventosActuales where ok is null                  
--		--  END          
--	END          
--                
-- END                
--                
---------------- 2.ACTUALIZA INGRESOS DE HLE --------------------------------------                  
--	if @sCodLin='HLE' AND (@sEve='0400' OR @sEve='0500')                  
--	BEGIN 
--		SET @LIN='2'                
--		IF @local='LIMA'      
--		begin     
-- 			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from oceanica1.descarga.dbo.LIN_HLE_INGRESOS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'               
--			and B.idlinea=@LIN                 
--			and @sEve=c.codigo --case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                  
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update oceanica1.descarga.dbo.LIN_HLE_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		END
--		
--		IF @local='PAITA'      
--		begin     
-- 			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from oceanicaP1.descarga.dbo.LIN_HLE_INGRESOS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'               
--			and B.idlinea=@LIN                 
--			and @sEve=c.codigo --case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                  
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)            
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)            
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update oceanicaP1.descarga.dbo.LIN_HLE_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		END
--                
--	END
---------------- TERMINO DE LINEAS 
--END
--
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS_CALLAO]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- SP_HELPTEXT LIN_ACTUALIZA_INGRESOS_CALLAO  
--                
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_INGRESOS_CALLAO]             
--(@sCodLin as char(3),            
--@sEve as char(4)                
--)              
--AS                                  
--BEGIN                                 
--              
--declare @ctrr as char(11)                
--declare @tot as int                
--declare @id as int                
--declare @idc as int                
--DECLARE @LIN AS VARCHAR(2)                
--                
-- DECLARE @eventosActuales TABLE (                  
--  [idreg] [int] NOT NULL,                                            
--  [idcont] [int] NOT NULL,                                            
--  [NroCtr] [char] (11) NOT NULL,                
--  [ok] [char](1) NULL                
--  )                  
--                
---------------- 1.ACTUALIZA INGRESOS DE HSD --------------------------------------                
-- if @sCodLin='HSD'                
-- BEGIN                
--	SET @LIN='1'                
--	if @sEve='0400' or @sEve='0500'         
--	BEGIN        
--		insert @eventosActuales(idreg,idcont,nroctr)                
--            
--		select b.idregistro,a.idcontador,b.contenedor                
--		from oceanica1.descarga.dbo.LIN_HSD_INGRESOS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'            
--		and B.idlinea=@LIN               
--		and @sEve=case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--			update oceanica1.descarga.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--			update @eventosActuales set ok='1' where idreg=@id                
--			select @tot=count(*) from @eventosActuales where ok is null                
--		END        
--	END        
--
--	if @sEve='0900'        
--	BEGIN        
--		insert @eventosActuales(idreg,idcont,nroctr)                
--            
--		select b.idregistro,a.idcontador,b.contenedor                
--		from [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'            
--		and B.idlinea=@LIN               
--		and @sEve=c.codigo        
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--			update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve    
--			update @eventosActuales set ok='1' where idcont=@idc               
--			select @tot=count(*) from @eventosActuales where ok is null                
--		END     
--	END
--        
--	if @sEve='0200'        
--	BEGIN        
--		PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'        
--		--  insert @eventosActuales(idreg,idcont,nroctr)       
--		--                
--		--  select b.idregistro,a.idcontador,b.contenedor                
--		--  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_INGRESOS A with(nolock)                 
--		--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		--  where                 
--		--  a.estado='COM'                
--		--  and B.estado='ENV'            
--		--  and B.idlinea=@LIN               
--		--  and @sEve=c.codigo        
--		--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--		--          
--		--  select @tot=count(*) from @eventosActuales where ok is null                
--		--  WHILE @tot>0                                     
--		--  BEGIN                   
--		--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		--   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--		--   update @eventosActuales set ok='1' where idreg=@id                
--		--   select @tot=count(*) from @eventosActuales where ok is null                
--		--  END        
--	END        
--              
-- END              
--              
---------------- 2.ACTUALIZA INGRESOS DE HLE --------------------------------------                
-- if @sCodLin='HLE' AND (@sEve='0400' OR @sEve='0500')                
-- BEGIN                
--	SET @LIN='2'              
--	  
--	insert @eventosActuales(idreg,idcont,nroctr)                
--                
--	select b.idregistro,a.idcontador,b.contenedor                
--	from oceanica1.descarga.dbo.LIN_HLE_INGRESOS A with(nolock)                 
--	INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--	INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--	where                 
--	a.estado='COM'                
--	and B.estado='ENV'             
--	and B.idlinea=@LIN               
--	and @sEve=case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                
--	and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--	and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--	select @tot=count(*) from @eventosActuales where ok is null                
--	WHILE @tot>0                                     
--	BEGIN                   
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		update oceanica1.descarga.dbo.LIN_HLE_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--		update @eventosActuales set ok='1' where idreg=@id                
--		select @tot=count(*) from @eventosActuales where ok is null                
--	END                
-- END              
--              
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS_CALLAO_bk]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
----SP_HELPTEXT LIN_ACTUALIZA_INGRESOS_CALLAO  
--  
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS_PAITA]    Script Date: 07/11/2012 10:01:26 ******/      
--        
--    
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_INGRESOS_CALLAO_bk]       
--(@sCodLin as char(3)    
--)  
--AS                      
--BEGIN                     
--  
--declare @ctrr as char(11)    
--declare @tot as int    
--declare @id as int    
--declare @idc as int    
--DECLARE @LIN AS VARCHAR(2)    
--    
-- DECLARE @eventosActuales TABLE (      
--  [idreg] [int] NOT NULL,                                
--  [idcont] [int] NOT NULL,                                
--  [NroCtr] [char] (11) NOT NULL,    
--  [ok] [char](1) NULL    
--  )      
--    
---------------- 1.ACTUALIZA INGRESOS DE HSD --------------------------------------    
-- if @sCodLin='HSD'    
-- BEGIN    
--  SET @LIN='1'    
--  
--  insert @eventosActuales(idreg,idcont,nroctr)    
--    
--  select b.idregistro,a.idcontador,b.contenedor    
--  from oceanica1.descarga.dbo.LIN_HSD_INGRESOS A with(nolock)     
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS    
--  where     
--  a.estado='COM'    
--  and B.idlinea=@LIN   
--  and B.estado='ENV' and b.idevento in ('5','6')    
--  AND A.FECHA>=dateadd(MINUTE,-15,B.FECHAEVENTO) AND A.FECHA<=dateadd(MINUTE,15,B.FECHAEVENTO)    
--  --and a.contenedor='CPSU1766708'    
--  
--  select @tot=count(*) from @eventosActuales where ok is null    
--  WHILE @tot>0                         
--  BEGIN       
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null    
--  
--   update oceanica1.descarga.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc    
--   update @eventosActuales set ok='1' where idreg=@id    
--  
--   select @tot=count(*) from @eventosActuales where ok is null    
--  END    
-- END  
--  
---------------- 2.ACTUALIZA INGRESOS DE HLE --------------------------------------    
-- if @sCodLin='HLE'    
-- BEGIN    
--  SET @LIN='2'  
--  
--  insert @eventosActuales(idreg,idcont,nroctr)    
--    
--  select b.idregistro,a.idcontador,b.contenedor    
--  from oceanica1.descarga.dbo.LIN_HLE_INGRESOS A with(nolock)     
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS    
--  where     
--  a.estado='COM'    
--  and B.idlinea=@LIN   
--  and B.estado='ENV' and b.idevento in ('5','6')    
--  AND A.FECHA>=dateadd(MINUTE,-15,B.FECHAEVENTO) AND A.FECHA<=dateadd(MINUTE,15,B.FECHAEVENTO)    
--  --and a.contenedor='CPSU1766708'    
--  
--  select @tot=count(*) from @eventosActuales where ok is null    
--  WHILE @tot>0                         
--  BEGIN       
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null    
--  
--   update oceanica1.descarga.dbo.LIN_HLE_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc    
--   update @eventosActuales set ok='1' where idreg=@id    
--  
--   select @tot=count(*) from @eventosActuales where ok is null    
--  END    
-- END  
--  
--END    
--GO
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS_PAITA]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sp_helptext [LIN_ACTUALIZA_INGRESOS_PAITA]  
  
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_INGRESOS_PAITA]    Script Date: 07/11/2012 10:01:26 ******/            
          
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_INGRESOS_PAITA]  
--(@sCodLin as char(3),      
--@sEve as char(4)      
--)                                        
--AS                            
--BEGIN                                 
--              
--declare @ctrr as char(11)                
--declare @tot as int                
--declare @id as int                
--declare @idc as int                
--DECLARE @LIN AS VARCHAR(2)                
--                
-- DECLARE @eventosActuales TABLE (                  
--  [idreg] [int] NOT NULL,                                            
--  [idcont] [int] NOT NULL,                                            
--  [NroCtr] [char] (11) NOT NULL,                
--  [ok] [char](1) NULL                
--  )                  
--                
---------------- 1.ACTUALIZA INGRESOS DE HSD --------------------------------------                
-- if @sCodLin='HSD'                
-- BEGIN                
--	SET @LIN='1'                
--	if @sEve='0400' or @sEve='0500'         
--	BEGIN        
--		insert @eventosActuales(idreg,idcont,nroctr)                
--            
--		select b.idregistro,a.idcontador,b.contenedor                
--		from oceanicaP1.descarga.dbo.LIN_HSD_INGRESOS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'            
--		and B.idlinea=@LIN               
--		and @sEve=case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--			update oceanicaP1.descarga.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--			update @eventosActuales set ok='1' where idreg=@id                
--			select @tot=count(*) from @eventosActuales where ok is null                
--		END        
--	END        
--
--	if @sEve='0900'        
--	BEGIN        
--		insert @eventosActuales(idreg,idcont,nroctr)                
--            
--		select b.idregistro,a.idcontador,b.contenedor                
--		from neptuniaP2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'            
--		and B.idlinea=@LIN               
--		and @sEve=c.codigo        
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--			update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve    
--			update @eventosActuales set ok='1' where idcont=@idc               
--			select @tot=count(*) from @eventosActuales where ok is null                
--		END     
--	END
--        
--	if @sEve='0200'        
--	BEGIN        
--		PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'        
--		--  insert @eventosActuales(idreg,idcont,nroctr)       
--		--                
--		--  select b.idregistro,a.idcontador,b.contenedor                
--		--  from neptuniaP1.TERMINAL.dbo.LIN_HSD_INGRESOS A with(nolock)                 
--		--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		--  where                 
--		--  a.estado='COM'                
--		--  and B.estado='ENV'            
--		--  and B.idlinea=@LIN               
--		--  and @sEve=c.codigo        
--		--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--		--          
--		--  select @tot=count(*) from @eventosActuales where ok is null                
--		--  WHILE @tot>0                                     
--		--  BEGIN                   
--		--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		--   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--		--   update @eventosActuales set ok='1' where idreg=@id                
--		--   select @tot=count(*) from @eventosActuales where ok is null                
--		--  END        
--	END        
--              
-- END              
--              
---------------- 2.ACTUALIZA INGRESOS DE HLE --------------------------------------                
-- if @sCodLin='HLE' AND (@sEve='0400' OR @sEve='0500')                
-- BEGIN                
--	SET @LIN='2'              
--	  
--	insert @eventosActuales(idreg,idcont,nroctr)                
--                
--	select b.idregistro,a.idcontador,b.contenedor                
--	from oceanicaP1.descarga.dbo.LIN_HLE_INGRESOS A with(nolock)                 
--	INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--	INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--	where                 
--	a.estado='COM'                
--	and B.estado='ENV'             
--	and B.idlinea=@LIN               
--	and @sEve=case c.codigo when '0400' then '0400' when '0500' then '0400' end --and b.idevento in ('5','6')                
--	and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--	and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--	select @tot=count(*) from @eventosActuales where ok is null                
--	WHILE @tot>0                                     
--	BEGIN                   
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		update oceanicaP1.descarga.dbo.LIN_HLE_INGRESOS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--		update @eventosActuales set ok='1' where idreg=@id                
--		select @tot=count(*) from @eventosActuales where ok is null                
--	END                
-- END              
--              
--END 
--GO
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS            
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 07/11/2012 10:01:26 ******/                    
--                  
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS]                  
--(@sCodLin as char(3),          
--@sEve as char(4),  
--@local as char(5)      
--)             
--AS                                    
--BEGIN                                   
--            
-- declare @ctrr as char(11)                  
-- declare @tot as int                  
-- declare @id as int                  
-- declare @idc as int               
-- DECLARE @LIN AS VARCHAR(2)                   
--            
-- DECLARE @eventosActuales TABLE (                    
-- [idreg] [int] NOT NULL,                                              
-- [idcont] [int] NOT NULL,                                              
-- [NroCtr] [char] (11) NOT NULL,                  
-- [ok] [char](1) NULL                  
-- )               
---------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------                
-- if @sCodLin='HSD'                
-- BEGIN                
--	SET @LIN='1'              
--	if @sEve='0715' or @sEve='0800'
--	begin      
--		IF @local='LIMA'      
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--	          
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from oceanica1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN            
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			-- and a.contenedor='SUDU7462756'                      
--			     
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update oceanica1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END
--		end
--
--		IF @local='PAITA'      
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--	          
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from oceanicaP1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN            
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			-- and a.contenedor='SUDU7462756'                      
--			     
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update oceanicaP1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END
--		end
--                  
--	end
--      
--	if @sEve='1000'
--	BEGIN   
--		IF @local='LIMA'      
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN  
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			--and a.contenedor='SUDU7541665'  
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve    
--
--				update @eventosActuales set ok='1' where idcont=@idc                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		end
--
--		IF @local='PAITA'  
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN            
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			-- and a.contenedor='SUDU7462756'                      
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc AND EVENTO=@sEve    
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		end   
--	END
--
--     
--	if @sEve='0230'      
--	begin      
--		PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'      
--		--  insert @eventosActuales(idreg,idcont,nroctr)                    
--		--           
--		--  select b.idregistro,a.idcontador,b.contenedor                    
--		--  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS A with(nolock)                     
--		--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                    
--		--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--		--  where                     
--		--  a.estado='COM'              
--		--  and B.estado='ENV'       
--		--  and B.idlinea=@LIN               
--		--  and @sEve=c.codigo --and b.idevento in ('10','12')      
--		--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--		--  -- and a.contenedor='SUDU7462756'               
--		--      
--		--  select @tot=count(*) from @eventosActuales where ok is null                    
--		--  WHILE @tot>0                                         
--		--  BEGIN                       
--		--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                    
--		--   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                    
--		--   update @eventosActuales set ok='1' where idreg=@id                    
--		--   select @tot=count(*) from @eventosActuales where ok is null                    
--		--  END                    
--	END        
--      
-- END            
---------------------------------------------------------------------
---------------------------------------------------------------------           
-- if @sCodLin='HLE' AND (@sEve='0715' OR @sEve='0800')      
-- BEGIN  
--	IF @local='LIMA'      
--	begin      
--		SET @LIN='2'              
--		insert @eventosActuales(idreg,idcont,nroctr)                  
--
--		select b.idregistro,a.idcontador,b.contenedor                  
--		from oceanica1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                   
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
--		where                   
--		a.estado='COM'           
--		and B.estado='ENV'             
--		and B.idlinea=@LIN      
--		and @sEve=c.codigo --case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                           
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--
--		select @tot=count(*) from @eventosActuales where ok is null                  
--
--		WHILE @tot>0                                       
--		BEGIN                     
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--			update oceanica1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--			update @eventosActuales set ok='1' where idreg=@id                  
--			select @tot=count(*) from @eventosActuales where ok is null                  
--		END                  
--	END
--
--	IF @local='PAITA'      
--	begin      
--		SET @LIN='2'              
--		insert @eventosActuales(idreg,idcont,nroctr)                  
--
--		select b.idregistro,a.idcontador,b.contenedor                  
--		from oceanicaP1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                   
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
--		where                   
--		a.estado='COM'           
--		and B.estado='ENV'             
--		and B.idlinea=@LIN      
--		and @sEve=c.codigo --case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                           
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--
--		select @tot=count(*) from @eventosActuales where ok is null                  
--
--		WHILE @tot>0                                       
--		BEGIN                     
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--			update oceanicaP1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--			update @eventosActuales set ok='1' where idreg=@id                  
--			select @tot=count(*) from @eventosActuales where ok is null                  
--		END                  
--	END
--
-- END                
---------------------------------------------------------------------
---------------------------------------------------------------------           
--
--END 
--GO
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS_CALLAO            
            
                
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 07/11/2012 10:01:26 ******/                    
                      
                  
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]                  
--(@sCodLin as char(3),          
--@sEve as char(4)      
--)             
--AS                                    
--BEGIN                                   
--            
-- declare @ctrr as char(11)                  
-- declare @tot as int                  
-- declare @id as int                  
-- declare @idc as int               
-- DECLARE @LIN AS VARCHAR(2)                   
--            
-- DECLARE @eventosActuales TABLE (                    
-- [idreg] [int] NOT NULL,                                              
-- [idcont] [int] NOT NULL,                                              
-- [NroCtr] [char] (11) NOT NULL,                  
-- [ok] [char](1) NULL                  
-- )               
---------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------                
-- if @sCodLin='HSD'                
-- BEGIN                
-- SET @LIN='1'              
-- if @sEve='0715' or @sEve='0800'       
-- begin      
--  insert @eventosActuales(idreg,idcont,nroctr)                  
--              
--  select b.idregistro,a.idcontador,b.contenedor                  
--  from oceanica1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--  where                   
--  a.estado='COM'                  
--  and B.estado='ENV'       
--  and B.idlinea=@LIN            
--  and @sEve=c.codigo --and b.idevento in ('10','12')      
--  and convert(char(8),A.FEC_COMPLETA,112)>=convert(char(8),dateadd(d,-5,B.FECHAEVENTO),112)          
--  and convert(char(8),A.FEC_COMPLETA,112)<=convert(char(8),dateadd(d,5,B.FECHAEVENTO),112)          
--  -- and a.contenedor='SUDU7462756'                      
--                 
--  select @tot=count(*) from @eventosActuales where ok is null                  
--  WHILE @tot>0                                       
--  BEGIN                     
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--   update oceanica1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--   update @eventosActuales set ok='1' where idreg=@id                  
--   select @tot=count(*) from @eventosActuales where ok is null                  
--  END                  
-- end      
-- if @sEve='1000'      
-- begin      
--  insert @eventosActuales(idreg,idcont,nroctr)                  
--              
--  select b.idregistro,a.idcontador,b.contenedor                  
--  from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--  where                   
--  a.estado='COM'                  
--  and B.estado='ENV'       
--  and B.idlinea=@LIN            
--  and @sEve=c.codigo --and b.idevento in ('10','12')      
--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(d,-5,B.FECHAEVENTO),112)          
--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(d,5,B.FECHAEVENTO),112)          
--  -- and a.contenedor='SUDU7462756'                      
--                 
--  select @tot=count(*) from @eventosActuales where ok is null                  
--  WHILE @tot>0                                       
--  BEGIN                     
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--   update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc AND EVENTO=@sEve    
--   update @eventosActuales set ok='1' where idreg=@id                  
--   select @tot=count(*) from @eventosActuales where ok is null                  
--  END                  
--end      
-- if @sEve='0230'      
-- begin      
--        PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'      
----  insert @eventosActuales(idreg,idcont,nroctr)                    
----           
----  select b.idregistro,a.idcontador,b.contenedor                    
----  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS A with(nolock)                     
----  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                    
----  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
----  where                     
----  a.estado='COM'              
----  and B.estado='ENV'       
----  and B.idlinea=@LIN               
----  and @sEve=c.codigo --and b.idevento in ('10','12')      
----  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
----  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
----  -- and a.contenedor='SUDU7462756'               
----      
----  select @tot=count(*) from @eventosActuales where ok is null                    
----  WHILE @tot>0                                         
----  BEGIN                       
----   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                    
----   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                    
----   update @eventosActuales set ok='1' where idreg=@id                    
----   select @tot=count(*) from @eventosActuales where ok is null                    
----  END                    
-- END        
--      
-- END            
--            
-- if @sCodLin='HLE' AND (@sEve='0715' OR @sEve='0800')      
-- BEGIN                
-- SET @LIN='2'              
-- insert @eventosActuales(idreg,idcont,nroctr)                  
--      
-- select b.idregistro,a.idcontador,b.contenedor                  
-- from oceanica1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                   
-- INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
-- INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
-- where                   
-- a.estado='COM'           
-- and B.estado='ENV'             
-- and B.idlinea=@LIN      
-- and @sEve=case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                           
-- and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
-- and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--      
--      
-- select @tot=count(*) from @eventosActuales where ok is null                  
--      
-- WHILE @tot>0                                       
-- BEGIN                     
--  select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--  update oceanica1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--  update @eventosActuales set ok='1' where idreg=@id                  
--  select @tot=count(*) from @eventosActuales where ok is null                  
-- END                  
-- END                
--            
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_bk]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 07/11/2012 10:01:26 ******/              
--                
--            
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_bk]
--(@sCodLin as char(3)          
--)       
--AS                              
--BEGIN                             
--      
-- declare @ctrr as char(11)            
-- declare @tot as int            
-- declare @id as int            
-- declare @idc as int         
-- DECLARE @LIN AS VARCHAR(2)             
--      
-- DECLARE @eventosActuales TABLE (              
-- [idreg] [int] NOT NULL,                                        
-- [idcont] [int] NOT NULL,                                        
-- [NroCtr] [char] (11) NOT NULL,            
-- [ok] [char](1) NULL            
-- )         
---------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------          
-- if @sCodLin='HSD'          
-- BEGIN          
--  SET @LIN='1'        
--           
--  insert @eventosActuales(idreg,idcont,nroctr)            
--          
--  select b.idregistro,a.idcontador,b.contenedor            
--  from oceanica1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)             
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS            
--  --INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento        
--  where             
--  a.estado='COM'            
--  and B.idlinea=@LIN      
--  --and a.evento=c.codigo COLLATE SQL_Latin1_General_CP1_CI_AS         
--  and B.estado='ENV' and b.idevento  in ('10','12') -- eventos de salidas        
--  --AND A.FECHA>=dateadd(MINUTE,-15,B.FECHAEVENTO) AND A.FECHA<=dateadd(MINUTE,15,B.FECHAEVENTO)      
--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
--           
--             
--  select @tot=count(*) from @eventosActuales where ok is null            
--          
--  WHILE @tot>0                                 
--  BEGIN               
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null            
--           
--   update oceanica1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc            
--   update @eventosActuales set ok='1' where idreg=@id            
--           
--   select @tot=count(*) from @eventosActuales where ok is null            
--  END            
-- END      
--      
-- if @sCodLin='HLE'          
-- BEGIN          
--  SET @LIN='2'        
--           
--  insert @eventosActuales(idreg,idcont,nroctr)            
--          
--  select b.idregistro,a.idcontador,b.contenedor            
--  from oceanica1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)             
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS            
--  where             
--  a.estado='COM'            
--  and B.idlinea=@LIN and B.estado='ENV' and b.idevento in ('10')            
--  --AND A.FECHA>=dateadd(MINUTE,-15,B.FECHAEVENTO) AND A.FECHA<=dateadd(MINUTE,15,B.FECHAEVENTO)            
--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
--           
--             
--  select @tot=count(*) from @eventosActuales where ok is null            
--          
--  WHILE @tot>0                                 
--  BEGIN               
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null            
--           
--   update oceanica1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc            
--   update @eventosActuales set ok='1' where idreg=@id            
--           
--   select @tot=count(*) from @eventosActuales where ok is null            
--  END            
-- END          
--      
--      
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_V]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS_CALLAO          
          
              
/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 07/11/2012 10:01:26 ******/                  
                    
                
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_V]                
--(@sCodLin as char(3),        
--@sEve as char(4),
--@local as char(5)    
--)           
--AS                                  
--BEGIN                                 
--          
-- declare @ctrr as char(11)                
-- declare @tot as int                
-- declare @id as int                
-- declare @idc as int             
-- DECLARE @LIN AS VARCHAR(2)                 
--          
-- DECLARE @eventosActuales TABLE (                  
-- [idreg] [int] NOT NULL,                                            
-- [idcont] [int] NOT NULL,                                            
-- [NroCtr] [char] (11) NOT NULL,                
-- [ok] [char](1) NULL                
-- )             
---------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------              
-- if @sCodLin='HSD'              
-- BEGIN              
-- SET @LIN='1'            
-- if @sEve='0715' or @sEve='0800'     
-- begin    
--  insert @eventosActuales(idreg,idcont,nroctr)                
--            
--  select b.idregistro,a.idcontador,b.contenedor                
--  from oceanica1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--  where                 
--  a.estado='COM'                
--  and B.estado='ENV'     
--  and B.idlinea=@LIN          
--  and @sEve=c.codigo --and b.idevento in ('10','12')    
--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)        
--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)        
--  -- and a.contenedor='SUDU7462756'                    
--               
--  select @tot=count(*) from @eventosActuales where ok is null                
--  WHILE @tot>0                                     
--  BEGIN                   
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--   update oceanica1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--   update @eventosActuales set ok='1' where idreg=@id                
--   select @tot=count(*) from @eventosActuales where ok is null                
--  END                
-- end    
-- if @sEve='1000' 
--	IF @local='LIMA'    
--	begin    
--		insert @eventosActuales(idreg,idcont,nroctr)                
--		        
--		select b.idregistro,a.idcontador,b.contenedor                
--		from [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'     
--		and B.idlinea=@LIN          
--		and @sEve=c.codigo --and b.idevento in ('10','12')    
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)        
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)        
--		-- and a.contenedor='SUDU7462756'                    
--		           
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc AND EVENTO=@sEve  
--		update @eventosActuales set ok='1' where idreg=@id                
--		select @tot=count(*) from @eventosActuales where ok is null                
--		END                
--	end
--	IF @local='PAITA'
--	begin    
--		insert @eventosActuales(idreg,idcont,nroctr)                
--		        
--		select b.idregistro,a.idcontador,b.contenedor                
--		from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
--		where                 
--		a.estado='COM'                
--		and B.estado='ENV'     
--		and B.idlinea=@LIN          
--		and @sEve=c.codigo --and b.idevento in ('10','12')    
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)        
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)        
--		-- and a.contenedor='SUDU7462756'                    
--		           
--		select @tot=count(*) from @eventosActuales where ok is null                
--		WHILE @tot>0                                     
--		BEGIN                   
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--		update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc AND EVENTO=@sEve  
--		update @eventosActuales set ok='1' where idreg=@id                
--		select @tot=count(*) from @eventosActuales where ok is null                
--		END                
--	end	
--    
-- if @sEve='0230'    
-- begin    
--        PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'    
----  insert @eventosActuales(idreg,idcont,nroctr)                  
----         
----  select b.idregistro,a.idcontador,b.contenedor                  
----  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS A with(nolock)                   
----  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
----  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento            
----  where                   
----  a.estado='COM'            
----  and B.estado='ENV'     
----  and B.idlinea=@LIN             
----  and @sEve=c.codigo --and b.idevento in ('10','12')    
----  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)        
----  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)        
----  -- and a.contenedor='SUDU7462756'             
----    
----  select @tot=count(*) from @eventosActuales where ok is null                  
----  WHILE @tot>0                                       
----  BEGIN                     
----   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
----   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
----   update @eventosActuales set ok='1' where idreg=@id                  
----   select @tot=count(*) from @eventosActuales where ok is null                  
----  END                  
-- END      
--    
-- END          
--          
-- if @sCodLin='HLE' AND (@sEve='0715' OR @sEve='0800')    
-- BEGIN              
-- SET @LIN='2'            
-- insert @eventosActuales(idreg,idcont,nroctr)                
--    
-- select b.idregistro,a.idcontador,b.contenedor                
-- from oceanica1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                 
-- INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
-- INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento        
-- where                 
-- a.estado='COM'         
-- and B.estado='ENV'           
-- and B.idlinea=@LIN    
-- and @sEve=case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                         
-- and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)        
-- and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)        
--    
--    
-- select @tot=count(*) from @eventosActuales where ok is null                
--    
-- WHILE @tot>0                                     
-- BEGIN                   
--  select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--  update oceanica1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--  update @eventosActuales set ok='1' where idreg=@id                
--  select @tot=count(*) from @eventosActuales where ok is null                
-- END                
-- END              
--          
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_V2]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS_CALLAO            
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO]    Script Date: 07/11/2012 10:01:26 ******/                    
--                  
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_CALLAO_V2]                  
--(@sCodLin as char(3),          
--@sEve as char(4),  
--@local as char(5)      
--)             
--AS                                    
--BEGIN                                   
--            
-- declare @ctrr as char(11)                  
-- declare @tot as int                  
-- declare @id as int                  
-- declare @idc as int               
-- DECLARE @LIN AS VARCHAR(2)                   
--            
-- DECLARE @eventosActuales TABLE (                    
-- [idreg] [int] NOT NULL,                                              
-- [idcont] [int] NOT NULL,                                              
-- [NroCtr] [char] (11) NOT NULL,                  
-- [ok] [char](1) NULL                  
-- )               
---------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------                
-- if @sCodLin='HSD'                
-- BEGIN                
--	SET @LIN='1'              
--	if @sEve='0715' or @sEve='0800'       
--	begin      
--		insert @eventosActuales(idreg,idcont,nroctr)                  
--          
--		select b.idregistro,a.idcontador,b.contenedor                  
--		from oceanica1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--		where                   
--		a.estado='COM'                  
--		and B.estado='ENV'       
--		and B.idlinea=@LIN            
--		and @sEve=c.codigo --and b.idevento in ('10','12')      
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--		-- and a.contenedor='SUDU7462756'                      
--		     
--		select @tot=count(*) from @eventosActuales where ok is null                  
--		WHILE @tot>0                                       
--		BEGIN                     
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--			update oceanica1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--			update @eventosActuales set ok='1' where idreg=@id                  
--			select @tot=count(*) from @eventosActuales where ok is null                  
--		END                  
--	end
--      
--	if @sEve='1000'
--	BEGIN   
--		IF @local='LIMA'      
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN  
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			--and a.contenedor='SUDU7541665'  
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update [SP3TDA-DBSQL01].Descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where idcontador=@idc AND EVENTO=@sEve    
--
--				update @eventosActuales set ok='1' where idcont=@idc                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		end
--
--		IF @local='PAITA'  
--		begin      
--			insert @eventosActuales(idreg,idcont,nroctr)                  
--
--			select b.idregistro,a.idcontador,b.contenedor                  
--			from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                   
--			INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--			INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--			where                   
--			a.estado='COM'                  
--			and B.estado='ENV'       
--			and B.idlinea=@LIN            
--			and @sEve=c.codigo --and b.idevento in ('10','12')      
--			and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--			and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--			-- and a.contenedor='SUDU7462756'                      
--
--			select @tot=count(*) from @eventosActuales where ok is null                  
--			WHILE @tot>0                                       
--			BEGIN                     
--				select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--				update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc AND EVENTO=@sEve    
--				update @eventosActuales set ok='1' where idreg=@id                  
--				select @tot=count(*) from @eventosActuales where ok is null                  
--			END                  
--		end   
--	END
--
--     
--	if @sEve='0230'      
--	begin      
--		PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIA1'      
--		--  insert @eventosActuales(idreg,idcont,nroctr)                    
--		--           
--		--  select b.idregistro,a.idcontador,b.contenedor                    
--		--  from [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS A with(nolock)                     
--		--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                    
--		--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento              
--		--  where                     
--		--  a.estado='COM'              
--		--  and B.estado='ENV'       
--		--  and B.idlinea=@LIN               
--		--  and @sEve=c.codigo --and b.idevento in ('10','12')      
--		--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--		--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--		--  -- and a.contenedor='SUDU7462756'               
--		--      
--		--  select @tot=count(*) from @eventosActuales where ok is null                    
--		--  WHILE @tot>0                                         
--		--  BEGIN                       
--		--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                    
--		--   update [SP3TDA-DBSQL01].Terminal.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                    
--		--   update @eventosActuales set ok='1' where idreg=@id                    
--		--   select @tot=count(*) from @eventosActuales where ok is null                    
--		--  END                    
--	END        
--      
-- END            
---------------------------------------------------------------------
---------------------------------------------------------------------           
-- if @sCodLin='HLE' AND (@sEve='0715' OR @sEve='0800')      
-- BEGIN                
--	SET @LIN='2'              
--	insert @eventosActuales(idreg,idcont,nroctr)                  
--
--	select b.idregistro,a.idcontador,b.contenedor                  
--	from oceanica1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                   
--	INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                  
--	INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
--	where                   
--	a.estado='COM'           
--	and B.estado='ENV'             
--	and B.idlinea=@LIN      
--	and @sEve=case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                           
--	and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)          
--	and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)          
--
--
--	select @tot=count(*) from @eventosActuales where ok is null                  
--
--	WHILE @tot>0                                       
--	BEGIN                     
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                  
--		update oceanica1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                  
--		update @eventosActuales set ok='1' where idreg=@id                  
--		select @tot=count(*) from @eventosActuales where ok is null                  
--	END                  
--
-- END                
---------------------------------------------------------------------
---------------------------------------------------------------------           
--
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS_PAITA    
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA]    Script Date: 07/11/2012 10:01:26 ******/                  
--                    
--                
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA]  
--(@sCodLin as char(3),      
--@sEve as char(4)            
--)            
--AS                                  
--BEGIN                                 
--            
-- declare @ctrr as char(11)                
-- declare @tot as int                
-- declare @id as int                
-- declare @idc as int             
-- DECLARE @LIN AS VARCHAR(2)            
--              
-- DECLARE @eventosActuales TABLE (                  
--  [idreg] [int] NOT NULL,                                            
--  [idcont] [int] NOT NULL,                                            
--  [NroCtr] [char] (11) NOT NULL,                
--  [ok] [char](1) NULL                
-- )                  
--              
-- -------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------            
-- if @sCodLin='HSD'            
-- BEGIN            
-- SET @LIN='1'            
-- if @sEve='0715' or @sEve='0800'   
-- begin  
--          
--  insert @eventosActuales(idreg,idcont,nroctr)                
--              
--  select b.idregistro,a.idcontador,b.contenedor                
--  from oceanicap1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
--  where                 
--  a.estado='COM'          
--  and B.estado='ENV'   
--  and B.idlinea=@LIN           
--  and @sEve=c.codigo --and b.idevento in ('10','12')  
--  and convert(char(8),A.FEC_COMPLETA,112)>=convert(char(8),dateadd(d,-5,B.FECHAEVENTO),112)      
--  and convert(char(8),A.FEC_COMPLETA,112)<=convert(char(8),dateadd(d,5,B.FECHAEVENTO),112)      
--  -- and a.contenedor='SUDU7462756'           
--  
--  select @tot=count(*) from @eventosActuales where ok is null                
--  WHILE @tot>0                                     
--  BEGIN                   
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--   update oceanicaP1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--   update @eventosActuales set ok='1' where idreg=@id                
--   select @tot=count(*) from @eventosActuales where ok is null                
--  END                
-- END            
-- if @sEve='1000'  
-- begin  
--          
--  insert @eventosActuales(idreg,idcont,nroctr)                
--              
--  select b.idregistro,a.idcontador,b.contenedor                
--  from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)                 
--  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
--  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
--  where                 
--  a.estado='COM'          
--  and B.estado='ENV'   
--  and B.idlinea=@LIN           
--  and @sEve=c.codigo --and b.idevento in ('10','12')  
--  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)      
--  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)      
--  -- and a.contenedor='SUDU7462756'           
--  
--  select @tot=count(*) from @eventosActuales where ok is null                
--  WHILE @tot>0                                     
--  BEGIN                   
--   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--   update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--   update @eventosActuales set ok='1' where idreg=@id                
--   select @tot=count(*) from @eventosActuales where ok is null                
--  END                
-- END    
-- if @sEve='0230'  
-- begin  
--        PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIAP1'  
----  insert @eventosActuales(idreg,idcont,nroctr)                
----              
----  select b.idregistro,a.idcontador,b.contenedor                
----  from NEPTUNIAp1.TERMINAL.dbo.LIN_HSD_SALIDAS A with(nolock)                 
----  INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
----  INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento          
----  where                 
----  a.estado='COM'          
----  and B.estado='ENV'   
----  and B.idlinea=@LIN           
----  and @sEve=c.codigo --and b.idevento in ('10','12')  
----  and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)      
----  and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)      
----  -- and a.contenedor='SUDU7462756'           
----  
----  select @tot=count(*) from @eventosActuales where ok is null                
----  WHILE @tot>0                                     
----  BEGIN                   
----   select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
----   update NEPTUNIAp1.TERMINAL.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
----   update @eventosActuales set ok='1' where idreg=@id                
----   select @tot=count(*) from @eventosActuales where ok is null                
----  END                
-- END    
--  
-- END  
--  
-- if @sCodLin='HLE' AND (@sEve='0715' OR @sEve='0800')  
-- BEGIN            
-- SET @LIN='2'  
-- insert @eventosActuales(idreg,idcont,nroctr)                
--           
-- select b.idregistro,a.idcontador,b.contenedor                
-- from oceanicap1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)                 
-- INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS                
-- INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento      
-- where                 
-- a.estado='COM'       
-- and B.estado='ENV'           
-- and B.idlinea=@LIN  
-- and @sEve=case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                       
-- and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)      
-- and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)      
--          
-- select @tot=count(*) from @eventosActuales where ok is null                
--          
-- WHILE @tot>0                                     
-- BEGIN                   
--  select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null                
--  update oceanicap1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc                
--  update @eventosActuales set ok='1' where idreg=@id            
--  select @tot=count(*) from @eventosActuales where ok is null                
-- END                
--  
-- END            
--                
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA_bk]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- SP_HELPTEXT LIN_ACTUALIZA_SALIDAS_PAITA  
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA]    Script Date: 07/11/2012 10:01:26 ******/                
--                  
--              
--ALTER PROCEDURE [dbo].[LIN_ACTUALIZA_SALIDAS_PAITA_bk]
--(@sCodLin as char(3),    
--@sEve as char(4)          
--)          
--AS                                
--BEGIN                               
--          
-- declare @ctrr as char(11)              
-- declare @tot as int              
-- declare @id as int              
-- declare @idc as int           
-- DECLARE @LIN AS VARCHAR(2)          
--            
-- DECLARE @eventosActuales TABLE (                
--  [idreg] [int] NOT NULL,                                          
--  [idcont] [int] NOT NULL,                                          
--  [NroCtr] [char] (11) NOT NULL,              
--  [ok] [char](1) NULL              
-- )                
--            
-- -------------- 1.ACTUALIZA SALIDAS DE HSD --------------------------------------          
-- if @sCodLin='HSD'          
-- BEGIN          
--	SET @LIN='1'          
--	if @sEve='0715' or @sEve='0800' 
--	begin
--        
--		insert @eventosActuales(idreg,idcont,nroctr)              
--            
--		select b.idregistro,a.idcontador,b.contenedor              
--		from oceanicap1.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)               
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS              
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento        
--		where               
--		a.estado='COM'        
--		and B.estado='ENV' 
--		and B.idlinea=@LIN         
--		and @sEve=c.codigo --and b.idevento in ('10','12')
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
--		-- and a.contenedor='SUDU7462756'         
--
--		select @tot=count(*) from @eventosActuales where ok is null              
--		WHILE @tot>0                                   
--		BEGIN                 
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null              
--			update oceanicaP1.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc              
--			update @eventosActuales set ok='1' where idreg=@id              
--			select @tot=count(*) from @eventosActuales where ok is null              
--		END              
--	END          
--	if @sEve='1000'
--	begin
--        
--		insert @eventosActuales(idreg,idcont,nroctr)              
--            
--		select b.idregistro,a.idcontador,b.contenedor              
--		from NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS A with(nolock)               
--		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS              
--		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento        
--		where               
--		a.estado='COM'        
--		and B.estado='ENV' 
--		and B.idlinea=@LIN         
--		and @sEve=c.codigo --and b.idevento in ('10','12')
--		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
--		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
--		-- and a.contenedor='SUDU7462756'         
--
--		select @tot=count(*) from @eventosActuales where ok is null              
--		WHILE @tot>0                                   
--		BEGIN                 
--			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null              
--			update NEPTUNIAp2.descarga.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc              
--			update @eventosActuales set ok='1' where idreg=@id              
--			select @tot=count(*) from @eventosActuales where ok is null              
--		END              
--	END  
--	if @sEve='0230'
--	begin
--        PRINT 'AUN NO IMPLEMENTADO CONTROL EN NEPTUNIAP1'
----		insert @eventosActuales(idreg,idcont,nroctr)              
----            
----		select b.idregistro,a.idcontador,b.contenedor              
----		from NEPTUNIAp1.TERMINAL.dbo.LIN_HSD_SALIDAS A with(nolock)               
----		INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS              
----		INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento        
----		where               
----		a.estado='COM'        
----		and B.estado='ENV' 
----		and B.idlinea=@LIN         
----		and @sEve=c.codigo --and b.idevento in ('10','12')
----		and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
----		and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
----		-- and a.contenedor='SUDU7462756'         
----
----		select @tot=count(*) from @eventosActuales where ok is null              
----		WHILE @tot>0                                   
----		BEGIN                 
----			select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null              
----			update NEPTUNIAp1.TERMINAL.dbo.LIN_HSD_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc              
----			update @eventosActuales set ok='1' where idreg=@id              
----			select @tot=count(*) from @eventosActuales where ok is null              
----		END              
--	END  
--
-- END
--
-- if @sCodLin='HLE'  AND (@sEve='0715' OR @sEve='0800')
-- BEGIN          
--	SET @LIN='2'
--	insert @eventosActuales(idreg,idcont,nroctr)              
--	        
--	select b.idregistro,a.idcontador,b.contenedor              
--	from oceanicap1.descarga.dbo.LIN_HLE_SALIDAS A with(nolock)               
--	INNER JOIN lin_registro B with(nolock)  ON a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS              
--	INNER JOIN lin_evento C with(nolock)  ON b.idevento=c.idevento    
--	where               
--	a.estado='COM'     
--	and B.estado='ENV'         
--	and B.idlinea=@LIN
--	and b.idevento in ('10') 
--	and @sEve=case c.codigo when '0715' then '0715' when '0800' then '0715' end --and b.idevento in ('5','6')                     
--	and convert(char(8),A.FECHA,112)>=convert(char(8),dateadd(MINUTE,-15,B.FECHAEVENTO),112)    
--	and convert(char(8),A.FECHA,112)<=convert(char(8),dateadd(MINUTE,15,B.FECHAEVENTO),112)    
--        
--	select @tot=count(*) from @eventosActuales where ok is null              
--        
--	WHILE @tot>0                                   
--	BEGIN                 
--		select top 1 @ctrr=nroctr,@id=idreg,@idc=idcont from @eventosActuales where ok is null              
--		update oceanicap1.descarga.dbo.LIN_HLE_SALIDAS set estado ='ENV' where contenedor=@ctrr and idcontador=@idc              
--		update @eventosActuales set ok='1' where idreg=@id          
--		select @tot=count(*) from @eventosActuales where ok is null              
--	END              
--
-- END          
--              
--END 
--GO
--/****** Object:  StoredProcedure [dbo].[LIN_ACTUALIZACIONENVIOREGISTROMANUAL]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
  
-- =============================================        
-- Author:  Luis Cuadra      
-- Create date: 10/11/2011        
-- Description:         
-- =============================================        
--[LIN_ACTUALIZACIONENVIOREGISTROMANUAL]       
    
ALTER PROCEDURE [dbo].[LIN_ACTUALIZACIONENVIOREGISTROMANUAL]    
@IDREGISTRO INT,    
@ESTADO VARCHAR(4),    
@FLGENV BIT    
AS    
BEGIN   

if @ESTADO = 'GEN' 
	SET @ESTADO = 'VAL'
	 
UPDATE LIN_REGISTRO    
SET     
ESTADO = @ESTADO,    
EnvioManual = @FLGENV,    
FecGen = getdate()    
WHERE IDREGISTRO = @IDREGISTRO    
END 
 
GO
/****** Object:  StoredProcedure [dbo].[Lin_Actualizar_Campos_Faltantes]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Actualizar_Campos_Faltantes]
@idregistro int,
@fechaevento datetime,
@navvia varchar(10),
@tipodocumento varchar(10),
@numerodocumento varchar(15),
@bookingbl varchar(15),
@genbkg varchar(15)
as

UPDATE Lin_registro
SET FechaEvento=@fechaevento,Navvia=@navvia,TipoDocumento=@tipodocumento,NumeroDocumento=@numerodocumento,BookingBL=@bookingbl,Genbkg=@genbkg
WHERE Idregistro=@idregistro;
GO
/****** Object:  StoredProcedure [dbo].[Lin_Actualizar_Parametros]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Actualizar_Parametros]
@ID int,
@Valor Varchar(150)
as

Update lin_Parametros set [Par_Valor]=@Valor where [Par_ID] = @ID
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarCampo]
(
	@IdCampo int,
	@IdEvento int,
	@Codigo nvarchar(15),
	@Nombre nvarchar(100),
	@TipoDato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Campo
	SET		IdEvento = @IdEvento,
			Codigo = @Codigo,
			Nombre = @Nombre,
			TipoDato = @TipoDato
	WHERE	IdCampo = @IdCampo
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarEquivalencia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarEquivalencia]
(
	@IdEquivalencia int,
	@IdCampo int,
	@ValorOriginal nvarchar(100),
	@ValorEquivalente nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Equivalencia
	SET		IdCampo = @IdCampo,
			ValorOriginal = @ValorOriginal,
			ValorEquivalente = @ValorEquivalente
	WHERE	IdEquivalencia = @IdEquivalencia
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarEvento]
(
	@IdEvento int,
	@Codigo nvarchar(10),
	@Nombre nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Evento
	SET		Codigo = @Codigo,
			Nombre = @Nombre
	WHERE	IdEvento = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarFechaProcesoCorte]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --LIN_ActualizarFechaProcesoCorte 5,1  
  
-- =============================================  
-- Author:  MDTEC-K  
-- Create date: 27/10/2012  
-- Description: Actualiza el proceso ejecutado e inserta el próximo  
-- =============================================  
  
ALTER PROCEDURE [dbo].[LIN_ActualizarFechaProcesoCorte]  
(  
   @IdLinea INT 
 , @IdGrupo INT 
 , @IdProceso INT  
)  
  
AS  
   
  
DECLARE @FechaCorteAnterior DATETIME  
DECLARE @FechaCorteProximo DATETIME  
  
SET @FechaCorteAnterior =   
(  
SELECT TOP 1 FechaCorte   
  FROM (  
  SELECT IdHoraCorte   
    , DATEADD(MINUTE,MinutoCorte,DATEADD(HOUR,HoraCorte,CONVERT(DATETIME  
         , RIGHT('0' + CAST(DAY(GETDATE())AS VARCHAR),2)+ '/'  
         + RIGHT('0' + CAST(MONTH(GETDATE())AS VARCHAR),2)+ '/'  
         + CAST(YEAR(GETDATE())AS VARCHAR)   
         , 103))) FechaCorte  
    , HoraCorte, MinutoCorte  
    FROM LIN_Linea_HoraCorte  
   WHERE IdLinea = @IdLinea  
     AND IdGrupo = @IdGrupo
   UNION  
   SELECT IdHoraCorte   
    , DATEADD(MINUTE,MinutoCorte,DATEADD(HOUR,HoraCorte,CONVERT(DATETIME  
         , RIGHT('0' + CAST(DAY(GETDATE()-1)AS VARCHAR),2)+ '/'  
         + RIGHT('0' + CAST(MONTH(GETDATE()-1)AS VARCHAR),2)+ '/'  
         + CAST(YEAR(GETDATE()-1)AS VARCHAR)   
         , 103))) FechaCorte  
    , HoraCorte, MinutoCorte  
    FROM LIN_Linea_HoraCorte  
   WHERE IdLinea = @IdLinea  
     AND IdGrupo = @IdGrupo
   ) HC  
 WHERE HC.FechaCorte < GETDATE()  
ORDER BY FechaCorte DESC  
)  
  
PRINT @FechaCorteAnterior  
  
SET @FechaCorteProximo =   
(SELECT TOP 1 FechaCorte  
  FROM (  
SELECT IdHoraCorte   
    , DATEADD(MINUTE,MinutoCorte,DATEADD(HOUR,HoraCorte,CONVERT(DATETIME  
         , RIGHT('0' + CAST(DAY(GETDATE())AS VARCHAR),2)+ '/'  
         + RIGHT('0' + CAST(MONTH(GETDATE())AS VARCHAR),2)+ '/'  
         + CAST(YEAR(GETDATE())AS VARCHAR)   
         , 103))) FechaCorte  
    , HoraCorte, MinutoCorte  
    FROM LIN_Linea_HoraCorte  
   WHERE IdLinea = @IdLinea  
     AND IdGrupo = @IdGrupo
UNION  
SELECT IdHoraCorte   
    , DATEADD(MINUTE,MinutoCorte,DATEADD(HOUR,HoraCorte,CONVERT(DATETIME  
         , RIGHT('0' + CAST(DAY(GETDATE()+1)AS VARCHAR),2)+ '/'  
         + RIGHT('0' + CAST(MONTH(GETDATE()+1)AS VARCHAR),2)+ '/'  
         + CAST(YEAR(GETDATE()+1)AS VARCHAR)   
         , 103))) FechaCorte  
    , HoraCorte, MinutoCorte  
    FROM LIN_Linea_HoraCorte  
   WHERE IdLinea = @IdLinea
     AND IdGrupo = @IdGrupo) HC  
 WHERE FechaCorte > @FechaCorteAnterior   
 ORDER BY FechaCorte)  
   
 PRINT @FechaCorteProximo  
   
 UPDATE LIN_FechaProcesoCorte  
    SET FechaProceso = GETDATE()  
      , EstadoProceso = 'P'  
  WHERE IdProceso = @IdProceso  
    
 INSERT INTO LIN_FechaProcesoCorte (IdLinea,IdGrupo, FechaCorteAnterior, FechaCorteProximo, FechaProceso, EstadoProceso)  
      VALUES (@IdLinea, @IdGrupo, @FechaCorteAnterior, @FechaCorteProximo, null, 'N')  
   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarGrupo_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
    
-- =============================================          
-- Author: David Arias      
-- Create date: 20/12/2010          
-- Description:           
-- =============================================          
ALTER PROCEDURE [dbo].[LIN_ActualizarGrupo_IdLinea]          
(          
 @idGrupo int,
 @idEventoBase int,      
 @descripcion  varchar(250), 
 @EnvioAutomatico bit,
 @EnvioCorte bit, 
 @activo bit  
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
           
 UPDATE  LIN_Linea_Grupo  
    SET idEventoBase = @idEventoBase
      , descripcion = @descripcion  
      , EnvioAutomatico = @EnvioAutomatico 
      , EnvioCorte = @EnvioCorte
      , activo = @activo  
  WHERE idGrupo = @idGrupo  
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================      
-- Author:  Enrique Véliz      
-- Create date: 20/12/2010      
-- Description:       
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ActualizarLinea]      
(      
 @IdLinea int,      
 @Codigo nvarchar(10),      
 @Nombre nvarchar(100),      
 @PeriodoMinutos int,      
 @EnvioTotal bit,      
 @Activo bit,    
 @EnvioAutomatico bit,         
 @ConfiguracionCorte bit,
 @Email varchar(1000),
 @AsuntoEmail varchar(100)
)      
AS      
BEGIN      
 SET NOCOUNT ON;      
       
 UPDATE LIN_Linea      
 SET  Codigo = @Codigo,      
   Nombre = @Nombre,      
   PeriodoMinutos = @PeriodoMinutos,      
   EnvioTotal = @EnvioTotal,      
   Activo = @Activo,    
   EnvioAutomatico = @EnvioAutomatico,    
   ConfiguracionCorte = @ConfiguracionCorte, 
   Email = @Email,
   AsuntoEmail = @AsuntoEmail
 WHERE IdLinea = @IdLinea      
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Véliz
-- Create date: 30/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXEvento]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3),
	@DefinicionFormato xml,
	@NombreArchivo nvarchar(100),
	@TamanhoLote int,
	@Email nvarchar(MAX),
	@AsuntoEmail nvarchar(50),
	@Activo bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_LineaXEvento
	SET		TipoFormato = @TipoFormato,
			DefinicionFormato = @DefinicionFormato,
			NombreArchivo = @NombreArchivo,
			TamanhoLote = @TamanhoLote,
			Email = @Email,
			AsuntoEmail = @AsuntoEmail,
			Activo = @Activo
	WHERE	IdLinea = @IdLinea
	AND		IdEvento = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXEvento_Configuracion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXEvento_Configuracion]        
(        
 @IdLinea int,        
 @IdEvento int,        
 @DefinicionNombreArchivo xml,        
 @NombreArchivo nvarchar(100),        
 @TamanhoLote int,        
 @Email nvarchar(MAX),        
 @AsuntoEmail nvarchar(50),      
 @RutaCopy nvarchar(100),     
 @RutaFTP  nvarchar (250),    
 @UsuarioFTP nvarchar (50),    
 @PasswordFTP nvarchar (50),    
 @IdCampoAgrupar int,        
 @Activo bit,      
 @EventoInicial bit,  
 @IDTipoEvento int, 
 @FechaOperativa int, 
 @CampoBD varchar(100)    
 )        
AS        
BEGIN        
 SET NOCOUNT ON;        
    select * from    LIN_LineaXEvento  
 UPDATE LIN_LineaXEvento        
 SET  DefinicionNombreArchivo = @DefinicionNombreArchivo,        
   NombreArchivo = @NombreArchivo,        
   TamanhoLote = @TamanhoLote,        
   Email = @Email,        
   AsuntoEmail = @AsuntoEmail,      
   RutaCopy = @RutaCopy,    
   RutaFTP =@RutaFTP,    
   UsuarioFTP=@UsuarioFTP,    
   PasswordFTP=@PasswordFTP,        
   IdCampoAgrupar = @IdCampoAgrupar,        
   Activo = @Activo,      
   EventoInicial = @EventoInicial,  
   IDTipoEvento =@IDTipoEvento ,  
   IDFechaOperativa=@FechaOperativa,
   CampoBD=@CampoBD  
 WHERE IdLinea = @IdLinea        
 AND  IdEvento = @IdEvento        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXEvento_TipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 22/06/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXEvento_TipoFormato]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_LineaXEvento
	SET		TipoFormato = @TipoFormato
	WHERE	IdLinea = @IdLinea
	AND		IdEvento = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXEventoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 22/06/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXEventoXTipoFormato]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3),
	@DefinicionFormato xml
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_LineaXEventoXTipoFormato
	SET		DefinicionFormato = @DefinicionFormato
	WHERE	IdLinea = @IdLinea
	AND		IdEvento = @IdEvento
	AND		TipoFormato = @TipoFormato
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXGrupo_Configuracion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  David Arias       
-- Create date: 22/06/2011        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXGrupo_Configuracion]        
(        
 @IdLinea int,        
 @IdGrupo int,        
 @DefinicionNombreArchivo xml,        
 @NombreArchivo nvarchar(100),        
 @TamanhoLote int,        
 @Email nvarchar(MAX),        
 @AsuntoEmail nvarchar(50),      
 @RutaCopy nvarchar(100),     
 @RutaFTP  nvarchar (250),    
 @UsuarioFTP nvarchar (50),    
 @PasswordFTP nvarchar (50),    
 @IdCampoAgrupar int,        
 @Activo bit,      
 @EventoInicial bit)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 UPDATE LIN_LineaXGrupo        
 SET  DefinicionNombreArchivo = @DefinicionNombreArchivo,        
   NombreArchivo = @NombreArchivo,        
   TamanhoLote = @TamanhoLote,        
   Email = @Email,        
   AsuntoEmail = @AsuntoEmail,      
   RutaCopy = @RutaCopy,    
   RutaFTP =@RutaFTP,    
   UsuarioFTP=@UsuarioFTP,    
   PasswordFTP=@PasswordFTP,        
   IdCampoAgrupar = @IdCampoAgrupar,        
   Activo = @Activo,      
   EventoInicial = @EventoInicial  
 WHERE IdLinea = @IdLinea        
 AND  IdGrupo = @IdGrupo        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXGrupo_TipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXGrupo_TipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 UPDATE LIN_LineaXGrupo  
 SET  TipoFormato = @TipoFormato  
 WHERE IdLinea = @IdLinea  
 AND  IdGrupo = @IdGrupo  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarLineaXGrupoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ActualizarLineaXGrupoXTipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3),  
 @DefinicionFormato xml  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 UPDATE LIN_LineaXGrupoXTipoFormato  
 SET  DefinicionFormato = @DefinicionFormato  
 WHERE IdLinea = @IdLinea  
 AND  IdGrupo = @IdGrupo  
 AND  TipoFormato = @TipoFormato  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistro_EnvioForzado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		José Rodriguez
-- Create date: 11/01/2014
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistro_EnvioForzado]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Registro WITH (ROWLOCK)
	SET		EnvioForzado  = 1
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistro_Estado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 08/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistro_Estado]
(
	@IdRegistro int,
	@Estado char(3)
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE	LIN_Registro WITH (ROWLOCK)
	SET		Estado = @Estado
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistro_FechaEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistro_FechaEvento]
(
	@IdRegistro int,
	@FechaEvento datetime
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Registro WITH (ROWLOCK)
	SET		FechaEvento = @FechaEvento
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistro_IdRegistroAnterior]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistro_IdRegistroAnterior]
(
	@IdRegistro int,
	@IdRegistro_Anterior int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Registro WITH (ROWLOCK)
	SET		IdRegistro_Anterior = @IdRegistro_Anterior
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistro_IdRegistroSiguiente]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistro_IdRegistroSiguiente]
(
	@IdRegistro int,
	@IdRegistro_Siguiente int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_Registro WITH (ROWLOCK)
	SET		IdRegistro_Siguiente = @IdRegistro_Siguiente
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ActualizarRegistroFormato_NombreArchivoLote]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 27/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ActualizarRegistroFormato_NombreArchivoLote]
(
	@IdRegistro int,
	@NombreArchivoLote nvarchar(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	LIN_RegistroFormato WITH (ROWLOCK)
	SET		NombreArchivoLote = @NombreArchivoLote
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_CONSULTAEVENTOXLINEAS_ENVIOMANUALMDT]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                    
-- Author:  Luis Cuadra                  
-- Create date: 10/11/2011                    
-- Description:                     
-- =============================================                    
--   
    
            
ALTER PROCEDURE [dbo].[LIN_CONSULTAEVENTOXLINEAS_ENVIOMANUALMDT]                  
@IDLINEA INT,  
@IDGRUPO INT,                      
@FECINI DATETIME,                      
@FECFIN DATETIME,                
@ESTADO VARCHAR(3)                      
AS                      
BEGIN          
  
  
  
set @FECFIN = dateadd(day,1, @FECFIN )    
           
SELECT R.IdRegistro AS IdRegistro,                      
   R.Contenedor as Contenedor,                       
   L.Codigo AS CodigoLinea,                        
   L.Nombre AS NombreLinea,                        
   E.Codigo AS CodigoEvento,                        
   E.Nombre AS NombreEvento,                        
   R.FechaEvento AS FechaEvento,                        
   R.FechaCreacion AS FechaRegistro,                        
   R.Tipo AS Tipo,                        
   R.Estado AS Estado,                        
   COALESCE(                        
    (                        
     SELECT TOP 1                        
       RL.Mensaje                        
     FROM LIN_RegistroLog RL WITH (NOLOCK)                        
     WHERE RL.IdRegistro = R.IdRegistro                        
     ORDER BY RL.FechaCreacion DESC                        
    )                        
   ,'') AS Mensaje ,              
   R.EnvioManual,              
   R.FecGen                       
       FROM LIN_Registro R WITH (NOLOCK)                        
 INNER JOIN LIN_Linea L WITH (NOLOCK) ON R.IdLinea = L.IdLinea                        
 INNER JOIN LIN_Evento E WITH (NOLOCK) ON R.IdEvento = E.IdEvento                        
      WHERE 1=1                      
		AND (@ESTADO IS NULL		
					     OR ( @ESTADO ='VAL' AND R.ESTADO = @ESTADO )   
						 OR ( @ESTADO ='GEN' AND R.ESTADO = 'VAL' )   
					     OR ( @ESTADO ='ENV' AND R.ESTADO = @ESTADO ))              
        AND R.FechaEvento >= @FECINI        
        AND R.FechaEvento <= @FECFIN        
	    AND L.idLinea = @IDLINEA    
	    AND IDREGISTRO NOT IN (SELECT IDREGISTRO 
							     FROM  LIN_REGISTRO lr  
							    WHERE EXISTS (    
												SELECT 'X' 
												  FROM  LIN_REGISTRO   
											     WHERE TIPO = 'MOD' 
											       AND ESTADO = 'VAL' 
											       AND CONTENEDOR = LR.CONTENEDOR 
											       AND IDLINEA = LR.IDLINEA AND IDEVENTO=LR.IDEVENTO )   
								 AND ESTADO ='VAL' 
								 AND TIPO = 'NUE'  
								 AND IDLINEA = @IDLINEA)
		AND R.IdEvento in (SELECT IdEvento 
						     FROM LIN_Grupo_Evento 
						    WHERE IdGrupo = @IDGRUPO)                     
 ORDER BY R.IdRegistro DESC                        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_CONSULTAEVENTOXLINEAS_ENVIOXCORTE]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
   
 --EXEC [LIN_CONSULTAEVENTOXLINEAS_ENVIOXCORTE] 5, @FECINI,@FECFIN,'VAL'  
  --exec LIN_CONSULTAEVENTOXLINEAS_ENVIOXCORTE   
  --@IDLINEA=5,@FECINI='Oct 29 2012 9:00:00:000AM',@FECFIN='Oct 29 2012  3:00:00:000PM',@ESTADO='VAL'  
    
ALTER PROCEDURE [dbo].[LIN_CONSULTAEVENTOXLINEAS_ENVIOXCORTE]                    
@IDLINEA INT,  
@IdGrupo INT,                      
@FECINI DATETIME,                        
@FECFIN DATETIME,                  
@ESTADO VARCHAR(3)                        
AS                        
BEGIN            
        
    set @FECINI =@FECINI - 4    
           
SELECT R.IdRegistro AS IdRegistro,                        
   R.Contenedor as Contenedor,                         
   L.IdLinea AS IdLinea,                          
   L.Nombre AS NombreLinea,                          
   E.IdEvento AS IdEvento,                          
   E.Nombre AS NombreEvento,                          
   R.FechaEvento AS FechaEvento,                          
   R.FechaCreacion AS FechaCreacion,   
   R.IdRegistro_Anterior,  
   R.IdRegistro_Siguiente,  
   R.Tipo,  
   R.EnvioIndependiente ,  
   R.Estado                        
       FROM LIN_Registro R WITH (NOLOCK)                          
 INNER JOIN LIN_Linea L WITH (NOLOCK) ON R.IdLinea = L.IdLinea                          
 INNER JOIN LIN_Evento E WITH (NOLOCK) ON R.IdEvento = E.IdEvento                          
      WHERE L.idLinea = @IDLINEA 
		AND R.FechaEvento >= @FECINI          
		AND R.FechaEvento <= @FECFIN                         
		AND (@ESTADO IS NULL OR ( @ESTADO ='VAL' AND R.ESTADO = @ESTADO ) 
							 OR ( @ESTADO ='GEN' AND R.ESTADO = 'VAL' AND R.EnvioManual = 1 )
							 OR ( @ESTADO ='ENV' AND R.ESTADO = @ESTADO AND R.EnvioManual = 1 ))                  
		AND IDREGISTRO NOT IN (SELECT IDREGISTRO 
								 FROM  LIN_REGISTRO lr    
							    WHERE EXISTS (SELECT 'X' 
												FROM  LIN_REGISTRO     
											   WHERE TIPO = 'MOD' AND ESTADO = 'VAL' AND CONTENEDOR = LR.CONTENEDOR 
											     AND IDLINEA = LR.IDLINEA AND IDEVENTO=LR.IDEVENTO)     
								  AND ESTADO ='VAL' AND TIPO = 'NUE'  AND IDLINEA = @IDLINEA)  
		AND R.IdEvento IN (SELECT IdEvento 
							 FROM LIN_Grupo_Evento
							WHERE IdGrupo = @IdGrupo)                    
 ORDER BY R.IdRegistro DESC                          
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ConsultarActualizacionesMSC]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                  
-- Author:  Johan Cahuachi               
-- Create date: 31/12/2012                 
-- Description:                   
-- =============================================                  
-- 
  
          
ALTER PROCEDURE [dbo].[LIN_ConsultarActualizacionesMSC]                
@Nave varchar(6),
@Viaje varchar(10),
@Booking varchar(20),
@FechaCorte DATETIME,                    
@EstadoActualizacion CHAR(1)                    
AS                    
BEGIN        

SET @Nave = ISNULL(@Nave,'')
SET @Viaje = ISNULL(@Viaje,'')
SET @Booking = ISNULL(@Booking,'')
SET @EstadoActualizacion = ISNULL(@EstadoActualizacion,'')

SELECT IdActualizacion, Nave, Viaje, Booking
     , Contenedor
     , EstadoContenedor = CASE EstadoContenedor WHEN 'A' then 'Asignado' WHEN 'L' THEN 'Llenado'WHEN 'R' THEN 'Retirado' END
     , TipoActualizacion = CASE TipoActualizacion WHEN 'A' then 'Actualizado' WHEN 'N' THEN 'Insertado' END

     , FechaCorte, FechaInicioCargaOperativo,FechaTerminoCargaOperativo, FechaActualizacionMSC 
  FROM MSC_ACTUALIZACION
 WHERE (@Nave ='' or (Nave = @Nave)) 
   AND (@Viaje ='' or (Viaje = @Viaje))
   AND (@Booking ='' or (Booking = @Booking))
   AND (YEAR(@FechaCorte) = 1900 OR((YEAR(FechaCorte) = YEAR(@FechaCorte) AND MONTH(FechaCorte) = MONTH(@FechaCorte) AND DAY(FechaCorte) = DAY(@FechaCorte))))
   AND ((@EstadoActualizacion = '0' AND FechaActualizacionMSC IS NULL)OR (@EstadoActualizacion = '1' AND FechaActualizacionMSC IS NOT NULL))	                    
 ORDER BY IdActualizacion DESC
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ConsultarEventosPorContenedor]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 31/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ConsultarEventosPorContenedor]
(
	@Contenedor nvarchar(20),
	@Estado char(3),
	@EnvioIndependiente bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	R.IdRegistro AS IdRegistro,
			L.Codigo AS CodigoLinea,
			L.Nombre AS NombreLinea,
			E.Codigo AS CodigoEvento,
			E.Nombre AS NombreEvento,
			R.FechaEvento AS FechaEvento,
			R.FechaCreacion AS FechaRegistro,
			R.Tipo AS Tipo,
			R.Estado AS Estado,
			COALESCE(
				(
					SELECT	TOP 1
							RL.Mensaje
					FROM	LIN_RegistroLog RL WITH (NOLOCK)
					WHERE	RL.IdRegistro = R.IdRegistro
					ORDER BY	RL.FechaCreacion DESC
				)
			,'') AS Mensaje
	FROM	LIN_Registro R WITH (NOLOCK)
	INNER JOIN	LIN_Linea L WITH (NOLOCK) ON R.IdLinea = L.IdLinea
	INNER JOIN	LIN_Evento E WITH (NOLOCK) ON R.IdEvento = E.IdEvento
	WHERE	R.Contenedor = @Contenedor
	AND		(@Estado IS NULL OR R.Estado = @Estado)
	AND		(@EnvioIndependiente IS NULL OR R.EnvioIndependiente = @EnvioIndependiente)
	ORDER BY	R.IdRegistro DESC
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_ATASCOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_ATASCOS]    Script Date: 07/11/2012 10:01:26 ******/  
    
---------------------------------------------------------------------      
-- Elimina los atascos de eventos para evitar colas de eventos       
-- sin envío.      
-- Solo aplica para la linea HamburgSUD      
---------------------------------------------------------------------      
ALTER PROCEDURE [dbo].[LIN_CORRIGE_ATASCOS]                  
AS                  
BEGIN                 
      

--------------------------------------------------------------------      
-- ELIMINA ATASCOS DE LA TABLA DE ENVIADOS DE LOS OPERATIVOS QUE      
-- AUN NO ESTAN PENDIENTES EN EL SISTEMA DE EVENTOS(SOLO PARA HSD)      
--------------------------------------------------------------------      
      
BEGIN  
 insert into [SP3TDA-DBSQL01].Balanza.dbo.lin_atasco_eventos (codcon04)      
 SELECT distinct contenedor FROM LIN_REGISTRO  (NOLOCK)      
 WHERE IDLINEA='1' AND IDEVENTO='13' AND IDREGISTRO_ANTERIOR IS NOT NULL AND ESTADO='ENV'  -- 13: EVENTO 900
  AND IDREGISTRO_SIGUIENTE IS NULL      
  and fechaevento>=dateadd(DAY,-2,getdate())       
  
       
 --insert into [neptuniaP2].Balanza.dbo.lin_atasco_eventos (codcon04)      
 --SELECT distinct contenedor FROM LIN_REGISTRO  (NOLOCK)      
 --WHERE IDLINEA='1' AND IDEVENTO='13' AND IDREGISTRO_ANTERIOR IS NOT NULL AND ESTADO='ENV'  -- 13: EVENTO 900    
 -- AND IDREGISTRO_SIGUIENTE IS NULL      
 -- and fechaevento>=dateadd(DAY,-2,getdate())       
       
 EXEC [SP3TDA-DBSQL01].Balanza.dbo.LIN_CORRIGE_ATASCOS      
 EXEC [SP3TDA-DBSQL01].Balanza.dbo.LIN_CORRIGE_ATASCOS      
      
END      
--------------------------------------------------------------------      
-- PASA A ERROR LOS ATASCOS QUE SON EVENTOS PREDECESORES (230)       
-- CON ESTO LOS EVENTOS (900 Y 1000) ENCOLADOS, PASARAN A ENVIADOS (SOLO PARA HSD)      
--------------------------------------------------------------------      
      
UPDATE lin_registro      
SET ESTADO='ERR'      
WHERE IDREGISTRO IN ( select IDREGISTRO from lin_registro (nolock)         
      where      
      idevento='4'      
      and idlinea='1'      
      and estado='ENV'      
      AND CONTENEDOR IN ( select DISTINCT CONTENEDOR       
           from lin_registro (nolock)       
           WHERE estado='COM' AND IDLINEA='1' AND IDEVENTO IN ('13','16')      
             and fechaevento>=dateadd(DAY,-2,getdate())       
           )      
     )      
      
      
      
              
END              
        
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_EVENTOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
      
ALTER PROCEDURE [dbo].[LIN_CORRIGE_EVENTOS]      
AS      
BEGIN     
  
  
  
update LIN_Registro   
set estado='ERR'  
WHERE   
ESTADO='COM'  
AND IDLINEA<>'5'  
AND idregistro IN (  
  
 select distinct a.idregistro from dbo.LIN_Registro a (nolock)   
 inner join dbo.LIN_Registro b (nolock) on a.contenedor=b.contenedor    
 where  
 a.idevento=b.idevento  
 AND a.IDLINEA<>'5'   -- DIFERENTE DE LINEA: PIL
 AND b.IDLINEA<>'5'   -- DIFERENTE DE LINEA: PIL
 and a.ESTADO='COM'  
 and b.ESTADO='ENV'  
--and a.idregistro='23591588'
  
)  
  
  
  
  
---------------------------------------------------------------------------------  
----*** No debe haber campor con FECHA NULL  
-- select * from lin_registro (nolock) where fechaevento is null and estado<>'ERR'  
-----------------------------  
----*** Lo eventos Pendientes que poseen el mismo tipo de evento en ENVIADO, deben darse como ERRROR de repetido  
--  
-- select a.idregistro,b.idregistro,a.estado,b.estado,a.idEvento,b.idEvento,a.* from dbo.LIN_Registro a (nolock)   
-- inner join dbo.LIN_Registro b (nolock) on a.contenedor=b.contenedor    
-- where  
-- a.idevento=b.idevento  
-- AND a.IDLINEA<>'5'   
-- AND b.IDLINEA<>'5'  
-- and a.ESTADO='COM'  
-- and b.ESTADO='ENV'--b.ESTADO<>'VAL' and b.ESTADO<>'COM'  
-- --ORDER BY a.IDREGISTRO,b.IDREGISTRO  
-- ORDER BY a.fechaEvento ,a.IDREGISTRO,b.IDREGISTRO  
--  
-- SELECT * FROM dbo.LIN_Evento (NOLOCK)  
-----------------------------------------------------------------------  
  
  
END   
  
GO
--/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_PIL]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--  
--  
--  
--ALTER PROCEDURE [dbo].[LIN_CORRIGE_PIL]    
--as                                       
--    
--    
----------------------------------------------------------    
---- I. LISTA TODOS LOS ERRORES:    
----------------------------------------------------------    
----select * from  LIN_AUDITORIA_PIL (nolock)    
----where contenedor is null or contenedor='' or    
----  linea is null or linea='' or    
----  navvia  is null or navvia='' or    
----  fechaevento  is null or fechaevento='' or    
----  iso_st is null or iso_st='' or    
----  activity_code is null or activity_code='' or    
----  fechagene is null or fechagene='' or    
----  horagene is null or horagene='' or    
----  pto_ori is null or pto_ori='' or    
----  pto_carga is null or pto_carga='' or    
----  pto_dcarga is null or pto_dcarga='' or    
----  pto_dest is null or pto_dest='' or    
----  nave_npt is null or nave_npt='' or    
----  nave_pil0 is null or nave_pil0='' or    
----  nave_pil is null or nave_pil='' or    
----  nro_viaje is null or nro_viaje='' or    
----  pool_loc is null or pool_loc='' or    
----  book_bl is null or book_bl='' or    
----  impoexpo is null or impoexpo=''     
--    
--    
---- query base:    
----select distinct a.*,b.*,c.*,d.* from lin_registro a (nolock)    
----inner join LIN_AUDITORIA_PIL b (nolock) on a.idregistro=b.idregistro    
----LEFT join LIN_RegistroXCampo c (nolock) on a.idregistro=c.idregistro    
----LEFT join LIN_Campo d (nolock)  on c.idcampo=d.idcampo    
----where    
----a.idlinea='5'    
----and a.estado='VAL'    
----and b.activity_code='MEA'    
----and 'MEA' in (    
----    select e.valor from LIN_RegistroXCampo e (nolock)    
----    inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
----    where b.contenedor=f.contenedor    
----)    
----order by a.fechaevento desc    
--    
--    
--                 
----------------------------------------------------------      
---- II. BORRA EL NRO DE PRECINTO    
----------------------------------------------------------    
---- Se corrigio desde el SP principal que envia el Operativo    
--    
----update lin_registroxcampo    
----set valor =' '    
------select a.*,b.*    
----From lin_registroxcampo a (nolock)    
----inner join lin_campo b (nolock) on a.idcampo=b.idcampo    
----where b.codigo='SEAL_NUMBER1'    
----  and a.valor<>' '    
--    
----------------------------------------------------------      
---- III. DEPURA LOS NAVVIA = 1,2,3,4... MENOR A 10,     
---- que causan campos en blanco en los eventos PIL    
----------------------------------------------------------    
--    
--    
--DELETE LIN_DUPLICIDAD_PIL    
--    
--INSERT INTO LIN_DUPLICIDAD_PIL (IDREGISTRO)    
--select DISTINCT a.idregistro--,a.contenedor,d.contenedor,a.fechaevento,a.estado,a.fechacreacion,a.idregistro_anterior,a.idregistro_siguiente,B.IDCAMPO,b.valor,c.idevento,c.codigo,c.nombre,c.tipodato    
--from lin_registro a (nolock)    
--LEFT join LIN_RegistroXCampo b (nolock) on a.idregistro=b.idregistro    
--LEFT join LIN_Campo c (nolock)  on b.idcampo=c.idcampo    
--INNER join lin_auditoria_pil d (nolock) on a.contenedor=d.contenedor    
--where    
--a.estado<>'ERR'    
--AND A.IDLINEA='5'    
--AND 'MEA' IN ( SELECT DISTINCT E.VALOR FROM LIN_RegistroXCampo E (NOLOCK)    
--     INNER JOIN lin_registro F (NOLOCK) ON E.IDREGISTRO=F.IDREGISTRO    
--     WHERE E.VALOR='MEA' and a.contenedor=F.contenedor    
--    )    
--AND C.CODIGO='REFERENCE'    
--AND B.VALOR=''    
--AND D.ACTIVITY_CODE='MEA'    
--    
--    
---- 2. Depura en el sistema de eventos:    
--    
-- DELETE LIN_RegistroXCampo      
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_RegistroXCampo, depurada... 1 de 6'    
--        
-- DELETE LIN_RegistroLog        
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_RegistroLog, depurada... 2 de 6'    
--        
-- DELETE LIN_RegistroFormato        
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_RegistroFormato, depurada... 3 de 6'    
--        
-- DELETE LIN_RegistroDetalleXCampo        
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_RegistroDetalleXCampo, depurada... 4 de 6'    
--        
-- DELETE LIN_RegistroDetalle        
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_RegistroDetalle, depurada... 5 de 6'    
--        
-- DELETE LIN_Registro        
-- WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
-- print 'Tabla: LIN_Registro, depurada... 6 de 6'    
--    
--    
----------------------------------------------------------      
---- IV. ACTUALIZA EL NOMBRE DE NAVE Y VIAJE    
----------------------------------------------------------    
---- 1. Actualizo la tabla matriz    
--    
---- Se requiere que se actualice la tabla de naves PIL, seguido este SP actualiza el sistema de eventos:    
----INSERT OCEANICA1.Descarga.dbo.EQUIVNAVPIL (CODNAVEPIL,CODNAVENEP) VALUES ('QRW','RIWI')    
--    
---- 2. Actualizo la nave en tabla auditoria:    
----BEGIN    
---- UPDATE LIN_AUDITORIA_PIL    
----  SET nave_pil0=b.CodNavePil,    
----   ERROR=1    
----     
---- FROM LIN_AUDITORIA_PIL a (nolock)    
---- LEFT join OCEANICA1.Descarga.dbo.EQUIVNAVPIL B WITH(NOLOCK) ON A.nave_npt COLLATE DATABASE_DEFAULT =B.CodNaveNep    
---- WHERE B.CodNaveNep IS NOT NULL    
----   AND b.CodNavePil IS NOT NULL    
----   AND CHARINDEX('-',B.CodNaveNep,1)=0    
----   AND (a.nave_pil0 is null or a.nave_pil0='' or CHARINDEX('-',a.nave_pil0,1)=4)    
----     
----END    
----    
------ 3. Actualizo el viaje en tabla auditoria:    
----BEGIN    
---- UPDATE LIN_AUDITORIA_PIL    
----  SET NRO_VIAJE=REPLACE(B.numvia11, '-', ''),    
----   ERROR=2    
----    
---- FROM LIN_AUDITORIA_PIL a (nolock)    
---- inner join OCEANICA1.Descarga.dbo.ddcabman11 B WITH(NOLOCK)  ON A.navvia COLLATE DATABASE_DEFAULT =B.navvia11    
---- WHERE B.numvia11 IS NOT NULL    
----   AND REPLACE(B.numvia11, '-', '')<>'0000'      
----   AND (a.NRO_VIAJE is null or a.NRO_VIAJE='')    
----    
----END    
----    
---- 4. Actualizo la navePIL(nave+viaje) en tabla auditoria    
--begin    
-- update LIN_AUDITORIA_PIL     
--  set nave_pil = replace(nro_viaje,' ','')+replace(nave_pil0,' ',''),    
--   error = 3    
-- WHERE --CONTENEDOR='PCIU8417161'    
--  LEN(replace(NAVE_PIL,' ',''))<7    
--  and len(nave_pil0)=3    
--  and len(nro_viaje)=4    
--end    
--    
--    
---- 5. Actualizo nave/viaje en Sistema de Eventos:    
--    
---- 5.1 Actualizacion de eventos MEA:    
-- UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--    
--  --SELECT     
--  --d.codigo,    
--  --A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0    
--       WHEN 'VOYAGE_NO' THEN C.NAVE_PIL    
--  END --as valorfinal     
--  --,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('VESSEL_CODE','VOYAGE_NO')    
-- AND LEN(C.NAVE_PIL0)>1    
-- AND LEN(C.NAVE_PIL)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MEA'    
-- and 'MEA' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--    
--    
---- 5.2 Actualizacion de eventos MOS:    
-- UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--    
--  --SELECT     
--  --d.codigo,    
--  --A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0    
--       WHEN 'VOYAGE_NO' THEN C.NAVE_PIL    
--  END --as valorfinal     
--  --,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('VESSEL_CODE','VOYAGE_NO')    
-- AND LEN(C.NAVE_PIL0)>1    
-- AND LEN(C.NAVE_PIL)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--    
--    
----------------------------------------------------------      
---- V. ACTUALIZA PUERTOS:    
----------------------------------------------------------    
--    
-- /* 1. EVENTOS MOS:  */  
--     
-- /*Obtengo los casos del sistema de eventos para buscarlo en los operativos*/    
-- --creo tabla temporal de puertos    
--     
-- declare @contador int    
-- declare @idregistro int     
-- declare @contenedor char(11)    
-- DECLARE @navvia CHAR(08)    
-- declare @pto_descarga varchar(5)    
-- declare @pto_descargao varchar(5)    
-- declare @pto_destinoo varchar(50)    
-- declare @pto_destino varchar(5)    
-- declare @bookin char(25)  
-- declare @pto_descargaEo char(3)  
-- declare @pto_descargaE varchar(5)  
--     
-- declare @lin_puertos_pil table(              
--  id int identity(1,1) not null,              
--  idregistro int,              
--  contenedor char(11),     
--  navvia char(08),    
--  PTO_DCARGA varchar(5),    
--  PTO_DEST varchar(5),    
--  enviado char(1),  
--  book_bl char(25)  
-- )    
--     
-- set @contador=0    
--   
-- /* 1.1 Actualiza eventos MOS: Puerto de Descarga y Destino en BLANCO */   
--    
-- insert into @lin_puertos_pil (idregistro,contenedor,navvia,PTO_DCARGA,PTO_DEST,book_bl)    
-- SELECT distinct    
--  b.idregistro,b.contenedor,c.navvia,C.PTO_DCARGA,C.PTO_DEST,C.book_bl    
----  d.codigo,    
----  A.VALOR as valorIni,    
----  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
----       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
----  END --as valorfinal     
----  ,c.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- --AND LEN(C.PTO_DCARGA)>1    
-- --AND LEN(C.PTO_DEST)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--    
-- -- busco los datos en los operativos y actualizo la tabla    
-- select @contador=count(*) from @lin_puertos_pil where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
-- --select * from @lin_puertos_pil where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
--    
-- while @contador>0    
-- begin    
--    
--  select @contenedor=contenedor,@navvia=navvia,@idregistro=idregistro,@bookin=book_bl from @lin_puertos_pil  where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
--      
--    
--  /*Puerto Descarga, Destino y booking salida*/        
--  Select top 1 @pto_descargao = a.codpue02, @pto_destinoo = a.desfin13    
--  from [OCEANICA1].DESCARGA.dbo.erconasi17 b WITH(NOLOCK), [OCEANICA1].DESCARGA.dbo.edbookin13 a WITH(NOLOCK),[OCEANICA1].DESCARGA.dbo.ddcabman11 c WITH(NOLOCK)    
--  where a.genbkg13=b.genbkg13 and a.navvia11=c.navvia11             
--  and b.codcon04=@contenedor order by fecasi17 desc        
--    
--      
--    
--  /*Puerto Descarga del sistema de embarque: Neptunia2*/       
----  SELECT top 1 @pto_descargaEo=codpue02 FROM [SP3TDA-DBSQL01].Descarga.dbo.edbookin13    
----  WHERE codarm10 = 'PIL'--@SLINEA      
----  and nrocon13 = @bookin--'200057'--@SBOOKIN      
----  and flgtbk13='C'  --AND NAVVIA11=@sCodInt    
----  order by fecusu00 desc   
----    
----  select top 1 @pto_descargaE = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
----  from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02  
----  where codpue02 =@pto_descargaEo and codadu02<>'000000'      
----  
----  IF @pto_descargaE='000000' OR @pto_descargaE='' OR @pto_descargaE IS NULL        
----    BEGIN        
----     select top 1 @pto_descargaE = codaduHIS02          
----     from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02  
----     where codpue02 = @pto_descargaEo and codadu02<>'000000'        
----    
----   IF @pto_descargaE='000000' OR @pto_descargaE='' OR @pto_descargaE IS NULL        
----     BEGIN        
----      select top 1 @pto_descargaE = codaduHIS02          
----      from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02           
----      where codpue02 = @pto_descargaEo     
----     END       
----       
----    END        
--  
--  
--  
--  /*Puerto Descarga*/        
--  select top 1 @pto_descarga = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
--  from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--  where codpue02 =@pto_descargao and codadu02<>'000000'         
--     
--  IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL        
--    BEGIN        
--     select top 1 @pto_descarga = codaduHIS02          
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--     where codpue02 = @pto_descargao and codadu02<>'000000'        
--    
--   IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL        
--     BEGIN        
--      select top 1 @pto_descarga = codaduHIS02          
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--      where codpue02 = @pto_descargao     
--     END       
--       
--    END        
--     
--      
--  ----------------------    
--  /*Puerto Destino*/         
--   select top 1 @pto_destino = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
--   from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--   where despue02 = @pto_destinoo and codadu02<>'000000'        
--           
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL        
--    BEGIN        
--     select top 1 @pto_destino = codaduHIS02          
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--     where despue02 = @pto_destinoo and codadu02<>'000000'        
--    
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL        
--     BEGIN        
--      select top 1 @pto_destino = codaduHIS02          
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--      where despue02 = @pto_destinoo     
--     END       
--    
--    END        
--    
--    
-- IF LEN(@pto_descarga)>0  
-- BEGIN  
-- -- acutalizo tabla temporal:    
--   update @lin_puertos_pil    
--    set PTO_DCARGA=@pto_descarga,    
--  enviado='X'    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DCARGA IS NULL OR PTO_DCARGA='')    
--  
-- -- actualizo tabla auditoria:    
--   update LIN_AUDITORIA_PIL    
--    set PTO_DCARGA=@pto_descarga,    
--  error=5    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DCARGA IS NULL OR PTO_DCARGA='')    
--  
--    END  
--  
-- IF LEN(@pto_destino)>0  
-- BEGIN  
-- -- acutalizo tabla temporal:    
--   update @lin_puertos_pil    
--    set PTO_DEST=@pto_destino,    
--  enviado='X'    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DEST IS NULL OR PTO_DEST='')    
--   
-- -- actualizo tabla auditoria:    
-- update LIN_AUDITORIA_PIL    
--    set PTO_DEST=@pto_destino,    
--  error=5    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DEST IS NULL OR PTO_DEST='')    
--  
-- END    
--  
--    
--  select @contador=count(*) from @lin_puertos_pil  where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
-- end    
--     
-- --SELECT * FROM @lin_puertos_pil   
--  
--     
--     
--     
--     
--    
-- -- Actualizo los puerto de Descarga y Destino del evento MOS en el sistema de Eventos:  */  
--   
--   
--  
--UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--  
---- SELECT     
----  d.codigo,    
----  A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
--       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
--  END --as valorfinal     
----  ,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- AND LEN(C.PTO_DCARGA)>1    
-- AND LEN(C.PTO_DEST)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--  
--  -------------------------------------------------------------
--  -------------------------------------------------------------
--    
-- /* 1.2 Actualizo los valores que cambiaron para eventos MOS*/   
--  
--
-- set @contador=0  
-- delete @lin_puertos_pil
--
-- insert into @lin_puertos_pil (idregistro,contenedor,navvia,PTO_DCARGA,PTO_DEST,book_bl)  
-- SELECT distinct  
--  b.idregistro,b.contenedor,c.navvia,C.PTO_DCARGA,C.PTO_DEST,C.book_bl  
-- FROM LIN_RegistroXCampo a (nolock)  
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro  
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro  
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo  
-- where   
-- b.fechaevento>dateadd(month,-1,getdate()) -- actualiza datos con 1 mes de antiguedad 
-- and A.VALOR<>'' -- PARA YA REGISTRADOS
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')  
-- AND LEN(C.PTO_DCARGA)>1  
-- AND LEN(C.PTO_DEST)>1  
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO  
-- and B.idlinea='5'  
-- and B.estado='VAL'  
-- and LEN(C.navvia)>3  
-- and C.idregistro is not null  
-- and C.activity_code='MOS'  
-- and 'MOS' in (  
--     select e.valor from LIN_RegistroXCampo e (nolock)  
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro  
--     where C.contenedor=f.contenedor  
-- )  
--  
--
--
-- -- busco los datos en los operativos y actualizo la tabla  
-- select @contador=count(*) from @lin_puertos_pil where enviado IS NULL OR enviado=''
-- --select * from @lin_puertos_pil where enviado IS NULL OR enviado=''
--  
-- while @contador>0  
-- begin  
--
--  SET @pto_descarga=''
--  SET @pto_descargao=''
--  SET @pto_destinoo=''
--  SET @pto_destino=''
--  set @bookin=''
--  select @contenedor=contenedor,@navvia=navvia,@idregistro=idregistro,@bookin=book_bl from @lin_puertos_pil  where enviado IS NULL OR enviado=''
--    
--
--  /*Puerto Descarga, Destino y booking salida*/      
--  Select top 1 @pto_descargao = a.codpue02, @pto_destinoo = a.desfin13 --,@sRefer = a.nrocon13 
--  from [OCEANICA1].DESCARGA.dbo.erconasi17 b WITH(NOLOCK), [OCEANICA1].DESCARGA.dbo.edbookin13 a WITH(NOLOCK),[OCEANICA1].DESCARGA.dbo.ddcabman11 c WITH(NOLOCK)  
--  where a.genbkg13=b.genbkg13 and a.navvia11=c.navvia11           
--  and b.codcon04=@contenedor order by fecasi17 desc      
--
--
--
--  /*Puerto Descarga*/      
--  select top 1 @pto_descarga = Case codadu02 when '000000' then codaduhis02 else codadu02 End       
--  from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--  where codpue02 =@pto_descargao and codadu02<>'000000'       
--   
--  IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL      
--    BEGIN      
--     select top 1 @pto_descarga = codaduHIS02        
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--     where codpue02 = @pto_descargao and codadu02<>'000000'      
--  
--   IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL      
--     BEGIN      
--      select top 1 @pto_descarga = codaduHIS02        
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--      where codpue02 = @pto_descargao   
--     END     
--     
--    END      
--   
--    
--  ----------------------  
--  /*Puerto Destino*/       
--   select top 1 @pto_destino = Case codadu02 when '000000' then codaduhis02 else codadu02 End       
--   from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--   where despue02 = @pto_destinoo and codadu02<>'000000'      
--         
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL      
--    BEGIN      
--     select top 1 @pto_destino = codaduHIS02        
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--     where despue02 = @pto_destinoo and codadu02<>'000000'      
--  
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL      
--     BEGIN      
--      select top 1 @pto_destino = codaduHIS02        
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--      where despue02 = @pto_destinoo   
--     END     
--  
--    END      
--  
--	-- Actualizo las tablas virtual y de Auditoria
--
--	IF LEN(@pto_descarga)>0
--	BEGIN
--	-- actualizo tabla temporal:  
--		  update @lin_puertos_pil  
--		   set PTO_DCARGA=@pto_descarga,  
--			enviado='Y'  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and PTO_DCARGA<>@pto_descarga and len(@pto_descarga)>0
--			--AND ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR enviado IS NULL OR enviado='')
--		
--	-- actualizo tabla auditoria:  
--		  update LIN_AUDITORIA_PIL  
--		   set PTO_DCARGA=@pto_descarga,  
--			error=7  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and ACTIVITY_CODE='MOS'
--			and PTO_DCARGA<>@pto_descarga and len(@pto_descarga)>0
--			
--
--		PRINT '-- y --'
--		PRINT @bookin+' - '+@pto_descarga+' - '+@pto_descargao+' - '+@pto_destinoo+' - '+@pto_destino
--
--
--		END
--
--	IF LEN(@pto_destino)>0
--	BEGIN
--		-- acutalizo tabla temporal:  
--		  update @lin_puertos_pil  
--		   set PTO_DEST=@pto_destino,  
--			enviado='Z'  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and PTO_DEST<>@pto_destino and len(@pto_destino)>0
--			--and ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR enviado IS NULL OR enviado='')
--
--		-- actualizo tabla auditoria:  
--		update LIN_AUDITORIA_PIL  
--		   set PTO_DEST=@pto_destino,  
--			error=8
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and ACTIVITY_CODE='MOS'
--			and PTO_DEST<>@pto_destino and len(@pto_destino)>0
--			
--
--			PRINT '-- z --'
--			PRINT @bookin+' - '+@pto_descarga+' - '+@pto_descargao+' - '+@pto_destinoo+' - '+@pto_destino
--
--	END  
--
--
--
--	update @lin_puertos_pil  
--	   set PTO_DCARGA=@pto_descarga,  
--		enviado='X'  
--	   where --contenedor=@contenedor and idregistro=@idregistro  
--		book_bl=@bookin and len(@bookin)>0
--		AND ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR  enviado IS NULL OR enviado='')
--
-- 
--
--	
--	
--  
--  select @contador=count(*) from @lin_puertos_pil  where enviado IS NULL OR enviado=''  
--
--
--
-- end  
--   
-- --SELECT * FROM @lin_puertos_pil     
--  
--------------------------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------------------------  
--    
-- -- Actualizo los puerto de Descarga y Destino del evento MOS en el sistema de Eventos:  */  
--UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--  
---- SELECT     
----  d.codigo,    
----  A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
--       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
--  END --as valorfinal     
----  ,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- --A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- AND LEN(C.PTO_DCARGA)>1    
-- AND LEN(C.PTO_DEST)>1    
-- AND (C.ERROR=7 or C.ERROR=8) -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_PIL_ACT_NAVEVIAJE]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER PROCEDURE [dbo].[LIN_CORRIGE_PIL_ACT_NAVEVIAJE]  
as                                         
      
      
--------------------------------------------------------      
-- I. LISTA TODOS LOS ERRORES:      
--------------------------------------------------------      
--select * from  LIN_AUDITORIA_PIL (nolock)      
--where contenedor is null or contenedor='' or      
--  linea is null or linea='' or      
--  navvia  is null or navvia='' or      
--  fechaevento  is null or fechaevento='' or      
--  iso_st is null or iso_st='' or      
--  activity_code is null or activity_code='' or      
--  fechagene is null or fechagene='' or      
--  horagene is null or horagene='' or      
--  pto_ori is null or pto_ori='' or      
--  pto_carga is null or pto_carga='' or      
--  pto_dcarga is null or pto_dcarga='' or      
--  pto_dest is null or pto_dest='' or      
--  nave_npt is null or nave_npt='' or      
--  nave_pil0 is null or nave_pil0='' or      
--  nave_pil is null or nave_pil='' or      
--  nro_viaje is null or nro_viaje='' or      
--  pool_loc is null or pool_loc='' or      
--  book_bl is null or book_bl='' or      
--  impoexpo is null or impoexpo=''       
      
      
-- query base:      
--select distinct a.*,b.*,c.*,d.* from lin_registro a (nolock)      
--inner join LIN_AUDITORIA_PIL b (nolock) on a.idregistro=b.idregistro      
--LEFT join LIN_RegistroXCampo c (nolock) on a.idregistro=c.idregistro      
--LEFT join LIN_Campo d (nolock)  on c.idcampo=d.idcampo      
--where      
--a.idlinea='5'      
--and a.estado='VAL'      
--and b.activity_code='MEA'      
--and 'MEA' in (      
--    select e.valor from LIN_RegistroXCampo e (nolock)      
--    inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
--    where b.contenedor=f.contenedor      
--)      
--order by a.fechaevento desc      
      
  
--------------------------------------------------------        
-- IV. ACTUALIZA EL NOMBRE DE NAVE Y VIAJE      
--------------------------------------------------------      
-- 1. Actualizo la tabla matriz      
      
-- Se requiere que se actualice la tabla de naves PIL, seguido este SP actualiza el sistema de eventos:      
--INSERT OCEANICA1.Descarga.dbo.EQUIVNAVPIL (CODNAVEPIL,CODNAVENEP) VALUES ('QRW','RIWI')      
      
-- 2. Actualizo la nave en tabla auditoria:      
--BEGIN      
-- UPDATE LIN_AUDITORIA_PIL      
--  SET nave_pil0=b.CodNavePil,      
--   ERROR=1      
--       
-- FROM LIN_AUDITORIA_PIL a (nolock)      
-- LEFT join OCEANICA1.Descarga.dbo.EQUIVNAVPIL B WITH(NOLOCK) ON A.nave_npt COLLATE DATABASE_DEFAULT =B.CodNaveNep      
-- WHERE B.CodNaveNep IS NOT NULL      
--   AND b.CodNavePil IS NOT NULL      
--   AND CHARINDEX('-',B.CodNaveNep,1)=0      
--   AND (a.nave_pil0 is null or a.nave_pil0='' or CHARINDEX('-',a.nave_pil0,1)=4)      
--       
--END      
      
-- 3. Actualizo el viaje en tabla auditoria:      
--BEGIN      
-- UPDATE LIN_AUDITORIA_PIL      
--  SET NRO_VIAJE=REPLACE(B.numvia11, '-', ''),      
--   ERROR=2      
--      
-- FROM LIN_AUDITORIA_PIL a (nolock)      
-- inner join OCEANICA1.Descarga.dbo.ddcabman11 B WITH(NOLOCK)  ON A.navvia COLLATE DATABASE_DEFAULT =B.navvia11      
-- WHERE B.numvia11 IS NOT NULL      
--   AND REPLACE(B.numvia11, '-', '')<>'0000'        
--   AND (a.NRO_VIAJE is null or a.NRO_VIAJE='')      
--      
--END      
      
-- 4. Actualizo la navePIL(nave+viaje) en tabla auditoria      
begin      
 update LIN_AUDITORIA_PIL       
  set nave_pil = replace(nave_pil0,' ','')+replace(nro_viaje,' ',''),      
   error = 3      
 WHERE --CONTENEDOR='PCIU8417161'      
	LEN(replace(NAVE_PIL,' ',''))<7      
	AND len(nave_pil0)=3      
	AND len(nro_viaje)=4  
end      
      
      
-- 5. Actualizo nave/viaje en Sistema de Eventos:      
      
-- 5.1 Actualizacion de eventos MEA:      
	/* Para los campos en Blanco */
	 UPDATE LIN_RegistroXCampo      
	 set       
	  valor =      
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
		   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 A.VALOR='' -- PARA LOS CAMPOS EN BLANCO      
	 AND d.codigo in ('VESSEL_CODE','VOYAGE_NO')      
	 AND LEN(C.NAVE_PIL0)>1      
	 AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MEA'      
	 and 'MEA' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )      
      
     
	/* Para los campos incompletos */

	UPDATE LIN_RegistroXCampo      
	 set       
	  valor = C.NAVE_PIL0 
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  --CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
	  --	   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  --END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 (a.valor<>C.NAVE_PIL0 or a.valor is null) 
	 AND d.codigo='VESSEL_CODE'
	 AND LEN(C.NAVE_PIL0)>1      
	 --AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MEA'      
	 and 'MEA' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )  


	UPDATE LIN_RegistroXCampo      
	 set       
	  valor = C.NAVE_PIL 
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  --CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
	  --	   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  --END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 (a.valor<>C.NAVE_PIL or a.valor is null) 
	 AND d.codigo='VOYAGE_NO'
	 --AND LEN(C.NAVE_PIL0)>1      
	 AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MEA'      
	 and 'MEA' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )  
 


-- 5.2 Actualizacion de eventos MOS:     
	/* Para los campos en Blanco */ 
	 UPDATE LIN_RegistroXCampo      
	 set       
	  valor =      
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
		   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 A.VALOR='' -- PARA LOS CAMPOS EN BLANCO      
	 AND d.codigo in ('VESSEL_CODE','VOYAGE_NO')      
	 AND LEN(C.NAVE_PIL0)>1      
	 AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MOS'      
	 and 'MOS' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )      
	      
      
	/* Para los campos con algo de contenido: */

	-- Actualizo las naves(3digitos) incompletas
	UPDATE LIN_RegistroXCampo      
	 set       
	  valor =   C.NAVE_PIL0     
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  --CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
	  --	   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  --END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 (a.valor<>C.NAVE_PIL0 or a.valor is null)
	 and d.codigo='VESSEL_CODE'
	 AND LEN(C.NAVE_PIL0)>1      
	 --AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MOS'      
	 and 'MOS' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )      
	      
	-- Actualizo las naves PIL incompletas
	UPDATE LIN_RegistroXCampo      
	 set       
	  valor =   C.NAVE_PIL     
	      
	  --SELECT       
	  --d.codigo,      
	  --A.VALOR as valorIni,      
	  --CASE d.codigo WHEN 'VESSEL_CODE' THEN C.NAVE_PIL0      
	  --	   WHEN 'VOYAGE_NO' THEN C.NAVE_PIL      
	  --END --as valorfinal       
	  --,A.*,B.*      
	 FROM LIN_RegistroXCampo a (nolock)      
	 inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro      
	 inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro      
	 inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo      
	 where       
	 (a.valor<>C.NAVE_PIL  or a.valor is null)
	 and d.codigo='VOYAGE_NO'
	 --AND LEN(C.NAVE_PIL0)>1      
	 AND LEN(C.NAVE_PIL)>1      
	 AND C.ERROR=3 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO      
	 and B.idlinea='5'      
	 and B.estado='VAL'      
	 and LEN(C.navvia)>3      
	 and C.idregistro is not null      
	 and C.activity_code='MOS'      
	 and 'MOS' in (      
		 select e.valor from LIN_RegistroXCampo e (nolock)      
		 inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro      
		 where C.contenedor=f.contenedor      
	 )      
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_PIL_ACT_PUERTOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
--ALTER PROCEDURE [dbo].[LIN_CORRIGE_PIL_ACT_PUERTOS]
--as                                       
--    
--    
----------------------------------------------------------    
---- I. LISTA TODOS LOS ERRORES:    
----------------------------------------------------------    
----select * from  LIN_AUDITORIA_PIL (nolock)    
----where contenedor is null or contenedor='' or    
----  linea is null or linea='' or    
----  navvia  is null or navvia='' or    
----  fechaevento  is null or fechaevento='' or    
----  iso_st is null or iso_st='' or    
----  activity_code is null or activity_code='' or    
----  fechagene is null or fechagene='' or    
----  horagene is null or horagene='' or    
----  pto_ori is null or pto_ori='' or    
----  pto_carga is null or pto_carga='' or    
----  pto_dcarga is null or pto_dcarga='' or    
----  pto_dest is null or pto_dest='' or    
----  nave_npt is null or nave_npt='' or    
----  nave_pil0 is null or nave_pil0='' or    
----  nave_pil is null or nave_pil='' or    
----  nro_viaje is null or nro_viaje='' or    
----  pool_loc is null or pool_loc='' or    
----  book_bl is null or book_bl='' or    
----  impoexpo is null or impoexpo=''     
--    
--    
---- query base:    
----select distinct a.*,b.*,c.*,d.* from lin_registro a (nolock)    
----inner join LIN_AUDITORIA_PIL b (nolock) on a.idregistro=b.idregistro    
----LEFT join LIN_RegistroXCampo c (nolock) on a.idregistro=c.idregistro    
----LEFT join LIN_Campo d (nolock)  on c.idcampo=d.idcampo    
----where    
----a.idlinea='5'    
----and a.estado='VAL'    
----and b.activity_code='MEA'    
----and 'MEA' in (    
----    select e.valor from LIN_RegistroXCampo e (nolock)    
----    inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
----    where b.contenedor=f.contenedor    
----)    
----order by a.fechaevento desc    
--    
--
----------------------------------------------------------      
---- V. ACTUALIZA PUERTOS:    
----------------------------------------------------------    
--    
-- /* 1. EVENTOS MOS:  */  
--     
-- /*Obtengo los casos del sistema de eventos para buscarlo en los operativos*/    
-- --creo tabla temporal de puertos    
--     
-- declare @contador int    
-- declare @idregistro int     
-- declare @contenedor char(11)    
-- DECLARE @navvia CHAR(08)    
-- declare @pto_descarga varchar(5)    
-- declare @pto_descargao varchar(5)    
-- declare @pto_destinoo varchar(50)    
-- declare @pto_destino varchar(5)    
-- declare @bookin char(25)  
-- declare @pto_descargaEo char(3)  
-- declare @pto_descargaE varchar(5)  
--     
-- declare @lin_puertos_pil table(              
--  id int identity(1,1) not null,              
--  idregistro int,              
--  contenedor char(11),     
--  navvia char(08),    
--  PTO_DCARGA varchar(5),    
--  PTO_DEST varchar(5),    
--  enviado char(1),  
--  book_bl char(25)  
-- )    
--     
-- set @contador=0    
--   
-- /* 1.1 Actualiza eventos MOS: Puerto de Descarga y Destino en BLANCO */   
--    
-- insert into @lin_puertos_pil (idregistro,contenedor,navvia,PTO_DCARGA,PTO_DEST,book_bl)    
-- SELECT distinct    
--  b.idregistro,b.contenedor,c.navvia,C.PTO_DCARGA,C.PTO_DEST,C.book_bl    
----  d.codigo,    
----  A.VALOR as valorIni,    
----  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
----       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
----  END --as valorfinal     
----  ,c.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- --AND LEN(C.PTO_DCARGA)>1    
-- --AND LEN(C.PTO_DEST)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--    
-- -- busco los datos en los operativos y actualizo la tabla    
-- select @contador=count(*) from @lin_puertos_pil where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
-- --select * from @lin_puertos_pil where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
--    
-- while @contador>0    
-- begin    
--    
--  select @contenedor=contenedor,@navvia=navvia,@idregistro=idregistro,@bookin=book_bl from @lin_puertos_pil  where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
--      
--    
--  /*Puerto Descarga, Destino y booking salida*/        
--  Select top 1 @pto_descargao = a.codpue02, @pto_destinoo = a.desfin13    
--  from [OCEANICA1].DESCARGA.dbo.erconasi17 b WITH(NOLOCK), [OCEANICA1].DESCARGA.dbo.edbookin13 a WITH(NOLOCK),[OCEANICA1].DESCARGA.dbo.ddcabman11 c WITH(NOLOCK)    
--  where a.genbkg13=b.genbkg13 and a.navvia11=c.navvia11             
--  and b.codcon04=@contenedor order by fecasi17 desc        
--    
--      
--    
--  /*Puerto Descarga del sistema de embarque: Neptunia2*/       
----  SELECT top 1 @pto_descargaEo=codpue02 FROM [SP3TDA-DBSQL01].Descarga.dbo.edbookin13    
----  WHERE codarm10 = 'PIL'--@SLINEA      
----  and nrocon13 = @bookin--'200057'--@SBOOKIN      
----  and flgtbk13='C'  --AND NAVVIA11=@sCodInt    
----  order by fecusu00 desc   
----    
----  select top 1 @pto_descargaE = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
----  from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02  
----  where codpue02 =@pto_descargaEo and codadu02<>'000000'      
----  
----  IF @pto_descargaE='000000' OR @pto_descargaE='' OR @pto_descargaE IS NULL        
----    BEGIN        
----     select top 1 @pto_descargaE = codaduHIS02          
----     from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02  
----     where codpue02 = @pto_descargaEo and codadu02<>'000000'        
----    
----   IF @pto_descargaE='000000' OR @pto_descargaE='' OR @pto_descargaE IS NULL        
----     BEGIN        
----      select top 1 @pto_descargaE = codaduHIS02          
----      from [SP3TDA-DBSQL01].Descarga.dbo.DQPUERTO02           
----      where codpue02 = @pto_descargaEo     
----     END       
----       
----    END        
--  
--  
--  
--  /*Puerto Descarga*/        
--  select top 1 @pto_descarga = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
--  from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--  where codpue02 =@pto_descargao and codadu02<>'000000'         
--     
--  IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL        
--    BEGIN        
--     select top 1 @pto_descarga = codaduHIS02          
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--     where codpue02 = @pto_descargao and codadu02<>'000000'        
--    
--   IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL        
--     BEGIN        
--      select top 1 @pto_descarga = codaduHIS02          
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--      where codpue02 = @pto_descargao     
--     END       
--       
--    END        
--     
--      
--  ----------------------    
--  /*Puerto Destino*/         
--   select top 1 @pto_destino = Case codadu02 when '000000' then codaduhis02 else codadu02 End         
--   from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--   where despue02 = @pto_destinoo and codadu02<>'000000'        
--           
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL        
--    BEGIN        
--     select top 1 @pto_destino = codaduHIS02          
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--     where despue02 = @pto_destinoo and codadu02<>'000000'        
--    
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL        
--     BEGIN        
--      select top 1 @pto_destino = codaduHIS02          
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02           
--      where despue02 = @pto_destinoo     
--     END       
--    
--    END        
--    
--    
-- IF LEN(@pto_descarga)>0  
-- BEGIN  
-- -- acutalizo tabla temporal:    
--   update @lin_puertos_pil    
--    set PTO_DCARGA=@pto_descarga,    
--  enviado='X'    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DCARGA IS NULL OR PTO_DCARGA='')    
--  
-- -- actualizo tabla auditoria:    
--   update LIN_AUDITORIA_PIL    
--    set PTO_DCARGA=@pto_descarga,    
--  error=5    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DCARGA IS NULL OR PTO_DCARGA='')    
--  
--    END  
--  
-- IF LEN(@pto_destino)>0  
-- BEGIN  
-- -- acutalizo tabla temporal:    
--   update @lin_puertos_pil    
--    set PTO_DEST=@pto_destino,    
--  enviado='X'    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DEST IS NULL OR PTO_DEST='')    
--   
-- -- actualizo tabla auditoria:    
-- update LIN_AUDITORIA_PIL    
--    set PTO_DEST=@pto_destino,    
--  error=5    
--    where contenedor=@contenedor and idregistro=@idregistro    
--  AND (PTO_DEST IS NULL OR PTO_DEST='')    
--  
-- END    
--  
--    
--  select @contador=count(*) from @lin_puertos_pil  where (PTO_DCARGA='' or PTO_DEST='') and (enviado IS NULL OR enviado='')    
-- end    
--     
-- --SELECT * FROM @lin_puertos_pil   
--  
--     
--     
--     
--     
--    
-- -- Actualizo los puerto de Descarga y Destino del evento MOS en el sistema de Eventos:  */  
--   
--   
--  
--UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--  
---- SELECT     
----  d.codigo,    
----  A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
--       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
--  END --as valorfinal     
----  ,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- AND LEN(C.PTO_DCARGA)>1    
-- AND LEN(C.PTO_DEST)>1    
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--  
--  -------------------------------------------------------------
--  -------------------------------------------------------------
--    
-- /* 1.2 Actualizo los valores que cambiaron para eventos MOS*/   
--  
--
-- set @contador=0  
-- delete @lin_puertos_pil
--
-- insert into @lin_puertos_pil (idregistro,contenedor,navvia,PTO_DCARGA,PTO_DEST,book_bl)  
-- SELECT distinct  
--  b.idregistro,b.contenedor,c.navvia,C.PTO_DCARGA,C.PTO_DEST,C.book_bl  
-- FROM LIN_RegistroXCampo a (nolock)  
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro  
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro  
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo  
-- where   
-- b.fechaevento>dateadd(month,-1,getdate()) -- actualiza datos con 1 mes de antiguedad 
-- and A.VALOR<>'' -- PARA YA REGISTRADOS
-- AND d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')  
-- AND LEN(C.PTO_DCARGA)>1  
-- AND LEN(C.PTO_DEST)>1  
-- --AND C.ERROR=1 -- ERROR TIPO NOMBRE DE NAVE CORREGIDO  
-- and B.idlinea='5'  
-- and B.estado='VAL'  
-- and LEN(C.navvia)>3  
-- and C.idregistro is not null  
-- and C.activity_code='MOS'  
-- and 'MOS' in (  
--     select e.valor from LIN_RegistroXCampo e (nolock)  
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro  
--     where C.contenedor=f.contenedor  
-- )  
--  
--
--
-- -- busco los datos en los operativos y actualizo la tabla  
-- select @contador=count(*) from @lin_puertos_pil where enviado IS NULL OR enviado=''
-- --select * from @lin_puertos_pil where enviado IS NULL OR enviado=''
--  
-- while @contador>0  
-- begin  
--
--  SET @pto_descarga=''
--  SET @pto_descargao=''
--  SET @pto_destinoo=''
--  SET @pto_destino=''
--  set @bookin=''
--  select @contenedor=contenedor,@navvia=navvia,@idregistro=idregistro,@bookin=book_bl from @lin_puertos_pil  where enviado IS NULL OR enviado=''
--    
--
--  /*Puerto Descarga, Destino y booking salida*/      
--  Select top 1 @pto_descargao = a.codpue02, @pto_destinoo = a.desfin13 --,@sRefer = a.nrocon13 
--  from [OCEANICA1].DESCARGA.dbo.erconasi17 b WITH(NOLOCK), [OCEANICA1].DESCARGA.dbo.edbookin13 a WITH(NOLOCK),[OCEANICA1].DESCARGA.dbo.ddcabman11 c WITH(NOLOCK)  
--  where a.genbkg13=b.genbkg13 and a.navvia11=c.navvia11           
--  and b.codcon04=@contenedor order by fecasi17 desc      
--
--
--
--  /*Puerto Descarga*/      
--  select top 1 @pto_descarga = Case codadu02 when '000000' then codaduhis02 else codadu02 End       
--  from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--  where codpue02 =@pto_descargao and codadu02<>'000000'       
--   
--  IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL      
--    BEGIN      
--     select top 1 @pto_descarga = codaduHIS02        
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--     where codpue02 = @pto_descargao and codadu02<>'000000'      
--  
--   IF @pto_descarga='000000' OR @pto_descarga='' OR @pto_descarga IS NULL      
--     BEGIN      
--      select top 1 @pto_descarga = codaduHIS02        
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--      where codpue02 = @pto_descargao   
--     END     
--     
--    END      
--   
--    
--  ----------------------  
--  /*Puerto Destino*/       
--   select top 1 @pto_destino = Case codadu02 when '000000' then codaduhis02 else codadu02 End       
--   from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--   where despue02 = @pto_destinoo and codadu02<>'000000'      
--         
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL      
--    BEGIN      
--     select top 1 @pto_destino = codaduHIS02        
--     from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--     where despue02 = @pto_destinoo and codadu02<>'000000'      
--  
--   IF @pto_destino='000000' OR @pto_destino='' OR @pto_destino IS NULL      
--     BEGIN      
--      select top 1 @pto_destino = codaduHIS02        
--      from [SP3TDA-DBSQL01].Terminal.dbo.DQPUERTO02         
--      where despue02 = @pto_destinoo   
--     END     
--  
--    END      
--  
--	-- Actualizo las tablas virtual y de Auditoria
--
--	IF LEN(@pto_descarga)>0
--	BEGIN
--	-- actualizo tabla temporal:  
--		  update @lin_puertos_pil  
--		   set PTO_DCARGA=@pto_descarga,  
--			enviado='Y'  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and PTO_DCARGA<>@pto_descarga and len(@pto_descarga)>0
--			--AND ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR enviado IS NULL OR enviado='')
--		
--	-- actualizo tabla auditoria:  
--		  update LIN_AUDITORIA_PIL  
--		   set PTO_DCARGA=@pto_descarga,  
--			error=7  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and ACTIVITY_CODE='MOS'
--			and PTO_DCARGA<>@pto_descarga and len(@pto_descarga)>0
--			
--
--		PRINT '-- y --'
--		PRINT @bookin+' - '+@pto_descarga+' - '+@pto_descargao+' - '+@pto_destinoo+' - '+@pto_destino
--
--
--		END
--
--	IF LEN(@pto_destino)>0
--	BEGIN
--		-- acutalizo tabla temporal:  
--		  update @lin_puertos_pil  
--		   set PTO_DEST=@pto_destino,  
--			enviado='Z'  
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and PTO_DEST<>@pto_destino and len(@pto_destino)>0
--			--and ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR enviado IS NULL OR enviado='')
--
--		-- actualizo tabla auditoria:  
--		update LIN_AUDITORIA_PIL  
--		   set PTO_DEST=@pto_destino,  
--			error=8
--		   where --contenedor=@contenedor and idregistro=@idregistro  
--			book_bl=@bookin and len(@bookin)>0
--			and ACTIVITY_CODE='MOS'
--			and PTO_DEST<>@pto_destino and len(@pto_destino)>0
--			
--
--			PRINT '-- z --'
--			PRINT @bookin+' - '+@pto_descarga+' - '+@pto_descargao+' - '+@pto_destinoo+' - '+@pto_destino
--
--	END  
--
--
--
--	update @lin_puertos_pil  
--	   set PTO_DCARGA=@pto_descarga,  
--		enviado='X'  
--	   where --contenedor=@contenedor and idregistro=@idregistro  
--		book_bl=@bookin and len(@bookin)>0
--		AND ((enviado<>'X' AND enviado<>'Y' AND enviado<>'Z') OR  enviado IS NULL OR enviado='')
--
-- 
--
--	
--	
--  
--  select @contador=count(*) from @lin_puertos_pil  where enviado IS NULL OR enviado=''  
--
--
--
-- end  
--   
-- --SELECT * FROM @lin_puertos_pil     
--  
--------------------------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------------------------  
--    
-- -- Actualizo los puerto de Descarga y Destino del evento MOS en el sistema de Eventos:  */  
--UPDATE LIN_RegistroXCampo    
-- set     
--  valor =    
--  
---- SELECT     
----  d.codigo,    
----  A.VALOR as valorIni,    
--  CASE d.codigo WHEN 'DISCHARGE_PORT' THEN C.PTO_DCARGA    
--       WHEN 'FINAL_DESTINATI' THEN C.PTO_DEST    
--  END --as valorfinal     
----  ,A.*,B.*    
-- FROM LIN_RegistroXCampo a (nolock)    
-- inner join LIN_REGISTRO b (nolock) on a.idregistro=b.idregistro    
-- inner join LIN_AUDITORIA_PIL c (nolock) on a.idregistro=c.idregistro    
-- inner join LIN_Campo d (nolock)  on a.idcampo=d.idcampo    
-- where     
-- --A.VALOR='' -- PARA LOS CAMPOS EN BLANCO    
-- d.codigo in ('DISCHARGE_PORT','FINAL_DESTINATI')    
-- AND LEN(C.PTO_DCARGA)>1    
-- AND LEN(C.PTO_DEST)>1    
-- AND (C.ERROR=7 or C.ERROR=8) -- ERROR TIPO NOMBRE DE NAVE CORREGIDO    
-- and B.idlinea='5'    
-- and B.estado='VAL'    
-- and LEN(C.navvia)>3    
-- and C.idregistro is not null    
-- and C.activity_code='MOS'    
-- and 'MOS' in (    
--     select e.valor from LIN_RegistroXCampo e (nolock)    
--     inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--     where C.contenedor=f.contenedor    
-- )    
--GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_PIL_BORRA_DUPLICIDAD]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER PROCEDURE [dbo].[LIN_CORRIGE_PIL_BORRA_DUPLICIDAD]
as                                       
    
    
--------------------------------------------------------    
-- I. LISTA TODOS LOS ERRORES:    
--------------------------------------------------------    
--select * from  LIN_AUDITORIA_PIL (nolock)    
--where contenedor is null or contenedor='' or    
--  linea is null or linea='' or    
--  navvia  is null or navvia='' or    
--  fechaevento  is null or fechaevento='' or    
--  iso_st is null or iso_st='' or    
--  activity_code is null or activity_code='' or    
--  fechagene is null or fechagene='' or    
--  horagene is null or horagene='' or    
--  pto_ori is null or pto_ori='' or    
--  pto_carga is null or pto_carga='' or    
--  pto_dcarga is null or pto_dcarga='' or    
--  pto_dest is null or pto_dest='' or    
--  nave_npt is null or nave_npt='' or    
--  nave_pil0 is null or nave_pil0='' or    
--  nave_pil is null or nave_pil='' or    
--  nro_viaje is null or nro_viaje='' or    
--  pool_loc is null or pool_loc='' or    
--  book_bl is null or book_bl='' or    
--  impoexpo is null or impoexpo=''     
    
    
-- query base:    
--select distinct a.*,b.*,c.*,d.* from lin_registro a (nolock)    
--inner join LIN_AUDITORIA_PIL b (nolock) on a.idregistro=b.idregistro    
--LEFT join LIN_RegistroXCampo c (nolock) on a.idregistro=c.idregistro    
--LEFT join LIN_Campo d (nolock)  on c.idcampo=d.idcampo    
--where    
--a.idlinea='5'    
--and a.estado='VAL'    
--and b.activity_code='MEA'    
--and 'MEA' in (    
--    select e.valor from LIN_RegistroXCampo e (nolock)    
--    inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--    where b.contenedor=f.contenedor    
--)    
--order by a.fechaevento desc    
    
    
--------------------------------------------------------      
-- III. DEPURA LOS NAVVIA = 1,2,3,4... MENOR A 10,     
-- que causan campos en blanco en los eventos PIL    
--------------------------------------------------------    
    
    
DELETE LIN_DUPLICIDAD_PIL    
    
INSERT INTO LIN_DUPLICIDAD_PIL (IDREGISTRO)    
select DISTINCT a.idregistro--,a.contenedor,d.contenedor,a.fechaevento,a.estado,a.fechacreacion,a.idregistro_anterior,a.idregistro_siguiente,B.IDCAMPO,b.valor,c.idevento,c.codigo,c.nombre,c.tipodato    
from lin_registro a (nolock)    
LEFT join LIN_RegistroXCampo b (nolock) on a.idregistro=b.idregistro    
LEFT join LIN_Campo c (nolock)  on b.idcampo=c.idcampo    
INNER join lin_auditoria_pil d (nolock) on a.contenedor=d.contenedor    
where    
a.estado<>'ERR'    
AND A.IDLINEA='5'    
AND 'MEA' IN ( SELECT DISTINCT E.VALOR FROM LIN_RegistroXCampo E (NOLOCK)    
     INNER JOIN lin_registro F (NOLOCK) ON E.IDREGISTRO=F.IDREGISTRO    
     WHERE E.VALOR='MEA' and a.contenedor=F.contenedor    
    )    
AND C.CODIGO='REFERENCE'    
AND B.VALOR=''    
AND D.ACTIVITY_CODE='MEA'    
    
    
-- 2. Depura en el sistema de eventos:    
    
 DELETE LIN_RegistroXCampo      
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_RegistroXCampo, depurada... 1 de 6'    
        
 DELETE LIN_RegistroLog        
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_RegistroLog, depurada... 2 de 6'    
        
 DELETE LIN_RegistroFormato        
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_RegistroFormato, depurada... 3 de 6'    
        
 DELETE LIN_RegistroDetalleXCampo        
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_RegistroDetalleXCampo, depurada... 4 de 6'    
        
 DELETE LIN_RegistroDetalle        
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_RegistroDetalle, depurada... 5 de 6'    
        
 DELETE LIN_Registro        
 WHERE IDREGISTRO in (select idregistro from LIN_DUPLICIDAD_PIL (nolock) )    
 print 'Tabla: LIN_Registro, depurada... 6 de 6'    
    
    
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_PIL_BORRA_PRECINTOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER PROCEDURE [dbo].[LIN_CORRIGE_PIL_BORRA_PRECINTOS]    
as                                       
    
    
--------------------------------------------------------    
-- I. LISTA TODOS LOS ERRORES:    
--------------------------------------------------------    
--select * from  LIN_AUDITORIA_PIL (nolock)    
--where contenedor is null or contenedor='' or    
--  linea is null or linea='' or    
--  navvia  is null or navvia='' or    
--  fechaevento  is null or fechaevento='' or    
--  iso_st is null or iso_st='' or    
--  activity_code is null or activity_code='' or    
--  fechagene is null or fechagene='' or    
--  horagene is null or horagene='' or    
--  pto_ori is null or pto_ori='' or    
--  pto_carga is null or pto_carga='' or    
--  pto_dcarga is null or pto_dcarga='' or    
--  pto_dest is null or pto_dest='' or    
--  nave_npt is null or nave_npt='' or    
--  nave_pil0 is null or nave_pil0='' or    
--  nave_pil is null or nave_pil='' or    
--  nro_viaje is null or nro_viaje='' or    
--  pool_loc is null or pool_loc='' or    
--  book_bl is null or book_bl='' or    
--  impoexpo is null or impoexpo=''     
    
    
-- query base:    
--select distinct a.*,b.*,c.*,d.* from lin_registro a (nolock)    
--inner join LIN_AUDITORIA_PIL b (nolock) on a.idregistro=b.idregistro    
--LEFT join LIN_RegistroXCampo c (nolock) on a.idregistro=c.idregistro    
--LEFT join LIN_Campo d (nolock)  on c.idcampo=d.idcampo    
--where    
--a.idlinea='5'    
--and a.estado='VAL'    
--and b.activity_code='MEA'    
--and 'MEA' in (    
--    select e.valor from LIN_RegistroXCampo e (nolock)    
--    inner join LIN_AUDITORIA_PIL f (nolock) on e.idregistro=f.idregistro    
--    where b.contenedor=f.contenedor    
--)    
--order by a.fechaevento desc    
    
    
                 
--------------------------------------------------------      
-- II. BORRA EL NRO DE PRECINTO    
--------------------------------------------------------    
-- Se corrigio desde el SP principal que envia el Operativo    
BEGIN    

	update lin_registroxcampo    
	set valor =' '    
	--select a.*,b.*    
	From lin_registroxcampo a (nolock)    
	inner join lin_campo b (nolock) on a.idcampo=b.idcampo    
	where b.codigo='SEAL_NUMBER1'    
	  and a.valor<>' '    

END

GO
/****** Object:  StoredProcedure [dbo].[LIN_DEPURA_ERRORES]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[LIN_DEPURA_ERRORES]    --FMCR      
--AS          
--BEGIN         


-------------------------------------------------------------
---- DEPURA EL ARCHIVO DE LOG, PARA NO LLENAR LA BD
-------------------------------------------------------------

---- OBTIENE LOS NOMBRE DE ARCHVOS DE LA BD
---- SP_helpfile will give you the logical log file name

--BACKUP LOG enviolineas WITH TRUNCATE_ONLY
--DBCC SHRINKFILE (EnvioLineas_log, 1)



-------------------------------------------------------------
---- ELIMINAR LOS ARCHIVOS CUYO ESTADO ES ERROR (DIARIAMENTE)
-------------------------------------------------------------
      
--delete LIN_ERRORES      
-----------------------        
--insert into LIN_ERRORES (IDREGISTRO)        
--select DISTINCT IDREGISTRO from LIN_Registro (nolock)      
--where       
----fechaevento<=dateadd(DAY,-1,getdate())
----fechaevento<=dateadd(month,-1,getdate())      
--fechaevento<='2012-06-20 00:00:00.000'      
----IDREGISTRO='18360734'      
--and estado='ERR'      
----ORDER BY FECHAEVENTO      

--print 'Llenado de tabla listo'
-------------------------      
      
      
-- DELETE LIN_RegistroXCampo    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_RegistroXCampo, depurada... 1 de 6'
    
-- DELETE LIN_RegistroLog    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_RegistroLog, depurada... 2 de 6'
    
-- DELETE LIN_RegistroFormato    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_RegistroFormato, depurada... 3 de 6'
    
-- DELETE LIN_RegistroDetalleXCampo    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_RegistroDetalleXCampo, depurada... 4 de 6'
    
-- DELETE LIN_RegistroDetalle    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_RegistroDetalle, depurada... 5 de 6'
    
-- DELETE LIN_Registro    
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )
-- print 'Tabla: LIN_Registro, depurada... 6 de 6'
      
 
      
--END      
  
--GO
/****** Object:  StoredProcedure [dbo].[LIN_DEPURA_EVENTOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
------------------------------------------------------------  
-- Tarea que elimina diariamente todos los errores que   
-- se registran en el sistema de Eventos Linea.  
------------------------------------------------------------  
  
--ALTER PROCEDURE [dbo].[LIN_DEPURA_EVENTOS]    --FMCR        
--AS            
--BEGIN           
  
  
-------------------------------------------------------------  
---- DEPURA EL ARCHIVO DE LOG, PARA NO LLENAR LA BD  
-------------------------------------------------------------  
  
---- OBTIENE LOS NOMBRE DE ARCHVOS DE LA BD  
---- SP_helpfile will give you the logical log file name  
  
--BACKUP LOG enviolineas WITH TRUNCATE_ONLY  
--DBCC SHRINKFILE (EnvioLineas_log, 1)  
  
  
  
-------------------------------------------------------------  
---- ELIMINAR LOS ARCHIVOS CUYO ESTADO ES ERROR (DIARIAMENTE)  
-------------------------------------------------------------  
        
--delete LIN_ERRORES        
-----------------------          
--insert into LIN_ERRORES (IDREGISTRO)          
--select DISTINCT IDREGISTRO from LIN_Registro (nolock)        
--where         
----fechaevento<=dateadd(DAY,-1,getdate())  
--fechaevento<=dateadd(month,-2,getdate())        
----fechaevento<='2012-07-05 00:00:00.000'        
----IDREGISTRO='18360734'        
--and estado='ERR'        
----ORDER BY FECHAEVENTO        
  
--print 'Llenado de tabla listo'  
-------------------------        
        
        
-- DELETE LIN_RegistroXCampo      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_RegistroXCampo, depurada... 1 de 6'  
      
-- DELETE LIN_RegistroLog      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_RegistroLog, depurada... 2 de 6'  
      
-- DELETE LIN_RegistroFormato      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_RegistroFormato, depurada... 3 de 6'  
      
-- DELETE LIN_RegistroDetalleXCampo      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_RegistroDetalleXCampo, depurada... 4 de 6'  
      
-- DELETE LIN_RegistroDetalle      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_RegistroDetalle, depurada... 5 de 6'  
      
-- DELETE LIN_Registro      
-- WHERE IDREGISTRO in (select idregistro from LIN_ERRORES (nolock) )  
-- print 'Tabla: LIN_Registro, depurada... 6 de 6'  
        
   
        
--END        
--GO
/****** Object:  StoredProcedure [dbo].[LIN_ELIMINA_ERRORES]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ELIMINA_ERRORES]        
AS        
BEGIN       
    
delete LIN_ERRORES    
---------------------      
insert into LIN_ERRORES (IDREGISTRO)      
select DISTINCT IDREGISTRO from LIN_Registro (nolock)    
where     
idlinea='5' AND ESTADO='COM'
    
    

 DELETE LIN_RegistroXCampo  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
  
 DELETE LIN_RegistroLog  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )

 DELETE LIN_RegistroFormato  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
  
 DELETE LIN_RegistroDetalleXCampo  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
  
 DELETE LIN_RegistroDetalle  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
  
 DELETE LIN_Registro  
 WHERE IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
      
 delete lin_errores    
 where IDREGISTRO in (select distinct idregistro from LIN_ERRORES (NOLOCK)    )
    
 

   

    
END    

GO
/****** Object:  StoredProcedure [dbo].[LIN_ELIMINA_ERRORES_MOL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
ALTER PROCEDURE [dbo].[LIN_ELIMINA_ERRORES_MOL]    
AS    
BEGIN   

delete LIN_ERRORES
---------------------  
insert into LIN_ERRORES (IDREGISTRO)  
select DISTINCT IDREGISTRO from LIN_Registro (nolock)
where 
fechaevento between '2012-07-02 00:00:00.000' and '2012-07-02 12:00:00.000'
and idlinea='6'

--print 'acabo insert'
-----------------------
DECLARE @CANT_ERRORES INT  
DECLARE @ID_ERR INT  



	select @CANT_ERRORES=count(*) FROM LIN_ERRORES (NOLOCK) 
	
	WHILE @CANT_ERRORES>0   
	BEGIN  
  
	select @ID_ERR=IDREGISTRO
	FROM LIN_ERRORES (NOLOCK)

	DELETE LIN_RegistroXCampo
	WHERE IDREGISTRO=@ID_ERR--'18739485'

	DELETE LIN_RegistroLog
	WHERE IDREGISTRO=@ID_ERR--'18739485'

	DELETE LIN_RegistroFormato
	WHERE IDREGISTRO=@ID_ERR--'18739485'

	DELETE LIN_RegistroDetalleXCampo
	WHERE IDREGISTRO=@ID_ERR--'18739485'

	DELETE LIN_RegistroDetalle
	WHERE IDREGISTRO=@ID_ERR--'18739485'

	DELETE LIN_Registro
	WHERE IDREGISTRO=@ID_ERR--'18739485'
  


	delete lin_errores
	where IDREGISTRO=@ID_ERR

	select @CANT_ERRORES=count(*) FROM LIN_ERRORES (NOLOCK) 
------

	END 

END

GO
/****** Object:  StoredProcedure [dbo].[LIN_ELIMINA_PENDIENTES_PASADOS]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------    
-- Elimina los atascos de eventos para evitar colas de eventos     
-- sin envío.    
-- Solo aplica para la linea HamburgSUD    
---------------------------------------------------------------------    
ALTER PROCEDURE [dbo].[LIN_ELIMINA_PENDIENTES_PASADOS]                
AS                
BEGIN               
    
--------------------------------------------------------------------    
-- ELIMINA PENDIENTES CON MAS DE 2 DIAS DE ANTIGUEDAD (SOLO PARA HSD)    
--------------------------------------------------------------------    
delete LIN_DEMORA            
---------------------              
insert into LIN_DEMORA (IDREGISTRO)              
select DISTINCT IDREGISTRO from LIN_Registro (nolock)            
where             
--fechaevento<='2012-07-09 00:00:00.000'    
fechaevento<=dateadd(DAY,-3,getdate())    
and estado IN ('COM','VAL')      
and idlinea='1'      
--and idregistro in ('23583869','23583870')      
      
print 'Llenado de tabla Demora - listo'      
-----------------------            
      
UPDATE LIN_Registro      
SET ESTADO='ERR'      
WHERE IDREGISTRO in (select idregistro from LIN_DEMORA (nolock) )      
      
    
    
            
END            
      
GO
/****** Object:  StoredProcedure [dbo].[Lin_Eliminar_Evento_no_configurados]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Eliminar_Evento_no_configurados]
  as
  DELETE FROM LIN_REGISTRO
WHERE IdRegistro IN
 ( SELECT lr.IdRegistro
   FROM LIN_REGISTRO lr
     INNER JOIN (select idLinea, idevento from lin_lineaXevento  where activo = 0  ) evEliminar on (lr.idLinea = evEliminar.idLinea AND lr.idEvento = evEliminar.idEvento))
GO
/****** Object:  StoredProcedure [dbo].[LIN_EliminarEquivalencia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_EliminarEquivalencia]
(
	@IdEquivalencia int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM	LIN_Equivalencia
	WHERE	IdEquivalencia = @IdEquivalencia
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_EliminarEventoGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_EliminarEventoGrupo]          
(          
 @IdGrupo int,
 @IdEvento int       
)     
AS  
BEGIN  
 DELETE LIN_Grupo_Evento
 WHERE IdGrupo = @IdGrupo 
   AND IdEvento = @IdEvento 
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_EliminarEventoXEvento_IdEventoFin]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 05/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_EliminarEventoXEvento_IdEventoFin]
(
	@IdEvento_Fin int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM	LIN_EventoXEvento
	WHERE	IdEvento_Fin = @IdEvento_Fin
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_EliminarHoraCorte_IdHoraCorte]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_EliminarHoraCorte_IdHoraCorte]        
(        
 @IdHoraCorte int      
)   
AS
BEGIN
	DELETE dbo.LIN_Linea_HoraCorte
	WHERE IdHoraCorte = @IdHoraCorte
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ERRORES_ATASCO]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ERRORES_ATASCO]
AS        
BEGIN       
    
--delete LIN_ERRORES    
UPDATE LIN_REGISTRO
SET ESTADO='ERR'
WHERE IDREGISTRO IN (
---------------------      
--insert into LIN_ERRORES (IDREGISTRO)      

select DISTINCT IDREGISTRO from lin_registro(nolock)
where idlinea='2' and idevento in ('5','6','10','3','4') and estado='ENV'
and contenedor in (

select contenedor from lin_registro(nolock)
where idlinea='2' and idevento in ('13') AND ESTADO='COM'
and fechaevento>='2012-10-01 09:52:00.000'
and contenedor in (

select contenedor from lin_registro(nolock)
where idlinea='2' and idevento in ('5','6','10','3','4') and estado='ENV'

				)
				)
)
-------------------
   

    
END    

GO
/****** Object:  StoredProcedure [dbo].[LIN_ERRORES_ATASCO_PIL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ERRORES_ATASCO_PIL]
AS        
BEGIN       
    
--delete LIN_ERRORES    
UPDATE LIN_REGISTRO
SET ESTADO='ERR'
WHERE IDREGISTRO IN (
---------------------      
--insert into LIN_ERRORES (IDREGISTRO)      

select DISTINCT IDREGISTRO from lin_registro(nolock)
where idlinea='5' and idevento in ('5','6','10','12') and estado='ENV'
and contenedor in (

select contenedor from lin_registro(nolock)
where idlinea='5' and idevento in ('5','6') AND ESTADO='COM'
and fechaevento>='2012-10-01 09:52:00.000'
and contenedor in (

select contenedor from lin_registro(nolock)
where idlinea='5' and idevento in ('10','12') and estado='ENV'

				)
				)


)
-------------------
   

    
END    

GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteCampo_CodigoXIdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteCampo_CodigoXIdEvento]
(
	@Codigo nvarchar(10),
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF EXISTS	(	SELECT	*
					FROM	LIN_Campo
					WHERE	Codigo = @Codigo
					AND		IdEvento = @IdEvento
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteCampo_CodigoXIdEvento_NotIdCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteCampo_CodigoXIdEvento_NotIdCampo]
(
	@Codigo nvarchar(15),
	@IdEvento int,
	@IdCampo int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Campo
					WHERE	Codigo = @Codigo
					AND		IdEvento = @IdEvento
					AND		IdCampo <> @IdCampo
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteEquivalencia_IdCampoXIdLineaXValorOriginal]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteEquivalencia_IdCampoXIdLineaXValorOriginal]
(
	@IdCampo int,
	@IdLinea int,
	@ValorOriginal nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Equivalencia
					WHERE	IdCampo = @IdCampo
					AND		IdLinea = @IdLinea
					AND		ValorOriginal = @ValorOriginal
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteEquivalencia_IdCampoXIdLineaXValorOriginal_NotIdEquivalencia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteEquivalencia_IdCampoXIdLineaXValorOriginal_NotIdEquivalencia]
(
	@IdCampo int,
	@IdLinea int,
	@ValorOriginal nvarchar(100),
	@IdEquivalencia int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Equivalencia
					WHERE	IdCampo = @IdCampo
					AND		IdLinea = @IdLinea
					AND		ValorOriginal = @ValorOriginal
					AND		IdEquivalencia <> @IdEquivalencia
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteEvento_Codigo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteEvento_Codigo]
(
	@Codigo nvarchar(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Evento
					WHERE	Codigo = @Codigo
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteEvento_Codigo_NotIdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteEvento_Codigo_NotIdEvento]
(
	@Codigo nvarchar(10),
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Evento
					WHERE	Codigo = @Codigo
					AND		IdEvento <> @IdEvento
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteEvento_IdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 05/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteEvento_IdEvento]
(
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Evento
					WHERE	IdEvento = @IdEvento
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteHoraCorte_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Enrique Véliz    
-- Create date: 20/12/2010    
-- Description:     
-- =============================================    
ALTER PROCEDURE [dbo].[LIN_ExisteHoraCorte_IdLinea]    
(    
 @idLinea int,
 @idGrupo int,  
 @horaCorte int,  
 @minutoCorte int  
)    
AS    
BEGIN    
 SET NOCOUNT ON;    
     
 IF EXISTS ( SELECT *    
     FROM dbo.LIN_Linea_HoraCorte    
     WHERE idLinea = @idLinea  
     AND idGrupo = @idGrupo
     AND horaCorte = @horaCorte  
     AND minutoCorte = @minutoCorte  
     )    
  SELECT 1    
 ELSE    
  SELECT 0    
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLinea_Codigo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteLinea_Codigo]
(
	@Codigo nvarchar(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Linea
					WHERE	Codigo = @Codigo
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLinea_Codigo_NotIdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteLinea_Codigo_NotIdLinea]
(
	@Codigo nvarchar(10),
	@IdLinea int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_Linea
					WHERE	Codigo = @Codigo
					AND		IdLinea <> @IdLinea
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLineaXEvento_IdLineaXIdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 30/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteLineaXEvento_IdLineaXIdEvento]
(
	@IdLinea int,
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_LineaXEvento
					WHERE	IdLinea = @IdLinea
					AND		IdEvento = @IdEvento
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLineaXEventoXTipoFormato_IdLineaXIdEventoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 22/06/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ExisteLineaXEventoXTipoFormato_IdLineaXIdEventoXTipoFormato]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	LIN_LineaXEventoXTipoFormato
					WHERE	IdLinea = @IdLinea
					AND		IdEvento = @IdEvento
					AND		TipoFormato = @TipoFormato
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLineaXGrupo_IdLineaXIdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 30/12/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ExisteLineaXGrupo_IdLineaXIdGrupo]  
(  
 @IdLinea int,  
 @IdGrupo int  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 IF EXISTS ( SELECT *  
     FROM LIN_LineaXGrupo  
     WHERE IdLinea = @IdLinea  
     AND  IdGrupo = @IdGrupo  
    )  
  SELECT 1  
 ELSE  
  SELECT 0  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ExisteLineaXGrupoXTipoFormato_IdLineaXIdGrupoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ExisteLineaXGrupoXTipoFormato_IdLineaXIdGrupoXTipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 IF EXISTS ( SELECT *  
     FROM LIN_LineaXGrupoXTipoFormato  
     WHERE IdLinea = @IdLinea  
     AND  IdGrupo = @IdGrupo  
     AND  TipoFormato = @TipoFormato  
    )  
  SELECT 1  
 ELSE  
  SELECT 0  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_FORMATOGLOBAL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================    
-- Author:  Luis Cuadra
-- Create date: 24/11/2011   
-- Description:     
-- =============================================    
ALTER PROCEDURE [dbo].[LIN_FORMATOGLOBAL]  
@IDLINEA INT,  
@CONFIG XML,  
@EVENTOBASE INT  
AS  
BEGIN  
  
UPDATE LIN_LINEA  
SET GLOBALCONFIG = @CONFIG,  
EVENTOBASE = @EVENTOBASE  
WHERE IDLINEA = @IDLINEA  
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_Insert_Mail_Presupuesto]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_Insert_Mail_Presupuesto]  
@from nvarchar(40),  
@asusnto nvarchar (60),  
@fecha datetime,  
@body text  
as  
insert into lin_Mail_Presupuesto  
values (@from,@asusnto,@fecha,@body,getdate())
GO
/****** Object:  StoredProcedure [dbo].[LIN_Insertar_ContenedorLog]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[LIN_Insertar_ContenedorLog]
  @idmail int,
  @contenedor nvarchar(20),
  @estado char(1)
    as
  insert into LIN_Mail_Log
  values (@idmail,@contenedor,GETDATE(),@estado) 
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarCampo]
(
	@IdEvento int,
	@Codigo nvarchar(15),
	@Nombre nvarchar(100),
	@TipoDato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_Campo
	(IdEvento,Codigo,Nombre,TipoDato)
	VALUES
	(@IdEvento,@Codigo,@Nombre,@TipoDato)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarEquivalencia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarEquivalencia]
(
	@IdCampo int,
	@IdLinea int,
	@ValorOriginal nvarchar(100),
	@ValorEquivalente nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_Equivalencia
	(IdCampo,IdLinea,ValorOriginal,ValorEquivalente)
	VALUES
	(@IdCampo,@IdLinea,@ValorOriginal,@ValorEquivalente)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarEvento]
(
	@Codigo nvarchar(10),
	@Nombre nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_Evento
	(Codigo,Nombre)
	VALUES
	(@Codigo,@Nombre)
	
	SELECT	SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarEvento_IdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
  
-- =============================================        
-- Author: David Arias    
-- Create date: 20/12/2010        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_InsertarEvento_IdGrupo]        
(        
 @idGrupo int,  
 @idEvento int
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 INSERT INTO  LIN_Grupo_Evento
 (IdGrupo,IdEvento)        
 VALUES        
 (@idGrupo,@idEvento) 
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarEventoXEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 05/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarEventoXEvento]
(
	@IdEvento_Inicio int,
	@IdEvento_Fin int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_EventoXEvento
	(IdEvento_Inicio,IdEvento_Fin)
	VALUES
	(@IdEvento_Inicio,@IdEvento_Fin)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarGrupo_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
  
-- =============================================        
-- Author: David Arias    
-- Create date: 20/12/2010        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_InsertarGrupo_IdLinea]        
(        
 @idLinea int,  
 @idEventoBase int,      
 @descripcion varchar(250),
 @EnvioAutomatico bit,
 @EnvioCorte bit,
 @activo bit
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 INSERT INTO  LIN_Linea_Grupo
 (IdLinea,IdEventoBase, Descripcion,EnvioAutomatico,EnvioCorte, Activo)        
 VALUES        
 (@idLinea,@idEventoBase,@descripcion,@EnvioAutomatico,@EnvioCorte, @activo) 
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarHoraCorte_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
-- =============================================          
-- Author:  Enrique Véliz          
-- Create date: 20/12/2010          
-- Description:           
-- =============================================          
ALTER PROCEDURE [dbo].[LIN_InsertarHoraCorte_IdLinea]          
(          
 @idLinea int, 
 @idGrupo int,         
 @horaCorte int,          
 @minutoCorte int   
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
           
 INSERT INTO dbo.LIN_Linea_HoraCorte  
 (IdLinea,IdGrupo, HoraCorte,MinutoCorte)          
 VALUES          
 (@idLinea,@idGrupo,@horaCorte,@minutoCorte)   
 
 IF NOT EXISTS (SELECT 'X' 
				  FROM LIN_FechaProcesoCorte 
				 WHERE idLinea = @idLinea
				   AND IdGrupo = @idGrupo)
 INSERT INTO [LIN_FechaProcesoCorte]
           ([idLinea]
           ,[FechaCorteAnterior]
           ,[FechaCorteProximo]
           ,[FechaProceso]
           ,[EstadoProceso]
           ,[IdGrupo])
     VALUES
           (@idLinea
           ,GETDATE() -1
           ,GETDATE() -1
           ,null
           ,'N'
           ,@idGrupo)
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
-- =============================================        
-- Author:  Enrique Véliz        
-- Create date: 20/12/2010        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_InsertarLinea]        
(        
 @Codigo nvarchar(10),        
 @Nombre nvarchar(100),        
 @PeriodoMinutos int,        
 @EnvioTotal bit,        
 @Activo bit ,      
 @EnvioAutomatico bit,
 @ConfiguracionCorte bit ,
 @Email varchar(1000),
 @AsuntoEmail varchar(100)    
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 INSERT INTO LIN_Linea        
 (Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo,EnvioAutomatico,
 ConfiguracionCorte,Email,AsuntoEmail
 )        
 VALUES        
 (@Codigo,@Nombre,@PeriodoMinutos,@EnvioTotal,@Activo,@EnvioAutomatico,
 @ConfiguracionCorte,@Email,@AsuntoEmail
  )        
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Véliz
-- Create date: 30/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXEvento]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3),
	@DefinicionFormato xml,
	@NombreArchivo nvarchar(100),
	@TamanhoLote int,
	@Email nvarchar(MAX),
	@AsuntoEmail nvarchar(50),
	@Activo bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_LineaXEvento
	(IdLinea,IdEvento,TipoFormato,DefinicionFormato,NombreArchivo,TamanhoLote,Email,AsuntoEmail,Activo)
	VALUES
	(@IdLinea,@IdEvento,@TipoFormato,@DefinicionFormato,@NombreArchivo,@TamanhoLote,@Email,@AsuntoEmail,@Activo)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXEvento_Configuracion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- =============================================        
-- Author:  Enrique Véliz        
-- Create date: 22/06/2011        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXEvento_Configuracion]        
(        
 @IdLinea int,        
 @IdEvento int,        
 @DefinicionNombreArchivo xml,        
 @NombreArchivo nvarchar(100),        
 @TamanhoLote int,        
 @Email nvarchar(MAX),        
 @AsuntoEmail nvarchar(50),       
 @RutaCopy nvarchar(100),        
 @RutaFTP nvarchar(250),    
 @UsuarioFTP nvarchar(50),    
 @PasswordFTP nvarchar(50),    
 @IdCampoAgrupar int,        
 @Activo bit,      
 @EventoInicial bit , 
 @IDTipoEvento int,   
 @FechaOperativa int,   
 @CampoBD varchar(100)         
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 INSERT INTO LIN_LineaXEvento        
 (IdLinea,IdEvento,DefinicionNombreArchivo,NombreArchivo,TamanhoLote,Email,AsuntoEmail,RutaCopy,RutaFTP,UsuarioFTP,PasswordFTP,IdCampoAgrupar,Activo, EventoInicial,IDTipoEvento,IDFechaOperativa,CampoBD)        
 VALUES        
 (@IdLinea,@IdEvento,@DefinicionNombreArchivo,@NombreArchivo,@TamanhoLote,@Email,@AsuntoEmail,@RutaCopy,@RutaFTP,@UsuarioFTP,@PasswordFTP,@IdCampoAgrupar,@Activo, @EventoInicial,@IDTipoEvento,@FechaOperativa,@CampoBD)        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXEvento_TipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 22/06/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXEvento_TipoFormato]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_LineaXEvento
	(IdLinea,IdEvento,TipoFormato,EventoInicial,Activo)
	VALUES
	(@IdLinea,@IdEvento,@TipoFormato,0,0)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXEventoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 22/06/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXEventoXTipoFormato]
(
	@IdLinea int,
	@IdEvento int,
	@TipoFormato char(3),
	@DefinicionFormato xml
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_LineaXEventoXTipoFormato
	(IdLinea,IdEvento,TipoFormato,DefinicionFormato)
	VALUES
	(@IdLinea,@IdEvento,@TipoFormato,@DefinicionFormato)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXGrupo_Configuracion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- =============================================        
-- Author:  Enrique Véliz        
-- Create date: 22/06/2011        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXGrupo_Configuracion]        
(        
 @IdLinea int,        
 @IdGrupo int,        
 @DefinicionNombreArchivo xml,        
 @NombreArchivo nvarchar(100),        
 @TamanhoLote int,        
 @Email nvarchar(MAX),        
 @AsuntoEmail nvarchar(50),       
 @RutaCopy nvarchar(100),        
 @RutaFTP nvarchar(250),    
 @UsuarioFTP nvarchar(50),    
 @PasswordFTP nvarchar(50),    
 @IdCampoAgrupar int,        
 @Activo bit,      
 @EventoInicial bit          
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 INSERT INTO LIN_LineaXGrupo       
 (IdLinea,IdGrupo,DefinicionNombreArchivo,NombreArchivo,TamanhoLote,Email,AsuntoEmail,RutaCopy,RutaFTP,UsuarioFTP,PasswordFTP,IdCampoAgrupar,Activo, EventoInicial)        
 VALUES        
 (@IdLinea,@IdGrupo,@DefinicionNombreArchivo,@NombreArchivo,@TamanhoLote,@Email,@AsuntoEmail,@RutaCopy,@RutaFTP,@UsuarioFTP,@PasswordFTP,@IdCampoAgrupar,@Activo, @EventoInicial)        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXGrupo_TipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXGrupo_TipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 INSERT INTO LIN_LineaXGrupo  
 (IdLinea,IdGrupo,TipoFormato,EventoInicial,Activo)  
 VALUES  
 (@IdLinea,@IdGrupo,@TipoFormato,0,0)  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLineaXGrupoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_InsertarLineaXGrupoXTipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3),  
 @DefinicionFormato xml  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 INSERT INTO LIN_LineaXGrupoXTipoFormato  
 (IdLinea,IdGrupo,TipoFormato,DefinicionFormato)  
 VALUES  
 (@IdLinea,@IdGrupo,@TipoFormato,@DefinicionFormato)  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarLogError]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[LIN_InsertarLogError]
(
   @DescPrograma nvarchar(100)
 , @DescError  nvarchar(1000)
)

AS
 
 INSERT INTO  [LIN_LogErrror]
           ([DescPrograma]
           ,[FechaError]
           ,[DescError])
     VALUES
           (@DescPrograma
           ,getdate()
           ,@DescError)
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarOperativo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--LIN_InsertarOperativo '20110805'  
  
--delete from lin_operativo where evento in ('0800')   
--select evento, count(*) from lin_operativo where evento in ('0600', '0700') group by evento  
--delete from lin_operativo  
--select evento, count(*) from lin_operativo  
--group by evento  
--select * from lin_operativo where evento = '0200' and fechacreacion is not null  
  
  
--ALTER PROCEDURE [dbo].[LIN_InsertarOperativo]  --FMCR
--@FechaProceso datetime  
--as  
--set nocount on  
  
--declare @0200 bit, @0230 bit, @0400 bit,   
--@0500 bit, @0600 bit, @0601 bit,   
--@0700 bit, @0715 bit, @0800 bit, @0900 bit, @1000 bit   
  
--set @0200 = 1  
--set @0230 = 1  
--set @0400 = 1  
--set @0500 = 1  
--set @0600 = 1  
--set @0601 = 1  
--set @0700 = 1  
--set @0715 = 1  
--set @0800 = 1  
--set @0900 = 1  
--set @1000 = 1  
  
--if @0200 = 1  
--Begin  
-- /*  
-- PROCESANDO EVENTO 0200  
-- */  
-- delete from lin_operativo where evento = '0200' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
    
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '0200' as Evento,   
-- n.Linea,   
-- n.Contenedor,   
-- n.fecha   
-- from Nep_Evento_0200 n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0200 Listo'  
--end  
  
--if @0230 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0230  
-- */  
-- delete from lin_operativo where evento = '0230' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '0230',   
-- n.Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0230 n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0230 Listo'  
--end  
  
--if @0400 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0400 HLE  
-- */  
-- delete from lin_operativo where evento = '0400' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)   
-- select distinct '0400',   
-- 'HLE' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0400_HLE n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0400 HLE Listo'  
  
-- /*  
-- PROCESANDO EVENTO 0400 HSD  
-- */  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0400' as Evento, 'HSD' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0400_HSD n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0400 HSD Listo'  
--End  
  
--if @0500 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0500 HLE  
-- */  
  
-- delete from lin_operativo where evento = '0500' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0500' as Evento, 'HLE' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0500_HLE n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- print 'Evento 0500 HLE Listo'  
  
-- /*  
-- PROCESANDO EVENTO 0500 HSD  
-- */  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0500' as Evento, 'HSD' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0500_HSD n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- print 'Evento 0500 HSD Listo'  
--end  
  
--if @0600 = 1  
--begin  
-- delete from lin_operativo where evento = '0600' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
-- /*  
-- PROCESANDO EVENTO 0600 HSD  
-- */  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0600' as Evento, 'HSD' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0600_HSD n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- print 'Evento 0600 HSD Listo'  
--end  
  
--if @0601 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0601 HSD  
-- */  
-- delete from lin_operativo where evento = '0601' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0601' as Evento, 'HSD' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0601_HSD n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0601 HSD Listo'  
--end  
  
--if @0700 = 1  
--Begin  
-- /*  
-- PROCESANDO EVENTO 0700 HSD  
-- */  
-- delete from lin_operativo where evento = '0700' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0700' as Evento, 'HSD' as Linea,   
-- n.Contenedor,   
-- n.fecha  
-- from NEP_Evento_0700_HSD n  
-- Where FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
--End  
  
--if @0715 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0715  
-- */   
-- delete from lin_operativo where evento = '0715' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '0715', Linea, n.Contenedor,   
-- n.fecha   
-- from NEP_Evento_0715 n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0715 Listo'  
--End   
  
--if @0800 = 1  
--Begin  
-- /*  
-- PROCESANDO EVENTO 0800 A  
-- */  
-- delete from lin_operativo where evento = '0800' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '0800', Linea, n.Contenedor, n.fecha  
-- from NEP_Evento_0800A n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0800A Listo'  
-- /*  
-- PROCESANDO EVENTO 0800 B  
-- */  
   
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select distinct '0800', Linea, n.Contenedor, n.fecha  
-- from NEP_Evento_0800B n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0800B Listo'  
--End  
  
--if @0900 = 1  
--begin  
-- /*  
-- PROCESANDO EVENTO 0900  
-- */  
-- delete from lin_operativo where evento = '0900' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
   
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '0900', Linea, n.Contenedor, n.fecha  
-- from NEP_Evento_0900 n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 0900 Listo'  
--End  
  
--if @1000 = 1  
--Begin  
-- /*  
-- PROCESANDO EVENTO 1000  
-- */  
-- delete from lin_operativo where evento = '1000' and FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- insert lin_operativo (Evento, Linea, Contenedor, Fecha)  
-- select '1000', Linea, n.Contenedor, n.fecha  
-- from NEP_Evento_1000 n  
-- where n.linea in ('HSD', 'HLE')  
-- and FLOOR(CAST(n.fecha as float)) = FLOOR(CAST(@FechaProceso as float))  
  
-- print 'Evento 1000 Listo'  
--End  
  
  
--GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 21/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistro]
(
	@IdLinea int,
	@IdEvento int,
	@Contenedor nvarchar(20),
	@FechaEvento datetime,
	@Estado char(3),
	@IdRegistro_Anterior int,
	@IdRegistro_Siguiente int,
	@Tipo char(3),
	@EnvioIndependiente bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,@FechaEvento,@Estado,GETDATE(),
	@IdRegistro_Anterior,@IdRegistro_Siguiente,@Tipo,@EnvioIndependiente)
	
	SELECT	SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistroDetalle]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistroDetalle]
(
	@IdRegistro int,
	@NroItem int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_RegistroDetalle
	(IdRegistro,NroItem)
	VALUES
	(@IdRegistro,@NroItem)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistroDetalleXCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistroDetalleXCampo]
(
	@IdRegistro int,
	@NroItem int,
	@IdCampo int,
	@Valor nvarchar(500)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_RegistroDetalleXCampo
	(IdRegistro,NroItem,IdCampo,Valor)
	VALUES
	(@IdRegistro,@NroItem,@IdCampo,@Valor)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistroFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistroFormato]
(
	@IdRegistro int,
	@Tipo char(3),
	@Formato nvarchar(MAX),
	@NombreArchivo nvarchar(MAX),
	@NombreArchivoLote nvarchar(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_RegistroFormato
	(IdRegistro,Tipo,Formato,NombreArchivo,NombreArchivoLote)
	VALUES
	(@IdRegistro,@Tipo,@Formato,@NombreArchivo,@NombreArchivoLote)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistroLog]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Véliz
-- Create date: 12/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistroLog]
(
	@IdRegistro int,
	@Estado char(3),
	@Mensaje nvarchar(MAX)

)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO	LIN_RegistroLog WITH (ROWLOCK)
	(IdRegistro,Estado,Mensaje,FechaCreacion)
	VALUES
	(@IdRegistro,@Estado,@Mensaje,GETDATE())

	-- SE COMENTO POR MALAS PRACTICAS
	--SELECT	SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[LIN_InsertarRegistroXCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_InsertarRegistroXCampo]
(
	@IdRegistro int,
	@IdCampo int,
	@Valor nvarchar(500)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	LIN_RegistroXCampo
	(IdRegistro,IdCampo,Valor)
	VALUES
	(@IdRegistro,@IdCampo,@Valor)
END
GO
/****** Object:  StoredProcedure [dbo].[Lin_Obtener_Campos_Faltantes]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Obtener_Campos_Faltantes]
@idregistro int
as
select isnull(FechaEvento,'') as FechaEvento , isnull(Navvia,'')  as Navvia, isnull(TipoDocumento,'') as TipoDocumento , isnull(Numerodocumento,'')  as Numerodocumento, isnull(BookingBL,'')as BookingBL,isnull(Genbkg,'') as Genbkg from lin_Registro where idregistro = @idregistro
GO
/****** Object:  StoredProcedure [dbo].[Lin_Obtener_ErrorXIdregistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Obtener_ErrorXIdregistro]
@idregistro int
as

select Mensaje from lin_RegistroLog
where IdRegistro = @idregistro
order by 1 desc
GO
/****** Object:  StoredProcedure [dbo].[LIN_OBTENER_FECHAORGANIZACIONALXCOD]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_OBTENER_FECHAORGANIZACIONALXCOD]
@IDTIPOEVENTO INT
AS
SELECT ID,DESCRIPCION FROM lin_fechaOrganizacional WHERE IDTIPOEVENTO=@IDTIPOEVENTO
GO
/****** Object:  StoredProcedure [dbo].[LIN_Obtener_Mailid]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_Obtener_Mailid]
as
select top 1idmail from lin_mail_presupuesto
order by idmail desc
GO
/****** Object:  StoredProcedure [dbo].[Lin_Obtener_Parametros]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Obtener_Parametros]
as
select [Par_ID] as ID,[Par_Name] as Nombre,[Par_Descripcion] as Descripcion,[Par_Valor] as Valor
from lin_Parametros
GO
/****** Object:  StoredProcedure [dbo].[Lin_Obtener_ParametrosXid]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Lin_Obtener_ParametrosXid]
@ID int
as
select [Par_ID] as ID,[Par_Name] as Nombre,[Par_Descripcion] as Descripcion,[Par_Valor] as Valor
from lin_Parametros where [Par_ID] = @ID
GO
/****** Object:  StoredProcedure [dbo].[LIN_OBTENER_TIPOEVENTO]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_OBTENER_TIPOEVENTO]
AS
SELECT * FROM LIN_TIPOEVENTO
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 11/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerCampo]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdCampo,IdEvento,Codigo,Nombre,TipoDato
	FROM	LIN_Campo
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerCampo_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerCampo_Consultar]
(
	@Codigo nvarchar(10),
	@Nombre nvarchar(100),
	@IdEvento int,
	@TipoDato char(3)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	C.IdCampo AS IdCampo,
			C.Codigo AS Codigo,
			C.Nombre AS Nombre,
			E.Codigo AS CodigoEvento,
			E.Nombre AS NombreEvento,
			C.TipoDato AS TipoDato
	FROM	LIN_Campo C
	INNER JOIN	LIN_Evento E ON C.IdEvento = E.IdEvento
	WHERE	(@Codigo IS NULL OR C.Codigo LIKE '%' + @Codigo + '%')
	AND		(@Nombre IS NULL OR C.Nombre LIKE '%' + @Nombre + '%')
	AND		(@IdEvento IS NULL OR C.IdEvento = @IdEvento)
	AND		(@TipoDato IS NULL OR C.TipoDato = @TipoDato)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerCampo_IdCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 02/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerCampo_IdCampo]
(
	@IdCampo int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdCampo,IdEvento,Codigo,Nombre,TipoDato
	FROM	LIN_Campo
	WHERE	IdCampo = @IdCampo
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerCampo_IdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 11/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerCampo_IdEvento]
(
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdCampo,IdEvento,Codigo,Nombre,TipoDato
	FROM	LIN_Campo
	WHERE	IdEvento = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerCampos_LineaXEventoXContenedor]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 31/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerCampos_LineaXEventoXContenedor]
(
	@IdLinea int,
	@IdEvento int,
	@Contenedor nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE	@CodigoLinea nvarchar(10)
	DECLARE	@CodigoEvento nvarchar(10)
	
	SELECT	@CodigoLinea = Codigo
	FROM	LIN_Linea
	WHERE	IdLinea = @IdLinea
	
	SELECT	@CodigoEvento = Codigo
	FROM	LIN_Evento
	WHERE	IdEvento = @IdEvento
	
	EXEC	NEP_ObtenerCampos_LineaXEventoXContenedor @CodigoLinea,@CodigoEvento,@Contenedor
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEquivalencia_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEquivalencia_Consultar]
(
	@IdLinea int,
	@IdEvento int,
	@IdCampo int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	E.IdEquivalencia AS IdEquivalencia,
			C.IdCampo AS IdCampo,
			C.Codigo AS CodigoCampo,
			C.Nombre AS NombreCampo,
			EV.IdEvento AS IdEvento,
			EV.Codigo AS CodigoEvento,
			EV.Nombre AS NombreEvento,
			L.IdLinea AS IdLinea,
			L.Codigo AS CodigoLinea,
			L.Nombre AS NombreLinea,
			E.ValorOriginal AS ValorOriginal,
			E.ValorEquivalente AS ValorEquivalente
	FROM	LIN_Equivalencia E
	INNER JOIN	LIN_Campo C ON E.IdCampo = C.IdCampo
	INNER JOIN	LIN_Evento EV ON C.IdEvento = EV.IdEvento
	INNER JOIN	LIN_Linea L ON E.IdLinea = L.IdLinea
	WHERE	(@IdLinea IS NULL OR E.IdLinea = @IdLinea)
	AND		(@IdEvento IS NULL OR EV.IdEvento = @IdEvento)
	AND		(@IdCampo IS NULL OR C.IdCampo = @IdCampo)
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEquivalencia_IdCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEquivalencia_IdCampo]
(
	@IdCampo int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdEquivalencia,IdCampo,IdLinea,ValorOriginal,ValorEquivalente
	FROM	LIN_Equivalencia
	WHERE	IdCampo = @IdCampo
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEquivalencia_IdCampoXIdLineaXValorOriginal]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEquivalencia_IdCampoXIdLineaXValorOriginal]
(
	@IdCampo int,
	@IdLinea int,
	@ValorOriginal nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdEquivalencia,IdCampo,IdLinea,ValorOriginal,ValorEquivalente
	FROM	LIN_Equivalencia
	WHERE	IdCampo = @IdCampo
	AND		IdLinea = @IdLinea
	AND		ValorOriginal = @ValorOriginal
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEquivalencia_IdEquivalencia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 03/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEquivalencia_IdEquivalencia]
(
	@IdEquivalencia int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdEquivalencia,IdCampo,IdLinea,ValorOriginal,ValorEquivalente
	FROM	LIN_Equivalencia
	WHERE	IdEquivalencia = @IdEquivalencia
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 09/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEvento]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdEvento,Codigo,Nombre
	FROM	LIN_Evento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEvento_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEvento_Consultar]
(
	@Codigo nvarchar(10),
	@Nombre nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	E.IdEvento AS IdEvento,
			E.Codigo AS Codigo,
			E.Nombre AS Nombre
	FROM	LIN_Evento E
	WHERE	(@Codigo IS NULL OR E.Codigo LIKE '%' + @Codigo + '%')
	AND		(@Nombre IS NULL OR E.Nombre LIKE '%' + @Nombre + '%')
	ORDER BY	E.Codigo ASC
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEvento_IdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 16/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEvento_IdEvento]
(
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdEvento,Codigo,Nombre
	FROM	LIN_Evento
	WHERE	IdEvento = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEvento_IdEventoGlobal]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================      
-- Author:  Enrique Véliz      
-- Create date: 16/12/2010      
-- Description:       
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ObtenerEvento_IdEventoGlobal]    
(      
 @IdLinea int      
)      
AS      
BEGIN      
 SET NOCOUNT ON;      
       
 SELECT E.IdEvento,E.Codigo,E.Nombre      
 FROM LIN_Evento  E    
 LEFT JOIN LIN_Linea L ON L.EVENTOBASE = E.IDEVENTO    
 WHERE IDLINEA = @IDLINEA    
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEventoFiltro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Luis Cuadra    
-- Create date: 26/07/2011  
-- Description:     
-- =============================================    
ALTER PROCEDURE [dbo].[LIN_ObtenerEventoFiltro]    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 SELECT IdEvento,Codigo,Nombre    
 FROM LIN_Evento    
 WHERE IdEvento in ( 3,4,5,6,7,8,9,10,12,13,16) 
   
 END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEventoPredecesor_IdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 05/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEventoPredecesor_IdEvento]
(
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	E.IdEvento,E.Codigo,E.Nombre
	FROM	LIN_EventoXEvento EXE
	INNER JOIN	LIN_Evento E ON EXE.IdEvento_Inicio = E.IdEvento
	WHERE	EXE.IdEvento_Fin = @IdEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEventos_IdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --LIN_ObtenerEventos_IdGrupo 7
-- =============================================      
-- Author: David Arias
-- Create date: 16/12/2010      
-- Description:   
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ObtenerEventos_IdGrupo]      
(      
 @IdGrupo int      
)      
AS      
BEGIN      
	SET NOCOUNT ON;      
	SELECT IdGrupo, GE.IdEvento
	     , CodigoEvento = E.Codigo, NombreEvento = E.Nombre 
	FROM LIN_Grupo_Evento GE with (nolock)  
	INNER JOIN LIN_Evento E on E.IdEvento = GE.IdEvento   
	WHERE IdGrupo = @IdGrupo      
	--ORDER BY Descripcion    
END   
 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerEventoXEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 09/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerEventoXEvento]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdEvento_Inicio,IdEvento_Fin
	FROM	LIN_EventoXEvento
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerFechaProcesoCorte]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
 --[LIN_ObtenerFechaProcesoCorte] 5  
   
ALTER PROCEDURE [dbo].[LIN_ObtenerFechaProcesoCorte]  
(  
@IdLinea INT,
@IdGrupo INT  
)  
as  
   
 SELECT [idProceso]  
      ,[idLinea]  
      ,[FechaCorteAnterior]  
      ,[FechaCorteProximo]  
      ,[FechaProceso]  
      , EstadoProceso   
   FROM LIN_FechaProcesoCorte  
  WHERE FechaCorteProximo < GETDATE()  
    AND EstadoProceso = 'N'  
    AND idLinea = @IdLinea
    AND IdGrupo = @IdGrupo
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerFechaProcesoCortexxx]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
 --[LIN_ObtenerFechaProcesoCorte] 10 ,1   
     
ALTER PROCEDURE [dbo].[LIN_ObtenerFechaProcesoCortexxx]    
(    
@IdLinea INT,  
@IdGrupo INT    
)    
as    
     
 SELECT [idProceso]    
      ,[idLinea]    
      ,[FechaCorteAnterior]    
      ,[FechaCorteProximo]    
      ,[FechaProceso]    
      , EstadoProceso     
   FROM LIN_FechaProcesoCorte 
   where idProceso =384	   
  --WHERE FechaCorteProximo < GETDATE()    
  --  AND EstadoProceso = 'N'    
  --  AND idLinea = @IdLinea  
  --  AND IdGrupo = @IdGrupo
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerFormatoGrupo_IdLineaXIdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
  --LIN_ObtenerFormatoGrupo_IdLineaXIdGrupo 5, -1  
  --LIN_ObtenerFormatoGrupo_IdLineaXIdGrupo -1, -1  ,1
-- =============================================          
-- Author: David Arias      
-- Create date: 20/12/2010          
-- Description:           
-- =============================================          
ALTER PROCEDURE [dbo].[LIN_ObtenerFormatoGrupo_IdLineaXIdGrupo]          
(          
 @idLinea int,  
 @idGrupo int,  
 @indValidarCorte int  
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
           
    
SELECT L.IdLinea, L.Codigo CodigoLinea, L.Nombre DescripcionLinea  
     , LG.IdGrupo, LG.Descripcion DescripcionGrupo, LG.IdEventoBase   
     , LGP.DefinicionNombreArchivo, LGP.Email, LGP.AsuntoEmail
     , LGTF.TipoFormato, LGTF.DefinicionFormato  
  FROM LIN_LINEA L  
  JOIN LIN_Linea_Grupo LG ON LG.IdLinea = L.IdLinea   
  JOIN LIN_LineaxGrupo LGP ON LGP.Idlinea = LG.IdLinea AND LGP.IdGrupo = LG.IdGrupo  
  JOIN LIN_LineaXGrupoXTipoFormato LGTF ON LGTF.Idlinea = LG.IdLinea AND LGTF.IdGrupo = LG.IdGrupo  
  WHERE (@indValidarCorte = 0 or (@indValidarCorte= 1 AND LG.EnvioCorte = 1))  
    AND (@idLinea = -1 OR L.IdLinea = @idLinea)  
    AND (@idGrupo = -1 OR LG.IdGrupo = @idGrupo )  
    
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerGrupo_Id]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
  
-- =============================================        
-- Author: David Arias    
-- Create date: 20/12/2010        
-- Description:         
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_ObtenerGrupo_Id]        
(        
 @idGrupo int
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
 SELECT IdGrupo,IdLinea,IdEventoBase
      , DescripcionEvento = (SELECT CODIGO + ' - ' + NOMBRE 
	                              FROM LIN_Evento
	                             WHERE IdEvento = LG.IdEventoBase)
	  , Descripcion
	  , EnvioAutomatico, EnvioCorte, Activo
   FROM LIN_Linea_Grupo LG  
  WHERE idGrupo = @idGrupo
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerGrupos_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --LIN_ObtenerGrupos_IdLinea 7    
-- =============================================          
-- Author: David Arias    
-- Create date: 16/12/2010          
-- Description:   
-- Update : Jose Rodriguez
-- Update date : 10/10/2014    
-- =============================================          
ALTER PROCEDURE [dbo].[LIN_ObtenerGrupos_IdLinea]          
(          
 @IdLinea int         
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
 SELECT LG.IdGrupo, LG.IdLinea,
 --Agregado por jose
 gp.IdEvento as IdEventoBase    
 ------
      , DescripcionEvento = (SELECT CODIGO + ' - ' + NOMBRE     
                               FROM LIN_Evento    
                              WHERE IdEvento = LG.IdEventoBase), Descripcion    
      , LG.EnvioAutomatico, LG.EnvioCorte, LG.Activo    
 FROM LIN_Linea_Grupo LG with (nolock),
 --Agregado por Jose
 LIN_Grupo_Evento GP with (nolock)          
 ---
 WHERE (@IdLinea = 0 OR IdLinea = @IdLinea) 
 --Agregado por Jose
 and LG.IdGrupo = GP.IdGrupo  
 --------
   --AND (@IndEnvioAutomatico = 0 Or LG.EnvioAutomatico =  @IndEnvioAutomatico)  
 ORDER BY Descripcion        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerGrupos_IdLinea_Web]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --LIN_ObtenerGrupos_IdLinea 7    
-- =============================================          
-- Author: David Arias    
-- Create date: 16/12/2010          
-- Description:   
-- Update : Jose Rodriguez
-- Update date : 10/10/2014    
-- =============================================          
ALTER PROCEDURE [dbo].[LIN_ObtenerGrupos_IdLinea_Web]          
(          
 @IdLinea int         
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
 SELECT LG.IdGrupo, LG.IdLinea,LG.IdEventoBase    
      , DescripcionEvento = (SELECT CODIGO + ' - ' + NOMBRE     
                               FROM LIN_Evento    
                              WHERE IdEvento = LG.IdEventoBase), Descripcion    
      , LG.EnvioAutomatico, LG.EnvioCorte, LG.Activo    
 FROM LIN_Linea_Grupo LG with (nolock)  
 WHERE (@IdLinea = 0 OR IdLinea = @IdLinea) 
   --AND (@IndEnvioAutomatico = 0 Or LG.EnvioAutomatico =  @IndEnvioAutomatico)  
 ORDER BY Descripcion        
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerHorasCortes_IDLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  Edgard Moras  
-- Create date: 16/12/2010        
-- Description:     
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_ObtenerHorasCortes_IDLinea]        
(        
 @IdLinea int,  
 @IdGrupo int      
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
 SELECT IdHoraCorte
      , RIGHT('00'+ CAST(HoraCorte as varchar(2)),2) + ':' 
      + RIGHT('00'+ CAST(MinutoCorte as varchar(2)),2) AS HoraCorte   
 FROM LIN_Linea_HoraCorte with (nolock)        
 WHERE IdLinea = @IdLinea
   AND IdGrupo = @IdGrupo        
 ORDER BY HoraCorte, MinutoCorte          
END     
  
-- LIN_ObtenerHorasCortes_IDLinea 5  
--SELECT * FROM LIN_Linea_Corte with (nolock)      dbo.
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerIdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 09/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerIdLinea]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdLinea
	FROM	LIN_Linea
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerIdLineaActivo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 15/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerIdLineaActivo]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdLinea
	FROM	LIN_Linea
	WHERE	Activo = 1
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================      
-- Author:  Enrique Véliz      
-- Create date: 04/11/2010      
-- Description:       
-- Update Date: 24/11/2011  
-- Description: Se agregaron campos de linea  
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ObtenerLinea]      
AS      
BEGIN      
 SET NOCOUNT ON;      
      
 SELECT IdLinea,Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo    
 ,EnvioAutomatico,FlagGlobal,GlobalConfig,EventoBase      
 ,ConfiguracionCorte , Email, AsuntoEmail    
 FROM LIN_Linea      
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLinea_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 20/12/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerLinea_Consultar]  
(  
 @Codigo nvarchar(10),  
 @Nombre nvarchar(100),  
 @Activo bit  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT L.IdLinea AS IdLinea,  
   L.Codigo AS Codigo,  
   L.Nombre AS Nombre,  
   L.PeriodoMinutos AS PeriodoMinutos,  
   L.EnvioTotal AS EnvioTotal,  
   L.Activo AS Activo,  
   L.ConfiguracionCorte AS ConfiguracionCorte, --EWMN
   L.Email as Email,
   L.AsuntoEmail as AsuntoEmail
 FROM LIN_Linea L  
 WHERE (@Codigo IS NULL OR L.Codigo LIKE '%' + @Codigo + '%')  
 AND  (@Nombre IS NULL OR L.Nombre LIKE '%' + @Nombre + '%')  
 AND  (@Activo IS NULL OR L.Activo = @Activo)  
 ORDER BY L.Codigo ASC  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLinea_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
-- =============================================      
-- Author:  Enrique Véliz      
-- Create date: 16/12/2010      
-- Description:   
-- Update Date: 24/11/2011  
-- Description: Se agregaron campos de linea  
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ObtenerLinea_IdLinea]      
(      
 @IdLinea int      
)      
AS      
BEGIN      
 SET NOCOUNT ON;      
       
 SELECT IdLinea,Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo    
 ,EnvioAutomatico,FlagGlobal,GlobalConfig,EventoBase,
 ConfiguracionCorte, Email, AsuntoEmail     
 FROM LIN_Linea with (nolock)      
 WHERE IdLinea = @IdLinea      
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaConfiguracionCorte_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 -- LIN_ObtenerLineaConfiguracionCorte_IdLinea 5
-- =============================================      
-- Author:  Enrique Véliz      
-- Create date: 16/12/2010      
-- Description:   
-- Update Date: 24/11/2011  
-- Description: Se agregaron campos de linea  
-- =============================================      
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaConfiguracionCorte_IdLinea]      
(      
 @IdLinea int      
)      
AS      
BEGIN      
 SET NOCOUNT ON;      
       
 SELECT IdLinea,Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo    
 ,EnvioAutomatico,FlagGlobal,GlobalConfig,EventoBase,
 ConfiguracionCorte, Email, AsuntoEmail     
 FROM LIN_Linea with (nolock)      
 WHERE IdLinea = @IdLinea      
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaEnvioInformacionCorte_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaEnvioInformacionCorte_Consultar]      
AS      
BEGIN      
 SET NOCOUNT ON;            
 SELECT IdLinea,Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo    
 ,EnvioAutomatico,FlagGlobal,GlobalConfig,EventoBase,ConfiguracionCorte, Email, AsuntoEmail
 FROM LIN_Linea
 WHERE EnvioAutomatico = 0
 AND ConfiguracionCorte = 1      
END   
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineas_EnvioAutomatico]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =============================================        
-- Author:  David Arias       
-- Create date: 04/11/2010        
-- Description:         
-- Update Date: 24/11/2011    
-- Description: Se agregaron campos de linea    
-- =============================================        
ALTER PROCEDURE [dbo].[LIN_ObtenerLineas_EnvioAutomatico]        
AS        
BEGIN        
 SET NOCOUNT ON;        
        
 SELECT IdLinea,Codigo,Nombre,PeriodoMinutos,EnvioTotal,Activo      
 ,EnvioAutomatico,FlagGlobal,GlobalConfig,EventoBase        
 ,ConfiguracionCorte , Email, AsuntoEmail      
 FROM LIN_Linea        
 WHERE IdLinea IN (SELECT DISTINCT IdLinea 
                     FROM dbo.LIN_Linea_Grupo 
				    WHERE Activo = 1
				      AND EnvioAutomatico = 0)
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXEvento_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 20/12/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXEvento_Consultar]  
(  
 @IdLinea int  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT @IdLinea AS IdLinea,  
   E.IdEvento AS IdEvento,  
   E.Codigo AS CodigoEvento,  
   E.Nombre AS NombreEvento,  
   LXE.TipoFormato AS TipoFormato,  
   COALESCE(LXE.Activo, CAST(0 AS bit)) AS Activo,
   COALESCE(LXE.EventoInicial, CAST(0 AS bit)) AS EventoInicial
 FROM LIN_Evento E  
 LEFT JOIN LIN_LineaXEvento LXE ON E.IdEvento = LXE.IdEvento AND LXE.IdLinea = @IdLinea  
 ORDER BY E.Codigo ASC   
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXEvento_IdLinea]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXEvento_IdLinea]            
(            
 @IdLinea int            
)            
AS            
BEGIN            
 SET NOCOUNT ON;            
            
 SELECT IdLinea,IdGrupo=0,IdEvento,TipoFormato,DefinicionFormato        
      , DefinicionNombreArchivo,NombreArchivo,TamanhoLote,Email,AsuntoEmail        
      , isnull(RutaCopy,'') RutaCopy    
      , isnull(RutaFTP,'') RutaFTP, isnull(UsuarioFTP,'') UsuarioFTP, isnull(PasswordFTP,'') PasswordFTP    
      , IdCampoAgrupar,Activo, EventoInicial  
     ,  idtipoEvento, idFechaOperativa, CampoBD                         
 FROM LIN_LineaXEvento            
 WHERE IdLinea = @IdLinea            
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXEvento_IdLineaXIdEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                
-- Author:  Enrique Véliz                
-- Create date: 02/11/2010                
-- Description:                 
-- =============================================                
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXEvento_IdLineaXIdEvento]                
(                
 @IdLinea int,                
 @IdEvento int              
)                
AS                
BEGIN                
 SET NOCOUNT ON;                
                
 --SELECT IdLinea,idGrupo = 0, IdEvento,TipoFormato,DefinicionFormato              
 --     , DefinicionNombreArchivo,NombreArchivo,TamanhoLote              
 --     , Email,AsuntoEmail,isnull(RutaCopy,'') RutaCopy            
 --     , isnull(RutaFTP,'') RutaFTP, isnull(UsuarioFTP,'') UsuarioFTP, isnull(PasswordFTP,'') PasswordFTP          
 --     , IdCampoAgrupar,Activo, EventoInicial                
 --FROM LIN_LineaXEvento                
 --WHERE IdLinea = @IdLinea                
 --AND  IdEvento = @IdEvento  
   
  SELECT IdLinea,idGrupo = 0, IdEvento,TipoFormato,DefinicionFormato              
      , DefinicionNombreArchivo,NombreArchivo,TamanhoLote              
      , Email,AsuntoEmail,isnull(RutaCopy,'') RutaCopy            
      , isnull(RutaFTP,'') RutaFTP, isnull(UsuarioFTP,'') UsuarioFTP, isnull(PasswordFTP,'') PasswordFTP          
      , IdCampoAgrupar,Activo, EventoInicial 
      ,  idtipoEvento, idFechaOperativa, CampoBD             
 FROM LIN_LineaXEvento                
 WHERE IdLinea = @IdLinea                
 AND  IdEvento = @IdEvento               
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXEventoXTipoFormato_IdLineaXIdEventoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Enrique Véliz    
-- Create date: 22/06/2011    
-- Description:     
-- =============================================    
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXEventoXTipoFormato_IdLineaXIdEventoXTipoFormato]    
(    
 @IdLinea int,    
 @IdEvento int,    
 @TipoFormato char(3)    
)    
AS    
BEGIN    
 SET NOCOUNT ON;    
     
 SELECT IdLinea,IdGrupo = 0,IdEvento,TipoFormato,DefinicionFormato    
 FROM LIN_LineaXEventoXTipoFormato    
 WHERE IdLinea = @IdLinea    
 AND  IdEvento = @IdEvento    
 AND  TipoFormato = @TipoFormato 
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXGrupo_IdLineaXIdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================              
-- Author:  Enrique Véliz              
-- Create date: 02/11/2010              
-- Description:               
-- =============================================              
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXGrupo_IdLineaXIdGrupo]              
(              
 @IdLinea int,              
 @IdGrupo int            
)              
AS              
BEGIN              
 SET NOCOUNT ON;              
              
 SELECT IdLinea,IdGrupo, IdEvento = (Select IdEventoBase from LIN_Linea_Grupo where idGrupo = LG.idGrupo)  
      , TipoFormato, DefinicionFormato            
      , DefinicionNombreArchivo, NombreArchivo, TamanhoLote            
      , Email, AsuntoEmail, isnull(RutaCopy,'') RutaCopy          
      , isnull(RutaFTP,'') RutaFTP, isnull(UsuarioFTP,'') UsuarioFTP, isnull(PasswordFTP,'') PasswordFTP        
      , IdCampoAgrupar,Activo, EventoInicial 
      , idtipoEvento, idFechaOperativa, CampoBD                            
 FROM LIN_LineaXGrupo  LG            
 WHERE IdLinea = @IdLinea              
 AND  IdGrupo = @IdGrupo            
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerLineaXGrupoXTipoFormato_IdLineaXIdGrupoXTipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  David Arias  
-- Create date: 22/06/2011  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerLineaXGrupoXTipoFormato_IdLineaXIdGrupoXTipoFormato]  
(  
 @IdLinea int,  
 @IdGrupo int,  
 @TipoFormato char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT IdLinea,IdGrupo, IdEvento = (Select IdEventoBase from LIN_Linea_Grupo where idGrupo = LG.idGrupo)
      , TipoFormato,DefinicionFormato  
 FROM LIN_LineaXGrupoXTipoFormato  LG
 WHERE IdLinea = @IdLinea  
 AND  IdGrupo = @IdGrupo  
 AND  TipoFormato = @TipoFormato  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerOperativo_Eventos]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
-- =============================================            
-- Author:  Victor Silva      
-- Create date: 11/08/2011          
-- Description:             
-- =============================================            
  --select * from LIN_REGISTRO  
    
    
ALTER PROCEDURE [dbo].[LIN_ObtenerOperativo_Eventos]                                  
@Fecha Datetime,             
@FechaFin Datetime,                              
@IdLinea int,                              
@IdEvento int,                              
@Contenedor varchar(50),    
@Tipo varchar(10)    
AS           
BEGIN                                  
    
set @FechaFin = dateadd(dd,1, @FechaFin)    
    
SELECT distinct                                  
L.CODIGO as CodLinea,    
L.NOMBRE as Linea,                                  
R.CONTENEDOR,                                  
E.CODIGO as CodEvento,    
E.NOMBRE as Evento,                                  
FECHAEVENTO = (SELECT TOP 1 FECHACREACION FROM LIN_REGISTROLOG WHERE IDREGISTRO = R.IDREGISTRO AND ESTADO  ='ENV' ),  
R.FECHACREACION FechaCarga,R.ESTADO,                            
null TI,                             
cast(CASE WHEN XL.IDEXCEL IS NOT NULL THEN 1                            
ELSE 0 END as bit) LIN,            
XL.FECOPERA,    
rl.Mensaje,    
r.Tipo,    
xl.BILLPA as NumeroReferenciaLinea    
FROM LIN_REGISTRO R          
INNER JOIN LIN_RegistroLog rl on r.IdRegistro = rl.idRegistro and r.Estado = rl.Estado                            
INNER JOIN LIN_EVENTO E ON R.IDEVENTO = E.IDEVENTO                                  
INNER JOIN LIN_LINEA L  ON R.IDLINEA = L.IDLINEA                                  
LEFT JOIN (                  
SELECT DISTINCT 1 AS IDEXCEL ,CONTENEDOR,CODEVE,FECOPERA,ST,REMARK,BILLPA FROM LIN_CARGAEXCEL                  
) XL                             
ON XL.CONTENEDOR = R.CONTENEDOR                            
AND E.CODIGO = XL.CODEVE  AND convert(varchar(10), XL.FECOPERA, 112) = convert(varchar(10), @Fecha, 112)        
WHERE L.IDLINEA = @IdLinea           
AND R.ESTADO in ('ENV','COM','CAR', 'ERR')        
AND E.IdEvento = @IdEvento        
and R.Tipo =  @Tipo    
AND R.FECHACREACION >= @Fecha    
AND R.FECHACREACION <= @FechaFin    
AND(@Contenedor  IS NULL OR R.CONTENEDOR = @Contenedor   )                            
Order by L.CODIGO, R.CONTENEDOR, R.ESTADO                                 
END       
    
    
    
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerOperativo_Eventos_TMP]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
-- =============================================              
-- Author:  Victor Silva        
-- Create date: 11/08/2011            
-- Description:               
-- =============================================              
  --select * from LIN_REGISTRO    
      
      
ALTER PROCEDURE [dbo].[LIN_ObtenerOperativo_Eventos_TMP]                                    
@Fecha Datetime,               
@FechaFin Datetime,                                
@IdLinea int,                                
@IdEvento int,                                
@Contenedor varchar(50),      
@Tipo varchar(10)      
AS             
BEGIN                                    
      
set @FechaFin = dateadd(dd,1, @FechaFin)      
      
SELECT distinct                                    
L.CODIGO as CodLinea,      
L.NOMBRE as Linea,                                    
R.CONTENEDOR,                                    
E.CODIGO as CodEvento,      
E.NOMBRE as Evento,     
R.FECHACREACION FechaCarga,                                 
FECHAEVENTO = (SELECT TOP 1 FECHACREACION FROM LIN_REGISTROLOG WHERE IDREGISTRO = R.IDREGISTRO AND ESTADO  ='ENV' ),    
DIFERENCIA = -1*DATEDIFF(SECOND  
,(SELECT TOP 1 FECHACREACION FROM LIN_REGISTROLOG WHERE IDREGISTRO = R.IDREGISTRO AND ESTADO  ='ENV' )  
,R.FECHACREACION),  
R.ESTADO,                              
null TI,                               
cast(CASE WHEN XL.IDEXCEL IS NOT NULL THEN 1                              
ELSE 0 END as bit) LIN,              
XL.FECOPERA,      
rl.Mensaje,      
r.Tipo,      
xl.BILLPA as NumeroReferenciaLinea      
FROM LIN_REGISTRO R            
INNER JOIN LIN_RegistroLog rl on r.IdRegistro = rl.idRegistro and r.Estado = rl.Estado                              
INNER JOIN LIN_EVENTO E ON R.IDEVENTO = E.IDEVENTO                                    
INNER JOIN LIN_LINEA L  ON R.IDLINEA = L.IDLINEA                                    
LEFT JOIN (                    
SELECT DISTINCT 1 AS IDEXCEL ,CONTENEDOR,CODEVE,FECOPERA,ST,REMARK,BILLPA FROM LIN_CARGAEXCEL                    
) XL                               
ON XL.CONTENEDOR = R.CONTENEDOR                              
AND E.CODIGO = XL.CODEVE  AND convert(varchar(10), XL.FECOPERA, 112) = convert(varchar(10), @Fecha, 112)          
WHERE L.IDLINEA = @IdLinea             
AND R.ESTADO in ('ENV','COM','CAR', 'VAL')          
--AND E.IdEvento = @IdEvento          
and R.Tipo =  @Tipo      
AND R.FECHACREACION >= @Fecha      
AND R.FECHACREACION <= @FechaFin      
--AND(@Contenedor  IS NULL OR R.CONTENEDOR = @Contenedor   )   
and R.CONTENEDOR IN ('HLXU6719170',
'CPSU5131710',
'HLXU6707287',
'HLXU8738097',
'HLXU6760105',
'HLXU6757518',
'HLXU6743659',
'HLXU6743345',
'TRIU8817031',
'CLHU9128083',
'HLXU6499157',
'HLXU6221037',
'HLXU8702685',
'HLXU6728910',
'HLXU8032048',
'TCNU8009606',
'HLXU6377992',
'CPSU5168453',
'CPSU5126226',
'CPSU5116845',
'CRLU1171863',
'CPSU5169207',
'CPSU5168833',
'GESU9192300',
'HLXU6701838',
'HLXU6709037',
'HLXU6711395',
'HLXU4771667',
'GESU9578611',
'HLXU6723586',
'HLXU6723570',
'HLXU6757987',
'HLXU6769735',
'HLXU8732313',
'HLXU8731533',
'HLXU8751606',
'HLXU8727683',
'HLXU8717427',
'TRIU8179003',
'TRIU8325638',
'TRLU1817862',
'CPSU6482788',
'HLXU6746175',
'TCLU8362977',
'TCLU8058630',
'HLXU8138343',
'GESU9181917',
'HLXU4771667',
'CPSU5116589',
'HLXU8745286',
'HLXU6743535',
'HLXU6726760',
'CPSU5110934',
'HLXU6738626',
'GESU9184840',
'GESU9193456',
'GESU9192383',
'HLXU6739875',
'TRLU7017569',
'CPSU6478284',
'CPSU6469338',
'CPSU6425509',
'CPSU6421592',
'CPSU6410453',
'CLHU8844416',
'CLHU8976921',
'GESU5406954',
'GESU5303278',
'GESU5655371',
'HLXU6490078',
'HLXU6406827',
'TRLU7185557',
'TRLU7117212',
'TCNU9964960',
'TCNU9042759',
'TCLU8118718',
'TCLU8076865',
'HLXU8275032',
'AMFU8721305',
'HLXU6756050',
'TRIU8330911',
'GESU9575891',
'TCLU1182090',
'TRIU8854457',
'HLXU8761137',
'GESU9583958',
'TCLU1039664',
'TRIU8812180',
'TCLU1189453',
'TRLU1717930',
'TRLU1831726',
'TRLU1817862',
'HLXU8759090',
'HLXU8751606',
'HLXU8738097',
'HLXU8735478',
'HLXU6769735',
'HLXU6767481',
'HLXU6760105',
'HLXU6743345',
'HLXU6757987',
'HLXU6757518',
'HLXU6736897',
'HLXU6725824',
'HLXU6723570',
'HLXU6719170',
'HLXU6706130',
'GESU9583161',
'CPSU5168833',
'CPSU5126226',
'CPSU5116803',
'TRIU8143783',
'TCLU1205678',
'TCKU1347510',
'TCKU1347510',
'TCLU2826319',
'TCLU2826319',
'HLXU3510400',
'HLXU3510400',
'TCLU1040752',
'TCLU1040752',
'TGHU0546391',
'TGHU0546391',
'CPSU1028155',
'CPSU1028155',
'TCLU1043828',
'TCLU1043828',
'TCLU1029769',
'CPSU5141621',
'GESU9184520',
'GESU9579670',
'HLXU6702557',
'TCLU1180733',
'SEGU9009179',
'SEGU9008228',
'HLXU6729373',
'HLXU6722260',
'HLXU8726516',
'HLXU8727620',
'TCLU1010465',
'SEGU9009728',
'HLXU8738116',
'HLXU8754591',
'HLXU8753168',
'HLXU6750540',
'TCLU1181391',
'TRIU8178368',
'TRIU8146191',
'TCLU1188077',
'TCLU1031030',
'GESU9140820',
'CPSU5113131',
'CPSU5118093',
'HLXU8716879',
'HLXU8738116',
'CPSU5119910',
'HLXU8759525',
'TCLU1040752',
'HLXU8752238',
'CRLU8202375',
'TRLU5534578',
'TRLU5534578',
'HLXU6592104',
'HLXU6405137',
'TRLU7103780',
'TRLU8225130',
'CPSU6432494',
'TRLU5563540',
'HLXU6467503',
'TCNU9875082',
'HLXU6461911',
'HLXU6416830',
'HLXU6383573',
'HLXU6555420',
'TCNU9040083',
'TRLU8146745',
'TCLU8068509',
'HLXU8182080',
'HLXU6463806',
'GESU5582399',
'CAXU9308493',
'HLXU8702129',
'HLXU6713274',
'HLXU6705176',
'HLXU6743284',
'HLXU6770335',
'TRIU8146191',
'HLXU8727620',
'CPSU5118093',
'HLXU8712153',
'HLXU6497370',
'CPSU5116336',
'CPSU6482788',
'HLXU8716204',
'CRLU1171863',
'FSCU9857098',
'TRLU7500896',
'CPSU5113131',
'HLXU6705598',
'TRIU8325638',
'HLXU6756050',
'CPSU5141621',
'HLXU8710504',
'CRLU6218032',
'CPSU5113574',
'HLXU6746175',
'HLXU6732654',
'TRIU8425004',
'HLXU6709037',
'CPSU5116845',
'CPSU5124809',
'HLXU6701838',
'HLXU8759525',
'HLXU8752238',
'CRLU8202375',
'TCLU1040752',
'GESU9535374',
'HLXU8716879',
'HLXU8738116',
'TCLU1029769',
'HLXU6737846',
'CPSU5119910',
'CPSU5119628',
'TCLU1020376',
'HLXU8715065',
'HLXU8715065',
'TCNU8009606',
'TCLU8362977',
'TCLU8058630',
'TRIU8143783',
'GESU9184963',
'GESU9134849',
'TCLU1182757',
'HLXU8751057',
'HLXU6701859',
'CRLU6214145',
'CPSU5147851',
'TRIU8462857',
'CPSU5103642',
'CPSU5147682',
'CPSU5169700',
'GESU9192383',
'GESU9193456',
'HLXU8757184',
'GESU9584872',
'HLXU8760871',
'TRLU1994359',
'CPSU5110111',
'GESU9194154',
'CPSU5121965',
'TCLU1183250',
'HLXU6759779',
'HLXU8711753',
'CPSU5127921',
'TCLU1171726',
'TCLU1205678',
'GESU9584701',
'GESU9149828',
'HLXU6729753',
'TRIU8854457')                             
Order by L.CODIGO, R.CONTENEDOR, R.ESTADO                                   
END         
      
      
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerOperativo_Neptunia]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--ALTER PROCEDURE [dbo].[LIN_ObtenerOperativo_Neptunia] --FMCR
--@Fecha datetime,
--@FechaFin Datetime, 
--@IdLinea int,          
--@IdEvento int,
--@Contenedor varchar(50),
--@Tipo varchar(10)
--AS          
--BEGIN          
        
        
--DECLARE @codigoLinea VARCHAR(3)          
--DECLARE @codigoEvento VARCHAR(5)          

--set @FechaFin = dateadd(dd,1, @FechaFin)
          
--SELECT @codigoLinea = CODIGO FROM LIN_LINEA WHERE IDLINEA = @IdLinea        
--SELECT @codigoEvento =CODIGO FROM LIN_EVENTO WHERE IDEVENTO = @IdEvento

--if @Contenedor = ''
--	set @Contenedor = null

--IF @codigoEvento = '0200'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha, 
--	'' as NumeroReferencia
--	from NEP_Evento_0200
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and Linea = @codigoLinea
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0230'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha, 
--	'' as NumeroReferencia
--	from NEP_Evento_0230
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and Linea = @codigoLinea
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0400' and @codigoLinea = 'HLE'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia
--	from NEP_Evento_0400_HLE
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0400' and @codigoLinea = 'HSD'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0400_HSD
--	where fecha>= @fecha
--	and fecha<=@FechaFin 	
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0500' and @codigoLinea = 'HLE'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0500_HLE
--	where fecha>= @fecha
--	and fecha<=@FechaFin	          
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0500' and @codigoLinea = 'HSD'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0500_HSD
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0600' and @codigoLinea = 'HSD'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0600_HSD
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0601' and @codigoLinea = 'HSD'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0601_HSD
--	where fecha>= @fecha
--	and fecha<=@FechaFin
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0700' and @codigoLinea = 'HSD'
--	select @codigoEvento as Evento, @codigoLinea as Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0700_HSD
--	where fecha>= @fecha
--	and fecha<=@FechaFin	
--	and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0715'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0715
--	where fecha>= @fecha
--	and fecha<=@FechaFin     
--    and Linea = @codigoLinea
--    and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0800'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0800A
--	where fecha>= @fecha
--	and fecha<=@FechaFin    
--    and Linea = @codigoLinea
--    and (@Contenedor is null or Contenedor = @Contenedor)
--    union all
--    select @codigoEvento as Evento, Linea, Contenedor, Fecha,
--    '' as NumeroReferencia 
--    from NEP_Evento_0800B
--	where fecha>= @fecha
--	and fecha<=@FechaFin   
--    and Linea = @codigoLinea
--    and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '0900'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_0900
--	where fecha>= @fecha
--	and fecha<=@FechaFin  
--    and Linea = @codigoLinea    
--    and (@Contenedor is null or Contenedor = @Contenedor)
--ELSE IF @codigoEvento = '1000'          
--	select @codigoEvento as Evento, Linea, Contenedor, Fecha,
--	'' as NumeroReferencia 
--	from NEP_Evento_1000
--	where fecha>= @fecha
--	and fecha<=@FechaFin   
--    and Linea = @codigoLinea        
--    and (@Contenedor is null or Contenedor = @Contenedor)
--Else
--	select '' as Evento, '' as Linea, '' as Contenedor, null as Fecha,	'' as NumeroReferencia     
--END 



--GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerOperativoConsolidado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerOperativoConsolidado]    
@FechaProceso datetime    
as    
Select Linea, Evento,     
Count(*) as Operativo,    
Sum(case when x.NoRegistrado = 'NO' then 1    
 else 0 end) as [No enviados por el SW Operativo al SW de Lineas],    
Sum(case when x.Enviado = 'NO' then 1    
 else 0 end) as [No Enviado por el SW de Lineas]    
From    
(    
 select distinct Linea, Evento, Contenedor, Fecha, --EnviadoLinea,    
 case when not exists (    
  Select * from lin_registro r     
  inner join lin_evento e on r.idevento = e.idevento    
  where r.contenedor = l.contenedor and fechaevento>=@FechaProceso    
  and e.codigo = l.evento    
  ) then 'NO'    
  else 'SI' END as NoRegistrado,    
 case when not exists (    
  Select * from lin_registro r     
  inner join lin_evento e on r.idevento = e.idevento    
  where r.contenedor = l.contenedor     
  and fechaevento>=@FechaProceso    
  and r.estado = 'ENV'    
  and e.codigo = l.evento    
  ) then 'NO'    
  else 'SI' END as Enviado     
 from lin_operativo l    
 where FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))    
)x    
GRoup by x.Linea, x.Evento    
Order by x.Linea, x.Evento
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerOperativoFaltantes]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerOperativoFaltantes]
@FechaProceso datetime
as
Select * From
(
	select distinct Linea, Evento, Contenedor, Fecha, --EnviadoLinea,
	case when not exists (
		Select * from lin_registro r 
		inner join lin_evento e on r.idevento = e.idevento
		where r.contenedor = l.contenedor and fechaevento>=@FechaProceso
		and e.codigo = l.evento
		) then 'NO'
		else 'SI' END as [No enviados por el SW Operativo al SW de Lineas],
	case when not exists (
		Select * from lin_registro r 
		inner join lin_evento e on r.idevento = e.idevento
		where r.contenedor = l.contenedor 
		and fechaevento>=@FechaProceso
		and r.estado = 'ENV'
		and e.codigo = l.evento
		) then 'NO'
		else 'SI' END as [No enviado por el SW de Lineas],
	(	
		Select top 1 Mensaje from lin_registro r 
		inner join lin_evento e on r.idevento = e.idevento
		inner join lin_registrolog rl on rl.idregistro = r.idregistro
		where r.contenedor = l.contenedor 
		and fechaevento>=@FechaProceso
		and r.estado = 'ERR'
		and e.codigo = l.evento
	) as ObservacionError,
	case when not exists (
		Select * from lin_operativolinea ol 
		where ol.contenedor = l.contenedor 
		and ol.fecha>=@FechaProceso
		) then 'NO'
		else 'SI' END as [No enviado a la Linea]		
	from lin_operativo l
	where FLOOR(CAST(fecha as float)) = FLOOR(CAST(@FechaProceso as float))
) x 
where x.[No enviado por el SW de Lineas] = 'NO'
Order by x.Linea, x.Evento

GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_ConsultarEventoEstadoEnvio]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 27/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_ConsultarEventoEstadoEnvio]
(
	@FechaInicio datetime,
	@FechaFin datetime,
	@IdLinea int,
	@IdEvento int,
	@Contenedor nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @FechaInicio = CAST(FLOOR(CAST(@FechaInicio AS float)) AS datetime)
	SET @FechaFin = CAST(FLOOR(CAST(@FechaFin AS float)) AS datetime) + 1
	
	SELECT	R.IdRegistro AS IdRegistro,
			R.Contenedor AS Contenedor,
			E.Codigo AS CodigoEvento,
			E.Nombre AS NombreEvento,
			L.Codigo AS CodigoLinea,
			L.Nombre AS NombreLinea,
			R.Estado AS Estado,
			R.FechaCreacion AS FechaCreacion
	FROM	LIN_Registro R
	INNER JOIN	LIN_Linea L ON R.IdLinea = L.IdLinea
	INNER JOIN	LIN_Evento E ON R.IdEvento = E.IdEvento
	WHERE	(@FechaInicio IS NULL OR R.FechaCreacion >= @FechaInicio)
	AND		(@FechaFin IS NULL OR R.FechaCreacion < @FechaFin)
	AND		(@IdLinea IS NULL OR R.IdLinea = @IdLinea)
	AND		(@IdEvento IS NULL OR R.IdEvento = @IdEvento)
	AND		(@Contenedor IS NULL OR R.Contenedor LIKE '%' + @Contenedor + '%')
	ORDER BY	R.FechaCreacion DESC
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_ConsultarEventoEstadoEnvioDetalle]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 27/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_ConsultarEventoEstadoEnvioDetalle]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	R.IdRegistroLog AS IdRegistroLog,
			R.Estado AS Estado,
			R.FechaCreacion AS FechaCreacion,
			R.Mensaje AS Mensaje
	FROM	LIN_RegistroLog R
	WHERE	R.IdRegistro = @IdRegistro
	ORDER BY	R.FechaCreacion ASC
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_EnvioManualMDT]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =============================================        
-- Author:  Luis Cuadra      
-- Create date: 10/11/2011        
-- Description:         
-- =============================================        
--[LIN_ObtenerRegistro_EnvioManualMDT]      
        
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_EnvioManualMDT]        
(        
 @IdLinea int,
 @IdGrupo int,        
 @Estado char(3)        
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
        
 SELECT IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,        
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente        
 FROM LIN_Registro R WITH (NOLOCK)        
 WHERE IdLinea = @IdLinea   
   AND (( @ESTADO ='VAL' AND R.ESTADO = @ESTADO ) OR ( @ESTADO ='GEN' AND R.ESTADO = 'VAL' AND R.EnvioManual = 1 ))            
   AND R.IdEvento in (SELECT IdEvento 
						     FROM LIN_Grupo_Evento 
						    WHERE IdGrupo = @IDGRUPO)       
END   
  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_Estado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 02/11/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_Estado]  
(  
 @Estado char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SELECT IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,  
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente 
 FROM LIN_Registro  
 WHERE Estado = @Estado  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_IdGrupo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
-- =============================================          
-- Author:  Luis Cuadra        
-- Create date: 10/11/2011          
-- Description:           
-- =============================================          
--[LIN_ObtenerRegistro_EnvioManualMDT]        
          
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_IdGrupo]          
(          
 @IdLinea int,  
 @IdGrupo int,          
 @Estado char(3)          
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
          
 SELECT IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,          
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente          
 FROM LIN_Registro R WITH (NOLOCK)          
 WHERE IdLinea = @IdLinea     
   AND R.ESTADO = @ESTADO         
   AND R.IdEvento in (SELECT IdEvento   
           FROM LIN_Grupo_Evento   
          WHERE IdGrupo = @IDGRUPO)         
END     
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_IdRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 16/12/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_IdRegistro]  
(  
 @IdRegistro int  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,  
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente 
 FROM LIN_Registro WITH (NOLOCK)  
 WHERE IdRegistro = @IdRegistro  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_LineaXEstado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  Enrique Véliz        
-- Create date: 05/11/2010        
-- Description:         
-- =============================================        
--[LIN_ObtenerRegistro_LineaXEstado] 5, 'VAL' 
        
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_LineaXEstado]        
(        
 @IdLinea int,        
 @Estado char(3)       
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
 DECLARE @NUM_REGISTROS INT  
   
 SELECT IdRegistro,R.IdLinea,R.IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,        
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente , IdGrupo = ISNULL(LGE.IdGrupo,0)       
 FROM LIN_Registro R WITH (NOLOCK) 
 LEFT JOIN (SELECT IdLinea, LG.IdGrupo, IdEvento 
              FROM LIN_LINEA_GRUPO LG  
	          JOIN LIN_GRUPO_EVENTO GE ON GE.IdGrupo = LG.IdGrupo
	         WHERE LG.Activo = 1) LGE ON LGE.IdLinea = R.IdLinea AND LGE.IdEvento =R.IdEvento
 WHERE R.IdLinea = @IdLinea        
 AND Estado = @Estado  
 --AND (@ExcluirGrupo = 0 OR 
	-- (@ExcluirGrupo = 1 AND (IdEvento NOT IN (SELECT IdEvento 
	--										FROM LIN_Grupo_Evento
	--									   WHERE IdGrupo IN (SELECT IdGrupo 
	--														   FROM LIN_Linea_Grupo
	--														  WHERE idLinea = @IdLinea
	--															AND Activo = 1 )))))
    
SELECT @NUM_REGISTROS = COUNT('X')       
 FROM LIN_Registro WITH (NOLOCK)        
 WHERE IdLinea = @IdLinea      
 AND  Estado = @Estado     
     
insert into LogConsultas    
values (getdate(), @IdLinea,@Estado,@NUM_REGISTROS)    
    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_LineaXEstado_Prueba]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:  Enrique Véliz          
-- Create date: 05/11/2010          
-- Description:           
-- =============================================          
--[LIN_ObtenerRegistro_LineaXEstado] 5, 'VAL'   
         -- LIN_ObtenerRegistro_LineaXEstadoxxx 2,'dfd'
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_LineaXEstado_Prueba]          
(          
 @idRegistro int         
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
 DECLARE @NUM_REGISTROS INT    
     
 SELECT IdRegistro,R.IdLinea,R.IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,          
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente , IdGrupo = ISNULL(LGE.IdGrupo,0)         
 FROM LIN_Registro R WITH (NOLOCK)   
 LEFT JOIN (SELECT IdLinea, LG.IdGrupo, IdEvento   
              FROM LIN_LINEA_GRUPO LG    
           JOIN LIN_GRUPO_EVENTO GE ON GE.IdGrupo = LG.IdGrupo  
          WHERE LG.Activo = 1) LGE ON LGE.IdLinea = R.IdLinea AND LGE.IdEvento =R.IdEvento  
 WHERE idRegistro = @idRegistro
 
      
       
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_LineaXEventoXEstado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 09/11/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_LineaXEventoXEstado]  
(  
 @IdLinea int,  
 @IdEvento int,  
 @Estado char(3)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SELECT IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,  
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente  
 FROM LIN_Registro WITH (NOLOCK)  
 WHERE IdLinea = @IdLinea  
 AND  IdEvento = @IdEvento  
 AND  Estado = @Estado  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_LineaXEventoXEstado_Top]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 09/11/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_LineaXEventoXEstado_Top]  
(  
 @IdLinea int,  
 @IdEvento int,  
 @Estado char(3),  
 @Top int  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @sql nvarchar(MAX)  
   
 SET @sql = N'  
 SELECT TOP ' + CAST(@Top AS nvarchar(10)) + '  
   IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,  
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente  
 FROM LIN_Registro WITH (NOLOCK)  
 WHERE IdLinea = @IdLinea  
 AND  IdEvento = @IdEvento  
 AND  Estado = @Estado  
 ORDER BY FechaCreacion DESC'  
   
 EXEC sp_executesql @sql,  
  N'@IdLinea int, @IdEvento int, @Estado char(3)',  
  @IdLinea = @IdLinea,  
  @IdEvento = @IdEvento,  
  @Estado = @Estado  
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistro_TipoFormato]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Victor Silva
-- Create date: 08/07/2011
-- Description:	
-- =============================================

ALTER PROCEDURE [dbo].[LIN_ObtenerRegistro_TipoFormato]
(
	@IdLinea int,
	@Estado char(3)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdRegistro,r.IdLinea,r.IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
			IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente, ef.TipoFormato
	FROM	LIN_Registro r WITH (NOLOCK)
	INNER JOIN Lin_LineaxEventoxTipoformato ef on r.IdLinea = ef.IdLinea and r.IdEvento = ef.IdEvento
	WHERE	r.IdLinea = @IdLinea
	AND		r.Estado = @Estado
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroDetalle_IdRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 02/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroDetalle_IdRegistro]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdRegistro,NroItem
	FROM	LIN_RegistroDetalle WITH (NOLOCK)
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroDetalleXCampo_IdRegistroXNroItem]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 02/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroDetalleXCampo_IdRegistroXNroItem]
(
	@IdRegistro int,
	@NroItem int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdRegistro,NroItem,IdCampo,Valor
	FROM	LIN_RegistroDetalleXCampo WITH (NOLOCK)
	WHERE	IdRegistro = @IdRegistro
	AND		NroItem = @NroItem
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroFormato_IdRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 20/01/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroFormato_IdRegistro]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdRegistro,Tipo,Formato,NombreArchivo,NombreArchivoLote
	FROM	LIN_RegistroFormato
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroFormato_NombreArchivoLote]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroFormato_NombreArchivoLote]
as
select distinct nombrearchivolote 
from lin_registro r with (nolock)
inner join lin_evento e with (nolock) on r.IdEvento = e.IdEvento
inner join lin_registroformato rf with (nolock) on r.IdRegistro = rf.IdRegistro
where r.FechaEvento >= '20110720'
and r.FechaEvento < '20110813'
and r.Estado = 'ENV'
and r.IdLinea = 1
and not exists 
(
	Select * From lin_operativolinea ol 
	where ol.Contenedor = r.Contenedor 
	and ol.Evento = e.Codigo
)

GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroNoEnviado]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroNoEnviado]
as
declare @fecha float
set @fecha = floor(CAST(getdate() as float))

select distinct r.IdEvento, Contenedor, Estado, FechaEvento, FechaCreacion, 
EnvioIndependiente, e.Nombre as Evento, l.Nombre as Linea 
from lin_registro r
inner join lin_evento e on r.IdEvento = e.IdEvento 
inner join lin_linea l on r.IdLinea = l.IdLinea
where estado not in ('ENV', 'COM', 'ERR')
--and floor(CAST(fechaCreacion as float)) in (@Fecha, @Fecha - 1)
--and r.idevento in (4,7,8)
and contenedor not in 
(
	select contenedor
	from lin_registro r1
	where floor(CAST(fechaCreacion as float)) in (@Fecha, @Fecha - 1)
	and r1.idevento = r.idevento
	and r1.contenedor = r.contenedor
	and estado in ('ENV')
)
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedor]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Enrique Véliz  
-- Create date: 10/01/2010  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedor]  
(  
 @IdLinea int,  
 @Contenedor nvarchar(20)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT TOP 1  
   IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,  
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente
 FROM LIN_Registro WITH (NOLOCK)  
 WHERE (@IdLinea IS NULL OR IdLinea = @IdLinea)  
 AND  Contenedor = @Contenedor  
 AND  Estado IN ('VAL','ENV')  
 AND  IdRegistro_Siguiente IS NULL  
 AND  EnvioIndependiente = 0  
 ORDER BY FechaCreacion DESC  
END  
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedor_Prueba]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Enrique Véliz    
-- Create date: 10/01/2010    
-- Description:     
-- =============================================    
 ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedor_Prueba]    
(    
 @IdLinea int,    
 @Contenedor nvarchar(20)    
)    
AS    
BEGIN    
 SET NOCOUNT ON;    
     
 SELECT TOP 1    
   IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,    
   IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente  
 FROM LIN_Registro WITH (NOLOCK)    
 WHERE (@IdLinea IS NULL OR IdLinea = @IdLinea)    
 AND  Contenedor = @Contenedor    
 AND  Estado IN ('VAL','ENV')    
 AND  IdRegistro_Siguiente IS NULL    
 AND  EnvioIndependiente = 0 
 
 ORDER BY FechaCreacion DESC    
END 
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedorXEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroUltimo_IdLineaXContenedorXEvento]
(
	@IdLinea int,
	@Contenedor nvarchar(20),
	@IdEvento int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	TOP 1
			IdRegistro,IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
			IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente
	FROM	LIN_Registro WITH (NOLOCK)
	WHERE	(@IdLinea IS NULL OR IdLinea = @IdLinea)
	AND		Contenedor = @Contenedor
	AND		Estado IN ('VAL','ENV')
	AND		IdEvento = @IdEvento
	AND		EnvioIndependiente = 0
	ORDER BY	FechaCreacion DESC
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_ObtenerRegistroXCampo_IdRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 02/11/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[LIN_ObtenerRegistroXCampo_IdRegistro]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	IdRegistro,IdCampo,Valor
	FROM	LIN_RegistroXCampo WITH (NOLOCK)
	WHERE	IdRegistro = @IdRegistro
END
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Config_Actualizar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LIN_Perfil_Config_Actualizar]
@idevento int,
@idlinea int,
@idperfil int,
@config text
as
Update LIN_Perfil_Config set Config=@config where   idevento=@idevento and idlinea=@idlinea and idperfil=@idperfil
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Config_Obtener]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LIN_Perfil_Config_Obtener]
@idevento int,
@idlinea int,
@idperfil int
as
select id,Config from LIN_Perfil_Config where idevento=@idevento and idlinea=@idlinea and idperfil=@idperfil
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Config_Registrar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LIN_Perfil_Config_Registrar]
@config text,
@idevento int,
@idlinea int,
@idperfil int
as
insert into LIN_Perfil_Config (idevento,idlinea,idperfil,Config) values(@idevento,@idlinea,@idperfil,@config)
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Editar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LIN_Perfil_Editar]
@Id int,
@Nombre varchar(50)
as
Update LIN_Perfil set Perfil_Descripcion=@Nombre where ID_Perfil=@Id
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Obtener]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LIN_Perfil_Obtener]
as
select ID_Perfil as ID ,Perfil_Descripcion as Descripcion from LIN_Perfil
order by Perfil_Descripcion  asc
GO
/****** Object:  StoredProcedure [dbo].[LIN_Perfil_Registrar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LIN_Perfil_Registrar]
@Nombre varchar(50)
as
insert into LIN_Perfil (Perfil_Descripcion) values(@Nombre)
GO
/****** Object:  StoredProcedure [dbo].[LIN_RealizarLimpiezaBD]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER PROCEDURE [dbo].[LIN_RealizarLimpiezaBD]    
as    
set nocount on    
declare @fechaProceso datetime    
declare @fechaHoy datetime    
declare @fechaBorrado datetime    
set @fechaProceso = (select min(fechacreacion) from lin_registro with(nolock))    
set @fechaProceso = convert(varchar(10), @fechaProceso, 112)    
set @fechaHoy = convert(varchar(10), getdate(), 112)    
set @fechaBorrado = dateadd(mm, -4, @fechaHoy)    
    
print @fechaProceso    
print @fechaHoy    
print @fechaBorrado     
print '====================='    
    
declare @tabla table(    
 idregistro int    
)    
    
while (@fechaProceso <= @fechaBorrado)    
Begin    
 insert @tabla     
 select idregistro from lin_registro with(nolock)     
 where convert(varchar(10),fechacreacion,112) =  @fechaProceso    
     
 delete from LIN_RegistroDetalleXCampo where idregistro in (select idregistro from @tabla)    
 delete from LIN_RegistroDetalle where idregistro in (select idregistro from @tabla)    
 delete from LIN_RegistroFormato where idregistro in (select idregistro from @tabla)    
 delete from LIN_RegistroXCampo where idregistro in (select idregistro from @tabla)    
 delete from LIN_RegistroLog where idregistro in (select idregistro from @tabla)    
 delete from LIN_Registro where idregistro in (select idregistro from @tabla)    
  
 delete from @tabla    
 print @fechaProceso     
 set @fechaProceso = dateadd(dd, 1, @fechaProceso)    
End    
---------------------------------------  
--DELETE LIN_AUDITORIA_HLE WHERE FECREACION<=DATEADD(MONTH,-6,GETDATE())  
---------------------------------------  
DBCC SHRINKDATABASE (EnvioLineas)

GO
/****** Object:  StoredProcedure [dbo].[Log_LineaPIL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Log_LineaPIL]  
@contenedor nvarchar(11),  
@navvia nvarchar(11)  
as   
begin  
insert into TB_LOGINSERTPIL (contenedor,navvia,dia)  
values(@contenedor ,@navvia ,getdate())  
end
GO
/****** Object:  StoredProcedure [dbo].[MSC_ActualizarRegistroMSC]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JOHAN CAHUACACHI
-- Create date: 31/12/2012
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[MSC_ActualizarRegistroMSC]
(
	@IdActualizacion int,
	@FechaActualizacion datetime,
	@TipoActualizacion char(1)
)
AS
BEGIN
 	set nocount on  
  
 
  
	UPDATE MSC_Actualizacion
	   SET FechaActualizacionMSC  = @FechaActualizacion
	     , TipoActualizacion = @TipoActualizacion
	 WHERE IdActualizacion = @IdActualizacion   
	   
	
 
END
GO
/****** Object:  StoredProcedure [dbo].[MSC_InsertarActualizacionLogErrror]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [dbo].[MSC_InsertarActualizacionLogErrror]  
(  
           @Booking varchar(20),   
           @Contenedor varchar(11) ,  
           @DescError varchar(1000) ,
           @Fecha datetime 
)  
AS  
BEGIN  
     
 INSERT INTO  [MSC_ActualizacionLogErrror]
           ([Booking]
           ,[Contenedor]
           ,[DescError]
           ,Fecha)
     VALUES
           (@Booking  
           ,@Contenedor 
           ,@DescError
           ,@Fecha)
   
 END  
GO
/****** Object:  StoredProcedure [dbo].[MSC_InsertarRegistroMSC]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  JOHAN CAHUACACHI  
-- Create date: 31/12/2012  
-- Description:   
-- =============================================  
ALTER PROCEDURE [dbo].[MSC_InsertarRegistroMSC]  
(  
      @Nave varchar(6),   
           @Viaje varchar(10) ,  
           @Booking varchar(20),   
           @Contenedor varchar(11) ,  
           @EstadoContenedor char(1),   
           @TipoActualizacion char(1),   
           @FechaCorte datetime ,  
           @FechaInicioCargaOperativo datetime , 
           @FechaTerminoCargaOperativo datetime ,  
           @FechaActualizacionMSC datetime   
)  
AS  
BEGIN  
  set nocount on    
    
 INSERT INTO  [MSC_Actualizacion]  
           ([Nave]  
           ,[Viaje]  
           ,[Booking]  
           ,[Contenedor]  
           ,[EstadoContenedor]  
           ,[TipoActualizacion]  
           ,[FechaCorte]  
           , FechaInicioCargaOperativo
           , FechaTerminoCargaOperativo  
           ,[FechaActualizacionMSC])  
     VALUES  
           ( @Nave  ,   
           @Viaje   ,  
           @Booking  ,   
           @Contenedor  ,  
           @EstadoContenedor ,   
           @TipoActualizacion ,   
           @FechaCorte   ,
           @FechaInicioCargaOperativo ,  
           @FechaTerminoCargaOperativo   ,  
           @FechaActualizacionMSC   )  
   
 SELECT SCOPE_IDENTITY()  
END  
GO
/****** Object:  StoredProcedure [dbo].[NEP_ActualizarRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_ActualizarRegistro]
@IdRegistro int
,@navvia char(6)
,@genbkg char(6)
,@Local varchar(30)
,@TipoDoc varchar(10)
,@NroDoc varchar(20)
as

UPDATE LIN_Registro
SET Navvia=isnull(@navvia,null),Genbkg=isnull(@genbkg,null),Local=isnull(@Local,null),TipoDocumento=isnull(@TipoDoc,null),NumeroDocumento=isnull(@NroDoc,null)
WHERE IdRegistro=@IdRegistro


GO
/****** Object:  StoredProcedure [dbo].[NEP_ActualizarRegistro_Completo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_ActualizarRegistro_Completo]
@IdRegistro int
,@navvia char(6)
,@genbkg char(6)
,@Local varchar(30)
,@TipoDoc varchar(10)
,@NroDoc varchar(20)
,@Bookingbl varchar(30)
,@Sistema varchar(30)
,@Procedimiento varchar(100)
as

UPDATE LIN_Registro
SET Navvia=isnull(@navvia,null),Genbkg=isnull(@genbkg,null),Local=isnull(@Local,null),TipoDocumento=isnull(@TipoDoc,null),NumeroDocumento=isnull(@NroDoc,null)
,BookingBL=isnull(@Bookingbl,null),Sistema=isnull(@Sistema,null),StoreProcedure=isnull(@Procedimiento,null)
WHERE IdRegistro=@IdRegistro
GO
/****** Object:  StoredProcedure [dbo].[NEP_AgregarRegistroDetalleXCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_AgregarRegistroDetalleXCampo]
(
	@IdRegistro int,
	@NroItem int,
	@CodigoCampo nvarchar(15),
	@Valor nvarchar(500)
)
AS
BEGIN
	SET NOCOUNT ON;

	IF	@IdRegistro IS NULL
	BEGIN
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Registro WITH (NOLOCK)
	WHERE	IdRegistro = @IdRegistro
	AND		Estado = 'CAR'

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el registro con ID %d o ya ha sido procesado',11,1,@IdRegistro)
		RETURN
	END

	DECLARE	@IdCampo int
	DECLARE	@TipoDato char(3)

	SELECT	@IdCampo = IdCampo,
			@TipoDato = TipoDato
	FROM	LIN_Campo WITH (NOLOCK)
	WHERE	Codigo = @CodigoCampo
	AND		IdEvento = @IdEvento

	IF	@IdCampo IS NULL
	BEGIN
		RAISERROR('No se encontró el campo con código ''%s''',11,1,@CodigoCampo)
		RETURN
	END

	BEGIN TRY
		EXEC NEP_ValidarCampo @Valor,@TipoDato,@Valor OUTPUT
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState)
		RETURN
	END CATCH

	INSERT INTO	LIN_RegistroDetalleXCampo
	(IdRegistro,NroItem,IdCampo,Valor)
	VALUES
	(@IdRegistro,@NroItem,@IdCampo,@Valor)
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_AgregarRegistroXCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_AgregarRegistroXCampo]
(
	@IdRegistro int,
	@CodigoCampo nvarchar(15),
	@Valor nvarchar(500)
)
AS
BEGIN
	SET NOCOUNT ON;

	IF	@IdRegistro IS NULL
	BEGIN
		RETURN
	END

	DECLARE	@IdEvento int, @IdLinea int

	SELECT	@IdEvento = IdEvento,
	@IdLinea = IdLinea
	FROM	LIN_Registro WITH (NOLOCK)
	WHERE	IdRegistro = @IdRegistro
	AND		Estado = 'CAR'

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el registro con ID %d o ya ha sido procesado',11,1,@IdRegistro)
		RETURN
	END

	DECLARE	@IdCampo int
	DECLARE	@TipoDato char(3)

	SELECT	@IdCampo = IdCampo,
			@TipoDato = TipoDato
	FROM	LIN_Campo WITH (NOLOCK)
	WHERE	Codigo = @CodigoCampo
	AND		IdEvento = @IdEvento

	IF	@IdCampo IS NULL
	BEGIN
		RAISERROR('No se encontró el campo con código ''%s''',11,1,@CodigoCampo)
		RETURN
	END

	BEGIN TRY
	
		if @IdLinea = 5
			EXEC NEP_ValidarCampo_PIL @Valor,@TipoDato,@Valor OUTPUT
		else				
			EXEC NEP_ValidarCampo @Valor,@TipoDato,@Valor OUTPUT
			
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState)
		RETURN
	END CATCH

	INSERT INTO	LIN_RegistroXCampo
	(IdRegistro,IdCampo,Valor)
	VALUES
	(@IdRegistro,@IdCampo,@Valor)
END

GO
/****** Object:  StoredProcedure [dbo].[NEP_CompletarRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_CompletarRegistro]
(
	@IdRegistro int
)
AS
BEGIN
	SET NOCOUNT ON;

	IF	@IdRegistro IS NULL
	BEGIN
		RETURN
	END

	UPDATE	LIN_Registro
	SET		Estado = 'COM'
	WHERE	IdRegistro = @IdRegistro
	AND		Estado = 'CAR'
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'COM',''
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_ConsultaContenedorNepXls]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_ConsultaContenedorNepXls]              
@FECINI Datetime,          
@FECFIN Datetime,          
@IdLinea int,          
@IdEvento int,          
@Contenedor varchar(11)          
AS              
BEGIN              
SELECT               
L.CODIGO as CodLinea,L.NOMBRE as Linea,              
R.CONTENEDOR,              
E.CODIGO as CodEvento,E.NOMBRE as Evento,              
R.FECHAEVENTO,R.ESTADO,        
null TI,         
cast(CASE WHEN XL.IDEXCEL IS NOT NULL THEN 1        
ELSE 0 END as bit) LIN              
FROM LIN_REGISTRO R              
INNER JOIN LIN_EVENTO E         
ON R.IDEVENTO = E.IDEVENTO              
INNER JOIN LIN_LINEA L         
ON R.IDLINEA = L.IDLINEA              
LEFT JOIN LIN_CARGAEXCEL XL         
ON XL.CONTENEDOR = R.CONTENEDOR        
AND E.CODIGO = XL.CODEVE   AND XL.FECOPERA BETWEEN @FECINI  AND @FECFIN     
WHERE 1=1      
AND L.IDLINEA = @IdLinea     
--AND R.CONTENEDOR = @Contenedor    
AND R.ESTADO = 'ENV'        
AND E.IdEvento = @IdEvento     
AND R.FechaEvento BETWEEN @FECINI  AND @FECFIN     
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_CONSULTALINEASNEPTUNIA]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[NEP_CONSULTALINEASNEPTUNIA]    
--@FECINI DATETIME,    
--@FECFIN DATETIME,    
--@LINEA int,    
--@EVENTO int  
--AS    
--BEGIN    
--  
--  
--DECLARE @VLINEA VARCHAR(3)    
--DECLARE @VEVENTO VARCHAR(5)    
--    
--DECLARE @VFECINI VARCHAR(8)    
--DECLARE @VFECFIN VARCHAR(8)    
--    
--SELECT @VFECINI  = CONVERT(VARCHAR,@FECINI,112)    
--SELECT @VFECFIN  = CONVERT(VARCHAR,@FECFIN,112)    
--  
--SELECT @VLINEA=CODIGO FROM LIN_LINEA WHERE IDLINEA = @LINEA  
--SELECT @VEVENTO=CODIGO FROM LIN_EVENTO WHERE IDEVENTO = @EVENTO   
--  
--    
--IF @VEVENTO = '0200'    
--select null,null,null,null,null ,null     
----exec sp_ObtenerContenedoresImport_GIFU  @VFECINI,@VFECFIN,@VLINEA    --0200    
--ELSE IF @VEVENTO = '0230'    
--select null,null,null,null,null ,null     
----exec SP_ObtenerContenedores_GOFU @VFECINI,@VFECFIN,@VLINEA           --0230     
--ELSE IF @VEVENTO = '0400'    
--exec OCEANICA1.descarga.dbo.sp_ObtenerContenedoresVacios_GIMT_O @VFECINI,@VFECFIN,@VLINEA        --0400    
--ELSE IF @VEVENTO = '0500'    
--exec OCEANICA1.descarga.dbo.sp_ObtenerContenedoresVacios_GIMT_D  @VFECINI,@VFECFIN,@VLINEA       --0500     
--ELSE IF @VEVENTO = '0715' AND @VLINEA = 'HLE'    
--exec OCEANICA1.descarga.dbo.usp_ObtenerContenedorVacios_GOMT_C  @VFECINI,@VFECFIN,@VLINEA,'O'  --    HLE --0715       
--ELSE IF @VEVENTO = '0800' AND @VLINEA = 'HSD'    
--exec OCEANICA1.descarga.dbo.usp_ObtenerContenedorVacios_GOMT_C  @VFECINI,@VFECFIN,@VLINEA,'M'  --    HSD --0800     
--ELSE IF @VEVENTO = '0715' AND @VLINEA = 'HSD'    
--exec OCEANICA1.descarga.dbo.usp_ObtenerContenedorVacios_GOMT_C  @VFECINI,@VFECFIN,@VLINEA,'E'  --    HSD --0715    
--ELSE IF @VEVENTO = '0900'    
--exec [SP3TDA-DBSQL01].descarga.dbo.usp_ObtenerContenedorExport_GIFU @VFECINI,@VFECFIN,@VLINEA       --0900      
--ELSE IF @VEVENTO = '1000'    
--exec [SP3TDA-DBSQL01].descarga.dbo.usp_ObtenerContenedorExport_GOFU  @VFECINI,@VFECFIN,@VLINEA       --1000    
--ELSE
--select null,null,null,null,null ,null     
--    
--END
--GO
/****** Object:  StoredProcedure [dbo].[NEP_ConsultarEventos]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 02/02/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_ConsultarEventos]
(
	@FechaInicio datetime,
	@FechaFin datetime,
	@CodigoEvento nvarchar(10),
	@CodigoLinea nvarchar(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET	@FechaInicio = CAST(FLOOR(CAST(@FechaInicio AS float)) AS datetime)
	SET	@FechaFin = CAST(FLOOR(CAST(@FechaFin AS float)) AS datetime) + 1
	
	SELECT	R.Contenedor,
			R.FechaEvento
	FROM	LIN_Registro R
	INNER JOIN	LIN_Linea L ON R.IdLinea = L.IdLinea
	INNER JOIN	LIN_Evento E ON R.IdEvento = E.IdEvento
	WHERE	R.FechaEvento >= @FechaInicio
	AND		R.FechaEvento < @FechaFin
	AND		R.Estado = 'ENV'
	AND		L.Codigo = @CodigoLinea
	AND		E.Codigo = @CodigoEvento
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_CrearRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_CrearRegistro]
(
	@CodigoLinea nvarchar(10),
	@CodigoEvento nvarchar(10),
	@Contenedor nvarchar(20),
	@FechaEvento smalldatetime,
	@IdRegistro int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@IdLinea int

	SELECT	@IdLinea = IdLinea
	FROM	LIN_Linea WITH (NOLOCK)
	WHERE	Codigo = @CodigoLinea

	IF	@IdLinea IS NULL
	BEGIN
		SET	@IdRegistro = NULL
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Evento WITH (NOLOCK)
	WHERE	Codigo = @CodigoEvento

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)
		RETURN
	END

	SET	@Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))

	IF	@Contenedor IS NULL OR LEN(@Contenedor) = 0
	BEGIN
		RAISERROR('El código del contenedor no puede estar en blanco',11,1)
		RETURN
	END

	IF	@FechaEvento IS NULL
	BEGIN
		RAISERROR('La fecha del evento no puede estar en blanco',11,1)
		RETURN
	END

	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,@FechaEvento,'CAR',GETDATE(),
	NULL,NULL,'NUE',0)

	SET	@IdRegistro = SCOPE_IDENTITY()
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''
END


GO
/****** Object:  StoredProcedure [dbo].[NEP_CrearRegistroDetalle]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_CrearRegistroDetalle]
(
	@IdRegistro int,
	@NroItem int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	IF	@IdRegistro IS NULL
	BEGIN
		RETURN
	END

	SELECT	@NroItem = COALESCE(MAX(NroItem),0) + 1
	FROM	LIN_RegistroDetalle
	WHERE	IdRegistro = @IdRegistro

	INSERT INTO	LIN_RegistroDetalle
	(IdRegistro,NroItem)
	VALUES
	(@IdRegistro,@NroItem)
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_CrearRegistroEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext NEP_CrearRegistroEvento
ALTER PROCEDURE [dbo].[NEP_CrearRegistroEvento]    
(    
 @CodigoLinea nvarchar(10),   
 @CodigoEvento nvarchar(10),    
 @Contenedor nvarchar(20),    
 @FechaEvento smalldatetime,    
 @IdRegistro int OUTPUT,  
 @Sistema varchar(50),  
 @Navvia varchar(10),  
 @Local varchar(10),  
 @TipoDocumento varchar(10),  
 @NumeroDocumento varchar(15),  
 @BookingBL varchar(15),  
 @Genbkg varchar(15),  
 @StoreProcedure varchar(100)   
 )    
AS      
BEGIN      
 SET NOCOUNT ON;      
      
 DECLARE @IdLinea int      
      
 SELECT @IdLinea = IdLinea      
 FROM LIN_Linea WITH (NOLOCK)      
 WHERE Codigo = @CodigoLinea      
  
  
 IF @IdLinea IS NULL      
 BEGIN      
  SET @IdRegistro = NULL      
        
  RETURN      
 END      
     
 DECLARE @IdEvento int      
      
 SELECT @IdEvento = IdEvento      
 FROM LIN_Evento WITH (NOLOCK)      
 WHERE Codigo = CONVERT(INT, @CodigoEvento)        
      
 IF @IdEvento IS NULL      
 BEGIN      
  RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)      
        
  RETURN      
 END      
      
 SET @Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))      
      
 IF @Contenedor IS NULL OR LEN(@Contenedor) = 0      
 BEGIN      
  RAISERROR('El código del contenedor no puede estar en blanco',11,1)      
        
  RETURN      
 END      
      
 IF @FechaEvento IS NULL      
 BEGIN      
  RAISERROR('La fecha del evento no puede estar en blanco',11,1)      
        
  RETURN      
 END      
   
 INSERT INTO LIN_Registro    
 (IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,    
 IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente,Sistema,Navvia,  
 Local,TipoDocumento,NumeroDocumento,BookingBL,Genbkg,StoreProcedure)  
 VALUES    
 (@IdLinea,@IdEvento,@Contenedor,@FechaEvento,'CAR',GETDATE(),    
 NULL,NULL,'NUE',0 ,@Sistema , @Navvia ,  
 @Local , @TipoDocumento,@NumeroDocumento,@BookingBL,@Genbkg ,@StoreProcedure)  
 SET @IdRegistro = SCOPE_IDENTITY()    
 EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''    
END 
GO
/****** Object:  StoredProcedure [dbo].[NEP_CrearRegistroIndependiente]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Véliz
-- Create date: 01/07/2011
-- Description:	
-- =============================================

ALTER PROCEDURE [dbo].[NEP_CrearRegistroIndependiente]
(
	@CodigoLinea nvarchar(10),
	@CodigoEvento nvarchar(10),
	@Contenedor nvarchar(20),
	@FechaEvento datetime,
	@IdRegistro int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@IdLinea int

	SELECT	@IdLinea = IdLinea
	FROM	LIN_Linea WITH (NOLOCK)
	WHERE	Codigo = @CodigoLinea

	IF	@IdLinea IS NULL
	BEGIN
		SET	@IdRegistro = NULL
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Evento WITH (NOLOCK)
	WHERE	Codigo = @CodigoEvento

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)
		RETURN
	END

	SET	@Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))

	IF	@Contenedor IS NULL OR LEN(@Contenedor) = 0
	BEGIN
		RAISERROR('El código del contenedor no puede estar en blanco',11,1)
		RETURN
	END

	IF	@FechaEvento IS NULL
	BEGIN
		RAISERROR('La fecha del evento no puede estar en blanco',11,1)
		RETURN
	END

	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,@FechaEvento,'CAR',GETDATE(),
	NULL,NULL,'NUE',1)

	SET	@IdRegistro = SCOPE_IDENTITY()
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_EliminarRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 11/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_EliminarRegistro] 
(
	@CodigoLinea nvarchar(10),
	@CodigoEvento nvarchar(10),
	@Contenedor nvarchar(20),
	@IdRegistro int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE	@IdLinea int

	SELECT	@IdLinea = IdLinea
	FROM	LIN_Linea WITH (NOLOCK)
	WHERE	Codigo = @CodigoLinea

	IF	@IdLinea IS NULL
	BEGIN
		SET	@IdRegistro = NULL
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Evento WITH (NOLOCK)
	WHERE	Codigo = @CodigoEvento

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)
		RETURN
	END

	SET	@Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))

	IF	@Contenedor IS NULL OR LEN(@Contenedor) = 0
	BEGIN
		RAISERROR('El código del contenedor no puede estar en blanco',11,1)
		RETURN
	END
	
	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,NULL,'CAR',GETDATE(),
	NULL,NULL,'ELI',0)
	
	SET	@IdRegistro = SCOPE_IDENTITY()
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_INSERTAEXCEL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_INSERTAEXCEL]  
(  
@CONTENEDOR VARCHAR(11),  
@ST VARCHAR(2),  
@CODEVE VARCHAR(6),  
@REMARK VARCHAR(200),  
@BILLPA VARCHAR(20),  
@FECOPERA DATETIME,  
@NOMEXCEL VARCHAR(100),  
@USUARIO VARCHAR(10)  
)AS  
BEGIN  
  
INSERT INTO LIN_CARGAEXCEL (  
CONTENEDOR,ST,CODEVE,REMARK,BILLPA,FECOPERA,FECREGISTRO,NOMEXCEL,USUARIO  
)  
VALUES (  
@CONTENEDOR,@ST,@CODEVE,@REMARK,@BILLPA,@FECOPERA,GETDATE(),@NOMEXCEL,@USUARIO  
)  
  
SELECT SCOPE_IDENTITY()  
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_ModificarRegistro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 11/01/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_ModificarRegistro] 
(
	@CodigoLinea nvarchar(10),
	@CodigoEvento nvarchar(10),
	@Contenedor nvarchar(20),
	@IdRegistro int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE	@IdLinea int

	SELECT	@IdLinea = IdLinea
	FROM	LIN_Linea WITH (NOLOCK)
	WHERE	Codigo = @CodigoLinea

	IF	@IdLinea IS NULL
	BEGIN
		SET	@IdRegistro = NULL
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Evento WITH (NOLOCK)
	WHERE	Codigo = @CodigoEvento

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)
		RETURN
	END

	SET	@Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))

	IF	@Contenedor IS NULL OR LEN(@Contenedor) = 0
	BEGIN
		RAISERROR('El código del contenedor no puede estar en blanco',11,1)
		RETURN
	END
	
	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,NULL,'CAR',GETDATE(),
	NULL,NULL,'MOD',0)
	
	SET	@IdRegistro = SCOPE_IDENTITY()
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_ModificarRegistroIndependiente]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Victor Silva
-- Create date: 01/08/2011
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_ModificarRegistroIndependiente] 
(
	@CodigoLinea nvarchar(10),
	@CodigoEvento nvarchar(10),
	@Contenedor nvarchar(20),
	@IdRegistro int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE	@IdLinea int
	DECLARE	@fechaevento datetime

	SELECT	@IdLinea = IdLinea
	FROM	LIN_Linea WITH (NOLOCK)
	WHERE	Codigo = @CodigoLinea

	IF	@IdLinea IS NULL
	BEGIN
		SET	@IdRegistro = NULL
		RETURN
	END

	DECLARE	@IdEvento int

	SELECT	@IdEvento = IdEvento
	FROM	LIN_Evento WITH (NOLOCK)
	WHERE	Codigo = @CodigoEvento

	IF	@IdEvento IS NULL
	BEGIN
		RAISERROR('No se encontró el evento con código ''%s''',11,1,@CodigoEvento)
		RETURN
	END

	SET	@Contenedor = UPPER(LTRIM(RTRIM(@Contenedor)))

	IF	@Contenedor IS NULL OR LEN(@Contenedor) = 0
	BEGIN
		RAISERROR('El código del contenedor no puede estar en blanco',11,1)
		RETURN
	END
	
	select top 1 @fechaevento = fechaEvento from lin_registro 
	where contenedor =@Contenedor
	and estado = 'ENV'
	and idevento = @IdEvento
	order by fechacreacion desc
	
	if @fechaevento is null 
	begin
		RAISERROR('No se obtuvo la fecha del evento original',11,1)
		RETURN
	end 
	
	
	INSERT INTO	LIN_Registro
	(IdLinea,IdEvento,Contenedor,FechaEvento,Estado,FechaCreacion,
	IdRegistro_Anterior,IdRegistro_Siguiente,Tipo,EnvioIndependiente)
	VALUES
	(@IdLinea,@IdEvento,@Contenedor,@fechaevento,'CAR',GETDATE(),
	NULL,NULL,'MOD',1)
	
	SET	@IdRegistro = SCOPE_IDENTITY()
	
	EXEC LIN_InsertarRegistroLog @IdRegistro,'CAR',''
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_Obtener_Datos_Modificacion_Masiva]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NEP_Obtener_Datos_Modificacion_Masiva]
 @idregistro int
 as
 select lr.Local as LOCAL
 ,ll.codigo as LINEA
 ,le.codigo + ':'+le.nombre as EVENTO
 ,lr.contenedor as CONTENEDOR
 ,lr.Estado as ESTADO
 ,lr.fechacreacion as FECHA_REGISTRO
 ,lr.IdRegistro as ID
 ,lr.IdEvento as idevento
  from lin_registro lr,lin_Evento le,lin_Linea ll where idregistro=@idregistro and lr.idlinea=ll.idlinea and lr.idevento=le.idevento
GO
/****** Object:  StoredProcedure [dbo].[NEP_ValidarCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_ValidarCampo] 
(
	@Valor nvarchar(500),
	@TipoDato char(3),
	@Result nvarchar(500) OUTPUT
)
AS
BEGIN
	IF	@TipoDato = 'INT'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@entero bigint
			SET	@entero = CAST(@Valor AS bigint)
			SET	@Valor = @entero
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a entero',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'DEC'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@decimal decimal(15,5)
			SET	@decimal = CAST(@Valor AS decimal(15,5))
			SET	@Valor = @decimal
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a decimal',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'DAT'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@fecha datetime
			SET	@fecha = CONVERT(datetime,@Valor,121)
			SET	@Valor = CONVERT(nvarchar(500),@fecha,121)
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a fecha/hora',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'STR'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL
		BEGIN
			SET	@Valor = ''
		END
	END

	SET @Result = @Valor
END
GO
/****** Object:  StoredProcedure [dbo].[NEP_ValidarCampo_PIL]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Véliz
-- Create date: 29/10/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[NEP_ValidarCampo_PIL] 
(
	@Valor nvarchar(500),
	@TipoDato char(3),
	@Result nvarchar(500) OUTPUT
)
AS
BEGIN
	IF	@TipoDato = 'INT'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@entero bigint
			SET	@entero = CAST(@Valor AS bigint)
			SET	@Valor = @entero
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a entero',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'DEC'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@decimal decimal(15,5)
			SET	@decimal = CAST(@Valor AS decimal(15,5))
			SET	@Valor = @decimal
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a decimal',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'DAT'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL OR LEN(@Valor) = 0
		BEGIN
			RAISERROR('El parámetro @Valor no debe estar en blanco',11,1)
			RETURN
		END

		BEGIN TRY
			DECLARE	@fecha datetime
			SET	@fecha = CONVERT(datetime,@Valor,121)
			SET	@Valor = CONVERT(nvarchar(500),@fecha,121)
		END TRY
		BEGIN CATCH
			RAISERROR('La cadena ''%s'' no se pudo convertir a fecha/hora',11,1,@Valor)
			RETURN
		END CATCH
	END
	ELSE IF @TipoDato = 'STR'
	BEGIN
		SET	@Valor = LTRIM(RTRIM(@Valor))

		IF	@Valor IS NULL or @Valor = ''
		BEGIN
			SET	@Valor = ' '
		END
	END

	SET @Result = @Valor
END

GO
/****** Object:  StoredProcedure [dbo].[PAR_Guardar_Tarifa]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PAR_Guardar_Tarifa]
@Servicio varchar(100),
@Componente Varchar(100),
@Reparacion varchar(100),
@Lugar varchar(100),
@Tamano varchar(100),
@Costo varchar(50),
@Hora varchar(50)
as
declare @existe int
set @existe = 0
select @existe = COUNT(*) from PAR_TABLA_TARIFA 
where Tipo_Contenedor = @Servicio and Component_Code = @Componente
and Repair_Code = @Reparacion and Damage_Location = @Lugar
and Size = @Tamano ;
print @existe

if @existe = 1 
begin
if @Costo =''
set @Costo=null
if @Hora =''
set @Hora=null
update PAR_TABLA_TARIFA set Formular_Costo = @Costo , Formular_Hora = @Hora
where Tipo_Contenedor = @Servicio and Component_Code = @Componente
and Repair_Code = @Reparacion and Damage_Location = @Lugar
and Size = @Tamano ;
end
else
begin
insert into PAR_TABLA_TARIFA values (@Servicio,@Componente,@Reparacion,@Lugar,
@Tamano,@Costo,@Hora);
end 




GO
/****** Object:  StoredProcedure [dbo].[PAR_Insertar_Elementos]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[PAR_Insertar_Elementos]
@codigo nvarchar(10),
@Descripcion nvarchar(100)
as
insert into [PAR_TABLA_ELEMENTOS] values (@Codigo,@Descripcion)

GO
/****** Object:  StoredProcedure [dbo].[PAR_Obtener_Elementos]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[PAR_Obtener_Elementos]
@id_elemento nvarchar(10)
as
select * from [PAR_TABLA_ELEMENTOS] where Ident_Campo = @id_elemento

GO
/****** Object:  StoredProcedure [dbo].[PAR_Obtener_Parametro]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[PAR_Obtener_Parametro]
 @idDefinicion int
 as
select 
PE.Ident_Campo,PE.Desc_Campo,PE.Ident_Tabla from PAR_TABLA_DEFINICION  PD 
INNER JOIN  PAR_TABLA_ELEMENTOS PE ON PE.Ident_Tabla=PD.Ident_Tabla
WHERE PD.Ident_Tabla=@idDefinicion
GO
/****** Object:  StoredProcedure [dbo].[PAR_Obtener_PDT]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PAR_Obtener_PDT](      
@Tipo_Contenedor VARCHAR(50),      
@Componente VARCHAR(50),      
@Reparar VARCHAR(50),      
@lugar VARCHAR(50),
@tamano varchar(50)     
)      
AS      
SELECT Tipo_Contenedor,Component_Code Componente,Repair_Code Reparacion,Damage_Location lugar,Size tamano,Formular_Costo,Formular_Hora,DBO.MFTK_Funcion_Formulador(Damage_Location,'*') + DBO.MFTK_Funcion_Formulador(Size,'*') PATRON FROM PAR_TABLA_TARIFA     
WHERE @Tipo_Contenedor LIKE REPLACE(Tipo_Contenedor,'*','_') AND       
  @Componente LIKE REPLACE(Component_Code,'*','_') AND       
  @Reparar LIKE REPLACE(Repair_Code,'*','_') AND       
  @lugar LIKE REPLACE(Damage_Location,'*','_')  and
  @tamano like replace(Size,'*','_')
ORDER BY PATRON  
GO
/****** Object:  StoredProcedure [dbo].[PAR_OBTENER_TARIFA]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_OBTENER_TARIFA]
@servicio varchar(100),
@componente varchar(100),
@reparacion varchar (100),
@lugar varchar(100),
@tamano varchar(100)
as
truncate TABLE PAR_Entidad

insert PAR_Entidad(tipo_contenedor,componente,reparacion,lugar,tamano)
select distinct a.Desc_Campo tipo_contenedor, b.Desc_Campo componente, c.Desc_Campo reparacion,d.Desc_Campo lugar,e.Desc_Campo tamano from 
(SELECT '1' cod  ,[Desc_Campo]
  FROM [dbo].[PAR_TABLA_ELEMENTOS]
  where ident_tabla = 1 and Desc_Campo=@servicio) A
  join 
  (SELECT '1' cod
      ,[Desc_Campo]
  FROM [dbo].[PAR_TABLA_ELEMENTOS]
  where ident_tabla = 2 and Desc_Campo=@componente) b on a.cod = b.cod
 join
  (SELECT '1' cod
      ,[Desc_Campo]
  FROM [dbo].[PAR_TABLA_ELEMENTOS]
  where ident_tabla = 3 and Desc_Campo=@reparacion) c on b.cod = c.cod
  join
  (SELECT '1' cod
      ,[Desc_Campo]
  FROM [dbo].[PAR_TABLA_ELEMENTOS]
  where ident_tabla = 4 and (@lugar is null or Desc_Campo LIKE '%' + @Lugar+ '%')) d on c.cod = d.cod
  join
  (SELECT '1' cod
      ,[Desc_Campo]
  FROM [dbo].[PAR_TABLA_ELEMENTOS]
  where ident_tabla = 5 and (@tamano is null or Desc_Campo LIKE '%' + @tamano+ '%')) e on d.cod = e.cod
   order by 1
  
  
 select distinct replace(replace(e.tipo_contenedor,'''','['),'"',']') tipo_contenedor2, e.tipo_contenedor ,e.componente,e.reparacion
,e.lugar,e.tamano,isnull(f.formular_costo,'Por Definir')Formular_Costo ,isnull(f.formular_hora,'Por Definir') Formular_Hora from PAR_Entidad E   
left join
PAR_TABLA_TARIFA f on f.Tipo_Contenedor=e.tipo_contenedor and f.Component_Code = e.componente and 
f.Repair_Code = e.reparacion and f.Damage_Location = e.lugar and f.Size = e.tamano

GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerComponente]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[PAR_ObtenerComponente]
as
SELECT *
  FROM [dbo].[PAR_TABLA_ELEMENTOS] where Ident_Tabla = '2'

 order by  Desc_Campo asc
GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerEntidad]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_ObtenerEntidad]
as
select * from par_tabla_definicion

GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerEntidad_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_ObtenerEntidad_Consultar]
@Codigo nvarchar(10),
@Nombre nvarchar(100)
as
select ident_Campo , Ident_tabla , Desc_Campo from [PAR_TABLA_ELEMENTOS] where (@Codigo IS NULL OR Ident_tabla LIKE '%' + @Codigo + '%')
	AND		(@Nombre IS NULL OR Desc_Campo LIKE '%' + @Nombre + '%')
	ORDER BY	Desc_Campo ASC
GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerLugar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_ObtenerLugar]
as
SELECT *
  FROM [dbo].[PAR_TABLA_ELEMENTOS] where Ident_Tabla = '4'

 order by  Desc_Campo asc
GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerReparacion]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[PAR_ObtenerReparacion]
as
SELECT *
  FROM [dbo].[PAR_TABLA_ELEMENTOS] where Ident_Tabla = '3'
 order by  Desc_Campo asc
GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerServicio]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_ObtenerServicio]
as
SELECT *
  FROM [dbo].[PAR_TABLA_ELEMENTOS] where Ident_Tabla = '1'

 order by  Desc_Campo asc
GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerTamano]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PAR_ObtenerTamano]
as
SELECT *
  FROM [dbo].[PAR_TABLA_ELEMENTOS] where Ident_Tabla = '5'
  order by  Desc_Campo asc

GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerTarifa]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER PROCEDURE [dbo].[PAR_ObtenerTarifa]  --FMCR
--@Servicio nvarchar(100),
--@Componente nvarchar(100),
--@Reparacion nvarchar(100),
--@Lugar nvarchar(100),
--@Tamano nvarchar(100)
--as
--select * from PAR_TABLA_TARIFA where (@Servicio is null or Asiatic_Container_Services LIKE '%' + @Servicio+ '%') and
--(@Componente is null or Component_Code LIKE '%' + @Componente+ '%')and
--(@Reparacion is null or Repair_Code LIKE '%' + @Reparacion+ '%' ) and
--(@Lugar is null or Damage_Location LIKE '%' + @Lugar+ '%' ) and
--(@Tamano is null or Size LIKE '%' + @Tamano+ '%')
--GO
/****** Object:  StoredProcedure [dbo].[SEG_ActualizarUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SEG_ActualizarUsuario]
(
	@IdUsuario int,
	@Nombre nvarchar(100),
	@Email nvarchar(100),
	@Activo bit,
	@Perfil int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	SEG_Usuario
	SET		Nombre = @Nombre,
			Email = @Email,
			Activo = @Activo,
			Perfil = @Perfil
	WHERE	IdUsuario = @IdUsuario
END

GO
/****** Object:  StoredProcedure [dbo].[SEG_ActualizarUsuario_Password]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ActualizarUsuario_Password]
(
	@IdUsuario int,
	@Password nvarchar(200)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE	SEG_Usuario
	SET		Password = @Password
	WHERE	IdUsuario = @IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_EliminarUsuarioXPermiso_IdUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 27/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_EliminarUsuarioXPermiso_IdUsuario]
(
	@IdUsuario int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM	SEG_UsuarioXPermiso
	WHERE	IdUsuario = @IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ExisteUsuario_IdUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ExisteUsuario_IdUsuario]
(
	@IdUsuario int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	SEG_Usuario
					WHERE	IdUsuario = @IdUsuario
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ExisteUsuario_Login]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ExisteUsuario_Login]
(
	@Login nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	EXISTS	(	SELECT	*
					FROM	SEG_Usuario
					WHERE	Login = @Login
				)
		SELECT	1
	ELSE
		SELECT	0
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_InsertarUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SEG_InsertarUsuario]
(
	@Login nvarchar(50),
	@Nombre nvarchar(100),
	@Email nvarchar(100),
	@Password nvarchar(200),
	@Salt nvarchar(50),
	@Activo bit,
	@Perfil int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	SEG_Usuario
	(Login,Nombre,Email,Password,Salt,Activo,Perfil)
	VALUES
	(@Login,@Nombre,@Email,@Password,@Salt,@Activo,@Perfil)
	
	SELECT	SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[SEG_InsertarUsuarioXPermiso]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 27/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_InsertarUsuarioXPermiso]
(
	@IdUsuario int,
	@IdPermiso int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO	SEG_UsuarioXPermiso
	(IdUsuario,IdPermiso)
	VALUES
	(@IdUsuario,@IdPermiso)
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerPermiso]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 23/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ObtenerPermiso]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdPermiso,IdPermiso_Padre,Codigo,Nombre,Orden
	FROM	SEG_Permiso
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerPermiso_IdUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 23/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ObtenerPermiso_IdUsuario]
(
	@IdUsuario int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	P.IdPermiso,P.IdPermiso_Padre,P.Codigo,P.Nombre,P.Orden
	FROM	SEG_Permiso P
	INNER JOIN	SEG_UsuarioXPermiso UXP ON P.IdPermiso = UXP.IdPermiso
	WHERE	UXP.IdUsuario = @IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerPermiso_Login]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 23/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ObtenerPermiso_Login]
(
	@Login nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	P.IdPermiso,P.IdPermiso_Padre,P.Codigo,P.Nombre,P.Orden
	FROM	SEG_Permiso P
	INNER JOIN	SEG_UsuarioXPermiso UXP ON P.IdPermiso = UXP.IdPermiso
	INNER JOIN	SEG_Usuario U ON UXP.IdUsuario = U.IdUsuario
	WHERE	U.Login = @Login
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerUsuario_Consultar]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 17/12/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[SEG_ObtenerUsuario_Consultar]
(
	@Login nvarchar(50),
	@Nombre nvarchar(100),
	@Activo bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	U.IdUsuario AS IdUsuario,
			U.Login AS Login,
			U.Nombre AS Nombre,
			U.Email AS Email,
			U.Activo AS Activo
	FROM	SEG_Usuario U
	WHERE	(@Login IS NULL OR U.Login LIKE '%' + @Login + '%')
	AND		(@Nombre IS NULL OR U.Nombre LIKE '%' + @Nombre + '%')
	AND		(@Activo IS NULL OR U.Activo = @Activo)
	ORDER BY	U.Login ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerUsuario_IdUsuario]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SEG_ObtenerUsuario_IdUsuario]
(
	@IdUsuario int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdUsuario,Login,Nombre,Email,Password,Salt,Activo,Perfil
	FROM	SEG_Usuario
	WHERE	IdUsuario = @IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[SEG_ObtenerUsuario_Login]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SEG_ObtenerUsuario_Login]
(
	@Login nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	IdUsuario,Login,Nombre,Email,Password,Salt,Activo,Perfil
	FROM	SEG_Usuario
	WHERE	Login = @Login
END





GO
/****** Object:  StoredProcedure [dbo].[SP_Actualizar_Campos]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Actualizar_Campos]
@idregistro varchar(20),
@codigo varchar(50),
@valor nvarchar(500)
as

declare @id int

select @id=IdCampo from LIN_Campo where Codigo=@codigo

update [LIN_RegistroDetalleXCampo]
set Valor=@valor where IdCampo=@id and IdRegistro=@idregistro
GO
/****** Object:  StoredProcedure [dbo].[SP_DesfasesDetalles]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DesfasesDetalles]  
@linea varchar(25),  
@viaje varchar(25),  
@contenedor varchar(25),  
@evento varchar(25),  
@estado varchar (25),  
@local varchar(25),  
@booking varchar(25),  
@genbkg varchar(25),  
@nrodoc varchar(25)  
as  
  
select distinct top 1    
L.Nombre Linea,  
E.Codigo + ': '+E.Nombre as Evento,  
R.Contenedor as Ctr,  
R.Sistema as Sistema,  
null as fecingreso,  
null as fecinspeccion,  
null as fecasignacion,  
null as fecllenado,   
null as fecsalida,  
null as fecpresupuesto,   
null as fecaprobacion,  
null as fectermino,  
REPLACE(convert(char(16),R.FechaEvento, 121 ),'-','') as fecoperativo,  
Replace(convert(char(16),r.FechaCreacion, 121 ),'-','') as fecrecieventos,  
Replace(convert(char(16),(case Rl.Estado when 'Env' then Rl.FechaCreacion else null end), 121 ),'-','') as fecenviolinea ,  
convert(varchar,r.FechaCreacion - R.FechaEvento,108) as generaredi,  
convert(varchar,(case Rl.Estado when 'Env' then Rl.FechaCreacion else null end)-R.FechaCreacion ,108) as envioedi,  
convert(varchar,((r.FechaCreacion - R.FechaEvento)+((case Rl.Estado when 'Env' then Rl.FechaCreacion else null end)-R.FechaCreacion) ),108) as defasetotal,  
ISNULL(LXE.IDTipoEvento,0) as tipoevento,  
convert(varchar,r.IdRegistro) idregistro,  
convert(varchar,r.IdEvento) idevento,  
r.Estado as estado,  
E.Nombre as eventoname  
from   
LIN_Registro R LEFT JOIN LIN_Linea L on R.IdLinea = L.IdLinea   
LEFT JOIN LIN_Evento E on R.IdEvento = E.IdEvento   
LEFT JOIN LIN_RegistroLog Rl on R.IdRegistro = Rl.IdRegistro   
LEFT JOIN LIN_LineaXEvento LXE on r.IdLinea = LXE.IdLinea and r.IdEvento = LXE.IdEvento  
where   
R.IdLinea = @linea   
and R.IdEvento = @evento   
and R.Contenedor = @contenedor   
and R.Estado = @estado   
and R.Local =@local   
and (R.BookingBL=@Booking OR @Booking IS NULL OR @Booking='')   
and (R.Genbkg=@genbkg OR @genbkg IS NULL OR @genbkg='')   
and (R.NumeroDocumento=@nrodoc OR @nrodoc IS NULL OR @nrodoc='')  
group by   
l.Nombre,  
r.Contenedor,  
r.Sistema,  
e.Codigo,  
e.Nombre,  
r.FechaEvento,  
r.FechaCreacion,  
rl.Estado,  
rl.FechaCreacion,  
LXE.IDTipoEvento,  
r.IdRegistro,  
r.IdEvento,  
r.Estado,  
e.Nombre   
order by defasetotal desc
GO
/****** Object:  StoredProcedure [dbo].[sp_DesfaseVerCampo]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[sp_DesfaseVerCampo]    
 @idregistro varchar(25),    
 @idevento varchar(10)    
 as    
 select c.Codigo ,c.Nombre ,(case c.TipoDato when 'STR' then 'Cadena'    
 when 'DEC' then 'Decimal' when 'DAT' then 'Fecha' end) as TipoDato,RXP.Valor , c.idcampo as CodigoCampo from lin_registroxcampo RXP LEFT JOIN LIN_Campo C on RXP.IdCampo = C.IdCampo    
 left join lin_Evento e on e.Codigo=@idevento  
 where RXP.IdRegistro = @idregistro and C.IdEvento = e.idevento 
GO
/****** Object:  StoredProcedure [dbo].[sp_Envio_Informacion_VGM_Cliente]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Envio_Informacion_VGM_Cliente]
@sRucCon varchar(11) 
as
declare @sFecIni varchar(8)
declare @sFecFin varchar(8)
SELECT @sFecIni=CONVERT(VARCHAR(10), dateadd(day,-1,getdate()), 112)
SELECT @sFecFin=CONVERT(VARCHAR(10), dateadd(day,0,getdate()), 112)

select b.codemc12 as RUC, b.nomemb13 as CLIENTE_EMBARCADOR, 
a.desc_nave as NAVE, a.cod_viaje as VIAJE, a.line as LINEA,
a.bookinbl as BOOKING, a.discharge_port as PUERTO, 
a.fechaevento as FECHA_EVENTO, a.contenedor as CONTENEDOR, 
a.peso_ctr as PESO, b.conten13 as CONTENIDO
from LIN_REGISTRO_VGM a (nolock)
inner join [SP3TDA-DBSQL01].Descarga.dbo.edbookin13 b on (a.genbkg collate SQL_Latin1_General_CP1_CI_AS =b.genbkg13)
where a.fechacreacion>= @sFecIni and a.fechacreacion<@sFecFin
and b.codemc12=@sRucCon
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Envios_Alertas]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Eventos_Envios_Alertas]
as         
begin 
declare @a char(01)
set @a='0'
select @a
---print 'xxx'
	   
	          
end

 
GO
/****** Object:  StoredProcedure [dbo].[SP_EVENTOS_VACIOS_ENVIOS_GOMT_MG_INTERMEDIO]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER PROCEDURE [dbo].[SP_EVENTOS_VACIOS_ENVIOS_GOMT_MG_INTERMEDIO]
	@sCodEve as char(05),                                                                            
	@sCodLin as char(3),                                                                            
	@sCodInt as char(06),                                                                            
	@sNroCtr as char(11),                                                                            
	@sFecReg as char(20),                                                
	@dPesCtr decimal(12,2)  
	as
	exec   [dbo].[sp_Eventos_Vacio_Envios_GOMT_MG] @sCodEve,@sCodLin,@sCodInt,@sNroCtr,@sFecReg,@dPesCtr
GO
/****** Object:  StoredProcedure [dbo].[SP_MonitoreoDetalle]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 ALTER PROCEDURE [dbo].[SP_MonitoreoDetalle]          
@linea int,          
@navvia varchar(25),          
@evento varchar(25),          
@genbkg char(6),          
@nrodoc varchar (20),          
@local varchar(10),          
@fechaini char(8),          
@fechafin char(8)          
          
as        
select distinct       
le.nombre as Evento,      
ll.nombre as Linea,      
lr.contenedor as contenedor,      
lr.estado as Estado,      
lr.navvia as navvia,      
lr.local as local,      
lr.tipodocumento as tipodocumento,      
lr.numerodocumento as numerodocumento,      
lr.bookingbl as bookingBL,      
lr.genbkg as Genbkg,      
convert(varchar,lr.FechaEvento,103) as fechaevento      
from Lin_registro LR       
Left join lin_linea ll on lr.idlinea=ll.idlinea      
left join lin_evento le on lr.idevento=le.idevento      
where lr.IdEvento = @evento and lr.IdLinea=@linea       
and (lr.navvia=@navvia OR @navvia IS NULL OR @navvia='') and (lr.genbkg = @genbkg OR @genbkg IS NULL OR @genbkg='')           
and (lr.NumeroDocumento = @nrodoc OR @nrodoc IS NULL OR @nrodoc='') and (lr.Local=@local OR @local IS NULL OR @local='')          
and (@fechaini IS NULL OR @fechaini='' OR lr.FechaEvento>=@fechaini)          
and (@fechafin IS NULL OR @fechafin='' OR lr.FechaEvento<@fechafin)      
 
  
and lr.estado='ENV'      
order by 3 desc   
GO
/****** Object:  StoredProcedure [dbo].[SP_MonitoreoDetalle2]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER PROCEDURE [dbo].[SP_MonitoreoDetalle2]    
@linea int,    
@navvia varchar(25),    
@evento varchar(25),    
@genbkg char(6),    
@nrodoc varchar (20),    
@local varchar(10),    
@fechaini datetime,    
@fechafin datetime    
    
as  
select distinct 
le.nombre as Evento,
ll.nombre as Linea,
lr.contenedor as contenedor,
lr.estado as Estado,
lr.navvia as navvia,
lr.local as local,
lr.tipodocumento as tipodocumento,
lr.numerodocumento as numerodocumento,
lr.bookingbl as bookingBL,
lr.genbkg as Genbkg,
convert(varchar,lr.FechaEvento,103) as fechaevento
from Lin_registro LR 
Left join lin_linea ll on lr.idlinea=ll.idlinea
left join lin_evento le on lr.idevento=le.idevento
where lr.IdEvento = @evento and lr.IdLinea=@linea 
and (lr.navvia=@navvia OR @navvia IS NULL OR @navvia='') and (lr.genbkg = @genbkg OR @genbkg IS NULL OR @genbkg='')     
and (lr.NumeroDocumento = @nrodoc OR @nrodoc IS NULL OR @nrodoc='') and (lr.Local=@local OR @local IS NULL OR @local='')    
and (@fechaini IS NULL OR @fechaini='' OR lr.FechaEvento>=@fechaini)    
and (@fechafin IS NULL OR @fechafin='' OR lr.FechaEvento<=@fechafin)  
GO
/****** Object:  StoredProcedure [dbo].[SP_MonitoreoDetalle3]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_MonitoreoDetalle3]    
@linea int,    
@navvia varchar(25),    
@evento varchar(25),    
@genbkg char(6),    
@nrodoc varchar (20),    
@local varchar(10),    
@fechaini datetime,    
@fechafin datetime    
    
as    
Select distinct    
e.Nombre as Evento,l.Nombre as Linea,m.Contenedor,m.Estado,m.navvia,m.local,m.TipoDocumento,m.NumeroDocumento,m.BookingBL,m.Genbkg    
from  LIN_Registro m,LIN_Evento e ,LIN_Linea l    
where e.IdEvento = @evento and l.IdLinea=@linea and m.IdEvento = @evento and m.idlinea=@linea     
and (m.navvia=@navvia OR @navvia IS NULL OR @navvia='') and (m.genbkg = @genbkg OR @genbkg IS NULL OR @genbkg='')     
and (m.NumeroDocumento = @nrodoc OR @nrodoc IS NULL OR @nrodoc='') and (m.Local=@local OR @local IS NULL OR @local='')    
and (@fechaini IS NULL OR @fechaini='' OR convert(varchar,m.FechaEvento,103)>=convert(varchar,@fechaini,103))    
and (@fechafin IS NULL OR @fechafin='' OR convert(varchar,m.FechaEvento,103)<=convert(varchar,@fechafin,103))    
group by e.Nombre,l.nombre,m.contenedor,m.estado,m.navvia,m.local,m.tipodocumento,m.numerodocumento,m.bookingbl,m.genbkg
GO
/****** Object:  StoredProcedure [dbo].[SP_MonitoreoDetalleerr]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_MonitoreoDetalleerr]        
@linea int,        
@navvia varchar(25),        
@evento varchar(25),        
@genbkg char(6),        
@nrodoc varchar (20),        
@local varchar(10),        
@fechaini char(8),        
@fechafin char(8)      
        
as      
select distinct    
le.nombre as Evento,    
ll.nombre as Linea,    
lr.contenedor as contenedor,    
lr.estado as Estado,    
lr.navvia as navvia,    
lr.local as local,    
lr.tipodocumento as tipodocumento,    
lr.numerodocumento as numerodocumento,    
lr.bookingbl as bookingBL,    
lr.genbkg as Genbkg,
lr.FechaEvento as fechaevento    
from Lin_registro LR     
Left join lin_linea ll on lr.idlinea=ll.idlinea    
left join lin_evento le on lr.idevento=le.idevento    
where lr.IdEvento = @evento and lr.IdLinea=@linea     
and (lr.navvia=@navvia OR @navvia IS NULL OR @navvia='') and (lr.genbkg = @genbkg OR @genbkg IS NULL OR @genbkg='')         
and (lr.NumeroDocumento = @nrodoc OR @nrodoc IS NULL OR @nrodoc='') and (lr.Local=@local OR @local IS NULL OR @local='')        
and (@fechaini IS NULL OR @fechaini='' OR lr.FechaEvento>=@fechaini)        
and (@fechafin IS NULL OR @fechafin='' OR lr.FechaEvento<@fechafin)    
and lr.estado='ERR' 
GO
/****** Object:  StoredProcedure [dbo].[SP_OBTENER_LINEA]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[SP_OBTENER_LINEA]
 @CODARM VARCHAR(3)
 AS
 BEGIN
	SELECT  idlinea
	FROM LIN_Linea WHERE ltrim(rtrim(codigo))=@CODARM
 END
GO
/****** Object:  StoredProcedure [dbo].[sp_Obtener_TipoEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Obtener_TipoEvento]
as
select idlinea,idevento,isnull(idtipoevento,0) as idtipoevento,isnull(idfechaoperativa,0) as idfechaoperativa
from LIN_LineaXEvento
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerEvento]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ObtenerEvento]
@idevento varchar(25)
as
select nombre from LIN_Evento where IdEvento = @idevento
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento04000500]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento04000500]
--@linea varchar(20),
--@evento varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_INGRESOS_VACIOS where 
--LINEA = @linea and EVENTO=@evento
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0600]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0600]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_PRESUPUESTO_VACIOS_CTR where 
--LINEA = @linea 
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0601]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0601]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_PRESUPUESTO_VACIOS_MOTOR where 
--LINEA = @linea 
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0602]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0602]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_PRESUPUESTO_VACIOS_MOTOR where 
--LINEA = @linea 
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0700]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0700]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_TERMINOREPARACION_VACIOS where 
--LINEA = @linea 
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0715]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0715]
--@linea varchar(20)
--as	
--select * from oceanica1BK.descarga.dbo.LIN_SALIDAS_VACIOS_EMBARQUE where 
--LINEA = 'HSD'
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0800]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0800]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_SALIDAS_VACIOS_CLIENTE where 
--LINEA = @linea
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento08000801]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento08000801]
--@linea varchar(20),
--@evento varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_SALIDAS_VACIOS_CLIENTEYMOVILIZADOS where 
--LINEA = @linea and EVENTO=@evento
--GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerOperativoEvento0801]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ObtenerOperativoEvento0801]
--@linea varchar(20)
--as	
--select * from oceanica1BK.Descaga.LIN_SALIDAS_VACIOS_MOVILIZADOS where 
--LINEA = @linea
--GO
/****** Object:  StoredProcedure [dbo].[SpSeguimientoEventos_Envios_TI]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
---
SERVIDOR:	calw3bdpor
USER:		sa
PASW:		neptunia2009
BD:			EnvioLineas
*/	
--DETALLE
ALTER PROCEDURE [dbo].[SpSeguimientoEventos_Envios_TI]
	(
		@F_Ini	datetime,
		@F_Fin	datetime
	)
AS

Begin

	SELECT 
			B.Codigo Linea,
			A.idregistro,
			C.Codigo CodEvento, 
			C.Nombre Nombre_Evento,
			A.contenedor,
			A.fechaevento,
			A.estado,
			A.fechacreacion,
			A.local
	FROM dbo.LIN_REGISTRO A INNER 
			JOIN dbo.LIN_Linea B ON A.idlinea = B.idlinea 
			JOIN dbo.LIN_Evento C ON C.idevento = A.idevento
	WHERE A.ESTADO='ENV'
	
	AND CONVERT(VARCHAR,A.fechacreacion,112) >= @F_Ini 
	AND CONVERT(VARCHAR,A.fechacreacion,112) <= @F_Fin 
	AND C.idevento IN (5,10,12,14,13,16) 
	AND (A.Local in ('CALLAO') or a.local IS NULL) 
	
End
GO
/****** Object:  StoredProcedure [dbo].[TableSpaceUsed]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[TableSpaceUsed]
AS

-- Crea Tabla temporal
CREATE TABLE #tblResults
(
[name]   nvarchar(20),
[rows]   int,
[reserved]   varchar(18),
[reserved_int]   int default(0),
[data]   varchar(18),
[data_int]   int default(0),
[index_size]   varchar(18),
[index_size_int]   int default(0),
[unused]   varchar(18),
[unused_int]   int default(0)
)

-- Realiza scan por cada elemento de tabla e indice
EXEC sp_MSforeachtable @command1=
"INSERT INTO #tblResults
([name],[rows],[reserved],[data],[index_size],[unused])
EXEC sp_spaceused '?'"

-- Actualiza los KB por cada Campo
UPDATE #tblResults SET
[reserved_int] = CAST(SUBSTRING([reserved], 1,
CHARINDEX(' ', [reserved])) AS int),
[data_int] = CAST(SUBSTRING([data], 1,
CHARINDEX(' ', [data])) AS int),
[index_size_int] = CAST(SUBSTRING([index_size], 1,
CHARINDEX(' ', [index_size])) AS int),
[unused_int] = CAST(SUBSTRING([unused], 1,
CHARINDEX(' ', [unused])) AS int)

-- Devuelve resultado
SELECT * FROM #tblResults



GO
/****** Object:  StoredProcedure [dbo].[TI_alertas_HLE]    Script Date: 08/03/2019 12:44:06 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[TI_alertas_HLE]          
--as          
--begin  
--
--
--	declare @cod_int varchar(06)
--	declare @contenedor char(11), @fecha char(14),@linea char(3),@evento char(4), @guia_eir char(20), @tipsalida char(20)
--	declare @fec_sinformato datetime
--
--	declare CURSORITO2 cursor for                 
--
--	----------------------- EVENTOS CALLAO ------------------------------	
--	select A.cod_int,a.contenedor ,a.fecha,a.fec_sinformato,a.linea,a.evento,a.guia_eir,a.tipsalida,'LOCAL'='LIMA'
--	from oceanica1.descarga.dbo.LIN_SALIDAS A with(nolock)                   
--	where                   
--	linea='HLE' and
--	convert(char(9),A.FEC_SINFORMATO,112)+ convert(char(5),A.FEC_SINFORMATO,108) >
--		ISNULL(
--			(
--			select max(convert(char(9),B.FECHAEVENTO,112)+ convert(char(5),B.FECHAEVENTO,108))
--			from lin_registro b with(nolock)
--			where 
--			B.IDEVENTO IN ('10','12') AND B.TIPO<>'ELI' AND B.idlinea='2' AND B.estado='ENV'
--			and a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS
--			)
--		,'2013-02-01 00:00:00.000'
--		)
--	AND A.FEC_SINFORMATO>'2013-02-01 00:00:00.000'
--	--order by a.fecha 
--
--	UNION
--	----------------------- EVENTOS PAITA ------------------------------	
--	--SELECT * FROM  LIN_SALIDAS_sinlock
--	
--	select A.cod_int,a.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS ,
--			a.fecha COLLATE SQL_Latin1_General_CP1_CI_AS, a.fec_sinformato 
--			,a.linea COLLATE SQL_Latin1_General_CP1_CI_AS
--			,a.evento COLLATE SQL_Latin1_General_CP1_CI_AS,a.guia_eir COLLATE SQL_Latin1_General_CP1_CI_AS
--			,a.tipsalida COLLATE SQL_Latin1_General_CP1_CI_AS,'LOCAL'='PAITA'
--	from LIN_SALIDAS_sinlock A --with(nolock)                   
--	where                   
--	linea='HLE' and
--	convert(char(9),A.FEC_SINFORMATO,112)+ convert(char(5),A.FEC_SINFORMATO,108) >
--		ISNULL(
--			(
--			select max(convert(char(9),B.FECHAEVENTO,112)+ convert(char(5),B.FECHAEVENTO,108))
--			from lin_registro b with(nolock)
--			where 
--			B.IDEVENTO IN ('10','12') AND B.TIPO<>'ELI' AND B.idlinea='2' AND B.estado='ENV'
--			and a.contenedor=b.contenedor COLLATE SQL_Latin1_General_CP1_CI_AS
--			)
--		,'2013-02-01 00:00:00.000'
--		)
--	AND A.FEC_SINFORMATO>'2013-02-01 00:00:00.000'
--	order by local,a.fecha 	
--	
--	
--	----------------------------------
--	open CURSORITO2                
--	---avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro                  
--	fetch next from CURSORITO2               
--
--	into  @cod_int,@contenedor,@fecha,@fec_sinformato,@linea,@evento,@guia_eir,@tipsalida
--              
--	while @@fetch_status = 0                  
--	begin     
--		exec  TI_Eventos_Envios_Alertas @evento,@linea,@cod_int,@contenedor,@fecha,0      
--		-- Avanzamos otro registro                    
--		fetch next from CURSORITO2                  
--		into @cod_int,@contenedor,@fecha,@fec_sinformato,@linea,@evento,@guia_eir,@tipsalida
--	end                  
--	--cerramos el cursor                  
--
--	close CURSORITO2                  
--	deallocate CURSORITO2            
--
--          
--end
--GO
/****** Object:  StoredProcedure [dbo].[TI_Eventos_Envios_Alertas]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TI_Eventos_Envios_Alertas]
@sCodEve as char(05),                                
@sCodLin as char(3),                                
@sCodInt as char(08),                                
@sNroCtr as char(11),                                
@sFecReg as char(14)  
as          
begin  
----------------------
declare @IdRegistro bigint                                
if @sCodLin='HLE'
EXEC NEP_CrearRegistro 'ALERTAHLE',@sCodEve,@sNroCtr,@sFecReg,@IdRegistro OUTPUT                                
--EXEC NEP_AgregarRegistroXCampo @IdRegistro,'CODIGO_INTERNO',@sCodInt                                
--EXEC NEP_AgregarRegistroXCampo @IdRegistro,'FECHA_EVENTO',@sFecReg               
--EXEC NEP_AgregarRegistroXCampo @IdRegistro,'LOCALNPT','LIMA'  

EXEC NEP_CompletarRegistro @IdRegistro                      
-----------------------
end
GO
/****** Object:  StoredProcedure [dbo].[USP_ACTUALIZAR_ENVIOS_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ACTUALIZAR_ENVIOS_VGM]
@Contenedor VARCHAR(11)
,@Peso_Ctr DECIMAL(12, 3)
,@Navvia varchar(6)
AS
BEGIN
	UPDATE LIN_REGISTRO_VGM
		SET Peso_Ctr = @Peso_Ctr
	WHERE Contenedor = @Contenedor
	AND navvia = @navvia
END
GO
/****** Object:  StoredProcedure [dbo].[USP_IDObtenerEnvios]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_IDObtenerEnvios]
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
	A.idregistro as ID
	,A.line as LINEA
	,A.Contenedor as EQD
	,A.INLANDDEPOT
	,B.Ruta_Interna
	FROM LIN_REGISTRO_VGM A WITH (NOLOCK)
	INNER JOIN LIN_OBTENERLINEA_VGM B WITH (NOLOCK) ON LTRIM(RTRIM(A.line)) = LTRIM(RTRIM(B.linea))
	INNER JOIN LIN_TIPOENVIO_VGM C WITH (NOLOCK) ON A.idtipoenvio = C.idtipoenvio
	WHERE B.Activo = '1' AND A.estado = 'REG'
SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_LLENAR_GRILLA_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_LLENAR_GRILLA_VGM] @tipo VARCHAR(1)
	,@sucursal VARCHAR(25)
	,@contenedor VARCHAR(25)
	,@Busqueda VARCHAR(35)
AS
BEGIN
	SET NOCOUNT ON;
	SET @sucursal = LTRIM(RTRIM(@sucursal))
	SET @contenedor = LTRIM(RTRIM(@contenedor))
	SET @Busqueda = LTRIM(RTRIM(@Busqueda))

	IF @tipo = '0'
	BEGIN
		SELECT DISTINCT *
		FROM (
			SELECT ISNULL(A.line, '') AS linea
				,LTRIM(RTRIM(ISNULL(A.BookinBL, ''))) AS booking
				,LTRIM(RTRIM(ISNULL(A.Desc_Nave, ''))) AS nave
				,LTRIM(RTRIM(ISNULL(A.Cod_Viaje, ''))) AS viaje
				,ISNULL(A.Contenedor, '') AS contenedor
				,idtipoenvio AS metodo
				,cast(convert(DECIMAL(12, 2), A.Peso_Ctr) AS VARCHAR) AS peso
				,ISNULL((convert(VARCHAR, A.FechaCreacion, 106) + ' ' + convert(VARCHAR(5), A.FechaCreacion, 114)), '') AS fecregistro
				,ISNULL((convert(VARCHAR, A.feccut11, 106) + ' ' + convert(VARCHAR(5), A.feccut11, 114)), '') AS cutoffdry
				,ISNULL((convert(VARCHAR, A.feccutR11, 106) + ' ' + convert(VARCHAR(5), A.feccutR11, 114)), '') AS cutoffreefer
			FROM LIN_REGISTRO_VGM A WITH (NOLOCK)
			WHERE A.feclle11 >= DATEADD(DAY, - 5, GETDATE())
				AND A.feccut11 >= DATEADD(HOUR, - 24, GETDATE())
				AND A.INLANDDEPOT = 'NEC'
			) UML
		ORDER BY UML.fecregistro DESC
	END

	IF @tipo = '1'
	BEGIN
		DECLARE @DATO VARCHAR(3)

		IF @sucursal = 'Callao'
		BEGIN
			SET @DATO = 'NEC'
		END

		IF @sucursal = 'Paita'
		BEGIN
			SET @DATO = 'NEP'
		END

		IF @Busqueda = 'Booking'
		BEGIN
			SELECT DISTINCT *
			FROM (
				SELECT ISNULL(A.line, '') AS linea
					,LTRIM(RTRIM(ISNULL(A.BookinBL, ''))) AS booking
					,LTRIM(RTRIM(ISNULL(A.Desc_Nave, ''))) AS nave
					,LTRIM(RTRIM(ISNULL(A.Cod_Viaje, ''))) AS viaje
					,ISNULL(A.Contenedor, '') AS contenedor
					,idtipoenvio AS metodo
					,cast(convert(DECIMAL(12, 2), A.Peso_Ctr) AS VARCHAR) AS peso
					,ISNULL((convert(VARCHAR, A.FechaCreacion, 106) + ' ' + convert(VARCHAR(5), A.FechaCreacion, 114)), '') AS fecregistro
					,ISNULL((convert(VARCHAR, A.feccut11, 106) + ' ' + convert(VARCHAR(5), A.feccut11, 114)), '') AS cutoffdry
					,ISNULL((convert(VARCHAR, A.feccutR11, 106) + ' ' + convert(VARCHAR(5), A.feccutR11, 114)), '') AS cutoffreefer
				FROM LIN_REGISTRO_VGM A WITH (NOLOCK)
				WHERE A.INLANDDEPOT = @DATO
					AND A.BookinBL = @contenedor
				) UML
			ORDER BY UML.fecregistro DESC
		END

		IF @Busqueda = 'Contenedor'
		BEGIN
			SELECT DISTINCT *
			FROM (
				SELECT ISNULL(A.line, '') AS linea
					,LTRIM(RTRIM(ISNULL(A.BookinBL, ''))) AS booking
					,LTRIM(RTRIM(ISNULL(A.Desc_Nave, ''))) AS nave
					,LTRIM(RTRIM(ISNULL(A.Cod_Viaje, ''))) AS viaje
					,ISNULL(A.Contenedor, '') AS contenedor
					,idtipoenvio AS metodo
					,cast(convert(DECIMAL(12, 2), A.Peso_Ctr) AS VARCHAR) AS peso
					,ISNULL((convert(VARCHAR, A.FechaCreacion, 106) + ' ' + convert(VARCHAR(5), A.FechaCreacion, 114)), '') AS fecregistro
					,ISNULL((convert(VARCHAR, A.feccut11, 106) + ' ' + convert(VARCHAR(5), A.feccut11, 114)), '') AS cutoffdry
					,ISNULL((convert(VARCHAR, A.feccutR11, 106) + ' ' + convert(VARCHAR(5), A.feccutR11, 114)), '') AS cutoffreefer
				FROM LIN_REGISTRO_VGM A WITH (NOLOCK)
				WHERE A.INLANDDEPOT = @DATO
					AND A.Contenedor = @contenedor
				) UML
			ORDER BY UML.fecregistro DESC
		END
	END

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LLENAR_GRILLA_VGM_NEW]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_LLENAR_GRILLA_VGM_NEW]            
@tipo varchar(1),            
@sucursal varchar(25),            
@contenedor varchar(25),        
@Busqueda varchar(35)        
AS            
BEGIN             
SET NOCOUNT ON;            
 SET @sucursal = LTRIM(RTRIM(@sucursal))            
 SET @contenedor = LTRIM(RTRIM(@contenedor))            
 SET @Busqueda = LTRIM(RTRIM(@Busqueda))            
             
 IF @tipo ='0'            
 BEGIN            
    SELECT DISTINCT *      
    FROM      
    (      
     SELECT    
     cast(idregistro as varchar) as ID           
     ,ISNULL(A.line,'') as linea            
     ,LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking             
     ,LTRIM(RTRIM(ISNULL(A.Desc_Nave,''))) as nave            
     ,LTRIM(RTRIM(ISNULL(A.Cod_Viaje,''))) as viaje            
     ,ISNULL(A.Contenedor,'') as contenedor          
     ,idtipoenvio AS metodo          
     ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso            
     ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro            
     ,ISNULL( (convert(varchar,A.feccut11,106) + ' ' +  convert(varchar(5),A.feccut11,114)) ,'') as cutoffdry            
     ,ISNULL( (convert(varchar,A.feccutR11,106) + ' ' +  convert(varchar(5),A.feccutR11,114)) ,'') as cutoffreefer            
     FROM LIN_REGISTRO_VGM A WITH (NOLOCK)            
     where             
     A.feclle11 >= DATEADD(DAY,-15,GETDATE())            
     AND A.feccut11 >= DATEADD(HOUR,-24,GETDATE())       
    ) UML        
    order by UML.fecregistro desc           
 END            
         
 IF @tipo ='1'            
 BEGIN            
   DECLARE @DATO VARCHAR(3)            
               
   IF @sucursal = 'Callao'            
   BEGIN            
    SET @DATO = 'NEC'            
   END            
               
   IF @sucursal = 'Paita'            
   BEGIN            
    SET @DATO = 'NEP'            
   END            
           
   IF @Busqueda = 'Booking'        
   BEGIN        
		SELECT DISTINCT *      
		FROM      
		(      
	  SELECT    
	  cast(idregistro as varchar) as ID  
	  ,ISNULL(A.line,'') as linea            
	  ,LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking             
	  ,LTRIM(RTRIM(ISNULL(A.Desc_Nave,''))) as nave            
	  ,LTRIM(RTRIM(ISNULL(A.Cod_Viaje,''))) as viaje            
	  ,ISNULL(A.Contenedor,'') as contenedor            
	  ,idtipoenvio AS metodo          
	  ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso            
	  ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro            
	  ,ISNULL( (convert(varchar,A.feccut11,106) + ' ' +  convert(varchar(5),A.feccut11,114)) ,'') as cutoffdry            
	  ,ISNULL( (convert(varchar,A.feccutR11,106) + ' ' +  convert(varchar(5),A.feccutR11,114)) ,'') as cutoffreefer            
	  FROM LIN_REGISTRO_VGM A WITH (NOLOCK)            
	  where A.INLANDDEPOT = @DATO            
	  AND A.BookinBL = @contenedor       
	  ) UML        
		order by UML.fecregistro desc        
   END        
           
   IF @Busqueda = 'Contenedor'        
   BEGIN            
		SELECT DISTINCT *      
		FROM      
		(      
	  SELECT  
	  cast(idregistro as varchar) as ID            
	  ,ISNULL(A.line,'') as linea            
	  ,LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking             
	  ,LTRIM(RTRIM(ISNULL(A.Desc_Nave,''))) as nave            
	  ,LTRIM(RTRIM(ISNULL(A.Cod_Viaje,''))) as viaje            
	  ,ISNULL(A.Contenedor,'') as contenedor            
	  ,idtipoenvio AS metodo          
	  ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso            
	  ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro            
	  ,ISNULL( (convert(varchar,A.feccut11,106) + ' ' +  convert(varchar(5),A.feccut11,114)) ,'') as cutoffdry            
	  ,ISNULL( (convert(varchar,A.feccutR11,106) + ' ' +  convert(varchar(5),A.feccutR11,114)) ,'') as cutoffreefer              FROM LIN_REGISTRO_VGM A WITH (NOLOCK)            
	  where A.INLANDDEPOT = @DATO            
	  AND A.Contenedor = @contenedor       
	  ) UML        
		order by UML.fecregistro desc        
   END        
               
  END      
  
  IF @tipo ='3'            
 BEGIN            
   DECLARE @DATO1 VARCHAR(3)            
               
   IF @sucursal = 'Callao'            
   BEGIN            
    SET @DATO1 = 'NEC'            
   END            
               
   IF @sucursal = 'Paita'            
   BEGIN            
    SET @DATO1 = 'NEP'            
   END            
           
   IF @Busqueda = 'Booking'        
   BEGIN        
		SELECT DISTINCT *      
		FROM      
		(      
	  SELECT     
	  ISNULL(A.line,'') as linea            
	  ,LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking             
	  ,LTRIM(RTRIM(ISNULL(A.Desc_Nave,''))) as nave            
	  ,LTRIM(RTRIM(ISNULL(A.Cod_Viaje,''))) as viaje            
	  ,ISNULL(A.Contenedor,'') as contenedor            
	  ,idtipoenvio AS metodo          
	  ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso            
	  ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro            
	  ,ISNULL( (convert(varchar,A.feccut11,106) + ' ' +  convert(varchar(5),A.feccut11,114)) ,'') as cutoffdry            
	  ,ISNULL( (convert(varchar,A.feccutR11,106) + ' ' +  convert(varchar(5),A.feccutR11,114)) ,'') as cutoffreefer            
	  FROM LIN_REGISTRO_VGM A WITH (NOLOCK)            
	  where A.INLANDDEPOT = @DATO1            
	  AND A.BookinBL = @contenedor       
	  ) UML        
		order by UML.fecregistro desc        
   END        
           
   IF @Busqueda = 'Contenedor'        
   BEGIN            
		SELECT DISTINCT *      
		FROM      
		(      
	  SELECT            
	  ISNULL(A.line,'') as linea            
	  ,LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking             
	  ,LTRIM(RTRIM(ISNULL(A.Desc_Nave,''))) as nave            
	  ,LTRIM(RTRIM(ISNULL(A.Cod_Viaje,''))) as viaje            
	  ,ISNULL(A.Contenedor,'') as contenedor            
	  ,idtipoenvio AS metodo          
	  ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso            
	  ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro            
	  ,ISNULL( (convert(varchar,A.feccut11,106) + ' ' +  convert(varchar(5),A.feccut11,114)) ,'') as cutoffdry            
	  ,ISNULL( (convert(varchar,A.feccutR11,106) + ' ' +  convert(varchar(5),A.feccutR11,114)) ,'') as cutoffreefer              FROM LIN_REGISTRO_VGM A WITH (NOLOCK)            
	  where A.INLANDDEPOT = @DATO1            
	  AND A.Contenedor = @contenedor       
	  ) UML        
		order by UML.fecregistro desc        
   END        
               
  END                  
             
SET NOCOUNT OFF;            
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerEnvios]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerEnvios]
@ID INT
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
	A.Contenedor as EQD
	,A.FechaEvento as DTM
	,A.BookinBL as RFF
	,A.Codigo_ISO as ISOEQD
	,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as MEA
	,A.Cod_Viaje as COD_VIAJE
	,A.Desc_Nave as DESC_NAVE
	,A.Local_Puerto as LOCALPUERTO
	,A.INLANDDEPOT
	,A.DISCHARGE_PORT
	FROM LIN_REGISTRO_VGM A WITH (NOLOCK)
	WHERE A.idregistro = @ID
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerRuta]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerRuta]
@LINEA VARCHAR(3)
AS
BEGIN
SET NOCOUNT ON;
	SELECT Ruta_Interna
	FROM LIN_OBTENERLINEA_VGM
	WHERE linea = LTRIM(RTRIM(@LINEA))
SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENERVGM_ID]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENERVGM_ID]    
@ID INT    
AS    
BEGIN    
set nocount on;    
  SELECT             
  LTRIM(RTRIM(ISNULL(A.BookinBL,''))) as booking                       
  ,ISNULL(A.Contenedor,'') as contenedor            
  ,CAST(A.idtipoenvio AS VARCHAR) AS metodo            
  ,cast(convert(decimal(12,2),A.Peso_Ctr) as varchar) as peso       
  ,ISNULL( (convert(varchar,A.FechaCreacion,106) + ' ' +  convert(varchar(5),A.FechaCreacion,114)) ,'') as fecregistro    
  ,CASE WHEN A.INLANDDEPOT ='NEC' THEN 'CALLAO'    
     ELSE 'PAITA'    
     END AS sucursal  
  ,('DEXP: ' + (right('00000000'+ltrim(rtrim(idregistro)),(8))) ) as ID             
  FROM LIN_REGISTRO_VGM A WITH (NOLOCK)    
  WHERE A.idregistro = @ID    
set nocount off;    
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_REGISTAR_ENVIOS_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REGISTAR_ENVIOS_VGM]  
@line varchar(3),  
@evento varchar(3),  
@estado varchar(3),  
@Sistema varchar(100),  
@usuario varchar(35),  
@ip_machine varchar(35),  
@desc_local varchar(15),  
@idtipoenvio int,   
@Contenedor varchar(11),  
@FechaEvento varchar(20),  
@navvia varchar(20),  
@tipo_documento varchar(5),  
@Nro_Documento varchar(8),  
@BookinBL varchar(35),  
@Genbkg varchar(6),  
@Tamanyo_ctr varchar(2),  
@Tipo_ctr varchar(3),  
@Codigo_ISO varchar(5),  
@Peso_Ctr decimal(12,3),  
@Local_Etiqueta varchar(15),  
@Opera varchar(1),  
@Condcont varchar(1),  
@Local_Origen varchar(1),  
@SIZETYPE varchar(5),  
@Cod_Viaje varchar(10),  
@Desc_Nave varchar(100),  
@Local_Puerto varchar(5),  
@INLANDDEPOT varchar(3),  
@DISCHARGE_PORT varchar(5),  
@FECLLE DATETIME = NULL,  
@FECCUTDRY DATETIME = NULL,  
@FECCUTREEF DATETIME = NULL  
AS  
BEGIN  
 IF NOT EXISTS( SELECT * FROM LIN_REGISTRO_VGM   
     WHERE line = @line AND navvia = @navvia AND Contenedor = @Contenedor AND idtipoenvio = @idtipoenvio and Genbkg = @Genbkg  
     )  
 BEGIN  
  INSERT INTO LIN_REGISTRO_VGM  
  (line,evento,estado,FechaCreacion,Sistema,usuario,ip_machine,desc_local,idtipoenvio,  
  Contenedor,FechaEvento,navvia,tipo_documento,Nro_Documento,BookinBL,Genbkg,Tamanyo_ctr,  
  Tipo_ctr,Codigo_ISO,Peso_Ctr,Local_Etiqueta,Opera,Condcont,Local_Origen,SIZETYPE,Cod_Viaje,  
  Desc_Nave,Local_Puerto,INLANDDEPOT,DISCHARGE_PORT,  
  feclle11,feccut11,feccutR11)  
  VALUES  
  (@line,@evento,@estado,GETDATE(),@Sistema,@usuario,@ip_machine,@desc_local,@idtipoenvio,  
  @Contenedor,@FechaEvento,@navvia,@tipo_documento,@Nro_Documento,@BookinBL,@Genbkg,@Tamanyo_ctr,  
  @Tipo_ctr,@Codigo_ISO,@Peso_Ctr,@Local_Etiqueta,@Opera,@Condcont,@Local_Origen,@SIZETYPE,@Cod_Viaje,  
  @Desc_Nave,@Local_Puerto,@INLANDDEPOT,@DISCHARGE_PORT,  
  @FECLLE,@FECCUTDRY,@FECCUTREEF  
  )  
 END  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REGISTAR_ENVIOS_VGM_PRUEBA]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REGISTAR_ENVIOS_VGM_PRUEBA]
@line	varchar(3),
@evento	varchar(3),
@estado	varchar(3),
@Sistema	varchar(100),
@usuario	varchar(35),
@ip_machine	varchar(35),
@desc_local	varchar(15),
@idtipoenvio	int,	
@Contenedor	varchar(11),
@FechaEvento	varchar(20),
@navvia	varchar(20),
@tipo_documento	varchar(5),
@Nro_Documento	varchar(8),
@BookinBL	varchar(35),
@Genbkg	varchar(6),
@Tamanyo_ctr	varchar(2),
@Tipo_ctr	varchar(3),
@Codigo_ISO	varchar(5),
@Peso_Ctr	decimal(12,3),
@Local_Etiqueta	varchar(15),
@Opera	varchar(1),
@Condcont	varchar(1),
@Local_Origen	varchar(1),
@SIZETYPE	varchar(5),
@Cod_Viaje	varchar(10),
@Desc_Nave	varchar(100),
@Local_Puerto	varchar(5),
@INLANDDEPOT	varchar(3),
@DISCHARGE_PORT	varchar(5),
@FECLLE DATETIME = NULL,
@FECCUTDRY DATETIME = NULL,
@FECCUTREEF DATETIME = NULL
AS
BEGIN
	IF NOT EXISTS(	SELECT * FROM LIN_REGISTRO_VGM 
					WHERE line = @line AND navvia = @navvia AND Contenedor = @Contenedor AND idtipoenvio = @idtipoenvio
				 )
	BEGIN
		INSERT INTO LIN_REGISTRO_VGM
		(line,evento,estado,FechaCreacion,Sistema,usuario,ip_machine,desc_local,idtipoenvio,
		Contenedor,FechaEvento,navvia,tipo_documento,Nro_Documento,BookinBL,Genbkg,Tamanyo_ctr,
		Tipo_ctr,Codigo_ISO,Peso_Ctr,Local_Etiqueta,Opera,Condcont,Local_Origen,SIZETYPE,Cod_Viaje,
		Desc_Nave,Local_Puerto,INLANDDEPOT,DISCHARGE_PORT,
		feclle11,feccut11,feccutR11)
		VALUES
		(@line,@evento,@estado,GETDATE(),@Sistema,@usuario,@ip_machine,@desc_local,@idtipoenvio,
		@Contenedor,@FechaEvento,@navvia,@tipo_documento,@Nro_Documento,@BookinBL,@Genbkg,@Tamanyo_ctr,
		@Tipo_ctr,@Codigo_ISO,@Peso_Ctr,@Local_Etiqueta,@Opera,@Condcont,@Local_Origen,@SIZETYPE,@Cod_Viaje,
		@Desc_Nave,@Local_Puerto,@INLANDDEPOT,@DISCHARGE_PORT,
		@FECLLE,@FECCUTDRY,@FECCUTREEF
		)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REGISTRAR_AUDITORIA_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REGISTRAR_AUDITORIA_VGM]
@IP VARCHAR(35),
@Opcion_Audi VARCHAR(1),
@Error VARCHAR(250),
@contenedor VARCHAR(11)
AS
BEGIN
	SET @IP = LTRIM(RTRIM(@IP))
	SET @Error = LTRIM(RTRIM(@Error))
	SET @contenedor = LTRIM(RTRIM(@contenedor))
	
	INSERT INTO DDAUT_VGM00(ip_machine00,opcion_audi00,error00,contenedor,fecope00)
	VALUES(@IP,@Opcion_Audi,@Error,@contenedor,GETDATE())
	
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Registro_CODECO_GWC]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Registro_CODECO_GWC]
@SISTEMA         VARCHAR(20),
@USUARIO         VARCHAR(30),
@ITRM            VARCHAR(10),
@EQID            VARCHAR(20),
@EVENT_CODE      VARCHAR(10),
@LINE_CODE       VARCHAR(20),
@RESULT_PATH     VARCHAR(256),
@EVDATE          DATETIME,
@RESULT          INT OUTPUT,
@RESULT_SZ       VARCHAR(100) OUTPUT
AS
BEGIN

  INSERT INTO CODECO_TRANSACTION(SISTEMA,USUARIO,ITRM,EQID,EVENT_CODE,LINE_CODE,RESULT_PATH,EVDATE)
    VALUES (@SISTEMA,@USUARIO,@ITRM,@EQID,@EVENT_CODE,@LINE_CODE,@RESULT_PATH,@EVDATE) 
  
  SET @RESULT = 0
  SET @RESULT_SZ = ''

END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_Envios]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_Envios]
@ID INT
AS
BEGIN
	UPDATE LIN_REGISTRO_VGM SET estado = 'ENV'
	WHERE idregistro = @ID
	
	SELECT 'ACTUALIZACION CORRECTA' AS 'Mensaje'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_PESOVGM_FC]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_PESOVGM_FC]
@CODEMC VARCHAR(11),
@CTR VARCHAR(11),
@PESONETO DECIMAL(12,3),
@BOOKIN VARCHAR(25)
AS
BEGIN
	
	SET @BOOKIN = LTRIM(RTRIM(@BOOKIN))
	
	IF @CODEMC = '20100971772'
	BEGIN
		UPDATE LIN_REGISTRO_VGM SET Peso_Ctr = @PESONETO
		WHERE LTRIM(RTRIM(BookinBL)) = @BOOKIN
		AND Contenedor = @CTR
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDATION_VGM]    Script Date: 08/03/2019 12:44:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec USP_VALIDATION_VGM 'Paita','087LIM198888','Booking'  
--ALTER PROCEDURE [dbo].[USP_VALIDATION_VGM]  --FMCR
--@sucursal varchar(25),  
--@contenedor varchar(25),
--@busqueda varchar(25)  
--AS  
--BEGIN  
--SET NOCOUNT ON;  
-- SET @sucursal = ltrim(rtrim(@sucursal))  
-- SET @contenedor = ltrim(rtrim(@contenedor))  
-- SET @busqueda = ltrim(rtrim(@busqueda))  
   
-- DECLARE @MENSAJE VARCHAR(250)  
-- SET @MENSAJE = ''  
   
-- IF @sucursal = '-Seleccionar-'  
-- BEGIN  
--	SET @MENSAJE = 'Seleccione una Sucursal para realizar la Consulta'  
--	SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--	RETURN;  
-- END  
 
-- IF @busqueda ='Contenedor'
-- BEGIN  
--	 IF LEN(@contenedor) <> 11  
--	 BEGIN  
--		  SET @MENSAJE = 'Ingrese un contenedor de 11 dígitos'  
--		  SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--		  RETURN;  
--	 END  
   
--	 IF @sucursal = 'Callao'  
--	 BEGIN  
--		IF NOT EXISTS(  
--						  SELECT TOP 1 A.genbkg13   
--						  FROM [SP3TDA-DBSQL01].Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)  
--						  INNER JOIN [SP3TDA-DBSQL01].Descarga.dbo.ERCONASI17 B WITH (NOLOCK) on A.genbkg13 = B.genbkg13  
--						  WHERE B.codcon04 = @contenedor  
--					  )  
--		BEGIN  
--			   SET @MENSAJE = 'El Contenedor: ' + @contenedor + ', No se encuentra asignado a un Booking'  
--			   SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			   RETURN;  
--		END  
--		IF NOT EXISTS(  
--						SELECT top 1 * FROM LIN_REGISTRO_VGM WITH (NOLOCK)  
--						WHERE ltrim(rtrim(Contenedor)) = @contenedor AND INLANDDEPOT = 'NEC'  
--					 )  
--		BEGIN  
--				SET @MENSAJE = 'El Contenedor: ' + @contenedor + ', No cuenta con VGM generado'  
--				SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--				RETURN;  
--		END  
--	 END   
   
--	 IF @sucursal = 'Paita'  
--	 BEGIN  
--		IF NOT EXISTS(  
--						SELECT TOP 1 A.genbkg13   
--						FROM Neptuniap2.Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)  
--						INNER JOIN Neptuniap2.Descarga.dbo.ERCONASI17 B WITH (NOLOCK) on A.genbkg13 = B.genbkg13  
--						WHERE B.codcon04 = @contenedor  
--					  )  
--		BEGIN  
--			SET @MENSAJE = 'El Contenedor: ' + @contenedor + ', No se encuentra asignado a un Booking'  
--			SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			RETURN;  
--		END  
--		IF NOT EXISTS(  
--						SELECT * FROM LIN_REGISTRO_VGM WITH (NOLOCK)  
--						WHERE ltrim(rtrim(Contenedor)) = @contenedor AND INLANDDEPOT = 'NEP'  
--					  )  
--		BEGIN  
--			SET @MENSAJE = 'El Contenedor: ' + @contenedor + ', No cuenta con VGM generado'  
--			SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			RETURN;  
--		END  
--	 END
-- END   
 
-- IF @busqueda ='Booking'
-- BEGIN  
--	 IF LEN(@contenedor) < 1  
--	 BEGIN  
--		  SET @MENSAJE = 'Ingrese un Booking a Consultar'  
--		  SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--		  RETURN;  
--	 END  
   
--	 IF @sucursal = 'Callao'  
--	 BEGIN  
--		IF NOT EXISTS(
--						  SELECT TOP 1 A.bkgcom13   
--						  FROM [SP3TDA-DBSQL01].Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)
--						  WHERE ltrim(rtrim(ISNULL(A.bkgcom13,''))) = @contenedor  
--					 )
--		BEGIN
--			   SET @MENSAJE = 'El Booking: ' + @contenedor + ', No se encuentra registrado en el Sistema'  
--			   SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			   RETURN;
--		END
--		IF NOT EXISTS(  
--						  SELECT TOP 1 A.genbkg13   
--						  FROM [SP3TDA-DBSQL01].Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)  
--						  INNER JOIN [SP3TDA-DBSQL01].Descarga.dbo.ERCONASI17 B WITH (NOLOCK) on A.genbkg13 = B.genbkg13  
--						  WHERE ltrim(rtrim(ISNULL(A.bkgcom13,''))) = @contenedor  
--					  )  
--		BEGIN  
--			   SET @MENSAJE = 'El Booking: ' + @contenedor + ', No tiene Contenedores asignados'  
--			   SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			   RETURN;  
--		END  
--		IF NOT EXISTS(  
--						SELECT top 1 * FROM LIN_REGISTRO_VGM WITH (NOLOCK)  
--						WHERE ltrim(rtrim(BookinBL)) = @contenedor AND INLANDDEPOT = 'NEC'  
--					 )  
--		BEGIN  
--				SET @MENSAJE = 'El Booking: ' + @contenedor + ', No cuenta con VGM generado para sus Contenedores Asociados'  
--				SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--				RETURN;  
--		END  
--	 END   
   
--	 IF @sucursal = 'Paita'  
--	 BEGIN  
--		print '1'
		
--		IF NOT EXISTS(
--						  SELECT TOP 1 A.bkgcom13   
--						  FROM Neptuniap2.Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)
--						  WHERE ltrim(rtrim(ISNULL(A.bkgcom13,''))) = @contenedor  
--					 )
--		BEGIN
--			   SET @MENSAJE = 'El Booking: ' + @contenedor + ', No se encuentra registrado en el Sistema'  
--			   SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			   RETURN;
--		END
--		/*
--		IF NOT EXISTS(  
--						  SELECT TOP 1 A.genbkg13   
--						  FROM Neptuniap2.Descarga.dbo.EDBOOKIN13 A WITH (NOLOCK)  
--						  INNER JOIN Neptuniap2.Descarga.dbo.ERCONASI17 B WITH (NOLOCK) on A.genbkg13 = B.genbkg13  
--						  WHERE ltrim(rtrim(ISNULL(A.bkgcom13,''))) = @contenedor  
--					  )  
--		BEGIN  
--			   SET @MENSAJE = 'El Booking: ' + @contenedor + ', No tiene Contenedores asignados'  
--			   SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--			   RETURN;  
--		END  
--		IF NOT EXISTS(  
--						SELECT top 1 * FROM LIN_REGISTRO_VGM WITH (NOLOCK)  
--						WHERE ltrim(rtrim(BookinBL)) = @contenedor AND INLANDDEPOT = 'NEP'  
--					 )  
--		BEGIN  
--				SET @MENSAJE = 'El Booking: ' + @contenedor + ', No cuenta con VGM generado para sus Contenedores Asociados'  
--				SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
--				RETURN;  
--		END 
--		*/ 
--	 END
-- END   
   
-- SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'  
   
--SET NOCOUNT OFF;  
--END
--GO
