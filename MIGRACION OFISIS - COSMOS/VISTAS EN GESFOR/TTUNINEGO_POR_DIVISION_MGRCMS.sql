USE [Neptunia_SGC_Produccion]
GO

/*****************************************************************************************************/
/****** Object:  View [dbo].[TTUNINEGO_POR_DIVISION_MGRCMS]    Script Date: 12/13/2017 09:46:39 ******/
/****** CREADO 12/13/2017																        ******/
/****** EDUARDO MILLA																	        ******/
/****** PARA MIGRACION																	        ******/
/*****************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE VIEW [dbo].[TTUNINEGO_POR_DIVISION_MGRCMS]
AS

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
[COSMOS-DATA].ofireca.dbo.TTDIVI_NEGO b
where a.co_empr = '01'
and a.co_empr = b.co_empr
and a.co_dine = b.co_dine
GO

