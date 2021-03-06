USE [Descarga]
GO

CREATE TABLE TERMLLENADN4
(
GKEY INT IDENTITY(1,1) not null --Identificardor interno
,GKEY_UNIT VARCHAR(500) not null --Identificar N4 unico
,GKEY_BOOKING VARCHAR(500) null --Identificador N4 Booking
,LINEA VARCHAR(3) NOT NULL --Codigo de linea Neptunia
,NAVVIA VARCHAR(6) NOT NULL --Codigo interno Nave/Viaje Neptunia
,BOOKING VARCHAR(35) --Booking completo asociado al contendor 
,GENBKG13 VARCHAR(6) --Codigo interno de tabla booking Neptunia
,CONTENEDOR VARCHAR(15) not null --Nro de contenedor
,TAMANYO_CTR VARCHAR(2) --Tamaño del contenedor
,TIPO_CTR VARCHAR(2) --Tipo de contenedor
,ISOCODE VARCHAR(50) --Isocode del contenedor basado en el tamaño y tipo

,ESTADO VARCHAR(2) --1: Registrado , 2: Modificado

,PESONETO_REG DECIMAL(15,3) NOT NULL --Peso Neto de la mercaderia inicial en el regsitro
,PRECINTO_REG VARCHAR(500) --Precinto asociado en el contendor inicial en el regsitro
,USER_CREATOR VARCHAR(60) --Usuario creacion
,USER_CREATED DATETIME --Fecha registro
,IP_CREATOR VARCHAR(60) --Ip de la maquina que realiza el resgitro

,PESONETO_MOD DECIMAL(15,3) --Nuevo Peso Neto de la mercaderia si en caso sufre alguna modificacion, siempre registra la ultima actualizacion
,PRECINTO_MOD VARCHAR(500) --Nuevo precinto si en caso sufre alguna modificacion, siempre registra la ultima actualizacion
,USER_CHANGER VARCHAR(60) --Usuario que reliza la modificacion
,USER_CHANGED DATETIME --Fecha en la que se reliza la modificacion
,IP_CHANGER VARCHAR(60) --IP donde se realiza la modificacion
,SUCURSAL VARCHAR(3)
,CONSTRAINT PK_TERMLLENADN4_GKEY PRIMARY KEY(GKEY)
)

GO 
GRANT ALL ON  TERMLLENADN4 TO PUBLIC
GO

create table EDITEMBOOKIN13
(
GkeyBooking varchar(550) not null
,GkeyItem varchar(500) not null
,qty int not null
,codtam09 varchar(2) not null
,codtip05 varchar(2) not null
,isoCode varchar(50) not null
,GkeyHazard varchar(500) 
,UnlImoNumber varchar(500)
,imgdClass varchar(5)
,ReqTemperatura varchar(500)
constraint pk_ItemBookin primary key(GkeyItem)
)
go
grant all on EDITEMBOOKIN13 to public
GO

USE [Descarga]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Consulta_Valores_Adicionales_Billing]    Script Date: 14/03/2019 12:11:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_Consulta_Valores_Adicionales_Billing](@UnitFacilityVisitGkey VARCHAR(500))RETURNS VARCHAR(2000)      
    
AS         
    
BEGIN       
    
DECLARE @ORD_FLAGREGISTRO AS VARCHAR(1)       
    
DECLARE @ORD_CODAGENCIA AS VARCHAR(11)       
    
DECLARE @ORD_CLIENTE AS VARCHAR(11)       
    
DECLARE @CODPRO27 AS VARCHAR(5)       
    
DECLARE @CONTEN13 AS VARCHAR(200)       
    
DECLARE @RUCCLI13 AS VARCHAR(11)       
    
DECLARE @RUCOPL13 AS VARCHAR(11)       
    
DECLARE @ORD_CLIENTEFACT AS VARCHAR(11)       
    
DECLARE @ORD_OBSERVACION AS VARCHAR(200)       
    
DECLARE @CODPLANTA AS VARCHAR(4)       
    
DECLARE @ORD_CODIGO AS VARCHAR(10)       
    
       
    
DECLARE @RESULT AS VARCHAR(2000)    
  
DECLARE @Nombre_Zona AS VARCHAR(250)     
DECLARE @LLENADO_EN_NPT AS VARCHAR(10)     
DECLARE @LINEA_TKT AS VARCHAR(10)     
DECLARE @LINEA_GRUPO AS VARCHAR(10)     
DECLARE @VACIO_NEPT AS VARCHAR(10)        
    
       
    
SELECT        
    
  @ORD_FLAGREGISTRO = ISNULL(A.ORD_FLAGREGISTRO,''),       
    
  @ORD_CODAGENCIA = ISNULL(A.ORD_CODAGENCIA,''),       
    
  @ORD_CLIENTE = ISNULL(A.ORD_CLIENTE,''),       
    
  @CODPRO27 = ISNULL(B.CODPRO27,''),       
    
  @CONTEN13 = RTRIM(ISNULL(B.CONTEN13,'')),       
    
  @RUCCLI13 = ISNULL(B.RUCCLI13,''),       
    
  @RUCOPL13 = ISNULL(B.RUCOPL13,''),       
    
  @ORD_CLIENTEFACT = ISNULL(A.ORD_CLIENTEFACT,''),       
    
  @ORD_OBSERVACION = REPLACE(REPLACE(ISNULL(A.ORD_OBSERVACION,''),',',''),':',''),       
    
  @CODPLANTA = ISNULL(A.CODPLANTA,''),       
    
  @ORD_CODIGO = ISNULL(A.ORD_CODIGO,''),    
    
 @Nombre_Zona =  ISNULL((SELECT TOP 1 C.Nombre_Zona FROM TERMINAL.DBO.SSI_PLANIFICA_TRANSPORTE PT   
       JOIN TERMINAL.DBO.CAMIONAJE_CALLE_ZONA C ON C.Codigo_Zona = PT.ORD_ZONA     
     WHERE PT.ORD_CODIGO = A.ORD_CODIGO),''),  
  @LLENADO_EN_NPT = ISNULL(CASE WHEN B.codbolH03 = 'LC' THEN 'SI' ELSE 'NO' END,''),  
  @LINEA_TKT = ISNULL(B.CODLIN10,''),  
  @LINEA_GRUPO = ISNULL((SELECT CODGRU10 FROM DQARMADO10 WHERE codarm10 = B.codarm10),''),  
  @VACIO_NEPT =  ISNULL(CASE WHEN (SELECT [rb_int_identificador_terminal] FROM [dbneptunia].[contenedor].[tbl_reserva_booking] WHERE [rb_str_numero_booking] = B.bkgcom13) IS NOT NULL THEN 'SI' ELSE 'NO' END,'')  
       
       
    
FROM terminal.dbo.SSI_ORDEN A RIGHT JOIN EDBOOKIN13 B ON A.ORD_NUMDOCUMENTO = B.bkgcom13       
    
  WHERE unitFacilityVisitGkey = @UnitFacilityVisitGkey and ISNULL(b.flgEnviarN4,'0') = 1       
    
    
SET @RESULT =        
    
     'ORD_FLAGREGISTRO:'+@ORD_FLAGREGISTRO+ ','+       
    
     'ORD_CODAGENCIA:'+@ORD_CODAGENCIA+ ','+       
    
     'ORD_CLIENTE:'+@ORD_CLIENTE+ ','+       
    
     'CODPRO27:'+@CODPRO27+ ','+       
    
     'CONTEN13:'+@CONTEN13+ ','+       
    
     'RUCCLI13:'+@RUCCLI13+ ','+       
    
     'RUCOPL13:'+@RUCOPL13+ ','+       
    
     'ORD_CLIENTEFACT:'+@ORD_CLIENTEFACT+ ','+       
    
     'ORD_OBSERVACION:'+@ORD_OBSERVACION+ ','+       
    
     'CODPLANTA:'+@CODPLANTA+ ','+       
    
     'ORD_CODIGO:'+@ORD_CODIGO+ ','+       
    
     'NOMBRE_ZONA:'+@Nombre_Zona+ ','+      
  'LLENADO_EN_NPT:'+@LLENADO_EN_NPT+ ','+      
  'LINEA_TKT:'+@LINEA_TKT+ ','+      
  'LINEA_GRUPO:'+@LINEA_GRUPO+ ','+      
  'VACIO_NEPT:'+@VACIO_NEPT  
    
--SELECT @RESULT AS RESULT;       
RETURN  @RESULT
       
END 
GO

ALTER PROCEDURE SP_INS_FICHA_ASIGNACION
	--DECLARE                      
	@I_GENBKG13 CHAR(6)
	,@S_GENBKG13 CHAR(6)
	,@CODCON04_NEW VARCHAR(11)
	,@CODCON04_OLD VARCHAR(11)
	--SET @I_GENBKG13 = '424451'                      
	--SET @S_GENBKG13 = '424047'                      
AS
DECLARE @f_CONTEN13 CHAR(200)
	,@f_CODEMC12 CHAR(13)
	,@f_NOMEMB13 CHAR(100)
	,@f_RUCAGE19 CHAR(11)
	,@f_BOOKIN13 CHAR(6)
	,@n_genbkg13 CHAR(6)
	,@f_NROCON13 CHAR(25)
	,@f_CODARM10 CHAR(3)
	,@f2_CODARM10 CHAR(3)
	,@f2_NAVVIA11 CHAR(6)
	,@f2_CODLIN10 CHAR(3)
	,@f_BOOKCOMPLE CHAR(25)
	,@f2_GKEY_BOOKING VARCHAR(500)

--|BOOKIN PRINCIPAL                    
SELECT @f_CONTEN13 = CONTEN13
	,@f_CODEMC12 = CODEMC12
	,@f_NOMEMB13 = NOMEMB13
	,@f_RUCAGE19 = RUCAGE19
	,@f_BOOKIN13 = BOOKIN13
	,@f_NROCON13 = NROCON13
	,@f_CODARM10 = CODARM10
	,@f_BOOKCOMPLE = bkgcom13
FROM EDBOOKIN13
WHERE GENBKG13 = @S_GENBKG13

--|BOOKIN AL QUE SE ROLEA                        
SELECT @f2_CODARM10 = CODARM10
	,@f2_NAVVIA11 = NAVVIA11
	,@f2_CODLIN10 = codlin10
	,@f2_GKEY_BOOKING = ltrim(rtrim(UnitFacilityVisitGkey))
FROM EDBOOKIN13
WHERE genbkg13 = @I_GENBKG13

--|Registrar Consolidador en la auditoria    
DECLARE @ruccli13 VARCHAR(11)

SELECT @ruccli13 = isnull(ruccli13, '')
FROM edbookin13
WHERE genbkg13 = @I_GENBKG13

--select @f_CONTEN13, @f_CODEMC12, @f_NOMEMB13, @f_RUCAGE19, @f_BOOKIN13, @f_NROCON13, @f_CODARM10, @f_NAVVIA11                      
--    

--|Obtener Valores del GkeyBooking y UnitFacilityVisitGkey
DECLARE @Gkeybooking varchar(500)
,@GkeyUnitFacilityVisit varchar(500)

select @Gkeybooking = isnull(UnitFacilityVisitGkey,'') 
from EDBOOKIN13 (nolock) WHERE genbkg13 = @I_GENBKG13

select @GkeyUnitFacilityVisit = isnull(UnitFacilityVisitGkey,'') 
from ERCONASI17 (nolock) WHERE genbkg13 = @I_GENBKG13 --AND codcon04 = @CODCON04_NEW

--select @f2_CODARM10                      
IF (
		LEN(@f_NROCON13) > 4
		AND @f_CODARM10 <> 'OC'
		)
	OR (
		@f_CODARM10 = 'OC'
		AND @f2_CODARM10 = 'OC'
		)
BEGIN
	SELECT @I_GENBKG13 AS genbkg13

	Update EDBOOKIN13
		set UnitFacilityVisitGkey = @Gkeybooking
	WHERE genbkg13 = @S_GENBKG13 

	Update ERCONASI17
		set UnitFacilityVisitGkey = @GkeyUnitFacilityVisit
	WHERE genbkg13 = @S_GENBKG13 --and codcon04 = @CODCON04_OLD 

	INSERT INTO DDAUDITTRASEG00
	VALUES (
		@S_GENBKG13
		,@ruccli13
		,user_name()
		,GETDATE()
		,@I_GENBKG13
		,'1'
		)
