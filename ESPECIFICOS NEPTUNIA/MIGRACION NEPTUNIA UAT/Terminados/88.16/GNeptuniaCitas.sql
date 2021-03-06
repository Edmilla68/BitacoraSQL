USE [GNeptuniaCitas]
GO
/****** Object:  UserDefinedFunction [dbo].[CIT_ObtenerCapacidadCalendario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DECLARE @Capacidad INT
--SET @Capacidad = dbo.CIT_ObtenerCapacidadCalendario('08:00-09:00','20141016')
--SELECT @Capacidad
ALTER FUNCTION [dbo].[CIT_ObtenerCapacidadCalendario] 
(@turno VARCHAR(20),
@dia DATETIME)
RETURNS INT
AS 
BEGIN
	DECLARE @capacidad INT
	DECLARE @Existe INT

	SET  @Existe = ( 
			SELECT Cap_Disp_Turno 
			FROM CIT_Turno 
			WHERE 
			Des_Turno=@turno 
			AND Fec_Turno=@dia
	)


	IF (@Existe IS NULL)
	BEGIN
		SET	@capacidad=(
			SELECT Can_Capacidad
			FROM CIT_CapacidadMaximaAtencionTurno
			WHERE 
			Turno_Capacidad=@turno 
			AND Fecha_Capacidad=@dia
		)
	END
	ELSE
	BEGIN 
		SET @capacidad=@Existe
	END
	
	RETURN (@capacidad)
END
GO
/****** Object:  UserDefinedFunction [dbo].[CIT_ObtenerCapacidadCalendarioSemanal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
--declare @existe varchar(max) 
-- set @existe=dbo.CIT_ObtenerCapacidadCalendarioSemanal('08:00-08:30','2010-06-10 00:00:00.000')
--
--select @existe
ALTER FUNCTION [dbo].[CIT_ObtenerCapacidadCalendarioSemanal] (@turno varchar(20),@dia datetime)

RETURNS varchar(max)

AS 

BEGIN

DECLARE @Reservada int
DECLARE @CapacidadMaxima int
DECLARE @Etiqueta varchar(max)

SET  @Reservada =(SELECT Cap_Res_Turno 
			   FROM CIT_Turno 
			   WHERE Des_Turno=@turno AND Fec_Turno=@dia)

IF (@Reservada IS NULL)
BEGIN
SET @Reservada=0
END



SET	@CapacidadMaxima=(SELECT Can_Capacidad
				FROM CIT_CapacidadMaximaAtencionTurno
				WHERE Turno_Capacidad=@turno AND Fecha_Capacidad=@dia)



SET @Etiqueta='CM:'+CONVERT(VARCHAR(2),@CapacidadMaxima)+CHAR(13)+'CR:' + CONVERT(VARCHAR(2),@Reservada)


 RETURN (@Etiqueta)

END


GO
/****** Object:  UserDefinedFunction [dbo].[CIT_ObtenerContenedorByCodVolanteYNroPlaca]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 25/11/2014
-- Description:	Devuelve el próximo contenedor que debe ser sacado
-- SELECT dbo.CIT_ObtenerContenedorByCodVolanteYNroPlaca ('554719','GYS111')
-- =============================================
ALTER FUNCTION [dbo].[CIT_ObtenerContenedorByCodVolanteYNroPlaca] 
(
	@pCod_Volante VARCHAR(6),
	@pNro_Placa VARCHAR(10)
)
RETURNS VARCHAR(11)
AS
BEGIN
	DECLARE @vCod_Contenedor VARCHAR(11),
			@vTmp_Tolerancia INT,
			@vTmp_Desde DATETIME,
			@vTmp_Hasta DATETIME,
			@vNro_Comprobante VARCHAR(20)
			--,@pCod_Volante VARCHAR(6),
			--@pNro_Placa VARCHAR(10),
	
	--SET @pCod_Volante = '555185'--

	SELECT 
		@vNro_Comprobante = Nro_Comprobante
	FROM dbo.CIT_OrdenRetiro
	WHERE 
	Cod_Volante = @pCod_Volante
	AND Nro_Placa = @pNro_Placa
	
	SET @vCod_Contenedor = ''
	DECLARE @TT TABLE(Cod_Contenedor VARCHAR(11), Ord_Contenedor INT, Fec_Hor_Cita DATETIME, Ident_Cita INT, Nro_Placa VARCHAR(10))

	/*OBTENEMOS EL VALOR DE TOLERANCIA PARA ATENCIÓN DEL TURNO*/
	--SELECT @vTmp_Tolerancia = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 1

	/*ASIGNAMOS LOS LÍMITES PARA EL TIEMPO DE CITA*/
	--SET @vTmp_Tolerancia = ISNULL(@vTmp_Tolerancia,0)
	--SET @vTmp_Desde = DATEADD(MINUTE, (-1) * @vTmp_Tolerancia, GETDATE())
	--SET @vTmp_Hasta = DATEADD(MINUTE, @vTmp_Tolerancia, GETDATE())

	/*OBTENEMOS TODAS LAS CITAS PARA EL INTERVALO DE TIEMPO*/
	INSERT INTO @TT
	SELECT * FROM (
		SELECT 
			ORD.Cod_Contenedor,	
			CASE
				WHEN ISNULL(CTR.Ord_Contenedor,99) = 99 THEN 99
				WHEN CTR.Ord_Contenedor = 0 THEN 99
				ELSE CTR.Ord_Contenedor END AS Ord_Contenedor,
			CONVERT(DATETIME,CONVERT(VARCHAR(8),TUR.Fec_Turno,112) + ' ' + SUBSTRING(TUR.Des_Turno,0,6)) Fec_Hor_Cita,
			CIT.Ident_Cita,
			ORD.Nro_Placa
		FROM CIT_OrdenRetiro ORD
		LEFT JOIN dbo.CIT_Contenedor CTR ON ORD.Cod_Contenedor COLLATE DATABASE_DEFAULT = CTR.Cod_Contenedor COLLATE DATABASE_DEFAULT AND CTR.Cod_Estado <> 'BLQ'
		LEFT JOIN dbo.CIT_Cita CIT ON CTR.Cod_Volante COLLATE DATABASE_DEFAULT = CIT.Cod_Volante COLLATE DATABASE_DEFAULT
										AND ORD.Cod_Contenedor COLLATE DATABASE_DEFAULT = CIT.Cod_Contenedor COLLATE DATABASE_DEFAULT
										AND CIT.Cod_Estado IN ('FAC','ENP')
		LEFT JOIN dbo.CIT_Turno TUR ON CIT.Ident_Turno = TUR.Ident_Turno	
		WHERE 
		ORD.Cod_Volante = @pCod_Volante
		AND ISNULL(ORD.Asignado,0) = 0		
		AND ORD.Nro_Comprobante = @vNro_Comprobante
	) AS TT
	--WHERE 
	--TT.Fec_Hor_Cita BETWEEN @vTmp_Desde AND @vTmp_Hasta

	/*VALIDAMOS SI EN LAS CITAS DENTRO DEL INTERVALO SE HAN DEFINIDO PRIORIDADES*/
	DECLARE @vConPrioridad INT
	SELECT @vConPrioridad = COUNT(*)
	FROM @TT
	WHERE 
	Ord_Contenedor <> 99

	IF ((SELECT COUNT(Cod_Contenedor) FROM @TT ) = 1)
	BEGIN
		SELECT TOP 1 @vCod_Contenedor = Cod_Contenedor FROM @TT		
	END
	ELSE
	BEGIN
		IF(@vConPrioridad > 0)
		BEGIN
			/*SI SE DEFINIERON PRIORIDADES ENTONCES SE EMITE EL CONTENEDOR DE ACUERDO AL ORDEN INDICADO*/
			SELECT TOP 1 @vCod_Contenedor = Cod_Contenedor FROM @TT
			ORDER BY Ord_Contenedor, Fec_Hor_Cita, Ident_Cita
		END 
		ELSE
		BEGIN
			/*SI NO SE DEFINIERON PRIORIDADES SE DEVUELVE EL CONTENEDOR ASOCIADO A LA ORDEN DE RETIRO Y PLACA*/
			SELECT TOP 1 @vCod_Contenedor = Cod_Contenedor FROM @TT
			WHERE 
			Nro_Placa = @pNro_Placa
			ORDER BY Ord_Contenedor, Fec_Hor_Cita, Ident_Cita
		END
	END

	RETURN @vCod_Contenedor
END
GO
/****** Object:  UserDefinedFunction [dbo].[CIT_ObtenerReservasCapacidadCalendario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DECLARE @CantidadReservada INT
--SET @CantidadReservada = dbo.CIT_ObtenerReservasCapacidadCalendario('08:00-09:00','20141016')
--SELECT @CantidadReservada
ALTER FUNCTION [dbo].[CIT_ObtenerReservasCapacidadCalendario] (@turno VARCHAR(20),@dia DATETIME)        
RETURNS INT
AS  
BEGIN
	DECLARE @CapacidadInicial INT, @CapacidadFinal INT

	SET @CapacidadInicial=(
		SELECT ISNULL(SUM(Cantidad),0)  
		FROM [CIT_ReservaCupos]  
		WHERE 
		@dia BETWEEN Fec_Desde AND Fec_Hasta  
		AND Tur_Reserva = @turno
	)

	/*OBTENEMOS EL ID ASOCIADO A LA FECHA Y EL TURNO*/
	DECLARE @IdTurno INT, @NroCitasInt INT
	SELECT @IdTurno = Ident_Turno 
	FROM dbo.CIT_Turno 
	WHERE 
	Des_Turno = @turno
	AND Fec_Turno = @dia

	/*OBTENEMOS LA CANTIDAD DE CITAS INTEGRALES QUE SE HAN REGISTRADO PARA EL TURNO EN CONSULTA*/
	SELECT @NroCitasInt = COUNT(Ident_Cita)
	FROM dbo.CIT_Cita
	WHERE 
	Ident_Turno = @IdTurno
	AND Cod_Estado <> 'ANU'
	AND EsIntegral = 1

	SET @NroCitasInt = ISNULL(@NroCitasInt,0)
	SET @CapacidadFinal = @CapacidadInicial - @NroCitasInt

	IF(@CapacidadFinal < 0)
		SET @CapacidadFinal = 0

	RETURN (@CapacidadFinal)        
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnSplitString] 
( 
	@string NVARCHAR(4000), 
	@delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(4000)) 
BEGIN 
	DECLARE @start INT, @end INT 
	SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
	WHILE @start < LEN(@string) + 1 BEGIN 
		IF @end = 0  
			SET @end = LEN(@string) + 1

		INSERT INTO @output (splitdata)  
		VALUES(SUBSTRING(@string, @start, @end - @start)) 
		SET @start = @end + 1 
		SET @end = CHARINDEX(@delimiter, @string, @start)

	END 
	RETURN 
END
GO
/****** Object:  View [dbo].[CIT_VistaPanelElectronico]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[CIT_VistaPanelElectronico]
AS
SELECT	TOP 1
		Nro_Placa,
		Ruma,
		Habilitado
FROM	dbo.CIT_PanelElectronicoVista
GO
/****** Object:  View [dbo].[SGS_VISTA_USUARIO_ListarUsuario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[SGS_VISTA_USUARIO_ListarUsuario]
AS
	SELECT * FROM [SP3TDA-DBSQL01].Seguridad.dbo.SGT_USUARIO
GO
/****** Object:  View [dbo].[vw_CumpleCita_DespachoImpo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[vw_CumpleCita_DespachoImpo]
AS
	SELECT 
	Nu_Placa_Asociado = ISNULL(CIT.Nu_Placa_Asociado, '')
	,Cumple_Cita = CASE WHEN ISNULL(CIT.Cumple_Cita, '0') = '0' THEN 'NO' ELSE 'SI' END
	,Cod_Contenedor_Desp = ISNULL(O.Cod_Contenedor_Desp, '')
	,CIT.Fec_Ing_Nep_Cita
	,CIT.Ident_Cita
	FROM [dbo].[CIT_Cita] CIT
		LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON (
				O.Nro_Orden_Retiro = CASE 
					WHEN CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI IS NULL
						THEN CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI
					ELSE CASE 
							WHEN SUBSTRING(CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI, 1, 6) = SUBSTRING(CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI, 1, 6)
								THEN CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI
							ELSE CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI
							END
					END
				)
	WHERE CIT.cod_Estado not in ('CAN', 'VEN', 'ANU') 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ACTUALIZAR_ESTADO_CITA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ACTUALIZAR_ESTADO_CITA] @Co_Cita VARCHAR(10)
	,@No_Estado VARCHAR(3)
	,@No_Usuario AS VARCHAR(100)
AS
DECLARE @Fe_Actual AS DATETIME

BEGIN
	IF @No_Estado = 'ENP'
	BEGIN
		UPDATE [dbo].[CIT_Cita]
		SET [Fec_Ing_Bal_Cita] = getdate()
			,Cod_Estado = 'ENP'
		WHERE [Ident_Cita] = @Co_Cita
			AND Cod_Estado = 'INS'
	END

	SET @Fe_Actual = getdate()
	exec CIT_AUDITORIA_ESTADOS @No_Estado,@Co_Cita,@Fe_Actual,@No_Usuario;    
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarAcciones]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ActualizarAcciones]
@acc_codigo INT,
@acc_nombre NVARCHAR(500),
@USU_Codigo NVARCHAR(25)
AS
BEGIN
	DECLARE @Ident INT

	IF( (SELECT COUNT(*) FROM [CIT_Acciones] WHERE [acc_nombre] = @acc_nombre) > 0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		UPDATE [dbo].[CIT_Acciones]
		SET [acc_nombre] = @acc_nombre
			,[acc_codigo_modifica] = @USU_Codigo
			,[acc_fecha_modifica] = getdate()
		WHERE  acc_codigo = @acc_codigo

		SET @Ident = @acc_codigo
	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarCapacidadMaximaXParametro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





---------------------------------------------------------------------------------
-- Nombre: CIT_ActualizarCapacidadMaximaXParametro
-- Objetivo: Actualiza Capacidad Máxima por Valores de Parámetros
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarCapacidadMaximaXParametro]
	@p_Anio			int,
	@p_Mes			int,
	@p_Dia			int,
	@p_Turno		Varchar(11),
	@p_Capacidad	int,
	@p_Usuario		Varchar(20)
AS
BEGIN
	/*
	DECLARE @p_Anio			int,
			@p_Mes			int,
			@p_Dia			int,
			@p_Turno		Varchar(11),
			@p_Capacidad	int,
			@p_Usuario		Varchar(20)

	SET @p_Anio = 2010
	SET @p_Mes = 2
	SET @p_Dia = 0
	SET @p_Turno = '0'
	SET @p_Capacidad = 8
	SET @p_Usuario = 'SYSTEM'
	*/

	DECLARE @FecIni	Datetime,
			@FecFin	Datetime

	DECLARE @nIntervalo			Decimal(18,7),
			@HoraInicio					Datetime,
			@HoraFin					Datetime,
			@HoraInicioIntegrales		Datetime,
			@HoraFinIntegrales			Datetime,	
			@HoraInicioTurno	Varchar(5),
			@HoraFinTurno		Varchar(5),
			@RangoTurno			Varchar(11),
			@sSQL				Varchar(8000)

	
	SET @FecIni =	RTRIM(LTRIM(STR(@p_Anio))) + 
					CASE WHEN @p_Mes = 0 THEN '01' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Mes))),2) END + 
					CASE WHEN @p_Dia = 0 THEN '01' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Dia))),2) END

	SET @FecFin =	RTRIM(LTRIM(STR(@p_Anio))) + 
					CASE WHEN @p_Mes = 0 THEN '12' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Mes))),2) END + 
					CASE WHEN @p_Dia = 0 THEN	RIGHT(CONVERT(Varchar(8),DATEADD(d,-1,DATEADD(m,1,
												RTRIM(LTRIM(STR(@p_Anio))) + CASE WHEN @p_Mes = 0 THEN '12' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Mes))),2) END + '01')),112),2)
					ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Dia))),2) END		

	SELECT @nIntervalo = MAX(CONVERT(Decimal(18,7),P.Valor_Parametro)) * 60
	FROM CIT_PARAMETRO P
		WHERE P.Cod_Parametro IN (6)

	WHILE (@FecIni<=@FecFin)
	BEGIN

		--Todos los Turnos
			IF (@p_Turno = '0')
			BEGIN

--				SELECT @HoraInicio = DescmCampo + ':00'
--					FROM dbo.PAR_Tabla_Generica G
--					INNER JOIN (
--									SELECT MIN(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
--									FROM CIT_PARAMETRO P
--										WHERE P.Cod_Parametro IN (2,4)
--								) P ON
--					G.ValorCampo = P.Valor_Parametro
--					WHERE G.Ident_Tabla IN (2)

--				SELECT @HoraFin = DescmCampo + ':00'
--					FROM dbo.PAR_Tabla_Generica G
--					INNER JOIN (
--									SELECT MAX(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
--									FROM CIT_PARAMETRO P
--										WHERE P.Cod_Parametro IN (3,5)
--								) P ON
--					G.ValorCampo = P.Valor_Parametro
--					WHERE G.Ident_Tabla IN (2)

				SET @HoraInicio = '00:00:00'
				SET @HoraFin = '23:30:00'

				WHILE (@HoraInicio<@HoraFin)
				BEGIN
					SET @HoraInicioTurno = CONVERT(Varchar(5),@HoraInicio,108)
					SET @HoraInicio = DATEADD(mi,@nIntervalo,@HoraInicio)
					SET @HoraFinTurno = CONVERT(Varchar(5),@HoraInicio,108)
					SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno
					EXEC dbo.CIT_ActualizarCapacidadMaximaXTurno @FecIni,@RangoTurno,@p_Capacidad,@p_Usuario
				END
			END

		--Especificamos un Turno
			IF (@p_Turno <> '0')
			BEGIN
				EXEC dbo.CIT_ActualizarCapacidadMaximaXTurno @FecIni,@p_Turno,@p_Capacidad,@p_Usuario
			END

		SET @FecIni = DATEADD(d,1,@FecIni)
	END
END









GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarCapacidadMaximaXTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  

  
---------------------------------------------------------------------------------  
-- Nombre: CIT_ActualizarCapacidadMaxima  
-- Objetivo: Actualiza Capacidad Máxima por Turno  
-- Valores Prueba:   
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528  
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528  
---------------------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_ActualizarCapacidadMaximaXTurno]  
  @p_Fecha  Datetime,  --Fecha de Horario  
  @p_Turno  Varchar(11), --Turno de Horario  
  @p_Capacidad int,   --Capacidad Máxima  
  @p_Usuario  Varchar(20)  --Usuario  
AS  
BEGIN  
  
  
-- DECLARE @p_Fecha  Datetime,  
--   @p_Turno  Varchar(11),  
--   @p_Capacidad int,  
--   @p_Usuario  Varchar(20)  
--  
-- SET @p_Fecha = '20100531'  
-- SET @p_Turno = '08:00-10:30'  
-- SET @p_Capacidad = 9  
-- SET @p_Usuario = 'SYSTEM'  
  
   
 DECLARE @FlagExiste int,  
   @FlagCita int,  
   @FlagHistorico int,  
   @FlagCompromiso int  
  
 SELECT  
  @FlagExiste = COUNT(*)  
 FROM dbo.CIT_CapacidadMaximaAtencionTurno C  
  WHERE C.Fecha_Capacidad = @p_Fecha AND  
    C.Turno_Capacidad = @p_Turno  
  
-- SELECT *  
--  @FlagHistorico = COUNT(*)  
-- FROM dbo.CIT_CapacidadMaximaAtencionTurnoXHistorico H  
--  INNER JOIN dbo.CIT_CapacidadMaximaAtencionTurno C ON  
--   H.Ident_AtencionTurno = C.Ident_AtencionTurno  
--  WHERE C.Fecha_Capacidad = @p_Fecha AND  
--    C.Turno_Capacidad = @p_Turno  
  
 SELECT   
  @FlagCompromiso = COUNT(*)   
 FROM dbo.CIT_Cita C  
  INNER JOIN dbo.CIT_Turno T ON  
   C.Ident_Turno = T.Ident_Turno  
    AND    C.Cod_Estado <> 'ANU'
 WHERE T.Fec_Turno = @p_Fecha AND  
   T.Des_Turno = @p_Turno  
 IF (@FlagCompromiso = 0 AND (CONVERT(Varchar(8),@p_Fecha,112) + ' ' + LEFT(@p_Turno,5) + ':00') >= CONVERT(Varchar,GETDATE(),112))  
 BEGIN  
  --Si NO existe insertamos registro  
  IF (@FlagExiste = 0)  
   BEGIN     
    INSERT INTO dbo.CIT_CapacidadMaximaAtencionTurno  
     (Fecha_Capacidad, Turno_Capacidad, Can_Capacidad, Fec_Reg_Parametro, Usu_Reg_Parametro)  
    VALUES  
     (@p_Fecha, @p_Turno, @p_Capacidad, GETDATE(), @p_Usuario)  
   END  
  --Si existe actualizamos registro  
  ELSE  
   BEGIN     
    UPDATE C  
    SET  
     C.Can_Capacidad = @p_Capacidad,  
     C.Fec_Reg_Parametro = GETDATE(),  
     C.Usu_Reg_Parametro = @p_Usuario  
    FROM dbo.CIT_CapacidadMaximaAtencionTurno C  
     WHERE C.Fecha_Capacidad = @p_Fecha AND  
       C.Turno_Capacidad = @p_Turno      
   END  
 END  
END  


 --SELECT   
 --  COUNT(*)   
 --FROM dbo.CIT_Cita C  
 -- INNER JOIN dbo.CIT_Turno T ON  
 --  C.Ident_Turno = T.Ident_Turno  
 --WHERE T.Fec_Turno = '20100810' AND  
 --  T.Des_Turno = '11:00-12:00' 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarConfigAlerta]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ActualizarConfigAlerta]
	@Id  int
,@Descripcion varchar(200)
,@Dias int
,@Sucursales varchar(1000)
,@CodSucursales varchar(1000)
,@NVeces INT
,@Intervalo INT = 0
as
begin
	UPDATE [dbo].[CIT_Parametro_Alertas]
	SET			
		[Descripcion] = @Descripcion
		,[Dias] = @Dias
		,[Sucursales] =@Sucursales
		,[CodSucursales]= @CodSucursales
		,[NVeces] = @NVeces
		,[Intervalo] = @Intervalo
	WHERE
	Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarConfigPDT]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- RV - 04/12/2014 - Se comentó la validación de una balanza asociada a un sólo PDT
ALTER PROCEDURE [dbo].[CIT_ActualizarConfigPDT]  
@id INT,  
@codigo NVARCHAR(50),  
@Panel CHAR(2),  
@Balanza INT 
AS 
BEGIN 
	DECLARE @Ident INT
	SET @Ident = 0
	/*VALIDAMOS QUE NO EXISTA MÁS DE UNA BALANZA CON PANEL*/
	IF(((SELECT COUNT(Id) FROM [CIT_Parametro_PDT] WHERE Panel = 'SI' AND Id <> @id) > 0) AND @Panel = 'SI')
	BEGIN 
		SET @Ident = -3
	END

	--IF((SELECT COUNT(Id) FROM [CIT_Parametro_PDT] WHERE  Balanza = @Balanza AND codigo <> @codigo) > 0  )  
	--BEGIN 
	--	SET @Ident = -2   
	--END 
	IF (@Ident = 0)
	BEGIN
		UPDATE [dbo].[CIT_Parametro_PDT]  
		SET 
			[codigo] = @codigo  
			,[Panel] = @Panel  
			,Balanza = @Balanza  
		WHERE [id] = @id  
		SET @Ident = 1  
	END 
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarEstadoCitaXAnulacionXFactura]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------
-- Nombre: CIT_ActualizarEstadoCitaXAnulacionXFactura
-- Objetivo: Actual76iza el estado a la Cita a Anulada siempre y cuando este proceso se haga en facturacion
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo Chunga  14/05/2010
-- Modificacion: 
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarEstadoCitaXAnulacionXFactura]
@NumeroComprobante  Varchar(11), --Numero de Comprobante
@TipoComprobante		Varchar(3)	--Tipo de Comprobante
AS
BEGIN
	--Actualiza las citas a anuladas
    UPDATE C
		SET C.Cod_Estado='REG',
			C.Nro_Orden_Retiro=NULL
	FROM dbo.CIT_Cita C
	INNER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
	INNER JOIN CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	  
	WHERE
		O.Nro_Comprobante = @NumeroComprobante
		AND O.Tip_Comprobante=	@TipoComprobante
        AND O.Cod_Estado='ACT'
        AND C.Cod_Estado='FAC'

   --Actualiza las ordenes de retiro a inactivas
    UPDATE O
	SET O.Cod_Estado='INA'  
	FROM dbo.CIT_OrdenRetiro O 
	WHERE
		O.Nro_Comprobante = @NumeroComprobante
		AND O.Tip_Comprobante=	@TipoComprobante
        AND O.Cod_Estado='ACT'

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarEstadoReprogramado]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 20/11/2014
-- Description:	ACTUALIZA EL ESTADO DE LA CITA
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ActualizarEstadoReprogramado]
@p_Ident_Cita INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.CIT_Cita
	SET 
		Cod_Estado = 'REP',
		Fec_Rep_Cita = GETDATE()
	WHERE 
	Ident_Cita = @p_Ident_Cita
	AND Cod_Estado = 'ANU'
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarFechaBloqueoXParametro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------
-- Nombre: CIT_ActualizarFechaBloqueoXParametro
-- Objetivo: Actualiza Fecha de Bloqueo por Valores de Parámetros
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarFechaBloqueoXParametro]
	@p_Fecha		Varchar(8),		--Fecha de Horario
	@p_Turno		Varchar(11),
	@p_Usuario		Varchar(20),
	@p_FlagDesBloqueo	int
AS
BEGIN

	DECLARE @nIntervalo			Decimal(18,7),
			@HoraInicio					Datetime,
			@HoraFin					Datetime,
			@HoraInicioTurno	Varchar(5),
			@HoraFinTurno		Varchar(5),
			@RangoTurno			Varchar(11),
			@sSQL				Varchar(8000)


		--Todos los Turnos
			IF (@p_Turno = '0')
			BEGIN
				SELECT @nIntervalo = CONVERT(Decimal(18,7),P.Valor_Parametro) * 60
				FROM CIT_PARAMETRO P
					WHERE P.Cod_Parametro IN (6)

				SELECT @HoraInicio = DescmCampo + ':00'
					FROM dbo.PAR_Tabla_Generica G
					INNER JOIN (
									SELECT MIN(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
									FROM CIT_PARAMETRO P
										WHERE P.Cod_Parametro IN (2,4)
								) P ON
					G.ValorCampo = P.Valor_Parametro
					WHERE G.Ident_Tabla IN (2)

				SELECT @HoraFin = DescmCampo + ':00'
					FROM dbo.PAR_Tabla_Generica G
					INNER JOIN (
									SELECT MAX(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
									FROM CIT_PARAMETRO P
										WHERE P.Cod_Parametro IN (3,5)
								) P ON
					G.ValorCampo = P.Valor_Parametro
					WHERE G.Ident_Tabla IN (2)

				WHILE (@HoraInicio<@HoraFin)
				BEGIN
					SET @HoraInicioTurno = CONVERT(Varchar(5),@HoraInicio,108)
					SET @HoraInicio = DATEADD(mi,@nIntervalo,@HoraInicio)
					SET @HoraFinTurno = CONVERT(Varchar(5),@HoraInicio,108)
					SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno
					EXEC dbo.CIT_ActualizarFechaBloqueoXTurno @p_Fecha,@RangoTurno,@p_Usuario,@p_FlagDesBloqueo
				END
			END

		--Especificamos un Turno
			IF (@p_Turno <> '0')
			BEGIN
				EXEC dbo.CIT_ActualizarFechaBloqueoXTurno @p_Fecha,@p_Turno,@p_Usuario,@p_FlagDesBloqueo
			END

END





GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarFechaBloqueoXTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






---------------------------------------------------------------------------------
-- Nombre: CIT_ActualizarFechaBloqueoXTurno
-- Objetivo: Actualiza Fecha de Bloqueo por Turno
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarFechaBloqueoXTurno]
		@p_Fecha			Datetime,		--Fecha de Horario
		@p_Turno			Varchar(11),	--Turno de Horario
		@p_Usuario			Varchar(20),	--Usuario quien Bloquea o Desbloquea
		@p_FlagDesBloqueo	int				--Flag Indicador de Bloqueo o Desbloqueo
AS
BEGIN

	DECLARE @FlagExiste int,
			@FlagCompromiso int
				

	SELECT 
		@FlagExiste = COUNT(*)
	FROM dbo.CIT_FechaBloqueoCita C
		WHERE	C.Fec_Bloq_Cita = @p_Fecha AND
				C.Tur_Bloq_Cita = @p_Turno

	SELECT 
		@FlagCompromiso = COUNT(*) 
	FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_Turno T ON
			C.Ident_Turno = T.Ident_Turno
	WHERE	T.Fec_Turno = @p_Fecha AND
			T.Des_Turno = @p_Turno

	--Si es Bloqueo
	IF (@p_FlagDesBloqueo = 0 AND @FlagExiste = 0 AND @FlagCompromiso=0 AND (CONVERT(Varchar(8),@p_Fecha,112) + ' ' + LEFT(@p_Turno,5) + ':00') >=GETDATE())	
		BEGIN			
			INSERT INTO dbo.CIT_FechaBloqueoCita
				(Fec_Bloq_Cita, Tur_Bloq_Cita, Fec_Reg_Parametro, Usu_Reg_Parametro)
			VALUES
				(@p_Fecha, @p_Turno, GETDATE(), @p_Usuario)
		END
	--Si existe actualizamos registro
	IF (@p_FlagDesBloqueo = 1 AND @FlagExiste = 1 AND (CONVERT(Varchar(8),@p_Fecha,112) + ' ' + LEFT(@p_Turno,5) + ':00') >=GETDATE())	
		BEGIN
			DELETE F
			FROM dbo.CIT_FechaBloqueoCita F
				WHERE	F.Fec_Bloq_Cita = @p_Fecha AND
						F.Tur_Bloq_Cita = @p_Turno	
		END
END









GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarFechaIngresoBalanza]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ActualizarFechaIngresoBalanza] @p_Nro_Placa VARCHAR(6)
	,--Número de Placa  
	@p_Fec_Ing_Bal_Cita DATETIME
AS
BEGIN
	RETURN;
	SET NOCOUNT ON

	-- identificar si trabaja con panel o no, si el numero de placa no se encuentra en la tabla CIT_PanelElectronico es por que no cuenta con panel  
	IF EXISTS (
			SELECT 1
			FROM [DBO].[CIT_PanelElectronico]
			WHERE NRO_PLACA = @p_Nro_Placa
			)
	BEGIN --si cuenta con panel  
		BEGIN TRANSACTION [TRAN1]

		-- cod_Estado  de la tabla cita tiene que ponerce como ENP, ingresar Fec_Ing_Bal_Cita  
		UPDATE C
		SET C.[Fec_Ing_Bal_Cita] = @p_Fec_Ing_Bal_Cita
			,C.[Cod_Estado] = 'ENP'
		FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
		INNER JOIN dbo.CIT_PanelElectronico PE ON PE.Nro_Placa = O.Nro_Placa
		WHERE O.Nro_Placa = @p_Nro_Placa
			AND C.Fec_Ing_Bal_Cita IS NULL
			AND PE.COD_ESTADO IN (
				'COL'
				,'RET'
				)

		--Actualizamos Estado de Panel Electrónico  
		UPDATE P
		SET P.Cod_Estado = 'ING'
		FROM dbo.CIT_PanelElectronico P
		WHERE P.Nro_Placa = @p_Nro_Placa
			AND P.Cod_Estado IN (
				'COL'
				,'RET'
				)

		DELETE dbo.CIT_PanelElectronicoTemporal
		WHERE Nro_Placa = @p_Nro_Placa

		IF @@ERROR = 0
			COMMIT TRANSACTION [TRAN1]
		ELSE
			ROLLBACK TRANSACTION [TRAN1]
	END
	ELSE --- no cuenta con panel  
	BEGIN
		BEGIN TRANSACTION [TRAN2]

		UPDATE C
		SET C.Fec_Ing_Bal_Cita = @p_Fec_Ing_Bal_Cita
			,C.Cod_Estado = 'ENP'
		FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
		WHERE O.Nro_Placa = @p_Nro_Placa
			AND C.Fec_Ing_Bal_Cita IS NULL

		IF @@ERROR = 0
			COMMIT TRANSACTION [TRAN2]
		ELSE
			ROLLBACK TRANSACTION [TRAN2]
	END
END --FIN DE PROCEDURE  
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarFechaSalidaBalanza]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ActualizarFechaSalidaBalanza] @nroplaca VARCHAR(6)
	,--Número de Placa          
	@Fec_Des_Cita DATETIME --Fecha de Salida a Balanza          
AS
BEGIN
	SET NOCOUNT ON

	/*           
realizar cambio para los que ingresan sin panel y con panel          
*/
	-- identificar si trabaja con panel o no, si el numero de placa no se encuentra en la tabla CIT_PanelElectronico es por que no cuenta con panel          
	--SELECT * FROM CIT_PanelElectronico          
	
	SET @nroplaca = LTRIM(RTRIM(@nroplaca))
	
	IF EXISTS (
			SELECT 1
			FROM [DBO].[CIT_PanelElectronico]
			WHERE NRO_PLACA = @nroplaca
			)
	BEGIN --si cuenta con panel          
		BEGIN TRANSACTION [TRAN1]

		UPDATE C
		SET C.Fec_Des_Cita = @Fec_Des_Cita
			,C.Cod_Estado = 'DES'
		FROM dbo.CIT_Cita C
		--INNER JOIN dbo.CIT_OrdenRetiro O ON (C.Nro_Orden_Retiro = O.Nro_Orden_Retiro)        
		INNER JOIN dbo.CIT_OrdenRetiro O ON ISNULL(SUBSTRING((C.Nu_OrdenRetiro_AsociaCita collate SQL_Latin1_General_CP1_CI_AS), 1, 6), '') = SUBSTRING(O.Nro_Orden_Retiro, 1, 6)
		--AND ISNULL(LTRIM(RTRIM(C.Nu_Placa_Asociado collate SQL_Latin1_General_CP1_CI_AS)), '') = LTRIM(RTRIM(O.Nro_Placa))  
		LEFT JOIN dbo.CIT_PanelElectronico PE ON ltrim(rtrim(PE.Nro_Placa)) = ltrim(rtrim(C.Nu_Placa_Asociado collate SQL_Latin1_General_CP1_CI_AS))
			--INNER JOIN dbo.CIT_PanelElectronico PE ON PE.Nro_Placa = O.Nro_Placa        
			AND O.Cod_Estado = 'ACT'
			AND C.Cod_Estado = 'ENP'
		--AND PE.Cod_Estado = 'ING'        
		WHERE isnull(ltrim(rtrim(C.Nu_Placa_Asociado collate SQL_Latin1_General_CP1_CI_AS)), '') = @nroplaca

		UPDATE P
		SET P.Cod_Estado = 'SAL'
		FROM dbo.CIT_PanelElectronico P
		WHERE P.Nro_Placa = @nroplaca
			AND P.Cod_Estado = 'ING'

		IF @@ERROR = 0
			COMMIT TRANSACTION [TRAN1]
		ELSE
			ROLLBACK TRANSACTION [TRAN1]
	END
	ELSE
	BEGIN -- no panel          
		BEGIN TRANSACTION [TRAN2]

		UPDATE C
		SET C.Fec_Des_Cita = @Fec_Des_Cita
			,C.Cod_Estado = 'DES'
		FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_OrdenRetiro O ON ISNULL(SUBSTRING((C.Nu_OrdenRetiro_AsociaCita collate SQL_Latin1_General_CP1_CI_AS), 1, 6), '') = SUBSTRING(O.Nro_Orden_Retiro, 1, 6)
			--AND ISNULL(LTRIM(RTRIM(C.Nu_Placa_Asociado collate SQL_Latin1_General_CP1_CI_AS)), '') = LTRIM(RTRIM(O.Nro_Placa))  
			--INNER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro        
			AND O.Cod_Estado = 'ACT'
			AND C.Cod_Estado = 'ENP'
		WHERE isnull(ltrim(rtrim(C.Nu_Placa_Asociado collate SQL_Latin1_General_CP1_CI_AS)), '') = @nroplaca

		--WHERE O.Nro_Placa = @nroplaca        
		UPDATE dbo.CIT_EnvioSparcTemporal
		SET Atendido = 1
			,Fec_Salida = @Fec_Des_Cita
		WHERE Nro_Placa = @nroplaca
			AND Enviado = 1
			AND Atendido = 0

		IF @@ERROR = 0
			COMMIT TRANSACTION [TRAN2]
		ELSE
			ROLLBACK TRANSACTION [TRAN2]
	END
END --FIN DE PROCEDURE          
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarHistoricoParametroXFecha]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------    
-- Nombre: [CIT_ActualizarHistoricoParametroXFecha]    
-- Objetivo: Actualiza Histórico de Parámetros    
-- Valores Prueba:    
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608    
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608    
-- Modificacion : Juan Carlos Urrelo Chunga - 20100930    
-- Modificación: Enrique Véliz Guardia - 20110128    
---------------------------------------------------------------------------------    
ALTER PROCEDURE [dbo].[CIT_ActualizarHistoricoParametroXFecha] (
	@Fecha DATETIME
	,@MotivoRegistro VARCHAR(3)
	)
AS
BEGIN
	--1)Actualiza Paràmetros    
	-- Modificacion por tiempo de tolerancia modificado por JCUCH    
	DECLARE @TiempoTolerancia INT

	SELECT @TiempoTolerancia = CAST(Valor_Parametro AS INT)
	FROM CIT_PARAMETRO
	WHERE COD_PARAMETRO = 1 -- Tiempo de tolerancia    

	DECLARE @FlagExiste INT

	SELECT @FlagExiste = COUNT(*)
	FROM CIT_ParametroXHistorico
	WHERE Fec_Historica = @Fecha

	IF @FlagExiste = 0
	BEGIN
		INSERT INTO CIT_ParametroXHistorico
		SELECT Cod_Parametro
			,@Fecha
			,Des_Parametro
			,Valor_Parametro
			,GETDATE()
			,Usuario_Registro
			,@MotivoRegistro
		FROM CIT_Parametro
	END

	--2)Anula Citas que cumplan las siguientes condiciones:    
	--a)Citas que tengan estado Registrado y que la fecha y hora de turno ya expiró.    
	DECLARE @CanAnularCitaReg INT
	DECLARE @TablaAnularCitaReg TABLE (
		Row INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
		,Ident_Cita INT
		)

	INSERT INTO @TablaAnularCitaReg
	SELECT Ident_Cita
	FROM CIT_Cita C
	INNER JOIN CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	WHERE C.Cod_Estado = 'VEN'
		AND CONVERT(VARCHAR(10), T.Fec_Turno, 112) <= CONVERT(VARCHAR(10), GETDATE(), 112)
		AND DATEADD(mi, CASE 
				WHEN @MotivoRegistro = 'JOB'
					THEN 0
				ELSE @TiempoTolerancia
				END, CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 7, 5) + ':00', 120)) <= GETDATE()

	DECLARE @contCitaReg INT
	DECLARE @maxCitaReg INT

	SET @contCitaReg = 1

	SELECT @maxCitaReg = COUNT(*)
	FROM @TablaAnularCitaReg

	WHILE @contCitaReg <= @maxCitaReg
	BEGIN
		DECLARE @Ident_CitaReg INT

		SELECT @Ident_CitaReg = Ident_Cita
		FROM @TablaAnularCitaReg
		WHERE Row = @contCitaReg

		EXEC CIT_AnularCita_NEW @Ident_CitaReg

		SET @contCitaReg = @contCitaReg + 1
	END

	--b)Citas que tengan estado Facturado, que la fecha y hora de turno ya expiró y que la fecha de vigencia         
	--  sea menor o igual a la hora de ejecución del job.        
	DECLARE @CanAnularCitaFac INT
	DECLARE @TablaAnularCitaFac TABLE (
		Row INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
		,Ident_Cita INT
		)

	INSERT INTO @TablaAnularCitaFac
	SELECT Ident_Cita
	FROM CIT_Cita C
	INNER JOIN CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	LEFT JOIN CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
	WHERE C.Cod_Estado = 'VEN'
		AND CONVERT(VARCHAR(10), T.Fec_Turno, 112) <= CONVERT(VARCHAR(10), GETDATE(), 112)
		AND DATEADD(mi, CASE 
				WHEN @MotivoRegistro = 'JOB'
					THEN 0
				ELSE @TiempoTolerancia
				END, CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 7, 5) + ':00', 120)) <= GETDATE()

	--AND  (O.Fec_Vig_Orden_Retiro IS NULL OR CONVERT(varchar(10),O.Fec_Vig_Orden_Retiro,112) <= CONVERT(varchar(10),GETDATE(),112))    
	DECLARE @contCitaFac INT
	DECLARE @maxCitaFac INT

	SET @contCitaFac = 1

	SELECT @maxCitaFac = COUNT(*)
	FROM @TablaAnularCitaFac

	WHILE @contCitaFac <= @maxCitaFac
	BEGIN
		DECLARE @Ident_CitaFac INT

		SELECT @Ident_CitaFac = Ident_Cita
		FROM @TablaAnularCitaFac
		WHERE Row = @contCitaFac

		EXEC CIT_AnularCita_NEW @Ident_CitaFac

		SET @contCitaFac = @contCitaFac + 1
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarHistoricoParametroXFecha_Antiguo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
    
---------------------------------------------------------------------------------    
-- Nombre: [CIT_ActualizarHistoricoParametroXFecha]    
-- Objetivo: Actualiza Histórico de Parámetros    
-- Valores Prueba:     
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608    
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608    
--Modificacion : Juan Carlos Urrelo Chunga - 20100930  
---------------------------------------------------------------------------------    
    
ALTER PROCEDURE [dbo].[CIT_ActualizarHistoricoParametroXFecha_Antiguo]     
 @Fecha datetime,    
 @MotivoRegistro Varchar(3)    
AS    
BEGIN    
/*    
 DECLARE @Fecha datetime    
 SET @Fecha = CONVERT(Varchar,GETDATE(),112)    
*/    
    
-- SELECT @FlagExiste = COUNT(*)    
-- FROM CIT_CapacidadMaximaAtencionTurnoXHistorico    
-- WHERE Fec_Historica = @Fecha    
--    
-- IF (@FlagExiste=0)    
-- BEGIN    
--  INSERT INTO dbo.CIT_CapacidadMaximaAtencionTurnoXHistorico    
--  SELECT    
--   Ident_AtencionTurno,    
--   Fecha_Capacidad,    
--   'JOB'    
--  FROM dbo.CIT_CapacidadMaximaAtencionTurno    
--  WHERE Fecha_Capacidad = @Fecha    
-- END    
    
--1) Actualiza Paràmetros    
 --Modificacion por tiempo de tolerancia modificado por JCUCH
 
 DECLARE @TiempoTolerancia int,
         @Resto INT,
         @TiempoToleranciaFinal INT
 SELECT  @TiempoTolerancia=valor_parametro 
 FROM CIT_PARAMETRO
 WHERE COD_PARAMETRO=1 -- Tiempo de tolerancia
 

 SET @Resto = @TiempoTolerancia % 60 

SET @TiempoToleranciaFinal=(SELECT CASE WHEN @Resto = 0 THEN

@TiempoTolerancia / 60

ELSE

(@TiempoTolerancia/60) + cast((@TiempoTolerancia)as decimal(3))/100

END AS CALCULO)
 
 
 
 --
 
    
 DECLARE @FlagExiste int    
    
 SELECT @FlagExiste = COUNT(*)    
 FROM dbo.CIT_ParametroXHistorico    
 WHERE Fec_Historica = @Fecha    
    
 IF (@FlagExiste=0)    
 BEGIN    
  INSERT INTO dbo.CIT_ParametroXHistorico    
  SELECT    
   Cod_Parametro,    
   @Fecha,    
   Des_Parametro,    
   Valor_Parametro,    
   GETDATE(),    
   Usuario_Registro,    
   @MotivoRegistro    
  FROM dbo.CIT_Parametro    
 END    
    
--2) Anula Citas que cumplan las siguientes condiciones:    
--a) Citas que tengan estado Registrado y que la fecha y hora de turno ya expiró.    
    
DECLARE @CanAnularCitaReg Int,    
  @IdentCita Int    
    
SELECT @CanAnularCitaReg = COUNT(*)     
FROM dbo.CIT_Cita C    
INNER JOIN dbo.CIT_Turno T ON    
 C.Ident_Turno = T.Ident_Turno    
WHERE C.Cod_Estado = 'REG' AND    
  CONVERT(Varchar,T.Fec_Turno,112) <= CONVERT(Varchar,GETDATE(),112)    
  AND CONVERT(Decimal(6,2),SUBSTRING(T.Des_Turno,7,2)+'.'+SUBSTRING(T.Des_Turno,10,2))+ @TiempoToleranciaFinal<=CONVERT(DECIMAL(6,2),SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),1,2)+'.'+SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),4,2)) --Adicionar validacion JCUCH  
WHILE (@CanAnularCitaReg>0)    
BEGIN    
 SET @CanAnularCitaReg = @CanAnularCitaReg - 1    
 SELECT TOP 1 @IdentCita = Ident_Cita    
 FROM dbo.CIT_Cita C    
 INNER JOIN dbo.CIT_Turno T ON    
  C.Ident_Turno = T.Ident_Turno    
 WHERE C.Cod_Estado = 'REG' AND    
   CONVERT(Varchar,T.Fec_Turno,112) <= CONVERT(Varchar,GETDATE(),112)   
    AND CONVERT(Decimal(6,2),SUBSTRING(T.Des_Turno,7,2)+'.'+SUBSTRING(T.Des_Turno,10,2))+@TiempoToleranciaFinal<=CONVERT(DECIMAL(6,2),SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),1,2)+'.'+SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),4,2)) --Adicionar validacion JCUCH  
 ORDER BY 1    
    
 EXEC dbo.CIT_AnularCita @IdentCita  --Comentado por pedido del Usuario  
END    
    
--b) Citas que tengan estado Facturado, que la fecha y hora de turno ya expiró y que la fecha de vigencia     
--sea menor o igual a la hora de ejecución del job.    
    
DECLARE @CanAnularCitaFac Int    
    
SELECT @CanAnularCitaFac = COUNT(*)    
FROM dbo.CIT_Cita C    
INNER JOIN dbo.CIT_Turno T ON    
 C.Ident_Turno = T.Ident_Turno    
LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON    
 C.Nro_Orden_Retiro = O.Nro_Orden_Retiro    
WHERE C.Cod_Estado = 'FAC' AND    
  CONVERT(Varchar,T.Fec_Turno,112) <= CONVERT(Varchar,GETDATE(),112) AND   
    CONVERT(Decimal(6,2),SUBSTRING(T.Des_Turno,7,2)+'.'+SUBSTRING(T.Des_Turno,10,2))+@TiempoToleranciaFinal<=CONVERT(DECIMAL(6,2),SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),1,2)+'.'+SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),4,2)) AND --Adicionar validacion JCUCH  
  ( CONVERT(Varchar,O.Fec_Vig_Orden_Retiro,112) <= CONVERT(Varchar,GETDATE(),112) OR    
   O.Fec_Vig_Orden_Retiro IS NULL)    
    
WHILE (@CanAnularCitaFac>0)    
BEGIN    
 SET @CanAnularCitaFac = @CanAnularCitaFac - 1    
 SELECT TOP 1 @IdentCita = Ident_Cita    
 FROM dbo.CIT_Cita C     INNER JOIN dbo.CIT_Turno T ON    
  C.Ident_Turno = T.Ident_Turno    
 LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON    
  C.Nro_Orden_Retiro = O.Nro_Orden_Retiro    
 WHERE C.Cod_Estado = 'FAC' AND    
   CONVERT(Varchar,T.Fec_Turno,112) <= CONVERT(Varchar,GETDATE(),112) AND    
  CONVERT(Decimal(6,2),SUBSTRING(T.Des_Turno,7,2)+'.'+SUBSTRING(T.Des_Turno,10,2))+@TiempoToleranciaFinal<=CONVERT(DECIMAL(6,2),SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),1,2)+'.'+SUBSTRING(CONVERT(VARCHAR,GETDATE(),108),4,2)) AND --Adicionar validacion JCUCH  
 ( CONVERT(Varchar,O.Fec_Vig_Orden_Retiro,112) <= CONVERT(Varchar,GETDATE(),112) OR    
    O.Fec_Vig_Orden_Retiro IS NULL)    
    
 EXEC dbo.CIT_AnularCita @IdentCita  --Comentado a Pedido del Usuario  
END    
    
END    
    
    
    
    
    
    
    
    
    
    
    
  
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarLogProcesoTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 03/12/2014
-- Description:	ACTUALIZA LA INFORMACIÓN DE PROCESADO DE ACUERDO AL TURNO
-- EXEC CIT_ActualizarLogProcesoTurno '20141204','20:00-22:00'
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ActualizarLogProcesoTurno]
@p_Fec_Turno DATETIME,
@p_Des_Turno VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @v_Fec_Actual DATETIME,
			@v_Fec_Hor_Turno DATETIME

	SET @v_Fec_Actual = GETDATE()
	SET @v_Fec_Hor_Turno = CONVERT(DATETIME, CONVERT(VARCHAR(10),@p_Fec_Turno,112) + ' ' + SUBSTRING(@p_Des_Turno,1,5)) 

	UPDATE CIT_LogProcesoTurno
	SET 
		Procesado = 1,
		Fec_Fin_Proceso = @v_Fec_Actual
	WHERE 
	Fec_Turno = @v_Fec_Hor_Turno
	AND Procesado = 0
	AND Fec_Fin_Proceso IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarLogProcesoVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 03/12/2014
-- Description:	ACTUALIZA LA INFORMACIÓN DE PROCESADO DE ACUERDO AL VOLANTE
-- EXEC CIT_ActualizarLogProcesoVolante '555420'
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ActualizarLogProcesoVolante]
@p_Cod_Volante VARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @v_Fec_Actual DATETIME
	SET @v_Fec_Actual = GETDATE()

	UPDATE CIT_LogProcesoVolante
	SET 
		Procesado = 1,
		Fec_Fin_Proceso = @v_Fec_Actual
	WHERE 
	Cod_Volante = @p_Cod_Volante
	AND Procesado = 0
	AND Fec_Fin_Proceso IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarNroMovimientosXOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------
-- Nombre: [CIT_ActualizarNroMovimientosXOrdenRetiro]
-- Objetivo: Actualiza Nro de Movimientos y Ruma X Orden de Retiro
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100603
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100603
---------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_ActualizarNroMovimientosXOrdenRetiro]
@p_NroOrdenRetiro	Varchar(10)
AS
BEGIN

	DECLARE @NroMovimientos int,
			@Ruma			varchar(3),
			@CodContenedor	varchar(11)

	SELECT
		@CodContenedor = C.Cod_Contenedor
	FROM dbo.CIT_Cita C
	WHERE	
	C.Nro_Orden_Retiro = @p_NroOrdenRetiro 
	AND	C.Cod_Estado = 'FAC'	

	CREATE TABLE #NROMOVIMIENTOS (Ruma Varchar(3), NroMovimientos Varchar(2))

	INSERT INTO #NROMOVIMIENTOS (Ruma, NroMovimientos)	
	EXEC SN_NEPT_CIT_MovimientosXContenedor @CodContenedor
	--EXEC NEPTUNIABK1.TERMINAL.dbo.CIT_MovimientosXContenedor @CodContenedor

	IF ((SELECT COUNT(*) FROM #NROMOVIMIENTOS)>0)
	BEGIN
		SELECT TOP 1
			@Ruma = [Ruma],
			@NroMovimientos = [NroMovimientos]
		FROM #NROMOVIMIENTOS
	END
	ELSE
	BEGIN
		SET @Ruma = NULL
		SET @NroMovimientos = 99
	END

	UPDATE P
	SET
		P.NroMovimientos = CASE WHEN ISNUMERIC(@NroMovimientos) = 0 THEN 99 ELSE @NroMovimientos END,
		P.Ruma = LEFT(RTRIM(LTRIM(@Ruma)),2)
	FROM dbo.CIT_PanelElectronico P
	WHERE P.Nro_Orden_Retiro = @p_NroOrdenRetiro

	DROP TABLE #NROMOVIMIENTOS

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarNumeroPlaca]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----------------------------------------------------------------------
-- Nombre: CIT_ActualizarNumeroPlaca
-- Objetivo: Actualiza el numero de placa del camion cuando se realiza su ingreso via movil.  
-- Creacion: Nelson I. Cuba Ramos - Gesfor Perú - 20100528
-- Modificacion: Nelson I. Cuba Ramos - Gesfor Perú - 20100528
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarNumeroPlaca]
	@p_Nro_Orden_Retiro				Varchar(10),		--Número de Orden de Retiro
	@p_Nro_Placa					Varchar(10)			--Número de Placa del Camión
AS
BEGIN

--Insertar el numero de placa
	
	UPDATE dbo.CIT_OrdenRetiro
	SET Nro_Placa = @p_Nro_Placa
	WHERE Nro_Orden_Retiro = @p_Nro_Orden_Retiro

END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarOrdenamientoContenedorXCodContenedor]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--------------------------------------------------------------------
-- Nombre: CIT_ActualizarOrdenamientoContenedorXCodContenedor
-- Objetivo: Actualiza Orden de Contenedor por Código de Contenedor
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100524
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100524
--------------------------------------------------------------------


ALTER PROCEDURE [dbo].[CIT_ActualizarOrdenamientoContenedorXCodContenedor]
	@p_Cod_Volante		Varchar(6),		--Nro. de Volante
	@p_Cod_Contenedor	Varchar(11),		--Identificador de Contenedor
	@p_Ord_Contenedor	Int
AS
BEGIN
	UPDATE C
	SET
		C.Ord_Contenedor = CASE WHEN @p_Ord_Contenedor=99 THEN NULL ELSE @p_Ord_Contenedor END
	FROM dbo.CIT_Contenedor C
	WHERE	C.Cod_Volante = @p_Cod_Volante AND
			C.Cod_Contenedor = @p_Cod_Contenedor
END




GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarPesoAbreviaturaXParametro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
-- Nombre: CIT_ActualizarPesoAbreviaturaXParametro
-- Objetivo: Actualiza Peso Abreviatura por actualización de Parámetros de Proporción
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100603
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100603
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarPesoAbreviaturaXParametro]
AS
BEGIN

	DECLARE @ProporcionCita			int,
			@ProporcionNoCita		int,
			@ProporcionIntegral		int,
			@ProporcionNoIntegral	int,
			@ProporcionPuntual		int,
			@ProporcionNoPuntual	int

	DECLARE @SumaCitaNoCita			int,
			@SumaIntegralNoIntegral	int,
			@SumaPuntualNoPuntual	int

	DECLARE @PesoCita				decimal(18,7),
			@PesoNoCita				decimal(18,7),
			@PesoIntegral			decimal(18,7),
			@PesoNoIntegral			decimal(18,7),
			@PesoPuntual			decimal(18,7),
			@PesoNoPuntual			decimal(18,7)

	DECLARE @PesoCIP				decimal(18,7),
			@PesoCINP				decimal(18,7),
			@PesoCNIP				decimal(18,7),
			@PesoCNINP				decimal(18,7),
			@PesoNCI				decimal(18,7),
			@PesoNCNI				decimal(18,7)

	--1) Obtenemos valores de parámetros
	SELECT @ProporcionCita = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 12
	SELECT @ProporcionNoCita = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 13
	SELECT @ProporcionIntegral = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 15
	SELECT @ProporcionNoIntegral = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 16
	SELECT @ProporcionPuntual = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 10
	SELECT @ProporcionNoPuntual = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 11

	--2) Calculamos sumas de proporción
	SET @SumaCitaNoCita = @ProporcionCita + @ProporcionNoCita
	SET @SumaIntegralNoIntegral = @ProporcionIntegral + @ProporcionNoIntegral
	SET @SumaPuntualNoPuntual = @ProporcionPuntual + @ProporcionNoPuntual

	--3) Calculamos peso por cada parámetro
	SET @PesoCita = CONVERT(decimal(18,7),@ProporcionCita) / CONVERT(decimal(18,7),@SumaCitaNoCita)
	SET @PesoNoCita = CONVERT(decimal(18,7),@ProporcionNoCita) / CONVERT(decimal(18,7),@SumaCitaNoCita)
	SET @PesoIntegral = CONVERT(decimal(18,7),@ProporcionIntegral) / CONVERT(decimal(18,7),@SumaIntegralNoIntegral)
	SET @PesoNoIntegral = CONVERT(decimal(18,7),@ProporcionNoIntegral) / CONVERT(decimal(18,7),@SumaIntegralNoIntegral)
	SET @PesoPuntual = CONVERT(decimal(18,7),@ProporcionPuntual) / CONVERT(decimal(18,7),@SumaPuntualNoPuntual)
	SET @PesoNoPuntual = CONVERT(decimal(18,7),@ProporcionNoPuntual) / CONVERT(decimal(18,7),@SumaPuntualNoPuntual)

	--4) Calculamos peso por combinaciones
	SET @PesoCIP = @PesoCita * @PesoIntegral * @PesoPuntual
	SET @PesoCINP = @PesoCita * @PesoIntegral * @PesoNoPuntual
	SET @PesoCNIP = @PesoCita * @PesoNoIntegral * @PesoPuntual
	SET @PesoCNINP = @PesoCita * @PesoNoIntegral * @PesoNoPuntual
	SET @PesoNCI = @PesoNoCita * @PesoIntegral
	SET @PesoNCNI = @PesoNoCita * @PesoNoIntegral


	UPDATE G SET ValorCampo = @PesoCIP FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'CIP'
	UPDATE G SET ValorCampo = @PesoCINP FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'CINP'
	UPDATE G SET ValorCampo = @PesoCNIP FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'CNIP'
	UPDATE G SET ValorCampo = @PesoCNINP FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'CNINP'
	UPDATE G SET ValorCampo = @PesoNCI FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'NCI'
	UPDATE G SET ValorCampo = @PesoNCNI FROM dbo.PAR_Tabla_Generica G WHERE CodlCampo = 'NCNI'

END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarPrioridadXOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- Nombre: CIT_ActualizarPrioridadXOrdenRetiro
-- Objetivo: Actualiza Prioridad por Orden de Retiro
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100617
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100617
--------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_ActualizarPrioridadXOrdenRetiro] 
@sOrdenRetiro Varchar(10)
AS
BEGIN

	DECLARE @CodPanel Varchar(10),
			@CodCita Varchar(10),
			@CodIntegral Varchar(10),
			@CodPuntual Varchar(10),
			@nFlagCita bit,
			@nFlagIntegral bit,
			@nFlagPuntual bit,
			@nTiempoTolerancia int,
			@dHoraInicioPuntual Datetime,			
			@dHoraFinPuntual Datetime,
			@dHoraFinNoPuntual Datetime

	--P1) Consultamos si tiene Cita
	-------------------------------

	SELECT @nFlagCita = COUNT(Ident_Cita)
	FROM dbo.CIT_Cita C
	INNER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	WHERE	
	CONVERT(Varchar(8),T.Fec_Turno,112) = CONVERT(Varchar(8),GETDATE(),112) 
	AND C.Cod_Estado = 'FAC' 
	AND C.Nro_Orden_Retiro = @sOrdenRetiro

	SET @CodCita = CASE WHEN @nFlagCita > 0 THEN 'C' ELSE 'NC' END

	--P2) Consultamos si es Integral
	--------------------------------

	SELECT @nFlagIntegral = P.Integral
	FROM dbo.CIT_PanelElectronico P
	WHERE	P.Nro_Orden_Retiro = @sOrdenRetiro

	SET @CodIntegral = CASE WHEN @nFlagIntegral > 0 THEN 'I' ELSE 'NI' END

	--P3) Consultamos si es Puntual en caso tenga Cita
	--------------------------------------------------

	SELECT @nTiempoTolerancia = Valor_Parametro
	FROM dbo.CIT_Parametro
	WHERE 
	Cod_Parametro = 1

	SELECT
		@dHoraInicioPuntual = CONVERT(Varchar(8),GETDATE(),112) + ' ' + LEFT(T.Des_Turno,5) + ':00',
		@dHoraFinPuntual = CONVERT(Varchar(8),GETDATE(),112) + ' ' + RIGHT(T.Des_Turno,5) + ':00',
		@dHoraFinNoPuntual = DATEADD(mi,@nTiempoTolerancia,CONVERT(Varchar(8),GETDATE(),112) + ' ' + RIGHT(T.Des_Turno,5) + ':00')
	FROM dbo.CIT_Cita C
	INNER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	WHERE	
	CONVERT(Varchar(8),T.Fec_Turno,112) = CONVERT(Varchar(8),GETDATE(),112) 
	AND C.Cod_Estado = 'FAC' 
	AND C.Nro_Orden_Retiro = @sOrdenRetiro

	SET @CodPuntual =	CASE
							WHEN GETDATE() < @dHoraInicioPuntual THEN 'P'
							WHEN GETDATE() BETWEEN @dHoraInicioPuntual AND @dHoraFinPuntual THEN 'P' 
							WHEN GETDATE() BETWEEN @dHoraFinPuntual AND @dHoraFinNoPuntual THEN 'NP'							
						ELSE 'NP' END

	SET @CodCita =		CASE
							WHEN GETDATE() > @dHoraFinNoPuntual THEN 'NC'
							ELSE @CodCita
						END

	SET @CodPanel =		@CodCita + @CodIntegral + CASE WHEN @CodCita = 'C' THEN @CodPuntual ELSE '' END

	UPDATE P
	SET
		P.Abreviatura = @CodPanel,
		P.PesoAbreviatura = G.ValorCampo
	FROM dbo.CIT_PanelElectronico P
	INNER JOIN dbo.PAR_Tabla_Generica G ON G.Ident_Tabla = 5 AND G.CodlCampo = @CodPanel
	WHERE 
	Nro_Orden_Retiro = @sOrdenRetiro

	--Actualiza Nro de Movimientos y Ruma
	EXEC [CIT_ActualizarNroMovimientosXOrdenRetiro] @sOrdenRetiro	

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarSucursal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ActualizarSucursal]
	@codigo int,
	@Nombre varchar(100)
AS
BEGIN
	update [dbo].[CIT_Sucursal]
	set			[Nombre] = @Nombre
	where codigo = @codigo
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarValorParametro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
-- Nombre: CIT_ActualizarValorParametro
-- Objetivo: Actualiza Valor de Parámetro
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ActualizarValorParametro]
	@p_Cod_Parametro		int,				--Código de Parámetro
	@p_Valor_Parametro		varchar(50),		--Valor de Parámetro
	@p_Usuario_Registro		varchar(50)			--Usuario quien registra Parámetro
AS
BEGIN

	UPDATE P
	SET
		P.Valor_Parametro = @p_Valor_Parametro,
		P.Fecha_Registro = GETDATE(),
		P.Usuario_Registro = @p_Usuario_Registro
	FROM dbo.CIT_Parametro P
		WHERE P.Cod_Parametro = @p_Cod_Parametro

	IF (@p_Cod_Parametro IN (10,11,12,13,15,16))
		EXEC CIT_ActualizarPesoAbreviaturaXParametro

END



GO
/****** Object:  StoredProcedure [dbo].[CIT_ActualizarVistaPanelElectronico]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- Nombre: [CIT_ActualizarVistaPanelElectronico]  

-- Objetivo: Actualiza Vista de Panel Electrónico  

-- Valores Prueba:   

-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100604  

-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100604  

-------------------------------------------------------------------------  

ALTER PROCEDURE [dbo].[CIT_ActualizarVistaPanelElectronico]  

AS  

BEGIN  

  

 DECLARE @sSQL      Varchar(8000)  

  

 DECLARE @nNumeroTopCamiones   INT,  

   @nNumeroMaxCamionesEnPatio INT,  

   @nNumeroCamionesIngresados INT,  

   @bActivarPanelElectronico INT,  

   @ContarVista    INT,  

            @NumeroBalancero   INT,  

   @ContadorBalancero   INT  

  

 --Obtenemos valores de parámetros  

  

 --Número de camiones que como máximo estarán en patio (Almacén)  

 SELECT @nNumeroMaxCamionesEnPatio = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 18  

  

 --Flag de activación de Panel Electrónico  

 SELECT @bActivarPanelElectronico = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 17  

  

 --Calculamos la cantidad de camiones en el turno que se encuentran en cola  

 SELECT @nNumeroTopCamiones = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 14 --(Desde Parámetro)  

  

 -- Tiempo máximo de demora del balancero en atender a un contenedor  

  

 SELECT @NumeroBalancero = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 21  

  

  

 --Obtenemos Número de Camiones en Almacén que están siendo atendidos  

  

 SELECT @nNumeroCamionesIngresados = COUNT(Ident_Panel_Electronico)   

 FROM dbo.CIT_PanelElectronico P  

 WHERE P.Cod_Estado = 'ING'  

 AND CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)  

  

 --Reiniciamos el Panel Electrónico Temporal para fechas pasadas  

 DELETE P    

 FROM CIT_PanelElectronicoTemporal P  

 WHERE CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) <> CONVERT(Varchar(8),GETDATE(),112)  

  

  

 IF (@bActivarPanelElectronico = 1) --Solo ejecutamos en el caso esté activo el Flag de Panel Electrónico  

 BEGIN  

    

  PRINT 'ACTIVAR PANEL'  

    

  --Limpiamos la vista temporal   NICR  20101007   

  /*BORRAN DE LA TABLA DE PANEL TEMPORAL TODOS AQUELLOS REGISTROS QUE YA SE HAYAN INSERTADOS PARA POSTERIORMENTE  

  VOLVER A SER AÑADIDOS A LA TABLA*/  

  

  

  DELETE C  

  FROM CIT_PanelElectronicoTemporal C  

  WHERE   

  C.Ident_Panel_Electronico IN (  

   SELECT Ident_Panel_Electronico   

   FROM CIT_PanelElectronico   

   WHERE Cod_Estado='ING'  

  )  

  

  --1) Cargamos Lista de Camiones Atendidos  

  SET @sSQL = '  

   INSERT INTO CIT_PanelElectronicoTemporal  

   (  

    Ident_Panel_Electronico,  

    NroLlamadas,  

    Nro_Placa,  

    Nro_Orden_Retiro,  

    Fec_Reg_Panel_Electronico,  

    Abreviatura,  

    NroMovimientos,  

    Ruma  

   )  

   SELECT   

    P.Ident_Panel_Electronico,  

    0,  

    P.Nro_Placa,  

    P.Nro_Orden_Retiro,  

    P.Fec_Reg_Panel_Electronico,  

    P.Abreviatura,  

    P.NroMovimientos,  

    P.Ruma  

   FROM dbo.CIT_PanelElectronico P  

   INNER JOIN (  

    SELECT TOP @nNumeroTopCamiones P.*   

    FROM dbo.CIT_PanelElectronico P   

    LEFT OUTER JOIN CIT_PanelElectronicoTemporal T ON P.Ident_Panel_Electronico = T.Ident_Panel_Electronico   

    WHERE   

    Cod_Estado = ''COL''   

    AND CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)   

    AND T.Ident_Panel_Electronico IS NULL   

    ORDER BY P.Fec_Reg_Panel_Electronico ASC  

   ) O ON P.Ident_Panel_Electronico = O.Ident_Panel_Electronico  

   WHERE   

   CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)  

   ORDER BY P.PesoAbreviatura DESC, P.NroMovimientos ASC'  

  

  SET @sSQL = REPLACE(@sSQL,'@nNumeroTopCamiones',@nNumeroTopCamiones)  

  

  --Si es que no existe lista de camiones a llamar  

  IF ((SELECT COUNT(*) FROM dbo.CIT_PanelElectronicoTemporal P WHERE CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)) = 0)  

  BEGIN  

   PRINT 'NO HAY NINGUNA INFO EN PANEL TEMPORAL'  

   DBCC CHECKIDENT (CIT_PanelElectronicoTemporal, RESEED,0)  

   EXEC(@sSQL)  

  END  

  

  --Si es que ya se llamaron a todos los camiones más de 2 veces entonces se cargará una nueva lista  

  IF ((SELECT MIN(NroLlamadas) FROM dbo.CIT_PanelElectronicoTemporal P WHERE CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)) >= 2)  

  BEGIN  

   PRINT 'YA SE LLAMARON MÁS DE DOS VECES'  

   EXEC(@sSQL)  

  END  

  

  --Cuando se exeda el número de máquinas para atención (Brazos mecánicos) debe paralizar la operación    

  

  SELECT TOP 1 @ContadorBalancero=DATEDIFF(mi,Fec_Reg_Primera_Llamada,getdate())   

  FROM CIT_PanelElectronicoTemporal C   

  ORDER BY C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico  

  

        IF (@ContadorBalancero IS NULL)  

  BEGIN  

   /*SI EL NÚMERO DE CAMIONES INGRESADOS ES MENOR QUE EL NÚMERO DE CAMIONES EN PATIO CONFIGURADO*/  

   IF (@nNumeroCamionesIngresados < @nNumeroMaxCamionesEnPatio)   

   BEGIN  

  

    --Actualizar Fecha de Registro de Última llamada  

    UPDATE C  

    SET  

     C.NroLlamadas = C.NroLlamadas + 1,  

     C.Fec_Reg_Ultima_Llamada = GETDATE()  

    FROM CIT_PanelElectronicoTemporal C   

    WHERE   

    C.Ident_Panel_Electronico = (  

      SELECT TOP 1 C.Ident_Panel_Electronico   

      FROM CIT_PanelElectronicoTemporal C   

      ORDER BY C.Fec_Reg_Ultima_Llamada , C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico)   

    AND C.Fec_Reg_Primera_Llamada IS NOT NULL  

  

    --Actualizar Fecha de Registro de Primera llamada  

    UPDATE C  

    SET  

     C.NroLlamadas = C.NroLlamadas + 1,  

     C.Fec_Reg_Primera_Llamada = GETDATE(),  

     C.Fec_Reg_Ultima_Llamada = GETDATE()  

    FROM CIT_PanelElectronicoTemporal C   

    WHERE C.Ident_Panel_Electronico = (  

      SELECT TOP 1 C.Ident_Panel_Electronico  

      FROM CIT_PanelElectronicoTemporal C   

      ORDER BY C.Fec_Reg_Ultima_Llamada , C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico  

    )  

    AND C.Fec_Reg_Primera_Llamada IS NULL  

  

    --Actualizar Datos en Registro de Panel Electrónico  

    UPDATE P  

    SET  

     P.Fec_Reg_Primera_Llamada = T.Fec_Reg_Primera_Llamada,  

     P.Fec_Reg_Ultima_Llamada = T.Fec_Reg_Ultima_Llamada,  

     P.NroLlamadas = T.NroLlamadas  

    FROM dbo.CIT_PanelElectronico P  

    INNER JOIN dbo.CIT_PanelElectronicoTemporal T ON P.Ident_Panel_Electronico = T.Ident_Panel_Electronico  

    WHERE   

    CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)  

  

    --Si es que ya se ha llamado al vehículo por más de una hora entonces será eliminado de la lista de camiones llamados  

    UPDATE P  

    SET  

     P.Cod_Estado = 'RET'  

    FROM dbo.CIT_PanelElectronico P  

    INNER JOIN dbo.CIT_PanelElectronicoTemporal T ON P.Ident_Panel_Electronico = T.Ident_Panel_Electronico  

    WHERE   

    DATEDIFF(mi,T.Fec_Reg_Primera_Llamada, T.Fec_Reg_Ultima_Llamada)>=60      

  

  

    DELETE C  

    FROM CIT_PanelElectronicoTemporal C  

    WHERE DATEDIFF(mi,Fec_Reg_Primera_Llamada, Fec_Reg_Ultima_Llamada)>=60     

  

   END  

  END  

  ELSE  

  BEGIN  

   /*SI EL TIEMPO DE LA ÚLTIMA LLAMADA ATENCIÓN ES MAYOR AL PARÁMETRO DE CONFIGURACIÓN DE TIEMPO DE ATENCIÓN DEL BALANCERO*/  

   IF (@ContadorBalancero>@NumeroBalancero)  

   BEGIN  

    UPDATE C  

    SET  

     C.NroLlamadas = C.NroLlamadas + 1,  

     C.Fec_Reg_Ultima_Llamada = GETDATE()  

    FROM CIT_PanelElectronicoTemporal C   

    WHERE   

    C.Ident_Panel_Electronico = (  

      SELECT TOP 1 C.Ident_Panel_Electronico   

      FROM CIT_PanelElectronicoTemporal C  

      ORDER BY C.Fec_Reg_Ultima_Llamada , C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico  

    )  

    AND C.Fec_Reg_Primera_Llamada IS NOT NULL  

  

    --Actualizar Fecha de Registro de Primera llamada  

    UPDATE C  

    SET  

     C.NroLlamadas = C.NroLlamadas + 1,  

     C.Fec_Reg_Primera_Llamada = GETDATE(),  

     C.Fec_Reg_Ultima_Llamada = GETDATE()  

    FROM CIT_PanelElectronicoTemporal C   

    WHERE   

    C.Ident_Panel_Electronico = (  

      SELECT TOP 1 C.Ident_Panel_Electronico   

      FROM CIT_PanelElectronicoTemporal C   

      ORDER BY C.Fec_Reg_Ultima_Llamada , C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico  

    )   

    AND C.Fec_Reg_Primera_Llamada IS NULL  

  

    --Actualizar Datos en Registro de Panel Electrónico  

    UPDATE P  

    SET  

     P.Fec_Reg_Primera_Llamada = T.Fec_Reg_Primera_Llamada,  

     P.Fec_Reg_Ultima_Llamada = T.Fec_Reg_Ultima_Llamada,  

     P.NroLlamadas = T.NroLlamadas  

    FROM dbo.CIT_PanelElectronico P  

    INNER JOIN dbo.CIT_PanelElectronicoTemporal T ON P.Ident_Panel_Electronico = T.Ident_Panel_Electronico  

    WHERE   

    CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)  

  

    --Si es que ya se ha llamado al vehículo por más de una hora entonces será eliminado de la lista de camiones llamados  

    UPDATE P  

    SET  

     P.Cod_Estado = 'RET'  

    FROM dbo.CIT_PanelElectronico P  

    INNER JOIN dbo.CIT_PanelElectronicoTemporal T ON P.Ident_Panel_Electronico = T.Ident_Panel_Electronico  

    WHERE   

    DATEDIFF(mi,T.Fec_Reg_Primera_Llamada, T.Fec_Reg_Ultima_Llamada)>=@NumeroBalancero   

  

  

    DELETE C  

    FROM CIT_PanelElectronicoTemporal C  

    WHERE DATEDIFF(mi,Fec_Reg_Primera_Llamada, Fec_Reg_Ultima_Llamada)>=@NumeroBalancero  

  

  

   END  

  END  

  

  --Se actualiza la vista del Panel Electrónico con los valores obtenidos  

  DELETE CIT_PanelElectronicoVista  

  

  IF @nNumeroCamionesIngresados = @nNumeroMaxCamionesEnPatio  

  BEGIN  

   --En Almacen  

   INSERT INTO CIT_PanelElectronicoVista  

   (Ident_Panel_Electronico, Nro_Placa, Ruma, Habilitado)  

  

   SELECT TOP 1   

    Ident_Panel_Electronico,  

    Nro_Placa,  

    Ruma,  

    1  

   FROM dbo.CIT_PanelElectronico P  

   WHERE P.Cod_Estado = 'ING' AND  

   CONVERT(Varchar(8),P.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)  

   ORDER BY P.Fec_Reg_Ultima_Llamada DESC  

  END  

  ELSE  

  BEGIN  

  

         --En Cola  

   INSERT INTO CIT_PanelElectronicoVista  

   (Ident_Panel_Electronico, Nro_Placa, Ruma, Habilitado)  

   SELECT TOP 1   

    Ident_Panel_Electronico,  

    Nro_Placa,  

    Ruma,  

    1  

   FROM CIT_PanelElectronicoTemporal C  

   WHERE   

   CONVERT(Varchar(8),C.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112)     

   ORDER BY C.Fec_Reg_Ultima_Llamada DESC, C.NroLlamadas DESC, C.Orden_Atencion_Panel_Electronico --, C.Orden_Atencion_Panel_Electronico  

  END  

  

     SET @ContarVista = (SELECT COUNT(Nro_Placa) FROM CIT_PanelElectronicoVista)  

        IF  (@ContarVista=0)     

  BEGIN  

   INSERT INTO CIT_PanelElectronicoVista  

   (Ident_Panel_Electronico, Nro_Placa, Ruma, Habilitado)  

   SELECT '','','',1  

  END  

 END  

 ELSE  

 BEGIN  

  /*SI EL USO DEL PANEL ESTÁ INACTIVO ENTONCES NO SE MOSTRARÁ INFORMACIÓN EN ÉL*/  

  

  --Se actualiza la vista del Panel Electrónico con los valores obtenidos  

  DELETE CIT_PanelElectronicoVista  

  

  INSERT INTO CIT_PanelElectronicoVista  

  (Ident_Panel_Electronico, Nro_Placa, Ruma, Habilitado)  

  SELECT '','','',1  

 END   

END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_AnularCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------  
-- Nombre: CIT_AnularCita  
-- Objetivo: Anular Cita   
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100611  
-- SE AÑADIÓ LA LÓGICA PARA ACTUALIZAR EL CAMPO ORDEN DE LOS CONTENEDORES ADEMÁS DE LA LÓGICA DE ACTUALIZAR EL ESTADO DE LA OR
--------------------------------------------------------------------  
ALTER PROCEDURE [dbo].[CIT_AnularCita]  
@p_Ident_Cita   int 
AS  
BEGIN  
	DECLARE @IDENT_TURNO INT,
			@IDENT_CITAPADRE INT,

			@NRO_ORDENRETIRO VARCHAR(10),
			@NRO_CONTENEDOR VARCHAR(11)

	SELECT 
		@IDENT_TURNO = Ident_Turno, 
		@IDENT_CITAPADRE = Cod_Cita_Padre,
		@NRO_ORDENRETIRO = Nro_Orden_Retiro,
		@NRO_CONTENEDOR = Cod_Contenedor
	FROM dbo.CIT_Cita
	WHERE Ident_Cita = @p_Ident_Cita

	UPDATE  CIT_Cita  
	SET 
		Cod_Estado='ANU',
		Fec_Anu_Cita=GETDATE() 
	WHERE 
	Ident_Cita = @p_Ident_Cita  

	UPDATE CIT_Turno  
	SET 
		Cap_Disp_Turno = Cap_Disp_Turno + 1,  
		Cap_Res_Turno = Cap_Res_Turno - 1  
	WHERE 
	Ident_Turno = @IDENT_TURNO  

	UPDATE CIT_CitaPadre  
	SET 
		Cup_Res_Cita_Padre = Cup_Res_Cita_Padre - 1  
	WHERE 
	Cod_Cita_Padre = @IDENT_CITAPADRE  

	UPDATE C
	SET
		C.Ord_Contenedor = 99
	FROM dbo.CIT_Contenedor C
	INNER JOIN dbo.CIT_Cita I ON I.Cod_Volante = C.Cod_Volante
	WHERE 
	I.Ident_Cita = @p_Ident_Cita
	AND C.Cod_Contenedor = @NRO_CONTENEDOR

	UPDATE dbo.CIT_OrdenRetiro
	SET
		ConCita = 0
	WHERE 
	Nro_Orden_Retiro = @NRO_ORDENRETIRO
	AND Cod_Contenedor = @NRO_CONTENEDOR
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_AnularCita_NEW]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------      
-- Nombre: CIT_AnularCita      
-- Objetivo: Anular Cita       
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100611      
-- SE AÑADIÓ LA LÓGICA PARA ACTUALIZAR EL CAMPO ORDEN DE LOS CONTENEDORES ADEMÁS DE LA LÓGICA DE ACTUALIZAR EL ESTADO DE LA OR    
--------------------------------------------------------------------      
ALTER PROCEDURE [dbo].[CIT_AnularCita_NEW] @p_Ident_Cita INT  
AS  
BEGIN  
 DECLARE @IDENT_TURNO INT  
  ,@IDENT_CITAPADRE INT  
  ,@NRO_ORDENRETIRO VARCHAR(10)  
  ,@NRO_CONTENEDOR VARCHAR(11)  
  
 SELECT @IDENT_TURNO = Ident_Turno  
  ,@IDENT_CITAPADRE = Cod_Cita_Padre  
  ,@NRO_ORDENRETIRO = Nro_Orden_Retiro  
  ,@NRO_CONTENEDOR = Cod_Contenedor  
 FROM dbo.CIT_Cita  
 WHERE Ident_Cita = @p_Ident_Cita  

 UPDATE CIT_Cita  
 SET Cod_Estado = 'CAN'  
  ,Fec_Can_Cita = GETDATE()  
 WHERE Ident_Cita = @p_Ident_Cita  
  
 UPDATE CIT_Turno  
 SET Cap_Disp_Turno = Cap_Disp_Turno + 1  
  ,Cap_Res_Turno = Cap_Res_Turno - 1  
 WHERE Ident_Turno = @IDENT_TURNO  
  
 UPDATE CIT_CitaPadre  
 SET Cup_Res_Cita_Padre = Cup_Res_Cita_Padre - 1  
 WHERE Cod_Cita_Padre = @IDENT_CITAPADRE  
  
 UPDATE C  
 SET C.Ord_Contenedor = 99  
 FROM dbo.CIT_Contenedor C  
 INNER JOIN dbo.CIT_Cita I ON I.Cod_Volante = C.Cod_Volante  
 WHERE I.Ident_Cita = @p_Ident_Cita  
  AND C.Cod_Contenedor = @NRO_CONTENEDOR  
  
 UPDATE dbo.CIT_OrdenRetiro  
 SET ConCita = 0  
 WHERE Nro_Orden_Retiro = @NRO_ORDENRETIRO  
  AND Cod_Contenedor = @NRO_CONTENEDOR  
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_AUDITORIA_ESTADOS]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_AUDITORIA_ESTADOS]
@Co_Estado varchar(50),
@Co_Cita  int,
@Fe_Estado  datetime,
@No_Usuario varchar(100)
as
BEGIN
insert into[dbo].[CIT_ESTADO_AUDITORIA] (Co_Estado,Co_Cita,Fe_Estado,No_Usuario) values(@Co_Estado,@Co_Cita,@Fe_Estado,@No_Usuario) 
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_CLIENTE_ESPECIAL]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCA_CLIENTE_ESPECIAL]     
@nroord  char (6)    
as    

declare @TipoMercaderia varchar(3)
 set @TipoMercaderia = ''
   
 set @TipoMercaderia = (select codemb06 from [SP3TDA-DBSQL01].terminal.dbo.ddordret41 where nroord41 = @nroord)
 
if @TipoMercaderia = 'CTR'    
BEGIN
declare @Ruc varchar(11)  
Select top 1 @Ruc = v.Ruc_Con_Volante  
from [dbo].[CIT_OrdenRetiro] odr  
inner join [dbo].[CIT_Volante] v on    
(odr.Cod_Volante collate SQL_Latin1_General_CP1_CI_AS = v.Cod_Volante collate SQL_Latin1_General_CP1_CI_AS)  
where substring(Nro_Orden_Retiro,0,7) = @nroord  
  
select * from [dbo].[CIT_Parametro_Clientes_Especiales]  
where ruc = @Ruc  
   
END   
ELSE
BEGIN 
select TOP 1 * from [dbo].[CIT_Parametro_Clientes_Especiales]    
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_CODIGO_CLIENTE]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCA_CODIGO_CLIENTE]
@ruc varchar(11)
as

select CA.Id,
       CA.Ruc,
       Cli.NOMBRE  ,
       CA.Codigo_Generado,
       Ecod.estadocodaut_v_des as Estado
     

from dbo.CIT_CodigoAutogenerado CA inner join [SP3TDA-DBSQL01].terminal.dbo.AACLIENTESAA Cli
 on CA.Ruc collate SQL_Latin1_General_CP1_CI_AS = Cli.CONTRIBUY collate SQL_Latin1_General_CP1_CI_AS
 inner join dbo.CIT_EstadoCodAutorizacion Ecod on Ecod.estadocodaut_v_codigo = CA.Estado

where CA.Ruc = @ruc
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_CODIGOS_AUTORIZACION]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCA_CODIGOS_AUTORIZACION]    
as    
    
select TOP 50 CA.Id,      
       CA.Codigo_Generado,
       Fec_Registro,   
       case when CONVERT(Datetime,CONVERT(Varchar(10),fec_registro,111)+ ' 23:59:59') < GETDATE() then 'Vencido' else Ecod.estadocodaut_v_des end AS 'EstadoAEvaluar'
       --Ecod.estadocodaut_v_des as Estado    
         
from dbo.CIT_CodigoAutogenerado CA inner join dbo.CIT_EstadoCodAutorizacion Ecod on Ecod.estadocodaut_v_codigo = CA.Estado    
   
 ORDER BY Fec_Registro Desc
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_CODIGOS_AUTORIZACION_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCA_CODIGOS_AUTORIZACION_JFN]  

as    


select TOP 50 CA.Id,      

       CA.Codigo_Generado,

       Fec_Registro,   

       case when CONVERT(Datetime,CONVERT(Varchar(10),fec_registro,111)+ ' 23:59:59') < GETDATE() then 'Vencido' else Ecod.estadocodaut_v_des end AS 'EstadoAEvaluar',
CA.[Nu_OrdenRetiro],
CA.[No_UsuarioCreado],
CA.[No_UsuarioUtilizo]
       --Ecod.estadocodaut_v_des as Estado    

from dbo.CIT_CodigoAutogenerado CA inner join dbo.CIT_EstadoCodAutorizacion Ecod on Ecod.estadocodaut_v_codigo = CA.Estado    

  
 ORDER BY Fec_Registro Desc
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_OR_CITA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================  
-- Author: Katherine Ascencio (XTREME)  
-- Create date: 15/05/2015  
-- Description: Buscar Ordenes de Pedido con o sin cita  
-- ====================================================  
ALTER PROCEDURE [dbo].[CIT_BUSCA_OR_CITA] @nroord CHAR(6)
AS
SET NOCOUNT ON;

SELECT c.Ident_Cita
	,c.Cod_Cita_Padre
	,c.Cod_Volante
	,c.Cod_Contenedor
	,c.Nro_Orden_Retiro
	,c.Ident_Turno
	,c.Cod_Estado
	,c.Fec_Reg_Cita --, v.Ruc_Con_Volante  
FROM [dbo].[CIT_Cita] c
--inner join [dbo].[CIT_Volante] v on c.Cod_Volante = v.Cod_Volante  
--inner join [dbo].[CIT_Parametro_Clientes_Especiales] ce  on   
--(ce.ruc collate SQL_Latin1_General_CP1_CI_AS = v.Ruc_Con_Volante collate SQL_Latin1_General_CP1_CI_AS)  
WHERE Cod_Estado IN (
		'ACT'
		,'COL'
		,'DBL'
		,'DES'
		,'ENP'
		,'FAC'
		,'REG'
		,'ING'
		,'REG'
		,'INS'
		)
	AND substring(c.Nro_Orden_Retiro, 0, 7) = @nroord

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCA_OR_SIN_ESCANEO]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCA_OR_SIN_ESCANEO]   

@nroord  char (6)  

as  

set nocount on;

Select Ident_Panel_Electronico, Nro_Placa, Nro_Orden_Retiro, Ord_Panel_Electronico, 

CONVERT(char(10), Fec_Vig_Orden_Retiro, 103) Fec_Vig_Orden_Retiro,  

CONVERT(char(10),Fec_Reg_Panel_Electronico, 103) Fec_Reg_Panel_Electronico

from [dbo].[CIT_PanelElectronico]

where Est_Orden_Retiro = 'ACT'

and Cod_Estado in ('ING')

--Descomentar

--and CONVERT(char(10), Fec_Reg_Panel_Electronico, 103) = CONVERT(char(10), getdate(), 103) 

and substring(Nro_Orden_Retiro,0,7) = @nroord

 
GO
/****** Object:  StoredProcedure [dbo].[CIT_BUSCAR_CITA_POR_NUMERO_PLACA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_BUSCAR_CITA_POR_NUMERO_PLACA] @Nu_Placa AS VARCHAR(10)  
 ,@Nu_OrdenRetiro AS VARCHAR(10)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SELECT c.Ident_Cita  
  ,c.Cod_Cita_Padre  
  ,c.Cod_Volante  
  ,c.Cod_Contenedor  
  ,c.Nro_Orden_Retiro  
  ,c.Ident_Turno  
  ,c.Cod_Estado  
  ,c.Fec_Reg_Cita  
  ,c.Nu_Placa_Asociado  
 FROM [dbo].[CIT_Cita] c  
 WHERE ltrim(rtrim( isnull(c.Nu_Placa_Asociado,'') )) = LTRIM(RTRIM(@Nu_Placa))  
  AND substring( isnull(c.Nro_Orden_Retiro,'') , 1, 6) = ltrim(rtrim(@Nu_OrdenRetiro))  
  AND c.Cod_Estado = 'INS'  
   
 --//Auditoria registrar placa y orden de retiro asociado a cita.  
 declare @ident_cita int, @dato varchar(100)  
   
 SELECT @ident_cita = c.Ident_Cita  
 FROM [dbo].[CIT_Cita] c  
 WHERE ltrim(rtrim( isnull(c.Nu_Placa_Asociado,'') )) = LTRIM(RTRIM(@Nu_Placa))  
 AND substring( isnull(c.Nro_Orden_Retiro,'') , 1, 6) = ltrim(rtrim(@Nu_OrdenRetiro))  
 AND c.Cod_Estado = 'INS'  
   
 set @dato = cast(isnull(@ident_cita,0) as varchar) + '|' + LTRIM(RTRIM(isnull(@Nu_Placa,''))) + '|' + ltrim(rtrim(isnull(@Nu_OrdenRetiro,'')))  
   
 insert into DDAUDITO00  
 values('DESPACHO','C',user_name(),getdate(),host_name(),  
 @dato,@ident_cita)  
   
   
 SET NOCOUNT OFF;  
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_CARGAR_DETALLE_CONDUCTOR_MOBILE]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_CARGAR_DETALLE_CONDUCTOR_MOBILE]        
@OrdenRetiro varchar(25),      
@retiros_v_numbrevete varchar(10)      
AS        
 declare @TipoMercaderia varchar(3)
 declare @iCant int
 set @TipoMercaderia = ''
 set @iCant=0
/*
 set @TipoMercaderia = (select @iCant=count(*) from [SP3TDA-DBSQL01].terminal.dbo.ddordret41 a
 inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 b on (a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12)
 where nroord41 = substring(upper(@OrdenRetiro),1,6) )
*/ 
 select @iCant=count(*) from [SP3TDA-DBSQL01].terminal.dbo.ddordret41 a
 inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 b on (a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12)
 where a.nroord41 = substring(upper(@OrdenRetiro),1,6) 

 if @iCant>0
	set @TipoMercaderia = 'CTR'
 else
	set @TipoMercaderia = 'BUL'
	 	
 if @TipoMercaderia = 'CTR'       
 select        
 ret.retiros_v_numbrevete as 'retiros_v_numbrevete'    
 from dbo.CIT_RetiroTransportista ret
 where substring(upper(retiros_v_numeroOR),1,6) = substring(upper(@OrdenRetiro),1,6) 
 and upper(retiros_v_numbrevete) = upper(@retiros_v_numbrevete)
 else 
 select @OrdenRetiro as 'retiros_v_numbrevete'
GO
/****** Object:  StoredProcedure [dbo].[CIT_CARGAR_DETALLE_PLACA_MOBILE]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_CARGAR_DETALLE_PLACA_MOBILE]        

@OrdenRetiro varchar(25)  ,      

@retiros_v_Placa varchar(10)         

AS        

declare @TipoMercaderia varchar(3)

 set @TipoMercaderia = ''

 set @TipoMercaderia = (select codemb06 from [SP3TDA-DBSQL01].terminal.dbo.ddordret41 where nroord41 = substring(upper(@OrdenRetiro),1,6) )

 if @TipoMercaderia = 'CTR'   

 select       

 ret.retiros_v_Placa as 'retiros_v_Placa'  

  from dbo.CIT_RetiroTransportista ret      

  where SUBSTRING(upper(retiros_v_numeroOR),1,6) = SUBSTRING(upper(@OrdenRetiro),1,6) and upper(retiros_v_Placa) = upper(@retiros_v_Placa) 

 else 

 select @OrdenRetiro as 'retiros_v_Placa'
GO
/****** Object:  StoredProcedure [dbo].[CIT_CARGAR_DETALLE_PLACA_MOBILE_PRUEBA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_CARGAR_DETALLE_PLACA_MOBILE_PRUEBA]        
@OrdenRetiro varchar(25)  ,      
@retiros_v_Placa varchar(10)      
       
AS        
 
 declare @flagIntegral int
 set @flagIntegral = 0
     
 if(@flagIntegral = 1)    
  select @retiros_v_Placa AS 'PLACA'
 else
 
 select       
 ret.retiros_v_Placa AS 'PLACA'    
      
  from dbo.CIT_RetiroTransportista ret      
  where upper(retiros_v_numeroOR) = upper(@OrdenRetiro) and upper(retiros_v_Placa) = upper(@retiros_v_Placa) 
GO
/****** Object:  StoredProcedure [dbo].[CIT_Cliente_Es_Especial]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 15/05/2015
-- Description:	1 en caso de existir el cliente en la tabla CIT_Parametro_Clientes_Especiales, de lo contrario 0
-- =============================================
ALTER PROCEDURE [dbo].[CIT_Cliente_Es_Especial] 
	@Ruc varchar(11)
As
Begin
	SET NOCOUNT ON;
	select count(Id)as cant from CIT_Parametro_Clientes_Especiales where ruc = @Ruc
End
GO
/****** Object:  StoredProcedure [dbo].[CIT_CONSULTAR_CLIENTES]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_CONSULTAR_CLIENTES]
as


select top 4 
  Cli.CONTRIBUY as RUC,
       Cli.NOMBRE   
from  [SP3TDA-DBSQL01].terminal.dbo.AACLIENTESAA Cli
GO
/****** Object:  StoredProcedure [dbo].[CIT_Consultar_Parametro_Clientes_Especiales]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 15/05/2015
-- Description:	Devuelve de la tabla de 
-- clientes especiales de la configiracion de citas
-- =============================================
ALTER PROCEDURE [dbo].[CIT_Consultar_Parametro_Clientes_Especiales]
As
Begin
	SET NOCOUNT ON;
	Select 
		A.Id, 
		A.RUC, 
		B.Nombre,
		A.Fec_Registro
	from 
		dbo.CIT_Parametro_Clientes_Especiales A Join 
		[SP3TDA-DBSQL01].Terminal.dbo.AAclientesAA B on (A.RUC collate SQL_Latin1_General_CP1_CI_AS = B.CONTRIBUY collate SQL_Latin1_General_CP1_CI_AS) order by B.Nombre
End

GO
/****** Object:  StoredProcedure [dbo].[CIT_CONSULTARCITA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_CONSULTARCITA]
@IDENT_CITA			INT
,@COD_CITA_PADRE	INT
,@COD_VOLANTE		VARCHAR(6)
,@COD_CONTENEDOR	VARCHAR(11)
,@NRO_ORDEN_RETIRO	VARCHAR(10)
,@IDENT_TURNO		INT
,@COD_ESTADO		VARCHAR(3)
,@ESINTEGRAL		BIT
--
,@RUC_CONSIGNATARIO VARCHAR(11)
AS
BEGIN

IF @IDENT_CITA			IS NULL SET @IDENT_CITA  = 0
IF @COD_CITA_PADRE		IS NULL SET @COD_CITA_PADRE  = 0
IF @COD_VOLANTE			IS NULL SET @COD_VOLANTE  = ''
IF @COD_CONTENEDOR		IS NULL SET @COD_CONTENEDOR  = ''
IF @NRO_ORDEN_RETIRO	IS NULL SET @NRO_ORDEN_RETIRO  = ''
IF @IDENT_TURNO			IS NULL SET @IDENT_TURNO  = 0
IF @COD_ESTADO			IS NULL SET @COD_ESTADO  = ''
IF @ESINTEGRAL			IS NULL SET @ESINTEGRAL  = 0
IF @RUC_CONSIGNATARIO	IS NULL SET @RUC_CONSIGNATARIO  = ''

SELECT 
C.Ident_Cita
,C.Cod_Cita_Padre
,C.Cod_Volante
,C.Cod_Contenedor
,C.Nro_Orden_Retiro
,C.Ident_Turno
,C.Cod_Estado
,C.Fec_Reg_Cita
,C.Fec_Fac_Cita
,C.Fec_Ing_Nep_Cita
,C.Fec_Ing_Bal_Cita
,C.Fec_Des_Cita
,C.Fec_Anu_Cita
,C.Usuario_Registro
,ISNULL(C.EsIntegral,0)EsIntegral
FROM CIT_CITA C
	LEFT JOIN CIT_VOLANTE V ON C.Cod_Volante = V.Cod_Volante
WHERE 
	1 = CASE
		WHEN @IDENT_CITA = 0 THEN 1
		WHEN C.Ident_Cita = @IDENT_CITA THEN 1
		END
	AND 1 = CASE
		WHEN @COD_CITA_PADRE = 0 THEN 1
		WHEN C.Cod_Cita_Padre = @COD_CITA_PADRE THEN 1
		END
	AND 1 = CASE
		WHEN @COD_VOLANTE = '' THEN 1
		WHEN C.Cod_Volante = @COD_VOLANTE THEN 1
		END
	AND 1 = CASE
		WHEN @COD_CONTENEDOR = '' THEN 1
		WHEN C.Cod_Contenedor = @COD_CONTENEDOR THEN 1
		END
	AND 1 = CASE
		WHEN @NRO_ORDEN_RETIRO = '' THEN 1
		WHEN C.Nro_Orden_Retiro = @NRO_ORDEN_RETIRO THEN 1
		END
	AND 1 = CASE
		WHEN @IDENT_TURNO = 0 THEN 1
		WHEN C.Ident_Turno = @IDENT_TURNO THEN 1
		END
	AND 1 = CASE
		WHEN @COD_ESTADO = '' THEN 1
		WHEN C.Cod_Estado = @COD_ESTADO THEN 1
		END
	AND 1 = CASE
		WHEN @ESINTEGRAL = 0 THEN 1
		WHEN C.EsIntegral = @ESINTEGRAL THEN 1
		END
	AND 1 = CASE
		WHEN @RUC_CONSIGNATARIO = '' THEN 1
		WHEN V.Ruc_Con_Volante = @RUC_CONSIGNATARIO THEN 1
		END
ORDER BY Ident_Cita
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarCitaXTicketera]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
-- Nombre: CIT_ConsultarCitaXTicketera
-- Objetivo: Consultar en el sistema de citas si que ese volante tiene cita reservada devuelve 1 
--           de lo contrario devuelve 0
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo 17/05/2010
-- Modificacion: 
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarCitaXTicketera]
	@nrovolante		Varchar(6)		--Orden de Retiro
AS
BEGIN
DECLARE @varvolante varchar(6),@Existe int
	 

SET @varvolante=(SELECT COUNT(Cod_Volante) FROM CIT_Cita
                 WHERE Cod_Estado='REG'
                 AND   LTRIM(RTRIM(Cod_Volante))=@nrovolante)

IF (@varvolante IS NULL)
BEGIN
	SET @Existe=0
	SELECT 	@Existe
END
ELSE
BEGIN
	SET @Existe=1
	SELECT @Existe
END	  

END


GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarCompromiso]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------
-- Nombre: CIT_ConsultarCompromiso
-- Objetivo: Consulta Compromiso de Turno
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarCompromiso]
		@p_Fecha		Varchar(8),		--Fecha de Horario
		@p_Turno		Varchar(11)		--Turno de Horario
AS
BEGIN
	DECLARE @FlagCompromiso int

	SELECT 
		@FlagCompromiso = COUNT(*) 
	FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_Turno T ON
			C.Ident_Turno = T.Ident_Turno
	WHERE	T.Fec_Turno = @p_Fecha AND
			T.Des_Turno = @p_Turno AND
			C.Cod_Estado IN ('REG','FAC','DES')

	SELECT @FlagCompromiso AS [FlagCompromiso]
END




GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarCompromisoXSiguientesDias]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- Nombre: CIT_ConsultarCompromisoXSiguientesDias
-- Objetivo: Consulta si es que en los días posteriores existen compromisos
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100608
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarCompromisoXSiguientesDias]
AS
BEGIN

	DECLARE @FlagCompromiso int

	SELECT @FlagCompromiso=COUNT(*)
	FROM dbo.CIT_Cita C
		INNER JOIN dbo.CIT_Turno T ON
			C.Ident_Turno = T.Ident_Turno
	WHERE T.Fec_Turno >= CONVERT(Varchar,DATEADD(d,1,GETDATE()),112) + ' 00:00:00'
			AND C.Cod_Estado IN ('REG','FAC','DES')

	SELECT @FlagCompromiso FlagCompromiso
		
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarDatosOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ConsultarDatosOrdenRetiro]        
@p_Nro_Orden_Retiro    VARCHAR(10)   --Número de Orden de Retiro          
AS          
BEGIN          
  
 SET NOCOUNT ON  
  
 SELECT TOP 1  
  CIT.NRO_ORDEN_RETIRO  NROORDEN ,  
  CIT.IDENT_CITA,            
  --CIT.FEC_REG_CITA,            
  T.Fec_Turno FEC_REG_CITA,  
  VOL.AGE_ADU_VOLANTE,            
  CIT.COD_CONTENEDOR,    
  T.Des_Turno,  
  ISNULL(CIT.EsIntegral,0)        EsIntegral,
  SOR.ORD_CODIGO AS 'ServicioIntegral'
    
 FROM  dbo.CIT_Cita CIT      
 INNER JOIN CIT_Volante VOL ON (CIT.COD_VOLANTE = VOL.COD_VOLANTE )     
 INNER JOIN  dbo.CIT_Turno  T ON (CIT.Ident_Turno = T.Ident_Turno)
 left outer join [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD 
	ON TD.NROSEC23 = VOL.COD_VOLANTE left outer join [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN SOR
	ON SOR.ORD_BL = VOL.CNC_VOLANTE AND SOR.ORD_NAVVIA = TD.NAVVIA11 AND SOR.ORD_NUMDOCUMENTO <> '' 
	AND SOR.ORD_FLAGESTADO IS NULL
 WHERE    
 CIT.NRO_ORDEN_RETIRO IS NOT NULL    
 AND CIT.NRO_ORDEN_RETIRO=@p_Nro_Orden_Retiro   
END    
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarDatosOrdenRetiro_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ConsultarDatosOrdenRetiro_JFN] @p_Nro_Orden_Retiro VARCHAR(10) --Número de Orden de Retiro            
AS
BEGIN
	SET NOCOUNT ON

	--1) Parametros  
	DECLARE @TiempoTolerancia INT

	SELECT @TiempoTolerancia = CAST(Valor_Parametro AS INT)
	FROM CIT_PARAMETRO
	WHERE COD_PARAMETRO = 9

	--2) Consulta  
	SELECT CIT.NRO_ORDEN_RETIRO NROORDEN
		,CIT.IDENT_CITA
		,
		--CIT.FEC_REG_CITA,              
		T.Fec_Turno FEC_REG_CITA
		,VOL.AGE_ADU_VOLANTE
		,CIT.COD_CONTENEDOR
		,T.Des_Turno
		,DATEADD(mi, - @TiempoTolerancia, CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), T.Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 1, 5) + ':00', 120)) AS 'Turno_hora_inicio'
		,DATEADD(mi, @TiempoTolerancia, CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), T.Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 7, 5) + ':00', 120)) AS 'Turno_hora_fin'
		,ISNULL(CIT.EsIntegral, 0) EsIntegral
		,SOR.ORD_CODIGO AS 'ServicioIntegral'
		,CIT.[Cod_Estado] AS 'CodEstado'
	FROM dbo.CIT_Cita CIT
	INNER JOIN CIT_Volante VOL ON (CIT.COD_VOLANTE = VOL.COD_VOLANTE)
	INNER JOIN dbo.CIT_Turno T ON (CIT.Ident_Turno = T.Ident_Turno)
	LEFT OUTER JOIN [SP3TDA-DBSQL01].[TERMINAL].DBO.DDVOLDES23 TD ON TD.NROSEC23 = VOL.COD_VOLANTE
	LEFT OUTER JOIN [SP3TDA-DBSQL01].[TERMINAL].DBO.SSI_ORDEN SOR ON SOR.ORD_BL = VOL.CNC_VOLANTE
		AND SOR.ORD_NAVVIA = TD.NAVVIA11
		AND SOR.ORD_NUMDOCUMENTO <> ''
		AND SOR.ORD_FLAGESTADO IS NULL
	WHERE 
		CIT.NRO_ORDEN_RETIRO IS NOT NULL
		AND substring(CIT.NRO_ORDEN_RETIRO, 1, convert(INT, CHARINDEX('-', CIT.NRO_ORDEN_RETIRO COLLATE Latin1_General_CI_AS)) - 1) = @p_Nro_Orden_Retiro
		-- ||   
		-- INICIO JHFLORES   
		--and CONVERT(VARCHAR(10), DATEADD(mi, -@TiempoTolerancia ,CONVERT(datetime,SUBSTRING(CONVERT(varchar(100),T.Fec_Turno,120),1,10) + ' ' + SUBSTRING(T.Des_Turno,1,5) + ':00',120)),112)  = CONVERT (char(10), GETDATE() , 112)  
		AND CONVERT(VARCHAR(10), CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), T.Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 1, 5) + ':00', 120), 112) = CONVERT(CHAR(10), GETDATE(), 112)
		AND CIT.Nu_OrdenRetiro_AsociaCita IS NULL
		AND CIT.Cod_Estado IN (
			'REG'
			,'FAC'
			,'REP'
			)
	ORDER BY DATEADD(mi, - @TiempoTolerancia, CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(100), T.Fec_Turno, 120), 1, 10) + ' ' + SUBSTRING(T.Des_Turno, 1, 5) + ':00', 120)) ASC
		-- FIN JHFLORES   
		-- ||   
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarDisponibilidadXTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 20141016
-- Description:	Verifica la disponibilidad para un turno indicado
-- EXEC CIT_ConsultarDisponibilidadXTurno '20141016','17:00-18:00',0,1
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ConsultarDisponibilidadXTurno]
--DECLARE
@pFechaTurno		DATETIME,
@pTurno				VARCHAR(18),
@pCupos				INT,
@pEsIntegral		BIT
AS
BEGIN
	--SET @pFechaTurno  = '20141016'
	--SET @pTurno = '17:00-18:00'
	--SET @pEsIntegral = 0
	--SET @pCupos = 20
	/*OBTENEMOS LA CAPACIDAD DISPONIBLE*/
	DECLARE @CapacidadDisponiblePrev INT, @CapacidadDisponibleFin INT,  @CuposReservados INT
	SET @CapacidadDisponiblePrev = dbo.CIT_ObtenerCapacidadCalendario(@pTurno, @pFechaTurno)
	/*EVALUAMOS SI ES UNA CITA DE UN CLIENTE INTEGRAL O NO*/
	IF(@pEsIntegral = 0)
	BEGIN
		/*SI NO ES INTEGRAL EVALUAMOS SI SE HAN REALIZADOS RESERVA DE CUPOS*/
		SET @CuposReservados = dbo.CIT_ObtenerReservasCapacidadCalendario(@pTurno, @pFechaTurno)
		SET @CuposReservados = ISNULL(@CuposReservados,0)

		SET @CapacidadDisponiblePrev = @CapacidadDisponiblePrev - @CuposReservados
	END
	--SELECT @CapacidadDisponibleFin CapaFin, @CapacidadDisponiblePrev CapaPrev, @CuposReservados CupoRese
	SET @CapacidadDisponibleFin = @CapacidadDisponiblePrev - @pCupos
	IF @CapacidadDisponibleFin < 0	
		SELECT 'false'
	ELSE
		SELECT 'true'
	--SELECT @CapacidadDisponibleFin CapaFin, @CapacidadDisponiblePrev CapaPrev, @CuposReservados CupoRese
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarExisteOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----------------------------------------------------------------------
-- Nombre: CIT_ConsultarExisteVolanteXImportacion '197999'
-- Objetivo: Stored que realiza la consulta si existe el volante en el sistema de importacion devuelve 1 si existe volante y 0 si no lo hay
-- Valores Prueba: 
-- Creacion: Nelson Isaac Cuba Ramos
-- Modificacion: 
--------------------------------------------------------------------
--EXEC CIT_ConsultarExisteOrdenRetiro '303840-2'
ALTER PROCEDURE [dbo].[CIT_ConsultarExisteOrdenRetiro]
	@p_Nro_Orden_Retiro				Varchar(10)	
AS
BEGIN
DECLARE @EXISTEORDENRETIRO INT
DECLARE @EXISTE BIT 


CREATE TABLE #ORDENRETIRO
(
	[NROORDEN] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TURNO] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CITA] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INTEGRAL] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FECHA_DESPACHO][datetime] NULL,
	[FECHAVIGENCIA][datetime] NULL,
	[IDENT_CITA] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_ADU_VOLANTE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COD_CONTENEDOR] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [NRO_PLACA] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [COD_ESTADO] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

INSERT INTO #ORDENRETIRO
EXEC CIT_ConsultarDatosOrdenRetiro @p_Nro_Orden_Retiro

SET @EXISTEORDENRETIRO =(SELECT COUNT(NROORDEN) 
		      FROM  #ORDENRETIRO 
              WHERE NROORDEN=@p_Nro_Orden_Retiro)

IF (@EXISTEORDENRETIRO =0)
BEGIN 
	SET @EXISTE=0
END
ELSE
BEGIN 
	SET @EXISTE=1
END
SELECT @EXISTE
DROP TABLE #ORDENRETIRO
END










GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarExisteVolanteFacturado]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------    
-- Nombre: CIT_ConsultarExisteVolanteXImportacion '123456'    
-- Objetivo: Store que realiza la consulta si existe el volante en el sistema de importacion que este facturado devuelve 1 si existe volante y 0 si no lo hay    
-- Valores Prueba:     
-- Creacion: JUAN CARLOS URRELO 06/07/2010    
-- Modificacion:     
--------------------------------------------------------------------    
ALTER PROCEDURE [dbo].[CIT_ConsultarExisteVolanteFacturado]    
 @p_Cod_Volante varchar(6)    
AS    
BEGIN
	EXEC dbo.CIT_ConsultarVolanteFacturado  @p_Cod_Volante
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarExisteVolanteXCodVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
-- Nombre: CIT_ConsultarExisteVolanteXCodVolante
-- Objetivo: Consulta si existe Nro. de Volante
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 19/05/2010
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 19/05/2010
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarExisteVolanteXCodVolante]
	@p_Cod_Volante varchar(6)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @sw bit	
	SELECT @sw=COUNT(*) FROM dbo.CIT_Volante V WHERE V.Cod_Volante =@p_Cod_Volante
	SELECT @sw

END



GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarExisteVolanteXCodVolanteXUsuario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- Nombre: CIT_ConsultarExisteVolanteXCodVolanteXUsuario
-- Objetivo: Consulta si existe Nro. de Volante y por Usuario
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 05/07/2010
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 05/07/2010
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarExisteVolanteXCodVolanteXUsuario]
	@p_Cod_Volante Varchar(6),
	@p_Usuario Varchar(20)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @sw bit	
	SELECT
		@sw=COUNT(*)
	FROM dbo.CIT_Volante V
		WHERE	V.Cod_Volante =@p_Cod_Volante AND
				V.Usuario_Registro = @p_Usuario
	SELECT @sw

END




GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarExisteVolanteXImportacion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
    
    
    
  --CIT_ConsultarExisteVolanteXImportacion '123456'  
    
----------------------------------------------------------------------    
-- Nombre: CIT_ConsultarExisteVolanteXImportacion '197999'    
-- Objetivo: Store que realiza la consulta si existe el volante en el sistema de importacion devuelve 1 si existe volante y 0 si no lo hay    
-- Valores Prueba:     
-- Creacion: JUAN CARLOS URRELO 20/05/2010    
-- Modificacion:     
--------------------------------------------------------------------    
    
ALTER PROCEDURE [dbo].[CIT_ConsultarExisteVolanteXImportacion]    
 @p_Cod_Volante varchar(6)    
AS    
BEGIN    
DECLARE @EXISTEVOLANTE INT    
DECLARE @EXISTE BIT     
CREATE TABLE ##IMPO    
(    
 [Numero_de_Volante] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Consignatario] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
    [RUC_Consignatario] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [nave] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Viaje] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Conocimiento] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [FechaIngreso] [datetime] NULL,    
 [Agente_de_Aduanas] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [RUC_Agente_de_Aduanas] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
    [Email_Agente_de_Aduanas] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
    [Puerto_Origen] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Linea] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Ident_Contenedor] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Estado_Contenedor] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Usuario_de_Bloqueo] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
 [Fecha_de_bloqueo] [datetime] NULL,    
 [Motivo_de_Bloqueo] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,    
    [SI] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
[Flag_Retirado] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  
)    
  
INSERT INTO ##IMPO     
exec  dbo.NEPT_Consultar_Datos_Volante @p_Cod_Volante   
     
    
    
SET @EXISTEVOLANTE =(SELECT COUNT(Numero_de_Volante)     
        FROM  ##IMPO     
              WHERE Numero_de_Volante=@p_Cod_Volante)    
    
IF (@EXISTEVOLANTE =0)    
BEGIN     
 SET @EXISTE=0    
    
END    
ELSE    
BEGIN     
 SET @EXISTE=1    
END    
    
SELECT @EXISTE    
    
DROP TABLE ##IMPO    
END    
    
    
    
    
    
    
    
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarOrdenManualContenedores]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
-- Nombre: CIT_ConsultarOrdenManualContenedores
-- Objetivo: Consulta el orden manual asignado a los contenedores.
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarOrdenManualContenedores]
	@p_Cod_Volante			Varchar(6) --Número de Volante
AS
BEGIN

	SELECT 
		C.Cod_Volante,
		C.Cod_Contenedor,
		C.Ord_Contenedor
	FROM dbo.CIT_Contenedor C
	WHERE
		C.Cod_Volante = @p_Cod_Volante	
	ORDER BY 
		C.Ord_Contenedor	

--	IF (SELECT COUNT(C.Cod_Volante) FROM dbo.CIT_Contenedor C WHERE C.Cod_Volante = @p_Cod_Volante) <> 0
--		BEGIN
--			SELECT 
--				C.Cod_Volante,
--				C.Cod_Contenedor,
--				C.Ord_Contenedor
--			FROM dbo.CIT_Contenedor C
--			WHERE
--				C.Cod_Volante = @p_Cod_Volante	
--			ORDER BY 
--				C.Ord_Contenedor	
--		END
--	ELSE
--	BEGIN
--			SELECT 
--				@p_Cod_Volante AS [Cod_Volante],
--				'' AS [Cod_Contenedor],
--				'' AS [Ord_Contenedor]
--	END
END





GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarPanelElectronico]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
-- Nombre: CIT_ConsultarPanelElectronico
-- Objetivo: Consulta Lista de Cola de Panel Electrónico
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarPanelElectronico]
AS
BEGIN
	SELECT 				
		C.Nro_Placa,
		C.Ruma,
		C.Orden_Atencion_Panel_Electronico
	FROM CIT_PanelElectronicoTemporal C
 INNER JOIN CIT_PanelElectronico PE ON C.Nro_Placa= PE.Nro_Placa --MODIFICADO POR JUCH   
    WHERE CONVERT(Varchar(8),C.Fec_Reg_Panel_Electronico,112) = CONVERT(Varchar(8),GETDATE(),112) 
    AND PE.COD_ESTADO<>'SAL' AND PE.COD_ESTADO<>'RET' --MODIFICADO POR JUCH
	ORDER BY Orden_Atencion_Panel_Electronico
END


GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarSobrePasaPeriodoDisponibleXTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------
-- Nombre: CIT_ConsultarSobrePasaPeriodoDisponibleXTurno
-- Objetivo: Consulta si sobrepasa el periodo disponible (Devuelve 1 cuando sobrepasa el periodo disponible y 0 cuando no)
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100611
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100611
---------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_ConsultarSobrePasaPeriodoDisponibleXTurno]
@p_Fec_Turno		Datetime,
@p_Des_Turno		Varchar(18),    	   
@p_CuposSeparados	int,
@p_Integral			int
AS
BEGIN
	/*
	--Parámetros
	----------------------------------------------------------------

	DECLARE @p_Des_Turno		Varchar(18),    
			@p_Fec_Turno		Datetime,   
			@p_CuposSeparados		int,
			@p_Integral			int

	SET @p_Fec_Turno = '20100619'
	SET @p_Des_Turno = '09:00-09:30'
	--SET @p_Des_Turno = '10:00-10:30'
	--SET @p_Des_Turno = '10:30-11:00'
	SET @p_CuposSeparados = 20
	SET @p_Integral = 0

	--Parámetros calculados
	----------------------------------------------------------------
	*/

	DECLARE @sHoraInicio					Varchar(15),
			@sHoraFin						Varchar(15),
			@nIntervalo						Decimal(18,7),
			@nSemanaLaboral					int,
			@nPeriodoDisponibleGenerarCita	INT,

			@MaxDiaDisponible Datetime

	SELECT @sHoraInicio=G.DescmCampo
	FROM dbo.CIT_Parametro P
		INNER JOIN dbo.PAR_Tabla_Generica G ON
			P.Valor_Parametro = G.ValorCampo AND
			G.Ident_Tabla = 2
	WHERE Cod_Parametro  = CASE WHEN @p_Integral = 1 THEN 4 ELSE 2 END

	SELECT @sHoraFin=G.DescmCampo
	FROM dbo.CIT_Parametro P
		INNER JOIN dbo.PAR_Tabla_Generica G ON
			P.Valor_Parametro = G.ValorCampo AND
			G.Ident_Tabla = 2
	WHERE Cod_Parametro  = CASE WHEN @p_Integral = 1 THEN 5 ELSE 3 END

	SELECT @nSemanaLaboral = Valor_Parametro FROM CIT_PARAMETRO
	WHERE Cod_Parametro = 7

	SELECT @nIntervalo = valor_parametro FROM CIT_Parametro  
	WHERE Cod_Parametro = 6

	SELECT @nPeriodoDisponibleGenerarCita = Valor_Parametro
	FROM CIT_PARAMETRO
	WHERE Cod_Parametro = 8

	SET @MaxDiaDisponible = CONVERT(Varchar,DATEADD(d,@nPeriodoDisponibleGenerarCita,GETDATE()),112) 

	----------------------------------------------------------------

	DECLARE @SumaCapacidad	int,
			@nTop			int,
			@sSQL			Varchar(8000),
			@FechaMaxima	Datetime

	SET @SumaCapacidad = 0
	SET @nTop = 1

		WHILE (@SumaCapacidad<@p_CuposSeparados)
		BEGIN

			SET @sSQL = '
			SELECT SUM(Can_Capacidad) AS [Suma_Can_Capacidad]
			FROM (
				select Top @nTop Turno_Capacidad, Fecha_Capacidad, Can_Capacidad
				from (  
				select   
				 C.Turno_Capacidad,  
				 C.Fecha_Capacidad,  
				 C.Can_Capacidad  
				from CIT_CapacidadMaximaAtencionTurno C  
				left outer join CIT_Turno T ON  
				 C.Turno_Capacidad = T.Des_Turno AND  
				 C.Fecha_Capacidad = T.Fec_Turno  
				LEFT OUTER JOIN (SELECT Fec_Bloq_Cita,Tur_Bloq_Cita FROM dbo.CIT_FechaBloqueoCita WHERE Fec_Bloq_Cita>=GETDATE()) B ON
				 C.Fecha_Capacidad = B.Fec_Bloq_Cita AND
				 C.Turno_Capacidad = B.Tur_Bloq_Cita
				where (CONVERT(Varchar,Fecha_Capacidad,112) + Turno_Capacidad) >=(CONVERT(varchar,''@p_Fec_Turno'',112) + ''@p_Des_Turno'') AND
				(convert(decimal(18,7),datediff(mi,left(Turno_Capacidad,5),right(Turno_Capacidad,5)))/60) = @nIntervalo 
				AND T.Fec_Turno IS NULL  
				AND LEFT(Turno_Capacidad,5)>=''@sHoraInicio''
				AND RIGHT(Turno_Capacidad,5)<=''@sHoraFin''
				AND DATEPART(weekday,Fecha_Capacidad) <> CASE WHEN @nSemanaLaboral=1 THEN 1 ELSE 0 END
				AND B.Tur_Bloq_Cita IS NULL
				UNION  
				SELECT  
				 T.Des_Turno,  
				 T.Fec_Turno,  
				 T.Cap_Disp_Turno
				FROM CIT_Turno T  
				LEFT OUTER JOIN (SELECT Fec_Bloq_Cita,Tur_Bloq_Cita FROM dbo.CIT_FechaBloqueoCita WHERE Fec_Bloq_Cita>=GETDATE()) B ON
				 T.Fec_Turno = B.Fec_Bloq_Cita AND
				 T.Des_Turno = B.Tur_Bloq_Cita
				where T.Cap_Disp_Turno>0   AND
				(CONVERT(Varchar,T.Fec_Turno,112) + T.Des_Turno) >=(CONVERT(varchar,''@p_Fec_Turno'',112) + ''@p_Des_Turno'')
				AND LEFT(T.Des_Turno,5)>=''@sHoraInicio''
				AND RIGHT(T.Des_Turno,5)<=''@sHoraFin''
				AND DATEPART(weekday,T.Fec_Turno) <> CASE WHEN @nSemanaLaboral=1 THEN 1 ELSE 0 END
				AND B.Tur_Bloq_Cita IS NULL
				) lista  
				order by 2,1
			) SUMA'

			SET @sSQL = REPLACE(@sSQL,'@nTop',@nTop)
			SET @sSQL = REPLACE(@sSQL,'@p_Fec_Turno',CONVERT(varchar,@p_Fec_Turno,112))
			SET @sSQL = REPLACE(@sSQL,'@p_Des_Turno',@p_Des_Turno)
			SET @sSQL = REPLACE(@sSQL,'@nIntervalo',@nIntervalo)
			SET @sSQL = REPLACE(@sSQL,'@sHoraInicio',@sHoraInicio)
			SET @sSQL = REPLACE(@sSQL,'@sHoraFin',@sHoraFin)	
			SET @sSQL = REPLACE(@sSQL,'@nSemanaLaboral',@nSemanaLaboral)	

			CREATE TABLE #Suma_Can_Capacidad (Suma_Can_Capacidad INT)
			INSERT INTO #Suma_Can_Capacidad exec(@sSQL)
			SELECT @SumaCapacidad = Suma_Can_Capacidad FROM #Suma_Can_Capacidad
			DROP TABLE #Suma_Can_Capacidad

			SET @nTop = @nTop + 1
			PRINT @SumaCapacidad
			PRINT @p_CuposSeparados

		END

			SET @nTop = @nTop - 1

			SET @sSQL = '
			SELECT Fecha_Capacidad
			FROM(
			SELECT TOP 1 * 
			FROM (
				select Top @nTop Turno_Capacidad, Fecha_Capacidad, Can_Capacidad
				from (  
				select   
				 C.Turno_Capacidad,  
				 C.Fecha_Capacidad,  
				 C.Can_Capacidad  
				from CIT_CapacidadMaximaAtencionTurno C  
				left outer join CIT_Turno T ON  
				 C.Turno_Capacidad = T.Des_Turno AND  
				 C.Fecha_Capacidad = T.Fec_Turno  
				LEFT OUTER JOIN (SELECT Fec_Bloq_Cita,Tur_Bloq_Cita FROM dbo.CIT_FechaBloqueoCita WHERE Fec_Bloq_Cita>=GETDATE()) B ON
				 C.Fecha_Capacidad = B.Fec_Bloq_Cita AND
				 C.Turno_Capacidad = B.Tur_Bloq_Cita
				where (CONVERT(Varchar,Fecha_Capacidad,112) + Turno_Capacidad) >=(CONVERT(varchar,''@p_Fec_Turno'',112) + ''@p_Des_Turno'') AND
				(convert(decimal(18,7),datediff(mi,left(Turno_Capacidad,5),right(Turno_Capacidad,5)))/60) = @nIntervalo 
				AND T.Fec_Turno IS NULL  
				AND LEFT(Turno_Capacidad,5)>=''@sHoraInicio''
				AND RIGHT(Turno_Capacidad,5)<=''@sHoraFin''
				AND DATEPART(weekday,Fecha_Capacidad) <> CASE WHEN @nSemanaLaboral=1 THEN 1 ELSE 0 END
				AND B.Tur_Bloq_Cita IS NULL
				UNION  
				SELECT  
				 T.Des_Turno,  
				 T.Fec_Turno,  
				 T.Cap_Disp_Turno
				FROM CIT_Turno T  
				LEFT OUTER JOIN (SELECT Fec_Bloq_Cita,Tur_Bloq_Cita FROM dbo.CIT_FechaBloqueoCita WHERE Fec_Bloq_Cita>=GETDATE()) B ON
				 T.Fec_Turno = B.Fec_Bloq_Cita AND
				 T.Des_Turno = B.Tur_Bloq_Cita
				where T.Cap_Disp_Turno>0   AND
				(CONVERT(Varchar,T.Fec_Turno,112) + T.Des_Turno) >=(CONVERT(varchar,''@p_Fec_Turno'',112) + ''@p_Des_Turno'')
				AND LEFT(T.Des_Turno,5)>=''@sHoraInicio''
				AND RIGHT(T.Des_Turno,5)<=''@sHoraFin''
				AND DATEPART(weekday,T.Fec_Turno) <> CASE WHEN @nSemanaLaboral=1 THEN 1 ELSE 0 END
				AND B.Tur_Bloq_Cita IS NULL
				) lista  
				order by 2,1) TURNO
				ORDER BY 2 DESC, 1 DESC) Fecha_Capacidad
				'

			SET @sSQL = REPLACE(@sSQL,'@nTop',@nTop)
			SET @sSQL = REPLACE(@sSQL,'@p_Fec_Turno',CONVERT(varchar,@p_Fec_Turno,112))
			SET @sSQL = REPLACE(@sSQL,'@p_Des_Turno',@p_Des_Turno)
			SET @sSQL = REPLACE(@sSQL,'@nIntervalo',@nIntervalo)
			SET @sSQL = REPLACE(@sSQL,'@sHoraInicio',@sHoraInicio)
			SET @sSQL = REPLACE(@sSQL,'@sHoraFin',@sHoraFin)	
			SET @sSQL = REPLACE(@sSQL,'@nSemanaLaboral',@nSemanaLaboral)

			CREATE TABLE #FechaMaxima (FechaMaxima Datetime)
			INSERT INTO #FechaMaxima exec(@sSQL)
			SELECT @FechaMaxima = FechaMaxima FROM #FechaMaxima
			DROP TABLE #FechaMaxima

			IF (@FechaMaxima >= @MaxDiaDisponible)
				SELECT 1 AS [Rpta]
			ELSE
				SELECT 0 AS [Rpta]

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarTurnoOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
-- Nombre: CIT_ConsultarTurnoOrdenRetiro '353011-1'
-- Objetivo: Consulta el turno de la orden de retiro
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarTurnoOrdenRetiro]
	@p_Nro_Orden_Retiro			Varchar(10)		--Orden de Retiro
AS
BEGIN

	--Si existe Nro de Orden de Retiro mostrar el turno asociado
	IF (SELECT COUNT(C.Nro_Orden_Retiro) FROM dbo.CIT_Cita C WHERE C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro) <> 0
		BEGIN
			SELECT C.Nro_Orden_Retiro, CONVERT(VARCHAR,T.Fec_Turno,103) + ' '+T.Des_Turno  AS Des_Turno
				FROM dbo.CIT_Cita C
					INNER JOIN dbo.CIT_Turno T ON
						C.Ident_Turno = T.Ident_Turno
					WHERE
						Nro_Orden_Retiro = @p_Nro_Orden_Retiro
		END
	--Si no existe mostrar en blanco el turno
	ELSE
		BEGIN
			SELECT @p_Nro_Orden_Retiro AS [Nro_Orden_Retiro], '' AS [Des_Turno]
		END
END

	
GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarValorParametroXCodParametro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Nombre: CIT_ConsultarValorParametroXCodParametro
-- Objetivo: Consulta Valor de Parámetro por Código de Parámetro
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
----------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarValorParametroXCodParametro]
	@p_Cod_Parametro	int		--Código de Parámetro
AS
BEGIN
	SELECT 
		Valor_Parametro
	FROM CIT_Parametro P
		WHERE Cod_Parametro = @p_Cod_Parametro
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ConsultarVistaPanelElectronico]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- Nombre: CIT_ConsultarVistaPanelElectronico
-- Objetivo: Consulta la vsitadel Panel Electrónico
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100607
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100607
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ConsultarVistaPanelElectronico]
AS
BEGIN

	IF (SELECT COUNT(*) FROM CIT_VistaPanelElectronico) > 0
		select * from dbo.CIT_VistaPanelElectronico
	ELSE
		SELECT NULL AS Nro_Placa, NULL AS Ruma, NULL AS Habilitado
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_DeleteRetiroTransportista]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_DeleteRetiroTransportista]      
@Codigo int      
AS BEGIN      

DELETE FROM 
CIT_RetiroAuditoria    
WHERE retiros_n_codigo = @Codigo      
      
DELETE FROM      
CIT_RetiroTransportista  
WHERE retiros_n_codigo = @Codigo 
      
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_DeleteRetiroTransportista_NEW]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_DeleteRetiroTransportista_NEW] @Codigo INT
	,@usuarioreg VARCHAR(100)
AS
BEGIN

	DELETE  
	FROM CIT_RetiroAuditoria  
	WHERE retiros_n_codigo = @Codigo  
	
	INSERT INTO CIT_RetiroAuditoria_NEW
	SELECT @Codigo
		,CONVERT(VARCHAR(10), GETDATE(), 103)
		,CONVERT(VARCHAR(5), GETDATE(), 108)
		,ltrim(rtrim(@usuarioreg))
		,'ELIMINACION'
		,retiros_v_Placa
		,retiros_v_numeroOR
	FROM CIT_RetiroTransportista
	WHERE retiros_n_codigo = @Codigo
	
	DELETE
	FROM CIT_RetiroTransportista
	WHERE retiros_n_codigo = @Codigo
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_DesactivarCodigoAutorizacion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_DesactivarCodigoAutorizacion]  
@Codigo_Generado varchar(20)  
as  
  
update CIT_CodigoAutogenerado set Estado = 'I' where Codigo_Generado = @Codigo_Generado

GO
/****** Object:  StoredProcedure [dbo].[CIT_DesactivarCodigoAutorizacion_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_DesactivarCodigoAutorizacion_JFN]  
@Codigo_Generado varchar(20) ,   
@No_UsuarioUso as varchar(50),  
@Nu_OrdeRetiro as varchar(10)  
as    
set @Codigo_Generado = ltrim(rtrim(@Codigo_Generado))
set @No_UsuarioUso = ltrim(rtrim(@No_UsuarioUso))
set @Nu_OrdeRetiro = ltrim(rtrim(@Nu_OrdeRetiro))

update CIT_CodigoAutogenerado set Estado = 'I'
,No_UsuarioUtilizo=@No_UsuarioUso
,Nu_OrdenRetiro=@Nu_OrdeRetiro 
where Codigo_Generado = @Codigo_Generado  
GO
/****** Object:  StoredProcedure [dbo].[CIT_ELIMINAR_CTR_ASIGNADO]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ELIMINAR_CTR_ASIGNADO]
@CTR VARCHAR(11),
@pNumeroOR VARCHAR(6)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @vCodVolante VARCHAR(6)
		,@vCountCTR INT
		,@vNumeroComprobante VARCHAR(20)
			
	SELECT @vCodVolante = Cod_Volante
		,@vNumeroComprobante = Nro_Comprobante
	FROM dbo.CIT_OrdenRetiro
	WHERE Nro_Orden_Retiro LIKE (@pNumeroOR + '%')
	
	UPDATE CIT_OrdenRetiro SET Asignado='0'
	WHERE Cod_Contenedor = @CTR
	AND Nro_Comprobante = @vNumeroComprobante
	AND ISNULL(Asignado, 0) = 1
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_Eliminar_Parametro_Clientes_Especiales]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 15/05/2015
-- Description:	Elimina un registro en la tabla de 
-- clientes especiales de la configiracion de citas
-- =============================================
ALTER PROCEDURE [dbo].[CIT_Eliminar_Parametro_Clientes_Especiales]
	@Id int
As
Begin
	SET NOCOUNT ON;
	Delete from dbo.CIT_Parametro_Clientes_Especiales where Id = @Id
End
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarAcciones]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EliminarAcciones]
@acc_codigo INT
AS
BEGIN
	DECLARE @Ident INT
	IF( (SELECT COUNT(per_codigo) FROM CIT_PERFILACCION WHERE acc_codigo = @acc_codigo) > 0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		DELETE FROM [dbo].[CIT_Acciones] WHERE  acc_codigo = @acc_codigo    
		SET @Ident = @acc_codigo
	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarAccionesPerfil]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EliminarAccionesPerfil]
@per_codigo INT,
@acc_codigo INT
AS
BEGIN
	DELETE FROM dbo.CIT_PERFILACCION
	WHERE 
	per_codigo = @per_codigo
	AND acc_codigo = @acc_codigo
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarCodigosAutorizacion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EliminarCodigosAutorizacion]
@Id int
as

delete dbo.CIT_CodigoAutogenerado
where Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarConfigPDT]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[CIT_EliminarConfigPDT]
@id INT
AS  
BEGIN	 
	DELETE FROM dbo.CIT_Parametro_PDT WHERE Id = @id   
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarReservaCupos]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EliminarReservaCupos]
(@Ident_ReservaCupos int )
AS
BEGIN
	DELETE FROM dbo.CIT_ReservaCupos 
	WHERE
	Ident_ReservaCupos = @Ident_ReservaCupos
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_EliminarSucursal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EliminarSucursal]
@codigo int
AS
BEGIN
	DELETE FROM dbo.CIT_Sucursal WHERE codigo =@codigo
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_EnviarInformacionSinPanelASparc]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_EnviarInformacionSinPanelASparc]
AS
return --APC 09/11/2015
BEGIN
	SET NOCOUNT ON;

	DECLARE @TEnvioSparcTMP TABLE (
		Id INT IDENTITY,
		IdEnvioSparcTemporal INT,
		Nro_Orden_Retiro VARCHAR(10),
		Nro_Salida VARCHAR(6),
		Cod_Contenedor VARCHAR(11),
		Ord_Contenedor INT,
		Cod_Aplicacion VARCHAR(100),
		Cod_Usuario VARCHAR(50),
		Cod_IP VARCHAR(100),
		Fec_Registro DATETIME,
		Nro_Movimientos INT,
		Ruma VARCHAR(20)
	)

	DECLARE @IdMin INT,
			@IdMax INT,
			@vIdEnvioSparcFIN INT,
			@vNumeroCamionesIngresados INT,
			@vParamNumeroCamionesEnPatio INT,
			@vNumeroCamionesEnSparc INT,
			@vNumeroCTRConOrden INT

	/*OBTENEMOS EL PARÁMETRO DE VEHÍCULOS DISPONIBLES EN PATIO PARA EL CASO SIN PANEL*/
	SELECT @vParamNumeroCamionesEnPatio = Valor_Parametro FROM dbo.CIT_Parametro WHERE Cod_Parametro = 23

	/*OBTENEMOS EL NÚMERO DE CAMIONES ENVIADOS A SPARC Y QUE AÚN NO HAYAN SIDO ATENDIDOS*/
	SELECT @vNumeroCamionesEnSparc = COUNT(IdEnvioSparcTemporal)
	FROM dbo.CIT_EnvioSparcTemporal
	WHERE
	Enviado = 1
	AND Atendido = 0

	IF(@vParamNumeroCamionesEnPatio > @vNumeroCamionesEnSparc)
	BEGIN
		/*OBTENEMOS LOS REGISTROS QUE AÚN NO HAN SIDO ENVIADOS A SPARC*/
		INSERT INTO @TEnvioSparcTMP (
				IdEnvioSparcTemporal, 
				Nro_Orden_Retiro, 
				Nro_Salida, 
				Cod_Contenedor, 
				Ord_Contenedor,
				Cod_Aplicacion, 
				Cod_Usuario, 
				Cod_IP, Fec_Registro)
		SELECT 
				IdEnvioSparcTemporal,
				Nro_Orden_Retiro, 
				Nro_Salida,
				Cod_Contenedor,
				Ord_Contenedor,
				Cod_Aplicacion,
				Cod_Usuario,
				Cod_IP,
				Fec_Registro
		FROM dbo.CIT_EnvioSparcTemporal
		WHERE 
		Enviado = 0

		/*EVALUAMOS SI SE HAN DEFINIDO PRIORIDADES*/
		SELECT @vNumeroCTRConOrden = COUNT(IdEnvioSparcTemporal) 
		FROM @TEnvioSparcTMP
		WHERE ISNULL(Ord_Contenedor,0) NOT IN (0,99)

		IF(@vNumeroCTRConOrden = 0)
		BEGIN
			/*OBTENEMOS LOS LÍMITES DE LA MATRIZ*/
			/*SET @IdMin = 1
			SELECT @IdMax = MAX(Id) FROM @TEnvioSparcTMP
			WHILE (@IdMin <= @IdMax)
			BEGIN
				DECLARE @TMovimientosTMP TABLE (Ruma VARCHAR(20), Nro_Movimientos INT)
				DECLARE	@vIdEnvioSparcTMP INT,
						@vCodContenedorTMP VARCHAR(11),
						@vRuma VARCHAR(20),
						@vNroMovimientos INT

				/*OBTENEMOS LOS VALORES PARA PODER EVALUAR LOS NÚMEROS DE MOVIMIENTOS*/
				
				SELECT 
					@vIdEnvioSparcTMP = IdEnvioSparcTemporal,
					@vCodContenedorTMP = Cod_Contenedor
				FROM @TEnvioSparcTMP
				WHERE 
				Id = @IdMin

				INSERT INTO @TMovimientosTMP	       
				EXEC dbo.SN_NEPT_CIT_MovimientosXContenedor @vCodContenedorTMP -- 'sudu1234567'--

				/*OBTENEMOS LA INFORMACIÓN DE LA RUMA Y EL NÚMERO DE MOVIMIENTOS*/
				SELECT 
					@vRuma = Ruma, 
					@vNroMovimientos = Nro_Movimientos
				FROM @TMovimientosTMP

				/*ACTUALIZAMOS VALORES EN LA TABLA TEMPORAL*/
				UPDATE @TEnvioSparcTMP
				SET Nro_Movimientos = @vNroMovimientos,
					Ruma = @vRuma
				WHERE IdEnvioSparcTemporal = @vIdEnvioSparcTMP

				/*AÑADIMOS UNO AL MARCADOR*/
				SET @IdMin = @IdMin + 1
			END*/

			/*OBTENEMOS EL MÁS PRÓXIMO A ENVIAR*/
			/*SELECT TOP 1 @vIdEnvioSparcFIN = IdEnvioSparcTemporal
			FROM @TEnvioSparcTMP 
			WHERE Nro_Movimientos IS NOT NULL
			ORDER BY Nro_Movimientos, Fec_Registro*/
			
			SELECT TOP 1 @vIdEnvioSparcFIN = IdEnvioSparcTemporal
			FROM @TEnvioSparcTMP 
			ORDER BY Fec_Registro 
		END
		ELSE
		BEGIN
			/*OBTENEMOS EL MÁS PRÓXIMO A ENVIAR CON RESPECTO AL ORDEN DEFINIDO*/
			SELECT TOP 1 @vIdEnvioSparcFIN = IdEnvioSparcTemporal
			FROM @TEnvioSparcTMP 
			WHERE Ord_Contenedor IS NOT NULL
			ORDER BY Ord_Contenedor, Fec_Registro
		END

		IF(ISNULL(@vIdEnvioSparcFIN,0)>0)
		BEGIN
			-- CREAMOS VARIABLES TEMPORALES DE ENVÍO
			DECLARE @transaccion VARCHAR(20),
					@contenedor VARCHAR(11),
					@aplicacion VARCHAR(20),
					@usuario VARCHAR(20),
					@ip VARCHAR(15)

			-- OBTENEMOS VALOR PARA LAS VARIABLES
			SELECT 
				@transaccion = Nro_Salida,
				@contenedor = Cod_Contenedor,
				@aplicacion = 'Citas',
				@usuario = Cod_Usuario,
				@ip = Cod_IP
			FROM dbo.CIT_EnvioSparcTemporal
			WHERE
			IdEnvioSparcTemporal = @vIdEnvioSparcFIN

			-- ENVIAMOS INFORMACIÓN A SPARC
			EXEC [dbo].[SN_SPH_uspSparcsHostSolicitaSalidaContenedorImpo]	@transaccion,
																			@contenedor,
																			@aplicacion,
																			@usuario,
																			@ip
			-- ACTUALIZAMOS ESTADO ENVIADO EN TABLA DE ENVÍO
			UPDATE dbo.CIT_EnvioSparcTemporal
			SET 
				Enviado = 1,
				Fec_Envio = GETDATE()
			WHERE
			IdEnvioSparcTemporal = @vIdEnvioSparcFIN

			--SELECT * FROM dbo.CIT_EnvioSparcTemporal WHERE IdEnvioSparcTemporal = @vIdEnvioSparcFIN
		END	
	END	

	-- ACTUALIZAMOS EL CAMPO ATENDIDO CUANDO LUEGO DE HABER SIDO ENVIADO SOBRE PASA EL TIEMPO DE 60 MIN
	UPDATE dbo.CIT_EnvioSparcTemporal
	SET
		Atendido = 1,
		Fec_Salida = GETDATE()
	WHERE
	Enviado = 1 
	AND DATEDIFF(MI, Fec_Envio, GETDATE()) >= 60
END


GO
/****** Object:  StoredProcedure [dbo].[CIT_EvaluarVehiculoPanel]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  RV  
-- Create date: 06/11/2014  
-- Description: EVALÚA SI EL CARRO QUE SE ESTÁ REGISTRANDO EL INGRESO POR BALANZA TIENE PANEL O NO  
-- EXEC CIT_EvaluarVehiculoPanel 'YY1234','576053'  
-- =============================================  
ALTER PROCEDURE [dbo].[CIT_EvaluarVehiculoPanel]
	--DECLARE  
	@p_Placa VARCHAR(6)
	,@p_Orden_Retiro VARCHAR(20)
	,@p_Cod_Contenedor VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	------------------------------------------------------------------------------------------  
	/*OBTENEMOS EL NÚMERO DE VOLANTE PARA LUEGO MARCAR EL CONTENEDOR COMO ASIGNADO*/
	DECLARE @vCodVolante VARCHAR(6)
		,@vNroOrdenRetiro VARCHAR(20)
		,@vConCita BIT
		,@vCodContenedor VARCHAR(11)

	SELECT @vCodVolante = Cod_Volante
		,@vNroOrdenRetiro = Nro_Orden_Retiro
		,@vConCita = ConCita
		,@vCodContenedor = Cod_Contenedor
	FROM dbo.CIT_OrdenRetiro
	WHERE Nro_Orden_Retiro LIKE (@p_Orden_Retiro + '%')
		AND Nro_Placa = @p_Placa

	UPDATE dbo.CIT_Contenedor
	SET Asignado = 1
	WHERE Cod_Volante = @vCodVolante
		AND Cod_Contenedor = @p_Cod_Contenedor

	IF (
			@vConCita = 0
			AND @vCodContenedor <> @p_Cod_Contenedor
			)
	BEGIN
		UPDATE dbo.CIT_Contenedor
		SET Ord_Contenedor = 99
		WHERE Cod_Volante = @vCodVolante
			AND Cod_Contenedor = @vCodContenedor
	END

	/*ACTUALIZAMOS EL CONTENEDOR QUE ESTÁ SIENDO ASIGNADO EN EL SISTEMA DE TERMINAL PARA QUE YA NO SEA CONSIDERADO*/
	UPDATE dbo.CIT_OrdenRetiro
	SET Asignado = 1
	WHERE Cod_Volante = @vCodVolante
		AND Cod_Contenedor = @p_Cod_Contenedor

	------------------------------------------------------------------------------------------  
	/*ACTUALIZAMOS EL CONTENEDOR QUE ESTÁ SIENDO DESPACHADO EN TERMINAL*/
	declare @nroord varchar(10)
	
	SELECT @nroord = ltrim(rtrim(Nu_OrdenRetiro_AsociaCita ))
	FROM CIT_CITA  WITH (NOLOCK)
	WHERE Nro_Orden_Retiro  LIKE (@p_Orden_Retiro + '%')
	AND Nu_Placa_Asociado = @p_Placa
	AND cod_estado <> 'DES'
	
	IF isnull(@nroord,'') = ''
	BEGIN
		UPDATE dbo.CIT_OrdenRetiro
		SET Cod_Contenedor_Desp = @p_Cod_Contenedor
		WHERE Nro_Orden_Retiro = @vNroOrdenRetiro
	END
	ELSE
	BEGIN
		UPDATE dbo.CIT_OrdenRetiro
		SET Cod_Contenedor_Desp = @p_Cod_Contenedor
		WHERE Nro_Orden_Retiro = @nroord
	END
	------------------------------------------------------------------------------------------  
	/*UNA VEZ QUE EL CARRO INGRESA SI ES QUE TIENE PANEL SE REGITRA SU INGRESO EN LA TABLA PANELELECTRÓNICO  
 ENTONCES SI NO EXISTE AHÍ ES POR QUE EL VEHÍCULO PERTENECE A UNA BALANZA SIN PANEL*/
	DECLARE @IdPanelElectronico INT

	SELECT @IdPanelElectronico = Ident_Panel_Electronico
	FROM dbo.CIT_PanelElectronico
	WHERE Nro_Placa = @p_Placa
		AND Nro_Orden_Retiro LIKE (@p_Orden_Retiro + '%')

	SELECT ISNULL(@IdPanelElectronico, 0) IdPanelElectronico
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ExisteFechaTurnoBloqueo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- Nombre: [CIT_ExisteFechaTurnoBloqueo]
-- Objetivo: Evalua si existe fecha con turno bloqueado
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo CHunga 04/06/2010
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ExisteFechaTurnoBloqueo]
	@fecha		datetime,
	@turno	    varchar(12)

AS
BEGIN
DECLARE @EXISTE INT 
 

SET @EXISTE=(SELECT Ident_BloqueoCita 
			 FROM CIT_FechaBloqueoCita
			 WHERE CONVERT(VARCHAR,Fec_Bloq_Cita,112)=CONVERT(VARCHAR,@fecha,112)
			 AND Tur_Bloq_Cita=@turno)

IF (@EXISTE IS NULL)    
BEGIN    
SET @EXISTE=0    
SELECT @EXISTE
END    
ELSE    
BEGIN     
SET @EXISTE=1 
SELECT @EXISTE   
END    
    
    
 
END





GO
/****** Object:  StoredProcedure [dbo].[CIT_GetAllAuditoriaByCodigoOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetAllAuditoriaByCodigoOR]
@Codigo int
AS BEGIN

SELECT 
auditoria_n_codigo AS 'Codigo',
auditoria_d_fecha AS 'Fecha',
auditoria_v_hora AS 'Hora',
auditoria_v_usuario AS 'Usuario',
auditoria_v_evento AS 'Evento'
FROM
CIT_RetiroAuditoria
WHERE retiros_n_codigo = @Codigo
ORDER BY auditoria_d_fecha,auditoria_v_hora desc

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetAllOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetAllOrdenRetiro]    
(
@CodigoAgenciaAduanas varchar(10),
@Perfil varchar(2)
)
AS BEGIN    

IF(@Perfil = 'AA')      
SELECT     
RT.retiros_n_codigo AS 'Codigo',    
RT.retiros_v_numeroOR AS 'OrdenRetiro',    
RT.retiros_v_Placa AS 'Placa',    
RT.retiros_v_nombre AS 'Conductor',    
RT.retiros_v_Dni AS 'DNI',    
RT.retiros_v_numbrevete AS 'Brevete',    
RT.retiros_d_fecha AS 'FechaRegistro',    
ER.estadoret_v_descripcion AS 'Estado',    
RT.retiros_v_agenteadu AS 'AgenteAduanas',    
RT.retiros_v_Dniagenteadu AS 'DniAgente',    
RT.retiros_v_numop AS 'NumeroOP',  
RT.Despachador AS 'Despachador'   
FROM    
CIT_RetiroTransportista RT INNER JOIN CIT_EstadoRetiro ER    
ON RT.estadoret_n_codigo = ER.estadoret_n_codigo INNER JOIN [SP3TDA-DBSQL01].TERMINAL.dbo.DDORDRET41 O
ON RT.retiros_v_numeroOR COLLATE SQL_Latin1_General_CP1_CI_AS = O.nroord41 COLLATE SQL_Latin1_General_CP1_CI_AS 
INNER JOIN [SP3TDA-DBSQL01].SEGURIDAD.dbo.SGT_Usuario U ON U.USU_CodigoInterno COLLATE SQL_Latin1_General_CP1_CI_AS = O.codage19 COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE U.USU_Codigo = @CodigoAgenciaAduanas
ORDER BY RT.retiros_d_fecha DESC    
    
ELSE

SELECT     
RT.retiros_n_codigo AS 'Codigo',    
RT.retiros_v_numeroOR AS 'OrdenRetiro',    
RT.retiros_v_Placa AS 'Placa',    
RT.retiros_v_nombre AS 'Conductor',    
RT.retiros_v_Dni AS 'DNI',    
RT.retiros_v_numbrevete AS 'Brevete',    
RT.retiros_d_fecha AS 'FechaRegistro',    
ER.estadoret_v_descripcion AS 'Estado',    
RT.retiros_v_agenteadu AS 'AgenteAduanas',    
RT.retiros_v_Dniagenteadu AS 'DniAgente',    
RT.retiros_v_numop AS 'NumeroOP',  
RT.Despachador AS 'Despachador'   
FROM    
CIT_RetiroTransportista RT INNER JOIN CIT_EstadoRetiro ER    
ON RT.estadoret_n_codigo = ER.estadoret_n_codigo
ORDER BY RT.retiros_d_fecha DESC    
    
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetAllOrdenRetiroByFiltros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetAllOrdenRetiroByFiltros]      
(  
@CodigoAgenciaAduanas varchar(4),  
@Perfil varchar(2),  
@OrdenRetiro varchar(6),  
@FechaIni varchar(10),  
@FechaFin varchar(10)
)  
AS BEGIN      
  
IF(@Perfil = 'AA')        
SELECT       
RT.retiros_n_codigo AS 'Codigo',      
RT.retiros_v_numeroOR AS 'OrdenRetiro',      
RT.retiros_v_Placa AS 'Placa',      
RT.retiros_v_nombre AS 'Conductor',      
RT.retiros_v_Dni AS 'DNI',      
RT.retiros_v_numbrevete AS 'Brevete',      
RT.retiros_d_fecha AS 'FechaRegistro',      
ER.estadoret_v_descripcion AS 'Estado',      
RT.retiros_v_agenteadu AS 'AgenteAduanas',      
RT.retiros_v_Dniagenteadu AS 'DniAgente',      
RT.retiros_v_numop AS 'NumeroOP',    
RT.Despachador AS 'Despachador'     
FROM      
CIT_RetiroTransportista RT INNER JOIN CIT_EstadoRetiro ER      
ON RT.estadoret_n_codigo = ER.estadoret_n_codigo 
--INNER JOIN [SP3TDA-DBSQL01].TERMINAL.dbo.DDORDRET41 O  
--ON RT.retiros_v_numeroOR COLLATE SQL_Latin1_General_CP1_CI_AS = O.nroord41 COLLATE SQL_Latin1_General_CP1_CI_AS   
--INNER JOIN [SP3TDA-DBSQL01].SEGURIDAD.dbo.SGT_Usuario U ON U.USU_CodigoInterno COLLATE SQL_Latin1_General_CP1_CI_AS = O.codage19 COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE isnull(RT.retiros_v_codageadu,'') = @CodigoAgenciaAduanas
--U.USU_Codigo = @CodigoAgenciaAduanas
AND (isnull(RT.retiros_v_numeroOR,'') like (case @OrdenRetiro when '' then '%' else @OrdenRetiro end))
AND ((CONVERT(datetime, RT.retiros_d_fecha,103) between CONVERT(datetime,@FechaIni,103) and DATEadd(day,1,CONVERT(datetime,@FechaFin,103))) OR (@FechaIni ='' and @FechaFin =''))
--AND ((CONVERT(datetime, RT.retiros_d_fecha) between CONVERT(datetime,@FechaIni) and CONVERT(datetime,@FechaFin)) OR (@FechaIni ='' and @FechaFin =''))
ORDER BY RT.retiros_d_fecha DESC      
      
ELSE  
  
SELECT       
RT.retiros_n_codigo AS 'Codigo',      
RT.retiros_v_numeroOR AS 'OrdenRetiro',      
RT.retiros_v_Placa AS 'Placa',      
RT.retiros_v_nombre AS 'Conductor',      
RT.retiros_v_Dni AS 'DNI',      
RT.retiros_v_numbrevete AS 'Brevete',      
RT.retiros_d_fecha AS 'FechaRegistro',      
ER.estadoret_v_descripcion AS 'Estado',      
RT.retiros_v_agenteadu AS 'AgenteAduanas',      
RT.retiros_v_Dniagenteadu AS 'DniAgente',      
RT.retiros_v_numop AS 'NumeroOP',    
RT.Despachador AS 'Despachador'     
FROM      
CIT_RetiroTransportista RT INNER JOIN CIT_EstadoRetiro ER      
ON RT.estadoret_n_codigo = ER.estadoret_n_codigo  
WHERE
(isnull(RT.retiros_v_numeroOR,'') like (case @OrdenRetiro when '' then '%' else @OrdenRetiro end))
AND ((CONVERT(datetime, RT.retiros_d_fecha,103) between CONVERT(datetime,@FechaIni,103) and DATEadd(day,1,CONVERT(datetime,@FechaFin,103))) OR (@FechaIni ='' and @FechaFin =''))
--AND ((CONVERT(datetime, RT.retiros_d_fecha) between CONVERT(datetime,@FechaIni) and CONVERT(datetime,@FechaFin)) OR (@FechaIni ='' and @FechaFin =''))
ORDER BY RT.retiros_d_fecha DESC      
      
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetCodAgenciaAduBYCodUsuario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetCodAgenciaAduBYCodUsuario]    
(    
@CodUsuario varchar(10)    
)    
AS BEGIN  
	SELECT      
	USU_CodigoInterno AS 'CodAgenciaAduanas'     
	from [SP3TDA-DBSQL01].Seguridad.dbo.SGT_Usuario with (nolock)    
	WHERE USU_Codigo = @CodUsuario  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetDatosAgenciaAduanasBYOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetDatosAgenciaAduanasBYOR]    
(    
@OrdenRetiro varchar(6)    
)    
AS BEGIN    
select O.nroord41 AS 'OrdenRetiro',     
U.USU_NumDocumento AS 'RucAgencia',      
--U.USU_Nombres +' '+ isnull(U.USU_Paterno,'') +' '+ isnull(U.USU_Materno,'') AS 'AgenciaAduanas',     
U.USU_Nombres AS 'AgenciaAduanas', 
O.codibm45 AS 'NroOperacion',    
D.NOMBRES + ' ' + D.APELLIDOS AS 'Despachador',  
O.codage19 AS 'CodAgenciaAduanas'     
from [SP3TDA-DBSQL01].TERMINAL.dbo.ddordret41 O inner join [SP3TDA-DBSQL01].TERMINAL.dbo.DESPACHADOR D    
ON O.codibm45 = D.DOCUMENTO inner join [SP3TDA-DBSQL01].Seguridad.dbo.SGT_Usuario U    
ON O.codage19 collate SQL_Latin1_General_CP1_CI_AS = U.USU_CodigoInterno collate SQL_Latin1_General_CP1_CI_AS    
WHERE O.nroord41 = @OrdenRetiro    
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetFechaVigenciaOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CIT_GetFechaVigenciaOR]  
(
@sNroOrd char(8)
)
AS  BEGIN
  
select   
a.fecexp41 AS 'FECHAVIGENCIA'
  
          
from [SP3TDA-DBSQL01].TERMINAL.dbo.ddordret41 a (nolock)    
inner join [SP3TDA-DBSQL01].TERMINAL.dbo.dddetord43 b (nolock) on (a.nroord41=b.nroord41)    
left join [SP3TDA-DBSQL01].TERMINAL.dbo.ddblodes60 c (nolock) on (a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12)    
where a.nroord41=SUBSTRING(@sNroOrd,1, 6)

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetNombreCompletoUsuarioByCodigo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetNombreCompletoUsuarioByCodigo]      
(      
@Codigo varchar(10)      
)      
AS BEGIN      
SELECT USU_Nombres AS 'NombreUsuario'--+ ' ' + ISNULL(USU_Paterno,'') + ' ' + ISNULL(USU_Materno,'') AS 'NombreUsuario'      
FROM [SP3TDA-DBSQL01].Seguridad.DBO.SGT_USUARIO       
WHERE USU_Codigo = @Codigo      
      
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetNombreDespachadorBYNumOpe]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetNombreDespachadorBYNumOpe]
(
@NumeroOperacion varchar(11)
)
AS BEGIN
select 
NOMBRES + ' ' + APELLIDOS AS 'NombreDespachador' 
from  [SP3TDA-DBSQL01].TERMINAL.dbo.DESPACHADOR
WHERE DOCUMENTO = @NumeroOperacion
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetNumOREdit]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetNumOREdit] (
	@OrdenRetiro VARCHAR(6)
	,@Placa VARCHAR(6)
	,@FechaRegistro VARCHAR(19)
	)
AS
BEGIN
	DECLARE @CORRE INT;
	DECLARE @tab TABLE (
		id INT NOT NULL identity(1, 1)
		,Orden VARCHAR(6)
		,Placa VARCHAR(6)
		,Fecha VARCHAR(19)
		)

	INSERT @tab
	SELECT retiros_v_numeroOR
		,retiros_v_Placa
		,CONVERT(VARCHAR(19), retiros_d_fecha, 121)
	FROM CIT_RETIROTRANSPORTISTA
	WHERE retiros_v_numeroOR = @OrdenRetiro
	ORDER BY 1 ASC

	--SELECT * FROM @tab  
	SELECT @CORRE = ID
	FROM @tab
	WHERE Orden = @OrdenRetiro
		--AND Placa = @Placa
		AND Fecha = @FechaRegistro

	SELECT @CORRE 'Correlativo'
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetNumRegistrosWithOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetNumRegistrosWithOR]
(  
 @OrdenRetiro varchar(6)  
)  
  
AS BEGIN  
  
     SELECT COUNT(retiros_n_codigo) AS 'NumeroRegistros'
     FROM CIT_RETIROTRANSPORTISTA
     WHERE retiros_v_numeroOR = @OrdenRetiro
   
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetOrdenRetiroByCodigo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetOrdenRetiroByCodigo] @Codigo INT
AS
BEGIN
	SELECT RT.retiros_n_codigo AS 'Codigo'
		,RT.retiros_v_numeroOR AS 'OrdenRetiro'
		,RT.retiros_v_Placa AS 'Placa'
		,RT.retiros_v_nombre AS 'Conductor'
		,RT.retiros_v_Dni AS 'DNI'
		,RT.retiros_v_numbrevete AS 'Brevete'
		,RT.retiros_d_fecha AS 'FechaRegistro'
		,ER.estadoret_v_descripcion AS 'Estado'
		,RT.retiros_v_agenteadu AS 'AgenteAduanas'
		,RT.retiros_v_Dniagenteadu AS 'DniAgente'
		,RT.retiros_v_numop AS 'NumeroOP'
		,RT.Despachador AS 'Despachador'
		,isnull(RT.retiros_v_Celular,'') AS 'Celular'
	FROM CIT_RetiroTransportista RT
	INNER JOIN CIT_EstadoRetiro ER ON RT.estadoret_n_codigo = ER.estadoret_n_codigo
	WHERE RT.retiros_n_codigo = @Codigo
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_GetOrdenRetiroByCodigoAgente]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_GetOrdenRetiroByCodigoAgente]
(
@OrdenRetiro varchar(6),
@CodAgenteAduanas varchar(10)
)

AS
BEGIN

SELECT O.nroord41 AS 'ORDENRETIRO'
FROM [SP3TDA-DBSQL01].TERMINAL.dbo.ddordret41 O inner join [SP3TDA-DBSQL01].Seguridad.dbo.SGT_USUARIO S
ON O.codage19 collate Modern_Spanish_CI_AS = S.USU_CodigoInterno collate Modern_Spanish_CI_AS
WHERE SUBSTRING(O.nroord41,1,6) = @OrdenRetiro AND S.USU_Codigo = @CodAgenteAduanas

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_HabilitarXOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----------------------------------------------------------------------
-- Nombre: CIT_HabilitarXOrdenRetiro '353011'
-- Objetivo: Habilita orden de retiro a Activa siempre y cuando en el sistema de importacion se realice la habilitacion
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo Chunga  14/05/2010
-- Modificacion: Nelson I. Cuba Ramos 05/10/2010
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_HabilitarXOrdenRetiro]
@Nro_Orden_Retiro  Varchar(10) --Número Orden de Retiro

AS
BEGIN
    
   --Actualiza las ordenes de retiro a activas en el caso que tengan citas
    UPDATE O
	SET O.Cod_Estado='ACT' ,
    O.Fec_Vig_Orden_Retiro=GETDATE() 
	FROM dbo.CIT_OrdenRetiro O
    INNER JOIN CIT_Cita C ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro 
	WHERE
		O.Nro_Orden_Retiro like '%'+@Nro_Orden_Retiro+'%'  
        AND O.Cod_Estado='INA' AND C.Cod_Estado <>'DES'
    
END







GO
/****** Object:  StoredProcedure [dbo].[CIT_IngresarConfigMobile]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_IngresarConfigMobile]  
@IpMobile VARCHAR(200),  
@Balanza INT  
AS BEGIN

DECLARE @PANEL varchar(2)
SET @PANEL = 'NO'

IF(@Balanza = 3) 
SET @PANEL = 'SI'
 
 INSERT INTO CIT_Parametro_PDT  
    ([Codigo]
    ,[Panel]  
    ,[Balanza])  
   VALUES  
    (@IpMobile
    ,@PANEL  
    ,@Balanza)     
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_Insertar_Parametro_Clientes_Especiales]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 15/05/2015
-- Description:	Inserta un registro en la tabla de 
-- clientes especiales de la configiracion de citas
-- =============================================
ALTER PROCEDURE [dbo].[CIT_Insertar_Parametro_Clientes_Especiales]
	@RUC varchar(11)
As
Begin
	SET NOCOUNT ON;
	Insert Into dbo.CIT_Parametro_Clientes_Especiales (RUC, Fec_Registro)
	Values (@RUC, getdate())

	select SCOPE_IDENTITY()
End

GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarAcciones]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarAcciones]
@acc_nombre NVARCHAR(500),
@USU_Codigo NVARCHAR(25)
AS
BEGIN
	DECLARE @Ident INT

	IF( (SELECT COUNT(ACC_Codigo) FROM [CIT_Acciones] WHERE  ACC_Nombre = @acc_nombre) > 0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[CIT_Acciones]
				(ACC_Nombre
				,ACC_Codigo_Registra
				,ACC_Fecha_Registra)
			VALUES
				(@acc_nombre
				,@USU_Codigo
				,getdate())
		SET @Ident = SCOPE_IDENTITY()

	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarAccionesPerfil]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarAccionesPerfil]
@per_codigo INT,
@per_nombre NVARCHAR(500),
@acc_codigo INT,
@acc_nombre NVARCHAR(500),
@USU_Codigo NVARCHAR(25)
AS
BEGIN
	DECLARE @Ident INT

	IF((SELECT COUNT(*) FROM [CIT_PERFILACCION] WHERE  [per_codigo] = @per_codigo AND [acc_codigo] = @acc_codigo)>0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[CIT_PERFILACCION]
					([per_codigo]
					,[acc_codigo]
					,[USU_Codigo]
					,[per_nombre]
					,[acc_nombre])
				VALUES
					(@per_codigo, 
					@acc_codigo, 
					@USU_Codigo, 
					@per_nombre, 
					@acc_nombre)
		SET @Ident = @per_codigo
	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
-- Nombre: CIT_InsertarCita  
-- Objetivo: Insertar Cita   
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100609  
-- Modificación: 
-- 28/10/2014 - RV - SE AGREGÓ EL CAMPO CONTENEDOR PARA REGISTRARLO SI SE SELECCIONA AL MOMENTO DE GENERAR LA CITA
--				TAMBIÉN SE AGREGÓ LA LÓGICA PARA OBTENER EL NÚMERO DE OR CUANDO SE GENERE UNA CITA POST.
-- 01/12/2014 - RV - SE OBTIENE COMO RESPUESTA EL ID DEL REGISTRO
----------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_InsertarCita]  
@p_Ident_Cita_Padre	INT,    
@p_Cod_Volante		VARCHAR(11),    
@p_Ident_Turno		INT,   
@p_UsuarioRegistro  VARCHAR(50),--Dato que llega de la intranet de neptunia  
@Facturado			INT,
@p_EsIntegral		BIT = 0,
@p_Cod_Contenedor	VARCHAR(11) = NULL,
@p_Placa			varchar(6) = null --agregado por jrivero bvision 21/05/2015
AS  
BEGIN  

	DECLARE @estado VARCHAR(3),
			@v_Ident_Cita INT

	IF(@Facturado = 0)
	BEGIN
		SET @estado = 'REG';
	END
	ELSE
	BEGIN
		SET @estado = 'FAC';
	END

	DECLARE @NRO_OR VARCHAR(20), @FECHA_FACTURADO DATETIME
	/*EVALUAMOS SI EL CÓDIGO DE VOLANTE Y CONTENEDOR TIENE UNA OR GENERADA*/	
	SELECT TOP 1
		@NRO_OR = Nro_Orden_Retiro, 
		@p_Cod_Contenedor = Cod_Contenedor,
		@FECHA_FACTURADO = Fec_Reg_Orden_Retiro
	FROM dbo.CIT_OrdenRetiro 
	WHERE 
	ConCita = 0
	AND Cod_Volante = @p_Cod_Volante
	AND (Cod_Contenedor = @p_Cod_Contenedor OR ISNULL(@p_Cod_Contenedor,'') = '')
	--AND Nro_Orden_Retiro LIKE '576030%' ORDER BY Fec_Reg_Orden_Retiro

	/*SI LA CITA YA TIENE FACTURA ENTONCES EL ESTADO DE LA CITA SERÁ FACTURADO*/
	IF(ISNULL(@NRO_OR,'')<> '')
		SET @estado = 'FAC'

	INSERT CIT_Cita( 
		Cod_Cita_Padre,  
		Cod_Volante,   
		Ident_Turno,  
		Cod_Estado,  
		Fec_Reg_Cita,   
		Usuario_Registro, 
		EsIntegral,
		Cod_Contenedor,
		Nro_Orden_Retiro,
		Fec_Fac_Cita,
		Placa
	)  

	VALUES    (
		@p_Ident_Cita_Padre,  
		@p_Cod_Volante,  
		@p_Ident_Turno,  
		@estado,  
		getdate(),  
		@p_UsuarioRegistro,
		@p_EsIntegral,
		@p_Cod_Contenedor,
		@NRO_OR,
		@FECHA_FACTURADO,
		@p_Placa
	)

	SET @v_Ident_Cita = SCOPE_IDENTITY()

	UPDATE CIT_Turno  
	SET 
		Cap_Res_Turno = Cap_Res_Turno+1,  
		Cap_Disp_Turno = Cap_Disp_Turno-1  
	WHERE 
	Ident_Turno = @p_Ident_Turno  

	/*ACTUALIZAMOS LA ORDEN DE RETIRO PARA NO VOLVER A SER CONSIDERADA*/
	UPDATE dbo.CIT_OrdenRetiro
	SET 
		ConCita = 1
	WHERE 
	Nro_Orden_Retiro = @NRO_OR

	/*ACTUALIZAMOS EL CONTENEDOR PARA QUE NO VUELVA A SER ASIGNADO*/
	UPDATE dbo.CIT_Contenedor
	SET
		Ord_Contenedor = 0
	WHERE 
	Cod_Volante = @p_Cod_Volante
	AND Cod_Contenedor = @p_Cod_Contenedor
	AND ISNULL(Ord_Contenedor,99) = 99

	SELECT @v_Ident_Cita

END

GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarCita_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarCita_JFN] @p_Ident_Cita_Padre INT
	,@p_Cod_Volante VARCHAR(11)
	,@p_Ident_Turno INT
	,@p_UsuarioRegistro VARCHAR(50)
	,--Dato que llega de la intranet de neptunia    
	@Facturado INT
	,@p_EsIntegral BIT = 0
	,@p_Cod_Contenedor VARCHAR(11) = NULL
	,@p_Placa VARCHAR(6) = NULL --agregado por jrivero bvision 21/05/2015  
AS
BEGIN
	DECLARE @estado VARCHAR(3)
		,@v_Ident_Cita INT

	IF (@Facturado = 0)
	BEGIN
		SET @estado = 'REG';
	END
	ELSE
	BEGIN
		SET @estado = 'FAC';
	END

	DECLARE @NRO_OR VARCHAR(20)
		,@FECHA_FACTURADO DATETIME

	/*EVALUAMOS SI EL CÓDIGO DE VOLANTE Y CONTENEDOR TIENE UNA OR GENERADA*/
	SELECT TOP 1 @NRO_OR = A.Nro_Orden_Retiro
		,@p_Cod_Contenedor = A.Cod_Contenedor
		,@FECHA_FACTURADO = A.Fec_Reg_Orden_Retiro
	FROM dbo.CIT_OrdenRetiro A
	--//VALIDAR QUE LA ORDEN DE RETIRO NO ESTE CANCELADA
	INNER JOIN [SP3TDA-DBSQL01].terminal.dbo.ddordret41 B with (nolock) ON B.nroord41 = SUBSTRING(LTRIM(RTRIM(A.Nro_Orden_Retiro)),1,6) 
																 AND ISNULL(B.status41,'') <> 'C'
	--//
	WHERE A.ConCita = 0
		AND A.Cod_Volante = @p_Cod_Volante
		AND (
			A.Cod_Contenedor = @p_Cod_Contenedor
			OR ISNULL(@p_Cod_Contenedor, '') = ''
			)

	--AND Nro_Orden_Retiro LIKE '576030%' ORDER BY Fec_Reg_Orden_Retiro  
	/*SI LA CITA YA TIENE FACTURA ENTONCES EL ESTADO DE LA CITA SERÁ FACTURADO*/
	IF (ISNULL(@NRO_OR, '') <> '')
		SET @estado = 'FAC'

	INSERT CIT_Cita (
		Cod_Cita_Padre
		,Cod_Volante
		,Ident_Turno
		,Cod_Estado
		,Fec_Reg_Cita
		,Usuario_Registro
		,EsIntegral
		,Cod_Contenedor
		,Nro_Orden_Retiro
		,Fec_Fac_Cita
		,Placa
		)
	VALUES (
		@p_Ident_Cita_Padre
		,@p_Cod_Volante
		,@p_Ident_Turno
		,@estado
		,getdate()
		,@p_UsuarioRegistro
		,@p_EsIntegral
		,
		-- INICIO JHFLORES  
		@p_Cod_Contenedor
		,
		-- FIN JHFLORES  
		@NRO_OR
		,@FECHA_FACTURADO
		,@p_Placa
		)

	SET @v_Ident_Cita = SCOPE_IDENTITY()

	--||  
	-- INICIO JHFLORES  
	-- 21/07/2016  
	--||  
	DECLARE @Fe_Actual AS DATETIME

	SET @Fe_Actual = getdate()

	EXEC CIT_AUDITORIA_ESTADOS @estado
		,@v_Ident_Cita
		,@Fe_Actual
		,@p_UsuarioRegistro;

	--||  
	-- FIN JHFLORES  
	--||  
	UPDATE CIT_Turno
	SET Cap_Res_Turno = Cap_Res_Turno + 1
		,Cap_Disp_Turno = Cap_Disp_Turno - 1
	WHERE Ident_Turno = @p_Ident_Turno

	/*ACTUALIZAMOS LA ORDEN DE RETIRO PARA NO VOLVER A SER CONSIDERADA*/
	UPDATE dbo.CIT_OrdenRetiro
	SET ConCita = 1
	WHERE Nro_Orden_Retiro = @NRO_OR

	/*ACTUALIZAMOS EL CONTENEDOR PARA QUE NO VUELVA A SER ASIGNADO*/
	UPDATE dbo.CIT_Contenedor
	SET Ord_Contenedor = 0
	WHERE Cod_Volante = @p_Cod_Volante
		AND Cod_Contenedor = @p_Cod_Contenedor
		AND ISNULL(Ord_Contenedor, 99) = 99

	SELECT @v_Ident_Cita
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarCitaPadre]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- Nombre: CIT_InsertarVolante      
-- Objetivo: Insertar datos del volante      
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100608      
----------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_InsertarCitaPadre]      
@p_Cod_Volante				VARCHAR(6),        
@p_Total_Contenedor		INT,       
@p_Disponible_Contenedor   INT,      
@p_Bloqueados_Contenedor	INT,    
@p_Reservados				INT,    
@p_Retenidos_Contenedor	INT,
@p_UsuarioRegistro VARCHAR(50)--Dato que llega de la INTranet de neptunia
AS      
BEGIN      
	DECLARE @Ident INT      
	INSERT CIT_CitaPadre (
		Cod_Volante,      
		Nro_Tot_Contenedor,       
		Nro_Disp_Contenedor,      
		Nro_Bloq_Contenedor,     
		Cup_Res_Cita_Padre,       
		Nro_Ret_Contenedor,     
		Fecha_Registro,      
		Usuario_Registro      
    ) 

	VALUES (
		@p_Cod_Volante,      
		@p_Total_Contenedor,      
		@p_Disponible_Contenedor,      
		@p_Bloqueados_Contenedor,    
		@p_Reservados,    
		@p_Retenidos_Contenedor, 

		GETDATE(),
		@p_UsuarioRegistro)

	SET @Ident = SCOPE_IDENTITY()       
	SELECT @Ident
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarCodigosAutorizacion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarCodigosAutorizacion]
@Ruc varchar(11),
@Codigo_Generado varchar(20),
@Fec_Registro datetime,
@Estado char(1)
as

WHILE (EXISTS (SELECT Codigo_Generado FROM CIT_CodigoAutogenerado WHERE Codigo_Generado=@Codigo_Generado AND FEC_REGISTRO  BETWEEN DATEADD(DAY,-15,GETDATE()) AND GETDATE()))
BEGIN
	IF @Codigo_Generado>=99999
		BEGIN
			SET @Codigo_Generado=1001
		END
	ELSE
		BEGIN
			SET @Codigo_Generado=@Codigo_Generado+1
		END	
END

insert into dbo.CIT_CodigoAutogenerado(
Ruc,
Codigo_Generado,
Fec_Registro,
Estado)

values(
@Ruc,
@Codigo_Generado,
@Fec_Registro,
@Estado)

select @@identity
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarCodigosAutorizacion_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarCodigosAutorizacion_JFN] @Ruc VARCHAR(11)
	,@Codigo_Generado VARCHAR(20)
	,@Fec_Registro DATETIME
	,@Estado CHAR(1)
	,@No_UsuarioCreado VARCHAR(50)
AS
WHILE (
		EXISTS (
			SELECT Codigo_Generado
			FROM CIT_CodigoAutogenerado
			WHERE Codigo_Generado = @Codigo_Generado
				AND FEC_REGISTRO BETWEEN DATEADD(DAY, - 15, GETDATE())
					AND GETDATE()
			)
		)
BEGIN
	IF @Codigo_Generado >= 99999
	BEGIN
		SET @Codigo_Generado = 1001
	END
	ELSE
	BEGIN
		SET @Codigo_Generado = @Codigo_Generado + 1
	END
END

--|OBTENER USUARIO LOGUEADO A NEPTUNIA ONLINE  
SET @No_UsuarioCreado = LTRIM(RTRIM(@No_UsuarioCreado))

DECLARE @usuario_login VARCHAR(50)

IF @No_UsuarioCreado <> 'ADMIN'
BEGIN
	IF @No_UsuarioCreado = ''
	BEGIN
		SET @usuario_login = 'admin'
	END
	ELSE
	BEGIN
		IF EXISTS (
				SELECT *
				FROM [SP3TDA-DBSQL01].SEGURIDAD.DBO.SGT_USUARIO WITH (NOLOCK)
				WHERE USU_CODIGO = @No_UsuarioCreado
				)
		BEGIN
			SELECT @usuario_login = USU_CODIGOINTERNO
			FROM [SP3TDA-DBSQL01].SEGURIDAD.DBO.SGT_USUARIO WITH (NOLOCK)
			WHERE USU_CODIGO = @No_UsuarioCreado
		END
		ELSE
		BEGIN
			SET @usuario_login = 'admin'
		END
	END
END
ELSE
BEGIN
	SET @usuario_login = 'admin'
END

--|  
INSERT INTO dbo.CIT_CodigoAutogenerado (
	Ruc
	,Codigo_Generado
	,Fec_Registro
	,Estado
	,No_UsuarioCreado
	)
VALUES (
	@Ruc
	,@Codigo_Generado
	,@Fec_Registro
	,@Estado
	,@usuario_login
	)

--,@No_UsuarioCreado  
SELECT @@identity
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarConfigAlerta]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarConfigAlerta]
@Descripcion VARCHAR(200)
,@Dias INT
,@Sucursales VARCHAR(1000)
,@CodSucursales VARCHAR(1000)
,@NVeces INT = 0
,@Intervalo INT = 0
AS
BEGIN
	DECLARE @Ident INT

	IF((SELECT COUNT(Id) FROM [CIT_Parametro_Alertas] WHERE  [Descripcion] = @Descripcion)>0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[CIT_Parametro_Alertas]
			([Descripcion]
			,[Dias]
			,[Sucursales]
			,[CodSucursales]
			,[NVeces]
			,[Intervalo]
			)
		VALUES
			(@Descripcion
			,@Dias
			,@Sucursales
			,@CodSucursales
			,@NVeces
			,@Intervalo
			)
		SET @Ident = SCOPE_IDENTITY()
	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarConfigPDT]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modificación: 
-- RV - 28/11/2014 - Se agregó una condición para controlar que sólo exista una balanza con panel
-- RV - 04/12/2014 - Se comentó la validación de una balanza asociada a un sólo PDT
ALTER PROCEDURE [dbo].[CIT_InsertarConfigPDT]
@codigo NVARCHAR(50),
@Panel CHAR(2),
@Balanza INT
AS
BEGIN
	DECLARE @Ident INT

	SET @Ident = 0
	/*VALIDAMOS QUE NO EXISTA UN PDT CON EL MISMO IP*/
	IF((SELECT COUNT(Id) FROM [CIT_Parametro_PDT] WHERE  [codigo] = @codigo)>0 )
	BEGIN
		SET @Ident = -1 
	END

	/*VALIDAMOS QUE NO EXISTA UNA BALANZA CON MÁS DE UN PDT*/
	--IF((SELECT COUNT(Id) FROM [CIT_Parametro_PDT] WHERE  Balanza = @Balanza)>0 )
	--BEGIN
	--	SET @Ident = -2 
	--END

	/*VALIDAMOS QUE NO EXISTA MÁS DE UNA BALANZA CON PANEL*/
	IF(((SELECT COUNT(Id) FROM [CIT_Parametro_PDT] WHERE Panel = 'SI') > 0) AND @Panel = 'SI')
	BEGIN 
		SET @Ident = -3
	END

	IF(@Ident = 0)
	BEGIN
		INSERT INTO [dbo].[CIT_Parametro_PDT]
				([codigo]
				,[Panel]
				,[Balanza])
			VALUES
				(@codigo
				,@Panel
				,@Balanza)
		SET @Ident = SCOPE_IDENTITY()
	END 

	SELECT @Ident  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarContenedor]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------  
-- Nombre: CIT_InsertarContenedor  
-- Objetivo: Insertar datos del CONTENEDOR  
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100608  
-- Modificación:
-- 28/11/2014 - Se añadió el parámetro asignado para registrar aquellos contenedores que ya hayan sido retirados, por default el valor es falso.
--------------------------------------------------------------------  
ALTER PROCEDURE [dbo].[CIT_InsertarContenedor]  
@p_Cod_Volante    varchar(6),    
@p_Cod_Contenedor   varchar(11),   
@p_CodEstado      bit,  
@p_UsuarioBloqueo   varchar(20),  
@p_FechaBloqueo    datetime,  
@p_MotivoBloqueo   varchar(20),  
@p_UsuarioRegistro   varchar(50),--Dato que llega de la intranet de neptunia  
@p_Ord_Contenedor int,
@p_Asignado bit = 0
AS  
BEGIN  
	DECLARE @EXISTE INT  
	DECLARE @ESTADO varchar(3)  

	IF (@p_CodEstado=1)   
	BEGIN  
		SET @ESTADO='DBL'  
	END  
	ELSE  
	BEGIN   
		SET @ESTADO='BLQ'  
	END  

	/*OBTENEMOS INFORMACIÓN SI YA SE HA REGISTRADO EL CONTENEDOR*/
	DECLARE @Cod_ContenedorTMP VARCHAR(11), @Ord_ContenedorTMP INT
	SELECT 

		@Cod_ContenedorTMP = Cod_Contenedor,
		@Ord_ContenedorTMP = Ord_Contenedor
	FROM dbo.CIT_Contenedor
	WHERE 
	Cod_Volante=@p_Cod_Volante 
	AND Cod_Contenedor=@p_Cod_Contenedor 

	/*SI EL CONTENEDOR NO EXISTE ENTONCES LO INSERTAMOS*/
	IF (ISNULL(@Cod_ContenedorTMP,'')= '')  
	BEGIN  
		INSERT CIT_Contenedor (Cod_Volante,  
			 Cod_Contenedor,   
			 Cod_Estado,  
			 Usu_Blo_Contenedor,  
			 Fec_Blo_Contenedor,   
			 Mot_Blo_Contenedor,  
			 Fec_Reg_Contenedor,  
			 Usuario_Registro,

			 Ord_Contenedor,
			 Asignado)  

		VALUES    (
			@p_Cod_Volante,  
			@p_Cod_Contenedor,  
			@ESTADO,  
			@p_UsuarioBloqueo,  
			@p_FechaBloqueo,  
			@p_MotivoBloqueo,  
			getdate(),  
			@p_UsuarioRegistro,
			@p_Ord_Contenedor,
			@p_Asignado)  
	END  
	ELSE  
	BEGIN 
		/*SÓLO ACTUALIZAREMOS AQUELLOS REGISTROS QUE NO HALLAN SIDO YA SELECCIONADOS PARA UNA CITA,
		RECONOCEMOS ESTO CON EL CAMPO ORD_CONTENEDOR, NO PERTENECE A UNA CITA CUANDO ES NULL O 99*/
		IF(ISNULL(@Ord_ContenedorTMP,99) = 99)
		BEGIN
			UPDATE CIT_Contenedor  
			SET     
				Cod_Estado=@ESTADO,  
				Usu_Blo_Contenedor=@p_UsuarioBloqueo,  
				Fec_Blo_Contenedor=@p_FechaBloqueo,   
				Mot_Blo_Contenedor=@p_MotivoBloqueo,  
				Usuario_Registro=@p_UsuarioRegistro,

				Ord_Contenedor = @p_Ord_Contenedor      
			WHERE  
			Cod_Volante=@p_Cod_Volante
			AND Cod_Contenedor=@p_Cod_Contenedor  
		END
	END  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarLogProcesoTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 04/12/2014
-- Description:	REGISTRA LA INFORMACIÓN DEL TURNO QUE ESTÁ SIENDO PROCESADO
-- EXEC CIT_InsertarLogProcesoTurno '20141204','RV-TEST','20:00-22:00'
-- =============================================
ALTER PROCEDURE [dbo].[CIT_InsertarLogProcesoTurno]
@p_Fec_Turno DATETIME,
@p_Usu_Registro VARCHAR(50),
@p_Des_Turno VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @v_Fec_Actual DATETIME,
			@v_Ident_LogProcesoTurno BIGINT,
			@v_Fec_Hor_Turno DATETIME,
			@v_Seg_Concurrencia INT
			
	SELECT @v_Seg_Concurrencia = Valor_Parametro FROM CIT_Parametro WHERE Cod_Parametro = 25
	

	SET @v_Fec_Actual = GETDATE()

	SET @v_Fec_Hor_Turno = CONVERT(DATETIME, CONVERT(VARCHAR(10),@p_Fec_Turno,112) + ' ' + SUBSTRING(@p_Des_Turno,1,5)) 

	SELECT 
		@v_Ident_LogProcesoTurno = Ident_LogProcesoTurno 
	FROM CIT_LogProcesoTurno (NOLOCK)
	WHERE 
	Fec_Turno = @v_Fec_Hor_Turno -- '555420' -- 
	AND ((Procesado = 0
	AND Fec_Fin_Proceso IS NULL
	AND DATEDIFF(SS, Fec_Ini_Proceso, @v_Fec_Actual) < @v_Seg_Concurrencia) 
	OR DATEDIFF(SS, Fec_Ini_Proceso, @v_Fec_Actual) < @v_Seg_Concurrencia)
	
	SET @v_Ident_LogProcesoTurno = ISNULL(@v_Ident_LogProcesoTurno,0)

	IF(@v_Ident_LogProcesoTurno = 0)
	BEGIN 
		INSERT INTO CIT_LogProcesoTurno (
					Fec_Turno,
					Fec_Ini_Proceso,
					Usu_Registro,
					Procesado
		)
		VALUES (
				@v_Fec_Hor_Turno,
				@v_Fec_Actual,
				@p_Usu_Registro,
				0
		)
	END
	SELECT @v_Ident_LogProcesoTurno
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarLogProcesoVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 03/12/2014
-- Description:	REGISTRA LA INFORMACIÓN DEL VOLANTE QUE ESTÁ SIENDO PROCESADO
-- EXEC CIT_InsertarLogProcesoVolante '555420','RV-TEST'
-- =============================================
ALTER PROCEDURE [dbo].[CIT_InsertarLogProcesoVolante]
@p_Cod_Volante VARCHAR(6),
@p_Usu_Registro VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @v_Fec_Actual DATETIME,
			@v_Ident_LogProcesoVolante BIGINT,
			@v_Seg_Concurrencia INT
			
	SELECT @v_Seg_Concurrencia = Valor_Parametro FROM CIT_Parametro WHERE Cod_Parametro = 26

	SET @v_Fec_Actual = GETDATE()

	SELECT 
		@v_Ident_LogProcesoVolante = Ident_LogProcesoVolante 
	FROM CIT_LogProcesoVolante (NOLOCK) 
	WHERE 
	Cod_Volante = @p_Cod_Volante -- '555420' -- 
	AND ((Procesado = 0
	AND Fec_Fin_Proceso IS NULL
	AND DATEDIFF(SS, Fec_Ini_Proceso, @v_Fec_Actual) < @v_Seg_Concurrencia) 
	OR DATEDIFF(SS, Fec_Ini_Proceso, @v_Fec_Actual) < @v_Seg_Concurrencia)

	SET @v_Ident_LogProcesoVolante = ISNULL(@v_Ident_LogProcesoVolante,0)

	IF(@v_Ident_LogProcesoVolante = 0)
	BEGIN 
		INSERT INTO CIT_LogProcesoVolante (
					Cod_Volante,
					Fec_Ini_Proceso,
					Usu_Registro,
					Procesado
		)
		VALUES (
				@p_Cod_Volante,
				@v_Fec_Actual,
				@p_Usu_Registro,
				0
		)
	END
	SELECT @v_Ident_LogProcesoVolante
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarReservaCupos]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarReservaCupos]
@Fec_Desde datetime , 
@Fec_Hasta datetime, 
@Tur_Reserva varchar(50), 
@Cantidad int
AS  
BEGIN
	INSERT INTO  dbo.CIT_ReservaCupos (Fec_Desde, Fec_Hasta, Tur_Reserva, Cantidad)  
	VALUES(@Fec_Desde, @Fec_Hasta, @Tur_Reserva, @Cantidad)  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarSucursal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_InsertarSucursal]
	@codigo int,
	@Nombre varchar(100)
AS
BEGIN
	DECLARE @Ident int  ;

	IF((select Count(*) from [CIT_Sucursal] where  [codigo] = @codigo )>0 )
	BEGIN
		SET @Ident = -1 
	END
	ELSE
	BEGIN
		IF((select Count(*) from [CIT_Sucursal] where  [Nombre] = @Nombre)>0 )
		BEGIN
			SET @Ident = -2 
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[CIT_Sucursal]
					([codigo]
					,[Nombre])
			VALUES
					(@codigo
					,@Nombre)

			SET @Ident = @codigo
		END
	END
	SELECT @Ident
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  CIT_InsertarTurno '10:00-10:30','2010-06-11 00:00:00.000' ,'sistemas'
----------------------------------------------------------------------
-- Nombre: CIT_InsertarTurno  
-- Objetivo: Insertar turno  
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100609  
----------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_InsertarTurno]  
@p_Des_Turno		VARCHAR(18),    
@p_Fec_Turno		DATETIME,    
@p_UsuarioRegistro  VARCHAR(50),	--Dato que llega de la INTranet de neptunia  
@p_Integral			INT

AS  
BEGIN  
	DECLARE @Ident INT, 
			@intervalo DECIMAL(18,7),
			@sHoraInicio VARCHAR(15),
			@sHoraFin VARCHAR(15)

	DECLARE @Existe INT  
	DECLARE @DESTURNO VARCHAR(18)  
	DECLARE @FECHATURNO DATETIME  
	DECLARE @Capacidad INT  
	DECLARE @SemanaLaboral INT

	SELECT 
		@SemanaLaboral = Valor_Parametro 

	FROM CIT_PARAMETRO
	WHERE 
	Cod_Parametro = 7

	SELECT 
		@intervalo = valor_parametro 
	FROM CIT_Parametro  
	WHERE 
	Cod_Parametro = 6 --Identificador del parametro INTervalo 

	SELECT 
		@sHoraInicio=G.DescmCampo
	FROM dbo.CIT_Parametro P
	INNER JOIN dbo.PAR_Tabla_Generica G ON P.Valor_Parametro = G.ValorCampo AND G.Ident_Tabla = 2
	WHERE 
	Cod_Parametro  = CASE WHEN @p_Integral = 1 THEN 4 ELSE 2 END

	SELECT @sHoraFin=G.DescmCampo
	FROM dbo.CIT_Parametro P
	INNER JOIN dbo.PAR_Tabla_Generica G ON P.Valor_Parametro = G.ValorCampo AND G.Ident_Tabla = 2
	WHERE 
	Cod_Parametro  = CASE WHEN @p_Integral = 1 THEN 5 ELSE 3 END

	SELECT TOP 1
		@DESTURNO=Turno_Capacidad,
		@FECHATURNO=Fecha_Capacidad,
		@Capacidad=Can_Capacidad  
	--SELECT Turno_Capacidad,Fecha_Capacidad,Can_Capacidad  
	FROM (  
		SELECT   
			C.Turno_Capacidad,  
			C.Fecha_Capacidad,  
			C.Can_Capacidad

		FROM CIT_CapacidadMaximaAtencionTurno C  
		LEFT OUTER JOIN CIT_Turno T ON C.Turno_Capacidad = T.Des_Turno AND C.Fecha_Capacidad = T.Fec_Turno  
		LEFT OUTER JOIN (
			SELECT
				Fec_Bloq_Cita,
				Tur_Bloq_Cita 
			FROM dbo.CIT_FechaBloqueoCita 
			WHERE Fec_Bloq_Cita>=GETDATE()
		) B ON C.Fecha_Capacidad = B.Fec_Bloq_Cita AND C.Turno_Capacidad = B.Tur_Bloq_Cita
		--WHERE Fecha_Capacidad>=@p_Fec_Turno and Turno_Capacidad>=@p_Des_Turno 
		WHERE 
		(CONVERT(VARCHAR,Fecha_Capacidad,112) + Turno_Capacidad) >=(CONVERT(VARCHAR,@p_Fec_Turno,112) + @p_Des_Turno) 
		AND	(CONVERT(DECIMAL(18,7),DATEDIFF(mi,LEFT(Turno_Capacidad,5),right(Turno_Capacidad,5)))/60) = @intervalo 
		AND T.Fec_Turno IS NULL  
		AND LEFT(Turno_Capacidad,5)>=@sHoraInicio
		AND RIGHT(Turno_Capacidad,5)<=@sHoraFin
		AND DATEPART(weekday,Fecha_Capacidad) <> CASE WHEN @SemanaLaboral=1 THEN 1 ELSE 0 END
		AND B.Tur_Bloq_Cita IS NULL

		UNION  

		SELECT  
			T.Des_Turno,  
			T.Fec_Turno,  
			T.Cap_Disp_Turno
		FROM CIT_Turno T  
		LEFT OUTER JOIN (SELECT Fec_Bloq_Cita,Tur_Bloq_Cita FROM dbo.CIT_FechaBloqueoCita WHERE Fec_Bloq_Cita>=GETDATE()) B ON
		T.Fec_Turno = B.Fec_Bloq_Cita AND
		T.Des_Turno = B.Tur_Bloq_Cita
		WHERE T.Cap_Disp_Turno>0   AND  
		--T.Des_Turno>=@p_Des_Turno and T.Fec_Turno>=@p_Fec_Turno
		(CONVERT(VARCHAR,T.Fec_Turno,112) + T.Des_Turno) >=(CONVERT(VARCHAR,@p_Fec_Turno,112) + @p_Des_Turno)
		AND LEFT(T.Des_Turno,5)>=@sHoraInicio
		AND RIGHT(T.Des_Turno,5)<=@sHoraFin
		AND DATEPART(WEEKDAY,T.Fec_Turno) <> CASE WHEN @SemanaLaboral=1 THEN 1 ELSE 0 END
		AND B.Tur_Bloq_Cita IS NULL
	) lista  
	ORDER BY 2,1

	SET @Existe = (
		SELECT Ident_Turno   
		FROM CIT_Turno   
		WHERE 
		Des_Turno=@DESTURNO 
		AND Fec_Turno=@FECHATURNO
	)  

	IF (@Existe IS NULL)  
	BEGIN   
		INSERT CIT_Turno (Des_Turno,  
			 Fec_Turno,   
			 Cap_Max_Turno,  
			 Cap_Res_Turno,   
			 Cap_Disp_Turno,  
			 Fecha_Registro,  
			 Usuario_Registro  
			 )  

		VALUES    (@DESTURNO,  
			  @FECHATURNO,  
			  @Capacidad,  
			  0,  
			  @Capacidad,  
			  getdate(),  
			  @p_UsuarioRegistro)  

		SET @Ident = scope_identity()   
		EXEC CIT_ActualizarHistoricoParametroXFecha @FECHATURNO,'REG' 

	END   
	ELSE  
	BEGIN   
		SET @Ident = (
			SELECT Ident_Turno   
			FROM CIT_Turno   
			WHERE 
			Des_Turno=@DESTURNO 
			AND Fec_Turno=@FECHATURNO
		)
	END  

	SELECT @Ident 

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertarVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  
----------------------------------------------------------------------  
-- Nombre: CIT_InsertarVolante  
-- Objetivo: Insertar datos del volante  
-- Creacion: Juan Carlos Urrelo - Gesfor Perú - 20100608  
--------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_InsertarVolante]  
 @p_Cod_Volante    Varchar(6),    
 @p_Con_Volante    Varchar(80),   
    @p_Ruc_Con_Volante    varchar(11),  
    @p_Nav_Volante    varchar(30),  
 @p_Via_Volante    varchar(10),  
    @p_Cnc_Volante    varchar(25),  
    @p_Fec_Ing_Volante   datetime,  
 @p_Age_Adu_Volante   varchar(80),  
 @p_Ruc_Age_Adu_Volante  varchar(11),  
 @p_Email_Age_Adu_Volante varchar(150),  
 @p_Pue_Ori_Volante   varchar(30),  
    @p_Integral     bit,  
    @p_UsuarioRegistro   varchar(50)--Dato que llega de la intranet de neptunia  
  
       
AS  
BEGIN  
DECLARE @EXISTE INT  
  
SET @EXISTE = (SELECT COUNT(COD_VOLANTE)   
      FROM CIT_Volante   
      WHERE  Cod_Volante=@p_Cod_Volante)  
  
IF (@EXISTE=0)  
BEGIN  
INSERT CIT_Volante (Cod_Volante,  
     Con_Volante,   
     Ruc_Con_Volante,  
     Nav_Volante,  
     Via_Volante,   
     Cnc_Volante,  
     Fec_Ing_Volante,  
     Age_Adu_Volante,  
     Ruc_Age_Adu_Volante,  
     Email_Age_Adu_Volante,  
     Pue_Ori_Volante,  
     Integral,  
     Fec_Registro,  
     Usuario_Registro)  
  
VALUES    (@p_Cod_Volante,  
      @p_Con_Volante,  
      @p_Ruc_Con_Volante,  
      @p_Nav_Volante,  
      @p_Via_Volante,  
      @p_Cnc_Volante,  
      @p_Fec_Ing_Volante,  
      @p_Age_Adu_Volante,  
      @p_Ruc_Age_Adu_Volante,  
      @p_Email_Age_Adu_Volante,  
      @p_Pue_Ori_Volante,   
      @p_Integral,  
      getdate(),  
      @p_UsuarioRegistro)  
END  
ELSE  
BEGIN  
UPDATE CIT_Volante  
SET     Con_Volante=@p_Con_Volante,   
     Ruc_Con_Volante=@p_Ruc_Con_Volante,  
     Nav_Volante=@p_Nav_Volante,  
     Via_Volante=@p_Via_Volante,   
     Cnc_Volante=@p_Cnc_Volante,  
     Fec_Ing_Volante=@p_Fec_Ing_Volante,  
     Age_Adu_Volante=@p_Age_Adu_Volante,  
     Ruc_Age_Adu_Volante=@p_Ruc_Age_Adu_Volante,  
     Email_Age_Adu_Volante=@p_Email_Age_Adu_Volante,  
     Pue_Ori_Volante=@p_Pue_Ori_Volante,  
     Integral=@p_Integral,  
     Fec_Registro=getdate(),  
     Usuario_Registro=@p_UsuarioRegistro       
  
WHERE  Cod_Volante=@p_Cod_Volante  
END  
END  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[CIT_InsertEnvioSparcTemporal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		RV
-- Create date: 06/11/2014
-- Description:	REGISTRA EL ENVÍO TEMPORAL DE SPARC
-- EXEC CIT_InsertEnvioSparcTemporal 
-- =============================================
ALTER PROCEDURE [dbo].[CIT_InsertEnvioSparcTemporal]
@p_Nro_Orden_Retiro VARCHAR(6),
@p_Nro_Salida VARCHAR(10),
@p_Cod_Contenedor VARCHAR(11),
@p_Cod_Aplicacion VARCHAR(20),
@p_Cod_Usuario VARCHAR(50),
@p_Cod_IP VARCHAR(15),
@p_Nro_Placa VARCHAR(10)
AS
return -- APC 29/11/2015
BEGIN
	SET NOCOUNT ON;
	/*OBTENEMOS EL ORDEN DE RECOJO SI SE HA DEFINIDO UNO PARA EL CONTENEDOR*/
	-- OBTENEMOS EL NRO DE VOLANTE
	DECLARE @v_Nro_Volante VARCHAR(6),
			@v_Ord_Contenedor INT

	SELECT @v_Nro_Volante = Cod_Volante 
	FROM dbo.CIT_OrdenRetiro
	WHERE 
	Nro_Orden_Retiro LIKE ( @p_Nro_Orden_Retiro + '%')
	AND Cod_Contenedor = @p_Cod_Contenedor

	-- OBTENEMOS EL ORDEN ASIGNADO AL CONTENEDOR
	SELECT @v_Ord_Contenedor = Ord_Contenedor
	FROM dbo.CIT_Contenedor
	WHERE 
	Cod_Contenedor = @p_Cod_Contenedor
	AND Cod_Volante = @v_Nro_Volante

	/*REGISTRAMOS LA INFORMACIÓN*/
	INSERT INTO CIT_EnvioSparcTemporal (
			Nro_Orden_Retiro,
			Nro_Salida,
			Nro_Placa,
			Cod_Contenedor,
			Ord_Contenedor,
			Cod_Aplicacion,
			Cod_Usuario,
			Cod_IP,
			Enviado,
			Atendido,
			Fec_Registro)
	VALUES (
			@p_Nro_Orden_Retiro,
			@p_Nro_Salida,
			@p_Nro_Placa,
			@p_Cod_Contenedor,
			@v_Ord_Contenedor,
			@p_Cod_Aplicacion,
			@p_Cod_Usuario,
			@p_Cod_IP,
			0,
			0,
			GETDATE())
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_LISTAR_CITAS_POR_TIEMPO_ATENCION]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_LISTAR_CITAS_POR_TIEMPO_ATENCION]
@fe_inicio as varchar(8),
@fe_fin as varchar(8)

AS
BEGIN
select  CIT.Ident_Cita,O.Cod_Contenedor_Desp,CIT.Nu_OrdenRetiro_AsociaCita , cit.Fec_Reg_Cita,CIT.Fec_Fac_Cita,CIT.Fec_Ing_Nep_Cita,CIT.Fec_Ing_Bal_Cita,
CIT.Fec_Des_Cita,CIT.Fec_Rep_Cita,CIT.Fec_Ven_Cita,CIT.Fec_Can_Cita, CIT.Fec_Anu_Cita,EST.Des_Estado  from  [dbo].[CIT_Cita] CIT
inner join [dbo].[CIT_Estado] EST on (EST.Cod_Estado=CIT.Cod_Estado)
inner join [dbo].[CIT_Turno] TUR on (CIT.Ident_Turno=TUR.Ident_Turno)
LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON (CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI= O.Nro_Orden_Retiro      )
where TUR.Fec_Turno between @fe_inicio and @fe_fin order by CIT.Ident_Cita desc
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarAniosParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Nombre: CIT_ListaAniosParametros
-- Objetivo: Lista los años según información actual
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarAniosParametros]
AS
BEGIN
	SELECT
		YEAR(GETDATE())	AS [Anio]
	UNION
	SELECT
		YEAR(GETDATE())+1
	ORDER BY 1
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarContenedoresXCodVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- Nombre: CIT_ListarContenedoresXCodVolante
-- Objetivo: Listar contenedores habilitados según Nro. de Volante
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 19/05/2010
-- Modificacion: 
--------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_ListarContenedoresXCodVolante]
@p_Cod_Volante Varchar(6)	--Nro. de Volante
AS
BEGIN
	SELECT
		C.Cod_Volante,
		C.Cod_Contenedor,
		C.Cod_Estado,
		C.Fec_Reg_Contenedor,
		CASE WHEN C.Ord_Contenedor IS NULL THEN 99 ELSE C.Ord_Contenedor END Ord_Contenedor,
		C.Usu_Blo_Contenedor,
		C.Fec_Blo_Contenedor,
		C.Mot_Blo_Contenedor,
		CASE WHEN C.Ord_Contenedor IS NOT NULL THEN 'true' ELSE 'false' END AS [Flag_Asignacion_Contenedor]	
	FROM CIT_CONTENEDOR C
	WHERE	
	C.Cod_Volante = @p_Cod_Volante 
	AND C.Cod_Estado = 'DBL'
	ORDER BY C.Cod_Volante
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarDiasParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Nombre: CIT_ListarDiasParametros
-- Objetivo: Lista días correspondientes al mes y año seleccionado
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
---------------------------------------------------------------------------------

--CIT_ListarDiasParametros 2,2010

ALTER PROCEDURE [dbo].[CIT_ListarDiasParametros]
		@nMes int,
		@nAnio int
AS
BEGIN
	
	DECLARE @sSQL Varchar(8000)
	DECLARE @nDias int,
			@sDias Varchar(2),
			@sMes Varchar(2),
			@sAnio Varchar(4)

	SET @sAnio = RTRIM(LTRIM(STR(@nAnio)))
	SET @sMes = RIGHT('00'+RTRIM(LTRIM(STR(@nMes))),2)
	SET @nDias = 0
	SET @sSQL = 'SELECT 0 AS [DiaValor], ''Todos'' AS [DiaDescripcion]'

	WHILE (@nDias<=31)
	BEGIN
		SET @sDias = RIGHT('00'+RTRIM(LTRIM(STR(@nDias))),2)
		IF (ISDATE(@sAnio+@sMes+@sDias) = 1)
		BEGIN
			SET @sSQL = @sSQL + ' UNION SELECT @nDias,''@sDias'' '
			SET @sSQL = REPLACE(@sSQL,'@nDias',@nDias)
			SET @sSQL = REPLACE(@sSQL,'@sDias',@sDias)
		END
		SET @nDias = @nDias + 1
	END

	EXEC(@sSQL)	
END







GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarEstadosXDstEstado]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------
-- Nombre: CIT_ListarEstadosXDstEstado
-- Objetivo: Lista Estados según el Destino
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100525
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100525
------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarEstadosXDstEstado]
	@p_Dst_Estado Varchar(20)	--Destino Estado
AS
BEGIN
	SELECT
		E.Cod_Estado,
		E.Des_Estado,
		E.Dst_Estado,
		E.Cod_Orden
	FROM dbo.CIT_Estado E
		WHERE E.Cod_Estado = 'TOD'
	UNION
	SELECT
		E.Cod_Estado,
		E.Des_Estado,
		E.Dst_Estado,
		E.Cod_Orden
	FROM dbo.CIT_Estado E
		WHERE E.Dst_Estado=@p_Dst_Estado
	ORDER BY E.Cod_Orden
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarHorariosParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
-- Nombre: CIT_ListarHorariosParametros
-- Objetivo: Lista Horarios Disponibles
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarHorariosParametros]
AS
BEGIN
	SELECT 
		ValorCampo AS [HorarioValor],
		DescmCampo AS [HorarioDescripcion]
	FROM dbo.PAR_Tabla_Generica
	WHERE Ident_Tabla = 2
	ORDER BY ValorCampo
END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarIntervalosTurnosParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
-- Nombre: CIT_ListarIntervalosTurnosParametros
-- Objetivo: Lista Intervalos de Turnos Disponibles
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100527
-------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarIntervalosTurnosParametros]
AS
BEGIN
	SELECT 
		ValorCampo AS [IntervaloTurnoValor],
		DescmCampo AS [IntervaloTurnoDescripcion]
	FROM dbo.PAR_Tabla_Generica
	WHERE Ident_Tabla = 1
	ORDER BY ValorCampo
END


GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarMesesParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----------------------------------------------------------------------------------
-- Nombre: CIT_ListarMesesParametros
-- Objetivo: Lista los meses
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarMesesParametros]
AS
BEGIN
	SELECT
		0 AS [MesValor],
		'Seleccionar' AS [MesDescripcion]
	UNION
	SELECT 
		ValorCampo,
		DescmCampo
	FROM dbo.PAR_Tabla_Generica
		WHERE Ident_Tabla = 3
	ORDER BY 1
END






GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarParametr_PDT]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ListarParametr_PDT]
@CODIGO varchar(15)
AS
BEGIN
	IF(@CODIGO IS NULL) SET @CODIGO = ''

	SELECT 
	P.Id
	,P.Codigo
	,P.Panel
	,P.Balanza
	FROM CIT_PARAMETRO_PDT P
	WHERE
		1 = CASE
			WHEN CODIGO = '' THEN 1
			WHEN CODIGO LIKE  '%' + @CODIGO + '%' THEN 1
			END
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ListarRangoTurnosParametros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------
-- Nombre: CIT_ListarRangoTurnosParametros
-- Objetivo: Lista rangos de turno
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100528
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ListarRangoTurnosParametros]
AS
BEGIN
	DECLARE @nIntervalo					Decimal(18,7),
			@HoraInicio					Datetime,
			@HoraFin					Datetime,
			@HoraInicioIntegrales		Datetime,
			@HoraFinIntegrales			Datetime,			
			@HoraInicioTurno			Varchar(5),
			@HoraFinTurno				Varchar(5),
			@RangoTurno					Varchar(11),
			@sSQL						Varchar(8000)

	SELECT @nIntervalo = CONVERT(Decimal(18,7),P.Valor_Parametro) * 60
	FROM CIT_PARAMETRO P
		WHERE P.Cod_Parametro IN (6)



	SELECT @HoraInicio = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN (
						SELECT MIN(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
						FROM CIT_PARAMETRO P
							WHERE P.Cod_Parametro IN (2,4)
					) P ON
		G.ValorCampo = P.Valor_Parametro
		WHERE G.Ident_Tabla IN (2)

	SELECT @HoraFin = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN (
						SELECT MAX(CONVERT(Decimal(18,7),P.Valor_Parametro)) AS [Valor_Parametro]
						FROM CIT_PARAMETRO P
							WHERE P.Cod_Parametro IN (3,5)
					) P ON
		G.ValorCampo = P.Valor_Parametro
		WHERE G.Ident_Tabla IN (2)

/*
	SELECT @HoraInicio = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN CIT_PARAMETRO P ON
			G.ValorCampo = P.Valor_Parametro
		WHERE	G.Ident_Tabla IN (2) AND
				P.Cod_Parametro IN (2)

	SELECT @HoraFin = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN CIT_PARAMETRO P ON
			G.ValorCampo = P.Valor_Parametro
		WHERE	G.Ident_Tabla IN (2) AND
				P.Cod_Parametro IN (3)

	SELECT @HoraInicioIntegrales = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN CIT_PARAMETRO P ON
			G.ValorCampo = P.Valor_Parametro
		WHERE	G.Ident_Tabla IN (2) AND
				P.Cod_Parametro IN (4)

	SELECT @HoraFinIntegrales = DescmCampo + ':00'
		FROM dbo.PAR_Tabla_Generica G
		INNER JOIN CIT_PARAMETRO P ON
			G.ValorCampo = P.Valor_Parametro
		WHERE	G.Ident_Tabla IN (2) AND
				P.Cod_Parametro IN (5)
*/

	SET @sSQL = 'SELECT DISTINCT ''0'' AS [RangoTurnoValor], ''Todos'' AS [RangoTurnoDescripcion]'

	WHILE (@HoraInicio<@HoraFin)
	BEGIN
		SET @HoraInicioTurno = CONVERT(Varchar(5),@HoraInicio,108)
		SET @HoraInicio = DATEADD(mi,@nIntervalo,@HoraInicio)
		SET @HoraFinTurno = CONVERT(Varchar(5),@HoraInicio,108)		
		SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno
		SET @sSQL = @sSQL + ' UNION SELECT ''@RangoTurno'', ''@RangoTurno'''
		SET @sSQL = REPLACE(@sSQL,'@RangoTurno',@RangoTurno)
	END
/*
	WHILE (@HoraInicioIntegrales<@HoraFinIntegrales)
	BEGIN
		SET @HoraInicioTurno = CONVERT(Varchar(5),@HoraInicioIntegrales,108)
		SET @HoraInicioIntegrales = DATEADD(mi,@nIntervalo,@HoraInicioIntegrales)
		IF (DATEADD(mi,@nIntervalo,@HoraInicioIntegrales)>@HoraFinIntegrales)
			SET @HoraFinTurno = CONVERT(Varchar(5),@HoraFinIntegrales,108)
		ELSE
			SET @HoraFinTurno = CONVERT(Varchar(5),@HoraInicioIntegrales,108)	
		SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno
		SET @sSQL = @sSQL + ' UNION SELECT ''@RangoTurno'', ''@RangoTurno'''
		SET @sSQL = REPLACE(@sSQL,'@RangoTurno',@RangoTurno)
	END
*/

	EXEC(@sSQL)
    
END







GO
/****** Object:  StoredProcedure [dbo].[CIT_Movil_GetNroServicioIntegral]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_Movil_GetNroServicioIntegral]  
(  
@OrdenRetiro varchar(10)  
)  
AS BEGIN  

SELECT SOR.ORD_CODIGO AS 'NROSERVICIOINTEGRAL'
FROM [SP3TDA-DBSQL01].TERMINAL.DBO.ddordret41 O inner join [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD   
ON O.navvia11 = TD.navvia11 AND O.nrodet12 = TD.nrodet12 inner join [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN SOR  
ON TD.nrosec23 = SOR.ORD_NUMDOCUMENTO  
AND SOR.ORD_FLAGESTADO IS NULL          
WHERE O.nroord41 = @OrdenRetiro 
  
--SELECT    
--SOR.ORD_CODIGO AS 'NROSERVICIOINTEGRAL'  
--FROM CIT_OrdenRetiro O inner join CIT_Volante V  
--ON O.Cod_Volante = V.Cod_Volante COLLATE SQL_Latin1_General_CP1_CI_AS inner join [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD   
--ON TD.NROSEC23 = V.COD_VOLANTE inner join [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN SOR  
--ON SOR.ORD_BL = V.CNC_VOLANTE AND SOR.ORD_NAVVIA = TD.NAVVIA11 AND SOR.ORD_NUMDOCUMENTO <> ''   
--AND SOR.ORD_FLAGESTADO IS NULL          
--WHERE O.Nro_Orden_Retiro = @OrdenRetiro  
  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtCodSucConfigAlerta]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObtCodSucConfigAlerta]
@id INT
AS
BEGIN
	SELECT 
		Dias,
		CodSucursales,
		NVeces,
		Intervalo
	FROM dbo.CIT_Parametro_Alertas
	WHERE 
	Id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObteneConfiguracionAlertas]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObteneConfiguracionAlertas]
AS
BEGIN
	SELECT	
		id,
		Descripcion ,
		Dias,
		Sucursales,
		CodSucursales,
		NVeces,
		Intervalo
	FROM CIT_Parametro_Alertas
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObteneConfiguracionPDT]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObteneConfiguracionPDT] 
AS  
BEGIN  
	SELECT 
		id,  
		codigo,  
		Panel,
		Balanza
	FROM dbo.CIT_Parametro_PDT  
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_Obtener_Accion_Por_Usuario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CIT_Obtener_Accion_Por_Usuario]
@Co_Usuario  nvarchar(500),
@Cod_Accion int
AS
BEGIN
	SELECT acc_codigo,acc_nombre 
	FROM dbo.CIT_PERFILACCION
	WHERE
	usu_codigo = @Co_Usuario
	and acc_codigo= @Cod_Accion
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_OBTENER_FECHA_ULTIMA_CITA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_OBTENER_FECHA_ULTIMA_CITA]
@RUC_CONSIGNATARIO CHAR(11)
AS
BEGIN
	--DECLARE @RUC_CONSIGNATARIO CHAR(11)
	DECLARE @COD_VOLANTE VARCHAR(6)
	DECLARE @FECHA_ULTIMA_CITA DATETIME

	--SET @RUC_CONSIGNATARIO = '20109714039'

	SELECT TOP 1 @COD_VOLANTE = Cod_Volante
	FROM CIT_VOLANTE V
	WHERE V.Ruc_Con_Volante = @RUC_CONSIGNATARIO
	ORDER BY Fec_Registro DESC

	SELECT TOP 1 @FECHA_ULTIMA_CITA = C.Fec_Reg_Cita
	FROM CIT_CITA C
	WHERE C.Cod_Volante = @COD_VOLANTE
	ORDER BY C.Fec_Reg_Cita DESC

	--SELECT @COD_VOLANTE
	SELECT @FECHA_ULTIMA_CITA
	--SELECT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_Obtener_Parametro_Clientes_EspecialesXRuc]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 15/05/2015
-- Description:	Obtiene un cliente de la tabla CIT_Parametro_Clientes_Especiales
-- =============================================
ALTER PROCEDURE [dbo].[CIT_Obtener_Parametro_Clientes_EspecialesXRuc]
	@RUC varchar(11)
As
Begin
	SET NOCOUNT ON;
	Select * from CIT_Parametro_Clientes_Especiales where ruc = @ruc
End

GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerAcciones]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObtenerAcciones]
AS
BEGIN
	SELECT 
		acc_codigo,
		acc_nombre 
	FROM dbo.CIT_Acciones
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerAccionesPerfil]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObtenerAccionesPerfil]
AS
BEGIN
	SELECT 
		per_codigo, 
		per_nombre,
		acc_codigo,
		acc_nombre
	FROM  dbo.CIT_PERFILACCION
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerAccionesPerfiles]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObtenerAccionesPerfiles]
@perfiles  nvarchar(500),
@acc_codigo int
AS
BEGIN
	SELECT acc_codigo,acc_nombre 
	FROM dbo.CIT_PERFILACCION
	WHERE
	acc_codigo = @acc_codigo
	AND per_codigo in (SELECT splitdata FROM dbo.fnSplitString(@perfiles,','))
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerCitaPorOrdenRetiro]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 28/05/2015
-- Description:	Devuelve inforación una cita a partir de la orden de retiro, evitando aquellas que esten anuladas
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ObtenerCitaPorOrdenRetiro]
	@OrdenRetiro as varchar(10) --pasar la orden de retiro como se almacena en terminal si es decir solo los caracteres que estan antes del "-", por ejemplo el campo esta asi en citas 606402-8 y asi en terminal 606402
as
begin
	select Ident_Cita, cod_contenedor, Cod_Cita_Padre, Cod_Volante, Cod_Estado,Fec_Reg_Cita, Fec_Fac_Cita, IsNull(Placa, '') As Placa
	from CIT_Cita 
	where nro_orden_retiro like @OrdenRetiro + '%' and cod_estado != 'ANU' and cod_estado != 'DES'
end
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerCitaPorOrdenRetiroYContenedor]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 26/05/2015
-- Description:	Devuelve inforación una cita a partir de la orden de retiro y el contenedor, evitando aquellas que esten anuladas
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ObtenerCitaPorOrdenRetiroYContenedor]
	@OrdenRetiro as varchar(10), --pasar la orden de retiro como se almacena en terminal si es decir solo los caracteres que estan antes del "-", por ejemplo el campo esta asi en citas 606402-8 y asi en terminal 606402
	@Contenedor as varchar(11)
as
begin
	select Ident_Cita, Cod_Cita_Padre, Cod_Volante, Cod_Estado,Fec_Reg_Cita, Fec_Fac_Cita, IsNull(Placa, '') As Placa
	from CIT_Cita 
	where nro_orden_retiro like @OrdenRetiro + '%' and cod_contenedor = @Contenedor and cod_estado != 'ANU' and cod_estado != 'DES'
end
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerContenedorByNumeroORYPlaca]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  RV    
-- Create date: 23/10/2014    
-- Description: Obtiene la placa registrada en el ingreso desde el PDT para la orden.    
-- PARA QUE APLIQUE LA LÓGICA DEL NÚMERO DE MOVIMIENTO TODOS LOS CONTENEDORES DEL VOLANTE DEBEN HABER SIDO FACTURADOS    
-- ADEMÁS TODOS DEBEN DE TENER CITA PARA EL MISMO TURNO Y FECHA, Y TODAS LAS CITAS DEBEN DE HABER SIDO GENERADAS DE FORMA AUTOMÁTICA    
-- RV - 10/12/2014 - SE MODIFICÓ LA LÓGICA, PARA APLICAR LA LÓGICA DE NÚMERO DE MOVIMIENTOS, SE DARÁ A PARTIR DE LA BOLSA A LA QUE    
-- PERTENEZCA EL CONTENEDOR, CONSIDERANDO EL NÚMERO DE COMPROBANTE COMO FILTRO; ESCENARIOS:    
--     
-- EXEC CIT_ObtenerContenedorByNumeroORYPlaca '587528','XCC222'    
-- =============================================    
ALTER PROCEDURE [dbo].[CIT_ObtenerContenedorByNumeroORYPlaca]    
@pNumeroOR VARCHAR(20),    
@pPlaca VARCHAR(20)    
AS    
BEGIN     
 SET NOCOUNT ON;    
    
 DECLARE @vCodVolante VARCHAR(6),    
   @vCountCTR INT,    
   @vNumeroComprobante VARCHAR(20)    
   --,@pNumeroOR VARCHAR(6)    
   --,@pPlaca VARCHAR(6)    
     
 --SET @vCodVolante = '567170'    
 --SET @pNumeroOR = '588329'    
 --SET @pPlaca = 'GYS111'    
    
 /*OBTENEMOS EL NÚMERO DE VOLANTE*/    
 SELECT @vCodVolante = Cod_Volante,    
  @vNumeroComprobante = Nro_Comprobante     
 FROM dbo.CIT_OrdenRetiro    
 WHERE     
 Nro_Orden_Retiro LIKE (@pNumeroOR + '%')     
 --SELECT @vNumeroComprobante    
    
 DECLARE @TDataContenedoresCITTMP TABLE (Id INT IDENTITY, Cod_Contenedor VARCHAR(11), Ord_Contenedor INT, Nro_Movimientos INT)       
 DECLARE @vNumeroCTRConOrden INT    
    
 DECLARE @TDatosContenedoresTerminal TABLE (Cod_Contenedor VARCHAR(11))    
    
 INSERT INTO @TDatosContenedoresTerminal    
 EXEC [dbo].[SN_NEPT_CIT_ObtenerContenedoresSinSalidaDeAlmacen] @pNumeroOR --'587528' --    
    
 /*OBTENEMOS TODOS LOS CONTENEDORES ASOCIADOS AL NÚMERO DE COMPROBANTE - BOLSA DE CONTENEDORES*/    
 INSERT INTO @TDataContenedoresCITTMP (Cod_Contenedor, Ord_Contenedor)    
 SELECT     
  ORD.Cod_Contenedor,     
  CASE WHEN ISNULL(CTR.Ord_Contenedor, 0) = 0 THEN 99       
   ELSE CTR.Ord_Contenedor END Ord_Contenedor     
 FROM @TDatosContenedoresTerminal CTER    
 LEFT JOIN dbo.CIT_OrdenRetiro ORD ON ORD.Cod_Contenedor = CTER.Cod_Contenedor AND ORD.Nro_Comprobante = @vNumeroComprobante AND ISNULL(ORD.Asignado, 0) = 0    
 LEFT JOIN dbo.CIT_Contenedor CTR ON CTR.Cod_Contenedor COLLATE DATABASE_DEFAULT = ORD.Cod_Contenedor COLLATE DATABASE_DEFAULT    
     
 --SELECT * FROM @TDataContenedoresCITTMP    
 /*OBTENEMOS SI ALGÚN CONTENEDOR TIENE UN ORDEN DE RECOJO ASIGNADO*/    
 SELECT @vNumeroCTRConOrden = COUNT(Cod_Contenedor)     
 FROM @TDataContenedoresCITTMP    
 WHERE     
 Ord_Contenedor NOT IN (0,99)    
 --SELECT @vNumeroCTRConOrden    
     
 SELECT @vCountCTR = COUNT(Id) FROM @TDataContenedoresCITTMP    
    
 /*SI NO SE HA DEFINIDO UN ORDEN DE RECOJO ENTONCES APLICA LA REGLA DEL NÚMERO DE MOVIMIENTOS*/    
 /*SI SE HA DEFINIDO UN ORDEN DE RECOJO ES POR QUE TIENE CITA*/    
 IF(@vNumeroCTRConOrden = 0)    
 BEGIN    
  PRINT 'NO SE HA DEFINIDO NINGÚN ORDEN DE RECOJO'    
  DECLARE @IdMin INT,    
    @IdMax INT    
    
  SET @IdMin = 1    
  SELECT @IdMax = MAX(Id) FROM @TDataContenedoresCITTMP    
    
  WHILE (@IdMin <= @IdMax)    
  BEGIN    
   DECLARE @TMovimientosTMP TABLE (Ruma VARCHAR(20), Nro_Movimientos INT)    
   DECLARE @vCodContenedorTMP VARCHAR(11),    
     @vNroMovimientos INT    
   /*OBTENEMOS LOS PARÁMETROS*/    
   SELECT @vCodContenedorTMP = Cod_Contenedor    
   FROM @TDataContenedoresCITTMP    
   WHERE     
   Id = @IdMin    
    
   INSERT INTO @TMovimientosTMP            
   EXEC dbo.SN_NEPT_CIT_MovimientosXContenedor @vCodContenedorTMP -- 'sudu1234567'--    
   --EXEC [SP3TDA-DBSQL01].Terminal.dbo.CIT_MovimientosXContenedor_10032016 @vCodContenedorTMP    
      
   SELECT @vNroMovimientos = Nro_Movimientos    
   FROM @TMovimientosTMP    
    
   /*ACTUALIZAMOS VALORES EN LA TABLA TEMPORAL*/    
   UPDATE @TDataContenedoresCITTMP    
   SET Nro_Movimientos = @vNroMovimientos    
   WHERE     
   Id = @IdMin    
    
   SET @IdMin = @IdMin + 1    
  END    
  --SELECT * FROM @TDataContenedoresCITTMP    
  SELECT TOP 1 Cod_Contenedor FROM @TDataContenedoresCITTMP ORDER BY Nro_Movimientos, Id    
 END    
 ELSE    
 BEGIN         
  PRINT 'SE HA DEFINIDO ORDEN DE RECOJO'    
  SELECT TOP 1 Cod_Contenedor FROM @TDataContenedoresCITTMP     
  ORDER BY Ord_Contenedor    
  --SELECT dbo.CIT_ObtenerContenedorByCodVolanteYNroPlaca (@vCodVolante, @pPlaca) AS Cod_Contenedor    
 END     
END    
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerCuposReservadosXCodVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------    
-- Nombre: CIT_ObtenerCuposReservadosXCodVolante '197999'    
-- Objetivo: Obtiene los datos del volante ya registrados en la cita padre    
-- Valores Prueba:     
-- Creacion: Juan Carlos Urrelo 20/05/2010    
-- Modificacion:     
-- RV - 01/12/2014 - Se añadió la lógica para disminuir los contenedores que ya han sido retirados.
-- EXEC dbo.CIT_ObtenerCuposReservadosXCodVolante @p_Cod_Volante = '9999999999' -- varchar(6)
ALTER PROCEDURE [dbo].[CIT_ObtenerCuposReservadosXCodVolante]    
@p_Cod_Volante varchar(6)    
AS    
BEGIN

	--Obtenemos de la Cita Padre el Total de Cupos Reservados    
	DECLARE @Max_Cupos_Cita_Padre INT
    
	SET @Max_Cupos_Cita_Padre = (
		SELECT SUM(CP.Cup_Res_Cita_Padre)    
		FROM CIT_CitaPadre CP    
		WHERE 

		CP.Cod_Volante = @p_Cod_Volante
	) 
	SET @Max_Cupos_Cita_Padre = ISNULL(@Max_Cupos_Cita_Padre,0)

	/*OBTENEMOS EL NÚMERO DE CITAS QUE YA HAN SIDO DESPACHADAS*/
	DECLARE @vCont_Retirados INT
	SELECT @vCont_Retirados = COUNT(Ident_Cita)
	FROM dbo.CIT_Cita
	WHERE 
	Cod_Volante = @p_Cod_Volante -- '554781' --
	AND Cod_Estado = 'DES'

	/*DADO QUE CADA VEZ QUE EL VEHÍCULO SALE SE SUMA UNO EN TERMINAL A LOS CONTENEDORES QUE HAN SIDO RETIRADOS,
	NOSOTROS DESCONTAMOS UNO A LOS CUPOS.*/
	SET @Max_Cupos_Cita_Padre = @Max_Cupos_Cita_Padre - @vCont_Retirados

	SELECT  @Max_Cupos_Cita_Padre
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerDatosVolanteXCodVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
 
  
  
----------------------------------------------------------------------  
-- Nombre: CIT_ObtenerDatosVolante  
-- Objetivo: Obtiene los datos del volante registrado  
-- Valores Prueba:   
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 17/05/2010  
-- Modificacion:   
--------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_ObtenerDatosVolanteXCodVolante]  
 @p_Cod_Volante varchar(6)  
AS  
BEGIN  
  
 --Obtenemos la Última Cita Padre del Nro. de Volante  
 DECLARE @Max_Cod_Cita_Padre int  
  
 SELECT  
  @Max_Cod_Cita_Padre = MAX(CP.Cod_Cita_Padre)  
 FROM CIT_CitaPadre CP  
  WHERE CP.Cod_Volante = @p_Cod_Volante  
  
  
 --Obtenemos los totales consolidados en la Cita Padre  
 DECLARE @Nro_Tot_Contenedor int,  
   @Nro_Disp_Contenedor int,  
   @Nro_Bloq_Contenedor int,  
   @Cup_Res_Cita_Padre int,
   @Nro_Ret_Contenedor int   
  
 SELECT   
  @Nro_Tot_Contenedor = CP.Nro_Tot_Contenedor,  
  @Nro_Disp_Contenedor = CP.Nro_Disp_Contenedor,  
  @Nro_Bloq_Contenedor = CP.Nro_Bloq_Contenedor,  
  @Cup_Res_Cita_Padre = CP.Cup_Res_Cita_Padre,  
  @Nro_Ret_Contenedor =CP.Nro_Ret_Contenedor 
FROM dbo.CIT_CitaPadre CP  
  WHERE CP.Cod_Cita_Padre = @Max_Cod_Cita_Padre  
  
 SELECT   
  @Cup_Res_Cita_Padre = SUM(CP.Cup_Res_Cita_Padre)  
 FROM dbo.CIT_CitaPadre CP  
  WHERE CP.Cod_Volante = @p_Cod_Volante  
  
 SELECT   
  @Nro_Tot_Contenedor = CP.Nro_Tot_Contenedor,  
  @Nro_Disp_Contenedor = CP.Nro_Disp_Contenedor,  
  @Nro_Bloq_Contenedor = CP.Nro_Bloq_Contenedor,
  @Nro_Ret_Contenedor = CP.Nro_Ret_Contenedor  
 FROM dbo.CIT_CitaPadre CP  
  WHERE CP.Cod_Cita_Padre = @Max_Cod_Cita_Padre  
  
 --Obtenemos los datos del Nro. de Volante  
 SELECT   
  C.Cod_Volante,  
  C.Con_Volante,  
  C.Ruc_Con_Volante,  
  C.Nav_Volante,  
  C.Via_Volante,  
  C.Cnc_Volante,  
  C.Fec_Ing_Volante,  
  C.Age_Adu_Volante,  
  C.Ruc_Age_Adu_Volante,  
  C.Email_Age_Adu_Volante,  
  C.Pue_Ori_Volante,  
  C.Lin_Volante,  
  @Nro_Tot_Contenedor AS [Nro_Tot_Contenedor],  
  @Nro_Disp_Contenedor AS [Nro_Disp_Contenedor],  
  @Nro_Bloq_Contenedor AS [Nro_Bloq_Contenedor],  
  @Cup_Res_Cita_Padre AS [Cup_Res_Cita_Padre],
  @Nro_Ret_Contenedor AS [Nro_Ret_Contenedor]  
 FROM dbo.CIT_VOLANTE C  
  WHERE  
   C.Cod_Volante = @p_Cod_Volante  
  
END  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerDisponibilidadXVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec CIT_ObtenerDisponibilidadXVolante '704581'
-- =============================================  
-- Author:  RV  
-- Create date: 02/12/2014  
-- Description: Obtiene la disponibilidad del Volante  
-- EXEC CIT_ObtenerDisponibilidadXVolante '554481' --   
-- =============================================  
ALTER PROCEDURE [dbo].[CIT_ObtenerDisponibilidadXVolante] @p_Cod_Volante VARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;

	/*OBTENEMOS LA INFORMACIÓN DEL VOLANTE DESDE IMPO*/
	DECLARE @TVolanteTMP TABLE (
		Numero_Volante VARCHAR(6)
		,Consignatario VARCHAR(200)
		,Ruc_Consignatario VARCHAR(20)
		,Nave VARCHAR(100)
		,Viaje VARCHAR(20)
		,Conocimiento VARCHAR(50)
		,Fecha_Ingreso DATETIME
		,Agente_Aduana VARCHAR(200)
		,Ruc_Agente_Aduana VARCHAR(20)
		,Email_Agente_Aduana VARCHAR(100)
		,Puerto_Origen VARCHAR(50)
		,Linea VARCHAR(200)
		,Cod_Contenedor VARCHAR(11)
		,Estado_Contenedor VARCHAR(20)
		,Usuario_Bloqueo VARCHAR(100)
		,Fecha_Bloqueo DATETIME
		,Motivo_Bloqueo VARCHAR(200)
		,Es_Integral VARCHAR(2)
		,Esta_Retirado INT
		)

	INSERT INTO @TVolanteTMP
	EXEC [dbo].[SN_NEPT_Consultar_Datos_Volante] @p_Cod_Volante -- '554481' --   

	DECLARE @v_Contenedores_Totales INT
		,@v_Contenedores_Retirados INT
		,@v_Contenedores_Bloqueados INT
		,@v_Contenedores_Reservados INT
		,@v_Contenedores_Disponibles INT

	/*OBTENEMOS EL TOTAL DE CONTENEDORES*/
	SELECT @v_Contenedores_Totales = COUNT(Cod_Volante)
	FROM dbo.CIT_Contenedor
	WHERE Cod_Volante = @p_Cod_Volante -- '554481' --   

	IF (@v_Contenedores_Totales = 0)
		SELECT @v_Contenedores_Totales = COUNT(Numero_Volante)
		FROM @TVolanteTMP

	/*OBTENEMOS EL NÚMERO DE CONTENEDORES RETIRADOS*/
	SELECT @v_Contenedores_Retirados = COUNT(Numero_Volante)
	FROM @TVolanteTMP
	WHERE Esta_Retirado = 1

	/*OBTENEMOS EL NÚMERO DE CONTENEDORES BLOQUEADOS*/
	SELECT @v_Contenedores_Bloqueados = COUNT(cod_volante)
	FROM dbo.CIT_Contenedor
	WHERE Cod_Volante = @p_Cod_Volante -- '554481' --  
		AND Cod_Estado = 'BLQ'

	--SELECT @v_Contenedores_Bloqueados  
	/*OBTENEMOS EL NÚMERO DE CUPOS RESERVADOS*/
	DECLARE @TReservasTMP TABLE (Numero_Reservas INT)

	INSERT INTO @TReservasTMP
	EXEC dbo.CIT_ObtenerCuposReservadosXCodVolante @p_Cod_Volante -- '554481' --   

	SELECT @v_Contenedores_Reservados = Numero_Reservas
	FROM @TReservasTMP

	/*LA CAPACIDAD DISPONIBLE ES: TOTAL DE CTRS - (CTRS BLOQ + CTRS RETIRADOS + RESERVAS) */
	SET @v_Contenedores_Disponibles = @v_Contenedores_Totales - (@v_Contenedores_Bloqueados + @v_Contenedores_Retirados + @v_Contenedores_Reservados)
	
	--print @v_Contenedores_Totales
	--print @v_Contenedores_Bloqueados
	--print @v_Contenedores_Retirados
	--print @v_Contenedores_Retirados
	
	IF @v_Contenedores_Disponibles < 0
		SET @v_Contenedores_Disponibles = 0

	--SELECT @v_Contenedores_Disponibles Disp, @v_Contenedores_Totales Tot, @v_Contenedores_Bloqueados Bloq, @v_Contenedores_Retirados Ret, @v_Contenedores_Reservados Res  
	SELECT @v_Contenedores_Disponibles
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerFechaCita_Volante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 18/08/2010
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ObtenerFechaCita_Volante]
(
	@NroVolante varchar(15)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	C.Cod_Volante NroVolante,
			CONVERT(datetime,CONVERT(char(10),T.Fec_Turno,121) + ' ' + SUBSTRING(T.Des_Turno,1,5) + ':00.000',121) FechaCita
	FROM	CIT_Cita C
	INNER JOIN	CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	WHERE	C.Cod_Volante = @NroVolante
	AND		C.Cod_Estado = 'REG'
	ORDER BY	2 ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerFechaPrimeraCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  
  
----------------------------------------------------------------------  
-- Nombre: CIT_ObtenerFechaPrimeraCita  
-- Objetivo: Obtener Fecha de la primera cita  
-- Valores Prueba:   
-- Creacion: Juan Carlos Urrelo 16/06/2010  
-- Modificacion:   
--------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_ObtenerFechaPrimeraCita]  
   
AS  
BEGIN  
  
select top 1 TU.Fec_Turno from CIT_Turno TU
INNER JOIN CIT_Cita CI ON CI.Ident_Turno = TU.Ident_Turno 
where CI.Cod_Estado not in ('ANU')  
order by TU.Fec_Turno asc   
  
  
  
END  
  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerFechaUltimaCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  
  
----------------------------------------------------------------------  
-- Nombre: CIT_ObtenerFechaUltima9Cita  
-- Objetivo: Obtener Fecha de la ultima cita  
-- Valores Prueba:   
-- Creacion: Juan Carlos Urrelo 16/06/2010  
-- Modificacion:   
--------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_ObtenerFechaUltimaCita]  
   
AS  
BEGIN  
  
select top 1 TU.Fec_Turno from CIT_Turno TU
INNER JOIN CIT_Cita CI ON CI.Ident_Turno = TU.Ident_Turno 
where CI.Cod_Estado not in ('ANU')  
order by TU.Fec_Turno desc   
  
  
END  
  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerMatrizCalendario]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CIT_ObtenerMatrizCalendario 1,'20140709',1        
----------------------------------------------------------------------            
-- Nombre: [CIT_ObtenerMatrizCalendario]            
-- Objetivo: Store que permite armar la matriz que se consultará al registrar una cita             
-- Valores Prueba:             
-- Creacion: JUAN CARLOS URRELO 28/05/2010            
-- Modificacion:             
--------------------------------------------------------------------        
ALTER PROCEDURE [dbo].[CIT_ObtenerMatrizCalendario] @integral BIT
	,@fechaactual DATETIME
	,@Permiso BIT
AS
BEGIN
	DECLARE @nIntervalo DECIMAL(18, 7)
		,@HoraInicio DATETIME
		,@HoraFin DATETIME
		,@HoraInicioTurno VARCHAR(5)
		,@HoraFinTurno VARCHAR(5)
		,@RangoTurno VARCHAR(11)
		,@sSQL VARCHAR(max)
		,@dia1 DATETIME
		,@dia2 DATETIME
		,@dia3 DATETIME
		,@dia4 DATETIME
		,@dia5 DATETIME
		,@dia6 DATETIME
		,@dia7 DATETIME
		,@capacidad1 INT
		,@capacidad2 INT
		,@capacidad3 INT
		,@capacidad4 INT
		,@capacidad5 INT
		,@capacidad6 INT
		,@capacidad7 INT
		,@capacidad11 INT
		,@capacidad21 INT
		,@capacidad31 INT
		,@capacidad41 INT
		,@capacidad51 INT
		,@capacidad61 INT
		,@capacidad71 INT
		,@descontar1 INT
		,@descontar2 INT
		,@descontar3 INT
		,@descontar4 INT
		,@descontar5 INT
		,@descontar6 INT
		,@descontar7 INT

	--SET @fechaactual='20100528'            
	SELECT @nIntervalo = MAX(CONVERT(DECIMAL(18, 7), P.Valor_Parametro))
	FROM CIT_PARAMETRO P
	WHERE P.Cod_Parametro IN (6)

	IF (@integral = 1) --4 ES EL VALOR PARA INTEGRALES INICIO Y 5 INTEGRALES FIN Y 2 ES EL VALOR DE LOS TURNOS             
	BEGIN
		SET @HoraInicio = (
				SELECT B.DescmCampo
				FROM CIT_PARAMETRO A
				INNER JOIN PAR_Tabla_Generica B ON A.Valor_Parametro = B.ValorCampo
				WHERE A.COD_PARAMETRO = 4
					AND Ident_Tabla = 2
				)
		SET @HoraFin = (
				SELECT B.DescmCampo
				FROM CIT_PARAMETRO A
				INNER JOIN PAR_Tabla_Generica B ON A.Valor_Parametro = B.ValorCampo
				WHERE A.COD_PARAMETRO = 5
					AND Ident_Tabla = 2
				)
	END
	ELSE
	BEGIN --EL VALOR DE HORAS NORMALES INICIALES ES EL CODIGO 2 Y LAS HORAS NORMALES FINALES ES EL CODIGO 3            
		SET @HoraInicio = (
				SELECT B.DescmCampo
				FROM CIT_PARAMETRO A
				INNER JOIN PAR_Tabla_Generica B ON A.Valor_Parametro = B.ValorCampo
				WHERE A.COD_PARAMETRO = 2
					AND Ident_Tabla = 2
				)
		SET @HoraFin = (
				SELECT B.DescmCampo
				FROM CIT_PARAMETRO A
				INNER JOIN PAR_Tabla_Generica B ON A.Valor_Parametro = B.ValorCampo
				WHERE A.COD_PARAMETRO = 3
					AND Ident_Tabla = 2
				)
	END

	--SET @sSQL = 'SELECT ''0'' AS [RangoTurnoValor], ''Todos'' AS [RangoTurnoDescripcion]'            
	--SET @sSQL = 'SELECT ''0'' AS [RangoTurnoValor]'            
	--SET @sSQL = 'SELECT ''0'' AS [RangoTurnoValor]'            
	--SET @sSQL = 'SELECT ''0'' AS [RangoTurnoValor]'            
	SET @sSQL = ''

	WHILE (@HoraInicio < @HoraFin)
	BEGIN
		SET @HoraInicioTurno = CONVERT(VARCHAR(5), @HoraInicio, 108)
		SET @HoraInicio = DATEADD(mi, @nIntervalo * 60, @HoraInicio)
		SET @HoraFinTurno = CONVERT(VARCHAR(5), @HoraInicio, 108)
		SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno
		SET @dia1 = DATEADD(day, 0, @fechaactual)
		SET @dia2 = DATEADD(day, 1, @fechaactual)
		SET @dia3 = DATEADD(day, 2, @fechaactual)
		SET @dia4 = DATEADD(day, 3, @fechaactual)
		SET @dia5 = DATEADD(day, 4, @fechaactual)
		SET @dia6 = DATEADD(day, 5, @fechaactual)
		SET @dia7 = DATEADD(day, 6, @fechaactual)
		SET @capacidad11 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia1)
		SET @capacidad21 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia2)
		SET @capacidad31 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia3)
		SET @capacidad41 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia4)
		SET @capacidad51 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia5)
		SET @capacidad61 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia6)
		SET @capacidad71 = dbo.CIT_ObtenerCapacidadCalendario(@RangoTurno, @dia7)

		IF (@Permiso = 0)
		BEGIN
			SET @descontar1 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia1)
			SET @descontar2 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia2)
			SET @descontar3 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia3)
			SET @descontar4 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia4)
			SET @descontar5 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia5)
			SET @descontar6 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia6)
			SET @descontar7 = dbo.CIT_ObtenerReservasCapacidadCalendario(@RangoTurno, @dia7)
			SET @capacidad1 = (@capacidad11 - @descontar1)

			IF @capacidad1 < 0
				SET @capacidad1 = 0
			SET @capacidad2 = (@capacidad21 - @descontar2)

			IF @capacidad2 < 0
				SET @capacidad2 = 0
			SET @capacidad3 = (@capacidad31 - @descontar3)

			IF @capacidad3 < 0
				SET @capacidad3 = 0
			SET @capacidad4 = (@capacidad41 - @descontar4)

			IF @capacidad4 < 0
				SET @capacidad4 = 0
			SET @capacidad5 = (@capacidad51 - @descontar5)

			IF @capacidad5 < 0
				SET @capacidad5 = 0
			SET @capacidad6 = (@capacidad61 - @descontar6)

			IF @capacidad6 < 0
				SET @capacidad6 = 0
			SET @capacidad7 = (@capacidad71 - @descontar7)

			IF @capacidad7 < 0
				SET @capacidad7 = 0
		END
		ELSE
		BEGIN
			SET @capacidad1 = (@capacidad11)
			SET @capacidad2 = (@capacidad21)
			SET @capacidad3 = (@capacidad31)
			SET @capacidad4 = (@capacidad41)
			SET @capacidad5 = (@capacidad51)
			SET @capacidad6 = (@capacidad61)
			SET @capacidad7 = (@capacidad71)
		END

		--SET @sSQL = @sSQL + ' UNION SELECT ''@RangoTurno'', ''@RangoTurno'''            
		IF (DATEADD(mi, @nIntervalo * 60, @HoraInicio) <= @HoraFin + 1)
			SET @sSQL = @sSQL + ' SELECT ''@RangoTurno'' AS [Turno],            
   isnull(@capacidad1,'''') AS [D1],            
   isnull(@capacidad2,'''') AS [D2],            
   isnull(@capacidad3,'''') AS [D3],            
   isnull(@capacidad4,'''') AS [D4],            
   isnull(@capacidad5,'''') AS [D5],            
   isnull(@capacidad6,'''') AS [D6],            
   isnull(@capacidad7,'''') AS [D7]            
   UNION'
		ELSE
			SET @sSQL = @sSQL + '  SELECT ''@RangoTurno'' AS [Turno],            
   isnull(@capacidad1,'''') AS [D1],            
   isnull(@capacidad2,'''') AS [D2],            
   isnull(@capacidad3,'''') AS [D3],            
   isnull(@capacidad4,'''') AS [D4],            
   isnull(@capacidad5,'''') AS [D5],            
   isnull(@capacidad6,'''') AS [D6],            
   isnull(@capacidad7,'''') AS [D7]'

		SET @sSQL = REPLACE(@sSQL, '@RangoTurno', @RangoTurno)
		SET @sSQL = REPLACE(@sSQL, '@capacidad1', isnull(@capacidad1, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad2', isnull(@capacidad2, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad3', isnull(@capacidad3, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad4', isnull(@capacidad4, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad5', isnull(@capacidad5, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad6', isnull(@capacidad6, ''))
		SET @sSQL = REPLACE(@sSQL, '@capacidad7', isnull(@capacidad7, ''))

		PRINT @sSQL
		PRINT '2'
			--select @RangoTurno,@capacidad1,@capacidad2,@capacidad3,@capacidad4,@capacidad5,@capacidad6,@capacidad7  
	END

	SET @sSQL = LEFT(@sSQL, LEN(@sSQL) - 5)

	PRINT @sSQL

	EXEC (@sSQL)
		--PRINT @sSQL          
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerMatrizCalendarioAvanceSemanal]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--set ANSI_NULLS ON
--set QUOTED_IDENTIFIER ON
--go
--
--
--  
--  
--  
--  
--  SELECT * FROM CIT_PARAMETRO
--  
--  
  
--   SELECT * FROM dbo.CIT_ParametroXHistorico
  
----------------------------------------------------------------------  
-- Nombre: CIT_ObtenerMatrizCalendarioAvanceSemanal '20100621'
-- Objetivo: Store que permite armar la matriz que se consultará al ingresar al avance semanal   
-- Valores Prueba:   
-- Creacion: JUAN CARLOS URRELO 16/06/2010  
-- Modificacion:   
--------------------------------------------------------------------  
  
ALTER PROCEDURE [dbo].[CIT_ObtenerMatrizCalendarioAvanceSemanal]  
 @fechaactual  datetime   
      
AS  
  
  
BEGIN  
 
DECLARE @nIntervalo   Decimal(18,7),  
   @HoraInicio   Datetime,  
   @HoraFin   Datetime, 
   @HoraInicioIntegral   Datetime,  
   @HoraFinIntegral   Datetime,  
   @HoraInicioTurno Varchar(5),  
   @HoraFinTurno  Varchar(5),  
   @RangoTurno   Varchar(11),  
   @sSQL    varchar(max),  
   @dia1    Datetime,  
    @dia2    Datetime,  
   @dia3    Datetime,  
   @dia4    Datetime,  
   @dia5    Datetime,   
    @dia6    Datetime,  
   @dia7    Datetime,  
   @capacidad1   varchar(max),  
   @capacidad2   varchar(max),  
   @capacidad3   varchar(max),  
   @capacidad4   varchar(max),  
   @capacidad5   varchar(max),  
   @capacidad6   varchar(max),  
   @capacidad7   varchar(max) 





  SET @dia1=  DATEADD(day, 0, @fechaactual)  
  SET @dia2=  DATEADD(day, 1, @fechaactual)  
  SET @dia3=  DATEADD(day, 2, @fechaactual)  
  SET @dia4=  DATEADD(day, 3, @fechaactual)  
  SET @dia5=  DATEADD(day, 4, @fechaactual)  
  SET @dia6=  DATEADD(day, 5, @fechaactual)  
  SET @dia7=  DATEADD(day, 6, @fechaactual)   
       
  
SET @nIntervalo = (select top 1 valor_parametro from dbo.CIT_ParametroXHistorico
where Cod_Parametro=6 and Fec_historica in (@dia1,@dia2,@dia3,@dia4,@dia5,@dia6,@dia7)
order by Valor_Parametro desc )

IF (@nIntervalo IS NULL)
BEGIN
SET  @nIntervalo = (select top 1 valor_parametro from dbo.CIT_Parametro
where Cod_Parametro=6 
order by Valor_Parametro desc )
END



SET @HoraInicio = (select top 1 TG.DescmCampo 
				   from dbo.CIT_ParametroXHistorico PH
                   inner join PAR_Tabla_Generica TG on PH.Valor_Parametro=TG.ValorCampo  
where PH.Cod_Parametro=2 and TG.Ident_Tabla=2 and PH.Fec_historica in (@dia1,@dia2,@dia3,@dia4,@dia5,@dia6,@dia7)
order by PH.Valor_Parametro asc )

IF (@HoraInicio IS NULL)
BEGIN
SET @HoraInicio = (select top 1 TG.DescmCampo 
				   from dbo.CIT_Parametro P
                   inner join PAR_Tabla_Generica TG on P.Valor_Parametro=TG.ValorCampo  
where P.Cod_Parametro=2 and TG.Ident_Tabla=2 
order by P.Valor_Parametro asc )
END

SET @HoraInicioIntegral = (select top 1 TG.DescmCampo 
                           from dbo.CIT_ParametroXHistorico PH
                           inner join PAR_Tabla_Generica TG on PH.Valor_Parametro=TG.ValorCampo
where PH.Cod_Parametro=4 and TG.Ident_Tabla=2 and Fec_historica in (@dia1,@dia2,@dia3,@dia4,@dia5,@dia6,@dia7)
order by PH.Valor_Parametro asc)

IF (@HoraInicioIntegral IS NULL)
BEGIN 
SET @HoraInicioIntegral = (select top 1 TG.DescmCampo 
                           from dbo.CIT_Parametro P
                           inner join PAR_Tabla_Generica TG on P.Valor_Parametro=TG.ValorCampo
where P.Cod_Parametro=4 and TG.Ident_Tabla=2 
order by P.Valor_Parametro asc)
END

IF (CONVERT(VARCHAR,@HoraInicio,108)<=CONVERT(VARCHAR,@HoraInicioIntegral,108))
BEGIN
SET @HoraInicio=@HoraInicio
END
ELSE
BEGIN 
	SET @HoraInicio=@HoraInicioIntegral
END


SET @HoraFin = (select top 1 TG.DescmCampo 
			    from dbo.CIT_ParametroXHistorico PH
				inner join PAR_Tabla_Generica TG on PH.Valor_Parametro=TG.ValorCampo
where PH.Cod_Parametro=3 and TG.Ident_Tabla=2 and Fec_historica in (@dia1,@dia2,@dia3,@dia4,@dia5,@dia6,@dia7)
order by PH.Valor_Parametro desc )

IF (@HoraFin IS NULL)
BEGIN

SET @HoraFin = (select top 1 TG.DescmCampo 
			    from dbo.CIT_Parametro P
				inner join PAR_Tabla_Generica TG on P.Valor_Parametro=TG.ValorCampo
where P.Cod_Parametro=3 and TG.Ident_Tabla=2 
order by P.Valor_Parametro desc )
END

SET @HoraFinIntegral = (select top 1 TG.DescmCampo 
						   from dbo.CIT_ParametroXHistorico PH
						   inner join PAR_Tabla_Generica TG on PH.Valor_Parametro=TG.ValorCampo	
where PH.Cod_Parametro=5 and TG.Ident_Tabla=2 and Fec_historica in (@dia1,@dia2,@dia3,@dia4,@dia5,@dia6,@dia7)
order by PH.Valor_Parametro desc)

IF (@HoraFinIntegral IS NULL)
BEGIN
SET @HoraFinIntegral = (select top 1 TG.DescmCampo 
						   from dbo.CIT_Parametro P
						   inner join PAR_Tabla_Generica TG on P.Valor_Parametro=TG.ValorCampo	
where P.Cod_Parametro=5 and TG.Ident_Tabla=2 
order by P.Valor_Parametro desc)
END 

IF (CONVERT(VARCHAR,@HoraFin,108)>=CONVERT(VARCHAR,@HoraFinIntegral,108))
BEGIN
SET @HoraFin=@HoraFin

END

ELSE
BEGIN 
	SET @HoraFin=@HoraFinIntegral
END
  
 SET @sSQL = ''  
  
  

   
 WHILE (@HoraInicio<@HoraFin)  
 BEGIN  
  SET @HoraInicioTurno = CONVERT(Varchar(5),@HoraInicio,108)  
  SET @HoraInicio = DATEADD(mi,@nIntervalo*60,@HoraInicio)  
  SET @HoraFinTurno = CONVERT(Varchar(5),@HoraInicio,108)  
  SET @RangoTurno = @HoraInicioTurno + '-' + @HoraFinTurno  
 
       SET @capacidad1= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia1)
        SET @capacidad2=dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia2)   
        SET @capacidad3= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia3)  
        SET @capacidad4= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia4)  
         SET @capacidad5= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia5)  
         SET @capacidad6= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia6)   
  SET @capacidad7= dbo.CIT_ObtenerCapacidadCalendarioSemanal(@RangoTurno,@dia7)  
  --SET @sSQL = @sSQL + ' UNION SELECT ''@RangoTurno'', ''@RangoTurno'''  
  IF (DATEADD(mi,@nIntervalo*60,@HoraInicio)<=@HoraFin+1)  
   SET @sSQL = @sSQL + ' SELECT ''@RangoTurno'' AS [Turno],''@capacidad1'' AS [D1],''@capacidad2'' AS [D2],''@capacidad3'' AS [D3],''@capacidad4'' AS [D4],''@capacidad5'' AS [D5],''@capacidad6'' AS [D6],''@capacidad7'' AS [D7] UNION'  
  ELSE  
   SET @sSQL = @sSQL + '  SELECT ''@RangoTurno'' AS [Turno],''@capacidad1'' AS [D1],''@capacidad2'' AS [D2],''@capacidad3'' AS [D3],''@capacidad4'' AS [D4],''@capacidad5'' AS [D5],''@capacidad6'' AS [D6],''@capacidad7'' AS [D7]'  
  SET @sSQL = REPLACE(@sSQL,'@RangoTurno',@RangoTurno)  
  SET @sSQL = REPLACE(@sSQL,'@capacidad1',@capacidad1)  
        SET @sSQL = REPLACE(@sSQL,'@capacidad2',@capacidad2)  
  SET @sSQL = REPLACE(@sSQL,'@capacidad3',@capacidad3)  
  SET @sSQL = REPLACE(@sSQL,'@capacidad4',@capacidad4)  
  SET @sSQL = REPLACE(@sSQL,'@capacidad5',@capacidad5)  
  SET @sSQL = REPLACE(@sSQL,'@capacidad6',@capacidad6)  
        SET @sSQL = REPLACE(@sSQL,'@capacidad7',@capacidad7)   
 END  

     SET @sSQL =LEFT(@sSQL,LEN(@sSQL)-5)   
   EXEC(@sSQL)  

 
END  
  

  
  
  







GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerNumeroServIntegralPorVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:		Jhony Rivero (BVision)
-- Create date: 28/05/2015
-- Description:	Devuelve el numero de servicio integral a partir de un codigo de volante
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ObtenerNumeroServIntegralPorVolante]
	@Volante as varchar(6) 
as
begin
	select 
		ssi.ORD_CODIGO
	from 
		[SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 v	
		left join 
		GNeptuniaCitas.dbo.Cit_Volante cv on (cv.cod_volante = v.NROSEC23)
		left join 
		[SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN ssi ON ssi.ORD_BL = cv.CNC_VOLANTE 
			AND ssi.ORD_NAVVIA = v.NAVVIA11 
		    AND ssi.ORD_NUMDOCUMENTO <> '' 
			AND ssi.ORD_FLAGESTADO IS NULL
		where v.NROSEC23 = @Volante
end
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerParametrosXCodigo]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----------------------------------------------------------------------
-- Nombre: CIT_ObtenerParametrosXCodigo
-- Objetivo: Obtener PARAMETROS DEL SISTEMA POR CODIGO
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo 25/05/2010
-- Modificacion: 
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ObtenerParametrosXCodigo]
	@codigo int
AS
BEGIN

SELECT Cod_Parametro Codigo,
       Des_Parametro Descripcion,
       Valor_Parametro Valor
FROM CIT_Parametro  
WHERE Cod_Parametro= @codigo


END






GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerReservaCupos]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------    
-- Nombre: CIT_ObtenerReservaCupos    
-- Objetivo:     
-- Valores Prueba:     
-- Creacion: DRB    
-- Modificacion: DBR    
--------------------------------------------------------------------   
ALTER PROCEDURE [dbo].[CIT_ObtenerReservaCupos]
AS    
BEGIN    
	DECLARE @FHOY DATETIME    
	SET @FHOY = DATEADD(DD,0,DATEDIFF(DD,0,GETDATE()))    

	SELECT     
		Ident_ReservaCupos,     
		Fec_Desde,     
		Fec_Hasta,     
		Tur_Reserva,     
		Cantidad     
	FROM CIT_ReservaCupos    
	WHERE 
	(( @FHOY between  Fec_Desde and Dateadd(day,1,Fec_Hasta)) OR Fec_Desde > @FHOY)  
	ORDER BY  Ident_ReservaCupos asc
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerRucClientePorVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- Nombre: CIT_ObtenerRucClientePorVolante
-- Objetivo: Obtiene el ruc de un determinado volante
-- Creacion: Jhony Rivero - BVision - 18/05/2015
-- Modificacion: 
--------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_ObtenerRucClientePorVolante]
	@Volante Varchar(6)	--Nro. de Volante
AS
Begin
	select top 1 ruccli12 from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 where nrosec23 = @Volante
End
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerSucursales]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ObtenerSucursales]
AS
BEGIN
	SELECT 
		[codigo]
		,[Nombre]
	FROM [dbo].[CIT_Sucursal]
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerTurnosReservadosXCodCitaPadre]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
-- Nombre: CIT_ObtenerTurnosReservadosXCodCitaPadre
-- Objetivo: Obtiene los cupos reservados por turno por Nro. de Cita Padre
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100518
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100518
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ObtenerTurnosReservadosXCodCitaPadre]
	@p_Cod_Cita_Padre	Varchar(10)		--Nro. de Cita Padre
AS
BEGIN
	SELECT
			C.Cod_Cita_Padre,
			T.Des_Turno,
			T.Fec_Turno,
			COUNT(*) as [Cupos_Reservados]
		FROM dbo.CIT_Cita C 				
			INNER JOIN dbo.CIT_Turno T ON
				C.Ident_Turno = T.Ident_Turno
		WHERE 
			C.Cod_Cita_Padre = @p_Cod_Cita_Padre AND
			C.Cod_Estado = 'REG'
		GROUP BY
			C.Cod_Cita_Padre,
			T.Des_Turno,
			T.Fec_Turno
END


GO
/****** Object:  StoredProcedure [dbo].[CIT_ObtenerVecesEnvioXCodVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RV
-- Create date: 20/11/2014
-- Description:	Obtiene el número de veces que se ha enviado el correo de alerta para un volante.
-- =============================================
ALTER PROCEDURE [dbo].[CIT_ObtenerVecesEnvioXCodVolante]
@p_Cod_Volante VARCHAR(6)
AS
BEGIN	
	SET NOCOUNT ON;
	/*OBTENEMOS EL NÚMERO DE VECES DE ENVÍOS PARA EL VOLANTE*/
	DECLARE @v_Nro_Veces INT
	SELECT @v_Nro_Veces = Nro_Veces_Envio
	FROM CIT_EnvioAlertaCorreo
	WHERE 
	Cod_Volante = @p_Cod_Volante

	/*OBTENEMOS EL NÚMERO DE VECES DE ENVÍO COMO PARÁMETRO*/
	DECLARE @v_Nro_Veces_Param INT
	SELECT @v_Nro_Veces_Param = NVeces
	FROM dbo.CIT_Parametro_Alertas

	SET @v_Nro_Veces = ISNULL(@v_Nro_Veces,0)
	SET @v_Nro_Veces_Param = ISNULL(@v_Nro_Veces_Param,0)

	/*SI LAS VECES DE ENVÍO CONFIGURADA ES MENOR IGUAL A LAS VECES QUE YA SE HA ENVIADO, YA NO SE HARÁ NADA*/
	IF(@v_Nro_Veces < @v_Nro_Veces_Param)
	BEGIN
		/*SI NO EXISTE EL VOLANTE LO REGISTRAMOS*/
		IF(ISNULL(@v_Nro_Veces,0) = 0)
		BEGIN
			INSERT INTO CIT_EnvioAlertaCorreo (
					Cod_Volante,
					Fec_Ult_Envio,
					Nro_Veces_Envio)
					VALUES (
					@p_Cod_Volante,
					GETDATE(),
					1)
		END
		ELSE
		BEGIN
			UPDATE CIT_EnvioAlertaCorreo
			SET	
				Nro_Veces_Envio = Nro_Veces_Envio + 1
			WHERE 
			Cod_Volante = @p_Cod_Volante
		END
	END

	SELECT @v_Nro_Veces
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_OrdeRetiroEstaAsociado]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_OrdeRetiroEstaAsociado]
@Nu_OrdenRetiro as varchar(10)
as
begin

if exists(select Nro_Orden_Retiro from [dbo].[CIT_OrdenRetiro] ORT where  ORT.nro_orden_retiro=@Nu_OrdenRetiro)
begin
	if exists(select Nu_OrdenRetiro_AsociaCita from CIT_Cita CIT where  Nu_OrdenRetiro_AsociaCita=@Nu_OrdenRetiro AND NOT ciT.Cod_Estado IN ('ANU','CAN'))
		begin
		select 1 as 'Asignado a cita'
		end
		else
		begin
		select 0 as 'No asginado'
		end
	end
else
begin
	select -1 as 'No existe'
end
end
GO
/****** Object:  StoredProcedure [dbo].[CIT_RegistrarContenedorPanelElectronico]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ----------------------------------------------------------------------    
-- Nombre: CIT_RegistrarContenedorPanelElectronico    
-- Objetivo: Registra los datos en Panel Electrónico del contenedor a retirar para     
-- Valores Prueba:     
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100514    
-- Modificacion: Nelson Isaac Cuba Ramos - Gesfor Perú - 20100622    
-- 20141020 -- Se añadió el parámetro NroCTR para poder controlar la asociación OR-CTR-PLACA
--------------------------------------------------------------------    
--EXEC CIT_RegistrarContenedorPanelElectronico 'EEEEEE','303840-2','ACT','2010-07-02 11:14:00.000',1,1,'Cueto te fuiste!'    
ALTER PROCEDURE [dbo].[CIT_RegistrarContenedorPanelElectronico]    
@p_Nro_Placa     VARCHAR(6),  --Número de Placa    
@p_Nro_Orden_Retiro    VARCHAR(10), --Número de Orden de Retiro    
@p_Est_Orden_Retiro    VARCHAR(20), --Estado de Orden de Retiro    
@p_Fec_Vig_Orden_Retiro   Datetime,  --Fecha de Vigencia Orden de Retiro     
@Integral      int,   --Indicador si es servicio integral o no    
@Cita       int,   --Indicador si tiene cita o no    
@Anotaciones     VARCHAR(255), --Anotaciones hechas por el Operario,  
@IpMobil         VARCHAR(255)
--,@p_Nro_CTR VARCHAR(11)='' --  Número de Contenedor Asociado a la OR.
AS    
BEGIN    
	DECLARE @EXISTE INT ;  

	IF (
		(SELECT Panel 
		FROM CIT_Parametro_PDT   
		WHERE codigo = @IpMobil 
		GROUP BY Panel)= 'NO'
	)  
	BEGIN  
        --Actualizamos valor en orden de retiro    
		UPDATE O    
		SET    
			O.Nro_Placa = @p_Nro_Placa    
		FROM dbo.CIT_OrdenRetiro O    
		WHERE Nro_Orden_Retiro = @p_Nro_Orden_Retiro    

		--Actualizamos fecha de ingreso a Neptunia    
		UPDATE C    
		SET    
			C.Fec_Ing_Nep_Cita = GETDATE()    
		FROM dbo.CIT_Cita C    
		WHERE C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro   
	END
	ELSE
	BEGIN        
		SET @EXISTE = (
			SELECT COUNT (NRO_ORDEN_RETIRO) 
			FROM dbo.CIT_PanelElectronico 
			WHERE 
			NRO_ORDEN_RETIRO = @p_Nro_Orden_Retiro
		)    

		IF (@EXISTE=1)    
		BEGIN    
			UPDATE dbo.CIT_PanelElectronico    
			SET 
				NRO_PLACA=@p_Nro_Placa,  
				Anotaciones=@Anotaciones,
				Integral=@Integral,
				Cita=@Cita    
			WHERE 
			NRO_ORDEN_RETIRO = @p_Nro_Orden_Retiro    
		END    
		ELSE           

		BEGIN    
			INSERT INTO dbo.CIT_PanelElectronico    
			(Nro_Placa, Nro_Orden_Retiro, Est_Orden_Retiro, Fec_Vig_Orden_Retiro, Fec_Reg_Panel_Electronico,Integral,Cita,Cod_Estado,Anotaciones)    
			VALUES    
			(@p_Nro_Placa, @p_Nro_Orden_Retiro, @p_Est_Orden_Retiro, @p_Fec_Vig_Orden_Retiro, getdate(),@Integral,@Cita,'COL',@Anotaciones)    
		END          

		--Actualizamos valor en orden de retiro    

		UPDATE O    
		SET    
			O.Nro_Placa = @p_Nro_Placa    
		FROM dbo.CIT_OrdenRetiro O    
		WHERE Nro_Orden_Retiro = @p_Nro_Orden_Retiro    

		--Actualizamos fecha de ingreso a Neptunia    
		UPDATE C    
		SET    
			C.Fec_Ing_Nep_Cita = GETDATE()    
		FROM dbo.CIT_Cita C    
		WHERE C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro    

		EXEC CIT_ActualizarPrioridadXOrdenRetiro @p_Nro_Orden_Retiro 
	END     
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_RegistrarContenedorPanelElectronico_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_RegistrarContenedorPanelElectronico_JFN] @p_Nro_Placa VARCHAR(6)
	,--Número de Placa          
	@p_Nro_Orden_Retiro VARCHAR(10)
	,--Número de Orden de Retiro          
	@p_Est_Orden_Retiro VARCHAR(20)
	,--Estado de Orden de Retiro          
	@p_Fec_Vig_Orden_Retiro DATETIME
	,--Fecha de Vigencia Orden de Retiro           
	@Integral INT
	,--Indicador si es servicio integral o no          
	@Cita INT
	,--Indicador si tiene cita o no          
	@Anotaciones VARCHAR(255)
	,--Anotaciones hechas por el Operario,        
	@IpMobil VARCHAR(255)
	,
	-- |      
	-- INICIO JHFLORES      
	-- |      
	@Nro_Cita AS INT
	,@Fl_CumpleCita AS BIT
	-- |      
	-- FIN JHFLORES      
	-- |      
	--,@p_Nro_CTR VARCHAR(11)='' --  Número de Contenedor Asociado a la OR.      
AS
BEGIN
	DECLARE @Fe_Actual AS DATETIME
	DECLARE @EXISTE INT;

	IF (
			(
				SELECT Panel
				FROM CIT_Parametro_PDT
				WHERE codigo = @IpMobil
				GROUP BY Panel
				) = 'NO'
			)
	BEGIN
		--Actualizamos valor en orden de retiro          
		UPDATE O
		SET O.Nro_Placa = @p_Nro_Placa
			,nro_cita_asociado = @Nro_Cita
		FROM dbo.CIT_OrdenRetiro O
		WHERE Nro_Orden_Retiro = @p_Nro_Orden_Retiro

		--Actualizamos fecha de ingreso a Neptunia          
		UPDATE C
		SET C.Fec_Ing_Nep_Cita = GETDATE()
		FROM dbo.CIT_Cita C
		WHERE C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro
	END
	ELSE
	BEGIN
		SET @EXISTE = (
				SELECT COUNT(NRO_ORDEN_RETIRO)
				FROM dbo.CIT_PanelElectronico
				WHERE NRO_ORDEN_RETIRO = @p_Nro_Orden_Retiro
				)

		IF (@EXISTE = 1)
		BEGIN
			UPDATE dbo.CIT_PanelElectronico
			SET NRO_PLACA = @p_Nro_Placa
				,Anotaciones = @Anotaciones
				,Integral = @Integral
				,Cita = @Cita
			WHERE NRO_ORDEN_RETIRO = @p_Nro_Orden_Retiro
		END
		ELSE
		BEGIN
			INSERT INTO dbo.CIT_PanelElectronico (
				Nro_Placa
				,Nro_Orden_Retiro
				,Est_Orden_Retiro
				,Fec_Vig_Orden_Retiro
				,Fec_Reg_Panel_Electronico
				,Integral
				,Cita
				,Cod_Estado
				,Anotaciones
				)
			VALUES (
				@p_Nro_Placa
				,@p_Nro_Orden_Retiro
				,@p_Est_Orden_Retiro
				,@p_Fec_Vig_Orden_Retiro
				,getdate()
				,@Integral
				,@Cita
				,'COL'
				,@Anotaciones
				)
		END

		--Actualizamos valor en orden de retiro          
		UPDATE O
		SET O.Nro_Placa = @p_Nro_Placa
			,nro_cita_asociado = @Nro_Cita
		FROM dbo.CIT_OrdenRetiro O
		WHERE Nro_Orden_Retiro = @p_Nro_Orden_Retiro

		--Actualizamos fecha de ingreso a Neptunia          
		UPDATE C
		SET C.Fec_Ing_Nep_Cita = GETDATE()
		FROM dbo.CIT_Cita C
		WHERE C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro

		EXEC CIT_ActualizarPrioridadXOrdenRetiro @p_Nro_Orden_Retiro
	END

	-- Asociar orden de retiro a cita      
	UPDATE c
	SET c.Nu_OrdenRetiro_AsociaCita = @p_Nro_Orden_Retiro
		,c.Cod_Estado = 'INS'
		,c.Fec_Ing_Nep_Cita = GETDATE()
		,c.Nu_Placa_Asociado = @p_Nro_Placa
		,c.Cumple_Cita = @Fl_CumpleCita
	FROM CIT_Cita c
	WHERE C.Ident_Cita = @Nro_Cita

	-- Registrar auditoria de estado      
	SET @Fe_Actual = getdate()

	EXEC CIT_AUDITORIA_ESTADOS 'INS'
		,@Nro_Cita
		,@Fe_Actual
		,'Garita';
	
	INSERT INTO USP_LOG_CITA
	VALUES
	(@Nro_Cita,@p_Nro_Placa,@p_Nro_Orden_Retiro,
	@IpMobil,USER_NAME(),GETDATE(),HOST_NAME())
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_RegistrarOrdenRetiroXCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------  
-- Nombre: CIT_RegistrarOrdenRetiroXCita  
-- Objetivo: Actualiza orden de retiro y contenedor de cita con turno más próximo.  
-- Valores Prueba:   
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513  
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100513 
-- RV - Se agregó el insert del contenedor sobre la tabla de OR para poder obtener el dato y seleccionarlo en el sitema de integra impo. 
--------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CIT_RegistrarOrdenRetiroXCita]  
@p_Cod_Volante    VARCHAR(6),  --Número de Volante  
@p_Cod_Contenedor   VARCHAR(11), --Identificador de Contenedor  
@p_Nro_Orden_Retiro   VARCHAR(10),  --Orden de Retiro  
@p_Fec_Vig_Orden_Retiro  Datetime,  --Fecha de Vigencia  
@p_Nro_Comprobante   VARCHAR(11), --Número de Comprobante  
@p_Tip_Comprobante   VARCHAR(3)  --Tipo de Comprobante (FAC/BOL)
AS  
BEGIN  

	DECLARE @TopCodCita INT, @pCitaConOrden BIT 

	/*VALIDAMOS SI LA OR TIENE CITA*/

	/*PRIMERO VALIDAMOS SI HAY CITA PARA EL CONTENEDOR*/
	SELECT TOP 1 @TopCodCita = C.Ident_Cita  
	FROM dbo.CIT_Cita C  
	INNER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno  
	WHERE  
	C.Cod_Volante = @p_Cod_Volante AND  
	C.Cod_Contenedor = @p_Cod_Contenedor AND  
	C.Nro_Orden_Retiro IS NULL AND  
	C.Cod_Estado = 'REG'  
	ORDER BY T.Fec_Turno ASC, T.Des_Turno ASC 

	/*SI NO HAY CITA PARA EL CONTENEDOR, VALIDAMOS SI SE HAN GENERADO CITAS SIN SELECCIONAR CONTENEDOR*/
	IF(@TopCodCita IS NULL)
	BEGIN
		SELECT TOP 1 @TopCodCita = C.Ident_Cita  
		FROM dbo.CIT_Cita C  
		INNER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno  
		WHERE  
		C.Cod_Volante = @p_Cod_Volante AND  
		C.Cod_Contenedor IS NULL AND  
		C.Nro_Orden_Retiro IS NULL AND  
		C.Cod_Estado = 'REG'  
		ORDER BY T.Fec_Turno ASC, T.Des_Turno ASC  

		SET @pCitaConOrden = 1
	END

	/*SI HAY CITA REGISTRADA*/

	IF (@TopCodCita IS NOT NULL)  
	BEGIN    

		/*REGISTRAMOS LA ORDEN DE RETIRO*/  

		INSERT INTO dbo.CIT_OrdenRetiro  
		(Nro_Orden_Retiro, Fec_Reg_Orden_Retiro, Fec_Vig_Orden_Retiro, Nro_Comprobante, Tip_Comprobante, Cod_Estado, Cod_Contenedor, Cod_Volante, ConCita)  
		VALUES   
		(@p_Nro_Orden_Retiro, GETDATE(), @p_Fec_Vig_Orden_Retiro, @p_Nro_Comprobante, @p_Tip_Comprobante, 'ACT', @p_Cod_Contenedor, @p_Cod_Volante, 1)  

		/*ACTUALIZAMOS CITA CON OR Y CONTENEDOR*/

		UPDATE C  
		SET  
			C.Cod_Contenedor = @p_Cod_Contenedor,  
			C.Cod_Estado = 'FAC',  
			C.Nro_Orden_Retiro = @p_Nro_Orden_Retiro,  
			C.Fec_Fac_Cita = GETDATE()  
		FROM dbo.CIT_Cita C  
		WHERE   
		C.Ident_Cita = @TopCodCita 

		/*ACTUALIZAMOS EL ORDEN DEL CONTENEDOR PARA QUE NO VUELVA A APARECER EN LA LISTA DE CONTENEDORES*/
		/*SI TIENE CITA PERO NO SE SELECCIONÓ EL CONTENEDOR*/
		IF(@pCitaConOrden = 1)
		BEGIN 
			UPDATE dbo.CIT_Contenedor
			SET 
				Ord_Contenedor = '0'
			WHERE 
			Cod_Volante = @p_Cod_Volante
			AND Cod_Contenedor = @p_Cod_Contenedor	
		END	
	END  
	ELSE
	BEGIN
		/*REGISTRAMOS LA ORDEN DE RETIRO CON EL CAMPO CONCITA = 0 PARA ASOCIARLE A LA CITA LUEGO QUE SE GENERE LA MISMA*/
		INSERT INTO dbo.CIT_OrdenRetiro  
		(Nro_Orden_Retiro, Fec_Reg_Orden_Retiro, Fec_Vig_Orden_Retiro, Nro_Comprobante, Tip_Comprobante, Cod_Estado, Cod_Contenedor, Cod_Volante, ConCita)
		VALUES   
		(@p_Nro_Orden_Retiro, GETDATE(), @p_Fec_Vig_Orden_Retiro, @p_Nro_Comprobante, @p_Tip_Comprobante, 'ACT', @p_Cod_Contenedor, @p_Cod_Volante, 0)  
	END   
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_RegistrarRetiroTransportista]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_RegistrarRetiroTransportista] (
	@retiros_v_numeroOR VARCHAR(15)
	,@retiros_v_Placa VARCHAR(10)
	,@retiros_v_nombre VARCHAR(50)
	,@retiros_v_Dni VARCHAR(8)
	,@retiros_v_numbrevete VARCHAR(10)
	,@retiros_d_fecha DATETIME
	,@estadoret_n_codigo INT
	,@retiros_v_agenteadu VARCHAR(50)
	,@retiros_v_Dniagenteadu VARCHAR(11)
	,@retiros_v_numop VARCHAR(11)
	,@UsuarioRegistro VARCHAR(20)
	,@AuditoriaFecha VARCHAR(50)
	,@AuditoriaHora VARCHAR(10)
	,@AuditoriaEvento VARCHAR(20)
	,@Despachador VARCHAR(150)
	,@CodAgenciaAduanas VARCHAR(4)
	)
AS
BEGIN
	DECLARE @retiros_n_codigo INT
	,@valor INT
	
	SET @retiros_n_codigo = 0
	
	SELECT @valor = datediff(minute, MAX(retiros_d_fecha), getdate())
	FROM CIT_RetiroTransportista
	WHERE retiros_v_numeroOR = @retiros_v_numeroOR
		AND retiros_v_Placa = @retiros_v_Placa
		AND retiros_v_nombre = @retiros_v_nombre
		AND retiros_v_Dni = @retiros_v_Dni
		AND retiros_v_numbrevete = @retiros_v_numbrevete
		AND retiros_v_numop = @retiros_v_numop
		AND Despachador = @Despachador
	
	IF @valor is null
	BEGIN
		INSERT INTO CIT_RetiroTransportista (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			)

		SET @retiros_n_codigo = @@IDENTITY

		INSERT INTO CIT_RetiroAuditoria (
			retiros_n_codigo
			,auditoria_d_fecha
			,auditoria_v_hora
			,auditoria_v_usuario
			,auditoria_v_evento
			,retiros_v_placa
			,retiros_v_numeroOR
			)
		VALUES (
			@retiros_n_codigo
			,@AuditoriaFecha
			,@AuditoriaHora
			,@UsuarioRegistro
			,@AuditoriaEvento
			,@retiros_v_Placa
			,@retiros_v_numeroOR
			)		
	END
	ELSE IF @valor > 3
	BEGIN
		INSERT INTO CIT_RetiroTransportista (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			)

		SET @retiros_n_codigo = @@IDENTITY

		INSERT INTO CIT_RetiroAuditoria (
			retiros_n_codigo
			,auditoria_d_fecha
			,auditoria_v_hora
			,auditoria_v_usuario
			,auditoria_v_evento
			,retiros_v_placa
			,retiros_v_numeroOR
			)
		VALUES (
			@retiros_n_codigo
			,@AuditoriaFecha
			,@AuditoriaHora
			,@UsuarioRegistro
			,@AuditoriaEvento
			,@retiros_v_Placa
			,@retiros_v_numeroOR
			)
	END
	ELSE
	BEGIN
		INSERT INTO CIT_RetiroTransportista_NEW (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_RegistrarRetiroTransportista_NEW]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_RegistrarRetiroTransportista_NEW] (
	@retiros_v_numeroOR VARCHAR(15)
	,@retiros_v_Placa VARCHAR(10)
	,@retiros_v_nombre VARCHAR(50)
	,@retiros_v_Dni VARCHAR(8)
	,@retiros_v_numbrevete VARCHAR(10)
	,@retiros_d_fecha DATETIME
	,@estadoret_n_codigo INT
	,@retiros_v_agenteadu VARCHAR(50)
	,@retiros_v_Dniagenteadu VARCHAR(11)
	,@retiros_v_numop VARCHAR(11)
	,@UsuarioRegistro VARCHAR(20)
	,@AuditoriaFecha VARCHAR(50)
	,@AuditoriaHora VARCHAR(10)
	,@AuditoriaEvento VARCHAR(20)
	,@Despachador VARCHAR(150)
	,@CodAgenciaAduanas VARCHAR(4)
	,@retiros_v_Celular VARCHAR(9)
	)
AS
BEGIN
	DECLARE @retiros_n_codigo INT
		,@valor INT

	SET @retiros_n_codigo = 0

	SELECT @valor = datediff(minute, MAX(retiros_d_fecha), getdate())
	FROM CIT_RetiroTransportista
	WHERE retiros_v_numeroOR = @retiros_v_numeroOR
		AND retiros_v_Placa = @retiros_v_Placa
		AND retiros_v_nombre = @retiros_v_nombre
		AND retiros_v_Dni = @retiros_v_Dni
		AND retiros_v_numbrevete = @retiros_v_numbrevete
		AND retiros_v_numop = @retiros_v_numop
		AND Despachador = @Despachador

	IF @valor IS NULL
	BEGIN
		INSERT INTO CIT_RetiroTransportista (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			,retiros_v_Celular
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			,@retiros_v_Celular
			)

		SET @retiros_n_codigo = @@IDENTITY

		INSERT INTO CIT_RetiroAuditoria (
			retiros_n_codigo
			,auditoria_d_fecha
			,auditoria_v_hora
			,auditoria_v_usuario
			,auditoria_v_evento
			,retiros_v_placa
			,retiros_v_numeroOR
			)
		VALUES (
			@retiros_n_codigo
			,@AuditoriaFecha
			,@AuditoriaHora
			,@UsuarioRegistro
			,@AuditoriaEvento
			,@retiros_v_Placa
			,@retiros_v_numeroOR
			)
	END
	ELSE IF @valor > 3
	BEGIN
		INSERT INTO CIT_RetiroTransportista (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			,retiros_v_Celular
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			,@retiros_v_Celular
			)

		SET @retiros_n_codigo = @@IDENTITY

		INSERT INTO CIT_RetiroAuditoria (
			retiros_n_codigo
			,auditoria_d_fecha
			,auditoria_v_hora
			,auditoria_v_usuario
			,auditoria_v_evento
			,retiros_v_placa
			,retiros_v_numeroOR
			)
		VALUES (
			@retiros_n_codigo
			,@AuditoriaFecha
			,@AuditoriaHora
			,@UsuarioRegistro
			,@AuditoriaEvento
			,@retiros_v_Placa
			,@retiros_v_numeroOR
			)
	END
	ELSE
	BEGIN
		INSERT INTO CIT_RetiroTransportista_NEW (
			retiros_v_numeroOR
			,retiros_v_Placa
			,retiros_v_nombre
			,retiros_v_Dni
			,retiros_v_numbrevete
			,retiros_d_fecha
			,estadoret_n_codigo
			,retiros_v_agenteadu
			,retiros_v_Dniagenteadu
			,retiros_v_numop
			,Despachador
			,retiros_v_codageadu
			,retiros_v_Celular
			)
		VALUES (
			@retiros_v_numeroOR
			,@retiros_v_Placa
			,@retiros_v_nombre
			,@retiros_v_Dni
			,@retiros_v_numbrevete
			,@retiros_d_fecha
			,@estadoret_n_codigo
			,@retiros_v_agenteadu
			,@retiros_v_Dniagenteadu
			,@retiros_v_numop
			,@Despachador
			,@CodAgenciaAduanas
			,@retiros_v_Celular
			)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_REGITRAR_CITAS_VENCIDAS_CANCELADA]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CIT_REGITRAR_CITAS_VENCIDAS_CANCELADA]
AS


BEGIN

--1) Parametros

	DECLARE	@TiempoTolerancia int
			
	SELECT	@TiempoTolerancia = CAST(Valor_Parametro AS int)
	FROM	CIT_PARAMETRO
	WHERE	COD_PARAMETRO = 1 -- Tiempo de tolerancia

	INSERT INTO	CIT_ParametroXHistorico
	SELECT	Cod_Parametro,
			getdate(),
			Des_Parametro,
			Valor_Parametro,
			GETDATE(),
			Usuario_Registro,
			'JOB'
	FROM	CIT_Parametro
	
    
--2) Registrar cita como vencido

	--||
	-- CITAS REGISTRADAS
	--||

	DECLARE	@CanAnularCitaReg int
	
	DECLARE	@TablaAnularCitaReg TABLE
	(
		Row int IDENTITY(1,1) PRIMARY KEY NOT NULL,
		Ident_Cita int
	)
		
	INSERT INTO	@TablaAnularCitaReg
	SELECT	Ident_Cita
	FROM	CIT_Cita C
	INNER JOIN	CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	WHERE	C.Cod_Estado = 'REG'
	AND		CONVERT(varchar(10),T.Fec_Turno,112) <= CONVERT(varchar(10),GETDATE(),112)
	AND		DATEADD(mi,@TiempoTolerancia,CONVERT(datetime,SUBSTRING(CONVERT(varchar(100),Fec_Turno,120),1,10) + ' ' + SUBSTRING(T.Des_Turno,7,5) + ':00',120)) <= GETDATE()
	
	DECLARE @contCitaReg int
	DECLARE @maxCitaReg int
	SET @contCitaReg = 1
	SELECT @maxCitaReg = COUNT(*) FROM @TablaAnularCitaReg

	WHILE @contCitaReg <= @maxCitaReg
	BEGIN
		DECLARE	@Ident_CitaReg int
		SELECT	@Ident_CitaReg = Ident_Cita
		FROM	@TablaAnularCitaReg
		WHERE	Row = @contCitaReg
		
		EXEC	CIT_VencidaCanceladaCita @Ident_CitaReg,'VEN'
		
		SET	@contCitaReg = @contCitaReg + 1
	END
    
--b) Registrar cita facturada como vencido
    
	--||
	-- CITAS FACTURADAS
	--||

	DECLARE	@TablaAnularCitaFac TABLE
	(
		Row int IDENTITY(1,1) PRIMARY KEY NOT NULL,
		Ident_Cita int
	)

	INSERT INTO	@TablaAnularCitaFac
	SELECT	Ident_Cita
	FROM	CIT_Cita C
	INNER JOIN	CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	LEFT JOIN	CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
	WHERE	C.Cod_Estado = 'FAC'
	AND		CONVERT(varchar(10),T.Fec_Turno,112) <= CONVERT(varchar(10),GETDATE(),112)
	AND		DATEADD(mi, @TiempoTolerancia ,CONVERT(datetime,SUBSTRING(CONVERT(varchar(100),Fec_Turno,120),1,10) + ' ' + SUBSTRING(T.Des_Turno,7,5) + ':00',120)) <= GETDATE()
	
	DECLARE @contCitaFac int
	DECLARE @maxCitaFac int
	SET @contCitaFac = 1
	SELECT @maxCitaFac = COUNT(*) FROM @TablaAnularCitaFac

	WHILE @contCitaFac <= @maxCitaFac
	BEGIN
		DECLARE	@Ident_CitaFac int
		
		SELECT	@Ident_CitaFac = Ident_Cita
		FROM	@TablaAnularCitaFac
		WHERE	Row = @contCitaFac
		
		EXEC	CIT_VencidaCanceladaCita @Ident_CitaFac,'VEN'

		SET	@contCitaFac = @contCitaFac + 1
	END

	--||
	-- Registrar cita reprogramda como vencido
	--||
		
	DECLARE	@TablaAnularCitaREN TABLE
	(
		Row int IDENTITY(1,1) PRIMARY KEY NOT NULL,
		Ident_Cita int
	)
	INSERT INTO	@TablaAnularCitaREN
	SELECT	Ident_Cita
	FROM	CIT_Cita C
	INNER JOIN	CIT_Turno T ON C.Ident_Turno = T.Ident_Turno
	LEFT JOIN	CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro
	WHERE	C.Cod_Estado = 'REP'
	AND		CONVERT(varchar(10),T.Fec_Turno,112) <= CONVERT(varchar(10),GETDATE(),112)
	AND		DATEADD(mi, @TiempoTolerancia ,CONVERT(datetime,SUBSTRING(CONVERT(varchar(100),Fec_Turno,120),1,10) + ' ' + SUBSTRING(T.Des_Turno,7,5) + ':00',120)) <= GETDATE()
	
	DECLARE @contCitaRen int
	DECLARE @maxCitaRen int
	SET @contCitaRen = 1
	SELECT @maxCitaRen = COUNT(*) FROM @TablaAnularCitaREN

	WHILE @contCitaRen <= @maxCitaRen
	BEGIN
		DECLARE	@Ident_CitaRen int
		
		SELECT	@Ident_CitaRen = Ident_Cita
		FROM	@TablaAnularCitaREN
		WHERE	Row = @contCitaRen
		
		EXEC	CIT_VencidaCanceladaCita @Ident_CitaRen,'CAN'
		
		SET	@contCitaRen = @contCitaRen + 1
	END

END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ReporteCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
-- RV -- 09/12/2014 -- Se agregó el campo Contenedor Despachado a la consulta.    
    
ALTER PROCEDURE [dbo].[CIT_ReporteCita]            
    
@p_Cod_Volante Varchar(6),            
    
@p_Ident_Cita Varchar(15),            
    
@p_Cod_Estado Varchar(3),            
    
@p_Con_Volante Varchar(80),            
    
@p_Fec_Ini  Varchar(10),            
    
@p_Fec_Fin  Varchar(10),            
    
@p_Perfil  Varchar(10),            
    
@p_Usuario  Varchar(20),            
    
@sAgenteAduanas Varchar(10),          
    
@p_NroOrdenRetiro varchar(80),        
    
@p_AgenteAduanas Varchar(10)     
    
AS            
    
BEGIN      
    
 /*            
    
 CIT_ReporteCita  '536742','','TOD','','','','','','','',''    
    
 -- Valores Prueba:            
    
 DECLARE @p_Cod_Volante Varchar(6),            
    
   @p_Ident_Cita Varchar(15),            
    
   @p_Cod_Estado Varchar(3),            
    
   @p_Con_Volante Varchar(80),            
    
   @p_Fec_Ini  Varchar(10),            
    
   @p_Fec_Fin  Varchar(10)            
    
    
    
 SELECT @p_Cod_Volante = ''            
    
 SELECT @p_Ident_Cita = ''            
    
 SELECT @p_Cod_Estado = ''            
    
 SELECT @p_Con_Volante = ''            
    
 SELECT @p_Fec_Ini = '20100525'            
    
 SELECT @p_Fec_Fin = '20100525'            
    
 */            
    
    
    
 SELECT             
    
  C.Cod_Volante,            
    
  C.Ident_Cita,            
    
  V.Con_Volante,            
    
  E.Des_Estado,              
    
  CONVERT(Varchar(10),C.Fec_Reg_Cita,103) AS [Fec_Reg_Cita],            
    
  --+ CONVERT(Varchar(10),C.Fec_Reg_Cita,108) AS [Fec_Reg_Cita],            
    
  CONVERT(Varchar(10),T.Fec_Turno,103) + ' ' + T.Des_Turno AS [Hora_Cita],        
    
  O.Nro_Comprobante AS FacturaAsociada,        
    
  V.Age_Adu_Volante AS AgenteAduanas,        
    
  C.Cod_Contenedor AS CTR,        
    
  USU.USU_Nombres AS UsuarioCreador,        
    
  --'' AS UsuarioCreador,        
    
  CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,108) AS [Fec_Ing_Nep_Cita],            
    
  CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,108) AS [Fec_Ing_Bal_Cita],             
    
  CONVERT(Varchar(10),C.Fec_Des_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Des_Cita,108) AS [Fec_Sal_Bal_Cita],              
    
  O.Nro_Placa,            
    
  C.Nro_Orden_Retiro,    
    
  O.Cod_Contenedor_Desp AS CTRDespachado,    
  -- Campo ORD_CODIGO que equivale al Servicio Integral    
        TS.ORD_CODIGO 
    
    --          ( select g.nrocon12
    -- from terminal.dbo.ddvoldes23 b (nolock)inner join terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12) 
    --                           inner join terminal.dbo.drblcont15 i on (i.navvia11=g.navvia11 and i.nrodet12=g.nrodet12)       
		  --where     
		  --i.nrosec23 is not null and  
		  --i.codcon63 is not null and  
		  ----codcon04 is not null and    
		  ----coddes92 is null and     
		  --b.nrosec23=C.Cod_Volante  and i.codcon04 = C.Cod_Contenedor ) as BL 
     
     
     
    
  -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal    
    
 -- (SELECT ORD_CODIGO FROM TERMINAL.DBO.SSI_ORDEN TS WHERE TS.ORD_BL = V.CNC_VOLANTE AND TS.ORD_NAVVIA = TD.NAVVIA11) AS 'ORD_CODIGO'    
    
     -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal       
    
 FROM dbo.CIT_Cita C            
    
 LEFT OUTER JOIN dbo.CIT_Volante V ON C.Cod_Volante = V.Cod_Volante            
    
 LEFT OUTER JOIN dbo.CIT_Estado E ON C.Cod_Estado = E.Cod_Estado AND E.Dst_Estado='CIT_Cita'            
    
 LEFT OUTER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno    
    
 LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro           
    
 -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal    
    
-- LEFT OUTER JOIN TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE      
    
 -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal    
    
    
    
 --LEFT outer JOIN (select USU_Codigo, USU_NumDocumento, USU_Nombres from neptunia1bk.Seguridad.dbo.SGT_Usuario)  USU         
    
 LEFT outer JOIN SGS_VISTA_USUARIO_ListarUsuario  USU ON C.Usuario_Registro = USU.USU_Codigo COLLATE SQL_Latin1_General_CP1_CI_AS        
 -- Línea de código para obtener el campo NAVVIA11 que es necesario para hacer el join con la tabla SSI_ORDEN a través del campo ORD_NAVVIA    
 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD     
             ON TD.NROSEC23 = V.COD_VOLANTE      
 -- Línea de código para obtener el campo para el Servicio Integral    
 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN TS     
             ON TS.ORD_BL = V.CNC_VOLANTE     
   AND TS.ORD_NAVVIA = TD.NAVVIA11     
      AND ORD_NUMDOCUMENTO <> ''     
   AND ORD_FLAGESTADO IS NULL    
 WHERE             
    
 --C.Usuario_Registro = CASE WHEN @p_Perfil = @sAgenteAduanas THEN @p_Usuario ELSE C.Usuario_Registro END AND            
    
 C.Cod_Volante = CASE WHEN @p_Cod_Volante='' THEN C.Cod_Volante ELSE @p_Cod_Volante END AND            
    
 C.Ident_Cita = CASE WHEN @p_Ident_Cita='' THEN C.Ident_Cita ELSE @p_Ident_Cita END AND            
    
 C.Cod_Estado = CASE WHEN @p_Cod_Estado='TOD' THEN C.Cod_Estado ELSE @p_Cod_Estado END AND            
    
 ( @p_Con_Volante = '' OR V.Con_Volante LIKE '%' + @p_Con_Volante + '%' )AND            
    
 T.Fec_Turno >= CASE WHEN @p_Fec_Ini='' THEN '00:00:00'  ELSE @p_Fec_Ini + ' 00:00:00' END AND            
    
 T.Fec_Turno <= CASE WHEN @p_Fec_Fin='' THEN CONVERT(Varchar,DATEADD(m,1,GETDATE()),112) ELSE @p_Fec_Fin END + ' 23:59:59'  AND            
    
 ( @p_NroOrdenRetiro = '' OR C.Nro_Orden_Retiro LIKE '%' + @p_NroOrdenRetiro + '%') AND          
    
 ( @p_AgenteAduanas = '' OR V.Age_Adu_Volante LIKE  '%' + @p_AgenteAduanas + '%' )            
    
END 
GO
/****** Object:  StoredProcedure [dbo].[CIT_ReporteCita_fase2]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
ALTER PROCEDURE [dbo].[CIT_ReporteCita_fase2]              
      
@p_Cod_Volante Varchar(6),              
      
@p_Ident_Cita Varchar(15),              
      
@p_Cod_Estado Varchar(3),              
      
@p_Con_Volante Varchar(80),              
      
@p_Fec_Ini  Varchar(10),              
      
@p_Fec_Fin  Varchar(10),              
      
@p_Perfil  Varchar(10),              
      
@p_Usuario  Varchar(20),              
      
@sAgenteAduanas Varchar(10),            
      
@p_NroOrdenRetiro varchar(80),          
      
@p_AgenteAduanas Varchar(10)       
      
AS              
      
BEGIN        
      
 /*              
      
 CIT_ReporteCita  '536742','','TOD','','','','','','','',''      
      
 -- Valores Prueba:              
      
 DECLARE @p_Cod_Volante Varchar(6),              
      
   @p_Ident_Cita Varchar(15),              
      
   @p_Cod_Estado Varchar(3),              
      
   @p_Con_Volante Varchar(80),              
      
   @p_Fec_Ini  Varchar(10),              
      
   @p_Fec_Fin  Varchar(10)              
      
      
      
 SELECT @p_Cod_Volante = ''              
      
 SELECT @p_Ident_Cita = ''              
      
 SELECT @p_Cod_Estado = ''              
      
 SELECT @p_Con_Volante = ''              
      
 SELECT @p_Fec_Ini = '20100525'              
      
 SELECT @p_Fec_Fin = '20100525'              
      
 */              
      
 
 
 SELECT *
 FROM     
 (     
 SELECT               
      
  C.Cod_Volante,              
      
  C.Ident_Cita,              
      
  V.Con_Volante,              
      
  E.Des_Estado,                
      
  CONVERT(Varchar(10),C.Fec_Reg_Cita,103) AS [Fec_Reg_Cita],
  fec_reg_cita as Fecha_Carga_Data,              
      
  --+ CONVERT(Varchar(10),C.Fec_Reg_Cita,108) AS [Fec_Reg_Cita],              
      
  CONVERT(Varchar(10),T.Fec_Turno,103) + ' ' + T.Des_Turno AS [Hora_Cita],          
      
  O.Nro_Comprobante AS FacturaAsociada,          
      
  V.Age_Adu_Volante AS AgenteAduanas,          
      
  --C.Cod_Contenedor AS CTR,     
    
      CASE ISNULL((select RUC from [dbo].[CIT_Parametro_Clientes_Especiales] where ruc collate SQL_Latin1_General_CP1_CI_AS = v.Ruc_Con_Volante  collate SQL_Latin1_General_CP1_CI_AS),'A')  
   WHEN 'A' THEN ' '   
   ELSE C.Cod_Contenedor   
   END as CTR ,       
      
  USU.USU_Nombres AS UsuarioCreador,          
      
  --'' AS UsuarioCreador,          
      
  CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,108) AS [Fec_Ing_Nep_Cita],              
      
  CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,108) AS [Fec_Ing_Bal_Cita],               
      
  CONVERT(Varchar(10),C.Fec_Des_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Des_Cita,108) AS [Fec_Sal_Bal_Cita],                
      
  O.Nro_Placa,              
      
  C.Nro_Orden_Retiro,      
      
  O.Cod_Contenedor_Desp AS CTRDespachado,      
  -- Campo ORD_CODIGO que equivale al Servicio Integral      
        TS.ORD_CODIGO ,  
          
          --lester
    --          ( select g.nrocon12  
    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   
    --                           inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 i on (i.navvia11=g.navvia11 and i.nrodet12=g.nrodet12)         
    --where       
    --i.nrosec23 is not null and    
    --i.codcon63 is not null and    
    ----codcon04 is not null and      
    ----coddes92 is null and       
    --b.nrosec23=C.Cod_Volante  and i.codcon04 = C.Cod_Contenedor ) as BL   
      
      
      --ROBERT
    --  ( select g.nrocon12
    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   
    --where                
    --b.nrosec23=C.Cod_Volante and c.fec_reg_cita > CONVERT(Varchar,DATEadd(m,-12,GETDATE()),112)) as BL,
    --  ( select COUNT(I.codcon04)  
    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   
    --                           inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 i on (i.navvia11=g.navvia11 and i.nrodet12=g.nrodet12)         
    --where                
    --b.nrosec23=C.Cod_Volante) as NumeroContenedores
      
      '' AS BL,
      '' AS NumeroContenedores
    
  
  -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal      
      
 -- (SELECT ORD_CODIGO FROM TERMINAL.DBO.SSI_ORDEN TS WHERE TS.ORD_BL = V.CNC_VOLANTE AND TS.ORD_NAVVIA = TD.NAVVIA11) AS 'ORD_CODIGO'      
      
     -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal         
      
 FROM dbo.CIT_Cita C              
      
 LEFT OUTER JOIN dbo.CIT_Volante V ON C.Cod_Volante = V.Cod_Volante
 --INNER JOIN dbo.CIT_Volante V ON C.Cod_Volante = V.Cod_Volante                            
      
 LEFT OUTER JOIN dbo.CIT_Estado E ON C.Cod_Estado = E.Cod_Estado AND E.Dst_Estado='CIT_Cita'        
 --INNER JOIN dbo.CIT_Estado E ON C.Cod_Estado = E.Cod_Estado AND E.Dst_Estado='CIT_Cita'        
      
 LEFT OUTER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno      
      
 LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro             
 
 
      
 -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal      
      
-- LEFT OUTER JOIN TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        
      
 -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal      
      
      
      
 --LEFT outer JOIN (select USU_Codigo, USU_NumDocumento, USU_Nombres from neptunia1bk.Seguridad.dbo.SGT_Usuario)  USU           
      
 LEFT outer JOIN SGS_VISTA_USUARIO_ListarUsuario  USU ON C.Usuario_Registro = USU.USU_Codigo COLLATE SQL_Latin1_General_CP1_CI_AS          
 -- Línea de código para obtener el campo NAVVIA11 que es necesario para hacer el join con la tabla SSI_ORDEN a través del campo ORD_NAVVIA      
 --LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        
 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        
 
 -- Línea de código para obtener el campo para el Servicio Integral      
 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN TS       
             ON TS.ORD_BL = V.CNC_VOLANTE       
   AND TS.ORD_NAVVIA = TD.NAVVIA11       
      AND ORD_NUMDOCUMENTO <> ''       
   AND ORD_FLAGESTADO IS NULL      
 WHERE               
      
 --C.Usuario_Registro = CASE WHEN @p_Perfil = @sAgenteAduanas THEN @p_Usuario ELSE C.Usuario_Registro END AND              
      
 C.Cod_Volante = CASE WHEN @p_Cod_Volante='' THEN C.Cod_Volante ELSE @p_Cod_Volante END AND              
      
 C.Ident_Cita = CASE WHEN @p_Ident_Cita='' THEN C.Ident_Cita ELSE @p_Ident_Cita END AND              
      
 C.Cod_Estado = CASE WHEN @p_Cod_Estado='TOD' THEN C.Cod_Estado ELSE @p_Cod_Estado END AND              
      
 ( @p_Con_Volante = '' OR V.Con_Volante LIKE '%' + @p_Con_Volante + '%' )AND              
      
 T.Fec_Turno >= CASE WHEN @p_Fec_Ini='' THEN '00:00:00'  ELSE @p_Fec_Ini + ' 00:00:00' END AND              
      
 T.Fec_Turno <= CASE WHEN @p_Fec_Fin='' THEN CONVERT(Varchar,DATEADD(m,1,GETDATE()),112) ELSE @p_Fec_Fin END + ' 23:59:59'  AND  
      
 ( @p_NroOrdenRetiro = '' OR C.Nro_Orden_Retiro LIKE '%' + @p_NroOrdenRetiro + '%') AND            
      
 ( @p_AgenteAduanas = '' OR V.Age_Adu_Volante LIKE  '%' + @p_AgenteAduanas + '%' )              
        

) AS B
WHERE B.Fecha_Carga_Data > CONVERT(Varchar,DATEadd(m,-12,GETDATE()),112)
--and B.Cod_Volante = @p_Con_Volante

END 

GO
/****** Object:  StoredProcedure [dbo].[CIT_ReporteCita_fase2_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      

ALTER PROCEDURE [dbo].[CIT_ReporteCita_fase2_JFN]              

      

@p_Cod_Volante Varchar(6),              

      

@p_Ident_Cita Varchar(15),              

      

@p_Cod_Estado Varchar(3),              

      

@p_Con_Volante Varchar(80),              

      

@p_Fec_Ini  Varchar(10),              

      

@p_Fec_Fin  Varchar(10),              

      

@p_Perfil  Varchar(10),              

      

@p_Usuario  Varchar(20),              

      

@sAgenteAduanas Varchar(10),            

      

@p_NroOrdenRetiro varchar(80),          

      

@p_AgenteAduanas Varchar(10)       

      

AS              

      

BEGIN        

      

 /*              

      

 CIT_ReporteCita  '536742','','TOD','','','','','','','',''      

      

 -- Valores Prueba:              

      

 DECLARE @p_Cod_Volante Varchar(6),              

      

   @p_Ident_Cita Varchar(15),              

      

   @p_Cod_Estado Varchar(3),              

      

   @p_Con_Volante Varchar(80),              

      

   @p_Fec_Ini  Varchar(10),              

      

   @p_Fec_Fin  Varchar(10)              

      

      

      

 SELECT @p_Cod_Volante = ''              

      

 SELECT @p_Ident_Cita = ''              

      

 SELECT @p_Cod_Estado = ''              

      

 SELECT @p_Con_Volante = ''              

      

 SELECT @p_Fec_Ini = '20100525'              

      

 SELECT @p_Fec_Fin = '20100525'              

      

 */              

      

 

 

 SELECT *

 FROM     

 (     

 SELECT               

      

  C.Cod_Volante,              

      

  C.Ident_Cita,              

      

  V.Con_Volante,              

      

  E.Des_Estado,                

      

  CONVERT(Varchar(10),C.Fec_Reg_Cita,103) AS [Fec_Reg_Cita],

  fec_reg_cita as Fecha_Carga_Data,              

      

  --+ CONVERT(Varchar(10),C.Fec_Reg_Cita,108) AS [Fec_Reg_Cita],              

      

  CONVERT(Varchar(10),T.Fec_Turno,103) + ' ' + T.Des_Turno AS [Hora_Cita],          

      

  O.Nro_Comprobante AS FacturaAsociada,          

      

  V.Age_Adu_Volante AS AgenteAduanas,          

      

  --C.Cod_Contenedor AS CTR,     

    

      CASE ISNULL((select RUC from [dbo].[CIT_Parametro_Clientes_Especiales] where ruc collate SQL_Latin1_General_CP1_CI_AS = v.Ruc_Con_Volante  collate SQL_Latin1_General_CP1_CI_AS),'A')  

   WHEN 'A' THEN ' '   

   ELSE C.Cod_Contenedor   

   END as CTR ,       

      

  USU.USU_Nombres AS UsuarioCreador,          

      

  --'' AS UsuarioCreador,          

      

  CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Nep_Cita,108) AS [Fec_Ing_Nep_Cita],              

      

  CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Ing_Bal_Cita,108) AS [Fec_Ing_Bal_Cita],               

      

  CONVERT(Varchar(10),C.Fec_Des_Cita,103) + ' ' +CONVERT(Varchar(10),C.Fec_Des_Cita,108) AS [Fec_Sal_Bal_Cita],                

      

  O.Nro_Placa,              

      

  C.Nro_Orden_Retiro,      

      

  O.Cod_Contenedor_Desp AS CTRDespachado,      

  -- Campo ORD_CODIGO que equivale al Servicio Integral      

        TS.ORD_CODIGO ,  

          

          --lester

    --          ( select g.nrocon12  

    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   

    --                           inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 i on (i.navvia11=g.navvia11 and i.nrodet12=g.nrodet12)         

    --where       

    --i.nrosec23 is not null and    

    --i.codcon63 is not null and    

    ----codcon04 is not null and      

    ----coddes92 is null and       

    --b.nrosec23=C.Cod_Volante  and i.codcon04 = C.Cod_Contenedor ) as BL   

      

      

      --ROBERT

    --  ( select g.nrocon12

    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   

    --where                

    --b.nrosec23=C.Cod_Volante and c.fec_reg_cita > CONVERT(Varchar,DATEadd(m,-12,GETDATE()),112)) as BL,

    --  ( select COUNT(I.codcon04)  

    -- from [SP3TDA-DBSQL01].terminal.dbo.ddvoldes23 b (nolock)inner join [SP3TDA-DBSQL01].terminal.dbo.dddetall12 g on (b.navvia11=g.navvia11 and b.nrodet12=g.nrodet12)   

    --                           inner join [SP3TDA-DBSQL01].terminal.dbo.drblcont15 i on (i.navvia11=g.navvia11 and i.nrodet12=g.nrodet12)         

    --where                

    --b.nrosec23=C.Cod_Volante) as NumeroContenedores

      

      '' AS BL,

      '' AS NumeroContenedores,


    c.Nu_OrdenRetiro_AsociaCita,

  case c.Cumple_Cita
  when 1 then 'SI'
  when 0 then 'No'
  else
  ''
  end  as CumpleCita

  -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal      

      

 -- (SELECT ORD_CODIGO FROM TERMINAL.DBO.SSI_ORDEN TS WHERE TS.ORD_BL = V.CNC_VOLANTE AND TS.ORD_NAVVIA = TD.NAVVIA11) AS 'ORD_CODIGO'      

      

     -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal         

      

 FROM dbo.CIT_Cita C              

      

 LEFT OUTER JOIN dbo.CIT_Volante V ON C.Cod_Volante = V.Cod_Volante

 --INNER JOIN dbo.CIT_Volante V ON C.Cod_Volante = V.Cod_Volante                            

      

 LEFT OUTER JOIN dbo.CIT_Estado E ON C.Cod_Estado = E.Cod_Estado AND E.Dst_Estado='CIT_Cita'        

 --INNER JOIN dbo.CIT_Estado E ON C.Cod_Estado = E.Cod_Estado AND E.Dst_Estado='CIT_Cita'        

      

 LEFT OUTER JOIN dbo.CIT_Turno T ON C.Ident_Turno = T.Ident_Turno      

      

 LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON C.Nro_Orden_Retiro = O.Nro_Orden_Retiro             

 

 

      

 -- Inicio: 25/05/2015 REQ002 - Obtener servicio terminal      

      

-- LEFT OUTER JOIN TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        

      

 -- Fin: 25/05/2015 REQ002 - Obtener servicio terminal      

      

      

      

 --LEFT outer JOIN (select USU_Codigo, USU_NumDocumento, USU_Nombres from neptunia1bk.Seguridad.dbo.SGT_Usuario)  USU           

      

 LEFT outer JOIN SGS_VISTA_USUARIO_ListarUsuario  USU ON C.Usuario_Registro = USU.USU_Codigo COLLATE SQL_Latin1_General_CP1_CI_AS          

 -- Línea de código para obtener el campo NAVVIA11 que es necesario para hacer el join con la tabla SSI_ORDEN a través del campo ORD_NAVVIA      

 --LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        

 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = V.COD_VOLANTE        

 

 -- Línea de código para obtener el campo para el Servicio Integral      

 LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN TS       

             ON TS.ORD_BL = V.CNC_VOLANTE       

   AND TS.ORD_NAVVIA = TD.NAVVIA11       

      AND ORD_NUMDOCUMENTO <> ''       

   AND ORD_FLAGESTADO IS NULL      

 WHERE               

      

 --C.Usuario_Registro = CASE WHEN @p_Perfil = @sAgenteAduanas THEN @p_Usuario ELSE C.Usuario_Registro END AND              

      

 C.Cod_Volante = CASE WHEN @p_Cod_Volante='' THEN C.Cod_Volante ELSE @p_Cod_Volante END AND              

      

 C.Ident_Cita = CASE WHEN @p_Ident_Cita='' THEN C.Ident_Cita ELSE @p_Ident_Cita END AND              

      

 C.Cod_Estado = CASE WHEN @p_Cod_Estado='TOD' THEN C.Cod_Estado ELSE @p_Cod_Estado END AND              

      

 ( @p_Con_Volante = '' OR V.Con_Volante LIKE '%' + @p_Con_Volante + '%' )AND              

      

 T.Fec_Turno >= CASE WHEN @p_Fec_Ini='' THEN '00:00:00'  ELSE @p_Fec_Ini + ' 00:00:00' END AND              

      

 T.Fec_Turno <= CASE WHEN @p_Fec_Fin='' THEN CONVERT(Varchar,DATEADD(m,1,GETDATE()),112) ELSE @p_Fec_Fin END + ' 23:59:59'  AND  

      

 ( @p_NroOrdenRetiro = '' OR C.Nro_Orden_Retiro LIKE '%' + @p_NroOrdenRetiro + '%') AND            

      

 ( @p_AgenteAduanas = '' OR V.Age_Adu_Volante LIKE  '%' + @p_AgenteAduanas + '%' )              

        



) AS B

WHERE B.Fecha_Carga_Data > CONVERT(Varchar,DATEadd(m,-12,GETDATE()),112)

--and B.Cod_Volante = @p_Con_Volante



END 


GO
/****** Object:  StoredProcedure [dbo].[CIT_ReprogramarCitaTurno]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CIT_ReprogramarCitaTurno]
(
@Ident_Cita int,
@Ident_Turno int,
@Usuario_Registro varchar(50)
)
AS BEGIN

UPDATE CIT_Cita
set Ident_Turno = @Ident_Turno, Cod_Estado = 'REP',
Usuario_Registro = @Usuario_Registro, Fec_Rep_Cita = GETDATE()
WHERE Ident_Cita = @Ident_Cita

END

GO
/****** Object:  StoredProcedure [dbo].[CIT_ReprogramarCitaTurno_JFN]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CIT_ReprogramarCitaTurno_JFN]
(
@Ident_Cita int,
@Ident_Turno int,
@Usuario_Registro varchar(50)
)
AS BEGIN

UPDATE CIT_Cita
set Ident_Turno = @Ident_Turno, Cod_Estado = 'REP',
Usuario_Registro = @Usuario_Registro, Fec_Rep_Cita = GETDATE()
WHERE Ident_Cita = @Ident_Cita

declare @Fe_Actual as datetime
set @Fe_Actual=getdate()
exec CIT_AUDITORIA_ESTADOS 'REP',@Ident_Cita,@Fe_Actual,@Usuario_Registro;
END


GO
/****** Object:  StoredProcedure [dbo].[CIT_UpdateRetiroTransportista]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_UpdateRetiroTransportista]          
(        
@Codigo int,          
@retiros_v_numeroOR varchar(15),          
@retiros_v_Placa varchar(10),          
@retiros_v_nombre varchar(50),          
@retiros_v_Dni varchar(8),          
@retiros_v_numbrevete varchar(10),          
@retiros_d_fecha datetime,          
@estadoret_n_codigo int,          
@retiros_v_agenteadu varchar(50),          
@retiros_v_Dniagenteadu varchar(11),          
@retiros_v_numop varchar(11),          
@UsuarioRegistro varchar(20),          
@AuditoriaFecha varchar(50),          
@AuditoriaHora varchar(10),          
@AuditoriaEvento varchar(20),    
@Despachador varchar(150)       
)          
          
AS BEGIN          
          
UPDATE CIT_RetiroTransportista        
SET retiros_v_numeroOR = @retiros_v_numeroOR,retiros_v_Placa=@retiros_v_Placa,retiros_v_nombre=@retiros_v_nombre,        
 retiros_v_Dni=@retiros_v_Dni,retiros_v_numbrevete=@retiros_v_numbrevete,      
 --retiros_d_fecha=@retiros_d_fecha,        
 estadoret_n_codigo=@estadoret_n_codigo,retiros_v_agenteadu=@retiros_v_agenteadu,retiros_v_Dniagenteadu=@retiros_v_Dniagenteadu,        
 retiros_v_numop=@retiros_v_numop, Despachador = @Despachador       
WHERE retiros_n_codigo = @Codigo             
          
INSERT INTO CIT_RetiroAuditoria(retiros_n_codigo,auditoria_d_fecha,auditoria_v_hora,auditoria_v_usuario,auditoria_v_evento,retiros_v_placa,retiros_v_numeroOR)           
VALUES (@Codigo,@AuditoriaFecha,@AuditoriaHora,@UsuarioRegistro,@AuditoriaEvento,@retiros_v_Placa,@retiros_v_numeroOR)          
          
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_UpdateRetiroTransportista_NEW]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_UpdateRetiroTransportista_NEW] (
	@Codigo INT
	,@retiros_v_numeroOR VARCHAR(15)
	,@retiros_v_Placa VARCHAR(10)
	,@retiros_v_nombre VARCHAR(50)
	,@retiros_v_Dni VARCHAR(8)
	,@retiros_v_numbrevete VARCHAR(10)
	,@retiros_d_fecha DATETIME
	,@estadoret_n_codigo INT
	,@retiros_v_agenteadu VARCHAR(50)
	,@retiros_v_Dniagenteadu VARCHAR(11)
	,@retiros_v_numop VARCHAR(11)
	,@UsuarioRegistro VARCHAR(20)
	,@AuditoriaFecha VARCHAR(50)
	,@AuditoriaHora VARCHAR(10)
	,@AuditoriaEvento VARCHAR(20)
	,@Despachador VARCHAR(150)
	,@retiros_v_Celular VARCHAR(9)
	)
AS
BEGIN
	UPDATE CIT_RetiroTransportista
	SET retiros_v_numeroOR = @retiros_v_numeroOR
		,retiros_v_Placa = @retiros_v_Placa
		,retiros_v_nombre = @retiros_v_nombre
		,retiros_v_Dni = @retiros_v_Dni
		,retiros_v_numbrevete = @retiros_v_numbrevete
		,
		--retiros_d_fecha=@retiros_d_fecha,          
		estadoret_n_codigo = @estadoret_n_codigo
		,retiros_v_agenteadu = @retiros_v_agenteadu
		,retiros_v_Dniagenteadu = @retiros_v_Dniagenteadu
		,retiros_v_numop = @retiros_v_numop
		,Despachador = @Despachador
		,retiros_v_Celular = @retiros_v_Celular
	WHERE retiros_n_codigo = @Codigo

	INSERT INTO CIT_RetiroAuditoria (
		retiros_n_codigo
		,auditoria_d_fecha
		,auditoria_v_hora
		,auditoria_v_usuario
		,auditoria_v_evento
		,retiros_v_placa
		,retiros_v_numeroOR
		)
	VALUES (
		@Codigo
		,@AuditoriaFecha
		,@AuditoriaHora
		,@UsuarioRegistro
		,@AuditoriaEvento
		,@retiros_v_Placa
		,@retiros_v_numeroOR
		)
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidaNumOpeByOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ValidaNumOpeByOR]  
(

@OrdenRetiro varchar(6), 

@NumOpe varchar(11)  

)  

AS BEGIN  

declare @TipoMercaderia varchar(3)

 set @TipoMercaderia = ''

 set @TipoMercaderia = (select codemb06 from [SP3TDA-DBSQL01].terminal.dbo.ddordret41 where nroord41 = substring(upper(@OrdenRetiro),1,6) )

 if @TipoMercaderia = 'CTR'   

	select nroord41 AS 'OrdenRetiro'   

	from [SP3TDA-DBSQL01].TERMINAL.dbo.ddordret41

	WHERE nroord41 = @OrdenRetiro and codibm45 = @NumOpe  

 else 

	select @OrdenRetiro as 'OrdenRetiro'

END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarCapacidadMaxima]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------
-- Nombre: [CIT_Validar_CapacidadMaxima]
-- Objetivo: Actualiza Capacidad Máxima por Valores de Parámetros
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100531
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100531
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ValidarCapacidadMaxima]
	@p_Anio			int,
	@p_Mes			int,
	@p_Dia			int,
	@p_Turno		Varchar(11),
	@p_Capacidad	int
AS
BEGIN
/*	
	DECLARE @p_Anio			int,
			@p_Mes			int,
			@p_Dia			int,
			@p_Turno		Varchar(11),
			@p_Capacidad	int,
			@p_Usuario		Varchar(20)

	SET @p_Anio = 2010
	SET @p_Mes = 0
	SET @p_Dia = 0
	SET @p_Turno = '0'
	SET @p_Capacidad = 8	
*/
	

	DECLARE @sRpta		Varchar(150),
			@sFecha		Varchar(8)

	SET	@sRpta =	''
	SET @sFecha	=	RTRIM(LTRIM(STR(@p_Anio))) +
					CASE WHEN @p_Mes = 0 THEN	'01' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Mes))),2) END +
					CASE WHEN @p_Dia = 0 THEN	'01' ELSE RIGHT('00' + RTRIM(LTRIM(STR(@p_Dia))),2) END

	--PRINT 	@sFecha

	IF (CONVERT(Varchar(8),GETDATE(),112) < @sFecha)
	BEGIN
		SET	@sRpta =	'El periodo seleccionado no puede ser menor a la fecha actual'
	END

	SELECT @sRpta AS [Rpta]

END




GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarCodigoAutorizacion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ValidarCodigoAutorizacion]    
@Codigo_Generado varchar(20)    
as    
    
select Codigo_Generado,  
case when CONVERT(Datetime,CONVERT(Varchar(10),fec_registro,111)+ ' 23:59:59') < GETDATE() then 'V' else Estado end AS 'EstadoAEvaluar'  
from dbo.CIT_CodigoAutogenerado where Codigo_Generado=@Codigo_Generado
order by fec_registro desc
GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarDisponibilidadYListaContenedoresXVolante]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  RV  
-- Create date: 11/12/2014  
-- Description: Valida si la información que se va a registrar en la cita puede ser posible o no.  
-- =============================================  
ALTER PROCEDURE [dbo].[CIT_ValidarDisponibilidadYListaContenedoresXVolante] @p_Cod_Volante VARCHAR(6)
	,@p_Cod_Contenedor VARCHAR(5000)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(Ident_Cita)
	FROM dbo.CIT_Cita A
	inner join dbo.Cit_ordenretiro B on ltrim(rtrim(isnull(A.Nu_OrdenRetiro_AsociaCita collate Latin1_General_CI_AI,''))) = ltrim(rtrim(B.Nro_Orden_Retiro))	
	WHERE A.Cod_Volante = @p_Cod_Volante
		AND A.Cod_Estado IN (
			'REG'
			,'FAC'
			)
		--AND Cod_Contenedor COLLATE DATABASE_DEFAULT IN (
		AND isnull(B.Cod_Contenedor_Desp,'') COLLATE DATABASE_DEFAULT IN (
			SELECT splitdata
			FROM dbo.fnSplitString(@p_Cod_Contenedor, ',')
			)
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_validarFechaVigenciaOR]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_validarFechaVigenciaOR]
@sNroOrd char(8),
@Orden_de_Retiro varchar(15) output,
@Fecha_de_Vigencia datetime output
as

select @Orden_de_Retiro = a.nroord41 ,
       @Fecha_de_Vigencia = a.fecexp41 

        
from [SP3TDA-DBSQL01].TERMINAL.dbo.ddordret41 a (nolock)  
inner join [SP3TDA-DBSQL01].TERMINAL.dbo.dddetord43 b (nolock) on (a.nroord41=b.nroord41)  
left join [SP3TDA-DBSQL01].TERMINAL.dbo.ddblodes60 c (nolock) on (a.navvia11=c.navvia11 and a.nrodet12=c.nrodet12)  
where a.nroord41=SUBSTRING(@sNroOrd,1, 6)  
GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarHoraAtencionIntegrales]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- Nombre: CIT_Validar_HoraAtencionIntegrales
-- Objetivo: Validación del parámetro Horario de Atención Integrales
-- Valores Prueba: 
-- Creacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100531
-- Modificacion: Mirko Portocarrero Valenzuela - Gesfor Perú - 20100531
---------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[CIT_ValidarHoraAtencionIntegrales]
	@p_HoraInicioIntegral Varchar(20)
AS
BEGIN

	/*
	DECLARE @HoraInicioIntegral	Decimal(18,7)
	SET @HoraInicioIntegral = 7
	*/

	DECLARE @nIntervalo Decimal(18,7),
			@nHoraInicio Decimal(18,7),
			@Rpta Varchar(150)

	SET @Rpta = ''

	SELECT @nIntervalo = CONVERT(Decimal(18,7),P.Valor_Parametro)
	FROM CIT_PARAMETRO P
		WHERE P.Cod_Parametro IN (6)

	SELECT @nHoraInicio = CONVERT(Decimal(18,7),P.Valor_Parametro)
	FROM CIT_PARAMETRO P
		WHERE P.Cod_Parametro IN (2)

	IF (ABS((@nHoraInicio - @p_HoraInicioIntegral) % @nIntervalo) > 0)
	BEGIN
		SET @Rpta = 'La Hora Inicio de Atención Integrales debe ser proporcional a la Hora Inicio de Atención'
	END

	SELECT @Rpta AS [Rpta]

END








GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarReservaCupos]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIT_ValidarReservaCupos]
(@Fec_ini DATETIME, 
@Fec_Fin DATETIME,  
@Tur_Reserva varchar(50), 
@Cantidad int)  
AS   
BEGIN  
	SELECT 
		CASE
			WHEN @Fec_ini > @Fec_Fin THEN 'Fecha de Inicio es Mayor a la Fecha FIN'   
			WHEN (	
					SELECT count(*) 
					FROM   dbo.CIT_ReservaCupos 
					WHERE  
					(@Fec_ini Between Fec_Desde and Fec_Hasta or  
					@Fec_Fin between Fec_Desde and Fec_Hasta ) 
					and Tur_Reserva = Tur_Reserva  
				) > 0  THEN 'Ya Existe una Reserva para el Turno Seleccionado'                
			WHEN @Cantidad = 0 THEN 'Debe ingresar una Cantidad a Bloquear/Separar'                      
			ELSE ''       
		END AS Mensaje 
END
GO
/****** Object:  StoredProcedure [dbo].[CIT_ValidarReservaDisponibleCupos]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  RV  
-- Create date: 09/07/2014  
-- Description: VALIDA SI UNA RESERVA QUE SE INTENTA REGISTRAR PUEDE O NO SER REGISTRADA DE ACUERDO A LA  
--    CANTIDAD ENVIADA COMO PARÁMETRO, DEVUELVE 1 SI ES POSIBLE Y 0 SI NO ES POSIBLE  
-- =============================================  
-- EXEC CIT_ValidarReservaDisponibleCupos '20141027','20141030','08:00-09:00',31
ALTER PROCEDURE [dbo].[CIT_ValidarReservaDisponibleCupos]  
--DECLARE   
@pFDesde DATETIME,  
@pFHasta DATETIME,  
@pTurno VARCHAR(50),  
@pCantidad INT  
AS  
BEGIN   
	SET NOCOUNT ON;   
	SET @pFDesde = CONVERT(DATETIME,@pFDesde,103)  
	SET @pFHasta = CONVERT(DATETIME,@pFHasta,103)  
	SET @pTurno = @pTurno  
	SET @pCantidad = @pCantidad  

	--RESETEAMOS LOS VALORES DE LAS FECHAS  
	SET @pFDesde = DATEADD(DD,0,DATEDIFF(DD,0,@pFDesde))      
	SET @pFHasta = DATEADD(SS,-1,DATEADD(DD,1,DATEDIFF(DD,0,@pFHasta)))      

	--OBTENEMOS LAS FECHAS REGISTRADAS PARA EL INTERVALO SELECCIONADO  
	DECLARE @TFechaCapacidad TABLE (ID INT PRIMARY KEY IDENTITY, Fecha_Capacidad DATETIME)  
	INSERT INTO @TFechaCapacidad  
	SELECT DISTINCT Fecha_Capacidad  
	FROM CIT_CapacidadMaximaAtencionTurno  
	WHERE    
		Fecha_Capacidad BETWEEN @pFDesde AND @pFHasta  
	ORDER BY Fecha_Capacidad  

	DECLARE @IDMIN INT, @IDMAX INT, @RESULT INT  
	SET @RESULT = 1  
	SELECT @IDMIN = MIN (ID) FROM @TFechaCapacidad  
	SELECT @IDMAX = MAX (ID) FROM @TFechaCapacidad  

	WHILE(@IDMIN <= @IDMAX)  
	BEGIN		
		DECLARE @FCAPA DATETIME, @pCapaTemp INT 
		SELECT @FCAPA = Fecha_Capacidad FROM @TFechaCapacidad WHERE ID = @IDMIN  

		DECLARE @CAPA INT  
		EXEC @CAPA = dbo.CIT_ObtenerCapacidadCalendario @pTurno,@FCAPA   
		--SELECT @CAPA  
		/*OBTENEMOS LOS CUPOS YA RESERVADOS PARA LA FECHA INDICADA*/
		DECLARE @SumaCuposReservados INT
		SELECT @SumaCuposReservados = SUM(Cantidad)
		FROM dbo.CIT_ReservaCupos
		WHERE 
		Tur_Reserva = @pTurno
		AND @FCAPA BETWEEN Fec_Desde AND Fec_Hasta

		SET @pCapaTemp = @pCantidad + ISNULL(@SumaCuposReservados,0)

		IF(@CAPA<@pCapaTemp)  
		BEGIN  
			--SELECT @CAPA capa, @pCantidad cant, @FCAPA fcapa
			SET @RESULT = 0  
			BREAK;  
		END    

		SET @IDMIN = @IDMIN + 1  
	END  
	SELECT @RESULT   
END  
GO
/****** Object:  StoredProcedure [dbo].[CIT_VencidaCanceladaCita]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CIT_VencidaCanceladaCita]  
@p_Ident_Cita   int,
@Estado_cita as char(3) -- estado de cita
AS  
BEGIN  

	IF @Estado_cita='CAN'
	begin

	UPDATE  CIT_Cita  
	SET 
	Cod_Estado=@Estado_cita,
	[Fec_Can_Cita]=GETDATE() 
	WHERE 
	Ident_Cita = @p_Ident_Cita  
	end
	else
	begin
		UPDATE  CIT_Cita  
	SET 
	Cod_Estado=@Estado_cita,
	[Fec_Ven_Cita]=GETDATE() 
	WHERE 
	Ident_Cita = @p_Ident_Cita  

	end 
	/*INICIO*/
	declare @EsReproVencia as int
	select @EsReproVencia=isnull(EsRepr_Vencimiento,0) from CIT_Cita _Ident_Cita  
	if @EsReproVencia=0
	begin
		UPDATE  CIT_Cita  SET EsRepr_Vencimiento=1 WHERE Ident_Cita = @p_Ident_Cita  
	end
	else if @EsReproVencia=1
	begin
		UPDATE  CIT_Cita  SET EsRepr_Vencimiento=2 WHERE Ident_Cita = @p_Ident_Cita  
	end
	/* FIN*/

	/*INICIO LIBERAR CUANDO ES CANCELADO*/
	IF @Estado_cita='CAN'
		BEGIN
		DECLARE @IDENT_TURNO INT,
				@IDENT_CITAPADRE INT,
				@NRO_ORDENRETIRO VARCHAR(10),
				@NRO_CONTENEDOR VARCHAR(11)

		SELECT 
			@IDENT_TURNO = Ident_Turno, 
			@IDENT_CITAPADRE = Cod_Cita_Padre,
			@NRO_ORDENRETIRO = Nro_Orden_Retiro,
			@NRO_CONTENEDOR = Cod_Contenedor
		FROM dbo.CIT_Cita
		WHERE Ident_Cita = @p_Ident_Cita


		UPDATE CIT_Turno  
		SET 
			Cap_Disp_Turno = Cap_Disp_Turno + 1,  
			Cap_Res_Turno = Cap_Res_Turno - 1  
		WHERE 
		Ident_Turno = @IDENT_TURNO  

		UPDATE CIT_CitaPadre  
		SET 
			Cup_Res_Cita_Padre = Cup_Res_Cita_Padre - 1  
		WHERE 
		Cod_Cita_Padre = @IDENT_CITAPADRE  

		UPDATE C
		SET
			C.Ord_Contenedor = 99
		FROM dbo.CIT_Contenedor C
		INNER JOIN dbo.CIT_Cita I ON I.Cod_Volante = C.Cod_Volante
		WHERE 
		I.Ident_Cita = @p_Ident_Cita
		AND C.Cod_Contenedor = @NRO_CONTENEDOR


		UPDATE dbo.CIT_OrdenRetiro
		SET
			ConCita = 0
		WHERE 
		Nro_Orden_Retiro = @NRO_ORDENRETIRO
		AND Cod_Contenedor = @NRO_CONTENEDOR
	END
	/*FIN*/

	-- Registrar en tabla auditoria
	DECLARE @Fe_Actual AS datetime
	set @Fe_Actual=getdate()
	exec CIT_AUDITORIA_ESTADOS @Estado_cita,@p_Ident_Cita,@Fe_Actual,'SISTEMA';

END

GO
/****** Object:  StoredProcedure [dbo].[PAR_ObtenerTablaGenericaXDefinicion]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----------------------------------------------------------------------
-- Nombre: PAR_ObtenerTablaGenericaXDefinicion
-- Objetivo: Obtener Tabla Generica por Definicion , como los dias o los meses del calendario
-- Valores Prueba: 
-- Creacion: Juan Carlos Urrelo 01/06/2010
-- Modificacion: 
--------------------------------------------------------------------

ALTER PROCEDURE [dbo].[PAR_ObtenerTablaGenericaXDefinicion]
	@codigo int
AS
BEGIN

SELECT Ident_Campo,CodlCampo,DescmCampo  
FROM PAR_Tabla_Generica
WHERE Ident_Tabla=@codigo
ORDER BY CodiOrden

END







GO
/****** Object:  StoredProcedure [dbo].[SPLIST_NROPLA_PANEL]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPLIST_NROPLA_PANEL]
AS
BEGIN

	SELECT NRO_PLACA, 'EN PANEL' CON_PANEL, '' AS NRO_OR   
	FROM dbo.CIT_PanelElectronicoVista

	UNION

	SELECT 
		NRO_PLACA  COLLATE DATABASE_DEFAULT NRO_PLACA, 'EN COLA' CON_PANEL, 
		Nro_Orden_Retiro COLLATE DATABASE_DEFAULT NRO_OR
	FROM DBO.CIT_PANELELECTRONICOTEMPORAL 

	UNION

	SELECT NRO_PLACA  COLLATE DATABASE_DEFAULT NRO_PLACA,'SIN PANEL' CON_PANEL, Nro_Orden_Retiro NRO_OR
	FROM DBO.CIT_ENVIOSPARCTEMPORAL
	WHERE ENVIADO = 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CIT_GetAllOrdenRetiroByFiltros]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CIT_GetAllOrdenRetiroByFiltros] (
	@CodigoAgenciaAduanas VARCHAR(4)
	,@Perfil VARCHAR(2)
	,@OrdenRetiro VARCHAR(6)
	,@FechaIni VARCHAR(10)
	,@FechaFin VARCHAR(10)
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@Perfil = 'AA')
	BEGIN
		IF @OrdenRetiro = ''
			AND @FechaIni = ''
			AND @FechaFin = ''
			--AND (  
			-- @CodigoAgenciaAduanas = '4303'  
			-- OR @CodigoAgenciaAduanas = '6892'  
			-- OR @CodigoAgenciaAduanas = '4920'  
			-- OR @CodigoAgenciaAduanas = '2224'  
			-- OR @CodigoAgenciaAduanas = '1009'  
			-- )  
		BEGIN
			SELECT DISTINCT TOP 1 RT.retiros_n_codigo AS 'Codigo'
				,RT.retiros_v_numeroOR AS 'OrdenRetiro'
				,
				--|Agregar volante                        
				--'nrovolante'=isnull( (select top 1 cod_volante from CIT_OrdenRetiro H where left(H.Nro_orden_Retiro,6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS ) ,''),                        
				'nrovolante' = isnull(h.cod_volante, '')
				,
				--|                                
				RT.retiros_v_Placa AS 'Placa'
				,RT.retiros_v_nombre AS 'Conductor'
				,RT.retiros_v_Dni AS 'DNI'
				,RT.retiros_v_numbrevete AS 'Brevete'
				,RT.retiros_d_fecha AS 'FechaRegistro'
				,ER.estadoret_v_descripcion AS 'Estado'
				,RT.retiros_v_agenteadu AS 'AgenteAduanas'
				,RT.retiros_v_Dniagenteadu AS 'DniAgente'
				,RT.retiros_v_numop AS 'NumeroOP'
				,RT.Despachador AS 'Despachador'
				,isnull(RT.retiros_v_Celular,'') AS 'Celular'
			FROM CIT_RetiroTransportista RT WITH (NOLOCK)
			INNER JOIN CIT_EstadoRetiro ER WITH (NOLOCK) ON RT.estadoret_n_codigo = ER.estadoret_n_codigo
			LEFT JOIN CIT_OrdenRetiro H WITH (NOLOCK) ON left(H.Nro_orden_Retiro, 6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS
			WHERE isnull(RT.retiros_v_codageadu, '') = ltrim(rtrim(@CodigoAgenciaAduanas))
			ORDER BY RT.retiros_d_fecha DESC
		END
		ELSE
		BEGIN
			SELECT DISTINCT TOP 50 RT.retiros_n_codigo AS 'Codigo'
				,RT.retiros_v_numeroOR AS 'OrdenRetiro'
				,
				--|Agregar volante                        
				--'nrovolante'=isnull( (select top 1 cod_volante from CIT_OrdenRetiro H where left(H.Nro_orden_Retiro,6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS ) ,''),                        
				'nrovolante' = isnull(h.cod_volante, '')
				,
				--|                                
				RT.retiros_v_Placa AS 'Placa'
				,RT.retiros_v_nombre AS 'Conductor'
				,RT.retiros_v_Dni AS 'DNI'
				,RT.retiros_v_numbrevete AS 'Brevete'
				,RT.retiros_d_fecha AS 'FechaRegistro'
				,ER.estadoret_v_descripcion AS 'Estado'
				,RT.retiros_v_agenteadu AS 'AgenteAduanas'
				,RT.retiros_v_Dniagenteadu AS 'DniAgente'
				,RT.retiros_v_numop AS 'NumeroOP'
				,RT.Despachador AS 'Despachador'
				,isnull(RT.retiros_v_Celular,'') AS 'Celular'
			FROM CIT_RetiroTransportista RT WITH (NOLOCK)
			INNER JOIN CIT_EstadoRetiro ER WITH (NOLOCK) ON RT.estadoret_n_codigo = ER.estadoret_n_codigo
			--INNER JOIN [SP3TDA-DBSQL01].TERMINAL.dbo.DDORDRET41 O                            
			--ON RT.retiros_v_numeroOR COLLATE SQL_Latin1_General_CP1_CI_AS = O.nroord41 COLLATE SQL_Latin1_General_CP1_CI_AS                             
			--INNER JOIN [SP3TDA-DBSQL01].SEGURIDAD.dbo.SGT_Usuario U ON U.USU_CodigoInterno COLLATE SQL_Latin1_General_CP1_CI_AS = O.codage19 COLLATE SQL_Latin1_General_CP1_CI_AS                            
			LEFT JOIN CIT_OrdenRetiro H WITH (NOLOCK) ON left(H.Nro_orden_Retiro, 6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS
			WHERE isnull(RT.retiros_v_codageadu, '') = @CodigoAgenciaAduanas
				--U.USU_Codigo = @CodigoAgenciaAduanas                          
				AND (
					isnull(RT.retiros_v_numeroOR, '') LIKE (
						CASE @OrdenRetiro
							WHEN ''
								THEN '%'
							ELSE @OrdenRetiro
							END
						)
					)
				AND (
					(
						CONVERT(DATETIME, RT.retiros_d_fecha, 103) BETWEEN CONVERT(DATETIME, @FechaIni, 103)
							AND DATEadd(day, 1, CONVERT(DATETIME, @FechaFin, 103))
						)
					OR (
						@FechaIni = ''
						AND @FechaFin = ''
						)
					)
			--AND ((CONVERT(datetime, RT.retiros_d_fecha) between CONVERT(datetime,@FechaIni) and CONVERT(datetime,@FechaFin)) OR (@FechaIni ='' and @FechaFin =''))                     
			--AND RT.retiros_d_fecha >= dateadd(month,-4,getdate())                      
			ORDER BY RT.retiros_d_fecha DESC
		END
	END
	ELSE
	BEGIN
		SELECT DISTINCT TOP 50 RT.retiros_n_codigo AS 'Codigo'
			,RT.retiros_v_numeroOR AS 'OrdenRetiro'
			,
			--|Agregar volante                        
			--'nrovolante'=isnull( (select top 1 cod_volante from CIT_OrdenRetiro H where left(H.Nro_orden_Retiro,6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS ) ,''),                        
			'nrovolante' = isnull(h.cod_volante, '')
			,
			--|                                
			RT.retiros_v_Placa AS 'Placa'
			,RT.retiros_v_nombre AS 'Conductor'
			,RT.retiros_v_Dni AS 'DNI'
			,RT.retiros_v_numbrevete AS 'Brevete'
			,RT.retiros_d_fecha AS 'FechaRegistro'
			,ER.estadoret_v_descripcion AS 'Estado'
			,RT.retiros_v_agenteadu AS 'AgenteAduanas'
			,RT.retiros_v_Dniagenteadu AS 'DniAgente'
			,RT.retiros_v_numop AS 'NumeroOP'
			,RT.Despachador AS 'Despachador'
			,isnull(RT.retiros_v_Celular,'') AS 'Celular'
		FROM CIT_RetiroTransportista RT WITH (NOLOCK)
		INNER JOIN CIT_EstadoRetiro ER WITH (NOLOCK) ON RT.estadoret_n_codigo = ER.estadoret_n_codigo
		LEFT JOIN CIT_OrdenRetiro H WITH (NOLOCK) ON left(H.Nro_orden_Retiro, 6) = RT.retiros_v_numeroOR collate SQL_Latin1_General_CP1_CI_AS
		WHERE (
				isnull(RT.retiros_v_numeroOR, '') LIKE (
					CASE @OrdenRetiro
						WHEN ''
							THEN '%'
						ELSE @OrdenRetiro
						END
					)
				)
			AND (
				(
					CONVERT(DATETIME, RT.retiros_d_fecha, 103) BETWEEN CONVERT(DATETIME, @FechaIni, 103)
						AND DATEadd(day, 1, CONVERT(DATETIME, @FechaFin, 103))
					)
				OR (
					@FechaIni = ''
					AND @FechaFin = ''
					)
				)
		--AND ((CONVERT(datetime, RT.retiros_d_fecha) between CONVERT(datetime,@FechaIni) and CONVERT(datetime,@FechaFin)) OR (@FechaIni ='' and @FechaFin =''))                          
		ORDER BY RT.retiros_d_fecha DESC
	END

	SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CIT_LISTAR_CITAS_POR_TIEMPO_ATENCION]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CIT_LISTAR_CITAS_POR_TIEMPO_ATENCION] @fe_inicio AS VARCHAR(8)
	,@fe_fin AS VARCHAR(8)
AS
BEGIN
	SELECT DISTINCT CIT.Ident_Cita
		,O.Cod_Contenedor_Desp
		,CIT.Nu_OrdenRetiro_AsociaCita
		,CIT.Nu_Placa_Asociado
		,cit.Fec_Reg_Cita
		,CIT.Fec_Fac_Cita
		,CIT.Fec_Ing_Nep_Cita
		,CIT.Fec_Ing_Bal_Cita
		,CIT.Fec_Des_Cita
		,CIT.Fec_Rep_Cita
		,CIT.Fec_Ven_Cita
		,CIT.Fec_Can_Cita
		,CIT.Fec_Anu_Cita
		,EST.Des_Estado --as 'Estado_Cita'      
		--|AGREGAR NUEVAS COLUMNAS A CITAS            
		,CIT.Cod_Volante AS 'Nro. Volante'
		,W.BL AS BL
		--,Estado_Modificado = CASE       
		-- WHEN CIT.Fec_Des_Cita is not null      
		--  THEN 'DESPACHADO'      
		-- ELSE EST.Des_Estado      
		-- END      
		,W.NumeroContenedores AS 'Num. Cont'
		,W.CONSIGNATARIO AS 'Consignatario'
		,(CONVERT(VARCHAR(10), TUR.Fec_Turno, 103) + ' ' + TUR.Des_Turno) AS 'Hora Cita'
		,O.Nro_Comprobante AS 'Factura Asociada'
		,V.Age_Adu_Volante AS 'Agente de Aduanas'
		,O.Cod_Contenedor_Desp AS 'CTR Despachado'
		,USU.USU_Nombres AS 'Usuario Creador'
		,O.Nro_Placa AS 'Nro. Placa'
		,CIT.Nro_Orden_Retiro AS 'Nro.Orden de Retiro'
		,TS.ORD_CODIGO AS 'Nro. Srev. Integral'
		,CASE CIT.Cumple_Cita
			WHEN 1
				THEN 'SI'
			WHEN 0
				THEN 'No'
			ELSE ''
			END AS 'Cumple Cita'
		,'Ctr Facturado' = isnull(O.Cod_Contenedor, '')
	FROM [dbo].[CIT_Cita] CIT
	INNER JOIN [dbo].[CIT_Estado] EST ON (EST.Cod_Estado = CIT.Cod_Estado)
	INNER JOIN [dbo].[CIT_Turno] TUR ON (CIT.Ident_Turno = TUR.Ident_Turno)
	LEFT OUTER JOIN dbo.CIT_OrdenRetiro O ON (
			O.Nro_Orden_Retiro = CASE 
				WHEN CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI IS NULL
					THEN CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI
					ELSE CASE WHEN SUBSTRING(CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI,1,6) = SUBSTRING(CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI,1,6) 
							  THEN CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI
							  ELSE CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI
							  END
					END
			)
	--( CIT.[Nu_OrdenRetiro_AsociaCita] collate Latin1_General_CI_AI= O.Nro_Orden_Retiro or  CIT.[Nro_Orden_Retiro] collate Latin1_General_CI_AI= O.Nro_Orden_Retiro )              
	LEFT JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.VW_CIT_CONTENEDORE W ON W.nrosec23 = CIT.Cod_Volante
	LEFT JOIN dbo.CIT_Volante V ON CIT.Cod_Volante = V.Cod_Volante
	LEFT JOIN SGS_VISTA_USUARIO_ListarUsuario USU ON CIT.Usuario_Registro = USU.USU_Codigo COLLATE SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.DDVOLDES23 TD ON TD.NROSEC23 = CIT.Cod_Volante
	LEFT OUTER JOIN [SP3TDA-DBSQL01].TERMINAL.DBO.SSI_ORDEN TS ON ltrim(rtrim(TS.ORD_NUMDOCUMENTO)) = CIT.Cod_Volante
		AND TS.ORD_NAVVIA = TD.NAVVIA11
		AND ORD_NUMDOCUMENTO <> ''
		AND ORD_FLAGESTADO IS NULL
		AND substring(TS.ORD_CODIGO, 1, 1) = 'I'
	WHERE
		--CIT.ident_cita='14139'          
		TUR.Fec_Turno BETWEEN @fe_inicio
			AND @fe_fin
	ORDER BY CIT.Ident_Cita DESC
END

GO
/****** Object:  StoredProcedure [dbo].[USP_CIT_ObtenerCelularConDNI]    Script Date: 08/03/2019 01:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CIT_ObtenerCelularConDNI]
@NroDNI varchar(8)
as
begin
	declare @NroCelular varchar(9)
	
	select top 1 @NroCelular = isnull(retiros_v_Celular, '')
	from CIT_RetiroTransportista (nolock)
	where retiros_v_Dni = @NroDNI
	order by retiros_n_codigo desc
	
	select isnull(@NroCelular, '') as Celular
end

grant all on USP_CIT_ObtenerCelularConDNI to public
 
GO