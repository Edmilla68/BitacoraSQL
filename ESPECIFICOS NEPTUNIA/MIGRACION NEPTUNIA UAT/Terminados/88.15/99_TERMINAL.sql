USE [TERMINAL]
GO

/****** Object:  StoredProcedure [dbo].[usp_IntN4_ObtenerParametro]    Script Date: 12/03/2019 11:50:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_IntN4_ObtenerParametro]
	@vch_Parametro VARCHAR(100)
AS
BEGIN

	DECLARE @VALUE VARCHAR(MAX)
	
	SELECT @VALUE =ISNULL(VALUE,'') FROM COSETTING WHERE KEY_COSETTING=@vch_Parametro
		
	SELECT @VALUE
END
GO

USE [TERMINAL]
GO
/****** Object:  Trigger [dbo].[DDCABMAN11_I]    Script Date: 12/03/2019 01:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Trigger dbo.DDCABMAN11_I    Script Date: 08-09-2002 08:50:40 PM ******/
ALTER TRIGGER [dbo].[DDCABMAN11_I] ON [dbo].[DDCABMAN11]
FOR INSERT
AS
IF @@rowcount = 0
	RETURN
ELSE
	INSERT INTO CDAUDMAN00 (
		nomtab00
		,tipope00
		,codusu00
		,fecope00
		,hostid00
		,regupd00
		)
	SELECT 'DDCABMAN11'
		,'I'
		,user_name()
		,getdate()
		,host_name()
		,regupd00 = 
		substring(
		'NAVE:' + ISNULL(codnav08,'') + '|' + 
		'VIAJE:' + ISNULL(numvia11,'') + '|' + 
		'F.LLEGADA:' + convert(CHAR(20), ISNULL(feclle11,''), 100) + '|' + 
		'F.DESCARGA:' + convert(CHAR(20), ISNULL(fecdes11,''), 100) + '|' + 
		'MANIFIESTO:' + ISNULL(numman11, '') + '|' + 
		'NAVVIA11:' + ISNULL(navvia11,'') + '|' + 
		'USUARIO:' + ISNULL(codusu17, '') + '|' + 
		'F.USUARIO:' + convert(CHAR(20), ISNULL(fecdes11,''), 100) + '|' + 
		'OPERACION:' + ISNULL(tipope11,'') + '|' + 
		'FECALM11:' + convert(CHAR(20), ISNULL(fecalm11,''), 100) + '|' + 
		'F.ATRACO:' + convert(CHAR(20), ISNULL(fecatr11,''), 100) + '|' + 
		'F.ZARPE:' + convert(CHAR(20), ISNULL(feczar11,''), 100) + '|' + 
		'F.PRI.MOV:' + convert(CHAR(20), ISNULL(primov11,''), 100) + '|' + 
		'F.ULT.MOV:' + convert(CHAR(20), ISNULL(ultmov11,''), 100) + '|' + 
		'FECABA11:' + convert(CHAR(20), ISNULL(fecaba11,''), 100) + '|' + 
		'CONDEP11:' + ISNULL(condep11, '') + '|' + 
		'ENVADU11:' + convert(CHAR(4), ISNULL(envadu11,'')) + '|' + 
		'OBS:' + substring(ISNULL(obser11,''), 1, 4) + '|' + 
		ISNULL(expdir11,'') + '|' + 
		'FULTDI11:' + convert(CHAR(20), ISNULL(fultdi11,''), 100) + '|' + 
		'EXPIND11:' + ISNULL(expind11,'') + '|' + 
		'FULTIN11:' + convert(CHAR(20), ISNULL(fultin11,''), 100) + '|' + 
		'FLGCID11:' + ISNULL(flgcid11, '') + '|' + 
		'FLGCID11:' + ISNULL(flgcii11, '') + '|' + 
		'COD.ULTRAGESTION:' + ISNULL(codcco06,'') + '|' + 
		'RESPONSABLE:' + ISNULL(respon11, '') + '|' + 
		'PONCHILE:' + ISNULL(numvip11, '') + '|' + 
		'MUELLE:' + ISNULL(MUELLE11, '') + '|' + 
		'PUERTO ORIGEN:' + ISNULL(ptoori11, '')
		, 1, 2000)
	FROM INSERTED

/*
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON

insert into neptunia69.ofireca.dbo.TTNAVE_VIAJ
(CO_EMPR,CO_UNID,CO_NAVE_VIAJ,DE_NAVE_VIAJ,CO_USUA_CREA,FE_USUA_CREA,CO_USUA_MODI,FE_USUA_MODI)
(select '01','001',navvia11,substring(desnav08 + ' ' + numvia11,1,50),user,getdate(),user,getdate() From INSERTED a inner join dqnavier08 b on (a.codnav08=b.codnav08)
)    
*/


DECLARE @DESNAVE VARCHAR(5), @NAVVIA VARCHAR(6), @USUARIO VARCHAR(8)

select @DESNAVE = substring(desnav08 + ' ' + numvia11,1,50), @NAVVIA = navvia11, @USUARIO = USER
From INSERTED a inner join dqnavier08 b on (a.codnav08=b.codnav08)

--EXEC CALW3ERP001.OFIRECA.DBO.USP_REG_NAVEVIAJE '01','001',@NAVVIA,@DESNAVE,@USUARIO
EXEC [SP3TDA-DBSQL02].[OFIRECA].[DBO].[USP_REG_NAVEVIAJE] '16','001',@NAVVIA,@DESNAVE,@USUARIO


UPDATE DDCABMAN11
SET CODUSU17 = USER_NAME()
	,FECUSU00 = GETDATE()
	,PTOORI11 = CASE 
		WHEN INSERTED.PTOORI11 = 'A'
			THEN 'E'
		ELSE INSERTED.PTOORI11
		END
FROM INSERTED
WHERE DDCABMAN11.NAVVIA11 = INSERTED.NAVVIA11

--===========================================================================================================================================
--====Control de ROCKY para determinar la fecha de Inicio y Fin de Movimientos de la Nave/Viaje
--====Implementado por Hvega 23/02/2005 10:00
--===========================================================================================================================================
INSERT INTO ROCKY_INI_MOV_DES
SELECT codnav08
	,numvia11
	,coalesce(primov11, '19000101')
	,coalesce(ultmov11, '19000101')
	,0
	,getdate()
	,navvia11
	,tipope11
FROM INSERTED

--where tipope11='E'
--*********************************************************************************************************************************************************************************************
--Actualizar la fecha de abandono legal : Pedido por ROMY GUEVARA 
--*********************************************************************************************************************************************************************************************
DECLARE @FEC_DESCARGA SMALLDATETIME
DECLARE @NAVE CHAR(4)
DECLARE @CONTADOR TINYINT
DECLARE @CONT TINYINT
DECLARE @VIAJE VARCHAR(10)
DECLARE @TIPOPE CHAR(1)

SELECT @FEC_DESCARGA = ultmov11
FROM INSERTED

SELECT @NAVE = codnav08
FROM INSERTED

SELECT @VIAJE = numvia11
FROM INSERTED

SELECT @TIPOPE = tipope11
FROM INSERTED

SELECT @CONTADOR = 0

IF @TIPOPE = 'D'
	AND @FEC_DESCARGA IS NOT NULL
BEGIN
	WHILE @CONTADOR < 30
	BEGIN
		SELECT @FEC_DESCARGA = dateadd(dd, 1, @FEC_DESCARGA)

		SELECT @CONT = Count(*)
		FROM OQFERIAD01
		WHERE convert(CHAR(8), fecfer01, 112) = convert(CHAR(8), @FEC_DESCARGA, 112)
			AND actadu01 = '1'

		IF @CONT = 0
		BEGIN
			SELECT @CONTADOR = @CONTADOR + 1
		END

		CONTINUE
	END

	--Update DDCABMAN11 SET fecaba11=@FEC_DESCARGA Where codnav08=@NAVE and numvia11=@VIAJE and tipope11=@TIPOPE
	UPDATE DDCABMAN11
	SET fecaba11 = dateadd(dd, 30, fecdes11)
	WHERE codnav08 = @NAVE
		AND numvia11 = @VIAJE
		AND tipope11 = @TIPOPE
		AND fecdes11 IS NOT NULL