END
ELSE
BEGIN
	IF EXISTS (
			SELECT genbkg13
			FROM EDBOOKIN13
			WHERE genbkg13 = @I_GENBKG13
				AND BOOKIN13 = @f_BOOKIN13
			)
	BEGIN                        
		SELECT @I_GENBKG13 AS genbkg13

		Update EDBOOKIN13
			set UnitFacilityVisitGkey = @Gkeybooking
		WHERE genbkg13 = @S_GENBKG13

		Update ERCONASI17
			set UnitFacilityVisitGkey = @GkeyUnitFacilityVisit
		WHERE genbkg13 = @S_GENBKG13 --and codcon04 = @CODCON04_OLD

		INSERT INTO DDAUDITTRASEG00
		VALUES (
			@S_GENBKG13
			,@ruccli13
			,user_name()
			,GETDATE()
			,@I_GENBKG13
			,'2'
			)
	END

	IF EXISTS (
			SELECT *
			FROM EDBOOKIN13
			WHERE BOOKIN13 = @f_BOOKIN13
				AND CODARM10 = @f2_CODARM10
				AND NAVVIA11 = @f2_NAVVIA11
				--|VALIDACION PARA EVITAR DUPLICIDAD POR BOOKING DE 6 DIGITOS          
				AND isnull(bkgcom13, '') = @f_BOOKCOMPLE
			)
	BEGIN                    
		IF (SELECT count(*)
			FROM ERCONASI17
			WHERE genbkg13 = @I_GENBKG13) > 1
		BEGIN
			declare @GenbkgAntiguo VARCHAR(6)

			set @GenbkgAntiguo = @S_GENBKG13

			SELECT @S_GENBKG13 = GENBKG13
			FROM EDBOOKIN13
			WHERE BOOKIN13 = @f_BOOKIN13
				AND CODARM10 = @f2_CODARM10
				AND NAVVIA11 = @f2_NAVVIA11
				--|VALIDACION PARA EVITAR DUPLICIDAD POR BOOKING DE 6 DIGITOS          
				AND isnull(bkgcom13, '') = @f_BOOKCOMPLE

			SELECT @S_GENBKG13 AS genbkg13

			Update EDBOOKIN13
				set UnitFacilityVisitGkey = @Gkeybooking
			--WHERE genbkg13 = @GenbkgAntiguo
			WHERE genbkg13 = @S_GENBKG13

			--IF NOT EXISTS(
			--				SELECT genbkg13
			--				FROM ERCONASI17
			--				WHERE genbkg13 = @S_GENBKG13
			--				and codcon04 = @CODCON04_NEW
			--			 )
			--BEGIN
			--	INSERT INTO ERCONASI17 (
			--		genbkg13
			--		,codcon04
			--		,nroitm17
			--		,fecasi17
			--		,codusu17
			--		,fecusu00
			--		,coddep04
			--		,flgvia17
			--		,flgenv17
			--		,flgnot17
			--		,nropre16
			--		,nroaut14
			--		,flgsol17
			--		,ftrsme17
			--		,feccan17
			--		,flgtra99
			--		,fectra99
			--		,flgmoe17
			--		,fecmoe17
			--		,ordemb17
			--		,notemb17
			--		,codaut17
			--		,codimo17
			--		,coduno17
			--		,nroenv17
			--		,fecref17
			--		,fecnum17
			--		,feccon17
			--		,sucursal
			--		,flgmov17
			--		,cambio17
			--		,flgemb17
			--		,slocal17
			--		,flgfum17
			--		,otrdep17
			--		,flgexp17
			--		,nroena17
			--		,autena17
			--		,aduana17
			--		,Depori17
			--		,destra17
			--		,fecfum17
			--		,profum17
			--		,nropre16full
			--		,desimo17
			--		,nropreLfull
			--		,flgReefer
			--		,carta
			--		,fecVenCarta
			--		,UnitFacilityVisitGkey
			--		)
			--	SELECT @S_GENBKG13
			--		,codcon04
			--		,nroitm17
			--		,fecasi17
			--		,user_name()
			--		,getdate()
			--		,coddep04
			--		,flgvia17
			--		,flgenv17
			--		,flgnot17
			--		,nropre16
			--		,nroaut14
			--		,flgsol17
			--		,ftrsme17
			--		,feccan17
			--		,flgtra99
			--		,fectra99
			--		,flgmoe17
			--		,fecmoe17
			--		,ordemb17
			--		,notemb17
			--		,codaut17
			--		,codimo17
			--		,coduno17
			--		,nroenv17
			--		,fecref17
			--		,fecnum17
			--		,feccon17
			--		,sucursal
			--		,flgmov17
			--		,cambio17
			--		,flgemb17
			--		,slocal17
			--		,flgfum17
			--		,otrdep17
			--		,flgexp17
			--		,nroena17
			--		,autena17
			--		,aduana17
			--		,depori17
			--		,destra17
			--		,fecfum17
			--		,profum17
			--		,nropre16full
			--		,desimo17
			--		,nropreLfull
			--		,flgReefer
			--		,carta
			--		,fecVenCarta
			--		,UnitFacilityVisitGkey
			--	FROM ERCONASI17
			--	WHERE genbkg13 = @I_GENBKG13
			--	and codcon04 = @CODCON04_NEW
			--END
		END
		ELSE
		BEGIN
			SELECT @S_GENBKG13 = GENBKG13
			FROM EDBOOKIN13
			WHERE BOOKIN13 = @f_BOOKIN13
				AND CODARM10 = @f2_CODARM10
				AND NAVVIA11 = @f2_NAVVIA11
				--|VALIDACION PARA EVITAR DUPLICIDAD POR BOOKING DE 6 DIGITOS          
				AND isnull(bkgcom13, '') = @f_BOOKCOMPLE

			SELECT @S_GENBKG13 AS genbkg13

			Update EDBOOKIN13
				set UnitFacilityVisitGkey = @Gkeybooking
			WHERE genbkg13 = @S_GENBKG13

			Update ERCONASI17
				set UnitFacilityVisitGkey = @GkeyUnitFacilityVisit
			WHERE genbkg13 = @S_GENBKG13 --and codcon04 = @CODCON04_OLD
		END 

		INSERT INTO DDAUDITTRASEG00
		VALUES (
			@S_GENBKG13
			,@ruccli13
			,user_name()
			,GETDATE()
			,@I_GENBKG13
			,'3'
			)
	END
	ELSE
	BEGIN
		--SELECT 'No debe ingresar'                      
		SET @n_genbkg13 = (
				SELECT (CONTAD00 + 1) + '000000'
				FROM ECBOOKIN13
				)

		INSERT INTO EDBOOKIN13 (
			codarm10
			,bookin13
			,codemc12
			,codage29
			,codpue02
			,navvia11
			,codusu17
			,fecusu00
			,codbol03
			,codtam09
			,codtip05
			,genbkg13
			,numcon13
			,codprv15
			,codpro27
			,codemb06
			,pesmer13
			,codpue13
			,conten13
			,status13
			,flgmer13
			,flgcon13
			,nomemb13
			,flgTbk13
			,desfin13
			,correl13
			,codtip55
			,ruccli13
			,rucage19
			,flgtra99
			,fectra99
			,codimo00
			,nrocon13
			,ponedi13
			,consol13
			,consfc13
			,sucursal
			,SistemaFuente
			,bkgmad13
			,trainf13
			,cod_producto
			,cod_subproducto
			,Ejecutivo
			,Estado
			,EstadoMod
			,flgNTipos
			,forrado
			,facturara
			,gremios
			,viaembarque
			,cobrotarja
			,feclln13
			,coddep04
			,usuweb13
			,desc_producto
			,tracasa
			,Tar_Apli
			,codbolH03
			,rucopl13
			,cancit13
			,feccit13
			,EmbPaita
			,ruccol13
			,BloqueoWms13
			,codTipReefer
			,codlin10
			,bkgcom13
			,UnitFacilityVisitGkey
			)
		SELECT codarm10
			,@f_BOOKIN13
			,@f_CODEMC12
			,codage29
			,codpue02
			,navvia11
			,user_name()
			,getdate()
			,codbol03
			,codtam09
			,codtip05
			,@n_genbkg13
			,numcon13
			,codprv15
			,codpro27
			,codemb06
			,pesmer13
			,codpue13
			,@f_CONTEN13
			,status13
			,flgmer13
			,flgcon13
			,@f_NOMEMB13
			,flgTbk13
			,desfin13
			,correl13
			,codtip55
			,ruccli13
			,@f_RUCAGE19
			,flgtra99
			,fectra99
			,codimo00
			,nrocon13
			,ponedi13
			,consol13
			,consfc13
			,sucursal
			,SistemaFuente
			,bkgmad13
			,trainf13
			,cod_producto
			,cod_subproducto
			,Ejecutivo
			,Estado
			,EstadoMod
			,flgNTipos
			,forrado
			,facturara
			,gremios
			,viaembarque
			,cobrotarja
			,feclln13
			,coddep04
			,usuweb13
			,desc_producto
			,tracasa
			,tar_apli
			,codbolH03
			,rucopl13
			,cancit13
			,feccit13
			,embpaita
			,ruccol13
			,bloqueowms13
			,codTipReefer
			,codlin10
			,@f_BOOKCOMPLE
			,@Gkeybooking
		FROM EDBOOKIN13
		WHERE GENBKG13 = @I_GENBKG13

		INSERT INTO ERCONASI17 (
			genbkg13
			,codcon04
			,nroitm17
			,fecasi17
			,codusu17
			,fecusu00
			,coddep04
			,flgvia17
			,flgenv17
			,flgnot17
			,nropre16
			,nroaut14
			,flgsol17
			,ftrsme17
			,feccan17
			,flgtra99
			,fectra99
			,flgmoe17
			,fecmoe17
			,ordemb17
			,notemb17
			,codaut17
			,codimo17
			,coduno17
			,nroenv17
			,fecref17
			,fecnum17
			,feccon17
			,sucursal
			,flgmov17
			,cambio17
			,flgemb17
			,slocal17
			,flgfum17
			,otrdep17
			,flgexp17
			,nroena17
			,autena17
			,aduana17
			,Depori17
			,destra17
			,fecfum17
			,profum17
			,nropre16full
			,desimo17
			,nropreLfull
			,flgReefer
			,carta
			,fecVenCarta
			,UnitFacilityVisitGkey
			)
		SELECT @n_genbkg13
			,codcon04
			,nroitm17
			,fecasi17
			,user_name()
			,getdate()
			,coddep04
			,flgvia17
			,flgenv17
			,flgnot17
			,nropre16
			,nroaut14
			,flgsol17
			,ftrsme17
			,feccan17
			,flgtra99
			,fectra99
			,flgmoe17
			,fecmoe17
			,ordemb17
			,notemb17
			,codaut17
			,codimo17
			,coduno17
			,nroenv17
			,fecref17
			,fecnum17
			,feccon17
			,sucursal
			,flgmov17
			,cambio17
			,flgemb17
			,slocal17
			,flgfum17
			,otrdep17
			,flgexp17
			,nroena17
			,autena17
			,aduana17
			,depori17
			,destra17
			,fecfum17
			,profum17
			,nropre16full
			,desimo17
			,nropreLfull
			,flgReefer
			,carta
			,fecVenCarta
			,UnitFacilityVisitGkey
		FROM ERCONASI17
		WHERE genbkg13 = @I_GENBKG13
		--and codcon04 = @CODCON04_NEW

		UPDATE ECBOOKIN13
		SET CONTAD00 = CONTAD00 + 1

		SELECT @n_genbkg13 AS genbkg13

		INSERT INTO DDAUDITTRASEG00
		VALUES (
			@n_genbkg13
			,@ruccli13
			,user_name()
			,GETDATE()
			,@I_GENBKG13
			,'0'
			)
	END
END
GO

/*    
Descripcion: Stored Procedures para migrar informacion de Lineas del N4 hacia Neptunia    
Fecha: 05-10-2018    
Autor: Franklin Milla    
*/
ALTER PROCEDURE sp_IntN4_Mantenimiento_Generacionlineas
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@CodLinea varchar(5)
,@NombreLinea varchar(150)
,@PerteneceNeptunia varchar(1)
,@Status varchar(1)
,@Tipo int --1:Registro, 2:Actualizacion, 3:cancelacion

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
AS
BEGIN
	DECLARE @Exists int
	
	/*Incializando Variables de Salida*/
	SET @IdResul = '0'
	SET @DesResul = 'OK'
	
	SET @CodLinea = LTRIM(rtrim(@CodLinea))
	SET @NombreLinea = LTRIM(rtrim(@NombreLinea))
	SET @NombreLinea = SUBSTRING(@NombreLinea, 1, 35)
	SET @PerteneceNeptunia = LTRIM(rtrim(@PerteneceNeptunia))
	SET @Status = LTRIM(rtrim(@Status))
	/*********************************/

	/*Acciones Registrar(1), Actualizar (2) o cancelar (3)*/
	IF (@Tipo = 1)
	BEGIN
		IF EXISTS(SELECT codarm10 FROM DQARMADO10 (NOLOCK) WHERE codarm10_N4 = @CodLinea)
		BEGIN
			SET @IdResul = '0'
			SET @DesResul = 'OK - Codigo ya existe'
			RETURN;
		END
		IF EXISTS(SELECT codarm10 FROM DQARMADO10 (NOLOCK) WHERE codarm10 = @CodLinea)
		BEGIN
			SET @IdResul = '0'
			SET @DesResul = 'OK - Codigo ya existe'

			UPDATE DQARMADO10
				SET codarm10_N4 = @CodLinea
			WHERE codarm10 = @CodLinea

			RETURN;
		END

		INSERT INTO DQARMADO10
		(codarm10, desarm10, flgfac10, codgru10, flgtra99, fectra99, flgnep10, flgact10, codarm10_N4)
		VALUES
		(@CodLinea, @NombreLinea, 'S', @CodLinea, 'I', GETDATE(), @PerteneceNeptunia, '1', @CodLinea)	
	END
	
	IF (@Tipo = 2)
	BEGIN		
		UPDATE DQARMADO10
			SET flgnep10 = @PerteneceNeptunia
			, flgact10 = @Status
			, desarm10 = @NombreLinea
		 WHERE codarm10_N4 = @CodLinea
	END
	
	IF (@Tipo = 3)
	BEGIN
		IF EXISTS(SELECT codarm10 FROM DQARMADO10 WHERE codarm10_N4 = @CodLinea)
		BEGIN
			UPDATE DQARMADO10
				SET flgact10 = @Status
			 WHERE codarm10_N4 = @CodLinea
		END 
	END
	/*********************************/
