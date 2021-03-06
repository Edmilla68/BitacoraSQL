----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 ALTER procedure  MOVIMIENTOS_EXPO
                                                                                                                                                                                                                                 
as
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
--'INGRESO DE CTRS
                                                                                                                                                                                                                                           
Select distinct NAVE=b.codnav08, VIAJE=b.numvia11, ID_FECHA='0', FECHA=CONVERT(CHAR(8),max(a.fecsal18),112),
                                                                                                                                                 
LINEA=c.codarm10, 
                                                                                                                                                                                                                                           
TAMANIO=case when c.codtam09='20' then 1
                                                                                                                                                                                                                     
	     when c.codtam09='40' then 2
                                                                                                                                                                                                                            
	     when c.codtam09='45' then 2 end,
                                                                                                                                                                                                                       
TIPOCTR=e.dc_tipo_contenedor,
                                                                                                                                                                                                                                
CONTENEDOR=c.codcon04, 
                                                                                                                                                                                                                                      
COND=case when c.codbol03='FC' then 1
                                                                                                                                                                                                                        
	  when c.codbol03='FL' then 1
                                                                                                                                                                                                                               
	  when c.codbol03='LC' then 2
                                                                                                                                                                                                                               
	  when c.codbol03='LF' then 2 end,
                                                                                                                                                                                                                          
SUCURSAL=case when a.sucursal = '2' then 4
                                                                                                                                                                                                                   
	   when a.sucursal = '1' then 1
                                                                                                                                                                                                                             
	   when a.sucursal = '3' then 7
                                                                                                                                                                                                                             
	   when a.sucursal = '5' then 14 end, TIPO='1', CONCEPTO=''
                                                                                                                                                                                                 
from ddticket18 a (nolock), ddcabman11 b (nolock), edconten04 c (nolock),  edllenad16 d (nolock), dqtipcon05 e (nolock)
                                                                                                                                      
Where a.navvia11=b.navvia11
                                                                                                                                                                                                                                  
and a.codcon04=c.codcon04
                                                                                                                                                                                                                                    
and c.codcon04=d.codcon04
                                                                                                                                                                                                                                    
and d.flgenv16 not in ('2')
                                                                                                                                                                                                                                  
and a.navvia11=d.navvia11
                                                                                                                                                                                                                                    
and c.codtip05=e.codtip05
                                                                                                                                                                                                                                    
and a.fecsal18 >= '20060101'
                                                                                                                                                                                                                                 
group by
                                                                                                                                                                                                                                                     
b.codnav08,b.numvia11,c.codarm10,c.codtam09,
                                                                                                                                                                                                                 
e.dc_tipo_contenedor,c.codcon04,c.codbol03,a.sucursal
                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
UNION 
                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
--'SALIDA DE CTRS
                                                                                                                                                                                                                                            
Select distinct NAVE=b.codnav08, VIAJE=b.numvia11, ID_FECHA='0',FECHA=CONVERT(CHAR(8),a.fecsal18,112),
                                                                                                                                                       
LINEA=c.codarm10, 
                                                                                                                                                                                                                                           
TAMANIO=case when c.codtam09='20' then 1
                                                                                                                                                                                                                     
	     when c.codtam09='40' then 2
                                                                                                                                                                                                                            
	     when c.codtam09='45' then 2 end,
                                                                                                                                                                                                                       
TIPOCTR=e.dc_tipo_contenedor,
                                                                                                                                                                                                                                
CONTENEDOR=c.codcon04, 
                                                                                                                                                                                                                                      
COND=case when c.codbol03='FC' then 1
                                                                                                                                                                                                                        
	  when c.codbol03='FL' then 1
                                                                                                                                                                                                                               
	  when c.codbol03='LC' then 2
                                                                                                                                                                                                                               
	  when c.codbol03='LF' then 2 end,
                                                                                                                                                                                                                          
SUCURSAL=case when a.sucursal = '2' then 4
                                                                                                                                                                                                                   
	   when a.sucursal = '1' then 1
                                                                                                                                                                                                                             
	   when a.sucursal = '3' then 7
                                                                                                                                                                                                                             
	   when a.sucursal = '5' then 14 end, TIPO='2', CONCEPTO=''
                                                                                                                                                                                                 
from ddticket18 a (nolock), ddcabman11 b (nolock), edconten04 c (nolock),  drctrtmc90 d (nolock), dqtipcon05 e (nolock)
                                                                                                                                      
Where a.navvia11=b.navvia11
                                                                                                                                                                                                                                  
and c.codcon04=d.codcon04
                                                                                                                                                                                                                                    
and a.nrotkt18=d.nrotkt28
                                                                                                                                                                                                                                    
and a.navvia11=d.navvia11
                                                                                                                                                                                                                                    