END
GO

USE [TERMINAL]
GO
/****** Object:  Trigger [dbo].[DDCABMAN11_U]    Script Date: 12/03/2019 01:37:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[DDCABMAN11_U] ON [dbo].[DDCABMAN11]
FOR UPDATE
AS
IF @@rowcount = 0
	RETURN
ELSE
	UPDATE DDCABMAN11
	SET CODUSU17 = USER_NAME()
		,FECUSU00 = GETDATE()
		,FLGTRA99 = 'U'
		,FECTRA99 = GETDATE()
		,PTOORI11 = CASE 
			WHEN INSERTED.PTOORI11 = 'A'
				THEN 'E'
			ELSE INSERTED.PTOORI11
			END
	FROM INSERTED
	WHERE DDCABMAN11.NAVVIA11 = INSERTED.NAVVIA11
		AND DDCABMAN11.flgtra99 NOT IN ('C')

DECLARE @NAVVIA1111 VARCHAR(6)

--//

SELECT @NAVVIA1111 = NAVVIA11
FROM INSERTED

IF EXISTS(
	SELECT *
	FROM INSERTED
	WHERE ultmov11 IS NOT NULL
)
BEGIN
	IF NOT EXISTS(
					SELECT *
					FROM CROLADD.DBO.STA_REGISTROMANIFIESTO_CONSULTATARJA
					WHERE navvia11 = @NAVVIA1111
				 )
	BEGIN
		INSERT INTO CROLADD.DBO.STA_REGISTROMANIFIESTO_CONSULTATARJA
		SELECT anyman11,numman11,navvia11,GETDATE(),'0','0'
		FROM INSERTED
	END
END

--//

INSERT INTO CDAUDMAN00 (
	nomtab00
	,tipope00
	,codusu00
	,fecope00
	,hostid00
	,regupd00
	)
SELECT 'DDCABMAN11'
	,'U'
	,user_name()
	,getdate()
	,host_name()
	,regupd00 = 
	substring(
	'NAVE:' + ISNULL(codnav08,'') + '|' + 
	'VIAJE:' + ISNULL(numvia11,'') + '|' + 
	'F.LLEGADA:' + convert(CHAR(20), ISNULL(feclle11,''), 100) + '|' + 
	'F.DESCARGA:' + convert(CHAR(20), ISNULL(fecdes11,''), 100) + '|' + 
	'MANIFIESTO:' + ISNULL(numman11, '') + '|' + 
	'NAVVIA11:' + ISNULL(navvia11,'') + '|' + 
	'USUARIO:' + ISNULL(codusu17, '') + '|' + 
	'F.USUARIO:' + convert(CHAR(20), ISNULL(fecdes11,''), 100) + '|' + 
	'OPERACION:' + ISNULL(tipope11,'') + '|' + 
	'FECALM11:' + convert(CHAR(20), ISNULL(fecalm11,''), 100) + '|' + 
	'F.ATRACO:' + convert(CHAR(20), ISNULL(fecatr11,''), 100) + '|' + 
	'F.ZARPE:' + convert(CHAR(20), ISNULL(feczar11,''), 100) + '|' + 
	'F.PRI.MOV:' + convert(CHAR(20), ISNULL(primov11,''), 100) + '|' + 
	'F.ULT.MOV:' + convert(CHAR(20), ISNULL(ultmov11,''), 100) + '|' + 
	'FECABA11:' + convert(CHAR(20), ISNULL(fecaba11,''), 100) + '|' + 
	'CONDEP11:' + ISNULL(condep11, '') + '|' + 
	'ENVADU11:' + convert(CHAR(4), ISNULL(envadu11,'')) + '|' + 
	'OBS:' + substring(ISNULL(obser11,''), 1, 4) + '|' + 
	ISNULL(expdir11,'') + '|' + 
	'FULTDI11:' + convert(CHAR(20), ISNULL(fultdi11,''), 100) + '|' + 
	'EXPIND11:' + ISNULL(expind11,'') + '|' + 
	'FULTIN11:' + convert(CHAR(20), ISNULL(fultin11,''), 100) + '|' + 
	'FLGCID11:' + ISNULL(flgcid11, '') + '|' + 
	'FLGCID11:' + ISNULL(flgcii11, '') + '|' + 
	'COD.ULTRAGESTION:' + ISNULL(codcco06,'') + '|' + 
	'RESPONSABLE:' + ISNULL(respon11, '') + '|' + 
	'PONCHILE:' + ISNULL(numvip11, '') + '|' + 
	'MUELLE:' + ISNULL(MUELLE11, '') + '|' + 
	'PUERTO ORIGEN:' + ISNULL(ptoori11, '')
	, 1, 2000)
FROM INSERTED

--===========================================================================================================================================
--====Control de ROCKY para determinar la fecha de Inicio y Fin de Movimientos de la Nave/Viaje
--===========================================================================================================================================
DECLARE @CON INT
DECLARE @PRIMER_MOV_ROCKY SMALLDATETIME
DECLARE @ULTIMO_MOV_ROCKY SMALLDATETIME
DECLARE @VIAJE VARCHAR(10)
DECLARE @NAVVIA11 CHAR(6)
DECLARE @PRIMER_MOVIMIENTO SMALLDATETIME
DECLARE @ULTIMO_MOVIMIENTO SMALLDATETIME
DECLARE @TIPOPE11 CHAR(1)

SELECT @VIAJE = numvia11
FROM INSERTED

SELECT @NAVVIA11 = navvia11
FROM INSERTED

SELECT @PRIMER_MOVIMIENTO = primov11
FROM INSERTED

SELECT @ULTIMO_MOVIMIENTO = ultmov11
FROM INSERTED

SELECT @TIPOPE11 = TIPOPE11
FROM INSERTED

SELECT @CON = count(*)
FROM ROCKY_INI_MOV_DES
WHERE navvia11 IN (
		SELECT navvia11
		FROM INSERTED
		)

SELECT @PRIMER_MOV_ROCKY = PRIMER_MOVIMIENTO
FROM ROCKY_INI_MOV_DES
WHERE navvia11 = @NAVVIA11

IF @CON <> 0
BEGIN
	UPDATE ROCKY_INI_MOV_DES
	SET VIAJE = @VIAJE
		,TIPOPE11 = @TIPOPE11
		,FECHA_ACTUAL = getdate()
	WHERE NAVVIA11 = @NAVVIA11

	IF @PRIMER_MOV_ROCKY <> @PRIMER_MOVIMIENTO
		UPDATE ROCKY_INI_MOV_DES
		SET PRIMER_MOVIMIENTO = @PRIMER_MOVIMIENTO
			,VEZ_MAIL = 0
		WHERE NAVVIA11 = @NAVVIA11
			--	IF @ULTIMO_MOV_ROCKY<>@ULTIMO_MOVIMIENTO
			--		Update ROCKY_INI_MOV_DES set ULTIMO_MOVIMIENTO=@ULTIMO_MOVIMIENTO,VEZ_MAIL=0  Where NAVVIA11=@NAVVIA11
END

--*********************************************************************************************************************************************************************************************
--Actualizar la fecha de abandono legal : Pedido por ROMY GUEVARA y AL PORRAS 20/10/2005
DECLARE @FEC_DESCARGA SMALLDATETIME
DECLARE @NAVE CHAR(4)
DECLARE @CONTADOR TINYINT
DECLARE @CONT TINYINT
DECLARE @TIPOPE CHAR(1)

SELECT @FEC_DESCARGA = ultmov11
FROM INSERTED

SELECT @NAVE = codnav08
FROM INSERTED

SELECT @VIAJE = numvia11
FROM INSERTED

SELECT @TIPOPE = tipope11
FROM INSERTED

SELECT @CONTADOR = 0

IF @TIPOPE = 'D'
	AND @FEC_DESCARGA IS NOT NULL
BEGIN
	/*
	WHILE @CONTADOR<30
	Begin 
		Select @FEC_DESCARGA=dateadd(dd,1,@FEC_DESCARGA)
		Select @CONT=Count(*) From OQFERIAD01 Where convert(char(8),fecfer01,112)=convert(char(8),@FEC_DESCARGA,112) and actadu01 = '1'
		IF @CONT=0
		Begin 
			Select @CONTADOR=@CONTADOR+1
		End
		CONTINUE
	End
*/
	UPDATE DDCABMAN11
	SET fecaba11 = dateadd(dd, 15, fecdes11)
	WHERE codnav08 = @NAVE
		AND numvia11 = @VIAJE
		AND tipope11 = @TIPOPE
		AND fecdes11 IS NOT NULL
