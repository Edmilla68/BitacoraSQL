USE [BDGWC]
GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_left_align_string]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manuel Cuya Roldán
-- ALTER date: 2015-04-08
-- Description:	Funcion que prepara un dato string
--              alineado a la izquierda con "n" 
--              espacios a la izquierda
-- =============================================
ALTER FUNCTION [dbo].[usf_gwc_left_align_string](@fp_string varchar(max), @fp_espacios int) returns varchar(max) As
BEGIN

	IF @fp_string IS NULL 
		BEGIN
			RETURN REPLICATE(' ',@fp_espacios)
		END

	RETURN LEFT(RTRIM(LTRIM(@fp_string)) + REPLICATE(' ',@fp_espacios),@fp_espacios)
END 

GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_datetime]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usf_gwc_prepare_value_datetime](@sp_param datetime, @sp_tipo int) returns varchar(max) As
BEGIN
   DECLARE @fecha_convert VARCHAR(10)

	IF @sp_param IS NULL 
		BEGIN
			RETURN ''
		END

    SELECT @fecha_convert = CONVERT(VARCHAR(10),@sp_param,@sp_tipo)
	RETURN @fecha_convert
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_for_stream]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usf_gwc_prepare_value_for_stream](@sp_param varchar(max)) returns varchar(max) As
BEGIN
	IF @sp_param IS NULL 
		BEGIN
			RETURN '0000'
		END

	RETURN RIGHT('0000' + RTRIM(LTRIM(CONVERT(CHAR(4),LEN(@sp_param)))),4)+RTRIM(LTRIM(@sp_param))
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_for_stream_datetime]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[usf_gwc_prepare_value_for_stream_datetime](@sp_param datetime, @sp_tipo int) returns varchar(max) As
BEGIN
   DECLARE @fecha_convert VARCHAR(10)

	IF @sp_param IS NULL 
		BEGIN
			RETURN '0000'
		END

    SELECT @fecha_convert = LTRIM(RTRIM(convert(VARCHAR(10),@sp_param,@sp_tipo)))
	RETURN RIGHT('0000' + RTRIM(LTRIM(CONVERT(CHAR(4),LEN(@fecha_convert)))),4)+@fecha_convert
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_for_stream_decimal]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usf_gwc_prepare_value_for_stream_decimal](@sp_param decimal(12,2)) returns varchar(max) As
BEGIN
   DECLARE @decimal_convert VARCHAR(20)

	IF @sp_param IS NULL 
		BEGIN
			RETURN '0000'
		END

    SELECT @decimal_convert = convert(varchar(20),@sp_param)
	RETURN RIGHT('0000' + RTRIM(LTRIM(CONVERT(CHAR(4),LEN(@decimal_convert)))),4)+@decimal_convert
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_for_stream_int]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usf_gwc_prepare_value_for_stream_int](@sp_param int) returns varchar(max) As
BEGIN
   DECLARE @int_convert VARCHAR(20)

	IF @sp_param IS NULL 
		BEGIN
			RETURN '0000'
		END

    SELECT @int_convert = convert(varchar(20),@sp_param)
	RETURN RIGHT('0000' + RTRIM(LTRIM(CONVERT(CHAR(4),LEN(@int_convert)))),4)+@int_convert
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_prepare_value_for_stream_notrim]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usf_gwc_prepare_value_for_stream_notrim](@sp_param varchar(max)) returns varchar(max) As
BEGIN
	IF @sp_param IS NULL 
		BEGIN
			RETURN '0000'
		END

	RETURN RIGHT('0000' + RTRIM(LTRIM(CONVERT(CHAR(4),LEN(@sp_param)))),4) + @sp_param
END 


GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_right_align_int]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Manuel Cuya Roldán
-- ALTER date: 2015-04-08
-- Description:	Funcion que prepara un dato int
--              alineado a la derecha con "n" 
--              espacios a la derecha
-- =============================================
ALTER FUNCTION [dbo].[usf_gwc_right_align_int](@fp_number int, @fp_espacios int) returns varchar(max) As
BEGIN
   DECLARE @int_convert VARCHAR(20)

	IF @fp_number IS NULL 
		BEGIN
			RETURN REPLICATE(' ',@fp_espacios)
		END

    SELECT @int_convert = convert(varchar(20),@fp_number)
	RETURN RIGHT(REPLICATE(' ',@fp_espacios) + RTRIM(LTRIM(@int_convert)),@fp_espacios)
END 




GO
/****** Object:  UserDefinedFunction [dbo].[usf_gwc_right_align_pattern_padding]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Manuel Cuya Roldán
-- ALTER date: 2015-04-09
-- Description:	Funcion que prepara un dato int
--              alineado a la derecha con "n" 
--              caracteres a la derecha
-- =============================================
ALTER FUNCTION [dbo].[usf_gwc_right_align_pattern_padding](@fp_number int, @fp_espacios int, @fp_pattern char(1)) returns varchar(max) As
BEGIN
   DECLARE @int_convert VARCHAR(20)

	IF @fp_number IS NULL 
		BEGIN
			RETURN REPLICATE(' ',@fp_espacios)
		END

    SELECT @int_convert = convert(varchar(20),@fp_number)
	RETURN RIGHT(REPLICATE(@fp_pattern,@fp_espacios) + RTRIM(LTRIM(@int_convert)),@fp_espacios)
END 





GO
/****** Object:  StoredProcedure [dbo].[usp_bulk_load_gwc_padron_sunat]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_bulk_load_gwc_padron_sunat](@FILENAME NVARCHAR(256),
									@codigoret int OUTPUT, @resultado varchar(8000) OUTPUT)
AS
BEGIN
	DECLARE @BulkInsert AS NVARCHAR(1000)
	DECLARE @OutputResult TABLE(ESTADO VARCHAR(20), RUC CHAR(11));
	DECLARE @resultado_tmp varchar(1000);
	DECLARE @resultadoQ varchar(1000);

	SET @BulkInsert = N'BULK INSERT gwc_padron_ruc_sunat_tmp FROM ''' +
					@FILENAME + 
					N''' WITH( FIELDTERMINATOR = ''|'',ROWTERMINATOR = ''\n'', CODEPAGE = ''RAW'', DATAFILETYPE = ''char'')'

	BEGIN TRY
		TRUNCATE TABLE gwc_padron_ruc_sunat_tmp

		EXEC sp_executesql @BulkInsert
	END TRY
	BEGIN CATCH
		SET @codigoret = 900
		SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
		RETURN
	END CATCH

	BEGIN TRY
		--BEGIN TRAN
		MERGE gwc_padron_ruc_sunat AS T
			USING gwc_padron_ruc_sunat_tmp AS S
				ON T.RUC = S.RUC
			WHEN MATCHED THEN 
				UPDATE SET T.RZSOC = S.RZSOC,
				  T.ESTADO_SUNAT = S.ESTADO_SUNAT,
				  T.COND_DOMICILIO = S.COND_DOMICILIO,
				  T.UBIGEO = S.UBIGEO,
				  T.TIPO_VIA = S.TIPO_VIA,
				  T.NOMBRE_VIA = S.NOMBRE_VIA,
				  T.CODIGO_ZONA = S.CODIGO_ZONA,
				  T.TIPO_ZONA = S.TIPO_ZONA,
				  T.NUMERO = S.NUMERO,
				  T.INTERIOR = S.INTERIOR,
				  T.LOTE = S.LOTE,
				  T.DPTO = S.DPTO,
				  T.MANZANA = S.MANZANA,
				  T.KILOMETRO = S.KILOMETRO
			WHEN NOT MATCHED BY TARGET THEN
				INSERT (RUC, RZSOC, ESTADO_SUNAT, COND_DOMICILIO, UBIGEO, TIPO_VIA,
					NOMBRE_VIA, CODIGO_ZONA, TIPO_ZONA, NUMERO, INTERIOR,
					LOTE, DPTO, MANZANA, KILOMETRO)
				VALUES (S.RUC, S.RZSOC, S.ESTADO_SUNAT, S.COND_DOMICILIO, S.UBIGEO, S.TIPO_VIA,
					S.NOMBRE_VIA, S.CODIGO_ZONA, S.TIPO_ZONA, S.NUMERO, S.INTERIOR,S.LOTE,
					S.DPTO, S.MANZANA, S.KILOMETRO)
			OUTPUT $action, Inserted.RUC INTO @OutputResult;
		--ROLLBACK TRAN;
	END TRY
	BEGIN CATCH
		SET @codigoret = 900
		SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
		RETURN
	END CATCH

	SET @resultadoQ = '';
	SET @resultado_tmp = '';
	
	SELECT @resultado_tmp = RIGHT('0000' + (CONVERT(varchar,COUNT(ESTADO))),4) 
	FROM @OutputResult 
	WHERE ESTADO = 'INSERT'
    GROUP BY ESTADO;

	IF @@ROWCOUNT = 0 
		BEGIN
			SET @resultadoQ = '0000';
		END
	ELSE
		BEGIN
			SET @resultadoQ = @resultado_tmp;
		END

	SET @resultado_tmp = '';

	SELECT @resultadoQ = @resultadoQ  + RIGHT('0000' + (CONVERT(varchar,COUNT(ESTADO))),4) 
	FROM @OutputResult 
	WHERE ESTADO = 'UPDATE'
    GROUP BY ESTADO;

	IF @@ROWCOUNT = 0 
		BEGIN
			SET @resultadoQ = @resultadoQ + '0000';
		END
	ELSE
		BEGIN
			SET @resultadoQ = @resultadoQ + @resultado_tmp;
		END

	SET @codigoret = 0
	SET @resultado = @resultadoQ

END	




GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_backup_gwcserver_stream]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--================================================================================
-- CREAMOS EL STORED PROCEDURE
--================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_backup_gwcserver_stream](
   @NDIAS            INT,
   @CODIGORET        INT OUTPUT, 
   @RESULTADO        VARCHAR(8000) OUTPUT)
AS

SET @CODIGORET = 0;
SET @RESULTADO = '';
--================================================================================
-- BACKUP TEMPORAL TODOS LOS REGISTROS QUE TENGAN FECHA DISTINTA A LA DE HOY
--================================================================================
   BEGIN TRY
      SELECT
         *
      INTO
         #TEMPO
      FROM
         GWCSERVER_STREAM
      WHERE
         CONVERT(DATETIME,DATE_I)<>CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)   
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- SE BORRA DE LA TABLA ORIGINAL LOS REGISTROS QUE SE COPIARON EN EL BACKUP
--================================================================================
   BEGIN TRY
      DELETE
      FROM
         GWCSERVER_STREAM
      WHERE
         GWCID+SERVICENAME+TRANSACTIONAL+CONVERT(VARCHAR(20),MESSAGEID)+CONVERT(VARCHAR(20),STREAMTYPE)+CONVERT(VARCHAR(20),STREAMID)
         IN
         (SELECT GWCID+SERVICENAME+TRANSACTIONAL+CONVERT(VARCHAR(20),MESSAGEID)+CONVERT(VARCHAR(20),STREAMTYPE)+CONVERT(VARCHAR(20),STREAMID) FROM #TEMPO)
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- INSERTA EN LA TABLA HISTORICA LOS REGISTROS DEL BACKUP TEMPORAL
--================================================================================
   BEGIN TRY
      INSERT
         INTO GWCSERVER_STREAM_HISTORY
      SELECT
         *
      FROM
         #TEMPO
      WHERE 
         DATEDIFF(DAY,CONVERT(DATETIME,DATE_I),GETDATE()) BETWEEN 1 AND @NDIAS
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH

/*
-- PRUEBA
DECLARE @CODIGORET     INT 
DECLARE @RESULTADO     VARCHAR(8000)

EXECUTE usp_gwc_backup_gwcserver_stream 8,@CODIGORET OUTPUT, @RESULTADO OUTPUT
   
PRINT @CODIGORET
PRINT @RESULTADO
*/
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_backup_gwcserver_transactional]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--================================================================================
-- CREAMOS EL STORED PROCEDURE
--================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_backup_gwcserver_transactional](
   @NDIAS            INT,
   @CODIGORET        INT OUTPUT, 
   @RESULTADO        VARCHAR(8000) OUTPUT)