END

GO
GRANT ALL ON sp_IntN4_Mantenimiento_Generacionlineas TO PUBLIC

GO

/*    
Descripcion: Stored Procedures para migrar informacion de Naves del N4 hacia Neptunia    
Fecha: 05-10-2018    
Autor: Franklin Milla    
*/
ALTER PROCEDURE sp_IntN4_Mantenimiento_GeneracionNaves
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@CodNave varchar(15)
,@NombreNave varchar(50)
,@CodLinea varchar(5)
,@Status varchar(1)
,@Tipo int --1:Registro, 2:Actualizacion, 3:cancelacion

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
AS
BEGIN
	DECLARE @Exists int
	,@CodigoLineaNeptunia varchar(3)
	
	/*Incializando Variables de Salida*/
	SET @IdResul = '0'
	SET @DesResul = 'OK'
	
	SET @CodLinea = LTRIM(rtrim(@CodLinea))
	SET @NombreNave = LTRIM(rtrim(@NombreNave))
	SET @NombreNave = SUBSTRING(@NombreNave, 1, 30)
	SET @CodNave = LTRIM(rtrim(@CodNave))
	SET @Status = LTRIM(rtrim(@Status))
	
	SET @Status = CASE WHEN @Status = '1' THEN 'S' ELSE 'N' END
	
	IF EXISTS(SELECT codarm10 FROM DQARMADO10 (NOLOCK) WHERE codarm10_N4 = @CodLinea)
	BEGIN
		SELECT @CodigoLineaNeptunia = codarm10
		FROM DQARMADO10 (NOLOCK)
		WHERE codarm10_N4 = @CodLinea
	END
	ELSE
	BEGIN
		SET @CodigoLineaNeptunia = '000' 
	END
	/*********************************/
	
	/*Logica Para Obtener el codigo de Nave si excede los 4 digitos*/
	DECLARE @CodigoNaveNep VARCHAR(4)
	IF (LEN(@CodNave) > 4)
	BEGIN
		SELECT @CodigoNaveNep = codnav08
		FROM terminal..DQNAVIER08 (NOLOCK)
		WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave
	END
	ELSE
	BEGIN
		SET @CodigoNaveNep = @CodNave
	END
	/*********************************/
	
	/*Acciones Registrar(1), Actualizar (2) o cancelar (3)*/
	SET @Exists = 0
	IF (@Tipo = 1)
	BEGIN
		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave)
		BEGIN
			SET @IdResul = '0'
			SET @DesResul = 'OK - codigo ya existe'
			RETURN;
		END
		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE LTRIM(RTRIM(codnav08)) = @CodNave)
		BEGIN
			SET @IdResul = '0'
			SET @DesResul = 'OK - codigo ya existe'

			UPDATE DQNAVIER08
				SET codnav08_N4 = @CodNave
			WHERE LTRIM(RTRIM(codnav08)) = @CodNave

			RETURN;
		END
		
		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE desnav08 = @NombreNave)
		BEGIN
			SET @Exists = 1
		END

		IF @Exists = 0
		BEGIN
			INSERT INTO DQNAVIER08
			(codnav08, desnav08, codpai07, flgtra99, fectra99, activo08, codlineaNave, codnav08_N4)
			VALUES
			(@CodigoNaveNep, @NombreNave, '99', 'I', GETDATE(), 'S', @CodigoLineaNeptunia, @CodNave)
		END
		ELSE
		BEGIN
			UPDATE DQNAVIER08
				SET activo08 = 'S'
				, codnav08_N4 = @CodNave
				, codlineaNave = @CodigoLineaNeptunia
			WHERE desnav08 = @NombreNave
		END	 
	END
	
	SET @Exists = 0
	IF (@Tipo = 2)
	BEGIN
		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave)
		BEGIN
			SET @Exists  = 1
		END

		IF @Exists = 0
		BEGIN
			IF NOT EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE desnav08 = @NombreNave)
			BEGIN
				INSERT INTO DQNAVIER08
				(codnav08, desnav08, codpai07, flgtra99, fectra99, activo08, codlineaNave, codnav08_N4)
				VALUES
				(@CodigoNaveNep, @NombreNave, '99', 'I', GETDATE(), @Status, @CodigoLineaNeptunia, @CodNave)
			END
			ELSE
			BEGIN
				UPDATE DQNAVIER08
				SET activo08 = @Status
				, codnav08_N4 = @CodNave
				, codlineaNave = @CodigoLineaNeptunia
				WHERE desnav08 = @NombreNave
			END
		END
		ELSE
		BEGIN
			UPDATE DQNAVIER08
				SET activo08 = @Status
				, codlineaNave = @CodigoLineaNeptunia
				, desnav08 = @NombreNave
			 WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave
		END	 
	END
	
	SET @Exists = 0
	IF (@Tipo = 3)
	BEGIN
		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave)
		BEGIN
			UPDATE DQNAVIER08
				SET activo08 = @Status
			 WHERE LTRIM(RTRIM(codnav08_N4)) = @CodNave
		END
	END
	/*********************************/
END

GO
GRANT ALL ON sp_IntN4_Mantenimiento_GeneracionNaves TO PUBLIC

GO

ALTER PROCEDURE sp_Expo_FW_Sf_Grabar_Fico
	/**Crea Ficha de Cconsolidacion**/
	@Cod_Cons VARCHAR(11)
	,--Ruc Consolidador  
	@cod_Pue VARCHAR(03)
	,--Cod Puerto  
	@sNavVia VARCHAR(06)
	,--Cod Nave Viaje  
	@sUser VARCHAR(15)
	,--Cod Usuario  
	@RucEmb VARCHAR(11)
	,--Cod Embarcador  
	@NroBoo VARCHAR(06) --Nro Booking   
AS
DECLARE @iCount INTEGER
DECLARE @Cod_Fico DECIMAL

if not exists(
				select Nom_Usua
				from forwarders..Usuarios 
				where Nom_Usua = ltrim(rtrim(@sUser))
			 )
begin
	set @sUser = 'web'
end

SELECT @iCount = count(*)
FROM forwarders..Ficha_Consolidacion
WHERE Cod_Cons = @Cod_Cons
	AND isnull(Cod_Pue, '') = @cod_Pue
	AND Est_Fico = 'A'
	AND navvia11 = @sNavVia

IF @iCount = 0
BEGIN
	INSERT forwarders..Ficha_Consolidacion (
		Cod_Cons
		,Fec_Fico
		,Usu_Creo
		,cod_pue
		,navvia11
		)
	VALUES (
		@Cod_Cons
		,getdate()
		,@sUser
		,@Cod_Pue
		,@sNavVia
		)
END

SELECT @Cod_Fico = Cod_Fico
FROM forwarders..Ficha_Consolidacion
WHERE Cod_Cons = @Cod_Cons
	AND isnull(Cod_Pue, '') = @cod_Pue
	AND Est_Fico = 'A'
	AND navvia11 = @sNavVia

SELECT @iCount = count(*)
FROM forwarders..Embarcadores
WHERE Cod_Fico = @Cod_Fico

IF @iCount = 0
BEGIN
	INSERT forwarders..Embarcadores (
		Cod_Fico
		,Cod_Emba
		,Nro_Book
		)
	VALUES (
		@Cod_Fico
		,@RucEmb
		,@NroBoo
		)
END
GO

/*    
Descripcion: Stored Procedure Para Validar datos de Operativa antes de realizar la Finalizacion de llenado de un contenedor 
Fecha: 15-03-2019    
Autor: Franklin Milla    
*/
create procedure sp_IntN4_Embarque_FinalizacionLlenado_Validaciones
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@Contenedor varchar(11)
,@Gkeybooking varchar(500)
,@Sucursal varchar(3) --VIL:Villegas, VEN:Ventanilla, PAI:Paita
,@UnitFacilityVisitGkey varchar(500)
,@VesselVisit varchar(150)

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	set @IdResul = '0'
	set @DesResul = 'OK'
	
	set @Contenedor = LTRIM(rtrim(@Contenedor))
	set @Gkeybooking = LTRIM(rtrim(@Gkeybooking))
	set @UnitFacilityVisitGkey = LTRIM(rtrim(@UnitFacilityVisitGkey))
	/*********************************/

	declare @Navvia varchar(6)
	,@nroaut varchar(8)
	,@ICOUNT int
	,@NROTKT varchar(8)
	,@PESONETOMERC DECIMAL(12, 3)

	if not exists(select navvia11 from ddcabman11 (nolock) where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit and tipope11 = 'E')
	begin
		set @IdResul = '-1'
		set @DesResul = 'VesselVisit no registrado en el Maestro de Nave-Viaje'
		return;
	end
	else
	begin
		select @Navvia = navvia11
		from DDCABMAN11 (nolock)
		where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit
		and tipope11 = 'E'
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Contenedor no se encuentra Asignado a un Booking en Embarque'
		return;
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
					and B.flgenv17 <> '2'
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Contenedor se encuentra cancelado en sistema Embarque'
		return;
	end

	if exists(
				select CONTENEDOR
				from TERMLLENADN4 (nolock)
				where CONTENEDOR = @Contenedor
				and NAVVIA = @Navvia
			 )
	begin
		set @IdResul = '-1'
		set @DesResul = 'Ya se registro la Finalización de Llenado para ese Contenedor'
		return;
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
														  and C.codcon14 = B.codcon04
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'El Contenedor no cuenta con registro de Autorizaciones de Ingreso'
		return;
	end

	set @nroaut = ''

	select @nroaut = C.nroaut14
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	left join EDLLENAD16 D with (nolock) on D.nroaut14 = C.nroaut14
										 and D.codcon04 = C.codcon14
	where B.nroaut14 IS NULL
		and A.navvia11 = @Navvia
		and B.codcon04 = @Contenedor

	if LTRIM(RTRIM(ISNULL(@nroaut, ''))) <> ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'El Nro. de autorización: ' + @nroaut + ' asociado al contenedor no cuenta con Llenado'
		return;
	end
	
	select @ICOUNT = COUNT(*)
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	inner join DDTICKET18 D WITH (NOLOCK) on C.nroaut14 = D.nroaut14
										  and D.codcon04 = C.codcon14
	where D.fecsal18 IS NOT NULL
		and A.navvia11 = @Navvia
		and C.codcon14 = @Contenedor

	IF @ICOUNT = 0
	BEGIN
		set @IdResul = '-1'
		set @DesResul = 'El Contenedor: ' + @Contenedor + ' No cuenta con Registro de Ticket de Salida'
		return;
	END

	select C.nroaut14
		,C.codcon14
		,IDENTITY(INT, 1, 1) AS ID
	into #TEMPORAL
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	where A.navvia11 = @Navvia
		and C.codcon14 = @Contenedor

	declare @C INT
		,@CC INT

	set @C = 1

	select @CC = COUNT(*)
	from #TEMPORAL

	while @C <= @CC
	begin
		select @NROAUT = nroaut14
		from #TEMPORAL
		where ID = @C

		select @ICOUNT = COUNT(*)
		from DDTICKET18 with (nolock)
		where nroaut14 = @NROAUT
			AND fecsal18 is not null

		if @ICOUNT = 0
		begin
			select @NROTKT = nrotkt18
			from DDTICKET18 with (nolock)
			where nroaut14 = @NROAUT
				and fecsal18 IS NULL
			
			set @IdResul = '-1'
			set @DesResul = 'El Ticket: ' + @NROTKT + ' No cuenta con Fecha de Salida (No existe peso Neto registrado)'
			return;
		end

		set @C = @C + 1
	end

	drop table #TEMPORAL

	select @PESONETOMERC = SUM(B.pesnet18)
	from DDTICKET18 B with (nolock)
	where B.codcon04 = @Contenedor
		AND B.navvia11 = @Navvia
		AND B.fecsal18 IS NOT NULL
	group by B.navvia11

	set @DesResul = ltrim(rtrim(cast(@PESONETOMERC as varchar(16))))