END
GO

USE [TERMINAL]
GO

/****** Object:  StoredProcedure [dbo].[usp_Cooperation_ObtenerDataToBilling]    Script Date: 14/03/2019 12:08:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Cooperation_ObtenerDataToBilling]     
 --R: Registro U: Modificacion                            
 @sIntegral VARCHAR(10)      
AS    
BEGIN    
	DECLARE @USER_ODS AS VARCHAR(256)
	DECLARE @PASS_ODS AS VARCHAR(256)
	DECLARE @GKEY_ODS AS VARCHAR(256)
	DECLARE @SUCURSAL_ODS AS VARCHAR(256)
	DECLARE @CADENA_ODS AS VARCHAR(2000)

	SELECT @USER_ODS = VALUE FROM COSETTING WHERE KEY_COSETTING = 'USER_DPW_INT_N4'
    SELECT @PASS_ODS = VALUE FROM COSETTING WHERE KEY_COSETTING = 'PASS_DPW_INT_N4'

    SELECT @GKEY_ODS=UnitFacilityVisitGkey,@SUCURSAL_ODS=CASE WHEN SUCURSAL = 1 THEN 'VIL' WHEN sucursal= 2 THEN 'VEN' WHEN sucursal = 3 THEN 'PAI' END FROM EDBOOKIN13 A JOIN SSI_ORDEN B ON A.bkgcom13 = B.ORD_NUMDOCUMENTO WHERE ORD_CODIGO = @sIntegral

	SET @CADENA_ODS = DESCARGA.DBO.fn_Consulta_Valores_Adicionales_Billing(@GKEY_ODS) 

	SELECT @USER_ODS AS USER_ODS,@PASS_ODS AS PASS_ODS,@GKEY_ODS AS GKEY_ODS,@SUCURSAL_ODS AS SUCURSAL_ODS,@CADENA_ODS AS CADENA_ODS

END
GO


CREATE TABLE LOGINTN4_ODS
(
DESCMETODO VARCHAR(500)
,VALUE1 VARCHAR(50)
,VALUE2 VARCHAR(50)
,VALUE3 VARCHAR(50)
,TRAMAENVIO VARCHAR(MAX)
,JSONRESPUESTA VARCHAR(MAX)
,CODUSER VARCHAR(60)
,OCCURRENCE	DATETIME
)

GO
GRANT ALL ON LOGINTN4_ODS TO PUBLIC
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
	
	SET @CodUsuarioWS = LTRIM(rtrim(@CodUsuarioWS))
	SET @PassUsuarioWS = LTRIM(rtrim(@PassUsuarioWS))
	SET @CodLinea = LTRIM(rtrim(@CodLinea))
	SET @NombreLinea = LTRIM(rtrim(@NombreLinea))
	SET @NombreLinea = SUBSTRING(@NombreLinea, 1, 35)
	SET @PerteneceNeptunia = LTRIM(rtrim(@PerteneceNeptunia))
	SET @Status = LTRIM(rtrim(@Status))
	/*********************************/
	
	/*Validaciones Previas al Registro*/
	IF NOT EXISTS(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Usuario de conexion N4 incorrecto'
		RETURN;
	END
	IF NOT EXISTS(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Password de conexion N4 incorrecto'
		RETURN;
	END	
	IF (LEN(@CodLinea) = 0)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Debe enviar Codigo de Linea'
		RETURN;
	END
	IF (LEN(@CodLinea) > 3)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Codigo de Linea debe ser menor a 3 dígitos'
		RETURN;
	END
	IF (@Tipo = 1 OR @Tipo = 2)
	BEGIN
		IF (LEN(@NombreLinea) = 0)
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'Debe enviar Nombre de Linea'
			RETURN;
		END
		IF (@PerteneceNeptunia <> '0' AND @PerteneceNeptunia <> '1')
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'El valor Linea pertenece a neptunia debe ser  0 o 1'
			RETURN;
		END
		IF (@Status <> '0' AND @Status <> '1')
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'El valor Status debe ser  0 o 1'
			RETURN;
		END		
	END
	IF (@Tipo < 1 OR @Tipo > 3 )
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'El Tipo Envio debe ser  1-Insert o 2-Update o 3-Delete'
		RETURN;
	END
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
		IF EXISTS(SELECT codarm10 FROM DQARMADO10 (NOLOCK) WHERE codarm10_N4 = @CodLinea)
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
	
	SET @CodUsuarioWS = LTRIM(rtrim(@CodUsuarioWS))
	SET @PassUsuarioWS = LTRIM(rtrim(@PassUsuarioWS))
	SET @CodLinea = LTRIM(rtrim(@CodLinea))
	SET @NombreNave = LTRIM(rtrim(@NombreNave))
	SET @NombreNave = SUBSTRING(@NombreNave, 1, 30)
	SET @CodNave = LTRIM(rtrim(@CodNave))
	SET @Status = LTRIM(rtrim(@Status))
	/*********************************/
	
	/*Validaciones Previas al Registro*/
	IF NOT EXISTS(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Usuario de conexion N4 incorrecto'
		RETURN;
	END
	IF NOT EXISTS(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Password de conexion N4 incorrecto'
		RETURN;
	END	
	IF (LEN(@CodNave) = 0)
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'Debe enviar Codigo de Nave'
		RETURN;
	END
	IF (@Tipo = 1 OR @Tipo = 2)
	BEGIN
		IF (LEN(@CodLinea) = 0)
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'Debe enviar Codigo de Linea'
			RETURN;
		END
		IF (LEN(@CodLinea) > 3)
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'Codigo de Linea debe ser menor a 3 dígitos'
			RETURN;
		END
		IF (LEN(@NombreNave) = 0)
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'Debe enviar Nombre de Nave'
			RETURN;
		END
		IF (@Status <> '0' AND @Status <> '1')
		BEGIN
			SET @IdResul = '-1'
			SET @DesResul = 'El valor Status debe ser  0 o 1'
			RETURN;
		END
	END
	IF (@Tipo < 1 OR @Tipo > 3 )
	BEGIN
		SET @IdResul = '-1'
		SET @DesResul = 'El Tipo Envio debe ser  1-Insert o 2-Update o 3-Delete'
		RETURN;
	END
	
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
		SELECT @CodigoNaveNep = dbo.fn_Convert_Codnav08(@CodNave)
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

		IF EXISTS(SELECT codnav08 FROM DQNAVIER08 (NOLOCK) WHERE LTRIM(RTRIM(codnav08)) = @CodNave)
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

ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito1] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81               
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0

GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito2 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18  
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY               
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta          
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                  
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18   
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY              
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito67 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81              
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito68 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18 
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                
WHERE                   
	a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta           
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                 
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito1] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81               
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito2 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18  
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY               
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta          
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                  
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18   
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY              
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito67 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81              
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito68 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18 
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                
WHERE                   
	a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta           
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                 
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

GO
alter table camionajetotal
alter column nroguia varchar(100);

GO
alter table camionajetotal
alter column nrotkt varchar(100);

GO


/*    
Descripcion: Stored Procedures para migrar informacion de Asignacion de Ctr del N4 hacia Neptunia    
Fecha: 08-02-2019    
Autor: Franklin Milla    
*/ 
ALTER procedure sp_IntN4_Camionaje_GeneracionImport
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@Contenedor varchar(11)
,@VesselVisit varchar(35)
,@Placa varchar(8)
,@RucTransporte varchar(11)
,@IsoCode varchar(10)
,@NroGuia varchar(100)
,@NroTicket varchar(100)
,@Brevete varchar(15)
,@Motivo varchar(1)
,@Sucursal varchar(3)
,@Category varchar(50)
,@Sub_Type varchar(10)
,@FechaIngreso varchar(15)
,@FechaSalida varchar(15)
,@Condicion varchar(5)
,@FlgDobleTrans varchar(1)
,@ufvFlexString06 varchar(10)

,@IdResul  varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	SET @IdResul = '0'
	SET @DesResul = 'OK'
	
	set @CodUsuarioWS = LTRIM(rtrim(@CodUsuarioWS))
	set @PassUsuarioWS = LTRIM(rtrim(@PassUsuarioWS))
	set @ufvFlexString06 = LTRIM(RTRIM(@ufvFlexString06))
	set @Brevete = LTRIM(RTRIM(@Brevete))
	set @Placa = LTRIM(RTRIM(@Placa))

	set @Brevete = replace(@Brevete ,'-', '')
	set @Placa = replace(@Placa ,'-', '')
	/***********************************/
	
	/*Declaracion de Variables*/
	declare @Navvianep varchar(6)
	,@TamanyoCtr varchar(2)
	,@TipoCtr varchar(2)
	,@CodNave varchar(4)
	,@NumViaje varchar(10)
	,@CondicionCtr varchar(3)
	,@NombreTrans varchar(100)
	,@FechaGuia varchar(15)
	,@PuertoNave varchar(1)
	,@CodCircuito varchar(4)
	,@nroCarga int
	,@TipOpe varchar(1)
	/***********************************/
	
	/***** Validaciones *****/
	if not exists(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Usuario de conexion N4 incorrecto'
		return;
	end
	
	if not exists(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Password de conexion N4 incorrecto'
		return;
	end	
	
	if @Category = 'IMPRT'
	begin
		set @TipOpe = 'D'
	end
	else if @Category = 'EXPRT'
	begin
		set @TipOpe = 'E'
	end 
	else
	begin
		set @TipOpe = 'D' 
	end

	if not exists(select navvia11 from ddcabman11 (nolock) where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit and tipope11 = @TipOpe)
	begin
		set @IdResul = '-1'
		set @DesResul = 'VesselVisit no registrado en el Maestro de Nave-Viaje'
		return;
	end
	else
	begin
		select @Navvianep = a.navvia11
		, @CodNave = b.codnav08
		, @NumViaje= a.numvia11
		, @PuertoNave = a.ptoori11
		from DDCABMAN11 a (nolock)
		inner join DQNAVIER08 b (nolock) on a.codnav08 = b.codnav08
		where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit
		and tipope11 = @TipOpe
	end
	/***********************************/

	/***** Obtener Variables *****/
	if @Sucursal = 'VIL'
	begin
		set @Sucursal = '3'
	end
	else if  @Sucursal = 'VEN'
	begin
		set @Sucursal = '2'
	end
	else
	begin
		set @Sucursal = '6'
	end

	if ltrim(rtrim(@Condicion)) = 'FCL'
	begin
		set @Condicion = 'FC'
	end
	else if ltrim(rtrim(@Condicion)) = 'LCL'
	begin
		set @Condicion = 'LC'
	end
	else if ltrim(rtrim(@Condicion)) = 'MTY'
	begin
		set @Condicion = 'MT'
	end
	else
	begin	
		set @Condicion = ''
	end

	if @ufvFlexString06 = 'null' or @ufvFlexString06 = ''
	begin
		set @ufvFlexString06 = null
	end

	if @NroGuia = 'null' or @NroGuia = ''
	begin
		set @NroGuia = null
	end

	if @NroTicket = 'null' or @NroTicket = ''
	begin
		set @NroTicket = null
	end

	select @FechaGuia = dbo.fn_Obtener_FechaGuia(@PuertoNave, @Motivo, @Sucursal, @Category, @Sub_Type, @FechaIngreso, @FechaSalida, @RucTransporte, @ufvFlexString06) 
	select @CodCircuito = dbo.fn_Obtener_CodCircuito(@PuertoNave, @Motivo, @Sucursal, @Category, @Sub_Type, @RucTransporte, @ufvFlexString06) 

	if isnull(@CodCircuito, '') = ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'Codigo de Circuito no encontrado con el criterio ingresado (' + @PuertoNave + '/' + @Motivo + '/' + @Sucursal + '/' + @Category + '/' + 
		@Sub_Type + '/' + @RucTransporte + '/' + isnull(@ufvFlexString06, '') + ')' 
		return;
	end 

	select @NombreTrans = ltrim(rtrim(a.nombre))
	from AACLIENTESAA a (nolock)
	where a.contribuy = @RucTransporte

	select 
	@TamanyoCtr = CAST(Tamanyo as VARCHAR)
	, @TipoCtr = ltrim(rtrim(Tipo))
	from spbmcaracteristicascontenedor (nolock)
	where ltrim(rtrim(CodigoInternacional)) = @IsoCode

	if isnull(@TamanyoCtr, '') = ''
	begin
		select 
		@TamanyoCtr = CAST(Tamanyo as VARCHAR)
		, @TipoCtr = ltrim(rtrim(Tipo))
		from spbmcaracteristicascontenedor (nolock)
		where ltrim(rtrim(CodigoInternacional_N4)) = @IsoCode
	end
	/***********************************/

	INSERT INTO CAMIONAJETOTAL (
	Contenedor
	,NaveViaje
	,Placa
	,fechaGuia
	,Nave
	,Viaje
	,RucTransporte
	,TamanioCntr
	,TipoCntr
	,condicionCntr
	,NombreEmpTrans
	,nroguia
	,TipoOperacion
	,FechaRegGuia
	,FechaCargaAut
	,CodCircuito
	,DesCircuito
	,Tarifa20
	,Tarifa40
	,AfectoIgv
	,Descuento20
	,Descuento40
	,CobroViaje
	,cantViaje
	,nrotkt
	,DifMinutos
	,brevete
	)

	select 
	ltrim(rtrim(@Contenedor)) AS Contenedor
	,ltrim(rtrim(@Navvianep)) AS Naveviaje
	,ltrim(rtrim(@Placa)) AS Placa
	,ltrim(rtrim(@FechaGuia)) AS FechaGuia
	,ltrim(rtrim(@CodNave)) AS Nave
	,ltrim(rtrim(@NumViaje)) AS Viaje
	,ltrim(rtrim(isnull(@RucTransporte, ''))) AS RucTransporte
	,ltrim(rtrim(@TamanyoCtr)) AS Tamanio
	,case when ltrim(rtrim(@CodCircuito)) in ('C05', 'C06') 
		  then '*'
		  else ltrim(rtrim(@TipoCtr)) 
		  end AS Tipo
	,case when ltrim(rtrim(@CodCircuito)) in ('C05', 'C06') 
		  then 'MT'
		  else ltrim(rtrim(@Condicion)) 
		  end AS Condicion
	,ltrim(rtrim(isnull(@NombreTrans, ''))) AS NombreTra
	,ltrim(rtrim(@NroGuia)) AS nroGuia
	,case when ltrim(rtrim(@Sub_Type)) = 'DI'
		  then @Motivo
		  else ''
		  end AS TipoOperacion
	,ltrim(rtrim(@FechaGuia)) AS FecRegGuia
	,getdate() AS FechaCarga
	,g.codrut01 AS CodCircuito
	,g.destar01 AS DesCircuito
	,g.tarifa02 AS Tarifa20
	,g.tarifa01 AS Tarifa40
	,g.apligv01 AS AfectoIgv
	,h.montos20 AS Descuento20
	,h.montos40 AS Descuento40
	,g.CobroViaje AS CobroViaje
	,case when @FlgDobleTrans = '1' 
		  then 2
		  else 1
		  end AS Cantidad
	,case when ltrim(rtrim(@Sub_Type)) = 'DI' 
		 then ''
		  else ltrim(rtrim(@NroTicket))
		  end AS nrotkt
	,case when ltrim(rtrim(@Sub_Type)) = 'DI' 
								then 0
								else (
										CASE 
										WHEN datediff(minute, isnull(cast(@FechaIngreso as datetime), 0), isnull(cast(@FechaSalida as datetime), 0)) > 0
											THEN datediff(minute, isnull(cast(@FechaIngreso as datetime), 0), isnull(cast(@FechaSalida as datetime), 0))
										ELSE 0
										END
									 )
								end AS DifMinutos
	,ltrim(rtrim(@Brevete)) AS brevete
	from DDTARCAM01 g (nolock)
	LEFT JOIN DBO.CDDSCCAR02 h (nolock) ON g.codrut01 = h.codrut01
												 AND h.ruccli12 = @RucTransporte 
	where 
	g.codrut01 = @CodCircuito
	and ( ltrim(rtrim( @Contenedor)) + ltrim(rtrim(@Navvianep)) ) not in (
																			select ( ltrim(rtrim(Contenedor)) + ltrim(rtrim(NaveViaje)) )
																			from CAMIONAJETOTAL (nolock)
																			where fechaGuia >= dateadd(MONTH, -2, getdate()) 
																		 )
	

	
	set @nroCarga = @@IDENTITY

	/******Actualizar Tarifas*****/
	UPDATE camionajetotal
	SET TarifaCobrar = CASE 
			WHEN CobroViaje = 1
				AND cantViaje = 1
				THEN tarifa40 + isnull(descuento40, 0)
			WHEN CobroViaje = 1
				AND cantViaje = 2
				THEN tarifa20 + isnull(descuento20, 0)
			WHEN CobroViaje = 0
				AND tamaniocntr = '20'
				THEN tarifa20 + isnull(descuento20, 0)
			WHEN CobroViaje = 0
				AND tamaniocntr = '40'
				THEN tarifa40 + isnull(descuento40, 0)
			ELSE tarifa40 + isnull(descuento40, 0)
			END
	FROM camionajetotal
	WHERE nrocamionaje IS NULL
	and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 1
	WHERE nroCamionaje IS NULL
	and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	WHERE nroCamionaje IS NULL
		and cantViaje = 2
		and isnull(nroguia, '') <> ''
		and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	WHERE nroCamionaje IS NULL
		and cantViaje = 2
		and isnull(nroguia, '') = ''
		and isnull(nrotkt, '') <> ''
		and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	FROM dbo.Camionaje_TKT_Dos_Contenedores_Placa() AS a
	INNER JOIN camionajetotal AS b ON a.placa = b.placa
		and a.codcircuito = b.codcircuito
		and convert(VARCHAR(8), fechaguia, 112) + substring(convert(VARCHAR(8), fechaguia, 108), 1, 2) = fecha
	WHERE nroCamionaje IS NULL
		and isnull(nroguia, '') = ''
		and nroCarga = @nroCarga

	/******************************/

end

go
grant all on sp_IntN4_Camionaje_GeneracionImport to public
GO

ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito1] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81               
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito2 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18  
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY               
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'LC'
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'
/*
UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta          
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                  
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18   
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY              
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'
*/
RETURN 0
GO
ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito67 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81              
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

ALTER PROCEDURE CargaAuto_SP_CAMIONAJE_Circuito68 @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
/*
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18 
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                
WHERE                   
	a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

UNION
*/

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta           
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                 
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'LC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[usp_Cooperation_ObtenerDataToBilling]    Script Date: 25/03/2019 09:54:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[usp_Cooperation_ObtenerDataToBilling]       
 --R: Registro U: Modificacion                              
 @sIntegral VARCHAR(10)        
AS      
BEGIN      
 DECLARE @USER_ODS AS VARCHAR(256)  
 DECLARE @PASS_ODS AS VARCHAR(256)  
 DECLARE @GKEY_ODS AS VARCHAR(256)  
 DECLARE @SUCURSAL_ODS AS VARCHAR(256)  
 DECLARE @CADENA_ODS AS VARCHAR(2000)  
  
    SELECT @USER_ODS = VALUE FROM COSETTING WHERE KEY_COSETTING = 'USER_DPW_INT_N4'  
    SELECT @PASS_ODS = VALUE FROM COSETTING WHERE KEY_COSETTING = 'PASS_DPW_INT_N4'  
  
    SELECT @GKEY_ODS=UnitFacilityVisitGkey,@SUCURSAL_ODS=CASE WHEN SUCURSAL = 1 THEN 'VIL' WHEN sucursal= 2 THEN 'VEN' WHEN sucursal = 3 THEN 'VIL' END FROM EDBOOKIN13 A JOIN SSI_ORDEN B ON A.bkgcom13 = B.ORD_NUMDOCUMENTO WHERE ORD_CODIGO = @sIntegral  
  
 SET @CADENA_ODS = DESCARGA.DBO.fn_Consulta_Valores_Adicionales_Billing(@GKEY_ODS)   
  
 SELECT @USER_ODS AS USER_ODS,@PASS_ODS AS PASS_ODS,@GKEY_ODS AS GKEY_ODS,@SUCURSAL_ODS AS SUCURSAL_ODS,@CADENA_ODS AS CADENA_ODS  
  
END  
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[CargaAuto_SP_CAMIONAJE_Circuito1]    Script Date: 25/03/2019 09:56:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito1] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81               
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'

RETURN 0
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[CargaAuto_SP_CAMIONAJE_Circuito2]    Script Date: 25/03/2019 09:57:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito2] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18  
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY               
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'LC'
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'
/*
UNION

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta          
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                  
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18   
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY              
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'E'
*/
RETURN 0
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[CargaAuto_SP_CAMIONAJE_Circuito67]    Script Date: 25/03/2019 09:59:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito67] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaDoc
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta               
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81              
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'FC'
	--AND c.observ04 NOT LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[CargaAuto_SP_CAMIONAJE_Circuito68]    Script Date: 25/03/2019 10:00:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaAuto_SP_CAMIONAJE_Circuito68] @fecha2 VARCHAR(8)
	,@TipOpe VARCHAR(1)
	,@sucursal VARCHAR(1)
	,@faduan18 VARCHAR(2)
	,@codbol03 VARCHAR(2)
	,@observ04 VARCHAR(8)
	,@CodRuta VARCHAR(3)
