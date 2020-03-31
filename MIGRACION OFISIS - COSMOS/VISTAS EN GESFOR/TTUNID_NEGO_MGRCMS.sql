USE [Neptunia_SGC_Produccion]
GO

/******************************************************************************************/
/****** Object:  View [dbo].[TTUNID_NEGO_MGRCMS]    Script Date: 12/13/2017 09:53:27 ******/
/****** CREADO 12/13/2017		  										             ******/
/****** EDUARDO MILLA														         ******/
/****** PARA MIGRACION														         ******/
/******************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  View [dbo].[TTUNID_NEGO_MGRCMS]
As      
/*** VISTA DE CENTRO DE COSTO***/
SELECT [dc_centro_costo], [DE_UNNE] as dg_centro_costo, [CO_UNNE], [CO_EMPR],  [CO_DINE],      
       [dc_division_negocio], [df_inicio_vigencia],      
       [df_termino_vigencia], [dg_alias_centro_costo],      
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]      
FROM   [COSMOS-DATA].[OFIRECA].[dbo].[TTUNID_NEGO]    
WHERE  [CO_EMPR] = '01' 
GO