AS

SET @CODIGORET = 0;
SET @RESULTADO = '';
--================================================================================
-- BACKUP TEMPORAL TODOS LOS REGISTROS QUE TENGAN FECHA DISTINTA A LA DE HOY
--================================================================================
   BEGIN TRY
      SELECT
         *
      INTO
         #TEMPO
      FROM
         GWCSERVER_TRANSACTIONAL
      WHERE
         CONVERT(DATETIME,DATE_I)<>CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)   
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- SE BORRA DE LA TABLA ORIGINAL LOS REGISTROS QUE SE COPIARON EN EL BACKUP
--================================================================================
   BEGIN TRY
      DELETE
      FROM
         GWCSERVER_TRANSACTIONAL
      WHERE
         GWCID+SERVICENAME+TRANSACTIONAL+CONVERT(VARCHAR(20),MESSAGEID) IN
                  (SELECT GWCID+SERVICENAME+TRANSACTIONAL+CONVERT(VARCHAR(20),MESSAGEID) FROM #TEMPO)
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- INSERTA EN LA TABLA HISTORICA LOS REGISTROS DEL BACKUP TEMPORAL
--================================================================================
   BEGIN TRY
      INSERT
         INTO GWCSERVER_TRANSACTIONAL_HISTORY
      SELECT
         *
      FROM
         #TEMPO
      WHERE 
         DATEDIFF(DAY,CONVERT(DATETIME,DATE_I),GETDATE()) BETWEEN 1 AND @NDIAS
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH

/*
-- PRUEBA
DECLARE @CODIGORET     INT 
DECLARE @RESULTADO     VARCHAR(8000)

EXECUTE usp_gwc_backup_gwcserver_transactional 8,@CODIGORET OUTPUT, @RESULTADO OUTPUT
   
PRINT @CODIGORET
PRINT @RESULTADO
*/
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_backup_os_gwc_status_transactional]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--================================================================================
-- CREAMOS EL STORED PROCEDURE
--================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_backup_os_gwc_status_transactional](
   @NDIAS            INT,
   @CODIGORET        INT OUTPUT, 
   @RESULTADO        VARCHAR(8000) OUTPUT)
AS

SET @CODIGORET = 0;
SET @RESULTADO = '';
--================================================================================
-- BACKUP TEMPORAL TODOS LOS REGISTROS QUE TENGAN FECHA DISTINTA A LA DE HOY
--================================================================================
   BEGIN TRY
      SELECT
         *
      INTO
         #TEMPO
      FROM
         OS_GWC_STATUS_TRANSACTIONAL
      WHERE
         CONVERT(DATETIME,CONVERT(VARCHAR(10),FECGIN,103),103)<>CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)   
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- SE BORRA DE LA TABLA ORIGINAL LOS REGISTROS QUE SE COPIARON EN EL BACKUP
--================================================================================
   BEGIN TRY
      DELETE
      FROM
         OS_GWC_STATUS_TRANSACTIONAL
      WHERE
         NUMORD IN
                  (SELECT NUMORD FROM #TEMPO)
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
--================================================================================
-- INSERTA EN LA TABLA HISTORICA LOS REGISTROS DEL BACKUP TEMPORAL
--================================================================================
   BEGIN TRY
      INSERT
         INTO OS_GWC_STATUS_TRANSACTIONAL_HISTORY
      SELECT
         *
      FROM
         #TEMPO
      WHERE 
         DATEDIFF(DAY,FECGIN,GETDATE()) BETWEEN 1 AND @NDIAS
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_anula_fe_documents]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_anula_fe_documents]
(@DOCUMENTO CHAR(20), @CODIGORET INT OUTPUT, @RESULTADO VARCHAR(8000) OUTPUT)
AS
BEGIN
   SET NOCOUNT ON
   
   DECLARE @TIPO           VARCHAR(02)
   DECLARE @SERIE          VARCHAR(04)
   DECLARE @FOLIO          INT
   DECLARE @NFILAS         INT

   SET @CODIGORET          = 0
   SET @NFILAS             = 0
   
   IF LEN(LTRIM(RTRIM(@DOCUMENTO)))=0 OR @DOCUMENTO IS NULL
      BEGIN
	     SET @CODIGORET = 860
	     SET @RESULTADO = 'REVIEW_CANCELED_DOCS_NEPTUNIA53 : LA FECHA INICIAL DEL RANGO NO PUEDE SER NULA O VACÍA'
	     RETURN
      END

   
   --12345678901234567890
   --03B22100000006
   SELECT @TIPO            = SUBSTRING(@DOCUMENTO,1,2)
   SELECT @SERIE           = SUBSTRING(@DOCUMENTO,3,4)
   SELECT @FOLIO           = CONVERT(INT,SUBSTRING(@DOCUMENTO,7,LEN(RTRIM(LTRIM(@DOCUMENTO)))))
  
   BEGIN TRY
      UPDATE
         BDGWC..GWCSERVER_FE_DOCUMENTS
      SET
         ESTADOGWC    = -1,
         DATEMODIFIED = GETDATE(),
         USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC     = 0
		   AND ESTADOPPL in (1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		   AND TIPODOC   = @TIPO
         AND SERIE     = @SERIE  
         AND FOLIO     = @FOLIO  
         
      SET @NFILAS = @@ROWCOUNT
      
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
      RETURN
   END CATCH
   IF @NFILAS = 0
      BEGIN
         SET @codigoret = 999
         SET @resultado = 'NO EXISTE DOCUMENTO O NO CUMPLE CON LOS REQUISITOS PARA SER ANULADO'
      END
   ELSE
      BEGIN
         SET @resultado = 'EL DOCUMENTO HA SIDO ANULADO SATISFACTORIAMENTE'
      END
   RETURN
END

--=================================================================================
-- EJEMPLO PARA EJECUTAR EL STORED PROCEDURE
--=================================================================================
/*
DECLARE @resultado varchar(8000);
DECLARE @codresul int;

EXEC dbo.usp_gwc_cuadratura_anula_fe_documents '01F03200158508',@codresul OUTPUT, @resultado OUTPUT;

print @codresul
print @resultado;
*/
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_anula_fe_documents_paita_neptunia53]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_anula_fe_documents_paita_neptunia53]
(@DOCUMENTO CHAR(20), @CODIGORET INT OUTPUT, @RESULTADO VARCHAR(8000) OUTPUT)
AS
BEGIN
   SET NOCOUNT ON
   
   DECLARE @TIPO           VARCHAR(02)
   DECLARE @SERIE          VARCHAR(04)
   DECLARE @FOLIO          INT
   DECLARE @NFILAS         INT

   SET @CODIGORET          = 0
   SET @NFILAS             = 0
   
   IF LEN(LTRIM(RTRIM(@DOCUMENTO)))=0 OR @DOCUMENTO IS NULL
      BEGIN
	     SET @CODIGORET = 934
	     SET @RESULTADO = 'UPDATE_CANCELED_DOCS_FROM_NEPTUNIA53 : EL NUMERO DE DOCUMENTO NO PUEDE SER NULA O VACÍA'
	     RETURN
      END

   
   --12345678901234567890
   --03B22100000006
   SELECT @TIPO            = SUBSTRING(@DOCUMENTO,1,2)
   SELECT @SERIE           = SUBSTRING(@DOCUMENTO,3,4)
   SELECT @FOLIO           = CONVERT(INT,SUBSTRING(@DOCUMENTO,7,LEN(RTRIM(LTRIM(@DOCUMENTO)))))
  
   BEGIN TRY
      UPDATE
         BDGWC..GWCSERVER_FE_DOCUMENTS
      SET
         ESTADOGWC    = -1,
         DATEMODIFIED = GETDATE(),
         USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC     = 0
		   AND ESTADOPPL in (1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		   AND TIPODOC   = @TIPO
         AND SERIE     = @SERIE  
         AND FOLIO     = @FOLIO  
         
      SET @NFILAS = @@ROWCOUNT
      
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
      RETURN
   END CATCH
   IF @NFILAS = 0
      BEGIN
         SET @codigoret = 935
         SET @resultado = 'UPDATE_CANCELED_DOCS_FROM_NEPTUNIA53 : NO EXISTE DOCUMENTO O NO CUMPLE CON LOS REQUISITOS PARA SER ANULADO'
      END
   ELSE
      BEGIN
         SET @resultado = 'EL DOCUMENTO HA SIDO ANULADO SATISFACTORIAMENTE'
      END
   RETURN
END

--=================================================================================
-- EJEMPLO PARA EJECUTAR EL STORED PROCEDURE
--=================================================================================
/*
DECLARE @resultado varchar(8000);
DECLARE @codresul int;

EXEC dbo.usp_gwc_cuadratura_anula_fe_documents_paita_neptunia53 '01F03200158508',@codresul OUTPUT, @resultado OUTPUT;

print @codresul
print @resultado;
*/
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_detallado]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_detallado](
   @FECHAINI   DATETIME, @FECHAFIN   DATETIME,  @FILENAME VARCHAR(256)
)
AS

