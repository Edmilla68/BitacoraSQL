USE [Neptunia_SGC_Produccion]
GO

/*****************************************************************************************************/
/****** Object:  View [dbo].[TMTIEN_MGRCMS]    Script Date: 12/13/2017 09:46:39				    ******/
/****** CREADO 12/13/2017																        ******/
/****** EDUARDO MILLA																	        ******/
/****** PARA MIGRACION																	        ******/
/*****************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[TMTIEN_MGRCMS] 
AS      
/*** VISTA DE LOCAL***/
SELECT [DC_SUCURSAL], [DE_TIEN] as dg_sucursal, [CO_TIEN], [CO_UNID], [CO_EMPR], [DE_TIEN], [DE_TIEN_LARG], [DE_DIRE], [CO_UBIC_GEOG],      
       [DE_CIUD], [DE_DPTO], [CO_PAIS], [NU_TLF1], [NU_TLF2], [NU_FAXS], [DE_DIRE_MAIL],      
       [TI_AUXI_EMPR], [CO_AUXI_EMPR], [NU_SERI_NCON], [CO_VEND_DEFA], [CO_CLIE_DEFA],      
       [ST_PUNT_VENT], [DG_ALIAS_SUCURSAL], [DF_VIGENCIA_INICIO], [DF_VIGENCIA_TERMINO],      
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]      
FROM   [COSMOS-DATA].[OFIRECA].[dbo].[TMTIEN]     
WHERE  [CO_EMPR] = '01'  
GO