and c.codtip05=e.codtip05
                                                                                                                                                                                                                                    
and a.fecsal18 >= '20060101'
                                                                                                                                                                                                                                 
group by
                                                                                                                                                                                                                                                     
b.codnav08,b.numvia11,c.codarm10,c.codtam09,
                                                                                                                                                                                                                 
e.dc_tipo_contenedor,c.codcon04,c.codbol03,a.sucursal,a.navvia11,a.fecsal18
                                                                                                                                                                                  

                                                                                                                                                                                                                                                             
UNION
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
--SERVICIOS
                                                                                                                                                                                                                                                  
SELECT DISTINCT NAVE=d.codnav08, VIAJE=d.numvia11, ID_FECHA='0',FECHA=CONVERT(CHAR(8),a.fecord50,112),
                                                                                                                                                       
LINEA=c.codarm10, 
                                                                                                                                                                                                                                           
TAMANIO=case when c.codtam09='20' then 1
                                                                                                                                                                                                                     
	     when c.codtam09='40' then 2
                                                                                                                                                                                                                            
	     when c.codtam09='45' then 2 end,
                                                                                                                                                                                                                       
TIPOCTR=f.dc_tipo_contenedor,
                                                                                                                                                                                                                                
CONTENEDOR=c.codcon04, 
                                                                                                                                                                                                                                      
COND=case when c.codbol03='FC' then 1
                                                                                                                                                                                                                        
	  when c.codbol03='FL' then 1
                                                                                                                                                                                                                               
	  when c.codbol03='LC' then 2
                                                                                                                                                                                                                               
	  when c.codbol03='LF' then 2 end,
                                                                                                                                                                                                                          
SUCURSAL=case when a.sucursal = '2' then 4
                                                                                                                                                                                                                   
	   when a.sucursal = '1' then 1
                                                                                                                                                                                                                             
	   when a.sucursal = '3' then 7
                                                                                                                                                                                                                             
	   when a.sucursal = '5' then 14 end, TIPO='3', CONCEPTO=g.servicio
                                                                                                                                                                                         
--CONCEPTO=b.codcon14,DESCRIPCION=e.descon14
                                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
from EDORDSER50 a (NOLOCK), EDDETORD51 b (NOLOCK), EDCONTEN04 c (NOLOCK), DDCABMAN11 d (NOLOCK), 
                                                                                                                                                            
GQCONTAR14_NT e (NOLOCK), dqtipcon05 f (nolock), CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DIM_SERVICIOS g
                                                                                                                                                           
Where a.nroors50 = b.nroors50 
                                                                                                                                                                                                                               
and a.navvia11=d.navvia11 
                                                                                                                                                                                                                                   
and b.codent51=c.codcon04
                                                                                                                                                                                                                                    
and SUBSTRING(b.codent51,1,11)=c.codcon04 
                                                                                                                                                                                                                   
and b.codcon14=e.codcon14
                                                                                                                                                                                                                                    
and a.sucursal=e.sucursal
                                                                                                                                                                                                                                    
and e.codsbd03=g.servicio
                                                                                                                                                                                                                                    
and c.codtip05=f.codtip05
                                                                                                                                                                                                                                    
and a.status50 not in ('a')
                                                                                                                                                                                                                                  
AND a.fecord50 >= '20060101'
                                                                                                                                                                                                                                 
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  ROCKY_ACTUALIZAR_ATENCIONES_FUERA_DE_HORARIO
                                                                                                                                                                                                
@CONTRIBUY varchar(11),
                                                                                                                                                                                                                                      
@FECHA char(8)
                                                                                                                                                                                                                                               
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
EXEC CALW12SQLCORP.NPT9_BD_NEPT..ROCKY_ACTUALIZAR_ATENCIONES_FUERA_DE_HORARIO @CONTRIBUY,@FECHA                                                                                                                                                                         
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  ROCKY_ATENCIONES_FUERA_DE_HORARIO
                                                                                                                                                                                                           
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
EXEC CALW12SQLCORP.NPT9_BD_NEPT..ROCKY_ATENCIONES_FUERA_DE_HORARIO                                                                                                                                                                                                      
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  ROCKY_LISTAR_NRO_DE_CNTR_EMBARQUE
                                                                                                                                                                                                           
@NAVVIA 	varchar(10),
                                                                                                                                                                                                                                        
@NAVE	varchar(5),
                                                                                                                                                                                                                                            
@VIAJE	varchar(10),
                                                                                                                                                                                                                                          
@LLEGADA	smalldatetime
                                                                                                                                                                                                                                       
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Declare @Total int, @Enviados int
                                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
Select @Total = count(distinct c.codcon04)
                                                                                                                                                                                                                   
