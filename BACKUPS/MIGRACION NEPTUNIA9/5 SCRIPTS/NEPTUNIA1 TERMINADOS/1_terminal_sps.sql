--------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER procedure  Camionaje_LIstaTotalesbyFechas --'200603', '20060301'
                                                                                                                                                                                       
@MesAnio char(6),
                                                                                                                                                                                                                                            
@FechaIni char(8)
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
select convert(varchar(10), convert(datetime, a.fecini10), 103) as fecini10, 
                                                                                                                                                                                
convert(varchar(10), convert(datetime, a.fecfin10), 103) as fecfin10, 
                                                                                                                                                                                       
a.nrocamionaje, sum(a.tottar99)as total,
                                                                                                                                                                                                                     
a.codrut01, 
                                                                                                                                                                                                                                                 
b.desrut01,
                                                                                                                                                                                                                                                  
b.succon01,
                                                                                                                                                                                                                                                  
b.cencos01,
                                                                                                                                                                                                                                                  
b.Item01,
                                                                                                                                                                                                                                                    
c.dg_item_gasto,
                                                                                                                                                                                                                                             
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal
                                                                                                                                                                                                                                                
from CDFACAUT10 as a inner join CQCIRCUI01 as b on a.codrut01 = b.codrut01
                                                                                                                                                                                   
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_item_gasto as c on b.item01 = c.dc_item_gasto
                                                                                                                                                                            
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as d on b.cencos01 = d.dc_centro_costo
                                                                                                                                                                      
INNER JOIN CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_INST as e on b.succon01 = e.dc_sucursal
                                                                                                                                                                         
where substring(fecini10, 1,6) = @MesAnio
                                                                                                                                                                                                                    
and fecemi10 between @FechaIni and convert(varchar(8),dateadd(month,1,@FechaIni), 112)
                                                                                                                                                                       
group by a.fecini10, a.fecfin10, a.nrocamionaje, a.codrut01,
                                                                                                                                                                                                 
b.desrut01,b.succon01,b.cencos01,b.Item01,c.dg_item_gasto,
                                                                                                                                                                                                   
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal
                                                                                                                                                                                                                                                
order by a.CodRut01
                                                                                                                                                                                                                                          
return 0
                                                                                                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  Camionaje_LIstaTotalesbyFueradeFecha --'200603', '20060301'
                                                                                                                                                                                 
@MesAnio char(6),
                                                                                                                                                                                                                                            
@Fecha char(8)
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
select convert(varchar(10), convert(datetime, a.fecini10), 103) as fecini10, 
                                                                                                                                                                                
convert(varchar(10), convert(datetime, a.fecfin10), 103) as fecfin10, 
                                                                                                                                                                                       
sum(a.tottar99) as Total, a.Nrocamionaje, a.ruccli12, a.razage19,  
                                                                                                                                                                                          
a.nrofac10, a.fecemi10,
                                                                                                                                                                                                                                      
a.codrut01, 
                                                                                                                                                                                                                                                 
b.desrut01,
                                                                                                                                                                                                                                                  
b.succon01,
                                                                                                                                                                                                                                                  
b.cencos01,
                                                                                                                                                                                                                                                  
b.Item01,
                                                                                                                                                                                                                                                    
c.dg_item_gasto,
                                                                                                                                                                                                                                             
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal
                                                                                                                                                                                                                                                
from CDFACAUT10 as a inner join CQCIRCUI01 as b on a.codrut01 = b.codrut01
                                                                                                                                                                                   
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_item_gasto as c on b.item01 = c.dc_item_gasto
                                                                                                                                                                            
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as d on b.cencos01 = d.dc_centro_costo
                                                                                                                                                                      
INNER JOIN CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_INST as e on b.succon01 = e.dc_sucursal
                                                                                                                                                                         
where substring(fecini10, 1,6) = @MesAnio
                                                                                                                                                                                                                    
and fecemi10 >= convert(varchar(8),dateadd(month,1,@Fecha), 112)
                                                                                                                                                                                             
group by a.fecini10, a.fecfin10, a.ruccli12, a.razage19, a.Nrocamionaje, 
                                                                                                                                                                                    
a.nrofac10, a.fecemi10,
                                                                                                                                                                                                                                      
a.codrut01, 
                                                                                                                                                                                                                                                 
b.desrut01,
                                                                                                                                                                                                                                                  
b.succon01,
                                                                                                                                                                                                                                                  
b.cencos01,
                                                                                                                                                                                                                                                  
b.Item01,
                                                                                                                                                                                                                                                    
c.dg_item_gasto,
                                                                                                                                                                                                                                             
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal 
                                                                                                                                                                                                                                               
return 0
                                                                                                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  Camionaje_LIstaTotalesbyNoFacturadas
                                                                                                                                                                                                        
@MesAnio char(6)
                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
select convert(varchar(10), convert(datetime, a.fecini10), 103) as fecini10, 
                                                                                                                                                                                
convert(varchar(10), convert(datetime, a.fecfin10), 103) as fecfin10, 
                                                                                                                                                                                       
a.Nrocamionaje, a.ruccli12, a.razage19,  sum(a.tottar99) as total,
                                                                                                                                                                                           
a.codrut01, 
                                                                                                                                                                                                                                                 
b.desrut01,
                                                                                                                                                                                                                                                  
b.succon01,
                                                                                                                                                                                                                                                  
b.cencos01,
                                                                                                                                                                                                                                                  
b.Item01,
                                                                                                                                                                                                                                                    
c.dg_item_gasto,
                                                                                                                                                                                                                                             
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal
                                                                                                                                                                                                                                                
from CDFACAUT10 as a inner join CQCIRCUI01 as b on a.codrut01 = b.codrut01
                                                                                                                                                                                   
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_item_gasto as c on b.item01 = c.dc_item_gasto
                                                                                                                                                                            
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as d on b.cencos01 = d.dc_centro_costo
                                                                                                                                                                      
INNER JOIN CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_INST as e on b.succon01 = e.dc_sucursal
                                                                                                                                                                         
where substring(fecini10, 1,6) = @MesAnio 
                                                                                                                                                                                                                   
and fecemi10 is null
                                                                                                                                                                                                                                         
group by a.fecini10, a.fecfin10, a.Nrocamionaje, a.ruccli12, a.razage19, 
                                                                                                                                                                                    
a.codrut01, 
                                                                                                                                                                                                                                                 
b.desrut01,
                                                                                                                                                                                                                                                  
b.succon01,
                                                                                                                                                                                                                                                  
b.cencos01,
                                                                                                                                                                                                                                                  
b.Item01,
                                                                                                                                                                                                                                                    
c.dg_item_gasto,
                                                                                                                                                                                                                                             
d.dg_centro_costo,
                                                                                                                                                                                                                                           
e.dg_sucursal 
                                                                                                                                                                                                                                               
return 0
                                                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  FACTOT_ActualizaNroFacturaDetOT
                                                                                                                                                                                                            
@nroord01 varchar(10),
                                                                                                                                                                                                                                       
@dm_detraccion char(1),
                                                                                                                                                                                                                                      
@dc_porcentaje_detraccion int,
                                                                                                                                                                                                                               
@nroFactura varchar(10)
                                                                                                                                                                                                                                      
as
                                                                                                                                                                                                                                                           
update ddordtra01 set 
                                                                                                                                                                                                                                       
nrofac01 = @nroFactura
                                                                                                                                                                                                                                       
from ddordtra01 as a inner join 
                                                                                                                                                                                                                             
CALW12SQLCORP.NPT9_bd_nept.dbo.Servicio_Sucursal_CenCos as b
                                                                                                                                                                                                          
on a.idtiposerv = b.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS and a.idsucursal = b.dc_sucursal_imputacion and
                                                                                                                                         
a.idcentrocosto = b.dc_centro_costo_imputacion
                                                                                                                                                                                                               
--where nroord01 = '014204' and dm_detraccion ='S'
                                                                                                                                                                                                           
--and dc_porcentaje_detraccion = 0
                                                                                                                                                                                                                           
where nroord01 = @nroord01 and dm_detraccion = @dm_detraccion
                                                                                                                                                                                                
and dc_porcentaje_detraccion = @dc_porcentaje_detraccion 
                                                                                                                                                                                                    
return 0 
                                                                                                                                                                                                                                                    
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  FACTOT_ConsultaTotalDetalleDetrac
                                                                                                                                                                                                          
@nroord01 varchar(10),
                                                                                                                                                                                                                                       
@dm_detraccion char(1),
                                                                                                                                                                                                                                      
@dc_porcentaje_detraccion int
                                                                                                                                                                                                                                
as
                                                                                                                                                                                                                                                           
select 
                                                                                                                                                                                                                                                      
sum(preciounit * cantidad) as Total
                                                                                                                                                                                                                          
from ddordtra01 as a inner join 
                                                                                                                                                                                                                             
CALW12SQLCORP.NPT9_bd_nept.dbo.Servicio_Sucursal_CenCos as b
                                                                                                                                                                                                          
on a.idtiposerv = b.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS and a.idsucursal = b.dc_sucursal_imputacion and
                                                                                                                                         
a.idcentrocosto = b.dc_centro_costo_imputacion
                                                                                                                                                                                                               
--where nroord01 = '014204' and dm_detraccion ='S'
                                                                                                                                                                                                           
--and dc_porcentaje_detraccion = 0
                                                                                                                                                                                                                           
where nroord01 = @nroord01 and dm_detraccion = @dm_detraccion
                                                                                                                                                                                                
and dc_porcentaje_detraccion = @dc_porcentaje_detraccion 
                                                                                                                                                                                                    
return 0 
                                                                                                                                                                                                                                                    
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  PN_sp_Busca_Deuda_Pendiente_Cliente 
                                                                                                                                                                                                        
@RUC varchar(11),
                                                                                                                                                                                                                                            
@DEUVEN char(2),
                                                                                                                                                                                                                                             
@TICKET char(2)=null
                                                                                                                                                                                                                                         
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Declare @USERID as varchar(20)
                                                                                                                                                                                                                               
Declare @AUTORIZACION as char(2)
                                                                                                                                                                                                                             
Select @USERID=user_name()
                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
--====================================================
                                                                                                                                                                                                       
--====OJO: SI HAY EMERGENCIA: ACTIVAS ESTE BLOQUE====
                                                                                                                                                                                                        
--====================================================
                                                                                                                                                                                                       
/*
                                                                                                                                                                                                                                                           
Select '','','','','','','','','','','','','','','','','','','','','' from aaclientesaa where 1=2
                                                                                                                                                            
Return 0
                                                                                                                                                                                                                                                     
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
--********************************************************************
                                                                                                                                                                                       
--****Tengo que verificar si ya tiene Autorizacion de Ingreso
                                                                                                                                                                                                
--********************************************************************
                                                                                                                                                                                       
if exists (Select * from ddautdoc16 where contribuy=@RUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))
                                                                                                                                   
	Select @AUTORIZACION='SI'
                                                                                                                                                                                                                                   
else
                                                                                                                                                                                                                                                         
	Select @AUTORIZACION='NO'
                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.
                                                                                                                                                                  
--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion
                                                                                                                                                       
--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el 
                                                                                                                                                   
--          cliente es atendido por primera vez en un dia especifico.
                                                                                                                                                                                        
--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente
                                                                                                                                                             
--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                     
--===========================================================================
                                                                                                                                                                                
EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET
                                                                                                                                                  

                                                                                                                                                                                                                                                             
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
                                                                                                                                                         
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
                                                                                                                                      
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                   
--===========================================================================
                                                                                                                                                                                
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'
                                                                                                                                                                       

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure   ROCKY_FACTURAS_CON_CARGA_RETIRADA
                                                                                                                                                                                                         
AS
                                                                                                                                                                                                                                                           
 
                                                                                                                                                                                                                                                            
Declare @AGENTE_ADUANA varchar(11)
                                                                                                                                                                                                                           
 
                                                                                                                                                                                                                                                            
Select a.*,b.nombre,NOM_AGENTE=coalesce(c.nombre,'')
                                                                                                                                                                                                         
From dcordfac01 a
                                                                                                                                                                                                                                            
Inner Join aaclientesaa b on a.RUCCONSIGNATARIO=b.contribuy
                                                                                                                                                                                                  
left Join aaclientesaa c on a.RUCADUANAS=c.contribuy
                                                                                                                                                                                                         
where Cargaretirada=1 and e_mail='N' and Estado not in ('A','X') and TIPODOC='01' and numerodoc is not null 
                                                                                                                                                 
and a.RUCCONSIGNATARIO COLLATE SQL_Latin1_General_CP1_CI_AS not in (Select RUC from CALW12SQLCORP.NPT9_Datawarehouse.dbo.ROCKY_LINEA_CREDITO Where LINEA_CREDITO>0)
                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  ROCKY_LISTAR_NRO_DE_CNTR_DESCARGA
                                                                                                                                                                                                           
@NAVVIA 	varchar(10),
                                                                                                                                                                                                                                        
@NAVE	varchar(5),
                                                                                                                                                                                                                                            
@VIAJE	varchar(10),
                                                                                                                                                                                                                                          
@LLEGADA	smalldatetime
                                                                                                                                                                                                                                       
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Declare @Total int, @Ing int, @NoIng int, @Vacios Int
                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
Select @Total = count(codcon04) From DDCONTEN04 Where navvia11 = @NAVVIA and flgsta04 = '1'
                                                                                                                                                                  

                                                                                                                                                                                                                                                             
Select @Ing = count(codcon04) From DDCONTEN04 Where navvia11 = @NAVVIA and flgsta04 = '1' AND Nrotkt18 is not null
                                                                                                                                           

                                                                                                                                                                                                                                                             
Select @NoIng = count(codcon04) From DDCONTEN04 Where navvia11 = @NAVVIA and flgsta04 = '1' AND Nrotkt18 is null and codbol03 <> 'MT'
                                                                                                                        

                                                                                                                                                                                                                                                             
Select @Vacios = count(codcon04) From DDCONTEN04 Where navvia11 = @NAVVIA and Nrotkt18 is null  and flgsta04=1 and codbol03 = 'MT'
                                                                                                                           

                                                                                                                                                                                                                                                             
Insert Into CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_INFORME_DESCARGA (NAVVIA11,TOTAL,INGRESADOS,NO_INGRESADOS,VACIOS,INGRESO_VACIOS,EMAIL,NAVE,VIAJE,LLEGADA)
                                                                                                            
Select NAVVIA=@NAVVIA, Total =@Total, Ing=@Ing, NoIng=@NoIng, Vacios=@Vacios, 0, 'N', @NAVE, @VIAJE, @LLEGADA
                                                                                                                                                

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- exec SIG_DEUDA_PENDIENTE_CLIENTE '20504065121', 'SI'
                                                                                                                                                                                                      
GO  
 ALTER procedure  [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE]   
                                                                                                                                                                                                      
@RUC varchar(11),  
                                                                                                                                                                                                                                          
@DEUVEN char(2),  
                                                                                                                                                                                                                                           
@TICKET char(2)=null  
                                                                                                                                                                                                                                       
AS  
                                                                                                                                                                                                                                                         
  
                                                                                                                                                                                                                                                           
Declare @USERID as varchar(20)  
                                                                                                                                                                                                                             
Declare @AUTORIZACION as char(2)  
                                                                                                                                                                                                                           
Select @USERID=user_name()  
                                                                                                                                                                                                                                 
  
                                                                                                                                                                                                                                                           
--====================================================  
                                                                                                                                                                                                     
--====OJO: SI HAY EMERGENCIA: ACTIVAS ESTE BLOQUE====  
                                                                                                                                                                                                      
--====================================================  
                                                                                                                                                                                                     
/*  
                                                                                                                                                                                                                                                         
Select '','','','','','','','','','','','','','','','','','','','','' from aaclientesaa where 1=2  
                                                                                                                                                          
Return 0  
                                                                                                                                                                                                                                                   
*/  
                                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
--/*  
                                                                                                                                                                                                                                                       
--********************************************************************  
                                                                                                                                                                                     
--****Tengo que verificar si ya tiene Autorizacion de Ingreso  
                                                                                                                                                                                              
--********************************************************************  
                                                                                                                                                                                     
if exists (Select * from ddautdoc16 where contribuy=@RUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))  
                                                                                                                                 
 Select @AUTORIZACION='SI'  
                                                                                                                                                                                                                                 
else  
                                                                                                                                                                                                                                                       
 Select @AUTORIZACION='NO'  
                                                                                                                                                                                                                                 
  
                                                                                                                                                                                                                                                           
--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.  
                                                                                                                                                                
--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion  
                                                                                                                                                     
--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el   
                                                                                                                                                 
--          cliente es atendido por primera vez en un dia especifico.  
                                                                                                                                                                                      
--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente  
                                                                                                                                                           
--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.  
                                                                                                                                                                   
--===========================================================================  
                                                                                                                                                                              
EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET  
                                                                                                                                                
  
                                                                                                                                                                                                                                                           
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.  
                                                                                                                                                       
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia  
                                                                                                                                    
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.  
                                                                                                                                                                 
--===========================================================================  
                                                                                                                                                                              
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'
                                                                                                                                                                       
--*/                                                                                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
-- exec SIG_DEUDA_PENDIENTE_CLIENTE '20504065121', 'SI'  
                                                                                                                                                                                                    
GO  
 ALTER procedure  [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_P]     
                                                                                                                                                                                                  
@RUC varchar(11),    
                                                                                                                                                                                                                                        
@DEUVEN char(2),    
                                                                                                                                                                                                                                         
@TICKET char(2)=null    
                                                                                                                                                                                                                                     
AS    
                                                                                                                                                                                                                                                       
    
                                                                                                                                                                                                                                                         
Declare @USERID as varchar(20)    
                                                                                                                                                                                                                           
Declare @AUTORIZACION as char(2)    
                                                                                                                                                                                                                         
Select @USERID=user_name()    
                                                                                                                                                                                                                               
    
                                                                                                                                                                                                                                                         
--====================================================    
                                                                                                                                                                                                   
--====OJO: SI HAY EMERGENCIA: ACTIVAS ESTE BLOQUE====    
                                                                                                                                                                                                    
--====================================================    
                                                                                                                                                                                                   
/*    
                                                                                                                                                                                                                                                       
Select '','','','','','','','','','','','','','','','','','','','','' from aaclientesaa where 1=2    
                                                                                                                                                        
Return 0    
                                                                                                                                                                                                                                                 
*/    
                                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
--/*    
                                                                                                                                                                                                                                                     
--********************************************************************    
                                                                                                                                                                                   
--****Tengo que verificar si ya tiene Autorizacion de Ingreso    
                                                                                                                                                                                            
--********************************************************************    
                                                                                                                                                                                   
if exists (Select * from ddautdoc16 where contribuy=@RUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))    
                                                                                                                               
 Select @AUTORIZACION='SI'    
                                                                                                                                                                                                                               
else    
                                                                                                                                                                                                                                                     
 Select @AUTORIZACION='NO'    
                                                                                                                                                                                                                               
    
                                                                                                                                                                                                                                                         
--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.    
                                                                                                                                                              
--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion    
                                                                                                                                                   
--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el     
                                                                                                                                               
--          cliente es atendido por primera vez en un dia especifico.    
                                                                                                                                                                                    
--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente    
                                                                                                                                                         
--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.    
                                                                                                                                                                 
--===========================================================================    
                                                                                                                                                                            
EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET    
                                                                                                                                              
    
                                                                                                                                                                                                                                                         
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.    
                                                                                                                                                     
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia    
                                                                                                                                  
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.    
                                                                                                                                                               
--===========================================================================    
                                                                                                                                                                            
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'  
                                                                                                                                                                     
--*/                                                                                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SP_ACTUALIZA_CLIENTES_ESPECIALES              
                                                                                                                                                                                              
AS              
                                                                                                                                                                                                                                             
BEGIN              
                                                                                                                                                                                                                                          
	SELECT IDENTITY(INT,1,1) AS ID,               
                                                                                                                                                                                                              
	RUC,NOMBRE              
                                                                                                                                                                                                                                    
		INTO #CLIENTES_ESPECIALES              
                                                                                                                                                                                                                    
	FROM CALW12SQLCORP.NPT9_Datawarehouse.dbo.CLIENTES_ESPECIALES              
                                                                                                                                                                                          
	ORDER BY RUC ASC               
                                                                                                                                                                                                                             
               
                                                                                                                                                                                                                                              
	DECLARE @COUNT INT              
                                                                                                                                                                                                                            
	DECLARE @COUNT_TOTAL INT              
                                                                                                                                                                                                                      
	DECLARE @RUC_DATO VARCHAR(11)              
                                                                                                                                                                                                                 
               
                                                                                                                                                                                                                                              
	SET @COUNT=1              
                                                                                                                                                                                                                                  
	SELECT @COUNT_TOTAL=COUNT(*) FROM #CLIENTES_ESPECIALES              
                                                                                                                                                                                        
               
                                                                                                                                                                                                                                              
	WHILE @COUNT < @COUNT_TOTAL + 1              
                                                                                                                                                                                                               
	BEGIN              
                                                                                                                                                                                                                                         
               
                                                                                                                                                                                                                                              
		SELECT @RUC_DATO=RUC FROM #CLIENTES_ESPECIALES WHERE ID=@COUNT              
                                                                                                                                                                               
		SET @RUC_DATO=LTRIM(RTRIM(@RUC_DATO))              
                                                                                                                                                                                                        
                
                                                                                                                                                                                                                                             
		--IF EXISTS (SELECT * FROM CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO Where EMAIL='N' AND CONTRIBUY=@RUC_DATO)              
                                                                                                                       
		--BEGIN              
                                                                                                                                                                                                                                      
           
                                                                                                                                                                                                                                                  
		--|CALLAO              
                                                                                                                                                                                                                                    
		Insert ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                                          
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')             
                                                                                                                                 
             
                                                                                                                                                                                                                                                
		Insert Depositos..ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                               
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')               
                                                                                                                               
               
                                                                                                                                                                                                                                              
		Insert Neptunia2.descarga.dbo.ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                   
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')              
                                                                                                                                
               
                                                                                                                                                                                                                                              
		Insert Oceanica1.Descarga.dbo.ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                   
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')             
                                                                                                                                 
		--|        
                                                                                                                                                                                                                                                
         
                                                                                                                                                                                                                                                    
		UPDATE CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO SET EMAIL='W',MOTIVO='CLIENTE ESPECIAL'              
                                                                                                                                            
		WHERE CONTRIBUY=@RUC_DATO AND EMAIL='N'        
                                                                                                                                                                                                            
           
                                                                                                                                                                                                                                                  
		--|PAITA        
                                                                                                                                                                                                                                           
		Insert Neptuniap1.Terminal.dbo.ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                  
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')             
                                                                                                                                 
        
                                                                                                                                                                                                                                                     
		Insert Neptuniap2.Descarga.dbo.ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                  
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')             
                                                                                                                                 
        
                                                                                                                                                                                                                                                     
		Insert OceanicaP1.Descarga.dbo.ddautdoc16 (CONTRIBUY,FECINI16,userid16,fecusu16,observ16 )               
                                                                                                                                                  
		values (@RUC_DATO,CAST(GETDATE() AS smalldatetime),'web',CAST(GETDATE() AS smalldatetime),'CLIENTE ESPECIAL')      
                                                                                                                                        
		--|        
                                                                                                                                                                                                                                                
                 
                                                                                                                                                                                                                                            
		--END              
                                                                                                                                                                                                                                        
                
                                                                                                                                                                                                                                             
		SET @COUNT = @COUNT + 1               
                                                                                                                                                                                                                     
	END              
                                                                                                                                                                                                                                           
               
                                                                                                                                                                                                                                              
	DROP TABLE #CLIENTES_ESPECIALES              
                                                                                                                                                                                                               
               
                                                                                                                                                                                                                                              
	PRINT 'EJUCUTADO CORRECTAMENTE'              
                                                                                                                                                                                                               
               
                                                                                                                                                                                                                                              
