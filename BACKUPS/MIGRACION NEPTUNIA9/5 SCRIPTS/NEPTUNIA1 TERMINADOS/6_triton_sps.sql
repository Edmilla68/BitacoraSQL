----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER FUNCTION dbo.fn_ListaDetFact      
                                                                                                                                                                                                                    
(@NroFactura varchar(10))            
                                                                                                                                                                                                                        
returns table        
                                                                                                                                                                                                                                        
as           
                                                                                                                                                                                                                                                
return      
                                                                                                                                                                                                                                                 
(select         
                                                                                                                                                                                                                                             
--e.codcco06,        
                                                                                                                                                                                                                                        
a.cantid01 as Cantidad, a.preuni01,       
                                                                                                                                                                                                                   
a.cantid01 * a.preuni01 as subTotal, b.nropla01, b.brevet01,       
                                                                                                                                                                                          
(select codtam01 from DDGUITTR01 where nrogui01 = b.nrogui01 group by codtam01) as codtam01,          
                                                                                                                                                       
codrut01, kilometros as Kilometros, d.desrut01,          
                                                                                                                                                                                                    
convert(varchar(3),h.dc_centro_costo) as centroCosto, cencos01 as codultra          
                                                                                                                                                                         
from dbo.DDFACTTR01 as a           
                                                                                                                                                                                                                          
inner join dbo.DCGUITTR01 as b on a.nrodet01 = b.nrodet01           
                                                                                                                                                                                         
inner join dbo.CQCIRCUI01 as d on b.idcircuito = d.idcircuito          
                                                                                                                                                                                      
left join terminal.dbo.ddcabman11 as e on b.navvia11 = e.navvia11          
                                                                                                                                                                                  
--left join dbo.DDGUITTR01 as c on b.nrogui01 = c.nrogui01          
                                                                                                                                                                                         
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                    
                                                                                                                                                                         
on substring(b.nropla01,1,2)+'-'+substring(b.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS      
                                                                                                                        
or substring(b.nropla01,1,3)+'-'+substring(b.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS                    
                                                                                                         
where nrofac01 = @NroFactura --'0010055184'       
                                                                                                                                                                                                           
)                                                                                                                                                                                                                                                              
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER FUNCTION dbo.fn_ListaDetFact_OFISIS ()          
                                                                                                                                                                                                      
returns table                
                                                                                                                                                                                                                                
as                   
                                                                                                                                                                                                                                        
return           
                                                                                                                                                                                                                                            
(select a.nrofac01 factura,   
                                                                                                                                                                                                                               
  m.ruccli01,   
                                                                                                                                                                                                                                             
  m.fecemi01,   
                                                                                                                                                                                                                                             
  m.tipdoc01,          
                                                                                                                                                                                                                                      
  a.cantid01 as Cantidad,   
                                                                                                                                                                                                                                 
  a.preuni01,               
                                                                                                                                                                                                                                 
  a.cantid01 * a.preuni01 as subTotal,   
                                                                                                                                                                                                                    
  b.nropla01,   
                                                                                                                                                                                                                                             
  b.brevet01,               
                                                                                                                                                                                                                                 
  (select codtam01 from DDGUITTR01 where nrogui01 = b.nrogui01 group by codtam01) as codtam01,                  
                                                                                                                                             
  codrut01,   
                                                                                                                                                                                                                                               
  kilometros as Kilometros,   
                                                                                                                                                                                                                               
  d.desrut01,                  
                                                                                                                                                                                                                              
  convert(varchar(3),h.dc_centro_costo) as centroCosto,   
                                                                                                                                                                                                   
  cencos01 as codultra                  
                                                                                                                                                                                                                     
from dbo.DDFACTTR01 as a           
                                                                                                                                                                                                                          
inner join  dbo.DcFACTTR01 as m on ( a.nrofac01 = m.nrofac01  and a.tipdoc01=m.tipdoc01 and a.idconta01=m.idconta01)                
                                                                                                                         
left join dbo.DCGUITTR01 as b on a.nrodet01 = b.nrodet01                   
                                                                                                                                                                                  
left join dbo.CQCIRCUI01 as d on b.idcircuito = d.idcircuito                  
                                                                                                                                                                               
left join terminal.dbo.ddcabman11 as e on b.navvia11 = e.navvia11                  
                                                                                                                                                                          
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                            
                                                                                                                                                                 
on substring(b.nropla01,1,2)+'-'+substring(b.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                            
                                                                                                  
or substring(b.nropla01,1,3)+'-'+substring(b.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS  
                                                                                                                           
where m.fecemi01>='20090101'            
                                                                                                                                                                                                                     
and m.fecemi01<='20091031'       
                                                                                                                                                                                                                            
AND m.flages01 <> 'A'     
                                                                                                                                                                                                                                   
and a.tipser01 = 'T'  -- agregado ultimo   
                                                                                                                                                                                                                  
)     
                                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
union   
                                                                                                                                                                                                                                                     
  
                                                                                                                                                                                                                                                           
select a.nrofac01 factura,  
                                                                                                                                                                                                                                 
  m.ruccli01,  
                                                                                                                                                                                                                                              
  m.fecemi01,      
                                                                                                                                                                                                                                          
  m.tipdoc01,                            
                                                                                                                                                                                                                    
  a.cantid01 as Cantidad,                        
                                                                                                                                                                                                            
  a.preuni01,                                           
                                                                                                                                                                                                     
  a.cantid01 * a.preuni01 as SubTotal,    
                                                                                                                                                                                                                   
  '' as nropla01,                      
                                                                                                                                                                                                                      
  '' as brevet01,                  
                                                                                                                                                                                                                          
  0 as codtam01,                        
                                                                                                                                                                                                                     
  '' as codrut01,                        
                                                                                                                                                                                                                    
  0 as kilometros,   
                                                                                                                                                                                                                                        
  '' as desrut01,  
                                                                                                                                                                                                                                          
  case when a.tipser01 = 'S' then f.cod_tipo_comb                      
                                                                                                                                                                                      
    else '0' end as centrocosto,     
                                                                                                                                                                                                                        
  case when d.idtikets is null then b.cod_ultra                           
                                                                                                                                                                                   
    when d.idtikets is not null then f.cod_ultra  end as codultra                      
                                                                                                                                                                      
from DDFACTTR01 as a   
                                                                                                                                                                                                                                      
inner join  dbo.DcFACTTR01 as m on ( a.nrofac01 = m.nrofac01  and a.tipdoc01=m.tipdoc01 and a.idconta01=m.idconta01)                
                                                                                                                         
inner join TQTIPSER01 as b ON a.tipser01 = b.tipser01           
                                                                                                                                                                                             
left join TQTIKETS AS d on a.nrodet01 = d.nrofactu           
                                                                                                                                                                                                
left join TQCOMBUS as f on d.idcombus = f.idcombus                    
                                                                                                                                                                                       
where m.fecemi01>='20090101'            
                                                                                                                                                                                                                     
and m.fecemi01<='20091031'       
                                                                                                                                                                                                                            
AND m.flages01 <> 'A'     
                                                                                                                                                                                                                                   
and a.tipser01 <> 'T'                                                                                                                                                                                                                                          
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  Listar_DetFacturaByNroFac                  
                                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
@nrofac01 char(10),                  
                                                                                                                                                                                                                        
    
                                                                                                                                                                                                                                                         
@tipdoc01 char(2),                  
                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
@idconta01 int                  
                                                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
as                  
                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
        
                                                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                         
select a.nrodet01,                   
                                                                                                                                                                                                                        
    
                                                                                                                                                                                                                                                         
a.cantid01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.preuni01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.tipser01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.desart01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.cantid01 * a.preuni01 as Total,                  
                                                                                                                                                                                                          
    
                                                                                                                                                                                                                                                         
b.descri01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
c.nrogui01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
c.idcircuito,            
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
d.idtikets,                
                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
h.dc_tipo_identificacion_bien as nropla01,                
                                                                                                                                                                                                   
    
                                                                                                                                                                                                                                                         
c.brevet01,            
                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
g.kilometros,            
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
g.codrut01,            
                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
c.codcco06,               
                                                                                                                                                                                                                                   
    
                                                                                                                                                                                                                                                         
case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra                  
                                                                                                                                                                       
    
                                                                                                                                                                                                                                                         
     when d.idtikets is not null then f.cod_ultra                  
                                                                                                                                                                                          
    
                                                                                                                                                                                                                                                         
     when c.nrogui01 is not null then g.cencos01 end as cod_ultra,         
                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
case when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)    
                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
     when a.tipser01 = 'S' then f.cod_tipo_comb            
                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
     else '0' end as centrocosto,            
                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
        
                                                                                                                                                                                                                                                     
case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)            
                                                                                                                                              
    
                                                                                                                                                                                                                                                         
     else 0 end as codtam01,             
                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)            
                                                                                                                                             
    
                                                                                                                                                                                                                                                         
     else 0 end as cantidad             
                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
from DDFACTTR01 as a inner join TQTIPSER01 as b                 
                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
ON a.tipser01 = b.tipser01     
                                                                                                                                                                                                                              
    
                                                                                                                                                                                                                                                         
left join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01     
                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
left join TQTIKETS AS d on a.nrodet01 = d.nrofactu     
                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
--left join TQPRECOMB as e on d.idprecio  =  e.idprecio      
                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
left join TQCOMBUS as f on d.idcombus = f.idcombus              
                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
left join cqcircui01 as g on c.idcircuito = g.idcircuito            
                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h            
                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS            
                                                                                                                  
    
                                                                                                                                                                                                                                                         
where  a.idconta01 = @idconta01             
                                                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01                 
                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
return 0            
                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  [dbo].[Listar_DetFacturaByNroFac_Optimizado]  
                                                                                                                                                                                              
@nrofac01 char(10),                    
                                                                                                                                                                                                                      
@tipdoc01 char(2),                    
                                                                                                                                                                                                                       
@idconta01 int                    
                                                                                                                                                                                                                           
      
                                                                                                                                                                                                                                                       
as              
                                                                                                                                                                                                                                             
  
                                                                                                                                                                                                                                                           
Declare @TipoServicio char(1)  
                                                                                                                                                                                                                              
  
                                                                                                                                                                                                                                                           
set @TipoServicio = (select top 1 tipser01 from DDFACTTR01  
                                                                                                                                                                                                 
where  idconta01 = @idconta01                      
                                                                                                                                                                                                          
and tipdoc01 = @tipdoc01 and  nrofac01 = @nrofac01)  
                                                                                                                                                                                                        
     
                                                                                                                                                                                                                                                        
if @TipoServicio = 'T'  
                                                                                                                                                                                                                                     
begin  
                                                                                                                                                                                                                                                      
select a.nrodet01,                     
                                                                                                                                                                                                                      
a.cantid01,                    
                                                                                                                                                                                                                              
a.preuni01,                    
                                                                                                                                                                                                                              
a.tipser01,                    
                                                                                                                                                                                                                              
a.desart01,                    
                                                                                                                                                                                                                              
a.cantid01 * a.preuni01 as Total,                    
                                                                                                                                                                                                        
b.descri01,                    
                                                                                                                                                                                                                              
c.nrogui01,                    
                                                                                                                                                                                                                              
c.idcircuito,              
                                                                                                                                                                                                                                  
'' as idtikets,                  
                                                                                                                                                                                                                            
h.dc_tipo_identificacion_bien as nropla01,                  
                                                                                                                                                                                                 
c.brevet01,              
                                                                                                                                                                                                                                    
g.kilometros,              
                                                                                                                                                                                                                                  
g.codrut01,              
                                                                                                                                                                                                                                    
c.codcco06,                 
                                                                                                                                                                                                                                 
  
                                                                                                                                                                                                                                                           
/*case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra                    
                                                                                                                                                                   
     when d.idtikets is not null then f.cod_ultra                    
                                                                                                                                                                                        
     when c.nrogui01 is not null then g.cencos01 end as cod_ultra,           
                                                                                                                                                                                
*/  
                                                                                                                                                                                                                                                         
g.cencos01  as cod_ultra,           
                                                                                                                                                                                                                         
convert(varchar(3),h.dc_centro_costo)  as centrocosto,  
                                                                                                                                                                                                     
/*case when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)      
                                                                                                                                                                                
     when a.tipser01 = 'S' then f.cod_tipo_comb              
                                                                                                                                                                                                
     else '0' end as centrocosto,              
                                                                                                                                                                                                              
*/  
                                                                                                                                                                                                                                                         
x.codtam01,  
                                                                                                                                                                                                                                                
count(c.nrogui01) as cantidad,  
                                                                                                                                                                                                                             
a.ctrCostoOtros /*case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)              
                                                                                                                          
     else 0 end as codtam01               
                                                                                                                                                                                                                   
case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)              
                                                                                                                                           
     else 0 end as cantidad             */  
                                                                                                                                                                                                                 
from DDFACTTR01 as a inner join TQTIPSER01 as b                   
                                                                                                                                                                                           
ON a.tipser01 = b.tipser01       
                                                                                                                                                                                                                            
inner join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01    
                                                                                                                                                                                                    
left join DDGUITTR01 as x on c.nrogui01 = x.nrogui01     
                                                                                                                                                                                                    
--left join TQTIKETS AS d on a.nrodet01 = d.nrofactu       
                                                                                                                                                                                                  
--left join TQCOMBUS as f on d.idcombus = f.idcombus                
                                                                                                                                                                                         
inner join cqcircui01 as g on c.idcircuito = g.idcircuito              
                                                                                                                                                                                      
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h              
                                                                                                                                                                              
on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS              
                                                                                                                
or substring(c.nropla01,1,3)+'-'+substring(c.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                         
where  a.idconta01 = @idconta01                      
                                                                                                                                                                                                        
and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01      
                                                                                                                                                                                                 
  
                                                                                                                                                                                                                                                           
/*where  a.idconta01 = '1'               
                                                                                                                                                                                                                    
and a.tipdoc01 = '01' and  a.nrofac01 = '0010061338'    
                                                                                                                                                                                                     
*/  
                                                                                                                                                                                                                                                         
  
                                                                                                                                                                                                                                                           
group by   
                                                                                                                                                                                                                                                  
a.nrodet01,                     
                                                                                                                                                                                                                             
a.cantid01,                    
                                                                                                                                                                                                                              
a.preuni01,                    
                                                                                                                                                                                                                              
a.tipser01,                    
                                                                                                                                                                                                                              
a.desart01,                    
                                                                                                                                                                                                                              
a.cantid01,  
                                                                                                                                                                                                                                                
a.preuni01 ,                    
                                                                                                                                                                                                                             
b.descri01,                    
                                                                                                                                                                                                                              
c.nrogui01,                    
                                                                                                                                                                                                                              
c.idcircuito,              
                                                                                                                                                                                                                                  
--d.idtikets,                  
                                                                                                                                                                                                                              
h.dc_tipo_identificacion_bien ,                  
                                                                                                                                                                                                            
c.brevet01,              
                                                                                                                                                                                                                                    
g.kilometros,              
                                                                                                                                                                                                                                  
g.codrut01,              
                                                                                                                                                                                                                                    
c.codcco06,          
                                                                                                                                                                                                                                        
g.cencos01,  
                                                                                                                                                                                                                                                
convert(varchar(3),h.dc_centro_costo),  
                                                                                                                                                                                                                     
x.codtam01,  
                                                                                                                                                                                                                                                
a.ctrCostoOtros  
                                                                                                                                                                                                                                            
end  
                                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
else  
                                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
begin   
                                                                                                                                                                                                                                                     
        
                                                                                                                                                                                                                                                     
select a.nrodet01,                             
                                                                                                                                                                                                              
a.cantid01,                      
                                                                                                                                                                                                                            
a.preuni01,                      
                                                                                                                                                                                                                            
a.tipser01,                      
                                                                                                                                                                                                                            
a.desart01,                      
                                                                                                                                                                                                                            
a.cantid01 * a.preuni01 as Total,                      
                                                                                                                                                                                                      
b.descri01,                      
                                                                                                                                                                                                                            
'' as nrogui01,                      
                                                                                                                                                                                                                        
'' as idcircuito,                
                                                                                                                                                                                                                            
d.idtikets,                    
                                                                                                                                                                                                                              
'' as nropla01,             
                                                                                                                                                                                                                                 
'' as brevet01,                
                                                                                                                                                                                                                              
'' as kilometros,                
                                                                                                                                                                                                                            
'' as codrut01,                      
                                                                                                                                                                                                                        
'' as codcco06,                   
                                                                                                                                                                                                                           
--case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra,      
                                                                                                                                                                                
case when d.idtikets is null then b.cod_ultra                         
                                                                                                                                                                                       
     when d.idtikets is not null then f.cod_ultra  end as cod_ultra,   
                                                                                                                                                                                      
--when c.nrogui01 is not null then g.cencos01 end as cod_ultra,             
                                                                                                                                                                                 
        
                                                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                         
--when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)            
                                                                                                                                                                               
case when a.tipser01 = 'S' then f.cod_tipo_comb                    
                                                                                                                                                                                          
     else '0' end as centrocosto,                
                                                                                                                                                                                                            
        
                                                                                                                                                                                                                                                     
            
                                                                                                                                                                                                                                                 
/*case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)                
                                                                                                                                        
     else 0 end as codtam01,                       
                                                                                                                                                                                                          
case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)                
                                                                                                                                         
     else 0 end as cantidad               */  
                                                                                                                                                                                                               
  
                                                                                                                                                                                                                                                           
0 as codtam01,  
                                                                                                                                                                                                                                             
0 as cantidad ,  
                                                                                                                                                                                                                                            
a.ctrCostoOtros        
                                                                                                                                                                                                                                      
from DDFACTTR01 as a inner join TQTIPSER01 as b                     
                                                                                                                                                                                         
ON a.tipser01 = b.tipser01         
                                                                                                                                                                                                                          
--left join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01         
                                                                                                                                                                                              
left join TQTIKETS AS d on a.nrodet01 = d.nrofactu         
                                                                                                                                                                                                  
--left join TQPRECOMB as e on d.idprecio  =  e.idprecio          
                                                                                                                                                                                            
left join TQCOMBUS as f on d.idcombus = f.idcombus                  
                                                                                                                                                                                         
--left join cqcircui01 as g on c.idcircuito = g.idcircuito                
                                                                                                                                                                                   
--left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                      
                                                                                                                                                                     
--on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                      
                                                                                                      
  
                                                                                                                                                                                                                                                           
where  a.idconta01 = @idconta01                      
                                                                                                                                                                                                        
and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01                     
                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                           
end  
                                                                                                                                                                                                                                                        
   
                                                                                                                                                                                                                                                          
return 0              
                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Insertar_Lista_GuiaByRucCircuitoMan  
                                                                                                                                                                                                    
@client01 char(11),                          
                                                                                                                                                                                                                
@idcircuito int,                      
                                                                                                                                                                                                                       
@fecini char(8),                      
                                                                                                                                                                                                                       
@fecfin char(8),                  
                                                                                                                                                                                                                           
@horaIni char(8),                  
                                                                                                                                                                                                                          
@horaFin char(8),  
                                                                                                                                                                                                                                          
@Moneda char(1),  
                                                                                                                                                                                                                                           
@Usuario varchar(30)                      
                                                                                                                                                                                                                   
  
                                                                                                                                                                                                                                                           
as                                
                                                                                                                                                                                                                           
/*  
                                                                                                                                                                                                                                                         
set @client01 = '20100010217'                 
                                                                                                                                                                                                               
set @idcircuito = '127'                    
                                                                                                                                                                                                                  
set @fecini = '20080901'                    
                                                                                                                                                                                                                 
set @fecfin = '20080930'             
                                                                                                                                                                                                                        
set @horaIni = '00:00:00'  
                                                                                                                                                                                                                                  
set @horaFin = '00:00:00'  
                                                                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                           
*/  
                                                                                                                                                                                                                                                         
  
                                                                                                                                                                                                                                                           
delete from ListaCircuitoManual  
                                                                                                                                                                                                                            
where Usuario = @Usuario  
                                                                                                                                                                                                                                   
  
                                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           
Insert into ListaCircuitoManual             
                                                                                                                                                                                                                 
select                       
                                                                                                                                                                                                                                
A.nrogui01,                          
                                                                                                                                                                                                                        
A.Nropla01,                        
                                                                                                                                                                                                                          
A.Brevet01,                        
                                                                                                                                                                                                                          
convert(varchar(10), A.fecgen01, 103) as fecgen01,                       
                                                                                                                                                                                    
A.codnav08,                      
                                                                                                                                                                                                                            
A.navvia11,                       
                                                                                                                                                                                                                           
B.desrut01,                       
                                                                                                                                                                                                                           
B.codrut01,                       
                                                                                                                                                                                                                           
isnull(g.codtam01, '') as codtam01,                  
                                                                                                                                                                                                        
/*Count (a.nrogui01) as cantidad,                
                                                                                                                                                                                                            
case when a.flagvicon = 'S' then precioCir                      
                                                                                                                                                                                             
     when a.flagvicon = 'N' and Count (a.nrogui01)= 0 then precioCir                       
                                                                                                                                                                  
     when a.flagvicon = 'N' and Count (a.nrogui01)> 0 then precioCir * Count (a.nrogui01)                      
                                                                                                                                              
     end as tarifa,                         
                                                                                                                                                                                                                 
*/  
                                                                                                                                                                                                                                                         
a.flagvicon,  
                                                                                                                                                                                                                                               
e.numvia11,      -- '' as numvia11,   
                                                                                                                                                                                                                       
f.dc_centro_costo as centroCosto,                      
                                                                                                                                                                                                      
f.dc_tipo_identificacion_bien,                      
                                                                                                                                                                                                         
a.codcco06,  
                                                                                                                                                                                                                                                
  
                                                                                                                                                                                                                                                           
case when a.flagvicon = 'S' and g.codtam01 = '40' then g.codcon01  
                                                                                                                                                                                          
     when a.flagvicon = 'S' and g.codtam01 <> '40' then ''  
                                                                                                                                                                                                 
     when a.flagvicon = 'N' then g.codcon01 end as codcon01,   
                                                                                                                                                                                              
@Usuario,  
                                                                                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                           
case when @Moneda = 'S' then precioCir_S  
                                                                                                                                                                                                                   
     else precioCir end precioCir  
                                                                                                                                                                                                                          
  
                                                                                                                                                                                                                                                           
from DCGUITTR01 as A (NOLOCK)            
                                                                                                                                                                                                                    
left join DDGUITTR01 as G (nolock) on (A.nrogui01=g.nrogui01)              
                                                                                                                                                                                  
inner join CQCIRCUI01 as B (NOLOCK) on A.idcircuito = B.idcircuito                      
                                                                                                                                                                     
left join  TERMINAL.DBO.DDCABMAN11 AS E (NOLOCK) on a.navvia11 = e.navvia11                      
                                                                                                                                                            
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f                      
                                                                                                                                                                      
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS       
                                                                                                                       
or substring(a.nropla01,1,3)+'-'+substring(a.nropla01,4,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                       
                                                                                                       
where A.nrodet01 is null                      
                                                                                                                                                                                                               
and A.client01 = @client01                          
                                                                                                                                                                                                         
and a.idcircuito = @idcircuito                      
                                                                                                                                                                                                         
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)                  
                                                                                                                                                                           
and convert(datetime, @fecfin + ' ' + @horaFin)                  
                                                                                                                                                                                            
return 0                                                                                                                                                                                                                                                       
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Listar_GuiaByRucCircuitoCont            
                                                                                                                                                                                                 
@client01 char(11),                
                                                                                                                                                                                                                          
@idcircuito int,            
                                                                                                                                                                                                                                 
@fecini char(8),            
                                                                                                                                                                                                                                 
@fecfin char(8),            
                                                                                                                                                                                                                                 
@horaIni char(8),    
                                                                                                                                                                                                                                        
@horaFin char(8)    
                                                                                                                                                                                                                                         
as                
                                                                                                                                                                                                                                           
select             
                                                                                                                                                                                                                                          
A.nrogui01,                
                                                                                                                                                                                                                                  
A.Nropla01,              
                                                                                                                                                                                                                                    
A.Brevet01,              
                                                                                                                                                                                                                                    
convert(varchar(10), A.fecgen01, 103) as fecgen01,             
                                                                                                                                                                                              
A.codnav08,            
                                                                                                                                                                                                                                      
A.navvia11,             
                                                                                                                                                                                                                                     
B.desrut01,             
                                                                                                                                                                                                                                     
B.codrut01,             
                                                                                                                                                                                                                                     
D.codtam01,            
                                                                                                                                                                                                                                      
--dbo.fn_CantContxViaje(A.nrogui01) as cantidad,            
                                                                                                                                                                                                 
1 as cantidad,      
                                                                                                                                                                                                                                         
case when c.flagCirViaje = 1 then            
                                                                                                                                                                                                                
     (case when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20                
                                                                                                                                                  
           when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40                
                                                                                                                                                  
           when D.codtam01 = 40 then  c.tarifa40 end)            
                                                                                                                                                                                            
           when c.flagCirViaje = 0 then            
                                                                                                                                                                                                          
     (case when D.codtam01 = 20 then  c.tarifa20                
                                                                                                                                                                                             
           when D.codtam01 = 40 then  c.tarifa40 end)            
                                                                                                                                                                                            
           end as tarifa,               
                                                                                                                                                                                                                     
e.numvia11,            
                                                                                                                                                                                                                                      
f.dc_centro_costo as centroCosto,            
                                                                                                                                                                                                                
f.dc_tipo_identificacion_bien,            
                                                                                                                                                                                                                   
a.codcco06,     
                                                                                                                                                                                                                                             
d.codcon01,
                                                                                                                                                                                                                                                  
case when c.flagCirViaje = 1 then            
                                                                                                                                                                                                                
     (case when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20_S
                                                                                                                                                                
           when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40_S
                                                                                                                                                                
           when D.codtam01 = 40 then  c.tarifa40_S end)            
                                                                                                                                                                                          
           when c.flagCirViaje = 0 then            
                                                                                                                                                                                                          
     (case when D.codtam01 = 20 then  c.tarifa20_S                
                                                                                                                                                                                           
           when D.codtam01 = 40 then  c.tarifa40_S end)            
                                                                                                                                                                                          
           end as tarifa_S                 
                                                                                                                                                                                                                  
from DCGUITTR01 as A (nolock) inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito            
                                                                                                                                                          
inner join CQTARCIR01 AS C (nolock)  ON c.idcircuito = b.idcircuito--a.idtarifa = c.idtarifa            
                                                                                                                                                     
inner join DDGUITTR01 AS d (nolock)  on A.nrogui01 = d.NroGui01                 
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f            
                                                                                                                                                                                
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS            
                                                                                                                  
left join TERMINAL.DBO.DDCABMAN11 AS E on a.navvia11 = e.navvia11            
                                                                                                                                                                                
where A.nrodet01 is null     
                                                                                                                                                                                                                                
and A.client01 = @client01     
                                                                                                                                                                                                                              
and a.idcircuito = @idcircuito
                                                                                                                                                                                                                               
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)    
                                                                                                                                                                                         
