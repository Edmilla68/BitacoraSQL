USE [OrdenesServicio]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscaDatos]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_BuscaDatos]  
(@nroOrden int,   
@CodigoCampo int)  
returns varchar(100)  
begin  
declare @valor varchar(100)  
  
select @valor = oc_valor from ost_orden_servicio_config  
where cam_codigo = @CodigoCampo and ose_codigo = @nroOrden  
return @valor  
end  


GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscaDatosTotal]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_BuscaDatosTotal]    
(@nroOrden int,     
@CodigoCampo int)    
returns varchar(100)    
begin    
declare @valor varchar(100)    
    
select @valor = count(oc_valor) from ost_orden_servicio_config    
where cam_codigo = @CodigoCampo and ose_codigo = @nroOrden    
return @valor    
end    
  


GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscaFechas]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_BuscaFechas]
(@nroOrden int,     
@CodigoCampo int)    
returns char(8)    
begin    
declare @valor char(8)
    
select @valor = substring(oc_valor,7,4)+substring(oc_valor,4,2)+substring(oc_valor,1,2) from ost_orden_servicio_config    
where cam_codigo = @CodigoCampo and ose_codigo = @nroOrden    
return @valor    
end 

GO
/****** Object:  UserDefinedFunction [dbo].[SGF_ConvertirStrFechaDatetime]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------
ALTER FUNCTION [dbo].[SGF_ConvertirStrFechaDatetime](@vchFecha varchar(14))
	RETURNS datetime
as
BEGIN
/****
creado: Celia Macedo
Fecha : 08/09/2005
Descripcion : 	Convierte una fecha expresado en varchar a uno en datetime
		el formato de ingreso es : 12/05/2005
*******/	
	declare @fecha 	datetime
	set @fecha = cast((right(@vchFecha,4)+ left(right(@vchFecha,7),2)+left(@vchFecha,2)) as datetime)
	RETURN (@FECHA)
END
----------------------------------------------------------------------------

GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscaDatostabla]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_BuscaDatostabla]    
(@nroOrden int,     
@CodigoCampo int)    
returns table
as   

return (select ose_codigo, oc_valor, cam_index from ost_orden_servicio_config    
where cam_codigo = @CodigoCampo and ose_codigo = @nroOrden)


GO
/****** Object:  View [dbo].[SGV_Lista_Area]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[SGV_Lista_Area]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_AREA


GO
/****** Object:  View [dbo].[SGV_Lista_Empresa]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[SGV_Lista_Empresa]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_EMPRESA


GO
/****** Object:  View [dbo].[SGV_Lista_Opcion]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER VIEW [dbo].[SGV_Lista_Opcion]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_OPCION


GO
/****** Object:  View [dbo].[SGV_Lista_OpcionPerfil]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[SGV_Lista_OpcionPerfil]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_OPCION_PERFIL



GO
/****** Object:  View [dbo].[SGV_Lista_Perfil]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER VIEW [dbo].[SGV_Lista_Perfil]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_PERFIL


GO
/****** Object:  View [dbo].[SGV_Lista_PerfilUsuario]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER VIEW [dbo].[SGV_Lista_PerfilUsuario]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_PERFIL_USUARIO




GO
/****** Object:  View [dbo].[SGV_Lista_Usuario]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[SGV_Lista_Usuario]
AS
SELECT     *
FROM         Seguridad.dbo.SGT_USUARIO


GO
/****** Object:  View [dbo].[SGV_Lista_UsuarioArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER VIEW [dbo].[SGV_Lista_UsuarioArea]
AS
SELECT  LU.USU_CODIGOINTERNO AS USU_CODIGO ,
	LUA.ARE_CODIGO AS ARE_CODIGO 
FROM    Seguridad.dbo.SGT_USUARIO_AREA LUA,
 	Seguridad.dbo.SGT_USUARIO LU
WHERE  LU.USU_CODIGO=LUA.USU_CODIGO 


GO
/****** Object:  View [dbo].[TAV_Servicio]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TAV_Servicio]    
AS    
SELECT        
Servicio,     
CodigoServicio,     
Nombre ,     
NombreIngles,     
FlagDetraccion,     
FlagGeneraAlmacenaje,     
FlagAlmacenaje,     
FlagGeneraOT,     
ModoFacturacion,     
FlagConfirmacionMail,     
FlagIGV,     
CodigoExterno,     
TipoVia,     
Empresa,     
Sucursal,     
UltimoUsuario,     
UltimaFecha,     
Estado,     
FlagPublicado,     
FlagTransporte,
FlagDua     
FROM   Tarifario.dbo.TA_Servicio  where estado= 'A'
GO
/****** Object:  View [dbo].[TAV_ServicioArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TAV_ServicioArea]    
AS    
SELECT     *    
FROM         Tarifario.dbo.TA_ServicioArea    


GO
/****** Object:  StoredProcedure [dbo].[DBS_DETALLE_HIJO]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DBS_DETALLE_HIJO]
@OSE_CODIGO int
AS
SELECT 
OAH.EST_Codigo estadocodiaudihijo,
OAH.AOH_FechaHoraInicio,
OAH.AOH_FechaHoraFin,
E.EST_Nombre estadonomaudihijo,

OSH.OSH_Codigo codihijo,
EOSH.EST_Nombre ultimoestadodehijo,

OS.OSE_Codigo codipadre,
OS.OSE_Descripcion descripadre,
T.TSV_Nombre tiposervicio,
A.ARE_Nombre,
VLU.USU_Nombres + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno NombreUsuario,
VLU.USU_Codigo
FROM 	OST_ORDEN_SERVICIO OS,
	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_ESTADO E,
	OST_ESTADO EOSH,
OST_TIPO_SERVICIO T,


	OST_AUDITORIA_ORDEN_HIJO OAH,
	SGV_Lista_Usuario VLU,
SGV_LISTA_AREA A
WHERE 	OS.OSE_CODIGO=OSH.OSE_CODIGO AND
 OS.TSV_Codigo=T.TSV_Codigo and 
T.ARE_Codigo=A.ARE_Codigo and

	OSH.OSE_CODIGO=OAH.OSE_CODIGO AND
	OSH.OSH_Codigo=OAH.OSH_Codigo AND
	OAH.EST_CODIGO=E.EST_CODIGO  AND
OSH.EST_Codigo=EOSH.EST_Codigo and 
	OAH.USU_Codigo=VLU.USU_codigo AND
	OSH.OSE_Codigo = @OSE_Codigo and
	OS.OSE_Codigo=@OSE_Codigo and 
	OAH.OSE_Codigo=@OSE_Codigo


GO
/****** Object:  StoredProcedure [dbo].[DBS_FILTROCLIENTE1]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE  [dbo].[DBS_FILTROCLIENTE1]
@EST_CODIGO INT ,
@AUO_FECHAHORAINICIO  varchar(8),
@AUO_FECHAHORAFIN  varchar(8),
@USU_Codigo varchar(10) 

 AS
SELECT DISTINCT OS.OSE_CODIGO,
	OS.OSE_DESCRIPCION,
	rtrim(ltrim(OE.EST_NOMBRE)) EST_CODIGO,
	AO.AUO_FECHAHORAINICIO,
--	AO.AUO_FECHAHORAFIN,
	AO.USU_Codigo
FROM 	OST_ORDEN_SERVICIO OS,
	OST_AUDITORIA_ORDEN AO,
	OST_ESTADO OE,
	SGV_Lista_Usuario VLU 
WHERE AO.OSE_CODIGO 		= OS.OSE_CODIGO 		AND
	--AO.AUO_FECHAHORAINICIO 	>= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAINICIO))) AND
 	--AO.AUO_FECHAHORAFIN 	<= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAFIN))) and
	AO.AUO_FECHAHORAINICIO between  @AUO_FECHAHORAINICIO and  dateadd(dd,1,@AUO_FECHAHORAFIN) and 
	AO.USU_Codigo=VLU.usu_codigo and 
	rtrim(ltrim(VLU.usu_codigointerno))= rtrim(ltrim(@USU_Codigo)) AND 
	ao.EST_Codigo=@EST_CODIGO and
	OE.EST_CODIGO		= ao.EST_CODIGO 
order by 4





GO
/****** Object:  StoredProcedure [dbo].[DBS_FILTROUSER1]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[DBS_FILTROUSER1]
(
 @ARE_codigo  as int ,
  @TSV_codigo as int,
  @USU_codigo as varchar(10) ,
  @EST_codigo as int ,
  @AUO_FechaHoraInicio as  datetime,
  @AUO_FechaHoraFin as datetime
)
AS
SELECT OS.OSE_Codigo,
	OS.OSE_Descripcion,
	TS.TSV_Codigo,
	rtrim(ltrim(TS.TSV_Nombre)) TSV_Nombre,
	AO.AUO_FechaHoraInicio,
	AO.AUO_FechaHoraFin,
	rtrim(ltrim(VLA.ARE_Nombre))  ARE_Nombre,
	VLA.ARE_codigo,
	isnull(VLU.USU_Nombres,'') + '  ' + isnull(VLU.USU_Paterno,'') + '  ' + + isnull(VLU.USU_Materno,'')  nombreusuario,
	VLU.USU_Codigo,
	rtrim(ltrim(OE.EST_Nombre)) EST_Nombre
FROM 	OST_ORDEN_SERVICIO OS,
          	OST_TIPO_SERVICIO TS,
	OST_AUDITORIA_ORDEN AO,
	OST_ESTADO  OE,
	SGV_Lista_Area VLA,
	SGV_Lista_Usuario VLU
WHERE OS.TSV_CODIGO = TS.TSV_CODIGO AND
	AO.OSE_CODIGO=OS.OSE_CODIGO  AND
	AO.USU_Codigo = VLU.USU_Codigo  AND
	TS.ARE_CODIGO=VLA.ARE_CODIGO AND
	OS.EST_CODIGO= OE.EST_CODIGO   AND
	OE.EST_codigo =@EST_codigo and
	VLU.USU_Codigo=@USU_codigo and
	VLA.ARE_Codigo=@ARE_codigo and	
	TS.TSV_Codigo=@TSV_codigo and
	AO.AUO_FECHAHORAINICIO 	>= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAINICIO))) AND
 	AO.AUO_FECHAHORAFIN 	<= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAFIN)))

GO
/****** Object:  StoredProcedure [dbo].[DBS_RELACION_HIJO]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DBS_RELACION_HIJO]

@OSE_Codigo int,
@OSH_Codigo int 

AS

SELECT 
OSH.OSH_Codigo,
	E.EST_Codigo,
	E.EST_Nombre,
	AOH_FechaHoraInicio,
	AOH_FechaHoraFin,
	VLU.USU_Nombres + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno NombreUsuario,
	VLU.USU_Codigo
FROM 	OST_ORDEN_SERVICIO OS,
	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_ESTADO E,
	OST_AUDITORIA_ORDEN_HIJO OAH,
	SGV_Lista_Usuario VLU
WHERE OS.OSE_CODIGO=OSH.OSE_CODIGO AND
	OSH.OSE_CODIGO=OAH.OSE_CODIGO AND
	OSH.OSH_Codigo=OAH.OSH_Codigo AND
	OAH.EST_CODIGO=E.EST_CODIGO  AND
	OAH.USU_Codigo=VLU.USU_codigo AND
	OSH.OSE_Codigo = @OSE_Codigo and 
	OSH.OSH_Codigo=@OSH_Codigo

GO
/****** Object:  StoredProcedure [dbo].[DBS_RELACIONPADRE]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[DBS_RELACIONPADRE]  
(
	@OSE_Codigo INT
)
AS
SELECT distinct OSE.OSE_Codigo,
	OSE.OSE_Descripcion,
	OSH.OSH_Codigo,
	E.EST_Codigo,
	E.EST_Nombre,
	rtrim(ltrim(TS.TSV_NOMBRE)) TSV_NOMBRE,
	rtrim(ltrim(VLA.ARE_NOMBRE))  ARE_NOMBRE 
	
FROM 	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_ORDEN_SERVICIO OSE,
	OST_ESTADO E,
	OST_TIPO_SERVICIO TS,
	SGV_LISTA_AREA VLA

WHERE OSH.OSE_CODIGO=OSE.OSE_CODIGO AND
	OSH.EST_CODIGO=E.EST_CODIGO  AND
	TS.TSV_CODIGO=OSE.TSV_CODIGO AND
	VLA.ARE_CODIGO=TS.ARE_CODIGO AND
	OSE.OSE_Codigo = @OSE_Codigo

GO
/****** Object:  StoredProcedure [dbo].[DBS_REPORTE_WORKFLOWOS]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DBS_REPORTE_WORKFLOWOS]
(
	@OSE_Codigo INT
)
AS

SELECT OS.OSE_Codigo,
	OS.OSE_Descripcion,
	RTRIM(LTRIM(TS.TSV_NOMBRE))  TSV_NOMBRE,
	AO.AUO_FechaHoraINICIO,
	AO.AUO_FechaHoraFin,
	RTRIM(LTRIM(VLA.ARE_NOMBRE))  ARE_NOMBRE,
	VLU.USU_Nombres + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno,
	OE.EST_Nombre
FROM 	OST_ORDEN_SERVICIO OS,
	OST_TIPO_SERVICIO TS,
	OST_AUDITORIA_ORDEN AO,
	SGV_LISTA_AREA VLA,
	SGV_Lista_Usuario VLU,
	OST_ESTADO OE
WHERE OS.TSV_CODIGO = TS.TSV_CODIGO AND
	AO.OSE_CODIGO = OS.OSE_CODIGO AND
	TS.ARE_CODIGO = VLA.ARE_Codigo AND
	LTRIM(RTRIM(AO.USU_Codigo)) = LTRIM(RTRIM(VLU.USU_Codigo)) AND
	AO.EST_Codigo = OE.EST_Codigo AND
	OS.OSE_Codigo = @OSE_Codigo

RETURN

GO
/****** Object:  StoredProcedure [dbo].[DBS_SUBFILTROCLIENTE]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE  [dbo].[DBS_SUBFILTROCLIENTE]

@EST_NOMBRE VARCHAR (25) ,
@AUO_FECHAHORAFIN DATETIME,
@AUO_FECHAHORAINICIO DATETIME

 AS
SELECT OS.OSE_CODIGO,
	OSH.OSH_CODIGO,
	OS.OSE_DESCRIPCION,
	OE.EST_CODIGO,
	AO.AUO_FECHAHORAINICIO,
	AO.AUO_FECHAHORAFIN,
	AOH.AOH_FECHAHORAINICIO,
	AOH.AOH_FECHAHORAFIN
FROM 	OST_ORDEN_SERVICIO OS,
	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_AUDITORIA_ORDEN AO,
	OST_AUDITORIA_ORDEN_HIJO AOH,
	OST_ESTADO OE
WHERE AO.OSE_CODIGO=OS.OSE_CODIGO AND
	AOH.OSE_CODIGO=OSH.OSE_CODIGO AND
	OS.EST_CODIGO=OE.EST_CODIGO  AND
	AO.AUO_FECHAHORAINICIO 	>= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAINICIO))) AND
 	AO.AUO_FECHAHORAFIN 	<= Convert(datetime,Rtrim(Ltrim(@AUO_FECHAHORAFIN)))

GO
/****** Object:  StoredProcedure [dbo].[DBS_SUBFILTROUSER]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DBS_SUBFILTROUSER]
@ARE_CODIGO as INT	,
@TSV_codigo as INT,
@USU_codigo as varchar(10) ,
@EST_codigo as INT,
@AOH_FechaHoraInicio as datetime,
@AOH_FechaHoraFin AS datetime
as
SELECT  OS.OSE_CODIGO,
	OSH.OSH_CODIGO,
	OE.EST_CODIGO,
	LC.CON_NOMBRE,
	VLU.USU_CODIGO,
	VLU.USU_NOMBRES + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno,
	AOH.AOH_FechaHoraInicio,
	AOH.AOH_FechaHoraFin
FROM 	OST_ORDEN_SERVICIO OS,
	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_AUDITORIA_ORDEN_HIJO AOH,
	FIV_Lista_ConceptoServicio LC,
	OST_ESTADO OE,
	SGV_LISTA_USUARIO  VLU,
	SGV_Lista_Area VLA,
	OST_Tipo_Servicio TS
WHERE OS.OSE_CODIGO = OSH.OSE_CODIGO AND
	 OS.OSE_CODIGO=AOH.OSE_CODIGO  AND
	AOH.OSE_CODIGO = OSH.OSE_CODIGO AND
	AOH.OSH_CODIGO = OSH.OSH_CODIGO AND
	LC.CON_CODIGO = OSH.CON_CODIGO AND
	OE.EST_CODIGO = OS.EST_CODIGO AND
	OE.EST_CODIGO = OSH.EST_CODIGO AND
	OSH.EST_CODIGO = AOH.EST_CODIGO AND
	AOH.USU_Codigo = VLU.USU_Codigo  AND
	VLA.ARE_CODIGO=TS.ARE_CODIGO AND
	OS.TSV_CODIGO=TS.TSV_CODIGO AND
	VLA.ARE_CODIGO= @ARE_codigo and
	TS.TSV_CODIGO=  @TSV_codigo AND
	VLU.USu_CODIGO=  @USU_codigo AND
	OE.EST_CODIGO=  @EST_codigo AND
	AOH.AOH_FechaHoraInicio>= Convert(datetime,Rtrim(Ltrim( @AOH_FechaHoraInicio))) AND
 	AOH.AOH_FechaHoraInicio<= Convert(datetime,Rtrim(Ltrim(@AOH_FechaHoraFin)))
GROUP BY  OS.OSE_CODIGO,
	OSH.OSH_CODIGO,
	OE.EST_CODIGO,
	LC.CON_NOMBRE,
	VLU.USU_CODIGO,
	VLU.USU_NOMBRES + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno,
	AOH.AOH_FechaHoraInicio,
	AOH.AOH_FechaHoraFin
	


GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_addtosourcecontrol]
    @vchSourceSafeINI varchar(255) = '',
    @vchProjectName   varchar(255) ='',
    @vchComment       varchar(255) ='',
    @vchLoginName     varchar(255) ='',
    @vchPassword      varchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'AddProjectToSourceSafe',
											NULL,
											@vchSourceSafeINI,
											@vchProjectName output,
											@@SERVERNAME,
											@vchDatabaseName,
											@vchLoginName,
											@vchPassword,
											@vchComment


    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties
    
    select @iObjectCount = 0;

CleanUp:
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_addtosourcecontrol_u]
    @vchSourceSafeINI nvarchar(255) = '',
    @vchProjectName   nvarchar(255) ='',
    @vchComment       nvarchar(255) ='',
    @vchLoginName     nvarchar(255) ='',
    @vchPassword      nvarchar(255) =''

as
	-- This procedure should no longer be called;  dt_addtosourcecontrol should be called instead.
	-- Calls are forwarded to dt_addtosourcecontrol to maintain backward compatibility
	set nocount on
	exec dbo.dt_addtosourcecontrol 
		@vchSourceSafeINI, 
		@vchProjectName, 
		@vchComment, 
		@vchLoginName, 
		@vchPassword



GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Add an object to the dtproperties table
*/
ALTER PROCEDURE [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity

GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject_vcs]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_adduserobject_vcs]
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** Create the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn



GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_checkinobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '', /* create stream */
    @txStream3     Text = ''  /* grant stream  */


as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0
	declare @iStreamObjectId int

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iPropertyObjectId int
	select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    declare @iReturnValue	  int
    declare @pos			  int
    declare @vchProcLinePiece varchar(255)

    
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT
        if @iReturn <> 0 GOTO E_OAError
        
        if @iActionFlag = 1
        begin
            
            declare @iStreamLength int
			
			select @pos=1
			select @iStreamLength = datalength(@txStream2)
			
			if @iStreamLength > 0
			begin
			
				while @pos < @iStreamLength
				begin
						
					select @vchProcLinePiece = substring(@txStream2, @pos, 255)
					
					exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
            		if @iReturn <> 0 GOTO E_OAError
            		
					select @pos = @pos + 255
					
				end
            
				exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
														'CheckIn_StoredProcedure',
														NULL,
														@sProjectName = @vchProjectName,
														@sSourceSafeINI = @vchSourceSafeINI,
														@sServerName = @vchServerName,
														@sDatabaseName = @vchDatabaseName,
														@sObjectName = @vchObjectName,
														@sComment = @vchComment,
														@sLoginName = @vchLoginName,
														@sPassword = @vchPassword,
														@iVCSFlags = @iVCSFlags,
														@iActionFlag = @iActionFlag,
														@sStream = ''
                                        
			end
        end
        else
        begin
        
            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin                
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255                  
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
													'CheckIn_StoredProcedure',
													NULL,
													@sProjectName = @vchProjectName,
													@sSourceSafeINI = @vchSourceSafeINI,
													@sServerName = @vchServerName,
													@sDatabaseName = @vchDatabaseName,
													@sObjectName = @vchObjectName,
													@sComment = @vchComment,
													@sLoginName = @vchLoginName,
													@sPassword = @vchPassword,
													@iVCSFlags = @iVCSFlags,
													@iActionFlag = @iActionFlag,
													@sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
	return

E_Compile_Fail:
	declare @lerror int
	select @lerror = @@error
	rollback tran compile_all
	RAISERROR (@lerror,16,-1)
	goto CleanUp

E_OAError:
	if @iActionFlag = 1 rollback tran compile_all
	exec dbo.dt_displayoaerror @iObjectId, @iReturn
	goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_checkinobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     text = '',  /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     text = '',  /* create stream */
    @txStream3     text = ''   /* grant stream  */

as	
	-- This procedure should no longer be called;  dt_checkinobject should be called instead.
	-- Calls are forwarded to dt_checkinobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkinobject
		@chObjectType,
		@vchObjectName,
		@vchComment,
		@vchLoginName,
		@vchPassword,
		@iVCSFlags,
		@iActionFlag,   
		@txStream1,		
		@txStream2,		
		@txStream3		



GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_checkoutobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId =0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @vchTempText varchar(255)

	/* this is for our strings */
	declare @iStreamObjectId int
	select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'CheckOut_StoredProcedure',
												NULL,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sComment = @vchComment,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword,
												@iVCSFlags = @iVCSFlags,
												@iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #commenttext (sourcecode) select @vchTempText
        end

        select 'VCS'=sourcecode from #commenttext order by id
        select 'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_checkoutobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	-- This procedure should no longer be called;  dt_checkoutobject should be called instead.
	-- Calls are forwarded to dt_checkoutobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkoutobject
		@chObjectType,  
		@vchObjectName, 
		@vchComment,    
		@vchLoginName,  
		@vchPassword,  
		@iVCSFlags,    
		@iActionFlag 



GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_displayoaerror]
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = master.dbo.sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return


GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_displayoaerror_u]
    @iObject int,
    @iresult int
as
	-- This procedure should no longer be called;  dt_displayoaerror should be called instead.
	-- Calls are forwarded to dt_displayoaerror to maintain backward compatibility.
	set nocount on
	exec dbo.dt_displayoaerror
		@iObject,
		@iresult



GO
/****** Object:  StoredProcedure [dbo].[dt_droppropertiesbyid]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
ALTER PROCEDURE [dbo].[dt_droppropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property


GO
/****** Object:  StoredProcedure [dbo].[dt_dropuserobjectbyid]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Drop an object from the dbo.dtproperties table
*/
ALTER PROCEDURE [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id

GO
/****** Object:  StoredProcedure [dbo].[dt_generateansiname]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
ALTER PROCEDURE [dbo].[dt_generateansiname](@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = 'MSDT-A-' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = 'DIAGRAM' 
	goto Leave 

GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve the owner object(s) of a given property
*/
ALTER PROCEDURE [dbo].[dt_getobjwithprop]
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value

GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve the owner object(s) of a given property
*/
ALTER PROCEDURE [dbo].[dt_getobjwithprop_u]
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_u]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_vcs]
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )


GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_vcs_u]
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    -- This procedure should no longer be called;  dt_getpropertiesbyid_vcsshould be called instead.
	-- Calls are forwarded to dt_getpropertiesbyid_vcs to maintain backward compatibility.
	set nocount on
    exec dbo.dt_getpropertiesbyid_vcs
		@id,
		@property,
		@value output


GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_isundersourcecontrol]
    @vchLoginName varchar(255) = '',
    @vchPassword  varchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName = '')	set @vchProjectName		= null
    if (@vchSourceSafeINI = '') set @vchSourceSafeINI	= null
    if (@vchServerName = '')	set @vchServerName		= null
    if (@vchDatabaseName = '')	set @vchDatabaseName	= null
    
    if (@vchProjectName is null) or (@vchSourceSafeINI is null) or (@vchServerName is null) or (@vchDatabaseName is null)
    begin
        RAISERROR('Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'GetListOfObjects',
												NULL,
												@vchProjectName,
												@vchSourceSafeINI,
												@vchServerName,
												@vchDatabaseName,
												@vchLoginName,
												@vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_isundersourcecontrol_u]
    @vchLoginName nvarchar(255) = '',
    @vchPassword  nvarchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as
	-- This procedure should no longer be called;  dt_isundersourcecontrol should be called instead.
	-- Calls are forwarded to dt_isundersourcecontrol to maintain backward compatibility.
	set nocount on
	exec dbo.dt_isundersourcecontrol
		@vchLoginName,
		@vchPassword,
		@iWhoToo 



GO
/****** Object:  StoredProcedure [dbo].[dt_removefromsourcecontrol]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_removefromsourcecontrol]

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0



GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
ALTER PROCEDURE [dbo].[dt_setpropertybyid]
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end


GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
ALTER PROCEDURE [dbo].[dt_setpropertybyid_u]
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if 'DtgSchemaNAME' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end

GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_validateloginparams]
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'ValidateLoginParams',
											NULL,
											@sSourceSafeINI = @vchSourceSafeINI,
											@sLoginName = @vchLoginName,
											@sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_validateloginparams_u]
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

	-- This procedure should no longer be called;  dt_validateloginparams should be called instead.
	-- Calls are forwarded to dt_validateloginparams to maintain backward compatibility.
	set nocount on
	exec dbo.dt_validateloginparams
		@vchLoginName,
		@vchPassword 



GO
/****** Object:  StoredProcedure [dbo].[dt_vcsenabled]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_vcsenabled]

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iReturn int
    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('', 16, -1) /* Can't Load Helper DLLC */



GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp006]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by legacy versions of the Microsoft
**	Visual Database Tools.  Version is 7.0.00.
*/
ALTER PROCEDURE [dbo].[dt_verstamp006]
as
	select 7000

GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp007]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by the the Microsoft Visual Database Tools.
**	Version is 7.0.05.
*/
ALTER PROCEDURE [dbo].[dt_verstamp007]
as
	select 7005

GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_whocheckedout]
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'WhoCheckedOut',
												@vchReturnValue OUT,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout_u]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[dt_whocheckedout_u]
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

	-- This procedure should no longer be called;  dt_whocheckedout should be called instead.
	-- Calls are forwarded to dt_whocheckedout to maintain backward compatibility.
	set nocount on
	exec dbo.dt_whocheckedout
		@chObjectType, 
		@vchObjectName,
		@vchLoginName, 
		@vchPassword  



GO
/****** Object:  StoredProcedure [dbo].[OSS_ACTUALIZA_SERVICIO_VOLANTE_ANULADOS]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ACTUALIZA_SERVICIO_VOLANTE_ANULADOS]
AS  
update terminal..ddordser32 set status32='A' from terminal..ddordser32 a inner join OST_ORDEN_SERVICIO b 
on a.nroors32=cast(b.OSE_Codigo as char(6))
where  EST_Codigo in ('2','4' ) and OSE_Fecha>=dateadd(day,-20,getdate()) and status32<>'A'

GO
/****** Object:  StoredProcedure [dbo].[OSS_ALERTAESTADO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ALERTAESTADO_Insertar] 
@OSE_Codigo integer,
@EST_Codigo integer,
@ALO_FlagEnvio int,
@ALO_Resultado varchar(500),
@ALO_Estado varchar(1), 
@ALO_FechaEnvio datetime,
@USU_Codigo as varchar(10) 

AS

/**********************************************
Procedimiento	: OSS_ALERTAESTADO_Insertar
Proposito	: Insertar alerta de estado para el envio de mail
Entrada		: Datos de la alerta
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/


SET NOCOUNT ON

/* Verificar que no exista nombre de tipo */

IF EXISTS( SELECT 1 FROM OST_ALERTA_ESTADO WHERE OSE_Codigo = @OSE_Codigo AND EST_Codigo = @EST_Codigo and USU_Codigo = @USU_Codigo)
  BEGIN
	UPDATE OST_ALERTA_ESTADO 
	SET 	ALO_Resultado=@ALO_Resultado,
		ALO_FechaEnvio=@ALO_FechaEnvio,
		ALO_FlagEnvio=@ALO_FlagEnvio 
	WHERE OSE_Codigo=@OSE_Codigo 
		 AND EST_Codigo=@EST_Codigo
		 AND USU_Codigo=@USU_Codigo 
	RETURN
  END