AS
/*
SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,b.codage19 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS Cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta         
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18 
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                
WHERE                   
	a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = @codbol03
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

UNION
*/

SELECT DISTINCT c.codcon04 AS Contenedor
	,a.navvia11 AS Naveviaje
	,a.nropla18 AS Placa
	,a.fecing18 AS FechaGuia
	,d.codnav08 AS Nave
	,d.numvia11 AS Viaje
	,A.RucTransportista18 AS RucTransporte
	,c.codtam09 AS Tamanio
	,c.codtip05 AS Tipo
	,c.codbol03 AS Condicion
	,e.NOMBRE AS NombreTra
	,'' AS nroGuia
	,a.tipope18 AS TipoOperacion
	,a.fecusu00 AS FecRegGuia
	,getdate() AS FechaCarga
	,f.codrut01 AS CodCircuito
	,f.destar01 AS DesCircuito
	,f.tarifa02 AS Tarifa20
	,f.tarifa01 AS Tarifa40
	,f.apligv01 AS AfectoIgv
	,g.montos20 AS Descuento20
	,g.montos40 AS Descuento40
	,f.CobroViaje AS CobroViaje
	,1 AS cantidad
	,a.nrotkt18 AS nrotkt
	,CASE 
		WHEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0)) > 0
			THEN datediff(minute, isnull(fecing18, 0), isnull(fecsal18, 0))
		ELSE 0
		END AS DifMinutos
	,'' AS Brevete