and convert(datetime, @fecfin + ' ' + @horaFin)   
                                                                                                                                                                                                           
and c.fecreg = (select max(fecreg) from cqtarcir01 where idcircuito = @idcircuito )         
                                                                                                                                                                 
order by             
                                                                                                                                                                                                                                        
A.codnav08,            
                                                                                                                                                                                                                                      
A.navvia11,    
                                                                                                                                                                                                                                              
d.codcon01   
                                                                                                                                                                                                                                                

                                                                                                                                                                                                                                                             
/**
                                                                                                                                                                                                                                                          
from DCGUITTR01 as A (nolock) inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito            
                                                                                                                                                          
inner join CQTARCIR01 AS C (nolock)  ON a.idtarifa = c.idtarifa            
                                                                                                                                                                                  
inner join DDGUITTR01 AS d (nolock)  on A.nrogui01 = d.NroGui01                 
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f            
                                                                                                                                                                                
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS            
                                                                                                                  
left join TERMINAL.DBO.DDCABMAN11 AS E on a.navvia11 = e.navvia11            
                                                                                                                                                                                
where A.nrodet01 is null     
                                                                                                                                                                                                                                
and A.client01 = @client01     
                                                                                                                                                                                                                              
and a.idcircuito = @idcircuito            
                                                                                                                                                                                                                   
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)    
                                                                                                                                                                                         
and convert(datetime, @fecfin + ' ' + @horaFin)    
                                                                                                                                                                                                          
order by             
                                                                                                                                                                                                                                        
A.codnav08,            
                                                                                                                                                                                                                                      
A.navvia11,    
                                                                                                                                                                                                                                              
d.codcon01  
                                                                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
*/
                                                                                                                                                                                                                                                           
   
                                                                                                                                                                                                                                                          