END                                                                                                                                                                                                                                                            
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Actualiza_UltimoNroDocUltra
                                                                                                                                                                                                              
@TipoDoc int,
                                                                                                                                                                                                                                                
@dn_serie varchar(3),
                                                                                                                                                                                                                                        
@dc_Sucursal int,
                                                                                                                                                                                                                                            
@Ultimonumero int
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
update CALW12SQLCORP.NPT9_bd_nept.dbo.tb_puntos_de_impresion set
                                                                                                                                                                                                      
dn_documento_disponible = @Ultimonumero,
                                                                                                                                                                                                                     
dn_ultimo_documento_emitido = @Ultimonumero
                                                                                                                                                                                                                  
where dc_tipo_documento = @TipoDoc and dn_serie = @dn_serie and dc_sucursal = @dc_Sucursal
                                                                                                                                                                   

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*creo el procedure en la importacion desde el Neptunia9*/
                                                                                                                                                                                                   
GO  
 ALTER procedure  SP_BSC_IMPORTAR_FECHAS_CLIENTES
                                                                                                                                                                                                             
/*
                                                                                                                                                                                                                                                           
Nombre : SP_BSC_IMPORTAR_FECHAS_CLIENTES
                                                                                                                                                                                                                     
Descripcion :  importa las fechas de neptunia9
                                                                                                                                                                                                               
Responsable : R&M 
                                                                                                                                                                                                                                           
Tablas Involucradas: BSC_Clientes_Fechaingreso (W)(R)
                                                                                                                                                                                                        
Tiempo Aproximado : 0:20 min
                                                                                                                                                                                                                                 
*/
                                                                                                                                                                                                                                                           
AS
                                                                                                                                                                                                                                                           
DELETE FROM BSC_Clientes_Fechaingreso
                                                                                                                                                                                                                        
INSERT INTO BSC_Clientes_Fechaingreso(RUC_CLIENTE,FECHINGRES)
                                                                                                                                                                                                
SELECT RUC_CLIENTE,FECHINGRES FROM CALW12SQLCORP.NPT9_BD_NEPT.DBO.BSC_Clientes_Fechaingreso
                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
GO  
 ALTER procedure  SP_CLIENTES_ESPECIALES
                                                                                                                                                                                                                      
@RUC VARCHAR(11)
                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        
	SELECT 
                                                                                                                                                                                                                                                     
	RUC AS RUCCLIENTE
                                                                                                                                                                                                                                           
	,NOMBRE AS NOMBRECLIENTE
                                                                                                                                                                                                                                    
	FROM CALW12SQLCORP.NPT9_Datawarehouse.dbo.CLIENTES_ESPECIALES WITH (NOLOCK)
                                                                                                                                                                                          
	WHERE RUC LIKE '%' + @RUC + '%' 
                                                                                                                                                                                                                            
	ORDER BY RUC ASC
                                                                                                                                                                                                                                            
END                                                                                                                                                                                                                                                            
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  [dbo].[sp_ConsultaNaveViaje]  
                                                                                                                                                                                                              
@Codigo varchar (10)    
                                                                                                                                                                                                                                     
--set @Codigo = '31084'
                                                                                                                                                                                                                                      
as    
                                                                                                                                                                                                                                                       
declare @FECHA datetime  
                                                                                                                                                                                                                                    
declare @navvia11 char(6)
                                                                                                                                                                                                                                    
  
                                                                                                                                                                                                                                                           
select @FECHA = Fecfin00 from  FIC_CONTA00  
                                                                                                                                                                                                                 
where codfic00 = 'UL'  
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
IF @FECHA >= GETDATE()  
                                                                                                                                                                                                                                     
begin  
                                                                                                                                                                                                                                                      
select * from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_codigo_nave_viaje    
                                                                                                                                                                                                 
where dc_codigo_nave_viaje = @Codigo    
                                                                                                                                                                                                                     
end  
                                                                                                                                                                                                                                                        
else  
                                                                                                                                                                                                                                                       
begin  
                                                                                                                                                                                                                                                      
/*Añadir validacion de ofisis */  
                                                                                                                                                                                                                           
select @navvia11 = navvia11  from ddcabman11 
                                                                                                                                                                                                                
where codcco06 = @Codigo
                                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--***VALIDACION - CUANDO EL [CO_NAVE_VIA1] ESTA SIN CERO --> '48396'************
                                                                                                                                                                             
DECLARE @contador INT = 0
                                                                                                                                                                                                                                    
DECLARE @navvia11_INT INT
                                                                                                                                                                                                                                    
select @contador=COUNT(*) From [CALW3ERP001].[OFIRECA].[dbo].[TTNAVE_VIAJ] where co_nave_via1 = @navvia11
                                                                                                                                                    
IF (@contador = 0)
                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        
	BEGIN TRY
                                                                                                                                                                                                                                                   
		SET @navvia11_INT = CONVERT(INT,@navvia11)
                                                                                                                                                                                                                 
		SET @navvia11 = CONVERT(VARCHAR(8),@navvia11_INT)		  
                                                                                                                                                                                                      
	END TRY
                                                                                                                                                                                                                                                     
	BEGIN CATCH
                                                                                                                                                                                                                                                 
		SET @navvia11 = @navvia11
                                                                                                                                                                                                                                  
	END CATCH;
                                                                                                                                                                                                                                                  
END
                                                                                                                                                                                                                                                          
--*****************************************************************************
                                                                                                                                                                              

                                                                                                                                                                                                                                                             
select *
                                                                                                                                                                                                                                                     
From   [CALW3ERP001].[OFIRECA].[dbo].[TTNAVE_VIAJ]    
                                                                                                                                                                                                       
where co_nave_via1 = @navvia11
                                                                                                                                                                                                                               
end  
                                                                                                                                                                                                                                                        
return 0  
                                                                                                                                                                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_DetOrdenSerByIdOrden   --47906                 
                                                                                                                                                                                
@Id_orden int                    
                                                                                                                                                                                                                            
as      
                                                                                                                                                                                                                                                     
declare @Fecha datetime  
                                                                                                                                                                                                                                    
  
                                                                                                                                                                                                                                                           
SELECT  @Fecha = feclec00 FROM FIC_CONTA00  
                                                                                                                                                                                                                 
where codfic00 = 'OF'  
                                                                                                                                                                                                                                      
IF @FECHA > GETDATE()  
                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
begin                
                                                                                                                                                                                                                                        
select                     
                                                                                                                                                                                                                                  
a.Id_orden,                    
                                                                                                                                                                                                                              
a.Id_Servicio,                    
                                                                                                                                                                                                                           
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                    
                                                                                                                                                                       
a.Tarifa,                    
                                                                                                                                                                                                                                
a.Cantidad,                    
                                                                                                                                                                                                                              
a.Tarifa * a.Cantidad as SubTotal,                    
                                                                                                                                                                                                       
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                     
                                                                                                                                                                            
b.dg_servicio,                  
                                                                                                                                                                                                                             
a.AfectoIgv,                  
                                                                                                                                                                                                                               
a.CodigoNave,                  
                                                                                                                                                                                                                              
a.NaveViaje,                  
                                                                                                                                                                                                                               
a.Sucursal,                  
                                                                                                                                                                                                                                
a.CentroCosto,                
                                                                                                                                                                                                                               
a.TamanoCntr,                      
                                                                                                                                                                                                                          
a.TipoCntr,                  
                                                                                                                                                                                                                                
a.StatusCntr,              
                                                                                                                                                                                                                                  
a.Nrobooking,          
                                                                                                                                                                                                                                      
a.desviaje,        
                                                                                                                                                                                                                                          
a.unidad,      
                                                                                                                                                                                                                                              
a.TipoDetalle,    
                                                                                                                                                                                                                                           
a.LineaTarifaEE            
                                                                                                                                                                                                                                  
from DDORDFAC01 as a                     
                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                    
                                                                                                                    
where Id_orden = @Id_Orden         
                                                                                                                                                                                                                          
end  
                                                                                                                                                                                                                                                        
else  
                                                                                                                                                                                                                                                       
begin  
                                                                                                                                                                                                                                                      
select                     
                                                                                                                                                                                                                                  
a.Id_orden,                    
                                                                                                                                                                                                                              
a.Id_Servicio,                    
                                                                                                                                                                                                                           
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                    
                                                                                                                                                                       
a.Tarifa,                    
                                                                                                                                                                                                                                
a.Cantidad,                    
                                                                                                                                                                                                                              
a.Tarifa * a.Cantidad as SubTotal,                    
                                                                                                                                                                                                       
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                     
                                                                                                                                                                            
b.dg_servicio,                  
                                                                                                                                                                                                                             
a.AfectoIgv,                  
                                                                                                                                                                                                                               
a.CodigoNave,                  
                                                                                                                                                                                                                              
a.NaveViaje,                  
                                                                                                                                                                                                                               
a.Sucursal,                  
                                                                                                                                                                                                                                
a.CentroCosto,                
                                                                                                                                                                                                                               
a.TamanoCntr,                      
                                                                                                                                                                                                                          
a.TipoCntr,                  
                                                                                                                                                                                                                                
a.StatusCntr,              
                                                                                                                                                                                                                                  
a.Nrobooking,          
                                                                                                                                                                                                                                      
a.desviaje,        
                                                                                                                                                                                                                                          
a.unidad,      
                                                                                                                                                                                                                                              
a.TipoDetalle,    
                                                                                                                                                                                                                                           
a.LineaTarifaEE,  
                                                                                                                                                                                                                                           
a.navvia11,  
                                                                                                                                                                                                                                                
--isnull(a.codtipocntr, '*') as codtipocntr,   
                                                                                                                                                                                                              
case a.codtipocntr 
                                                                                                                                                                                                                                          
	when '' then '*'
                                                                                                                                                                                                                                            
	when null then '*'
                                                                                                                                                                                                                                          
	else a.codtipocntr 
                                                                                                                                                                                                                                         
end as codtipocntr,
                                                                                                                                                                                                                                          
i.codtam09,  
                                                                                                                                                                                                                                                
e.codbol03,           
                                                                                                                                                                                                                                       
isnull(c.coduni54, 'CTR') as coduni54  
                                                                                                                                                                                                                      
from DDORDFAC01 as a                     
                                                                                                                                                                                                                    
inner join TTSERV as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio  
                                                                                                                                                                  
inner join DQTAMCON09 as i on a.tamanocntr = i.codult09                                      
                                                                                                                                                                
inner join DQCONCNT03 as e on a.StatusCntr = e.dc_dnd_contenedor                        
                                                                                                                                                                     
left join DQUNIMED54 as c on a.unidad = c.codofa54  
                                                                                                                                                                                                         
where Id_orden = @Id_Orden           
                                                                                                                                                                                                                        
end  
                                                                                                                                                                                                                                                        
return 0     
                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_DetOrdenSerByIdOrdenAut              
                                                                                                                                                                                          
@Id_orden int              
                                                                                                                                                                                                                                  
as   
                                                                                                                                                                                                                                                        
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin            
                                                                                                                                                                                                                                            
select               
                                                                                                                                                                                                                                        
a.Id_orden,              
                                                                                                                                                                                                                                    
a.Id_Servicio,              
                                                                                                                                                                                                                                 
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,              
                                                                                                                                                                             
a.Tarifa,              
                                                                                                                                                                                                                                      
a.Cantidad,              
                                                                                                                                                                                                                                    
a.Tarifa * a.Cantidad as SubTotal,              
                                                                                                                                                                                                             
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,               
                                                                                                                                                                                  
b.dg_servicio,            
                                                                                                                                                                                                                                   
a.AfectoIgv,            
                                                                                                                                                                                                                                     
a.CodigoNave,            
                                                                                                                                                                                                                                    
a.NaveViaje,            
                                                                                                                                                                                                                                     
a.Sucursal,            
                                                                                                                                                                                                                                      
a.CentroCosto,          
                                                                                                                                                                                                                                     
a.TamanoCntr,                
                                                                                                                                                                                                                                
a.TipoCntr,            
                                                                                                                                                                                                                                      
a.StatusCntr,        
                                                                                                                                                                                                                                        
a.Nrobooking,      
                                                                                                                                                                                                                                          
c.navvia11,      
                                                                                                                                                                                                                                            
a.desviaje as numvia11,      
                                                                                                                                                                                                                                
c.tipope11,      
                                                                                                                                                                                                                                            
c.feclle11,      
                                                                                                                                                                                                                                            
d.desnav08,      
                                                                                                                                                                                                                                            
e.dg_tipo_tamano_contenedor,  
                                                                                                                                                                                                                               
a.flgingModulo       
                                                                                                                                                                                                                                        
from DDORDFAC01 as a               
                                                                                                                                                                                                                          
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio              
                                                                                                                          
inner join ddcabman11 as c on a.naveviaje = c.codcco06      
                                                                                                                                                                                                 
inner join dqnavier08 as d on a.codigonave = d.codnav08      
                                                                                                                                                                                                
inner join tb_tipo_tamano_contenedor as e on a.tamanocntr = e.dc_tipo_tamano_contenedor      
                                                                                                                                                                
where Id_orden = @Id_orden        
                                                                                                                                                                                                                           
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
select               
                                                                                                                                                                                                                                        
a.Id_orden,              
                                                                                                                                                                                                                                    
a.Id_Servicio,              
                                                                                                                                                                                                                                 
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,              
                                                                                                                                                                             
a.Tarifa,              
                                                                                                                                                                                                                                      
a.Cantidad,              
                                                                                                                                                                                                                                    
a.Tarifa * a.Cantidad as SubTotal,              
                                                                                                                                                                                                             
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,               
                                                                                                                                                                                  
b.dg_servicio,            
                                                                                                                                                                                                                                   
a.AfectoIgv,            
                                                                                                                                                                                                                                     
a.CodigoNave,            
                                                                                                                                                                                                                                    
a.NaveViaje,            
                                                                                                                                                                                                                                     
a.Sucursal,            
                                                                                                                                                                                                                                      
a.CentroCosto,          
                                                                                                                                                                                                                                     
a.TamanoCntr,                
                                                                                                                                                                                                                                
a.TipoCntr,            
                                                                                                                                                                                                                                      
a.StatusCntr,        
                                                                                                                                                                                                                                        
a.Nrobooking,      
                                                                                                                                                                                                                                          
c.navvia11,      
                                                                                                                                                                                                                                            
a.desviaje as numvia11,      
                                                                                                                                                                                                                                
c.tipope11,      
                                                                                                                                                                                                                                            
c.feclle11,      
                                                                                                                                                                                                                                            
d.desnav08,      
                                                                                                                                                                                                                                            
e.destam09 as dg_tipo_tamano_contenedor,  
                                                                                                                                                                                                                   
a.flgingModulo       
                                                                                                                                                                                                                                        
from DDORDFAC01 as a               
                                                                                                                                                                                                                          
inner join TTSERV as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio              
                                                                                                                                                      
inner join ddcabman11 as c on a.navvia11 = c.navvia11
                                                                                                                                                                                                        
inner join dqnavier08 as d on a.codigonave = d.codnav08      
                                                                                                                                                                                                
inner join DQTAMCON09 as e on a.tamanocntr = e.codult09 
                                                                                                                                                                                                     
where Id_orden = @Id_orden        
                                                                                                                                                                                                                           
end
                                                                                                                                                                                                                                                          
return 0              
                                                                                                                                                                                                                                       
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  sp_Consultar_DetOrdenSerByIdOrdenNroFac                
                                                                                                                                                                                    
@Id_orden int,  
                                                                                                                                                                                                                                             
@Nrofact varchar(10)               
                                                                                                                                                                                                                          
as                
                                                                                                                                                                                                                                           
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin 
                                                                                                                                                                                                                                                       
select                 
                                                                                                                                                                                                                                      
a.Id_orden,                
                                                                                                                                                                                                                                  
a.Id_Servicio,                
                                                                                                                                                                                                                               
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                
                                                                                                                                                                           
a.Tarifa,                
                                                                                                                                                                                                                                    
a.Cantidad,                
                                                                                                                                                                                                                                  
a.Tarifa * a.Cantidad as SubTotal,                
                                                                                                                                                                                                           
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                 
                                                                                                                                                                                
b.dg_servicio,              
                                                                                                                                                                                                                                 
a.AfectoIgv,              
                                                                                                                                                                                                                                   
a.CodigoNave,              
                                                                                                                                                                                                                                  
a.NaveViaje,              
                                                                                                                                                                                                                                   
a.Sucursal,              
                                                                                                                                                                                                                                    
a.CentroCosto,            
                                                                                                                                                                                                                                   
a.TamanoCntr,                  
                                                                                                                                                                                                                              
a.TipoCntr,              
                                                                                                                                                                                                                                    
a.StatusCntr,          
                                                                                                                                                                                                                                      
a.Nrobooking,      
                                                                                                                                                                                                                                          
a.desviaje,    
                                                                                                                                                                                                                                              
a.unidad          
                                                                                                                                                                                                                                           
from DDORDFAC01 as a                 
                                                                                                                                                                                                                        
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                
                                                                                                                        
where a.Id_orden = @Id_Orden and a.nrofact = @Nrofact  
                                                                                                                                                                                                      
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
select                 
                                                                                                                                                                                                                                      
a.Id_orden,                
                                                                                                                                                                                                                                  
a.Id_Servicio,                
                                                                                                                                                                                                                               
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                
                                                                                                                                                                           
a.Tarifa,                
                                                                                                                                                                                                                                    
a.Cantidad,                
                                                                                                                                                                                                                                  
a.Tarifa * a.Cantidad as SubTotal,                
                                                                                                                                                                                                           
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                 
                                                                                                                                                                                
b.dg_servicio,              
                                                                                                                                                                                                                                 
a.AfectoIgv,              
                                                                                                                                                                                                                                   
a.CodigoNave,              
                                                                                                                                                                                                                                  
a.NaveViaje,              
                                                                                                                                                                                                                                   
a.Sucursal,              
                                                                                                                                                                                                                                    
a.CentroCosto,            
                                                                                                                                                                                                                                   
a.TamanoCntr,                  
                                                                                                                                                                                                                              
a.TipoCntr,              
                                                                                                                                                                                                                                    
a.StatusCntr,          
                                                                                                                                                                                                                                      
a.Nrobooking,      
                                                                                                                                                                                                                                          
a.desviaje,    
                                                                                                                                                                                                                                              
a.unidad          
                                                                                                                                                                                                                                           
from DDORDFAC01 as a                 
                                                                                                                                                                                                                        
inner join TTSERV as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                
                                                                                                                                                    
where a.Id_orden = @Id_Orden and a.nrofact = @Nrofact  
                                                                                                                                                                                                      
end
                                                                                                                                                                                                                                                          
return 0        
                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_DetOrdenSerByIdOrdenpl                
                                                                                                                                                                                         
@Id_orden int                
                                                                                                                                                                                                                                
as        
                                                                                                                                                                                                                                                   
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin            
                                                                                                                                                                                                                                            
select                 
                                                                                                                                                                                                                                      
a.Id_orden,                
                                                                                                                                                                                                                                  
a.Id_Servicio,                
                                                                                                                                                                                                                               
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                
                                                                                                                                                                           
a.Tarifa,                
                                                                                                                                                                                                                                    
a.Cantidad,                
                                                                                                                                                                                                                                  
a.Tarifa * a.Cantidad * a.horast as SubTotal,                
                                                                                                                                                                                                
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                 
                                                                                                                                                                                
b.dg_servicio,              
                                                                                                                                                                                                                                 
a.AfectoIgv,              
                                                                                                                                                                                                                                   
a.Sucursal,              
                                                                                                                                                                                                                                    
a.CentroCosto,            
                                                                                                                                                                                                                                   
a.fecini,        
                                                                                                                                                                                                                                            
a.fecfin,        
                                                                                                                                                                                                                                            
a.Horaini,        
                                                                                                                                                                                                                                           
a.Horafin,        
                                                                                                                                                                                                                                           
a.Horast,        
                                                                                                                                                                                                                                            
a.IdMaquina,        
                                                                                                                                                                                                                                         
a.TipoCobro,        
                                                                                                                                                                                                                                         
a.IdUnidad,        
                                                                                                                                                                                                                                          
c.desuni54 as unimed54,              
                                                                                                                                                                                                                        
'nroguiaprov'=isnull(a.nroguiaprov,''),        
                                                                                                                                                                                                              
'idtarifa'=isnull(a.idtarifa,0),        
                                                                                                                                                                                                                     
'idacuerdo'=isnull(a.idacuerdo,0),      
                                                                                                                                                                                                                     
a.ID_PROVEEDOR,      
                                                                                                                                                                                                                                        
a.HorasDif,      
                                                                                                                                                                                                                                            
a.HoroIni,      
                                                                                                                                                                                                                                             
a.HoroFin,  
                                                                                                                                                                                                                                                 
a.idTipoMaquina,
                                                                                                                                                                                                                                             
c.coduni54  
                                                                                                                                                                                                                                                 
from DDORDFACpl as a                 
                                                                                                                                                                                                                        
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                
                                                                                                                        
inner join DQUNIMED54 as c on a.IdUnidad = c.codpan54     
                                                                                                                                                                                                   
where Id_orden = @Id_Orden                
                                                                                                                                                                                                                   
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin            
                                                                                                                                                                                                                                            
select                 
                                                                                                                                                                                                                                      
a.Id_orden,                
                                                                                                                                                                                                                                  
