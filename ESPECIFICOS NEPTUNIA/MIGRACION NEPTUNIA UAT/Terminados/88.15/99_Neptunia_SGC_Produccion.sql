USE [Neptunia_SGC_Produccion]
GO
/****** Object:  Synonym [dbo].[FAC_TMCLIE_NEPT]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_TMCLIE_NEPT]
GO
/****** Object:  Synonym [dbo].[FAC_TipoCambio]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_TipoCambio]
GO
/****** Object:  Synonym [dbo].[FAC_RegistrarAplicacionAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_RegistrarAplicacionAnticipo_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_RegistrarAnularCopiar_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_RegistrarAnularCopiar_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_Parametro_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_Parametro_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_Igv]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_Igv]
GO
/****** Object:  Synonym [dbo].[FAC_GenerarAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_GenerarAnticipo_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_Empresa]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_Empresa]
GO
/****** Object:  Synonym [dbo].[FAC_Direccion_Cliente_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_Direccion_Cliente_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_Cliente_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_Cliente_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_AnularAplicacionAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:36 PM ******/
DROP SYNONYM [dbo].[FAC_AnularAplicacionAnticipo_OFISIS]
GO
/****** Object:  Synonym [dbo].[FAC_AnularAplicacionAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:37 PM ******/
CREATE SYNONYM [dbo].[FAC_AnularAplicacionAnticipo_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[NP_TCCOBR_D01]
GO
/****** Object:  Synonym [dbo].[FAC_Cliente_OFISIS]    Script Date: 20/03/2019 02:23:37 PM ******/
CREATE SYNONYM [dbo].[FAC_Cliente_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMCLIE]
GO
/****** Object:  Synonym [dbo].[FAC_Direccion_Cliente_OFISIS]    Script Date: 20/03/2019 02:23:37 PM ******/
CREATE SYNONYM [dbo].[FAC_Direccion_Cliente_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TDDIRE_CLIE]
GO
/****** Object:  Synonym [dbo].[FAC_Empresa]    Script Date: 20/03/2019 02:23:37 PM ******/
CREATE SYNONYM [dbo].[FAC_Empresa] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMEMPR]
GO
/****** Object:  Synonym [dbo].[FAC_GenerarAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_GenerarAnticipo_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[NP_TCCOBR_I03]
GO
/****** Object:  Synonym [dbo].[FAC_Igv]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_Igv] FOR [SP3TDA-DBSQL02].[OFISEGU].[dbo].[TTIMPT]
GO
/****** Object:  Synonym [dbo].[FAC_Parametro_OFISIS]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_Parametro_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMPARA_RECA]
GO
/****** Object:  Synonym [dbo].[FAC_RegistrarAnularCopiar_OFISIS]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_RegistrarAnularCopiar_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[NP_TCCOBR_U01]
GO
/****** Object:  Synonym [dbo].[FAC_RegistrarAplicacionAnticipo_OFISIS]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_RegistrarAplicacionAnticipo_OFISIS] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[NP_TCCOBR_I04]
GO
/****** Object:  Synonym [dbo].[FAC_TipoCambio]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_TipoCambio] FOR [SP3TDA-DBSQL02].[OFISEGU].[dbo].[TCFACT_CAMB]
GO
/****** Object:  Synonym [dbo].[FAC_TMCLIE_NEPT]    Script Date: 20/03/2019 02:23:38 PM ******/
CREATE SYNONYM [dbo].[FAC_TMCLIE_NEPT] FOR [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMCLIE_NEPT]
GO
/****** Object:  UserDefinedFunction [dbo].[FAC_FNObtenerQuiebre]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[FAC_FNObtenerQuiebre]
	( @Ident_documento int,@Cod_Ofisis VARCHAR(5) ) returns NVARCHAR(5)
AS
BEGIN	
	Declare @Valor NVARCHAR(5)
	
	DECLARE @ID INT 
	DECLARE @CLIENTE NVARCHAR(40)
	DECLARE @CONSOLIDADORA NVARCHAR(40)
	DECLARE @LINEA NVARCHAR(40)

	DECLARE @CO_QUIEBRE_CLI NVARCHAR(5)
	DECLARE @CO_QUIEBRE_CON NVARCHAR(5)
	DECLARE @CO_QUIEBRE_LIN NVARCHAR(5)

	SET @ID=@ident_documento

	SELECT 
		@CLIENTE=CASE DOC.I030_Sustento
			WHEN  93 THEN (SELECT Ident_ClienteOperacion FROM FAC_Operacion (NOLOCK) WHERE Ident_Operacion=DOC.Sustento)
			WHEN  94 THEN (SELECT Ident_Cliente FROM FAC_OrdenFacturacion (NOLOCK) WHERE Ident_OrdenFacturacion=DOC.Sustento)
			WHEN  95 THEN (SELECT Ident_Cliente FROM FAC_OrdenNotaCredito (NOLOCK) WHERE Ident_OrdenNotaCredito=DOC.Sustento)
		END 
	FROM FAC_Documento DOC
	WHERE DOC.Ident_Documento=@ID
	
	SELECT 
		 @LINEA=VAL.Codigo
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=17 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)

	SELECT 
		 @CONSOLIDADORA=ISNULL(VAL.Codigo,'')
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=21 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)
	
	select @CO_QUIEBRE_CLI=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CLIENTE AND ESTADO='A'
	select @CO_QUIEBRE_CON=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA AND ESTADO='A'
	select @CO_QUIEBRE_LIN=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where QUIEBRE=@LINEA AND ESTADO='A'
	
	IF ( @Cod_Ofisis IN ('001','002','060','061','030','031','062','063','021','017','026','054','056') )
	BEGIN
		SELECT @Valor=ISNULL(@CO_QUIEBRE_CLI,'41000') 
	END
	
	IF ( @Cod_Ofisis IN ('013','069'))
	BEGIN
		SELECT @Valor = ISNULL(@CO_QUIEBRE_CON,'41000')
	END
	
	IF ( @Cod_Ofisis IN ('003','004'))
	BEGIN
		SELECT @Valor=ISNULL(@CO_QUIEBRE_LIN,'41000')
	END

	Return @Valor
END
GO
/****** Object:  UserDefinedFunction [dbo].[FAC_ObtenerClienteOfisis]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[FAC_ObtenerClienteOfisis] (@Ruc VARCHAR(20))
RETURNS @tabla TABLE (
	Ruc NVARCHAR(40)
	,RazonSocial NVARCHAR(200)
	,Direccion NVARCHAR(400)
	)
AS
BEGIN
	DECLARE @ISCO_EMPR VARCHAR(2)
	DECLARE @VSTI_DIRE_FACT VARCHAR(3)

	SET @ISCO_EMPR = '16'

	SELECT @VSTI_DIRE_FACT = t1.TI_DIRE_FACT
	FROM FAC_Parametro_OFISIS t1
	INNER JOIN FAC_Empresa t2 ON t2.CO_EMPR = t1.CO_EMPR
	WHERE t1.CO_EMPR = @ISCO_EMPR

	--ruc y razón social
	DECLARE @RucOfisis NVARCHAR(40)
	DECLARE @RazonSocial NVARCHAR(200)

	SELECT @RucOfisis = CO_CLIE
		,@RazonSocial = NO_CLIE
	FROM FAC_Cliente_OFISIS
	WHERE rtrim(ltrim(CO_CLIE)) = @Ruc
		AND CO_EMPR = @ISCO_EMPR

	--dirección
	DECLARE @Direccion NVARCHAR(400)

	SELECT @Direccion = DE_DIRE
	FROM FAC_Direccion_Cliente_OFISIS
	WHERE rtrim(ltrim(CO_CLIE)) = @Ruc
		AND CO_EMPR = @ISCO_EMPR
		AND TI_DIRE = @VSTI_DIRE_FACT

	INSERT INTO @tabla (
		Ruc
		,RazonSocial
		,Direccion
		)
	VALUES (
		@RucOfisis
		,@RazonSocial
		,@Direccion
		)

	RETURN
END
GO
/****** Object:  View [dbo].[TTUNID_NEGO]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTUNID_NEGO] As        
/*** VISTA DE CENTRO DE COSTO***/  
SELECT [dc_centro_costo], [DE_UNNE] as dg_centro_costo, [CO_UNNE], [CO_EMPR],  [CO_DINE],        
       [dc_division_negocio], [df_inicio_vigencia],        
       [df_termino_vigencia], [dg_alias_centro_costo],        
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]        
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO]      
WHERE  [CO_EMPR] = '16'  
GO
/****** Object:  View [dbo].[TTUNINEGO_POR_DIVISION]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTUNINEGO_POR_DIVISION] AS  
  
select a.dc_centro_costo CENTRO_COSTO_SISFACTNEPT,  
  
a.dg_centro_costo NOMBRE_CENTRO_COSTO,  
  
a.CO_UNNE COD_UNIDAD_NEGOCIO,  
  
a.CO_EMPR COD_EMPRESA,  
  
a.CO_DINE COD_DIVNEG_OFISIS,  
  
b.DE_DINE NOMBRE_DIVISION_NEGOCIO,  
  
a.DC_DIVISION_NEGOCIO COD_DIV_NEGO_SISFACTNEPT,  
  
a.DF_INICIO_VIGENCIA,  
  
a.DF_TERMINO_VIGENCIA,  
  
a.DG_ALIAS_CENTRO_COSTO  
  
from ttunid_nego a,   
  
[SP3TDA-DBSQL02].ofireca.dbo.TTDIVI_NEGO b  
  
where a.co_empr = '16'  
  
and a.co_empr = b.co_empr  
  
and a.co_dine = b.co_dine  
GO
/****** Object:  View [dbo].[prefactura]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[prefactura] 
as

select distinct  nu_pres_fact
from  [SP3TDA-DBSQL02].ofireca.dbo.tccobr where 
 co_mone = 'SOL'
and nu_pres_fact like '068%'   and nu_pres_fact in 
(
'068-0005028',
'068-0005856',
'068-0006152',
'068-0006565',
'068-0007073',
'068-0007078',
'068-0007184',
'068-0007191',
'068-0007196',
'068-0007205',
'068-0007217',
'068-0007229',
'068-0007230',
'068-0007235',
'068-0007238',
'068-0007240',
'068-0007244',
'068-0007275',
'068-0007286',
'068-0007302',
'068-0007310',
'068-0007338',
'068-0007341',
'068-0007365',
'068-0007433',
'068-0007591',
'068-0008141',
'068-0008239',
'068-0008460',
'068-0009332',
'068-0009526',
'068-0009563',
'068-0011587',
'068-0011734',
'068-0012287',
'068-0012887',
'068-0013862',
'068-0014024',
'068-0014895',
'068-0015219',
'068-0015234',
'068-0016340',
'068-0017046',
'068-0017272',
'068-0017281',
'068-0017307',
'068-0017318',
'068-0017327',
'068-0017343',
'068-0017366',
'068-0017403',
'068-0017473',
'068-0018116',
'068-0018798',
'068-0020443',
'068-0020449',
'068-0021503',
'068-0021520',
'068-0021524',
'068-0021536',
'068-0022187',
'068-0022285',
'068-0022788',
'068-0022914',
'068-0022920',
'068-0023126',
'068-0023503',
'068-0023766',
'068-0023791',
'068-0023875',
'068-0024541',
'068-0024735',
'068-0025871',
'068-0026026',
'068-0026054',
'068-0026260',
'068-0027190',
'068-0029219',
'068-0029275',
'068-0029280',
'068-0033191',
'068-0034008',
'068-0035189',
'068-0035428',
'068-0035783',
'068-0036787',
'068-0036795',
'068-0037066',
'068-0037262',
'068-0037280',
'068-0037328',
'068-0037360',
'068-0037369',
'068-0037377',
'068-0037391',
'068-0037393',
'068-0037435',
'068-0038220',
'068-0038282',
'068-0038345',
'068-0038347',
'068-0038349',
'068-0038688',
'068-0039190',
'068-0040127',
'068-0040195',
'068-0040561',
'068-0040636',
'068-0040994',
'068-0041132',
'068-0041966',
'068-0042230',
'068-0042515',
'068-0042521',
'068-0042742',
'068-0042802',
'068-0042845',
'068-0042945',
'068-0043130',
'068-0043392',
'068-0043607',
'068-0043982',
'068-0044168',
'068-0044475',
'068-0044583',
'068-0045397',
'068-0045402',
'068-0045483',
'068-0045702',
'068-0045769',
'068-0045999',
'068-0046009',
'068-0046047',
'068-0046117',
'068-0046441',
'068-0046670',
'068-0046673',
'068-0046748',
'068-0046892',
'068-0047191',
'068-0047684',
'068-0047884',
'068-0047994',
'068-0048616',
'068-0049164',
'068-0049191',
'068-0049407',
'068-0049529',
'068-0049581',
'068-0049645'

)
GO
/****** Object:  View [dbo].[TMTIEN]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TMTIEN] As        
/*** VISTA DE LOCAL***/  
SELECT [DC_SUCURSAL], [DE_TIEN] as dg_sucursal, [CO_TIEN], [CO_UNID], [CO_EMPR], [DE_TIEN], [DE_TIEN_LARG], [DE_DIRE], [CO_UBIC_GEOG],        
       [DE_CIUD], [DE_DPTO], [CO_PAIS], [NU_TLF1], [NU_TLF2], [NU_FAXS], [DE_DIRE_MAIL],        
       [TI_AUXI_EMPR], [CO_AUXI_EMPR], [NU_SERI_NCON], [CO_VEND_DEFA], [CO_CLIE_DEFA],        
       [ST_PUNT_VENT], [DG_ALIAS_SUCURSAL], [DF_VIGENCIA_INICIO], [DF_VIGENCIA_TERMINO],        
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]        
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN]       
WHERE  [CO_EMPR] = '16'  
GO
/****** Object:  View [dbo].[TMUNID_RECA]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TMUNID_RECA] As   
/*** VISTA DE SUCURSAL ***/       
Select [CO_UNID], [CO_EMPR], [DE_UNID], [TI_AUXI_EMPR], [CO_AUXI_EMPR],        
       [SUCCON01], [CODSED01], [FLGACT01],        
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]        
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMUNID_RECA]        
WHERE  [CO_EMPR] = '16'  
GO
/****** Object:  View [dbo].[TRUNNE_SERV]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TRUNNE_SERV] As    
/*** VISTA DEL DETALLE DEL SERVICIO***/         
SELECT t2.DC_SERVICIO, t3.DC_SUCURSAL as dc_sucursal_imputacion,             
                t4.DC_CENTRO_COSTO as dc_centro_costo_imputacion,            
       t1.[dm_detraccion], t1.[afecto_igv], t1.[df_inicio_vigencia], t1.[df_final_vigencia],            
       t1.[dc_porcentaje_detraccion],            
       t1.[CO_ACTI_DETR], t1.[CO_TIPO_DETR]            
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1            
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 On            
       (      t1.[CO_EMPR] = t2.[CO_EMPR]     
    And    t2.CO_SERV = t1.CO_SERV )            
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 On            
       (      t3.CO_TIEN = t1.CO_TIEN            
       And    t3.CO_UNID = t1.CO_UNID            
       And    t3.CO_EMPR = t1.CO_EMPR )            
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 On            
       (      t4.CO_UNNE = t1.CO_UNNE            
       And    t4.CO_EMPR = t1.CO_EMPR )        
