----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure [dbo].[FACT_SERIESUCURSAL_ListarSucursal]        
                                                                                                                                                                                           
@fact_negocio char (1)      
                                                                                                                                                                                                                                 
AS        
                                                                                                                                                                                                                                                   
SELECT  a.fact_codigo, A.FACT_SUCURSAL,     
                                                                                                                                                                                                                 
a.fact_serie COLLATE SQL_Latin1_General_CP1_CI_AS + ' - '  + B.DG_SUCURSAL  AS SUCURSAL,     
                                                                                                                                                                
DG_SUCURSAL, FACT_PUNTOFACT    
                                                                                                                                                                                                                              
FROM FACT_SERIESUCURSAL AS A         
                                                                                                                                                                                                                        
--INNER JOIN CALW12SQLCORP.NEPT9_BD_INST.DBO.tb_sucursal_INST AS B         
                                                                                                                                                                                            
INNER JOIN tb_sucursal_INST AS B         
                                                                                                                                                                                                                    
ON A.FACT_SUCURSAL = B.DC_SUCURSAL        
                                                                                                                                                                                                                   
where fact_negocio = @fact_negocio     
                                                                                                                                                                                                                      
and FACT_FLGACTIVO = '1' and fact_tipodoc = '01'    
                                                                                                                                                                                                         
order by A.FACT_SUCURSAL, fact_serie      
                                                                                                                                                                                                                   
RETURN 0
                                                                                                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure SIG_DEUDA_PENDIENTE_CLIENTE   
                                                                                                                                                                                                              
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
                                                                                                                                                                                                     
  
                                                                                                                                                                                                                                                           
/*Select '','','','','','','','','','','','','','','','','','','','','' from aaclientesaa where 1=2  
                                                                                                                                                        
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
                                                                                                                                                                              
EXEC CALW12SQLCORP.NEPT9_DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET  
                                                                                                                                                
  
                                                                                                                                                                                                                                                           
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.  
                                                                                                                                                       
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia  
                                                                                                                                    
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.  
                                                                                                                                                                 
--===========================================================================  
                                                                                                                                                                              
--if @DEUVEN='NO' EXEC CALW12SQLCORP.NEPT9_DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'  
                                                                                                                                                                   
  
                                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*creo el procedure en la importacion desde el Neptunia9*/
                                                                                                                                                                                                   
ALTER procedure [dbo].[SP_BSC_IMPORTAR_FECHAS_CLIENTES]
                                                                                                                                                                                                     
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
                                                                                                                                                                                                
SELECT RUC_CLIENTE,FECHINGRES FROM CALW12SQLCORP.NEPT9_BD_NEPT.DBO.BSC_Clientes_Fechaingreso
                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure [dbo].[sp_Consultar_DetOrdenSerByIdOrden]              
                                                                                                                                                                                     
@Id_orden int              
                                                                                                                                                                                                                                  
as              
                                                                                                                                                                                                                                             
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
                                                                                                                                                                                                                          
inner join CALW12SQLCORP.NEPT9_bd_nept.dbo.tb_servicios as b on a.tiposerv COLLATE SQL_Latin1_General_CP1_CI_AS = b.dc_servicio              
                                                                                                                          
where Id_orden = @Id_Orden              
                                                                                                                                                                                                                     
return 0
                                                                                                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/************CREAR EN OCEANICA1 -> DESCARGA****************/
                                                                                                                                                                                                 
ALTER procedure [dbo].[SP_OBTIENE_CLIENTES_SIN_ACTUALIZAR]
                                                                                                                                                                                                  
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
insert into CALW12SQLCORP.NEPT9_bd_nept.dbo.ruc_clientes_sin_fecha_ingreso(ruc_cliente)
                                                                                                                                                                                
select contribuy 
                                                                                                                                                                                                                                            
from aaclientesaa(nolock)
                                                                                                                                                                                                                                    
where fechingres is null or fechingres='19000101'
                                                                                                                                                                                                            
and not exists(
                                                                                                                                                                                                                                              
select ruc_cliente 
                                                                                                                                                                                                                                          
from CALW12SQLCORP.NEPT9_bd_nept.dbo.ruc_clientes_sin_fecha_ingreso
                                                                                                                                                                                                    
where ruc_cliente=contribuy COLLATE SQL_Latin1_General_CP1_CI_AS
                                                                                                                                                                                             
)
                                                                                                                                                                                                                                                            
