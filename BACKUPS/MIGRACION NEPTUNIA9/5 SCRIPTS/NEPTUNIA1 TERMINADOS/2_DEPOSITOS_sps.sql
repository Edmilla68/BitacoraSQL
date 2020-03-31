----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                                 

 ALTER procedure  ROCKY_RANKING_FACTURACION 
                                                                                                                                                                                                                  
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From ddcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),feccom52,112) between @FECINI and @FECFIN and flgval52='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec CALW12SQLCORP.NPT9_bd_nept..ROCKY_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIG_FACTURAPRO
                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIG_DEUDA_PENDIENTE_CLIENTE     
                                                                                                                                                                                                            
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
 ALTER procedure  SIG_DEUDA_PENDIENTE_CLIENTE_NEW
                                                                                                                                                                                                           
@RUC varchar(11),
                                                                                                                                                                                                                                            
@DEUVEN char(2)
                                                                                                                                                                                                                                              
AS
                                                                                                                                                                                                                                                           
Declare @USERID as varchar(20)
                                                                                                                                                                                                                               
Declare @AUTORIZACION as char(2)
                                                                                                                                                                                                                             
Select @USERID=user_name()
                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
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
                                                                                                                                                                                
EXEC CALW12SQLCORP.NPT9_BD_NEPT..SIG_DEUDA_PENDIENTE_CLIENTE_NEW @RUC,@DEUVEN,'CLDA',@USERID,@AUTORIZACION
                                                                                                                                                            

                                                                                                                                                                                                                                                             
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
                                                                                                                                                         
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
                                                                                                                                      
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                   
--===========================================================================
                                                                                                                                                                                
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_BD_NEPT..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                             
GO  
 ALTER procedure  SIG_ESTACIONALIDAD_CLIENTES 
                                                                                                                                                                                                                
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=11 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                            
case when DATEPART(month, a.feccom52)=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                              
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From ddcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.feccom52)=convert(int,@ANIO) and a.flgval52='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec CALW12SQLCORP.NPT9_bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep), OCT=sum(oct), NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES_PR    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                          
GO  
 ALTER procedure  SIG_ESTACIONALIDAD_CLIENTES_PR
                                                                                                                                                                                                              
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=11 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                            
case when DATEPART(month, a.feccom52)=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                              
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From ddcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.feccom52)=convert(int,@ANIO) and a.flgval52='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, getdate())=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                                
case when DATEPART(month, getdate())=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                                
case when DATEPART(month, getdate())=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, getdate())=11 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, getdate())=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From dtcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where a.tipcli52=b.claseabc and a.codcli52=b.contribuy
                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec CALW12SQLCORP.NPT9_bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                                 
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOTAL=sum(total),
                                                                                                                                                              
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura_proyectada.rpt'
                                                                                                                                                                                   
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                            
GO  
 ALTER procedure  SIG_RANKING_FACTURACION_PROY 
                                                                                                                                                                                                               
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From ddcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),feccom52,112) between @FECINI and @FECFIN and flgval52='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From dtcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where tipcli52=claseabc and codcli52=contribuy
                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec CALW12SQLCORP.NPT9_bd_nept..SIG_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),REPORTE= 'facturacion_proyectada.rpt'
                                                                                                                                     
From SIG_FACTURAPRO
                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIG_SIP_ESTACIONALIDAD_CLIENTES 
                                                                                                                                                                                                            
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=1 then a.totcob58+0 else 0 end,
                                                                                                                                                                                        
case when DATEPART(month, a.fecemi52)=2 then a.totcob58+0 else 0 end,
                                                                                                                                                                                        
case when DATEPART(month, a.fecemi52)=3 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=4 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=5 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=6 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=7 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=8 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=9 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=10 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                      
case when DATEPART(month, a.fecemi52)=11 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                     
case when DATEPART(month, a.fecemi52)=12 then a.totcob58+0 else 0 end,
                                                                                                                                                                                       
a.totcob58+0
                                                                                                                                                                                                                                                 
From pdordser58 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.fecemi52)=convert(int,@ANIO) and a.flgval58='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=============================================================
                                                                                                                                                                                              
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec CALW12SQLCORP.NPT9_bd_nept..SIG_SIP_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIG_SIP_RANKING_FACTURACION 
                                                                                                                                                                                                                
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(totser58)
                                                                                                                                                                                                                                   
From pdordser58 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),fecemi52,112) between @FECINI and @FECFIN and flgval58='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec CALW12SQLCORP.NPT9_bd_nept..SIG_SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIG_FACTURAPRO
                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FACTURACION    Script Date: 08-09-2002 08:44:09 PM ******/
                                                                                                                                           
GO  
 ALTER procedure  SIG_TOTAL_MENSUAL_FACTURACION
                                                                                                                                                                                                               
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,feccom52),datename(month,feccom52),(subtot52+igvtot52)
                                                                                                                                                                                        
From ddcabcom52
                                                                                                                                                                                                                                              
where datepart(year,feccom52)=convert(int,@anio) and flgval52='1'
                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC CALW12SQLCORP.NPT9_BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
                                                                                                                                                                            
reporte= 'facturacion_mensual.rpt'
                                                                                                                                                                                                                            
From SIG_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FAC_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                              
GO  
 ALTER procedure  SIG_TOTAL_MENSUAL_FAC_PROY
                                                                                                                                                                                                                  
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,feccom52),datename(month,feccom52),(subtot52+igvtot52)
                                                                                                                                                                                        
From ddcabcom52
                                                                                                                                                                                                                                              
where datepart(year,feccom52)=convert(int,@anio) and flgval52='1'
                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,getdate()),datename(month,getdate()),(subtot52+igvtot52)
                                                                                                                                                                                      
From dtcabcom52
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC CALW12SQLCORP.NPT9_BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select 
                                                                                                                                                                                                                                                      
NUMMES,NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),reporte= 'facturacion_mensual_proyectada.rpt'
                                                                                                                                                       
From SIG_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIP_ESTACIONALIDAD_CLIENTES 
                                                                                                                                                                                                                
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIP_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=1 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.fecemi52)=2 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.fecemi52)=3 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=4 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=5 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=6 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=7 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=8 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=9 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=10 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=11 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                            
case when DATEPART(month, a.fecemi52)=12 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                              
a.totcob58+a.totigv58
                                                                                                                                                                                                                                        
From PDORDSER58 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.fecemi52)=convert(int,@ANIO) and 
                                                                                                                                                                                                     
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
/*
                                                                                                                                                                                                                                                           
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec CALW12SQLCORP.NPT9_bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Update SIP_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIP_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte='estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIP_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIP_RANKING_FACTURACION 
                                                                                                                                                                                                                    
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIP_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(a.totcob58+a.totigv58)
                                                                                                                                                                                                                      
From pdordser58 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),fecemi52,112) between @FECINI and @FECFIN and 
                                                                                                                                                                                               
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
--Insert into SIP_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                  
--exec CALW12SQLCORP.NPT9_bd_nept..SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
Update SIP_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIP_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIP_FACTURAPRO
                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SIP_TOTAL_MENSUAL_FACTURACION
                                                                                                                                                                                                               
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIP_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,fecemi52),datename(month,fecemi52),(totcob58+totigv58)
                                                                                                                                                                                        
From PDORDSER58
                                                                                                                                                                                                                                              
where datepart(year,fecemi52)=convert(int,@anio) 
                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
/*--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                  
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC CALW12SQLCORP.NPT9_BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
                                                                                                                                                                            
reporte= 'facturacion_mensual.rpt'
                                                                                                                                                                                                                            
From SIP_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                
