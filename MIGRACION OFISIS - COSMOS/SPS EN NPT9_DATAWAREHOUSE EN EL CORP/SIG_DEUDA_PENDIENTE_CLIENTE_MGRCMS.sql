USE [NPT9_Datawarehouse]
GO
/****** Object:  StoredProcedure [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_MGRCMS]    Script Date: 12/13/2017 15:55:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_MGRCMS] @RUC  varchar(11),@CON char(2),@LOC char(4) = null,@USER varchar(20) = null,@AUTORIZACION char(2)=null,@TICKET char(2)=null        
AS        
Declare @TIPO_CAMBIO as decimal(15,3)        
Declare @SALDO_SOLES as decimal(15,2)        
Declare @SALDO_DOLAR as decimal(15,2)        
Declare @SALDO_SOLES_NV as decimal(15,2)        
Declare @SALDO_DOLAR_NV as decimal(15,2)        
Declare @SALDO_SOLES_T as decimal(15,2)        
Declare @SALDO_DOLAR_T as decimal(15,2)        
Declare @DEUDA_DOLARIZADA decimal(15,2)        
Declare @DEUDA_DOLARIZADA_NV decimal(15,2)        
Declare @DEUDA_DOLARIZADA_T decimal(15,2)        
Declare @HORACT as varchar(8)        
Declare @HORINI as varchar(8)        
Declare @HORFIN as varchar(8)        
Declare @DIASEM as varchar(15)        
Declare @CONRUC as int        
Declare @CUENTA_REGISTROS int        
Declare @PRE_RAZON_SOCIAL as varchar(80)        
Declare @RAZON_SOCIAL as varchar(80)        
Declare @DIAS_CREDITO int        
Declare @LINEA_CREDITO decimal(15,2)         
Declare @CON_COP char(2)         
Declare @ACTIVADO char(1)        


--****EN CASO DE EMERGENCIA: ACTIVAS o DESACTIVAR EL FLAG DE ESTA TABLA****        
Select @ACTIVADO=ACTIVADO from ROCKY_PROCESOS where CODIGO=19        
If @ACTIVADO='N'        
 Select @CON='RO'         

--================================================================================================================================================================        
--****Guardar el CON original, para saber si solo se esta consultando****        
Select @CON_COP=@CON        

--================================================================================================================================================================        
--****Indico cuales son los horarios de atencion desde el sabado hasta el domingo       ****        
--****Falta considerar una tabla para controlar los horarios de antecion los dias feriados****        
--********************************************************************************************************        
Select @HORACT=convert(varchar(8),getdate(),108)        
Select @DIASEM=DATENAME(weekday, getdate())        
Select @HORINI='08:30:00',@HORFIN='17:00:00'        
IF @DIASEM='Saturday'        
 Select @HORFIN='13:00:00'        

--****************************************        
--****FERIADOS TODO EL DIA****        
--****************************************        
IF @DIASEM='Sunday' or right(convert(char(8),getdate(),112),4) in ('0101','0629','0728','0729','0730','0830','1008','1101','1208','1225')        
 Select @HORINI ='00:00:00',@HORFIN='00:00:01'        
--****************************************        
--****FERIADOS MEDIO DIA****        
--****************************************        
IF right(convert(char(8),getdate(),112),4) in ('1224','1231')        
 Select @HORFIN='12:00:00'        
--******************************************************************************        
--****CASOS PARTICULARES SOLICITADOS POR USUARIOS****        
--******************************************************************************        
--IF right(convert(char(8),getdate(),112),4) in ('0908','0909')        
-- Select @HORFIN='17:00:00'        

--================================================================================================================================================================        
--****Permite saber la Razon Social del Cliente, Linea de Credito y Dias de Credito****        
--**************************************************************************************************        

--Select @RAZON_SOCIAL=dg_razon_social, @LINEA_CREDITO=coalesce(dq_monto_autorizado_lincred1,0) from bd_nept..tb_persona Where dc_rut=@RUC        
--Select @DIAS_CREDITO=coalesce(min(dn_dias_vencim_fact_venta),0) from bd_nept..tb_cliente where dc_rut_cliente=@RUC        


Select top 1	
	@RAZON_SOCIAL = left(clie.NO_RAZO_SOCI,80), 		-- razon_social, 
	@LINEA_CREDITO = coalesce(clie.IM_LIMI_CRED,0), 	-- linea_credito, 
	@DIAS_CREDITO = coalesce(cond.NU_DIAS,0)  		-- dias_credito
From [COSMOS-DATA].OFIRECA.dbo.TMCLIE clie LEFT JOIN [COSMOS-DATA].OFIRECA.dbo.TTTIPO_COND cond    
  on clie.CO_COND_PAGO = cond.CO_COND_PAGO and clie.CO_EMPR = cond.CO_EMPR
where clie.CO_CLIE = @RUC 


--================================================================================================================================================================        
--****Permite saber el tipo de cambio del día****        
--******************************************************        
-- Select @TIPO_CAMBIO=dq_tipo_de_cambio         
-- From bd_inst..tb_tipo_cambio_INST        
-- Where convert(char(8),df_vigencia,112)=convert(char(8),getdate(),112) and dc_tipo_paridad='BANCA' and dc_moneda=2       


/**********Obtener tipo de cambio desde ofisis **********************/