From   erconasi17 a (NOLOCK),  edbookin13 b (NOLOCK),  edconten04 c (NOLOCK)  
                                                                                                                                                                               
Where a.genbkg13=b.genbkg13  and a.codcon04=c.codcon04  and a.flgenv17 NOT IN ('2')  and b.navvia11= @NAVVIA and a.otrdep17 is null
                                                                                                                          
and b.codbol03 not in ('mt') and a.coddep04 in ('OC','NE','CL','TA')
                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
Select @enviados = count(DISTINCT a.codcon04)
                                                                                                                                                                                                                
From drctrtmc90 a (nolock), ddticket18 b (nolock), edconten04 c (nolock)  
                                                                                                                                                                                   
Where a.navvia11=b.navvia11 and a.nrotkt28=b.nrotkt18 and a.codcon04=c.codcon04 and a.navvia11 = @NAVVIA
                                                                                                                                                     

                                                                                                                                                                                                                                                             
Select @Total as Total, isnull(@enviados, 0) as Enviados
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
Insert Into CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_INFORME_EMBARQUE (NAVVIA11,TOTAL,ENVIADOS,EMAIL,NAVE,VIAJE,LLEGADA)
                                                                                                                                                  
Select NAVVIA=@NAVVIA, Total =@Total, ENVIADOS=isnull(@enviados, 0), 'N', @NAVE, @VIAJE, @LLEGADA                                                                                                                                                              
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
                                                                                                                                                                                
EXEC CALW12SQLCORP.NPT9_datawarehouse..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET
                                                                                                                                                  

                                                                                                                                                                                                                                                             
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
                                                                                                                                                         
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
                                                                                                                                      
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                   
--===========================================================================
                                                                                                                                                                                
if @DEUVEN='NO' EXEC CALW12SQLCORP.NPT9_datawarehouse..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'                                                                                                                                                                         
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
 ALTER procedure  sp_Expo_Busca_Volante_Etiquetera                
                                                                                                                                                                                            
@sNroCtr char(11)                
                                                                                                                                                                                                                            
as                 
                                                                                                                                                                                                                                          
SET XACT_ABORT ON        
                                                                                                                                                                                                                                    
BEGIN TRAN        
                                                                                                                                                                                                                                           
        
                                                                                                                                                                                                                                                     
declare @sCodAge char(04)                
                                                                                                                                                                                                                    
declare @sBookin char(20)                
                                                                                                                                                                                                                    
declare @sFlgBlo char(01)                
                                                                                                                                                                                                                    
declare @sSucurs char(02)                
                                                                                                                                                                                                                    
declare @sRucEmb char(11)                
                                                                                                                                                                                                                    
declare @dMonDol decimal(12,2)                
                                                                                                                                                                                                               
declare @dMonSol decimal(12,2)                
                                                                                                                                                                                                               
                
                                                                                                                                                                                                                                             
set @sFlgBlo='0'                
                                                                                                                                                                                                                             
set @sBookin=''                
                                                                                                                                                                                                                              
set @sCodAge=''                
                                                                                                                                                                                                                              
set @sSucurs=''                
                                                                                                                                                                                                                              
set @sRucEmb='0000'                
                                                                                                                                                                                                                          
select top 1 @sBookin=a.bookin13, @sCodAge=c.cliente,                  
                                                                                                                                                                                      
@sSucurs=d.coddep04,@sRucEmb=a.codemc12                 
                                                                                                                                                                                                     
from edbookin13 a (nolock)                
                                                                                                                                                                                                                   
inner join edllenad16 b (nolock) on (a.genbkg13=b.genbkg13)                
                                                                                                                                                                                  
inner join erconasi17 d (nolock) on (b.codcon04=d.codcon04 and b.genbkg13=d.genbkg13)                
                                                                                                                                                        
inner join edauting14 e (nolock) on (e.nroaut14=b.nroaut14)              
                                                                                                                                                                                    
inner join aaclientesaa c (nolock) on (e.codage19=c.contribuy)                
                                                                                                                                                                               
where isnull(b.oemadu16,'') <>'' and b.codcon04=@sNroCtr                
                                                                                                                                                                                     
                
                                                                                                                                                                                                                                             
if @sRucEmb<>'0000'                
                                                                                                                                                                                                                          