BEGIN
   IF ISDATE(@FECHAINI)=0 OR @FECHAINI IS NULL OR @FECHAINI='19000101'
      BEGIN
	     PRINT 'La fecha incial del rango puede ser nula o vacía'
	     RETURN
      END
   IF ISDATE(@FECHAFIN)=0 OR @FECHAFIN IS NULL OR @FECHAFIN='19000101'
      BEGIN
	     PRINT 'La fecha final del rango puede ser nula o vacía'
	     RETURN
      END	  
   IF LTRIM(RTRIM(@FILENAME))='' OR @FILENAME IS NULL
      BEGIN
	     PRINT 'El nombre de archivo no puede ser nulo o vacío'
	     RETURN
	  END
   DECLARE @NFILAS     INT
   DECLARE @COMANDO    VARCHAR(2048)
   DECLARE @LARGOF     SMALLINT
   
   SET     @NFILAS     = 0
   SET     @LARGOF     = 91
   
   SET NOCOUNT ON
   BEGIN TRY
      --########################################################################################
	  --     C A B E C E R A
	  --########################################################################################
	  INSERT INTO BDGWC..gwc_tmp_reporte
	  SELECT @@SPID,'NEPTUNIA S.A.' + SPACE(62) + CONVERT(CHAR(16),GETDATE(),120)

      INSERT INTO BDGWC..gwc_tmp_reporte
	  SELECT @@SPID,SPACE(35) + 'REPORTE DE CUADRATURA'

	  INSERT INTO BDGWC..gwc_tmp_reporte
	  SELECT @@SPID,SPACE(35) + 'DETALLE DE DOCUMENTOS'

      INSERT INTO BDGWC..gwc_tmp_reporte
 	  SELECT @@SPID,REPLICATE('-',@LARGOF)

	  INSERT INTO BDGWC..gwc_tmp_reporte
	  SELECT @@SPID,'TP SERIE FOLIO    FECHA      MON       AFECTO       EXENTO     IMPUESTO        TOTAL ESTADO'

      INSERT INTO BDGWC..gwc_tmp_reporte
	  SELECT @@SPID,REPLICATE('-',@LARGOF)
      --########################################################################################
      INSERT INTO BDGWC..gwc_tmp_reporte
      SELECT
         ROW_NUMBER() OVER(ORDER BY A.TIPODOC,A.FECHA,A.SERIE ASC,A.FOLIO ASC),
         LEFT(RTRIM(LTRIM(A.TIPODOC)) + REPLICATE(' ',2),2) + ' ' +
         LEFT(RTRIM(LTRIM(A.SERIE)) + REPLICATE(' ',4),4) + '  ' +
         RIGHT(REPLICATE('0',8)+RTRIM(LTRIM(CONVERT(CHAR(8),A.FOLIO))),8) + ' ' +
         LEFT(RTRIM(LTRIM(CONVERT(CHAR(10),A.FECHA,103))) + REPLICATE(' ',10),10) + ' ' +
         LEFT(RTRIM(LTRIM(A.MONEDA)) + REPLICATE(' ',3),3) + ' ' +
         RIGHT(REPLICATE(' ',10)+RTRIM(LTRIM(CONVERT(CHAR(12),A.AFECTO))),12) + ' ' +
         RIGHT(REPLICATE(' ',10)+RTRIM(LTRIM(CONVERT(CHAR(12),A.EXENTO))),12) + ' ' +
         RIGHT(REPLICATE(' ',10)+RTRIM(LTRIM(CONVERT(CHAR(12),A.IMPUESTO))),12) + ' ' +
         RIGHT(REPLICATE(' ',10)+RTRIM(LTRIM(CONVERT(CHAR(12),A.TOTAL))),12) + ' ' +
         RIGHT(REPLICATE(' ',06)+RTRIM(LTRIM(convert(char(6),A.ESTADOPPL))),6)
      FROM
         GWCSERVER_FE_DOCUMENTS A,
         GWC_CUADRATURA_ESTADOS B
      WHERE
         --A.FECHA       BETWEEN @FECHAINI AND @FECHAFIN
         CONVERT(DATETIME, CONVERT(VARCHAR(10), A.FECHA, 101))  BETWEEN @FECHAINI AND @FECHAFIN
		 AND A.ESTADOPPL = B.NUMERO
       AND B.TIPO      = 'P'
		 
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
   /*IF @NFILAS=0
      BEGIN
	     PRINT 'NO EXISTEN REGISTROS CON LOS PARAMETROS INDICADOS'
      END*/
   --########################################################################################
   --     P I E   D E   R E P O R T E
   --########################################################################################
   BEGIN TRY   
     INSERT INTO BDGWC..gwc_tmp_reporte
     SELECT @@SPID,REPLICATE('-',@LARGOF)
      END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
   begin try
     INSERT INTO BDGWC..gwc_tmp_reporte
     SELECT @@SPID,'  SE HAN LISTADO : ' + CONVERT(VARCHAR(12),@NFILAS) + ' FILAS'
	  --SELECT @@SPID,'  SE HAN LISTADO : ' + FORMAT(@NFILAS, "Fixed") + ' FILAS'
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH

   --########################################################################################
   BEGIN TRY   
   Set @Comando='Exec Master..xp_Cmdshell ''bcp "Select ContenidoFila from BDGWC..gwc_tmp_reporte" queryout ' + @FILENAME + ' -c -T''' 
   Exec(@Comando) 
      END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH

   BEGIN TRY
      TRUNCATE TABLE BDGWC..gwc_tmp_reporte
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   SET NOCOUNT OFF   
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_informe_bajas]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_informe_bajas](
   @FECHAINI  DATETIME, @FECHAFIN  DATETIME, @FILENAME  VARCHAR(256), @CODIGORET  INT OUTPUT, @RESULTADO  VARCHAR(8000) OUTPUT)
AS

BEGIN

   IF ISDATE(@FECHAINI)=0 OR @FECHAINI IS NULL OR @FECHAINI='19000101'
      BEGIN
	     SET @CODIGORET = 863
	     SET @RESULTADO = 'CANCELED REPORT :  LA FECHA INICIAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END
   IF ISDATE(@FECHAFIN)=0 OR @FECHAFIN IS NULL OR @FECHAFIN='19000101'
      BEGIN
	     SET @CODIGORET = 864
	     SET @RESULTADO = 'CANCELED REPORT :  LA FECHA FINAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END	
   IF DATEDIFF(DAY, @FECHAINI, @FECHAFIN) < 0
      BEGIN
	     SET @CODIGORET = 865
	     SET @RESULTADO = 'CANCELED REPORT : LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL'
	     RETURN
      END	  
   IF LTRIM(RTRIM(@FILENAME))='' OR @FILENAME IS NULL
      BEGIN
	     SET @CODIGORET = 866
	     SET @RESULTADO = 'CANCELED REPORT : EL NOMBRE DE ARCHIVO NO PUEDE SER NULO O VACÍO'
	     RETURN
	  
	  END
	  
   DECLARE @SEPARADOR  CHAR(1)
   DECLARE @RUC        CHAR(11)
   DECLARE @NFILAS     INT
   DECLARE @COMANDO    VARCHAR(2048) 
   
   SET     @NFILAS     = 0
   SET     @SEPARADOR  = '|'
   SET     @RUC        = '20100010217'
   SET     @CODIGORET  = 0
   
   SET NOCOUNT ON
   BEGIN TRY
      INSERT INTO BDGWC..gwc_tmp_reporte
      SELECT @@SPID,
         @RUC                                             + @SEPARADOR +
         CONVERT(CHAR(08),FECHA,112)                      + @SEPARADOR +
         TIPODOC                                          + @SEPARADOR +
         SERIE                                            + @SEPARADOR +
         CONVERT(VARCHAR(08),FOLIO)                       + @SEPARADOR +
         CONVERT(CHAR(10),GETDATE(),120)                  + @SEPARADOR +   --OJO FECHA DE GENERACION DEL INFORME ????
         'ERROR EN EMISION DEL DOCUMENTO'
      FROM
         [DBO].[GWCSERVER_FE_DOCUMENTS]
      WHERE
         ESTADOGWC = -1     -- ANULADO EN GWC
         AND ESTADOPPL IN(1,2)  -- ACEPTADO POR SUNAT Y ACEPTADO CON OBSERVACIONES
         --AND FECHAPROC BETWEEN @FECHAINI AND @FECHAFIN
         AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAPROC, 101))  BETWEEN @FECHAINI AND @FECHAFIN
         
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   --ACTUALIZA ESTADOGWC CON -2  ANULADO Y ENVIADO EN UN INFORME DE BAJAS.
   BEGIN TRY
      UPDATE
         [DBO].[GWCSERVER_FE_DOCUMENTS]
      SET
         ESTADOGWC = -2
      WHERE
         ESTADOGWC = -1     -- ANULADO EN GWC
         AND ESTADOPPL IN(1,2)  -- ACEPTADO POR SUNAT Y ACEPTADO CON OBSERVACIONES
         --AND FECHAPROC BETWEEN @FECHAINI AND @FECHAFIN
         AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAPROC, 101))  BETWEEN @FECHAINI AND @FECHAFIN
         
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   
   BEGIN TRY
      Set @Comando='Exec Master..xp_Cmdshell ''bcp "Select ContenidoFila from BDGWC..gwc_tmp_reporte" queryout ' + @FILENAME + ' -c -T''' 
      Exec(@Comando)
	  SET @resultado = 'INFORME GENERADO SATISFACTORIAMENTE'
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   BEGIN TRY
      DELETE FROM BDGWC..gwc_tmp_reporte WHERE id = @@SPID
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH

   SET NOCOUNT OFF   
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_informe_bajas_reproceso]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_informe_bajas_reproceso](
   @FECHAINI  DATETIME, @FECHAFIN  DATETIME, @FILENAME  VARCHAR(256), @CODIGORET  INT OUTPUT, @RESULTADO  VARCHAR(8000) OUTPUT)
AS

