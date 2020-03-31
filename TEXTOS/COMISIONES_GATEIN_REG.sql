--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/********************************************************************************************************************************
FLUJO GATE IN CALLAO
-- DESARROLLADO POR : JONATHAN BERDEJO - NEPTUNIA 
-- DESARROLLADO EL : 19-11-2014
-- CORREGIDO EL : 29/01/2014
-- FORMATO FECHA EMISION = 'YYY-MM-DD HH:MM:SS SSS'
-- EXEC [COMISIONES_GATEIN_REG]
*********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[COMISIONES_GATEIN_REG]
AS
BEGIN 
SET NOCOUNT ON;
DECLARE @FECINI VARCHAR(10), @FECFIN VARCHAR(10)
SET @FECINI = CONVERT(VARCHAR,GETDATE()-1,112);
SET @FECFIN = CONVERT(VARCHAR,GETDATE(),112);
--SET @FECINI = '20150420'
--SET @FECFIN = '20150421'
PRINT @FECINI
/*************************************************************************************************
	EXTRAE LAS FACTURAS EMITIDAS EN EL GESFOR
	Y LAS UNE CON LOS REGISTROS PENDIENTES DE LA TABLA CONTROL,
	FINALMENTE LAS INSERTA EN UN TEMPORAL
**************************************************************************************************/	
IF OBJECT_ID ( 'TEMPDB..#TEMP_COMISIONES_GATEIN_GESFOR' ) IS NOT NULL 
	DROP TABLE #TEMP_COMISIONES_GATEIN_GESFOR;
SELECT torigen.[TP_FACT],torigen.[CNDCN],torigen.[NM_DOC],torigen.[FC_EMI]
	  ,torigen.[NAVE],torigen.[VIAJE],torigen.[DOC],torigen.[CNTDR],torigen.[MON],torigen.[TP_DOC]
	  ,torigen.[ST_SI],torigen.[SUSTENTO],torigen.[CD_SERV],torigen.[ST_ENV],torigen.[ST_REENV]
	  INTO #TEMP_COMISIONES_GATEIN_GESFOR
  FROM (SELECT DISTINCT
			   UPPER([TIPOFACTURACION]) AS [TP_FACT]
			  ,'-' AS [CNDCN]
			  ,[FACTURA] AS [NM_DOC]
			  ,[FECHAEMISION] AS [FC_EMI]
			  ,[NAVE] AS [NAVE]
			  ,[VIAJE] AS [VIAJE]
			  ,[DOCUMENTO] AS [DOC]
			  ,[CARGAFACTURADA] AS [CNTDR]
 			  ,[MONEDA] AS [MON]
			  ,[TIPODOCUMENTO] AS[TP_DOC]
			  ,'N' AS [ST_SI]
			  ,[SUSTENTO] AS [SUSTENTO]
			  ,[cod_origenservicio] AS [CD_SERV]
			  ,'0' AS [ST_ENV]
			  ,'0' AS [ST_REENV]
		  FROM [FACTNPT].[NEPTUNIA_SGC_PRODUCCION].[DBO].[FAC_LISTAR_FACTURAS_NAVEVIAJE]
		 WHERE [TIPOFACTURACION] LIKE '%FAC. DEVOLUCIÓN CNT%'
		   AND FECHAEMISION >= @FECINI AND FECHAEMISION < @FECFIN
		   AND cod_origenservicio IN ('213', '227')
		 UNION
		SELECT [TP_FACT],[CNDCN],[NM_DOC],[FC_EMI],[NAVE],[VIAJE],[DOC],[CO_CONT],[MON],[TP_DOC],[ST_SI],[SUSTENTO],[CD_SERV],[ST_ENV],[ST_REENV]
		  FROM [THCOMLIN_CTRL]
		 WHERE ST_ENV = '0'	AND ST_REENV = '0' AND FE_REGISTRO >= DATEADD(MONTH,-1,GETDATE())
		   AND DE_PROC_LINE = 'GATE IN'
 	  ) torigen
  LEFT JOIN [THCOMLIN_CTRL] ctrl
    ON ctrl.CO_CONT = torigen.CNTDR
   AND ctrl.NM_DOC = torigen.NM_DOC
 WHERE ctrl.CO_CONT IS NULL
    OR (ctrl.ST_ENV = '0' AND ctrl.ST_REENV = '0')
