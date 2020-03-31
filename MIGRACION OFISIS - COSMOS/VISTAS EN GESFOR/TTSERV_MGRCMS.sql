USE [Neptunia_SGC_Produccion]
GO

/*****************************************************************************************************/
/****** Object:  View [dbo].[TTSERV_MGRCMS]    Script Date: 12/13/2017 09:46:39					******/
/****** CREADO 12/13/2017																        ******/
/****** EDUARDO MILLA																	        ******/
/****** PARA MIGRACION																	        ******/
/*****************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[TTSERV_MGRCMS] As
/*** ESTE ES EL MAESTRO DE SERVICIO ***/      
SELECT [dc_servicio], [DE_SERV] as dg_servicio, [CO_SERV],       
       [dg_servicio_ingles], [dc_moneda_servicio],      
       [df_vigencia_inicio], [df_vigencia_termino],      
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]      
FROM   [COSMOS-DATA].[OFIRECA].[dbo].[TTSERV]      
WHERE CO_EMPR = '01'  
  

GO