begin                
                                                                                                                                                                                                                                        
 Select                         
                                                                                                                                                                                                                             
 @dMonSol=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                        
                                                                                                                                                           
 @dMonDol=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                        
                                                                                                                                                          
 From CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                        
                                                                                                                                                                                  
 Where RUC=@sRucEmb and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO              
                                                                                       
  and ruc not in (              
                                                                                                                                                                                                                             
 select CONTRIBUY from ddautdoc16               
                                                                                                                                                                                                             
 where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate() ) )              
                                                                                                                                 
                  
                                                                                                                                                                                                                                           
 if @dMonSol>0 or @dMonDol>0                
                                                                                                                                                                                                                 
 begin  
                                                                                                                                                                                                                                                     
  set @sFlgBlo='1'                
                                                                                                                                                                                                                           
   if exists((select count(*)       
                                                                                                                                                                                                                         
  from CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO         
                                                                                                                                                                                           
  where contribuy=@sRucEmb         
                                                                                                                                                                                                                          
  and year(registro)=year(getdate())         
                                                                                                                                                                                                                
  and month(registro)=month(getdate())         
                                                                                                                                                                                                              
  and day(registro)=day(getdate())  
                                                                                                                                                                                                                         
  and @sFlgBlo='1'  ))--= 0        
                                                                                                                                                                                                                          
         
                                                                                                                                                                                                                                                    
   print @dMonSol      
                                                                                                                                                                                                                                      
   print @dMonDol      
                                                                                                                                                                                                                                      
   print @sRucEmb      
                                                                                                                                                                                                                                      
         
                                                                                                                                                                                                                                                    
    Insert CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO)         
                                                                                                                                                 
    values (@sRucEmb,user,'TAIM',getdate())          
                                                                                                                                                                                                        
 end                
                                                                                                                                                                                                                                         
end  
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
                
                                                                                                                                                                                                                                             
select @sNroCtr as Contenedor,@sCodAge as Agente,@sBookin as Booking,                
                                                                                                                                                                        
@sFlgBlo as Bloqueo,@sSucurs as Sucursal,@sRucEmb as RUC         
                                                                                                                                                                                            
        
                                                                                                                                                                                                                                                     
COMMIT TRAN                                                                                                                                                                                                                                                    
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  [dbo].[sp_Expo_Busca_Volante_Etiquetera_2]                
                                                                                                                                                                                  
@sNroCtr char(11)                
                                                                                                                                                                                                                            
as                 
                                                                                                                                                                                                                                          
SET XACT_ABORT ON        
                                                                                                                                                                                                                                    
BEGIN TRAN        
                                                                                                                                                                                                                                           
        
                                                                                                                                                                                                                                                     
declare @sCodAge char(04)                
                                                                                                                                                                                                                    
declare @sBookin char(20)                
                                                                                                                                                                                                                    
declare @sFlgBlo char(01)                
                                                                                                                                                                                                                    
declare @sSucurs char(02)                
                                                                                                                                                                                                                    
declare @sRucEmb char(11)                
                                                                                                                                                                                                                    
declare @dMonDol decimal(12,2)                
                                                                                                                                                                                                               
declare @dMonSol decimal(12,2)                
                                                                                                                                                                                                               
                
                                                                                                                                                                                                                                             
set @sFlgBlo='0'                
                                                                                                                                                                                                                             
set @sBookin=''                
                                                                                                                                                                                                                              
set @sCodAge=''                
                                                                                                                                                                                                                              
set @sSucurs=''                
                                                                                                                                                                                                                              
set @sRucEmb='0000'                
                                                                                                                                                                                                                          
select top 1 @sBookin=a.bookin13, @sCodAge=c.cliente,                  
                                                                                                                                                                                      
@sSucurs=d.coddep04,@sRucEmb=a.codemc12                 
                                                                                                                                                                                                     
from edbookin13 a (nolock)                
                                                                                                                                                                                                                   
inner join edllenad16 b (nolock) on (a.genbkg13=b.genbkg13)                
                                                                                                                                                                                  
inner join erconasi17 d (nolock) on (b.codcon04=d.codcon04 and b.genbkg13=d.genbkg13)                
                                                                                                                                                        
inner join edauting14 e (nolock) on (e.nroaut14=b.nroaut14)              
                                                                                                                                                                                    
inner join aaclientesaa c (nolock) on (e.codage19=c.contribuy)                
                                                                                                                                                                               
where isnull(b.oemadu16,'') <>'' and b.codcon04=@sNroCtr                
                                                                                                                                                                                     
                
                                                                                                                                                                                                                                             
if @sRucEmb<>'0000'                
                                                                                                                                                                                                                          
