----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure SIG_DEUDA_PENDIENTE_CLIENTE 
                                                                                                                                                                                                                
@RUC varchar(11),
                                                                                                                                                                                                                                            
@DEUVEN char(2)
                                                                                                                                                                                                                                              
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
                                                                                                                                                                                
EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION
                                                                                                                                                          

                                                                                                                                                                                                                                                             
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
                                                                                                                                                         
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
                                                                                                                                      
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                   
--===========================================================================
                                                                                                                                                                                
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'                                                                                                                                                                         