a.Id_Servicio,                
                                                                                                                                                                                                                               
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                
                                                                                                                                                                           
a.Tarifa,                
                                                                                                                                                                                                                                    
a.Cantidad,                
                                                                                                                                                                                                                                  
a.Tarifa * a.Cantidad * a.horast as SubTotal,                
                                                                                                                                                                                                
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                 
                                                                                                                                                                                
b.dg_servicio,              
                                                                                                                                                                                                                                 
a.AfectoIgv,              
                                                                                                                                                                                                                                   
a.Sucursal,              
                                                                                                                                                                                                                                    
a.CentroCosto,            
                                                                                                                                                                                                                                   
a.fecini,        
                                                                                                                                                                                                                                            
a.fecfin,        
                                                                                                                                                                                                                                            
a.Horaini,        
                                                                                                                                                                                                                                           
a.Horafin,        
                                                                                                                                                                                                                                           
a.Horast,        
                                                                                                                                                                                                                                            
a.IdMaquina,        
                                                                                                                                                                                                                                         
a.TipoCobro,        
                                                                                                                                                                                                                                         
a.IdUnidad,        
                                                                                                                                                                                                                                          
c.desuni54 as unimed54,        
                                                                                                                                                                                                                              
'nroguiaprov'=isnull(a.nroguiaprov,''),        
                                                                                                                                                                                                              
'idtarifa'=isnull(a.idtarifa,0),        
                                                                                                                                                                                                                     
'idacuerdo'=isnull(a.idacuerdo,0),      
                                                                                                                                                                                                                     
a.ID_PROVEEDOR,      
                                                                                                                                                                                                                                        
a.HorasDif,      
                                                                                                                                                                                                                                            
a.HoroIni,      
                                                                                                                                                                                                                                             
a.HoroFin,  
                                                                                                                                                                                                                                                 
a.idTipoMaquina,
                                                                                                                                                                                                                                             
c.coduni54
                                                                                                                                                                                                                                                   
from DDORDFACpl as a                 
                                                                                                                                                                                                                        
inner join TTSERV as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                
                                                                                                                                                    
inner join DQUNIMED54 as c on a.IdUnidad = c.codpan54     
                                                                                                                                                                                                   
where Id_orden = @Id_Orden                
                                                                                                                                                                                                                   
end
                                                                                                                                                                                                                                                          
return 0         
                                                                                                                                                                                                                                            
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_DetOrdenSerPreByIdOrden                    
                                                                                                                                                                                    
@Id_orden int,      
                                                                                                                                                                                                                                         
@detraccion char(1),      
                                                                                                                                                                                                                                   
@Porcentaje int                 
                                                                                                                                                                                                                             
as             
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
declare @Afecto numeric (12,2)                    
                                                                                                                                                                                                           
declare @Inafecto numeric (12,2)                    
                                                                                                                                                                                                         
                    
                                                                                                                                                                                                                                         
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin
                                                                                                                                                                                                                                                        
    
                                                                                                                                                                                                                                                         
select @afecto = sum(Tarifa)                    
                                                                                                                                                                                                             
from ddordfac01 as a    
                                                                                                                                                                                                                                     
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as c on       
                                                                                                                                                                                     
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
where Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                              
and AfectoIgv = 1    
                                                                                                                                                                                                                                        
                    
                                                                                                                                                                                                                                         
select @inafecto = sum(Tarifa)  
                                                                                                                                                                                                                             
from ddordfac01 as a    
                                                                                                                                                                                                                                     
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as c on       
                                                                                                                                                                                     
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
where Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                              
and AfectoIgv = 0    
                                                                                                                                                                                                                                        
                           
                                                                                                                                                                                                                                  
select                     
                                                                                                                                                                                                                                  
a.Id_orden,                    
                                                                                                                                                                                                                              
a.Id_Servicio,                    
                                                                                                                                                                                                                           
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,                    
                                                                                                                                                                       
a.Tarifa,                    
                                                                                                                                                                                                                                
a.Cantidad,                    
                                                                                                                                                                                                                              
a.Tarifa as SubTotal,                    
                                                                                                                                                                                                                    
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                     
                                                                                                                                                                            
b.dg_servicio,                  
                                                                                                                                                                                                                             
a.AfectoIgv,                  
                                                                                                                                                                                                                               
a.CodigoNave,                  
                                                                                                                                                                                                                              
a.NaveViaje,                  
                                                                                                                                                                                                                               
a.Sucursal,                  
                                                                                                                                                                                                                                
a.CentroCosto,                
                                                                                                                                                                                                                               
a.TamanoCntr,                      
                                                                                                                                                                                                                          
a.TipoCntr,                  
                                                                                                                                                                                                                                
a.StatusCntr,              
                                                                                                                                                                                                                                  
a.Nrobooking,          
                                                                                                                                                                                                                                      
a.desviaje,        
                                                                                                                                                                                                                                          
a.unidad,      
                                                                                                                                                                                                                                              
c.dm_detraccion,      
                                                                                                                                                                                                                                       
c.dc_porcentaje_detraccion,    
                                                                                                                                                                                                                              
isnull(@inafecto, 0) as inafecto,    
                                                                                                                                                                                                                        
isnull(@afecto, 0) as afecto,    
                                                                                                                                                                                                                            
(isnull(@afecto, 0) * (1+d.impuesto)) + isnull(@inafecto, 0) as total    
                                                                                                                                                                                    
from DDORDFAC01 as a                     
                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                    
                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as c on       
                                                                                                                                                                                     
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
inner join DCORDFAC01 as d on a.id_orden = d.id_orden  
                                                                                                                                                                                                      
where a.Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                            
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin                  
                                                                                                                                                                                                                                      
                    
                                                                                                                                                                                                                                         
select @afecto = sum(Tarifa)                    
                                                                                                                                                                                                             
from ddordfac01 as a    
                                                                                                                                                                                                                                     
inner join TRUNNE_SERV as c on       
                                                                                                                                                                                                                        
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
where Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                              
and AfectoIgv = 1    
                                                                                                                                                                                                                                        
                    
                                                                                                                                                                                                                                         
select @inafecto = sum(Tarifa)  
                                                                                                                                                                                                                             
from ddordfac01 as a    
                                                                                                                                                                                                                                     
inner join TRUNNE_SERV as c on       
                                                                                                                                                                                                                        
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
where Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                              
and AfectoIgv = 0    
                                                                                                                                                                                                                                        
                           
                                                                                                                                                                                                                                  
select                     
                                                                                                                                                                                                                                  
a.Id_orden,                    
                                                                                                                                                                                                                              
a.Id_Servicio,                    
                                                                                                                                                                                                                           
a.Descripcion COLLATE SQL_Latin1_General_CP1_CI_AS as Descripcion,         
                                                                                                                                                                                  
a.Tarifa,                    
                                                                                                                                                                                                                                
a.Cantidad,                    
                                                                                                                                                                                                                              
a.Tarifa as SubTotal,                    
                                                                                                                                                                                                                    
a.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS as TipoServ,                     
                                                                                                                                                                            
b.dg_servicio,                  
                                                                                                                                                                                                                             
a.AfectoIgv,                  
                                                                                                                                                                                                                               
a.CodigoNave,                  
                                                                                                                                                                                                                              
a.NaveViaje,                  
                                                                                                                                                                                                                               
a.Sucursal,                  
                                                                                                                                                                                                                                
a.CentroCosto,                
                                                                                                                                                                                                                               
a.TamanoCntr,                      
                                                                                                                                                                                                                          
a.TipoCntr,                  
                                                                                                                                                                                                                                
a.StatusCntr,              
                                                                                                                                                                                                                                  
a.Nrobooking,          
                                                                                                                                                                                                                                      
a.desviaje,        
                                                                                                                                                                                                                                          
a.unidad,      
                                                                                                                                                                                                                                              
c.dm_detraccion,      
                                                                                                                                                                                                                                       
c.dc_porcentaje_detraccion,    
                                                                                                                                                                                                                              
isnull(@inafecto, 0) as inafecto,    
                                                                                                                                                                                                                        
isnull(@afecto, 0) as afecto,    
                                                                                                                                                                                                                            
(isnull(@afecto, 0) * (1+d.impuesto)) + isnull(@inafecto, 0) as total    
                                                                                                                                                                                    
from DDORDFAC01 as a                     
                                                                                                                                                                                                                    
inner join TTSERV as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio                    
                                                                                                                                                
inner join TRUNNE_SERV as c on       
                                                                                                                                                                                                                        
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion      
                                                                                           
inner join DCORDFAC01 as d on a.id_orden = d.id_orden  
                                                                                                                                                                                                      
where a.Id_orden = @Id_Orden and c.dm_detraccion = @detraccion and c.dc_porcentaje_detraccion = @Porcentaje      
                                                                                                                                            
end
                                                                                                                                                                                                                                                          
return 0    
                                                                                                                                                                                                                                                 
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_DetOrdenSerPreResByIdOrden                
                                                                                                                                                                                     
@Id_orden int     
                                                                                                                                                                                                                                           
as    
                                                                                                                                                                                                                                                       
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin          
                                                                                                                                                                                                                                              
select distinct                
                                                                                                                                                                                                                              
a.Id_orden,                
                                                                                                                                                                                                                                  
c.dm_detraccion,  
                                                                                                                                                                                                                                           
c.dc_porcentaje_detraccion   
                                                                                                                                                                                                                                
from DDORDFAC01 as a                 
                                                                                                                                                                                                                        
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as c on   
                                                                                                                                                                                         
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion  
                                                                                               
where Id_orden = @Id_Orden   
                                                                                                                                                                                                                                
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin          
                                                                                                                                                                                                                                              
select distinct                
                                                                                                                                                                                                                              
a.Id_orden,                
                                                                                                                                                                                                                                  
c.dm_detraccion,  
                                                                                                                                                                                                                                           
c.dc_porcentaje_detraccion   
                                                                                                                                                                                                                                
from DDORDFAC01 as a                 
                                                                                                                                                                                                                        
inner join TRUNNE_SERV as c on   
                                                                                                                                                                                                                            
a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = c.dc_servicio and a.sucursal =  c.dc_sucursal_imputacion  and a.centrocosto = c.dc_centro_costo_imputacion  
                                                                                               
where Id_orden = @Id_Orden   
                                                                                                                                                                                                                                
end
                                                                                                                                                                                                                                                          
return 0        
                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Consultar_UltimoNroDocUltra
                                                                                                                                                                                                              
@TipoDoc int,
                                                                                                                                                                                                                                                
@dn_serie varchar(3),
                                                                                                                                                                                                                                        
@dc_Sucursal int
                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
select dn_documento_disponible, dn_ultimo_documento_emitido 
                                                                                                                                                                                                 
from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_puntos_de_impresion
                                                                                                                                                                                                            
where dc_tipo_documento = @TipoDoc and dn_serie = @dn_serie and dc_sucursal = @dc_Sucursal
                                                                                                                                                                   

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------
                                                                                                                                                                                                              
GO  
 ALTER procedure  dbo.sp_Facpa_ListarAcuerdo
                                                                                                                                                                                                                  
as
                                                                                                                                                                                                                                                           
select distinct	
                                                                                                                                                                                                                                             
	'id_acuerdo'	=(select id_acuerdo from dcacuerdopl
                                                                                                                                                                                                           
			where id_servicio = t.id_servicio and 
                                                                                                                                                                                                                    
			ruccliente = t.ruccliente and
                                                                                                                                                                                                                             
			id_tarifa = t.id_tarifa and
                                                                                                                                                                                                                               
			fechareg=(select max(a.fechareg) from dcacuerdopl a where a.id_servicio = t.id_servicio and a.ruccliente=t.ruccliente and t.id_tarifa=a.id_tarifa)),
                                                                                                      
	t.RucCliente,
                                                                                                                                                                                                                                               
	'Cliente'	= isnull(c.nombre,''),
                                                                                                                                                                                                                            
	id_Servicio,
                                                                                                                                                                                                                                                
	'Servicio'	= dg_servicio,
                                                                                                                                                                                                                                   
	id_tarifa,
                                                                                                                                                                                                                                                  
	'tarifa'	= isnull((select monto from dctarifapl where id_tarifa=t.id_tarifa),0),
                                                                                                                                                                            
	'descuento' 	=(select descuento from dcacuerdopl
                                                                                                                                                                                                            
			where id_servicio = t.id_servicio and 
                                                                                                                                                                                                                    
			ruccliente = t.ruccliente and
                                                                                                                                                                                                                             
			id_tarifa = t.id_tarifa and
                                                                                                                                                                                                                               
			fechareg=(select max(a.fechareg) from dcacuerdopl a where a.id_servicio = t.id_servicio and a.ruccliente=t.ruccliente and t.id_tarifa=a.id_tarifa))
                                                                                                       
from dcacuerdopl t
                                                                                                                                                                                                                                           
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios s on t.id_servicio = s.dc_servicio
                                                                                                                                                                             
inner join aaclientesaa c on c.contribuy = t.ruccliente
                                                                                                                                                                                                      
----------------------------------------------
                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------
                                                                                                                                                                                                              
GO  
 ALTER procedure  dbo.sp_Facpa_ListarTarifa
                                                                                                                                                                                                                   
as
                                                                                                                                                                                                                                                           
select distinct	
                                                                                                                                                                                                                                             
	'id_tarifa'	=(select id_tarifa from dctarifapl 
                                                                                                                                                                                                             
			where id_servicio = t.id_servicio and 
                                                                                                                                                                                                                    
			id_moneda = t.id_moneda and
                                                                                                                                                                                                                               
			fechareg=(select max(a.fechareg) from dctarifapl a where a.id_servicio = t.id_servicio and t.id_moneda=a.id_moneda)),
                                                                                                                                     
	t.id_servicio,
                                                                                                                                                                                                                                              
	'Servicio'	= dg_servicio,
                                                                                                                                                                                                                                   
	t.id_moneda,
                                                                                                                                                                                                                                                
	'monto' 	=(select monto from dctarifapl 
                                                                                                                                                                                                                    
			where id_servicio = t.id_servicio and 
                                                                                                                                                                                                                    
			id_moneda = t.id_moneda and
                                                                                                                                                                                                                               
			fechareg=(select max(a.fechareg) from dctarifapl a where a.id_servicio = t.id_servicio and t.id_moneda=a.id_moneda ))
                                                                                                                                     
from dctarifapl t
                                                                                                                                                                                                                                            
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios s on t.id_servicio = s.dc_servicio
                                                                                                                                                                             
----------------------------------------------
                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_f_tipo_cambio_obtiene_nep1 (@df_vigencia		VARCHAR(10),
                                                                                                                                                                                        
				@dq_tipo_de_cambio		FLOAT 		OUTPUT	,
                                                                                                                                                                                                                     
				@dg_resultado			VARCHAR(250) 	OUTPUT	)
                                                                                                                                                                                                                   
AS
                                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
	SELECT 	@dq_tipo_de_cambio = dq_tipo_de_cambio
                                                                                                                                                                                                              
  	FROM 	CALW12SQLCORP.NPT9_bd_inst.dbo.tb_tipo_cambio_inst
                                                                                                                                                                                                           
 	WHERE 	dc_tipo_paridad = 'VENTA'
                                                                                                                                                                                                                           
   	AND 	dc_moneda = 2
                                                                                                                                                                                                                                       
   	AND 	CONVERT( DATETIME,df_vigencia,105) = CONVERT( DATETIME,@df_vigencia,105)
                                                                                                                                                                            
END
                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------
                                                                                                                                                                                          
GO  
 ALTER procedure  dbo.SP_GASTOS_ActualizarServicioGrupo
                                                                                                                                                                                                       
	@intServicio	int,
                                                                                                                                                                                                                                           
	@intGrupo	int,
                                                                                                                                                                                                                                              
	@intCenCos	int,
                                                                                                                                                                                                                                             
	@bitTipo	bit
                                                                                                                                                                                                                                                
as
                                                                                                                                                                                                                                                           
/*
                                                                                                                                                                                                                                                           
set	@intServicio	= 212
                                                                                                                                                                                                                                       
set	@intGrupo	= 5
                                                                                                                                                                                                                                            
set	@intCenCos	= 1
                                                                                                                                                                                                                                           
set	@bitTipo	= 0*/
                                                                                                                                                                                                                                           
declare @intservarea	int
                                                                                                                                                                                                                                     
if @bitTipo = 1
                                                                                                                                                                                                                                              
  begin
                                                                                                                                                                                                                                                      
	set @intservarea = (select servicioarea from neptunia11.ordenesservicio.dbo.tav_servicioarea  -- neptunia11.ordenesservicio.dbo.tav_servicioarea 
                                                                                                           
			where servicio=@intServicio and area = @intCenCos)
                                                                                                                                                                                                        
	if exists(select idservicioarea from neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea -- neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea 
                                                                                                        
		where flagtiporegistro= @bitTipo and idservicioarea =@intservarea ) 
                                                                                                                                                                                       
	  begin
                                                                                                                                                                                                                                                     
		SET XACT_ABORT ON
                                                                                                                                                                                                                                          
		update neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea --neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea
                                                                                                                                       
		set IdGrupo= @intGrupo where idservicioarea = @intservarea --, flagtiporegistro = @bitTipo
                                                                                                                                                                 
	  end
                                                                                                                                                                                                                                                       
	else
                                                                                                                                                                                                                                                        
	  begin
                                                                                                                                                                                                                                                     
		SET XACT_ABORT ON
                                                                                                                                                                                                                                          
		insert neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea (idGrupo,idServicioArea,flagtiporegistro ) -- neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea (idGrupo,idServicioArea,flagtiporegistro )
                                                
		values(@intGrupo,@intservarea,@bitTipo)
                                                                                                                                                                                                                    
	  end
                                                                                                                                                                                                                                                       
  end
                                                                                                                                                                                                                                                        
else
                                                                                                                                                                                                                                                         
  begin
                                                                                                                                                                                                                                                      
--	set @intservarea = (select dc_item_gasto from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_item_gasto 
                                                                                                                                                                        
--			where dc_item_gasto = @intServicio)
                                                                                                                                                                                                                     
	set @intservarea = @intServicio
                                                                                                                                                                                                                             
	if exists(select idservicioarea from neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea -- neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea 
                                                                                                        
		where flagtiporegistro= @bitTipo and idservicioarea =@intservarea ) 
                                                                                                                                                                                       
	  begin
                                                                                                                                                                                                                                                     
		SET XACT_ABORT ON
                                                                                                                                                                                                                                          
		update neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea -- neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea
                                                                                                                                      
		set IdGrupo= @intGrupo where idservicioarea = @intservarea --, flagtiporegistro = @bitTipo
                                                                                                                                                                 
	  end
                                                                                                                                                                                                                                                       
	else
                                                                                                                                                                                                                                                        
	  begin
                                                                                                                                                                                                                                                     
		SET XACT_ABORT ON
                                                                                                                                                                                                                                          
		insert neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea (idGrupo,idServicioArea,flagtiporegistro ) --neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea (idGrupo,idServicioArea,flagtiporegistro )
                                                 
		values(@intGrupo,@intservarea,@bitTipo)
                                                                                                                                                                                                                    
	  end
                                                                                                                                                                                                                                                       
  end
                                                                                                                                                                                                                                                        
------------------------------------------------------------------
                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------
                                                                                                                                                                                         
GO  
 ALTER procedure  dbo.SP_GASTOS_CentroCostos 
                                                                                                                                                                                                                 
as
                                                                                                                                                                                                                                                           
select 	'codigo' = dc_centro_costo,
                                                                                                                                                                                                                          
	'nombre' = dg_centro_costo,
                                                                                                                                                                                                                                 
	'codInterno'= dg_alias_centro_costo
                                                                                                                                                                                                                         
from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo
                                                                                                                                                                                                                   
where dc_centro_costo in (1,2,5)
                                                                                                                                                                                                                             
-------------------------------------------------------------------
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------
                                                                                                                                                                                         
GO  
 ALTER procedure  dbo.SP_GASTOS_CentroCostoxIdSuc 
                                                                                                                                                                                                            
	@intSucursal	int
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
select 	'codigo' = cc.dc_centro_costo,
                                                                                                                                                                                                                       
	'nombre' = cc.dg_centro_costo,
                                                                                                                                                                                                                              
	'codInterno' = cc.dg_alias_centro_costo
                                                                                                                                                                                                                     
from CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst si
                                                                                                                                                                                                               
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on si.dc_sucursal = sc.sucursal
                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo cc on cc.dc_centro_costo = sc.centro_costos
                                                                                                                                                                 
where 	si.dc_sucursal = @intSucursal and
                                                                                                                                                                                                                     
	cc.dc_centro_costo in (1,2,5)
                                                                                                                                                                                                                               
group by cc.dc_centro_costo,cc.dg_centro_costo,cc.dg_alias_centro_costo
                                                                                                                                                                                      
--------------------------------------------------------------------------
                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------
                                                                                                                                                                                         
GO  
 ALTER procedure  dbo.SP_GASTOS_ListarProveedores
                                                                                                                                                                                                             
	@vchNombre varchar(25)
                                                                                                                                                                                                                                      
as 
                                                                                                                                                                                                                                                          
	select 	'codigo'= tp.dc_rut_proveedor,
                                                                                                                                                                                                                      
		'nombre'=  p.dg_razon_social 
                                                                                                                                                                                                                              
	from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_scd_relacion_tipo_proveedor tp
                                                                                                                                                                                                
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona p  on p.dc_rut = tp.dc_rut_proveedor
                                                                                                                                                                            
	where tp.dc_tipo_proveedor = 3 and
                                                                                                                                                                                                                          
		p.dg_razon_social like '%'+@vchNombre+'%'
                                                                                                                                                                                                                  
-------------------------------------------------------------------
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
                                                                                                                                                                                  
GO  
 ALTER procedure  dbo.SP_GASTOS_ListarProveedoresNomb 
                                                                                                                                                                                                        
	@vchNombre varchar(25)
                                                                                                                                                                                                                                      
as 
                                                                                                                                                                                                                                                          
	select 	'PROVEEDORRUC'= tp.dc_rut_proveedor,
                                                                                                                                                                                                                
		'PROVEDORNOMBRE'=  p.dg_razon_social 
                                                                                                                                                                                                                      
	from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_scd_relacion_tipo_proveedor tp
                                                                                                                                                                                                
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona p  on p.dc_rut = tp.dc_rut_proveedor
                                                                                                                                                                            
	where tp.dc_tipo_proveedor = 3 and
                                                                                                                                                                                                                          
		p.dg_razon_social like '%'+@vchNombre+'%'
                                                                                                                                                                                                                  