begin                
                                                                                                                                                                                                                                        
 Select                         
                                                                                                                                                                                                                             
 @dMonSol=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                        
                                                                                                                                                           
 @dMonDol=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                        
                                                                                                                                                          
 From CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                        
                                                                                                                                                                                  
 Where RUC=@sRucEmb and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO              
                                                                                       
  and ruc not in (              
                                                                                                                                                                                                                             
 select CONTRIBUY from ddautdoc16               
                                                                                                                                                                                                             
 where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate() ) )              
                                                                                                                                 
                  
                                                                                                                                                                                                                                           
 if @dMonSol>0 or @dMonDol>0                
                                                                                                                                                                                                                 
 begin  
                                                                                                                                                                                                                                                     
  set @sFlgBlo='1'                
                                                                                                                                                                                                                           
   if exists((select count(*)       
                                                                                                                                                                                                                         
  from CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO         
                                                                                                                                                                                           
  where contribuy=@sRucEmb         
                                                                                                                                                                                                                          
  and year(registro)=year(getdate())         
                                                                                                                                                                                                                
  and month(registro)=month(getdate())         
                                                                                                                                                                                                              
  and day(registro)=day(getdate())  
                                                                                                                                                                                                                         
  and @sFlgBlo='1'  ))--= 0        
                                                                                                                                                                                                                          
         
                                                                                                                                                                                                                                                    
   print @dMonSol      
                                                                                                                                                                                                                                      
   print @dMonDol      
                                                                                                                                                                                                                                      
   print @sRucEmb      
                                                                                                                                                                                                                                      
         
                                                                                                                                                                                                                                                    
  --  Insert CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO)         
                                                                                                                                               
  --  values (@sRucEmb,user,'TAIM',getdate())          
                                                                                                                                                                                                      
 end                
                                                                                                                                                                                                                                         
end  
                                                                                                                                                                                                                                                        
                
                                                                                                                                                                                                                                             
select @sNroCtr as Contenedor,@sCodAge as Agente,@sBookin as Booking,                
                                                                                                                                                                        
@sFlgBlo as Bloqueo,@sSucurs as Sucursal,@sRucEmb as RUC         
                                                                                                                                                                                            
        
                                                                                                                                                                                                                                                     
COMMIT TRAN
                                                                                                                                                                                                                                                  
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  sp_Expo_Busca_Volante_Etiquetera_FWD                      
                                                                                                                                                                                  
@sBkgint char(07)                      
                                                                                                                                                                                                                      
as                       
                                                                                                                                                                                                                                    
SET XACT_ABORT ON              
                                                                                                                                                                                                                              
BEGIN TRAN              
                                                                                                                                                                                                                                     
              
                                                                                                                                                                                                                                               
declare @sBookin char(20)                      
                                                                                                                                                                                                              
declare @sSucurs char(02)                      
                                                                                                                                                                                                              
declare @sFlgBlo char(01)                      
                                                                                                                                                                                                              
declare @sFlgBloE char(01)                      
                                                                                                                                                                                                             
declare @sFlgBloC char(01)                      
                                                                                                                                                                                                             
declare @sRucCon char(11)                      
                                                                                                                                                                                                              
declare @sRucEmb char(11)                      
                                                                                                                                                                                                              
declare @sRucAge char(11)       
                                                                                                                                                                                                                             
declare @sCodAge char(04)                      
                                                                                                                                                                                                              
declare @dMonDol decimal(12,2)                      
                                                                                                                                                                                                         
declare @dMonSol decimal(12,2)                     
                                                                                                                                                                                                          
                      
                                                                                                                                                                                                                                       
set @sFlgBlo='0'                      
                                                                                                                                                                                                                       
set @sBookin=''                      
                                                                                                                                                                                                                        
set @sCodAge=''                      
                                                                                                                                                                                                                        
set @sSucurs=''                      
                                                                                                                                                                                                                        
set @sRucEmb='0000'          
                                                                                                                                                                                                                                
set @sRucCon=''      
                                                                                                                                                                                                                                        
set @sRucAge=''      
                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
set @sFlgBloE='0'   
                                                                                                                                                                                                                                         
set @sFlgBloC='0'   
                                                                                                                                                                                                                                         
      
                                                                                                                                                                                                                                                       
set @sBkgint=substring(@sBkgint,2,6)           
                                                                                                                                                                                                              
    
                                                                                                                                                                                                                                                         
-- select genbkg13,bookin13,* from edbookin13 order by fectra99 desc           
                                                                                                                                                                              
    
                                                                                                                                                                                                                                                         
select top 1 @sBookin=a.bookin13, @sCodAge=c.cliente,                        
                                                                                                                                                                                
@sSucurs=d.coddep04, @sRucEmb=a.codemc12,@sRucCon=a.ruccli13, @sRucAge=a.rucage19                      
                                                                                                                                                      
from edbookin13 a (nolock)                      
                                                                                                                                                                                                             
inner join edllenad16 b (nolock) on (a.genbkg13=b.genbkg13)                      
                                                                                                                                                                            
inner join erconasi17 d (nolock) on (b.codcon04=d.codcon04 and b.genbkg13=d.genbkg13)                      
                                                                                                                                                  
inner join edauting14 e (nolock) on (e.nroaut14=b.nroaut14)                    
                                                                                                                                                                              
inner join aaclientesaa c (nolock) on (e.codage19=c.contribuy)                      
                                                                                                                                                                         