BEGIN

   IF ISDATE(@FECHAINI)=0 OR @FECHAINI IS NULL OR @FECHAINI='19000101'
      BEGIN
	     SET @CODIGORET = 863
	     SET @RESULTADO = 'CANCELED REPORT :  LA FECHA INICIAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END
   IF ISDATE(@FECHAFIN)=0 OR @FECHAFIN IS NULL OR @FECHAFIN='19000101'
      BEGIN
	     SET @CODIGORET = 864
	     SET @RESULTADO = 'CANCELED REPORT :  LA FECHA FINAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END	
   IF DATEDIFF(DAY, @FECHAINI, @FECHAFIN) < 0
      BEGIN
	     SET @CODIGORET = 865
	     SET @RESULTADO = 'CANCELED REPORT : LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL'
	     RETURN
      END	  
   IF LTRIM(RTRIM(@FILENAME))='' OR @FILENAME IS NULL
      BEGIN
	     SET @CODIGORET = 866
	     SET @RESULTADO = 'CANCELED REPORT : EL NOMBRE DE ARCHIVO NO PUEDE SER NULO O VACÍO'
	     RETURN
	  
	  END
	  
   DECLARE @SEPARADOR  CHAR(1)
   DECLARE @RUC        CHAR(11)
   DECLARE @NFILAS     INT
   DECLARE @COMANDO    VARCHAR(2048) 
   
   SET     @NFILAS     = 0
   SET     @SEPARADOR  = '|'
   SET     @RUC        = '20100010217'
   SET     @CODIGORET  = 0
   
   SET NOCOUNT ON
   BEGIN TRY
      INSERT INTO BDGWC..gwc_tmp_reporte
      SELECT @@SPID,
         @RUC                                             + @SEPARADOR +
         CONVERT(CHAR(08),FECHA,112)                      + @SEPARADOR +
         TIPODOC                                          + @SEPARADOR +
         SERIE                                            + @SEPARADOR +
         CONVERT(VARCHAR(08),FOLIO)                       + @SEPARADOR +
         CONVERT(CHAR(10),GETDATE(),120)                  + @SEPARADOR +   --OJO FECHA DE GENERACION DEL INFORME ????
         'ERROR EN EMISION DEL DOCUMENTO'
      FROM
         [DBO].[GWCSERVER_FE_DOCUMENTS]
      WHERE
         ESTADOGWC = -1
         --AND ESTADOPPL IN(1,2)  -- ACEPTADO POR SUNAT Y ACEPTADO CON OBSERVACIONES
		 and ((ESTADOPPL IN(1,2) AND SUBSTRING(SERIE,1,1)<>'B') OR (ESTADOPPL in (0,1,2) AND SUBSTRING(SERIE,1,1)='B'))
         --AND FECHAPROC BETWEEN @FECHAINI AND @FECHAFIN
         AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAPROC, 101))  BETWEEN @FECHAINI AND @FECHAFIN
      ORDER BY FECHA   
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   --ACTUALIZA ESTADOGWC CON -2  ANULADO Y ENVIADO EN UN INFORME DE BAJAS.
   /*
   BEGIN TRY
      UPDATE
         [DBO].[GWCSERVER_FE_DOCUMENTS]
      SET
         ESTADOGWC = -2
      WHERE
         ESTADOGWC = -1     -- ANULADO EN GWC
         AND ESTADOPPL IN(1,2)  -- ACEPTADO POR SUNAT Y ACEPTADO CON OBSERVACIONES
         --AND FECHAPROC BETWEEN @FECHAINI AND @FECHAFIN
         AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAPROC, 101))  BETWEEN @FECHAINI AND @FECHAFIN
         
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   */
   
   BEGIN TRY
      Set @Comando='Exec Master..xp_Cmdshell ''bcp "Select ContenidoFila from BDGWC..gwc_tmp_reporte" queryout ' + @FILENAME + ' -c -T''' 
      Exec(@Comando)
	  SET @resultado = 'INFORME GENERADO SATISFACTORIAMENTE'
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   BEGIN TRY
      DELETE FROM BDGWC..gwc_tmp_reporte WHERE id = @@SPID
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH

   SET NOCOUNT OFF   
END



-- PARA PROBAR
/*
DECLARE @FECHAINI DATETIME
DECLARE @FECHAFIN DATETIME
DECLARE @COD      INT
DECLARE @RES      VARCHAR(8000)
DECLARE @ARCHIVO  VARCHAR(100)

SET @FECHAINI = '20151214'
SET @FECHAFIN = '20151214'
SET @ARCHIVO  = 'D:\SQLSERVER\InformeBajas20151214.txt'

EXECUTE usp_gwc_cuadratura_informe_bajas_reproceso @FECHAINI, @FECHAFIN, @ARCHIVO, @COD OUTPUT, @RES OUTPUT

PRINT @COD
PRINT @RES
*/

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_reporte]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_reporte](
   @FECHAINI  DATETIME, @FECHAFIN   DATETIME, @FILENAME VARCHAR(256), @CODIGORET  INT OUTPUT, @RESULTADO  VARCHAR(8000) OUTPUT)
AS

BEGIN
   IF ISDATE(@FECHAINI)=0 OR @FECHAINI IS NULL OR @FECHAINI='19000101'
      BEGIN
	     SET @CODIGORET = 867
	     SET @RESULTADO = 'QUADRATURE REPORT :  LA FECHA INICIAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END
   IF ISDATE(@FECHAFIN)=0 OR @FECHAFIN IS NULL OR @FECHAFIN='19000101'
      BEGIN
	     SET @CODIGORET = 868
	     SET @RESULTADO = 'QUADRATURE REPORT :  LA FECHA FINAL DEL RANGO PUEDE SER NULA O VACÍA'
	     RETURN
      END	
   IF DATEDIFF(DAY, @FECHAINI, @FECHAFIN) < 0
      BEGIN
	     SET @CODIGORET = 869
	     SET @RESULTADO = 'QUADRATURE REPORT : LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL'
	     RETURN
      END	  
   IF LTRIM(RTRIM(@FILENAME))='' OR @FILENAME IS NULL
      BEGIN
	     SET @CODIGORET = 870
	     SET @RESULTADO = 'QUADRATURE REPORT : EL NOMBRE DE ARCHIVO NO PUEDE SER NULO O VACÍO'
	     RETURN
	  
	  END
	  
   DECLARE @NFILAS     INT
   DECLARE @COMANDO    VARCHAR(2048) 
   DECLARE @FNAMERES   VARCHAR(256)
   DECLARE @FNAMEDET   VARCHAR(256)
   SET     @NFILAS     = 0
   SET     @CODIGORET  = 0
   
-- DEFINE LOS NOMBRES DE ARCHIVOS : RESUMEN y DETALLE   
   SET @FNAMERES = @FILENAME + '.RESUMEN.TXT'
   SET @FNAMEDET = @FILENAME + '.DETALLE.TXT'
   SET NOCOUNT ON
   --########################################################################################
   --     LLAMA AL SP QUE GENERARA EL DETALLE : usp_gwc_cuadratura_detallado
   --########################################################################################
   BEGIN TRY
      EXECUTE usp_gwc_cuadratura_detallado @FECHAINI, @FECHAFIN,  @FNAMEDET
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
   --########################################################################################
   --     LLAMA AL SP QUE GENERARA EL DETALLE : usp_gwc_cuadratura_resumen
   --########################################################################################
   BEGIN TRY
      EXECUTE usp_gwc_cuadratura_resumen @FECHAINI, @FECHAFIN,  @FNAMERES
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
   SET @resultado = 'REPORTE GENERADO SATISFACTORIAMENTE'
   SET NOCOUNT OFF   
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_resumen]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_resumen](
   @FECHAINI   DATETIME, @FECHAFIN   DATETIME,  @FILENAME VARCHAR(256)
)
AS