PRINT 'INSERT TEMP GESFOR ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT ) ;
--BORRAMOS LOS SERVICIOS QUE NO CORRESPONDEN
--DELETE #TEMP_COMISIONES_GATEIN_GESFOR WHERE [CD_SERV] NOT IN ('213', '227')
PRINT 'BORRA SERVICIOS GESFOR ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT );
/*************************************************************************************************
	COMPLETA LA TEMPORAL CON LA INFORMACION OPERATIVA
**************************************************************************************************/
IF OBJECT_ID ('TEMPDB..#TEMP_COMISIONES_GATEIN_OPERATIVO') IS NOT NULL 
	DROP TABLE #TEMP_COMISIONES_GATEIN_OPERATIVO;
SELECT tope.[CO_UNID]	,tope.[CO_LINE]		,tope.[DE_PROC_LINE]	,tope.[CO_CONT]		,tope.[CO_NAVB_CCTR]	,tope.[CO_TAMA_CCTR]	,tope.[FE_OPER]
	  ,tope.[CO_PROV]	,tope.[ST_MOVI]		,tope.[ST_REEN]			,tope.[ST_SADA]		,tope.[ST_SERV_INTE]	,tope.[CO_COND_CCTR]	,tope.[TI_DOCU]
	  ,tope.[NU_DOCU]	,tope.[FE_EMIS]		,tope.[TP_FACT]			,tope.[NM_DOC]		,tope.[FC_EMI]			,tope.[NAVE]			,tope.[VIAJE]
	  ,tope.[TP_DOC]	,tope.[MON]			,tope.[CNDCN]			,tope.[ST_SI]		,tope.[SUSTENTO]		,tope.[CD_SERV]			,tope.[DOC]
	  INTO #TEMP_COMISIONES_GATEIN_OPERATIVO
  FROM (SELECT DISTINCT '001' AS [CO_UNID]
			  ,mov.codarm10 AS [CO_LINE]
			  ,'GATE IN' AS [DE_PROC_LINE]
 			  ,fdet.codcon04 AS [CO_CONT]
			  ,fdet.navvia11 AS [CO_NAVB_CCTR]
			  ,con.codtam09 AS [CO_TAMA_CCTR]
			  ,mov.fecing09 AS [FE_OPER]
			  ,fcab.codage19 AS [CO_PROV]
			  ,'N' AS [ST_MOVI]
			  ,'N' AS [ST_REEN]
			  ,'N' AS [ST_SADA]
			  ,(CASE 
					WHEN ISNULL(ser.ORD_NUMDOCUMENTO,'') = '' THEN 'N' 
					--WHEN ISNULL(ser.ord_flagEstado,'') = 'A' THEN 'N' 
					ELSE 'S' END
				) AS [ST_SERV_INTE]
			  ,(CASE eir.tiping15 WHEN '1' THEN 'FC'
								  WHEN '8' THEN 'FC'
								  WHEN '13' THEN 'FC'
								  WHEN '9' THEN 'FC'
								  WHEN '14' THEN 'FC'
								  WHEN '12' THEN 'FC'
								  WHEN '3' THEN 'LC'
								  WHEN '4' THEN 'LC'
								  WHEN '2' THEN 'LC'
								  ELSE 'FC'
				END) AS [CO_COND_CCTR]
			  ,(CASE WHEN tmp.[TP_DOC] = 'factura' THEN 'FAC'
					 WHEN tmp.[TP_DOC] = 'boleta' THEN 'BOL'
				END) AS [TI_DOCU]
			  ,RIGHT('0000'+LEFT(fcab.nrodoc11,3),4) + '-' + RIGHT('0000000000'+RIGHT(fcab.nrodoc11,6),10) AS [NU_DOCU]
			  ,tmp.[FC_EMI] AS [FE_EMIS]
			  --*******************************************************************************************************
			  ,tmp.[TP_FACT]
			  ,tmp.[NM_DOC]
			  ,tmp.[FC_EMI]
			  ,tmp.[NAVE]
			  ,tmp.[VIAJE]
			  ,tmp.[TP_DOC]
			  ,tmp.[MON]
			  ,'-' AS [CNDCN]
			  ,'-' AS [ST_SI]
			  ,tmp.[SUSTENTO]
			  ,tmp.[CD_SERV]
			  ,tmp.[DOC]  
		  FROM #TEMP_COMISIONES_GATEIN_GESFOR tmp
		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].ADFACTUR11 fcab
		    ON fcab.nrodoc11 = LEFT(tmp.NM_DOC,3)+ RIGHT(tmp.NM_DOC,6)
		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].ADDETFAC12 fdet
			ON fdet.codtip48 = fcab.codtip48
		   AND fdet.nrodoc11 = fcab.nrodoc11
		   AND fdet.codcon04 = tmp.CNTDR
		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].DDCABMAN11 man
			ON man.navvia11 = fdet.navvia11
		  LEFT JOIN SSI_ORDEN ser
			ON ser.ORD_NAVVIA = fdet.navvia11
		   AND ser.ORD_NUMDOCUMENTO = tmp.SUSTENTO
		  --********************************************
		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].ADCONTEN04 con
		    ON con.codcon04 = tmp.CNTDR
 		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].ADREGEIR15 eir
			ON eir.codcon04 = fdet.codcon04
		   AND eir.navvia11 = fdet.navvia11
		  LEFT JOIN [OCEANICA1].[DESCARGA].[DBO].ADMOVCTR09 mov
			ON mov.codcon04 = eir.codcon04
 		   AND mov.nrosec09 = eir.nrosec09
		 WHERE 
			ISNULL(ser.ord_flagEstado,'') <> 'A' AND 
			(fdet.desimp12 LIKE '%213%' OR fdet.desimp12 LIKE '%227%' )
		   AND fcab.status11 NOT IN ('A')
		   AND eir.tipmov15 = 'I'
	   ) tope
  LEFT JOIN [THCOMLIN_CTRL] ctrl	--VALIDAMOS
    ON ctrl.CO_CONT = tope.CO_CONT
   AND ctrl.NM_DOC = tope.NM_DOC
 WHERE ctrl.CO_CONT IS NULL
