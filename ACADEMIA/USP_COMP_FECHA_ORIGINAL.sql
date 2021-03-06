USE [ACADEMIA]
GO
/****** Object:  StoredProcedure [dbo].[USP_COMP_FECHA]    Script Date: 12/08/2019 08:38:48  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_COMP_FECHA]
@nom_referencia VARCHAR(50),
@RES_ASIS VARCHAR(8)OUT
AS

BEGIN
DECLARE @HORAINI VARCHAR(10)
declare @fecha datetime

SELECT @HORAINI = val_referencia FROM m_referencia
WHERE est_referencia = 1 and nom_referencia = @nom_referencia

IF @HORAINI IS NULL 
BEGIN
SET @RES_ASIS = 'NOREF'
RETURN
END


DECLARE @HORA_CONCAT DATETIME
--SET @HORA_CONCAT = Convert(DateTime, convert(varchar,Convert(date,getdate()),103 ) + ' '+@HORAINI)


SET @HORA_CONCAT = 
CONVERT(DATETIME,
CASE WHEN LEN(convert(varchar,day(getdate()))) = 1 THEN '0'+convert(varchar,day(getdate())) ELSE convert(varchar,day(getdate())) END +'-'+
CASE WHEN LEN(convert(varchar,MONTH(getdate()))) = 1 THEN '0'+convert(varchar,MONTH(getdate())) ELSE convert(varchar,MONTH(getdate())) END +'-'+
Convert(varchar,year(getdate())) +' '+
@HORAINI
,103)



SELECT @RES_ASIS = CASE WHEN @HORA_CONCAT >= GETDATE() THEN 'TEMPRANO'
				ELSE 'TARDE' END 

END 