where isnull(b.oemadu16,'') <>'' and a.genbkg13=@sBkgint                     
                                                                                                                                                                                
                      
                                                                                                                                                                                                                                       
if @sRucEmb<>'0000'                      
                                                                                                                                                                                                                    
begin                      
                                                                                                                                                                                                                                  
 Select                               
                                                                                                                                                                                                                       
 @dMonSol=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                              
                                                                                                                                                     
 @dMonDol=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                              
                                                                                                                                                    
 From CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                              
                                                                                                                                                                            
 Where RUC=@sRucEmb and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO                    
                                                                                 
  and ruc not in (                    
                                                                                                                                                                                                                       
 select CONTRIBUY from ddautdoc16                     
                                                                                                                                                                                                       
 where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate() ) )                    
                                                                                                                           
                        
                                                                                                                                                                                                                                     
 if @dMonSol>0 or @dMonDol>0                      
                                                                                                                                                                                                           
 begin        
                                                                                                                                                                                                                                               
  set @sFlgBlo='1'  
                                                                                                                                                                                                                                         
  set @sFlgBloE ='1'                                           
                                                                                                                                                                                              
   if exists((select count(*)             
                                                                                                                                                                                                                   
  from CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO               
                                                                                                                                                                                     
  where contribuy=@sRucEmb               
                                                                                                                                                                                                                    
  and year(registro)=year(getdate())               
                                                                                                                                                                                                          
  and month(registro)=month(getdate())               
                                                                                                                                                                                                        
  and day(registro)=day(getdate())        
                                                                                                                                                                                                                   
  and @sFlgBlo='1'  ))--= 0              
                                                                                                                                                                                                                    
               
                                                                                                                                                                                                                                              
   print @dMonSol            
                                                                                                                                                                                                                                
   print @dMonDol            
                                                                                                                                                                                                                                
   print @sRucEmb            
                                                                                                                                                                                                                                
               
                                                                                                                                                                                                                                              
    Insert CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO)               
                                                                                                                                           
    values (@sRucEmb,user,'TAIM',getdate())                
                                                                                                                                                                                                  
       
                                                                                                                                                                                                                                                      
   print 'insertando'    
                                                                                                                                                                                                                                    
 end                      
                                                                                                                                                                                                                                   
end        
                                                                                                                                                                                                                                                  
        
                                                                                                                                                                                                                                                     
if @sRucAge<>'0000'                      
                                                                                                                                                                                                                    
begin                      
                                                                                                                                                                                                                                  
 Select                               
                                                                                                                                                                                                                       
 @dMonSol=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),                              
                                                                                                                                                     
 @dMonDol=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)                              
                                                                                                                                                    
 From CALW12SQLCORP.NPT9_datawarehouse.dbo.ROCKY_DM_CLIENTES                              
                                                                                                                                                                            
 Where RUC=@sRucAge and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8)       
                                                                                                                               
  and getdate()>=FECHA_VENCIMIENTO                    
                                                                                                                                                                                                       
  and ruc not in (                    
                                                                                                                                                                                                                       
 select CONTRIBUY from ddautdoc16                     
                                                                                                                                                                                                       
 where year(FECINI16)=year(getdate()) and month(FECINI16)=month(getdate()) and day(FECINI16)=day(getdate() ) )                    
                                                                                                                           
                        
                                                                                                                                                                                                                                     
 if @dMonSol>0 or @dMonDol>0                      
                                                                                                                                                                                                           
 begin        
                                                                                                                                                                                                                                               
  set @sFlgBlo='1'            
                                                                                                                                                                                                                               
  set @sFlgBloC ='1'             
                                                                                                                                                                                                                            
   if exists((select count(*)             
                                                                                                                                                                                                                   
  from CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO               
                                                                                                                                                                                     
  where contribuy=@sRucAge               
                                                                                                                                                                                                                    
  and year(registro)=year(getdate())               
                                                                                                                                                                                                          
  and month(registro)=month(getdate())               
                                                                                                                                                                                                        
  and day(registro)=day(getdate())        
                                                                                                                                                                                                                   
  and @sFlgBlo='1'  ))--= 0              
                                                                                                                                                                                                                    
               
                                                                                                                                                                                                                                              
   print @dMonSol            
                                                                                                                                                                                                                                
   print @dMonDol            
                                                                                                                                                                                                                                
   print @sRucEmb            
                                                                                                                                                                                                                                
               
                                                                                                                                                                                                                                              
   Insert CALW12SQLCORP.NPT9_Datawarehouse.dbo.SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO)               
                                                                                                                                            
   values (@sRucEmb,user,'TAIM',getdate())                
                                                                                                                                                                                                   
      
                                                                                                                                                                                                                                                       
  print 'Insertando'    
                                                                                                                                                                                                                                     
      
                                                                                                                                                                                                                                                       
 end                      
                                                                                                                                                                                                                                   