BEGIN
   IF ISDATE(@FECHAINI)=0 OR @FECHAINI IS NULL OR @FECHAINI='19000101'
      BEGIN
	     PRINT 'La fecha incial del rango puede ser nula o vacía'
	     RETURN
      END
   IF ISDATE(@FECHAFIN)=0 OR @FECHAFIN IS NULL OR @FECHAFIN='19000101'
      BEGIN
	     PRINT 'La fecha final del rango puede ser nula o vacía'
	     RETURN
      END	  
   IF LTRIM(RTRIM(@FILENAME))='' OR @FILENAME IS NULL
      BEGIN
	     PRINT 'El nombre de archivo no puede ser nulo o vacío'
	     RETURN
	  END
     
   SET NOCOUNT ON
   DECLARE @NFILAS     INT
   DECLARE @COMANDO    VARCHAR(2048) 
   SET     @NFILAS     = 0
   
   BEGIN TRY
      --########################################################################################
	  --     C A B E C E R A
	  --########################################################################################
	  INSERT INTO BDGWC..gwc_tmp_reporte1
	  SELECT @@SPID,'NEPTUNIA S.A.' + SPACE(51) + CONVERT(CHAR(16),GETDATE(),120),0

      INSERT INTO BDGWC..gwc_tmp_reporte1
	  SELECT @@SPID,SPACE(30) + 'REPORTE DE CUADRATURA',0

	  INSERT INTO BDGWC..gwc_tmp_reporte1
	  SELECT @@SPID,SPACE(31) + 'RESUMEN DE ESTADOS',0

      INSERT INTO BDGWC..gwc_tmp_reporte1
 	  SELECT @@SPID,REPLICATE('-',80),0

	  INSERT INTO BDGWC..gwc_tmp_reporte1
	  SELECT @@SPID,'  DESCRIPCION'+ SPACE(48) +'CANTIDAD',0

      INSERT INTO BDGWC..gwc_tmp_reporte1
	  SELECT @@SPID,REPLICATE('-',80),0
      
   
      INSERT INTO BDGWC..gwc_tmp_reporte1
      SELECT
         @@SPID,
         '  '+
         dbo.usf_gwc_left_align_string(B.DESCRIPCIONGWC,60) + ' ' +
         dbo.usf_gwc_right_align_int(COUNT(*),6),
         B.NumeroReporteGWC
      FROM
         GWCSERVER_FE_DOCUMENTS A,
         GWC_CUADRATURA_ESTADOS B
      WHERE
         CONVERT(DATETIME, CONVERT(VARCHAR(10), A.FECHA, 101))  BETWEEN @FECHAINI AND @FECHAFIN
         --A.FECHA BETWEEN @FECHAINI AND @FECHAFIN
         AND A.ESTADOPPL = B.NUMERO
         AND B.TIPO      = 'P'
      GROUP BY
         B.DESCRIPCIONGWC,B.NumeroReporteGWC
      ORDER BY
        B.NumeroReporteGWC ASC
        
      SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
   
   -- CONTADOR TOTAL
   BEGIN TRY
      SELECT
	      @NFILAS = COUNT(*)
      FROM
         GWCSERVER_FE_DOCUMENTS A,
         GWC_CUADRATURA_ESTADOS B
      WHERE
         A.FECHA BETWEEN @FECHAINI AND @FECHAFIN
         AND A.ESTADOPPL = B.NUMERO
         AND B.TIPO      = 'P'
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
	  RETURN
   END CATCH
	  
   INSERT INTO BDGWC..gwc_tmp_reporte1
   SELECT @@SPID,REPLICATE('-',80),0

   INSERT INTO BDGWC..gwc_tmp_reporte1
      SELECT @@SPID,'  Total  : ' + SPACE(54) + CONVERT(VARCHAR(12),@NFILAS),0
   
   --Set @Comando='Exec Master..xp_Cmdshell ''bcp "Select ContenidoFila from BDGWC..gwc_tmp_reporte1" queryout "D:\SQLSERVER\ResumenEstados.txt" -c -T''' 
   Set @Comando='Exec Master..xp_Cmdshell ''bcp "Select ContenidoFila from BDGWC..gwc_tmp_reporte1" queryout ' + @FILENAME + ' -c -T''' 
   Exec(@Comando) 
   BEGIN TRY
      DELETE FROM BDGWC..gwc_tmp_reporte1 WHERE id = @@SPID
   END TRY
   BEGIN CATCH
      PRINT 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   SET NOCOUNT OFF   
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_cuadratura_revisa_anulados]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_cuadratura_revisa_anulados]
(@desde DATETIME, @hasta DATETIME, @codigoret INT OUTPUT, @resultado varchar(8000) OUTPUT)
AS
   SET NOCOUNT ON
   --set dateformat mdy
   DECLARE @MAXIMO         INT;
   
   SET     @codigoret = 0;
   
   IF ISDATE(@desde)=0 OR @desde IS NULL OR @desde='19000101'
      BEGIN
	     SET @CODIGORET = 860
	     SET @RESULTADO = 'REVIEW_CANCELED_DOCS : LA FECHA INICIAL DEL RANGO NO PUEDE SER NULA O VACÍA'
	     RETURN
      END
   IF ISDATE(@hasta)=0 OR @hasta IS NULL OR @hasta='19000101'
      BEGIN
	     SET @CODIGORET = 861
	     SET @RESULTADO = 'REVIEW_CANCELED_DOCS : LA FECHA FINAL DEL RANGO NO PUEDE SER NULA O VACÍA'
	     RETURN
      END	
   IF DATEDIFF(DAY, @desde, @hasta) < 0
      BEGIN
	     SET @CODIGORET = 862
	     SET @RESULTADO = 'REVIEW_CANCELED_DOCS : LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL'
	     RETURN
      END
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --  ACTUALIZA DOCUMENTOS EN BDGWC..BDGWC_FE_DOCUMENTS
   --  TOMA COMO BASE DOCUMENTOS ANULADOS EN TERMINAL.DBO.DCORDFAC01
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --                              O F A M   -   C A L L A O
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   BEGIN TRY
      UPDATE
         BDGWC..GWCSERVER_FE_DOCUMENTS
      SET
         ESTADOGWC    = -1,
         DATEMODIFIED = GETDATE(),
         USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC = 0
		   AND ESTADOPPL in (0,1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		   AND TIPODOC + SERIE + [dbo].[usf_gwc_right_align_pattern_padding](FOLIO,8,'0') COLLATE SQL_Latin1_General_CP1_CI_AS IN
         (SELECT
            LTRIM(RTRIM(A.TIPODOC)) +
            CASE A.TIPODOC
               WHEN '01' THEN 'F'
				WHEN '03' THEN 'B'
				WHEN '07' THEN B.PREFIXFE
            END +
				SUBSTRING(A.NUMERODOC,1,3)+
				[dbo].[usf_gwc_right_align_pattern_padding]((CONVERT(INT,SUBSTRING(A.NUMERODOC,4,7))),8,'0')
			FROM
			   TERMINAL.DBO.DCORDFAC01                    A,
			   TERMINAL.DBO.FAC_FACTURAELECTRONICA_OFAM   B
			WHERE
			   A.ID_ORDEN = B.ID_ORDEN
			   AND A.ESTADO = 'A'
            AND A.NUMERODOC IS NOT NULL
            AND A.FECHAREGISTRO BETWEEN @desde AND @hasta)  --LOCAL GBPROYECTOS
              --AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAREGISTRO, 103))  BETWEEN @desde AND @hasta) --NEPTUNIA
				
      SET @resultado = 'PROCESO CONCLUIDO SATISFACTORIAMENTE!!!'
   END TRY
   BEGIN CATCH
      SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
      RETURN
   END CATCH

   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --  ACTUALIZA DOCUMENTOS EN BDGWC..BDGWC_FE_DOCUMENTS
   --  TOMA COMO BASE DOCUMENTOS ANULADOS EN NEPTUNIAP1.TERMINAL.DBO.DCORDFAC01
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --                       O F A M   -   P A I T A   -   M A T A R A N I
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --BEGIN TRY
   --   UPDATE
   --      BDGWC..GWCSERVER_FE_DOCUMENTS
   --   SET
   --      ESTADOGWC    = -1,
   --      DATEMODIFIED = GETDATE(),
   --      USERMODIFIED = USER_NAME()
   --   WHERE
   --      ESTADOGWC = 0
		 --  AND ESTADOPPL in (0,1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		 --  AND TIPODOC + SERIE + [dbo].[usf_gwc_right_align_pattern_padding](FOLIO,8,'0') COLLATE SQL_Latin1_General_CP1_CI_AS IN
   --      (SELECT
   --         LTRIM(RTRIM(TIPODOC)) +
   --         CASE TIPODOC
   --            WHEN '01' THEN 'F'
			--		WHEN '03' THEN 'B'
   --         END +
			--	SUBSTRING(NUMERODOC,1,3)+
			--	[dbo].[usf_gwc_right_align_pattern_padding]((CONVERT(INT,SUBSTRING(NUMERODOC,4,7))),8,'0')
			--FROM
			--   NEPTUNIAP1.TERMINAL.DBO.DCORDFAC01
			--WHERE
			--   ESTADO = 'A'
   --         AND NUMERODOC IS NOT NULL
   --         AND FECHAREGISTRO BETWEEN @desde AND @hasta)  --LOCAL GBPROYECTOS
   --           --AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECHAREGISTRO, 103))  BETWEEN @desde AND @hasta) --NEPTUNIA
				
   --   SET @resultado = 'PROCESO CONCLUIDO SATISFACTORIAMENTE!!!'
   --END TRY
   --BEGIN CATCH
   --   SET @codigoret = 900
   --   SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   --   RETURN
   --END CATCH
   
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --  ACTUALIZA DOCUMENTOS EN BDGWC..BDGWC_FE_DOCUMENTS
   --  TOMA COMO BASE DOCUMENTOS ANULADOS EN DEPOSITOS..DDCABCOM52
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   BEGIN TRY
      UPDATE
	     BDGWC..GWCSERVER_FE_DOCUMENTS
	  SET
	     ESTADOGWC = -1,
		 DATEMODIFIED = GETDATE(),
		 USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC = 0
         AND ESTADOPPL in (0,1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		 AND TIPODOC + SERIE + [dbo].[usf_gwc_right_align_pattern_padding](FOLIO,8,'0') COLLATE SQL_Latin1_General_CP1_CI_AS IN
		    (SELECT
			    LTRIM(RTRIM(CODCOM50)) +
				CASE CODCOM50
				             WHEN '01' THEN 'F'
							 WHEN '03' THEN 'B'
				          END +
				SUBSTRING(NUMCOM52,1,3)+
				[dbo].[usf_gwc_right_align_pattern_padding]((CONVERT(INT,SUBSTRING(NUMCOM52,4,7))),8,'0')
			 FROM
			    DEPOSITOS.DBO.DDCABCOM52
			 WHERE
			    FLGVAL52 = 0
             --AND CONVERT(DATETIME, CONVERT(VARCHAR(10), FECUSU52, 101))  BETWEEN @desde AND @hasta)
             AND FECUSU52 BETWEEN @desde AND @hasta)
			
      SET @resultado = 'PROCESO CONCLUIDO SATISFACTORIAMENTE!!!'
	  
   END TRY
   BEGIN CATCH
	   SET @codigoret = 900
      SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
      RETURN
   END CATCH
   
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   -- ACTUALIZA DOCUMENTOS EN BDGWC..BDGWC_FE_DOCUMENTS
   -- TOMA COMO BASE DOCUMENTOS ANULADOS EN CALW3BDSGC.NEPTUNIA_SGC_PRODUCCION.DBO.FAC_DOCUMENTO
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --                             G E S F O R   -   C A L L A O
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   BEGIN TRY
      UPDATE
	     BDGWC..GWCSERVER_FE_DOCUMENTS
	  SET
	     ESTADOGWC = -1,
		 DATEMODIFIED = GETDATE(),
		 USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC = 0
		   --AND ESTADOPPL in (1,2)    -- SOLAMENTE LOS ACEPTADOS Y ACEPTADO CON OBSERVACIONES (SUNAT)
         AND ESTADOPPL in (0,1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		 AND TIPODOC + SERIE + [dbo].[usf_gwc_right_align_pattern_padding](FOLIO,8,'0') COLLATE SQL_Latin1_General_CP1_CI_AS IN
		    (SELECT
                CASE b.Ident_TipoDocumento
                   WHEN 1 THEN '03'
		           WHEN 2 THEN '01'
		           WHEN 3 THEN '07'
		           WHEN 4 THEN '08'
                   ELSE ''
                END +
                CASE b.Ident_TipoDocumento
	               WHEN 1 THEN 'B'
		           WHEN 2 THEN 'F'
                   ELSE 'X'
                END + [dbo].[usf_gwc_right_align_pattern_padding](b.numero,3,'0') +
                [dbo].[usf_gwc_right_align_pattern_padding](a.numero,8,'0')
			 FROM
			     NEPTUNIA_SGC_PRODUCCION.DBO.FAC_DOCUMENTO A,
				 NEPTUNIA_SGC_PRODUCCION.DBO.FAC_SERIE B
			 WHERE
			    A.I023_ESTADO = 73
				AND A.IDENT_SERIE = B.IDENT_SERIE
              AND A.EMISION BETWEEN @desde AND @hasta)
              --AND CONVERT(DATETIME, CONVERT(VARCHAR(10), A.EMISION, 101))  BETWEEN @desde AND @hasta)
				
      SET @resultado = 'PROCESO CONCLUIDO SATISFACTORIAMENTE!!!'
	  
   END TRY
   BEGIN CATCH
	   SET @codigoret = 900
       SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
       RETURN
   END CATCH

   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   -- ACTUALIZA DOCUMENTOS EN BDGWC..BDGWC_FE_DOCUMENTS
   -- TOMA COMO BASE DOCUMENTOS ANULADOS EN CALW3BDSGC.NEPTUNIA_SGC.DBO.FAC_DOCUMENTO
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --                       G E S F O R   -   P A I T A   -   M A T A R A N I
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   BEGIN TRY
      UPDATE
	     BDGWC..GWCSERVER_FE_DOCUMENTS
	  SET
	     ESTADOGWC = -1,
		 DATEMODIFIED = GETDATE(),
		 USERMODIFIED = USER_NAME()
      WHERE
         ESTADOGWC = 0
		   --AND ESTADOPPL in (1,2)    -- SOLAMENTE LOS ACEPTADOS Y ACEPTADO CON OBSERVACIONES (SUNAT)
         AND ESTADOPPL in (0,1,2,3)  -- ACEPTADOS, ACEPTADO CON OBSERVACIONES Y RECHAZADO (SUNAT) 18-06-2015
		 AND TIPODOC + SERIE + [dbo].[usf_gwc_right_align_pattern_padding](FOLIO,8,'0') IN
		    (SELECT
                CASE b.Ident_TipoDocumento
                   WHEN 1 THEN '03'
		           WHEN 2 THEN '01'
		           WHEN 3 THEN '07'
		           WHEN 4 THEN '08'
                   ELSE ''
                END +
                CASE b.Ident_TipoDocumento
	               WHEN 1 THEN 'B'
		           WHEN 2 THEN 'F'
                   ELSE 'X'
                END + [dbo].[usf_gwc_right_align_pattern_padding](b.numero,3,'0') +
                [dbo].[usf_gwc_right_align_pattern_padding](a.numero,8,'0')
			 FROM
			    NEPTUNIA_SGC.DBO.FAC_DOCUMENTO A,
				 NEPTUNIA_SGC.DBO.FAC_SERIE B
			 WHERE
			    A.I023_ESTADO = 73
				AND A.IDENT_SERIE = B.IDENT_SERIE
              AND A.EMISION BETWEEN @desde AND @hasta)
              --AND CONVERT(DATETIME, CONVERT(VARCHAR(10), A.EMISION, 101))  BETWEEN @desde AND @hasta)
				
      SET @resultado = 'PROCESO CONCLUIDO SATISFACTORIAMENTE!!!'
	  
   END TRY
   BEGIN CATCH
	   SET @codigoret = 900
       SET @resultado = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
       RETURN
   END CATCH
   
   RETURN
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_insert_fe_documents]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_insert_fe_documents](
   @LINEAC      VARCHAR(250), @DETALLE    VARCHAR(8000), 
   @STATUS_GWC  INT,          @STATUS_PPL VARCHAR(5),     @PDF417   VARCHAR(1000), 
   @CODIGORET  INT OUTPUT,    @RESULTADO  VARCHAR(500) OUTPUT)