---------------------------------------------------------------------------
                                                                                                                                                                                  

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------
                                                                                                                                                                                   
GO  
 ALTER procedure  dbo.SP_GASTOS_ListarServicioxGrupo
                                                                                                                                                                                                          
	@intGrupo	int
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
/*
                                                                                                                                                                                                                                                           
descripcion: 	Lisat todos los servicios que se encuentra agrupados en dicho
                                                                                                                                                                                  
		id
                                                                                                                                                                                                                                                         
*/
                                                                                                                                                                                                                                                           
select 	'CON_SERVICIO'=sa.idservicioarea,
                                                                                                                                                                                                                    
	'CON_NOMBRE' = ig.Glosa_de_operaciones
                                                                                                                                                                                                                      
from neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea sa
                                                                                                                                                                                                
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES ig on sa.idservicioarea = ig.id_codigo
                                                                                                                                                            
where 	sa.idgrupo = @intGrupo and
                                                                                                                                                                                                                            
	flagtiporegistro = 0
                                                                                                                                                                                                                                        
order by ig.Glosa_de_operaciones
                                                                                                                                                                                                                             
--------------------------------------------------------------------------
                                                                                                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
                                                                                                                                                                                  
GO  
 ALTER procedure  dbo.SP_GASTOS_ObtenerGastosAgrupados 
                                                                                                                                                                                                       
	@intCenCos	int,
                                                                                                                                                                                                                                             
	@intGrupo	int
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
/*
                                                                                                                                                                                                                                                           
descripcion: 	Obtiene un listado de todos los Gastos que se encuentren agrupados en
                                                                                                                                                                          
		dicho id de la tabla de gastos
                                                                                                                                                                                                                             
*/
                                                                                                                                                                                                                                                           
select 	'codigo'=sc.item_de_gasto,
                                                                                                                                                                                                                           
	'nombre' = ig.dg_item_gasto,
                                                                                                                                                                                                                                
--	sc.sucursal,
                                                                                                                                                                                                                                              
	'CenCos' = sc.centro_costos
                                                                                                                                                                                                                                 
from neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea sa 
                                                                                                                                                                                               
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = sa.idservicioarea
                                                                                                                                                            
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_item_gasto ig on sc.item_de_gasto = ig.dc_item_gasto
                                                                                                                                                                     
where 	sc.centro_costos = @intCenCos and 
                                                                                                                                                                                                                    
	sa.idgrupo = @intGrupo and
                                                                                                                                                                                                                                  
	flagtiporegistro = 0
                                                                                                                                                                                                                                        
group by sc.item_de_gasto,ig.dg_item_gasto,sc.centro_costos
                                                                                                                                                                                                  
order by ig.dg_item_gasto
                                                                                                                                                                                                                                    
--------------------------------------------------------------------------
                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------  
                                                                                                                                                                                 
GO  
 ALTER procedure  dbo.SP_GASTOS_ObtenerGastosNoAgrupados  
                                                                                                                                                                                                    
	 @intCenCos int,  
                                                                                                                                                                                                                                          
	 @intGrupo int  
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
select  'codigo'= ig.id_codigo,--IG.codigoint,  
                                                                                                                                                                                                             
 	'nombre' = ig.glosa_de_operaciones,---ig.CONCEPTO,  
                                                                                                                                                                                                       
 	'CenCos' = sc.centro_costos
                                                                                                                                                                                                                                
from CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES ig--ITEMGASTO ig  
                                                                                                                                                                                      
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = ig.codigo_de_ultragestion --suc_cencos_ITEMGASTO sc on sc.ITEMGASTO = ig.CODIGO
                                                                                              
where  
                                                                                                                                                                                                                                                      
--sc.cencos = @intCenCos and   
                                                                                                                                                                                                                              
--ig.codigoint
                                                                                                                                                                                                                                               
 sc.centro_costos = @intCenCos and   
                                                                                                                                                                                                                        
 IG.id_codigo not in (select idServicioArea from neptunia11.ordenesservicio.dbo.ost_grupo_servicioarea 
                                                                                                                                                      
    			where idgrupo=@intGrupo and flagtiporegistro=0)  
                                                                                                                                                                                                     
--group by sc.cencos,IG.codigoint,ig.CONCEPTO
                                                                                                                                                                                                                
group by   sc.centro_costos,IG.id_codigo,ig.glosa_de_operaciones
                                                                                                                                                                                             
order by ig.glosa_de_operaciones
                                                                                                                                                                                                                             
--------------------------------------------------------------------------
                                                                                                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  dbo.SP_GASTOS_ObtenerSucursales
                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
/*
                                                                                                                                                                                                                                                           
descripcion : Obtiene los centros de costos activos
                                                                                                                                                                                                          
fecha : 11/10/2005
                                                                                                                                                                                                                                           
*/
                                                                                                                                                                                                                                                           
	select 	'codigo' = dc_sucursal,
                                                                                                                                                                                                                             
		'nombre' = dg_sucursal,
                                                                                                                                                                                                                                    
		'codInterno' = dg_alias_sucursal
                                                                                                                                                                                                                           
	from CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst
                                                                                                                                                                                                                 
	where getdate() between df_vigencia_inicio and df_vigencia_termino	
                                                                                                                                                                                         
	order by dg_sucursal
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------
                                                                                                                                                                                                    
GO  
 ALTER procedure  dbo.SP_Gastos_ObtenerSucursalxNom
                                                                                                                                                                                                           
	@vchSucursal	varchar(20)
                                                                                                                                                                                                                                    
as
                                                                                                                                                                                                                                                           
	select 	'ORDENSUCURSAL' = dc_sucursal,
                                                                                                                                                                                                                      
		'ORDENNOMBRESUC' = dg_sucursal
                                                                                                                                                                                                                             
		--'codInterno' = dg_alias_sucursal
                                                                                                                                                                                                                         
	from CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst
                                                                                                                                                                                                                 
	where getdate() between df_vigencia_inicio and df_vigencia_termino
                                                                                                                                                                                          
		and dg_sucursal like ''+ @vchSucursal + '%'
                                                                                                                                                                                                                
	order by dg_sucursal
                                                                                                                                                                                                                                        
--------------------------------------------------------
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  dbo.SP_GASTO_ObtenerCenCosxSucxNom
                                                                                                                                                                                                          
	@vchNombre varchar(25),
                                                                                                                                                                                                                                     
	@intSucursal int
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
if @intSucursal <> 0
                                                                                                                                                                                                                                         
  begin
                                                                                                                                                                                                                                                      
	select 	'ORDENCDC' = cc.dc_centro_costo,
                                                                                                                                                                                                                    
		'ORDENNOMBRECDC' = cc.dg_centro_costo		
                                                                                                                                                                                                                    
	from CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst si
                                                                                                                                                                                                              
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on si.dc_sucursal = sc.sucursal
                                                                                                                                                                   
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo cc on cc.dc_centro_costo = sc.centro_costos
                                                                                                                                                                
	where 	si.dc_sucursal = @intSucursal and
                                                                                                                                                                                                                    
		cc.dc_centro_costo in (1,2,5) and
                                                                                                                                                                                                                          
		cc.dg_centro_costo like '' + @vchNombre + '%'
                                                                                                                                                                                                              
	group by cc.dc_centro_costo,cc.dg_centro_costo,cc.dg_alias_centro_costo
                                                                                                                                                                                     
  end
                                                                                                                                                                                                                                                        
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  [dbo].[sp_Impo_Busca_Bloqueo_Volante_Etiquetera_2]                
                                                                                                                                                                         
@sVolante char(6)        
                                                                                                                                                                                                                                    
as        
                                                                                                                                                                                                                                                   
  
                                                                                                                                                                                                                                                           
SET XACT_ABORT ON  
                                                                                                                                                                                                                                          
BEGIN TRAN  
                                                                                                                                                                                                                                                 
  
                                                                                                                                                                                                                                                           
declare @sCodAge char(04)        
                                                                                                                                                                                                                            
declare @sBloOpe char(01)        
                                                                                                                                                                                                                            
declare @sBloCom char(01)        
                                                                                                                                                                                                                            
declare @sSucurs char(01)        
                                                                                                                                                                                                                            
declare @sRucCli char(11)        
                                                                                                                                                                                                                            
declare @sTipMer char(03)        
                                                                                                                                                                                                                            
declare @sConCit char(02)       
                                                                                                                                                                                                                             
declare @sCodCit char(03)       
                                                                                                                                                                                                                             
declare @iCanItm integer        
                                                                                                                                                                                                                             
declare @iCanBlo integer        
                                                                                                                                                                                                                             
declare @iConCit integer        
                                                                                                                                                                                                                             
declare @dMonDol decimal(12,2)        
                                                                                                                                                                                                                       
declare @dMonSol decimal(12,2)        
                                                                                                                                                                                                                       
declare @iCanDes integer      
                                                                                                                                                                                                                               
        
                                                                                                                                                                                                                                                     
set @sCodAge=''        
                                                                                                                                                                                                                                      
set @sBloOpe='0'        
                                                                                                                                                                                                                                     
set @sBloCom='0'        
                                                                                                                                                                                                                                     
set @sSucurs=''        
                                                                                                                                                                                                                                      
set @sRucCli='0000'        
                                                                                                                                                                                                                                  
set @sConCit=''        
                                                                                                                                                                                                                                      
set @iCanDes=0        
                                                                                                                                                                                                                                       
      
                                                                                                                                                                                                                                                       
select @iCanItm=count(distinct b.codcon63) from ddvoldes23 a (nolock)        
                                                                                                                                                                                
inner join drblcont15 b (nolock) on (        
                                                                                                                                                                                                                
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and a.nrosec23=b.nrosec23)        
                                                                                                                                                                           
where         
                                                                                                                                                                                                                                               
a.nrosec23=@sVolante        
                                                                                                                                                                                                                                 
      
                                                                                                                                                                                                                                                       
select @sRucCli =isnull(a.ruccli12,'0000') from ddvoldes23 a (nolock)        
                                                                                                                                                                                
inner join drblcont15 b (nolock) on (        
                                                                                                                                                                                                                
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and a.nrosec23=b.nrosec23)        
                                                                                                                                                                           
where         
                                                                                                                                                                                                                                               
a.nrosec23=@sVolante        
                                                                                                                                                                                                                                 
      
                                                                                                                                                                                                                                                       
      
                                                                                                                                                                                                                                                       
if @iCanItm>0         
                                                                                                                                                                                                                                       
begin        
                                                                                                                                                                                                                                                
 set @sTipMer='CTR'        
                                                                                                                                                                                                                                  
 select @iCanBlo=count(distinct b.codcon63) from ddvoldes23 a (nolock)        
                                                                                                                                                                               
 inner join drblcont15 b (nolock) on (        
                                                                                                                                                                                                               
 a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and a.nrosec23=b.nrosec23)        
                                                                                                                                                                          
 where         
                                                                                                                                                                                                                                              
 a.nrosec23=@sVolante and b.flgblo60='1'        
                                                                                                                                                                                                             
end        
                                                                                                                                                                                                                                                  
        
                                                                                                                                                                                                                                                     
if @iCanItm=0         
                                                                                                                                                                                                                                       
begin        
                                                                                                                                                                                                                                                
 select @iCanItm=count(distinct b.nrosec22)  from ddvoldes23 a (nolock)        
                                                                                                                                                                              
 inner join ddcartar22 b (nolock) on (a.nrosec23=b.nrosec23)        
                                                                                                                                                                                         
 where         
                                                                                                                                                                                                                                              
 a.nrosec23=@sVolante        
                                                                                                                                                                                                                                
 if @iCanItm>0         
                                                                                                                                                                                                                                      
 begin        
                                                                                                                                                                                                                                               
  set @sTipMer='BUL'        
                                                                                                                                                                                                                                 
  select @iCanBlo=count(distinct b.nrosec22) from ddvoldes23 a (nolock)        
                                                                                                                                                                              
  inner join ddcartar22 b (nolock) on (a.nrosec23=b.nrosec23)        
                                                                                                                                                                                        
  where         
                                                                                                                                                                                                                                             
  a.nrosec23=@sVolante and b.flgblo60='1'        
                                                                                                                                                                                                            
 end        
                                                                                                                                                                                                                                                 
end        
                                                                                                                                                                                                                                                  
        
                                                                                                                                                                                                                                                     
if @iCanItm=0         
                                                                                                                                                                                                                                       
begin        
                                                                                                                                                                                                                                                
 select @iCanItm=count(distinct b.nroveh14) from ddvoldes23 a (nolock)        
                                                                                                                                                                               
 inner join ddvehicu14 b (nolock) on (a.nrosec23=b.nrosec23)        
                                                                                                                                                                                         
 where         
                                                                                                                                                                                                                                              
 a.nrosec23=@sVolante        
                                                                                                                                                                                                                                
 if @iCanItm>0         
                                                                                                                                                                                                                                      
 begin        
                                                                                                                                                                                                                                               
  set @sTipMer='VEH'        
                                                                                                                                                                                                                                 
  select @iCanBlo=count(distinct b.nroveh14) from ddvoldes23 a (nolock)        
                                                                                                                                                                              
  inner join ddvehicu14 b (nolock) on (a.nrosec23=b.nrosec23)        
                                                                                                                                                                                        
  where         
                                                                                                                                                                                                                                             
  a.nrosec23=@sVolante and b.flgblo60='1'        
                                                                                                                                                                                                            
 end        
                                                                                                                                                                                                                                                 
end        
                                                                                                                                                                                                                                                  
      
                                                                                                                                                                                                                                                       
select @iConCit=count(*) from Calw3bdpor.Gneptuniacitas.dbo.CIT_Cita where cod_Volante=@sVolante       
                                                                                                                                                      
      
                                                                                                                                                                                                                                                       
if @iConCit>0      
                                                                                                                                                                                                                                          
 begin      
                                                                                                                                                                                                                                                 
  select top 1 @sCodCit=cod_estado from Calw3bdpor.Gneptuniacitas.dbo.CIT_Cita where cod_Volante=@sVolante order by Fec_Reg_Cita desc       
                                                                                                                 
  set @sConCit='SI'      
                                                                                                                                                                                                                                    
 end       
                                                                                                                                                                                                                                                  
else      
                                                                                                                                                                                                                                                   
 begin      
                                                                                                                                                                                                                                                 
  set @sConCit='NO'      
                                                                                                                                                                                                                                    
  set @sCodCit=''      
                                                                                                                                                                                                                                      
 end         
                                                                                                                                                                                                                                                
if @iCanItm=0        
                                                                                                                                                                                                                                        
select @sVolante,@sCodAge,@sBloOpe,@sBloCom,@sSucurs,@sRucCli,@sConCit,@sCodCit        
                                                                                                                                                                      
        
                                                                                                                                                                                                                                                     
if @iCanItm>0        
                                                                                                                                                                                                                                        