ORDER BY tope.[CO_NAVB_CCTR],tope.[CO_CONT]
PRINT 'INSERTA / VALIDA OPERATIVO ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT ) ;
/*************************************************************************************************
	INSERTAMOS LOS NUEVOS CASOS EN LA TABLA DE CONTROL
**************************************************************************************************/	
INSERT INTO [DBO].[THCOMLIN_CTRL]
 	   (CO_UNID		,CO_LINE		,DE_PROC_LINE		,CO_CONT		,CO_NAVB_CCTR		,CO_TAMA_CCTR		,FE_OPER	
	   ,CO_PROV		,ST_MOVI		,ST_REEN			,ST_SADA		,ST_SERV_INTE		,CO_COND_CCTR		,TI_DOCU
	   ,NU_DOCU		,FE_EMIS		,TP_FACT			,NM_DOC			,FC_EMI				,NAVE				,VIAJE
	   ,TP_DOC		,MON			,CNDCN				,ST_SI			,SUSTENTO			,CD_SERV
	   ,ST_ENV		,ST_REENV	
	   ,DOC			,FE_REGISTRO)
SELECT DISTINCT 
	   tmp.CO_UNID	,tmp.CO_LINE	,tmp.DE_PROC_LINE	,tmp.CO_CONT	,tmp.CO_NAVB_CCTR	,tmp.CO_TAMA_CCTR	,tmp.FE_OPER
	  ,tmp.CO_PROV	,tmp.ST_MOVI	,tmp.ST_REEN		,tmp.ST_SADA	,tmp.ST_SERV_INTE	,tmp.CO_COND_CCTR	,tmp.TI_DOCU
	  ,tmp.NU_DOCU	,tmp.FE_EMIS	,tmp.TP_FACT		,tmp.NM_DOC		,tmp.FC_EMI			,tmp.NAVE			,tmp.VIAJE
	  ,tmp.TP_DOC	,tmp.MON		,tmp.CNDCN			,tmp.ST_SI		,ISNULL(tmp.SUSTENTO,SPACE(20))		,tmp.CD_SERV
	  ,(CASE WHEN tmp.FE_OPER IS NOT NULL THEN '1' ELSE '0' END)		,'0'
	  ,ISNULL(tmp.DOC,SPACE(20))		,GETDATE()
  FROM #TEMP_COMISIONES_GATEIN_OPERATIVO tmp
  LEFT JOIN [THCOMLIN_CTRL] ctrl
    ON ctrl.CO_CONT = tmp.CO_CONT
    AND ctrl.NU_DOCU = tmp.NU_DOCU
    AND ctrl.DE_PROC_LINE = 'GATE IN'
 WHERE ctrl.NU_DOCU IS NULL AND ctrl.CO_CONT IS NULL --NO EXISTE EN EL CTRL
   AND tmp.CO_CONT IS NOT NULL
 ORDER BY tmp.CO_LINE DESC