end        
                                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
/*                      
                                                                                                                                                                                                                                     
select @sNroCtr as Contenedor,@sCodAge as Agente,@sBookin as Booking,                      
                                                                                                                                                                  
@sFlgBlo as Bloqueo,@sSucurs as Sucursal,@sRucEmb as RUC               
                                                                                                                                                                                      
*/      
                                                                                                                                                                                                                                                     
if @sFlgBloE ='0' and @sFlgBloC ='0'   
                                                                                                                                                                                                                      
 set @sFlgBlo ='0'   
                                                                                                                                                                                                                                        
if @sFlgBloE ='1' and @sFlgBloC ='0'   
                                                                                                                                                                                                                      
 set @sFlgBlo ='1'   
                                                                                                                                                                                                                                        
if @sFlgBloE ='0' and @sFlgBloC ='1'   
                                                                                                                                                                                                                      
 set @sFlgBlo ='2'   
                                                                                                                                                                                                                                        
if @sFlgBloE ='1' and @sFlgBloC ='1'   
                                                                                                                                                                                                                      
 set @sFlgBlo ='3'   
                                                                                                                                                                                                                                        
  
                                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           
select       
                                                                                                                                                                                                                                                
'0'+@sBkgint as Booking_Int,        
                                                                                                                                                                                                                         
@sBookin as Booking_Final,                       
                                                                                                                                                                                                            
@sSucurs as sucursal,                      
                                                                                                                                                                                                                  
@sFlgBlo as Bloqueo,                      
                                                                                                                                                                                                                   
@sRucCon as Consolidador,                      
                                                                                                                                                                                                              
@sRucEmb as Embarcador,                      
                                                                                                                                                                                                                
@sCodAge as Agente      
                                                                                                                                                                                                                                     
              
                                                                                                                                                                                                                                               
COMMIT TRAN                                                                                                                                                                                                                                                    
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/************CREAR EN NEPTUNIA 2 -> DESCARGA****************/
                                                                                                                                                                                                
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
 ALTER procedure  Usp_ValidaBooking
                                                                                                                                                                                                                           
@booking  varchar(6),                
                                                                                                                                                                                                                        
@respuesta char(1)=null output ,                
                                                                                                                                                                                                             
@motivo varchar(200)=null output,                
                                                                                                                                                                                                            
@lineafinaldelticket varchar(240)=null output,  
                                                                                                                                                                                                             
@Categoria Char(1)= null output  
                                                                                                                                                                                                                            
as                
                                                                                                                                                                                                                                           
declare @Cantidad int                
                                                                                                                                                                                                                        
declare @RESP char(2), @DESCR varchar(80), @CONSULTA varchar(80), @Cadena varchar(240), @Cadena1 varchar(240),@FormatBooking varchar(6), @ruccli varchar(11)              
                                                                                   
declare @TipoCli char(1)  
                                                                                                                                                                                                                                   
declare @i int              
                                                                                                                                                                                                                                 
select @FormatBooking =  RIGHT('000000'+ rtrim(@booking), 6)              
                                                                                                                                                                                   
select top 2 @ruccli=rtrim(codemc12) from edbookin13 (nolock) where bookin13= @FormatBooking order by navvia11 desc              
                                                                                                                            
          
                                                                                                                                                                                                                                                   
if (select count(*) from EDBOOKIN13 (nolock) WHERE bookin13 = @FormatBooking) > 0              
                                                                                                                                                              
begin              
                                                                                                                                                                                                                                          
   select @cadena = '   '              
                                                                                                                                                                                                                      
                 
                                                                                                                                                                                                                                            
--   insert into DDEtiquetera execute sp_ETIBLOTRAIN @FormatVolante          
                                                                                                                                                                                
