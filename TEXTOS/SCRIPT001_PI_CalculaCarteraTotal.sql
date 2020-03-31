USE [EFECTIVA]
GO
/****** Object:  Table [dbo].[Personas]    Script Date: 06/28/2017 10:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Personas](
	[NroOrden] [int] NOT NULL,
	[NumDocumento] [varchar](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CodTipoDocumento] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ApePaterno] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[ApeMaterno] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[ApeCasada] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[PriNombre] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[SegNombre] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[FecNacimiento] [date] NULL,
	[EdadActual] [int] NULL,
	[Genero] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
	[CodFteRegistro] [char](3) COLLATE Modern_Spanish_CI_AS NULL,
	[CodUbigeo] [varchar](8) COLLATE Modern_Spanish_CI_AS NULL,
	[FecUltimoReporteRCC] [date] NULL,
	[FlgUbigeoDefault] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
	[CodUbigeoOriginal] [char](6) COLLATE Modern_Spanish_CI_AS NULL,
	[CodEstadoCivil] [tinyint] NULL,
	[CodGradoInstruccion] [tinyint] NULL,
	[CodEstadoPersona] [tinyint] NULL,
 CONSTRAINT [PK_Personas] PRIMARY KEY CLUSTERED 
(
	[NumDocumento] ASC,
	[CodTipoDocumento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'IDX_NroOrden')
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NroOrden] ON [dbo].[Personas] 
(
	[NroOrden] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'idx_Personas')
CREATE NONCLUSTERED INDEX [idx_Personas] ON [dbo].[Personas] 
(
	[CodUbigeo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'idx_Personas_nrodoc')
CREATE NONCLUSTERED INDEX [idx_Personas_nrodoc] ON [dbo].[Personas] 
(
	[NumDocumento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'IdxPriNombre')
CREATE NONCLUSTERED INDEX [IdxPriNombre] ON [dbo].[Personas] 
(
	[PriNombre] ASC,
	[SegNombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'iux_Personas')
CREATE UNIQUE NONCLUSTERED INDEX [iux_Personas] ON [dbo].[Personas] 
(
	[NumDocumento] ASC,
	[CodTipoDocumento] ASC,
	[NroOrden] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'IUX_PersonasNDTD')
CREATE UNIQUE NONCLUSTERED INDEX [IUX_PersonasNDTD] ON [dbo].[Personas] 
(
	[NroOrden] ASC
)
INCLUDE ( [NumDocumento],
[CodTipoDocumento]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'iux_PersonasNO')
CREATE UNIQUE NONCLUSTERED INDEX [iux_PersonasNO] ON [dbo].[Personas] 
(
	[NroOrden] ASC
)
INCLUDE ( [NumDocumento],
[CodTipoDocumento],
[FecNacimiento],
[Genero],
[CodUbigeo],
[FecUltimoReporteRCC]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'iux_PersonasTD')
CREATE UNIQUE NONCLUSTERED INDEX [iux_PersonasTD] ON [dbo].[Personas] 
(
	[CodTipoDocumento] ASC,
	[NumDocumento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Personas]') AND name = N'iux_PersonasTDNDNO')
CREATE UNIQUE NONCLUSTERED INDEX [iux_PersonasTDNDNO] ON [dbo].[Personas] 
(
	[CodTipoDocumento] ASC,
	[NumDocumento] ASC,
	[NroOrden] ASC
)
INCLUDE ( [FecNacimiento],
[Genero],
[CodUbigeo]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [ANALITICA]
GO
/****** Object:  Table [dbo].[Maduracion_Creditos]    Script Date: 06/28/2017 10:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Maduracion_Creditos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Maduracion_Creditos](
	[Año] [int] NULL,
	[Mes] [int] NULL,
	[cod_credito] [bigint] NOT NULL,
	[Sistema] [char](3) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_agencia] [int] NULL,
	[T2M] [int] NULL,
	[T3M] [int] NULL,
	[T6M] [int] NULL,
	[T9M] [int] NULL,
	[T12M] [int] NULL,
	[FecCorte] [date] NULL,
 CONSTRAINT [PK_MaduracionCreditos] PRIMARY KEY CLUSTERED 
(
	[cod_credito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
USE [PROCESOS]
GO
/****** Object:  UserDefinedFunction [dbo].[F_ConsultaCodigoProceso]    Script Date: 06/28/2017 10:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[F_ConsultaCodigoProceso]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[F_ConsultaCodigoProceso] (@NomProceso varchar(50))
returns smallint
/*	Objetivo		:	Consulta el código de proceso de la tabla PROCESOS..Procesos
	Creador			:	César O. Serrano Rivera
	Fecha Creación 	:	25/11/2015
*/
as
begin
	declare @Resultado smallint = (select CodProceso from PROCESOS..Procesos where NomProceso = @NomProceso)

	--set @Resultado = (datediff(year,@FecNacimiento,@FecReferencia) - case when right(CONVERT([char](8),@FecNacimiento,(112)),4)>right(CONVERT([char](8),@FecReferencia,(112)),4) then (1) else 0 end)		
	--if @Resultado < 0 or @Resultado > 120
	--	set @Resultado = 0

	return(isnull(@Resultado,0))