return 0
                                                                                                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Listar_GuiaByRucCircuitoViaje              
                                                                                                                                                                                              
@client01 char(11),                  
                                                                                                                                                                                                                        
@idcircuito int,              
                                                                                                                                                                                                                               
@fecini char(8),              
                                                                                                                                                                                                                               
@fecfin char(8),              
                                                                                                                                                                                                                               
@horaIni char(8),    
                                                                                                                                                                                                                                        
@horaFin char(8)    
                                                                                                                                                                                                                                         
as                 
                                                                                                                                                                                                                                          
if @idcircuito=130
                                                                                                                                                                                                                                           
begin
                                                                                                                                                                                                                                                        
select               
                                                                                                                                                                                                                                        
A.nrogui01,                  
                                                                                                                                                                                                                                
A.Nropla01,                
                                                                                                                                                                                                                                  
A.Brevet01,                
                                                                                                                                                                                                                                  
convert(varchar(10), A.fecgen01, 103) as fecgen01,               
                                                                                                                                                                                            
A.codnav08,              
                                                                                                                                                                                                                                    
A.navvia11,               
                                                                                                                                                                                                                                   
B.desrut01,               
                                                                                                                                                                                                                                   
B.codrut01, 
                                                                                                                                                                                                                                                 
'' as codtam01,           
                                                                                                                                                                                                                                   
