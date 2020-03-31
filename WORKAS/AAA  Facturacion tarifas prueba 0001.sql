USE [Neptunia_SGC_Produccion]
GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerTarifa_GrupoTarifa_Valorizacion]    Script Date: 06/01/2015 13:32:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Autor: Victor Clerque    
-- Objetivo: Obtiene las tarifas de los grupos de tarifa para la valorización    
-- Valores de Prueba:    
-- Fecha de Creacion: 21/08/2009    
-- Fecha de Modificacion :    
--      
-- =============================================    
ALTER PROCEDURE [dbo].[FAC_ObtenerTarifa_GrupoTarifa_Valorizacion]    
    (@ListGrupoTarifa xml,@IdentConfiguracion int,@IdentCliente nvarchar(20))    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 DECLARE @DiaAsumeNeptunia_Inicio int    
 SET @DiaAsumeNeptunia_Inicio = dbo.FAC_ObtenerParametro_Valor('IdentDiaAsumeNeptunia_Inicio');    
    
 DECLARE @docHandle int    
 EXEC sp_xml_preparedocument @docHandle output, @ListGrupoTarifa    
 SELECT  gc.Ident_Cotizacion,    
   gc.Ident_GrupoCotizacion AS Ident_GrupoTarifa,    
   t.Ident_Tarifa,    
   sd.Ident_Servicio,    
   sd.Cod_CentroCosto AS Ident_UnidadNegocio,    
   sd.Cod_Local AS Ident_Local,    
   tc.Precio AS Tarifa,    
   CASE    
    WHEN t.PrecioEntidad IS NULL THEN tc.PeriodoLibres    
    WHEN tcl.NroHorasLibres IS NULL THEN t.PeriodoLibres    
    ELSE tcl.NroHorasLibres    
   END AS PeriodoLibre,    
   t.Constante AS Intervalo,    
   tc.Variables AS Variable,    
   t.TipoEntidad AS TipoCondicion,    
   CASE    
    WHEN t.IdTarifaFacturar IS NULL THEN t.PrecioEntidad    
    ELSE tf.PrecioEntidad    
   END AS PrecioCondicion,    
   t.NroHorasAsumeNeptunia AS PeriodoLibreCondicion,    
   CASE    
    WHEN t.HorasAsumeNeptunia = @DiaAsumeNeptunia_Inicio THEN 1 ELSE 0    
   END AS InicioLibreCondicion,    
   CASE    
    WHEN t.IdTarifaFacturar IS NULL THEN sd.Ident_Servicio    
    ELSE sdf.Ident_Servicio    
   END AS Ident_ServicioPrefactura,    
   CASE    
    WHEN t.IdTarifaFacturar IS NULL THEN sd.Cod_CentroCosto    
    ELSE sdf.Cod_CentroCosto    
   END AS Ident_UnidadNegocioPrefactura,    
   CASE    
    WHEN t.IdTarifaFacturar IS NULL THEN sd.Cod_Local    
    ELSE sdf.Cod_Local    
   END AS Ident_LocalPrefactura,  
t.ValorMinimo, t.ValorMaximo  
 FROM TAR_GrupoCotizacion gc    
 INNER JOIN OPENXML (@docHandle, '/ROOT/GrupoTarifa',1) WITH (Ident_GrupoTarifa int) x ON x.Ident_GrupoTarifa = gc.Ident_GrupoCotizacion    
 INNER JOIN TAR_TarifaCotizacion tc ON tc.Ident_GrupoCotizacion = gc.Ident_GrupoCotizacion    
 INNER JOIN TAR_Tarifa t ON tc.Ident_Tarifa = t.Ident_Tarifa    
 INNER JOIN SER_ServicioDetalle sd ON t.Ident_ServicioDetalle = sd.Ident_ServicioDetalle    
 INNER JOIN FAC_ConfiguracionXImputacion fci ON fci.Ident_Servicio = sd.Ident_Servicio AND fci.Ident_UnidadNegocio = sd.Cod_CentroCosto AND fci.Ident_Local = sd.Cod_Local    
 LEFT JOIN TAR_TarifaCliente tcl ON tcl.Ident_Tarifa = t.Ident_Tarifa AND tcl.RUC_Cliente COLLATE DATABASE_DEFAULT = @IdentCliente COLLATE DATABASE_DEFAULT AND tcl.Estado = 1    
 LEFT JOIN TAR_Tarifa tf ON t.IdTarifaFacturar = tf.Ident_Tarifa    
 LEFT JOIN SER_ServicioDetalle sdf ON tf.Ident_ServicioDetalle = sdf.Ident_ServicioDetalle    
 LEFT JOIN TAR_TarifaCliente tclf ON tclf.Ident_Tarifa = tf.Ident_Tarifa AND tclf.RUC_Cliente COLLATE DATABASE_DEFAULT = @IdentCliente COLLATE DATABASE_DEFAULT AND tclf.Estado = 1    
 WHERE tc.Estado = 1    
  AND fci.Ident_Configuracion = @IdentConfiguracion    
 EXEC sp_xml_removedocument @docHandle     
END    
/*---------------------------------------------------------------------------------------------*/    
SET ANSI_NULLS ON    
SET QUOTED_IDENTIFIER ON    
    
    