AS
   SET NOCOUNT ON;
   DECLARE @TPDOCRECEP   CHAR(02)
   DECLARE @NODOCRECEP   VARCHAR(15)
   DECLARE @LOCALCODE    CHAR(02)
   DECLARE @USUARIO      VARCHAR(20)
   DECLARE @TIPODOC      CHAR(02)
   DECLARE @SERIE        CHAR(04)
   DECLARE @FOLIO        INT
   DECLARE @FECHA        DATETIME
   DECLARE @MONEDA       CHAR(03)
   DECLARE @AFECTO       DECIMAL(12,2)
   DECLARE @EXENTO       DECIMAL(12,2)
   DECLARE @IMPUESTO     DECIMAL(12,2)
   DECLARE @TOTAL        DECIMAL(12,2)
   DECLARE @ESTADOGWC    SMALLINT
   DECLARE @ESTADOPPL    SMALLINT
   DECLARE @LARGOCAD    INT
   
   DECLARE @POSINI       SMALLINT
   DECLARE @POSFIN       SMALLINT
   DECLARE @QTYCAR       SMALLINT
   DECLARE @NFILAS       SMALLINT
   
   SET     @CODIGORET    = 0;
   SET     @LARGOCAD     = 0;
   
   SET     @LARGOCAD     = LEN(ISNULL(@LINEAC,''))

   IF @LINEAC IS NULL OR @LARGOCAD = 0
      BEGIN
	     SET @CODIGORET = 872
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA LONGITUD DEL CAMPO NO ES VALIDA -> @LINEAC'
	     RETURN
	  END
   