1 as cantidad,     
                                                                                                                                                                                                                                          
c.tarifa20 as tarifa,                  
                                                                                                                                                                                                                      
D.numvia11,              
                                                                                                                                                                                                                                    
e.dc_centro_costo as centroCosto,              
                                                                                                                                                                                                              
--dbo.fn_CantContxViajeTam (A.nrogui01) as codtam01,                            
                                                                                                                                                                             
--count(g.nrogui01) as cantidad,          
                                                                                                                                                                                                                   
--g.codtam01,          
                                                                                                                                                                                                                                      
e.dc_tipo_identificacion_bien,              
                                                                                                                                                                                                                 
a.codcco06,    
                                                                                                                                                                                                                                              
g.codcon01
                                                                                                                                                                                                                                                   
from DCGUITTR01 as A inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito              
                                                                                                                                                                 
inner join CQTARCIR01 AS C ON a.idtarifa = c.idtarifa              
                                                                                                                                                                                          
left join  TERMINAL.DBO.DDCABMAN11 AS D on a.navvia11 = d.navvia11              
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as e              
                                                                                                                                                                              
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = e.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS              
                                                                                                                
--left join DDGUITTR01 as g on A.nrogui01 = g.nrogui01          
                                                                                                                                                                                             
inner join DDGUITTR01 as G (nolock) on (A.nrogui01=g.nrogui01)
                                                                                                                                                                                               