WHERE  t1.[CO_EMPR] = '16'  
GO
/****** Object:  View [dbo].[TRUNNE_SERV_MGRCMS]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TRUNNE_SERV_MGRCMS] As  
/*** VISTA DEL DETALLE DEL SERVICIO***/       
SELECT t2.DC_SERVICIO, t3.DC_SUCURSAL as dc_sucursal_imputacion,           
                t4.DC_CENTRO_COSTO as dc_centro_costo_imputacion,          
       t1.[dm_detraccion], t1.[afecto_igv], t1.[df_inicio_vigencia], t1.[df_final_vigencia],          
       t1.[dc_porcentaje_detraccion],          
       t1.[CO_ACTI_DETR], t1.[CO_TIPO_DETR]          
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1          
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 On          
       (      t1.[CO_EMPR] = t2.[CO_EMPR]   
    And    t2.CO_SERV = t1.CO_SERV )          
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 On          
       (      t3.CO_TIEN = t1.CO_TIEN          
       And    t3.CO_UNID = t1.CO_UNID          
       And    t3.CO_EMPR = t1.CO_EMPR )          
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 On          
       (      t4.CO_UNNE = t1.CO_UNNE          
       And    t4.CO_EMPR = t1.CO_EMPR )      
WHERE  t1.[CO_EMPR] = '01'
GO
/****** Object:  View [dbo].[TTSERV]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTSERV] As  
/*** ESTE ES EL MAESTRO DE SERVICIO ***/        
SELECT [dc_servicio], [DE_SERV] as dg_servicio, [CO_SERV],         
       [dg_servicio_ingles], [dc_moneda_servicio],        
       [df_vigencia_inicio], [df_vigencia_termino],        
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]        
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV]        
WHERE CO_EMPR = '16'  
GO
/****** Object:  View [dbo].[vw_ConsultaServicioOfisis]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[vw_ConsultaServicioOfisis]
AS
SELECT 
	T2.CO_SERV CODIGOSERVICIO
	,T2.DE_SERV DESCRIPCION
	,T2.DG_SERVICIO_INGLES DESCRIPCION2
	,CASE T2.DC_MONEDA_SERVICIO
		WHEN 2 THEN '$'
		WHEN 1 THEN 'S/'
	END MONEDA
	,T2.TI_SITU ESTADO
	,T3.DE_TIEN [LOCAL]	
	,T4.DE_UNNE [UNIDADNEGOCIO]	
	,t1.[dm_detraccion] [DETRACCION]
	,t1.[afecto_igv] [AFECTOIGV]
	,t1.[df_inicio_vigencia] [INICIOVIGENCIA]
	,t1.[df_final_vigencia] [FINALVIGENCIA]
	,t1.[dc_porcentaje_detraccion] [PORCENTAJEDETRACCION]
FROM [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1
INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 ON (
		t1.[CO_EMPR] = t2.[CO_EMPR]
		AND t2.CO_SERV = t1.CO_SERV
		)
INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 ON (
		t3.CO_TIEN = t1.CO_TIEN
		AND t3.CO_UNID = t1.CO_UNID
		AND t3.CO_EMPR = t1.CO_EMPR
		)
INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 ON (
		t4.CO_UNNE = t1.CO_UNNE
		AND t4.CO_EMPR = t1.CO_EMPR
		)
WHERE t1.[CO_EMPR] = '16'
GO
/****** Object:  StoredProcedure [dbo].[BUQ_ObtenerCredito]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BUQ_ObtenerCredito]
AS
BEGIN
	SELECT '0' CO_COND_PAGO,'--Seleccione--' DE_COND
	UNION
	SELECT CO_COND_PAGO, UPPER(LEFT(DE_COND, 1)) + LOWER(SUBSTRING(DE_COND, 2, LEN(DE_COND))) DE_COND 
	FROM [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTTIPO_COND]
	WHERE CO_EMPR='16' AND CO_PAGO_NEPT IS NOT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[BUQ_ObtenerListaPreCotizacion]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BUQ_ObtenerListaPreCotizacion] @IdPerfil INT
	,@NombreUsuario VARCHAR(50)
AS
BEGIN
	IF @IdPerfil = 134 --AdminBUQ
	BEGIN
		SELECT PRECOT.IdPreCab id
			,UPPER(LEFT(LOC.Nombre, 1)) + LOWER(SUBSTRING(LOC.Nombre, 2, LEN(LOC.Nombre))) LOCAL
			,UN.DescripcionUnidad UnidadNegocio
			,TICLI.DescripcionTipoCliente TipoCliente
			,PRECOT.Ruc
			,CLI.RazonSocial
			,PRECOT.Margen
			,UPPER(LEFT(CRED.DE_COND, 1)) + LOWER(SUBSTRING(CRED.DE_COND, 2, LEN(CRED.DE_COND))) Credito
			,CASE PRECOT.I003_Moneda
				WHEN 10
					THEN 'SOL'
				WHEN 12
					THEN 'USD'
				END Moneda
			,VIAOPE.descripcion ViaOperacion
			--,PRECOT.FechaRegistro
			,EST.Descripcion Estado
		FROM CO_PreCotizacion_CAB PRECOT(NOLOCK)
		INNER JOIN TAR_Local LOC(NOLOCK) ON LOC.Cod_Local = PRECOT.Ident_Sucursal
		INNER JOIN CO_Unidad_Negocio UN(NOLOCK) ON UN.CodigoUnidad = PRECOT.CodigoUnidad
		INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTTIPO_COND] CRED ON CRED.CO_EMPR = '16'
			AND CRED.CO_PAGO_NEPT IS NOT NULL
			AND CRED.CO_COND_PAGO = PRECOT.Credito
		INNER JOIN CO_Tipo_Cliente TICLI(NOLOCK) ON TICLI.CodigoTipoCliente = PRECOT.CodigoTipoCliente
		INNER JOIN CO_ViaOperacion VIAOPE(NOLOCK) ON VIAOPE.CodigoViaOperacion = PRECOT.CodigoViaOperacion
		INNER JOIN CO_EstadoPreCotizacion EST(NOLOCK) ON EST.IdEstadoPreCot = PRECOT.IdEstadoPreCot
		INNER JOIN FAC_Cliente CLI(NOLOCK) ON CLI.Ruc = PRECOT.Ruc COLLATE Modern_Spanish_CI_AI
		ORDER BY PRECOT.IdPreCab DESC
	END

	IF @IdPerfil = 139--Jefe Ventas BUQ
	BEGIN
		SELECT PRECOT.IdPreCab id
			,UPPER(LEFT(LOC.Nombre, 1)) + LOWER(SUBSTRING(LOC.Nombre, 2, LEN(LOC.Nombre))) LOCAL
			,UN.DescripcionUnidad UnidadNegocio
			,TICLI.DescripcionTipoCliente TipoCliente
			,PRECOT.Ruc
			,CLI.RazonSocial
			,PRECOT.Margen
			,UPPER(LEFT(CRED.DE_COND, 1)) + LOWER(SUBSTRING(CRED.DE_COND, 2, LEN(CRED.DE_COND))) Credito
			,CASE PRECOT.I003_Moneda
				WHEN 10
					THEN 'SOL'
				WHEN 12
					THEN 'USD'
				END Moneda
			,VIAOPE.descripcion ViaOperacion
			--,PRECOT.FechaRegistro
			,EST.Descripcion Estado
		FROM CO_PreCotizacion_CAB PRECOT(NOLOCK)
		INNER JOIN TAR_Local LOC(NOLOCK) ON LOC.Cod_Local = PRECOT.Ident_Sucursal
		INNER JOIN CO_Unidad_Negocio UN(NOLOCK) ON UN.CodigoUnidad = PRECOT.CodigoUnidad
		INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTTIPO_COND] CRED ON CRED.CO_EMPR = '16'
			AND CRED.CO_PAGO_NEPT IS NOT NULL
			AND CRED.CO_COND_PAGO = PRECOT.Credito
		INNER JOIN CO_Tipo_Cliente TICLI(NOLOCK) ON TICLI.CodigoTipoCliente = PRECOT.CodigoTipoCliente
		INNER JOIN CO_ViaOperacion VIAOPE(NOLOCK) ON VIAOPE.CodigoViaOperacion = PRECOT.CodigoViaOperacion
		INNER JOIN CO_EstadoPreCotizacion EST(NOLOCK) ON EST.IdEstadoPreCot = PRECOT.IdEstadoPreCot
		INNER JOIN FAC_Cliente CLI(NOLOCK) ON CLI.Ruc = PRECOT.Ruc COLLATE Modern_Spanish_CI_AI
		WHERE PRECOT.IdEstadoPreCot IN (
				1
				,2
				,4
				)
		ORDER BY PRECOT.FechaRegistro
	END

	IF @IdPerfil = 140--Ejecutivo Venta BUQ
	BEGIN
		SELECT PRECOT.IdPreCab id
			,UPPER(LEFT(LOC.Nombre, 1)) + LOWER(SUBSTRING(LOC.Nombre, 2, LEN(LOC.Nombre))) LOCAL
			,UN.DescripcionUnidad UnidadNegocio
			,TICLI.DescripcionTipoCliente TipoCliente
			,PRECOT.Ruc
			,CLI.RazonSocial
			,PRECOT.Margen
			,UPPER(LEFT(CRED.DE_COND, 1)) + LOWER(SUBSTRING(CRED.DE_COND, 2, LEN(CRED.DE_COND))) Credito
			,CASE PRECOT.I003_Moneda
				WHEN 10
					THEN 'SOL'
				WHEN 12
					THEN 'USD'
				END Moneda
			,VIAOPE.descripcion ViaOperacion
			--,PRECOT.FechaRegistro
			,EST.Descripcion Estado
		FROM CO_PreCotizacion_CAB PRECOT(NOLOCK)
		INNER JOIN TAR_Local LOC(NOLOCK) ON LOC.Cod_Local = PRECOT.Ident_Sucursal
		INNER JOIN CO_Unidad_Negocio UN(NOLOCK) ON UN.CodigoUnidad = PRECOT.CodigoUnidad
		INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTTIPO_COND] CRED ON CRED.CO_EMPR = '16'
			AND CRED.CO_PAGO_NEPT IS NOT NULL
			AND CRED.CO_COND_PAGO = PRECOT.Credito
		INNER JOIN CO_Tipo_Cliente TICLI(NOLOCK) ON TICLI.CodigoTipoCliente = PRECOT.CodigoTipoCliente
		INNER JOIN CO_ViaOperacion VIAOPE(NOLOCK) ON VIAOPE.CodigoViaOperacion = PRECOT.CodigoViaOperacion
		INNER JOIN CO_EstadoPreCotizacion EST(NOLOCK) ON EST.IdEstadoPreCot = PRECOT.IdEstadoPreCot
		INNER JOIN FAC_Cliente CLI(NOLOCK) ON CLI.Ruc = PRECOT.Ruc COLLATE Modern_Spanish_CI_AI
		WHERE PRECOT.Usuario = @NombreUsuario
		ORDER BY PRECOT.FechaRegistro DESC
	END
	IF @IdPerfil = 143 --UserPricingBUQ
	BEGIN
		SELECT PRECOT.IdPreCab id
			,UPPER(LEFT(LOC.Nombre, 1)) + LOWER(SUBSTRING(LOC.Nombre, 2, LEN(LOC.Nombre))) LOCAL
			,UN.DescripcionUnidad UnidadNegocio
			,TICLI.DescripcionTipoCliente TipoCliente
			,PRECOT.Ruc
			,CLI.RazonSocial
			,PRECOT.Margen
			,UPPER(LEFT(CRED.DE_COND, 1)) + LOWER(SUBSTRING(CRED.DE_COND, 2, LEN(CRED.DE_COND))) Credito
			,CASE PRECOT.I003_Moneda
				WHEN 10
					THEN 'SOL'
				WHEN 12
					THEN 'USD'
				END Moneda
			,VIAOPE.descripcion ViaOperacion
			--,PRECOT.FechaRegistro
			,EST.Descripcion Estado
		FROM CO_PreCotizacion_CAB PRECOT(NOLOCK)
		INNER JOIN TAR_Local LOC(NOLOCK) ON LOC.Cod_Local = PRECOT.Ident_Sucursal
		INNER JOIN CO_Unidad_Negocio UN(NOLOCK) ON UN.CodigoUnidad = PRECOT.CodigoUnidad
		INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTTIPO_COND] CRED ON CRED.CO_EMPR = '16'
			AND CRED.CO_PAGO_NEPT IS NOT NULL
			AND CRED.CO_COND_PAGO = PRECOT.Credito
		INNER JOIN CO_Tipo_Cliente TICLI(NOLOCK) ON TICLI.CodigoTipoCliente = PRECOT.CodigoTipoCliente
		INNER JOIN CO_ViaOperacion VIAOPE(NOLOCK) ON VIAOPE.CodigoViaOperacion = PRECOT.CodigoViaOperacion
		INNER JOIN CO_EstadoPreCotizacion EST(NOLOCK) ON EST.IdEstadoPreCot = PRECOT.IdEstadoPreCot AND EST.IdEstadoPreCot IN (4,5)
		INNER JOIN FAC_Cliente CLI(NOLOCK) ON CLI.Ruc = PRECOT.Ruc COLLATE Modern_Spanish_CI_AI
		ORDER BY PRECOT.FechaRegistro DESC
	END
END

GO
/****** Object:  StoredProcedure [dbo].[BUQ_ObtenerMoneda]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BUQ_ObtenerMoneda]
AS
BEGIN
	SELECT '0' TI_TIPO_MONE,'--Seleccione--' CO_MONE_NEPT
	UNION
	SELECT TI_TIPO_MONE,CO_MONE_NEPT 
	FROM [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTMONE]
	WHERE CO_MONE_NEPT IS NOT NULL
	

END
GO
/****** Object:  StoredProcedure [dbo].[FAC_ActualizarDocumento_Estado]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[FAC_ActualizarDocumento_Estado] @Ident_Documento INT            
 ,@Estado INT            
AS            
BEGIN            
 /*Realizar Logica para verificar que el documento sea PAGO EFECTIVO                              
                               
 Declare @PagoEfectivo char(1)                              
                               
 If @PagoEfectivo = 1 and @Estado = 73                              
 Begin                              
   return                              
 End                              
                                
 */            
 UPDATE Fac_Documento            
 SET [I023_Estado] = @Estado            
 WHERE Ident_Documento = @Ident_Documento            
            
 /*Envia correo*/ 
 