begin        
                                                                                                                                                                                                                                                
  select @iCanDes=count(CONTRIBUY) from ddautdoc16         
                                                                                                                                                                                                  
  where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate())       
                                                                                                                                          
  and CONTRIBUY=@sRucCli       
                                                                                                                                                                                                                              
      
                                                                                                                                                                                                                                                       
 if @iCanDes>0      
                                                                                                                                                                                                                                         
     set @sBloCom='0'      
                                                                                                                                                                                                                                  
 else       
                                                                                                                                                                                                                                                 
 begin       
                                                                                                                                                                                                                                                
  Select                 
                                                                                                                                                                                                                                    
  @dMonSol=isnull(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                
                                                                                                                                                                    
  @dMonDol=isnull(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                
                                                                                                                                                                   
  From CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                
                                                                                                                                                                                         
  Where RUC=@sRucCli and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0       
                                                                                                                                                              
  and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO      
                                                                                                                                                                                     
  --if @dMonSol>0         
                                                                                                                                                                                                                                   
  -- set @sBloCom='1'      
                                                                                                                                                                                                                                  
  --if @dMonDol>0         
                                                                                                                                                                                                                                   
  -- set @sBloCom='1'      
                                                                                                                                                                                                                                  
    if @dMonSol>0 or @dMonDol > 0         
                                                                                                                                                                                                                   
   set @sBloCom='1'      
                                                                                                                                                                                                                                    
  print 'XXXXXXXXXXXXXXX'
                                                                                                                                                                                                                                    
  print @dMonSol
                                                                                                                                                                                                                                             
  print @dMonDol
                                                                                                                                                                                                                                             
  print @sRucCli	     
                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
  --SET XACT_ABORT OFF  
                                                                                                                                                                                                                                     
  --GO  
                                                                                                                                                                                                                                                     
  --BEGIN TRAN  
                                                                                                                                                                                                                                             
  if (select top 1 contribuy  
                                                                                                                                                                                                                               
 from CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO   
                                                                                                                                                                                                  
 where contribuy=@sRucCli   
                                                                                                                                                                                                                                 
 and year(registro)=year(getdate())   
                                                                                                                                                                                                                       
 and month(registro)=month(getdate())   
                                                                                                                                                                                                                     
 and day(registro)=day(getdate()) )= 0  
                                                                                                                                                                                                                     
  print @sRucCli
                                                                                                                                                                                                                                             
  print 'YYY'
                                                                                                                                                                                                                                                
     --Insert CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO)   
                                                                                                                                                    
     --values (@sRucCli,user,'TAIM',getdate())    
                                                                                                                                                                                                           
  --end       
                                                                                                                                                                                                                                               
  --COMMIT TRAN  
                                                                                                                                                                                                                                            
  --GO  
                                                                                                                                                                                                                                                     
       
                                                                                                                                                                                                                                                      
   --print cast(@dMonSol as char(10))      
                                                                                                                                                                                                                  
   --print cast(@dMonDol as char(10))      
                                                                                                                                                                                                                  
   --print @sRucCli      
                                                                                                                                                                                                                                    
       
                                                                                                                                                                                                                                                      
 --end      
                                                                                                                                                                                                                                                 
 
                                                                                                                                                                                                                                                            
 select @sRucCli=ruccli12, @sCodAge=codage19, @sSucurs=sucursal from ddvoldes23 where nrosec23=@sVolante        
                                                                                                                                             
 if @iCanBlo>0        
                                                                                                                                                                                                                                       
  if @iCanBlo<@iCanItm        
                                                                                                                                                                                                                               
   set @sBloOpe='2'        
                                                                                                                                                                                                                                  
  else        
                                                                                                                                                                                                                                               
   set @sBloOpe='1'        
                                                                                                                                                                                                                                  
 select @sVolante,@sCodAge,@sBloOpe,@sBloCom,@sSucurs,@sRucCli,@sConCit,@sCodCit        
                                                                                                                                                                     
end        
                                                                                                                                                                                                                                                  
COMMIT TRAN  
                                                                                                                                                                                                                                                
end
                                                                                                                                                                                                                                                          
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SP_IMPRIMEDET_OT
                                                                                                                                                                                                                            
@nroord01 varchar(6)
                                                                                                                                                                                                                                         
as
                                                                                                                                                                                                                                                           
select a.IdDetalle, a.IdSucursal, a.IdCentroCosto, a.IdTipoServ, a.PrecioUnit, 
                                                                                                                                                                              
a.Cantidad, a.NroOrd01, a.NroFac01, b.dg_sucursal, c.dg_centro_costo, d.dg_servicio, 
                                                                                                                                                                        
convert(varchar(10), e.fecfac01, 103) as fecfac01, e.totalfac, e.estado01
                                                                                                                                                                                    
from ddordtra01 as a inner join CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst as b on a.IdSucursal = b.dc_sucursal 
                                                                                                                                                 
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as c on a.IdCentroCosto = c.dc_centro_costo 
                                                                                                                                                                
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as d on d.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS = a.IdTipoServ COLLATE SQL_Latin1_General_CP1_CI_AS 
                                                                                                
left join cdfactot01 as e on e.nrofac01 = a.nrofac01
                                                                                                                                                                                                         
where a.nroord01 = @nroord01 
                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SP_IMPRIMEFACTURAdet_OT
                                                                                                                                                                                                                     
@nroord01 varchar(6),
                                                                                                                                                                                                                                        
@nrofac01 char(9)      
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
select a.IdDetalle, a.IdSucursal, a.IdCentroCosto, a.IdTipoServ, a.PrecioUnit, 
                                                                                                                                                                              
a.Cantidad, a.NroOrd01, a.NroFac01, b.dg_sucursal, c.dg_centro_costo, d.dg_servicio, 
                                                                                                                                                                        
convert(varchar(10), e.fecfac01, 103) as fecfac01, e.totalfac, e.estado01 
                                                                                                                                                                                   
from ddordtra01 as a inner join CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst as b on a.IdSucursal = b.dc_sucursal 
                                                                                                                                                 
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as c on a.IdCentroCosto = c.dc_centro_costo 
                                                                                                                                                                
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as d on d.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS = a.IdTipoServ COLLATE SQL_Latin1_General_CP1_CI_AS 
                                                                                                
left join cdfactot01 as e on e.nrofac01 = a.nrofac01
                                                                                                                                                                                                         
where a.nroord01 = @nroord01 and a.nrofac01 = @nrofac01
                                                                                                                                                                                                      
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SP_INSERT_CLIENTES_ESPECIALES      
                                                                                                                                                                                                         
@RUC VARCHAR(11),      
                                                                                                                                                                                                                                      
@NOMBRE VARCHAR(250),      
                                                                                                                                                                                                                                  
@SQL VARCHAR(1)      
                                                                                                                                                                                                                                        
AS      
                                                                                                                                                                                                                                                     
BEGIN      
                                                                                                                                                                                                                                                  
	SET @RUC=LTRIM(RTRIM(@RUC))      
                                                                                                                                                                                                                           
	SET @NOMBRE=LTRIM(RTRIM(@NOMBRE))      
                                                                                                                                                                                                                     
       
                                                                                                                                                                                                                                                      
	IF @SQL='I'      
                                                                                                                                                                                                                                           
	BEGIN      
                                                                                                                                                                                                                                                 
		Insert into CALW12SQLCORP.NPT9_Datawarehouse.dbo.CLIENTES_ESPECIALES (RUC,NOMBRE,FECHA,usuario)       
                                                                                                                                                              
		Values (@RUC,@NOMBRE,GETDATE(),user_name())      
                                                                                                                                                                                                          
		RETURN;      
                                                                                                                                                                                                                                              
	END      
                                                                                                                                                                                                                                                   
       
                                                                                                                                                                                                                                                      
	IF @SQL='D'      
                                                                                                                                                                                                                                           
	BEGIN      
                                                                                                                                                                                                                                                 
		Delete from CALW12SQLCORP.NPT9_Datawarehouse.dbo.CLIENTES_ESPECIALES where RUC=@RUC     
                                                                                                                                                                            
		insert into DDAUDITESP00(nomtab00,tipope00,codusu00,fecope00,hostid00,ruc00,name00) 
                                                                                                                                                                       
		values('CLIENTES_ESPECIALES','D',user_name(),getdate(),host_name(),@RUC,@NOMBRE)
                                                                                                                                                                           
		RETURN;      
                                                                                                                                                                                                                                              
	END      
                                                                                                                                                                                                                                                   
END                                                                                                                                                                                                                                                            
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaAlquilaMaqServpl  --  '20080101','20080201','2'  
                                                                                                                                                                                   
@Fecini varchar(8),      
                                                                                                                                                                                                                                    
@Fecfin Varchar(8),      
                                                                                                                                                                                                                                    
@moneda char(1)      
                                                                                                                                                                                                                                        
as      
                                                                                                                                                                                                                                                     
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN     
                                                                                                                                                                                                                                                   
select a.id_orden, a.FechaOrden, a.rucxcuenta,a.moneda,      
                                                                                                                                                                                                
a.numerodoc,       
                                                                                                                                                                                                                                          
convert(varchar(10), a.fechadoc, 103) as fechadoc,        
                                                                                                                                                                                                   
a.total, a.codigonave, a.idmuelle,      
                                                                                                                                                                                                                     
a.idmuelleseg, codigolinea, a.numvia, a.desnave,       
                                                                                                                                                                                                      
b.tarifa, b.cantidad, b.afectoigv, b.idmaquina,       
                                                                                                                                                                                                       
b.tipocobro, b.id_proveedor, b.idtipomaquina,       
                                                                                                                                                                                                         
convert(varchar(20),c.descri61) as descri61,      
                                                                                                                                                                                                           
convert(char(60), d.nombre) as Cliente,      
                                                                                                                                                                                                                
convert(char(40), case when e.desnav08 is null then e.desnav08  
                                                                                                                                                                                             
                       else a.desnave end) as desnav08,            
                                                                                                                                                                                          
b.tiposerv,      
                                                                                                                                                                                                                                            
f.rucprov,      
                                                                                                                                                                                                                                             
convert(char(60), f.nombreprov) as nombreprov,      
                                                                                                                                                                                                         
case when b.id_proveedor is not null then 'TERCEROS'      
                                                                                                                                                                                                   
     when b.id_proveedor is null then 'NEPTUNIA'  end AS SERVICIOS,      
                                                                                                                                                                                    
g.dg_servicio,      
                                                                                                                                                                                                                                         
b.tarifa * b.cantidad as TotalUnit      
                                                                                                                                                                                                                     
from dcordfacpl as a       
                                                                                                                                                                                                                                  
inner join ddordfacpl as b on a.id_orden = b.id_orden      
                                                                                                                                                                                                  
inner join aaclientesaa as d on a.rucxcuenta = d.contribuy     
                                                                                                                                                                                              
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as g on b.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS = g.dc_Servicio      
                                                                                                                                  
left join depositos.dbo.PDTIPMAQ61  as c on b.idtipomaquina  = c.codtip61      
                                                                                                                                                                              
left join dqnavier08 as e on a.codigonave = e.codnav08      
                                                                                                                                                                                                 
left join dcprovfacpl as f on b.id_proveedor = f.id_proveedor       
                                                                                                                                                                                         
where a.tipodoc = '01' and a.estado = 'u'      
                                                                                                                                                                                                              
and a.fechadoc between @Fecini and @Fecfin and a.moneda = @moneda    
                                                                                                                                                                                        
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
BEGIN     
                                                                                                                                                                                                                                                   
select a.id_orden, a.FechaOrden, a.rucxcuenta,a.moneda,      
                                                                                                                                                                                                
a.numerodoc,       
                                                                                                                                                                                                                                          
convert(varchar(10), a.fechadoc, 103) as fechadoc,        
                                                                                                                                                                                                   
a.total, a.codigonave, a.idmuelle,      
                                                                                                                                                                                                                     
a.idmuelleseg, codigolinea, a.numvia, a.desnave,       
                                                                                                                                                                                                      
b.tarifa, b.cantidad, b.afectoigv, b.idmaquina,       
                                                                                                                                                                                                       
b.tipocobro, b.id_proveedor, b.idtipomaquina,       
                                                                                                                                                                                                         
convert(varchar(20),c.desuni54) as descri61,      
                                                                                                                                                                                                           
convert(char(60), d.nombre) as Cliente,      
                                                                                                                                                                                                                
convert(char(40), case when e.desnav08 is null then e.desnav08  
                                                                                                                                                                                             
                       else a.desnave end) as desnav08,            
                                                                                                                                                                                          
b.tiposerv,      
                                                                                                                                                                                                                                            
f.rucprov,      
                                                                                                                                                                                                                                             
convert(char(60), f.nombreprov) as nombreprov,      
                                                                                                                                                                                                         
case when b.id_proveedor is not null then 'TERCEROS'      
                                                                                                                                                                                                   
     when b.id_proveedor is null then 'NEPTUNIA'  end AS SERVICIOS,      
                                                                                                                                                                                    
g.dg_servicio,      
                                                                                                                                                                                                                                         
b.tarifa * b.cantidad as TotalUnit      
                                                                                                                                                                                                                     
from dcordfacpl as a       
                                                                                                                                                                                                                                  
inner join ddordfacpl as b on a.id_orden = b.id_orden      
                                                                                                                                                                                                  
inner join aaclientesaa as d on a.rucxcuenta = d.contribuy     
                                                                                                                                                                                              
inner join TTSERV as g on b.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS = g.dc_Servicio      
                                                                                                                                                              
left join DQUNIMED54 as c on b.idtipomaquina  = c.codpan54     
                                                                                                                                                                                              
left join dqnavier08 as e on a.codigonave = e.codnav08      
                                                                                                                                                                                                 
left join dcprovfacpl as f on b.id_proveedor = f.id_proveedor       
                                                                                                                                                                                         
where a.tipodoc = '01' and a.estado = 'u'      
                                                                                                                                                                                                              
and a.fechadoc between @Fecini and @Fecfin and a.moneda = @moneda    
                                                                                                                                                                                        
end
                                                                                                                                                                                                                                                          
return 0      
                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaAlquilaMaqServRespl    
                                                                                                                                                                                                             
@Fecini varchar(8),    
                                                                                                                                                                                                                                      
@Fecfin Varchar(8),    
                                                                                                                                                                                                                                      
@moneda char(1)    
                                                                                                                                                                                                                                          
as    
                                                                                                                                                                                                                                                       
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin
                                                                                                                                                                                                                                                        
select     
                                                                                                                                                                                                                                                  
case when b.id_proveedor is not null then 'TERCEROS'    
                                                                                                                                                                                                     
     when b.id_proveedor is null then 'NEPTUNIA' end  AS SERVICIOS,    
                                                                                                                                                                                      
g.dg_servicio,    
                                                                                                                                                                                                                                           
sum(b.tarifa * b.cantidad) as TotalUnit    
                                                                                                                                                                                                                  
from dcordfacpl as a     
                                                                                                                                                                                                                                    
inner join ddordfacpl as b on a.id_orden = b.id_orden    
                                                                                                                                                                                                    
inner join aaclientesaa as d on a.rucxcuenta = d.contribuy    
                                                                                                                                                                                               
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as g on b.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS = g.dc_Servicio    
                                                                                                                                    
where a.tipodoc = '01' and a.estado = 'u'    
                                                                                                                                                                                                                
and a.fechadoc between @Fecini and @Fecfin and a.moneda = @moneda     
                                                                                                                                                                                       
group by a.rucxcuenta,a.moneda,d.nombre,g.dg_servicio,    
                                                                                                                                                                                                   
case when b.id_proveedor is not null then 'TERCEROS'    
                                                                                                                                                                                                     
     when b.id_proveedor is null then 'NEPTUNIA' end     
                                                                                                                                                                                                    
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
select     
                                                                                                                                                                                                                                                  
case when b.id_proveedor is not null then 'TERCEROS'    
                                                                                                                                                                                                     
     when b.id_proveedor is null then 'NEPTUNIA' end  AS SERVICIOS,    
                                                                                                                                                                                      
g.dg_servicio,    
                                                                                                                                                                                                                                           
sum(b.tarifa * b.cantidad) as TotalUnit    
                                                                                                                                                                                                                  
from dcordfacpl as a     
                                                                                                                                                                                                                                    
inner join ddordfacpl as b on a.id_orden = b.id_orden    
                                                                                                                                                                                                    
inner join aaclientesaa as d on a.rucxcuenta = d.contribuy    
                                                                                                                                                                                               
inner join TTSERV as g on b.TipoServ COLLATE SQL_Latin1_General_CP1_CI_AS = g.dc_Servicio    
                                                                                                                                                                
where a.tipodoc = '01' and a.estado = 'u'    
                                                                                                                                                                                                                
and a.fechadoc between @Fecini and @Fecfin and a.moneda = @moneda     
                                                                                                                                                                                       
group by a.rucxcuenta,a.moneda,d.nombre,g.dg_servicio,    
                                                                                                                                                                                                   
case when b.id_proveedor is not null then 'TERCEROS'    
                                                                                                                                                                                                     
     when b.id_proveedor is null then 'NEPTUNIA' end     
                                                                                                                                                                                                    
end
                                                                                                                                                                                                                                                          
return 0    
                                                                                                                                                                                                                                                 
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  sp_ListaCentroCosto      
                                                                                                                                                                                                                  
@centrocosto int      
                                                                                                                                                                                                                                       
AS        
                                                                                                                                                                                                                                                   
declare @Fecha datetime
                                                                                                                                                                                                                                      
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN     
                                                                                                                                                                                                                                                   
SELECT DISTINCT a.dc_centro_costo, a.dg_centro_costo     
                                                                                                                                                                                                    
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as a 
                                                                                                                                                                                                             
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b      
                                                                                                                                                                                         
on a.dc_centro_costo = b.dc_centro_costo_imputacion      
                                                                                                                                                                                                    
where b.dc_sucursal_imputacion = @centrocosto and dc_centro_costo <> 0     
                                                                                                                                                                                  
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
BEGIN     
                                                                                                                                                                                                                                                   
SELECT DISTINCT a.dc_centro_costo, a.dg_centro_costo     
                                                                                                                                                                                                    
FROM TTUNID_NEGO as a 
                                                                                                                                                                                                                                       
inner join TRUNNE_SERV as b      
                                                                                                                                                                                                                            
on a.dc_centro_costo = b.dc_centro_costo_imputacion      
                                                                                                                                                                                                    
where b.dc_sucursal_imputacion = @centrocosto and dc_centro_costo <> 0     
                                                                                                                                                                                  
end
                                                                                                                                                                                                                                                          
return 0        
                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaCentroCostoTodos    
                                                                                                                                                                                                                
as      
                                                                                                                                                                                                                                                     
declare @Fecha datetime  
                                                                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
/*SELECT  @Fecha = feclec00 FROM FIC_CONTA00  
                                                                                                                                                                                                               
where codfic00 = 'OF'  
                                                                                                                                                                                                                                      
print @Fecha  
                                                                                                                                                                                                                                               
IF @FECHA > GETDATE()  
                                                                                                                                                                                                                                      
BEGIN       
                                                                                                                                                                                                                                                 
SELECT  dc_centro_costo, dg_centro_costo         
                                                                                                                                                                                                            
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo    
                                                                                                                                                                                                               
end  
                                                                                                                                                                                                                                                        
else  */
                                                                                                                                                                                                                                                     
BEGIN       
                                                                                                                                                                                                                                                 
SELECT  dc_centro_costo, dg_centro_costo         
                                                                                                                                                                                                            
FROM TTUNID_NEGO    
                                                                                                                                                                                                                                         
end  
                                                                                                                                                                                                                                                        
return 0    
                                                                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- sp_ListaCentroCosto_MTEK_EWMN   4      
                                                                                                                                                                                                                   
GO  
 ALTER procedure  sp_ListaCentroCosto_MTEK_EWMN          
                                                                                                                                                                                                     
@centrocosto int          
                                                                                                                                                                                                                                   
AS            
                                                                                                                                                                                                                                               
declare @Fecha datetime    
                                                                                                                                                                                                                                  
SELECT  @Fecha = feclec00 FROM FIC_CONTA00    
                                                                                                                                                                                                               
where codfic00 = 'OF'    
                                                                                                                                                                                                                                    
  
                                                                                                                                                                                                                                                           
declare @FechaHoy Datetime -- Add EWMN 28.11.2011: Solo Vigentes  
                                                                                                                                                                                           
set @FechaHoy = CONVERT(datetime, DATEDIFF(d, 0, getdate()), 102) -- Add EWMN 28.11.2011: Solo Vigentes  
                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
IF @FECHA > GETDATE()    
                                                                                                                                                                                                                                    
BEGIN         
                                                                                                                                                                                                                                               
SELECT DISTINCT a.dc_centro_costo, a.dg_centro_costo         
                                                                                                                                                                                                
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as a     
                                                                                                                                                                                                         
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b          
                                                                                                                                                                                     
on a.dc_centro_costo = b.dc_centro_costo_imputacion          
                                                                                                                                                                                                
where b.dc_sucursal_imputacion = @centrocosto and dc_centro_costo <> 0         
                                                                                                                                                                              
and a.df_termino_vigencia > = @FechaHoy  -- Add EWMN 28.11.2011: Solo Vigentes  
                                                                                                                                                                             
end    
                                                                                                                                                                                                                                                      
else    
                                                                                                                                                                                                                                                     
BEGIN         
                                                                                                                                                                                                                                               
SELECT DISTINCT a.dc_centro_costo, a.dg_centro_costo         
                                                                                                                                                                                                
FROM TTUNID_NEGO as a     
                                                                                                                                                                                                                                   
inner join TRUNNE_SERV as b          
                                                                                                                                                                                                                        
on a.dc_centro_costo = b.dc_centro_costo_imputacion          
                                                                                                                                                                                                
where b.dc_sucursal_imputacion = @centrocosto and dc_centro_costo <> 0         
                                                                                                                                                                              
and a.df_termino_vigencia > = @FechaHoy -- Add EWMN 28.11.2011: Solo Vigentes  
                                                                                                                                                                              
end    
                                                                                                                                                                                                                                                      
return 0   
                                                                                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaSucursal   
                                                                                                                                                                                                                         
AS        
                                                                                                                                                                                                                                                   
declare @Fecha datetime    
                                                                                                                                                                                                                                  
SELECT  @Fecha = feclec00 FROM FIC_CONTA00    
                                                                                                                                                                                                               
where codfic00 = 'OF'    
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
IF @FECHA > GETDATE()    
                                                                                                                                                                                                                                    
BEGIN         
                                                                                                                                                                                                                                               
SELECT dc_sucursal, dg_sucursal FROM CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst       
                                                                                                                                                                           
end    
                                                                                                                                                                                                                                                      
else    
                                                                                                                                                                                                                                                     
BEGIN         
                                                                                                                                                                                                                                               
SELECT dc_sucursal, dg_sucursal FROM TMTIEN    
                                                                                                                                                                                                              
where dc_sucursal is not null  and DC_SUCURSAL<>0  
                                                                                                                                                                                                          
order by dc_sucursal     
                                                                                                                                                                                                                                    
end    
                                                                                                                                                                                                                                                      
return 0                                                                                                                                                                                                                                                       
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  sp_ListaSucursalxCentroCosto
                                                                                                                                                                                                               
@centrocosto int         
                                                                                                                                                                                                                                    
AS    
                                                                                                                                                                                                                                                       
declare @Fecha datetime
                                                                                                                                                                                                                                      
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN     
                                                                                                                                                                                                                                                   
SELECT DISTINCT a.dc_sucursal, a.dg_sucursal      
                                                                                                                                                                                                           
FROM CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst as a 
                                                                                                                                                                                                            
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b        
                                                                                                                                                                                       
on a.dc_sucursal = b.dc_sucursal_imputacion       
                                                                                                                                                                                                           
where b.dc_centro_costo_imputacion = @centrocosto  
                                                                                                                                                                                                          
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
BEGIN     
                                                                                                                                                                                                                                                   
SELECT DISTINCT a.dc_sucursal, a.dg_sucursal      
                                                                                                                                                                                                           
FROM TMTIEN as a inner join TRUNNE_SERV as b        
                                                                                                                                                                                                         
on a.dc_sucursal = b.dc_sucursal_imputacion       
                                                                                                                                                                                                           
where b.dc_centro_costo_imputacion = @centrocosto  
                                                                                                                                                                                                          
end
                                                                                                                                                                                                                                                          
return 0   
                                                                                                                                                                                                                                                  
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


GO  
 ALTER procedure  sp_ListaTipoServicio              
                                                                                                                                                                                                        
@moneda int,            
                                                                                                                                                                                                                                     
@sucursal int,            
                                                                                                                                                                                                                                   
@centrocosto int,    
                                                                                                                                                                                                                                        
@detraccion char(1)            
                                                                                                                                                                                                                              
AS              
                                                                                                                                                                                                                                             
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN
                                                                                                                                                                                                                                                        
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion            
                                                                                                                                                   
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as a             
                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b on a.dc_servicio = b.dc_servicio            
                                                                                                                                                  
where a.dc_moneda_servicio = @moneda and             
                                                                                                                                                                                                        
a.df_vigencia_termino > getdate() and       
                                                                                                                                                                                                                 
b.df_final_vigencia > getdate() and          
                                                                                                                                                                                                                
dc_sucursal_imputacion = @sucursal and             
                                                                                                                                                                                                          
dc_centro_costo_imputacion = @centrocosto and        
                                                                                                                                                                                                        
a.dc_servicio <> 0     
                                                                                                                                                                                                                                      
and dm_detraccion = @detraccion    
                                                                                                                                                                                                                          
order by convert(integer,a.dc_servicio)          
                                                                                                                                                                                                            
END
                                                                                                                                                                                                                                                          
ELSE
                                                                                                                                                                                                                                                         
BEGIN
                                                                                                                                                                                                                                                        
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion            
                                                                                                                                                   
FROM TTSERV as a             
                                                                                                                                                                                                                                
inner join TRUNNE_SERV as b on a.dc_servicio = b.dc_servicio            
                                                                                                                                                                                     
where a.dc_moneda_servicio = @moneda and             
                                                                                                                                                                                                        
a.df_vigencia_termino > getdate() and       
                                                                                                                                                                                                                 
b.df_final_vigencia > getdate() and          
                                                                                                                                                                                                                
dc_sucursal_imputacion = @sucursal and             
                                                                                                                                                                                                          
dc_centro_costo_imputacion = @centrocosto and        
                                                                                                                                                                                                        
a.dc_servicio <> 0     
                                                                                                                                                                                                                                      
and dm_detraccion = @detraccion    
                                                                                                                                                                                                                          
order by convert(integer,a.dc_servicio)          
                                                                                                                                                                                                            
END
                                                                                                                                                                                                                                                          
return 0     
                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaTipoServiciobyDetra      
                                                                                                                                                                                                           
@moneda int,                
                                                                                                                                                                                                                                 
@sucursal int,                
                                                                                                                                                                                                                               
@centrocosto int,        
                                                                                                                                                                                                                                    
@detraccion char(1),      
                                                                                                                                                                                                                                   
@porcentaje decimal(8,2)      
                                                                                                                                                                                                                               
AS             
                                                                                                                                                                                                                                              
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN     
                                                                                                                                                                                                                                                   
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion                
                                                                                                                                               
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as a                 
                                                                                                                                                                                                
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b on a.dc_servicio = b.dc_servicio                
                                                                                                                                              
where a.dc_moneda_servicio = @moneda and                 
                                                                                                                                                                                                    
CONVERT(VARCHAR(8), a.df_vigencia_termino, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and           
                                                                                                                                                       
CONVERT(VARCHAR(8), b.df_final_vigencia, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and              
                                                                                                                                                      
dc_sucursal_imputacion = @sucursal and                 
                                                                                                                                                                                                      
dc_centro_costo_imputacion = @centrocosto and            
                                                                                                                                                                                                    
a.dc_servicio <> 0         
                                                                                                                                                                                                                                  
and dm_detraccion = @detraccion        
                                                                                                                                                                                                                      
order by convert(integer,a.dc_servicio)              
                                                                                                                                                                                                        
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion                
                                                                                                                                               
FROM TTSERV as a                 
                                                                                                                                                                                                                            
inner join TRUNNE_SERV as b on a.dc_servicio = b.dc_servicio                
                                                                                                                                                                                 
where a.dc_moneda_servicio = @moneda and                 
                                                                                                                                                                                                    
CONVERT(VARCHAR(8), a.df_vigencia_termino, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and           
                                                                                                                                                       
CONVERT(VARCHAR(8), b.df_final_vigencia, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and              
                                                                                                                                                      
dc_sucursal_imputacion = @sucursal and                 
                                                                                                                                                                                                      
dc_centro_costo_imputacion = @centrocosto and            
                                                                                                                                                                                                    
a.dc_servicio <> 0         
                                                                                                                                                                                                                                  
and dm_detraccion = @detraccion        
                                                                                                                                                                                                                      
order by convert(integer,a.dc_servicio)              
                                                                                                                                                                                                        
end
                                                                                                                                                                                                                                                          
return 0         
                                                                                                                                                                                                                                            
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListaTipoServicioGenerico        
                                                                                                                                                                                                        
@moneda int,                
                                                                                                                                                                                                                                 
@sucursal int,                
                                                                                                                                                                                                                               
@centrocosto int                
                                                                                                                                                                                                                             
AS                  
                                                                                                                                                                                                                                         
declare @Fecha datetime  
                                                                                                                                                                                                                                    
SELECT  @Fecha = feclec00 FROM FIC_CONTA00  
                                                                                                                                                                                                                 
where codfic00 = 'OF'  
                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
IF @FECHA > GETDATE()  
                                                                                                                                                                                                                                      
BEGIN       
                                                                                                                                                                                                                                                 
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion                          
                                                                                                                                     
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as a                 
                                                                                                                                                                                                
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b on a.dc_servicio = b.dc_servicio                
                                                                                                                                              
where a.dc_moneda_servicio = @moneda and                 
                                                                                                                                                                                                    
CONVERT(VARCHAR(8), a.df_vigencia_termino, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and               
                                                                                                                                                   
CONVERT(VARCHAR(8), b.df_final_vigencia, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and                  
                                                                                                                                                  
dc_sucursal_imputacion = @sucursal and                 
                                                                                                                                                                                                      
dc_centro_costo_imputacion = @centrocosto and            
                                                                                                                                                                                                    
a.dc_servicio <> '0'            
                                                                                                                                                                                                                             
order by convert(integer,a.dc_servicio)              
                                                                                                                                                                                                        
end  
                                                                                                                                                                                                                                                        
else  
                                                                                                                                                                                                                                                       
begin  
                                                                                                                                                                                                                                                      
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv, b.dm_detraccion, b.dc_porcentaje_detraccion                          
                                                                                                                                     
FROM TTSERV as a                 
                                                                                                                                                                                                                            
inner join TRUNNE_SERV as b on a.dc_servicio = b.dc_servicio                
                                                                                                                                                                                 
where a.dc_moneda_servicio = @moneda and                 
                                                                                                                                                                                                    
CONVERT(VARCHAR(8), a.df_vigencia_termino, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and               
                                                                                                                                                   
CONVERT(VARCHAR(8), b.df_final_vigencia, 112) >=  CONVERT(VARCHAR(8), getdate(), 112) and                  
                                                                                                                                                  
dc_sucursal_imputacion = @sucursal and                 
                                                                                                                                                                                                      
dc_centro_costo_imputacion = @centrocosto and            
                                                                                                                                                                                                    
a.dc_servicio <> '0'           
                                                                                                                                                                                                                              
order by convert(integer,a.dc_servicio)              
                                                                                                                                                                                                        
end  
                                                                                                                                                                                                                                                        
return 0       
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  sp_ListaTipoServicioSinMoneda            
                                                                                                                                                                                                  
--@moneda int,          
                                                                                                                                                                                                                                     
@sucursal int,          
                                                                                                                                                                                                                                     
@centrocosto int          
                                                                                                                                                                                                                                   
AS            
                                                                                                                                                                                                                                               
declare @Fecha datetime
                                                                                                                                                                                                                                      
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
BEGIN     
                                                                                                                                                                                                                                                   
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv          
                                                                                                                                                                                                  
FROM CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as a           
                                                                                                                                                                                                      
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.servicio_sucursal_cencos as b on a.dc_servicio = b.dc_servicio          
                                                                                                                                                    
where --a.dc_moneda_servicio = @moneda and           
                                                                                                                                                                                                        
a.df_vigencia_termino > getdate() and           
                                                                                                                                                                                                             
dc_sucursal_imputacion = @sucursal and           
                                                                                                                                                                                                            
dc_centro_costo_imputacion = @centrocosto and      
                                                                                                                                                                                                          
a.dc_servicio <> 0      
                                                                                                                                                                                                                                     
order by convert(integer,a.dc_servicio)        
                                                                                                                                                                                                              
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
SELECT a.dc_servicio, a.dg_servicio, b.Afecto_Igv          
                                                                                                                                                                                                  
FROM TTSERV as a           
                                                                                                                                                                                                                                  
inner join TRUNNE_SERV as b on a.dc_servicio = b.dc_servicio          
                                                                                                                                                                                       
where --a.dc_moneda_servicio = @moneda and           
                                                                                                                                                                                                        
a.df_vigencia_termino > getdate() and           
                                                                                                                                                                                                             
dc_sucursal_imputacion = @sucursal and           
                                                                                                                                                                                                            
dc_centro_costo_imputacion = @centrocosto and      
                                                                                                                                                                                                          
a.dc_servicio <> 0      
                                                                                                                                                                                                                                     
order by convert(integer,a.dc_servicio)        
                                                                                                                                                                                                              
end
                                                                                                                                                                                                                                                          
return 0       
                                                                                                                                                                                                                                              
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_ListconFacServicios    
                                                                                                                                                                                                                  
@FecIni as char(8),      
                                                                                                                                                                                                                                    
@FecFin as char(8),      
                                                                                                                                                                                                                                    
@Servicio as varchar(6),    
                                                                                                                                                                                                                                 
@Ruc as varchar(11)    
                                                                                                                                                                                                                                      
as     
                                                                                                                                                                                                                                                      
if @ruc = '' AND @Servicio <> ''
                                                                                                                                                                                                                             
begin    
                                                                                                                                                                                                                                                    
select a.codcon35, 'C' AS Codtip01,      
                                                                                                                                                                                                                    
fecser32,b.codcon63,'',forors32,     
                                                                                                                                                                                                                        
case when e.motfer01 is null or e.motfer01 = 'SABADO' then c.tarifa01    
                                                                                                                                                                                    
     else c.tarifa01 * c.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                  
0,0, c.ccosto01,d.codtip05,      
                                                                                                                                                                                                                            
d.codtam09, d.codbol03,    
                                                                                                                                                                                                                                  
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else c.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
c.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32 = b.nroors32    
                                                                                                                                                                                                    
inner join pqprovee01 as c on c.codser14 = a.codcon35 and      
                                                                                                                                                                                              
c.codemb03 = a.codemb06 and c.ruccli01 = a.rucpro12    
                                                                                                                                                                                                      
inner join ddcontar63 as d on b.codcon63=d.codcon63 and      
                                                                                                                                                                                                
a.navvia11=d.navvia11    
                                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on c.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON C.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where       
                                                                                                                                                                                                                                                 
codcon35 = @Servicio    
                                                                                                                                                                                                                                     
and fecser32>=@FecIni and fecser32<@FecFin and      
                                                                                                                                                                                                         
status32 <> 'A' and a.codemb06='CTR'       
                                                                                                                                                                                                                  
and a.sucursal='3'      
                                                                                                                                                                                                                                     
--and a.rucpro12 ='20471077501'      
                                                                                                                                                                                                                        
and c.codtam09=d.codtam09    
                                                                                                                                                                                                                                
union      
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
select codcon35, 'M' AS  Codtip01, fecser32,    
                                                                                                                                                                                                             
substring(desitm16,1,49),    
                                                                                                                                                                                                                                
c.nrocar16,forors32,    
                                                                                                                                                                                                                                     
case when e.motfer01 is null or e.motfer01 = 'SABADO' then d.tarifa01    
                                                                                                                                                                                    
     else d.tarifa01 * d.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                  
0,0, d.ccosto01,'','','',    
                                                                                                                                                                                                                                
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else d.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
d.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32=b.nroors32    
                                                                                                                                                                                                      
inner join ddcargas16 as c on a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12    
                                                                                                                                                                            
inner join pqprovee01 as d on d.codser14 = a.codcon35     
                                                                                                                                                                                                   
and d.codemb03 = a.codemb06 and d.ruccli01 = a.rucpro12    
                                                                                                                                                                                                  
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on d.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON d.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where     
                                                                                                                                                                                                                                                   
codcon35 = @Servicio    
                                                                                                                                                                                                                                     
and fecser32>=@FecIni and fecser32<@FecFin     
                                                                                                                                                                                                              
and status32 <> 'A' and a.codemb06 not in ('VEH', 'CTR')    
                                                                                                                                                                                                 
and a.sucursal='3'      
                                                                                                                                                                                                                                     
group by codcon35, fecser32,desitm16,c.nrocar16,forors32, d.tarifa01,d.ccosto01,e.motfer01, d.Porcentaje,f.dg_centro_costo, G.dg_razon_Social    
                                                                                                            
end    
                                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
if @Servicio = '' and @ruc <> ''    
                                                                                                                                                                                                                         
begin    
                                                                                                                                                                                                                                                    
select a.codcon35, 'C' AS  Codtip01,      
                                                                                                                                                                                                                   
fecser32,b.codcon63,'',forors32,     
                                                                                                                                                                                                                        
case when e.motfer01 is null or e.motfer01 = 'SABADO' then c.tarifa01    
                                                                                                                                                                                    
     else c.tarifa01 * c.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                  
0, 0, c.ccosto01,d.codtip05,      
                                                                                                                                                                                                                           
d.codtam09, d.codbol03,    
                                                                                                                                                                                                                                  
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else c.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
c.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32 = b.nroors32    
                                                                                                                                                                                                    
inner join pqprovee01 as c on c.codser14 = a.codcon35 and      
                                                                                                                                                                                              
c.codemb03 = a.codemb06 and c.ruccli01 = a.rucpro12    
                                                                                                                                                                                                      
inner join ddcontar63 as d on b.codcon63=d.codcon63 and      
                                                                                                                                                                                                
a.navvia11=d.navvia11    
                                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on c.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON C.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where       
                                                                                                                                                                                                                                                 
fecser32>=@FecIni     
                                                                                                                                                                                                                                       
and fecser32< @FecFin     
                                                                                                                                                                                                                                   
AND status32 <> 'A' and a.codemb06='CTR'       
                                                                                                                                                                                                              
and a.sucursal='3'      
                                                                                                                                                                                                                                     
and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                    
and c.codtam09=d.codtam09    
                                                                                                                                                                                                                                
union      
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
select codcon35, 'M'  AS  Codtip01, fecser32,    
                                                                                                                                                                                                            
substring(desitm16,1,49),    
                                                                                                                                                                                                                                
c.nrocar16,forors32,    
                                                                                                                                                                                                                                     
case when e.motfer01 is null or e.motfer01 = 'SABADO' then d.tarifa01    
                                                                                                                                                                                    
 else d.tarifa01 * d.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                      
0,0, d.ccosto01,'','','',    
                                                                                                                                                                                                                                
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else d.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
d.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32=b.nroors32    
                                                                                                                                                                                                      
inner join ddcargas16 as c on a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12    
                                                                                                                                                                            
inner join pqprovee01 as d on d.codser14 = a.codcon35     
                                                                                                                                                                                                   
and d.codemb03 = a.codemb06 and d.ruccli01 = a.rucpro12    
                                                                                                                                                                                                  
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on d.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON d.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where     
                                                                                                                                                                                                                                                   
fecser32>=@FecIni and fecser32<@FecFin     
                                                                                                                                                                                                                  
and status32 <> 'A' and a.codemb06 not in ('VEH', 'CTR')    
                                                                                                                                                                                                 
and a.sucursal='3'      
                                                                                                                                                                                                                                     
and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                    
group by codcon35, fecser32,desitm16,c.nrocar16,forors32, d.tarifa01,d.ccosto01, e.motfer01, d.Porcentaje, f.dg_centro_costo, G.dg_razon_Social    
                                                                                                          
end    
                                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
if @Servicio <> ''  and @Ruc <> ''  
                                                                                                                                                                                                                         
begin    
                                                                                                                                                                                                                                                    
select a.codcon35, 'C' AS  Codtip01,      
                                                                                                                                                                                                                   
fecser32,b.codcon63,'',forors32,     
                                                                                                                                                                                                                        
case when e.motfer01 is null or e.motfer01 = 'SABADO' then c.tarifa01    
                                                                                                                                                                                    
     else c.tarifa01 * c.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                  
0, 0, c.ccosto01,d.codtip05,      
                                                                                                                                                                                                                           
d.codtam09, d.codbol03,    
                                                                                                                                                                                                                                  
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else c.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
c.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32 = b.nroors32    
                                                                                                                                                                                                    
inner join pqprovee01 as c on c.codser14 = a.codcon35 and      
                                                                                                                                                                                              
c.codemb03 = a.codemb06 and c.ruccli01 = a.rucpro12    
                                                                                                                                                                                                      
inner join ddcontar63 as d on b.codcon63=d.codcon63 and      
                                                                                                                                                                                                
a.navvia11=d.navvia11    
                                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on c.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON C.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where       
                                                                                                                                                                                                                                                 
fecser32>=@FecIni     
                                                                                                                                                                                                                                       
and fecser32< @FecFin     
                                                                                                                                                                                                                                   
AND status32 <> 'A' and a.codemb06='CTR'       
                                                                                                                                                                                                              
and a.sucursal='3'      
                                                                                                                                                                                                                                     
and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                    
and codcon35 = @Servicio   
                                                                                                                                                                                                                                  
and c.codtam09=d.codtam09    
                                                                                                                                                                                                                                
union      
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
select codcon35, 'M'  AS  Codtip01, fecser32,    
                                                                                                                                                                                                            
substring(desitm16,1,49),    
                                                                                                                                                                                                                                
c.nrocar16,forors32,    
                                                                                                                                                                                                                                     
case when e.motfer01 is null or e.motfer01 = 'SABADO' then d.tarifa01    
                                                                                                                                                                                    
 else d.tarifa01 * d.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                      
0,0, d.ccosto01,'','','',    
                                                                                                                                                                                                                                
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else d.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
d.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32=b.nroors32    
                                                                                                                                                                                                      
inner join ddcargas16 as c on a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12    
                                                                                                                                                                            
inner join pqprovee01 as d on d.codser14 = a.codcon35     
                                                                                                                                                                                                   
and d.codemb03 = a.codemb06 and d.ruccli01 = a.rucpro12    
                                                                                                                                                                                                  
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on d.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON d.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where     
                                                                                                                                                                                                                                                   
fecser32>=@FecIni and fecser32<@FecFin     
                                                                                                                                                                                                                  
and status32 <> 'A' and a.codemb06 not in ('VEH', 'CTR')    
                                                                                                                                                                                                 
and a.sucursal='3'      
                                                                                                                                                                                                                                     
and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                    
and codcon35 = @Servicio   
                                                                                                                                                                                                                                  
group by codcon35, fecser32,desitm16,c.nrocar16,forors32, d.tarifa01,d.ccosto01, e.motfer01, d.Porcentaje, f.dg_centro_costo, G.dg_razon_Social    
                                                                                                          
end    
                                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
if @Servicio = ''  and @Ruc = ''  
                                                                                                                                                                                                                           
begin    
                                                                                                                                                                                                                                                    
select a.codcon35, 'C' AS  Codtip01,      
                                                                                                                                                                                                                   
fecser32,b.codcon63,'',forors32,     
                                                                                                                                                                                                                        
case when e.motfer01 is null or e.motfer01 = 'SABADO' then c.tarifa01    
                                                                                                                                                                                    
     else c.tarifa01 * c.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                  
0, 0, c.ccosto01,d.codtip05,      
                                                                                                                                                                                                                           
d.codtam09, d.codbol03,    
                                                                                                                                                                                                                                  
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else c.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
c.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32 = b.nroors32    
                                                                                                                                                                                                    
inner join pqprovee01 as c on c.codser14 = a.codcon35 and      
                                                                                                                                                                                              
c.codemb03 = a.codemb06 and c.ruccli01 = a.rucpro12    
                                                                                                                                                                                                      
inner join ddcontar63 as d on b.codcon63=d.codcon63 and      
                                                                                                                                                                                                
a.navvia11=d.navvia11    
                                                                                                                                                                                                                                    
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on c.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON C.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where       
                                                                                                                                                                                                                                                 
fecser32>=@FecIni     
                                                                                                                                                                                                                                       
and fecser32< @FecFin     
                                                                                                                                                                                                                                   
AND status32 <> 'A' and a.codemb06='CTR'       
                                                                                                                                                                                                              
and a.sucursal='3'      
                                                                                                                                                                                                                                     
--and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                  
--and codcon35 = @Servicio   
                                                                                                                                                                                                                                
and c.codtam09=d.codtam09    
                                                                                                                                                                                                                                
union      
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
select codcon35, 'M'  AS  Codtip01, fecser32,    
                                                                                                                                                                                                            
substring(desitm16,1,49),    
                                                                                                                                                                                                                                
c.nrocar16,forors32,    
                                                                                                                                                                                                                                     
case when e.motfer01 is null or e.motfer01 = 'SABADO' then d.tarifa01    
                                                                                                                                                                                    
 else d.tarifa01 * d.Porcentaje end as TarifaTotal,    
                                                                                                                                                                                                      
0,0, d.ccosto01,'','','',    
                                                                                                                                                                                                                                
f.dg_centro_costo,    
                                                                                                                                                                                                                                       
case when e.motfer01 is null or e.motfer01 = 'SABADO' then 0    
                                                                                                                                                                                             
     else d.Porcentaje end as Porcentaje,    
                                                                                                                                                                                                                
d.tarifa01,    
                                                                                                                                                                                                                                              
G.dg_razon_Social    
                                                                                                                                                                                                                                        
from ddordser32 as a    
                                                                                                                                                                                                                                     
inner join dddetors33 as b on a.nroors32=b.nroors32    
                                                                                                                                                                                                      
inner join ddcargas16 as c on a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12    
                                                                                                                                                                            
inner join pqprovee01 as d on d.codser14 = a.codcon35     
                                                                                                                                                                                                   
and d.codemb03 = a.codemb06 and d.ruccli01 = a.rucpro12    
                                                                                                                                                                                                  
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as f on d.ccosto01 = f.dc_centro_costo    
                                                                                                                                                                  
INNER JOIN CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona as G ON d.ruccli01 = G.dc_rut COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                           
left join OQFERIAD01 as e on CONVERT(char(12), a.fecser32, 3)=CONVERT(char(12), e.fecfer01, 3)      
                                                                                                                                                         
where     
                                                                                                                                                                                                                                                   
fecser32>=@FecIni and fecser32<@FecFin     
                                                                                                                                                                                                                  
and status32 <> 'A' and a.codemb06 not in ('VEH', 'CTR')    
                                                                                                                                                                                                 
and a.sucursal='3'      
                                                                                                                                                                                                                                     
--and a.rucpro12 = @Ruc    
                                                                                                                                                                                                                                  
--and codcon35 = @Servicio   
                                                                                                                                                                                                                                
group by codcon35, fecser32,desitm16,c.nrocar16,forors32, d.tarifa01,d.ccosto01, e.motfer01, d.Porcentaje, f.dg_centro_costo, G.dg_razon_Social    
                                                                                                          
end    
                                                                                                                                                                                                                                                      
return 0      
                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/************CREAR EN NEPTUNIA 1 -> TERMINAL****************/
                                                                                                                                                                                                
GO  
 ALTER procedure  SP_OBTIENE_CLIENTES_SIN_ACTUALIZAR
                                                                                                                                                                                                          
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
insert into CALW12SQLCORP.NPT9_bd_nept.dbo.ruc_clientes_sin_fecha_ingreso(ruc_cliente)
                                                                                                                                                                                
select contribuy 
                                                                                                                                                                                                                                            
from aaclientesaa(nolock)
                                                                                                                                                                                                                                    
where fechingres is null or fechingres='19000101'
                                                                                                                                                                                                            
and not exists(
                                                                                                                                                                                                                                              
select ruc_cliente 
                                                                                                                                                                                                                                          
from CALW12SQLCORP.NPT9_bd_nept.dbo.ruc_clientes_sin_fecha_ingreso
                                                                                                                                                                                                    
where ruc_cliente=contribuy COLLATE SQL_Latin1_General_CP1_CI_AS
                                                                                                                                                                                             
)
                                                                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_RptOS_ListaFacturasxCentroCosto        
                                                                                                                                                                                                  
@FechaIni char(8),                    
                                                                                                                                                                                                                       
@FechaFin char(8),                   
                                                                                                                                                                                                                        
@centrocosto int,                  
                                                                                                                                                                                                                          
@sucursal int,      
                                                                                                                                                                                                                                         
@Estado varchar(1)        
                                                                                                                                                                                                                                   
as          
                                                                                                                                                                                                                                                 
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin
                                                                                                                                                                                                                                                        
   if @sucursal = 0                   
                                                                                                                                                                                                                       
	begin        
                                                                                                                                                                                                                                               
	select                      
                                                                                                                                                                                                                                
	a.id_orden,                     
                                                                                                                                                                                                                            
	a.NumeroDoc,                     
                                                                                                                                                                                                                           
	a.TipoDoc,                     
                                                                                                                                                                                                                             
	c.descri01,                    
                                                                                                                                                                                                                             
	a.moneda,                    
                                                                                                                                                                                                                               
	case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                            
	     else a.fechadoc end as fechadoc,                    
                                                                                                                                                                                                   
	a.rucarmador,                    
                                                                                                                                                                                                                           
	d.desarm10,                    
                                                                                                                                                                                                                             
	a.rucxcuenta,                
                                                                                                                                                                                                                               
	j.Nombre as Cliente,                
                                                                                                                                                                                                                        
	b.TipoServ,                    
                                                                                                                                                                                                                             
	b.Tarifa,                    
                                                                                                                                                                                                                               
	b.Cantidad,                    
                                                                                                                                                                                                                             
	i.dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                                         
	e.dg_tipo_status_contenedor,                     
                                                                                                                                                                                                           
	f.dg_tipo_contenedor,                          
                                                                                                                                                                                                             
	a.observaciones,            
                                                                                                                                                                                                                                
	b.afectoigv,                    
                                                                                                                                                                                                                            
	a.Impuesto,                
                                                                                                                                                                                                                                 
	b.Tarifa * b.Cantidad as Subtotal,                      
                                                                                                                                                                                                    
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad                 
                                                                                                                                                                                       
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,                        
                                                                                                                                                                   
	g.navvia11,                  
                                                                                                                                                                                                                               
	g.numvia11,                  
                                                                                                                                                                                                                               
	h.desnav08,                
                                                                                                                                                                                                                                 
	g.tipope11,        
                                                                                                                                                                                                                                         
	k.numerocntr,        
                                                                                                                                                                                                                                       
	case when b.TipoDetalle = 'M' then k.Embarcador else '' end TipoDetalle,        
                                                                                                                                                                            
	usuario + CASE WHEN usuarioMod IS NULL THEN ''     
                                                                                                                                                                                                         
        WHEN rtrim(usuarioMod) = rtrim(usuario) THEN ''      
                                                                                                                                                                                                
               ELSE '/' + usuarioMod END as Ejecutivo,        
                                                                                                                                                                                               
	a.Total,        
                                                                                                                                                                                                                                            
	b.descripcion,        
                                                                                                                                                                                                                                      
	q.descripcion as estado,       
                                                                                                                                                                                                                             
	l.dg_servicio       
                                                                                                                                                                                                                                        
	from dcordfac01 as a                     
                                                                                                                                                                                                                   
	inner join ddordfac01 as b on a.id_orden = b.id_orden                     
                                                                                                                                                                                  
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01          
                                                                                                                                                                                              
	INNER join EQESTADOS as q on a.estado = q.estado              
                                                                                                                                                                                              
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy                
                                                                                                                                                                                  
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as l on b.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = l.dc_servicio                      
                                                                                                                 
	left join ddorddet01 as k on b.id_servicio = k.idservicio                  
                                                                                                                                                                                 
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                    
                                                                                                                                                                                 
	left join ddcabman11 as g on b.naveviaje = g.codcco06                  
                                                                                                                                                                                     
	left join dqnavier08 as h on g.codnav08  = h.codnav08                  
                                                                                                                                                                                     
	left join tb_tipo_tamano_contenedor as i on b.tamanocntr = i.dc_tipo_tamano_contenedor                                    
                                                                                                                                  
	left join tb_tipo_status_contenedor as e on b.statuscntr = e.dc_tipo_status_contenedor                                    
                                                                                                                                  
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                                    
                                                                                                                                                  
	where a.Estado = @Estado and    
                                                                                                                                                                                                                            
	--and b.tipoServ = @TipoServ                    
                                                                                                                                                                                                            
	b.centrocosto = @centrocosto                  
                                                                                                                                                                                                              
	and case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                        
	     else a.fechadoc end between @FechaIni and @FechaFin                    
                                                                                                                                                                                
	and a.tipodoc in ('01', '03')         
                                                                                                                                                                                                                      
	end        
                                                                                                                                                                                                                                                 
    else        
                                                                                                                                                                                                                                             
	begin        
                                                                                                                                                                                                                                               
	select                      
                                                                                                                                                                                                                                
	a.id_orden,                     
                                                                                                                                                                                                                            
	a.NumeroDoc,                     
                                                                                                                                                                                                                           
	a.TipoDoc,                     
                                                                                                                                                                                                                             
	c.descri01,                    
                                                                                                                                                                                                                             
	a.moneda,                    
                                                                                                                                                                                                                               
	case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                            
	     else a.fechadoc end as fechadoc,                     
                                                                                                                                                                                                  
	a.rucarmador,                    
                                                                                                                                                                                                                           
	d.desarm10,                    
                                                                                                                                                                                                                             
	a.rucxcuenta,                
                                                                                                                                                                                                                               
	j.Nombre as Cliente,                
                                                                                                                                                                                                                        
	b.TipoServ,                    
                                                                                                                                                                                                                             
	b.Tarifa,                    
                                                                                                                                                                                                                               
	b.Cantidad,  	
                                                                                                                                                                                                                                              
	i.dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                                         
	e.dg_tipo_status_contenedor,                     
                                                                                                                                                                                                           
	f.dg_tipo_contenedor,                          
                                                                                                                                                                                                             
	a.observaciones,            
                                                                                                                                                                                                                                
	b.afectoigv,                    
                                                                                                                                                                                                                            
	a.Impuesto,                
                                                                                                                                                                                                                                 
	b.Tarifa * b.Cantidad as Subtotal,                      
                                                                                                                                                                                                    
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad                 
                                                                                                                                                                                       
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,                        
                                                                                                                                                                   
	g.navvia11,                  
                                                                                                                                                                                                                               
	g.numvia11,                  
                                                                                                                                                                                                                               
	h.desnav08,                
                                                                                                                                                                                                                                 
	g.tipope11,        
                                                                                                                                                                                                                                         
	k.numerocntr,        
                                                                                                                                                                                                                                       
	case when b.TipoDetalle = 'M' then k.Embarcador else '' end TipoDetalle,        
                                                                                                                                                                            
	usuario + CASE WHEN usuarioMod IS NULL THEN '' ELSE '/' + usuarioMod END as Ejecutivo,        
                                                                                                                                                              
	a.Total,        
                                                                                                                                                                                                                                            
	b.descripcion,        
                                                                                                                                                                                                                                      
	q.descripcion as estado,      
                                                                                                                                                                                                                              
	l.dg_servicio         
                                                                                                                                                                                                                                      
	from dcordfac01 as a                     
                                                                                                                                                                                                                   
	inner join ddordfac01 as b on a.id_orden = b.id_orden                     
                                                                                                                                                                                  
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                    
                                                                                                                                                                                    
	INNER join EQESTADOS as q on a.estado = q.estado    
                                                                                                                                                                                                        
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy       
                                                                                                                                                                                           
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as l on b.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = l.dc_servicio                               
                                                                                                        
	left join ddorddet01 as k on b.id_servicio = k.idservicio                  
                                                                                                                                                                                 
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                    
                                                                                                                                                                                 
	left join ddcabman11 as g on b.naveviaje = g.codcco06                  
                                                                                                                                                                                     
	left join dqnavier08 as h on g.codnav08  = h.codnav08                  
                                                                                                                                                                                     
	left join tb_tipo_tamano_contenedor as i on b.tamanocntr = i.dc_tipo_tamano_contenedor                                    
                                                                                                                                  
	left join tb_tipo_status_contenedor as e on b.statuscntr = e.dc_tipo_status_contenedor                                    
                                                                                                                                  
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                                    
                                                                                                                                                  
	where a.Estado = @Estado and    
                                                                                                                                                                                                                            
	--and b.tipoServ = @TipoServ                    
                                                                                                                                                                                                            
	b.sucursal = @sucursal         
                                                                                                                                                                                                                             
	and b.centrocosto = @centrocosto                  	
                                                                                                                                                                                                         
	and case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                        
	         else a.fechadoc end between @FechaIni and @FechaFin                    
                                                                                                                                                                            
	and a.tipodoc in ('01', '03')         
                                                                                                                                                                                                                      
	end       
                                                                                                                                                                                                                                                  
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
   if @sucursal = 0                   
                                                                                                                                                                                                                       
	begin        
                                                                                                                                                                                                                                               
	select                      
                                                                                                                                                                                                                                
	a.id_orden,                     
                                                                                                                                                                                                                            
	a.NumeroDoc,                     
                                                                                                                                                                                                                           
	a.TipoDoc,                     
                                                                                                                                                                                                                             
	c.descri01,                    
                                                                                                                                                                                                                             
	a.moneda,                    
                                                                                                                                                                                                                               
	case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                            
	     else a.fechadoc end as fechadoc,                    
                                                                                                                                                                                                   
	a.rucarmador,                    
                                                                                                                                                                                                                           
	d.desarm10,                    
                                                                                                                                                                                                                             
	a.rucxcuenta,                
                                                                                                                                                                                                                               
	j.Nombre as Cliente,                
                                                                                                                                                                                                                        
	b.TipoServ,                    
                                                                                                                                                                                                                             
	b.Tarifa,                    
                                                                                                                                                                                                                               
	b.Cantidad,                    
                                                                                                                                                                                                                             
	i.codtam09 as dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                             
	e.codbol03 as dg_tipo_status_contenedor,
                                                                                                                                                                                                                    
	case when b.codTipoCntr is null then f.dg_tipo_contenedor
                                                                                                                                                                                                   
	     else b.codTipoCntr end as dg_tipo_contenedor,                          
                                                                                                                                                                                
	a.observaciones,            
                                                                                                                                                                                                                                
	b.afectoigv,                    
                                                                                                                                                                                                                            
	a.Impuesto,                
                                                                                                                                                                                                                                 
	b.Tarifa * b.Cantidad as Subtotal,                      
                                                                                                                                                                                                    
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad                 
                                                                                                                                                                                       
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,                        
                                                                                                                                                                   
	g.navvia11,                  
                                                                                                                                                                                                                               
	g.numvia11,                  
                                                                                                                                                                                                                               
	h.desnav08,                
                                                                                                                                                                                                                                 
	g.tipope11,        
                                                                                                                                                                                                                                         
	k.numerocntr,        
                                                                                                                                                                                                                                       
	case when b.TipoDetalle = 'M' then k.Embarcador else '' end TipoDetalle,        
                                                                                                                                                                            
	usuario + CASE WHEN usuarioMod IS NULL THEN ''     
                                                                                                                                                                                                         
        WHEN rtrim(usuarioMod) = rtrim(usuario) THEN ''      
                                                                                                                                                                                                
               ELSE '/' + usuarioMod END as Ejecutivo,        
                                                                                                                                                                                               
	a.Total,        
                                                                                                                                                                                                                                            
	b.descripcion,        
                                                                                                                                                                                                                                      
	q.descripcion as estado,       
                                                                                                                                                                                                                             
	l.dg_servicio       
                                                                                                                                                                                                                                        
	from dcordfac01 as a                     
                                                                                                                                                                                                                   
	inner join ddordfac01 as b on a.id_orden = b.id_orden                     
                                                                                                                                                                                  
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01          
                                                                                                                                                                                              
	INNER join EQESTADOS as q on a.estado = q.estado              
                                                                                                                                                                                              
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy                
                                                                                                                                                                                  
	inner join TTSERV as l on b.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = l.dc_servicio                      
                                                                                                                                             
	left join ddorddet01 as k on b.id_servicio = k.idservicio                  
                                                                                                                                                                                 
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                    
                                                                                                                                                                                 
	left join ddcabman11 as g on b.navvia11 = g.navvia11
                                                                                                                                                                                                        
	left join dqnavier08 as h on g.codnav08  = h.codnav08                  
                                                                                                                                                                                     
	left join DQTAMCON09 as i on b.tamanocntr = i.codult09                                    
                                                                                                                                                                  
	left join DQCONCNT03 as e on b.StatusCntr = e.dc_dnd_contenedor                                    
                                                                                                                                                         
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                                 
                                                                                                                                                     
	where a.Estado = @Estado and    
                                                                                                                                                                                                                            
	--and b.tipoServ = @TipoServ                    
                                                                                                                                                                                                            
	b.centrocosto = @centrocosto                  
                                                                                                                                                                                                              
	and case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                        
	     else a.fechadoc end between @FechaIni and @FechaFin                    
                                                                                                                                                                                
	and a.tipodoc in ('01', '03')         
                                                                                                                                                                                                                      
	end     
                                                                                                                                                                                                                                                    
    else        
                                                                                                                                                                                                                                             
	begin        
                                                                                                                                                                                                                                               
	select                      
                                                                                                                                                                                                                                
	a.id_orden,                     
                                                                                                                                                                                                                            
	a.NumeroDoc,                     
                                                                                                                                                                                                                           
	a.TipoDoc,                     
                                                                                                                                                                                                                             
	c.descri01,                    
                                                                                                                                                                                                                             
	a.moneda,                    
                                                                                                                                                                                                                               
	case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                            
	     else a.fechadoc end as fechadoc,                     
                                                                                                                                                                                                  
	a.rucarmador,                    
                                                                                                                                                                                                                           
	d.desarm10,                    
                                                                                                                                                                                                                             
	a.rucxcuenta,                
                                                                                                                                                                                                                               
	j.Nombre as Cliente,                
                                                                                                                                                                                                                        
	b.TipoServ,                    
                                                                                                                                                                                                                             
	b.Tarifa,                    
                                                                                                                                                                                                                               
	b.Cantidad, 
                                                                                                                                                                                                                                                
	i.codtam09 as dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                             
	e.codbol03 as dg_tipo_status_contenedor,
                                                                                                                                                                                                                    
	case when b.codTipoCntr is null then f.dg_tipo_contenedor
                                                                                                                                                                                                   
	     else b.codTipoCntr end as dg_tipo_contenedor,                          
                                                                                                                                                                                
	a.observaciones,            
                                                                                                                                                                                                                                
	b.afectoigv,                    
                                                                                                                                                                                                                            
	a.Impuesto,                
                                                                                                                                                                                                                                 
	b.Tarifa * b.Cantidad as Subtotal,                      
                                                                                                                                                                                                    
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad                 
                                                                                                                                                                                       
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,                        
                                                                                                                                                                   
	g.navvia11,                  
                                                                                                                                                                                                                               
	g.numvia11,                  
                                                                                                                                                                                                                               
	h.desnav08,                
                                                                                                                                                                                                                                 
	g.tipope11,        
                                                                                                                                                                                                                                         
	k.numerocntr,        
                                                                                                                                                                                                                                       
	case when b.TipoDetalle = 'M' then k.Embarcador else '' end TipoDetalle,        
                                                                                                                                                                            
	usuario + CASE WHEN usuarioMod IS NULL THEN '' ELSE '/' + usuarioMod END as Ejecutivo,        
                                                                                                                                                              
	a.Total,        
                                                                                                                                                                                                                                            
	b.descripcion,        
                                                                                                                                                                                                                                      
	q.descripcion as estado,      
                                                                                                                                                                                                                              
	l.dg_servicio         
                                                                                                                                                                                                                                      
	from dcordfac01 as a                     
                                                                                                                                                                                                                   
	inner join ddordfac01 as b on a.id_orden = b.id_orden                     
                                                                                                                                                                                  
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                    
                                                                                                                                                                                    
	INNER join EQESTADOS as q on a.estado = q.estado    
                                                                                                                                                                                                        
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy       
                                                                                                                                                                                           
	inner join TTSERV as l on b.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = l.dc_servicio                               
                                                                                                                                    
	left join ddorddet01 as k on b.id_servicio = k.idservicio                  
                                                                                                                                                                                 
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                    
                                                                                                                                                                                 
	left join ddcabman11 as g on b.navvia11 = g.navvia11
                                                                                                                                                                                                        
	left join dqnavier08 as h on g.codnav08  = h.codnav08                  
                                                                                                                                                                                     
	left join DQTAMCON09 as i on b.tamanocntr = i.codult09   
                                                                                                                                                                                                   
	left join DQCONCNT03 as e on b.StatusCntr = e.dc_dnd_contenedor                                    
                                                                                                                                                         
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor  
                                                                                                                                                                                    
	where a.Estado = @Estado and    
                                                                                                                                                                                                                            
	--and b.tipoServ = @TipoServ                    
                                                                                                                                                                                                            
	b.sucursal = @sucursal         
                                                                                                                                                                                                                             
	and b.centrocosto = @centrocosto                  	
                                                                                                                                                                                                         
	and case when a.fechadoc is null then a.fechaorden  
                                                                                                                                                                                                        
	         else a.fechadoc end between @FechaIni and @FechaFin                    
                                                                                                                                                                            
	and a.tipodoc in ('01', '03')         
                                                                                                                                                                                                                      
	end       
                                                                                                                                                                                                                                                  
end
                                                                                                                                                                                                                                                          
return 0     
                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_RptOS_ListaFacturasxCliente            
                                                                                                                                                                                                  
@FechaIni char(8),                  
                                                                                                                                                                                                                         
@FechaFin char(8),        
                                                                                                                                                                                                                                   
@RucxCuenta varchar(11),   
                                                                                                                                                                                                                                  
@TipoRuc char(2)        
                                                                                                                                                                                                                                     
as     
                                                                                                                                                                                                                                                      
declare @Fecha datetime
                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
SELECT  @Fecha = feclec00 FROM FIC_CONTA00
                                                                                                                                                                                                                   
where codfic00 = 'OF'
                                                                                                                                                                                                                                        
IF @FECHA > GETDATE()
                                                                                                                                                                                                                                        
begin            
                                                                                                                                                                                                                                            
   if @TipoRuc = 'CO'               
                                                                                                                                                                                                                         
	begin  
                                                                                                                                                                                                                                                     
	select                    
                                                                                                                                                                                                                                  
	a.id_orden,                   
                                                                                                                                                                                                                              
	a.NumeroDoc,                   
                                                                                                                                                                                                                             
	a.TipoDoc,                   
                                                                                                                                                                                                                               
	c.descri01,                  
                                                                                                                                                                                                                               
	a.moneda,                  
                                                                                                                                                                                                                                 
	a.fechadoc,                  
                                                                                                                                                                                                                               
	a.rucarmador,          
                                                                                                                                                                                                                                     
	d.desarm10,                  
                                                                                                                                                                                                                               
	a.rucconsignatario,          
                                                                                                                                                                                                                               
	j.Nombre as Cliente,          
                                                                                                                                                                                                                              
	b.TipoServ,                  
                                                                                                                                                                                                                               
	b.Tarifa,                  
                                                                                                                                                                                                                                 
	b.Cantidad,                  
                                                                                                                                                                                                                               
	i.dg_tipo_tamano_contenedor,                     
                                                                                                                                                                                                           
	e.dg_tipo_status_contenedor,                   
                                                                                                                                                                                                             
	f.dg_tipo_contenedor,                        
                                                                                                                                                                                                               
	a.observaciones,                  
                                                                                                                                                                                                                          
	b.afectoigv,              
                                                                                                                                                                                                                                  
	a.Impuesto,          
                                                                                                                                                                                                                                       
	b.Tarifa * b.Cantidad as Subtotal,                
                                                                                                                                                                                                          
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad           
                                                                                                                                                                                             
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,    
                                                                                                                                                                                       
	a.Total,    
                                                                                                                                                                                                                                                
	g.navvia11,                
                                                                                                                                                                                                                                 
	g.numvia11,                
                                                                                                                                                                                                                                 
	h.desnav08,              
                                                                                                                                                                                                                                   
	g.tipope11,    
                                                                                                                                                                                                                                             
	k.dg_sucursal,    
                                                                                                                                                                                                                                          
	l.dg_centro_costo,    
                                                                                                                                                                                                                                      
	m.dg_servicio    
                                                                                                                                                                                                                                           
	from dcordfac01 as a                   
                                                                                                                                                                                                                     
	inner join ddordfac01 as b on a.id_orden = b.id_orden                   
                                                                                                                                                                                    
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                  
                                                                                                                                                                                      
	inner join aaclientesaa as j on a.rucconsignatario = j.contribuy          
                                                                                                                                                                                  
	inner join CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_INST as k on b.sucursal = k.dc_sucursal    
                                                                                                                                                                    
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as l on b.centrocosto = l.dc_centro_costo    
                                                                                                                                                              
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as m on b.tiposerv = m.dc_servicio  COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                  
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                  
                                                                                                                                                                                   
	left join ddcabman11 as g on b.naveviaje = g.codcco06                
                                                                                                                                                                                       
	left join dqnavier08 as h on g.codnav08  = h.codnav08                
                                                                                                                                                                                       
	left join tb_tipo_tamano_contenedor as i on b.tamanocntr = i.dc_tipo_tamano_contenedor                                  
                                                                                                                                    
	left join tb_tipo_status_contenedor as e on b.statuscntr = e.dc_tipo_status_contenedor                                  
                                                                                                                                    
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                                  
                                                                                                                                                    
	where Estado IN ('U') and a.rucconsignatario = @RucxCuenta            
                                                                                                                                                                                      
	and a.fechadoc between @FechaIni and @FechaFin                  
                                                                                                                                                                                            
	and a.tipodoc in ('01', '03')                  
                                                                                                                                                                                                             
	end  
                                                                                                                                                                                                                                                       
    else  
                                                                                                                                                                                                                                                   
	begin  
                                                                                                                                                                                                                                                     
	select                    
                                                                                                                                                                                                                                  
	a.id_orden,                   
                                                                                                                                                                                                                              
	a.NumeroDoc,                   
                                                                                                                                                                                                                             
	a.TipoDoc,                   
                                                                                                                                                                                                                               
	c.descri01,                  
                                                                                                                                                                                                                               
	a.moneda,                  
                                                                                                                                                                                                                                 
	a.fechadoc,                  
                                                                                                                                                                                                                               
	a.rucarmador,          
                                                                                                                                                                                                                                     
	d.desarm10,                  
                                                                                                                                                                                                                               
	a.rucconsignatario,          
                                                                                                                                                                                                                               
	j.Nombre as Cliente,          
                                                                                                                                                                                                                              
	b.TipoServ,                  
                                                                                                                                                                                                                               
	b.Tarifa,                  
                                                                                                                                                                                                                                 
	b.Cantidad,                  
                                                                                                                                                                                                                               
	i.dg_tipo_tamano_contenedor,                     
                                                                                                                                                                                                           
	e.dg_tipo_status_contenedor,                   
                                                                                                                                                                                                             
	f.dg_tipo_contenedor,                        
                                                                                                                                                                                                               
	a.observaciones,                  
                                                                                                                                                                                                                          
	b.afectoigv,              
                                                                                                                                                                                                                                  
	a.Impuesto,          
                                                                                                                                                                                                                                       
	b.Tarifa * b.Cantidad as Subtotal,                
                                                                                                                                                                                                          
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad           
                                                                                                                                                                                             
	     else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,    
                                                                                                                                                                                  
	a.Total,    
                                                                                                                                                                                                                                                
	g.navvia11,                
                                                                                                                                                                                                                                 
	g.numvia11,                
                                                                                                                                                                                                                                 
	h.desnav08,              
                                                                                                                                                                                                                                   
	g.tipope11,    
                                                                                                                                                                                                                                             
	k.dg_sucursal,    
                                                                                                                                                                                                                                          
	l.dg_centro_costo,    
                                                                                                                                                                                                                                      
	m.dg_servicio    
                                                                                                                                                                                                                                           
	from dcordfac01 as a                   
                                                                                                                                                                                                                     
	inner join ddordfac01 as b on a.id_orden = b.id_orden                   
                                                                                                                                                                                    
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                  
                                                                                                                                                                                      
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy          
                                                                                                                                                                                        
	inner join CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_INST as k on b.sucursal = k.dc_sucursal    
                                                                                                                                                                    
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_centro_costo as l on b.centrocosto = l.dc_centro_costo    
                                                                                                                                                              
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.tb_servicios as m on b.tiposerv = m.dc_servicio  COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                  
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                  
                                                                                                                                                                                   
	left join ddcabman11 as g on b.naveviaje = g.codcco06                
                                                                                                                                                                                       
	left join dqnavier08 as h on g.codnav08  = h.codnav08                
                                                                                                                                                                                       
	left join tb_tipo_tamano_contenedor as i on b.tamanocntr = i.dc_tipo_tamano_contenedor                                  
                                                                                                                                    
	left join tb_tipo_status_contenedor as e on b.statuscntr = e.dc_tipo_status_contenedor                                  
                                                                                                                                    
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                                  
                                                                                                                                                    
	where Estado IN ('U') and a.rucxcuenta = @RucxCuenta            
                                                                                                                                                                                            
	and a.fechadoc between @FechaIni and @FechaFin                  
                                                                                                                                                                                            
	and a.tipodoc in ('01', '03')                  
                                                                                                                                                                                                             
	end  
                                                                                                                                                                                                                                                       
end
                                                                                                                                                                                                                                                          
else
                                                                                                                                                                                                                                                         
begin
                                                                                                                                                                                                                                                        
   if @TipoRuc = 'CO'               
                                                                                                                                                                                                                         
	begin  
                                                                                                                                                                                                                                                     
	select                    
                                                                                                                                                                                                                                  
	a.id_orden,                   
                                                                                                                                                                                                                              
	a.NumeroDoc,                   
                                                                                                                                                                                                                             
	a.TipoDoc,                   
                                                                                                                                                                                                                               
	c.descri01,                  
                                                                                                                                                                                                                               
	a.moneda,                  
                                                                                                                                                                                                                                 
	a.fechadoc,                  
                                                                                                                                                                                                                               
	a.rucarmador,          
                                                                                                                                                                                                                                     
	d.desarm10,                  
                                                                                                                                                                                                                               
	a.rucconsignatario,          
                                                                                                                                                                                                                               
	j.Nombre as Cliente,          
                                                                                                                                                                                                                              
	b.TipoServ,                  
                                                                                                                                                                                                                               
	b.Tarifa,                  
                                                                                                                                                                                                                                 
	b.Cantidad,       
                                                                                                                                                                                                                                          
	i.codtam09 as dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                             
	e.codbol03 as dg_tipo_status_contenedor,
                                                                                                                                                                                                                    
	case when b.codTipoCntr is null then f.dg_tipo_contenedor
                                                                                                                                                                                                   
	     else b.codTipoCntr end as dg_tipo_contenedor,                          
                                                                                                                                                                                
	a.observaciones,                  
                                                                                                                                                                                                                          
	b.afectoigv,              
                                                                                                                                                                                                                                  
	a.Impuesto,          
                                                                                                                                                                                                                                       
	b.Tarifa * b.Cantidad as Subtotal,                
                                                                                                                                                                                                          
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad           
                                                                                                                                                                                             
	else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,    
                                                                                                                                                                                       
	a.Total,    
                                                                                                                                                                                                                                                
	g.navvia11,                
                                                                                                                                                                                                                                 
	g.numvia11,                
                                                                                                                                                                                                                                 
	h.desnav08,              
                                                                                                                                                                                                                                   
	g.tipope11,    
                                                                                                                                                                                                                                             
	k.dg_sucursal,    
                                                                                                                                                                                                                                          
	l.dg_centro_costo,    
                                                                                                                                                                                                                                      
	m.dg_servicio    
                                                                                                                                                                                                                                           
	from dcordfac01 as a                   
                                                                                                                                                                                                                     
	inner join ddordfac01 as b on a.id_orden = b.id_orden                   
                                                                                                                                                                                    
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                  
                                                                                                                                                                                      
	inner join aaclientesaa as j on a.rucconsignatario = j.contribuy          
                                                                                                                                                                                  
	inner join TMTIEN as k on b.sucursal = k.dc_sucursal    
                                                                                                                                                                                                    
	inner join TTUNID_NEGO as l on b.centrocosto = l.dc_centro_costo    
                                                                                                                                                                                        
	inner join TTSERV as m on b.tiposerv = m.dc_servicio  COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                                              
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                  
                                                                                                                                                                                   
	left join ddcabman11 as g on b.navvia11 = g.navvia11
                                                                                                                                                                                                        
	left join dqnavier08 as h on g.codnav08  = h.codnav08 
                                                                                                                                                                                                      
	left join DQTAMCON09 as i on b.tamanocntr = i.codult09   
                                                                                                                                                                                                   
	left join DQCONCNT03 as e on b.StatusCntr = e.dc_dnd_contenedor                                    
                                                                                                                                                         
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                   
                                                                                                                                                                   
	where Estado IN ('U') and a.rucconsignatario = @RucxCuenta            
                                                                                                                                                                                      
	and a.fechadoc between @FechaIni and @FechaFin                  
                                                                                                                                                                                            
	and a.tipodoc in ('01', '03')                  
                                                                                                                                                                                                             
	end  
                                                                                                                                                                                                                                                       
    else  
                                                                                                                                                                                                                                                   
	begin  
                                                                                                                                                                                                                                                     
	select                    
                                                                                                                                                                                                                                  
	a.id_orden,                   
                                                                                                                                                                                                                              
	a.NumeroDoc,                   
                                                                                                                                                                                                                             
	a.TipoDoc,                   
                                                                                                                                                                                                                               
	c.descri01,                  
                                                                                                                                                                                                                               
	a.moneda,                  
                                                                                                                                                                                                                                 
	a.fechadoc,                  
                                                                                                                                                                                                                               
	a.rucarmador,          
                                                                                                                                                                                                                                     
	d.desarm10,                  
                                                                                                                                                                                                                               
	a.rucconsignatario,          
                                                                                                                                                                                                                               
	j.Nombre as Cliente,          
                                                                                                                                                                                                                              
	b.TipoServ,                  
                                                                                                                                                                                                                               
	b.Tarifa,                  
                                                                                                                                                                                                                                 
	b.Cantidad,          
                                                                                                                                                                                                                                       
	i.codtam09 as dg_tipo_tamano_contenedor,                       
                                                                                                                                                                                             
	e.codbol03 as dg_tipo_status_contenedor,
                                                                                                                                                                                                                    
	case when b.codTipoCntr is null then f.dg_tipo_contenedor
                                                                                                                                                                                                   
	     else b.codTipoCntr end as dg_tipo_contenedor,                          
                                                                                                                                                                                
	a.observaciones,                  
                                                                                                                                                                                                                          
	b.afectoigv,              
                                                                                                                                                                                                                                  
	a.Impuesto,          
                                                                                                                                                                                                                                       
	b.Tarifa * b.Cantidad as Subtotal,                
                                                                                                                                                                                                          
	case when b.afectoigv = 0 then b.Tarifa * b.Cantidad           
                                                                                                                                                                                             
	     else b.Tarifa * b.Cantidad * (1+a.Impuesto) end SubtotalImpuesto,    
                                                                                                                                                                                  
	a.Total,    
                                                                                                                                                                                                                                                
	g.navvia11,                
                                                                                                                                                                                                                                 
	g.numvia11,                
                                                                                                                                                                                                                                 
	h.desnav08,              
                                                                                                                                                                                                                                   
	g.tipope11,    
                                                                                                                                                                                                                                             
	k.dg_sucursal,    
                                                                                                                                                                                                                                          
	l.dg_centro_costo,    
                                                                                                                                                                                                                                      
	m.dg_servicio    
                                                                                                                                                                                                                                           
	from dcordfac01 as a                   
                                                                                                                                                                                                                     
	inner join ddordfac01 as b on a.id_orden = b.id_orden                   
                                                                                                                                                                                    
	inner join FDTIPDOC01 as c on a.tipodoc = c.tipdoc01                  
                                                                                                                                                                                      
	inner join aaclientesaa as j on a.rucxcuenta = j.contribuy          
                                                                                                                                                                                        
	inner join TMTIEN as k on b.sucursal = k.dc_sucursal    
                                                                                                                                                                                                    
	inner join TTUNID_NEGO as l on b.centrocosto = l.dc_centro_costo    
                                                                                                                                                                                        
	inner join TTSERV as m on b.tiposerv = m.dc_servicio  COLLATE SQL_Latin1_General_CP1_CI_AS    
                                                                                                                                                              
	left  join DQARMADO10 as d on a.rucarmador = d.codarm10                  
                                                                                                                                                                                   
	left join ddcabman11 as g on b.navvia11 = g.navvia11
                                                                                                                                                                                                        
	left join dqnavier08 as h on g.codnav08  = h.codnav08                
                                                                                                                                                                                       
	left join DQTAMCON09 as i on b.tamanocntr = i.codult09   
                                                                                                                                                                                                   
	left join DQCONCNT03 as e on b.StatusCntr = e.dc_dnd_contenedor                                    
                                                                                                                                                         
	left join tb_tipo_contenedor as f on b.tipocntr = f.dc_tipo_contenedor                   
                                                                                                                                                                   
	where Estado IN ('U') and a.rucxcuenta = @RucxCuenta            
                                                                                                                                                                                            
	and a.fechadoc between @FechaIni and @FechaFin                  
                                                                                                                                                                                            
	and a.tipodoc in ('01', '03')                  
                                                                                                                                                                                                             
	end  
                                                                                                                                                                                                                                                       
end
                                                                                                                                                                                                                                                          
return 0       
                                                                                                                                                                                                                                              
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
GO  
 ALTER procedure  [dbo].[usp_gwc_bmatic_container]
                                                                                                                                                                                                            
(
                                                                                                                                                                                                                                                            
  @CONTAINER        varchar(21))
                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           
  DECLARE @ESTADO 		AS VARCHAR(20)
                                                                                                                                                                                                                           
  DECLARE @ESTNUM 		AS INT
                                                                                                                                                                                                                                   
  DECLARE @SBOOKIN 		AS CHAR(20)      
                                                                                                                                                                                                                       
  DECLARE @SRUCEMB    AS CHAR(11)    
                                                                                                                                                                                                                        
  DECLARE @SFLGBLO    AS CHAR(01)   
                                                                                                                                                                                                                         
  DECLARE @DMONDOL    AS DECIMAL(12,2)                
                                                                                                                                                                                                       
  DECLARE @DMONSOL    AS DECIMAL(12,2)       
                                                                                                                                                                                                                
  
                                                                                                                                                                                                                                                           
  SET @SFLGBLO='0'                
                                                                                                                                                                                                                           
  SET @SBOOKIN=''                
                                                                                                                                                                                                                            
  SET @SRUCEMB='0000'  
                                                                                                                                                                                                                                      
       
                                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
  SELECT TOP 1 @SBOOKIN=a.bookin13, @SRUCEMB=a.codemc12                 
                                                                                                                                                                                     
  FROM [NEPTUNIA2].[DESCARGA].[dbo].edbookin13 a (NOLOCK)                
                                                                                                                                                                                    
  INNER JOIN [NEPTUNIA2].[DESCARGA].[dbo].edllenad16 b (NOLOCK) ON (a.genbkg13=b.genbkg13)                
                                                                                                                                                   
  INNER JOIN [NEPTUNIA2].[DESCARGA].[dbo].erconasi17 d (NOLOCK) ON (b.codcon04=d.codcon04 AND b.genbkg13=d.genbkg13)                
                                                                                                                         
  INNER JOIN [NEPTUNIA2].[DESCARGA].[dbo].edauting14 e (NOLOCK) ON (e.nroaut14=b.nroaut14)              
                                                                                                                                                     
  INNER JOIN [NEPTUNIA2].[DESCARGA].[dbo].aaclientesaa c (NOLOCK) ON (e.codage19=c.contribuy)                
                                                                                                                                                
  WHERE ISNULL(b.oemadu16,'') <>'' AND b.codcon04=@CONTAINER  
                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
  IF @sRucEmb = '0000'                
                                                                                                                                                                                                                       
    BEGIN
                                                                                                                                                                                                                                                    
    SELECT '1','Contenedor : ' + @CONTAINER + ' NO EXISTE POR FAVOR INTENTE NUEVAMENTE','','','','',''
                                                                                                                                                       
    RETURN
                                                                                                                                                                                                                                                   
  END
                                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
  SELECT                         
                                                                                                                                                                                                                            
    @DMONSOL=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                        
                                                                                                                                                        
    @DMONDOL=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                        
                                                                                                                                                       
  FROM CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                        
                                                                                                                                                                                 
  WHERE RUC=@SRUCEMB and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO              
                                                                                      
      AND ruc NOT IN (              
                                                                                                                                                                                                                         
        select CONTRIBUY from ddautdoc16               
                                                                                                                                                                                                      
        where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate() ) )              
                                                                                                                          
                  
                                                                                                                                                                                                                                           
  IF @dMonSol>0 or @dMonDol>0                
                                                                                                                                                                                                                
    BEGIN
                                                                                                                                                                                                                                                    
    SET @sFlgBlo='1'                
                                                                                                                                                                                                                         
    SELECT '0','','33','','','Contenedor:' + LTRIM(RTRIM(@CONTAINER)) + ' Booking:' + LTRIM(RTRIM(@SBOOKIN)),'Anexo: xxxx'
                                                                                                                                   
    RETURN
                                                                                                                                                                                                                                                   
  END  
                                                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
  SELECT '0','','99','','','Contenedor:' + LTRIM(RTRIM(@CONTAINER)) + ' Booking:' + LTRIM(RTRIM(@SBOOKIN)),''
                                                                                                                                                

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  [dbo].[usp_gwc_bmatic_gateinout]
                                                                                                                                                                                                            
(  @NRORUC        varchar(21))
                                                                                                                                                                                                                               
AS
                                                                                                                                                                                                                                                           
  DECLARE @TMP                VARCHAR(100)
                                                                                                                                                                                                                   
  DECLARE @ROW_COUNT		  INT
                                                                                                                                                                                                                                  
  DECLARE @RESULTADO		  INT
                                                                                                                                                                                                                                  
  Declare @AUTORIZACION       CHAR(2)
                                                                                                                                                                                                                        
  Declare @USERID             VARCHAR(20)    
                                                                                                                                                                                                                
  DECLARE @TIPOVIP            VARCHAR(10)
                                                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
  
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
  SELECT @TMP = CONTRIBUY 
                                                                                                                                                                                                                                   
  FROM AACLIENTESAA
                                                                                                                                                                                                                                          
  WHERE CONTRIBUY = @NRORUC        
                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
  SET @ROW_COUNT = @@ROWCOUNT
                                                                                                                                                                                                                                

                                                                                                                                                                                                                                                             
  IF @ROW_COUNT = 0 
                                                                                                                                                                                                                                         
    BEGIN
                                                                                                                                                                                                                                                    
    SELECT '1','Ruc: ' + @NRORUC + ' NO EXISTE POR FAVOR INTENTE NUEVAMENTE','','','','',''
                                                                                                                                                                  
    RETURN
                                                                                                                                                                                                                                                   
  END
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
  Select @USERID=user_name() 
                                                                                                                                                                                                                                

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
  if exists (Select * from ddautdoc16 where contribuy=@NRORUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))  
                                                                                                                            
    Select @AUTORIZACION='SI'  
                                                                                                                                                                                                                              
  else  
                                                                                                                                                                                                                                                     
   Select @AUTORIZACION='NO'  
                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
  
                                                                                                                                                                                                                                                           
  --BEGIN TRY
                                                                                                                                                                                                                                                
  --  INSERT INTO #TEMP01
                                                                                                                                                                                                                                    
    --EXECUTE [dbo].[usp_gwc_SIG_DEUDA_PENDIENTE_CLIENTE] @NRORUC,@RESULTADO OUTPUT
                                                                                                                                                                          
	EXECUTE [NEPTUNIA9].[Datawarehouse].[dbo].[usp_gwc_SIG_DEUDA_PENDIENTE_CLIENTE] @NRORUC,'SI','TAIM',@USERID,@AUTORIZACION,NULL,@RESULTADO OUTPUT
                                                                                                            
  --END TRY
                                                                                                                                                                                                                                                  
  --BEGIN CATCH
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
  --END CATCH
                                                                                                                                                                                                                                                

                                                                                                                                                                                                                                                             
  
                                                                                                                                                                                                                                                           
  IF @RESULTADO = 1 
                                                                                                                                                                                                                                         
    BEGIN
                                                                                                                                                                                                                                                    
    SELECT '0','','33','','','Ruc: '  + @NRORUC +  ' - Bloqueado','Anexo: xxxx'
                                                                                                                                                                              
    RETURN
                                                                                                                                                                                                                                                   
  END
                                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
  ------------------------------------------------------------
                                                                                                                                                                                               
  --2016.05.05 GBPROYECTOS VERIFICACION DE CLIENTE VIP
                                                                                                                                                                                                       
  --           Solicitud Jose Alvarez
                                                                                                                                                                                                                        
  ------------------------------------------------------------
                                                                                                                                                                                               
  SET @TIPOVIP = '99'
                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
  SELECT TOP 1 @TIPOVIP = CT_CODIGO
                                                                                                                                                                                                                          
  FROM AACLIENTES_CLIENTESTIPOAA 
                                                                                                                                                                                                                            
  WHERE CONTRIBUY = @NRORUC
                                                                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                           
  SET @ROW_COUNT = @@ROWCOUNT
                                                                                                                                                                                                                                
  
                                                                                                                                                                                                                                                           
  --IF @ROW_COUNT <> 0 
                                                                                                                                                                                                                                      
  --  BEGIN
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
  --END
                                                                                                                                                                                                                                                      
  ------------------------------------------------------------
                                                                                                                                                                                               
  
                                                                                                                                                                                                                                                           
  SELECT '0','',@TIPOVIP,'','','Ruc: '  + @NRORUC,''
                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  Usp_ValidaVolantes        
                                                                                                                                                                                                                  
@volante  varchar(6),                    
                                                                                                                                                                                                                    
@respuesta char(1)=null output ,                    
                                                                                                                                                                                                         
@motivo varchar(200)=null output,                    
                                                                                                                                                                                                        
@lineafinaldelticket varchar(240)=null output,      
                                                                                                                                                                                                         
@Categoria Char(1)= null output      
                                                                                                                                                                                                                        
as                    
                                                                                                                                                                                                                                       
declare @Cantidad int                    
                                                                                                                                                                                                                    
declare @RESP char(2), @DESCR varchar(80), @CONSULTA varchar(80), @Cadena varchar(240), @Cadena1 varchar(240),@FormatVolante varchar(6), @ruccli varchar(11)                  
                                                                               
declare @TipoCli char(1)      
                                                                                                                                                                                                                               
declare @i int                  
                                                                                                                                                                                                                             
declare @fechtkt datetime  
                                                                                                                                                                                                                                  
select @FormatVolante =  RIGHT('000000'+ rtrim(@volante), 6)                  
                                                                                                                                                                               
select @ruccli=rtrim(ruccli12) from ddvoldes23 where nrosec23= @FormatVolante                  
                                                                                                                                                              
select @fechtkt = isnull(fechaemitick,getdate()) from DDVOLDES23 WHERE nrosec23 = @FormatVolante  
                                                                                                                                                           
              
                                                                                                                                                                                                                                               
if (select count(*) from DDVOLDES23 WHERE nrosec23 = @FormatVolante) > 0   
                                                                                                                                                                                  
begin                  
                                                                                                                                                                                                                                      
   if datediff(n,@fechtkt,getdate()) >=25  or (select count(*) from DDVOLDES23 WHERE nrosec23 = @FormatVolante and fechaemitick is null) > 0  
                                                                                                               
   begin  
                                                                                                                                                                                                                                                   
                  select @cadena = '   '                  
                                                                                                                                                                                                   
                  insert into DDEtiquetera execute sp_ETIBLOTRAIN @FormatVolante              
                                                                                                                                                               
                  insert into DDEtiquetera execute sp_ETIBLOGEN @FormatVolante              
                                                                                                                                                                 
                  select @TipoCli = 'N'               
                                                                                                                                                                                                       
                  if @ruccli is not null              
                                                                                                                                                                                                       
                  begin                    
                                                                                                                                                                                                                  
                exec sig_deuda_pendiente_cliente @ruccli,'SI','TK'                  
                                                                                                                                                                         
                        insert into DDEtiquetera select * from CALW12SQLCORP.NPT9_bd_nept.dbo.DDEtiquetera              
                                                                                                                                              
                select @TipoCli = clientevip from aaclientesaa  where contribuy = @ruccli      
                                                                                                                                                              
                  end                              
                                                                                                                                                                                                          
                  select @Cantidad = count(*) from DDEtiquetera                  
                                                                                                                                                                            
                  if @Cantidad > 0                     
                                                                                                                                                                                                      
                  begin                        
                                                                                                                                                                                                              
                declare Ticket_Cursor CURSOR FOR                     
                                                                                                                                                                                        
                        select RESPUESTA, MOTIVO, DESCRIPCION  from DDEtiquetera                  
                                                                                                                                                           
                select @i = 0          
                                                                                                                                                                                                                      
                        OPEN Ticket_Cursor                    
                                                                                                                                                                                               
                FETCH NEXT FROM Ticket_Cursor INTO @RESP, @DESCR, @CONSULTA                    
                                                                                                                                                              
                        WHILE (@@fetch_status <> -1)                    
                                                                                                                                                                                     
                BEGIN                    
                                                                                                                                                                                                                    
                            IF (@@fetch_status <> -2)                    
                                                                                                                                                                                    
                    begin                    
                                                                                                                                                                                                                
                              select @i = @i + 1            
                                                                                                                                                                                                 
                                     select @cadena1 = (convert(char(1),@i) + ' BLOQUEOS ' + rtrim(@DESCR) + ' ' + rtrim(@CONSULTA) + '  ')          
                                                                                                        
                              select @cadena =  @cadena + ' ' + @cadena1                                 
                                                                                                                                                    
                            end                         
                                                                                                                                                                                                     
                        FETCH NEXT FROM Ticket_Cursor INTO @RESP, @DESCR, @CONSULTA                        
                                                                                                                                                  
                        end                    
                                                                                                                                                                                                              
                CLOSE Ticket_Cursor                    
                                                                                                                                                                                                      
                        DEALLOCATE Ticket_Cursor                    
                                                                                                                                                                                         
          
                                                                                                                                                                                                                                                   
                       select @respuesta = '0'                    
                                                                                                                                                                                           
                       select @motivo = rtrim(@cadena)                
                                                                                                                                                                                       
                       select @lineafinaldelticket = 'Comunicarse a los anexos indicados en cada bloqueo '                 
                                                                                                                                  
                       select @Categoria = 'N'     
                                                                                                                                                                                                          
                         
                                                                                                                                                                                                                                    
                       delete DDEtiquetera                  
                                                                                                                                                                                                 
                       delete CALW12SQLCORP.NPT9_bd_nept.dbo.DDEtiquetera                  
                                                                                                                                                                           
                          
                                                                                                                                                                                                                                   
                  end                    
                                                                                                                                                                                                                    
                  else                    
                                                                                                                                                                                                                   
                  begin                    
                                                                                                                                                                                                                  
                     select @respuesta = '1'       
                                                                                                                                                                                                          
                     select @motivo = 'Datos Correctos'                    
                                                                                                                                                                                  
                     select @lineafinaldelticket = 'Si Usted no se presenta al momento de ser llamado por la caja debera generar nuevamente su ticket'                    
                                                                                   
                     select @categoria = @TipoCli      
                                                                                                                                                                                                      
                     update DDVOLDES23 set fechaemitick=getdate() WHERE nrosec23 = @FormatVolante   
                                                                                                                                                         
                  end    
                                                                                                                                                                                                                                    
            
                                                                                                                                                                                                                                                 
    end  
                                                                                                                                                                                                                                                    
    else  
                                                                                                                                                                                                                                                   
    begin  
                                                                                                                                                                                                                                                  
                 select @respuesta = '9'                    
                                                                                                                                                                                                 
                 select @motivo = 'Número de Ticket ya fue emitido, Vuelva a intentar en 25 minutos. Ult Reg. : '  + CAST(@fechtkt AS char(25))  --convert(varchar(20),@fechtkt,120) --+ @fechtkt                  
                                          
                 select @lineafinaldelticket = ''                    
                                                                                                                                                                                        
                 select @categoria = 'N'    
                                                                                                                                                                                                                 
    end  
                                                                                                                                                                                                                                                    
end                  
                                                                                                                                                                                                                                        
else                  
                                                                                                                                                                                                                                       
begin                  
                                                                                                                                                                                                                                      
     select @respuesta = '9'                    
                                                                                                                                                                                                             
     select @motivo = 'Número de Volante NO Existe'                    
                                                                                                                                                                                      
     select @lineafinaldelticket = ''                    
                                                                                                                                                                                                    
     select @categoria = 'N'      
                                                                                                                                                                                                                           
end                                                                                                                                                                                                                                                            