where A.nrodet01 is null              
                                                                                                                                                                                                                       
and A.client01 = @client01                  
                                                                                                                                                                                                                 
and A.idcircuito = @idcircuito              
                                                                                                                                                                                                                 
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)    
                                                                                                                                                                                         
and convert(datetime, @fecfin + ' ' + @horaFin)     --@fecini and @fecfin              
                                                                                                                                                                      
order by A.codnav08, A.navvia11        
                                                                                                                                                                                                                      
end
                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
if @idcircuito<>130
                                                                                                                                                                                                                                          
begin
                                                                                                                                                                                                                                                        
select               
                                                                                                                                                                                                                                        
A.nrogui01,                  
                                                                                                                                                                                                                                
A.Nropla01,                
                                                                                                                                                                                                                                  
A.Brevet01,                
                                                                                                                                                                                                                                  
convert(varchar(10), A.fecgen01, 103) as fecgen01,               
                                                                                                                                                                                            
A.codnav08,              
                                                                                                                                                                                                                                    
A.navvia11,               
                                                                                                                                                                                                                                   
B.desrut01,               
                                                                                                                                                                                                                                   
B.codrut01, 
                                                                                                                                                                                                                                                 
'' as codtam01,           
                                                                                                                                                                                                                                   
1 as cantidad,     
                                                                                                                                                                                                                                          