SELECT top 1 
	@TIPO_CAMBIO = FA_CMPR_OFIC
FROM 	[COSMOS-DATA].OFISEGU.DBO.TCFACT_CAMB  
WHERE 	(CO_MONE = 'DOL' ) AND  
	(CO_MONE_BASE = 'SOL' ) AND  
	(FE_CAMB = convert(char(8),getdate(), 112))  

 
--================================================================================================================================================================        
--****Permite saber el total de DEUDA SI VENCIDA de un cliente  ****        
--****************************************************************************        
Select         
@SALDO_SOLES=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),        
@SALDO_DOLAR=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)        
From ROCKY_DM_CLIENTES        
Where RUC=@RUC and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()>=FECHA_VENCIMIENTO        

--**********************************************************************************        
--****Permite saber el total de DEUDA NO VENCIDA de un cliente   ****        
--**********************************************************************************        
Select         
@SALDO_SOLES_NV =coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),         
@SALDO_DOLAR_NV=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)        
From ROCKY_DM_CLIENTES        
Where RUC=@RUC and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8) and getdate()<FECHA_VENCIMIENTO        


--**************************************************************************        
--****Permite saber el total de DEUDA TOTAL de un cliente   ****        
--**************************************************************************        
Select         
@SALDO_SOLES_T=coalesce(SUM(case when MONEDA=1 then SALDO_SOLES else 0 end),0),        
@SALDO_DOLAR_T=coalesce(SUM(case when MONEDA=2 then SALDO_DOLARES else 0 end),0)        
From ROCKY_DM_CLIENTES        
Where RUC=@RUC and (case when MONEDA=1 then SALDO_SOLES else SALDO_DOLARES end)<>0 and TIPO_DOCUMENTO in (1,3,7,8)     
    
--********************************************        
--****DEUDA TOTAL DOLARIZADA****        
--********************************************        
Select @DEUDA_DOLARIZADA_T=@SALDO_DOLAR_T+(@SALDO_SOLES_T/@TIPO_CAMBIO)        

--*****************************************************************************************************        
--****Si DEUDA NO VENCIDA DOLARIZADA<=CERO, NO BLOQUIEAR al clinete,  ****        
--****asi tenga facturas vencidas, no se debe bloquear en este caso.              ****         
--*****************************************************************************************************        
Select @DEUDA_DOLARIZADA_NV=@SALDO_DOLAR_NV+(@SALDO_SOLES_NV/@TIPO_CAMBIO)        