end

GO
grant all on sp_IntN4_Embarque_FinalizacionLlenado_Validaciones to public
GO

/*    
Descripcion: Stored Procedure Para Registrar datos de la Finalizacion de llenado de un contenedor 
Fecha: 17-03-2019    
Autor: Franklin Milla    
*/
create procedure sp_IntN4_Embarque_FinalizacionLlenado_Registro
@GkeyUnitFacilityVisit varchar(500)
,@Gkey_Booking varchar(500)
,@Linea varchar(5)
,@VesselVisit varchar(15)
,@Ctr varchar(11)
,@Precinto varchar(500)
,@PesoNeto decimal(15,3)
,@Sucursal varchar(3)
,@AccionSQL varchar(1) --1: INSERT, 2: UPDATE

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	set @IdResul = '0'
	set @DesResul = 'OK'
	
	set @GkeyUnitFacilityVisit = LTRIM(rtrim(@GkeyUnitFacilityVisit))
	set @Gkey_Booking = LTRIM(rtrim(@Gkey_Booking))
	set @VesselVisit = LTRIM(rtrim(@VesselVisit))
	set @Linea = ltrim(rtrim(@Linea))
	set @Precinto=ltrim(Rtrim(@Precinto))
	/*********************************/

	declare @navvia varchar(6)
	,@codLinea varchar(3)
	,@genbkg13 varchar(6)

	select @navvia = navvia11
	from DDCABMAN11(nolock)
	where tipope11 = 'E'
	and VESSELVISITID = @VesselVisit

	select @codLinea = codarm10
	from DQARMADO10 (nolock)
	where codarm10_N4 = @Linea

	select @genbkg13 =genbkg13
	from EDBOOKIN13 (nolock)
	where ltrim(rtrim(UnitFacilityVisitGkey)) = @Gkey_Booking

	exec sp_IntN4_Embarque_RegistrarCtrEmitidoN4 @GkeyUnitFacilityVisit, @Gkey_Booking, @codLinea,
	@navvia, @VesselVisit, @genbkg13, @Ctr, @Precinto, 'C', @PesoNeto, 'IntN4', @Sucursal, @AccionSQL

end

GO
grant all on sp_IntN4_Embarque_FinalizacionLlenado_Registro to public

GO