FROM DDTICKET18 A(NOLOCK)
INNER JOIN DDCONTEN04 C(NOLOCK) ON a.navvia11 = c.navvia11
	AND a.nrotkt18 = c.nrotkt18
	AND a.codcon04 = c.codcon63
INNER JOIN DDCABMAN11 D(NOLOCK) ON a.navvia11 = d.navvia11
INNER JOIN DDTARCAM01 AS F(NOLOCK) ON F.codrut01 = @CodRuta           
LEFT JOIN DQPLAAGS81 B(NOLOCK) ON a.nropla18 = b.nropla81                 
LEFT JOIN CDDSCCAR02 AS G(NOLOCK) ON f.codrut01 = g.codrut01
	AND g.ruccli12 = A.RucTransportista18
LEFT JOIN AACLIENTESAA E(NOLOCK) ON A.RucTransportista18 = e.CONTRIBUY                 
WHERE a.fecusu00 BETWEEN convert(VARCHAR(8), dateadd(d, - 15, @fecha2), 112)
		AND @fecha2
	AND a.tipope18 = @TipOpe
	AND a.sucursal = @sucursal
	AND c.codbol03 = 'LC'
	--AND c.observ04 LIKE @observ04
	--AND a.ftrans18 <> '2'
	--AND activo81 = '1'
	AND d.ptoori11 = 'D'

