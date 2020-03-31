CREATE  procedure sp_Consultar_OrdenSerByNroOrdFactura                                      
@Id_Orden int                                            
as                                            
declare @Afecto numeric (12,2)                                    
declare @Inafecto numeric (12,2)                                    
declare @TotalValref numeric (12,2)      
                                    
select @afecto = sum(Tarifa * Cantidad)                                    
from ddordfac01                                    
where AfectoIgv = 1 and                                    
Id_Orden = @Id_Orden                                        
                                    
select @inafecto = sum(Tarifa * Cantidad)                                    
from ddordfac01                                    
where AfectoIgv = 0 and                                    
Id_Orden = @Id_Orden                                        
      
select @TotalValref  = sum (case when tamanocntr = 1 then (round(cantidad/2, 0) *171.07)      
                                 when tamanocntr = 2 then (cantidad *171.07) end )      
from dcordfac01 as a inner join EQESTADOS as b on a.estado = b.estado                                       
inner join ddordfac01 AS d on a.id_orden = d.Id_orden                                       
where a.Id_Orden = @Id_Orden                                        
                                    
select                                            
a.moneda,                                              
a.NumeroDoc,                                              
a.FechaDoc,                                              
a.Observaciones,                                              
a.NroRef,                                            
a.FecRef,                                            
a.RucConsignatario,                                          
a.Direccion,                                          
a.Impuesto,                                      
a.Total,                                      
c.nombre,                                      
d.Descripcion,                                      
d.Tarifa,                                      
d.Cantidad,                                      
d.Tarifa * d.Cantidad as TotalSer,                                      
d.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                                      
d.AfectoIgv,                                      
d.CodigoNave,                                      
f.desnav08,                                      
d.NaveViaje,                                      
g.numvia11,                                      
d.Sucursal,                                      
d.CentroCosto,                                      
d.TamanoCntr,                                      
h.dg_servicio,                                      
i.dg_tipo_tamano_contenedor,                                      
e.NumeroCntr,                                         
d.Id_Servicio,                              
isnull(@inafecto, 0) as sumInafecto,                                    
isnull(@afecto, 0) as SumAfecto,                            
g.tipope11,                          
d.desviaje,                        
j.descrip,                 
--Porcentaje,                    
a.flagRefac,                    
a.NroNC,                   
                
--a.Retraccion                  
                
case when a.idglosa is null then a.Retraccion                
     when a.Retraccion <> 0 then a.retraccion              
     when a.Retraccion = 0 then j.detrac end Retraccion,              
                       
case when a.idglosa is null then a.Porcentaje                
     when j.detrac = 0 then a.Porcentaje                 
     when j.detrac = 1 then 12 end as Porcentaje,                       
            
case when @afecto is not null and a.moneda = 1 then @afecto            
     when @afecto is not null and a.moneda = 2 then @afecto * a.TipoCambio             
     else 0 end TotalSoles,      
            
k.montoreferencial,            
k.FlgTra,           
ISNULL(d.Unidad, '') as Unidad,      
@TotalValref as TotalValref      
               
from dcordfac01 as a inner join EQESTADOS as b on a.estado = b.estado                                       
inner join aaclientesaa as c on a.RucConsignatario = c.contribuy                                            
left join ddordfac01 AS d on a.id_orden = d.Id_orden                                       
left join ddorddet01 as e on e.id_orden = d.id_orden and e.IdServicio = d.Id_servicio                                      
left join dqnavier08 as f on d.codigonave = f.codnav08                                       
left join tb_servicios as h on d.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = h.dc_servicio                                            
left join tb_tipo_tamano_contenedor as i on d.tamanocntr = i.dc_tipo_tamano_contenedor                                            
left join ddcabman11 as g on d.naveviaje = g.codcco06                           
left join TQGLOSASI as j on a.idglosa = j.idglosa                        
left join DQPORDETRA as k on             
case when a.idglosa is null then a.Porcentaje                
     when j.detrac = 0 then a.Porcentaje                 
     when j.detrac = 1 then 12 end  = k.detraccion            
where a.Id_Orden = @Id_Orden                                        
return 0                      
            
      
    
  