--=================================================================================                      
-- CREAMOS EL STORED PROCEDURE                      
--=================================================================================                      
ALTER PROCEDURE [dbo].[usp_gwc_insert_edbooking13] (
	@codarm10 CHAR(03)
	,@bookin13 CHAR(06)
	,@codemc12 CHAR(13)
	,@codpue02 CHAR(03)
	,@codbol03 CHAR(02)
	,@codtam09 CHAR(02)
	,@codtip05 CHAR(02)
	,@numcon13 INT
	,@codpro27 CHAR(05)
	,@pesmer13 DECIMAL(12, 6)
	,@codpue13 CHAR(03)
	,@conten13 CHAR(200)
	,@status13 CHAR(01)
	,@flgmer13 CHAR(01)
	,@flgcon13 CHAR(01)
	,@nomemb13 CHAR(100)
	,@flgtbk13 CHAR(01)
	,@desfin13 CHAR(50)
	,@codtip55 CHAR(01)
	,@ruccli13 CHAR(11)
	,@rucage19 CHAR(11)
	,@codimo00 CHAR(02)
	,@nrocon13 CHAR(25)
	,@consfc13 CHAR(01)
	,@sucursal CHAR(01)
	,@bkgmad13 CHAR(01)
	,@cod_producto CHAR(05)
	,@cod_subproducto CHAR(05)
	,@tracasa CHAR(01)
	,@Tar_Apli CHAR(01)
	,@codbolH03 CHAR(02)
	,@rucopl13 CHAR(11)
	,@EmbPaita CHAR(15)
	,@ruccol13 CHAR(11)
	,@codTipReefer CHAR(02)
	,@codlin10 CHAR(03)
	,@observa VARCHAR(8000)
	,@nave CHAR(04)
	,@viaje CHAR(10)
	,@codigoret INT OUTPUT
	,@resultado VARCHAR(500) OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @nfilas INT;
	DECLARE @bookingen INT;
	DECLARE @tempo CHAR(06);
	-- <2015-04-24 - FMCR - INI>                      
	--DECLARE @cabecera     char(12);                      
	DECLARE @cabecera CHAR(16);
	DECLARE @fecllega CHAR(19);
	-- <2015-04-24 - FMCR - FIN>                      
	DECLARE @genbkg13 CHAR(06);
	DECLARE @navvia11 CHAR(06);
	--<2015-10-17 - VSB - INI>                      
	DECLARE @flgPto CHAR(1);
	DECLARE @flgPto2 CHAR(1);

	--<2015-10-17 - VSB - FIN>                      
	SET @nfilas = 0;
	SET @codigoret = 0;
	SET @bookingen = 0;
	SET @genbkg13 = '';
	SET @navvia11 = '';
	SET @tempo = '';
	-- <2015-04-24 - FMCR - INI>                      
	--SET @cabecera      = '000100060001'                      
	SET @cabecera = '0002000600190001'
	SET @fecllega = '';
	-- <2015-04-24 - FMCR - FIN>                      
	--<2015-10-17 - VSB - INI>                      
	SET @codpro27 = LTRIM(RTRIM(ISNULL(@codpro27, '')));
	SET @cod_producto = LTRIM(RTRIM(ISNULL(@cod_producto, '')));
	SET @cod_subproducto = LTRIM(RTRIM(ISNULL(@cod_subproducto, '')));
	SET @codpro27 = @cod_subproducto;

	--|VARIABLE NUEVO BOOKIN                    
	DECLARE @BOOK_NEW VARCHAR(6)
	DECLARE @FLGEMAIL VARCHAR(1)

	SET @FLGEMAIL = '0'

	--|                     
	--<2015-10-17 - VSB - FIN>                      
	-- VALIDACION DEL CAMPO LINEA                      
	IF (@codarm10 IS NULL)
		OR LEN(RTRIM(LTRIM(@codarm10))) <= 0
	BEGIN
		SET @codigoret = 817
		SET @resultado = 'WS_EMBARQUE_ERROR_INSERT_BOOKING: YOU ARE TRYING TO INSERT A NULL VALUE TO THE FIELD : LINEA'

		RETURN
	END

	-- VALIDACION DEL CAMPO NRO DEL BOOKING                      
	IF (@bookin13 IS NULL)
		OR LEN(RTRIM(LTRIM(@bookin13))) <= 0
	BEGIN
		SET @codigoret = 817
		SET @resultado = 'WS_EMBARQUE_ERROR_INSERT_BOOKING: YOU ARE TRYING TO INSERT A NULL VALUE TO THE FIELD : BKNG_EXT'

		RETURN
	END

	-- < 20180620 - FMCR - INICIO >    
	-- VALIDACION CAMPO CONDICION ORIGEN  @codbol03    
	--IF (@codbol03 IS NULL)    
	--OR LEN(RTRIM(LTRIM(@codbol03))) <= 0    
	--BEGIN    
	-- SET @codigoret = 817    
	-- SET @resultado = 'WS_EMBARQUE_ERROR_INSERT_BOOKING: ESTA TRATANDO DE INSERTAR UN VALOR VACIO EN EL CAMPO CONDICION ORIGEN, VERIFICAR!!!'    
	-- RETURN    
	--END    
	-- < 20180620 - FMCR - FINAL >    
	-- VALIDACION DEL CAMPO PUERTO DE DESCARGA                      
	/*            
 IF (@codpue02 IS NULL)            
  OR LEN(RTRIM(LTRIM(@codpue02))) <= 0            
 BEGIN            
  SET @codigoret = 817           
  SET @resultado = 'WS_EMBARQUE_ERROR_INSERT_BOOKING: YOU ARE TRYING TO INSERT A NULL VALUE TO THE FIELD : DESC'            
            
  RETURN            
 END            
 */
	--<2015-10-17 - VSB - INI>                  
	---CAMBIA EL CODIGO                      
	--ELSE            
	--BEGIN            
	SET @flgPto = ''

	SELECT @codpue02 = isnull(codpue02, '')
		,@flgPto = '1'
	FROM DQPUERTO02
	WHERE substring(codsol02, 3, 3) = @codpue02

	IF @flgPto = ''
		SET @codpue02 = 'XXX'
	SET @flgPto2 = ''

	SELECT @codpue13 = isnull(codpue02, '')
		,@flgPto2 = '1'
	FROM DQPUERTO02
	WHERE substring(codsol02, 3, 3) = @codpue13

	IF @flgPto2 = ''
		SET @codpue13 = 'XXX'

	--END            
	--<2015-10-17 - VSB - FIN>                      
	--|VALIDACIONES IQBF              
	DECLARE @IQBF VARCHAR(1)

	IF SUBSTRING(@observa, 1, 4) = 'IQBF'
	BEGIN
		SET @IQBF = '1'
	END
	ELSE
	BEGIN
		SET @IQBF = '0'
	END

	IF @observa LIKE '%IQBF%'
	BEGIN
		SET @IQBF = '1'
	END
	ELSE
	BEGIN
		SET @IQBF = '0'
	END

	--IF @flgmer13='1' AND @codimo00='IQ'                  
	--BEGIN                  
	-- SET @IQBF = '1'                  
	--END                  
	--ELSE                  
	--BEGIN                   
	-- SET @IQBF = '0'                   
	--END                  
	--SET @codimo00 = LTRIM(RTRIM(@codimo00))                  
	--IF @codimo00='IQ'                  
	--BEGIN                  
	-- SET @codimo00=''                  
	--END                   
	--|                  
	-- VALIDACION DE LOS CAMPOS NAVE Y VIAJE                      
	BEGIN TRY
		SET @nfilas = 0;

		SELECT
			-- <2015-04-24 - FMCR - INI>                      
			--   @navvia11 = navvia11                      
			@navvia11 = navvia11
			,@fecllega = dbo.usf_gwc_prepare_value_datetime(feclle11, 126)
		-- <2015-04-24 - FMCR - INI>                      
		FROM DDCABMAN11 WITH (NOLOCK)
		WHERE codnav08 = @nave
			AND numvia11 = @viaje
			AND TIPOPE11 IN (
				'E'
				,'A'
				)
		ORDER BY FECLLE11 DESC;

		SET @nfilas = @@ROWCOUNT;
	END TRY

	BEGIN CATCH
		SET @codigoret = 900
		SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()

		RETURN
	END CATCH

	IF @nfilas = 0
	BEGIN
		--//VALIDACION PARA QUE INSERTE NAVE/VIAJE FICTICIA PARA HSD , CON ESTO SE PODRAN CARGAR LOS COPARN        
		--IF LTRIM(RTRIM(@codarm10)) = 'HSD'    
		--BEGIN    
		-- SELECT    
		--  -- <2015-04-24 - FMCR - INI>                  
		--  --   @navvia11 = navvia11                  
		--  @navvia11 = navvia11    
		--  ,@fecllega = dbo.usf_gwc_prepare_value_datetime(feclle11, 126)    
		-- -- <2015-04-24 - FMCR - INI>                  
		-- FROM DDCABMAN11 WITH (NOLOCK)    
		-- WHERE codnav08 = 'GENE'    
		--  AND numvia11 = 'EXPO-'    
		--  AND TIPOPE11 IN (    
		--   'E'    
		--   ,'A'    
		--   )    
		-- ORDER BY FECLLE11 DESC;    
		--END    
		--ELSE    
		--BEGIN    
		SET @codigoret = 817
		SET @resultado = 'WS_EMBARQUE_ERROR_INSERT_BOOKING: YOU ARE TRYING TO INSERT A NAVE + VIAJE THAT DOES NOT EXIST'

		RETURN
			--END    
	END

	--<2015-10-19 - FMCR - INI>                      
	--SE QUITAN LOS ESPACIOS EN BLANCO DE LAS VARIABLES CHAR Y VARCHAR                      
	SET @codarm10 = LTRIM(RTRIM(@codarm10))
	SET @bookin13 = LTRIM(RTRIM(@bookin13))
	SET @codemc12 = LTRIM(RTRIM(@codemc12))
	SET @codpue02 = LTRIM(RTRIM(@codpue02))
	SET @codbol03 = LTRIM(RTRIM(@codbol03))
	SET @codtam09 = LTRIM(RTRIM(@codtam09))
	SET @codtip05 = LTRIM(RTRIM(@codtip05))
	SET @codpro27 = LTRIM(RTRIM(@codpro27))
	SET @codpue13 = LTRIM(RTRIM(@codpue13))
	SET @conten13 = LTRIM(RTRIM(@conten13))
	SET @status13 = LTRIM(RTRIM(@status13))
	SET @flgmer13 = LTRIM(RTRIM(@flgmer13))
	SET @flgcon13 = LTRIM(RTRIM(@flgcon13))
	SET @nomemb13 = LTRIM(RTRIM(@nomemb13))
	SET @flgtbk13 = LTRIM(RTRIM(@flgtbk13))
	SET @desfin13 = LTRIM(RTRIM(@desfin13))
	SET @codtip55 = LTRIM(RTRIM(@codtip55))
	SET @ruccli13 = LTRIM(RTRIM(@ruccli13))
	SET @rucage19 = LTRIM(RTRIM(@rucage19))
	SET @codimo00 = LTRIM(RTRIM(@codimo00))
	SET @nrocon13 = LTRIM(RTRIM(@nrocon13))
	SET @consfc13 = LTRIM(RTRIM(@consfc13))
	SET @sucursal = LTRIM(RTRIM(@sucursal))
	SET @bkgmad13 = LTRIM(RTRIM(@bkgmad13))
	SET @codlin10 = LTRIM(RTRIM(@codlin10))
	SET @Tar_Apli = LTRIM(RTRIM(@Tar_Apli))
	SET @rucopl13 = LTRIM(RTRIM(@rucopl13))
	SET @EmbPaita = LTRIM(RTRIM(@EmbPaita))
	SET @ruccol13 = LTRIM(RTRIM(@ruccol13))
	SET @tracasa = LTRIM(RTRIM(@tracasa))
	SET @observa = LTRIM(RTRIM(@observa))
	SET @nave = LTRIM(RTRIM(@nave))
	SET @viaje = LTRIM(RTRIM(@viaje))
	SET @codTipReefer = LTRIM(RTRIM(@codTipReefer))
	SET @codbolH03 = LTRIM(RTRIM(@codbolH03))
	SET @cod_producto = LTRIM(RTRIM(@cod_producto))
	SET @cod_subproducto = LTRIM(RTRIM(@cod_subproducto))

	--<2015-10-19 - FMCR - FIN>              
	BEGIN TRY
		SET @nfilas = 0

		--|MODIFICACION PARA NO REGISTRAR DUPLICADOS CUANDO LA LINEA SEHA PIL                    
		IF LTRIM(RTRIM(@codarm10)) = 'PIL'
			OR LTRIM(RTRIM(@codarm10)) = 'CSL'
		BEGIN
			SELECT @genbkg13 = genbkg13
			FROM EDBOOKIN13 WITH (NOLOCK)
			WHERE
				--<2015-10-19 - FMCR - INI>                      
				--genbkg13 = @genbkg13;                      
				bkgcom13 = @nrocon13
				AND navvia11 = @navvia11
				AND codarm10 = @codarm10
				--and bookin13 = @bookin13                      
				--and codemc12 = @codemc12                     
		END
		ELSE
		BEGIN
			SELECT @genbkg13 = genbkg13
			FROM EDBOOKIN13 WITH (NOLOCK)
			WHERE
				--<2015-10-19 - FMCR - INI>         
				--genbkg13 = @genbkg13;                      
				bkgcom13 = @nrocon13
				AND navvia11 = @navvia11
				AND codarm10 = @codarm10
				AND bookin13 = @bookin13
				AND codemc12 = @codemc12
				--<2015-10-19 - FMCR - FIN>                      
		END

		--|                    
		SET @nfilas = @@ROWCOUNT;
	END TRY

	BEGIN CATCH
		SET @codigoret = 900
		SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()

		RETURN
	END CATCH

	IF @nfilas = 0
	BEGIN
		--<2015-10-19 - FMCR - INI>                      
		SET @genbkg13 = '';

		--<2015-10-19 - FMCR - FIN>                      
		BEGIN TRY
			-- EJECUTAMOS EL SP DEL CONTADOR DE BOOKINGS                      
			EXEC usp_gwc_counter_ecbookin13 @bookingen OUTPUT
		END TRY

		BEGIN CATCH
			SET @codigoret = 900
			SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()

			RETURN
		END CATCH

		BEGIN TRY
			SELECT @genbkg13 = right('000000' + rtrim(ltrim(convert(CHAR(6), @bookingen))), 6);

			--|MODIFICACION PARA NO REGISTRAR DUPLICADOS CUANDO LA LINEA SEHA PIL                    
			IF LTRIM(RTRIM(@codarm10)) = 'PIL'
				OR LTRIM(RTRIM(@codarm10)) = 'CSL'
			BEGIN
				EXEC usp_gwc_new_bookin @bookin13
					,@navvia11
					,@codarm10
					,@nrocon13
					,@BOOK_NEW OUTPUT
					,@FLGEMAIL OUTPUT
			END
			ELSE
			BEGIN
				SET @BOOK_NEW = @bookin13
			END

			--|                    
			INSERT INTO EDBOOKIN13 (
				navvia11
				,codusu17
				,fecusu00
				,genbkg13
				,bookin13
				,nrocon13
				,codbolH03
				,codarm10
				,codemc12
				,codtip55
				,nomemb13
				,ruccli13
				,codpue02
				,codbol03
				,codtam09
				,codtip05
				,codpue13
				,conten13
				,status13
				,flgmer13
				,flgcon13
				,flgtbk13
				,desfin13
				,codpro27
				,cod_producto
				,cod_subproducto
				,rucage19
				,codimo00
				,consfc13
				,numcon13
				,sucursal
				,pesmer13
				,bkgmad13
				,tracasa
				,Tar_Apli
				,rucopl13
				,EmbPaita
				,ruccol13
				,codTipReefer
				,
				--<2015-10-17 - VSB - INI>                      
				--codlin10,Observacion)                      
				codlin10
				,Observacion
				,bkgcom13
				,flgIQBF
				,flgEnviarN4
				,flgRoleoN4
				)
			--<2015-10-17 - VSB - FIN>                      
			VALUES
				--(@navvia11,USER_NAME(),GETDATE(),@genbkg13,@bookin13,@nrocon13,@codbolH03,@codarm10,@codemc12,@codtip55,                     
				(
				@navvia11
				,USER_NAME()
				,GETDATE()
				,@genbkg13
				,@BOOK_NEW
				,@nrocon13
				,@codbolH03
				,@codarm10
				,@codemc12
				,@codtip55
				,@nomemb13
				,@ruccli13
				,@codpue02
				,@codbol03
				,@codtam09
				,@codtip05
				,@codpue13
				,@conten13
				,@status13
				,@flgmer13
				,@flgcon13
				,@flgtbk13
				,@desfin13
				,@codpro27
				,@cod_producto
				,@cod_subproducto
				,@rucage19
				,@codimo00
				,@consfc13
				,@numcon13
				,@sucursal
				,@pesmer13
				,@bkgmad13
				,@tracasa
				,@Tar_Apli
				,@rucopl13
				,LTRIM(RTRIM(@EmbPaita))
				,@ruccol13
				,@codTipReefer
				,
				--<2015-10-17 - VSB - INI>                      
				@codlin10
				,@observa
				,@nrocon13
				,@IQBF
				,'2'
				,'0'
				)
				--<2015-10-17 - VSB - FIN>                      
		END TRY

		BEGIN CATCH
			SET @codigoret = 900
			SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()

			RETURN
		END CATCH

		--||          
		IF @codigoret <> 0
		BEGIN
			RETURN
		END
	END
	ELSE
	BEGIN
		BEGIN TRY
			--<2015-10-19 - FMCR - INI>                      
			--|                    
			IF LTRIM(RTRIM(@codarm10)) = 'PIL'
				OR LTRIM(RTRIM(@codarm10)) = 'CSL'
			BEGIN
				UPDATE EDBOOKIN13
				SET navvia11 = isnull(@navvia11, navvia11)
					,codusu17 = USER_NAME()
					,fecusu00 = GETDATE()
					,
					--bookin13        = isnull(@bookin13,bookin13),                           
					nrocon13 = isnull(@nrocon13, nrocon13)
					,codbolH03 = isnull(@codbolH03, codbolH03)
					,codarm10 = isnull(@codarm10, codarm10)
					,codemc12 = isnull(@codemc12, codemc12)
					,nomemb13 = isnull(@nomemb13, nomemb13)
					,ruccli13 = isnull(@ruccli13, ruccli13)
					,codpue02 = isnull(@codpue02, codpue02)
					,codbol03 = isnull(@codbol03, codbol03)
					,codtam09 = isnull(@codtam09, codtam09)
					,codtip05 = isnull(@codtip05, codtip05)
					,codpue13 = isnull(@codpue13, codpue13)
					,conten13 = isnull(@conten13, conten13)
					,flgmer13 = isnull(@flgmer13, flgmer13)
					,flgcon13 = isnull(@flgcon13, flgcon13)
					,desfin13 = isnull(@desfin13, desfin13)
					,codpro27 = isnull(@codpro27, codpro27)
					,cod_producto = isnull(@cod_producto, cod_producto)
					,cod_subproducto = isnull(@cod_subproducto, cod_subproducto)
					,rucage19 = isnull(@rucage19, rucage19)
					,codimo00 = isnull(@codimo00, codimo00)
					,consfc13 = isnull(@consfc13, consfc13)
					,numcon13 = isnull(@numcon13, numcon13)
					,sucursal = isnull(@sucursal, sucursal)
					,pesmer13 = isnull(@pesmer13, pesmer13)
					,bkgmad13 = isnull(@bkgmad13, bkgmad13)
					,tracasa = isnull(@tracasa, tracasa)
					,Tar_Apli = isnull(@Tar_Apli, Tar_Apli)
					,rucopl13 = isnull(@rucopl13, rucopl13)
					,EmbPaita = isnull(LTRIM(RTRIM(@EmbPaita)), EmbPaita)
					,ruccol13 = isnull(@ruccol13, ruccol13)
					,codTipReefer = isnull(@codTipReefer, codTipReefer)
					,codlin10 = isnull(@codlin10, codlin10)
					,Observacion = isnull(@observa, Observacion)
					,flgIQBF = ISNULL(@IQBF, '0')
				WHERE bkgcom13 = @nrocon13
					AND navvia11 = @navvia11
					AND codarm10 = @codarm10
					--and bookin13 = @bookin13                      
					--and codemc12 = @codemc12                    
			END
			ELSE
			BEGIN
				UPDATE EDBOOKIN13
				SET navvia11 = isnull(@navvia11, navvia11)
					,codusu17 = USER_NAME()
					,fecusu00 = GETDATE()
					,bookin13 = isnull(@bookin13, bookin13)
					,nrocon13 = isnull(@nrocon13, nrocon13)
					,codbolH03 = isnull(@codbolH03, codbolH03)
					,codarm10 = isnull(@codarm10, codarm10)
					,codemc12 = isnull(@codemc12, codemc12)
					,nomemb13 = isnull(@nomemb13, nomemb13)
					,ruccli13 = isnull(@ruccli13, ruccli13)
					,codpue02 = isnull(@codpue02, codpue02)
					,codbol03 = isnull(@codbol03, codbol03)
					,codtam09 = isnull(@codtam09, codtam09)
					,codtip05 = isnull(@codtip05, codtip05)
					,codpue13 = isnull(@codpue13, codpue13)
					,conten13 = isnull(@conten13, conten13)
					,flgmer13 = isnull(@flgmer13, flgmer13)
					,flgcon13 = isnull(@flgcon13, flgcon13)
					,desfin13 = isnull(@desfin13, desfin13)
					,codpro27 = isnull(@codpro27, codpro27)
					,cod_producto = isnull(@cod_producto, cod_producto)
					,cod_subproducto = isnull(@cod_subproducto, cod_subproducto)
					,rucage19 = isnull(@rucage19, rucage19)
					,codimo00 = isnull(@codimo00, codimo00)
					,consfc13 = isnull(@consfc13, consfc13)
					,numcon13 = isnull(@numcon13, numcon13)
					,sucursal = isnull(@sucursal, sucursal)
					,pesmer13 = isnull(@pesmer13, pesmer13)
					,bkgmad13 = isnull(@bkgmad13, bkgmad13)
					,tracasa = isnull(@tracasa, tracasa)
					,Tar_Apli = isnull(@Tar_Apli, Tar_Apli)
					,rucopl13 = isnull(@rucopl13, rucopl13)
					,EmbPaita = isnull(LTRIM(RTRIM(@EmbPaita)), EmbPaita)
					,ruccol13 = isnull(@ruccol13, ruccol13)
					,codTipReefer = isnull(@codTipReefer, codTipReefer)
					,codlin10 = isnull(@codlin10, codlin10)
					,Observacion = isnull(@observa, Observacion)
					,flgIQBF = ISNULL(@IQBF, '0')
				WHERE bkgcom13 = @nrocon13
					AND navvia11 = @navvia11
					AND codarm10 = @codarm10
					AND bookin13 = @bookin13
					AND codemc12 = @codemc12
			END
					--|                    
		END TRY

		BEGIN CATCH
			SET @codigoret = 900
			SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()

			RETURN
		END CATCH
			--SET @codigoret = 818                      
			--SET @resultado = 'WS_EMBARQUE_ERROR_BOOKING_EXISTS: YOU ARE TRYING TO INSERT A BOOKING THAT ALREADY EXIST'                      
			--<2015-10-19 - FMCR - FIN>                      
	END

	--|ENVIO DE CORREO AUTOMATICO                    
	IF @FLGEMAIL = '1'
	BEGIN
		EXEC USP_SEND_BOOKIN_GWC @BOOK_NEW
			,@nrocon13
			,@nave
			,@viaje
			,@codarm10
	END

	--|                    
	SET NOCOUNT OFF
	SET @resultado = @cabecera + @genbkg13 + @fecllega
	SET NOCOUNT OFF
END

RETURN
GO

/*    
Descripcion: Stored Procedures Para Obtener contenedores vacios que seran transmitidos a N4
Fecha: 07-03-2019    
Autor: Franklin Milla    
*/
create PROCEDURE sp_IntN4_Embarque_ObtenerContenedoresVaciosParaN4
@Genbkg varchar(6)
as
begin
	/*Incializando Variables de Salida*/
	set @Genbkg = LTRIM(rtrim(@Genbkg))
	/***********************************/

	declare @Contenedores varchar(5000)
	,@Contenedorescancelados varchar(5000)
	,@icont int
	,@icont_tot int
	,@ctr varchar(11)

	set @Contenedores = ''
	set @Contenedorescancelados = ''
	set @icont = 1

	select a.codcon04,
	identity(int,1,1) as ID
		INTO #Contenedores
	from ERCONASI17 a (nolock) 
	where a.genbkg13 = @Genbkg
	and isnull(a.UnitFacilityVisitGkey, '') = ''
	and isnull(a.flgenv17, '') <> '2'

	select @icont_tot = count(*) from #Contenedores

	while @icont <= @icont_tot
	begin
		select @ctr = codcon04
		from #Contenedores
		where ID = @icont

		if @Contenedores = '' 
		begin	
			set @Contenedores = @Contenedores + @ctr
		end
		else
		begin
			set @Contenedores = @Contenedores + ';' + @ctr
		end
		
		set @icont = @icont + 1
	end

	--|Contenedores Cancelados
	if exists(	select a.genbkg13
				from ERCONASI17 a (nolock) 
				where a.genbkg13 = @Genbkg
				and isnull(a.UnitFacilityVisitGkey, '') <> ''
				and isnull(a.flgenv17, '') = '2'
				 )
	begin
		set @icont = 1

		select a.codcon04,
		identity(int,1,1) as ID
			INTO #ContenedoresCancelados
		from ERCONASI17 a (nolock) 
		where a.genbkg13 = @Genbkg
		and isnull(a.UnitFacilityVisitGkey, '') <> ''
		and isnull(a.flgenv17, '') = '2'

		select @icont_tot = count(*) from #ContenedoresCancelados

		while @icont <= @icont_tot
		begin
			select @ctr = codcon04
			from #ContenedoresCancelados
			where ID = @icont

			if @Contenedorescancelados = '' 
			begin	
				set @Contenedorescancelados = @Contenedorescancelados + @ctr
			end
			else
			begin
				set @Contenedorescancelados = @Contenedorescancelados + ';' + @ctr
			end

			set @icont = @icont + 1
		end
	end
	--|

	declare @GkeyBooking varchar(500)
	, @VesselVisit varchar(15)
	, @Booking varchar(35)

	select 
	@GkeyBooking = a.UnitFacilityVisitGkey
	, @VesselVisit = b.VESSELVISITID
	, @Booking = a.bkgcom13
	from EDBOOKIN13 a (nolock)
	inner join DDCABMAN11 b (nolock) on a.navvia11 = b.navvia11
	where a.genbkg13 = @Genbkg

	if ltrim(rtrim(@Contenedorescancelados)) = ''
	begin
		select case when @Contenedores = '' then '0'
										    else '1'
										    end as Resul
		, @GkeyBooking as GkeyBooking
		, @VesselVisit as VesselVisit
		, @Booking as Booking
		, ltrim(rtrim(@Contenedores)) as lstUnit
		, '1' as Accion
	end
	else
	begin
		select '1' as Resul
		, @GkeyBooking as GkeyBooking
		, @VesselVisit as VesselVisit
		, @Booking as Booking
		, ltrim(rtrim(@Contenedores)) as lstUnit
		, '1' as Accion

		union

		select '1' as Resul
		, @GkeyBooking as GkeyBooking
		, @VesselVisit as VesselVisit
		, @Booking as Booking
		, ltrim(rtrim(@Contenedorescancelados)) as lstUnit
		, '3' as Accion
	end

end

GO
grant all on sp_IntN4_Embarque_ObtenerContenedoresVaciosParaN4 to public

GO

/*    
Descripcion: Stored Procedures Para Actualizar El GkeyUnitFacility Visit
Fecha: 07-03-2019    
Autor: Franklin Milla    
*/
create PROCEDURE sp_IntN4_Embarque_UpdateContenedoresVaciosParaN4
@Genbkg varchar(6)
,@Contenedor varchar(11)
,@UnitFacilityVisitGkey varchar(500)
,@Tipo varchar(1)
as
begin
	if @Tipo = '3'
	begin
		update ERCONASI17
			set UnitFacilityVisitGkey = ''
		where genbkg13 = @Genbkg and codcon04 = @Contenedor and flgenv17 = '2'
	end
	else
	begin
		update ERCONASI17
			set UnitFacilityVisitGkey = @UnitFacilityVisitGkey
		where genbkg13 = @Genbkg and codcon04 = @Contenedor
		and isnull(flgenv17, '') <> '2'
	end
end

go 
grant all on sp_IntN4_Embarque_UpdateContenedoresVaciosParaN4 to public
GO

/*    
Descripcion: Stored Procedure Para Validar datos de Operativa antes de realizar la Finalizacion de llenado de un contenedor 
Fecha: 15-03-2019    
Autor: Franklin Milla    
*/
ALTER procedure sp_IntN4_Embarque_FinalizacionLlenado_Validaciones
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@Contenedor varchar(11)
,@Gkeybooking varchar(500)
,@Sucursal varchar(3) --VIL:Villegas, VEN:Ventanilla, PAI:Paita
,@UnitFacilityVisitGkey varchar(500)
,@VesselVisit varchar(150)

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	set @IdResul = '0'
	set @DesResul = 'OK'
	
	set @Contenedor = LTRIM(rtrim(@Contenedor))
	set @Gkeybooking = LTRIM(rtrim(@Gkeybooking))
	set @UnitFacilityVisitGkey = LTRIM(rtrim(@UnitFacilityVisitGkey))
	/*********************************/

	declare @Navvia varchar(6)
	,@nroaut varchar(8)
	,@ICOUNT int
	,@NROTKT varchar(8)
	,@PESONETOMERC DECIMAL(12, 3)

	if not exists(select navvia11 from ddcabman11 (nolock) where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit and tipope11 = 'E')
	begin
		set @IdResul = '-1'
		set @DesResul = 'VesselVisit no registrado en el Maestro de Nave-Viaje'
		return;
	end
	else
	begin
		select @Navvia = navvia11
		from DDCABMAN11 (nolock)
		where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit
		and tipope11 = 'E'
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Contenedor no se encuentra Asignado a un Booking en Embarque'
		return;
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
					and B.flgenv17 <> '2'
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Contenedor se encuentra cancelado en sistema Embarque'
		return;
	end

	if exists(
				select CONTENEDOR
				from TERMLLENADN4 (nolock)
				where CONTENEDOR = @Contenedor
				and NAVVIA = @Navvia
			 )
	begin
		set @IdResul = '-1'
		set @DesResul = 'Ya se registro la Finalización de Llenado para ese Contenedor'
		return;
	end

	if not exists(
					select A.genbkg13
					from EDBOOKIN13 A with (nolock)
					inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
					inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
														  and C.codcon14 = B.codcon04
					where B.codcon04 = @Contenedor
					and A.navvia11 = @Navvia
				)
	begin
		set @IdResul = '-1'
		set @DesResul = 'El Contenedor no cuenta con registro de Autorizaciones de Ingreso'
		return;
	end

	set @nroaut = ''

	select @nroaut = C.nroaut14
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	left join EDLLENAD16 D with (nolock) on D.nroaut14 = C.nroaut14
										 and D.codcon04 = C.codcon14
	where D.nroaut14 IS NULL
		and A.navvia11 = @Navvia
		and B.codcon04 = @Contenedor

	if LTRIM(RTRIM(ISNULL(@nroaut, ''))) <> ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'El Nro. de autorización: ' + @nroaut + ' asociado al contenedor no cuenta con Llenado'
		return;
	end
	
	select @ICOUNT = COUNT(*)
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	inner join DDTICKET18 D WITH (NOLOCK) on C.nroaut14 = D.nroaut14
										  and D.codcon04 = C.codcon14
	where D.fecsal18 IS NOT NULL
		and A.navvia11 = @Navvia
		and C.codcon14 = @Contenedor

	IF @ICOUNT = 0
	BEGIN
		set @IdResul = '-1'
		set @DesResul = 'El Contenedor: ' + @Contenedor + ' No cuenta con Registro de Ticket de Salida'
		return;
	END

	select C.nroaut14
		,C.codcon14
		,IDENTITY(INT, 1, 1) AS ID
	into #TEMPORAL
	from EDBOOKIN13 A with (nolock)
	inner join ERCONASI17 B with (nolock) on A.genbkg13 = B.genbkg13
	inner join EDAUTING14 C with (nolock) on C.genbkg13 = B.genbkg13
										  and C.codcon14 = B.codcon04
	where A.navvia11 = @Navvia
		and C.codcon14 = @Contenedor

	declare @C INT
		,@CC INT

	set @C = 1

	select @CC = COUNT(*)
	from #TEMPORAL

	while @C <= @CC
	begin
		select @NROAUT = nroaut14
		from #TEMPORAL
		where ID = @C

		select @ICOUNT = COUNT(*)
		from DDTICKET18 with (nolock)
		where nroaut14 = @NROAUT
			AND fecsal18 is not null

		if @ICOUNT = 0
		begin
			select @NROTKT = nrotkt18
			from DDTICKET18 with (nolock)
			where nroaut14 = @NROAUT
				and fecsal18 IS NULL
			
			set @IdResul = '-1'
			set @DesResul = 'El Ticket: ' + @NROTKT + ' No cuenta con Fecha de Salida (No existe peso Neto registrado)'
			return;
		end

		set @C = @C + 1
	end

	drop table #TEMPORAL

	select @PESONETOMERC = SUM(B.pesnet18)
	from DDTICKET18 B with (nolock)
	where B.codcon04 = @Contenedor
		AND B.navvia11 = @Navvia
		AND B.fecsal18 IS NOT NULL
	group by B.navvia11

	set @DesResul = ltrim(rtrim(cast(@PESONETOMERC as varchar(16))))
end

GO
grant all on sp_IntN4_Embarque_FinalizacionLlenado_Validaciones to public
GO

/*    
Descripcion: Stored Procedure Para Registrar datos de la Finalizacion de llenado de un contenedor 
Fecha: 17-03-2019    
Autor: Franklin Milla    
*/
alter procedure sp_IntN4_Embarque_FinalizacionLlenado_Registro
@GkeyUnitFacilityVisit varchar(500)
,@Gkey_Booking varchar(500)
,@Linea varchar(5)
,@VesselVisit varchar(15)
,@Ctr varchar(11)
,@Precinto varchar(500)
,@PesoNeto decimal(15,3)
,@Sucursal varchar(3)
,@AccionSQL varchar(1) --1: INSERT, 2: UPDATE

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	set @IdResul = '0'
	set @DesResul = 'OK'
	
	set @GkeyUnitFacilityVisit = LTRIM(rtrim(@GkeyUnitFacilityVisit))
	set @Gkey_Booking = LTRIM(rtrim(@Gkey_Booking))
	set @VesselVisit = LTRIM(rtrim(@VesselVisit))
	set @Linea = ltrim(rtrim(@Linea))
	set @Precinto=ltrim(Rtrim(@Precinto))
	/*********************************/

	declare @navvia varchar(6)
	,@codLinea varchar(3)
	,@genbkg13 varchar(6)

	select @navvia = navvia11
	from DDCABMAN11(nolock)
	where tipope11 = 'E'
	and VESSELVISITID = @VesselVisit

	select @codLinea = codarm10
	from DQARMADO10 (nolock)
	where codarm10_N4 = @Linea

	if isnull(@codLinea , '') = ''
	begin
		set @codLinea= 'XXX'
	end

	select @genbkg13 =genbkg13
	from EDBOOKIN13 (nolock)
	where ltrim(rtrim(UnitFacilityVisitGkey)) = @Gkey_Booking

	exec sp_IntN4_Embarque_RegistrarCtrEmitidoN4 @GkeyUnitFacilityVisit, @Gkey_Booking, @codLinea,
	@navvia, @VesselVisit, @genbkg13, @Ctr, @Precinto, 'C', @PesoNeto, 'IntN4', @Sucursal, @AccionSQL

end

GO
grant all on sp_IntN4_Embarque_FinalizacionLlenado_Registro to public

GO
create procedure sp_IntN4_Embarque_ValidarTipoCtrxItem
@Contenedor varchar(11)
,@Linea varchar(3)
,@GkeyBooking varchar(500)
as
begin
	declare @tipo varchar(2)
	,@Tamanyo varchar(2)
	,@Resultado varchar(500)

	set @Resultado = ''

	select @tipo = codtip05
	,@Tamanyo = codtam09
	from EDCONTEN04 (nolock)
	where codcon04 = @Contenedor
	and codarm10 = @Linea

	if not exists(
					select GkeyBooking
					from EDITEMBOOKIN13 (nolock)
					where ltrim(rtrim(GkeyBooking)) = ltrim(rtrim(@GkeyBooking))
					and codtip05 = @tipo
					and codtam09 = @Tamanyo
				)
	begin
		set @Resultado = 'El Tipo/Tamaño del Contenedor ' + @Contenedor + ' es distinto a los Item´s registrados'	
		select @Resultado as Resultado
		return;
	end

	select @Resultado as Resultado
end

GO
grant all on sp_IntN4_Embarque_ValidarTipoCtrxItem to public
GO

/*    
Descripcion: Stored Procedure Para Registrar datos de la Finalizacion de llenado de un contenedor 
Fecha: 17-03-2019    
Autor: Franklin Milla    
*/
ALTER procedure sp_IntN4_Embarque_FinalizacionLlenado_Registro
@GkeyUnitFacilityVisit varchar(500)
,@Gkey_Booking varchar(500)
,@Linea varchar(5)
,@VesselVisit varchar(15)
,@Ctr varchar(11)
,@Precinto varchar(500)
,@PesoNeto decimal(15,3)
,@Sucursal varchar(3)
,@AccionSQL varchar(1) --1: INSERT, 2: UPDATE

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	set @IdResul = '0'
	set @DesResul = 'OK'
	
	set @GkeyUnitFacilityVisit = LTRIM(rtrim(@GkeyUnitFacilityVisit))
	set @Gkey_Booking = LTRIM(rtrim(@Gkey_Booking))
	set @VesselVisit = LTRIM(rtrim(@VesselVisit))
	set @Linea = ltrim(rtrim(@Linea))
	set @Precinto=ltrim(Rtrim(@Precinto))
	/*********************************/

	declare @navvia varchar(6)
	,@codLinea varchar(3)
	,@genbkg13 varchar(6)

	select @navvia = navvia11
	from DDCABMAN11(nolock)
	where tipope11 = 'E'
	and VESSELVISITID = @VesselVisit

	select @codLinea = codarm10
	from DQARMADO10 (nolock)
	where codarm10_N4 = @Linea

	if isnull(@codLinea , '') = ''
	begin
		set @codLinea= 'XXX'
	end

	select @genbkg13 =genbkg13
	from EDBOOKIN13 (nolock)
	where ltrim(rtrim(UnitFacilityVisitGkey)) = @Gkey_Booking

	exec sp_IntN4_Embarque_RegistrarCtrEmitidoN4 @GkeyUnitFacilityVisit, @Gkey_Booking, @codLinea,
	@navvia, @VesselVisit, @genbkg13, @Ctr, @Precinto, 'C', @PesoNeto, 'IntN4', @Sucursal, @AccionSQL

	update EDLLENAD16
		set nropre16 = @Precinto
		, preadu16 = @Precinto
	where navvia11 = @navvia
	and codcon04 = @Ctr

end

GO
grant all on sp_IntN4_Embarque_FinalizacionLlenado_Registro to public
GO

USE [Descarga]
GO
/****** Object:  StoredProcedure [dbo].[usp_Cooperation_ValidarDeudaPendiente]    Script Date: 25/03/2019 10:08:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Cooperation_ValidarDeudaPendiente] @sNAMECLIENTE VARCHAR(80)     

,@DEUVEN CHAR(2)     

,@TICKET CHAR(2) = NULL     

AS     

BEGIN     

DECLARE @RUC VARCHAR(11)     

     

SET @RUC = ''     

     

SELECT @RUC = CONTRIBUY     

FROM AACLIENTESAA WITH (NOLOCK)     

WHERE LTRIM(RTRIM(NOMBRE)) LIKE '%' + LTRIM(RTRIM(@sNAMECLIENTE)) + '%'     

      

DECLARE @USERID AS VARCHAR(20)     

DECLARE @AUTORIZACION AS CHAR(2)     

     

SELECT @USERID = user_name()     

     

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

IF EXISTS (     

   SELECT *     

   FROM ddautdoc16     

   WHERE contribuy = @RUC     

    AND convert(CHAR(8), FECINI16, 112) = convert(CHAR(8), getdate(), 112)     

   )     

  SELECT @AUTORIZACION = 'SI'     

ELSE     

  SELECT @AUTORIZACION = 'NO'     

     

--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.       

--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion       

--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el        

--          cliente es atendido por primera vez en un dia especifico.       

--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente       

--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.       

--===========================================================================       

--EXEC NPT9_datawarehouse..SIG_DEUDA_PENDIENTE_CLIENTE @RUC   

  EXEC NPT9_datawarehouse..SIG_DEUDA_PENDIENTE_CLIENTE @RUC     

  ,@DEUVEN     

  ,'TAIM'     

  ,@USERID     

  ,@AUTORIZACION     

  ,@TICKET     

     

--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.       

--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia       

--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.       

--===========================================================================       

IF @DEUVEN = 'NO'     

--EXEC NPT9_datawarehouse..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC     

EXEC NPT9_datawarehouse..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC    

   ,'NO'     

   ----                                                                                                                                                                                                                                                         

   

        

   ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

   

---     

   /*creo el procedure en la importacion desde el Neptunia9*/     

END  
GO

USE [Descarga]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEND_MAIL_MULTIPLE]    Script Date: 25/03/2019 10:13:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SEND_MAIL_MULTIPLE]           
    