RETURN 0
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[usp_Cooperation_Lista_Integrales]    Script Date: 25/03/2019 10:01:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Cooperation_Lista_Integrales]    
 --@iFiltro INT                                    
 --1:Importacion Integral 2:Exportacion Integral 3:Importación Terminal  4:Exportación Terminal 5:Importación Forwarder 6:Exportación Forwarder                                           
 @iFiltroCriterio INT    
 ,--1:orden 2:cliente 3:Documento Operativo  4:Rango Fechas                                        
 @sValor CHAR(50)    
 ,@sUsuReg CHAR(20)    
 ,@sSucursal CHAR(1)    
AS    
DECLARE @sFecIni CHAR(8)    
 ,@sFecFin CHAR(8)    
    
SET @sValor = REPLACE(@sValor, SPACE(61), '')    
    
--//LOGICA DE GRUPOS DE TRABAJO                
DECLARE @sUsuario VARCHAR(35)    
DECLARE @FLG_SUPER_USER VARCHAR(1) --1: SUPER USER SI, 0: SUPER USER NO                
    
SET @sUsuario = ''    
SET @FLG_SUPER_USER = '0'    
    
SELECT @sUsuario = USU_CodigoInterno    
FROM Seguridad..SGT_USUARIO    
WHERE USU_Codigo = LTRIM(RTRIM(@sUsuReg))    
    
IF ISNULL(@sUsuario, '') = ''    
BEGIN    
 SET @sUsuario = LTRIM(RTRIM(@sUsuReg))    
END    
    
DECLARE @IDEQUIPO INT    
 ,@CANTIDAD INT    
 ,@PERCODIGO INT    
    
SET @IDEQUIPO = 0    
    
CREATE TABLE #USER (CodUsuario VARCHAR(50))    
    
SELECT @IDEQUIPO = EQP_TRABAJO    
 ,@PERCODIGO = PER_Codigo    
FROM SSI_EQUIPO_TRABAJO_COOPETARIONS    
WHERE USU_Codigo = @sUsuario    
    
IF ISNULL(@IDEQUIPO, 0) = 0    
BEGIN    
 INSERT INTO #USER (CodUsuario)    
 VALUES (@sUsuReg)    
END    
ELSE    
BEGIN    
 EXEC USP_COOPERATION_VALIDAR_SUPER_USER @sUsuario    
  ,@FLG_SUPER_USER OUTPUT    
    
 PRINT @FLG_SUPER_USER    
    
 IF @FLG_SUPER_USER = '0'    
 BEGIN    
  INSERT INTO #USER (CodUsuario)    
  SELECT USUARIO = CASE     
    WHEN B.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN A.USU_Codigo    
    ELSE B.USU_Codigo COLLATE Modern_Spanish_CI_AS    
    END    
  FROM SSI_EQUIPO_TRABAJO_COOPETARIONS A(NOLOCK)    
  LEFT JOIN Seguridad..SGT_USUARIO B(NOLOCK) ON A.USU_Codigo = B.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS    
  WHERE EQP_TRABAJO = @IDEQUIPO    
   AND A.PER_Codigo = '124'    
 END    
END    
    
--//                
IF @iFiltroCriterio = 1    
BEGIN    
 IF @FLG_SUPER_USER = '1'    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ORD_CODIGO LIKE '%' + LTRIM(RTRIM(@sValor)) + '%'    
   --AND ORD_USUARIOREG LIKE REPLACE(@sUsuReg, SPACE(61), '')                
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 12, getdate())    
  ORDER BY FECHA_REGISTRO DESC    
 END    
 ELSE    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG COLLATE Modern_Spanish_CI_AS    
  WHERE a.ORD_CODIGO LIKE '%' + LTRIM(RTRIM(@sValor)) + '%'    
   AND ORD_USUARIOREG  COLLATE Modern_Spanish_CI_AS IN (    
    SELECT CodUsuario    
    FROM #USER    
    )    
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 12, getdate())    
  ORDER BY FECHA_REGISTRO DESC    
 END    
END    
    
IF @iFiltroCriterio = 2    
BEGIN    
 IF @FLG_SUPER_USER = '1'    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  INNER JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE C.NOMBRE LIKE '%' + LTRIM(RTRIM(@sValor)) + '%'    
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 2, getdate())    
  --AND ORD_USUARIOREG LIKE REPLACE(@sUsuReg, SPACE(61), '')                
  ORDER BY FECHA_REGISTRO DESC    
 END    
 ELSE    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                        
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  INNER JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE C.NOMBRE LIKE '%' + LTRIM(RTRIM(@sValor)) + '%'    
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 2, getdate())    
   AND ORD_USUARIOREG IN (    
    SELECT CodUsuario    
    FROM #USER    
    )    
  ORDER BY FECHA_REGISTRO DESC    
 END    
END    
    
IF @iFiltroCriterio = 3    
BEGIN    
 IF @FLG_SUPER_USER = '1'    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ord_numdocumento = @sValor    
   --AND ORD_USUARIOREG LIKE REPLACE(@sUsuReg, SPACE(61), '')                
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 2, getdate())    
  ORDER BY FECHA_REGISTRO DESC    
 END    
 ELSE    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ord_numdocumento = @sValor    
   AND ORD_USUARIOREG IN (    
    SELECT CodUsuario    
    FROM #USER    
    )    
   AND a.ORD_FECHAREG >= DATEADD(MONTH, - 2, getdate())    
  ORDER BY FECHA_REGISTRO DESC    
 END    
END    
    
IF @iFiltroCriterio = 4    
BEGIN    
 SET @sFecIni = substring(@sValor, 1, 8)    
 SET @sFecFin = substring(@sValor, 9, 16)    
    
 IF @FLG_SUPER_USER = '1'    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), a.ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ord_fechaOpen >= @sFecIni    
   AND a.ord_fechaOpen < @sFecFin    
  --AND ORD_USUARIOREG LIKE REPLACE(@sUsuReg, SPACE(61), '')                
  ORDER BY FECHA_REGISTRO DESC    
 END    
 ELSE    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), a.ord_fechaOpen, 106) AS FECHA_REGISTRO                            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2'    
     THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3'    
     THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ord_fechaOpen >= @sFecIni    
   AND a.ord_fechaOpen < @sFecFin    
   AND ORD_USUARIOREG IN (    
    SELECT CodUsuario    
    FROM #USER    
    )    
  ORDER BY FECHA_REGISTRO DESC    
 END    
END 
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[usp_Cooperation_Lista_Operaciones]    Script Date: 25/03/2019 10:02:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_Cooperation_Lista_Operaciones '0000002429','1'                                
ALTER PROCEDURE [dbo].[usp_Cooperation_Lista_Operaciones]    
 --@iFiltro INT                              
 --1:Importacion Integral 2:Exportacion Integral 3:Importación Terminal  4:Exportación Terminal 5:Importación Forwarder 6:Exportación Forwarder                                     
 @sUsuReg CHAR(20)    
 ,@sSucursal CHAR(1)    