c.tarifa20 as tarifa,                  
                                                                                                                                                                                                                      
D.numvia11,              
                                                                                                                                                                                                                                    
e.dc_centro_costo as centroCosto,              
                                                                                                                                                                                                              
--dbo.fn_CantContxViajeTam (A.nrogui01) as codtam01,                            
                                                                                                                                                                             
--count(g.nrogui01) as cantidad,          
                                                                                                                                                                                                                   
--g.codtam01,          
                                                                                                                                                                                                                                      
e.dc_tipo_identificacion_bien,              
                                                                                                                                                                                                                 
a.codcco06,    
                                                                                                                                                                                                                                              
'' as codcon01
                                                                                                                                                                                                                                               
from DCGUITTR01 as A inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito              
                                                                                                                                                                 
inner join CQTARCIR01 AS C ON a.idtarifa = c.idtarifa              
                                                                                                                                                                                          
left join  TERMINAL.DBO.DDCABMAN11 AS D on a.navvia11 = d.navvia11              
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as e              
                                                                                                                                                                              
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = e.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS              
                                                                                                                
--left join DDGUITTR01 as g on A.nrogui01 = g.nrogui01          
                                                                                                                                                                                             
where A.nrodet01 is null              
                                                                                                                                                                                                                       
and A.client01 = @client01                  
                                                                                                                                                                                                                 