@viFrom varchar(200),           
    
@viFormName varchar(200),           
    
@viTo varchar(250),           
    
@viCC varchar(250),           
    
@viPrioridad varchar(15),           
    
@viSubject varchar(400),           
    
@viBody varchar(max),           
    
@viRuta varchar(5000),           
    
@viServer varchar(150)           
    
AS           
    
BEGIN           
    
            
    
--|SETEO DE VARIABLES           
    
SET @viFrom = LTRIM(RTRIM(@viFrom))           
    
SET @viFormName = LTRIM(RTRIM(@viFormName))           
    
SET @viTo = LTRIM(RTRIM(@viTo))           
    
SET @viCC = LTRIM(RTRIM(@viCC))           
    
SET @viPrioridad = LTRIM(RTRIM(@viPrioridad))           
    
SET @viSubject = LTRIM(RTRIM(@viSubject))           
    
SET @viBody = LTRIM(RTRIM(@viBody))           
    
SET @viRuta = LTRIM(RTRIM(@viRuta))           
    
SET @viServer = LTRIM(RTRIM(@viServer))           
    
--|           
    
            
    
declare @EX int           
    
EXEC @EX = [sp3tda-dbsql01].master.dbo.xp_smtp_sendmail                                                                 
    
   @FROM = @viFrom                        
    
  ,@FROM_NAME = @viFormName                       
    
  ,@TO = @viTo                        
    
  ,@CC = @viCC                        
    
  ,@priority = @viPrioridad                       
    
  ,@subject = @viSubject                         
    
  ,@message = @viBody                      
    
  ,@messagefile = N''                         
    
  ,@type = N'text/plain' --plain                         
    
  ,@attachment = @viRuta                      
    
  ,@attachments = N''                         
    
  ,@codepage = 0                         
    
  ,@server = 'correo.neptunia.com.pe'           
    
             
    