AS    
BEGIN    
 --//LOGICA DE GRUPOS DE TRABAJO          
 DECLARE @sUsuario VARCHAR(35)    
 DECLARE @FLG_SUPER_USER VARCHAR(1) --1: SUPER USER SI, 0: SUPER USER NO          
    
 SET @sUsuario = ''    
 SET @FLG_SUPER_USER = '0'    
    
 SELECT @sUsuario = USU_CodigoInterno    
 FROM Seguridad..SGT_USUARIO    
 WHERE USU_Codigo = LTRIM(RTRIM(@sUsuReg))    
    
 IF ISNULL(@sUsuario, '') = ''    
 BEGIN    
  SET @sUsuario = LTRIM(RTRIM(@sUsuReg))    
 END    
    
 DECLARE @IDEQUIPO INT    
  ,@CANTIDAD INT    
  ,@PERCODIGO INT    
    
 SET @IDEQUIPO = 0    
    
 CREATE TABLE #USER (CodUsuario VARCHAR(50))    
    
 SELECT @IDEQUIPO = EQP_TRABAJO    
  ,@PERCODIGO = PER_Codigo    
 FROM SSI_EQUIPO_TRABAJO_COOPETARIONS    
 WHERE USU_Codigo = @sUsuario    
    
 IF ISNULL(@IDEQUIPO, 0) = 0    
 BEGIN    
  INSERT INTO #USER (CodUsuario)    
  VALUES (@sUsuReg)    
 END    
 ELSE    
 BEGIN    
  EXEC USP_COOPERATION_VALIDAR_SUPER_USER @sUsuario    
   ,@FLG_SUPER_USER OUTPUT    
    
  IF @FLG_SUPER_USER = '0'    
  BEGIN    
   INSERT INTO #USER (CodUsuario)    
   SELECT USUARIO = CASE     
     WHEN B.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
      THEN A.USU_Codigo    
     ELSE B.USU_Codigo COLLATE Modern_Spanish_CI_AS    
     END    
   FROM SSI_EQUIPO_TRABAJO_COOPETARIONS A(NOLOCK)    
   LEFT JOIN Seguridad..SGT_USUARIO B(NOLOCK) ON A.USU_Codigo = B.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS    
   WHERE EQP_TRABAJO = @IDEQUIPO    
    AND A.PER_Codigo = '124'    
  END    
 END    
    
 --//          
 IF @FLG_SUPER_USER = '1'    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO                    
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2' THEN 'Via Otros Terminales'    
    WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3' THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END    
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
   ,A.ORD_FECHAREG    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ORD_FECHAREG >= DATEADD(MONTH, - 1, getdate())    
  --AND ORD_USUARIOREG LIKE '%' + replace(@sUsuReg, space(61), '') + '%'          
  --ORDER BY A.FECHA_REGISTRO DESC        
  ORDER BY A.ORD_FECHAREG DESC    
 END    
 ELSE    
 BEGIN    
  SELECT DISTINCT TOP 500 a.ord_codigo AS NRO_OSI    
   ,a.ord_numdocumento AS DOCUMENTO_OPERATIVO    
   ,ord_cliente AS RUC_CLIENTE    
   ,c.nombre AS CLIENTE    
   ,d.desnav08 AS NAVE    
   ,b.numvia11 AS VIAJE    
   ,a.ord_linea AS LINEA    
   --,convert(VARCHAR(20), ord_fechaOpen, 106) AS FECHA_REGISTRO            
   ,FECHA_REGISTRO = (convert(VARCHAR(10), A.ORD_FECHAREG, 103) + ' ' + convert(VARCHAR(5), A.ORD_FECHAREG, 108))    
   ,EST = CASE     
    WHEN A.ORD_FLAGESTADO IS NULL    
     THEN 'Activo'    
    ELSE 'Inactivo'    
    END    
   ,isnull(c.vendedor, '''') AS EJEC    
   ,b.numman11 AS MANIF    
   ,CAST(b.anyman11 AS VARCHAR) AS ANYM    
   ,TIPREG = CASE     
  WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '2' THEN 'Via Otros Terminales'    
  WHEN ISNULL(A.ORD_FLAGREGISTRO, '') = '3' THEN 'Directa'    
    ELSE 'Via Neptunia'    
    END      
   ,USUARIO_REG = CASE     
    WHEN USU.USU_Codigo COLLATE Modern_Spanish_CI_AS IS NULL    
     THEN UPPER(A.ORD_USUARIOREG)    
    ELSE UPPER(USU.USU_CodigoInterno COLLATE Modern_Spanish_CI_AS)    
    END    
   ,A.ORD_FECHAREG    
  FROM SSI_ORDEN A WITH (NOLOCK)    
  INNER JOIN DDCABMAN11 B WITH (NOLOCK) ON B.navvia11 = A.ORD_NAVVIA    
  LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON C.CONTRIBUY = A.ORD_CLIENTE    
  INNER JOIN DQNAVIER08 D WITH (NOLOCK) ON D.CODNAV08 = B.CODNAV08    
  LEFT JOIN Seguridad..SGT_USUARIO USU WITH (NOLOCK) ON USU.USU_Codigo COLLATE Modern_Spanish_CI_AS = A.ORD_USUARIOREG    
  WHERE a.ORD_FECHAREG >= DATEADD(MONTH, - 1, getdate())    
   AND ORD_USUARIOREG COLLATE Modern_Spanish_CI_AS IN (    
    SELECT CodUsuario    
    FROM #USER    
    ) 
  --ORDER BY A.FECHA_REGISTRO DESC        
  ORDER BY A.ORD_FECHAREG DESC    
 END    
    
 DROP TABLE #USER    
END  
GO

USE [TERMINAL]
GO
/****** Object:  StoredProcedure [dbo].[sp_IntN4_Camionaje_GeneracionImport]    Script Date: 25/03/2019 10:05:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_IntN4_Camionaje_GeneracionImport]
@CodUsuarioWS varchar(100)
,@PassUsuarioWS varchar(100)
,@Contenedor varchar(11)
,@VesselVisit varchar(35)
,@Placa varchar(8)
,@RucTransporte varchar(11)
,@IsoCode varchar(10)
,@NroGuia varchar(100)
,@NroTicket varchar(100)
,@Brevete varchar(15)
,@Motivo varchar(1)
,@Sucursal varchar(3)
,@Category varchar(50)
,@Sub_Type varchar(10)
,@FechaIngreso varchar(15)
,@FechaSalida varchar(15)
,@Condicion varchar(5)
,@FlgDobleTrans varchar(1)
,@ufvFlexString06 varchar(10)

,@IdResul  varchar(3) OUTPUT
,@DesResul varchar(500) OUTPUT
as
begin
	/*Incializando Variables de Salida*/
	SET @IdResul = '0'
	SET @DesResul = 'OK'
	
	set @CodUsuarioWS = LTRIM(rtrim(@CodUsuarioWS))
	set @PassUsuarioWS = LTRIM(rtrim(@PassUsuarioWS))
	set @ufvFlexString06 = LTRIM(RTRIM(@ufvFlexString06))
	set @Brevete = LTRIM(RTRIM(@Brevete))
	set @Placa = LTRIM(RTRIM(@Placa))

	set @Brevete = replace(@Brevete ,'-', '')
	set @Placa = replace(@Placa ,'-', '')
	/***********************************/
	
	/*Declaracion de Variables*/
	declare @Navvianep varchar(6)
	,@TamanyoCtr varchar(2)
	,@TipoCtr varchar(2)
	,@CodNave varchar(4)
	,@NumViaje varchar(10)
	,@CondicionCtr varchar(3)
	,@NombreTrans varchar(100)
	,@FechaGuia varchar(15)
	,@PuertoNave varchar(1)
	,@CodCircuito varchar(4)
	,@nroCarga int
	,@TipOpe varchar(1)
	/***********************************/
	
	/***** Validaciones *****/
	if not exists(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Usuario de conexion N4 incorrecto'
		return;
	end
	
	if not exists(SELECT VALUE FROM COSETTING (NOLOCK) WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)
	begin
		set @IdResul = '-1'
		set @DesResul = 'Password de conexion N4 incorrecto'
		return;
	end	
	
	if @Category = 'IMPRT'
	begin
		set @TipOpe = 'D'
	end
	else if @Category = 'EXPRT'
	begin
		set @TipOpe = 'E'
	end 
	else
	begin
		set @TipOpe = 'D' 
	end

	if not exists(select navvia11 from ddcabman11 (nolock) where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit and tipope11 = @TipOpe)
	begin
		set @IdResul = '-1'
		set @DesResul = 'VesselVisit no registrado en el Maestro de Nave-Viaje'
		return;
	end
	else
	begin
		select @Navvianep = a.navvia11
		, @CodNave = b.codnav08
		, @NumViaje= a.numvia11
		, @PuertoNave = a.ptoori11
		from DDCABMAN11 a (nolock)
		inner join DQNAVIER08 b (nolock) on a.codnav08 = b.codnav08
		where LTRIM(rtrim(VESSELVISITID)) = @VesselVisit
		and tipope11 = @TipOpe
	end
	/***********************************/

	/***** Obtener Variables *****/
	if @Sucursal = 'VIL'
	begin
		set @Sucursal = '3'
	end
	else if  @Sucursal = 'VEN'
	begin
		set @Sucursal = '2'
	end
	else
	begin
		set @Sucursal = '6'
	end

	if ltrim(rtrim(@Condicion)) = 'FCL'
	begin
		set @Condicion = 'FC'
	end
	else if ltrim(rtrim(@Condicion)) = 'LCL'
	begin
		set @Condicion = 'LC'
	end
	else if ltrim(rtrim(@Condicion)) = 'MTY'
	begin
		set @Condicion = 'MT'
	end
	else
	begin	
		set @Condicion = ''
	end

	if @ufvFlexString06 = 'null' or @ufvFlexString06 = ''
	begin
		set @ufvFlexString06 = null
	end

	if @NroGuia = 'null' or @NroGuia = ''
	begin
		set @NroGuia = null
	end

	if @NroTicket = 'null' or @NroTicket = ''
	begin
		set @NroTicket = null
	end

	select @FechaGuia = dbo.fn_Obtener_FechaGuia(@PuertoNave, @Motivo, @Sucursal, @Category, @Sub_Type, @FechaIngreso, @FechaSalida, @RucTransporte, @ufvFlexString06) 
	select @CodCircuito = dbo.fn_Obtener_CodCircuito(@PuertoNave, @Motivo, @Sucursal, @Category, @Sub_Type, @RucTransporte, @ufvFlexString06) 

	if isnull(@CodCircuito, '') = ''
	begin
		set @IdResul = '-1'
		set @DesResul = 'Codigo de Circuito no encontrado con el criterio ingresado (' + @PuertoNave + '/' + @Motivo + '/' + @Sucursal + '/' + @Category + '/' + 
		@Sub_Type + '/' + @RucTransporte + '/' + isnull(@ufvFlexString06, '') + ')' 
		return;
	end 

	select @NombreTrans = ltrim(rtrim(a.nombre))
	from AACLIENTESAA a (nolock)
	where a.contribuy = @RucTransporte

	select 
	@TamanyoCtr = CAST(Tamanyo as VARCHAR)
	, @TipoCtr = ltrim(rtrim(Tipo))
	from spbmcaracteristicascontenedor (nolock)
	where ltrim(rtrim(CodigoInternacional)) = @IsoCode

	if isnull(@TamanyoCtr, '') = ''
	begin
		select 
		@TamanyoCtr = CAST(Tamanyo as VARCHAR)
		, @TipoCtr = ltrim(rtrim(Tipo))
		from spbmcaracteristicascontenedor (nolock)
		where ltrim(rtrim(CodigoInternacional_N4)) = @IsoCode
	end
	/***********************************/

	INSERT INTO CAMIONAJETOTAL (
	Contenedor
	,NaveViaje
	,Placa
	,fechaGuia
	,Nave
	,Viaje
	,RucTransporte
	,TamanioCntr
	,TipoCntr
	,condicionCntr
	,NombreEmpTrans
	,nroguia
	,TipoOperacion
	,FechaRegGuia
	,FechaCargaAut
	,CodCircuito
	,DesCircuito
	,Tarifa20
	,Tarifa40
	,AfectoIgv
	,Descuento20
	,Descuento40
	,CobroViaje
	,cantViaje
	,nrotkt
	,DifMinutos
	,brevete
	)

	select 
	ltrim(rtrim(@Contenedor)) AS Contenedor
	,ltrim(rtrim(@Navvianep)) AS Naveviaje
	,ltrim(rtrim(@Placa)) AS Placa
	,ltrim(rtrim(@FechaGuia)) AS FechaGuia
	,ltrim(rtrim(@CodNave)) AS Nave
	,ltrim(rtrim(@NumViaje)) AS Viaje
	,ltrim(rtrim(isnull(@RucTransporte, ''))) AS RucTransporte
	,ltrim(rtrim(@TamanyoCtr)) AS Tamanio
	,case when ltrim(rtrim(@CodCircuito)) in ('C05', 'C06') 
		  then '*'
		  else ltrim(rtrim(@TipoCtr)) 
		  end AS Tipo
	,case when ltrim(rtrim(@CodCircuito)) in ('C05', 'C06') 
		  then 'MT'
		  else ltrim(rtrim(@Condicion)) 
		  end AS Condicion
	,ltrim(rtrim(isnull(@NombreTrans, ''))) AS NombreTra
	,ltrim(rtrim(@NroGuia)) AS nroGuia
	,case when ltrim(rtrim(@Sub_Type)) = 'DI'
		  then @Motivo
		  else ''
		  end AS TipoOperacion
	,ltrim(rtrim(@FechaGuia)) AS FecRegGuia
	,getdate() AS FechaCarga
	,g.codrut01 AS CodCircuito
	,g.destar01 AS DesCircuito
	,g.tarifa02 AS Tarifa20
	,g.tarifa01 AS Tarifa40
	,g.apligv01 AS AfectoIgv
	,h.montos20 AS Descuento20
	,h.montos40 AS Descuento40
	,g.CobroViaje AS CobroViaje
	,case when @FlgDobleTrans = '1' 
		  then 2
		  else 1
		  end AS Cantidad
	,case when ltrim(rtrim(@Sub_Type)) = 'DI' 
		 then ''
		  else ltrim(rtrim(@NroTicket))
		  end AS nrotkt
	,case when ltrim(rtrim(@Sub_Type)) = 'DI' 
								then 0
								else (
										CASE 
										WHEN datediff(minute, isnull(cast(@FechaIngreso as datetime), 0), isnull(cast(@FechaSalida as datetime), 0)) > 0
											THEN datediff(minute, isnull(cast(@FechaIngreso as datetime), 0), isnull(cast(@FechaSalida as datetime), 0))
										ELSE 0
										END
									 )
								end AS DifMinutos
	,ltrim(rtrim(@Brevete)) AS brevete
	from DDTARCAM01 g (nolock)
	LEFT JOIN DBO.CDDSCCAR02 h (nolock) ON g.codrut01 = h.codrut01
												 AND h.ruccli12 = @RucTransporte 
	where 
	g.codrut01 = @CodCircuito
	and ( ltrim(rtrim( @Contenedor)) + ltrim(rtrim(@Navvianep)) ) not in (
																			select ( ltrim(rtrim(Contenedor)) + ltrim(rtrim(NaveViaje)) )
																			from CAMIONAJETOTAL (nolock)
																			where fechaGuia >= dateadd(MONTH, -2, getdate()) 
																		 )
	

	
	set @nroCarga = @@IDENTITY

	/******Actualizar Tarifas*****/
	UPDATE camionajetotal
	SET TarifaCobrar = CASE 
			WHEN CobroViaje = 1
				AND cantViaje = 1
				THEN tarifa40 + isnull(descuento40, 0)
			WHEN CobroViaje = 1
				AND cantViaje = 2
				THEN tarifa20 + isnull(descuento20, 0)
			WHEN CobroViaje = 0
				AND tamaniocntr = '20'
				THEN tarifa20 + isnull(descuento20, 0)
			WHEN CobroViaje = 0
				AND tamaniocntr = '40'
				THEN tarifa40 + isnull(descuento40, 0)
			ELSE tarifa40 + isnull(descuento40, 0)
			END
	FROM camionajetotal
	WHERE nrocamionaje IS NULL
	and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 1
	WHERE nroCamionaje IS NULL
	and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	WHERE nroCamionaje IS NULL
		and cantViaje = 2
		and isnull(nroguia, '') <> ''
		and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	WHERE nroCamionaje IS NULL
		and cantViaje = 2
		and isnull(nroguia, '') = ''
		and isnull(nrotkt, '') <> ''
		and nroCarga = @nroCarga

	UPDATE camionajetotal
	SET ViajeDetraccion = 0.5
		,TarifaCobrar = TarifaCobrar / 2
	FROM dbo.Camionaje_TKT_Dos_Contenedores_Placa() AS a
	INNER JOIN camionajetotal AS b ON a.placa = b.placa
		and a.codcircuito = b.codcircuito
		and convert(VARCHAR(8), fechaguia, 112) + substring(convert(VARCHAR(8), fechaguia, 108), 1, 2) = fecha
	WHERE nroCamionaje IS NULL
		and isnull(nroguia, '') = ''
		and nroCarga = @nroCarga

	/******************************/

end
GO


