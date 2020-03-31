USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[Transporte_IMPO_viajestotal]    Script Date: 04/15/2015 16:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_helptext Transporte_IMPO_viajestotal -20                  
                  
--sp_helptext Transporte_IMPO_viajestotal -20                  
                  
ALTER PROCEDURE [dbo].[Transporte_IMPO_viajestotal] (@frecuencia int)                                                                           
as                                        
begin                                            
                                                 
-- Se enviará la data hasta luego de 5 días de que la nave arribo/llego al puerto del Callao.                          
set @frecuencia=@frecuencia-7200                          
            -- SELECT dateadd(n, -7220,getdate())               
Declare @Fecha datetime                                                  
    Set @Fecha =dateadd(n, @frecuencia,getdate())                                                  
                                             
delete from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT1 where interface='INTERFACE3' and Estado=1                                         
                                          
insert into CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT1 (Interface,Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,ManifestadoLleno,ManifestadoVacio,EsCargaPeligrosa,FlagImpoExpo,NaveViaje,EstadoRegistro,NombreNave)                
                                                  
              
                       
Select DISTINCT Interface,Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,                                                  
 SUM(ManifestadoLleno) ManifestadoLleno,                                                  
 SUM(ManifestadoVacio) ManifestadoVacio,                                                  
 SUM(EsCargaPeligrosa) EsCargaPeligrosa,FlagImpoExpo,NaveViaje                
 ,EstadoRegistro,desnav08                
 from                                                   
 (                                                                  
----------------------------------------------------         
        
 Select DISTINCT 'INTERFACE3' Interface,Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,                                                  
 0 AS ManifestadoLleno,                                                  
 COUNT(CASE WHEN condición='VACIO' THEN NRO_CTRS ELSE 0 END) ManifestadoVacio,                                                  
 SUM(CARGAPELIGROSA) EsCargaPeligrosa,FlagImpoExpo,NaveViaje                
 ,0 AS EstadoRegistro,desnav08            -- POR CORREGIR LA NAVE    
 from                       
 (                                                                  
         
        
 select DISTINCT        
 a.codnav08 Nave,                                                  
 a.numvia11 NumViaje,                                           
 (case a.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) as Origen,                                                  
 a.numman11 NroManifiesto,                                                  
 a.anyman11 AnioManifiesto,                                                  
 a.feclle11 FechaArribo,                                                  
 (case b.codbol03 when 'MT' then 'VACIO' ELSE 'LLENO' end ) as condición,                                                  
 (b.codcon04) NRO_CTRS,                                                  
 (case isnull(b.codimo13,'') when '' then 0 ELSE 1 END) AS CARGAPELIGROSA        
 ,a.tipope11 FlagImpoExpo,a.navvia11  NaveViaje      
 ,CASE b.FLGSTA04 WHEN '0' THEN 1 WHEN '1' THEN 0 END AS estadoRegistro,                      
 d.desnav08                 
 from DDCABMAN11 a (nolock)                                                   
 INNER JOIN DDCONTEN04 b (nolock)  ON a.navvia11=b.navvia11                                                  
 inner join DVCABCON18 d (nolock) ON a.navvia11=d.navvia11              
        
 WHERE                                                   
 a.TIPOPE11='D' and                                                  
 feclle11 >=@Fecha and                                     
 b.sucursal in ('1','2','3','4') -- 2:CONTENEDORES VACIOS                      
 and b.FLGSTA04 ='1' AND b.FLGDES04 ='0'   -- Filtros para solo Neptunia                                             
 AND b.codbol03='MT'        
 --and a.codnav08='WEEX'        
 --group by a.codnav08,a.numvia11,a.ptoori11,a.numman11,a.anyman11,a.feclle11,b.codbol03,a.TIPOPE11,a.navvia11,d.desnav08             
 ) tb                                                  
 group by Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,FlagImpoExpo,NaveViaje,estadoRegistro,desnav08              
        
        
        
UNION        
         
        
 Select DISTINCT 'INTERFACE3' Interface,Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,                                                  
 COUNT(CASE WHEN condición='LLENO' THEN NRO_CTRS ELSE 0 END) ManifestadoLleno,                                                  
 0 AS ManifestadoVacio,                                                  
 SUM(CARGAPELIGROSA) EsCargaPeligrosa,FlagImpoExpo,NaveViaje                
 ,0 AS EstadoRegistro,desnav08                
 from                                                   
 (                                                                  
         
        
 select DISTINCT        
 a.codnav08 Nave,                                                  
 a.numvia11 NumViaje,                                                  
 (case a.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) as Origen,                                                  
 a.numman11 NroManifiesto,                                                  
 a.anyman11 AnioManifiesto,                                                  
 a.feclle11 FechaArribo,                                                  
 (case b.codbol03 when 'MT' then 'VACIO' ELSE 'LLENO' end ) as condición,                                                  
 (b.codcon04) NRO_CTRS,                                                  
 (case isnull(b.codimo13,'') when '' then 0 ELSE 1 END) AS CARGAPELIGROSA        
 ,a.tipope11 FlagImpoExpo,a.navvia11  NaveViaje                      
 ,CASE b.FLGSTA04 WHEN '0' THEN 1 WHEN '1' THEN 0 END AS estadoRegistro,      
 d.desnav08                 
 from DDCABMAN11 a (nolock)                                                   
 INNER JOIN DDCONTEN04 b (nolock)  ON a.navvia11=b.navvia11                                                  
 inner join DVCABCON18 d (nolock) ON a.navvia11=d.navvia11              
        
 WHERE                                                   
 a.TIPOPE11='D' and                                                  
 feclle11 >=@Fecha and                                     
 b.sucursal in ('1','2','3','4') -- 2:CONTENEDORES VACIOS                      
 and b.FLGSTA04 ='1'  AND b.FLGDES04 ='0'   -- Filtros para solo Neptunia                                             
 AND b.codbol03<>'MT'        
 --and a.codnav08='WEEX'        
 --group by a.codnav08,a.numvia11,a.ptoori11,a.numman11,a.anyman11,a.feclle11,b.codbol03,a.TIPOPE11,a.navvia11,d.desnav08             
 ) tb                                                  
 group by Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,FlagImpoExpo,NaveViaje,estadoRegistro,desnav08              
        
        
-------------------------------------------------------                                      
 ) tb                                                  
 group by Interface,Nave,NumViaje,Origen,NroManifiesto,AnioManifiesto,FechaArribo,FlagImpoExpo,NaveViaje,EstadoRegistro,desnav08      
                                    
end 