ELSE
  BEGIN	
	INSERT INTO OST_ALERTA_ESTADO
	   (OSE_Codigo, EST_Codigo,ALO_Resultado ,ALO_Estado ,ALO_FechaEnvio ,USU_Codigo,ALO_FlagEnvio) 
 
 	VALUES (@OSE_Codigo,@EST_Codigo,@ALO_Resultado ,@ALO_Estado ,@ALO_FechaEnvio ,@USU_Codigo,@ALO_FlagEnvio)
      RETURN
END

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[OSS_AREA_Obtener]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_AREA_Obtener]     
@NombreArea varchar(50)    
    
/***************************************    
*Descripcion: Inserta un registro    
*Fecha Crea: 05/10/2005    
*Parametros:      
*Autor: Reyes Avalos Gisella Rubi      
*Modificado . Eugenia Palao 04/01/2007 ARE_Codigo * ARE_CodigoInterno  
***************************************/    
as    
select distinct ARE_Codigo, ARE_CodigoInterno from    
SGV_Lista_Area    
where     
ARE_Nombre=@NombreArea    
    


GO
/****** Object:  StoredProcedure [dbo].[OSS_AREA_ObtenerFlagAlerta]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_AREA_ObtenerFlagAlerta]   
  
@codArea int,  
@Servicio int  
  
/***************************************  
*Descripcion: Inserta un registro  
*Fecha Crea: 05/10/2005  
*Parametros:    
*Autor: Reyes Avalos Gisella Rubi    
***************************************/  
as  
select   
isnull(FlagRequiereAlerta,'')  
as FlagRequiereAlerta,
isnull(are_correo, '') AS are_correo
from  
TAV_ServicioArea  as a 
inner join seguridad.dbo.SGT_AREA as b
on a.area = b.are_codigointerno
where   
area=@codArea  
and  Servicio=@Servicio  



GO
/****** Object:  StoredProcedure [dbo].[OSS_AREA_PERMISO_GENERACION_SOLICITUD_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_AREA_PERMISO_GENERACION_SOLICITUD_Listar]

/**********************************************
Procedimiento	: OSS_AREA_PERMISO_GENERACION_SOLICITUD_Listar
Proposito	: Listar las Areas
Fecha y Hora	: 05/10/2005
Autor		: Rubi Reyes
******************************************/
as
select distinct 
a.ARE_Codigo,a.ARE_Nombre 
from SGV_Lista_Area a
inner join OST_PERMISO_GENERACION_SOLICITUD aa
on aa.TAV_ServicioArea_Area=a.ARE_Codigo
where 
a.ARE_Estado='A'
and
a.ARE_Codigo= aa.TAV_ServicioArea_Area



GO
/****** Object:  StoredProcedure [dbo].[OSS_AREA_PERMISO_GENERACION_SOLICITUD_ListarNoexistentes]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_AREA_PERMISO_GENERACION_SOLICITUD_ListarNoexistentes]

/**********************************************
Procedimiento	: dbo.OSS_AREA_PERMISO_GENERACION_SOLICITUD_ListarNoexistentes
Proposito	: Listar las Areas que no estan en
		  la tabla OSS_AREA_PERMISO_GENERACION_SOLICITUD
Fecha y Hora	: 05/10/2005
Autor		: Rubi Reyes
******************************************/
as

select distinct a.ARE_Codigo,a.ARE_Nombre 
from SGV_Lista_Area a
left join OST_PERMISO_GENERACION_SOLICITUD aa
on aa.TAV_ServicioArea_Area=a.ARE_Codigo
where 
a.ARE_Estado='A'
and
not exists (select * from 
OST_PERMISO_GENERACION_SOLICITUD aa
where
a.ARE_Codigo= aa.TAV_ServicioArea_Area)


GO
/****** Object:  StoredProcedure [dbo].[OSS_ARGUMENTO_ListarPorComponente]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_ARGUMENTO_ListarPorComponente]
@codTOS int,
@codSecuencia int
 AS

/**********************************************
Procedimiento	: OSS_ARGUMENTO_ListarPorComponente
Proposito	: Listar Argumentos por componente
Entrada		: Componente
Salida		: Listado
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/


select * 
from 	OST_COMPONENTE_ARGUMENTO
where 	TSV_Codigo= @codTOS 
	and CES_Secuencial= @codSecuencia

GO
/****** Object:  StoredProcedure [dbo].[OSS_AUDITORIA_ORDEN_ProcesaMail]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_AUDITORIA_ORDEN_ProcesaMail] AS

/**********************************************
Procedimiento	: OSS_AUDITORIA_ORDEN_ProcesaMail
Proposito	: Procesar el envio de mail
Entrada		: Ninguno
Salida		: Listado
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/

SELECT DISTINCT 
	O.OSE_Codigo as NumOrden, 
	O.OSE_CodigoOrigen as NumOrdenOrigen,
	O.EST_Codigo as CodEstado,
	E.EST_Nombre as NombEstado,
	U.USU_Correo as Correo,
	U.USU_Nombres+U.USU_Paterno+U.USU_Materno AS NombResponsable
FROM
	OST_AUDITORIA_ORDEN AUO,
	OST_ORDEN_SERVICIO O,
	OST_WORKFLOW_ESTADO WE,
	OST_PERMISO_WORKFLOW PW,
	SGV_LISTA_USUARIO U,
	OST_ESTADO E 
	
WHERE 	
	AUO.AUO_FlagEnvio=0 
	AND AUO.OSE_Codigo=O.OSE_Codigo
	AND AUO.EST_Codigo=WE.EST_CodigoOrigen
	AND WE.TSV_Codigo=O.TSV_Codigo
	AND WE.TSV_Codigo=PW.TSV_Codigo
	AND WE.EST_Codigo=PW.EST_Codigo
	AND PW.USU_Codigo=U.USU_Codigo
	AND AUO.EST_Codigo=E.EST_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_AUDITORIAORDEN_ActualizaFechaFin]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_AUDITORIAORDEN_ActualizaFechaFin] 
@OSE_CODIGO int,
@EST_CODIGO int,
@AUO_FechaHoraFin datetime  

/**********************************************
Procedimiento	: OSS_AUDITORIAORDEN_ActualizaFechaFin
Proposito	: Actualizar la Fecha de Finalizacion de la Orden en un Estado
Entrada		: Auditoria de Orden
Salida		: Nada
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/
AS

UPDATE OST_AUDITORIA_ORDEN
SET AUO_FechaHoraFin=@AUO_FechaHoraFin 
WHERE OSE_CODIGO= @OSE_CODIGO 
	AND EST_CODIGO= @EST_CODIGO


GO
/****** Object:  StoredProcedure [dbo].[OSS_AUDITORIAORDEN_ActualizaFlag]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_AUDITORIAORDEN_ActualizaFlag] 
@OSE_CODIGO int,
@EST_CODIGO int,
@AUO_FlagEnvio  int 

/**********************************************
Procedimiento	: OSS_AUDITORIAORDEN_ActualizaFlag
Proposito	: Actualizar el Flag de Envio de Mail
Entrada		: Auditoria de Orden
Salida		: Nada
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/

AS

UPDATE OST_AUDITORIA_ORDEN
SET AUO_FlagEnvio=@AUO_FlagEnvio 
WHERE OSE_CODIGO= @OSE_CODIGO 
	AND EST_CODIGO= @EST_CODIGO


GO
/****** Object:  StoredProcedure [dbo].[OSS_AUDITORIAORDEN_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_AUDITORIAORDEN_Insertar]   
@OSE_Codigo as integer,  
@EST_Codigo as integer,  
@USU_Codigo as varchar(10),  
@AUO_FechaHoraInicio datetime,   
@AUO_FlagEnvio as int   
/**********************************************  
Procedimiento : OSS_AUDITORIAORDEN_Insertar  
Proposito : Inserta una Auditoria Orden  
Entrada  : Datos de auditoria  
Salida  : Nada  
Fecha y Hora : Julio 2005 - pm  
Responsable : R&M  
******************************************/  
AS  
BEGIN
SET NOCOUNT ON  

--|AUDITORIA DE ORDENES DE SERVICIO
INSERT INTO OST_AUDITO00  
(OSE_Codigo, EST_Codigo, USU_Codigo,AUO_FechaHoraInicio)
VALUES (@OSE_Codigo,@EST_Codigo,@USU_Codigo,GETDATE())   
--|

  
/* Verificar que no exista auditoria */   
IF EXISTS( SELECT 1 FROM OST_AUDITORIA_ORDEN  WHERE OSE_Codigo = @OSE_Codigo AND EST_Codigo = @EST_Codigo )  
BEGIN  
	 UPDATE OST_AUDITORIA_ORDEN   
	 SET  USU_Codigo=@USU_Codigo,  
	 AUO_FechaHoraInicio=@AUO_FechaHoraInicio ,  
	 AUO_FlagEnvio=@AUO_FlagEnvio   
	 WHERE OSE_Codigo=@OSE_Codigo   
	 AND EST_Codigo=@EST_Codigo  
	 RETURN  
END  
ELSE  
BEGIN   
	 INSERT INTO OST_AUDITORIA_ORDEN  
	 (OSE_Codigo, EST_Codigo, USU_Codigo,AUO_FechaHoraInicio,AUO_FlagEnvio)  
	 VALUES (@OSE_Codigo,@EST_Codigo,@USU_Codigo,@AUO_FechaHoraInicio,@AUO_FlagEnvio)   
	  
	 RETURN  
END  

SET NOCOUNT OFF  
END 
 
GO
/****** Object:  StoredProcedure [dbo].[OSS_AUDITORIAORDENHIJO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_AUDITORIAORDENHIJO_Insertar]  
@OSE_Codigo as integer,  
@OSH_Codigo as integer,  
@EST_Codigo as integer,  
@USU_Codigo as varchar(10),  
@AOH_FechaHoraInicio as datetime,   
@AOH_FechaHoraFin as datetime  
  
/**********************************************
Procedimiento	: OSS_AUDITORIAORDENHIJO_Insertar
Proposito	: Inserta una Auditoria Orden de un Detalle
Entrada		: Datos de auditoria del detalle 
Salida		: Nada
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/

AS  
  
  
SET NOCOUNT ON  
  
INSERT INTO OST_AUDITORIA_ORDEN_HIJO  
    (OSE_Codigo, OSH_Codigo,EST_Codigo, USU_Codigo,AOH_FechaHoraInicio,AOH_FechaHoraFin)  
 VALUES (@OSE_Codigo,@OSH_Codigo,@EST_Codigo,@USU_Codigo,@AOH_FechaHoraInicio,@AOH_FechaHoraFin)  
  
  
SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_Actualizar] 
@CAM_Codigo int,
@CAM_Nombre varchar(25),
@CAM_Descripcion varchar(50),
@TDA_Codigo int,
@USU_UsuarioAct varchar(10),
@CAM_FechaAct datetime,
@CAM_FlagTarifario int,
@CAM_TipoValor varchar(1),
@CAM_CodigoContabilizacion varchar(8) 

/**********************************************
Procedimiento	: OSS_CAMPOTABLA_Actualizar 
Proposito		: Actualizar OSS_CAMPOTABLA
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/

as

UPDATE OST_CAMPOTABLA
SET 	CAM_Descripcion=@CAM_Descripcion,
	USU_UsuarioAct=@USU_UsuarioAct,
	CAM_FechaAct=@CAM_FechaAct ,
	CAM_FlagTarifario=@CAM_FlagTarifario,
	CAM_TipoValor=@CAM_TipoValor ,
	CAM_Nombre=@CAM_Nombre,
	TDA_Codigo=@TDA_Codigo , 
	CAM_CodigoContabilizacion=@CAM_CodigoContabilizacion 
WHERE CAM_Codigo=@CAM_Codigo






GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_Eliminar] 
@CAM_Codigo int ,
@resultado int output
AS

begin


set @resultado=0

if(not exists(select * from ost_componente_estandar where cam_codigo=@CAM_Codigo))
begin 
	delete from ost_campotabla where cam_codigo =@CAM_Codigo 
	set @resultado=1 
end

select @resultado as resultado 
------------------------------------------------------------------------------------
end




GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_Insertar]
@TDA_Codigo int,
@CAT_Codigo int,
@CAM_Nombre varchar(25),
@CAM_Descripcion varchar(50),
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10),
@CAM_FechaReg datetime,
@CAM_FechaAct datetime,
@CAM_FlagTarifario int,
@CAM_TipoValor varchar(1) ,
@CAM_CodigoContabilizacion varchar(8) 

/**********************************************
Procedimiento	: OSS_CAMPOTABLA_Insertar
Proposito	: Insertar  OSS_CAMPOTABLA
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
as

insert into OST_CAMPOTABLA 
(TDA_Codigo,CAT_Codigo,CAM_Nombre,
CAM_Descripcion,CAM_FechaReg,CAM_FechaAct,USU_UsuarioReg,USU_UsuarioAct,
CAM_FlagTarifario,CAM_TipoValor,CAM_CodigoContabilizacion ) 
VALUES (@TDA_Codigo,@CAT_Codigo,@CAM_Nombre,@CAM_Descripcion,
@CAM_FechaReg,@CAM_FechaAct,@USU_UsuarioReg,@USU_UsuarioAct,@CAM_FlagTarifario ,@CAM_TipoValor,@CAM_CodigoContabilizacion)




GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_Listar]

AS

SELECT TDA_Codigo 
	 CAM_Codigo,
	 CAM_Nombre,
	 CAM_Descripcion,
	 TDA_Codigo ,
	 CAM_FlagTarifario, 
	 CAM_TipoValor,
	isnull(CAM_CodigoContabilizacion ,'') as CAM_CodigoContabilizacion 
from OST_CAMPOTABLA
order by CAM_Nombre

GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_ListarPorCategoria]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_ListarPorCategoria]
@CAT_Codigo int

/**********************************************
Procedimiento	: OSS_CAMPOTABLA_ListarPorCategoria
Proposito		: Listar los campos por categoria
Entrada		: Codigo de Categoria
Salida		: Listado
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
AS

SELECT 	CAM_Codigo,CAM_Nombre,CAM_Descripcion,T.TDA_Codigo ,
	 CAM_FlagTarifario, CAM_TipoValor,T.TDA_Nombre ,isnull(CAM_CodigoContabilizacion ,'') as CAM_CodigoContabilizacion 
from 	OST_CAMPOTABLA C,
	OST_TIPO_DATO T
where 	CAT_Codigo=@CAT_Codigo
	AND  T.TDA_Codigo=C.TDA_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_ListarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_ListarPorCodigo]
@CAM_Codigo int
AS

SELECT *  from OST_CAMPOTABLA where CAM_Codigo=@CAM_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_ObtieneCodigoPorDescripcion]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_ObtieneCodigoPorDescripcion] 
@CAM_Descripcion as varchar(50)
AS

SELECT CAM_Codigo FROM OST_CAMPOTABLA
WHERE CAM_Descripcion=@CAM_Descripcion

GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_ObtieneDescripcionPorNombre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Ejecutar los siguientes scripts en la base de datos OrdenesServicio en N3ptunia11

ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_ObtieneDescripcionPorNombre] 
@CAM_Nombre as varchar(25)
AS

SELECT CAM_Descripcion FROM OST_CAMPOTABLA
WHERE CAM_Nombre=@CAM_Nombre


GO
/****** Object:  StoredProcedure [dbo].[OSS_CAMPOTABLA_ObtienePorNombre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CAMPOTABLA_ObtienePorNombre] 
@CAM_Nombre as varchar(25)

 AS

SELECT * FROM OST_CAMPOTABLA
WHERE CAM_Nombre=@CAM_Nombre



GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_Actualizar] 
@CAT_Codigo int,
@CAT_Nombre varchar(25),
@CAT_Descripcion varchar(50),
@USU_UsuarioAct varchar(10),
@CAT_FechaAct datetime
as

UPDATE OST_CATEGORIA_CAMPO 
SET 	CAT_Descripcion=@CAT_Descripcion,
	CAT_Nombre=@CAT_Nombre,
	USU_UsuarioAct=@USU_UsuarioAct,
	CAT_FechaAct=@CAT_FechaAct
WHERE CAT_Codigo=@CAT_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_Eliminar] 
@CAT_Codigo int ,
@resultado int output
AS

begin


set @resultado=0

if(not exists(select * from ost_campotabla where cat_codigo=@CAT_Codigo))
begin 
	delete from ost_categoria_campo where cat_codigo =@CAT_Codigo 
	set @resultado=1 
end

select @resultado as resultado 
------------------------------------------------------------------------------------
end



GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_Insertar]
@CAT_Descripcion varchar(25),
@CAT_Nombre varchar(50),
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10),
@CAT_FechaReg datetime,
@CAT_FechaAct datetime

/**********************************************
Procedimiento	: OSS_CATEGORIACAMPO_Insertar
Proposito	: Insertar OSS_CATEGORIACAMPO
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
as


insert into OST_CATEGORIA_CAMPO (CAT_Descripcion,CAT_Nombre,USU_UsuarioReg,USU_UsuarioAct,CAT_FechaReg,CAT_FechaAct)
values(@CAT_Descripcion,@CAT_Nombre,@USU_UsuarioReg,@USU_UsuarioAct,@CAT_FechaReg,@CAT_FechaAct)



GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_ListaPorNombre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_ListaPorNombre] 
@nombreCategoria as varchar(50)
AS

/**********************************************
Procedimiento	: OSS_CATEGORIA_CAMPO_ListaPorNombre
Proposito	: Buscar categoria por nombre
Entrada		: Nombre Categoria
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: Rocio Romero
******************************************/

SELECT * 
FROM OST_CATEGORIA_CAMPO 
WHERE upper(CAT_Nombre) like  '%' + upper(@nombreCategoria) + '%'
order by CAT_Nombre

GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_Listar]
AS
/**********************************************
Procedimiento	: OSS_CATEGORIACAMPO_Listar
Proposito	: Lista la categoria
Entrada		: Ninguna
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
SELECT CAT_Codigo,CAT_Nombre from OST_CATEGORIA_CAMPO ORDER BY CAT_Nombre

GO
/****** Object:  StoredProcedure [dbo].[OSS_CATEGORIACAMPO_ObtenerPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[OSS_CATEGORIACAMPO_ObtenerPorCodigo] 
@CAT_Codigo  int 

 AS

SELECT * FROM OST_CATEGORIA_CAMPO
WHERE CAT_Codigo=@CAT_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEARGUMENTO_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_COMPONENTEARGUMENTO_Eliminar] 
@tsv_Codigo int ,
@ces_secuencial int,
@car_secuencial int 
as

/**********************************************
Procedimiento	: OSS_COMPONENTEARGUMENTO_Eliminar
Proposito	: Elimina el Componente Argumento 
Entrada		: Ninguna
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/


delete ost_componente_Argumento
where 	tsv_Codigo=@tsv_Codigo and 
	ces_secuencial=@ces_secuencial and
	car_secuencial=@car_secuencial

GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEARGUMENTO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_COMPONENTEARGUMENTO_Insertar]
@TSV_Codigo int,
@ZON_Codigo int,
@CTR_Codigo int,
@CES_Secuencial int,
@CAR_Secuencial int,
@CAR_Orden smallint,
@CAR_Tipo char(1),
@CAR_IdCtrlStd int,
@CAR_CamCtrlStd int,
@CAR_IdCtrlEsp int,
@CAR_SecCtrlEsp int,
@CAR_NombreArgumento varchar(25),
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10),
@CAR_FechaReg datetime,
@CAR_FechaAct datetime ,
@car_nombrecontrol varchar(25) 


/**********************************************
Procedimiento	: OSS_COMPONENTEARGUMENTO_Insertar
Proposito	: Insertar OSS_COMPONENTEARGUMENTO
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
as 

insert into OST_COMPONENTE_ARGUMENTO
(TSV_Codigo,ZON_Codigo,CTR_Codigo,CES_Secuencial,
--CAR_Secuencial,
CAR_Orden,
CAR_FechaReg,CAR_FechaAct,USU_UsuarioReg,USU_UsuarioAct,
CAR_Tipo,CAR_IdCtrlStd,CAR_CamCtrlStd,CAR_IdCtrlEsp,CAR_SecCtrlEsp,CAR_NombreArgumento,car_nombrecontrol) 
values 
(@TSV_Codigo,@ZON_Codigo,@CTR_Codigo,@CES_Secuencial,
--@CAR_Secuencial,
@CAR_Orden, 
@CAR_FechaReg,@CAR_FechaAct,@USU_UsuarioReg,@USU_UsuarioAct, 
@CAR_Tipo,@CAR_IdCtrlStd,@CAR_CamCtrlStd,@CAR_IdCtrlEsp,@CAR_SecCtrlEsp,@CAR_NombreArgumento,@car_nombrecontrol)


GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEARGUMENTO_Seleccionar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_COMPONENTEARGUMENTO_Seleccionar] 
@tsv_Codigo int ,
@ces_secuencial int
as
/**********************************************
Procedimiento	: OSS_COMPONENTEARGUMENTO_Seleccionar
Proposito	: Selecciona los Componente Argumentos
Entrada		: Codigo del Tipo y Secuencial del Componente Especial 
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/
select 	car_secuencial,
	car_tipo,
	CAR_IdCtrlStd,
	CAR_CamCtrlStd,
	CAR_SecCtrlEsp, 
	CAR_IdCtrlEsp,
	car_nombreargumento,
	car_nombrecontrol ,
	zon_codigo,
	ctr_codigo 
from ost_componente_Argumento
where 	tsv_Codigo=@tsv_Codigo and 
	ces_secuencial=@ces_secuencial

GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESPECIAL_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_COMPONENTEESPECIAL_Actualizar]
@TSV_Codigo int,
@ZON_Codigo int,
@CTR_Codigo int,
@CES_Secuencial int,
@CES_FechaAct datetime,
@USU_UsuarioAct varchar(10) ,
@CES_NombreEtiqueta varchar(25) ,
@CES_NombreBaseDatos varchar(25) ,
@CES_NombreProcedure varchar(50) ,
@CES_NumArgEntrada int,
@CES_Path varchar(50) ,
@CES_ColPrincipal int ,
@CES_Estado varchar(1) ,
@CES_FlagObligatorio int ,
@CES_NombreCompleto varchar(50),
@CES_Descripcion varchar(50)

as 

/**********************************************
Procedimiento	: OSS_COMPONENTEESPECIAL_Actualizar
Proposito	: Actualiza el Componente Especial 
Entrada		: Campos 
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/

UPDATE OST_COMPONENTE_ESPECIAL 
SET 
	CES_FechaAct=@CES_FechaAct, 
	USU_UsuarioAct= @USU_UsuarioAct, 
	CES_NombreEtiqueta=@CES_NombreEtiqueta,
	CES_NombreBaseDatos =@CES_NombreBaseDatos,
	CES_NombreProcedure=@CES_NombreProcedure ,
	CES_NombreCompleto=upper(@CES_NombreCompleto),
	CES_NumArgEntrada=@CES_NumArgEntrada,
	CES_Path=@CES_Path,
	CES_ColPrincipal=@CES_ColPrincipal,
	CES_Estado=@CES_Estado ,
	CES_FlagObligatorio=@CES_FlagObligatorio ,
	CES_Descripcion=@CES_Descripcion ,
	ZON_Codigo=@ZON_Codigo,
	CTR_Codigo= @CTR_Codigo 

WHERE 	TSV_Codigo=@TSV_Codigo AND
	CES_Secuencial=@CES_Secuencial

UPDATE OST_COMPONENTE_ARGUMENTO
SET	ZON_Codigo=@ZON_Codigo,
	CTR_Codigo= @CTR_Codigo 
WHERE 	TSV_Codigo=@TSV_Codigo AND
	CES_Secuencial=@CES_Secuencial




GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESPECIAL_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_COMPONENTEESPECIAL_Insertar]
@TSV_Codigo int,
@ZON_Codigo int,
@CTR_Codigo int,
--@CES_Secuencial int,
@CES_NombreBaseDatos varchar(25),
@CES_NombreProcedure varchar(50),
@CES_NumArgEntrada smallint,
@CES_Descripcion varchar(50),
@CES_Path varchar(50),
@CES_ColPrincipal int ,
@CES_FechaReg datetime,
@CES_FechaAct datetime,
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10),
@CES_NombreCompleto varchar(50),
@CES_NombreEtiqueta varchar(25),
@CES_FlagObligatorio int ,
@CES_Estado varchar(1) 
as

/**********************************************
Procedimiento	: OSS_COMPONENTEESPECIAL_Insertar
Proposito	: Insertar OSS_COMPONENTEESPECIAL
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/

insert into OST_COMPONENTE_ESPECIAL (TSV_Codigo,ZON_Codigo,CTR_Codigo,
--CES_Secuencial,
CES_NombreBaseDatos,CES_NombreProcedure,CES_NumArgEntrada,
CES_Descripcion,CES_Path,CES_ColPrincipal,CES_FechaReg,CES_FechaAct,USU_UsuarioReg,USU_UsuarioAct,
CES_NombreCompleto,CES_NombreEtiqueta,CES_FlagObligatorio,CES_Estado )

values(@TSV_Codigo,@ZON_Codigo,@CTR_Codigo,
--@CES_Secuencial,
@CES_NombreBaseDatos,@CES_NombreProcedure,@CES_NumArgEntrada,@CES_Descripcion,
@CES_Path,@CES_ColPrincipal,
@CES_FechaReg,@CES_FechaAct,@USU_UsuarioReg,@USU_UsuarioAct,
upper(@CES_NombreCompleto),@CES_NombreEtiqueta,@CES_FlagObligatorio,@CES_Estado 
)

select  @@identity AS Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESPECIAL_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[OSS_COMPONENTEESPECIAL_SeleccionarPorCodigo]
@codTOS int,
@codEstado char 

 AS
/**********************************************
*
*
*
*
*
*
******************************************/

select 
	TSV_Codigo,                                                                                                                       
	ZON_Codigo,
	CTR_Codigo,
	CES_NombreBaseDatos,
	CES_NombreProcedure,
	CES_NumArgEntrada,
	CES_FechaReg,
	CES_FechaAct,
	USU_UsuarioReg,
	USU_UsuarioAct,
	isnull(CES_Descripcion,'') CES_Descripcion,
	CES_Secuencial,
	isnull(CES_Path,'') CES_Path,
	isnull(CES_ColPrincipal,0) CES_ColPrincipal,
	CES_NombreCompleto,
	isnull(CES_NombreEtiqueta,'') CES_NombreEtiqueta,
	CES_FlagObligatorio,
	CES_Estado 
 
from OST_COMPONENTE_ESPECIAL
where   TSV_Codigo= @codTOS
	AND ((CES_Estado=@codEstado) or (@codEstado =''))
order by ces_nombrecompleto 
--order by substring(ces_nombrecompleto,2,len(ces_nombrecompleto)-1)




GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESPECIAL_SeleccionarPorSecuencial]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_COMPONENTEESPECIAL_SeleccionarPorSecuencial]
@secuencial int 

 AS

select 
	TSV_Codigo,                                                                                                                       
	ZON_Codigo,
	CTR_Codigo,
	CES_NombreBaseDatos,
	CES_NombreProcedure,
	CES_NumArgEntrada,
	CES_FechaReg,
	CES_FechaAct,
	USU_UsuarioReg,
	USU_UsuarioAct,
	isnull(CES_Descripcion,'') CES_Descripcion,
	CES_Secuencial,
	isnull(CES_Path,'') CES_Path,
	isnull(CES_ColPrincipal,0) CES_ColPrincipal,
	CES_NombreCompleto,
	isnull(CES_NombreEtiqueta,'') CES_NombreEtiqueta,
	CES_FlagObligatorio,
	CES_Estado 
 
from OST_COMPONENTE_ESPECIAL
where   CES_Secuencial= @secuencial





GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESTANDAR_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_COMPONENTEESTANDAR_Actualizar]
@TSV_Codigo int,
@ZON_Codigo int,
@CAM_Codigo int,
@CTR_Codigo int,
@CST_FechaAct datetime,
@USU_UsuarioAct varchar(10) ,
@CST_NombreEtiqueta varchar(50) ,
@CST_Estado varchar(1) ,
@CST_FlagEditable  int,
@CST_Flagobligatorio int,
@CST_NombreCompleto varchar(50),
@CST_Tamano int,
@CST_Ancho int 


as 

UPDATE OST_COMPONENTE_ESTANDAR
SET 
	CST_FechaAct=@CST_FechaAct, 
	USU_UsuarioAct= @USU_UsuarioAct, 
	CST_NombreEtiqueta=@CST_NombreEtiqueta ,
	CST_Estado =@CST_Estado,
	CST_FlagEditable=@CST_FlagEditable,
	CST_Flagobligatorio=@CST_Flagobligatorio,
	CST_NombreCompleto=upper(@CST_NombreCompleto),
	CST_Tamano=@CST_Tamano, 
	CST_Ancho=@CST_Ancho,
	ZON_Codigo=@ZON_Codigo,
	CTR_Codigo= @CTR_Codigo 

