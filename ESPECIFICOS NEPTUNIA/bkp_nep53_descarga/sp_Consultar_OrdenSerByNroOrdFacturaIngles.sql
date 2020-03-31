CREATE  procedure sp_Consultar_OrdenSerByNroOrdFacturaIngles              
@Id_Orden int                    
as                    
 declare @Afecto numeric (12,2)            
 declare @Inafecto numeric (12,2)            
 declare @Fecha datetime  
  
 SELECT  @Fecha = feclec00 FROM FIC_CONTA00 where codfic00 = 'OF'  
           
 select @afecto = sum(Tarifa * Cantidad)            
 from ddordfac01            
 where AfectoIgv = 1 and            
 Id_Orden = @Id_Orden                
             
 select @inafecto = sum(Tarifa * Cantidad)            
 from ddordfac01            
 where AfectoIgv = 0 and            
 Id_Orden = @Id_Orden                
  
 IF @FECHA > GETDATE()  
 begin           
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
  h.dg_servicio_Ingles,              
  i.dg_tipo_tamano_contenedor,              
  e.NumeroCntr,                 
  d.Id_Servicio,    
  isnull(@inafecto, 0) as sumInafecto,            
  isnull(@afecto, 0) as SumAfecto            
  from dcordfac01 as a inner join EQESTADOS as b on a.estado = b.estado               
  inner join aaclientesaa as c on a.RucConsignatario = c.contribuy                    
  left join ddordfac01 AS d on a.id_orden = d.Id_orden               
  left join ddorddet01 as e on e.id_orden = d.id_orden and e.IdServicio = d.Id_servicio              
  left join dqnavier08 as f on d.codigonave = f.codnav08               
  left join neptunia9.bd_nept.dbo.tb_servicios as h on d.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = h.dc_servicio                    
  left join tb_tipo_tamano_contenedor as i on d.tamanocntr = i.dc_tipo_tamano_contenedor                    
  left join ddcabman11 as g on d.naveviaje = g.codcco06              
  where a.Id_Orden = @Id_Orden                
 end  
 else  
 begin  
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
  h.dg_servicio_Ingles,   
  i.codtam09 as dg_tipo_tamano_contenedor,                   
  e.NumeroCntr,                 
  d.Id_Servicio,    
  isnull(@inafecto, 0) as sumInafecto,            
  isnull(@afecto, 0) as SumAfecto            
  from dcordfac01 as a inner join EQESTADOS as b on a.estado = b.estado               
  inner join aaclientesaa as c on a.RucConsignatario = c.contribuy                    
  left join ddordfac01 AS d on a.id_orden = d.Id_orden               
  left join ddorddet01 as e on e.id_orden = d.id_orden and e.IdServicio = d.Id_servicio              
  left join dqnavier08 as f on d.codigonave = f.codnav08               
  left join TTSERV as h on d.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = h.dc_servicio                    
  left join DQTAMCON09 as i on d.tamanocntr = i.codult09   
  left join ddcabman11 as g on d.navvia11 = g.navvia11  
  where a.Id_Orden = @Id_Orden                
 end  
return 0  