--   insert into DDEtiquetera execute sp_ETIBLOGEN @FormatVolante          
                                                                                                                                                                                  

                                                                                                                                                                                                                                                             
   select @TipoCli = 'N'           
                                                                                                                                                                                                                          
   if @ruccli is not null          
                                                                                                                                                                                                                          
      PRINT 'ENTRA SIG_DEUDA_PENDIENTE_CLIENTE'
                                                                                                                                                                                                              
      begin                
                                                                                                                                                                                                                                  
        exec sig_deuda_pendiente_cliente @ruccli,'SI','TK'              
                                                                                                                                                                                     
        insert into DDEtiquetera select * from CALW12SQLCORP.NPT9_bd_nept.dbo.DDEtiquetera          
                                                                                                                                                                  
        select @TipoCli = clientevip from aaclientesaa  where contribuy = @ruccli  
                                                                                                                                                                          
        PRINT 'INSERTO EN CALW12SQLCORP.NPT9_BDNEPT.DDETIQUETERA'
                                                                                                                                                                                                     
      end              
                                                                                                                                                                                                                                      
      PRINT 'TERMINA SIG_DEUDA_PENDIENTE_CLIENTE'
                                                                                                                                                                                                            
          
                                                                                                                                                                                                                                                   
   select @Cantidad = count(*) from DDEtiquetera (nolock)
                                                                                                                                                                                                    
   if @Cantidad > 0                 
                                                                                                                                                                                                                         
    begin    
                                                                                                                                                                                                                                                
        PRINT 'ENTRA SI LA CANT MAYOR A CERO'
                                                                                                                                                                                                                
        declare Ticket_Cursor CURSOR FOR                 
                                                                                                                                                                                                    
        select RESPUESTA, MOTIVO, DESCRIPCION  from DDEtiquetera (nolock)             
                                                                                                                                                                       
        select @i = 0      
                                                                                                                                                                                                                                  
        OPEN Ticket_Cursor                
                                                                                                                                                                                                                   
        FETCH NEXT FROM Ticket_Cursor INTO @RESP, @DESCR, @CONSULTA                
                                                                                                                                                                          
        WHILE (@@fetch_status <> -1)                
                                                                                                                                                                                                         
        BEGIN              
                                                                                                                                                                                                                                  
            PRINT 'ENTRA FETCH STATUS DIF MENOS 1'  
                                                                                                                                                                                                         
            IF (@@fetch_status <> -2)                
                                                                                                                                                                                                        
            begin                
                                                                                                                                                                                                                            
              PRINT 'ENTRA FETCH STATUS DIF MENOS 2 - BLOQUEOS'  
                                                                                                                                                                                            
              select @i = @i + 1        
                                                                                                                                                                                                                     
              select @cadena1 = (convert(char(1),@i) + ' BLOQUEOS ' + rtrim(@DESCR) + ' ' + rtrim(@CONSULTA) + '  ')      
                                                                                                                                   
              select @cadena =  @cadena + ' ' + @cadena1                             
                                                                                                                                                                        
            end                 
                                                                                                                                                                                                                             
            PRINT @cadena
                                                                                                                                                                                                                                    
            FETCH NEXT FROM Ticket_Cursor INTO @RESP, @DESCR, @CONSULTA                
                                                                                                                                                                      
             
                                                                                                                                                                                                                                                
         end                
                                                                                                                                                                                                                                 
         CLOSE Ticket_Cursor                
                                                                                                                                                                                                                 
         DEALLOCATE Ticket_Cursor                
                                                                                                                                                                                                            
         PRINT 'CIERRA TICKET_CURSOR'
                                                                                                                                                                                                                        
 
                                                                                                                                                                                                                                                            
      select @respuesta = '0'                
                                                                                                                                                                                                                
      select @motivo = rtrim(@cadena)            
                                                                                                                                                                                                            
      select @lineafinaldelticket = 'Comunicarse a los anexos indicados en cada bloqueo '             
                                                                                                                                                       
      select @Categoria = 'N'  
                                                                                                                                                                                                                              
      delete DDEtiquetera              
                                                                                                                                                                                                                      
      delete CALW12SQLCORP.NPT9_bd_nept.dbo.DDEtiquetera              
                                                                                                                                                                                                
      PRINT  'BORRA CALW12SQLCORP.NPT9_DDETIQUETERA'
                                                                                                                                                                                                                  
   end                
                                                                                                                                                                                                                                       
else                
                                                                                                                                                                                                                                         
          
                                                                                                                                                                                                                                                   
begin  
                                                                                                                                                                                                                                                      
     PRINT 'DATOS CORRECTOS'
                                                                                                                                                                                                                                 
     select @respuesta = '1'                
                                                                                                                                                                                                                 
     select @motivo = 'Datos Correctos'                
                                                                                                                                                                                                      
     select @lineafinaldelticket = 'Si Usted no se presenta al momento de ser llamado por la caja debera generar nuevamente su ticket'                
                                                                                                       
     select @categoria = @TipoCli  
                                                                                                                                                                                                                          
end                
                                                                                                                                                                                                                                          
end              
                                                                                                                                                                                                                                            
else              
                                                                                                                                                                                                                                           
begin  
                                                                                                                                                                                                                                                      
     PRINT 'DATOS INCORRECTOS'
                                                                                                                                                                                                                               
     select @respuesta = '9'                
                                                                                                                                                                                                                 
     select @motivo = 'N�mero de Booking NO Existe, Verifique'                
                                                                                                                                                                               
     select @lineafinaldelticket = ''                
                                                                                                                                                                                                        
     select @categoria = 'N'  
                                                                                                                                                                                                                               
end
                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