-- DECODIFICACION LINEA CUADRATURA
   SET @POSINI      = 1
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   /*PRINT 'INI ' + convert(char(10),isnull(@POSINI,'NULO'))
   PRINT 'FIN ' + convert(char(10),isnull(@POSFIN,'NULO'))
   PRINT 'QTY ' + convert(char(10),isnull(@QTYCAR,'NULO'))
   return*/
   IF @QTYCAR < 0
      BEGIN
	     SET @CODIGORET = 874
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA CANTIDAD DE CARACTERES A EXTRAER NO ES VALIDA'
	     RETURN
	  END
   SET @TPDOCRECEP  = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)
   
   --==============================================================================
   -- VALIDANDO TIPO DE DOCUMENTO IDENTIDAD
   --==============================================================================
   SET @NFILAS = 0
   BEGIN TRY
      EXEC USP_GWC_TABLE_VALIDATION 'gwc_tipo_doc_identidad','codigo',@TPDOCRECEP,@NFILAS OUTPUT
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
	  SET @RESULTADO = 'OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
	  RETURN
   END CATCH
   PRINT @NFILAS
   IF @NFILAS <= 0
      BEGIN
         SET @CODIGORET = 871
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: EL VALOR DEL CAMPO INGRESADO NO ES VALIDO -> TPDOCRECEP'
	     RETURN
	  END

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @NODOCRECEP  = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @LOCALCODE   = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)
 
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @USUARIO     = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)
   
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @TIPODOC     = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)

   --==============================================================================
   -- VALIDANDO TIPO DE DOCUMENTO IDENTIDAD
   --==============================================================================
   SET @NFILAS = 0
   BEGIN TRY
      EXEC USP_GWC_TABLE_VALIDATION 'gwc_tipo_documento_sunat','codigo',@TIPODOC,@NFILAS OUTPUT
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
	  SET @RESULTADO = 'OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
	  RETURN
   END CATCH
   PRINT @NFILAS
   IF @NFILAS <= 0
      BEGIN
         SET @CODIGORET = 871
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: EL VALOR DEL CAMPO INGRESADO NO ES VALIDO -> TIPODOC'
	     RETURN
	  END
  
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @SERIE       = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @FOLIO       = CONVERT(INT,SUBSTRING(@LINEAC,@POSINI,@QTYCAR))

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @FECHA       = CONVERT(DATETIME,SUBSTRING(@LINEAC,@POSINI,@QTYCAR))   

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @MONEDA      = SUBSTRING(@LINEAC,@POSINI,@QTYCAR)

   --==============================================================================
   -- VALIDANDO LA MONEDA
   --==============================================================================
   SET @NFILAS = 0
   BEGIN TRY
      EXEC USP_GWC_TABLE_VALIDATION 'gwc_tipo_moneda','codigo',@MONEDA,@NFILAS OUTPUT
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
	  SET @RESULTADO = 'OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
	  RETURN
   END CATCH
   PRINT @NFILAS
   IF @NFILAS <= 0
      BEGIN
         SET @CODIGORET = 871
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: EL VALOR DEL CAMPO INGRESADO NO ES VALIDO -> MONEDA'
	     RETURN
	  END
	  
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @AFECTO      = CONVERT(DECIMAL(12,2),SUBSTRING(@LINEAC,@POSINI,@QTYCAR))  / 100

   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @EXENTO      = CONVERT(DECIMAL(12,2),SUBSTRING(@LINEAC,@POSINI,@QTYCAR))  / 100
   
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @IMPUESTO    = CONVERT(DECIMAL(12,2),SUBSTRING(@LINEAC,@POSINI,@QTYCAR))  / 100
   
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @TOTAL       = CONVERT(DECIMAL(12,2),SUBSTRING(@LINEAC,@POSINI,@QTYCAR))  / 100
   
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = CHARINDEX('|',@LINEAC,@POSINI)
   SET @QTYCAR      = @POSFIN - @POSINI
   SET @ESTADOGWC   = CONVERT(SMALLINT,SUBSTRING(@LINEAC,@POSINI,@QTYCAR))
   
   SET @POSINI      = @POSFIN + 1
   IF @POSINI > @LARGOCAD
      BEGIN
	     SET @CODIGORET = 873
	     SET @RESULTADO = 'WS_GWCSERVER_ERROR_INSERT_DOCUMENT: LA POSICION INICIAL PARA LA EXTRACCION ES MAYOR A LA LONGITUD DE LA CADENA'
	     RETURN
	  END
   SET @POSFIN      = LEN(@LINEAC)
   SET @QTYCAR      = @POSFIN - @POSINI
   --SET @ESTADOPPL   = CONVERT(SMALLINT,SUBSTRING(@LINEAC,@POSINI,@QTYCAR))

   IF ISNUMERIC(@STATUS_PPL) <> 1
    BEGIN
    SET @ESTADOPPL   = -99    --NO SE PUEDE DECODIFICAR STATUS
  END
  ELSE
    BEGIN
    SET @ESTADOPPL   = CONVERT(SMALLINT,@STATUS_PPL)
  END

   
  BEGIN TRY
    BEGIN TRAN 
    INSERT INTO GWCSERVER_FE_DOCUMENTS
      (TPDOCRECEP, NODOCRECEP, LOCALCODE, USUARIO,   TIPODOC, SERIE,
       FOLIO,      FECHA,      MONEDA,    AFECTO,    EXENTO,  IMPUESTO,
       TOTAL,      FECHAPROC,  ESTADOGWC, ESTADOPPL, DETALLE, PDF417,
	   USERMODIFIED, DATEMODIFIED)
	  VALUES
      (@TPDOCRECEP, @NODOCRECEP, @LOCALCODE, @USUARIO,   @TIPODOC, @SERIE,
       @FOLIO,      @FECHA,      @MONEDA,    @AFECTO,    @EXENTO,  @IMPUESTO,
       @TOTAL,      GETDATE(),   @STATUS_GWC, @ESTADOPPL, @DETALLE, @PDF417,
	     USER_NAME(), GETDATE())
    COMMIT
	  SET @RESULTADO='EL DOCUMENTO SE REGISTRÓ CORRECTAMENTE'
	  SET NOCOUNT OFF
  END TRY
   
  BEGIN CATCH
      ROLLBACK
      SET @CODIGORET = 900
      SET @RESULTADO='OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
  END CATCH

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_insert_program_execution_control]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_gwc_insert_program_execution_control]
(
   @Machine             VARCHAR(20),
	@ProgramName         VARCHAR(30),
	@Version             VARCHAR(20),
	@LastExecutionDate   VARCHAR(19),
	@UserName            VARCHAR(30),
	@Optional01          VARCHAR(50),
	@Optional02          VARCHAR(50),
	@RESULTADO           INT             OUTPUT,
	@MENSAJE             VARCHAR(300)    OUTPUT
)
AS
   DECLARE @NFILAS               INT
   DECLARE @LastExecutionDateD   DATETIME

   SET @NFILAS          = 0
   SET @RESULTADO       = 0
   SET @MENSAJE         = ''
   
   SELECT @LastExecutionDateD = CONVERT(DATETIME,@LastExecutionDate)
   
   BEGIN TRY
      SELECT
         @NFILAS = COUNT(*)
      FROM
         GWCSERVER_PROGRAM_EXECUTION_CONTROL
      WHERE
         Machine         = @Machine
         AND ProgramName = @ProgramName
   END TRY
   BEGIN CATCH
      SET @RESULTADO = 900
      SET @MENSAJE   = 'SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()   
      RETURN
   END CATCH
   
   IF @NFILAS > 0
   BEGIN    --ACTUALIZA
      BEGIN TRY
         BEGIN TRAN 
         UPDATE GWCSERVER_PROGRAM_EXECUTION_CONTROL
            SET
               Version           = @Version,          
               LastExecutionDate = @LastExecutionDateD,
               UserName          = @UserName,         
               Optional01        = @Optional01,       
               Optional02        = @Optional02       
         WHERE 
            Machine         = @Machine
            AND ProgramName = @ProgramName
         COMMIT
         
         SET @RESULTADO=0
         
      END TRY
      BEGIN CATCH
         ROLLBACK
         SET @RESULTADO = 900
         SET @MENSAJE   = 'SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()   
         RETURN
      END CATCH
      SET @MENSAJE = 'DOCUMENTO ACTUALIZADO SATISFACTORIAMENTE'
   END
   ELSE
   BEGIN
      BEGIN TRY
         BEGIN TRAN 
         INSERT INTO [GWCSERVER_PROGRAM_EXECUTION_CONTROL]
         VALUES(
                  @Machine          ,
                  @ProgramName      ,
                  @Version          ,
                  @LastExecutionDateD,
                  @UserName         ,
                  @Optional01       ,
                  @Optional02       
	            )
         COMMIT
         SET @RESULTADO=0
      END TRY
      BEGIN CATCH
         ROLLBACK
         SET @RESULTADO = 900
         SET @MENSAJE   = 'SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()   
         RETURN
      END CATCH
      SET @MENSAJE = 'DOCUMENTO INSERTADO SATISFACTORIAMENTE'
   END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_os_addtoqueue]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_gwc_os_addtoqueue](
@NUMORD        VARCHAR(15),
@RESULT        INT OUTPUT,
@RESULTSZ      VARCHAR(200) OUTPUT
)
AS 
BEGIN
  DECLARE @ROW_COUNT    INT
  DECLARE @ACTSTAT      INT
  DECLARE @DATEWMS      DATETIME

  SET @RESULT = -1
  SET @RESULTSZ = ''
  
  SET @NUMORD = LTRIM(RTRIM(@NUMORD))

  --VALIDACIONES NUMORD
  
  
  BEGIN TRY
    SELECT @ACTSTAT = ACTSTAT,
           @DATEWMS = LRUPDT
    FROM OS_GWC_STATUS_TRANSACTIONAL
    WHERE NUMORD = @NUMORD

    SET @ROW_COUNT = @@ROWCOUNT

    IF @ROW_COUNT = 0 
      BEGIN
      INSERT INTO OS_GWC_STATUS_TRANSACTIONAL(NUMORD,ACTSTAT)
      VALUES(@NUMORD,'0')

      SET @ACTSTAT = 0
    END
    ELSE
      BEGIN
        IF @ACTSTAT = 7 OR
           @ACTSTAT = 8 OR
           @ACTSTAT = 9 OR
           @ACTSTAT = 10 OR
           @ACTSTAT = 11 
          BEGIN
          IF DATEDIFF(minute,@DATEWMS,GETDATE()) < 1
            SET @ACTSTAT = 99
        END
    END

    SET @RESULT = @ACTSTAT
    SET @RESULTSZ = ''
  END TRY    
  BEGIN CATCH    
    SET @RESULT = -1
    SET @RESULTSZ = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()    
  END CATCH    

END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_os_readstatusdata]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_gwc_os_readstatusdata](
@NUMORD        VARCHAR(15),
@RESULT        INT OUTPUT,
@RESULTSZ      VARCHAR(8000) OUTPUT
)
AS 
BEGIN
  DECLARE @CABECERA     VARCHAR(300)
  DECLARE @NCAMPOS      SMALLINT

  DECLARE @ROW_COUNT    INT
  DECLARE @NOMAGE       VARCHAR(50)
  DECLARE @NOMTRA       VARCHAR(50)
  DECLARE @CODPLA       VARCHAR(10)
  DECLARE @QCANTID      INT
  DECLARE @QPESO        DECIMAL(15,5)
  DECLARE @CODALM       VARCHAR(15)
  DECLARE @STSGIN       VARCHAR(1)
  DECLARE @FECGIN       DATETIME
  DECLARE @STSBLZ       VARCHAR(1)
  DECLARE @FECBLZ       DATETIME
  DECLARE @STSCRE       VARCHAR(1)
  DECLARE @FECCRE       DATETIME
  DECLARE @STSASI       VARCHAR(1)
  DECLARE @FECASI       DATETIME
  DECLARE @STSLZD       VARCHAR(1)
  DECLARE @FECLZD       DATETIME
  DECLARE @STSEPR       VARCHAR(1)
  DECLARE @FECEPR       DATETIME
  DECLARE @STSPRE       VARCHAR(1)
  DECLARE @FECPRE       DATETIME
  DECLARE @STSPES       VARCHAR(1)
  DECLARE @FECPES       DATETIME
  DECLARE @STSEXP       VARCHAR(1)
  DECLARE @FECEXP       DATETIME
  DECLARE @STSGSL       VARCHAR(1)
  DECLARE @FECGSL       DATETIME
  DECLARE @PUERTA       NVARCHAR(30)
  DECLARE @TURNOA       NVARCHAR(30)
  DECLARE @DSPPAR       VARCHAR(1)
  DECLARE @FECPAR       DATETIME
  DECLARE @DSPTOT       VARCHAR(1)
	DECLARE @FECTOT       DATETIME

	  DECLARE @STSPSL       VARCHAR(1)
  DECLARE @FECPSL       DATETIME

  SET @RESULT = -1
  SET @RESULTSZ = ''
  
  SET @NUMORD = LTRIM(RTRIM(@NUMORD))

  BEGIN TRY
    SELECT 
      @NOMAGE = NOMAGE,
      @NOMTRA = NOMTRA,
      @CODPLA = CODPLA,
      @QCANTID = QCANTID,
      @QPESO = QPESO,
      @CODALM = CODALM,
      @STSGIN = STSGIN,
      @FECGIN = FECGIN,
      @STSBLZ = STSBLZ,
      @FECBLZ = FECBLZ,
      @STSCRE = STSCRE,
      @FECCRE = FECCRE,
      @STSASI = STSASI,
      @FECASI = FECASI,
      @STSLZD = STSLZD,
      @FECLZD = FECLZD,
      @STSEPR = STSEPR,
      @FECEPR = FECEPR,
      @STSPRE = STSPRE,
      @FECPRE = FECPRE,
      @STSPES = STSPES,
      @FECPES = FECPES,
      @STSEXP = STSEXP,
      @FECEXP = FECEXP,
      @STSGSL = STSGSL,
      @FECGSL = FECGSL,
      @PUERTA = PUERTA,
      @TURNOA = TURNOA,
      @DSPPAR = DSPPAR,
      @FECPAR = FECPAR,
      @DSPTOT = DSPTOT,
	    @FECTOT = FECTOT,
		@STSPSL=STSGSL,
		@FECGSL=FECGSL
    FROM OS_GWC_STATUS_TRANSACTIONAL
    WHERE NUMORD = @NUMORD

    SET @ROW_COUNT = @@ROWCOUNT

    IF @ROW_COUNT = 0 
      RETURN
    
    SET @RESULT = 0

    SET @NCAMPOS  = 33
    SET @CABECERA = RIGHT('0000' + CONVERT(VARCHAR(4),@NCAMPOS),4) + REPLICATE('LLLL',@NCAMPOS)

    SET @RESULTSZ = ''
    SET @RESULTSZ = @RESULTSZ + @CABECERA + '0001'
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@NUMORD)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@NOMAGE)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@NOMTRA)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@CODPLA)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(20),@QCANTID))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(20),@QPESO))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@CODALM)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSGIN)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECGIN,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSBLZ)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECBLZ,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSCRE)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECCRE,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSASI)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECASI,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSLZD)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECLZD,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSEPR)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECEPR,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSPRE)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECPRE,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSPES)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECPES,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSEXP)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECEXP,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSGSL)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECGSL,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@PUERTA)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@TURNOA)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@DSPPAR)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECPAR,'dd/MM/yyyy HH:mm')))
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@DSPTOT)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECTOT,'dd/MM/yyyy HH:mm')))
        SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(@STSPSL)
    SET @RESULTSZ = @RESULTSZ + dbo.usf_gwc_prepare_value_for_stream(CONVERT(VARCHAR(50), FORMAT(@FECPSL,'dd/MM/yyyy HH:mm')))


  END TRY    
  BEGIN CATCH    
    SET @RESULT = -1
    SET @RESULTSZ = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()    
  END CATCH    

