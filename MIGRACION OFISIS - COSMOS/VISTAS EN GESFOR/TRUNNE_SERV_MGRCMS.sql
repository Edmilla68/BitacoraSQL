USE [Neptunia_SGC_Produccion]
GO

/*****************************************************************************************************/
/****** Object:  View [dbo].[TRUNNE_SERV_MGRCMS]    Script Date: 12/13/2017 09:46:39			******/
/****** CREADO 12/13/2017																        ******/
/****** EDUARDO MILLA																	        ******/
/****** PARA MIGRACION																	        ******/
/*****************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[TRUNNE_SERV_MGRCMS] As  
/*** VISTA DEL DETALLE DEL SERVICIO***/       
SELECT t2.DC_SERVICIO, t3.DC_SUCURSAL as dc_sucursal_imputacion,           
                t4.DC_CENTRO_COSTO as dc_centro_costo_imputacion,          
       t1.[dm_detraccion], t1.[afecto_igv], t1.[df_inicio_vigencia], t1.[df_final_vigencia],          
       t1.[dc_porcentaje_detraccion],          
       t1.[CO_ACTI_DETR], t1.[CO_TIPO_DETR]          
From   [COSMOS-DATA].[OFIRECA].[dbo].[TRUNNE_SERV] t1          
       Inner Join [CALW3ERP001].[OFIRECA].[dbo].[TTSERV] t2 On          
       (      t1.[CO_EMPR] = t2.[CO_EMPR]   
    And    t2.CO_SERV = t1.CO_SERV )          
       Inner Join [CALW3ERP001].[OFIRECA].[dbo].[TMTIEN] t3 On          
       (      t3.CO_TIEN = t1.CO_TIEN          
       And    t3.CO_UNID = t1.CO_UNID          
       And    t3.CO_EMPR = t1.CO_EMPR )          
       Inner Join [CALW3ERP001].[OFIRECA].[dbo].[TTUNID_NEGO] t4 On          
       (      t4.CO_UNNE = t1.CO_UNNE          
       And    t4.CO_EMPR = t1.CO_EMPR )      
WHERE  t1.[CO_EMPR] = '01' 
GO