-- print 'Estado'  + convert(varchar,@Estado)

print @Estado
            
 IF @Estado = 73            
 BEGIN            
  DECLARE @NroFactura VARCHAR(100)            
  DECLARE @Ident_Cliente NVARCHAR(40)            
  DECLARE @cli_correoelectronico NVARCHAR(200)            
            
  SELECT @NroFactura = (            
    CASE             
     WHEN len(se.numero) = 2            
      THEN (            
        SELECT ISNULL(REPLICATE('0', 4 - LEN(se.numero)), '') + CAST(se.numero AS VARCHAR) + '-0' + ISNULL(REPLICATE('0', 9 - LEN(d.numero)), '') + CAST(d.numero AS VARCHAR)            
        )            
     WHEN len(se.numero) > 2            
      AND se.ident_TipoDocumento IN (            
       1            
       ,2            
       )            
      THEN left(td.nombre, 1) + (CAST(se.numero AS VARCHAR) + '-0' + ISNULL(REPLICATE('0', 9 - LEN(d.numero)), '') + CAST(d.numero AS VARCHAR))            
     END            
    )            
   ,@Ident_Cliente = CONVERT(NVARCHAR(40), Ident_Cliente)            
  FROM FAC_Documento d            
  INNER JOIN FAC_Serie se ON d.Ident_Serie = se.Ident_Serie            
  INNER JOIN FAC_TipoDocumento td ON se.Ident_TipoDocumento = td.Ident_TipoDocumento            
  WHERE Ident_Documento = @Ident_Documento            
            
  SELECT @cli_correoelectronico = isnull(CLI_CONTACTOFACTURACIONE, '')            
  FROM [SP3TDA-DBSQL02].NEP_MSCRM_BDI.dbo.cliente            
  WHERE cli_nrodocumento = @Ident_Cliente            
            
  INSERT INTO AUDIT_FACTURAS_ANULADAS            
  VALUES (            
   rtrim(ltrim(@Ident_Cliente))            
   ,rtrim(ltrim(@cli_correoelectronico))            
   ,rtrim(ltrim(@NroFactura))            
   ,GETDATE()            
   )            
            
  DECLARE @mensaje VARCHAR(max)            
                  
  SELECT @mensaje = '                                          
     <html>                                          
    <table>                
    <tbody>                
    <tr><td><span style="font-size: 9.0pt; color: gray;">Estimado Cliente</span></td></tr>                
    <tr><td>&nbsp;</td></tr>                
    <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Se informa que la factura ' + @NroFactura + ' fue anulada, por favor no considerar en sus registros contables, agradecemos su atenci&oacute;n</span></td></tr>  

                          
    <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Cualquier consulta enviar correo a: facturacion@neptunia.com.pe </span></td></tr>                
    <tr><td>&nbsp;</td></tr>                
    <tr><td><img src="http://www.neptunia.com.pe/assets/images/logo_neptunia.jpg" alt="" /></td></tr>                
    </tbody>                
    </table>                                
     </html>'            
            
  set @cli_correoelectronico='reclamos@neptunia.com.pe; '+@cli_correoelectronico         
  
  --IF @cli_correoelectronico <> ''            
  --BEGIN         
      
    --print 'entre' 
     
   EXEC master.dbo.xp_smtp_sendmail @FROM = N'aneptunia@neptunia.com.pe'            
    ,@FROM_NAME = N'NEPTUNIA S.A'            
    ,@TO = @cli_correoelectronico         
    ,@BCC = N'giancarlo.taipe@neptunia.com.pe; jacqueline.delgado@neptunia.com.pe;'           
    ,@priority = N'HIGH'            
    ,@subject = 'Anulación de Factura - NEPTUNIA S.A.'            
    ,@message = @mensaje            
    ,@type = N'text/html'            
    ,@attachments = N''            
    ,@codepage = 0            
    ,@server = N'correo.neptunia.com.pe'            
        
          
  --EXEC msdb.dbo.sp_send_dbmail        
  --  @profile_name = 'Notificaciones',        
  --  @recipients = 'giancarlo.taipe@neptunia.com.pe; eduardo.milla@gmail.com ', --@cli_correoelectronico,        
  --  @body = @mensaje,      
  --  @subject = 'Anulación de Factura - NEPTUNIA S.A.';        
          
  --END            
 END            
END 
GO
/****** Object:  StoredProcedure [dbo].[FAC_AnularPostFacturacion]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Autor: Victor Clerque  
-- Objetivo: Post Facturación - Anular  
-- Valores de Prueba:  
-- Fecha de Creacion: 21/08/2009  
-- Fecha de Modificacion :  
--    
-- =============================================  
ALTER PROCEDURE [dbo].[FAC_AnularPostFacturacion] (@IdentDocumento INT)
AS
BEGIN
	DECLARE @Serie INT
	DECLARE @Numero INT
	DECLARE @IdentTipoDocumento INT
	---
	DECLARE @IdentTipoSustento INT
	----
	DECLARE @IdentTipoFacturacion INT
	DECLARE @Sustento VARCHAR(50)
	DECLARE @Cliente NVARCHAR(20)
	DECLARE @Emision DATETIME
	DECLARE @Importe MONEY
	DECLARE @Moneda VARCHAR(3)
	----Ivan Martinez 07/08/13      
	DECLARE @Ident_Configuracion_Expo VARCHAR(5)
	----IV 17/11/14 -Fact.Manual    
	DECLARE @I030_Sustento INT -- 94:Orden de facturacion   
		
	SELECT @I030_Sustento=I030_Sustento FROM  FAC_Documento (NOLOCK) WHERE Ident_Documento = @IdentDocumento
	
	IF (@I030_Sustento=93)
		BEGIN
			SELECT @Serie = s.Numero
				,@Numero = d.Numero
				,@IdentTipoDocumento = s.Ident_TipoDocumento
				,@IdentTipoFacturacion = c.Ident_TipoFacturacion
				,@IdentTipoSustento = o.I021_Sustento
				,@Sustento = o.Sustento
				,@Cliente = d.Ident_Cliente
				,@Emision = d.Emision
				,@Importe = d.Importe
				,@Moneda = dc.Moneda
				,@Ident_Configuracion_Expo = c.Ident_Configuracion
				,@I030_Sustento = d.I030_Sustento
			FROM FAC_Documento d
			INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento
			INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie
			INNER JOIN FAC_Operacion o ON o.Ident_Operacion = d.Sustento
			INNER JOIN FAC_Configuracion c ON o.Ident_Configuracion = c.Ident_Configuracion
			WHERE d.Ident_Documento = @IdentDocumento
		END
	IF (@I030_Sustento=94)
		BEGIN
			SELECT @Serie = s.Numero
				,@Numero = d.Numero
				,@IdentTipoDocumento = s.Ident_TipoDocumento
				,@IdentTipoFacturacion = 0
				,@IdentTipoSustento = 0
				,@Sustento = ''
				,@Cliente = d.Ident_Cliente
				,@Emision = d.Emision
				,@Importe = d.Importe
				,@Moneda = dc.Moneda
				,@Ident_Configuracion_Expo = 0
				,@I030_Sustento = d.I030_Sustento
			FROM FAC_Documento d
			INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento
			INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie
			WHERE d.Ident_Documento = @IdentDocumento
		END

	

	DECLARE @TipoFacturacion_Descarga INT
	DECLARE @TipoFacturacion_Embarque INT
	DECLARE @TipoFacturacion_DevolucionCnt INT
	DECLARE @TipoFacturacion_RetiroCnt INT
	DECLARE @TipoFacturacion_TransporteCnt INT
	DECLARE @TipoFacturacion_OrdenServicioExpo INT
	DECLARE @TipoFacturacion_OrdenServicioImpo INT
	DECLARE @TipoFacturacion_Vigencia INT
	DECLARE @TipoFacturacion_Balex INT
	DECLARE @TipoFacturacion_ForwarderFlat INT
	DECLARE @TipoFacturacion_LineaVacios INT
	DECLARE @TipoFacturacion_LineaReefer INT

	SET @TipoFacturacion_Descarga = 2
	SET @TipoFacturacion_Embarque = 4
	SET @TipoFacturacion_DevolucionCnt = 5
	SET @TipoFacturacion_RetiroCnt = 6
	SET @TipoFacturacion_TransporteCnt = 7
	SET @TipoFacturacion_OrdenServicioExpo = 9
	SET @TipoFacturacion_OrdenServicioImpo = 46
	SET @TipoFacturacion_Vigencia = 48
	SET @TipoFacturacion_Balex = 11
	SET @TipoFacturacion_ForwarderFlat = 12
	SET @TipoFacturacion_LineaVacios = 14
	SET @TipoFacturacion_LineaReefer = 15

	DECLARE @MensajeError VARCHAR(MAX)
	DECLARE @IdentTipoDocumento_Factura INT

	SET @IdentTipoDocumento_Factura = dbo.FAC_ObtenerParametro_Valor('IdentTipoDocumento_Factura')

	IF @IdentTipoFacturacion = @TipoFacturacion_TransporteCnt
	BEGIN
		BEGIN TRY
			DECLARE @Resultado_1 INT
				,@Mensaje_1 VARCHAR(255)
			DECLARE @NroOrdenTransporte INT

			SET @NroOrdenTransporte = CAST(@Sustento AS INT)

			EXEC FAC_AnularPostFacturacion_LOG @NroOrdenTransporte
				,@Resultado_1 OUTPUT
				,@Mensaje_1 OUTPUT

			IF @Resultado_1 = - 1
				RAISERROR (
						@Mensaje_1
						,11
						,1
						)
		END TRY

		BEGIN CATCH
			SET @MensajeError = ERROR_MESSAGE()

			RAISERROR (
					@MensajeError
					,11
					,1
					)
		END CATCH
	END

	BEGIN
		/*Inicio Pagonet*/
		DECLARE @Condicion_Pagonet INT
			,@Condicion_CreditoPagonet INT
			,@Condicion_NumeroPrefacturaPagonet VARCHAR(50)
		DECLARE @IdentPagonet_SI INT
			,@IdentCreditoPagonet_NO INT
			,@IdentNumeroPrefacturaPagonet INT

		SET @IdentPagonet_SI = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_Pagonet_Si');
		SET @IdentCreditoPagonet_NO = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_CreditoPagonet_No');
		SET @IdentNumeroPrefacturaPagonet = dbo.FAC_ObtenerParametro_Valor('IdenCondicion_NumeroPrefacturaPagonet');

		SELECT TOP (1) @Condicion_Pagonet = cdc.Ident_ValorCondicion
		FROM FAC_Documento d
		INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
		INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
		WHERE d.Ident_Documento = @IdentDocumento
			AND cdc.Ident_ValorCondicion = @IdentPagonet_SI

		SELECT TOP (1) @Condicion_CreditoPagonet = cdc.Ident_ValorCondicion
		FROM FAC_Documento d
		INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
		INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
		WHERE d.Ident_Documento = @IdentDocumento
			AND cdc.Ident_ValorCondicion = @IdentCreditoPagonet_NO

		SELECT TOP (1) @Condicion_NumeroPrefacturaPagonet = cdc.Valor
		FROM FAC_Documento d
		INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
		INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
		WHERE d.Ident_Documento = @IdentDocumento
			AND cdc.Ident_Condicion = @IdentNumeroPrefacturaPagonet

		IF @Condicion_Pagonet IS NOT NULL
			AND @IdentTipoFacturacion = @TipoFacturacion_DevolucionCnt
		BEGIN
			DECLARE @TABLA_CNT_GATEIN TABLE (
				Row INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
				,CNTR_CODIGO CHAR(11)
				,CNTR_NAVEVIAJE CHAR(6)
				,CNTR_FACTURA CHAR(9)
				)

			INSERT INTO @TABLA_CNT_GATEIN
			SELECT CAST(CNT.Codigo AS CHAR(11)) CNTR_CODIGO
				,CAST((
						SELECT CXC.Valor
						FROM FAC_CntDocumentoXCondicion CXC
						WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
							AND CXC.Ident_Condicion = 67 --Nave Viaje  
							AND CXC.Valor IS NOT NULL
						) AS CHAR(6)) CNTR_NAVEVIAJE
				,CAST(dbo.FAC_FormatoCeroIzquierda(S.Numero, 3) + dbo.FAC_FormatoCeroIzquierda(D.Numero, 6) AS CHAR(9)) CNTR_FACTURA
			FROM FAC_Documento D
			INNER JOIN FAC_CntDocumento CNT ON CNT.Ident_Documento = D.Ident_Documento
			INNER JOIN FAC_Serie S ON S.Ident_Serie = D.Ident_Serie
			WHERE CNT.Ident_Documento = @IdentDocumento

			DECLARE @cont INT
			DECLARE @max INT

			SET @cont = 1

			SELECT @max = COUNT(*)
			FROM @TABLA_CNT_GATEIN

			WHILE @cont <= @max
			BEGIN
				DECLARE @CNTR_CODIGO CHAR(11)
				DECLARE @CNTR_NAVEVIAJE CHAR(6)
				DECLARE @CNTR_FACTURA CHAR(9)

				SELECT @CNTR_CODIGO = CNTR_CODIGO
					,@CNTR_NAVEVIAJE = CNTR_NAVEVIAJE
					,@CNTR_FACTURA = CNTR_FACTURA
				FROM @TABLA_CNT_GATEIN
				WHERE Row = @cont

				EXEC FAC_EliminarCntGateIn_PAGONET @CNTR_CODIGO
					,@CNTR_NAVEVIAJE
					,@CNTR_FACTURA

				SET @cont = @cont + 1
			END
		END
				--  IF  @Condicion_Pagonet IS NOT NULL  
				--  AND @Condicion_CreditoPagonet IS NOT NULL  
				--  AND @Condicion_NumeroPrefacturaPagonet IS NOT NULL  
				--  BEGIN  
				--   BEGIN TRY  
				--    DECLARE @ISNU_PREF varchar(20)  
				--    IF @IdentTipoFacturacion IN ( 5, --Fac.Devolución Cnt  
				--            6 --Fac.Retiro Cnt  
				--           )  
				--     SET @ISNU_PREF = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + '-' + dbo.FAC_FormatoCeroIzquierda(@Numero, 7)  
				--    ELSE  
				--     SET @ISNU_PREF = @Condicion_NumeroPrefacturaPagonet  
				--  
				--    DECLARE @Resultado_2 int, @Mensaje_2 varchar(255)      
				--    EXEC dbo.FAC_AnularAplicacionAnticipo_OFISIS @ISNU_PREF, @Resultado_2 output, @Mensaje_2 output  
				--    IF @Resultado_2 = 1  
				--     RAISERROR(@Mensaje_2, 11, 1)  
				--   END TRY  
				--   BEGIN CATCH  
				--    SET @MensajeError = ERROR_MESSAGE()  
				--    RAISERROR (@MensajeError, 11, 1)  
				--   END CATCH  
				--  END  
				/*Fin Pagonet*/
	END

	IF @IdentTipoFacturacion IN (
			@TipoFacturacion_Descarga
			,@TipoFacturacion_Embarque
			,@TipoFacturacion_DevolucionCnt
			,@TipoFacturacion_RetiroCnt
			,@TipoFacturacion_OrdenServicioExpo
			,@TipoFacturacion_Balex
			,@TipoFacturacion_ForwarderFlat
			,@TipoFacturacion_OrdenServicioImpo
			,@TipoFacturacion_Vigencia
			,@TipoFacturacion_LineaVacios,
			0
			)
	BEGIN
		DECLARE @IdentCondicion_FechaIngresoCarga INT

		SET @IdentCondicion_FechaIngresoCarga = dbo.FAC_ObtenerParametro_Valor('IdentCondicion_FechaIngresoCarga')

		DECLARE @NroFac CHAR(9)

		SET @NroFac = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + dbo.FAC_FormatoCeroIzquierda(@Numero, 6)

		DECLARE @TipFac CHAR(3)

		SET @TipFac = CASE @IdentTipoFacturacion
				WHEN @TipoFacturacion_Descarga
					THEN 'FIM'
				WHEN @TipoFacturacion_Embarque
					THEN 'FDU'
				WHEN @TipoFacturacion_DevolucionCnt
					THEN 'FGI'
				WHEN @TipoFacturacion_RetiroCnt
					THEN 'FGO'
				WHEN @TipoFacturacion_OrdenServicioExpo
					THEN 'FSX'
				WHEN @TipoFacturacion_Balex
					THEN 'FBA'
				WHEN @TipoFacturacion_ForwarderFlat
					THEN 'FFI'
				WHEN @TipoFacturacion_OrdenServicioImpo
					THEN 'FSE'
				WHEN @TipoFacturacion_Vigencia
					THEN 'FVI'
				WHEN @TipoFacturacion_LineaVacios
					THEN 'FAL'
				END

		----Ivan Martinez 07/08/13   
		IF @IdentTipoFacturacion = '12'
			AND @Ident_Configuracion_Expo = '104'
		BEGIN
			SET @TipFac = 'FFE' --- Forwarder Flat Expo      
		END ---      

		----IV 17/11/14 -Fact.Manual
		IF @I030_Sustento = 94
		BEGIN
			SET @TipFac = 'FMA' --- Facturacion manual 
		END

		---GTM - Fact. Adicional
		IF @IdentTipoSustento = 192
		BEGIN
			SET @TipFac = 'FSA'
		END

		DECLARE @TipDoc CHAR(2)

		SET @TipDoc = CASE 
				WHEN @IdentTipoDocumento = @IdentTipoDocumento_Factura
					THEN 'FA'
				ELSE 'BV'
				END

		BEGIN
			BEGIN TRY
				EXEC FAC_AnularPostFacturacion_NEP @TipFac
					,@TipDoc
					,@NroFac
			END TRY

			BEGIN CATCH
				SET @MensajeError = ERROR_MESSAGE()

				RAISERROR (
						@MensajeError
						,11
						,1
						)
			END CATCH
		END
	END

	EXEC FAC_AnularOrdenRetiroContenedor @IdentDocumento