END   
GO

USE [Descarga]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Consulta_Valores_Adicionales_Billing]    Script Date: 25/03/2019 10:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER FUNCTION [dbo].[fn_Consulta_Valores_Adicionales_Billing](@UnitFacilityVisitGkey VARCHAR(500))RETURNS VARCHAR(2000)          
        
AS             
        
BEGIN           
        
DECLARE @ORD_FLAGREGISTRO AS VARCHAR(100)           
        
DECLARE @ORD_CODAGENCIA AS VARCHAR(11)           
        
DECLARE @ORD_CLIENTE AS VARCHAR(11)           
        
DECLARE @CODPRO27 AS VARCHAR(200)           
        
DECLARE @CONTEN13 AS VARCHAR(200)           
        
DECLARE @RUCCLI13 AS VARCHAR(11)           
        
DECLARE @RUCOPL13 AS VARCHAR(11)           
        
DECLARE @ORD_CLIENTEFACT AS VARCHAR(11)           
        
DECLARE @ORD_OBSERVACION AS VARCHAR(200)           
        
DECLARE @CODPLANTA AS VARCHAR(200)           
        
DECLARE @ORD_CODIGO AS VARCHAR(10)           
        
           
        
DECLARE @RESULT AS VARCHAR(2000)        
      
DECLARE @Nombre_Zona AS VARCHAR(250)         
DECLARE @LLENADO_EN_NPT AS VARCHAR(10)         
DECLARE @LINEA_TKT AS VARCHAR(10)         
DECLARE @LINEA_GRUPO AS VARCHAR(10)         
DECLARE @VACIO_NEPT AS VARCHAR(10)  

DECLARE @IQBF AS VARCHAR(2)     
DECLARE @PTO_DEST_FINAL AS VARCHAR(10)     
             
SELECT            
        
  @ORD_FLAGREGISTRO = ISNULL(CASE WHEN A.ORD_FLAGREGISTRO = '1' THEN '1 - Via Neptunia' WHEN A.ORD_FLAGREGISTRO = '2' THEN '2 - Via Otros Terminales' ELSE '3 - Via Directa' END,''),            
        
  @ORD_CODAGENCIA = ISNULL(A.ORD_CODAGENCIA,''),           
        
  @ORD_CLIENTE = ISNULL(A.ORD_CLIENTE,''),           
        
  @CODPRO27 = ISNULL((select COD_SUBPRODUCTO +' - '+ DES_SUBPRODUCTO from SUBPRODUCTO where COD_PRODUCTO = b.cod_producto AND COD_SUBPRODUCTO = B.cod_subproducto),''),            
        
  @CONTEN13 = RTRIM(ISNULL(B.CONTEN13,'')),           
        
  @RUCCLI13 = ISNULL(B.RUCCLI13,''),           
        
  @RUCOPL13 = ISNULL(B.RUCOPL13,''),           
        
  @ORD_CLIENTEFACT = ISNULL(A.ORD_CLIENTEFACT,''),           
        
  @ORD_OBSERVACION = REPLACE(REPLACE(ISNULL(A.ORD_OBSERVACION,''),',',''),':',''),           
        
  @CODPLANTA = ISNULL(A.CODPLANTA,''),   
  
  @CODPLANTA =  ISNULL((SELECT CONVERT(varchar(10), codplanta) + ' - ' + descripcion FROM TERMINAL.DBO.ssi_planta WHERE codplanta = A.CODPLANTA),''),        
        
  @ORD_CODIGO = ISNULL(A.ORD_CODIGO,''),        
        
 @Nombre_Zona =  ISNULL((SELECT TOP 1 Replace(Replace(C.Nombre_Zona, '<', 'MENOR'),'>','MAYOR') 
							FROM TERMINAL.DBO.SSI_PLANIFICA_TRANSPORTE PT       
						 JOIN TERMINAL.DBO.CAMIONAJE_CALLE_ZONA C ON C.Codigo_Zona = PT.ORD_ZONA         
							WHERE PT.ORD_CODIGO = A.ORD_CODIGO),''),      
  @LLENADO_EN_NPT = ISNULL(CASE WHEN B.codbolH03 = 'LC' THEN 'SI' ELSE 'NO' END,''),      
  @LINEA_TKT = ISNULL(B.CODLIN10,''),      
  @LINEA_GRUPO = ISNULL((SELECT CODGRU10 FROM DQARMADO10 WHERE codarm10 = B.codarm10),''),      
  @VACIO_NEPT =  ISNULL(CASE WHEN (SELECT [rb_int_identificador_terminal] FROM [dbneptunia].[contenedor].[tbl_reserva_booking] WHERE [rb_str_numero_booking] = B.bkgcom13) IS NOT NULL THEN 'SI' ELSE 'NO' END,''),
  @IQBF = ISNULL(CASE WHEN B.flgIQBF = '1' THEN 'SI' ELSE 'NO' END,''),      
  @PTO_DEST_FINAL=ISNULL(B.codpue13,'')  