WHERE TSV_Codigo=@TSV_Codigo AND
	  CAM_Codigo=@CAM_Codigo

GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESTANDAR_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_COMPONENTEESTANDAR_Insertar]

@TSV_Codigo int,
@ZON_Codigo int,
@CAM_Codigo int,
@CTR_Codigo int,
@CST_Tamaño int,
@CST_FlagObligatorio tinyint,
@CST_FlagEditable tinyint,
@CST_NombreCompleto varchar(50),
@CST_FechaAct datetime,
@CST_FechaReg datetime, 
@USU_UsuarioReg varchar(10), 
@USU_UsuarioAct varchar(10) ,
@CST_NombreEtiqueta varchar(50) ,
@CST_Estado varchar(1) ,
@CST_Ancho int 


/**********************************************
Procedimiento	: OSS_COMPONENTEESTANDAR_Insertar
Proposito	: Insertar OSS_COMPONENTEESTANDAR
Entrada		: Los parametros
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/

as 

insert into OST_COMPONENTE_ESTANDAR(TSV_Codigo,ZON_Codigo,CAM_Codigo,CTR_Codigo,CST_NombreCompleto,CST_Tamano,CST_FlagObligatorio,CST_FlagEditable,
CST_FechaAct,CST_FechaReg,USU_UsuarioReg,USU_UsuarioAct,CST_NombreEtiqueta,CST_Estado ,CST_Ancho) 

values(@TSV_Codigo,@ZON_Codigo,@CAM_Codigo,@CTR_Codigo,upper(@CST_NombreCompleto),@CST_Tamaño,@CST_FlagObligatorio,@CST_FlagEditable,
@CST_FechaAct,@CST_FechaReg,@USU_UsuarioReg,@USU_UsuarioAct,@CST_NombreEtiqueta,@CST_Estado,@CST_Ancho)


GO
/****** Object:  StoredProcedure [dbo].[OSS_COMPONENTEESTANDAR_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




ALTER PROCEDURE [dbo].[OSS_COMPONENTEESTANDAR_SeleccionarPorCodigo]
@codTOS as int,
@codEstado char 
 AS
/**********************************************
*
*
*
*
*
*
******************************************/

select * 
from OST_Componente_Estandar
where   TSV_Codigo= @codTOS
	AND ((CST_Estado='A' or @codEstado=''))
order by substring(cst_nombrecompleto,2,len(cst_nombrecompleto)-1)




GO
/****** Object:  StoredProcedure [dbo].[OSS_CONTROL_ListarEspecial]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_CONTROL_ListarEspecial]
as

SELECT CTR_Codigo,CTR_Nombre from OST_CONTROL
WHERE CTR_TipoControl='S' and CTR_Estado='A'


GO
/****** Object:  StoredProcedure [dbo].[OSS_CONTROL_ListarEstandar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_CONTROL_ListarEstandar]
as

SELECT CTR_Codigo,CTR_Nombre 
from OST_CONTROL 
WHERE CTR_TipoControl='E' and CTR_Estado='A'


GO
/****** Object:  StoredProcedure [dbo].[OSS_CONTROL_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_CONTROL_SeleccionarPorCodigo]
@codControl int
 AS
/**********************************************
*
*
*
*
*
*
******************************************/

select * 
from OST_CONTROL
where CTR_Codigo= @codControl


GO
/****** Object:  StoredProcedure [dbo].[OSS_DETALLE_HIJO1]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_DETALLE_HIJO1]
@OSE_CODIGO int
AS
SELECT 
OAH.EST_Codigo estadocodiaudihijo,
OAH.AOH_FechaHoraInicio,
OAH.AOH_FechaHoraFin,
E.EST_Nombre estadonomaudihijo,

OSH.OSH_Codigo codihijo,
EOSH.EST_Nombre ultimoestadodehijo,

OS.OSE_Codigo codipadre,
OS.OSE_Descripcion descripadre,
T.TSV_Nombre tiposervicio,
A.ARE_Nombre,
VLU.USU_Nombres + '  ' + VLU.USU_Paterno + '  ' + VLU.USU_Materno NombreUsuario,
VLU.USU_Codigo
FROM 	OST_ORDEN_SERVICIO OS,
	OST_ORDEN_SERVICIO_HIJO OSH,
	OST_ESTADO E,
	OST_ESTADO EOSH,
OST_TIPO_SERVICIO T,


	OST_AUDITORIA_ORDEN_HIJO OAH,
	SGV_Lista_Usuario VLU,
SGV_LISTA_AREA A
WHERE 	OS.OSE_CODIGO=OSH.OSE_CODIGO AND
 OS.TSV_Codigo=T.TSV_Codigo and 
T.ARE_Codigo=A.ARE_Codigo and
	OSH.OSE_CODIGO=OAH.OSE_CODIGO AND
	OSH.OSH_Codigo=OAH.OSH_Codigo AND
	OAH.EST_CODIGO=E.EST_CODIGO  AND
OSH.EST_Codigo=EOSH.EST_Codigo and 
	OAH.USU_Codigo=VLU.USU_codigo AND
	OSH.OSE_Codigo = @OSE_Codigo and
	OS.OSE_Codigo=@OSE_Codigo and 
	OAH.OSE_Codigo=@OSE_Codigo






GO
/****** Object:  StoredProcedure [dbo].[OSS_DETALLE_X_USUARIO]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_DETALLE_X_USUARIO]
@ARE_CODIGO INT,
@TSV_CODIGO INT,
@EST_CODIGO INT,
@USU_CODIGO VARCHAR(10),
@FECHA_INICIO DATETIME,
@FECHA_FIN DATETIME
AS
SELECT OSE.OSE_Codigo padrecodi,
OSE.OSE_Descripcion padredescri,
OSE.OSE_CodigoOrigen,
OSE.OSE_Fecha padrefecha,
OSE.EST_Codigo padreestadocodi,
EOSE.EST_Nombre padreestnom,
OSE.TSV_Codigo padrecodtiposerv,
T1.TSV_Nombre padrenomtiposerv,
OSH.OSH_Codigo hijocodi,
OSH.EST_Codigo hijoestadocodi,
EOSH.EST_Nombre hijoestadonombre, 
AOH.EST_Codigo audihijocodiest,
AOH.AOH_FechaHoraInicio audihijofechini,
AOH.AOH_FechaHoraFin audihijofechfin,
EAOH.EST_Nombre audihijonomestado,
AO.USU_Codigo audipadrecodiusu,
AO.AUO_FechaHoraInicio audipadrefechini,
U.USU_Nombres+' '+U.USU_Paterno+' '+U.USU_Materno  padreusunom,
A.ARE_Nombre areapadre

from OST_ORDEN_SERVICIO OSE,
OST_ORDEN_SERVICIO_HIJO OSH,
OST_AUDITORIA_ORDEN AO,
OST_AUDITORIA_ORDEN_HIJO AOH,
OST_ESTADO EOSE,
OST_ESTADO EAOH,
OST_ESTADO EOSH,
OST_TIPO_SERVICIO T1,
SGV_Lista_Usuario U,
SGV_Lista_Area A



WHERE 
OSE.TSV_Codigo in (select TSV.TSV_Codigo from OST_TIPO_SERVICIO TSV WHERE TSV.ARE_Codigo=@ARE_CODIGO) AND 
OSE.TSV_Codigo=@TSV_CODIGO AND
OSE.TSV_Codigo=T1.TSV_Codigo and 
T1.ARE_Codigo=A.ARE_Codigo and 
EOSE.EST_Codigo=@EST_CODIGO AND 
OSE.EST_Codigo=@EST_CODIGO AND 
OSE.EST_Codigo=EOSE.EST_Codigo and
OSE.OSE_FECHA >= Convert(datetime,Rtrim(Ltrim(@FECHA_INICIO))) AND
OSE.OSE_FECHA<= Convert(datetime,Rtrim(Ltrim(@FECHA_FIN))) and
AO.OSE_Codigo=OSE.OSE_Codigo and
AO.EST_Codigo=OSE.EST_Codigo and
AO.USU_Codigo=@USU_CODIGO AND 
AO.USU_Codigo=U.USU_CODIGO AND 
OSH.OSE_Codigo=OSE.OSE_Codigo and
EOSH.EST_Codigo=OSH.EST_Codigo and
AOH.OSE_Codigo=OSH.OSE_Codigo and
AOH.OSH_Codigo=OSH.OSH_Codigo and
EAOH.EST_Codigo=AOH.EST_Codigo and
OSE.TSV_Codigo=@TSV_Codigo
 




GO
/****** Object:  StoredProcedure [dbo].[OSS_ESTADO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_ESTADO_Listar]
as

SELECT EST_Codigo,EST_Nombre, EST_Color  from OST_ESTADO




GO
/****** Object:  StoredProcedure [dbo].[OSS_ESTADO_ListarPorArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ESTADO_ListarPorArea]
@ARE_CodigoInterno varchar(5) 
as

SELECT 	distinct E.EST_CODIGO, E.EST_NOMBRE 
from 	OST_ESTADO E,
	OST_WORKFLOW_ESTADO WE,
	OST_TIPO_SERVICIO TS,
	SGV_Lista_Area A 
WHERE 	WE.EST_Codigo=E.EST_Codigo
	and WE.TSV_Codigo=TS.TSV_Codigo
	and TS.ARE_Codigo=A.ARE_Codigo 
	and rtrim(ltrim(A.ARE_CodigoInterno))=@ARE_CodigoInterno
	and e.EST_Codigo<>2



GO
/****** Object:  StoredProcedure [dbo].[OSS_ESTADO_ListarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ESTADO_ListarPorCodigo]
@EST_Codigo int 
as

SELECT *   from OST_ESTADO
WHERE EST_Codigo=@EST_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_Listar_TipoOS]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_Listar_TipoOS]

 AS

SELECT TSV.TSV_Codigo , LAR.ARE_Nombre,PLA.PLA_NombreLogico , TSV.TSV_Nombre 
FROM  OST_TIPO_SERVICIO TSV, SGV_Lista_Area LAR, OST_Plantilla PLA
WHERE TSV.PLA_Codigo = PLA.PLA_Codigo
AND   TSV.ARE_Codigo = LAR.ARE_Codigo
order by 1



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENESSERVICIO_ListaTransporte]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENESSERVICIO_ListaTransporte]    
@OSE_Codigo int    
AS      
     
--set   @OSE_Codigo = 147791    
DECLARE     
@plantilla int, @tipomov char(1), @tipomerc char(1),       
@idtipomov int, @condcontenedor int, @idOrden int,       
@distrito varchar(50), @zona int     
    
    
SELECT @plantilla = TSV_Codigo      
FROM  OST_ORDEN_SERVICIO O (NOLOCK)      
WHERE OSE_Codigo = @OSE_Codigo      
      
--Calle Impo      
IF @plantilla = 59      
BEGIN      
 SET @idtipomov = 1 --calleimportacion      
 SET @tipomov = 'C' --calle      
 SET @tipomerc = 'C' --contenedor      
 SET @condcontenedor = 1 --LLENO       
END      
      
--Calle Expo      
IF @plantilla = 60      
BEGIN      
 SET @idtipomov = 2 --calleexportacion      
 SET @tipomov = 'C' --calle      
 SET @tipomerc = 'C' --contenedor      
 SET @condcontenedor = 1 --LLENO       
END      
      
--Calle Posicionamiento      
IF @plantilla = 61      
BEGIN      
 SET @idtipomov = 3 --calleposicionamiento      
 SET @tipomov = 'C' --calle      
 SET @tipomerc = 'C' --contenedor      
 SET @condcontenedor = 2 --VACIO       
END      
      
--Calle Carga Suelta      
IF @plantilla = 62      
BEGIN      
 SET @idtipomov = 4 --callecargasuelta      
 SET @tipomov = 'C' --calle      
 SET @tipomerc = 'S' --carga suelta      
END      
      
--Otros      
IF @plantilla = 63      
BEGIN      
 SET @idtipomov = 12 --otros      
 SET @tipomov = 'T' --otros      
 SET @tipomerc = 'S' --carga suelta      
END      
      
--Operativo CTN Embarque/Descarga/Falso Embarque      
IF @plantilla = 64      
BEGIN      
 --El tipo y condición se seleccionan      
 SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181),      
        @condcontenedor = dbo.fn_BuscaDatos(O.OSE_Codigo,224)      
 FROM  OST_ORDEN_SERVICIO O (NOLOCK)      
 WHERE OSE_Codigo = @OSE_Codigo      
      
 SET @tipomov = 'O' --operativo      
 SET @tipomerc = 'C' --contenedor      
END      
      
--Operativo C/S Embarque/Descarga/Falso Embarque      
IF @plantilla = 65      
BEGIN      
 --El tipo se selecciona      
 SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181)      
 FROM  OST_ORDEN_SERVICIO O (NOLOCK)      
 WHERE OSE_Codigo = @OSE_Codigo      
      
 SET @tipomov = 'O' --operativo      
 SET @tipomerc = 'S' --carga suelta      
END      
      
--Operativo CTN Devolución/Posicionamiento/Traslado      
IF @plantilla = 66      
BEGIN      
 --El tipo se selecciona      
 SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181)      
 FROM  OST_ORDEN_SERVICIO O (NOLOCK)      
 WHERE OSE_Codigo = @OSE_Codigo      
      
 SET @tipomov = 'O' --operativo      
 SET @tipomerc = 'C' --contenedor      
 SET @condcontenedor = 2 --VACIO      
END      
      
--Operativo CTN Descarga Directa      
IF @plantilla = 68      
BEGIN      
 SET @idtipomov = 11      
 SET @tipomov = 'O' --operativo      
 SET @tipomerc = 'C' --contenedor      
 SET @condcontenedor = 1 --LLENO      
END      
      
--Operativo C/S Descarga Directa      
IF @plantilla = 69      
BEGIN      
 SET @idtipomov = 11      
 SET @tipomov = 'O' --operativo      
 SET @tipomerc = 'S' --Carga Suelta      
END      
      
--Buscando la zona, para posicionamiento se usa una zona que no maneja distritos      
IF @plantilla = 61      
BEGIN      
 SET @zona = 39      
END      
ELSE      
BEGIN      
 SELECT @distrito = isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,235),'')      
 FROM  OST_ORDEN_SERVICIO O (NOLOCK)      
 WHERE OSE_Codigo = @OSE_Codigo      
      
 SELECT @zona = Zona      
 FROM Logistica.dbo.SB_Zona (NOLOCK)      
 WHERE TipoTransporte = 'T' AND Descripcion LIKE '%'+@distrito+'%'      
END      
      
--Insertando la Orden      
    
SELECT DISTINCT        
convert(datetime,OSE_Fecha_Req + ' '+ OSE_Hora_Req,103) as FechaRegistro,                   
--H.CON_Codigo,       
--@tipomov as TipoMovimiento,       
--@idtipomov as TipoTransporte,      
--@tipomerc as TipoMercaderia,      
dbo.fn_BuscaDatos(O.OSE_Codigo,151) as RucCliente,       
dbo.fn_BuscaDatos(O.OSE_Codigo,152) as Cliente,       
--dbo.fn_BuscaDatos(O.OSE_Codigo,185) as RucConsig,      
--dbo.fn_BuscaDatos(O.OSE_Codigo,101) as codNave,       
--dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,         
--   dbo.fn_BuscaDatos(O.OSE_Codigo,148) as Booking,       
--dbo.fn_BuscaDatos(O.OSE_Codigo,223) as TipoContenedor,       
--@condcontenedor as CondContenedor,       
dbo.fn_BuscaDatos(O.OSE_Codigo,184) as CantCont20,      
dbo.fn_BuscaDatos(O.OSE_Codigo,183) as CantCont40,      
CASE isnull(@condcontenedor,0)      
WHEN 1 THEN cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,183),'0') as decimal(5,1)) + cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,184),'0') as decimal(5,1))      
WHEN 2 THEN round(cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,183),'0') as decimal(5,1)) + (cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,184),'0') as decimal(5,1))/2),0)       
ELSE isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,238),'0')      
END as Cantviajes,        
CASE RTRIM(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,239),'0'))       
WHEN '' THEN '0'      
ELSE isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,239),'0')      
END      
as Peso,       
dbo.fn_BuscaDatos(O.OSE_Codigo,226) as PersonaInicio,      
dbo.fn_BuscaDatos(O.OSE_Codigo,193) as DireccionInicio,      
dbo.fn_BuscaDatos(O.OSE_Codigo,227) as PersonaIntermedio,      
dbo.fn_BuscaDatos(O.OSE_Codigo,225) as DireccionIntermedio,      
dbo.fn_BuscaDatos(O.OSE_Codigo,228) as PersonaFinal,      
dbo.fn_BuscaDatos(O.OSE_Codigo,196) as DireccionFinal,      
dbo.fn_BuscaDatos(O.OSE_Codigo,235) as Distrito,       
@zona as Zona,      
dbo.fn_BuscaDatos(O.OSE_Codigo,222) as Observacion,      
dbo.fn_BuscaDatos(O.OSE_Codigo,237) as Prioridad    
--'R' as Estado,                
--substring(us.USU_CodigoInterno,1,20) as UsuarioCreador,       
--getdate() as FechaCreacion,         
--substring(us.USU_CodigoInterno,1,20) as UsuarioModificador,       
--getdate() as FechaModificacion,              
--O.OSE_Codigo       
FROM  OST_ORDEN_SERVICIO O                 
inner join OST_tipo_servicio as T on O.tsv_codigo = T.tsv_codigo               
inner join OST_ORDEN_SERVICIO_HIJO as H on O.OSE_Codigo = H.OSE_Codigo         
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo                
left join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo                
WHERE O.OSE_Codigo = @OSE_Codigo                 
and ao.est_codigo = 1      
return 0    


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_Actualizar]   
@OSE_Codigo as integer,  
@EST_Codigo as integer,  
@OSE_Descripcion as varchar(50)   
AS  
BEGIN 
	DECLARE @NORORS VARCHAR(6)
	SET @NORORS = CAST(@OSE_Codigo AS VARCHAR(6))
	
	IF EXISTS(
				SELECT *
				FROM TERMINAL..DDORDSER32 WITH (NOLOCK)
				WHERE nroors32 = @NORORS
				AND status32 <> 'A'
				AND ISNULL(nrofac37,'') <> ''
			 )
	BEGIN
		IF EXISTS( 
					SELECT * FROM TERMINAL..DDORDSER32 A WITH (NOLOCK)
					INNER JOIN TERMINAL..DDFACTUR37 B WITH (NOLOCK) ON A.nrofac37 = B.nrofac37
					WHERE B.status37 <> 'A'
					AND  nroors32 = @NORORS	   
				  )
		BEGIN
			PRINT 'EXITOSA'
			RETURN;
		END
	END
	
	UPDATE OST_ORDEN_SERVICIO  
	SET   
		EST_Codigo=@EST_Codigo,  
		OSE_Descripcion=@OSE_Descripcion   
	WHERE 
		OSE_Codigo=@OSE_Codigo  
END



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_AdmBandeja]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_AdmBandeja]   
@FechaIni char(8),  
@FechaFin char(8),  
@USU_Codigo varchar(10) ,  
@TSV_Codigo int   
  
AS   
  
SELECT distinct O.OSE_Codigo, O.OSE_CodigoOrigen,   
  O.OSE_Fecha, O.EST_Codigo ,  
  E.EST_Color , E.EST_Descripcion    
FROM  OST_ORDEN_SERVICIO O,  
 OST_WORKFLOW_ESTADO WE,  
 OST_ESTADO E,  
 OST_PERMISO_WORKFLOW PW   
   
WHERE convert(varchar(8), O.OSE_Fecha, 112) between  @FechaIni
	AND dateadd(d,1,@FechaFin)
 AND O.TSV_Codigo=@TSV_Codigo   
 AND O.TSV_Codigo=WE.TSV_Codigo  
 AND O.EST_Codigo=WE.EST_CodigoOrigen  
 AND WE.EST_Codigo=PW.EST_Codigo  
 AND WE.EST_CodigoOrigen=E.EST_Codigo   
 AND WE.TSV_Codigo=PW.TSV_Codigo  
 AND PW.USU_Codigo=@USU_Codigo  
order by O.OSE_Fecha desc



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_Insertar]   
@TSV_Codigo as integer,  
@EST_Codigo as integer,  
@OSE_Fecha as datetime,  
@OSE_FlagServicioIntegral as integer ,  
@ARE_CodigoInterno as varchar(10) ,  
@FlagRequiereSenasa char(1),  
@OSE_Fecha_Req varchar(12),  
@OSE_Hora_Req char(5),
@DESPACHADOR varchar(50)  
AS  
  
SET NOCOUNT ON  
  
  
INSERT INTO OST_ORDEN_SERVICIO   
    (TSV_Codigo, EST_Codigo, OSE_Fecha, OSE_FlagServicioIntegral,ARE_CodigoInterno,FlagRequiereSenasa,OSE_Fecha_Req,OSE_Hora_Req)  
 VALUES (@TSV_Codigo,@EST_Codigo,@OSE_Fecha,@OSE_FlagServicioIntegral,@ARE_CodigoInterno,@FlagRequiereSenasa,@OSE_Fecha_Req,@OSE_Hora_Req)  
  
  
SELECT @@IDENTITY  
  
--select max(TSV_Codigo) from OST_ORDEN_SERVICIO  
  
  
SET NOCOUNT OFF  
  
  
  
  


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_Insertar_dua]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_Insertar_dua]       
@TSV_Codigo as integer,        
@EST_Codigo as integer,        
@OSE_Fecha as datetime,        
@OSE_FlagServicioIntegral as integer ,        
@ARE_CodigoInterno as varchar(10) ,        
@FlagRequiereSenasa char(1),        
@OSE_Fecha_Req varchar(12),        
@OSE_Hora_Req char(5),      
@DESPACHADOR varchar(50),    
@DUA varchar(60),    
@CANAL varchar(10)        
AS        
        
SET NOCOUNT ON        
        
        
INSERT INTO OST_ORDEN_SERVICIO         
    (TSV_Codigo, EST_Codigo, OSE_Fecha, OSE_FlagServicioIntegral,ARE_CodigoInterno,FlagRequiereSenasa,OSE_Fecha_Req,OSE_Hora_Req, OSE_Dua, OSE_Canal,OSE_Despachador)      --SE AGREGO DESPACHADOR SE MANDARA EL CODIGO DEL DESPACHADOR  
 VALUES (@TSV_Codigo,@EST_Codigo,@OSE_Fecha,@OSE_FlagServicioIntegral,@ARE_CodigoInterno,@FlagRequiereSenasa,@OSE_Fecha_Req,@OSE_Hora_Req, @DUA, @CANAL,@DESPACHADOR)        --SE AGREGO DESPACHADOR SE MANDARA EL CODIGO DEL DESPACHADOR  
        
        
SELECT @@IDENTITY        
        
--select max(TSV_Codigo) from OST_ORDEN_SERVICIO        
        
        
SET NOCOUNT OFF 
GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_ListarporNroOrden]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_ListarporNroOrden]  
@NROORDEN int  
as  
SELECT     
ts.Nombre as nombreServicio,  
O.OSE_Fecha as FechaRegistro,  
us.usu_codigoInterno as Usuario,  
o.ose_fecha_req + ' '+ ose_hora_req + ':00' as FechaRealizacion,  
case when dbo.fn_BuscaDatos(O.OSE_Codigo,151) is not null then dbo.fn_BuscaDatos(O.OSE_Codigo,151)  
else dbo.fn_BuscaDatos(O.OSE_Codigo,160) end as cliente,  
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,  
--dbo.fn_BuscaDatos(O.OSE_Codigo,108) as AgenteAdunas,  
dbo.fn_BuscaDatos(O.OSE_Codigo,114) as linea,  
case when fc1.oc_valor is not null then fc1.oc_valor  
else fc5.oc_valor end as CodigoCont,  
fc2.oc_valor as tipoCont,  
fc3.oc_valor as Tamanio,  
fc4.oc_valor as Condicion  
FROM  OST_ORDEN_SERVICIO O     
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo     
inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo    
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo    
left join dbo.fn_BuscaDatostabla (@NROORDEN,139) as fc1 on o.ose_codigo = fc1.ose_codigo       
left join dbo.fn_BuscaDatostabla (@NROORDEN,136) as fc5 on o.ose_codigo = fc5.ose_codigo       
left join dbo.fn_BuscaDatostabla (@NROORDEN,140) as fc2 on o.ose_codigo = fc2.ose_codigo       
left join dbo.fn_BuscaDatostabla (@NROORDEN,141) as fc3 on o.ose_codigo = fc3.ose_codigo       
left join dbo.fn_BuscaDatostabla (@NROORDEN,142) as fc4 on o.ose_codigo = fc4.ose_codigo       
left join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo    
WHERE   
fc2.cam_index = case when fc1.cam_index is not null then fc1.cam_index  
                else fc5.cam_index end  
and fc2.cam_index = fc3.cam_index    
AND fc2.cam_index = fc4.cam_index   
and O.OSE_Codigo = @NROORDEN     
and ao.est_codigo = 1    
return 0  




GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_Mantenimiento]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_Mantenimiento]
@USU_Codigo varchar(10) ,
@TSV_Codigo int 

AS 

SELECT O.OSE_Codigo, 
	 O.OSE_CodigoOrigen, 
	O.OSE_Fecha, 
	O.EST_Codigo,
	O.OSE_Descripcion,
	 E.EST_Descripcion   
FROM 	OST_ORDEN_SERVICIO O,
	OST_WORKFLOW_ESTADO WE,
	OST_ESTADO E,
	OST_PERMISO_WORKFLOW PW 
WHERE
	O.TSV_Codigo=WE.TSV_Codigo
	AND O.EST_Codigo=WE.EST_CodigoOrigen
	AND WE.EST_Codigo=PW.EST_Codigo
	AND WE.EST_Codigo=E.EST_Codigo 
	AND WE.TSV_Codigo=PW.TSV_Codigo
	AND PW.USU_Codigo=@USU_Codigo
	AND O.TSV_Codigo=@TSV_Codigo
order by 1



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_MantenimientoLista]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--dbo.OSS_ORDENSERVICIO_MantenimientoLista  '1', '20070816', '20071129', '', '48','33','4984','027888', '',''

ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_MantenimientoLista]  
@Area varchar(5),      
@FechaiNi varchar(8),      
@FechaFin varchar(8),      
@Estado varchar(2),      
@TipoServicio int,      
@ConceptoServicio varchar(5),      
@Agente varchar(4),      
@NaveViaje varchar(6),      
@Nave VARCHAR(30),      
@Cliente varchar (11)      
      
AS      
/*  

set @Area = '1'
set @FechaiNi =  '20070816'    
set @FechaFin = '20071129'
set @Estado = ''
set @TipoServicio = '48'
set @ConceptoServicio = '33'   
set @Agente = '4984'  
set @NaveViaje = '027888' 
set @Nave = 'CAP ORTEGAL'
set @Cliente = '' 
*/

declare @cadena varchar(400)      
set @cadena =''      
      