--********************************************************************************************        
--****Si DEUDA VENCIDA DOLARIZADA<=CERO, NO BLOQUIEAR al clinete,  ****        
--****asi tenga facturas vencidas, no se debe bloquear en este caso.  ****         
--********************************************************************************************        
Select @DEUDA_DOLARIZADA=@SALDO_DOLAR+(@SALDO_SOLES/@TIPO_CAMBIO)        

if @DEUDA_DOLARIZADA<=0 --DEUDA VENCIDA en Negativo        
Begin        
 Select @PRE_RAZON_SOCIAL='Aplicar Documentos de '        
 Select @CON='RO'   
 If @DEUDA_DOLARIZADA_NV<=@LINEA_CREDITO and @LINEA_CREDITO>0        
 begin        
  Select @PRE_RAZON_SOCIAL='Deuda No Vencida de '        
  Select @CON='RO'         
 end        
 If @DEUDA_DOLARIZADA_NV>@LINEA_CREDITO AND @LINEA_CREDITO>0       
 Begin        
  Select @PRE_RAZON_SOCIAL= 'Exceso en Linea Crédito. (DEUDA NO VENCIDA) '        
  Select @CON='SI'         
 End        
End        
Else --DEUDA VENCIDA en Positivo        
Begin         
 Select @PRE_RAZON_SOCIAL='Deuda Vencida de '        
 Select @CON='SI'         
End

-- Si la deuda total es mayor a la linea de credito, sin importar si esta vencida o no => bloquear cliente
-- Solicitado por Rosa Cuadros -  Modificado por MIM  2008-07-10
if @DEUDA_DOLARIZADA_T >  @LINEA_CREDITO
 Begin        
  Select @PRE_RAZON_SOCIAL= 'Exceso en Linea Crédito. (SOBREGIRO DEUDA TOTAL) '        
  Select @CON='SI'         
 End        
        
--================================================================================================================================================================        
--****Solo consulta fuera de los horarios controlados y cuando se solicite expresamente una consulta, es decir 'RO'****         
--********************************************************************************        
IF @SALDO_DOLAR<=100 and @SALDO_SOLES<=350 --Pedido por Lvento y Mchell 10/06/2005 14:45, Se añadio el monto Soles 25/07/2007 Epalao       
 Select @CON='RO'        
IF @AUTORIZACION='SI'        
 Select @CON='RO'        
IF @CON_COP='RO'         
 Select @CON='RO'        
IF (@HORACT>=@HORFIN or @HORACT<=@HORINI)        
 Select @CON='RO'        
--================================================================================================================================================================        
--****Permite obtener los documentos vencidos en soles y dolares                                                                                                                        ****        
--****Se busca en ambos auxiliares puesto que existen inconsistencias en la tabla de personas y en los auxiliares con respecto al RUC            ****        
--****Por estas inconsistencias la busqueda se hace un poco lenta, porque si tuviera la seguridad que un clientes es nacional o del extranjero ****        
--****(cosa que en el mantenedor de personas no esta bien defionida) buscaria solamente en uno u otro auxiliar.                                               ****        
--*************************************************************************************************************************************************************************        
EXECUTE SIG_DEUDA_PENDIENTE_CLIENTE_01        
@RAZON_SOCIAL,@TIPO_CAMBIO,@SALDO_SOLES,@SALDO_DOLAR,@LOC,@RUC,@DEUDA_DOLARIZADA,@LINEA_CREDITO,@DIAS_CREDITO,@DEUDA_DOLARIZADA_T,@CON,@DEUDA_DOLARIZADA_NV,@PRE_RAZON_SOCIAL,@TICKET        
IF @CON='SI'        
Begin        
 Select @CONRUC=count(*) from SIG_DURANTE_EL_HORARIO where CONTRIBUY=@RUC and convert(char(8),REGISTRO,112)=convert(char(8),getdate(),112)        
 IF @CONRUC=0        
  Insert SIG_DURANTE_EL_HORARIO (CONTRIBUY,USERID,UBICACION,REGISTRO) values (@RUC,@USER,@LOC,getdate())        
End      
      

  



