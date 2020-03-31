CREATE  procedure [dbo].[sp_Consultar_OrdenSerByNroOrdImp] --15666                                     
@Id_Orden int                                      
as  
  
DECLARE @PREFIXFE   VARCHAR(4)  
  
SET @PREFIXFE = ''  
SELECT @PREFIXFE = ISNULL(PrefixFE,'')  
  FROM FAC_FacturaElectronica_OFAM  
  WHERE Id_Orden = @Id_Orden                                   
                             
select a.FechaOrden, a.HoraOrden, a.RucxCuenta,                                        
a.CodRefer,            
a.Contacto,            
a.MailContacto,            
a.TelContacto,            
a.moneda,            
a.TipoDoc,  
@PREFIXFE AS PREFIJOFE,            
a.SerieDoc,            
case when e.NroFactura is null then a.NumeroDoc                  
     else e.NroFactura end as NumeroDoc,            
a.FechaDoc,            
a.Observaciones,            
a.NroRef,            
a.FecRef,            
case when e.flagEstado is null then a.Estado                  
     else e.flagEstado end as Estado,                    
b.descripcion,            
a.RucConsignatario,            
a.RucGeneral,            
a.RucArmador,            
a.RucMaritimo,            
a.RucAduanas,            
a.IndicadorFac,            
a.Direccion,            
a.Cargo,            
a.Cargaretirada,            
a.TipoCambio,            
a.Usuario,            
a.Integral,            
a.Impuesto,            
case when e.Total is null then a.Total                  
     else e.Total end as Total,            
a.Consolidado,            
a.UsuarioFact,            
c.nombre,            
a.NroReclamo,            
a.Prefacturas,            
a.idglosa,                 
--a.retraccion,        
--a.Porcentaje,         
case when e.Detracion is null then               
     case when a.idglosa is null then a.Retraccion      
          when a.Retraccion <> 0 then a.retraccion    
          when a.Retraccion = 0 then k.detrac end       
     else e.Detracion end as Retraccion,               
              
case when e.PorcentajeDet is null then       
     case when a.idglosa is null then a.Porcentaje      
          when k.detrac = 0 then a.Porcentaje       
          when k.detrac = 1 then 12 end       
     else e.PorcentajeDet end as Porcentaje,              
                 
flagRefac,              
NroNC,            
g.nombre as NomGeneral,              
i.nombre as NomMaritimo,              
j.nombre as NOmAduanas,              
h.nombre as Nomxcuenta,          
case when a.idglosa is null then '0'          
else k.detrac end SerInt,  
   
case when e.Total is null and a.moneda = 1 then a.Total  
     when e.Total is null and a.moneda = 2 then a.Total * a.TipoCambio                
     when e.Total is not null and a.moneda = 2 then e.Total * a.TipoCambio   
     when e.Total is not null and a.moneda = 1 then e.Total end as TotalSoles   
            
from                   
dcordfac01 as a inner join EQESTADOS as b on a.estado = b.estado                                 
inner join aaclientesaa as c on a.RucConsignatario = c.contribuy                
left join aaclientesaa as g on a.RucGeneral = g.contribuy                    
left join aaclientesaa as h on a.RucxCuenta = h.contribuy                    
left join aaclientesaa as i on a.RucMaritimo = i.contribuy                    
left join aaclientesaa as j on a.RucAduanas = j.contribuy               
left join dcfacPre01 as e on a.Id_orden = e.idorden              
left join TQGLOSASI as k on a.idglosa = k.idglosa             
where                   
Id_Orden = @Id_Orden                                   
return 0                