declare @cadena1 varchar(5000)      
set @cadena1 =''      
      
      
if rtrim(ltrim(@Estado)) <> ''      
begin      
set @Estado=rtrim(ltrim(@Estado))      
set @cadena = @cadena + ' and O.EST_Codigo = convert(int,''' +  @Estado + ''') '      
end      
      
if rtrim(ltrim(@ConceptoServicio)) <> ''      
begin      
set @ConceptoServicio= rtrim(ltrim(@ConceptoServicio)) set @cadena = @cadena + ' and s.CON_Codigo = convert(int,''' + @ConceptoServicio + ''') '      
end      
      
if rtrim(ltrim(@Agente)) <> ''      
begin      
set @Agente=rtrim(ltrim(@Agente))      
set @cadena = @cadena + ' and      
rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,108)))      
=  rtrim(ltrim(''' + @Agente + ''')) '      
end      
      
if rtrim(ltrim(@NaveViaje)) <> ''      
begin      
set @NaveViaje=rtrim(ltrim(@NaveViaje))      
set @cadena = @cadena + 'and rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,103)))      
=  rtrim(ltrim(''' + @NaveViaje + ''')) '      
end      
      
if rtrim(ltrim(@Nave)) <> '' and rtrim(ltrim(@NaveViaje)) = ''       
begin      
set @Nave=rtrim(ltrim(@Nave))      
set @cadena = @cadena + 'and rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,102)))      
=  rtrim(ltrim(''' + @Nave + ''')) '      
end      
      
/*if rtrim(ltrim(@Cliente)) <> ''      
begin      
set @Cliente= rtrim(ltrim(@Cliente))      
set @cadena = @cadena + 'and      
rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,151))) =  rtrim(ltrim(''' + @Cliente + ''')) '      
end      
*/      
    
--select @cadena  
      
begin      
      
exec(      
'SELECT distinct      
O.OSE_Codigo,      
O.OSE_CodigoOrigen,      
O.OSE_Fecha,      
O.EST_Codigo,      
O.OSE_Descripcion,      
E.EST_Descripcion,      
ts.nombre as CON_NOMBRE ,      
A.ARE_Nombre,      
uo.usu_codigoInterno as usuario,  
em.emp_nombre as Empresa,  
dbo.fn_BuscaDatos(O.OSE_Codigo,116) as Volante,      
dbo.fn_BuscaDatos(O.OSE_Codigo,102) as nave,      
dbo.fn_BuscaDatos(O.OSE_Codigo,104) as viaje,      
dbo.fn_BuscaDatos(O.OSE_Codigo,109) as AgenteAdu,      
dbo.fn_BuscaDatos(O.OSE_Codigo,152) as Cliente,      
dbo.fn_BuscaDatos(O.OSE_Codigo,108) as CodigoAgente,      
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,    
 O.ARE_CODIGOINTERNO, s.CON_Codigo     
FROM  OST_ORDEN_SERVICIO O inner join OST_ESTADO E  on  O.EST_Codigo=E.EST_Codigo     
inner join seguridad.dbo.sgt_area as A on A.ARE_CODIGOInterno = O.ARE_CODIGOINTERNO       
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo      
INNER JOIN OST_AUDITORIA_ORDEN as AO on o.ose_codigo = ao.ose_codigo and o.est_codigo = ao.est_codigo  
inner join seguridad.dbo.SGT_USUARIO as uo on ao.usu_codigo = uo.usu_codigo  
inner join seguridad.dbo.SGT_EMPRESA as em on uo.emp_codigo = em.emp_codigo   
WHERE O.ARE_CODIGOINTERNO = ' + @Area + '      
  and O.EST_Codigo <> 2      
  and O.OSE_Fecha between ''' + @FechaiNi + '''      
  and  dateadd(dd,1,''' + @FechaFin + ''') ' +  @cadena + ' order by o.ose_codigo '      
      
)         
end      


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_MantenimientoLista1]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--dbo.OSS_ORDENSERVICIO_MantenimientoLista1  '1', '20071128', '20071129', '', '48'  
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_MantenimientoLista1]
@Area varchar(5),    
@FechaiNi varchar(8),    
@FechaFin varchar(8),    
@Estado varchar(2),    
@TipoServicio int,    
@ConceptoServicio varchar(5),    
@Agente varchar(4),    
@NaveViaje varchar(6),    
@Nave VARCHAR(30),    
@Cliente varchar (11)    
    
AS    

declare @cadena varchar(255)    
set @cadena =''    
    
declare @cadena1 varchar(5000)    
set @cadena1 =''    
    
    
if rtrim(ltrim(@Estado)) <> ''    
begin    
set @Estado=rtrim(ltrim(@Estado))    
set @cadena = @cadena + ' and O.EST_Codigo = convert(int,''' +  @Estado + ''') '    
end    
    
if rtrim(ltrim(@ConceptoServicio)) <> ''    
begin    
set @ConceptoServicio= rtrim(ltrim(@ConceptoServicio)) set @cadena = @cadena + ' and s.CON_Codigo = convert(int,''' + @ConceptoServicio + ''') '    
end    
    
if rtrim(ltrim(@Agente)) <> ''    
begin    
set @Agente=rtrim(ltrim(@Agente))    
set @cadena = @cadena + ' and    
rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,108)))    
=  rtrim(ltrim(''' + @Agente + ''')) '    
end    
    
if rtrim(ltrim(@NaveViaje)) <> ''    
begin    
set @NaveViaje=rtrim(ltrim(@NaveViaje))    
set @cadena = @cadena + 'and rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,103)))    
=  rtrim(ltrim(''' + @NaveViaje + ''')) '    
end    
    
if rtrim(ltrim(@Nave)) <> ''    
begin    
set @Nave=rtrim(ltrim(@Nave))    
set @cadena = @cadena + 'and rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,102)))    
=  rtrim(ltrim(''' + @Nave + ''')) '    
end    
    
/*if rtrim(ltrim(@Cliente)) <> ''    
begin    
set @Cliente= rtrim(ltrim(@Cliente))    
set @cadena = @cadena + 'and    
rtrim(ltrim(dbo.fn_BuscaDatos(O.OSE_Codigo,151))) =  rtrim(ltrim(''' + @Cliente + ''')) '    
end    
*/    
    
    
begin    
    
exec(    
'SELECT distinct    
O.OSE_Codigo,    
O.OSE_CodigoOrigen,    
O.OSE_Fecha,    
O.EST_Codigo,    
O.OSE_Descripcion,    
E.EST_Descripcion,    
ts.nombre as CON_NOMBRE ,    
A.ARE_Nombre,    
uo.usu_codigoInterno as usuario,
em.emp_nombre as Empresa,
dbo.fn_BuscaDatos(O.OSE_Codigo,116) as Volante,    
dbo.fn_BuscaDatos(O.OSE_Codigo,102) as nave,    
dbo.fn_BuscaDatos(O.OSE_Codigo,104) as viaje,    
dbo.fn_BuscaDatos(O.OSE_Codigo,109) as AgenteAdu,    
dbo.fn_BuscaDatos(O.OSE_Codigo,152) as Cliente,    
dbo.fn_BuscaDatos(O.OSE_Codigo,108) as CodigoAgente,    
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,  
 O.ARE_CODIGOINTERNO, s.CON_Codigo   
FROM  OST_ORDEN_SERVICIO O inner join OST_ESTADO E  on  O.EST_Codigo=E.EST_Codigo   
inner join seguridad.dbo.sgt_area as A on A.ARE_CODIGOInterno = O.ARE_CODIGOINTERNO     
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo    
INNER JOIN OST_AUDITORIA_ORDEN as AO on o.ose_codigo = ao.ose_codigo and o.est_codigo = ao.est_codigo
inner join seguridad.dbo.SGT_USUARIO as uo on ao.usu_codigo = uo.usu_codigo
inner join seguridad.dbo.SGT_EMPRESA as em on uo.emp_codigo = em.emp_codigo 
WHERE O.ARE_CODIGOINTERNO = ' + @Area + '    
  and O.EST_Codigo <> 2    
  and O.OSE_Fecha between ''' + @FechaiNi + '''    
  and  dateadd(dd,1,''' + @FechaFin + ''') ' +  @cadena + ' order by o.ose_codigo '    
    
)       
end    



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_MantenimientoListaPorOrden]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_MantenimientoListaPorOrden] -- '183115' 
@OSE_Codigo VARCHAR(30)    
  
AS  
  
declare @cadena varchar(255)  
set @cadena =''  
  
declare @cadena1 varchar(5000)  
set @cadena1 =''  
  
  
if rtrim(ltrim(@OSE_Codigo)) <> ''  
begin  
set @OSE_Codigo=rtrim(ltrim(@OSE_Codigo))  
set @cadena = @cadena + ' and O.OSE_Codigo = convert(int,''' +  @OSE_Codigo + ''') '  
end  
  
  
begin  
  
exec(  
'SELECT distinct  
O.OSE_Codigo,  
O.OSE_CodigoOrigen,  
O.OSE_Fecha,  
O.EST_Codigo,  
O.OSE_Descripcion,  
E.EST_Descripcion,  
ts.nombre as CON_NOMBRE ,  
A.ARE_Nombre,  
uo.usu_codigoInterno as usuario,
em.emp_nombre as Empresa,
dbo.fn_BuscaDatos(O.OSE_Codigo,116) as Volante,  
dbo.fn_BuscaDatos(O.OSE_Codigo,102) as nave,  
dbo.fn_BuscaDatos(O.OSE_Codigo,104) as viaje,  
dbo.fn_BuscaDatos(O.OSE_Codigo,109) as AgenteAdu,  
dbo.fn_BuscaDatos(O.OSE_Codigo,152) as Cliente,  
dbo.fn_BuscaDatos(O.OSE_Codigo,108) as CodigoAgente,  
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje, O.ARE_CODIGOINTERNO, s.CON_Codigo   
FROM  OST_ORDEN_SERVICIO O   
inner join OST_ESTADO E  on  O.EST_Codigo=E.EST_Codigo   
inner join seguridad.dbo.sgt_area as A on A.ARE_CODIGO = O.ARE_CODIGOINTERNO   
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo   
inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo   
left JOIN OST_AUDITORIA_ORDEN as AO on o.ose_codigo = ao.ose_codigo and o.est_codigo = ao.est_codigo
left join seguridad.dbo.SGT_USUARIO as uo on ao.usu_codigo = uo.usu_codigo
left join seguridad.dbo.SGT_EMPRESA as em on uo.emp_codigo = em.emp_codigo
WHERE    
  O.EST_Codigo <> 2 ' +  @cadena + ' order by o.ose_codigo '  
)  
  
end  


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_SeleccionaPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_SeleccionaPorCodigo]     
@OSE_Codigo integer   
AS  
/**********************************************  
Procedimiento : OSS_ORDENSERVICIO_SeleccionaPorCodigo     
Proposito  : Obtiene los datos de la orden  
Entrada  : codigo de orden  
Salida  : Datos de orden  
Fecha y Hora : Julio 2005 - pm  
Responsable : RyM  
******************************************/  
  
SELECT  OSE_Codigo,   
  OSE_CodigoOrigen,   
  TSV.TSV_Codigo,  
  TSV.TSV_Nombre,  
  TSV.TSV_FlagAdmWorkflow,  
  OSE_Descripcion,  
  OSE_Fecha,  
  OSE.EST_Codigo,  
  EST_Nombre,  
  OSE_FlagServicioIntegral,  
  ARE_CodigoInterno ,  
  isnull(OSE_Fecha_Req,'') as OSE_Fecha_Req,  
  isnull(OSE_Hora_Req,'') as OSE_Hora_Req,  
  isnull(FlagRequiereSenasa,0) as FlagRequiereSenasa ,  
  isnull(OSE.OSE_Despachador,'') as OSE_Despachador  
FROM  OST_ORDEN_SERVICIO OSE,  
 OST_ESTADO E,  
 OST_TIPO_SERVICIO TSV   
WHERE   
 OSE.OSE_Codigo =@OSE_Codigo   
 AND OSE.EST_Codigo=E.EST_Codigo  
 AND OSE.TSV_Codigo=TSV.TSV_Codigo  


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_Valida]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_Valida]  
@codConcepto int,  
@navvia11 char(6),  
@nrodet12 char(3)   
as  
SELECT distinct o.ose_codigo,    
             dbo.fn_BuscaDatos(O.OSE_Codigo,103) as ViajeNave,  
             dbo.fn_BuscaDatos(O.OSE_Codigo,111) as NroDet12,  
  s.con_codigo   
FROM  OST_ORDEN_SERVICIO O   
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo   
where     
 S.CON_Codigo=@codConcepto and   
 dbo.fn_BuscaDatos(O.OSE_Codigo,103)=@navvia11 and   
 dbo.fn_BuscaDatos(O.OSE_Codigo,111)=@nrodet12 and O.est_codigo <> 2  

GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIO_WorkFlowEstado]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIO_WorkFlowEstado]
@TSV_Codigo int,
@USU_Codigo varchar(10) ,
@EST_Codigo int 
AS

SELECT WE.EST_Codigo, E.EST_Nombre , E.EST_Color 
FROM   OST_PERMISO_WORKFLOW PW,
	OST_WORKFLOW_ESTADO WE,
	OST_ESTADO E 
WHERE  
	  WE.TSV_Codigo=@TSV_Codigo 
	  AND WE.EST_CodigoOrigen=@EST_Codigo
	  AND PW.TSV_Codigo=WE.TSV_Codigo 
	  AND PW.EST_Codigo=WE.EST_Codigo 
	  AND PW.USU_Codigo=@USU_Codigo 
	  AND WE.EST_Codigo=E.EST_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOCONFIG_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOCONFIG_Actualizar] 
@OSE_Codigo as integer,
@CAM_Codigo as integer,
@OC_Valor as varchar(250)
AS

UPDATE OST_ORDEN_SERVICIO_CONFIG 
SET 	  OC_Valor=@OC_Valor
WHERE OSE_Codigo=@OSE_Codigo 
	 AND CAM_Codigo=@CAM_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOCONFIG_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOCONFIG_Insertar] 
@OSE_Codigo as integer,
@CAM_Codigo as integer,
@OC_Valor as varchar(250),
@CAM_Index as int

AS

SET NOCOUNT ON


INSERT INTO OST_ORDEN_SERVICIO_CONFIG
	   (OSE_Codigo, CAM_Codigo,OC_Valor, CAM_Index)
 VALUES (@OSE_Codigo, @CAM_Codigo,@OC_Valor,@CAM_Index)


SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOCONFIG_SeleccionaPorCampo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOCONFIG_SeleccionaPorCampo]
@CAM_Codigo int
/**********************************************
Procedimiento	: OSS_ORDENSERVICIOCONFIG_SeleccionaPorCampo
Proposito	: Buscar categoria por codigo de campo
Entrada		: Codigo de campo
Salida		: Lista
Fecha y Hora	: Julio 2005 - pm
Responsable	: Rocio Romero
******************************************/
as 

SELECT OSE_Codigo 
FROM OST_ORDEN_SERVICIO_CONF 
WHERE CAM_Codigo=@CAM_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOHIJO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOHIJO_Actualizar] 
@OSE_Codigo as integer,
@OSH_Codigo as integer,
@EST_Codigo as integer,
@OSH_CodigoOrigen as varchar(10) 
AS

UPDATE OST_ORDEN_SERVICIO_HIJO
SET 
	EST_Codigo=@EST_Codigo,
	OSH_CodigoOrigen=@OSH_CodigoOrigen
WHERE OSE_Codigo=@OSE_Codigo
	 AND OSH_Codigo=@OSH_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOHIJO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************/
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOHIJO_Insertar]   
@OSE_Codigo as bigint,  
@EST_Codigo as integer,  
@CON_Codigo as integer   
  
  
/**********************************************  
Procedimiento : OSS_ORDENSERVICIOHIJO_Insertar  
Proposito : Insertar  OSS_ORDENSERVICIOHIJO  
Entrada  : Los parametros  
Salida  : Ninguna  
Fecha y Hora : Julio 2005 - pm  
Responsable : RyM  
******************************************/  
  
AS  
  
SET NOCOUNT ON  
  
DECLARE @V_OSH_Codigo  int  
  
SELECT @V_OSH_Codigo=MAX(OSH_Codigo) + 1   
FROM    OST_ORDEN_SERVICIO_HIJO     
WHERE OSE_Codigo = @OSE_Codigo  
  
IF @V_OSH_Codigo is NULL   
begin  
PRINT 'ENTRO AL IF'  
set @V_OSH_Codigo = 1  
end  
  
PRINT @V_OSH_Codigo   
INSERT INTO OST_ORDEN_SERVICIO_HIJO  
    (OSE_Codigo, OSH_Codigo,EST_Codigo, CON_Codigo)  
 VALUES (@OSE_Codigo,@V_OSH_Codigo,@EST_Codigo,@CON_Codigo)  
  
--Anulo OS Repetidas  20130815
 exec sp_Valida_Orden_de_Servicio_Repetidas @OSE_Codigo
  
select @V_OSH_Codigo  
  
SET NOCOUNT OFF 


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOHIJO_Insertar_dua]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOHIJO_Insertar_dua]   
@OSE_Codigo as integer,  
@EST_Codigo as integer,  
@CON_Codigo as integer,
@OSE_tiprec as varchar(60)   
  
  
/**********************************************  
Procedimiento : OSS_ORDENSERVICIOHIJO_Insertar  
Proposito : Insertar  OSS_ORDENSERVICIOHIJO  
Entrada  : Los parametros  
Salida  : Ninguna  
Fecha y Hora : Julio 2005 - pm  
Responsable : RyM  
******************************************/  
  
AS  
  
SET NOCOUNT ON  
  
DECLARE @V_OSH_Codigo  int  
  
SELECT @V_OSH_Codigo=MAX(OSH_Codigo) + 1   
FROM    OST_ORDEN_SERVICIO_HIJO     
WHERE OSE_Codigo = @OSE_Codigo  
  
  
IF @V_OSH_Codigo is NULL   
begin  
PRINT 'ENTRO AL IF'  
set @V_OSH_Codigo = 1  
end  
  
PRINT @V_OSH_Codigo   
  
INSERT INTO OST_ORDEN_SERVICIO_HIJO  
    (OSE_Codigo, OSH_Codigo,EST_Codigo, CON_Codigo, OSE_tiprec  )  
 VALUES (@OSE_Codigo,@V_OSH_Codigo,@EST_Codigo,@CON_Codigo, @OSE_tiprec)  
  
  
select @V_OSH_Codigo  
  
  
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOHIJO_SeleccionaPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOHIJO_SeleccionaPorCodigo] 
@OSE_Codigo int
as 

SELECT 
	OSH.OSE_Codigo,
	OSH.OSH_Codigo,
	OSH.EST_Codigo,
	OSH.OSH_CodigoOrigen,OSH.CON_Codigo ,
	cs.codigoservicio as CON_CodigoServicio,
	CS.Nombre as CON_Descripcion,
	CS.Nombre as CON_Nombre,
	ES.EST_NOMBRE
FROM 
	OST_ORDEN_SERVICIO_HIJO OSH , 
	TAV_Servicio CS,
	OST_ESTADO ES
WHERE 
	OSH.OSE_Codigo= @OSE_Codigo
	AND OSH.CON_Codigo = CS.Servicio 
	AND OSH.EST_CODIGO = ES.EST_CODIGO






GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOHIJO_SeleccionaPorConcepto]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOHIJO_SeleccionaPorConcepto] 
@CON_Codigo int,
@OSE_Codigo int 
as 

SET NOCOUNT ON


SELECT OSH.OSH_Codigo, OSH.OSH_CodigoOrigen
FROM OST_ORDEN_SERVICIO_HIJO OSH (NOLOCK)
WHERE OSH.OSE_Codigo= @OSE_Codigo AND OSH.CON_Codigo=@CON_Codigo

SET NOCOUNT OFF



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOINTERNO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOINTERNO_Actualizar] 
@OSE_Codigo as integer,
@CAM_Codigo as integer,
@CTR_Nombre varchar(25),
@OC_Valor as varchar(250)
AS

UPDATE OST_ORDEN_SERVICIO_INTERNO 
SET 	  OC_Valor=@OC_Valor
WHERE OSE_Codigo=@OSE_Codigo 
	 AND CAM_Codigo=@CAM_Codigo
	 AND CTR_Nombre=@CTR_Nombre



GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOINTERNO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOINTERNO_Insertar] 
@OSE_Codigo as integer,
@CAM_Codigo as integer,
@CTR_Nombre as varchar(50),
@OC_Valor as varchar(250),
@CAM_Index as int

AS

SET NOCOUNT ON


INSERT INTO OST_ORDEN_SERVICIO_INTERNO
	   (OSE_Codigo, CAM_Codigo,CTR_Nombre,OC_Valor,CAM_Index)
 VALUES (@OSE_Codigo, @CAM_Codigo,@CTR_Nombre,@OC_Valor,@CAM_Index)


SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOINTERNO_SeleccionaPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOINTERNO_SeleccionaPorCodigo] 
@OSE_Codigo as int 
AS

SELECT  C.CAM_Codigo,
	  C.CAM_Nombre,
	  OSI.OSE_Codigo,
	  OSI.OC_Valor ,
	  OSI.CTR_Nombre, 
	  OSI.CAM_Index 
FROM 
	OST_ORDEN_SERVICIO_INTERNO OSI, 
	OST_CAMPOTABLA C 
WHERE 
	OSI.OSE_Codigo=@OSE_Codigo
	AND OSI.CAM_Codigo= C.CAM_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIONEPTUNIA_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIONEPTUNIA_Eliminar]     
@ARE_Codigo int,    
@OSE_Codigo bigint     
AS  
BEGIN  
  
select @ARE_CODIGO = are_codigoInterno from OST_ORDEN_SERVICIO as a 
inner join dbo.OST_TIPO_SERVICIO as b
on a.tsv_codigo = b.tsv_codigo
where ose_codigo = @OSE_Codigo

 if @ARE_CODIGO=1     
  exec OSS_ACTUALIZA_SERVICIO_VOLANTE_ANULADOS
  exec sp_os_ModificaEstadoImpo @OSE_Codigo,'A'    
   
 if @ARE_CODIGO=2     
  
  exec descarga.dbo.sp_os_ModificaEstadoExpo @OSE_Codigo, 'A'    
  
--Caso Transporte: Anular la orden, no eliminarla  
 IF @ARE_CODIGO = 8     
  
  exec usp_os_ModificaEstadoTransp @OSE_Codigo, 'N'   
  
return 0  
  
END
GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIONEPTUNIA_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIONEPTUNIA_Insertar]     
@ARE_Codigo int,      
@OSE_Codigo int       
AS    
BEGIN    
    
DECLARE @plantilla int    
    
if @ARE_Codigo = 1       
begin      
    
  exec sp_os_InsertaOSImpo @OSE_Codigo      
 --Anulo OS Repetidas  20130815    
  exec sp_Valida_Orden_de_Servicio_Repetidas @OSE_Codigo    
end      
    
if @ARE_Codigo = 2       
begin      
    
  exec sp_os_InsertaOSExpo @OSE_Codigo      
    
end      
    
--RDT 02/01/2007: Caso Transporte     
IF @ARE_Codigo = 12       
BEGIN      
 SELECT @plantilla = TSV_Codigo    
 FROM OST_ORDEN_SERVICIO O (NOLOCK)    
 WHERE OSE_Codigo = @OSE_Codigo    
    
 -- Soportar todas las plantillas    
   IF @plantilla in (59,60,61,62,63,64,65,66,68,69)    
   EXEC usp_os_InsertaOSTranspCalle @OSE_Codigo         
    
END    
    
END     

GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICIOSPARCS_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ORDENSERVICIOSPARCS_Listar]  
@ARE_Codigo int,      
@OSE_Codigo int,
@est_codigo int
AS    
   
if @ARE_Codigo = 1       
begin      
select  distinct
ts.codigoservicio,                     
o.flagrequieresenasa,  
case when fc1.oc_valor = '' then null              
else fc1.oc_valor END as codcon63,                    
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,  
us.usu_codigoInterno as usuario                      
FROM  OST_ORDEN_SERVICIO O     
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo   
inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo        
inner join dbo.fn_BuscaDatostabla (@OSE_Codigo,136) as fc1 on o.ose_codigo = fc1.ose_codigo                         
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo                      
left join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo   
WHERE O.OSE_Codigo = @OSE_Codigo and ao.est_codigo  = @est_codigo
end   
else  
select '' as codigoservicio  
return 0


GO
/****** Object:  StoredProcedure [dbo].[OSS_ORDENSERVICO_EliminarDataCompEspecial]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[OSS_ORDENSERVICO_EliminarDataCompEspecial]

@OSE_Codigo as int
as

BEGIN



delete OST_ORDEN_SERVICIO_CONFIG where OSE_Codigo = @OSE_Codigo
and CAM_Codigo in (

select distinct CAM_Codigo from OST_ORDEN_SERVICIO_INTERNO  where  CTR_Nombre in (
select  CTR_Nombre 
from OST_ORDEN_SERVICIO_INTERNO 
where OSE_Codigo = @OSE_Codigo
group by  CTR_Nombre
having count(CTR_Nombre) > 1)

)



delete OST_ORDEN_SERVICIO_INTERNO where OSE_Codigo = @OSE_Codigo
and Ctr_nombre  in (
select  CTR_Nombre 
from OST_ORDEN_SERVICIO_INTERNO 
where OSE_Codigo = @OSE_Codigo
group by  CTR_Nombre
having count(CTR_Nombre) > 1)






end


GO
/****** Object:  StoredProcedure [dbo].[OSS_OSS_PERMISO_GENERACION_SOLICITUD_Comprobar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_OSS_PERMISO_GENERACION_SOLICITUD_Comprobar]
@codArea integer, 
@DiaGeneración varchar(10),
@HoraGeneracion char(5)
as
declare @diahoy varchar(10)
set @diahoy=
(select 
case
when  datepart(weekday,getdate()) =2 then 'Lunes'  
when  datepart(weekday,getdate()) =3 then 'Martes'  
when  datepart(weekday,getdate()) =4 then 'Miercoles'  
when  datepart(weekday,getdate()) =5 then 'Jueves'  
when  datepart(weekday,getdate()) =6 then 'Viernes'  
when  datepart(weekday,getdate()) =7 then 'Sabado'  
when  datepart(weekday,getdate()) =1 then 'Domingo'  
else
''
end  
as 'Hoy')
select
isnull(PGS_DiaRegistro,'') as PGS_DiaRegistro,
isnull(TAV_ServicioArea_Area,'')as TAV_ServicioArea_Area,
case
when PGS_DiaNoPermitido =2 then   'Lunes'  
when PGS_DiaNoPermitido =3 then   'Martes'  
when PGS_DiaNoPermitido =4 then   'Miercoles'  
when PGS_DiaNoPermitido =5 then   'Jueves'  
when PGS_DiaNoPermitido =6 then   'Viernes'  
when PGS_DiaNoPermitido =7 then   'Sabado'  
when PGS_DiaNoPermitido =1 then   'Domingo'  
else
''
end  
as PGS_DiaNoPermitido,
isnull(PGS_HoraTopedeDiasNoPermitidos,'') as PGS_HoraTopedeDiasNoPermitidos,
isnull( PGS_HoraTopedeGeneraciondeSolicitud,'')as PGS_HoraTopedeGeneraciondeSolicitud
from 
OST_PERMISO_GENERACION_SOLICITUD
where
TAV_ServicioArea_Area=@codArea
and 
PGS_DiaRegistro =@diahoy



GO
/****** Object:  StoredProcedure [dbo].[OSS_OSS_PERMISO_GENERACION_SOLICITUD_Verificar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[OSS_OSS_PERMISO_GENERACION_SOLICITUD_Verificar]
/*
@codArea integer, 
@DiaGeneración varchar(10),
@HoraGeneracion char(5)

as

declare @diahoy varchar(10)
set @diahoy=
(select 
case
when  datepart(weekday,getdate()) =2 then 'Lunes'  
when  datepart(weekday,getdate()) =3 then 'Martes'  
when  datepart(weekday,getdate()) =4 then 'Miercoles'  
when  datepart(weekday,getdate()) =5 then 'Jueves'  
when  datepart(weekday,getdate()) =6 then 'Viernes'  
when  datepart(weekday,getdate()) =7 then 'Sabado'  
when  datepart(weekday,getdate()) =1 then 'Domingo'  
else
''
end  
as 'Hoy')


select
isnull(PGS_DiaRegistro,'') as PGS_DiaRegistro,
isnull(TAV_ServicioArea_Area,'')as TAV_ServicioArea_Area,
case
when PGS_DiaNoPermitido =7 then   'Lunes'  
when PGS_DiaNoPermitido =6 then   'Martes'  
when PGS_DiaNoPermitido =5 then   'Miercoles'  
when PGS_DiaNoPermitido =4 then   'Jueves'  
when PGS_DiaNoPermitido =3 then   'Viernes'  
when PGS_DiaNoPermitido =2 then   'Sabado'  
when PGS_DiaNoPermitido =1 then   'Domingo'  
else
''
end  
as PGS_DiaNoPermitido,
isnull(PGS_HoraTopedeDiasNoPermitidos,'') as PGS_HoraTopedeDiasNoPermitidos,
isnull( PGS_HoraTopedeGeneraciondeSolicitud,'')as PGS_HoraTopedeGeneraciondeSolicitud,
case
when  datepart(weekday,@DiaGeneración) =2 then 'Lunes'  
when  datepart(weekday,@DiaGeneración) =3 then 'Martes'  
when  datepart(weekday,@DiaGeneración) =4 then 'Miercoles'  
when  datepart(weekday,@DiaGeneración) =5 then 'Jueves'  
when  datepart(weekday,@DiaGeneración) =6 then 'Viernes'  
when  datepart(weekday,@DiaGeneración) =7 then 'Sabado'  
when  datepart(weekday,@DiaGeneración) =1 then 'Domingo'  
else
''
end  
as 'DiaGeneraciónSolicitado',

case 
when @HoraGeneracion='' then '' 
else
convert(varchar(5),(isnull(@HoraGeneracion,'')),8) 

end  
as 'HoraGeneracionSolicitada'

from 
OST_PERMISO_GENERACION_SOLICITUD
where
TAV_ServicioArea_Area=@codArea
and 
PGS_DiaRegistro =@diahoy
*/



@codArea integer, 
@DiaGeneración varchar(10),
@HoraGeneracion char(5)
as
declare @diahoy varchar(10)
set @diahoy=
(select 
case
when  datepart(weekday,getdate()) =2 then 'Lunes'  
when  datepart(weekday,getdate()) =3 then 'Martes'  
when  datepart(weekday,getdate()) =4 then 'Miercoles'  
when  datepart(weekday,getdate()) =5 then 'Jueves'  
when  datepart(weekday,getdate()) =6 then 'Viernes'  
when  datepart(weekday,getdate()) =7 then 'Sabado'  
when  datepart(weekday,getdate()) =1 then 'Domingo'  
else
''
end  
as 'Hoy')
select
isnull(PGS_DiaRegistro,'') as PGS_DiaRegistro,
isnull(TAV_ServicioArea_Area,'')as TAV_ServicioArea_Area,
case
when PGS_DiaNoPermitido =2 then   'Lunes'  
when PGS_DiaNoPermitido =3 then   'Martes'  
when PGS_DiaNoPermitido =4 then   'Miercoles'  
when PGS_DiaNoPermitido =5 then   'Jueves'  
when PGS_DiaNoPermitido =6 then   'Viernes'  
when PGS_DiaNoPermitido =7 then   'Sabado'  
when PGS_DiaNoPermitido =1 then   'Domingo'  
else
''
end  
as PGS_DiaNoPermitido,
case
when  datepart(weekday,@DiaGeneración) =2 then 'Lunes'  
when  datepart(weekday,@DiaGeneración) =3 then 'Martes'  
when  datepart(weekday,@DiaGeneración) =4 then 'Miercoles'  
when  datepart(weekday,@DiaGeneración) =5 then 'Jueves'  
when  datepart(weekday,@DiaGeneración) =6 then 'Viernes'  
when  datepart(weekday,@DiaGeneración) =7 then 'Sabado'  
when  datepart(weekday,@DiaGeneración) =1 then 'Domingo'  
else
''
end  
as 'DiaGeneraciónSolicitado',


isnull(PGS_HoraTopedeDiasNoPermitidos,'') as PGS_HoraTopedeDiasNoPermitidos,
isnull( PGS_HoraTopedeGeneraciondeSolicitud,'')as PGS_HoraTopedeGeneraciondeSolicitud
from 
OST_PERMISO_GENERACION_SOLICITUD
where
TAV_ServicioArea_Area=@codArea
and 
PGS_DiaRegistro =@diahoy
GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Editar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Editar]

@vchDiaRegistro varchar(10),
@codArea integer, 
@DiaNopermitido integer,
@chHoraNopermitida char(5)
/***************************************
*Descripcion: Inserta un registro
*Fecha Crea: 20/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as
begin
update
OST_PERMISO_GENERACION_SOLICITUD
set
PGS_DiaNoPermitido=@DiaNopermitido,
PGS_HoraTopedeGeneraciondeSolicitud=@chHoraNopermitida
where
PGS_DiaRegistro=@vchDiaRegistro
and
TAV_ServicioArea_Area= @codArea
end
GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Eliminar]

@vchDiaRegistro varchar(10),
@codArea integer,
@err int output
/***************************************
*Descripcion: Inserta un registro
*Fecha Crea: 05/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as
begin 
delete 
from OST_PERMISO_GENERACION_SOLICITUD
where
@codArea=TAV_ServicioArea_Area
and
@vchDiaRegistro= PGS_DiaRegistro
	set @err = 0
	if(@@error<>0)
	begin
	set @err=1
	end
	else
	begin
	set @err=0
	end
end
print @err

GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_EliminarTodo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_EliminarTodo]

@codArea integer,
@err int output
/***************************************
*Descripcion: Elimina un registro
*Fecha Crea: 05/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as
begin 
delete 
from OST_PERMISO_GENERACION_SOLICITUD
where
@codArea=TAV_ServicioArea_Area
	set @err = 0
	if(@@error<>0)
	begin
	set @err=1
	end
	else
	begin
	set @err=0
	end
end
print @err

GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Obtener]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Obtener]

@vchDiaRegistro varchar(10),
@codArea integer

/***************************************
*Descripcion: Inserta un registro
*Fecha Crea: 05/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as
select 	
PGS_Codigo,
isnull(PGS_DiaRegistro,'') as PGS_DiaRegistro,
isnull(TAV_ServicioArea_Area,'')as TAV_ServicioArea_Area,
isnull(PGS_DiaNoPermitido,'') as PGS_DiaNoPermitido,
isnull(PGS_HoraTopedeDiasNoPermitidos,'') as PGS_HoraTopedeDiasNoPermitidos,
isnull(PGS_HoraTopedeGeneraciondeSolicitud,'')as PGS_HoraTopedeGeneraciondeSolicitud
from 
OST_PERMISO_GENERACION_SOLICITUD
where
TAV_ServicioArea_Area=@codArea
and 
PGS_DiaRegistro=@vchDiaRegistro



GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Registrar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[OSS_PERMISO_GENERACION_SOLICITUD_Registrar]

@vchDiaRegistro varchar(10),
@codArea integer, 
@DiaNopermitido integer,
@chHoraNopermitida char(5)
/***************************************
*Descripcion: Inserta un registro
*Fecha Crea: 05/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as

begin
insert
 OST_PERMISO_GENERACION_SOLICITUD (PGS_DiaRegistro, TAV_ServicioArea_Area,PGS_DiaNoPermitido,PGS_HoraTopedeGeneraciondeSolicitud)
 values 
(@vchDiaRegistro, @codArea, @DiaNopermitido,@chHoraNopermitida)
end
GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISOGENERACIONSOLICITUD_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[OSS_PERMISOGENERACIONSOLICITUD_Listar]
@codArea integer
/***************************************
*Descripcion: Lista los permisos 
*Fecha Crea: 04/10/2005
*Parametros: 	
*				
*Autor:	Reyes Avalos Gisella Rub{i 	
***************************************/
as
select 	
distinct PGS_Codigo,
isnull(PGS_DiaRegistro,'') as PGS_DiaRegistro,
isnull(TAV_ServicioArea_Area,'')as TAV_ServicioArea_Area,
case
when PGS_DiaNoPermitido =2 then   'Lunes'  
when PGS_DiaNoPermitido =3 then   'Martes'  
when PGS_DiaNoPermitido =4 then   'Miercoles'  
when PGS_DiaNoPermitido =5 then   'Jueves'  
when PGS_DiaNoPermitido =6 then   'Viernes'  
when PGS_DiaNoPermitido =7 then   'Sabado'  
when PGS_DiaNoPermitido =1 then   'Domingo'  
else
''
end  
as PGS_DiaNoPermitido,
isnull(PGS_HoraTopedeDiasNoPermitidos,'') as PGS_HoraTopedeDiasNoPermitidos,
isnull( PGS_HoraTopedeGeneraciondeSolicitud,'')as PGS_HoraTopedeGeneraciondeSolicitud
from 
OST_PERMISO_GENERACION_SOLICITUD
where
TAV_ServicioArea_Area=@codArea
GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISOWORKFLOW_Eliminar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_PERMISOWORKFLOW_Eliminar] 
@TSV_Codigo int,
@EST_Codigo int,
@USU_Codigo varchar(10) 

AS

DELETE FROM OST_PERMISO_WORKFLOW 
WHERE TSV_Codigo =@TSV_Codigo 
	 AND EST_Codigo =@EST_Codigo 
	 AND USU_Codigo=@USU_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISOWORKFLOW_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_PERMISOWORKFLOW_Insertar]
@TSV_Codigo int,
@EST_Codigo int,
@Usu_Codigo varchar(10),
@PWF_FechaReg datetime,
@PWF_FechaAct datetime, 
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10) 

as

insert into OST_PERMISO_WORKFLOW
(TSV_Codigo,EST_Codigo,USU_Codigo,
PWF_FechaReg,PWF_FechaAct,USU_UsuarioReg,USU_UsuarioAct) 
VALUES (@TSV_Codigo,@EST_Codigo,@Usu_Codigo,
@PWF_FechaReg,@PWF_FechaAct,@USU_UsuarioReg,@USU_UsuarioAct)



GO
/****** Object:  StoredProcedure [dbo].[OSS_PERMISOWORKFLOW_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_PERMISOWORKFLOW_Listar]  
@TSV_Codigo int,
@EST_Codigo int 

AS

SELECT U.USU_Codigo,
	 isnull(U.USU_Nombres,'') + '  ' + isnull(U.USU_Paterno,'') + '  ' + + isnull(U.USU_Materno,'')  as USU_Completo
FROM 	OST_PERMISO_WORKFLOW PW,
	SGV_Lista_Usuario U
WHERE TSV_Codigo=@TSV_Codigo 
	 AND EST_Codigo=@EST_Codigo
	 AND PW.USU_Codigo=U.USU_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_PLANTILLA_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_PLANTILLA_Listar]
as
SELECT PLA_Codigo,PLA_NombreLogico,PLA_NombreFisico from OST_PLANTILLA



GO
/****** Object:  StoredProcedure [dbo].[OSS_PLANTILLA_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_PLANTILLA_SeleccionarPorCodigo]
@codPlantilla as int
 AS
/**********************************************
*
*
*
*
*
*
******************************************/

select * 
from OST_Plantilla
where PLA_Codigo = @codPlantilla


GO
/****** Object:  StoredProcedure [dbo].[OSS_PRUEBACTR_CONSULTAR]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[OSS_PRUEBACTR_CONSULTAR]
@naveId as varchar(10)

as


SELECT TSV_Codigo as ordendocref, ARE_Codigo  as navvia11 

FROM OST_TIPO_SERVICIO

WHERE PLA_Codigo = @naveId

GO
/****** Object:  StoredProcedure [dbo].[OSS_Relacion_Hijoxpadre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_Relacion_Hijoxpadre]
@OSE_Codigo INT
as
select DISTINCT OSH.OSH_Codigo  from OST_ORDEN_SERVICIO_HIJO  OSH,OST_ORDEN_SERVICIO  OSE  where OSH.OSE_Codigo=@OSE_Codigo AND OSE.OSE_Codigo=@OSE_Codigo
and OSE.OSE_Codigo=OSH.OSE_Codigo




GO
/****** Object:  StoredProcedure [dbo].[OSS_REPORTE_CLIENTE_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE  [dbo].[OSS_REPORTE_CLIENTE_Listar]
@EST_CODIGO INT ,
@AUO_FECHAHORAINICIO  varchar(8),
@AUO_FECHAHORAFIN  varchar(8),
@USU_Codigo varchar(10) ,
@tipUsu varchar(2)

AS

if (@tipUsu='AI') 
begin

	SELECT DISTINCT OS.OSE_CODIGO,
		OS.OSE_DESCRIPCION,
		rtrim(ltrim(OE.EST_NOMBRE)) EST_CODIGO,
		AO.AUO_FECHAHORAINICIO,
		AO.USU_Codigo
	FROM 	OST_ORDEN_SERVICIO OS,
		OST_AUDITORIA_ORDEN AO,
		OST_ESTADO OE,
		SGV_Lista_Usuario VLU 
	WHERE AO.OSE_CODIGO 		= OS.OSE_CODIGO 		AND
		AO.AUO_FECHAHORAINICIO between  @AUO_FECHAHORAINICIO and  dateadd(dd,1,@AUO_FECHAHORAFIN) and 
		AO.USU_Codigo=VLU.usu_codigo and 
		ao.EST_Codigo=@EST_CODIGO and
		OE.EST_CODIGO= ao.EST_CODIGO 
	order by 4


end
else
begin	
	SELECT DISTINCT OS.OSE_CODIGO,
		OS.OSE_DESCRIPCION,
		rtrim(ltrim(OE.EST_NOMBRE)) EST_CODIGO,
		AO.AUO_FECHAHORAINICIO,
		AO.USU_Codigo
	FROM 	OST_ORDEN_SERVICIO OS,
		OST_AUDITORIA_ORDEN AO,
		OST_ESTADO OE,
		SGV_Lista_Usuario VLU 
	WHERE AO.OSE_CODIGO 		= OS.OSE_CODIGO 		AND
		AO.AUO_FECHAHORAINICIO between  @AUO_FECHAHORAINICIO and  dateadd(dd,1,@AUO_FECHAHORAFIN) and 
		AO.USU_Codigo=VLU.usu_codigo and 
		rtrim(ltrim(VLU.usu_codigointerno))= rtrim(ltrim(@USU_Codigo)) AND 
		ao.EST_Codigo=@EST_CODIGO and
		OE.EST_CODIGO		= ao.EST_CODIGO 
	order by 4
end
	




GO
/****** Object:  StoredProcedure [dbo].[OSS_REPOSITORIO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_REPOSITORIO_Listar]
 AS

/**********************************************
*
*
*
*
*
*
******************************************/

select * from OST_REPOSITORIO


GO
/****** Object:  StoredProcedure [dbo].[OSS_REPOSITORIO_SeleccionarPorNombre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_REPOSITORIO_SeleccionarPorNombre]
@NomBD as varchar(25)
 AS

/**********************************************
Procedimiento	: OSS_REPOSITORIO_SeleccionarPorNombre
Proposito	: Seleccionar la cadena de conexion
Entrada		: Nombre de base de datos
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
******************************************/

select * from OST_REPOSITORIO where BDA_NombreBaseDatos = @NomBD


GO
/****** Object:  StoredProcedure [dbo].[OSS_SERVICIO_ListarPorArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[OSS_SERVICIO_ListarPorArea]    

@ARE_CodigoInterno as varchar(10)    

as    

if @ARE_CodigoInterno<>""     

begin    

 select  VC.Servicio as CON_Servicio,     

  VC.CodigoServicio as CON_Codigo,      

  VC.CodigoServicio + ' - ' + VC.Nombre as CON_Nombre     

 from TAV_Servicio VC ,    

  TAV_ServicioArea VSA,    

  SGV_Lista_Area A     

 where  A.ARE_CodigoInterno=@ARE_CodigoInterno     

  and A.ARE_Codigo=VSA.Area    

  and VSA.Servicio =VC.Servicio    

  and VC.FlagPublicado in ('Y', 'S')     

 order by VC.Nombre    

end    

  

else    

  

begin    

 

 select  VC.Servicio as CON_Servicio,     

  VC.CodigoServicio as CON_Codigo,      

  VC.CodigoServicio + ' - ' + VC.Nombre as CON_Nombre     

 from TAV_Servicio VC    

 where  VC.FlagPublicado='Y'     

 order by VC.Nombre    

  

end    


GO
/****** Object:  StoredProcedure [dbo].[OSS_SERVICIO_ListarPorConceptoArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_SERVICIO_ListarPorConceptoArea]      
@CON_Codigo as varchar(5) ,         
@ARE_CodigoInterno as varchar(10),      
@TpoUsuario  as varchar(1)      
      
/***************************************        
*Descripcion: Obtiene el servicio        
*Fecha Crea: 30/12/2005        
*Parametros:             
*Autor:  Rocio Romero        
*Modificado : Eugenia Palao Malaga       
*Fecha Modif: 13/06/2005 13:50      
***************************************/        
as        
if @TpoUsuario = 'I'  
begin        
    select DISTINCT  VC.CodigoServicio as codigo,          
             VC.Servicio as numero,          
             VC.Nombre as nombre         
    from     TAV_Servicio VC ,        
             TAV_ServicioArea VSA,        
             SGV_Lista_Area A         
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno         
             and A.ARE_Codigointerno=VSA.Area        
             and VSA.Servicio =VC.Servicio        
             and VSA.FlagPublicado in ('Y', 'S')          
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'        
             order by 1        
end        
else        
begin        
   select  DISTINCT VC.CodigoServicio as codigo,         
            VC.Servicio as numero,          
            VC.Nombre as nombre         
   from     TAV_Servicio VC ,        
            TAV_ServicioArea VSA,        
            SGV_Lista_Area A         
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno         
            and A.ARE_CodigoInterno=VSA.Area        
            and VSA.Servicio =VC.Servicio        
            and VSA.FlagPublicado = 'Y'      
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'        
      
            /*from      TAV_Servicio VC        
            where   upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'         
            and VC.FlagPublicado='Y'   */      
            order by 1        
end        


GO
/****** Object:  StoredProcedure [dbo].[OSS_SERVICIO_ListarPorConceptoAreabyUsuario]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_SERVICIO_ListarPorConceptoAreabyUsuario]    
@CON_Codigo as varchar(5) ,           
@ARE_CodigoInterno as varchar(10),        
@ARE_UsuarioInterno as varchar(10),        
@TpoUsuario  as varchar(1)        
        
as          
if @TpoUsuario = 'I'    
begin          
    select DISTINCT  VC.CodigoServicio as codigo,            
             VC.Servicio as numero,            
             VC.Nombre as nombre           
    from     TAV_Servicio VC ,          
             TAV_ServicioArea VSA,          
             SGV_Lista_Area A           
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno           
             and A.ARE_Codigointerno=VSA.Area          
             and VSA.Servicio =VC.Servicio          
             and VSA.FlagPublicado in ('Y', 'S')            
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'     
      and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO )         
union  
    select DISTINCT  VC.CodigoServicio as codigo,            
             VC.Servicio as numero,            
             VC.Nombre as nombre           
    from     TAV_Servicio VC ,          
             TAV_ServicioArea VSA,          
             SGV_Lista_Area A           
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno           
             and A.ARE_Codigointerno=VSA.Area          
             and VSA.Servicio =VC.Servicio          
             and VSA.FlagPublicado in ('Y', 'S')            
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'     
      and VC.Servicio  in (select codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)         
             order by 1     
end          
else          
begin          
   select  DISTINCT VC.CodigoServicio as codigo,           
            VC.Servicio as numero,            
            VC.Nombre as nombre           
   from     TAV_Servicio VC ,          
            TAV_ServicioArea VSA,          
            SGV_Lista_Area A           
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno           
            and A.ARE_CodigoInterno=VSA.Area          
            and VSA.Servicio =VC.Servicio          
            and VSA.FlagPublicado = 'Y'        
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'    
            and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO)                  
union  
   select  DISTINCT VC.CodigoServicio as codigo,           
            VC.Servicio as numero,            
            VC.Nombre as nombre           
   from     TAV_Servicio VC ,          
            TAV_ServicioArea VSA,          
            SGV_Lista_Area A           
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno           
            and A.ARE_CodigoInterno=VSA.Area          
            and VSA.Servicio =VC.Servicio          
            and VSA.FlagPublicado = 'Y'        
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'    
            and VC.Servicio  in (select  codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)                  
            order by 1          
end          
  
GO
/****** Object:  StoredProcedure [dbo].[OSS_SERVICIO_ListarPorConceptoAreabyUsuarioDua]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OSS_SERVICIO_ListarPorConceptoAreabyUsuarioDua]        
@CON_Codigo as varchar(5) ,               
@ARE_CodigoInterno as varchar(10),            
@ARE_UsuarioInterno as varchar(10),            
@TpoUsuario  as varchar(1),    
@flagDua as varchar(1)            
            
as    
if @TpoUsuario = 'I'        
begin              
    select DISTINCT  VC.CodigoServicio as codigo,                
             VC.Servicio as numero,                
             VC.Nombre as nombre               
    from     TAV_Servicio VC ,              
             TAV_ServicioArea VSA,              
             SGV_Lista_Area A               
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno               
             and A.ARE_Codigointerno=VSA.Area              
             and VSA.Servicio =VC.Servicio              
             and VSA.FlagPublicado in ('Y', 'S')                
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'         
      and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO )    
   --and (VC.flagdua = 'N' or VC.flagdua = @flagdua)             
      --**MDTECH**  
   -- AGREGADO MDTECH 19092011  
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))               
   -- FIN AGREGADO MDTECH 19092011  
   
    
union      
    select DISTINCT  VC.CodigoServicio as codigo,                
             VC.Servicio as numero,                
             VC.Nombre as nombre               
    from     TAV_Servicio VC ,              
             TAV_ServicioArea VSA,              
             SGV_Lista_Area A               
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno               
             and A.ARE_Codigointerno=VSA.Area              
             and VSA.Servicio =VC.Servicio              
             and VSA.FlagPublicado in ('Y', 'S')                
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'         
      and VC.Servicio  in (select codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)             
   --and (VC.flagdua = 'N' or VC.flagdua = @flagdua)             
      --**MDTECH**  
   -- AGREGADO MDTECH 19092011  
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))               
   -- FIN AGREGADO MDTECH 19092011  
    
             order by 1         
end              
else              
begin              
   select  DISTINCT VC.CodigoServicio as codigo,               
            VC.Servicio as numero,                
            VC.Nombre as nombre               
   from     TAV_Servicio VC ,              
            TAV_ServicioArea VSA,              
            SGV_Lista_Area A               
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno               
            and A.ARE_CodigoInterno=VSA.Area              
            and VSA.Servicio =VC.Servicio              
            and VSA.FlagPublicado = 'Y'            
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'        
            and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO)                      
   --and (VC.flagdua = 'N' or VC.flagdua = @flagdua)             
   --**MDTECH**  
   -- AGREGADO MDTECH 19092011  
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))               
   -- FIN AGREGADO MDTECH 19092011  
union      
   select  DISTINCT VC.CodigoServicio as codigo,               
            VC.Servicio as numero,                
            VC.Nombre as nombre               
   from     TAV_Servicio VC ,              
            TAV_ServicioArea VSA,              
            SGV_Lista_Area A               
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno                           and A.ARE_CodigoInterno=VSA.Area              
            and VSA.Servicio =VC.Servicio              
            and VSA.FlagPublicado = 'Y'            
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'        
            and VC.Servicio  in (select  codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)                      
   --and (VC.flagdua = 'N' or VC.flagdua = @flagdua)      
   --**MDTECH**  
   -- AGREGADO MDTECH 19092011         
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))               
            order by 1              
   -- FIN AGREGADO MDTECH 19092011  
end  
GO
/****** Object:  StoredProcedure [dbo].[OSS_SERVICIOAREA_ObtenerFlagSENASA]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE  [dbo].[OSS_SERVICIOAREA_ObtenerFlagSENASA]

 

@codArea int,

@codServicio varchar(5) 

 

/***************************************

*Descripcion: obtiene el falg senasa

*Fecha Crea: 07/10/2005

*Parametros:     

*Autor:  Reyes Avalos Gisella Rubi         

***************************************/

as

select distinct isnull (FlagRequiereSenasa ,'') as FlagRequiereSENASA

from      TAV_ServicioArea SA,

            TAV_Servicio S

where   sa.servicio=s.servicio and 

            upper(codigoServicio)=upper(@codServicio)

            and Area=@codArea

 

 

 


GO
/****** Object:  StoredProcedure [dbo].[OSS_TAV_SERVICIOAREA_ObtenerFlagSENASA]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[OSS_TAV_SERVICIOAREA_ObtenerFlagSENASA]

@codArea int,
@Servicio int

/***************************************
*Descripcion: obtiene el falg senasa
*Fecha Crea: 07/10/2005
*Parametros: 	
*Autor:	Reyes Avalos Gisella Rubi 	
***************************************/
as
select 
isnull (FlagRequiereSenasa ,'')
as
FlagRequiereSENASA
from TAV_ServicioArea
where
Servicio=@Servicio
and
Area=@codArea


GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPODATO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPODATO_Listar]
AS

SELECT TDA_Codigo,TDA_Nombre from OST_TIPO_DATO



GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPODATO_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_TIPODATO_SeleccionarPorCodigo]
@codDato int
 AS

/*************************************************************
Procedimiento	: DBS_Lista_TipoDato_x_CodDato
Proposito	: Listar los tipos de datos
Entrada		: Cod Dato
Salida		: Ninguna
Fecha y Hora	: Julio 2005 - pm
Responsable	: RyM
**************************************************************/

select * 
from OST_TIPO_DATO
where TDA_Codigo= @codDato


GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_Actualizar]  
@TSV_Codigo  int ,
@PLA_Codigo  int ,
@ARE_Codigo  int,
@TSV_Nombre  varchar(40), 
@TSV_FlagAdmWorkflow  int,
@TSV_Descripcion  varchar(100),
@TSV_FechaAct  datetime,
@USU_UsuarioAct  varchar(10)

AS

UPDATE OST_TIPO_SERVICIO
SET 	PLA_Codigo =@PLA_Codigo ,
	ARE_Codigo =@ARE_Codigo,
	TSV_Nombre =@TSV_Nombre,
	TSV_FlagAdmWorkflow =@TSV_FlagAdmWorkflow,
	TSV_Descripcion= @TSV_Descripcion,
	TSV_FechaAct	 =@TSV_FechaAct,
	USU_UsuarioAct =@USU_UsuarioAct  
WHERE TSV_Codigo=@TSV_Codigo
GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_Insertar] 
@PLA_Codigo  int ,
@ARE_Codigo as int,
@TSV_Nombre as varchar(40), 
@TSV_FlagAdmWorkflow as int,
@TSV_Descripcion as varchar(100),
@TSV_FechaReg as datetime,
@TSV_FechaAct as datetime,
@USU_UsuarioReg as varchar(10),
@USU_UsuarioAct as varchar(10)


as
insert into OST_TIPO_SERVICIO (PLA_Codigo,ARE_Codigo,TSV_Nombre,
TSV_FlagAdmWorkflow,TSV_Descripcion,TSV_FechaReg,TSV_FechaAct,USU_UsuarioReg,USU_UsuarioAct) 
VALUES (@PLA_Codigo,@ARE_Codigo,@TSV_Nombre,
@TSV_FlagAdmWorkflow,@TSV_Descripcion,@TSV_FechaReg,@TSV_FechaAct,@USU_UsuarioReg,@USU_UsuarioAct)

select  @@identity AS Codigo
GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_ListarPorArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_ListarPorArea]
@ARE_Codigo int
as
SELECT * FROM  OST_TIPO_SERVICIO WHERE ARE_Codigo=@ARE_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_ListarPorAreaInterno]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_ListarPorAreaInterno] 
@ARE_CodigoInterno varchar(10)  
as

SELECT * 
FROM   OST_TIPO_SERVICIO T,
	SGV_Lista_Area A
WHERE A.ARE_CodigoInterno=@ARE_CodigoInterno
	 AND A.ARE_Codigo=T.ARE_Codigo


GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_ListarPorAreaPerfil]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_ListarPorAreaPerfil] 
@ARE_CodigoInterno varchar(10) ,
@USU_Perfil varchar(2) 
as

if @USU_Perfil='AI' 
begin
	SELECT * 
	FROM   OST_TIPO_SERVICIO T,
		SGV_Lista_Area A
	WHERE 	A.ARE_CodigoInterno=@ARE_CodigoInterno
		AND A.ARE_Codigo=T.ARE_Codigo
	--	AND (T.TSV_Cliente is null  or T.TSV_Cliente='N') 
end
else
begin
	SELECT * 
	FROM   OST_TIPO_SERVICIO T,
		SGV_Lista_Area A
	WHERE 	A.ARE_CodigoInterno=@ARE_CodigoInterno
		AND T.TSV_Cliente='Y' 
		AND A.ARE_Codigo=T.ARE_Codigo

end




GO
/****** Object:  StoredProcedure [dbo].[OSS_TIPOSERVICIO_SeleccionarPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[OSS_TIPOSERVICIO_SeleccionarPorCodigo]
@codTOS as int
 AS

/**********************************************
*
*
*
*
*
*
******************************************/

select * from OST_TIPO_SERVICIO where TSV_Codigo =@codTOS


GO
/****** Object:  StoredProcedure [dbo].[OSS_USUARIOAREA_ListarPorArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_USUARIOAREA_ListarPorArea]
@ARE_Codigo int
as
	SELECT 	LUA.USU_CODIGO,
		ISNULL(LU.USU_NOMBRES,' ') + ' ' + ISNULL(LU.USU_PATERNO,' ') + ' ' + ISNULL(LU.USU_MATERNO,' ') USU_NOMBRES
	FROM  	SGV_Lista_UsuarioArea LUA,
		SGV_Lista_Usuario LU
	WHERE 	LUA.USU_CODIGO = LU.USU_CODIGO
		AND ARE_Codigo=@ARE_Codigo





GO
/****** Object:  StoredProcedure [dbo].[OSS_VALIDAR_SERVICIO_VOLANTE]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OSS_VALIDAR_SERVICIO_VOLANTE]  
 @codigo_servicio as varchar(10),  
 @numero_volante as varchar(10)  
as  
declare @w_contenedores as int,  
 @w_carga_suelta as int,  
 @w_vehiculos as int,  
  
 @t_contenedores as int,  
 @t_carga_suelta as int,  
 @t_vehiculos as int;  
 -- Validamos si el volante es para contenedores  
 select @w_contenedores = count(*) from terminal.dbo.drblcont15 where nrosec23=rtrim(ltrim(@numero_volante))        
 if @w_contenedores>0   
	  begin  		 
		  select @t_contenedores = count(*) from dbo.OST_SERVICIO_EMBALAJE where codigo_servicio=ltrim(rtrim(@codigo_servicio)) and cod_emb='CTR'  
		  if @t_contenedores>0   
			   begin  
			     select 1
			     return
			   end   
		  else  
			   begin  
			     select 0
                             return 
			   end   
	  end  
 else  
   begin  
	  -- Validamos si el volante es para carga suelta  
	  select @w_carga_suelta = count(*) from terminal.dbo.ddcartar22 where nrosec23=ltrim(rtrim(@numero_volante))  
	  if @w_carga_suelta>0  
	   	begin  
		    select @t_carga_suelta = count(*) from dbo.OST_SERVICIO_EMBALAJE where codigo_servicio=ltrim(rtrim(@codigo_servicio)) and cod_emb='BUL'   
		    if @t_carga_suelta>0  
			    begin  
			      select 1
			      return 
			    end   
		    else  
			    begin  
			      select 0
			      return 
			    end   
	   	end  
	  else  
	   begin  
	   -- Validamos si el volante es para vehiculo  
		   select @w_vehiculos = count(*) from terminal.dbo.ddvehicu14 where nrosec23 = ltrim(rtrim(@numero_volante))  
		   if @w_vehiculos>0   
		    begin  
			    select @t_vehiculos = count(*) from dbo.OST_SERVICIO_EMBALAJE where codigo_servicio=ltrim(rtrim(@codigo_servicio)) and cod_emb='VEH'   
			    if @t_vehiculos>0  
				     begin  
				       select 1 
				       return 
				     end   
			    else  
				     begin  
				       select 0
				       return 
				     end   
		    end 		 
	    end   
   end  
GO
/****** Object:  StoredProcedure [dbo].[OSS_WORKFLOWESTADO_Actualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_WORKFLOWESTADO_Actualizar]
@TSV_Codigo int,
@EST_Codigo int,
@WFL_FlagAlertaAuto tinyint,
@EST_CodigoOrigen int,
@USU_UsuarioAct varchar(10),
@WFL_FechaAct datetime 

AS 

UPDATE OST_WORKFLOW_ESTADO 
SET 	WFL_FlagAlertaAuto=@WFL_FlagAlertaAuto,
	USU_UsuarioAct=@USU_UsuarioAct ,
	WFL_FechaAct=@WFL_FechaAct ,
	EST_CodigoOrigen=@EST_CodigoOrigen 	
WHERE TSV_Codigo=@TSV_Codigo
	 AND EST_Codigo=@EST_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_WORKFLOWESTADO_INSERTAR]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_WORKFLOWESTADO_INSERTAR]
@TSV_Codigo int,
@EST_Codigo int,
@WFL_FlagAlertaAuto tinyint,
@EST_CodigoOrigen int,
@USU_UsuarioReg varchar(10),
@USU_UsuarioAct varchar(10),
@WFL_FechaReg datetime,
@WFL_FechaAct datetime 
as

insert into 
OST_WORKFLOW_ESTADO 
(TSV_Codigo,EST_Codigo,WFL_FlagAlertaAuto,
USU_UsuarioReg,USU_UsuarioAct,WFL_FechaReg,WFL_FechaAct,
EST_CodigoOrigen) 
VALUES 
(@TSV_Codigo,@EST_Codigo,@WFL_FlagAlertaAuto,
@USU_UsuarioReg,@USU_UsuarioAct,@WFL_FechaReg,@WFL_FechaAct,
@EST_CodigoOrigen)



GO
/****** Object:  StoredProcedure [dbo].[OSS_WORKFLOWESTADO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_WORKFLOWESTADO_Listar] 
@TSV_Codigo int 
as

SELECT *
FROM OST_WORKFLOW_ESTADO
WHERE TSV_Codigo=@TSV_Codigo



GO
/****** Object:  StoredProcedure [dbo].[OSS_ZONA_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OSS_ZONA_Listar]
as

SELECT * FROM  OST_ZONA



GO
/****** Object:  StoredProcedure [dbo].[Relacion_Hijoxpadre]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Relacion_Hijoxpadre]
@OSE_Codigo INT

as
select OSH.OSH_Codigo,E.EST_Nombre from OST_ORDEN_SERVICIO_HIJO OSH,OST_ESTADO E where OSH.OSE_Codigo=@OSE_Codigo  ORDER BY OSH.OSH_Codigo



GO
/****** Object:  StoredProcedure [dbo].[SGS_AREA_LISTAR]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGS_AREA_LISTAR] AS

/**********************************************
Procedimiento	: OSS_AREA_LISTAR
Proposito	: Listar las Areas
Entrada		: Ninguna
Salida		: Listado
Fecha y Hora	: Julio 2005 - pm
Responsable	: R&M
******************************************/

SELECT *  from SGV_Lista_Area 
WHERE ARE_Estado='A'

GO
/****** Object:  StoredProcedure [dbo].[SGS_AREA_ListarPorUsuario]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGS_AREA_ListarPorUsuario]   
@USU_Codigo varchar(25)   
AS  
SELECT A.ARE_Codigo , A.ARE_Nombre, A.ARE_Descripcion, A.ARE_AreaSup , A.ARE_CodigoInterno   
FROM SGV_Lista_UsuarioArea UA, SGV_Lista_Area  A  
WHERE UA.ARE_Codigo= A.ARE_Codigo  
  AND UA.USU_Codigo=@USU_Codigo  
  AND A.ARE_Estado='A'  
order by A.ARE_Nombre desc

GO
/****** Object:  StoredProcedure [dbo].[SGS_AREA_ObtenerPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SGS_AREA_ObtenerPorCodigo] 
@ARE_Codigo int 
AS

SELECT * 
FROM SGV_Lista_Area
WHERE ARE_Codigo=@ARE_Codigo 



GO
/****** Object:  StoredProcedure [dbo].[SGS_AREA_ObtenerPorCodigoInterno]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[SGS_AREA_ObtenerPorCodigoInterno] 
@ARE_CodigoInterno varchar(20) 
AS

SELECT * 
FROM SGV_Lista_Area
WHERE ARE_CodigoInterno=@ARE_CodigoInterno 

GO
/****** Object:  StoredProcedure [dbo].[SGS_USUARIO_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SGS_USUARIO_Listar] 
AS

select (USU_Nombres    + ' '    +      USU_Paterno        ) as nombre, USU_Codigo

from SGV_Lista_Usuario

GO
/****** Object:  StoredProcedure [dbo].[SGS_USUARIO_ObtienePorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGS_USUARIO_ObtienePorCodigo] 
@USU_Codigo varchar(10)

 AS

SELECT *
FROM  SGV_Lista_Usuario U, 
	SGV_Lista_Empresa E 
WHERE U.USU_Codigo=@USU_Codigo
	 AND U.EMP_Codigo=E.EMP_Codigo


GO
/****** Object:  StoredProcedure [dbo].[SGS_USUARIO_OPCIONES_Listar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGS_USUARIO_OPCIONES_Listar]
@USU_Codigo varchar(10),
@SIS_Codigo int 

AS

SELECT O.OPC_Codigo, O.OPC_Nombre, O.OPC_Descripcion
FROM 	SGV_Lista_PerfilUsuario PU,
	SGV_Lista_OpcionPerfil OP ,
	SGV_Lista_Opcion O 
WHERE PU.USU_Codigo=@USU_Codigo
	 AND OP.PER_Codigo=PU.PER_Codigo
	 AND OP.OPC_Codigo=O.OPC_Codigo 
	 AND O.SIS_Codigo=@SIS_Codigo
	 AND O.OPC_Estado='A'


GO
/****** Object:  StoredProcedure [dbo].[SGS_USUARIOAREA_ListarPorArea]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[SGS_USUARIOAREA_ListarPorArea]
@ARE_Codigo int
as
	SELECT 	
		--DISTINCT LU.USU_CODIGOINTERNO AS usu_Codigo ,
		DISTINCT LU.USU_CODIGO AS usu_Codigo ,
		ISNULL(LU.USU_NOMBRES,' ') + ' ' + ISNULL(LU.USU_PATERNO,' ') + ' ' + ISNULL(LU.USU_MATERNO,' ') USU_NOMBRES
	FROM  	SGV_Lista_UsuarioArea LUA,
		SGV_Lista_Usuario LU
	WHERE 	LUA.USU_CODIGO = LU.USU_CODIGOINTERNO   
		AND ARE_Codigo=@ARE_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTO_ReporteGastos]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_GASTO_ReporteGastos]
	@intOrden	int
as
SELECT 
o.ose_fecha as FechaEmision,
o.ose_fecha_req as FechaServicio,
ts.Glosa_de_operaciones as Servicio,
'Tipo de Merca'= case dbo.fn_BuscaDatos(O.OSE_Codigo,163) 
		  when 'CTR'  THEN  dbo.fn_BuscaDatos(O.OSE_Codigo,163)+ ' ' + dbo.fn_BuscaDatos(O.OSE_Codigo,141)  
		  ELSE dbo.fn_BuscaDatos(O.OSE_Codigo,163) 
		 END,
'SUCURSAL'	= dbo.fn_BuscaDatos(O.OSE_Codigo,171) ,
'CENCOS'	= dbo.fn_BuscaDatos(O.OSE_Codigo,172) ,
'PROVEEDOR'	= dbo.fn_BuscaDatos(O.OSE_Codigo,167) 
FROM  OST_ORDEN_SERVICIO O 
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo 
inner join NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES as TS ON TS.id_codigo = s.CON_Codigo
where 	o.ose_codigo =@intOrden
--------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ListaGastosFiltrado]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------

 ALTER PROCEDURE  [dbo].[SP_GASTOS_ListaGastosFiltrado]   
                                                                                                                                                                                                        
	@intSucursal varchar(2),  
                                                                                                                                                                                                                                  
 	@intCenCos varchar(2),  
                                                                                                                                                                                                                                   
 	@intGrupo varchar(2)  
                                                                                                                                                                                                                                     
as  
                                                                                                                                                                                                                                                         
/*descripcion:  obtiene el listado de gastos dependiendo de los filtros   
                                                                                                                                                                                   
  que se le ingrese ,  pertenece a ordenesservicio
                                                                                                                                                                                                           
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
declare @select varchar(2000),  
                                                                                                                                                                                                                             
 	@inner varchar(2000),  
                                                                                                                                                                                                                                    
 	@where varchar(2000)  
                                                                                                                                                                                                                                     
set @select =''  
                                                                                                                                                                                                                                            
set @inner =''  
                                                                                                                                                                                                                                             
set @where =''  
                                                                                                                                                                                                                                             
  
                                                                                                                                                                                                                                                           
if @intSucursal <>''  
                                                                                                                                                                                                                                       
  begin  
                                                                                                                                                                                                                                                    
	 if @where =''  
                                                                                                                                                                                                                                            
	   begin  
                                                                                                                                                                                                                                                  
	  	set @where = ' where sc.sucursal =' + @intSucursal  
                                                                                                                                                                                                     
	   end  
                                                                                                                                                                                                                                                    
	 else   
                                                                                                                                                                                                                                                    
	   begin  
                                                                                                                                                                                                                                                  
	  	set @where = @where + 'and sc.sucursal =' + @intSucursal  
                                                                                                                                                                                               
	   end  
                                                                                                                                                                                                                                                    
 	--set @inner = ' inner join TERMINAL.dbo.suc_cencos_ITEMGASTO sc on sc.itemgasto = g.CODIGO'  
                                                                                                                                                             
	set @inner = ' inner join NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = g.CODIGO_de_ultragestion'  
                                                                                                                                  
  end  
                                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
if @intCenCos <> ''  
                                                                                                                                                                                                                                        
  begin  
                                                                                                                                                                                                                                                    
	 if @where =''  
                                                                                                                                                                                                                                            
	  	set @where = ' where sc.centro_costos ='+ @intCenCos  
                                                                                                                                                                                                   
	 else   
                                                                                                                                                                                                                                                    
	  	set @where = @where + ' and sc.centro_costos ='+@intCenCos   
                                                                                                                                                                                            
	 if @inner =''  
                                                                                                                                                                                                                                            
	  	set @inner = ' inner join NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = g.CODIGO_de_ultragestion'  
                                                                                                                               
  end  
                                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
if @intGrupo<>''  
                                                                                                                                                                                                                                           
  begin  
                                                                                                                                                                                                                                                    
	 if @where =''  
                                                                                                                                                                                                                                            
	  	set @where = ' where and gs.idgrupo = '+@intGrupo + ' and gs.flagtiporegistro=0'  
                                                                                                                                                                       
	 else   
                                                                                                                                                                                                                                                    
	  	set @where = @where + ' and gs.idgrupo ='+@intGrupo + ' and gs.flagtiporegistro=0'    
                                                                                                                                                                   
	 --set @inner = @inner + ' inner join ost_grupo_servicioarea gs on gs.idservicioarea = g.CODIGOINT'  
                                                                                                                                                       
	set @inner = @inner + ' inner join ost_grupo_servicioarea gs on gs.idservicioarea = g.id_codigo'  
                                                                                                                                                          
  end   
                                                                                                                                                                                                                                                     
  
                                                                                                                                                                                                                                                           
set @select= '  
                                                                                                                                                                                                                                             
select distinct g.id_codigo,  
                                                                                                                                                                                                                               
 g.glosa_de_operaciones 
                                                                                                                                                                                                                                     
from NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES g  
                                                                                                                                                                                                     
'  
                                                                                                                                                                                                                                                          
print(@select + @inner + @where )  
                                                                                                                                                                                                                          
exec(@select + @inner + @where )  
                                                                                                                                                                                                                           
-----------------------------------------------------------------------------------------------------
                                                                                                                                                        

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_MantenimientoLista]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SP_GASTOS_MantenimientoLista]  --4,'20050101','20051116','',57,'',5
                                                                                                                                                                          
	@Area varchar(5),
                                                                                                                                                                                                                                           
	@FechaiNi varchar(8),
                                                                                                                                                                                                                                       
	@FechaFin varchar(8),
                                                                                                                                                                                                                                       
	@Estado varchar(2),
                                                                                                                                                                                                                                         
	@TipoServicio int, 
                                                                                                                                                                                                                                         
	@ConceptoServicio varchar(5),
                                                                                                                                                                                                                               
	@CodGrupo varchar(2)
                                                                                                                                                                                                                                        
AS   
                                                                                                                                                                                                                                                        
/*
                                                                                                                                                                                                                                                           
SET @Area = 'GAS'
                                                                                                                                                                                                                                            
SET @FechaiNi ='20051001'
                                                                                                                                                                                                                                    
SET @FechaFin ='20051030'
                                                                                                                                                                                                                                    
SET @Estado =''
                                                                                                                                                                                                                                              
SET @TipoServicio =57
                                                                                                                                                                                                                                        
SET @ConceptoServicio =''
                                                                                                                                                                                                                                    
SET @CodGrupo = '2'
                                                                                                                                                                                                                                          
*/
                                                                                                                                                                                                                                                           
declare @cadena varchar(255)
                                                                                                                                                                                                                                 
set @cadena =''
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
declare @cadena1 varchar(5000)
                                                                                                                                                                                                                               
set @cadena1 =''
                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
if rtrim(ltrim(@Estado)) <> ''
                                                                                                                                                                                                                               
  begin
                                                                                                                                                                                                                                                      
	set @Estado=rtrim(ltrim(@Estado))
                                                                                                                                                                                                                           
	set @cadena = @cadena + ' and O.EST_Codigo = convert(int,''' +  @Estado + ''') '
                                                                                                                                                                            
  end
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
if rtrim(ltrim(@ConceptoServicio)) <> ''
                                                                                                                                                                                                                     
  begin
                                                                                                                                                                                                                                                      
	set @ConceptoServicio= rtrim(ltrim(@ConceptoServicio)) 
                                                                                                                                                                                                     
	set @cadena = @cadena + ' and s.CON_Codigo = convert(int,''' + @ConceptoServicio + ''') '
                                                                                                                                                                   
  end
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
if rtrim(ltrim(@CodGrupo)) <> ''
                                                                                                                                                                                                                             
  begin
                                                                                                                                                                                                                                                      
	set @CodGrupo=rtrim(ltrim(@CodGrupo)) 
                                                                                                                                                                                                                      
	set @cadena = @cadena + 'and s.con_codigo in (select idservicioarea from ost_grupo_servicioarea where idgrupo ='+@CodGrupo+')'
                                                                                                                              
  end
                                                                                                                                                                                                                                                        
begin
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
exec(
                                                                                                                                                                                                                                                        
	'SELECT distinct 
                                                                                                                                                                                                                                           
	O.OSE_Codigo,   
                                                                                                                                                                                                                                            
	O.OSE_CodigoOrigen,   
                                                                                                                                                                                                                                      
	O.OSE_Fecha,   
                                                                                                                                                                                                                                             
	O.EST_Codigo,  
                                                                                                                                                                                                                                             
	O.OSE_Descripcion,  
                                                                                                                                                                                                                                        
	E.EST_Descripcion,
                                                                                                                                                                                                                                          
	ts.glosa_de_operaciones as CON_NOMBRE ,     
                                                                                                                                                                                                                
	A.ARE_Nombre,
                                                                                                                                                                                                                                               
	dbo.fn_BuscaDatos(O.OSE_Codigo,116) as Volante,
                                                                                                                                                                                                             
	dbo.fn_BuscaDatos(O.OSE_Codigo,102) as nave,
                                                                                                                                                                                                                
	dbo.fn_BuscaDatos(O.OSE_Codigo,104) as viaje,
                                                                                                                                                                                                               
	dbo.fn_BuscaDatos(O.OSE_Codigo,109) as AgenteAdu,
                                                                                                                                                                                                           
	dbo.fn_BuscaDatos(O.OSE_Codigo,152) as Cliente,
                                                                                                                                                                                                             
	dbo.fn_BuscaDatos(O.OSE_Codigo,108) as CodigoAgente,
                                                                                                                                                                                                        
	dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,
                                                                                                                                                                                                           
	O.ARE_CODIGOINTERNO,
                                                                                                                                                                                                                                        
	s.CON_Codigo
                                                                                                                                                                                                                                                
	FROM  OST_ORDEN_SERVICIO O 
                                                                                                                                                                                                                                 
	inner join OST_ESTADO E  on  O.EST_Codigo=E.EST_Codigo   
                                                                                                                                                                                                   
	inner join seguridad.dbo.sgt_area as A on A.ARE_CODIGOINTERNO = O.ARE_CODIGOINTERNO
                                                                                                                                                               
	inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo 
                                                                                                                                                                                     
	inner join NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES as TS ON TS.id_codigo = s.CON_Codigo
                                                                                                                                                             
	WHERE  O.TSV_Codigo = ' + @TipoServicio + ' 
                                                                                                                                                                                                                
	and O.ARE_CODIGOINTERNO = ''' + @Area + '''
                                                                                                                                                                                                                 
	and s.OSH_FlagTipoSer = 1
                                                                                                                                                                                                                                   
	and O.EST_Codigo <> 2
                                                                                                                                                                                                                                       
	and O.OSE_Fecha between ''' + @FechaiNi + '''
                                                                                                                                                                                                               
	and  dateadd(dd,1,''' + @FechaFin + ''') ' +  @cadena + ' order by o.ose_codigo ' 
                                                                                                                                                                          
 )
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
end
                                                                                                                                                                                                                                                          
--------------------------------------------------------------------------
                                                                                                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------
                                                                                                                                                                                   

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ObtenerListaGastos]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_GASTOS_ObtenerListaGastos]
as
select 'con_servicio' = id_codigo,
	'con_nombre'	= glosa_de_operaciones
from  NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES
---------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ObtenerOrdenesActualizar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_GASTOS_ObtenerOrdenesActualizar]  
	@intSucursa int,    
	@intCenCos int,    
 	@vchFechaini varchar(14),    
 	@vchFechafin varchar(14),    
 	@intGrupo int    
as    
/*   
set @intSucursa = 3 --depositos de vacios    
set @intCenCos = 'IMPO'
set @vchFechaini = '01/10/2005'    
set @vchFechafin = '30/11/2005'    
set @intGrupo = 6
 */   
declare @dtFechaIni datetime,    
 	@dtFechaFin datetime,
	@vchCenCos varchar(10)
set @vchCenCos = (select are_codigointerno from dbo.SGV_Lista_Area where are_codigo = @intCenCos)
if @vchFechaini =''    
 set @dtFechaIni = (select min(dbo.SGF_ConvertirStrFechaDatetime(ose_fecha_req)) from ost_orden_Servicio)    
else    
 set @dtFechaIni = dbo.SGF_ConvertirStrFechaDatetime(@vchFechaini)    
if @vchFechafin =''    
 set @dtFechaFin = (select max(dbo.SGF_ConvertirStrFechaDatetime(ose_fecha_req))  from ost_orden_Servicio)    
else    
 set @dtFechaFin = dbo.SGF_ConvertirStrFechaDatetime(@vchFechafin)    
    

SELECT  S.OSE_CODIGO,    
 	S.EST_CODIGO,    
	'fechaAtencio'  = s.ose_fecha_req,    
 	'servicio' = ts.nombre,    
	'IdServicio'  = sh.ose_codigo     
FROM OST_ORDEN_SERVICIO S    
INNER JOIN OST_ORDEN_SERVICIO_CONFIG SC ON S.OSE_CODIGO = SC.OSE_CODIGO    
inner join ost_orden_servicio_hijo sh on sh.ose_codigo = sc.ose_codigo    
inner join tav_servicio ts on ts.servicio = sh.con_codigo    
inner join tav_servicioarea sa on ts.servicio = sa.servicio    
inner join ost_grupo_servicioarea gsa on gsa.idservicioarea = sa.servicioarea    
WHERE /* dbo.fn_BuscaDatos(s.ose_codigo,156) is not null     
 and*/ s.est_codigo = 1    
 and s.are_codigoInterno=@vchCenCos
 and gsa.idgrupo = @intGrupo    
 and dbo.fn_BuscaDatos(s.ose_codigo,164) = @intSucursa    
 and dbo.SGF_ConvertirStrFechaDatetime(s.ose_fecha_req)  between  @dtFechaIni and @dtFechaFin    
-- and isnull(dbo.SGF_ConvertirStrFechaDatetime(s.ose_fecha_req),'') =''    
 and sc.cam_codigo = 166  
 and isnull(dbo.fn_BuscaDatos(s.ose_codigo,166),'') = '' 
group by s.ose_codigo,s.est_codigo,ts.nombre,sh.OSE_Codigo,s.ose_fecha_req


GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ObtenerOrdenServicio]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SP_GASTOS_ObtenerOrdenServicio]  --70140
                                                                                                                                                                                                
	@intOrden	int
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
select 	'Orden'		= os.ose_codigo,
                                                                                                                                                                                                                            
	'Servicio'	= s.nombre,
                                                                                                                                                                                                                                      
	'CenCos'	= a.are_nombre,
                                                                                                                                                                                                                                    
	'FechaRe'	= os.ose_fecha_req,
                                                                                                                                                                                                                               
	'Proveedor'	= case 
                                                                                                                                                                                                                                         
			   when isnull(dbo.fn_BuscaDatos(@intOrden,166),'')<>'' then (select dg_razon_social from  NPT9_bd_nept.dbo.tb_persona where dc_rut= dbo.fn_BuscaDatos(@intOrden,166))
                                                                               
			   when isnull(dbo.fn_BuscaDatos(@intOrden,166),'')= '' then 'no asignado'
                                                                                                                                                                                
			  end
                                                                                                                                                                                                                                                     
from ost_orden_servicio os
                                                                                                                                                                                                                                   
inner join dbo.SGV_Lista_Area a on a.are_codigointerno = os.are_codigointerno
                                                                                                                                                                                
inner join ost_orden_servicio_hijo oh on oh.ose_codigo = os.ose_codigo
                                                                                                                                                                                       
inner join dbo.TAV_Servicio s on s.servicio =oh.con_codigo
                                                                                                                                                                                                   
where os.ose_codigo = @intOrden and os.est_codigo = 1 and oh.osh_flagtiposer<>1
                                                                                                                                                                              

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
                                                                                                                                                                

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ObtenerServicioxGrupo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_GASTOS_ObtenerServicioxGrupo]   
 @intGrupoSer int,  
 @intCenCosto int  
as  
/*  
descripción : Obtener los Servicios que estan asociados  
fecha : 11/10/2005  
*/  
select  'codigo'= s.servicio,   
 	'nombre' = s.nombre,s.codigoservicio,s.codigoexterno,sa.area  
from dbo.TAV_Servicio as s  
inner join dbo.TAV_ServicioArea as sa  on sa.servicio = s.servicio  
inner join ost_grupo_servicioarea as gsa on gsa.idServicioArea = sa.servicioarea  
where  	gsa.idgrupo =  @intGrupoSer and  
	sa.area = @intCenCosto  and
	flagtiporegistro = 1
order by s.nombre  
-------------------------------------------------------------------  




GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_OrdenServicioHijo_Insertar]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_GASTOS_OrdenServicioHijo_Insertar]
	@OSE_Codigo as integer,  
	@EST_Codigo as integer,  
	@CON_Codigo as integer,
	@flag_Tipo  as bit
AS  
SET NOCOUNT ON  
  
	DECLARE @V_OSH_Codigo  int  
	  
	SELECT @V_OSH_Codigo=MAX(OSH_Codigo) + 1   
	FROM    OST_ORDEN_SERVICIO_HIJO     
	WHERE OSE_Codigo = @OSE_Codigo  
	  
	  
	IF @V_OSH_Codigo is NULL   
	begin  
	PRINT 'ENTRO AL IF'  
	set @V_OSH_Codigo = 1  
	end  
	  
	PRINT @V_OSH_Codigo   
	  
	INSERT INTO OST_ORDEN_SERVICIO_HIJO  
	    (OSE_Codigo, OSH_Codigo,EST_Codigo, CON_Codigo,OSH_FlagTipoSer)  
	 VALUES (@OSE_Codigo,@V_OSH_Codigo,@EST_Codigo,@CON_Codigo,@flag_Tipo)  
	  
	  
	select @V_OSH_Codigo  
	  
  
SET NOCOUNT OFF  


GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_ReportePreFactura]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_GASTOS_ReportePreFactura] --'10249902468','20051104','20051116' --70149
	@vchProveedor	varchar(11),
	@chrFechaIni	char(8),
	@chrFechaFin	char(8)
as
/*
set	@vchProveedor	='10249902468'--'10249902468'
set	@chrFechaIni	='20051030'
set	@chrFechaFin	='20051125'
*/
if @chrFechaIni =''
  begin
	set @chrFechaIni = (select min(substring(ose_fecha_req,7,4)+substring(ose_fecha_req,4,2)+ substring(ose_fecha_req,1,2)) from dbo.ost_orden_servicio)
  end
else
  begin
	set @chrFechaFin = (select max(substring(ose_fecha_req,7,4)+substring(ose_fecha_req,4,2)+ substring(ose_fecha_req,1,2)) from dbo.ost_orden_servicio)
  end


select 	'FechaRealiza'	= os.ose_fecha_req,
	'OrdenServicio'	= os.ose_codigo,
	'idServicio' 	= oh.con_codigo,
	'Servicio'	= case oh.osh_flagtiposer
				--when 1 then (select concepto from terminal.dbo.itemgasto where codigoint =oh.con_codigo ) COLLATE Modern_Spanish_CI_AS
				when 1 then (select glosa_de_operaciones from NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES where id_codigo =oh.con_codigo ) COLLATE Modern_Spanish_CI_AS
				else (select nombre from ordenesservicio.dbo.TAV_Servicio where servicio =oh.con_codigo)--(select servicio from ordenesservicio.dbo.TAV_ServicioArea where servicioarea =oh.con_codigo ))
			  end ,
	'Proveedor'	= case oh.osh_flagtiposer
			  	when 1 then upper(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,167))
				else (select dg_razon_social from neptunia9.bd_nept.dbo.tb_persona where dc_rut = ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,166) COLLATE Modern_Spanish_CI_AS )
			  end,
	'Sucursal'	= case oh.osh_flagtiposer
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,171)
				else (select dg_sucursal from neptunia9.bd_inst.dbo.tb_sucursal_inst where dc_sucursal = ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,164) COLLATE Modern_Spanish_CI_AS )
			  end,
	'CenCos'	= case oh.osh_flagtiposer
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,172) --(select oc_valor from ordenesservicio.dbo.ost_orden_servicio_config  where ose_codigo = os.ose_codigo and cam_codigo = 171)
				else (select are_nombre from  ordenesservicio.dbo.SGV_Lista_Area where are_codigointerno = os.are_codigointerno)
			  end,
	'Monto'		= ISNULL(T.MONTO,0.00),
	'TipoMerca'	= case oh.osh_flagtiposer
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,163) COLLATE Modern_Spanish_CI_AS + ' ' + ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,141) COLLATE Modern_Spanish_CI_AS --(select oc_valor from ordenesservicio.dbo.ost_orden_servicio_config  where ose_codigo = os.ose_codigo and cam_codigo = 163) + ' ' + (select oc_valor from ordenesservicio.dbo.ost_orden_servicio_config  where ose_codigo = os.ose_codigo and cam_codigo = 141)
				else t.codembalaje + ' ' +t.tamanocont
			  end
from ordenesservicio.dbo.ost_orden_servicio os
inner join ordenesservicio.dbo.ost_orden_servicio_hijo oh on oh.ose_codigo = os.ose_codigo
inner join ordenesservicio.dbo.ost_orden_servicio_config oc on os.ose_codigo = oc.ose_codigo
INNER JOIN ORDENESSERVICIO.DBO.OST_GRUPO_SERVICIOAREA GS ON (GS.IDSERVICIOAREA = OH.CON_CODIGO and gs.flagtiporegistro = 0) or
							     (gs.idservicioarea=(select servicioarea from ordenesservicio.dbo.TAV_ServicioArea
									   where servicio = oh.con_codigo and  area= (select are_codigo from  ordenesservicio.dbo.SGV_Lista_Area where are_codigointerno = os.are_codigointerno)
							      ) and gs.flagtiporegistro = 1) 
left join terminal.dbo.dqtarser01 t	on 
			T.IDPROVEEDOR = @vchProveedor COLLATE Modern_Spanish_CI_AS  AND 
			T.IDINGRESOGASTOS=OH.CON_CODIGO and
			GS.IDGRUPO = T.IDGRUPOSERVICIO AND 
			T.FLAGTIPOSERV = (1-isnull(OH.osh_flagtiposer,0)) and 
			((t.idcentrocosto = ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,170) AND OH.OSH_FLAGTIPOSER=1) OR 
			 (t.idcentrocosto =(select are_codigo from  ordenesservicio.dbo.SGV_Lista_Area where are_codigointerno = os.are_codigointerno) AND ISNULL(OH.OSH_FLAGTIPOSER,0)=0)
			) and 
			((t.codembalaje=(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,163) COLLATE Modern_Spanish_CI_AS) and oh.osh_flagtiposer=1) or 
			 (t.codembalaje=(select case 
					    WHEN ISNULL(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,136),'') COLLATE Modern_Spanish_CI_AS <>'' then 'CTR'
					    WHEN ISNULL(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,129),'') COLLATE Modern_Spanish_CI_AS <>'' then 'BUL'
					    WHEN ISNULL(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,131),'') COLLATE Modern_Spanish_CI_AS <>'' then 'CTR'
					END) AND ISNULL(oh.osh_flagtiposer,0)=0
			))  and
			((t.tamanocont = (isnull(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,141),'') COLLATE Modern_Spanish_CI_AS ) and oh.osh_flagtiposer=1 ) or
			 (t.tamanocont = right(rtrim(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,127)),2) and ISNULL(oh.osh_flagtiposer,0)=0)
			)
where 	(OC.CAM_CODIGO = 166 and oc.oc_valor = @vchProveedor)
	and convert(datetime,substring(os.ose_fecha_req,7,4)+substring(os.ose_fecha_req,4,2)+ substring(os.ose_fecha_req,1,2)) between @chrFechaIni and @chrFechaFin
	and os.EST_Codigo = 1
order by os.ose_codigo
----------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SP_GASTOS_SeleccionaPorCodigo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_GASTOS_SeleccionaPorCodigo] 
	@OSE_Codigo int
as 
/* OBTIENE LOS GASTOS POR LA ORDEN DE SERVICIO
*/
SELECT 
	OSH.OSE_Codigo,OSH.OSH_Codigo,OSH.EST_Codigo,
	OSH.OSH_CodigoOrigen,OSH.CON_Codigo ,
	CS.Glosa_de_operaciones as CON_Descripcion,
	CS.Glosa_de_operaciones as CON_Nombre,
	ES.EST_NOMBRE
FROM 
	OST_ORDEN_SERVICIO_HIJO OSH , 
	NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES CS,
	OST_ESTADO ES
WHERE 
	OSH.OSE_Codigo= @OSE_Codigo
	AND OSH.CON_Codigo = CS.Id_Codigo
	AND OSH.EST_CODIGO = ES.EST_CODIGO
--------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SP_ObtenerOrdenExportacion]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ObtenerOrdenExportacion]  

  

            @intOrden        int    

  

as    

  

SELECT distinct     

  

            case     

  

  when dbo.fn_BuscaDatos(O.OSE_Codigo,109) is null then (select usu_nombres from seguridad.dbo.sgt_usuario where USU_CodigoInterno=dbo.fn_BuscaDatos(O.OSE_Codigo,108))      

  

  else dbo.fn_BuscaDatos(O.OSE_Codigo,109)     

  

  end    

  

     as Agencia,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,102) as Nave,    

  

            o.ose_fecha_req + ' - ' + o.ose_hora_req as FechaServicio,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,104) as ViajeNro,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,115) as Linea,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,161) as DescripcionServicio,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,150) as ImporteTarifa,    

  

            ts.nombre as Servicio,    

  

            dbo.fn_BuscaDatos(O.OSE_Codigo,179) as Embarcador,    

  

--            dbo.fn_BuscaDatos(O.OSE_Codigo,178) as NroEmbarque,    

  

                fcdua.oc_valor as NroEmbarque,    

  

            case      

  

                        when isnull(fc1.oc_valor,'')<>'' then fc1.oc_valor     

  

                        when isnull(fc4.oc_valor,'')<>'' then fc4.oc_valor     

  

                        when isnull(fc5.oc_valor,'')<>'' then fc5.oc_valor     

  

            else 'no hay'    

  

            end    

  

                        as Contenedores,    

  

            fc2.oc_valor as TipoContenedor,    

  

            fc3.oc_valor as TamanioContenedor,    

  

            fc6.oc_valor as ubicacion,    

  

            fcdesp.oc_valor + ' '+ fcnomdesp.oc_valor as ordendespachador ,    

  

            fcnomdesp.oc_valor as ORDENNOMBREDESP,    

  

            isnull(USU.USU_NOMBRES,'') + ' ' + isnull(USU.USU_paterno,'') + ' '+ isnull(USU.usu_materno,'')  as UsuNombre ,    

  

     case      

  

                        when o.flagrequieresenasa=1 then 'Requiere Senasa'    

  

                        else 'No Requiere Senasa'    

  

                        end    

  

            as RequiereSenasa ,    

  

     dbo.fn_BuscaDatos(O.OSE_Codigo,155) as observacion   

  

    

  

FROM  OST_ORDEN_SERVICIO O     

  

inner join OST_AUDITORIA_ORDEN as AUD on AUD.ose_Codigo = O.Ose_codigo     

  

inner join seguridad.dbo.sgt_usuario as USU on USU.USU_Codigo=AUD.usu_codigo     

  

inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo     

  

inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo    

  

inner join dbo.fn_BuscaDatostabla (@intOrden,139) as fc1 on o.ose_codigo = fc1.ose_codigo       

  

left join dbo.fn_BuscaDatostabla (@intOrden,140) as fc2 on o.ose_codigo = fc2.ose_codigo and fc1.cam_index = fc2.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,141) as fc3 on o.ose_codigo = fc3.ose_codigo and fc1.cam_index = fc3.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,129) as fc4 on o.ose_codigo = fc4.ose_codigo and fc1.cam_index = fc4.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,131) as fc5 on o.ose_codigo = fc5.ose_codigo and fc1.cam_index = fc5.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,142) as fc6 on o.ose_codigo = fc6.ose_codigo and fc1.cam_index = fc6.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,174) as fcdesp on o.ose_codigo = fcdesp.ose_codigo  --and fc1.cam_index = fcdesp.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,175) as fcnomdesp on o.ose_codigo = fcnomdesp.ose_codigo --and fc1.cam_index = fcnomdesp.cam_index     

  

left join dbo.fn_BuscaDatostabla (@intOrden,178) as fcdua on o.ose_codigo = fcdua.ose_codigo and fc1.cam_index = fcdua.cam_index     

  

where   o.ose_codigo =@intOrden   
 


GO
/****** Object:  StoredProcedure [dbo].[SP_ObtenerOrdenImportacion]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ObtenerOrdenImportacion] @intOrden INT
AS
SELECT DISTINCT dbo.fn_BuscaDatos(O.OSE_Codigo, 109) AS Agencia
	,o.ose_fecha AS FechaEmision
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 102) AS Nave
	,o.ose_fecha_req + ' - ' + o.ose_hora_req AS FechaServicio
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 104) AS ViajeNro
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 115) AS Linea
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 112) AS bl
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 161) AS DescripcionServicio
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 150) AS ImporteTarifa
	,Servicio = ( ts.CodigoServicio + ' / ' + ts.nombre  )
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 116) AS nroVolante
	,CASE 
		WHEN isnull(fc1.oc_valor, '') <> ''
			THEN fc1.oc_valor
		WHEN isnull(fc4.oc_valor, '') <> ''
			THEN fc4.oc_valor
		WHEN isnull(fc5.oc_valor, '') <> ''
			THEN fc5.oc_valor
		ELSE 'no hay'
		END AS Contenedores
	,fc2.oc_valor AS TipoContenedor
	,fc3.oc_valor AS TamanioContenedor
	,fc6.oc_valor AS ubicacion
	,fc5.oc_valor AS Vehiculo
	,fc7.oc_valor AS RUC_Cliente
	,fc8.oc_valor AS Cliente
	,fcitemnro.oc_valor AS ItemNro
	,fcitemq.oc_valor AS ItemCantidad
	,fcitememb.oc_valor AS ItemEmbalaje
	,fcitemcont.oc_valor AS ItemContenido
	,fcitemdesc.oc_valor AS ItemDescripcion
	,fccarnroman.oc_valor AS CargaNroManifiesto
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 174) AS ordendespachador
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 175) AS ORDENNOMBREDESP
	,dbo.fn_BuscaDatos(O.OSE_Codigo, 155) AS ORDENOBS
	,isnull(USU.USU_NOMBRES, '') + ' ' + isnull(USU.USU_paterno, '') + ' ' + isnull(USU.usu_materno, '') AS UsuNombre
	,CASE 
		WHEN o.flagrequieresenasa = 1
			THEN 'Requiere Senasa'
		ELSE 'No Requiere Senasa'
		END AS RequiereSenasa
	,
	-- **MDTECH 20110920  
	-- SE AGREGA LOS CAMPOS PARA EL CRYSTAL REPORT DE ORDENES DE SERVICIO  
	O.OSE_CODDESP AS CODDESP
	,--OST_CODDESP  
	CASE 
		WHEN DS.DNI IS NOT NULL
			THEN DS.DNI
		ELSE DS.DOCUMENTO
		END AS DNI
	,-- DOCUMENTO O DNI(PUEDE SEeR NULO)  
	O.OSE_DUA AS DUA
	,-- OST_DUA  
	O.OSE_CANAL AS CANAL -- OST_CANAL   
	--** FIN MDTECH  
FROM OST_ORDEN_SERVICIO O
INNER JOIN OST_AUDITORIA_ORDEN AS AUD ON AUD.ose_Codigo = O.Ose_codigo
LEFT JOIN seguridad.dbo.sgt_usuario AS USU ON USU.USU_Codigo = AUD.usu_codigo
INNER JOIN OST_ORDEN_SERVICIO_HIJO AS S ON S.ose_Codigo = O.Ose_codigo
INNER JOIN tav_servicio AS TS ON TS.servicio = s.CON_Codigo
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 136) AS fc1 ON o.ose_codigo = fc1.ose_codigo
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 124) AS fcitemnro ON o.ose_codigo = fcitemnro.ose_codigo
	AND fc1.cam_index = fcitemnro.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 125) AS fcitemq ON o.ose_codigo = fcitemq.ose_codigo
	AND fc1.cam_index = fcitemq.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 126) AS fcitememb ON o.ose_codigo = fcitememb.ose_codigo
	AND fc1.cam_index = fcitememb.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 127) AS fcitemcont ON o.ose_codigo = fcitemcont.ose_codigo
	AND fc1.cam_index = fcitemcont.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 123) AS fcitemdesc ON o.ose_codigo = fcitemdesc.ose_codigo
	AND fc1.cam_index = fcitemdesc.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 128) AS fccarnroman ON o.ose_codigo = fccarnroman.ose_codigo
	AND fc1.cam_index = fccarnroman.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 140) AS fc2 ON o.ose_codigo = fc2.ose_codigo
	AND fc1.cam_index = fc2.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 141) AS fc3 ON o.ose_codigo = fc3.ose_codigo
	AND fc1.cam_index = fc3.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 129) AS fc4 ON o.ose_codigo = fc4.ose_codigo
	AND fc1.cam_index = fc4.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 131) AS fc5 ON o.ose_codigo = fc5.ose_codigo
	AND fc1.cam_index = fc5.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 165) AS fc6 ON o.ose_codigo = fc6.ose_codigo
	AND fc1.cam_index = fc6.cam_index
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 151) AS fc7 ON o.ose_codigo = fc7.ose_codigo --and fc1.cam_index = fc7.cam_index       
LEFT JOIN dbo.fn_BuscaDatostabla(@intOrden, 152) AS fc8 ON o.ose_codigo = fc8.ose_codigo --and fc1.cam_index = fc8.cam_index       
	--** MDTECH 20110920  
	-- SE AGREGA EL ENLACE A LA TABLA DESPACHADOR PARA LA OBTENCION  
	-- DE LOS DATOS DEL DESPACHADOR  
LEFT JOIN terminal.dbo.despachador ds ON cast(ds.documento AS VARCHAR(11)) COLLATE Modern_Spanish_CI_AS = o.ose_coddesp COLLATE Modern_Spanish_CI_AS
--** FIN MDTECH  
WHERE o.ose_codigo = @intOrden

GO
/****** Object:  StoredProcedure [dbo].[SP_OrdenSelDespachador_old]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_OrdenSelDespachador_old]  
 @vchNombre varchar(100)  
as  
select  'ORDENDESPACHADOR'=codibm45,  
 'ORDENNOMBREDESP' = rtrim(nomage45) + ' '+ rtrim(apeage45)  
from terminal.dbo.dqageaut45  
where  codtip45 = 'a' and  
  (nomage45 like '%'+@vchNombre+'%'  or apeage45 like '%'+@vchNombre+'%')  
order by rtrim(nomage45) + ' '+ rtrim(apeage45)

GO
/****** Object:  StoredProcedure [dbo].[sp_os_EliminaOsExpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_os_EliminaOsExpo]  
@NROORDEN INT    
as    
 
delete from descarga.dbo.eddetord51   
where nroors50 = @NROORDEN  
 
delete from descarga.dbo.edordser50  
where nroors50 = @NROORDEN  
return 0  

 

GO
/****** Object:  StoredProcedure [dbo].[sp_os_EliminaOsImpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_os_EliminaOsImpo]
@NROORDEN INT  
as  
delete terminal.dbo.dddetors33 
where nroors32 = @NROORDEN

delete terminal.dbo.ddordser32
where nroors32 = @NROORDEN
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_os_InsertaOSExpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_os_InsertaOSExpo] 
@NROORDEN INT          
as          
insert into descarga.dbo.edordser50           
(          
nroors50,          
codage19,          
codarm10,          
navvia11,          
genbkg13,          
fecord50,          
flgimp50,          
detord50,          
status50,          
codtip48,          
nrodoc50,          
codusu17,          
fecusu00,          
ruccli50,          
flgtra99,          
fectra99,          
codage29,          
sucursal,          
orsint50          
)          
  
SELECT  distinct    
right('0'+ convert(varchar(6),O.OSE_Codigo),6) as OSE_Codigo,             
case when dbo.fn_BuscaDatos(O.OSE_Codigo,160) is null then 
     (select contribuy from terminal.dbo.aaclientesaa 
      where cliente = dbo.fn_BuscaDatos(O.OSE_Codigo,108))
else dbo.fn_BuscaDatos(O.OSE_Codigo,160) end as RucAgente,          
dbo.fn_BuscaDatos(O.OSE_Codigo,114) as CodigoLinea,          
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,          
dbo.fn_BuscaDatos(O.OSE_Codigo,162) as genbkg13,          
substring(O.OSE_Fecha_Req,7,4)+substring(O.OSE_Fecha_Req,4,2)+substring(O.OSE_Fecha_Req,1,2)  as OSE_Fecha,             
'1' as flgimp50,          
dbo.fn_BuscaDatos(O.OSE_Codigo,155) as observacion,          
'P' as Estado,          
null as codtip48,          
null as nrodoc50,          
us.usu_codigoInterno as usuario,        
O.OSE_Fecha as fecusu00,          
null as ruccli50,          
'I' as flgtra99,          
getdate () as fectra99,          
'' asclienteweb,          
dbo.fn_BuscaDatos(O.OSE_Codigo,176) as sucursal,          
null as orsint50          
FROM  OST_ORDEN_SERVICIO O           
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo        
inner join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo          
WHERE O.OSE_Codigo = @NROORDEN          
  
  
insert into descarga.dbo.eddetord51          
(          
nroors50,          
codcon14,          
codent51,          
tipent03,          
detord50,          
importe51,          
flgtra99,          
fectra99,          
sucursal,          
codpla28          
)          
select           
--O.OSE_Codigo,             
right('0'+ convert(varchar(6),O.OSE_Codigo),6) as OSE_Codigo,             
ts.codigoservicio,          
fc.oc_valor  as codigocontenedor,          
'09' as tippent103,          
isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,161), '') as observacion,          
dbo.fn_BuscaDatos(O.OSE_Codigo,150) as Tarifa,          
'I' as flgtra99,          
getdate () as fectra99,          
dbo.fn_BuscaDatos(O.OSE_Codigo,176) as sucursal,          
null as codpla28          
FROM  OST_ORDEN_SERVICIO O           
inner join dbo.fn_BuscaDatostabla (@NROORDEN,139) as fc on o.ose_codigo = fc.ose_codigo             
--inner join OST_ESTADO E  on   E.EST_Codigo=O.EST_Codigo             
--inner join n3ptunia1.seguridad.dbo.sgt_area as A on A.ARE_CODIGO = O.ARE_CODIGOINTERNO          
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo           
inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo          
WHERE O.OSE_Codigo = @NROORDEN          
return 0      


GO
/****** Object:  StoredProcedure [dbo].[sp_os_InsertaOSImpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_os_InsertaOSImpo]                         
--declare               
@NROORDEN varchar(20)                        
as            
--set @NROORDEN = 152684            
          
         
insert into Terminal.dbo.ddordser32                        
(nroors32, fecors32, nrosec23, codcon35, navvia11, nrodet12, nroitm13, flgimp32, codage19,                        
nrofac37, fecser32, status32, forors32, forcar32, feccar32, codtip48, valing32, codusu17,                        
fecusu00, codemb06, codibm45, flgtra99, fectra99, ruccli32, sucursal, codcon15, rucpro12)                     
              
SELECT  distinct                
right('0'+ convert(varchar(6),O.OSE_Codigo),6) as OSE_Codigo,                           
O.OSE_Fecha,                           
dbo.fn_BuscaDatos(O.OSE_Codigo,116) as nrosec23,                        
case when T.TSV_FlagManual = 1 and TS.FLAGigv = 'S' THEN 'SERES'                
     when T.TSV_FlagManual = 1 and TS.FLAGigv = 'N' THEN 'SERE0'                
     ELSE ts.codigoservicio END AS codigoservicio,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,111) as nroDetalle,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,124) as nroItem,                        
'I' as FlgImp,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,108) as codAgente,                        
null as fecfac,                        
--dbo.fn_BuscaFechas(O.OSE_Codigo,156) as FechaRealizacion,                        
substring(O.OSE_Fecha_Req,7,4)+substring(O.OSE_Fecha_Req,4,2)+substring(O.OSE_Fecha_Req,1,2)    as  FechaRealizacion,                      
'E' as Estado,                        
right('0'+ convert(varchar(6),O.OSE_Codigo),6) as OSE_Codigo,                           
null as forcar32,                        
null as feccar32,                        
null as codtip48,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,150) as Tarifa,                        
us.usu_codigoInterno as usuario,                        
--ao.usu_codigo as usuario,                        
             
getdate() as fecusu,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,163) as Codemb06,                        
null as codibm45,                        
null as flgtra99,                        
null as fectra99,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,151) as ruccli12,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,164) as Sucursal,                        
ts.codigoservicio,                        
null as rucpro12                        
FROM  OST_ORDEN_SERVICIO O                         
inner join OST_tipo_servicio as T on O.tsv_codigo = T.tsv_codigo                
inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo                         
inner join tav_servicio as TS ON TS.servicio = s.CON_Codigo                        
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo                        
left join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo                        
WHERE O.OSE_Codigo = @NROORDEN                         
and ao.est_codigo = 1                        
            
insert into terminal.dbo.dddetors33                        
(nroors32, codcon63, nrocar16, nroveh14, observ33, horbal33,                        
nrosec22, valcal33, navvia11, flgtra99, fectra99, sucursal)                        
select                         
--O.OSE_Codigo,                           
right('0'+ convert(varchar(6),O.OSE_Codigo),6) as OSE_Codigo,                           
case when fc1.oc_valor = '' then null                
else fc1.oc_valor END as codcon63,                      
fc2.oc_valor  as nrocar16,                        
fc3.oc_valor  as nrovhe14,                        
case WHEN flagrequieresenasa = 1 then 'INSPECCION SENASA'                  
ELSE  substring(dbo.fn_BuscaDatos(O.OSE_Codigo,161),1,50) END as observacion,                        
null as horbal33,                        
fc4.oc_valor  as nrose22,                        
convert(decimal(10,2), dbo.fn_BuscaDatos(O.OSE_Codigo,150))/convert(decimal(10,2), dbo.fn_BuscaDatosTotal(O.OSE_Codigo,126)) as valcal33,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,                        
null as flatra99,                
null as fectra99,                        
dbo.fn_BuscaDatos(O.OSE_Codigo,164) as Sucursal                        
FROM  OST_ORDEN_SERVICIO O         
inner join dbo.fn_BuscaDatostabla (@NROORDEN,136) as fc1 on o.ose_codigo = fc1.ose_codigo                           
inner join dbo.fn_BuscaDatostabla (@NROORDEN,128) as fc2 on o.ose_codigo = fc2.ose_codigo                           
inner join dbo.fn_BuscaDatostabla (@NROORDEN,131) as fc3 on o.ose_codigo = fc3.ose_codigo                           
inner join dbo.fn_BuscaDatostabla (@NROORDEN,129) as fc4 on o.ose_codigo = fc4.ose_codigo                           
WHERE O.OSE_Codigo = @NROORDEN                  
AND fc1.cam_index = fc2.cam_index                         
and fc1.cam_index = fc3.cam_index                        
AND fc1.cam_index = fc4.cam_index             
       
update terminal.dbo.ddordser32 set codemb06='VEH'            
from terminal.dbo.ddordser32 a, terminal.dbo.dditemsc13 b        
where           
a.navvia11=b.navvia11 and          
a.nrodet12=b.nrodet12 and          
a.nroitm13=b.nroitm13 and          
b.flgveh13='1' and b.codbol03='LC'          
and a.codcon35 in ('SERES','SERE0')        
and a.nroors32 = @NROORDEN       
  
--Anulo OS Repetidas  20130815  
 --exec sp_Valida_Orden_de_Servicio_Repetidas @NROORDEN  
  
/** Alerta de Movilización **/            
declare @nave varchar(15), @viaje varchar(10),   
@Contenedor char(11), @fecha char(10), @sucursal char(1), @Mensaje varchar(255)  
DECLARE cursor_Orden CURSOR for       
  
select substring(c.desnav08,1,15) as nave, b.numvia11 as viaje,   
d.codcon63 as contenedor,convert(char(10), fecors32, 103) as Fecha,   
a.sucursal as sucursal   
from Terminal.dbo.ddordser32 as a  
inner join terminal.dbo.dddetors33 as d on a.nroors32 = d.nroors32  
inner join terminal.dbo.ddcabman11 as b on a.navvia11 = b.navvia11   
inner join terminal.dbo.dqnavier08 as c on b.codnav08 = c.codnav08  
where codcon35 in ('TRALI', 'TRASD') and a.nroors32 = @NROORDEN  
      
OPEN cursor_orden  
FETCH NEXT FROM cursor_orden  
INTO @nave, @viaje, @contenedor, @Fecha, @Sucursal  
      
WHILE @@FETCH_STATUS = 0      
BEGIN      
 set @Mensaje = 'Nave: ' + @nave + ' /Viaje: ' + @Viaje + ' / Contenedor: ' + @Contenedor + ' / Sucursal ' + @sucursal + ' / Fecha: ' + @Fecha  
 exec terminal.dbo.sp_Alertas_Impo_Operaciones 'ALERTA DE SERVICIO TRASEGADO DE CTR ',@Mensaje  
    
 FETCH NEXT FROM cursor_orden  
 INTO @nave, @viaje, @contenedor, @Fecha, @Sucursal  
end      
CLOSE cursor_orden  
DEALLOCATE cursor_orden  
            
         
RETURN 0            
            
      
    
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_os_InsrtarUsuarioEstado]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_os_InsrtarUsuarioEstado]
@NROORDEN INT,  
@USUCODIGO VARCHAR(10),
@Estado int
as  

insert into ost_auditoria_orden 

(
ose_codigo,
est_codigo,
auo_fechaHoraInicio,
Usu_codigo,
auo_flagenvio)
values
(
@NROORDEN,
@Estado,
getdate(),
@USUCODIGO,
0 
)
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_os_ListadatosxVolante]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_os_ListadatosxVolante]   
@nrosec varchar(6)  
as  
/* Datos asociados al Volante */  
Select a.codage19 as AgenteCodigo,  
b.nombre as AgenteNombre,  
a.codarm10 as LineaCodigo,  
c.desarm10 as LineaDescripcion,        
a.navvia11 as ViajeNave,  
d.nrodet12 as detalleblNro,  
d.nrocon12 as detalleblNrobl,  
--d.flgfac12 as detalleblFlagFact,  
f.desnav08 as NaveDescripcion,   
g.codnav08 as NaveCodigo,   
g.numvia11 as ViajeNro ,   
g.fecdes11 as ViajeFecha,   
g.numman11 as ViajeNumMan, 
g.codcco06 as Viajeultra,
--/*,  
case when h.nrofac37 is not null then 'VOLANTE FACTURADO' 
ELSE 'REGISTRADO' END as EstadoFac,  
h.nrofac37 as FacturaNro  
--*/  
From ddvoldes23 a   
inner join aaagente01 b on a.codage19 = b.cliente   
inner join dqarmado10 c on a.codarm10 = c.codarm10  
inner join dddetall12 d on a.navvia11 = d.navvia11 and a.nrodet12 = d.nrodet12  
inner join ddcabman11 g on a.navvia11 = g.navvia11  
inner join dqnavier08 f on g.codnav08 = f.codnav08  
left join drpolfac42 h on a.nrosec23 = h.nrosec23  
Where a.nrosec23 = @nrosec

GO
/****** Object:  StoredProcedure [dbo].[sp_os_ListarNaveByCod]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_os_ListarNaveByCod]
@codnav08 varchar(4) 
as  
SELECT 	codnav08 as navecodigo, 
	desnav08 as navedescripcion
from DQNAVIER08  
WHERE codnav08 like '%' + @codnav08 +'%'
order by desnav08  

return 0



GO
/****** Object:  StoredProcedure [dbo].[sp_os_ModificaEstadoExpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_os_ModificaEstadoExpo]
@NROORDEN INT,  
@Estado int
as  
update descarga.dbo.edordser50 set
status50 = @Estado
where nroors50 = @NROORDEN
return 0


GO
/****** Object:  StoredProcedure [dbo].[sp_os_ModificaEstadoImpo]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_os_ModificaEstadoImpo]           
@NROORDEN bigINT,             
@Estado char(1)           
AS   
BEGIN       
	declare @sOrden char(6)    
	set @sOrden=convert(char(6),@NROORDEN)  
	
	IF EXISTS(
				SELECT *
				FROM TERMINAL..DDORDSER32 WITH (NOLOCK)
				WHERE nroors32 = @sOrden
				AND status32 <> 'A'
				AND ISNULL(nrofac37,'') <> ''
			 )
	BEGIN
		IF EXISTS( 
					SELECT * FROM TERMINAL..DDORDSER32 A WITH (NOLOCK)
					INNER JOIN TERMINAL..DDFACTUR37 B WITH (NOLOCK) ON A.nrofac37 = B.nrofac37
					WHERE B.status37 <> 'A'
					AND  nroors32 = @sOrden	   
				  )
		BEGIN
			PRINT 'EXITOSA'
			RETURN 0;
		END
	END
	
	  
	update terminal.dbo.ddordser32 set            
	status32 = @Estado          
	where nroors32 = @sOrden        
	    
	return 0 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TRM_InsertaAuditoriaRetiro]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_TRM_InsertaAuditoriaRetiro]
@FechaOrden datetime,
@NroOrden varchar(8),
@Contenedor varchar (11),
@Observaciones varchar (500)
as
INSERT INTO TRM_AuditoriaRetiro
(FechaSalida, SalidaAlmacen, Contenedor, 
UltimaFecha, Observaciones)
values
(@FechaOrden,
@NroOrden,
@Contenedor ,
getdate(),
@Observaciones 
)
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Valida_Orden_de_Servicio_Repetidas]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Valida_Orden_de_Servicio_Repetidas] @NroOS BIGINT    
AS    
DECLARE @sNroSec AS CHAR(06)    
DECLARE @sNroOrs AS CHAR(06)    
DECLARE @sCodCon AS CHAR(05)    
DECLARE @sNroItm AS CHAR(03)    
DECLARE @yy INT    
DECLARE @mm INT    
DECLARE @dd INT    
    
--|TABLAS TEMPORALES    
    
create table #servicio    
(    
servicio varchar(6),    
nrosec23 varchar(6),    
nroitm13 varchar(3)    
)    
    
CREATE TABLE #Tempo (    
cantidad INT    
,nrosec23 CHAR(06)    
,codcon35 CHAR(05)    
,nroors32 CHAR(06)    
,nroitm13 CHAR(03)    
,codcon63 VARCHAR(11)    
)    
/*    
IF EXISTS (    
   SELECT *    
   FROM TERMINAL..DDORDSER32 A    
   INNER JOIN TERMINAL..DDDETORS33 B ON A.nroors32 = B.nroors32    
   WHERE A.nroors32 = convert(CHAR(6), @NroOS)    
   AND ISNULL(B.codcon63,'')<>''    
    )    
BEGIN    
 SELECT @sNroSec = nrosec23    
  ,@yy = year(fecser32)    
  ,@mm = month(fecser32)    
  ,@dd = day(fecser32)    
  ,@sCodCon = codcon35    
  ,@sNroItm = nroitm13    
 FROM terminal..ddordser32    
 WHERE nroors32 = convert(CHAR(6), @NroOS)    
    
 INSERT INTO #Tempo    
 (cantidad,nrosec23,codcon35,nroors32,nroitm13,codcon63)    
 SELECT count(*)    
  ,@sNroSec    
  ,A.codcon35    
  ,''    
  ,A.nroitm13    
  ,B.codcon63    
 FROM terminal..DDORDSER32 A    
 INNER JOIN terminal..DDDETORS33 B ON A.nroors32 = B.nroors32    
 WHERE A.nrosec23 = @sNroSec    
  AND year(A.fecser32) = @yy    
  AND month(A.fecser32) = @mm    
  AND day(A.fecser32) = @dd    
  AND A.codcon35 = @sCodCon    
  AND A.status32 <> 'A'    
  AND A.codcon35 NOT IN (    
   'SERES'    
   ,'BALEX'    
   )    
  AND A.nrofac37 IS NULL    
 GROUP BY A.codcon35    
  ,A.nroitm13,B.codcon63    
 HAVING count(*) > 1    
     
 IF EXISTS(SELECT *FROM #Tempo)    
 BEGIN    
  --|OBTENER EL ULTIMOS SERVICIO GENERADO    
  INSERT INTO #servicio    
  SELECT TOP 1 b.nroors32,b.nrosec23,b.nroitm13    
  FROM #Tempo a    
  INNER JOIN terminal..ddordser32 b ON (    
    a.nrosec23 = b.nrosec23    
    AND a.nroitm13 = b.nroitm13    
    )    
  INNER JOIN terminal..DDDETORS33 c ON c.nroors32 = b.nroors32     
            AND c.codcon63 = a.codcon63    
  WHERE b.status32 <> 'A'    
   AND b.codcon35 = @sCodCon    
   AND year(fecser32) = @yy    
   AND month(fecser32) = @mm    
   AND day(fecser32) = @dd    
   AND b.codcon35 NOT IN (    
    'SERES'    
    ,'BALEX'    
    )    
  ORDER BY b.nroors32 DESC    
  --|    
      
  UPDATE #Tempo    
  SET nroors32 = b.servicio    
  FROM #Tempo a    
  INNER JOIN #servicio b ON (    
    a.nrosec23 = b.nrosec23    
    AND a.nroitm13 = b.nroitm13    
    )    
    
  --print @sCodCon + '.'        
  SELECT @sNroOrs = nroors32    
  FROM #Tempo    
  WHERE nrosec23 = @sNroSec    
   AND codcon35 = @sCodCon    
    
  UPDATE terminal..ddordser32    
  SET status32 = 'A'    
  WHERE nrosec23 = @sNroSec    
   AND codcon35 = @sCodCon    
   AND nroors32 <> @sNroOrs    
   AND year(fecser32) = @yy    
   AND month(fecser32) = @mm    
   AND day(fecser32) = @dd    
   AND nroitm13 = @sNroItm    
   AND codcon35 NOT IN (    
    'SERES'    
    ,'BALEX'    
    )    
 END    
END    
ELSE    
BEGIN    
*/    
 SELECT @sNroSec = nrosec23    
  ,@yy = year(fecser32)    
  ,@mm = month(fecser32)    
  ,@dd = day(fecser32)    
  ,@sCodCon = codcon35    
  ,@sNroItm = nroitm13    
 FROM terminal..ddordser32    
 WHERE nroors32 = convert(CHAR(6), @NroOS)    
    
 INSERT INTO #Tempo    
 (cantidad,nrosec23,codcon35,nroors32,nroitm13)    
 SELECT count(*)    
  ,@sNroSec    
  ,codcon35    
  ,''    
  ,nroitm13    
 FROM terminal..ddordser32    
 WHERE nrosec23 = @sNroSec    
  AND year(fecser32) = @yy    
  AND month(fecser32) = @mm    
  AND day(fecser32) = @dd    
  AND codcon35 = @sCodCon    
  AND status32 <> 'A'    
  AND codcon35 NOT IN (    
   'SERES'    
   ,'BALEX'
    ,'SUPCA' 
    ,'SENEC'        
   )    
  AND nrofac37 IS NULL    
 GROUP BY codcon35    
  ,nroitm13    
 HAVING count(*) > 1    
     
 IF EXISTS(SELECT *FROM #Tempo)    
 BEGIN    
  --|OBTENER EL ULTIMOS SERVICIO GENERADO    
  INSERT INTO #servicio    
  SELECT TOP 1 b.nroors32,b.nrosec23,b.nroitm13    
  FROM #Tempo a    
  INNER JOIN terminal..ddordser32 b ON (    
    a.nrosec23 = b.nrosec23    
    AND a.nroitm13 = b.nroitm13    
    )    
  WHERE b.status32 <> 'A'    
   AND b.codcon35 = @sCodCon    
   AND year(fecser32) = @yy    
   AND month(fecser32) = @mm    
   AND day(fecser32) = @dd    
   AND b.codcon35 NOT IN (    
    'SERES'    
    ,'BALEX'    
    ,'SUPCA' 
    ,'SENEC' 
    )    
  ORDER BY b.nroors32 DESC    
  --|    
     
  UPDATE #Tempo    
  SET nroors32 = b.servicio    
  FROM #Tempo a    
  INNER JOIN #servicio b ON (    
    a.nrosec23 = b.nrosec23    
    AND a.nroitm13 = b.nroitm13    
    )    
    
  --print @sCodCon + '.'        
  SELECT @sNroOrs = nroors32    
  FROM #Tempo    
  WHERE nrosec23 = @sNroSec    
   AND codcon35 = @sCodCon    
    
  UPDATE terminal..ddordser32    
  SET status32 = 'A' , obsmovanula32='ANULACION DUPLICIDAD WEB'   
  WHERE nrosec23 = @sNroSec    
   AND codcon35 = @sCodCon    
   AND nroors32 <> @sNroOrs    
   AND year(fecser32) = @yy    
   AND month(fecser32) = @mm    
   AND day(fecser32) = @dd    
   AND nroitm13 = @sNroItm    
   AND codcon35 NOT IN (    
    'SERES'    
    ,'BALEX'   
    ,'SUPCA' 
    ,'SENEC'  
    )    
 END    
--END    
    
DROP TABLE #Tempo    
DROP TABLE #servicio  
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Valida_Orden_de_Servicio_Repetidas_Ant]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Valida_Orden_de_Servicio_Repetidas_Ant]  
@NroOS bigint  
as  
declare @sNroSec as char(06)  
declare @sNroOrs as char(06)  
declare @sCodCon as char(05)  
declare @sNroItm as char(03)  
  
declare @yy int  
declare @mm int  
declare @dd int  
CREATE TABLE #Tempo       
(      
cantidad int,   
nrosec23 char(06),   
codcon35 char(05),  
nroors32 char(06),  
nroitm13 char(03)  
)  
  
select @sNroSec=nrosec23,@yy=year(fecors32),  
@mm=month(fecors32), @dd=day(fecors32), @sCodCon=codcon35,  
@sNroItm=nroitm13    
from terminal..ddordser32   
where nroors32=convert(char(6),@NroOS)  
  
insert into #Tempo  
select count(*), @sNroSec,codcon35,'',nroitm13  from terminal..ddordser32  
where nrosec23=@sNroSec and year(fecors32)=@yy and  
month(fecors32)=@mm and day(fecors32)=@dd and   
codcon35=@sCodCon and status32<>'A'  and codcon35 not in ('SERES','BALEX')
group by codcon35,nroitm13  
having count(*)>1  
  
update #Tempo set nroors32=b.nroors32 from  
#Tempo a   
inner join terminal..ddordser32 b on (a.nrosec23=b.nrosec23 and a.nroitm13=b.nroitm13)  
where b.status32<>'A' and b.codcon35=@sCodCon and year(fecors32)=@yy and  
month(fecors32)=@mm and day(fecors32)=@dd  and b.codcon35 not in ('SERES','BALEX')
  
--print @sCodCon + '.'  
select @sNroOrs=nroors32  from #Tempo where nrosec23=@sNroSec and codcon35=@sCodCon  
update terminal..ddordser32 set status32='A' where nrosec23=@sNroSec and codcon35=@sCodCon and nroors32<>@sNroOrs  
and year(fecors32)=@yy and month(fecors32)=@mm and day(fecors32)=@dd and nroitm13=@sNroItm  and codcon35 not in ('SERES','BALEX')
drop table #Tempo

update terminal..TRM_OS set  estado = 'C' from terminal..TRM_OS a
						inner join terminal..ddordser32 b on (a.numeroos=b.nroors32)
						where b.fecser32>=dateadd(day,-1,getdate())  and a.estado<>'C' and b.status32='A'

update OST_ORDEN_SERVICIO set  EST_Codigo = 2 from OST_ORDEN_SERVICIO  a
						inner join terminal..ddordser32 b on (cast(a.OSE_Codigo as char(6))=b.nroors32)
						where b.fecser32>=dateadd(day,-1,getdate())   and a.EST_Codigo<>2 and b.status32='A'
GO
/****** Object:  StoredProcedure [dbo].[sp_Valida_Servicio_OS_Generada_Mismo_Dia]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Valida_Servicio_OS_Generada_Mismo_Dia]
@iCodigo int
as
select a.ose_Fecha, a.ose_Codigo, b.Con_Codigo from OST_ORDEN_SERVICIO a
inner join OST_ORDEN_SERVICIO_HIJO b on (a.ose_Codigo=b.ose_Codigo)
where b.Con_Codigo= @iCodigo 
and year(a.ose_Fecha) = year(getdate()) 
and month(a.ose_Fecha)= month(getdate())
and day(a.ose_Fecha)=day(getdate()) 
and a.EST_Codigo not in ('2','4')
GO
/****** Object:  StoredProcedure [dbo].[usp_os_EliminaOsTransp]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_os_EliminaOsTransp] (@NROORDEN INT)
AS
BEGIN

DELETE FROM Logistica.dbo.Ta_OrdenTransporte 
WHERE  OSE_Codigo = @NROORDEN

END

GO
/****** Object:  StoredProcedure [dbo].[usp_os_InsertaOSTranspCalle]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_os_InsertaOSTranspCalle](@NROORDEN int)
AS
BEGIN

DECLARE @plantilla int, @tipomov char(1), @tipomerc char(1), 
	@idtipomov int, @condcontenedor int, @idOrden int, 
	@distrito varchar(50), @zona int

SELECT @plantilla = TSV_Codigo
FROM  OST_ORDEN_SERVICIO O (NOLOCK)
WHERE OSE_Codigo = @NROORDEN

--Calle Impo
IF @plantilla = 59
BEGIN
	SET @idtipomov = 1 --calleimportacion
	SET @tipomov = 'C' --calle
	SET @tipomerc = 'C' --contenedor
	SET @condcontenedor = 1 --LLENO	
END

--Calle Expo
IF @plantilla = 60
BEGIN
	SET @idtipomov = 2 --calleexportacion
	SET @tipomov = 'C' --calle
	SET @tipomerc = 'C' --contenedor
	SET @condcontenedor = 1 --LLENO	
END

--Calle Posicionamiento
IF @plantilla = 61
BEGIN
	SET @idtipomov = 3 --calleposicionamiento
	SET @tipomov = 'C' --calle
	SET @tipomerc = 'C' --contenedor
	SET @condcontenedor = 2 --VACIO	
END

--Calle Carga Suelta
IF @plantilla = 62
BEGIN
	SET @idtipomov = 4 --callecargasuelta
	SET @tipomov = 'C' --calle
	SET @tipomerc = 'S' --carga suelta
END

--Otros
IF @plantilla = 63
BEGIN
	SET @idtipomov = 12 --otros
	SET @tipomov = 'T' --otros
	SET @tipomerc = 'S' --carga suelta
END

--Operativo CTN Embarque/Descarga/Falso Embarque
IF @plantilla = 64
BEGIN
	--El tipo y condición se seleccionan
	SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181),
	       @condcontenedor = dbo.fn_BuscaDatos(O.OSE_Codigo,224)
	FROM  OST_ORDEN_SERVICIO O (NOLOCK)
	WHERE OSE_Codigo = @NROORDEN

	SET @tipomov = 'O' --operativo
	SET @tipomerc = 'C' --contenedor
END

--Operativo C/S Embarque/Descarga/Falso Embarque
IF @plantilla = 65
BEGIN
	--El tipo se selecciona
	SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181)
	FROM  OST_ORDEN_SERVICIO O (NOLOCK)
	WHERE OSE_Codigo = @NROORDEN

	SET @tipomov = 'O' --operativo
	SET @tipomerc = 'S' --carga suelta
END

--Operativo CTN Devolución/Posicionamiento/Traslado
IF @plantilla = 66
BEGIN
	--El tipo se selecciona
	SELECT @idtipomov = dbo.fn_BuscaDatos(O.OSE_Codigo,181)
	FROM  OST_ORDEN_SERVICIO O (NOLOCK)
	WHERE OSE_Codigo = @NROORDEN

	SET @tipomov = 'O' --operativo
	SET @tipomerc = 'C' --contenedor
	SET @condcontenedor = 2 --VACIO
END

--Operativo CTN Descarga Directa
IF @plantilla = 68
BEGIN
	SET @idtipomov = 11
	SET @tipomov = 'O' --operativo
	SET @tipomerc = 'C' --contenedor
	SET @condcontenedor = 1 --LLENO
END

--Operativo C/S Descarga Directa
IF @plantilla = 69
BEGIN
	SET @idtipomov = 11
	SET @tipomov = 'O' --operativo
	SET @tipomerc = 'S' --Carga Suelta
END

--Buscando la zona, para posicionamiento se usa una zona que no maneja distritos
IF @plantilla = 61
BEGIN
	SET @zona = 39
END
ELSE
BEGIN
	SELECT @distrito = isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,235),'')
	FROM  OST_ORDEN_SERVICIO O (NOLOCK)
	WHERE OSE_Codigo = @NROORDEN

	SELECT @zona = Zona
	FROM Logistica.dbo.SB_Zona (NOLOCK)
	WHERE TipoTransporte = 'T' AND Descripcion LIKE '%'+@distrito+'%'
END

--Insertando la Orden
INSERT INTO Logistica.dbo.Ta_OrdenTransporte          
(
FechaRegistro,
servicio,
TipoMovimiento,
idTipoTransporte,
TipoMercaderia,
RucCliente,
RucConsig,
CodNave,
Navvia11,
Booking,
idTipoContenedor,
idCondicion,
CantCont20,
CantCont40,
CantViajes,
peso,
PersonaInicio,
DireccionInicio,
PersonaIntermedio,
DireccionIntermedio,
PersonaFinal,
DireccionFinal,
distrito,
Zona,
Observacion,
Prioridad,
Estado,
UsuarioCreador,
FechaCreacion,
UsuarioModificador,
FechaModificacion,
OSE_Codigo
)       
SELECT DISTINCT  
convert(datetime,OSE_Fecha_Req + ' '+ OSE_Hora_Req,103) as FechaRegistro,             
H.CON_Codigo, 
@tipomov as TipoMovimiento, 
@idtipomov as TipoTransporte,
@tipomerc as TipoMercaderia,
dbo.fn_BuscaDatos(O.OSE_Codigo,151) as RucCliente, 
dbo.fn_BuscaDatos(O.OSE_Codigo,185) as RucConsig,
dbo.fn_BuscaDatos(O.OSE_Codigo,101) as codNave, 
dbo.fn_BuscaDatos(O.OSE_Codigo,103) as naveviaje,      
dbo.fn_BuscaDatos(O.OSE_Codigo,148) as Booking, 
dbo.fn_BuscaDatos(O.OSE_Codigo,223) as TipoContenedor, 
@condcontenedor as CondContenedor, 
dbo.fn_BuscaDatos(O.OSE_Codigo,184) as CantCont20,
dbo.fn_BuscaDatos(O.OSE_Codigo,183) as CantCont40,
CASE isnull(@condcontenedor,0)
WHEN 1 THEN cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,183),'0') as decimal(5,1)) + cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,184),'0') as decimal(5,1))
WHEN 2 THEN round(cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,183),'0') as decimal(5,1)) + (cast(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,184),'0') as decimal(5,1))/2),0) 
ELSE isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,238),'0')
END as Cantviajes,  
CASE RTRIM(isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,239),'0')) 
WHEN '' THEN '0'
ELSE isnull(dbo.fn_BuscaDatos(O.OSE_Codigo,239),'0')
END
as Peso, 
dbo.fn_BuscaDatos(O.OSE_Codigo,232) as PersonaInicio,
dbo.fn_BuscaDatos(O.OSE_Codigo,193) as DireccionInicio,
dbo.fn_BuscaDatos(O.OSE_Codigo,233) as PersonaIntermedio,
dbo.fn_BuscaDatos(O.OSE_Codigo,225) as DireccionIntermedio,
dbo.fn_BuscaDatos(O.OSE_Codigo,234) as PersonaFinal,
dbo.fn_BuscaDatos(O.OSE_Codigo,196) as DireccionFinal,
dbo.fn_BuscaDatos(O.OSE_Codigo,235) as Distrito, 
@zona as Zona,
dbo.fn_BuscaDatos(O.OSE_Codigo,222) as Observacion,
dbo.fn_BuscaDatos(O.OSE_Codigo,237) as Prioridad,
'R' as Estado,          
substring(us.USU_CodigoInterno,1,20) as UsuarioCreador, 
getdate() as FechaCreacion,   
substring(us.USU_CodigoInterno,1,20) as UsuarioModificador, 
getdate() as FechaModificacion,        
O.OSE_Codigo 
FROM  OST_ORDEN_SERVICIO O           
inner join OST_tipo_servicio as T on O.tsv_codigo = T.tsv_codigo         
inner join OST_ORDEN_SERVICIO_HIJO as H on O.OSE_Codigo = H.OSE_Codigo   
inner join ost_auditoria_orden as AO on ao.ose_codigo = o.ose_codigo          
left join seguridad.dbo.sgt_usuario as us on us.usu_codigo = ao.usu_Codigo          
WHERE O.OSE_Codigo = @NROORDEN           
and ao.est_codigo = 1          

SELECT @idOrden = idOrden
FROM Logistica.dbo.Ta_OrdenTransporte 
WHERE OSE_Codigo = @NROORDEN

--Insertando los viajes asignados
EXEC Logistica.dbo.usp_programacion_viajes @idOrden

--rdelacuba 01/03/2007: En caso de servicios de calle, insertar la orden de transporte al sistema de facturación
IF @tipomov = 'C'
BEGIN
 EXEC Logistica.dbo.usp_OS_SolicitudTransporteInterfaz @idOrden
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_os_ModificaEstadoTransp]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_os_ModificaEstadoTransp](@NROORDEN bigINT,@Estado char(1))
AS
BEGIN

UPDATE 	Logistica.dbo.Ta_OrdenTransporte
SET    	Estado = @Estado,
	UsuarioModificador = substring(suser_sname(),1,20),
	FechaModificacion = getdate()
WHERE OSE_Codigo = @NROORDEN    

END

GO
/****** Object:  StoredProcedure [dbo].[USP_REG_OS_WEBSITE]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REG_OS_WEBSITE]
AS
BEGIN
	IF EXISTS (
				SELECT *
				FROM TERMINAL..DDORDSER32 
				WHERE status32='A' AND fecser32>=CONVERT(VARCHAR,DATEADD(DAY,-1,GETDATE()),112)
			  )
	BEGIN
		update OST_ORDEN_SERVICIO set EST_Codigo='2'
		FROM OST_ORDEN_SERVICIO A
		INNER JOIN TERMINAL..DDORDSER32 B ON B.nroors32 = right('0'+ convert(varchar(6),A.OSE_Codigo),6)
		WHERE B.status32='A' AND B.fecser32>=CONVERT(VARCHAR,DATEADD(DAY,-1,GETDATE()),112)
		AND A.EST_Codigo='1'
	END
END
GO
/****** Object:  StoredProcedure [web].[OSS_ORDENSERVICIOHIJO_Insertar_dua]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[OSS_ORDENSERVICIOHIJO_Insertar_dua]   
@OSE_Codigo as integer,  
@EST_Codigo as integer,  
@CON_Codigo as integer,
@OSE_tiprec as varchar(60)   
  
  
/**********************************************  
Procedimiento : OSS_ORDENSERVICIOHIJO_Insertar  
Proposito : Insertar  OSS_ORDENSERVICIOHIJO  
Entrada  : Los parametros  
Salida  : Ninguna  
Fecha y Hora : Julio 2005 - pm  
Responsable : RyM  
******************************************/  
  
AS  
  
SET NOCOUNT ON  
  
DECLARE @V_OSH_Codigo  int  
  
SELECT @V_OSH_Codigo=MAX(OSH_Codigo) + 1   
FROM    OST_ORDEN_SERVICIO_HIJO     
WHERE OSE_Codigo = @OSE_Codigo  
  
  
IF @V_OSH_Codigo is NULL   
begin  
PRINT 'ENTRO AL IF'  
set @V_OSH_Codigo = 1  
end  
  
PRINT @V_OSH_Codigo   
  
INSERT INTO OST_ORDEN_SERVICIO_HIJO  
    (OSE_Codigo, OSH_Codigo,EST_Codigo, CON_Codigo, OSE_tiprec  )  
 VALUES (@OSE_Codigo,@V_OSH_Codigo,@EST_Codigo,@CON_Codigo, @OSE_tiprec)  
  
  
select @V_OSH_Codigo  
  
  
SET NOCOUNT OFF  

GO
/****** Object:  StoredProcedure [web].[OSS_SERVICIO_ListarPorConceptoAreabyUsuario]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[OSS_SERVICIO_ListarPorConceptoAreabyUsuario]  
@CON_Codigo as varchar(5) ,         
@ARE_CodigoInterno as varchar(10),      
@ARE_UsuarioInterno as varchar(10),      
@TpoUsuario  as varchar(1)      
      
as        
if @TpoUsuario = 'I'  
begin        
    select DISTINCT  VC.CodigoServicio as codigo,          
             VC.Servicio as numero,          
             VC.Nombre as nombre         
    from     TAV_Servicio VC ,        
             TAV_ServicioArea VSA,        
             SGV_Lista_Area A         
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno         
             and A.ARE_Codigointerno=VSA.Area        
             and VSA.Servicio =VC.Servicio        
             and VSA.FlagPublicado in ('Y', 'S')          
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'   
	     and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO ) 	     
union
    select DISTINCT  VC.CodigoServicio as codigo,          
             VC.Servicio as numero,          
             VC.Nombre as nombre         
    from     TAV_Servicio VC ,        
             TAV_ServicioArea VSA,        
             SGV_Lista_Area A         
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno         
             and A.ARE_Codigointerno=VSA.Area        
             and VSA.Servicio =VC.Servicio        
             and VSA.FlagPublicado in ('Y', 'S')          
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'   
	     and VC.Servicio  in (select codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno) 	     
             order by 1   
end        
else        
begin        
   select  DISTINCT VC.CodigoServicio as codigo,         
            VC.Servicio as numero,          
            VC.Nombre as nombre         
   from     TAV_Servicio VC ,        
            TAV_ServicioArea VSA,        
            SGV_Lista_Area A         
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno         
            and A.ARE_CodigoInterno=VSA.Area        
            and VSA.Servicio =VC.Servicio        
            and VSA.FlagPublicado = 'Y'      
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'  
            and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO) 	              
union
   select  DISTINCT VC.CodigoServicio as codigo,         
            VC.Servicio as numero,          
            VC.Nombre as nombre         
   from     TAV_Servicio VC ,        
            TAV_ServicioArea VSA,        
            SGV_Lista_Area A         
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno         
            and A.ARE_CodigoInterno=VSA.Area        
            and VSA.Servicio =VC.Servicio        
            and VSA.FlagPublicado = 'Y'      
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'  
            and VC.Servicio  in (select  codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno) 	              
            order by 1        
end        


GO
/****** Object:  StoredProcedure [web].[OSS_SERVICIO_ListarPorConceptoAreabyUsuarioDua]    Script Date: 07/03/2019 04:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [web].[OSS_SERVICIO_ListarPorConceptoAreabyUsuarioDua]      
@CON_Codigo as varchar(5) ,             
@ARE_CodigoInterno as varchar(10),          
@ARE_UsuarioInterno as varchar(10),          
@TpoUsuario  as varchar(1),  
@flagDua as varchar(1)          
          
as  
if @TpoUsuario = 'I'      
begin            
    select DISTINCT  VC.CodigoServicio as codigo,              
             VC.Servicio as numero,              
             VC.Nombre as nombre             
    from     TAV_Servicio VC ,            
             TAV_ServicioArea VSA,            
             SGV_Lista_Area A             
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno             
             and A.ARE_Codigointerno=VSA.Area            
             and VSA.Servicio =VC.Servicio            
             and VSA.FlagPublicado in ('Y', 'S')              
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'       
      and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO )  
   and (VC.flagdua = 'N' or VC.flagdua = @flagdua)           
      --**MDTECH**
   -- AGREGADO MDTECH 19092011
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))             
   -- FIN AGREGADO MDTECH 19092011
 
  
union    
    select DISTINCT  VC.CodigoServicio as codigo,              
             VC.Servicio as numero,              
             VC.Nombre as nombre             
    from     TAV_Servicio VC ,            
             TAV_ServicioArea VSA,            
             SGV_Lista_Area A             
    where    A.ARE_CodigoInterno = @ARE_CodigoInterno             
             and A.ARE_Codigointerno=VSA.Area            
             and VSA.Servicio =VC.Servicio            
             and VSA.FlagPublicado in ('Y', 'S')              
             and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'       
      and VC.Servicio  in (select codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)           
   and (VC.flagdua = 'N' or VC.flagdua = @flagdua)           
      --**MDTECH**
   -- AGREGADO MDTECH 19092011
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))             
   -- FIN AGREGADO MDTECH 19092011
  
             order by 1       
end            
else            
begin            
   select  DISTINCT VC.CodigoServicio as codigo,             
            VC.Servicio as numero,              
            VC.Nombre as nombre             
   from     TAV_Servicio VC ,            
            TAV_ServicioArea VSA,            
            SGV_Lista_Area A             
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno             
            and A.ARE_CodigoInterno=VSA.Area            
            and VSA.Servicio =VC.Servicio            
            and VSA.FlagPublicado = 'Y'          
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'      
            and VC.Servicio not in (select distinct codigo_Servicio from OST_SERVICIO_USUARIO)                    
   and (VC.flagdua = 'N' or VC.flagdua = @flagdua)           
   --**MDTECH**
   -- AGREGADO MDTECH 19092011
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))             
   -- FIN AGREGADO MDTECH 19092011
union    
   select  DISTINCT VC.CodigoServicio as codigo,             
            VC.Servicio as numero,              
            VC.Nombre as nombre             
   from     TAV_Servicio VC ,            
            TAV_ServicioArea VSA,            
            SGV_Lista_Area A             
   where    A.ARE_CodigoInterno=@ARE_CodigoInterno             
            and A.ARE_CodigoInterno=VSA.Area            
            and VSA.Servicio =VC.Servicio            
            and VSA.FlagPublicado = 'Y'          
            and upper(VC.CodigoServicio) like '%' + upper(@CON_Codigo) + '%'      
            and VC.Servicio  in (select  codigo_Servicio from OST_SERVICIO_USUARIO where cod_usuario  = @ARE_UsuarioInterno)                    
   and (VC.flagdua = 'N' or VC.flagdua = @flagdua)    
   --**MDTECH**
   -- AGREGADO MDTECH 19092011       
   and ( (@ARE_CodigoInterno <> '1')  OR (@flagdua = 'N' OR VC.CodigoServicio not in (SELECT CodigoServicio  FROM OST_Servicio_Dua_Filtro where Estado = 'A')))             
            order by 1            
   -- FIN AGREGADO MDTECH 19092011
end  
GO