PRINT 'INSERTA / VALIDA CONTROL ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT ) ;
/*************************************************************************************************
	ACTUALIZAMOS LOS CASOS PENDIENTES
**************************************************************************************************/	
UPDATE ctrl
   SET ctrl.ST_REENV = '1'
	  ,ctrl.FE_OPER = tmp.FE_OPER
--SELECT * --COMENTAR
  FROM [THCOMLIN_CTRL] ctrl
  INNER JOIN #TEMP_COMISIONES_GATEIN_OPERATIVO tmp
    ON ctrl.CO_CONT = tmp.CO_CONT
    AND ctrl.NU_DOCU = tmp.NU_DOCU
  WHERE tmp.FE_OPER IS NOT NULL
   AND ctrl.ST_ENV = '0'
   AND ctrl.ST_REENV = '0'
   AND ctrl.DE_PROC_LINE = 'GATE IN'
PRINT 'ACTUALIZA PENDIENTES CONTROL ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT ) ;
/*************************************************************************************************
	REGISTROS A ENVIAR  OFISIS
**************************************************************************************************/	
--INSERT INTO [TWCOPER_COMI](
 INSERT INTO [CALW3ERP001].[OFIRECA].[DBO].[TWCOPER_COMI](
	[CO_UNID],		[CO_LINE],		[DE_PROC_LINE],	[CO_CONT],	[CO_NAVB_CCTR],	[CO_TAMA_CCTR],
	[FE_OPER],		[CO_PROV],		[ST_MOVI],		[ST_REEN],	[ST_SADA],		[ST_SERV_INTE],
	[CO_COND_CCTR],	[TI_DOCU],		[NU_DOCU],		[FE_EMIS]
)
SELECT DISTINCT
	   ctrl.[CO_UNID]		,ctrl.[CO_LINE]	,ctrl.[DE_PROC_LINE]	,ctrl.[CO_CONT],	ctrl.[CO_NAVB_CCTR]	,ctrl.[CO_TAMA_CCTR]
	  ,ctrl.[FE_OPER]		,ctrl.[CO_PROV]	,ctrl.[ST_MOVI]			,ctrl.[ST_REEN],	ctrl.[ST_SADA]		,ctrl.[ST_SERV_INTE]
	  ,ctrl.[CO_COND_CCTR]	,ctrl.[TI_DOCU]	,ctrl.[NU_DOCU]			,ctrl.[FE_EMIS]
   FROM #TEMP_COMISIONES_GATEIN_OPERATIVO tmp
  LEFT JOIN [THCOMLIN_CTRL] ctrl
    ON ctrl.CO_CONT = tmp.CO_CONT
    AND ctrl.NU_DOCU = tmp.NU_DOCU
  WHERE ctrl.ST_ENV = '1' OR (ctrl.ST_ENV='0' AND ctrl.ST_REENV = '1')
   AND ctrl.DE_PROC_LINE = 'GATE IN'
PRINT 'INSERTA OFISIS ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT);
---------------------------------------------------------------------------------------------------
--	BUSCAMOS TODOS LOS REGISTROS INSERTADOS DE IMPO, PARA GATE IN Y COMPARAMOS CON INGRESOS EN 
--	EIR
---------------------------------------------------------------------------------------------------
IF OBJECT_ID ('TEMPDB..#GATEIN_INTEGRAL') IS NOT NULL 
	DROP TABLE #GATEIN_INTEGRAL;
SELECT IDENTITY(int, 1,1) AS ID_Num, DE_PROC_LINE,CO_CONT,CO_NAVB_CCTR,FE_OPER,ST_ENV 
INTO #GATEIN_INTEGRAL
FROM [THCOMLIN_CTRL] 
WHERE DE_PROC_LINE='GATE IN' AND ST_ENV='0' AND ST_SERV_INTE='S'
DECLARE @CONT INT;
DECLARE @CANT INT;
DECLARE @DE_PROC_LINE VARCHAR(10);
DECLARE @CO_CONT VARCHAR(11);
DECLARE @CO_NAVB_CCTR VARCHAR(6);
 DECLARE @FEC_OPER DATETIME;
SELECT @CANT = COUNT(*) FROM #GATEIN_INTEGRAL;
SET @CONT=1;
WHILE @CONT<=@CANT
	BEGIN
		SELECT 
			@DE_PROC_LINE=DE_PROC_LINE
			,@CO_CONT=CO_CONT	
			,@CO_NAVB_CCTR=CO_NAVB_CCTR	
		FROM
		#GATEIN_INTEGRAL
		WHERE ID_NUM=@CONT
		IF  EXISTS(SELECT * FROM OCEANICA1.DESCARGA.DBO.ADREGEIR15 WHERE CODCON04=@CO_CONT AND NAVVIA11=@CO_NAVB_CCTR AND TIPMOV15='I')
		BEGIN
			SELECT @FEC_OPER=FECEMI15 FROM OCEANICA1.DESCARGA.DBO.ADREGEIR15 WHERE CODCON04=@CO_CONT AND NAVVIA11=@CO_NAVB_CCTR AND TIPMOV15='I'
			UPDATE [THCOMLIN_CTRL] SET FE_OPER=@FEC_OPER ,ST_ENV='1' WHERE CO_CONT=@CO_CONT AND CO_NAVB_CCTR=@CO_NAVB_CCTR AND DE_PROC_LINE=@DE_PROC_LINE
			INSERT INTO [CALW3ERP001].[OFIRECA].[DBO].[TWCOPER_COMI](
			--INSERT INTO [TWCOPER_COMI](
					[CO_UNID],		[CO_LINE],		[DE_PROC_LINE],	[CO_CONT],	[CO_NAVB_CCTR],	[CO_TAMA_CCTR],
					[FE_OPER],		[CO_PROV],		[ST_MOVI],		[ST_REEN],	[ST_SADA],		[ST_SERV_INTE],
					[CO_COND_CCTR],	[TI_DOCU],		[NU_DOCU],		[FE_EMIS])
			SELECT DISTINCT
				   ctrl.[CO_UNID]		,ctrl.[CO_LINE]	,ctrl.[DE_PROC_LINE]	,ctrl.[CO_CONT],	ctrl.[CO_NAVB_CCTR]	,ctrl.[CO_TAMA_CCTR]
				  ,ctrl.[FE_OPER]		,ctrl.[CO_PROV]	,ctrl.[ST_MOVI]			,ctrl.[ST_REEN],	ctrl.[ST_SADA]		,ctrl.[ST_SERV_INTE]
				  ,ctrl.[CO_COND_CCTR]	,ctrl.[TI_DOCU]	,ctrl.[NU_DOCU]			,ctrl.[FE_EMIS]
			FROM [THCOMLIN_CTRL] ctrl WHERE ctrl.CO_CONT=@CO_CONT AND ctrl.CO_NAVB_CCTR=@CO_NAVB_CCTR AND ctrl.DE_PROC_LINE=@DE_PROC_LINE 
		END
		SET @CONT = @CONT + 1;
	END
/*************************************************************************************************
	INSERTAMOS EN EL REPORTE DE VACIOS
**************************************************************************************************/	
INSERT INTO [DBO].[TMCOMLIN](
	[CD_EMPR],			[CD_PROC],		[MON],			[NAVE],
	[CD_SCRL],			[LIN_CNTDR],	[PROC],			[CNTDR],	[CD_NAVE],		[TAM], 
	[FC_OPE],			[CD_PROV],		[ST_MO], 		[ST_RE],	[ST_SA],		[ST_SI],
	[CNDCN],			[TP_DOC],		[NM_DOC],		[FC_EMI],	[FC_REG]
)
SELECT DISTINCT
	   '01'				,'001'			,c.[MON]		,c.[NAVE]		
	  ,'001'			,c.[CO_LINE]	,'GATE IN'		,c.[CO_CONT]	,c.[CO_NAVB_CCTR]	,c.[CO_TAMA_CCTR]
	  ,c.[FE_OPER]		,c.[CO_PROV]	,c.[ST_MOVI]	,c.[ST_REEN]	,c.[ST_SADA]		,c.[ST_SI] 
	  ,c.[CO_COND_CCTR] ,c.[TI_DOCU]	,c.[NM_DOC]		,c.[FC_EMI]		,GETDATE()
  FROM #TEMP_COMISIONES_GATEIN_OPERATIVO t
  LEFT JOIN [THCOMLIN_CTRL] c
    ON c.CO_CONT = t.CO_CONT
   AND c.NU_DOCU = t.NU_DOCU
 WHERE c.ST_ENV = '1' OR (c.ST_ENV='0' AND c.ST_REENV = '1')
   AND c.DE_PROC_LINE = 'GATE IN'
PRINT 'INSERTA REPORTE ==> ' + CONVERT(VARCHAR(20),@@ROWCOUNT ) ;
/*************************************************************************************************
	ELIMINAR OBJETOS TEMPORALES
**************************************************************************************************/	
IF EXISTS ( SELECT 1 FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('TEMPDB..#TEMP_COMISIONES_GATEIN_GESFOR' ) )
 BEGIN 
DROP TABLE #TEMP_COMISIONES_GATEIN_GESFOR
END ; 
IF EXISTS ( SELECT 1 FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('TEMPDB..#TEMP_COMISIONES_GATEIN_OPERATIVO' ) )
BEGIN 
DROP TABLE #TEMP_COMISIONES_GATEIN_OPERATIVO
END ; 
IF EXISTS ( SELECT 1 FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('TEMPDB..#TEMP_COMISIONES_GATEIN' ) )
BEGIN 
DROP TABLE #TEMP_COMISIONES_GATEIN
END ; 
IF EXISTS ( SELECT 1 FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('TEMPDB..#GATEIN_INTEGRAL' ) )
BEGIN 
DROP TABLE #GATEIN_INTEGRAL
END ; 
 END ;