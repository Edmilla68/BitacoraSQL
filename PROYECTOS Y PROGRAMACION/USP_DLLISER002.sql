USE [MONITOR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================
--	LULA'S SYSTEM 
--	Author:			Eduardo Milla Marquez
--	Create date:	12/08/2015
--	Description:	CREA LINKS EN FORMA DINAMICA DESDE TABLA 
-- ===========================================================
CREATE PROCEDURE [dbo].[USP_DLLISER002] 
AS
BEGIN
	SET NOCOUNT ON;

-- Declaracion de variables para el cursor

DECLARE @IDSER	 int
DECLARE @CNOMSER varchar(255)
DECLARE @CCLAUSR varchar(255)
	
-- Declaración del cursor

DECLARE cSERVIDORES CURSOR FOR

SELECT TS.IDSER, CNOMSER, CCLAUSR
	FROM TSERVIDOR TS
			LEFT JOIN TUSUARIO TU
				ON TU.IDSER = TS.IDSER
			WHERE TU.CNOMUSR = 'SA'

-- Apertura del cursor
OPEN cSERVIDORES
-- Lectura de la primera fila del cursor
FETCH cSERVIDORES INTO @IDSER, @CNOMSER, @CCLAUSR

WHILE (@@FETCH_STATUS = 0 )
BEGIN

	PRINT CONVERT(VARCHAR(3),@IDSER) +'  '+ @CNOMSER+' ' + @CCLAUSR 
-- cuerpo

	IF EXISTS(SELECT * FROM sys.servers WHERE name = @CNOMSER)
	BEGIN
	EXEC master.sys.sp_dropserver @CNOMSER,'droplogins' 
	PRINT 'BORRANDO' 
	END
	ELSE
	PRINT 'NO EXISTE'

-- Lectura de la siguiente fila del cursor
	FETCH cSERVIDORES INTO @IDSER, @CNOMSER, @CCLAUSR
END

 
-- Cierre del cursor
CLOSE cSERVIDORES
-- Liberar los recursos
DEALLOCATE cSERVIDORES


    
END

GO