and A.idcircuito = @idcircuito              
                                                                                                                                                                                                                 
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)    
                                                                                                                                                                                         
and convert(datetime, @fecfin + ' ' + @horaFin)     --@fecini and @fecfin              
                                                                                                                                                                      
order by A.codnav08, A.navvia11        
                                                                                                                                                                                                                      
end
                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
return 0            
                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Listar_itemgastosUltragstion
                                                                                                                                                                                                             
@Periodo char(6)
                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
select dc_periodo, 
                                                                                                                                                                                                                                          
dc_tipo_identificacion_bien, 
                                                                                                                                                                                                                                
dg_item_gasto, 
                                                                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor,
                                                                                                                                                                                                                                             
dc_sucursal_imputacion, 
                                                                                                                                                                                                                                     
dc_centro_costo_imputacion, 
                                                                                                                                                                                                                                 
dg_razon_social, dg_centro_Costo, 
                                                                                                                                                                                                                           
dg_sucursal
                                                                                                                                                                                                                                                  
from NPT9_bd_trit.dbo.tb_mov_aux_MANT as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_MAN1 as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_proveedor = c.dc_rut
                                                                                                                                                                            
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                  
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                    
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_comb as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                    
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_MARE as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_SERT as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_proveedor = c.dc_rut
                                                                                                                                                                            
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                  
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
order by dc_periodo
                                                                                                                                                                                                                                          
