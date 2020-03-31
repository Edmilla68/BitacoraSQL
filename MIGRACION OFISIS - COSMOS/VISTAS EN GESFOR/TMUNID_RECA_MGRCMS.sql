USE [Neptunia_SGC_Produccion]
GO

/*****************************************************************************************************/
/****** Object:  View [dbo].[TMUNID_RECA_MGRCMS]    Script Date: 12/13/2017 09:46:39            ******/
/****** CREADO 12/13/2017																        ******/
/****** EDUARDO MILLA																	        ******/
/****** PARA MIGRACION																	        ******/
/*****************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[TMUNID_RECA_MGRCMS] As 
/*** VISTA DE SUCURSAL ***/     
Select [CO_UNID], [CO_EMPR], [DE_UNID], [TI_AUXI_EMPR], [CO_AUXI_EMPR],      
       [SUCCON01], [CODSED01], [FLGACT01],      
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]      
From   [COSMOS-DATA].[OFIRECA].[dbo].[TMUNID_RECA]      
WHERE  [CO_EMPR] = '01'  
GO

