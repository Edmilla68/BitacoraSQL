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
CREATE PROCEDURE [dbo].[USP_CRLISER001] 
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


--IF OBJECT_ID(@SERVER) IS NULL
IF NOT EXISTS ( SELECT 1 FROM sys.servers WHERE name = @CNOMSER )
BEGIN
  PRINT 'Does not exist, need to create link'
	EXEC master.dbo.sp_addlinkedserver @server = @CNOMSER, @srvproduct=N'SQL Server'
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@CNOMSER,@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword=@CCLAUSR
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'collation compatible', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'data access', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'dist', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'pub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'rpc', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'rpc out', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'sub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'connect timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'lazy schema validation', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'query timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'use remote collation', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@CNOMSER, @optname=N'remote proc transaction promotion', @optvalue=N'true'

END
ELSE
  PRINT 'Link already exists'

-- Lectura de la siguiente fila del cursor
	FETCH cSERVIDORES INTO @IDSER, @CNOMSER, @CCLAUSR
END

 
-- Cierre del cursor
CLOSE cSERVIDORES
-- Liberar los recursos
DEALLOCATE cSERVIDORES


    
END

GO