END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_os_savedata]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_gwc_os_savedata](
@NUMORD        VARCHAR(15),
@NOMAGE       VARCHAR(50),
@NOMTRA       VARCHAR(50),
@CODPLA       VARCHAR(10),
@QCANTID      INT,
@QPESO        DECIMAL(15,5),
@CODALM       VARCHAR(15),
@ACTSTAT       INT,
@RESULT        INT OUTPUT,
@RESULTSZ      VARCHAR(8000) OUTPUT
)
AS 
BEGIN
  
  SET @RESULT = -1
  SET @RESULTSZ = ''
  
  SET @NUMORD = LTRIM(RTRIM(@NUMORD))

  BEGIN TRY
    UPDATE OS_GWC_STATUS_TRANSACTIONAL
    SET 
      NOMAGE = @NOMAGE,
      NOMTRA = @NOMTRA,
      CODPLA = @CODPLA,
      QCANTID = @QCANTID,
      QPESO = @QPESO,
      CODALM = @CODALM,
      ACTSTAT = @ACTSTAT
    WHERE NUMORD = @NUMORD

    SET @RESULT = 0

  END TRY    
  BEGIN CATCH    
    SET @RESULT = -1
    SET @RESULTSZ = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()    
  END CATCH    

END


GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_os_updatedata]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_gwc_os_updatedata](
@NUMORD        VARCHAR(15),
@ACTSTAT       INT,
@STSGIN        VARCHAR(1),
@FECGIN        DATETIME,
@STSBLZ        VARCHAR(1),
@FECBLZ        DATETIME,
@STSCRE        VARCHAR(1),
@FECCRE        DATETIME,
@STSASI        VARCHAR(1),
@FECASI        DATETIME,
@STSLZD        VARCHAR(1),
@FECLZD        DATETIME,
@STSEPR        VARCHAR(1),
@FECEPR        DATETIME,
@STSPRE        VARCHAR(1),
@FECPRE        DATETIME,
@STSPES        VARCHAR(1),
@FECPES        DATETIME,
@STSEXP        VARCHAR(1),
@FECEXP        DATETIME,
@STSGSL        VARCHAR(1),
@FECGSL        DATETIME,
@PUERTA        NVARCHAR(30),
@TURNOA        NVARCHAR(30),
@DSPPAR        VARCHAR(1),
@FECPAR        DATETIME,
@DSPTOT        VARCHAR(1),
@FECTOT        DATETIME,
@RESULT        INT OUTPUT,
@RESULTSZ      VARCHAR(8000) OUTPUT
)
AS 
BEGIN
  
  SET @RESULT = -1
  SET @RESULTSZ = ''
  
  SET @NUMORD = LTRIM(RTRIM(@NUMORD))

  BEGIN TRY
    IF @ACTSTAT <= 5
      BEGIN
      SET @RESULT = 0
      SET @RESULTSZ = ''
      RETURN
    END

    IF @ACTSTAT = 6  --OSSTATUS_GARITA 5
       BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSGIN = @STSGIN,
            FECGIN = @FECGIN,
            PUERTA = @PUERTA,
            TURNOA = @TURNOA,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 7      --OSSTATUS_BALANZA 6
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSBLZ = @STSBLZ,
            FECBLZ = @FECBLZ,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 8 OR   --OSSTATUS_CREADO 7
            @ACTSTAT = 9 OR   --OSSTATUS_ASIGNADO 8
            @ACTSTAT = 10 OR   --OSSTATUS_LANZADO 9
            @ACTSTAT = 11 OR  --OSSTATUS_PREPARACION 10
            @ACTSTAT = 12     --OSSTATUS_PREPARADO 11
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSCRE = @STSCRE,
            FECCRE = @FECCRE,
            STSASI = @STSASI,
            FECASI = @FECASI,
            STSLZD = @STSLZD,
            FECLZD = @FECLZD,
            STSEPR = @STSEPR,
            FECEPR = @FECEPR,
            STSPRE = @STSPRE,
            FECPRE = @FECPRE,
            ACTSTAT = @ACTSTAT,
            LRUPDT = GETDATE()
          WHERE NUMORD = @NUMORD

    END 
    ELSE IF @ACTSTAT = 13      --OSSTATUS_PESANDO 12
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSPES = @STSPES,
            FECPES = @FECPES,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 14      --OSSTATUS_PESADO 13
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSPES = @STSPES,
            FECPES = @FECPES,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 15      --OSSTATUS_EXPEDIDO 14
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSPES = @STSPES,
            FECPES = @FECPES,
            STSEXP = @STSEXP,
            FECEXP = @FECEXP,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 16        --OSSTATUS_DESPACHOPARCIAL 15
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            PUERTA = @PUERTA,
            TURNOA = @TURNOA,
            DSPPAR = @DSPPAR,
            FECPAR = @FECPAR,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 17        --OSSTATUS_DESPACHOTOTAL 16
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            PUERTA = @PUERTA,
            TURNOA = @TURNOA,
            DSPTOT = @DSPTOT,
            FECTOT = @FECTOT,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 
    ELSE IF @ACTSTAT = 100  -- OSSTATUS_SALIDA 17
      BEGIN
        UPDATE OS_GWC_STATUS_TRANSACTIONAL
          SET 
            STSGSL = @STSGSL,
            FECGSL = @FECGSL,
            ACTSTAT = @ACTSTAT
          WHERE NUMORD = @NUMORD
    END 

    
    SET @RESULT = 0

  END TRY    
  BEGIN CATCH    
    SET @RESULT = -1
    SET @RESULTSZ = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()    
  END CATCH    

END


GO
/****** Object:  StoredProcedure [dbo].[USP_GWC_TABLE_VALIDATION]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[USP_GWC_TABLE_VALIDATION]
(@TABLA VARCHAR(100), @CAMPOCLAVE VARCHAR(100), @VALOR VARCHAR(200), @ENCONTRADO SMALLINT OUTPUT)
AS

BEGIN
   SET NOCOUNT ON
   DECLARE @SQL NVARCHAR(1000), @PARAMDEFINITION NVARCHAR(255), @PARAMVALUE CHAR(3)
   DECLARE @NFILAS INT
   
   SET @ENCONTRADO = 0
   SET @NFILAS = 0;
 
   -- VALIDACION DE LA TABLA
   IF (@TABLA IS NULL) OR LEN(RTRIM(LTRIM(@TABLA)))<=0
     BEGIN
	    SET @ENCONTRADO = -1
	    RETURN
	 END
   -- VALIDACION DEL CAMPO CLAVE
   IF (@CAMPOCLAVE IS NULL) OR LEN(RTRIM(LTRIM(@CAMPOCLAVE)))<=0
     BEGIN
	    SET @ENCONTRADO = -1
	    RETURN
	 END

	 -- PREPARA Y EJECUTA LA SENTENCIA SQL
   BEGIN TRY
--      SET @SQL = N'SELECT @NROFILAS = COUNT(*) FROM @CODTABLA WHERE @CODCAMPO = @VALORCAMPO' 
--	  SET @PARAMDEFINITION = N'@CODTABLA VARCHAR(100), @CODCAMPO VARCHAR(100), @VALORCAMPO VARCHAR(200), @NROFILAS INT OUTPUT' 
--      EXEC SP_EXECUTESQL @SQL, @PARAMDEFINITION, @CODTABLA=@TABLA, @CODCAMPO=@CAMPOCLAVE, @VALORCAMPO=@VALOR, @NROFILAS=@NFILAS OUTPUT
	  SET @SQL = N'SELECT ' + @CAMPOCLAVE + ' FROM ' + @TABLA + ' WHERE ' + @CAMPOCLAVE + ' = ''' + @VALOR + ''''
	  EXEC(@SQL)
	  SET @NFILAS = @@ROWCOUNT
   END TRY
   BEGIN CATCH
      PRINT 'OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
      SET @ENCONTRADO = -1
	  RETURN
   END CATCH
   
   IF @NFILAS > 0 
     BEGIN
        SET @ENCONTRADO = @NFILAS
	    RETURN
	 END
   SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_update_fe_documents]    Script Date: 07/03/2019 02:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_update_fe_documents](
   @TIPODOC    CHAR(02),    @SERIE      CHAR(04),     @FOLIO     INT,           @NEWSTATE  SMALLINT,
   @CODIGORET  INT OUTPUT,  @RESULTADO    VARCHAR(500) OUTPUT)
AS

DECLARE @nfilas      INT;
DECLARE @GWCDOCUMID  INT;

SET @GWCDOCUMID      = 0
SET @CODIGORET       = 0

BEGIN
   SET NOCOUNT ON;
   -- BUSCA EL DOCUMENTO
   SET @nfilas = 0;
   SELECT
      @GWCDOCUMID = GWCDOCUMID
   FROM
      GWCSERVER_FE_DOCUMENTS
   WHERE
      TIPODOC    = @TIPODOC
      AND SERIE  = @SERIE
      AND FOLIO  = @FOLIO
    
   SET @nfilas = @@ROWCOUNT;

   IF @nfilas > 0
   BEGIN
   BEGIN TRY
      BEGIN TRAN
         UPDATE
            GWCSERVER_FE_DOCUMENTS
         SET
            ESTADOGWC = @NEWSTATE,
			DATEMODIFIED = GETDATE(),
			USERMODIFIED = USER_NAME()
         WHERE
            GWCDOCUMID = @GWCDOCUMID
         COMMIT
         SET @RESULTADO = 'EL DOCUMENTO SE ACTUALIZÓ CORRECTAMENTE'
         SET NOCOUNT OFF
      END TRY
      BEGIN CATCH
         ROLLBACK
		 SET @CODIGORET = 900
         SET @RESULTADO = 'OCURRIÓ EL SIGUIENTE ERROR : ' + ERROR_MESSAGE()
      END CATCH
   END
   ELSE
      SET @CODIGORET = 900
      SET @RESULTADO = 'EL DOCUMENTO INGRESADO NO EXISTE!!!'
END

GO