end
' 
END
GO
USE [ANALITICA]
GO
/****** Object:  Table [dbo].[EFE_CarteraTotal]    Script Date: 06/28/2017 10:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EFE_CarteraTotal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EFE_CarteraTotal](
	[NroOrden] [int] NULL,
	[NumDocumento] [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
	[CodTipoDocumento] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
	[FecCorte] [date] NULL,
	[FecCorteRCC] [date] NULL,
	[FecDesembolso] [date] NULL,
	[FecUltimoPago] [date] NULL,
	[CodCredito] [bigint] NULL,
	[ImpDesembolso] [decimal](10, 2) NULL,
	[ImpInicial] [decimal](10, 2) NULL,
	[ImpValorCuota] [decimal](10, 2) NULL,
	[Perfil] [varchar](30) COLLATE Modern_Spanish_100_CI_AS NULL,
	[TipCredito] [varchar](17) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[DesTipoCredito] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CodAgencia] [smallint] NULL,
	[NomAgencia] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomEmpresa] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomPlaza] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomRegion] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomRegionCobranza] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomRegionComercial] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomRegionCredito] [nvarchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NomArticulo] [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NomSubgrupo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Marca] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[NroDiasAtraso] [int] NULL,
	[CodEstado] [tinyint] NULL,
	[NomEstadoCredito] [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
	[ImpCapital] [decimal](16, 2) NULL,
	[ImpInteres] [decimal](16, 2) NULL,
	[ImpCapitalMasInteres] [decimal](23, 2) NULL,
	[PlazoDias] [int] NULL,
	[NroCuotas] [int] NULL,
	[CodTipoCuota] [int] NULL,
	[TipCuota] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NroCuotasImpagas] [tinyint] NULL,
	[NroCuotasPagadas] [tinyint] NULL,
	[Edad] [tinyint] NULL,
	[FlgTieneGarante] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[CodOficio] [smallint] NULL,
	[NomOficio] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[ImpCMEAprobada] [decimal](14, 2) NULL,
	[NroHijos] [tinyint] NULL,
	[CodEstadoCivil] [tinyint] NULL,
	[NomEstadoCivil] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[ImpRentaMensual] [decimal](10, 2) NULL,
	[ImpDeudaTotal_SF] [decimal](13, 2) NULL,
	[ImpDeudaConsumo_SF] [decimal](13, 2) NULL,
	[CC_2M] [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CC_3M] [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CC_6M] [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CC_9M] [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CC_12M] [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ImpCMEPlus] [numeric](10, 2) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
USE [EFECTIVADW]
GO
/****** Object:  Table [dbo].[Dim_Perfil_Riesgos]    Script Date: 06/28/2017 10:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Perfil_Riesgos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Dim_Perfil_Riesgos](
	[id_perfil_riesgos] [smallint] NOT NULL,
	[cod_perfil_riesgos] [int] NOT NULL,
	[niv_riesgos] [smallint] NOT NULL,
	[des_perfil_riesgos] [varchar](30) COLLATE Modern_Spanish_100_CI_AS NOT NULL,
	[cod_version] [smallint] NOT NULL,
	[usu_registro] [char](3) COLLATE Modern_Spanish_100_CI_AS NOT NULL,
	[fec_registro] [date] NOT NULL,
	[fec_proceso] [date] NOT NULL,
	[hor_proceso] [time](7) NOT NULL,
	[cod_usuario] [varchar](15) COLLATE Modern_Spanish_100_CI_AS NOT NULL,
 CONSTRAINT [PK_PerfilRiesgos] PRIMARY KEY CLUSTERED 
(
	[cod_perfil_riesgos] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Dim_Oficio]    Script Date: 06/28/2017 10:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Oficio]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Dim_Oficio](
	[id_oficio] [smallint] NOT NULL,
	[cod_oficio] [smallint] NULL,
	[nom_oficio] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_situacion_laboral] [tinyint] NULL,
	[nom_situacion_laboral] [varchar](40) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_Dim_Oficio] PRIMARY KEY CLUSTERED 
(
	[id_oficio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [AK_Dim_Oficio] UNIQUE NONCLUSTERED 
(
	[cod_oficio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
USE [EFEDW]
GO
/****** Object:  Table [dbo].[Dim_Articulos]    Script Date: 06/28/2017 10:07:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Articulos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Dim_Articulos](
	[id_articulo] [int] NOT NULL,
	[cod_articulo] [varchar](40) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_flex_articulo] [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
	[des_articulo] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_grupo] [int] NULL,
	[des_grupo] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_sub_grupo] [int] NULL,
	[des_sub_grupo] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_linea] [int] NULL,
	[des_linea] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_linea_negocio] [int] NULL,
	[des_linea_negocio] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_empresa] [int] NULL,
 CONSTRAINT [PK_Dim_articulo] PRIMARY KEY CLUSTERED 
(
	[id_articulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_EfeDWDim_Articulos] UNIQUE NONCLUSTERED 
(
	[cod_articulo] ASC,
	[cod_empresa] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
USE [MAESTROBI]
GO
/****** Object:  Table [dbo].[CreditosBI]    Script Date: 06/28/2017 10:07:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditosBI](
	[cod_tipo_documento] [tinyint] NULL,
	[num_documento] [bigint] NULL,
	[cod_credito] [bigint] NULL,
	[plazo] [smallint] NULL,
	[cod_tipo_cuota] [tinyint] NULL,
	[num_cuotas_pagadas] [tinyint] NULL,
	[num_cuotas_impagas] [tinyint] NULL,
	[monto_venta] [decimal](10, 2) NULL,
	[monto_capital_no_atrasado] [decimal](10, 2) NULL,
	[monto_capital_atrasado] [decimal](10, 2) NULL,
	[monto_capital_pagado] [decimal](10, 2) NULL,
	[monto_interes_total] [decimal](10, 2) NULL,
	[monto_interes_no_atrasado] [decimal](10, 2) NULL,
	[monto_interes_atrasado] [decimal](10, 2) NULL,
	[monto_interes_pagado] [decimal](10, 2) NULL,
	[fecha_ultimo_pago] [date] NULL,
	[fecha_desembolso] [date] NULL,
	[dias_atraso] [int] NULL,
	[fecha_vcto_ult_cuota] [date] NULL,
	[monto_inicial] [decimal](10, 2) NULL,
	[cod_agencia] [smallint] NULL,
	[monto_recuperacion_dacion] [decimal](10, 2) NULL,
	[cod_moneda] [tinyint] NULL,
	[cod_flex_articulo01] [bigint] NULL,
	[cod_flex_articulo02] [bigint] NULL,
	[cod_flex_articulo03] [bigint] NULL,
	[cod_flex_articulo04] [bigint] NULL,
	[cod_flex_articulo05] [bigint] NULL,
	[cod_flex_articulo06] [bigint] NULL,
	[cod_flex_articulo07] [bigint] NULL,
	[cod_flex_articulo08] [bigint] NULL,
	[cod_flex_articulo09] [bigint] NULL,
	[cod_flex_articulo10] [bigint] NULL,
	[cod_campania] [int] NULL,
	[fecha_vcto_primera_cuota] [date] NULL,
	[cod_estado] [tinyint] NULL,
	[marca_impago] [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha_castigo] [date] NULL,
	[dias_atraso_cuota_mayor_atraso] [smallint] NULL,
	[fecha_vcto_cuota_mayor_atraso] [date] NULL,
	[cod_tipo_credito] [smallint] NULL,
	[marca_PAA] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha_PAA] [date] NULL,
	[monto_cuota] [decimal](10, 2) NULL,
	[flag_BRP] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha_BRP] [date] NULL,
	[monto_MGE] [decimal](10, 2) NULL,
	[sumatoria_dias_atraso] [int] NULL,
	[num_atrasos] [smallint] NULL,
	[cod_vendedor] [int] NULL,
	[nom_vendedor] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_cajera] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_cajera] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
	[monto_capital_vigente] [decimal](10, 2) NULL,
	[monto_interes_vigente] [decimal](10, 2) NULL,
	[monto_capital_01_08] [decimal](10, 2) NULL,
	[monto_interes_01_08] [decimal](10, 2) NULL,
	[monto_capital_09_30] [decimal](10, 2) NULL,
	[monto_interes_09_30] [decimal](10, 2) NULL,
	[monto_capital_31_60] [decimal](10, 2) NULL,
	[monto_interes_31_60] [decimal](10, 2) NULL,
	[monto_capital_61_90] [decimal](10, 2) NULL,
	[monto_interes_61_90] [decimal](10, 2) NULL,
	[monto_capital_91_120] [decimal](10, 2) NULL,
	[monto_interes_91_120] [decimal](10, 2) NULL,
	[monto_capital_121_mas] [decimal](10, 2) NULL,
	[monto_interes_121_mas] [decimal](10, 2) NULL,
	[cod_descuento_01] [int] NULL,
	[cod_descuento_02] [int] NULL,
	[cod_descuento_03] [int] NULL,
	[flag_seguro_pf] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[monto_seguro_pf] [decimal](10, 2) NULL,
	[correlativo_transaccion] [bigint] NULL,
	[flag_vta_nota_credito] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[flag_sistema] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[dia_pago] [tinyint] NULL,
	[monto_saldo_cargos] [decimal](10, 2) NULL,
	[monto_total_cargos] [decimal](10, 2) NULL,
	[monto_cargos_una_cuota] [decimal](10, 2) NULL,
	[flag_fideicomiso] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[monto_tasa_efectiva_mensual] [decimal](10, 3) NULL,
	[monto_tasa_efectiva_anual] [decimal](10, 3) NULL,
	[monto_tipo_cambio] [decimal](10, 3) NULL,
	[flag_efectivo_tarjeta_credito] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_proveedor_tarjeta] [varchar](40) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_beneficiario_seguropf] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha_corte] [date] NULL,
	[cod_cliente] [bigint] NULL,
	[cod_via_pago_ultima_cuota_pagada] [smallint] NULL,
	[cod_empresa] [smallint] NULL,
	[cod_tipo_local] [smallint] NULL,
	[fecha_incautacion] [date] NULL,
	[flag_seguro_accidentes_personales] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[monto_seguro_accidentes_personales] [decimal](14, 2) NULL,
	[cod_articulo01] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo02] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo03] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo04] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo05] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo06] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo07] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo08] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo09] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_articulo10] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo01] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo02] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo03] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo04] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo05] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo06] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo07] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo08] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo09] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[nom_linea_articulo10] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[monto_venta_articulo01] [decimal](10, 2) NULL,
	[monto_venta_articulo02] [decimal](10, 2) NULL,
	[monto_venta_articulo03] [decimal](10, 2) NULL,
	[monto_venta_articulo04] [decimal](10, 2) NULL,
	[monto_venta_articulo05] [decimal](10, 2) NULL,
	[monto_venta_articulo06] [decimal](10, 2) NULL,
	[monto_venta_articulo07] [decimal](10, 2) NULL,
	[monto_venta_articulo08] [decimal](10, 2) NULL,
	[monto_venta_articulo09] [decimal](10, 2) NULL,
	[monto_venta_articulo10] [decimal](10, 2) NULL,
	[monto_capital_BRP] [decimal](10, 2) NULL,
	[fecha_vcto_prox_cuota] [date] NULL,
	[dias_atraso_negativo] [int] NULL,
	[marca_baja] [smallint] NULL,
	[tasa] [decimal](10, 3) NULL,
	[cod_cobrador] [smallint] NULL,
	[cod_nivel_gestion] [smallint] NULL,
	[cod_plaza_ges_cob] [smallint] NULL,
	[cod_prod_crediticio] [int] NULL,
	[monto_CME_aprobada] [decimal](14, 2) NULL,
	[tip_lin_credito] [smallint] NULL,
	[cod_modelo] [smallint] NULL,
	[seg_filtro] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_zona_riesgo] [smallint] NULL,
	[cod_perfil_cli] [smallint] NULL,
	[flag_garante] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flag_RCC] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_SOE] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_aval] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_vent_com] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_recurrencia] [smallint] NULL,
	[flg_seg_nb] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_60_dias] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_flex] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[flx_22] [smallint] NULL,
	[flx_23] [smallint] NULL,
	[nro_meses_dorm] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_rd] [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
	[acc_rd] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[seg_bancarizado_rd] [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_motivo_interfaz] [smallint] NULL,
	[mon_cuota_actual] [decimal](10, 2) NULL,
	[tip_nota_credito] [char](2) COLLATE Modern_Spanish_CI_AS NULL,
	[usr_registro_credito] [char](3) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'idx_cod_credito')
CREATE NONCLUSTERED INDEX [idx_cod_credito] ON [dbo].[CreditosBI] 
(
	[cod_credito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'idx_cod_tipo_documento')
CREATE NONCLUSTERED INDEX [idx_cod_tipo_documento] ON [dbo].[CreditosBI] 
(
	[cod_tipo_documento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'IDX_CreditosBIFCNDFS')
CREATE NONCLUSTERED INDEX [IDX_CreditosBIFCNDFS] ON [dbo].[CreditosBI] 
(
	[fecha_corte] ASC,
	[num_documento] ASC,
	[cod_tipo_documento] ASC,
	[flag_sistema] ASC
)
INCLUDE ( [cod_credito],
[cod_tipo_credito],
[cod_via_pago_ultima_cuota_pagada]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'idx_fecha_corte')
CREATE NONCLUSTERED INDEX [idx_fecha_corte] ON [dbo].[CreditosBI] 
(
	[fecha_corte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'idx_fecha_corte_flag')
CREATE NONCLUSTERED INDEX [idx_fecha_corte_flag] ON [dbo].[CreditosBI] 
(
	[fecha_corte] ASC,
	[flag_sistema] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CreditosBI]') AND name = N'idx_num_documento')
CREATE NONCLUSTERED INDEX [idx_num_documento] ON [dbo].[CreditosBI] 
(
	[num_documento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientesBI]    Script Date: 06/28/2017 10:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientesBI]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClientesBI](
	[cod_tipo_documento] [tinyint] NULL,
	[num_documento] [bigint] NULL,
	[nom1] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[nom2] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[ape_paterno] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[ape_materno] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[ape_casada] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_perfil] [tinyint] NULL,
	[fecha_nacimiento] [date] NULL,
	[edad] [smallint] NULL,
	[cod_sexo] [tinyint] NULL,
	[cod_oficio] [smallint] NULL,
	[nom_empleador] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_CIIU] [smallint] NULL,
	[monto_renta_mensual] [decimal](10, 2) NULL,
	[direccion_laboral] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[ubigeo_laboral] [int] NULL,
	[telefono_laboral] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
	[direccion_particular] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[ubigeo_particular] [int] NULL,
	[telefono_particular] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
	[flag_garante] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[num_documento_garante] [bigint] NULL,
	[cod_tipo_evaluacion] [tinyint] NULL,
	[calificacion_recurrente] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
	[nuevo_recurrente] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_tipo_vivienda] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[num_hijos] [tinyint] NULL,
	[cod_estado_civil] [tinyint] NULL,
	[cod_condicion_laboral] [tinyint] NULL,
	[cod_actividad_giro] [tinyint] NULL,
	[tipo_afiliacion] [tinyint] NULL,
	[monto_CME_aprobada] [decimal](14, 2) NULL,
	[monto_CME_utilizada] [decimal](10, 2) NULL,
	[cod_tipo_cuota_CME] [tinyint] NULL,
	[flag_puesto_fijo] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_microzona] [int] NULL,
	[cod_plaza_JCC] [smallint] NULL,
	[cod_JCC] [smallint] NULL,
	[nom_JCC] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_ADC] [smallint] NULL,
	[nom_ADC] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[codigo_SBS] [bigint] NULL,
	[flag_RCC] [tinyint] NULL,
	[num_entidades] [tinyint] NULL,
	[urbanizacion] [varchar](60) COLLATE Modern_Spanish_CI_AS NULL,
	[marca_direccion] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha_corte] [date] NULL,
	[cod_cliente] [bigint] NULL,
	[cod_situacion_laboral] [smallint] NOT NULL,
	[cod_afiliacion] [smallint] NULL,
	[nodo_aprobacion] [smallint] NULL,
	[nom_perfil_bancarizado] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_cobrador] [smallint] NULL,
	[nom_cobrador] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_nivel_gestion] [smallint] NULL,
	[cod_plaza_cobranza] [smallint] NULL,
	[tip_lin_credito] [smallint] NULL,
	[cod_modelo] [smallint] NULL,
	[seg_filtro] [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_zona_riesgo] [smallint] NULL,
	[flg_SOE] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_aval] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_vent_com] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_recurrencia] [smallint] NULL,
	[flg_seg_nb] [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_60_dias] [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
	[flg_flex] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[flx_22] [smallint] NULL,
	[flx_23] [smallint] NULL,
	[nro_meses_dorm] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[cod_rd] [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
	[acc_rd] [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
	[seg_bancarizado_rd] [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
	[cal_crediticia] [smallint] NULL,
	[cod_motivo_interfaz] [smallint] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientesBI]') AND name = N'IDX_ClientesBI_FecCorte')
CREATE NONCLUSTERED INDEX [IDX_ClientesBI_FecCorte] ON [dbo].[ClientesBI] 
(
	[fecha_corte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientesBI]') AND name = N'IUX_ClientesBI')
CREATE UNIQUE NONCLUSTERED INDEX [IUX_ClientesBI] ON [dbo].[ClientesBI] 
(
	[fecha_corte] ASC,
	[num_documento] ASC,
	[cod_tipo_documento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_send_dbmail]    Script Date: 06/28/2017 10:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_send_dbmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- sp_send_dbmail : Sends a mail from Yukon outbox.
--
CREATE PROCEDURE [dbo].[sp_send_dbmail]
   @profile_name               sysname    = NULL,        
   @recipients                 VARCHAR(MAX)  = NULL, 
   @copy_recipients            VARCHAR(MAX)  = NULL,
   @blind_copy_recipients      VARCHAR(MAX)  = NULL,
   @subject                    NVARCHAR(255) = NULL,
   @body                       NVARCHAR(MAX) = NULL, 
   @body_format                VARCHAR(20)   = NULL, 
   @importance                 VARCHAR(6)    = ''NORMAL'',
   @sensitivity                VARCHAR(12)   = ''NORMAL'',
   @file_attachments           NVARCHAR(MAX) = NULL,  
   @query                      NVARCHAR(MAX) = NULL,
   @execute_query_database     sysname       = NULL,  
   @attach_query_result_as_file BIT          = 0,
   @query_attachment_filename  NVARCHAR(260) = NULL,  
   @query_result_header        BIT           = 1,
   @query_result_width         INT           = 256,            
   @query_result_separator     CHAR(1)       = '' '',
   @exclude_query_output       BIT           = 0,
   @append_query_error         BIT           = 0,
   @query_no_truncate          BIT           = 0,
   @query_result_no_padding    BIT           = 0,
   @mailitem_id               INT            = NULL OUTPUT,
   @from_address               VARCHAR(max)  = NULL,
   @reply_to                   VARCHAR(max)  = NULL
  WITH EXECUTE AS ''dbo''
AS
BEGIN
    SET NOCOUNT ON

    -- And make sure ARITHABORT is on. This is the default for yukon DB''s
    SET ARITHABORT ON

    --Declare variables used by the procedure internally
    DECLARE @profile_id         INT,
            @temp_table_uid     uniqueidentifier,
            @sendmailxml        VARCHAR(max),
            @CR_str             NVARCHAR(2),
            @localmessage       NVARCHAR(255),
            @QueryResultsExist  INT,
            @AttachmentsExist   INT,
            @RetErrorMsg        NVARCHAR(4000), --Impose a limit on the error message length to avoid memory abuse 
            @rc                 INT,
            @procName           sysname,
            @trancountSave      INT,
            @tranStartedBool    INT,
            @is_sysadmin        BIT,
            @send_request_user  sysname,
            @database_user_id   INT,
            @sid                varbinary(85)

    -- Initialize 
    SELECT  @rc                 = 0,
            @QueryResultsExist  = 0,
            @AttachmentsExist   = 0,
            @temp_table_uid     = NEWID(),
            @procName           = OBJECT_NAME(@@PROCID),
            @tranStartedBool    = 0,
            @trancountSave      = @@TRANCOUNT,
            @sid                = NULL

    EXECUTE AS CALLER
       SELECT @is_sysadmin       = IS_SRVROLEMEMBER(''sysadmin''),
              @send_request_user = SUSER_SNAME(),
              @database_user_id  = USER_ID()
    REVERT

    --Check if SSB is enabled in this database
    IF (ISNULL(DATABASEPROPERTYEX(DB_NAME(), N''IsBrokerEnabled''), 0) <> 1)
    BEGIN
       RAISERROR(14650, 16, 1)
       RETURN 1
    END

    --Report error if the mail queue has been stopped. 
    --sysmail_stop_sp/sysmail_start_sp changes the receive status of the SSB queue
    IF NOT EXISTS (SELECT * FROM sys.service_queues WHERE name = N''ExternalMailQueue'' AND is_receive_enabled = 1)
    BEGIN
       RAISERROR(14641, 16, 1)
       RETURN 1
    END

    -- Get the relevant profile_id 
    --
    IF (@profile_name IS NULL)
    BEGIN
        -- Use the global or users default if profile name is not supplied
        SELECT TOP (1) @profile_id = pp.profile_id
        FROM msdb.dbo.sysmail_principalprofile as pp
        WHERE (pp.is_default = 1) AND
            (dbo.get_principal_id(pp.principal_sid) = @database_user_id OR pp.principal_sid = 0x00)
        ORDER BY dbo.get_principal_id(pp.principal_sid) DESC

        --Was a profile found
        IF(@profile_id IS NULL)
        BEGIN
            -- Try a profile lookup based on Windows Group membership, if any
            EXEC @rc = msdb.dbo.sp_validate_user @send_request_user, @sid OUTPUT
            IF (@rc = 0)
            BEGIN
                SELECT TOP (1) @profile_id = pp.profile_id
                FROM msdb.dbo.sysmail_principalprofile as pp
                WHERE (pp.is_default = 1) AND
                      (pp.principal_sid = @sid)
                ORDER BY dbo.get_principal_id(pp.principal_sid) DESC
            END

            IF(@profile_id IS NULL)
            BEGIN
                RAISERROR(14636, 16, 1)
                RETURN 1
            END
        END
    END
    ELSE
    BEGIN
        --Get primary account if profile name is supplied
        EXEC @rc = msdb.dbo.sysmail_verify_profile_sp @profile_id = NULL, 
                         @profile_name = @profile_name, 
                         @allow_both_nulls = 0, 
                         @allow_id_name_mismatch = 0,
                         @profileid = @profile_id OUTPUT
        IF (@rc <> 0)
            RETURN @rc

        --Make sure this user has access to the specified profile.
        --sysadmins can send on any profiles
        IF ( @is_sysadmin <> 1)
        BEGIN
            --Not a sysadmin so check users access to profile
            iF NOT EXISTS(SELECT * 
                        FROM msdb.dbo.sysmail_principalprofile 
                        WHERE ((profile_id = @profile_id) AND
                                (dbo.get_principal_id(principal_sid) = @database_user_id OR principal_sid = 0x00)))
            BEGIN
                EXEC msdb.dbo.sp_validate_user @send_request_user, @sid OUTPUT
                IF(@sid IS NULL)
                BEGIN
                    RAISERROR(14607, -1, -1, ''profile'')
                    RETURN 1
                END
            END
        END
    END

    --Attach results must be specified
    IF @attach_query_result_as_file IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''attach_query_result_as_file'')
       RETURN 2
    END

    --No output must be specified
    IF @exclude_query_output IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''exclude_query_output'')
       RETURN 3
    END

    --No header must be specified
    IF @query_result_header IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''query_result_header'')
       RETURN 4
    END

    -- Check if query_result_separator is specifed
    IF @query_result_separator IS NULL OR DATALENGTH(@query_result_separator) = 0
    BEGIN
       RAISERROR(14618, 16, 1, ''query_result_separator'')
       RETURN 5
    END

    --Echo error must be specified
    IF @append_query_error IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''append_query_error'')
       RETURN 6
    END

    --@body_format can be TEXT (default) or HTML
    IF (@body_format IS NULL)
    BEGIN
       SET @body_format = ''TEXT''
    END
    ELSE
    BEGIN
       SET @body_format = UPPER(@body_format)

       IF @body_format NOT IN (''TEXT'', ''HTML'') 
       BEGIN
          RAISERROR(14626, 16, 1, @body_format)
          RETURN 13
       END
    END

    --Importance must be specified
    IF @importance IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''importance'')
       RETURN 15
    END

    SET @importance = UPPER(@importance)

    --Importance must be one of the predefined values
    IF @importance NOT IN (''LOW'', ''NORMAL'', ''HIGH'')
    BEGIN
       RAISERROR(14622, 16, 1, @importance)
       RETURN 16
    END

    --Sensitivity must be specified
    IF @sensitivity IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, ''sensitivity'')
       RETURN 17
    END

    SET @sensitivity = UPPER(@sensitivity)

    --Sensitivity must be one of predefined values
    IF @sensitivity NOT IN (''NORMAL'', ''PERSONAL'', ''PRIVATE'', ''CONFIDENTIAL'')
    BEGIN
       RAISERROR(14623, 16, 1, @sensitivity)
       RETURN 18
    END

    --Message body cannot be null. Atleast one of message, subject, query,
    --attachments must be specified.
    IF( (@body IS NULL AND @query IS NULL AND @file_attachments IS NULL AND @subject IS NULL)
       OR
    ( (LEN(@body) IS NULL OR LEN(@body) <= 0)  
       AND (LEN(@query) IS NULL  OR  LEN(@query) <= 0)
       AND (LEN(@file_attachments) IS NULL OR LEN(@file_attachments) <= 0)
       AND (LEN(@subject) IS NULL OR LEN(@subject) <= 0)
    )
    )
    BEGIN
       RAISERROR(14624, 16, 1, ''@body, @query, @file_attachments, @subject'')
       RETURN 19
    END   
    ELSE
       IF @subject IS NULL OR LEN(@subject) <= 0
          SET @subject=''SQL Server Message''

    --Recipients cannot be empty. Atleast one of the To, Cc, Bcc must be specified
    IF ( (@recipients IS NULL AND @copy_recipients IS NULL AND 
       @blind_copy_recipients IS NULL
        )     
       OR
        ( (LEN(@recipients) IS NULL OR LEN(@recipients) <= 0)
       AND (LEN(@copy_recipients) IS NULL OR LEN(@copy_recipients) <= 0)
       AND (LEN(@blind_copy_recipients) IS NULL OR LEN(@blind_copy_recipients) <= 0)
        )
    )
    BEGIN
       RAISERROR(14624, 16, 1, ''@recipients, @copy_recipients, @blind_copy_recipients'')
       RETURN 20
    END

    --If query is not specified, attach results and no header cannot be true.
    IF ( (@query IS NULL OR LEN(@query) <= 0) AND @attach_query_result_as_file = 1)
    BEGIN
       RAISERROR(14625, 16, 1)
       RETURN 21
    END

    --
    -- Execute Query if query is specified
    IF ((@query IS NOT NULL) AND (LEN(@query) > 0))
    BEGIN
        EXECUTE AS CALLER
        EXEC @rc = sp_RunMailQuery 
                    @query                     = @query,
               @attach_results            = @attach_query_result_as_file,
                    @query_attachment_filename = @query_attachment_filename,
               @no_output                 = @exclude_query_output,
               @query_result_header       = @query_result_header,
               @separator                 = @query_result_separator,
               @echo_error                = @append_query_error,
               @dbuse                     = @execute_query_database,
               @width                     = @query_result_width,
                @temp_table_uid            = @temp_table_uid,
            @query_no_truncate         = @query_no_truncate,
            @query_result_no_padding           = @query_result_no_padding
      -- This error indicates that query results size was over the configured MaxFileSize.
      -- Note, an error has already beed raised in this case
      IF(@rc = 101)
         GOTO ErrorHandler;
         REVERT
 
         -- Always check the transfer tables for data. They may also contain error messages
         -- Only one of the tables receives data in the call to sp_RunMailQuery
         IF(@attach_query_result_as_file = 1)
         BEGIN
             IF EXISTS(SELECT * FROM sysmail_attachments_transfer WHERE uid = @temp_table_uid)
            SET @AttachmentsExist = 1
         END
         ELSE
         BEGIN
             IF EXISTS(SELECT * FROM sysmail_query_transfer WHERE uid = @temp_table_uid AND uid IS NOT NULL)
            SET @QueryResultsExist = 1
         END

         -- Exit if there was an error and caller doesn''t want the error appended to the mail
         IF (@rc <> 0 AND @append_query_error = 0)
         BEGIN
            --Error msg with be in either the attachment table or the query table 
            --depending on the setting of @attach_query_result_as_file
            IF(@attach_query_result_as_file = 1)
            BEGIN
               --Copy query results from the attachments table to mail body
               SELECT @RetErrorMsg = CONVERT(NVARCHAR(4000), attachment)
               FROM sysmail_attachments_transfer 
               WHERE uid = @temp_table_uid
            END
            ELSE
            BEGIN
               --Copy query results from the query table to mail body
               SELECT @RetErrorMsg = text_data 
               FROM sysmail_query_transfer 
               WHERE uid = @temp_table_uid
            END

            GOTO ErrorHandler;
         END
         SET @AttachmentsExist = @attach_query_result_as_file
    END
    ELSE
    BEGIN
        --If query is not specified, attach results cannot be true.
        IF (@attach_query_result_as_file = 1)
        BEGIN
           RAISERROR(14625, 16, 1)
           RETURN 21
        END
    END

    --Get the prohibited extensions for attachments from sysmailconfig.
    IF ((@file_attachments IS NOT NULL) AND (LEN(@file_attachments) > 0)) 
    BEGIN
        EXECUTE AS CALLER
        EXEC @rc = sp_GetAttachmentData 
                        @attachments = @file_attachments, 
                        @temp_table_uid = @temp_table_uid,
                        @exclude_query_output = @exclude_query_output
        REVERT
        IF (@rc <> 0)
            GOTO ErrorHandler;
        
        IF EXISTS(SELECT * FROM sysmail_attachments_transfer WHERE uid = @temp_table_uid)
            SET @AttachmentsExist = 1
    END

    -- Start a transaction if not already in one. 
    -- Note: For rest of proc use GOTO ErrorHandler for falures  
    if (@trancountSave = 0) 
       BEGIN TRAN @procName

    SET @tranStartedBool = 1

    -- Store complete mail message for history/status purposes  
    INSERT sysmail_mailitems
    (
       profile_id,   
       recipients,
       copy_recipients,
       blind_copy_recipients,
       subject,
       body, 
       body_format, 
       importance,
       sensitivity,
       file_attachments,  
       attachment_encoding,
       query,
       execute_query_database,
       attach_query_result_as_file,
       query_result_header,
       query_result_width,          
       query_result_separator,
       exclude_query_output,
       append_query_error,
       send_request_user,
       from_address,
       reply_to
    )
    VALUES
    (
       @profile_id,        
       @recipients, 
       @copy_recipients,
       @blind_copy_recipients,
       @subject,
       @body, 
       @body_format, 
       @importance,
       @sensitivity,
       @file_attachments,  
       ''MIME'',
       @query,
       @execute_query_database,  
       @attach_query_result_as_file,
       @query_result_header,
       @query_result_width,            
       @query_result_separator,
       @exclude_query_output,
       @append_query_error,
       @send_request_user,
       @from_address,
       @reply_to
    )

    SELECT @rc          = @@ERROR,
           @mailitem_id = SCOPE_IDENTITY()

    IF(@rc <> 0)
        GOTO ErrorHandler;

    --Copy query into the message body
    IF(@QueryResultsExist = 1)
    BEGIN
      -- if the body is null initialize it
        UPDATE sysmail_mailitems
        SET body = N''''
        WHERE mailitem_id = @mailitem_id
        AND body is null

        --Add CR, a \r followed by \n, which is 0xd and then 0xa
        SET @CR_str = CHAR(13) + CHAR(10)
        UPDATE sysmail_mailitems
        SET body.WRITE(@CR_str, NULL, NULL)
        WHERE mailitem_id = @mailitem_id

   --Copy query results to mail body
        UPDATE sysmail_mailitems
        SET body.WRITE( (SELECT text_data from sysmail_query_transfer WHERE uid = @temp_table_uid), NULL, NULL )
        WHERE mailitem_id = @mailitem_id

    END

    --Copy into the attachments table
    IF(@AttachmentsExist = 1)
    BEGIN
        --Copy temp attachments to sysmail_attachments      
        INSERT INTO sysmail_attachments(mailitem_id, filename, filesize, attachment)
        SELECT @mailitem_id, filename, filesize, attachment
        FROM sysmail_attachments_transfer
        WHERE uid = @temp_table_uid
    END

    -- Create the primary SSB xml maessage
    SET @sendmailxml = ''<requests:SendMail xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.microsoft.com/databasemail/requests RequestTypes.xsd" xmlns:requests="http://schemas.microsoft.com/databasemail/requests"><MailItemId>''
                        + CONVERT(NVARCHAR(20), @mailitem_id) + N''</MailItemId></requests:SendMail>''

    -- Send the send request on queue.
    EXEC @rc = sp_SendMailQueues @sendmailxml
    IF @rc <> 0
    BEGIN
       RAISERROR(14627, 16, 1, @rc, ''send mail'')
       GOTO ErrorHandler;
    END

    -- Print success message if required
    IF (@exclude_query_output = 0)
    BEGIN
       SET @localmessage = FORMATMESSAGE(14635)
       PRINT @localmessage
    END  

    --
    -- See if the transaction needs to be commited
    --
    IF (@trancountSave = 0 and @tranStartedBool = 1)
       COMMIT TRAN @procName

    -- All done OK
    goto ExitProc;

    -----------------
    -- Error Handler
    -----------------
ErrorHandler:
    IF (@tranStartedBool = 1) 
       ROLLBACK TRAN @procName

    ------------------
    -- Exit Procedure
    ------------------
ExitProc:
   
    --Always delete query and attactment transfer records. 
   --Note: Query results can also be returned in the sysmail_attachments_transfer table
    DELETE sysmail_attachments_transfer WHERE uid = @temp_table_uid
    DELETE sysmail_query_transfer WHERE uid = @temp_table_uid

   --Raise an error it the query execution fails
   -- This will only be the case when @append_query_error is set to 0 (false)
   IF( (@RetErrorMsg IS NOT NULL) AND (@exclude_query_output=0) )
   BEGIN
      RAISERROR(14661, -1, -1, @RetErrorMsg)
   END

    RETURN (@rc)
END
' 
END
GO
USE [RCC]
GO
/****** Object:  Table [dbo].[RCC_ConsolidaObligacionesClientes]    Script Date: 06/28/2017 10:07:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RCC_ConsolidaObligacionesClientes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RCC_ConsolidaObligacionesClientes](
	[FecCorteRCC] [date] NOT NULL,
	[NroOrden] [int] NOT NULL,
	[NumDocumento] [varchar](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[CodTipoDocumento] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ImpDeudaMinima] [decimal](13, 2) NULL,
	[ImpDeudaMaxima] [decimal](13, 2) NULL,
	[ImpDeuda] [decimal](13, 2) NULL,
	[ImpRendimento] [decimal](13, 2) NULL,
	[ImpLineas] [decimal](13, 2) NULL,
	[ImpComision] [decimal](13, 2) NULL,
	[ImpProvision] [decimal](13, 2) NULL,
	[ImpDeudaPrestamoConsumo] [decimal](13, 2) NULL,
	[ImpDeudaTDC] [decimal](13, 2) NULL,
	[ImpDeudaHipotecaria] [decimal](13, 2) NULL,
	[ImpLineaNU] [decimal](13, 2) NULL,
	[ImpDeudaOtrosConsumo] [decimal](13, 2) NULL,
	[ImpDeudaCastigo] [decimal](13, 2) NULL,
	[ImpDeudaIndirectaContingente] [decimal](13, 2) NULL,
	[ImpInteresMES] [decimal](13, 2) NULL,
	[ImpDeudaMES] [decimal](13, 2) NULL,
	[ImpDeudaPeqEmpresa] [decimal](13, 2) NULL,
	[ImpDeudaMedEmpresa] [decimal](13, 2) NULL,
	[ImpValorCuotaEFE] [decimal](13, 2) NULL,
	[ImpCMEDisponibleEFE] [decimal](13, 2) NULL,
	[ImpCFMSF] [decimal](13, 2) NULL,
	[CodCalificacionSBS] [smallint] NULL,
	[CodCalificacionInterna] [smallint] NULL,
	[CodCalificacionAlineada] [smallint] NULL,
	[CodClasificacionInterna] [tinyint] NULL,
	[NroEntidadesReportantes] [smallint] NULL,
	[FlgReportadoEfe] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
	[NroEntidadesReportanDeuda] [smallint] NULL,
	[NroDiasAtraso] [smallint] NULL,
	[NroDiasAtrasoEFE] [smallint] NULL,
	[ImpDeudaDirecta] [float] NULL,
	[NroEmpresasDeudaDirecta] [smallint] NULL,
	[ImpDeudaDirectaConsumo] [float] NULL,
	[NroEmpresasDeudaConsumo] [smallint] NULL,
	[ImpDeudaDirectaMicroEmpresa] [float] NULL,
	[NroEmpresasDeudaMicroEmpresa] [smallint] NULL,
	[ImpDeudaVencida] [float] NULL,
	[NroEmpresasDeudaVencida] [smallint] NULL,
	[ImpInteres] [float] NULL,
	[ImpDeudaVigente] [float] NULL,
	[NroEmpresasDeudaVigente] [smallint] NULL,
	[ImpDeudaDirectaTdCConsumo] [float] NULL,
	[NroEmpresasDeudaDirectaTdCConsumo] [smallint] NULL,
	[ImpDeudaDirectaPrestamoConsumo] [float] NULL,
	[NroEmpresasDeudaDirectaPrestamoConsumo] [smallint] NULL,
	[ImpLineaTdCConsumo] [float] NULL,
 CONSTRAINT [PK_RCCConsolidaObligacionesClientes] PRIMARY KEY CLUSTERED 
(
	[FecCorteRCC] ASC,
	[NroOrden] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
USE [ANALITICA]
GO
/****** Object:  StoredProcedure [dbo].[PI_CalculaCarteraTotal]    Script Date: 06/28/2017 10:06:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_CalculaCarteraTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[PI_CalculaCarteraTotal]
@CodFecCorte	    DATE,
@FecCorteRCC    DATE,
@FlgEjecucion    char(20) = ''SSSSSSSSSSSSSSS''

-- =======================================================================================================================
--  Descripción		:	Generar Información de la cartera Total de los Préstamos de Financiera Efectiva
--	Creador			:	Carlos Alberto Paco Vigo
--	Fecha Creación 	:	27/02/2017
--	Parámetros		:	@FecCorte		:	Fecha de Corte; Formato ''AAAAMMDD''
--						@FecCorteRCC	:	Fecha de Corte; Formato ''AAAAMMDD''
-- Tablas Lectura	:	MaestroBI.dbo.CreditosBI
--						PROMETEO_DW..DIM_AGENCIA
--						EFEDW.dbo.Dim_Articulos
--						EfectivaDW.dbo.Dim_Perfil_Riesgos
--						EFECTIVADW.dbo.Dim_Oficio
--						EFECTIVA..Dim_EstadoCivil
--						EFECTIVA.dbo.Personas
--						RCC_ConsolidaObligacionesClientes	
--						MAESTROBI..PlusCmeClientes
--						ANALITICA..EFE_CarteraTotal
-- Tablas Inserta	:	ANALITICA.dbo.EFE_CarteraTotal
-- Tablas Actualiza	:
-- =======================================================================================================================
		
AS

BEGIN 

set nocount on 
	---------------------------------------
	-- Declara variables globales .........
	---------------------------------------
	declare @NroRegistros	int = 0
	Declare @NroPaso		tinyint = 1
	declare @CodPaso		smallint	= 0		-- Por defecto 1 corresponde al paso Inserta Datos
	declare @mensaje		varchar(250)
	Declare @cCadena		varchar(200)
	Declare @CodError		bigint = 0
	Declare @LineaError		varchar(250)
	Declare @MensajeError	varchar(1000)

	Declare @CodTFecCorte			char(6) = substring(cast(@CodFecCorte as char(10)),1,4)+substring(cast(@CodFecCorte as char(10)),6,2)
	Declare @CodProceso		smallint =	PROCESOS.dbo.F_ConsultaCodigoProceso (''PI_CalculaCarteraTotal'')
	Declare @NroEjecucion	int			= 0		-- El procedimiento entregará el N°	
	Declare @DecripPaso	varchar(1000)
	
	--Variables para el envio de correo
	Declare @DesAsunto Varchar(300),
			@DesMensaje Varchar(1000),
			@EmailDestino Varchar(200),
			@DesCabecera  Varchar(300),
			@CodNotificacion smallint,
			@tableHTML	varchar(max),
			@Cuentas    varchar(max);

	BEGIN TRY
		SET @NroRegistros = @@ROWCOUNT
		set @CodPaso  = @CodPaso+1
		print ''------------------------------------------------------------------------------------------------------------------------''
		exec PROCESOS..P_ExecProcesoInicio	@NroEjecucion output,@CodProceso
		SET @mensaje  = ''  1 - Inicio Proceso Cartera Total de Prestamos EFE. '' + @CodTFecCorte  + '' (NroEjecucion: '' + cast(@NroEjecucion as varchar(13)) + '')''
		TRUNCATE TABLE ANALITICA.dbo.EFE_CarteraTotal
		
		set @mensaje = @mensaje + space (97 - len(@mensaje)) + '' - ''  + convert (varchar(20), GETDATE(), 113) + ''.''
		print(@mensaje)

		------------------------------------------------------------------------------------------------------------------------
		--	2. Carga de archivo temporal #TmpBase ...............
		------------------------------------------------------------------------------------------------------------------------
		
		set @NroPaso = 2
		set	@DecripPaso=''Carga de archivo temporal #TmpBase''
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''#TmpBase'') IS NOT NULL DROP TABLE #TmpBase	
		
			SELECT DISTINCT 
				LTRIM(RTRIM(CAST(A.num_documento AS VARCHAR(12)))) num_documento,
				CAST(A.cod_tipo_documento AS CHAR(1)) cod_tipo_documento,				
				A.cod_credito, 
				cast(DATEADD(D,-1,DATEADD(M,1,''01/''+LTRIM(MONTH(A.fecha_desembolso))+''/''+LTRIM(YEAR(A.fecha_desembolso)))) as date) FecCorte, 
				cast(DATEADD(D,-1,DATEADD(M,0,''01/''+LTRIM(MONTH(A.fecha_desembolso))+''/''+LTRIM(YEAR(A.fecha_desembolso)))) as date) FecCorteRCC, 
				convert (char(6),A.fecha_desembolso, 112) CodFecDesembolso, 
				CASE WHEN a.cod_tipo_credito in (5,6,7,8,17,19,21,29) THEN ''Motos'' 
					 WHEN a.cod_tipo_credito = 9					  THEN ''MejoramientoHogar'' 
					 WHEN a.cod_tipo_credito = 10					  THEN ''Construcción'' 
					 WHEN a.cod_tipo_credito = 11					  THEN ''Efectivo'' 
					 ELSE ''Electro'' 
				END TipoCredito, 
				A.fecha_desembolso,
				A.cod_agencia, 
				B.Agencia NomAgencia, 
				ISNULL(C.des_articulo,ISNULL(D.des_articulo,ISNULL(E.des_articulo,ISNULL(F.des_articulo,ISNULL(G.des_articulo,'''')))))Nom_Articulo, 
				ISNULL(C.des_sub_grupo,ISNULL(D.des_sub_grupo,ISNULL(E.des_sub_grupo,ISNULL(F.des_sub_grupo,ISNULL(G.des_sub_grupo,'''')))))Nom_Subgrupo, 
				C.des_grupo Marca,
				H.des_perfil_riesgos Perfil,
				A.fecha_ultimo_pago, 
				A.dias_atraso, 
				B.Empresa	NomEmpresa,
				A.cod_estado,
				CASE WHEN A.cod_estado IN (2,3) THEN ''VIGENTE'' 
					 WHEN A.cod_estado IN (4,5) THEN ''VENCIDO'' 
					 WHEN A.cod_estado = 6		THEN ''JUDICIAL''
					 WHEN A.cod_estado = 7		THEN ''CASTIGADO'' 
					 WHEN A.cod_estado = 9		THEN ''CANCELADO'' 
				END EstCredito,  
				A.monto_capital_01_08 + A.monto_capital_09_30 + A.monto_capital_31_60 + A.monto_capital_61_90 + A.monto_capital_91_120 + A.monto_capital_121_mas + A.monto_capital_vigente Capital,
				A.monto_interes_01_08 + A.monto_interes_09_30 + A.monto_interes_31_60 + A.monto_interes_61_90 + A.monto_interes_91_120 + A.monto_interes_121_mas + A.monto_interes_vigente Interes,
				(A.monto_capital_01_08 + A.monto_capital_09_30 + A.monto_capital_31_60 + A.monto_capital_61_90 + A.monto_capital_91_120 + A.monto_capital_121_mas + A.monto_capital_vigente +
				A.monto_interes_01_08 + A.monto_interes_09_30 + A.monto_interes_31_60 + A.monto_interes_61_90 + A.monto_interes_91_120 + A.monto_interes_121_mas + A.monto_interes_vigente) K_mas_I, 
				A.plazo,
				( case when A.cod_tipo_cuota = 0 then 30 else A.cod_tipo_cuota end) as cod_tipo_cuota,
				CASE WHEN A.cod_tipo_cuota = 7  THEN ''SEMANAL'' 
					 WHEN A.cod_tipo_cuota = 30 THEN ''MENSUAL'' 
					 ELSE '''' 
				END TipoCuota, 
				A.cod_tipo_credito,
				CASE WHEN A.cod_tipo_credito = 9  THEN ''MEJORAMIENTO DE HOGAR''
					 WHEN A.cod_tipo_credito = 10 THEN ''CONSTRUCCION''
					 WHEN A.cod_tipo_credito = 11 THEN ''CREDITO EFECTIVO''
					 WHEN A.cod_tipo_credito = 12 THEN ''CREDITO COMERCIAL''
					 WHEN A.cod_tipo_credito = 13 THEN ''PRESTAMOS MES (MICROEMPRESA)''
					 WHEN A.cod_tipo_credito = 14 THEN ''PRESTAMOS DE CONSUMO (DEPENDIENTES)''
					 WHEN A.cod_tipo_credito = 17 THEN ''CREDITOS CONSUMO MENSUAL''
					 WHEN A.cod_tipo_credito = 19 THEN ''CREDITOS MES MENSUAL''
					 WHEN A.cod_tipo_credito = 21 THEN ''GARANTIA PRENDA VEHICULAR''
					 WHEN A.cod_tipo_credito = 24 THEN ''PRESTAMOS DE CONSUMO SEMANAL (DEPENDIENT''
					 WHEN A.cod_tipo_credito = 33 THEN ''PRESTAMOS MES - NO PREFERIDA'' 
					 ELSE '''' 
				END DescTipoCredito,
				A.monto_cuota, 
				A.num_cuotas_impagas, 
				A.num_cuotas_pagadas, 
				b.plaza NomPlaza,
				B.Region,
				B.Region_Cobranza,
				B.Region_Comercial,
				B.Region_Credito,
				A.monto_venta, 
				A.monto_inicial, 
				A.monto_tasa_efectiva_anual, 
				A.monto_tasa_efectiva_mensual				
			INTO #TmpBase
			FROM MaestroBI.dbo.CreditosBI					A
				LEFT JOIN PROMETEO_DW..DIM_AGENCIA			    B ON B.cod_agencia = A.cod_agencia
				LEFT JOIN EFEDW.dbo.Dim_Articulos				C ON C.cod_articulo = a.cod_articulo01 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				D ON D.cod_articulo = a.cod_articulo02 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				E ON E.cod_articulo = a.cod_articulo03 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				F ON F.cod_articulo = a.cod_articulo04 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				G ON G.cod_articulo = a.cod_articulo05 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EfectivaDW.dbo.Dim_Perfil_Riesgos	H ON H.Cod_perfil_riesgos = A.cod_perfil_cli
			WHERE A.flag_sistema = ''SFI'' AND A.fecha_corte =@CodFecCorte  AND A.fecha_desembolso > = ''20130101''  

			
			SET @NroRegistros = @@ROWCOUNT
			exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
			Set @mensaje  = ''  2 - Cálculo en Base de Datos - Carga en Tabla Temporal 					 - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
			print(@mensaje)	
			-- Crea indices a la tabla temporal ------------------------------------------------
			create index #TmpBase on #TmpBase(num_documento,cod_tipo_documento,FecCorte)
			create index #TmpBase_01 on #TmpBase(num_documento,cod_tipo_documento,cod_credito)
			------------------------------------------------------------------------------------
			UPDATE #TmpBase 
			SET num_documento = case	when cod_tipo_documento = ''1'' 
											then
												case when len(num_documento) = 11 then SUBSTRING(num_documento,3,8) ELSE right(''00000000'' + num_documento, 8) END
										when cod_tipo_documento = ''2'' 
											then right(''000000000'' + num_documento, 9)
										ELSE num_documento
								END;
		end

								
		------------------------------------------------------------------------------------------------------------------------
		--	3. Carga de archivo temporal #TmpBase_1 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 3
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''tempdb..#TmpBase_1'') IS NOT NULL DROP TABLE #TmpBase_1			
			SELECT
				a.num_documento NumDocumento,
				CAST (A.cod_tipo_documento AS CHAR (1)) CodTipoDocumento,
				A.cod_credito, 
				A.Perfil,
				A.FecCorte, 
				A.FecCorteRCC, 
				DescTipoCredito,
				TipoCredito TipoNegocio,
				A.CodFecDesembolso, 
				A.fecha_desembolso,
				A.cod_agencia, 
				A.NomAgencia, 
				A.Nom_Articulo, 
				A.Nom_Subgrupo, 
				A.Marca,		
				A.fecha_ultimo_pago, 
				A.dias_atraso, 
				A.NomEmpresa, 
				A.cod_estado,
				A.EstCredito,  
				A.Capital,
				A.Interes,
				A.K_mas_I, 
				A.plazo,
				A.cod_tipo_cuota,
				A.TipoCuota, 
				A.monto_cuota, 
				A.num_cuotas_impagas, 
				A.num_cuotas_pagadas, 
				P.EdadActual as edad,
				B.flag_garante, 
				B.cod_oficio, 
				C.Nom_Oficio,
				B.monto_CME_aprobada, 
				B.num_hijos, 
				B.cod_estado_civil,
				D.NomEstadoCivil,
				A.NomPlaza, 
				A.Region,
				A.Region_Cobranza,
				A.Region_Credito,
				A.Region_Comercial, 
				A.monto_venta, 
				A.monto_inicial, 
				B.monto_renta_mensual,
				b.cod_cliente
			INTO #TmpBase_1
			FROM #TmpBase A
				LEFT JOIN MaestroBI.dbo.ClientesBI	B ON B.num_documento = cast(A.num_documento as bigint) AND B.cod_tipo_documento = A.cod_tipo_documento AND B.fecha_corte = A.FecCorte   -- COSR
				LEFT JOIN EFECTIVADW.dbo.Dim_Oficio		C ON C.Cod_Oficio = B.cod_oficio
				LEFT JOIN EFECTIVA..Dim_EstadoCivil	D ON D.CodEstadoCivil = B.cod_estado_civil 
				LEFT JOIN EFECTIVA.dbo.Personas       P ON P.NumDocumento = cast(A.num_documento as varchar(12)) AND P.CodTipoDocumento = A.cod_tipo_documento and P.CodTipoDocumento <>''*''
			SET @NroRegistros = @@ROWCOUNT
			exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
			Set @mensaje  = ''  3 - Fin de Cálculo de Datos Personasles de los clientes. 				     - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
			print(@mensaje)	
		end
		
		------------------------------------------------------------------------------------------------------------------------
		--	4. Carga de archivo temporal #TmpBase_2 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 4
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
		
			IF OBJECT_ID(''tempdb..#TmpBase_2'') IS NOT NULL DROP TABLE #TmpBase_2
				SELECT B.NroOrden, A.* 
				INTO #TmpBase_2 
				FROM #TmpBase_1 A
					LEFT JOIN EFECTIVA.dbo.Personas B ON B.NumDocumento = A.NumDocumento AND B.CodTipoDocumento = A.CodTipoDocumento  and B.CodTipoDocumento <>''*''
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
				Set @mensaje  = ''  4 - Carga Nro. de Orden. 												     - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
				print(@mensaje)					
				------- Crea indices a la tabla temporal-----------------
					CREATE  INDEX Idx_NroOrden ON #TmpBase_2 (NroOrden)
				---------------------------------------------------------				
		end
		
		------------------------------------------------------------------------------------------------------------------------
		--	5. Carga de archivo temporal #TmpBase_3 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 5
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''tempdb..#TmpBase_3'') IS NOT NULL DROP TABLE #TmpBase_3
				SELECT 
				A.*, 
				ISNULL(B.ImpDeuda,0) ImpDeudaTotal_SF, 
				ISNULL(B.ImpDeudaPrestamoConsumo,0) ImpDeudaConsumo_SF
				INTO #TmpBase_3
				FROM #TmpBase_2 A
				LEFT JOIN RCC.dbo.RCC_ConsolidaObligacionesClientes B ON  B.FecCorteRCC = @FecCorteRCC  AND B.NroOrden = A.NroOrden --
				
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
				Set @mensaje  = ''  5 - Cálculo de Deudas Actuales. 											 - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
				print(@mensaje)	
		end	
		------------------------------------------------------------------------------------------------------------------------
		--	6. Carga de archivo temporal #TmpBase_3 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 6
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''tempdb..#TmpBase_4'') IS NOT NULL DROP TABLE #TmpBase_4				
				
				SELECT A.*, 
				ISNULL(CASE WHEN D.T2M IN (2,3,4,5,6,7) THEN ''1'' WHEN D.T2M IN (0,1,8) THEN ''0'' END, '''')CC_2M, 
				ISNULL(CASE WHEN D.T3M IN (2,3,4,5,6,7) THEN ''1'' WHEN D.T3M IN (0,1,8) THEN ''0'' END, '''')CC_3M, 
				ISNULL(CASE WHEN D.T6M IN (2,3,4,5,6,7) THEN ''1'' WHEN D.T6M IN (0,1,8) THEN ''0'' END, '''')CC_6M, 
				ISNULL(CASE WHEN D.T9M IN (2,3,4,5,6,7) THEN ''1'' WHEN D.T9M IN (0,1,8) THEN ''0'' END, '''')CC_9M,
				ISNULL(CASE WHEN D.T12M IN (2,3,4,5,6,7) THEN ''1'' WHEN D.T12M IN (0,1,8) THEN ''0'' END, '''')CC_12M
				INTO #TmpBase_4
				FROM #TmpBase_3 A
				LEFT JOIN ANALITICA.dbo.Maduracion_Creditos D 
							ON		D.cod_credito = A.cod_credito 
							AND		D.Año = YEAR(A.fecha_desembolso) 
							AND		D.Mes = MONTH(A.fecha_desembolso) 
							AND		D.Sistema = ''SFI''
				 
							
				SET @NroRegistros = @@ROWCOUNT				
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
				Set @mensaje  = ''  6 - Cálculo de Calidad de Cartera a 2,3,6,9 y 12 Meses. 			         - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
				print(@mensaje)	
								
		end	


		------------------------------------------------------------------------------------------------------------------------
		--	7. Valida existencia de duplicados ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 7
		if substring (@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''#duplicados'') IS NOT NULL DROP TABLE #nulos
			select	cod_cliente CodCliente,
					cod_transaccion CodTrx,
					COUNT(1)	NumReg
			into	#duplicados			
			from	MAESTROBI..PlusCmeClientes
			GROUP BY cod_cliente,cod_transaccion
			HAVING COUNT(1)>1
			set @NroRegistros = @@ROWCOUNT
			if 	@NroRegistros > 0
			begin
				Set @mensaje =  ''      Se han encontrado Registros Duplicados en la tabla MAESTROBI..PlusCmeClientes  -                   '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg.''
				print(@mensaje)

				Select @DesAsunto = NP.DesAsunto,
					   @DesMensaje = NP.DesMensaje,
					   @EmailDestino = NP.EmlDestinatario					   
				From PROCESOS..ProcesosNotificacionesPasos NP
				Where CodProceso = @CodProceso And NroPaso = @NroPaso And CodNotificacion = 1;
				
				--Envia Correo con Nro. de registros Duplicados
				Set @DesAsunto = @DesAsunto + '', Fecha de corte: '' + @CodTFecCorte
				Set @Cuentas = @EmailDestino

				SET @tableHTML = N''<H1 style="font-family: Arial, Helvetica, sans-serif; font-size: small">'' + @DesMensaje + ''</H1>'' +
								 N''<table border="1" style="font-family: Tahoma; font-size: 12px"><tr>'' +
								 N''<th>Cod. Origen</th><th>Origen</th></tr>'' +
								 CAST ( ( SELECT td = A.CodCliente, '''',							
								 				 td = A.CodTrx, ''''
								 		  FROM #duplicados as A											
								 		  FOR XML PATH(''tr''), TYPE
										) AS NVARCHAR(MAX) ) +
								 N''</table>''   +
								 N''<H2></H2>''
								 					

				EXEC msdb.dbo.sp_send_dbmail
				@profile_name = ''enviosbi'',
				@recipients   = @Cuentas,
				@body         = @tableHTML,
				@body_format  = ''HTML'',
				@subject      = @DesAsunto;
			
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, ''I'',@CodError, @NroRegistros 
				print ''      Reporte de Registros Duplicados, enviado por correo.''	
      		end
			else
			begin
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, ''I'',@CodError, @NroRegistros 
				Set @mensaje  = ''  7 - Validación satisfactoria de Reg. Duplicados -  PlusCmeClientes.        - '' + right(''              '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''				
				print(@mensaje)
			end
		end
		------------------------------------------------------------------------------------------------------------------------
		--	8. Carga de archivo temporal #TmpBase_4 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 8
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin	
			IF OBJECT_ID(''tempdb..#TmpCMEPlus'') IS NOT NULL DROP TABLE #TmpCMEPlus			
				SELECT cm.cod_cliente as CodCliente, max(cm.cod_transaccion) as NroTransaccion
				into #TmpCMEPlus
				from	MAESTROBI..pluscmeclientes	cm	
				inner join #TmpBase_4 tmp4 on (cm.cod_cliente = tmp4.cod_cliente 
												and cast(cm.fec_corte as date) <= cast(@CodFecCorte as date))  
				group by cm.cod_cliente
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
				Set @mensaje  = ''  8 - Cálculo de CMEPlus único por cliente. 							     - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''
				print(@mensaje)
				-- Crea indices a la tabla temporal --------------------
				create index Idx_CodCliente on #TmpCMEPlus (CodCliente)
				--------------------------------------------------------
				
		end	
		------------------------------------------------------------------------------------------------------------------------
		--	9. Carga de archivo temporal #TmpBase_4 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 9
		if substring(@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
			IF OBJECT_ID(''tempdb..#TmpBase_5'') IS NOT NULL DROP TABLE #TmpBase_5
				SELECT  A.*, cm.mon_cme_plus as ImpCMEPlus -- elclcpcmep ---> mon_cme_plus
				 INTO #TmpBase_5
				 FROM #TmpBase_4 A left join #TmpCMEPlus tcm on ( a.cod_cliente = tcm.CodCliente ) 
									left join MAESTROBI..pluscmeclientes cm on ( cm.cod_cliente = a.cod_cliente and cm.cod_transaccion = tcm.NroTransaccion )
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''I'', @CodError, @NroRegistros
				Set @mensaje  = ''  9 - Proceso de Asignación de CMEPlus. 					    		     - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''				
				print(@mensaje)					
						
		end
		------------------------------------------------------------------------------------------------------------------------
		--	10. Inserta registros en tabla CONTA..CarteraCastigosMensual ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 10
		if substring (@FlgEjecucion,@NroPaso, 1) = ''S''
		begin
				INSERT INTO ANALITICA.dbo.EFE_CarteraTotal (
					NroOrden,			NumDocumento,		CodTipoDocumento,	FecCorte,			FecCorteRCC,
					FecDesembolso,		FecUltPago,			CodFecDesembolso,	CodCredito,			ImpDesembolso,
					ImpInicial,			ImpCuota,			Perfil,				DescTipoCredito,	TipoNegocio,
					CodAgencia,			NomAgencia,			NomEmpresa,			NomPlaza,			Region,
					Region_Cobranza,	Region_Comercial,	Region_Credito,		NomArticulo,		NomSubgrupo,
					Marca,				NroDiasAtraso,		CodEstCredito,		EstCredito,			Capital,
					Interes,			K_mas_I,			PlazoDias,			PlazoMeses,			CodTipoCuota,
					TipoCuota,			NroCuotasImpagas,	NroCuotasPagadas,	Edad,				FlgAval,
					CodOficio,			NomOficio,			ImpCMEAprobada,		NroHijos,			CodEstCivil,
					NomEstadoCivil,		ImpIngresos,		ImpDeudaTotal_SF,	ImpDeudaConsumo_SF,	CC_2M,
					CC_3M,				CC_6M,				CC_9M,				CC_12M,
					ImpCMEPlus )
				SELECT 
					NroOrden,						NumDocumento,						CodTipoDocumento,					FecCorte,							FecCorteRCC, 
					fecha_desembolso FecDesembolso,	fecha_ultimo_pago FecUltPago,		CodFecDesembolso,					cod_credito ,				monto_venta ImpDesembolso,		
					monto_inicial	ImpInicial,		monto_cuota ImpCuota,				Perfil,								DescTipoCredito,					TipoNegocio,
					cod_agencia CodAgencia,			NomAgencia,							NomEmpresa,							NomPlaza,							Region,	
					Region_Cobranza,				Region_Comercial,					Region_Credito,						Nom_Articulo,						Nom_Subgrupo,
					Marca,							dias_atraso NroDiasAtraso,			cod_estado CodEstCredito,			EstCredito,							Capital,
					Interes,						K_mas_I,							plazo PlazoDias,					(plazo/cod_tipo_cuota) PlazoMeses,	cod_tipo_cuota CodTipoCuota,	
					TipoCuota,						num_cuotas_impagas NroCuotasImpagas,num_cuotas_pagadas NroCuotasPagadas,edad Edad,							flag_garante FlgAval,
					cod_oficio CodOficio,			Nom_Oficio,							monto_CME_aprobada ImpCMEAprobada,	num_hijos NroHijos,					cod_estado_civil CodEstCivil,
					NomEstadoCivil,					monto_renta_mensual ImpIngresos,	ImpDeudaTotal_SF,					ImpDeudaConsumo_SF,					CC_2M,
					CC_3M,							CC_6M,								CC_9M,								CC_12M,
					ImpCMEPlus
				FROM #TmpBase_5
				
				set @NroRegistros = @@ROWCOUNT
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, ''I'',@CodError, @NroRegistros
				exec procesos..P_ExecProcesoFinal @NroEjecucion, @CodProceso
				Set @mensaje  = '' 10 - Inserta registros en tabla ANALITICA.dbo.EFE_CarteraTotal              - '' + right(''             '' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + '' Reg. - '' + convert (varchar(20), GETDATE(), 113) + ''.''								
				print(@mensaje)
		end

		-- ----------------------------------------------------------------------------------------------------------------------
		-- 11. Elimina tablas temporales ...............
		-- ----------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 11
		if substring(@FlgEjecucion, @NroPaso, 1) = ''S''
		begin
			if OBJECT_ID(''tempdb..#TmpBase'') is not null drop table #TmpBase
			if OBJECT_ID(''tempdb..#TmpBase_1'') is not null drop table #TmpBase_1
			if OBJECT_ID(''tempdb..#TmpBase_2'') is not null drop table #TmpBase_2
			if OBJECT_ID(''tempdb..#TmpBase_3'') is not null drop table #TmpBase_3
			if OBJECT_ID(''tempdb..#TmpBase_4'') is not null drop table #TmpBase_4			
			if OBJECT_ID(''tempdb..#TmpBase_5'') is not null drop table #TmpBase_5
			if OBJECT_ID(''tempdb.. #TmpCMEPlus'') is not null drop table #TmpCMEPlus
			if OBJECT_ID(''tempdb..#duplicados'') is not null drop table #duplicados



			exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, ''D'', @CodError, @NroRegistros
			exec PROCESOS..P_ExecProcesoFinal @NroEjecucion, @CodProceso
			Set @mensaje = ''  19 - Fin Proceso de Proceso Cartera Total de Prestamos EFE ('' + @CodTFecCorte  + '')                                         - ''  + convert (varchar(20), GETDATE(), 113) + ''.''
			
		end		

	---------------------------------------------------
	
	END TRY
	---------------------------------------------------
	-- Objeto que captura el error
	---------------------------------------------------
	BEGIN CATCH
		Error:
		set @CodError = ERROR_NUMBER()
		set @LineaError = ERROR_LINE()
		set @MensajeError= ERROR_MESSAGE()
		set @Mensaje = ''  Error en el Paso Nro.:	'' + cast (@NroPaso as varchar(2)) + '' - '' + @DecripPaso
		print @mensaje
		set @mensaje = ''  Mensaje de error: '' + @MensajeError
		print @mensaje	
	END CATCH
END


' 
END
GO
USE [EFECTIVADW]
GO
/****** Object:  Default [df_Dim_Perfil_Riesgos_fec_proceso]    Script Date: 06/28/2017 10:07:06 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[df_Dim_Perfil_Riesgos_fec_proceso]') AND parent_object_id = OBJECT_ID(N'[dbo].[Dim_Perfil_Riesgos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[df_Dim_Perfil_Riesgos_fec_proceso]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Dim_Perfil_Riesgos] ADD  CONSTRAINT [df_Dim_Perfil_Riesgos_fec_proceso]  DEFAULT (getdate()) FOR [fec_proceso]
END


End
GO
/****** Object:  Default [df_Dim_Perfil_Riesgos_hor_proceso]    Script Date: 06/28/2017 10:07:06 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[df_Dim_Perfil_Riesgos_hor_proceso]') AND parent_object_id = OBJECT_ID(N'[dbo].[Dim_Perfil_Riesgos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[df_Dim_Perfil_Riesgos_hor_proceso]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Dim_Perfil_Riesgos] ADD  CONSTRAINT [df_Dim_Perfil_Riesgos_hor_proceso]  DEFAULT (CONVERT([varchar](8),getdate(),(108))) FOR [hor_proceso]
END


End
GO
/****** Object:  Default [df_Dim_Perfil_Riesgos_cod_usuario]    Script Date: 06/28/2017 10:07:06 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[df_Dim_Perfil_Riesgos_cod_usuario]') AND parent_object_id = OBJECT_ID(N'[dbo].[Dim_Perfil_Riesgos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[df_Dim_Perfil_Riesgos_cod_usuario]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Dim_Perfil_Riesgos] ADD  CONSTRAINT [df_Dim_Perfil_Riesgos_cod_usuario]  DEFAULT (suser_sname()) FOR [cod_usuario]
END


End
GO