FROM terminal.dbo.SSI_ORDEN A RIGHT JOIN EDBOOKIN13 B ON A.ORD_NUMDOCUMENTO = B.bkgcom13           
        
  WHERE unitFacilityVisitGkey = @UnitFacilityVisitGkey and ISNULL(b.flgEnviarN4,'0') = 1           
        
        
SET @RESULT =            
        
    'ORD_FLAGREGISTRO:'+@ORD_FLAGREGISTRO+ ','+           
        
    'ORD_CODAGENCIA:'+@ORD_CODAGENCIA+ ','+           
        
    'ORD_CLIENTE:'+@ORD_CLIENTE+ ','+           
        
    'CODPRO27:'+@CODPRO27+ ','+           
        
    'CONTEN13:'+@CONTEN13+ ','+           
        
    'RUCCLI13:'+@RUCCLI13+ ','+           
        
    'RUCOPL13:'+@RUCOPL13+ ','+           
        
    'ORD_CLIENTEFACT:'+@ORD_CLIENTEFACT+ ','+           
        
    'ORD_OBSERVACION:'+@ORD_OBSERVACION+ ','+           
        
    'CODPLANTA:'+@CODPLANTA+ ','+           
        
    'ORD_CODIGO:'+@ORD_CODIGO+ ','+           
        
    'NOMBRE_ZONA:'+@Nombre_Zona+ ','+          
	'LLENADO_EN_NPT:'+@LLENADO_EN_NPT+ ','+          
	'LINEA_TKT:'+@LINEA_TKT+ ','+          
	'LINEA_GRUPO:'+@LINEA_GRUPO+ ','+          
	'VACIO_NEPT:'+@VACIO_NEPT+ ','+
	'IQBF:'+@IQBF+ ','+  
	'PTO_DEST_FINAL:'+@PTO_DEST_FINAL       
        
--SELECT @RESULT AS RESULT;           
RETURN  @RESULT    
           
END 
GO

ALTER PROCEDURE [dbo].[USP_PERMISOS_BOOKING] @USER VARCHAR(35)
	,@OPCION VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET @USER = LTRIM(RTRIM(@USER))

	DECLARE @MENSAJE VARCHAR(250)

	SET @MENSAJE = ''

	IF @OPCION = 5
	BEGIN
		IF EXISTS (
				SELECT *
				FROM Terminal..DDUSER_PERF_SIST
				WHERE codusu17 = @USER
					AND perfil = 'ACTIVA TESORERIA'
				)
		BEGIN
			SET @MENSAJE = ''
		END
		ELSE
		BEGIN
			SET @MENSAJE = 'El usuario: ' + @USER + ' no cuenta con permisos para esta opción (ACTIVA TESORERIA)'
		END

		SELECT @MENSAJE AS 'Mensaje'

		RETURN
	END

	IF @OPCION = 6
	BEGIN
		IF EXISTS (
				SELECT *
				FROM Terminal..DDUSER_PERF_SIST
				WHERE codusu17 = @USER
					AND perfil = 'HABILITAR SAL ALM'
				)
		BEGIN
			SET @MENSAJE = ''
		END
		ELSE
		BEGIN
			SET @MENSAJE = 'El usuario: ' + @USER + ' no cuenta con permisos para esta opción (HABILITAR SAL ALM)'
		END

		SELECT @MENSAJE AS 'Mensaje'

		RETURN
	END

	IF EXISTS (
			SELECT *
			FROM Terminal..DDUSER_PERF_SIST
			WHERE codusu17 = @USER
				AND perfil = 'REGISTRO BOOKING'
			)
	BEGIN
		SET @MENSAJE = ''
	END
	ELSE
	BEGIN
		SET @MENSAJE = 'El usuario: ' + @USER + ' no cuenta con permisos para esta opción (REGISTRO BOOKING)'
	END

	SELECT @MENSAJE AS 'Mensaje'

	SET NOCOUNT OFF;
END

GO

/*    
Descripcion: Stored Procedures para Replicar Informacion (DDTICKET18, EDAUTING14, EDLLENAD16) y poder realizar RM, RD de contingencia para FCL    
Fecha: 22-03-2019    
Autor: Franklin Milla    
*/
create procedure sp_IntN4_Embarque_GenerarDataGateInOut_RE
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@Booking varchar(35) -- Numero de Booking
,@GkeyBooking varchar(500) --Gkey del Bookinig en N4
,@VesselVisit varchar(15) --ID de Nave-Viaje de N4
,@Contenedor varchar(11) --Nro de Contenedor
,@Sucursal varchar(3) --VIL: Villegas, VEN: Ventanilla, PAI: Paita
,@TaraContenedor decimal(12,3) -- Tara del Contenedor
,@PesoBruto decimal(8,2) -- Peso Bruto
,@PesoTara decimal(8,2) -- Peso Tara
,@PesoNeto decimal(8,2) -- Peso Neto
,@FechaIngreso varchar(15) -- Fecha de Ingreso Gate
,@FechaSalida varchar(15) -- Fecha Salida Gate
,@NroPrecinto varchar(100) --Nro de Precinto

,@IdResul varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	SET @IdResul = '0'
	SET @DesResul = 'OK'
	
	set @CodUsuarioWS = LTRIM(rtrim(@CodUsuarioWS))
	set @PassUsuarioWS = LTRIM(rtrim(@PassUsuarioWS))
	set @Booking = LTRIM(rtrim(@Booking))
	set @VesselVisit = LTRIM(rtrim(@VesselVisit))
	set @GkeyBooking = LTRIM(rtrim(@GkeyBooking))
	set @NroPrecinto = LTRIM(rtrim(@NroPrecinto))
	/***********************************/
	
	/***** Declaracion de Variables *****/
	declare @Navvia varchar(6)
	,@Nroaut varchar(8)
	,@Placa varchar(6)
	,@Genbkg varchar(6)
	,@Codemb varchar(3)
	,@RucAge varchar(11)
	,@Contenido varchar(200)
	,@NombreEmbarcador varchar(100)
	,@RucEmbarcador varchar(13)
	,@SucursalNep varchar(1)

	,@NroTkt varchar(8)
	,@NroTara decimal(5,3)

	,@Pesmer16 decimal(12,6)
	,@CodigoProducto varchar(5)
	,@CodigoSubProducto varchar(5)
	,@MotCambioPrecinto varchar(2)
	,@CodTip varchar(1)
	/***********************************/
	
	/***** Seteo de Variables *****/
	set @Codemb = 'CTR'
	set @MotCambioPrecinto = '00'
	set @Placa = 'INT987'

	if @Sucursal = 'VIL'
	begin
		set @SucursalNep = '3'
	end
	else if @Sucursal = 'VEN'
	begin
		set @SucursalNep = '2'
	end
	else
	begin
		set @SucursalNep = '6'
	end

	set @NroTara = @TaraContenedor / 1000

	set @Pesmer16 = @PesoNeto / 1000
	/***********************************/

	/***** Validaciones *****/
	if not exists(SELECT VALUE FROM terminal..COSETTING (NOLOCK) WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Usuario de conexion N4 incorrecto'
		return;
	end
	
	if not exists(SELECT VALUE FROM terminal..COSETTING (NOLOCK) WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Password de conexion N4 incorrecto'
		return;
	end	
	/*********************/

	select @Navvia = navvia11
	from DDCABMAN11 (nolock)
	where ltrim(rtrim(VESSELVISITID)) = @VesselVisit
	and tipope11 = 'E'

	if isnull(@Navvia, '') = ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'Vessel visit no registrado en el Maestro'
		return;
	end	

	select @Genbkg = genbkg13
	,@RucAge = rucage19
	,@Contenido = ltrim(rtrim(conten13))
	,@NombreEmbarcador = ltrim(rtrim(nomemb13))
	,@RucEmbarcador = codemc12
	,@CodigoProducto = cod_producto
	,@CodigoSubProducto = cod_subproducto
	from EDBOOKIN13 (nolock)
	where ltrim(rtrim(UnitFacilityVisitGkey)) = @GkeyBooking

	if isnull(@Genbkg, '') <> ''
	begin
		select @Genbkg = a.genbkg13
		,@RucAge = a.rucage19
		,@Contenido = ltrim(rtrim(a.conten13))
		,@NombreEmbarcador = ltrim(rtrim(a.nomemb13))
		,@RucEmbarcador = a.codemc12
		,@CodigoProducto = a.cod_producto
		,@CodigoSubProducto = a.cod_subproducto
		from EDBOOKIN13 a (nolock)
		inner join ERCONASI17 b (nolock) on a.genbkg13 = b.genbkg13
		where ltrim(rtrim(a.bkgcom13)) = @Booking
		and a.navvia11 = @Navvia 
		and b.codcon04 = @Contenedor
	end

	if isnull(@Genbkg, '') = ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'Booking no existe en el sistema de Embarque'
		return;
	end

	if not exists(
					select genbkg13
					from ERCONASI17 (nolock)
					where genbkg13 = @Genbkg
					and codcon04 = @Contenedor
				 )
	begin
		set @IdResul = '-1'
		set @DesResul = 'Contenedor no cuenta con asignación en el sistema de Embarque'
		return;
	end

	If SUBSTRING(@RucEmbarcador,1,2) = '20'
	begin
		set @CodTip = 'R'
    end
	else
	begin
       set @CodTip  = 'L'
    end

	--|Registrar Nro Autorización
	UPDATE ECAUTING14
	SET contad00 = contad00 + 1

	SELECT @Nroaut = RIGHT('00000000' + CONVERT(VARCHAR(8), contad00), 8)
	FROM ECAUTING14 (nolock)

	if not exists (
					select nroaut14
					from EDAUTING14 (nolock)
					where codcon14 = @Contenedor
					and navvia11 = @Navvia
				  )
	begin
		insert into edauting14(nroaut14, status14, genbkg13, navvia11, codemb06 ,nropla81,
        codusu17, fecusu00, fecaut14, codage19, conten13 ,nomemb14,
        codemc12, codtip55, codcon14, sucursal, nrogui14, pesgui14, TipoDoc14 ) 
		
		values (@Nroaut, 'P', @Genbkg, @Navvia, @Codemb, @Placa,
		'IntN4', @FechaIngreso, @FechaIngreso, @RucAge, @Contenido, @NombreEmbarcador,
		@RucEmbarcador, @CodTip, @Contenedor, @SucursalNep, '', 0, '0')         
	end
	--|

	--|Registrar Ticket de Ingreso
	UPDATE DCTICKET18
	SET contad00 = contad00 + 1

	SELECT @NroTkt = RIGHT('00000000' + CONVERT(VARCHAR(8), CONTAD00), 8)
	FROM DCTICKET18

	if not exists (
					select nrotkt18
					from DDTICKET18 (nolock)
					where codcon04 = @Contenedor
					and navvia11 = @Navvia
				  )
	begin
		insert into DDTICKET18 (NROTKT18, NROPLA18, nrotar18, OBSERV18, STATUS18, FECING18, fecsal18, TIPOPE18, NAVVIA11, 
		PESBRT18, PESTAR18, PESNET18, NROAUT14, nrosec18, codusu17, fecusu00, codemb06, buling18, traseg18, flgtransito18, sucursal)

		values(@NroTkt, @Placa, @NroTara, null, 'S', @FechaIngreso, @FechaSalida, 'E', @Navvia,
		@PesoBruto, @PesoTara, @PesoNeto, @Nroaut, '001', 'IntN4', @FechaIngreso, @Codemb, 1, '0', '0', '3')
	end
	--|

	--|Registrar Llenado
	if not exists (
					select nroaut14
					from edllenad16 (nolock)
					where codcon04 = @Contenedor
					and navvia11 = @Navvia
				  )
	begin
		insert into edllenad16 (nroaut14, codcon04, nrobul16, flglln16, observ16, nroitm16, codusu17, fecusu00,
        feclln16, pesmer16, genbkg13, codpro27, codemb06, navvia11, marcas16, flgpro16,
        flgenv16, flgemb16, nropre16, veccob16, sucursal, agrcar16, cod_producto, cod_subproducto, bulctr16, flgsobdimen04, nrotkt18, motcambprecinto)

		values(@Nroaut, @Contenedor, '1', '1', '', '001', 'IntN4', @FechaSalida,
		@FechaSalida, @Pesmer16, @Genbkg, @CodigoSubProducto, @Codemb, @Navvia, '', '0',
		'0', '0', SUBSTRING(@NroPrecinto, 1, 100), '0', @SucursalNep, '', @CodigoProducto, @CodigoSubProducto, 1,'0', @NroTkt, '00'
		)
	end
	--|
end

GO
grant all on sp_IntN4_Embarque_GenerarDataGateInOut_RE to public
GO

