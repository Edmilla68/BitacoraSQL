USE [ERH_DESARROLLO]
GO

/****** Object:  View [dbo].[REPV_CTAS_CTES]    Script Date: 26/06/2017 12:48:33 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[REPV_CTAS_CTES]
AS

SELECT P.Cod_personal,
	   P.cod_trabajador,
       DP.apellido_p+' '+DP.apellido_m+' '+DP.nombres as trabajador,
       CC.nombre as Concepto_nombre,
       CC.fecha as CtaCte_fecha,
       CC.cod_moneda as CtaCte_moneda,
       M.simbolo as simbolo,
       CC.monto as CtasCtes_Personal_monto,
       CC.saldo as CtasCtes_Personal_saldo,
       CC.monto  - CC.saldo  AS CtasCtes_Personal_CANCELADO,
       CC.numero as CtaCte_numero,
       CCP.cuota as CtaCte_Progcuota,
       CCP.fecha as CtaCte_Progfecha,
       CCP.monto as CtaCte_Progrmonto,
   	   CC.anulado, 
   	   Case CCP.estado When 'P' Then 'Pendiente' When 'C' Then 'Cancelado' When 'A' Then 'Anulado' Else '' End 'estado_CC',

   	   p.Cod_Empresa,
   	   PY.Cod_proyecto,
   	   PY.Descripcion AS proyecto,
   	   sge_centro_costo_master.Cod_centro_costo,
   	   sge_centro_costo_master.Descripcion as ccosto,
   	   sge_areas.Cod_area,
   	   sge_areas.Descripcion as area,
   	   UN.Cod_unidad_negocio,
   	   UN.Descripcion unegocio,
   	   sge_localidades.Cod_localidad,
   	   sge_localidades.Descripcion as localidad,
   	   tp.cod_tipo_planilla,
   	   tp.Nombre as planilla,
   	   p.estado,
   	   SGE_Cargo.nombre as cargo 
   	   
   	   
		
FROM SGE_V_CtasCtes_Personal CC


       INNER JOIN sge_personal P 
			ON P.cod_empresa = CC.cod_empresa 
				AND P.cod_personal = CC.cod_personal
       INNER JOIN sge_datos_personales DP 
			ON DP.cod_tipo_entidad = P.cod_tipo_entidad 
				AND DP.cod_entidad = P.cod_entidad
       INNER JOIN sge_monedas M 
			ON M.cod_moneda = CC.cod_moneda
       INNER JOIN sge_ctasctes_programacion CCP 
			ON CCP.cod_empresa = CC.cod_empresa 
				AND CCP.cod_personal = CC.cod_personal 
				AND CCP.tipo_concepto = CC.tipo_concepto 
				AND CCP.cod_concepto = CC.cod_concepto 
				AND CCP.numero = CC.numero
       
       LEFT OUTER JOIN sge_tipo_planilla TP 
			ON TP.cod_tipo_planilla = P.cod_tipo_planilla
       LEFT OUTER JOIN sge_proyectos PY 
			ON PY.cod_empresa = P.cod_empresa 
				AND PY.cod_proyecto = P.cod_proyecto
       LEFT OUTER JOIN sge_unidades_negocio UN 
			ON UN.cod_empresa = P.cod_empresa 
				AND UN.cod_unidad_negocio = P.cod_unidad_negocio
       LEFT OUTER JOIN sge_centro_costo_master 
			ON sge_centro_costo_master.cod_empresa = P.cod_empresa 
				AND sge_centro_costo_master.cod_centro_costo = P.cod_centro_costo
       LEFT OUTER JOIN sge_areas 
			ON sge_areas.cod_empresa = P.cod_empresa 
				AND sge_areas.cod_area = P.cod_area
       LEFT OUTER JOIN sge_localidades 
			ON sge_localidades.cod_empresa = P.cod_empresa 
				AND sge_localidades.cod_localidad = P.cod_localidad
				
LEFT JOIN SGE_Cargo 
	ON SGE_Cargo.cod_cargo = P.cod_cargo 				

GO