END
GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerContabilizacion_IdentDocumento_NPT]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:  Enrique Véliz          
-- Create date: 18/11/2009          
-- Description:           
-- =============================================          
ALTER PROCEDURE [dbo].[FAC_ObtenerContabilizacion_IdentDocumento_NPT] (@Ident_Documento INT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RucConsolidador VARCHAR(100)
	DECLARE @ident_cliente NVARCHAR(40)
	DECLARE @NumeroReferencia NVARCHAR(50)

	SELECT TOP 1 @RucConsolidador = ltrim(rtrim(isnull(vc.Codigo, '')))
	FROM FAC_CntDocumento cd
	INNER JOIN FAC_CntDocumentoXCondicion cdc ON cd.Ident_CntDocumento = cdc.Ident_CntDocumento
		AND cdc.Ident_Condicion = 21
	INNER JOIN FAC_ValorCondicion vc ON cdc.Ident_ValorCondicion = vc.Ident_ValorCondicion
	WHERE cd.Ident_Documento = @Ident_Documento

	IF @RucConsolidador = '' OR @RucConsolidador IS NULL
	BEGIN
		SELECT @ident_cliente = Ident_Cliente
		FROM FAC_Documento
		WHERE Ident_Documento = @Ident_Documento

		SET @RucConsolidador = @ident_cliente
	END
	
	IF EXISTS (SELECT Ident_Documento FROM FAC_Contabilizacion (NOLOCK) WHERE Ident_Documento = @Ident_Documento AND TipoDocumento='NTC')
	BEGIN
		SELECT @NumeroReferencia =( CASE TipoReferencia
										WHEN 'FAC' THEN 'F'+NumeroReferencia
									END )
		FROM FAC_Contabilizacion (NOLOCK)
		WHERE Ident_Documento = @Ident_Documento
	END
	ELSE
	BEGIN
		SELECT @NumeroReferencia = NumeroReferencia
		FROM FAC_Contabilizacion (NOLOCK)
		WHERE Ident_Documento = @Ident_Documento
	END

	SELECT Ident_Documento
		,Usuario
		,Sucursal
		,Empresa
		,TipoDocumento
		,NumeroDocumento
		,EmisionDocumento
		,TipoFacturacion
		,Moneda
		,RucCliente
		,CodigoImpuesto
		,ImporteImpuesto
		,ImporteBrutoAfecto
		,ImporteBrutoInafecto
		,ImporteTotal
		,GlosaCabecera
		,TipoReferencia
		,@NumeroReferencia as NumeroReferencia
		,AgenciaAduana
		,AgenciaMaritima
		,LineaNaviera
		,ServicioIntegral
		,NumeroAsiento
		,NumeroAsientoAnulacion
		,GlosaResultado
		,@RucConsolidador AS GlosaResultadoAnulacion
		,---GlosaResultadoAnulacion,          
		ValorReferencial
	FROM FAC_Contabilizacion
	WHERE Ident_Documento = @Ident_Documento
END

GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerQuiebre]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[FAC_ObtenerQuiebre] (@ident_documento int)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ID INT 
	DECLARE @CLIENTE NVARCHAR(40)
	DECLARE @CONSOLIDADORA NVARCHAR(40)
	DECLARE @LINEA NVARCHAR(40)

	DECLARE @CO_QUIEBRE_CLI NVARCHAR(5)
	DECLARE @CO_QUIEBRE_CON NVARCHAR(5)
	DECLARE @CO_QUIEBRE_LIN NVARCHAR(5)

	SET @ID=@ident_documento

	SELECT 
		@CLIENTE=CASE DOC.I030_Sustento
			WHEN  93 THEN (SELECT Ident_ClienteOperacion FROM FAC_Operacion (NOLOCK) WHERE Ident_Operacion=DOC.Sustento)
			WHEN  94 THEN (SELECT Ident_Cliente FROM FAC_OrdenFacturacion (NOLOCK) WHERE Ident_OrdenFacturacion=DOC.Sustento)
			WHEN  95 THEN (SELECT Ident_Cliente FROM FAC_OrdenNotaCredito (NOLOCK) WHERE Ident_OrdenNotaCredito=DOC.Sustento)
		END 
	FROM FAC_Documento DOC
	WHERE DOC.Ident_Documento=@ID

	SELECT 
		 @LINEA=VAL.Codigo
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=17 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)

	SELECT 
		 @CONSOLIDADORA=ISNULL(VAL.Codigo,'')
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=21 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)


	--SELECT ISNULL(@CLIENTE,'41000'),ISNULL(@CONSOLIDADORA,'41000'),ISNULL(@LINEA,'41000')

	--select @CO_QUIEBRE_CLI=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CLIENTE
	--select @CO_QUIEBRE_CON=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA
	--select @CO_QUIEBRE_LIN=CO_QUIEBRE from R where QUIEBRE=@LINEA

	/*
	select @CO_QUIEBRE_CLI=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CLIENTE AND ESTADO='A'
	select @CO_QUIEBRE_CON=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA AND ESTADO='A'
	select @CO_QUIEBRE_LIN=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where QUIEBRE=@LINEA AND ESTADO='A'
	*/
	
	
	select @CO_QUIEBRE_CLI=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CLIENTE AND ESTADO='A'
	select @CO_QUIEBRE_CON=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA AND ESTADO='A'
	select @CO_QUIEBRE_LIN=CO_QUIEBRE from TMCLIE_NEPT where QUIEBRE=@LINEA AND ESTADO='A'
	

	--SELECT @CO_QUIEBRE_CLI,@CO_QUIEBRE_CON,@CO_QUIEBRE_LIN

	CREATE TABLE #TEMPO
	(CentroCosto VARCHAR(3),CO_QUIEBRE VARCHAR(5))

	SELECT DISTINCT CentroCosto 
	into #Temporal
	FROM FAC_ItemContabilizacion WHERE Ident_Documento=@ID

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('001','002','060','061','030','031','062','063','021','017','026','054','056'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_CLI,'41000')CO_QUIEBRE
		FROM #Temporal 
		WHERE centroCosto IN ('001','002','060','061','030','031','062','063','021','017','026','054','056')
	END

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('013','069'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_CON,'41000')CO_QUIEBRE	
		FROM #Temporal 
		WHERE centroCosto IN ('013','069')
	END

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('003','004'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_LIN,'41000')CO_QUIEBRE
		FROM #Temporal 
		WHERE centroCosto IN ('003','004')
	END
	
	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('064','065'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_CLI,'41000')CO_QUIEBRE
		FROM #Temporal 
		WHERE centroCosto IN ('064','065')
	END

	UPDATE FAC_ItemContabilizacion SET CO_QUIEBRE=TE.CO_QUIEBRE
	FROM	FAC_ItemContabilizacion ITEMCONT (NOLOCK)
	INNER JOIN #TEMPO TE ON TE.CentroCosto collate DATABASE_DEFAULT =ITEMCONT.CentroCosto
	WHERE	Ident_Documento = @Ident_Documento

	--SELECT * FROM #TEMPO

	drop table #TEMPO
	drop table #Temporal
END

GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerQuiebre_PRUEBA]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[FAC_ObtenerQuiebre_PRUEBA] (@ident_documento int)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ID INT 
	DECLARE @CLIENTE NVARCHAR(40)
	DECLARE @CONSOLIDADORA NVARCHAR(40)
	DECLARE @LINEA NVARCHAR(40)

	DECLARE @CO_QUIEBRE_CLI NVARCHAR(5)
	DECLARE @CO_QUIEBRE_CON NVARCHAR(5)
	DECLARE @CO_QUIEBRE_LIN NVARCHAR(5)

	SET @ID=@ident_documento

	SELECT 
		@CLIENTE=CASE DOC.I030_Sustento
			WHEN  93 THEN (SELECT Ident_ClienteOperacion FROM FAC_Operacion (NOLOCK) WHERE Ident_Operacion=DOC.Sustento)
			WHEN  94 THEN (SELECT Ident_Cliente FROM FAC_OrdenFacturacion (NOLOCK) WHERE Ident_OrdenFacturacion=DOC.Sustento)
			WHEN  95 THEN (SELECT Ident_Cliente FROM FAC_OrdenNotaCredito (NOLOCK) WHERE Ident_OrdenNotaCredito=DOC.Sustento)
		END 
	FROM FAC_Documento DOC
	WHERE DOC.Ident_Documento=@ID

	SELECT 
		 @LINEA=VAL.Codigo
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=17 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)

	SELECT 
		 @CONSOLIDADORA=ISNULL(VAL.Codigo,'')
	FROM 
	FAC_CntDocumentoXCondicion DOCCON (NOLOCK)
	INNER JOIN FAC_ValorCondicion VAL (NOLOCK) ON VAL.Ident_Condicion=21 AND DOCCON.Ident_ValorCondicion=VAL.Ident_ValorCondicion
	WHERE 
	DOCCON.Ident_CntDocumento =(SELECT TOP 1 IDENT_CNTDOCUMENTO FROM FAC_CNTDocumento (NOLOCK) WHERE Ident_Documento=@ID)


	--SELECT ISNULL(@CLIENTE,'41000'),ISNULL(@CONSOLIDADORA,'41000'),ISNULL(@LINEA,'41000')

	--select @CO_QUIEBRE_CLI=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CLIENTE
	--select @CO_QUIEBRE_CON=CO_QUIEBRE from TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA
	--select @CO_QUIEBRE_LIN=CO_QUIEBRE from TMCLIE_NEPT where QUIEBRE=@LINEA

	select @CO_QUIEBRE_CLI=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CLIENTE AND ESTADO='A'
	select @CO_QUIEBRE_CON=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where CO_CLIE=@CONSOLIDADORA AND ESTADO='A'
	select @CO_QUIEBRE_LIN=CO_QUIEBRE from [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT where QUIEBRE=@LINEA AND ESTADO='A'

	--SELECT @CO_QUIEBRE_CLI,@CO_QUIEBRE_CON,@CO_QUIEBRE_LIN

	CREATE TABLE #TEMPO
	(CentroCosto VARCHAR(3),CO_QUIEBRE VARCHAR(5))

	SELECT DISTINCT CentroCosto 
	into #Temporal
	FROM FAC_ItemContabilizacion WHERE Ident_Documento=@ID

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('001','002','060','061','030','031','062','063','021','017','026','054','056'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_CLI,'41000')CO_QUIEBRE
		FROM #Temporal 
		WHERE centroCosto IN ('001','002','060','061','030','031','062','063','021','017','026','054','056')
	END

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('013','069'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_CON,'41000')CO_QUIEBRE	
		FROM #Temporal 
		WHERE centroCosto IN ('013','069')
	END

	IF EXISTS (SELECT CentroCosto FROM #Temporal WHERE centroCosto IN ('003','004'))
	BEGIN
		INSERT INTO #TEMPO
		SELECT CentroCosto ,ISNULL(@CO_QUIEBRE_LIN,'41000')CO_QUIEBRE
		FROM #Temporal 
		WHERE centroCosto IN ('003','004')
	END

	SELECT * FROM #TEMPO
	
	UPDATE FAC_ItemContabilizacion SET CO_QUIEBRE=TE.CO_QUIEBRE
	FROM	FAC_ItemContabilizacion ITEMCONT (NOLOCK)
	INNER JOIN #TEMPO TE ON TE.CentroCosto collate DATABASE_DEFAULT =ITEMCONT.CentroCosto
	WHERE	Ident_Documento = @Ident_Documento

	drop table #TEMPO
	drop table #Temporal
END
GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerTipoCambio]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Enrique Véliz
-- Create date: 13/08/2009
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[FAC_ObtenerTipoCambio]
AS
BEGIN
	SET NOCOUNT ON;
		
	--SELECT	TOP 1	FA_VNTA_OFIC
	----FROM	dbo.FAC_TipoCambio
	--FROM NEPTUNIA1.TERMINAL.DBO.TCFACT_CAMB
	--WHERE	CO_MONE = 'DOL'
	--AND		CO_MONE_BASE = 'SOL'
	--AND		FE_CAMB = CAST(FLOOR(CAST(GETDATE() AS float)) AS datetime)
	--ORDER BY	FE_CAMB DESC
	
	select camleg28 FA_VNTA_OFIC
	from TERMINAL.DBO.DQTIPCAM28 
	where CAST(FLOOR(CAST(fecusu00 AS float)) AS datetime) =CAST(FLOOR(CAST(GETDATE() AS float)) AS datetime)
	
END
GO
/****** Object:  StoredProcedure [dbo].[FAC_RegistrarOrdenRetiroContenedor]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================  
-- Autor: Yesenia Quispe, Enrique Véliz  
-- Objetivo: Registrar Órdenes de Retiro en el sistema de Citas y Facturación  
-- Valores de Prueba: exec FAC_RegistrarOrdenRetiroContenedor 413  
-- Fecha de Creacion: 17/05/2010  
-- Fecha de Modificacion :  
-- FAC_RegistrarOrdenRetiroContenedor  1389  
-- FAC_ReporteOrdenRetiro_Contenedor_NEP '055000266'  
-- FAC_RegistrarOrdenRetiroContenedor 1392  
-- ==============================================================================  
ALTER PROCEDURE [dbo].[FAC_RegistrarOrdenRetiroContenedor] (@IdentDocumento INT)
AS
BEGIN
	DECLARE @Sustento_Volante INT
	DECLARE @Documento_Operacion INT
	DECLARE @TipoFacturacion_Descarga INT
	DECLARE @TipoFacturacion_Vigencia INT
	DECLARE @NroVolante CHAR(7)
	DECLARE @Serie INT
	DECLARE @Numero INT
	DECLARE @IdentTipoDocumento CHAR(3)
	DECLARE @IdentTipoFacturacion INT
	DECLARE @Sustento VARCHAR(50)
	DECLARE @NroFac CHAR(9)
	DECLARE @NroFacFormato CHAR(11)

	SET @Sustento_Volante = 65
	SET @Documento_Operacion = 93
	SET @TipoFacturacion_Descarga = 2
	SET @TipoFacturacion_Vigencia = 48

	SELECT @Serie = s.Numero
		,@Numero = d.Numero
		,@IdentTipoDocumento = CASE 
			WHEN s.Ident_TipoDocumento = 1
				THEN 'BOL'
			ELSE 'FAC'
			END
		,@IdentTipoFacturacion = c.Ident_TipoFacturacion
		,@Sustento = o.Sustento
	FROM FAC_Documento d (NOLOCK)
	INNER JOIN FAC_Contabilizacion dc (NOLOCK) ON dc.Ident_Documento = d.Ident_Documento
	INNER JOIN FAC_Serie s (NOLOCK) ON d.Ident_Serie = s.Ident_Serie
	INNER JOIN FAC_Operacion o (NOLOCK) ON o.Ident_Operacion = d.Sustento
	INNER JOIN FAC_Configuracion c (NOLOCK) ON o.Ident_Configuracion = c.Ident_Configuracion
	WHERE d.Ident_Documento = @IdentDocumento

	SET @NroFac = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + dbo.FAC_FormatoCeroIzquierda(@Numero, 6)
	SET @NroFacFormato = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + '-' + dbo.FAC_FormatoCeroIzquierda(@Numero, 6)

	DECLARE @TABLA_ORDENRETIRO_CONTENEDOR TABLE (
		Row INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
		,NroOrden CHAR(10)
		,Codigo CHAR(4)
		,Agente VARCHAR(80)
		,FecExpedicion DATETIME
		,FacDesc CHAR(9)
		,FacAlm CHAR(9)
		,Vapor VARCHAR(30)
		,Viaje CHAR(10)
		,Puerto CHAR(30)
		,Linea CHAR(3)
		,FecLlegada DATETIME
		,Manifiesto CHAR(5)
		,Conocimiento CHAR(25)
		,Poliza CHAR(15)
		,FecNumeracion VARCHAR(10)
		,FecPago VARCHAR(10)
		,Regimen CHAR(25)
		,CodDespachador CHAR(11)
		,Despachador VARCHAR(100)
		,DNI CHAR(8)
		,Cantidad INT
		,Marca CHAR(11)
		,Expedido VARCHAR(15)
		,Peso DECIMAL(10, 2)
		,Ubicacion CHAR(25)
		,NroVolante CHAR(10)
		,NroMovimientos INT
		,FechaVigencia DATETIME
		)

	INSERT INTO @TABLA_ORDENRETIRO_CONTENEDOR
	EXEC FAC_ReporteOrdenRetiro_Contenedor_NEP @NroFac

	IF (
			SELECT COUNT(*)
			FROM @TABLA_ORDENRETIRO_CONTENEDOR
			) <> 0
	BEGIN
		--VALIDACION PARA CITAS  
		IF @IdentTipoFacturacion IN (
				@TipoFacturacion_Descarga
				,@TipoFacturacion_Vigencia
				)
		BEGIN
			--   --ORDENAMIENTO  
			--  
			--   DECLARE @TABLA_ORDENAMIENTO_CITAS TABLE  
			--   (  
			--    NroVolante varchar(50),  
			--    NroContenedor char(11),  
			--    OrdenCitas int  
			--   )  
			DECLARE @TABLA_ORDENAMIENTO TABLE (
				Orden INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
				,NroVolante VARCHAR(50)
				,NroContenedor CHAR(11)
				,ExisteCita BIT
				)

			SELECT @NroVolante = MAX(NroVolante)
			FROM @TABLA_ORDENRETIRO_CONTENEDOR

			INSERT INTO @TABLA_ORDENAMIENTO
			SELECT @NroVolante
				,Codigo
				,ExisteCita
			FROM NEP_ObtenerContenedor_OrdenRetiro
			WHERE IdFactura = @IdentDocumento
			ORDER BY OrdenamientoOrdenRetiro ASC

			--   INSERT INTO @TABLA_ORDENAMIENTO_CITAS EXEC CIT_ConsultarOrdenManualContenedores @NroVolante  
			--  
			--   INSERT INTO @TABLA_ORDENAMIENTO  
			--   SELECT NroVolante, NroContenedor  
			--   FROM @TABLA_ORDENAMIENTO_CITAS  
			--   WHERE OrdenCitas IS NOT NULL  
			--   ORDER BY OrdenCitas  
			--   INSERT INTO @TABLA_ORDENAMIENTO  
			--   SELECT NroVolante, Marca  
			--   FROM @TABLA_ORDENRETIRO_CONTENEDOR  
			--   --WHERE Marca in (SELECT NroContenedor FROM @TABLA_ORDENAMIENTO_CITAS WHERE OrdenCitas is null OR OrdenCitas = '')  
			--   WHERE Marca NOT IN (SELECT NroContenedor FROM @TABLA_ORDENAMIENTO)  
			--   ORDER BY NroMovimientos  
			--INSERCION EN SISTEMA DE CITAS  
			DECLARE @cont INT
			DECLARE @max INT

			SELECT @max = MAX(Orden)
			FROM @TABLA_ORDENAMIENTO

			SELECT @cont = MIN(Orden)
			FROM @TABLA_ORDENAMIENTO

			DECLARE @NroOrdenRetiro VARCHAR(10)
			DECLARE @NroOrdenRetiro_Anterior VARCHAR(10)
			DECLARE @cont_OrdenRetiro INT

			SET @NroOrdenRetiro_Anterior = NULL
			SET @cont_OrdenRetiro = 0

			WHILE @cont <= @max
			BEGIN
				DECLARE @NroContenedor CHAR(11)
				DECLARE @FechaVigencia DATETIME
				DECLARE @ExisteCita BIT

				SELECT @NroVolante = T.NroVolante
					,@NroContenedor = T.NroContenedor
					,@NroOrdenRetiro = RTRIM(LTRIM(CAST(O.NroOrden AS VARCHAR(6))))
					,@FechaVigencia = O.FechaVigencia
					,@ExisteCita = T.ExisteCita
				FROM @TABLA_ORDENAMIENTO T
				INNER JOIN @TABLA_ORDENRETIRO_CONTENEDOR O ON (
						O.NroVolante = T.NroVolante
						AND T.NroContenedor = O.Marca
						)
				WHERE T.Orden = @cont

				IF @NroOrdenRetiro <> COALESCE(@NroOrdenRetiro_Anterior, '')
				BEGIN
					SET @NroOrdenRetiro_Anterior = @NroOrdenRetiro
					SET @cont_OrdenRetiro = 1
				END
				ELSE
				BEGIN
					SET @cont_OrdenRetiro = @cont_OrdenRetiro + 1
				END

				SET @NroOrdenRetiro = @NroOrdenRetiro + '-' + CAST(@cont_OrdenRetiro AS VARCHAR(3))

				--    SELECT T.NroVolante,  
				--      T.NroContenedor,  
				--      CAST(O.NroOrden AS char(6)) + '-' + CAST(T.Orden AS char(3)) AS OrdenRetiro,  
				--      O.FechaVigencia  
				--    FROM @TABLA_ORDENAMIENTO T  
				--    INNER JOIN @TABLA_ORDENRETIRO_CONTENEDOR O ON (O.NroVolante = T.NroVolante AND T.NroContenedor = O.Marca)  
				--    WHERE T.Orden = @cont  
				-- IF @ExisteCita = 1  
				-- BEGIN  
				--EXEC DVW3BDOT.[GNeptuniaCitas].[dbo].CIT_RegistrarOrdenRetiroXCita  
				EXEC CIT_RegistrarOrdenRetiroXCita @NroVolante
					,@NroContenedor
					,@NroOrdenRetiro
					,@FechaVigencia
					,@NroFacFormato
					,@IdentTipoDocumento

				-- END  
				--CONSULTAMOS TURNOS  
				DECLARE @TABLA_TURNOS TABLE (
					NroOrdenRetiro CHAR(10)
					,Turno VARCHAR(30)
					)

				--INSERT INTO @TABLA_TURNOS EXEC DVW3BDOT.[GNeptuniaCitas].[dbo].CIT_ConsultarTurnoOrdenRetiro @NroOrdenRetiro  
				INSERT INTO @TABLA_TURNOS
				EXEC CIT_ConsultarTurnoOrdenRetiro @NroOrdenRetiro

				--INSERTO ORDEN DE RETIRO EN FACTURACION  
				DECLARE @Turno VARCHAR(30)

				SELECT @Turno = Turno
				FROM @TABLA_TURNOS
				WHERE NroOrdenRetiro = @NroOrdenRetiro

				IF (
						SELECT COUNT(NroVolante)
						FROM FAC_OrdenRetiroContenedor(NOLOCK)
						WHERE Ident_Documento = @IdentDocumento
							AND NroOrden = @NroOrdenRetiro
							AND NroVolante = @NroVolante
						) = 0
				BEGIN
					INSERT INTO FAC_OrdenRetiroContenedor (
						Ident_Documento
						,NroVolante
						,NroOrden
						,Codigo
						,Agente
						,FecExpedicion
						,FacDesc
						,FacAlm
						,Vapor
						,Viaje
						,Puerto
						,Linea
						,FecLlegada
						,Manifiesto
						,Conocimiento
						,Poliza
						,FecNumeracion
						,FecPago
						,Regimen
						,CodDespachador
						,Despachador
						,DNI
						,Cantidad
						,Marca
						,Expedido
						,Peso
						,Ubicacion
						,Turno
						,FechaVigencia
						)
					SELECT @IdentDocumento
						,@NroVolante
						,@NroOrdenRetiro
						,O.Codigo
						,O.Agente
						,O.FecExpedicion
						,O.FacDesc
						,O.FacAlm
						,O.Vapor
						,O.Viaje
						,O.Puerto
						,O.Linea
						,O.FecLlegada
						,O.Manifiesto
						,O.Conocimiento
						,O.Poliza
						,O.FecNumeracion
						,O.FecPago
						,O.Regimen
						,O.CodDespachador
						,O.Despachador
						,O.DNI
						,O.Cantidad
						,O.Marca
						,O.Expedido
						,O.Peso
						,O.Ubicacion
						,@Turno
						,@FechaVigencia
					FROM @TABLA_ORDENAMIENTO T
					INNER JOIN @TABLA_ORDENRETIRO_CONTENEDOR O ON (
							O.NroVolante = T.NroVolante
							AND T.NroContenedor = O.Marca
							)
					WHERE T.Orden = @cont
				END

				SET @cont = @cont + 1
			END
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[FAC_RegistrarPostFacturacion]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[FAC_RegistrarPostFacturacion] (
	@IdentDocumento INT
	,@GenerarOrden BIT
	)
AS
BEGIN
	DECLARE @Serie INT
	DECLARE @Numero INT
	DECLARE @IdentTipoDocumento INT
	DECLARE @IdentTipoFacturacion INT
	DECLARE @IdentTipoSustento INT
	DECLARE @Sustento VARCHAR(50)
	DECLARE @Cliente NVARCHAR(20)
	DECLARE @Emision DATETIME
	DECLARE @Importe MONEY
	DECLARE @Moneda VARCHAR(3)
	DECLARE @Hoy DATETIME
	DECLARE @Despachador VARCHAR(50)
	DECLARE @IdentConfiguracion INT --CAMBIO            
	DECLARE @IdentUnidadNegocio_Forwarders INT
	DECLARE @IdentUnidadNegocio_CargaProyectos INT
	DECLARE @IdentTipoFacturacion_Operacion INT
	DECLARE @IdentUnidadNegocio_Operacion INT
	----IV 24/09/12        
	DECLARE @Ident_Configuracion_Expo VARCHAR(5)
	----IV 17/11/14 -Fact.Manual        
	DECLARE @I030_Sustento INT -- 94:Orden de facturacion    

	--193853           
	SET @Hoy = getdate()
	
	SELECT @I030_Sustento=I030_Sustento FROM  FAC_Documento (NOLOCK) WHERE Ident_Documento = @IdentDocumento
	
	IF (@I030_Sustento=93)
		BEGIN
				SELECT @Serie = s.Numero
					,@Numero = d.Numero
					,@IdentTipoDocumento = s.Ident_TipoDocumento
					,@IdentTipoFacturacion = c.Ident_TipoFacturacion
					,@IdentTipoSustento = o.I021_Sustento
					,@Sustento = o.Sustento
					,@Cliente = d.Ident_Cliente
					,@Emision = d.Emision
					,@Importe = d.Importe
					,@Moneda = dc.Moneda
					,@Ident_Configuracion_Expo = c.Ident_Configuracion
					,@I030_Sustento = d.I030_Sustento
				FROM FAC_Documento d
				INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento
				INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie
				INNER JOIN FAC_Operacion o ON o.Ident_Operacion = d.Sustento
				INNER JOIN FAC_Configuracion c ON o.Ident_Configuracion = c.Ident_Configuracion
				WHERE d.Ident_Documento = @IdentDocumento
		END
	IF (@I030_Sustento=94)
		BEGIN	
				SELECT @Serie = s.Numero
					,@Numero = d.Numero
					,@IdentTipoDocumento = s.Ident_TipoDocumento
					,@IdentTipoFacturacion = 0
					,@IdentTipoSustento = 0
					,@Sustento = ''
					,@Cliente = d.Ident_Cliente
					,@Emision = d.Emision
					,@Importe = d.Importe
					,@Moneda = dc.Moneda
					,@Ident_Configuracion_Expo = ''
					,@I030_Sustento = d.I030_Sustento
				FROM FAC_Documento d
				INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento
				INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie				
				WHERE d.Ident_Documento = @IdentDocumento		
		END	

	--SELECT @Serie = s.Numero
	--	,@Numero = d.Numero
	--	,@IdentTipoDocumento = s.Ident_TipoDocumento
	--	,@IdentTipoFacturacion = c.Ident_TipoFacturacion
	--	,@IdentTipoSustento = o.I021_Sustento
	--	,@Sustento = o.Sustento
	--	,@Cliente = d.Ident_Cliente
	--	,@Emision = d.Emision
	--	,@Importe = d.Importe
	--	,@Moneda = dc.Moneda
	--	,
	--	----IV 24/09/12        
	--	@Ident_Configuracion_Expo = c.Ident_Configuracion
	--	,--Se usara solo cuando sea forwarder flat expo, para diferenciarlo        
	--	----IV 17/11/14 -Fact.Manual    
	--	@I030_Sustento = d.I030_Sustento
	--FROM FAC_Documento d
	--INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento
	--INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie
	--INNER JOIN FAC_Operacion o ON o.Ident_Operacion = d.Sustento
	--INNER JOIN FAC_Configuracion c ON o.Ident_Configuracion = c.Ident_Configuracion
	--WHERE d.Ident_Documento = @IdentDocumento

	SELECT @Despachador = MAX(CXC.Valor)
	FROM FAC_CntDocumento CNT
	INNER JOIN FAC_CntDocumentoXCondicion CXC ON CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
	WHERE CXC.Ident_Condicion = 60 --Despachador            
		AND CNT.Ident_Documento = @IdentDocumento

	---25/05/2016  
	IF @Despachador = ''
		OR @Despachador IS NULL
	BEGIN
		SELECT @Despachador = MAX(coc.Valor)
		FROM FAC_Documento d
		INNER JOIN FAC_Operacion o ON d.Sustento = o.Ident_Operacion
		INNER JOIN FAC_CntOperacion co ON o.Ident_Operacion = co.Ident_Operacion
		INNER JOIN FAC_CntOperacionXCondicion coc ON coc.Ident_CntOperacion = co.Ident_CntOperacion
		WHERE coc.Ident_Condicion = 60
			AND d.Ident_Documento = @IdentDocumento
	END

	DECLARE @TipoFacturacion_Descarga INT
	DECLARE @TipoFacturacion_Embarque INT
	DECLARE @TipoFacturacion_DevolucionCnt INT
	DECLARE @TipoFacturacion_RetiroCnt INT
	DECLARE @TipoFacturacion_TransporteCnt INT
	DECLARE @TipoFacturacion_OrdenServicioExpo INT
	DECLARE @TipoFacturacion_OrdenServicioImpo INT
	DECLARE @TipoFacturacion_Vigencia INT
	DECLARE @TipoFacturacion_Balex INT
	DECLARE @TipoFacturacion_ForwarderFlat INT
	DECLARE @TipoFacturacion_LineaVacios INT
	DECLARE @TipoFacturacion_LineaReefer INT
	DECLARE @TipoFacturacion_Manual INT --IV 17/11/14 -Fact.Manual    
	DECLARE @TipoFacturacion_OtroTerminal INT 

	SET @TipoFacturacion_Descarga = 2
	SET @TipoFacturacion_Embarque = 4
	SET @TipoFacturacion_DevolucionCnt = 5
	SET @TipoFacturacion_RetiroCnt = 6
	SET @TipoFacturacion_TransporteCnt = 7
	SET @TipoFacturacion_OrdenServicioExpo = 9
	SET @TipoFacturacion_OrdenServicioImpo = 46
	SET @TipoFacturacion_Vigencia = 48
	SET @TipoFacturacion_Balex = 11
	SET @TipoFacturacion_ForwarderFlat = 12
	SET @TipoFacturacion_LineaVacios = 14
	SET @TipoFacturacion_LineaReefer = 15
	SET @TipoFacturacion_OtroTerminal = 57

	IF (@IdentTipoFacturacion = 12)
	BEGIN
		SET @GenerarOrden = 0
	END

	DECLARE @IdentTipoDocumento_Factura INT

	SET @IdentTipoDocumento_Factura = dbo.FAC_ObtenerParametro_Valor('IdentTipoDocumento_Factura')

	DECLARE @IdentSustentoOperacion_Volante INT

	SET @IdentSustentoOperacion_Volante = dbo.FAC_ObtenerParametro_Valor('IdentSustentoOperacion_Volante')
	SET @IdentUnidadNegocio_Forwarders = dbo.FAC_ObtenerParametro_Valor('IdentUnidadNegocio_Forwarders')
	SET @IdentUnidadNegocio_CargaProyectos = dbo.FAC_ObtenerParametro_Valor('IdentUnidadNegocio_CargaProyectos')

	DECLARE @MensajeError VARCHAR(MAX)

	--Transporte            
	IF @IdentTipoFacturacion = @TipoFacturacion_TransporteCnt
	BEGIN
		BEGIN TRY
			DECLARE @Resultado_1 INT
				,@Mensaje_1 VARCHAR(255)
			DECLARE @NroOrdenTransporte INT

			SET @NroOrdenTransporte = CAST(@Sustento AS INT)

			EXEC FAC_RegistrarPostFacturacion_LOG @NroOrdenTransporte
				,@Resultado_1 OUTPUT
				,@Mensaje_1 OUTPUT

			IF @Resultado_1 = - 1
				RAISERROR (
						@Mensaje_1
						,11
						,1
						)
		END TRY

		BEGIN CATCH
			SET @MensajeError = ERROR_MESSAGE()

			RAISERROR (
					@MensajeError
					,11
					,1
					)
		END CATCH
	END

	/*Inicio Pagonet*/
	DECLARE @Condicion_Pagonet INT
		,@Condicion_CreditoPagonet INT
		,@Condicion_NumeroPrefacturaPagonet VARCHAR(50)
	DECLARE @IdentPagonet_SI INT
		,@IdentCreditoPagonet_NO INT
		,@IdentNumeroPrefacturaPagonet INT

	SET @IdentPagonet_SI = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_Pagonet_Si');
	SET @IdentCreditoPagonet_NO = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_CreditoPagonet_No');
	SET @IdentNumeroPrefacturaPagonet = dbo.FAC_ObtenerParametro_Valor('IdenCondicion_NumeroPrefacturaPagonet');

	SELECT TOP (1) @Condicion_Pagonet = cdc.Ident_ValorCondicion
	FROM FAC_Documento d
	INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
	INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
	WHERE d.Ident_Documento = @IdentDocumento
		AND cdc.Ident_ValorCondicion = @IdentPagonet_SI

	SELECT TOP (1) @Condicion_CreditoPagonet = cdc.Ident_ValorCondicion
	FROM FAC_Documento d
	INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
	INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
	WHERE d.Ident_Documento = @IdentDocumento
		AND cdc.Ident_ValorCondicion = @IdentCreditoPagonet_NO

	SELECT TOP (1) @Condicion_NumeroPrefacturaPagonet = cdc.Valor
	FROM FAC_Documento d
	INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento
	INNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento
	WHERE d.Ident_Documento = @IdentDocumento
		AND cdc.Ident_Condicion = @IdentNumeroPrefacturaPagonet

	IF @Condicion_Pagonet IS NOT NULL
		AND @IdentTipoFacturacion = @TipoFacturacion_DevolucionCnt --GateIn            
	BEGIN
		DECLARE @TABLA_CNT_GATEIN TABLE (
			Row INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
			,CNTR_CODIGO CHAR(11)
			,CNTR_NAVEVIAJE CHAR(6)
			,CNTR_TAMANIO CHAR(2)
			,CNTR_USUARIO VARCHAR(30)
			,CNTR_IDDOC INT
			,CNTR_NRODOC VARCHAR(6)
			,CNTR_VALORIZA INT
			,CNTR_FACTURA CHAR(9)
			,CNTR_SERVEXTRA CHAR(1)
			,CNTR_LINEA VARCHAR(4)
			,CNTR_CONDICION VARCHAR(2)
			,CNTR_TIPO VARCHAR(2)
			,CNTR_BL VARCHAR(25)
			,CNTR_PREMEMO CHAR(4)
			,CNTR_NROMEMO CHAR(10)
			,CNTR_VIGMEMO DATETIME
			,CNTR_LOCAL INT
			,CNTR_FLGREINGRESO INT
			)

		INSERT INTO @TABLA_CNT_GATEIN
		SELECT CAST(CNT.Codigo AS CHAR(11)) CNTR_CODIGO
			,CAST((
					SELECT CXC.Valor
					FROM FAC_CntDocumentoXCondicion CXC
					WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
						AND CXC.Ident_Condicion = 67 --Nave Viaje            
						AND CXC.Valor IS NOT NULL
					) AS CHAR(6)) CNTR_NAVEVIAJE
			,CAST((
					SELECT VC.Codigo
					FROM FAC_CntDocumentoXCondicion CXC
					INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion
					WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
						AND CXC.Ident_Condicion = 31 --Tamaño Contenedor            
					) AS CHAR(2)) CNTR_TAMANIO
			,CAST(D.Usuario AS VARCHAR(30)) CNTR_USUARIO
			,CAST(CASE 
					WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante
						THEN 1
					ELSE 3
					END AS INT) CNTR_IDDOC
			,CAST(CASE 
					WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante
						THEN O.Sustento
					ELSE (
							SELECT CXC.Valor
							FROM FAC_CntDocumentoXCondicion CXC
							WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
								AND CXC.Ident_Condicion = 67 --Nave Viaje            
								AND CXC.Valor IS NOT NULL
							)
					END AS VARCHAR(6)) CNTR_NRODOC
			,CAST(NULL AS INT) CNTR_VALORIZA
			,CAST(dbo.FAC_FormatoCeroIzquierda(S.Numero, 3) + dbo.FAC_FormatoCeroIzquierda(D.Numero, 6) AS CHAR(9)) CNTR_FACTURA
			,CAST('0' AS CHAR(1)) CNTR_SERVEXTRA
			,CAST((
					SELECT VC.Codigo
					FROM FAC_CntDocumentoXCondicion CXC
					INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion
					WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
						AND CXC.Ident_Condicion = 17 --Línea            
					) AS VARCHAR(4)) CNTR_LINEA
			,CAST((
					SELECT VC.Codigo
					FROM FAC_CntDocumentoXCondicion CXC
					INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion
					WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
						AND CXC.Ident_Condicion = 33 --Condición Contenedor            
					) AS VARCHAR(2)) CNTR_CONDICION
			,CAST((
					SELECT VC.Codigo
					FROM FAC_CntDocumentoXCondicion CXC
					INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion
					WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
						AND CXC.Ident_Condicion = 30 --Tipo Contenedor            
					) AS VARCHAR(2)) CNTR_TIPO
			,CAST(CASE 
					WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante
						THEN O.Sustento
					ELSE (
							SELECT CXC.Valor
							FROM FAC_CntDocumentoXCondicion CXC
							WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
								AND CXC.Ident_Condicion = 67 --Nave Viaje            
								AND CXC.Valor IS NOT NULL
							)
					END AS VARCHAR(6)) CNTR_BL
			,CAST(NULL AS CHAR(4)) CNTR_PREMEMO
			,CAST(NULL AS CHAR(10)) CNTR_NROMEMO
			,CAST(NULL AS DATETIME) CNTR_VIGMEMO
			,CAST(S.Ident_Local AS INT) CNTR_LOCAL
			,CAST(0 AS INT) CNTR_FLGREINGRESO
		FROM FAC_Documento D
		INNER JOIN FAC_CntDocumento CNT ON CNT.Ident_Documento = D.Ident_Documento
		INNER JOIN FAC_Operacion O ON O.Ident_Operacion = D.Sustento
		INNER JOIN FAC_Serie S ON S.Ident_Serie = D.Ident_Serie
		WHERE CNT.Ident_Documento = @IdentDocumento

		DECLARE @cont INT
		DECLARE @max INT

		SET @cont = 1

		SELECT @max = COUNT(*)
		FROM @TABLA_CNT_GATEIN

		WHILE @cont <= @max
		BEGIN
			DECLARE @CNTR_CODIGO CHAR(11)
			DECLARE @CNTR_NAVEVIAJE CHAR(6)
			DECLARE @CNTR_TAMANIO CHAR(2)
			DECLARE @CNTR_USUARIO VARCHAR(30)
			DECLARE @CNTR_IDDOC INT
			DECLARE @CNTR_NRODOC VARCHAR(6)
			DECLARE @CNTR_VALORIZA INT
			DECLARE @CNTR_FACTURA CHAR(9)
			DECLARE @CNTR_SERVEXTRA CHAR(1)
			DECLARE @CNTR_LINEA VARCHAR(4)
			DECLARE @CNTR_CONDICION VARCHAR(2)
			DECLARE @CNTR_TIPO VARCHAR(2)
			DECLARE @CNTR_BL VARCHAR(25)
			DECLARE @CNTR_PREMEMO CHAR(4)
			DECLARE @CNTR_NROMEMO CHAR(10)
			DECLARE @CNTR_VIGMEMO DATETIME
			DECLARE @CNTR_LOCAL INT
			DECLARE @CNTR_FLGREINGRESO INT
			DECLARE @CNTR_IDCNTR INT

			SELECT @CNTR_CODIGO = CNTR_CODIGO
				,@CNTR_NAVEVIAJE = CNTR_NAVEVIAJE
				,@CNTR_TAMANIO = CNTR_TAMANIO
				,@CNTR_USUARIO = CNTR_USUARIO
				,@CNTR_IDDOC = CNTR_IDDOC
				,@CNTR_NRODOC = CNTR_NRODOC
				,@CNTR_VALORIZA = CNTR_VALORIZA
				,@CNTR_FACTURA = CNTR_FACTURA
				,@CNTR_SERVEXTRA = CNTR_SERVEXTRA
				,@CNTR_LINEA = CNTR_LINEA
				,@CNTR_CONDICION = CNTR_CONDICION
				,@CNTR_TIPO = CNTR_TIPO
				,@CNTR_BL = CNTR_BL
				,@CNTR_PREMEMO = CNTR_PREMEMO
				,@CNTR_NROMEMO = CNTR_NROMEMO
				,@CNTR_VIGMEMO = CNTR_VIGMEMO
				,@CNTR_LOCAL = CNTR_LOCAL
				,@CNTR_FLGREINGRESO = CNTR_FLGREINGRESO
			FROM @TABLA_CNT_GATEIN
			WHERE Row = @cont

			EXEC FAC_InsertarCntGateIn_PAGONET @CNTR_CODIGO
				,@CNTR_NAVEVIAJE
				,@CNTR_TAMANIO
				,@CNTR_USUARIO
				,@CNTR_IDDOC
				,@CNTR_NRODOC
				,@CNTR_VALORIZA
				,@CNTR_FACTURA
				,@CNTR_SERVEXTRA
				,@CNTR_LINEA
				,@CNTR_CONDICION
				,@CNTR_TIPO
				,@CNTR_BL
				,@CNTR_PREMEMO
				,@CNTR_NROMEMO
				,@CNTR_VIGMEMO
				,@CNTR_LOCAL
				,@CNTR_FLGREINGRESO
				,@CNTR_IDCNTR OUTPUT

			SET @cont = @cont + 1
		END
	END

	-- IF  @Condicion_Pagonet IS NOT NULL            
	-- AND @Condicion_CreditoPagonet IS NOT NULL            
	-- AND @Condicion_NumeroPrefacturaPagonet IS NOT NULL            
	-- BEGIN            
	--  BEGIN TRY            
	--   DECLARE @ISTI_DOCU varchar(3)            
	--   SET @ISTI_DOCU =            
	--    CASE WHEN @IdentTipoDocumento = @IdentTipoDocumento_Factura            
	--     THEN 'FAC'            
	--     ELSE 'BOL'            
	--    END            
	--            
	--   DECLARE @ISNU_DOCU varchar(20)            
	--   SET @ISNU_DOCU = dbo.FAC_FormatoCeroIzquierda(@Serie, 4) + '-' + dbo.FAC_FormatoCeroIzquierda(@Numero, 10)            
	--            
	--   DECLARE @Resultado_2 int, @Mensaje_2 varchar(255)                    
	--   --EXEC FAC_RegistrarAplicacionAnticipo_OFISIS @Cliente, @Condicion_NumeroPrefacturaPagonet, @Hoy, @Moneda, @Importe, '001', @Resultado_2 output, @Mensaje_2 output            
	--   EXEC FAC_RegistrarAplicacionAnticipo_OFISIS @ISTI_DOCU, @ISNU_DOCU, @Condicion_NumeroPrefacturaPagonet, @Resultado_2 output, @Mensaje_2 output            
	--   IF @Resultado_2 = 1            
	--    RAISERROR(@Mensaje_2, 11, 1)            
	--               
	--  END TRY            
	--  BEGIN CATCH            
	--   SET @MensajeError = ERROR_MESSAGE()            
	--   RAISERROR (@MensajeError, 11, 1)            
	--  END CATCH            
	-- END            
	/*Fin Pagonet*/
	IF @IdentTipoFacturacion IN (
			@TipoFacturacion_Descarga
			,@TipoFacturacion_Embarque
			,@TipoFacturacion_DevolucionCnt
			,@TipoFacturacion_RetiroCnt
			,@TipoFacturacion_OrdenServicioExpo
			,@TipoFacturacion_Balex
			,@TipoFacturacion_ForwarderFlat
			,@TipoFacturacion_OrdenServicioImpo
			,@TipoFacturacion_Vigencia
			,@TipoFacturacion_LineaVacios
			,@TipoFacturacion_OtroTerminal
			,0
			)
	BEGIN
		DECLARE @IdentCondicion_FechaIngresoCarga INT

		SET @IdentCondicion_FechaIngresoCarga = dbo.FAC_ObtenerParametro_Valor('IdentCondicion_FechaIngresoCarga')

		DECLARE @NroFac CHAR(9)

		SET @NroFac = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + dbo.FAC_FormatoCeroIzquierda(@Numero, 6)

		DECLARE @TipFac CHAR(3)

		SET @TipFac = CASE @IdentTipoFacturacion
				WHEN @TipoFacturacion_Descarga
					THEN 'FIM'
				WHEN @TipoFacturacion_Embarque
					THEN 'FDU'
				WHEN @TipoFacturacion_DevolucionCnt
					THEN 'FGI'
				WHEN @TipoFacturacion_RetiroCnt
					THEN 'FGO'
				WHEN @TipoFacturacion_OrdenServicioExpo
					THEN 'FSX'
				WHEN @TipoFacturacion_Balex
					THEN 'FBA'
				WHEN @TipoFacturacion_ForwarderFlat
					THEN 'FFI' ---Forwarder flat Impo           
				WHEN @TipoFacturacion_OrdenServicioImpo
					THEN 'FSE'
				WHEN @TipoFacturacion_Vigencia
					THEN CASE 
							WHEN @IdentTipoSustento = @IdentSustentoOperacion_Volante
								THEN 'FIM'
							ELSE 'FVI'
							END
				WHEN @TipoFacturacion_LineaVacios
					THEN 'FAL'
				END

		------IV--- 24/09/12--Forwarder flat Expo - Lo unico q lo diferencia es el ID de configuracion        
		IF @IdentTipoFacturacion = '12'
			AND @Ident_Configuracion_Expo = '104'
		BEGIN
			SET @TipFac = 'FFE' --- Forwarder Flat Expo        
		END ---      

		----IV 17/11/14 -Fact.Manual    
		IF @I030_Sustento = 94
		BEGIN
			SET @TipFac = 'FMA' --- Facturacion manual     
		END		

		---GTM - Fact. Adicional  
		IF @IdentTipoSustento = 192
		BEGIN
			SET @TipFac = 'FSA'
		END

		IF @IdentTipoSustento = 192 AND @I030_Sustento = 93
		BEGIN
			SET @TipFac = 'FOT'
		END

		DECLARE @TipDoc CHAR(2)

		SET @TipDoc = CASE 
				WHEN @IdentTipoDocumento = @IdentTipoDocumento_Factura
					THEN 'FA'
				ELSE 'BV'
				END

		DECLARE @FecAlm CHAR(8)

		IF @TipFac = 'FAL'
		BEGIN
			SELECT @FecAlm = CONVERT(CHAR(8), CONVERT(DATETIME, MIN(CXC.Valor), 120), 112)
			FROM FAC_CntDocumento CNT
			INNER JOIN FAC_CntDocumentoXCondicion CXC ON CXC.Ident_CntDocumento = CNT.Ident_CntDocumento
			WHERE CXC.Ident_Condicion = @IdentCondicion_FechaIngresoCarga
				AND CNT.Ident_Documento = @IdentDocumento
		END

		DECLARE @coddespa VARCHAR(15)

		SET @coddespa = CAST(@Despachador AS VARCHAR(15))

		DECLARE @esPagonet BIT

		IF @Condicion_Pagonet IS NULL
			SET @esPagonet = 0
		ELSE
			SET @esPagonet = 1

		BEGIN
			BEGIN TRY
				EXEC FAC_RegistrarPostFacturacion_NEP @NroFac
					,@TipDoc
					,@FecAlm
					,@TipFac
					,@coddespa
					,@GenerarOrden
					,@IdentDocumento
					,@esPagonet
			END TRY

			BEGIN CATCH
				SET @MensajeError = ERROR_MESSAGE()

				RAISERROR (
						@MensajeError
						,11
						,1
						)
			END CATCH
		END
	END

	--Registra Orden de Retiro en Citas y Facturacion            
	--Cambio Carga Suelta          
	SELECT @IdentTipoFacturacion_Operacion = CONF.Ident_TipoFacturacion
		,@IdentUnidadNegocio_Operacion = CONF.Ident_UnidadNegocio
	FROM Fac_Documento D
	INNER JOIN Fac_Operacion O ON D.Sustento = O.Ident_Operacion
	INNER JOIN FAC_CONFIGURACION CONF ON O.Ident_Configuracion = CONF.Ident_Configuracion
	WHERE D.IDENT_Documento = @IdentDocumento

	--IF (@GenerarOrden =1 AND @IdentTipoFacturacion=2 AND @IdentConfiguracion in (91,92,95,96)   ) --cambio          
	IF (
			@GenerarOrden = 1
			AND @IdentTipoFacturacion_Operacion = @TipoFacturacion_Descarga
			AND (
				@IdentUnidadNegocio_Operacion = @IdentUnidadNegocio_Forwarders
				OR @IdentUnidadNegocio_Operacion = @IdentUnidadNegocio_CargaProyectos
				)
			)
	BEGIN
		EXEC FAC_RegistrarOrdenRetiroBulto @IdentDocumento
	END
	ELSE
	BEGIN
		EXEC FAC_RegistrarOrdenRetiroContenedor @IdentDocumento

		----17/05/13      
		EXEC FAC_RegularizaOR_Contenedores_tercero_PostFact @IdentDocumento ---**        
	END
END	
GO
/****** Object:  StoredProcedure [dbo].[sp_ListaFacturas_OfisisAutomatizacion_Comisiones_291214_01]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER PROCEDURE [dbo].[sp_ListaFacturas_OfisisAutomatizacion_Comisiones_291214_01]                              
@fechaInicio varchar(50),                              
@FechaFin varchar(50),                              
@Parametro VARCHAR(3)                              
as                              
                            
set @fechaInicio = @fechaInicio +  ' 00:00:00'                            
set @FechaFin = @FechaFin +  ' 23:59:59'                            
                            
SET @Parametro = LTRIM(RTRIM(@Parametro))            
                            
If @Parametro = '1' --BD CALLAO (calw3bdsgc/Neptunia_sgc_produccion)                            
BEGIN                            
    select  distinct                             
    --(select dbo.FAC_FormatoCeroIzquierda(se.numero, 4) + '-0' + dbo.FAC_FormatoCeroIzquierda(d.numero, 9)) as [NroFactura],    
    --(select ISNULL(REPLICATE('0',4 - LEN(se.numero)),'') + CAST(se.numero as varchar) + '-0' + ISNULL(REPLICATE('0',9 - LEN(d.numero)),'') + CAST(d.numero as varchar))as [NroFactura],                              
      
  (CASE  
  WHEN len(se.numero)=2  
  THEN  
  (select ISNULL(REPLICATE('0',4 - LEN(se.numero)),'') +   
  CAST(se.numero as varchar) + '-0' + ISNULL(REPLICATE('0',9 - LEN(d.numero)),'') +   
  CAST(d.numero as varchar))    
  WHEN len(se.numero)>2 AND se.ident_TipoDocumento in (1,2)  
  THEN  
   left(td.nombre,1) +  
  (CAST(se.numero as varchar) + '-0' + ISNULL(REPLICATE('0',9 - LEN(d.numero)),'') +   
  CAST(d.numero as varchar))   
  END )   AS [NroFactura],  
        
    CONVERT(char(10), d.emision,126) AS [FechaEmision],                              
     d.emision,                              
    d.ident_cliente as [ClienteFacturado],                              
    cli.razonSocial,                              
    TF.Nombre TipoFacturacion,                                
    UN.Nombre UnidadNegocio,                              
    --CO.nombre Concepto,                          
                              
    (CASE                           
    WHEN CONF.Ident_Configuracion in(2,78,80,90,1,91) THEN 'FWD IMPO FC'                          
    WHEN CONF.Ident_Configuracion in(31,129,32,33,34,35,36,92,109,126,97,110,128) THEN 'FWD IMPO LC'                          
    WHEN CONF.Ident_Configuracion in(4,3) THEN 'FWD EXPO FC'                          
    WHEN CONF.Ident_Configuracion in(88,89,105,127,106,37,118,119,120,121) THEN 'FWD EXPO LC'                          
    END )as [CONCEPTO] ,                          
                                 
                              
    Lo.Cod_Ofisis as [LocalOFISIS],                              
    LO.Nombre as [Local],  --Devuelve : C.Logistico, Villegas, Ventanilla                            
    td.nombre as [TipoDocumento],                              
    (select distinct do4.codigo                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento                              
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                              
    inner join fac_valorCondicion do4 on do4.ident_valorCondicion = do3.ident_ValorCondicion                              
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 21) as [RucConsolidadora],                              
    (select distinct do4.nombre                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento                              
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                              
    inner join fac_valorCondicion do4 on do4.ident_valorCondicion = do3.ident_ValorCondicion                              
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 21) as [Consolidadora],                              
    --cd.codigo,                           
                              
    (CASE WHEN len(cd.codigo) > 20                                      
    THEN (select top 1 isnull(codcon04,'') from Terminal.dbo.drblcont15 where nrocon12 = cdc3.valor)                          
    ELSE cd.codigo                                 
   END )as [Carga] ,                          
         
 /*COD_ORIGENOFISIS ES VARCHAR*/                            
    (CASE                         
    WHEN SER.COD_ORIGENOFISIS = '100177' AND CONF.Ident_TipoFacturacion = 4 THEN '100106'                             
    WHEN SER.COD_ORIGENOFISIS = '100178' AND CONF.Ident_TipoFacturacion = 4 THEN '100605'                             
    ELSE SER.COD_ORIGENOFISIS            
   END )as [ServicioOFISIS] ,                         
                 
    /*COD_ORIGENOFISIS ES VARCHAR*/                        
    (CASE                         
    WHEN SER.COD_ORIGENOFISIS = '100177' AND CONF.Ident_TipoFacturacion = 4 THEN (select NombreServicio from ser_servicio where cod_origenOfisis = '100106')                             
    WHEN SER.COD_ORIGENOFISIS = '100178' AND CONF.Ident_TipoFacturacion = 4 THEN (select NombreServicio from ser_servicio where cod_origenOfisis = '100605')                             
    ELSE SER.NombreServicio                                      
   END )as [NombreServicio] ,                            
                                 
    --SER.COD_ORIGENOFISIS AS [ServicioOFISIS],                              
    --SER.NombreServicio,                                
                            
   -- cid.Importe as [ImporteCargaServicio],                      
                          
     (CASE                           
    WHEN CONF.Ident_Configuracion in(31,129,32,33,34,35,36,92,109,126,97,110,128) THEN ID.importe    --IMPO LC                      
    WHEN CONF.Ident_Configuracion in(88,89,105,127,106,37,118,119,120,121) THEN ID.importe  --EXPO LC                      
    ELSE cid.Importe                        
    END )as [ImporteCargaServicio],                      
                          
                              
    (CASE WHEN SER.I003_MONEDA = 10                                      
    THEN 'SOL'  --10                                     
    ELSE 'DOL'  --12                                    
   END )as [MonedaServicio] ,                              
    (select distinct do3.valor                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento                              
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                              
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 10) as  booking,--booking                              
    cdc3.valor as [BillofLading],                            
                                
    (select distinct do4.nombre                               
    from fac_cntDocumento do1                               
    inner join fac_cntDocumentoxCondicion do3 on do3.ident_cntDocumento = do1.ident_cntDocumento                              
    inner join fac_valorCondicion do4 on do4.ident_valorCondicion = do3.ident_ValorCondicion                              
    where                               
    do1.ident_Cntdocumento = cd.ident_Cntdocumento and do3.ident_condicion = 31) as  TamañoContenedor,--nave                              
                                
    (select distinct do4.codigo                               
    from fac_cntDocumento do1                               
    inner join fac_cntDocumentoxCondicion do3 on do3.ident_cntDocumento = do1.ident_cntDocumento                              
    inner join fac_valorCondicion do4 on do4.ident_valorCondicion = do3.ident_ValorCondicion                              
    where                               
    do1.ident_Cntdocumento = cd.ident_Cntdocumento and do3.ident_condicion = 30) as  TipoContenedor,--nave                              
                     
     (select distinct do3.valor                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento                              
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                    
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 14) as  Nave,                
                    
     (select distinct do3.valor                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento                              
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                              
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 15) as  Viaje                
                       
    --cdc4.valor as Nave,                    
    --cdc5.valor as Viaje                    
                    
                    
   into #tmp_table                    
   from                               
    fac_documento d                               
    inner join fac_serie se on d.ident_serie = se.ident_serie                              
    left join fac_operacion o on o.ident_operacion = d.sustento                              
    left join FAC_Configuracion CONF ON CONF.Ident_Configuracion = o.Ident_Configuracion                                
    left join FAC_TipoFacturacion TF ON CONF.Ident_TipoFacturacion = TF.Ident_TipoFacturacion                                
    left join SER_CentroCosto UN ON CONF.Ident_UnidadNegocio = UN.Cod_CentroCosto                                
    left join FAC_Concepto CO ON CONF.Ident_Concepto = CO.Ident_Concepto                                
    left join TAR_Local LO ON CONF.Ident_Local = LO.Cod_Local                               
    inner join fac_cliente cli on cli.ruc=d.ident_cliente                              
    inner join fac_CNTDOCUMENTO CD on cd.ident_documento =d.ident_documento                              
    inner join fac_tipodocumento td on td.ident_tipoDocumento = se.ident_tipoDocumento                              
    inner Join fac_ItemDocumento ID on d.ident_documento = ID.ident_documento                              
    inner Join ser_servicio SER on ser.ident_servicio = ID.ident_servicio                              
    inner join FAC_CntDocumentoXItemDocumento cid on (cid.ident_cntDocumento = cd.ident_cntDocumento and id.ident_itemDocumento = cid.ident_itemDocumento)                              
                              
    left join dbo.fac_cntDocumento as cd3 with(nolock) on d.ident_documento = cd3.ident_documento                          
    left join dbo.fac_cntDocumentoxCondicion as cdc3  with(nolock) on (cd3.ident_cntDocumento = cdc3.ident_cntDocumento and cdc3.ident_condicion=11)                          
                        
    --left join dbo.fac_cntDocumento as cd4 with(nolock) on d.ident_documento = cd4.ident_documento                          
    --left join dbo.fac_cntDocumentoxCondicion as cdc4  with(nolock) on (cd4.ident_cntDocumento = cdc4.ident_cntDocumento and cdc4.ident_condicion=14)                          
    --left join dbo.fac_cntDocumento as cd5 with(nolock) on d.ident_documento = cd5.ident_documento                          
    --left join dbo.fac_cntDocumentoxCondicion as cdc5  with(nolock) on (cd5.ident_cntDocumento = cdc5.ident_cntDocumento and cdc5.ident_condicion=15)                          
                              
   where                       
    d.I023_Estado in (71,72)                               
    and (d.emision >= @fechaInicio and d.emision <= @FechaFin)                              
    --and td.ident_tipoDocumento=2                             
    and o.Ident_Configuracion is not null                              
    and TF.ident_tipoFacturacion in(2,4) -- Importacion/Exportacion                              
    and d.I030_SUstento=93                            
    and                               
    (select distinct do4.codigo                               
    from fac_documento do1                               
    inner join fac_cntDocumento do2 on do1.ident_documento = do2.ident_documento         
    inner join fac_cntDocumentoxCondicion do3 on do2.ident_cntDocumento = do3.ident_cntDocumento                              
    inner join fac_valorCondicion do4 on do4.ident_valorCondicion = do3.ident_ValorCondicion                              
    where                               
    do1.ident_documento = d.ident_documento and do3.ident_condicion = 21) is not null  
    --and d.numero = '0000112484'                            
    order by d.ident_cliente,d.emision desc                              
           
             
         
   Update #tmp_table        
   set        
   booking = c.bkgcom13        
   from  Descarga.dbo.dqnavier08 a        
   inner join Descarga.dbo.DDCABMAN11 b on (a.codnav08=b.codnav08)        
   inner join Descarga.dbo.EDBOOKIN13 c on (b.navvia11=c.navvia11)        
   where desnav08=Nave and numvia11=Viaje and bookin13=booking        
                    
            select * from #tmp_table        
                      
  RETURN                            
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_ActualizaEstadoServicio_Ofisis_Gesfor]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ActualizaEstadoServicio_Ofisis_Gesfor]
AS
BEGIN
	UPDATE SER_ServicioDetalle
	SET I002_EstadoServicio = 15

	SELECT DET.Ident_ServicioDetalle
		,SER.Cod_OrigenOfisis CO_SERV
		,SER.Cod_OrigenServicio DC_SERVICIO
		,DET.Cod_Local dc_sucursal_imputacion
		,DET.Cod_CentroCosto dc_centro_costo_imputacion
		,CASE DET.Detraccion
			WHEN 1
				THEN 'S'
			ELSE 'N'
			END dm_detraccion
		,CASE DET.AfectoIgv
			WHEN 1
				THEN 'SI'
			ELSE 'NO'
			END afecto_igv
		,CAST((DET.PrcDetraccion) * 100 AS INT) dc_porcentaje_detraccion
	INTO #TEMP01
	FROM SER_Servicio SER(NOLOCK)
	INNER JOIN SER_ServicioDetalle DET(NOLOCK) ON SER.Ident_Servicio = DET.Ident_Servicio

	--WHERE SER.Cod_OrigenOfisis ='100134'
	--ORDER BY DET.Cod_Local,DET.Cod_CentroCosto
	-----------------------------------------------------------------
	SELECT T2.CO_SERV
		,t2.DC_SERVICIO
		,t3.DC_SUCURSAL AS dc_sucursal_imputacion
		,t4.DC_CENTRO_COSTO AS dc_centro_costo_imputacion
		,t1.[dm_detraccion]
		,t1.[afecto_igv]
		,ISNULL(t1.[dc_porcentaje_detraccion],0) AS dc_porcentaje_detraccion
	INTO #TEMP02
	FROM [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1
	INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 ON t1.[CO_EMPR] = t2.[CO_EMPR]
		AND t2.CO_SERV = t1.CO_SERV
	INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 ON t3.CO_TIEN = t1.CO_TIEN
		AND t3.CO_UNID = t1.CO_UNID
		AND t3.CO_EMPR = t1.CO_EMPR
	INNER JOIN [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 ON t4.CO_UNNE = t1.CO_UNNE
		AND t4.CO_EMPR = t1.CO_EMPR
	WHERE t1.[CO_EMPR] = '16'
		AND T2.TI_SITU = 'ACT' --AND T2.CO_SERV='100134'

	-----------------------------------------------------------------
	--SELECT * FROM #TEMP01 --Gesfor
	--SELECT * FROM #TEMP02 --Ofisis
	UPDATE SER_ServicioDetalle
	SET I002_EstadoServicio = 14
	WHERE Ident_ServicioDetalle IN (
			SELECT B.IDENT_SERVICIODETALLE
			FROM #TEMP02 A
			INNER JOIN #TEMP01 B ON A.CO_SERV = B.CO_SERV
				AND A.DC_SERVICIO = B.DC_SERVICIO
				AND A.dc_sucursal_imputacion = B.dc_sucursal_imputacion
				AND A.dc_centro_costo_imputacion = B.dc_centro_costo_imputacion
				AND A.dm_detraccion = B.dm_detraccion
				AND A.afecto_igv = B.afecto_igv
				AND A.dc_porcentaje_detraccion = b.dc_porcentaje_detraccion
			)

	DROP TABLE #TEMP01
	DROP TABLE #TEMP02

END
GO
/****** Object:  StoredProcedure [dbo].[usp_IntN4_ObtenerVesselVisitd]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_IntN4_ObtenerVesselVisitd] (@pvch_nrosec23 CHAR(6))
AS
BEGIN
	DECLARE @VESSELVISITID varchar(200)
	
	SELECT @VESSELVISITID=ISNULL(VESSELVISITID,'')  
	FROM DDVOLDES23 A 
	INNER JOIN DDCABMAN11 B ON A.navvia11=B.navvia11
	WHERE A.nrosec23=@pvch_nrosec23
	
	SELECT @VESSELVISITID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerQuiebre_OfisisDPW]    Script Date: 20/03/2019 02:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerQuiebre_OfisisDPW]
AS
BEGIN
	DELETE FROM TMCLIE_NEPT
	
	INSERT INTO TMCLIE_NEPT
	SELECT * FROM [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT 
END
GO
