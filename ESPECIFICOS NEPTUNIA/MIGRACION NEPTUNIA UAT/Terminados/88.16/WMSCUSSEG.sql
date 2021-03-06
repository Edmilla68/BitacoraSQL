USE [WMSCUSSEG]
GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetEmpresa]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER FUNCTION [dbo].[BDFGetEmpresa] (@cod int)  
RETURNS varchar(100)
AS  
BEGIN 
declare @nombre varchar(100)
select @nombre=EMP_Nombre from SGT_Empresa where EMP_Codigo=@cod
return @nombre
END






GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetNombreEstado]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER FUNCTION [dbo].[BDFGetNombreEstado] (@cod varchar(1))  
RETURNS varchar(15)
AS  
BEGIN 
declare @nombre varchar(15)
if (@cod='A')
set @nombre='Activo'
else
set @nombre='Inactivo'
return @nombre



 
END





GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetNombrePerfil]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER FUNCTION [dbo].[BDFGetNombrePerfil] (@cod int)  
RETURNS varchar(100)
AS  
BEGIN 
declare @nombre varchar(100)
select @nombre=PER_Nombre from SGT_Perfil where PER_Codigo=@cod
return @nombre
END






GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetNombrePerfilCarga]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[BDFGetNombrePerfilCarga] (@cod int)  
RETURNS varchar(100)
AS  
BEGIN 
declare @nombre varchar(100)
select @nombre=PFC_Nombre from SGT_PERFILCARGA where PFC_Codigo=@cod
return @nombre
END

GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetNombrePerfilReporte]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER FUNCTION [dbo].[BDFGetNombrePerfilReporte] (@cod int)  
RETURNS varchar(100)
AS  
BEGIN 
declare @nombre varchar(100)
select @nombre=PFR_Nombre from SGT_PERFILREPORTE where PFR_Codigo=@cod
return @nombre
END

GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER FUNCTION [dbo].[BDFGetOpcion] (@cod int)  
RETURNS varchar(100)
AS  
BEGIN 
declare @nombre varchar(100)
select @nombre=OPC_Nombre from SGT_OPCION where OPC_Codigo=@cod
return @nombre
END







GO
/****** Object:  UserDefinedFunction [dbo].[BDFGetSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER FUNCTION [dbo].[BDFGetSistema](@cod int)  
RETURNS int
AS  
BEGIN 
declare @rcod int
select @rcod=SIS_Codigo from SGT_OPCION where OPC_Codigo=@cod
return @rcod
END







GO
/****** Object:  UserDefinedFunction [dbo].[fn_str_FROM_BASE64]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_str_FROM_BASE64]
(
    @BASE64_STRING VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN (
        SELECT 
            CAST(
                CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@BASE64_STRING"))', 'VARBINARY(MAX)') 
            AS VARCHAR(MAX)
            )   UTF8Encoding
    )
END


GO
/****** Object:  UserDefinedFunction [dbo].[fnIsColumnPrimaryKey]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[fnIsColumnPrimaryKey]
    (@sTableName varchar(128), @sColumnName varchar(128))
RETURNS bit
AS
BEGIN
    DECLARE    @nTableID int,
               @nIndexID int,
               @i int
    
    SET @nTableID = OBJECT_ID(@sTableName)

	SELECT @nIndexID = indid
	FROM      sysindexes
	WHERE  id = @nTableID
	 AND      indid BETWEEN 1 And 254 
	 AND      (status & 2048) = 2048
	ORDER BY indid
	
	IF (@nIndexID  Is Null)
	    RETURN 0

 IF @sColumnName IN
        (SELECT sc.[name]
          FROM       sysindexkeys sik
          INNER JOIN syscolumns sc ON sik.id = sc.id AND sik.colid =
                     sc.colid
          WHERE      sik.id = @nTableID
          AND        sik.indid = @nIndexID        )
     BEGIN
        RETURN 1
     END

    RETURN 0
END


 





GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[Split]
(
	@String varchar(50),
	@Delimiter char(1)
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @index int,
			@cadena varchar(50),
			@result varchar(50)

	-- Add the T-SQL statements to compute the return value here
	set @INDEX = CHARINDEX(@Delimiter,@STRING,0)
	select @result=RIGHT(@String,LEN(@String)-@INDEX)


	-- Return the result of the function
	RETURN @result
END

 






GO
/****** Object:  View [dbo].[BUQ_ObtenerUsuario]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[BUQ_ObtenerUsuario]
AS
	SELECT USU.USU_Codigo,USU.USU_Nombres+' ' +USU.USU_Paterno Nombre
	FROM SGT_USUARIO USU 
	INNER JOIN SGT_PERFIL_USUARIO PER ON PER.USU_CODIGO=USU.USU_CODIGO
	WHERE PER.PER_Codigo=140 AND USU.USU_Estado='A'
GO
/****** Object:  StoredProcedure [dbo].[ALMS_PRODUCTOS_Temp_Insertar_para_LDTrade]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Hanz  
-- Create date: 22/03/2008  
-- Description: Insertar un registro en la Tabla ALM_PRODUCTOS  
-- =============================================  
ALTER PROCEDURE [dbo].[ALMS_PRODUCTOS_Temp_Insertar_para_LDTrade]  
 @EMP_Secuencial int,    
 @PRD_Codigo varchar(20),    
 @FAM_Secuencial int,    
 @SFA_Secuencial int,    
 @TIP_Secuencial int,    
 @PRD_Parte varchar(15),    
 @PRD_Serie varchar(50),    
 @PRD_Descripcion varchar(150),    
 @PRD_DescripAlterna varchar(500),    
 @PRD_Marca varchar(50),    
 @NOR_Secuencial int,    
 @UBI_Secuencial int,    
 @SUB_Secuencial int,    
 @PRD_Capacidad varchar(50),    
 @PRD_Modelo varchar(100),    
 @PRD_Formato varchar(50),    
 @PRD_Plataforma varchar(50),    
 @PRD_Dimension varchar(50),    
 @PRD_Presentacion varchar(50),    
 @PRD_Contenido varchar(100),    
 @PRD_Adicional1 varchar(50),    
 @PRD_Adicional2 varchar(50),    
 @PRD_Adicional3 varchar(100),    
 @PRD_Adicional4 varchar(100),    
 @UND_Secuencial int,    
 @PRD_PrecioUnitario decimal(14, 2),    
 @PRD_CostoInicial decimal(14, 2),    
 @PRD_CostoFinal decimal(14, 2),    
 @MON_Secuencial int,    
 @PRD_StockInicial decimal(14, 2),    
 @PRD_StockFinal decimal(14, 2),    
 @PRD_StockFisico decimal(14, 2),    
 @PRD_Observaciones varchar(500),    
 @PRD_Especificaciones varchar(500),    
 @PRD_UsuarioCreacion int    
AS    
    
    
SET NOCOUNT ON    
IF NOT EXISTS(SELECT * FROM ALM_PRODUCTOS WHERE [PRD_Codigo]=@PRD_Codigo AND EMP_Secuencial = @EMP_Secuencial)  
BEGIN    
  
  declare @PRD_Secuencial int       
  EXEC dbo.SICS_CORRELATIVO_GenerarCorrelativoTabla 'ALM_PRODUCTOS', @PRD_Secuencial OUT    
    
 INSERT INTO [ALM_PRODUCTOS] (    
  PRD_Secuencial,    
  [EMP_Secuencial],    
  [PRD_Codigo],    
  [FAM_Secuencial],    
  [SFA_Secuencial],    
  [TIP_Secuencial],    
  [PRD_Parte],    
  [PRD_Serie],    
  [PRD_Descripcion],    
  [PRD_DescripAlterna],    
  [PRD_Marca],   
  [PRD_CostoFinal],    
  [MON_Secuencial],  
  [PRD_UsuarioCreacion],    
  [PRD_FechaCreacion]    
  --PRD_FlagEliminado    
 )    
 VALUES     
 (    
  @PRD_Secuencial,    
  @EMP_Secuencial,    
  @PRD_Codigo,    
  @FAM_Secuencial,    
  @SFA_Secuencial,    
  @TIP_Secuencial,    
  @PRD_Parte,    
  @PRD_Serie,    
  @PRD_Descripcion,    
  @PRD_DescripAlterna,  
  @PRD_Marca,  
  @PRD_CostoFinal,    
  @MON_Secuencial,  
  @PRD_UsuarioCreacion,    
  getdate()    
  --0  
  )    
 SELECT 'La operación se completo Satisfactoriamente'  
END    
ELSE    
BEGIN    
  SELECT 'El Codigo de producto Repedito'  
END
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: Actualizar accion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_Actualizar] (
	@ACC_Codigo int,
	@ACC_Nombre varchar(25),
	@ACC_Descripcion varchar(50),
	@ACC_Estado char(1),	
	@USU_UsuarioAct varchar(10)
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_ACCION]
SET
	[ACC_Nombre] = @ACC_Nombre,
	[ACC_Descripcion] = @ACC_Descripcion,
	[ACC_Estado] = @ACC_Estado,	
	[USU_FechaAct] = getdate(),	
	[USU_UsuarioAct] = @USU_UsuarioAct
WHERE
	 [ACC_Codigo] = @ACC_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_BusquedaXNombre]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: Buscar accion x nombre
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_BusquedaXNombre]
@ACC_Nombre varchar(100)=null
AS

SET NOCOUNT ON

SELECT
	[ACC_Codigo] 		as intcodigo,
	[ACC_Nombre] 		as strNombre,
	[ACC_Descripcion]	as strDescripcion,
	[ACC_Estado]		as chrEstado,
	[USU_FechaReg]		as dttFechaReg,
	[USU_FechaAct]		as dttFechaAct,
	[USU_UsuarioReg]	as strUsuarioReg,
	[USU_UsuarioAct]	as strUsuarioAct
FROM
	[SGT_ACCION]
where	
	(ACC_Nombre like '%' + coalesce (@ACC_Nombre,ACC_Nombre)+ '%')
order by ACC_Nombre
 


GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: Eliminar accion
*Fecha Crea: 20/09/2006
*Fecha Modi: 15/01/2007
*Parametros: 
*				
*Autor:	Lorena
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_Eliminar] (
	@ACC_Codigo int
)

AS
SET NOCOUNT ON

		DELETE FROM SGT_USUARIO_ACCION_OPCION 
		WHERE ACC_CODIGO=@ACC_Codigo
		
		DELETE FROM SGT_ACCION_OPCION 
		WHERE ACC_CODIGO=@ACC_Codigo

		DELETE FROM SGT_ACCION 
		WHERE ACC_CODIGO=@ACC_Codigo



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_EliminarPorUSU_UsuarioAct]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_EliminarPorUSU_UsuarioAct] (
	@USU_UsuarioAct varchar(10)
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_ACCION]
WHERE
	[USU_UsuarioAct] = @USU_UsuarioAct

 



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_EliminarPorUSU_UsuarioReg]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_EliminarPorUSU_UsuarioReg] (
	@USU_UsuarioReg varchar(10)
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_ACCION]
WHERE
	[USU_UsuarioReg] = @USU_UsuarioReg

 



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_ExisteDataRelacionada]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: Verifica si existe data relacionada a la accion.
*Fecha Crea: 20/09/2006
*Fecha Modi: 15/01/2007
*Parametros: 
*Descripcion :  1 tiene opciones
		0 no tiene opciones
*Autor:	Lorena
***************************************/
ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_ExisteDataRelacionada] (
	@ACC_Codigo int	
)
AS

SET NOCOUNT ON
IF( EXISTS ( select ACC_Codigo from SGT_USUARIO_ACCION_OPCION 
	     where ACC_Codigo=@ACC_Codigo) 
    OR 
    EXISTS ( select ACC_Codigo from SGT_ACCION_OPCION 
	     where ACC_Codigo=@ACC_Codigo) 
  )
   BEGIN
	SELECT 1	
   END
ELSE
   BEGIN
     	SELECT 0
   END












GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_Insertar] (
	
	@ACC_Nombre varchar(25),
	@ACC_Descripcion varchar(50),
	@ACC_Estado char(1),		
	@USU_UsuarioReg varchar(10)
	
)

AS

/***************************************
*Descripcion: Insertar accion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/


SET NOCOUNT ON

INSERT INTO [SGT_ACCION] (
	[ACC_Nombre],
	[ACC_Descripcion],
	[ACC_Estado],
	[USU_FechaReg],	
	[USU_UsuarioReg]
	
) VALUES (
	@ACC_Nombre,
	@ACC_Descripcion,
	@ACC_Estado,
	getdate(),
	@USU_UsuarioReg
	
)






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_Listar]

AS

/***************************************
*Descripcion: Listar accion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/


SET NOCOUNT ON

SELECT
	[ACC_Codigo] 		as intcodigo,
	[ACC_Nombre] 		as strNombre,
	[ACC_Descripcion]	as strDescripcion,
	[ACC_Estado]		as chrEstado,
	[USU_FechaReg]		as dttFechaReg,
	[USU_FechaAct]		as dttFechaAct,
	[USU_UsuarioReg]	as strUsuarioReg,
	[USU_UsuarioAct]	as strUsuarioAct
FROM
	[SGT_ACCION]





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_ListarPorUSU_UsuarioReg]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_ListarPorUSU_UsuarioReg] (
	@USU_UsuarioReg varchar(10)
)

AS

SET NOCOUNT ON

SELECT
	[ACC_Codigo],
	[ACC_Nombre],
	[ACC_Descripcion],
	[ACC_Estado],
	[USU_FechaReg],
	[USU_FechaAct],
	[USU_UsuarioReg],
	[USU_UsuarioAct]
FROM
	[SGT_ACCION]
WHERE
	[USU_UsuarioReg] = @USU_UsuarioReg



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_OPCION_EliminarXOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/***************************************
*Descripcion: Eliminar Accion_Opcion por opcion
*Fecha Crea: 10/01/2007
*Parametros:  
		@intCodigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/


ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_OPCION_EliminarXOpcion] 
	@intCodigo int
AS
	DELETE SGT_ACCION_OPCION 
	WHERE OPC_CODIGO=@intCodigo    






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/***************************************
*Descripcion: Insertar Accion_Opcion 
*Fecha Crea: 08/01/2007
*Parametros: 	@acc_codigo 	int
		@opc_codigo 	int
*				
*Autor:	Lorena
***************************************/


ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_OPCION_Insertar]
	@acc_codigo int,
	@opc_codigo int
AS

SET NOCOUNT ON

IF NOT EXISTS (SELECT * FROM [SGT_ACCION_OPCION] 
			WHERE ACC_CODIGO=@acc_codigo and
			      OPC_CODIGO= @opc_codigo
		)
BEGIN

	INSERT INTO [SGT_ACCION_OPCION ] 
			( 
				[ACC_CODIGO],
				[OPC_CODIGO],
				[SAO_FECHAASIGN]
				
			)
	VALUES		(
				@acc_codigo,
				@opc_codigo,
				getdate()
			)
END





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_OPCION_ListarXOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/***************************************
*Descripcion: Listar Accion_Opcion por Opcion 
*Fecha Crea: 08/01/2007
*Parametros: 	
		@intCodigo 	int
*				
*Autor:	Lorena
***************************************/



ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_OPCION_ListarXOpcion]
	@intCodigo int
as 
--SELECCIONA LAS ACCIONES ASIGNADAS A UNA OPCION
	select  
		AO.ACC_CODIGO	 	as intCodigo,
		A.ACC_NOMBRE		as strNombre
	from	
		SGT_ACCION_OPCION AO
		inner join SGT_ACCION A	
		on AO.ACC_CODIGO =A.ACC_CODIGO  and
		   A.ACC_ESTADO = 'A'
	where
		AO.OPC_CODIGO=@intCodigo
	
-- SELECCIONA LAS ACCIONES Q NO HAN SIDO ASIGANAS A UNA OPCION				
	select  
		A.ACC_CODIGO		as intCodigo,
		A.ACC_NOMBRE		as strNombre
	from
		SGT_ACCION A 		
	where
		A.ACC_ESTADO='A' and 
		A.ACC_CODIGO not in (
					select ACC_CODIGO
					from   SGT_ACCION_OPCION
					where  OPC_CODIGO=@intCodigo
				     )
			











GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_OPCION_USUARIO_Valida]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec BDS_SGT_ACCION_OPCION_USUARIO_Valida 'iprincipe' , 338 , 5

ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_OPCION_USUARIO_Valida]
@USU_Codigo Varchar(15), 
@OPC_Codigo int , 
@ACC_Codigo int 
As 
Begin 
	select 
			Count(usu_codigo) 
	from 
			sgt_usuario_accion_opcion
	Where 
			USU_Codigo = @USU_Codigo And 
			ACC_Codigo = @ACC_Codigo And 
			OPC_Codigo = @OPC_Codigo
End 
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ACCION_SeleccionarPorCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_ACCION_SeleccionarPorCodigo] (
	@ACC_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[ACC_Codigo] 		as intcodigo,
	[ACC_Nombre] 		as strNombre,
	[ACC_Descripcion]	as strDescripcion,
	[ACC_Estado]		as chrEstado,
	[USU_FechaReg]		as dttFechaReg,
	[USU_FechaAct]		as dttFechaAct,
	[USU_UsuarioReg]	as strUsuarioReg,
	[USU_UsuarioAct]	as strUsuarioAct
FROM
	[SGT_ACCION]
WHERE
	[ACC_Codigo] = @ACC_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_AREA_ListarPorCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_AREA_ListarPorCodigo]
@codigo int
 AS
Select ARE_Codigo,Are_Nombre,Are_descripcion from SGT_AREA where Are_Codigo=@codigo





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_AREA_ListarTodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_AREA_ListarTodos] AS
Select ARE_Codigo,Are_Nombre,Are_descripcion from SGT_AREA





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_DOCUMENTO_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_DOCUMENTO_Actualizar] (
	@DOC_Nombre varchar(20),
	@DOC_Codigo int
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_DOCUMENTO]
SET
	[DOC_Nombre] = @DOC_Nombre
WHERE
	 [DOC_Codigo] = @DOC_Codigo

 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_DOCUMENTO_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_DOCUMENTO_Eliminar] (
	@DOC_Codigo int
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_DOCUMENTO]
WHERE
	[DOC_Codigo] = @DOC_Codigo

 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_DOCUMENTO_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_DOCUMENTO_Insertar] (
	@DOC_Nombre varchar(20),
	@DOC_Codigo int
)

AS

SET NOCOUNT ON

INSERT INTO [SGT_DOCUMENTO] (
	[DOC_Nombre],
	[DOC_Codigo]
) VALUES (
	@DOC_Nombre,
	@DOC_Codigo
)

 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_DOCUMENTO_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_DOCUMENTO_Listar]

AS

SET NOCOUNT ON

SELECT
	[DOC_Nombre],
	[DOC_Codigo]
FROM
	[SGT_DOCUMENTO]






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_DOCUMENTO_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_DOCUMENTO_Seleccionar] (
	@DOC_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[DOC_Nombre],
	[DOC_Codigo]
FROM
	[SGT_DOCUMENTO]
WHERE
	[DOC_Codigo] = @DOC_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_EMPRESA_ListarTodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_EMPRESA_ListarTodos] 
AS

Select EMP_Codigo,EMP_Nombre
from 
SGT_EMPRESA
order by EMP_Nombre
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_ListarCategoria]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_ListarCategoria] 

AS
select 
	CAT_Codigo AS COD_CATEGORIA,
	CAT_Nombre AS DESCRIPCION
From 
	SGT_REPORT_CATEGORIA







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: Atualizar opcion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
*****************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Actualizar] (
	@OPC_Codigo int,	
	@OPC_Nombre varchar(25),
	@OPC_Descripcion varchar(50),
	@OPC_Estado char(1),
	@OPC_Enlace varchar(50),
	@OPC_Visibilidad char(1)
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_OPCION]
SET
	[OPC_Estado]   = @OPC_Estado,
	[OPC_Descripcion] = @OPC_Descripcion,
	[OPC_Nombre]   = @OPC_Nombre,			
	[OPC_Enlace]   =@OPC_Enlace ,
	[USU_FechaAct] = getdate(),
	[OPC_Visibilidad]=@OPC_Visibilidad
WHERE
	 [OPC_Codigo] = @OPC_Codigo



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Busqueda]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Busqueda] --null,'opciones'
@SIS_Codigo int=null,
@OPC_Nombre varchar(200)=null
as

--

select so.OPC_Codigo,
		so.OPC_Nombre,
		ss.SIS_Nombre,
		so.OPC_Estado,
		so.SIS_Codigo,
		isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
		isnull(so2.OPC_Nombre,'[Es un Menu]') +' '+
		case 
			when so2.OPC_OpcionPadre is null and  so2.OPC_FlagMenu='0' then  '[Menú]' 
			when so2.OPC_OpcionPadre is not null and  so2.OPC_FlagMenu='0' then  '[Sub-Menú]' 
			when so2.OPC_OpcionPadre  is not null and  so2.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
		else ''
		end
		as 'OPC_Nombre_Padre',
		isnull(so.OPC_Enlace,'No existe enlace')as 'OPC_Enlace',

		case 
		when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='0' then  '[Menú]' 
		when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu='0' then  '[Sub-Menú]' 
		when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
		else ''
		end as 'TipoMenu'
		

from	 
		sgt_opcion so
		inner join sgt_sistema ss
		on ss.SIS_Codigo=so.SIS_Codigo
		left join sgt_opcion so2
		on so2.OPC_Codigo=so.OPC_OpcionPadre
where 	  
		(so.OPC_Nombre like coalesce( @OPC_Nombre,so.OPC_Nombre)+ '%')
 		and (ss.SIS_Codigo = coalesce (@SIS_Codigo,ss.SIS_Codigo))
order by 	so.OPC_Nombre






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************
*Descripcion: Elimina opciones y sus posibles relaciones
*Fecha Crea: 01/10/2006
*Fecha Modif :	16/10/2009
*Parametros: 
*Autor:	Isaac Principe Capa
***************************************/

-- exec BDS_SGT_OPCION_Eliminar 303

ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Eliminar] (
	@OPC_Codigo int
)
as

-- borrando los perfiles asociados a los hijos de la opcion
		delete sgt_opcion_perfil where OPC_Codigo in (select OPC_codigo from sgt_opcion where OPC_OpcionPadre=@OPC_Codigo)
--borrando las acciones de la opcion por usuario
		delete sgt_usuario_accion_opcion where OPC_Codigo=@OPC_Codigo
--borrando las acciones de la opciones hijas
		delete sgt_accion_opcion where OPC_Codigo=@OPC_Codigo
-- borrando las opciones hijas
		delete sgt_opcion where OPC_OpcionPadre=@OPC_Codigo
-- borrando los perfiles asociados a la opcion
		delete sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo
-- borrando la opcion por usuario perfil
		delete SGT_USUARIO_PERFIL_OPCION where OPC_Codigo = @OPC_Codigo
-- borrando la opcion
		delete sgt_opcion where OPC_Codigo=@OPC_Codigo


GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/***************************************
*Descripcion: Insertar opcion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Insertar] (
	@OPC_Estado char(1),
	@OPC_Descripcion varchar(50),
	@OPC_Nombre varchar(25),
	@SIS_Codigo int,
	@OPC_OpcionPadre int,
	@OPC_Enlace varchar(100),
	@OPC_Visibilidad bit,
	@OPC_FlagMenu char(1),
	@OPC_Nivel int
)

AS

SET NOCOUNT ON
IF ( NOT EXISTS (SELECT * FROM SGT_OPCION WHERE OPC_NOMBRE=@OPC_NOMBRE AND SIS_CODIGO=@SIS_CODIGO))
BEGIN
	INSERT INTO [SGT_OPCION] (
		[OPC_Estado],
		[OPC_Descripcion],
		[OPC_Nombre],
		[SIS_Codigo],
		[OPC_OpcionPadre],
		[OPC_Enlace],
		[USU_FechaReg],		
		[OPC_Visibilidad],
		[OPC_FlagMenu],
		[OPC_Nivel]		
				 ) 
	VALUES (
		@OPC_Estado,
		@OPC_Descripcion,
		@OPC_Nombre,
		@SIS_Codigo,
		@OPC_OpcionPadre,
		@OPC_Enlace,
		getdate(),		
		@OPC_Visibilidad,
		@OPC_FlagMenu,
		@OPC_Nivel
	)
	SELECT SCOPE_IDENTITY()
END
ELSE
	SELECT -1






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Listar]

AS



/******************************************************************************
******************************************************************************/

select so.OPC_Codigo,so.OPC_Nombre,ss.SIS_Nombre,so.OPC_Estado,
so.SIS_Codigo,isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
isnull(so2.OPC_Nombre,'[Es un Menu]')as 'OPC_Nombre_Padre',
isnull(so.OPC_Enlace,'[Sin enlace]')as 'OPC_Enlace',
case 
when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='0' then  '[Menú]' 
when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu='0' then  '[Sub-Menú]' 
when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
end as 'TipoMenu'
from sgt_opcion so
inner join sgt_sistema ss
on ss.SIS_Codigo=so.SIS_Codigo
left join sgt_opcion so2
on so2.OPC_Codigo=so.OPC_OpcionPadre
--order by 2






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ListarOpcionesSimplesXSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
* Creado por 	: Lorena Quispe
* Fecha		: 02/03/2007
*/

ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ListarOpcionesSimplesXSistema] 
	@opc_codigo int,
	@sis_codigo int
AS

SET NOCOUNT ON

SELECT
	[OPC_Estado],
	[OPC_Descripcion],
	[OPC_Nombre],
	[OPC_Codigo],
	[SIS_Codigo]
	
FROM
	[SGT_OPCION]
WHERE
	[SIS_Codigo] = @sis_Codigo and
	OPC_OpcionPadre = @opc_codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ListarOpcionesXsistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ListarOpcionesXsistema]
@SIS_Codigo int

as

Select OPC_Codigo as codigo,dbo.BDFGetOpcion(OPC_Codigo) as opcion,dbo.BDFGetSistema(OPC_Codigo) as Sistema from SGT_Opcion where SIS_Codigo=@sis_codigo
 






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ListarXSistemayNombre]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ListarXSistemayNombre] (
	@SIS_Codigo int,
	@OPC_Nombre varchar(100)= null
)
as

select 	so.OPC_Codigo,so.OPC_Nombre,
	'nombre_opc' = case 
		when isnull(so.OPC_OpcionPadre,'')='' then so.opc_nombre + ' [Menu]'
		else isnull(so.opc_nombre + ' - De: ' + so2.opc_nombre,'')
		end,
	ss.SIS_Nombre,so.OPC_Estado,
	so.SIS_Codigo,isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
	isnull(so2.OPC_Nombre,'[Es un Menu]') +' '+ case 
	       when so2.OPC_OpcionPadre is null and  so2.OPC_FlagMenu='1' then  '[Menú]'	
	       else ''
	       end
	       as 'OPC_Nombre_Padre',
        isnull(so.OPC_Enlace,'No existe enlace')as 'OPC_Enlace'
from 	sgt_opcion so
	inner join sgt_sistema ss
	on ss.SIS_Codigo=so.SIS_Codigo
	left join sgt_opcion so2
	on so2.OPC_Codigo=so.OPC_OpcionPadre
where 	so.SIS_Codigo=@SIS_Codigo and
	so.OPC_Nombre like '%'+ coalesce( @OPC_Nombre,so.OPC_Nombre)+ '%'

order by so.OPC_Nombre














GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ObtenerPerfil]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ObtenerPerfil] 

@OPC_Codigo int 

as
	select 
		p.per_nombre 		as strNombre ,
		p.per_codigo		as intCodigo ,
		o.OPC_Codigo		as intOpcCodigo,
		o.SIS_Codigo		as intSisCodigo,
		p.per_estado		as chrEstado,
		isnull(OPC_OpcionPadre,'')as 'OPC_OpcionPadre'

	from    SGT_OPCION o
		inner join sgt_opcion_perfil op
		on op.OPC_Codigo=o.OPC_Codigo
		inner join sgt_perfil p
		on p.per_codigo=op.per_codigo
	where 
		o.opc_codigo=@OPC_Codigo







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ObtenerPorCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ObtenerPorCodigo] (
	@OPC_Codigo int
)
as

SELECT
	so.[OPC_Estado] 		as chrEstado,
	so.[OPC_Descripcion]      	as strDescripcion,
	so.[OPC_Nombre]			as strNombre,
	so.[OPC_Codigo]			as intCodigo,
	so.[SIS_Codigo]			as intSisCodigo,
	ss.SIS_Nombre			as strSisNombre,
	isnull(so.OPC_OpcionPadre,'')	as 'OPC_OpcionPadre' ,
	isnull(so2.OPC_Nombre,'[Es un Menu]')    as 'OPC_Nombre_Padre',
	isnull(so.OPC_Enlace,'No existe enlace') as strEnlace,		
	isnull(so2.OPC_Visibilidad, 1)    as boolVisibilidad
FROM
	[SGT_OPCION] so
	inner join SGT_SISTEMA ss
	on ss.SIS_Codigo=so.SIS_Codigo
	left join [SGT_OPCION] so2
	on so2.OPC_Codigo=so.OPC_OpcionPadre
WHERE
	so.[OPC_Codigo] = @OPC_Codigo
ORDER BY 1





 













GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ObtenerPorSIS_Codigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







--[BDS_SGT_OPCION_ObtenerPorSIS_Codigo] 13
--select * from sgt_opcion
ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ObtenerPorSIS_Codigo] (
	@SIS_Codigo int
)
as
select 	so.OPC_Codigo,so.OPC_Nombre,
	'nombre_opc' = case 
		when isnull(so.OPC_OpcionPadre,'')='' then so.opc_nombre + ' [Menu]'
		else isnull(so.opc_nombre + ' - De: ' + so2.opc_nombre,'')
		end,
	ss.SIS_Nombre,so.OPC_Estado,
	so.SIS_Codigo,isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
	isnull(so2.OPC_Nombre,'[Es un Menu]') +' '+ case 
          when so2.OPC_OpcionPadre is null and  so2.OPC_FlagMenu='1' then  '[Menú]' 

          else ''
          end
          as 'OPC_Nombre_Padre',
          isnull(so.OPC_Enlace,'No existe enlace')as 'OPC_Enlace'

from 	sgt_opcion so
	inner join sgt_sistema ss
	on ss.SIS_Codigo=so.SIS_Codigo
	left join sgt_opcion so2
	on so2.OPC_Codigo=so.OPC_OpcionPadre

where 	so.SIS_Codigo=@SIS_Codigo 
order by 1










GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_ObtenerPorSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_ObtenerPorSistema] 
(
	@sis_codigo int,
	@cod_usuario varchar(50)
)

AS

SET NOCOUNT ON

if (@sis_codigo<> 1 )
begin
	SELECT
		[OPC_Estado],
		[OPC_Descripcion],
		[OPC_Nombre],
		[OPC_Codigo],
		[SIS_Codigo]
		
	FROM
		[SGT_OPCION]
	WHERE
		([SIS_Codigo] = @sis_Codigo)
	and	[OPC_FlagMenu]=0

	ORDER BY [OPC_Nombre]
end
else
begin

	SELECT
		[OPC_Estado],
		[OPC_Descripcion],
		[OPC_Nombre],
		[OPC_Codigo],
		[SIS_Codigo]
		
	FROM
		[SGT_OPCION]
	WHERE
		([SIS_Codigo] = @sis_Codigo)
	and	[OPC_FlagMenu]=0
	and (@cod_usuario='Admin' or ([OPC_Codigo]<>4 and [OPC_Codigo]<>5 and [OPC_Codigo]<>6))
	ORDER BY [OPC_Nombre]

end

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_PERFIL_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_PERFIL_Eliminar]
	@PER_Codigo 	int,
	@OPC_Codigo	int
as
	declare @opc_padre int

	set @opc_padre=(select O.OPC_OpcionPadre from SGT_OPCION O
			where @OPC_Codigo=O.OPC_Codigo)
	select @opc_padre
	delete sgt_opcion_perfil
	where 	per_codigo = @PER_Codigo and 
	opc_codigo=@OPC_Codigo

     -- elimina el padre si ya no tiene hijos en la tabla SGT_OPCION_PERFIL
	if not exists (select OP.opc_codigo from SGT_OPCION OP				
				where OP.OPC_OpcionPadre=@opc_padre and 	 			
				OP.OPC_Codigo in (select OPE.opc_codigo from SGT_OPCION_PERFIL OPE 
							where per_codigo=@PER_Codigo)
			)
	begin 
		delete SGT_OPCION_PERFIL 
		where  per_codigo=@PER_Codigo and
			opc_codigo =@opc_padre
	end

	
	  

------------------------------------------------------------------------------------
 







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_PERFIL_EliminarXPerfilySistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_PERFIL_EliminarXPerfilySistema] 
	@PER_Codigo 	int,
	@SIS_Codigo	int
as
	
	delete sgt_opcion_perfil
	where  per_codigo = @PER_Codigo and
	       opc_codigo in (select opc_codigo 
			      from SGT_OPCION
			      where sis_codigo=@SIS_Codigo)


	
	
------------------------------------------------------------------------------------
 








GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_PERFIL_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_PERFIL_Insertar] (
	@PER_Codigo int,
	@OPC_Codigo int		
)

AS
declare @opc_padre int
 
SET NOCOUNT ON
if( not exists (select per_codigo, opc_codigo from sgt_opcion_perfil
		 where per_codigo=@PER_Codigo and opc_codigo=@OPC_Codigo )
   )
begin 
	INSERT INTO [SGT_OPCION_PERFIL] (
		[PER_Codigo],
		[OPC_Codigo],
		[OPE_FechaAsig],
		 OPE_Estado
		
		
	) VALUES (
		@PER_Codigo,
		@OPC_Codigo,
		getdate(),
		'A'
	)

	set @opc_padre=(select O.OPC_OpcionPadre from SGT_OPCION O
			where @OPC_Codigo=O.OPC_Codigo)
		
	if( @opc_padre is not null )
	begin		
		EXEC dbo.[BDS_SGT_OPCION_PERFIL_Insertar] @PER_Codigo,@opc_padre							    
		
	end

end




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_PERFIL_listarAsignadas]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_PERFIL_listarAsignadas] 
@per_codigo int
 AS
	Select  OP.OPC_Codigo 			as codigo,
		dbo.BDFGetOpcion(OP.OPC_Codigo) 	as opcion,
		dbo.BDFGetSistema(OP.OPC_Codigo) 	as Sistema 
	from 
		SGT_OPCION_PERFIL OP
	inner join
		SGT_OPCION O
	on	
		OP.OPC_Codigo=O.OPC_Codigo 
	where
		OP.PER_Codigo=@per_codigo and 
		O.OPC_FlagMenu =0
 





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_PERFIL_ListarOpcionesAsignadas]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_PERFIL_ListarOpcionesAsignadas]
@per_codigo int
 AS
Select OPC_Codigo as codigo,dbo.BDFGetOpcion(OPC_Codigo) as opcion,dbo.BDFGetSistema(OPC_Codigo) as Sistema from SGT_OPCION_PERFIL where PER_Codigo=@per_codigo





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_Seleccionar]
as
/***************************************
*Descripcion: Lista las Opciones existentes
*Fecha Crea: 23/08/2005
*Parametros: 	
*				
*Autor:	Reyes Avalos Gisella Rub{i 	
***************************************/

select so.OPC_Codigo,so.OPC_Nombre,ss.SIS_Nombre,so.OPC_Estado,
so.SIS_Codigo,isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
isnull(so2.OPC_Nombre,'[Es un Menu]')as 'OPC_Nombre_Padre',
isnull(so.OPC_Enlace,'[Sin enlace]')as 'OPC_Enlace',
case 
when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='0' then  '[Menú]' 
when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu='0' then  '[Sub-Menú]' 
when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
end as 'TipoMenu'
from sgt_opcion so
inner join sgt_sistema ss
on ss.SIS_Codigo=so.SIS_Codigo
left join sgt_opcion so2
on so2.OPC_Codigo=so.OPC_OpcionPadre
--order by 2




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_TieneOpciones]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************
*Descripcion: BDS_SGT_OPCION_TieneOpciones, verifica que no haya data que contenga a esta opcion
*Fecha Crea: 15/01/2007
*Parametros:  	@opc_codigo 	int		
*Salida	  :	@opciones  1 hay data relacionada
			   0 NO hay data relacionada		
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_TieneOpciones] (
	@OPC_Codigo int	,
	@opciones int output
)
as
  if ( not exists(select * from sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo) )
    begin
    if(not exists(select * from sgt_accion_opcion where OPC_Codigo=@OPC_Codigo ))
        begin
	        if(not exists(select * from sgt_opcion where OPC_OpcionPadre=@OPC_Codigo))
	      	 set  @opciones=0
		else set @opciones=1
	
        end
     
	else set @opciones=1
    end
else
	begin
	      set @opciones=1
	      end
		
select @opciones


 






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_VerAccionesdeOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_VerAccionesdeOpcion]

@OPC_codigo int 

as

select 
	a.ACC_Codigo 		as intCodigo,
	a.ACC_Nombre 		as strNombre,
	a.ACC_Descripcion 	as strDescripcion,
	a.ACC_Estado 		as chrEstado
FROM
	sgt_accion a 
	inner join sgt_accion_opcion ao
	on ao.ACC_Codigo=a.ACC_Codigo
WHERE
	 ao.OPC_Codigo=@OPC_codigo
	 and ao.SAO_FechaDesasign is null
order by a.ACC_Nombre







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCION_VerOpcionesdelMenu]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_OPCION_VerOpcionesdelMenu] 
@OPC_Codigo int 

as
select 
	so.OPC_Codigo			as intCodigo,
	so.OPC_Nombre			as strNombre,
	so.OPC_Estado			as chrEstado,
	isnull(so.OPC_Descripcion,'')   as strDescripcion,
	so.SIS_Codigo			as intSisCodigo,
	isnull(so.OPC_OpcionPadre,'') as 'OPC_OpcionPadre' ,
	isnull(so.OPC_Enlace,'No existe enlace')as strEnlace,
	case 
	when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='0' then  '[Menú]' 
	when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu='0' then  '[Sub-Menú]' 
	when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
	else ''
	end as 'TipoMenu'
	
FROM
	sgt_opcion so
WHERE 
	so.OPC_OpcionPadre = @OPC_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCIONES_ListarMenusXSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************
*Descripcion: Obtener Menu Padres
*Fecha Crea: 02/03/2007
*Parametros: 
*	 	
*Creado: Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_OPCIONES_ListarMenusXSistema] --'admin',8
	@SIS_Codigo int
as

	SELECT  OPC_Codigo, 
		OPC_Nombre, 
		OPC_Enlace, 			
		OPC_OpcionPadre
	FROM 
		SGT_OPCION 
		
	WHERE   OPC_OpcionPadre is null and
		SIS_Codigo=@SIS_Codigo   and 
		OPC_Estado='A' 
		







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_OPCIONPERFIL_ListarOpcionesdeUsuario]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[BDS_SGT_OPCIONPERFIL_ListarOpcionesdeUsuario] 
@cod_usu varchar(10)
as
Select * from SGT_OpcionesPerfil where USU_Codigo=@cod_usu
 



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_Actualizar] (
	@PER_Codigo int,
	@PER_Nombre varchar(25),	
	@PER_Estado char(1),
	@USU_UsuarioAct varchar(30)

	
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_PERFIL]
SET
	[PER_Estado] = @PER_Estado,
	[PER_Nombre] = @PER_Nombre,
	USU_UsuarioAct = @USU_UsuarioAct,
	USU_FechaAct =getdate()
WHERE
	 [PER_Codigo] = @PER_Codigo







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_BusquedaXNombre]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_BusquedaXNombre] 
@PER_Nombre varchar(50)=null,
@CodigoUser	varchar(20)

AS
	select 
		Per_codigo 			as intCodigo,
		Per_nombre 			as strNombre,
		Per_Estado 			as chrEstado,
		Per_CodigoInterno		as strCodigoInterno

	from 	SGT_Perfil 
	where	(Per_Nombre like '%' + coalesce(@PER_Nombre,Per_Nombre) + '%')
and (@CodigoUser='ADMIN' or Per_Codigo<>1)











GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_Eliminar] 
(
@PER_Codigo int
)

AS

SET NOCOUNT ON

If ( Not Exists (Select * From sgt_opcion_perfil Where PER_Codigo=@PER_Codigo))
Begin 
    If(Not Exists(Select * From sgt_perfil_usuario Where PER_Codigo=@PER_Codigo))
    Begin 
		Delete From [SGT_PERFIL] Where [PER_Codigo] = @PER_Codigo
	End 
    Else 
	Begin 
		Delete From sgt_perfil_usuario where PER_Codigo=@PER_Codigo	
		Delete From [SGT_PERFIL] Where [PER_Codigo] = @PER_Codigo
	End
End 
Else 
Begin 
	Delete From sgt_opcion_perfil Where PER_Codigo=@PER_Codigo
	Delete From sgt_perfil_usuario Where PER_Codigo=@PER_Codigo	
	Delete From [SGT_PERFIL] Where [PER_Codigo] = @PER_Codigo
End 
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_Insertar] (

	@PER_Nombre varchar(25),	
	@PER_Estado char(1),
	@USU_UsuarioReg varchar(30)
)

AS

SET NOCOUNT ON
if not exists( select * from SGT_PERFIL WHERE PER_NOMBRE= @PER_NOMBRE)
BEGIN

	INSERT INTO [SGT_PERFIL] (
		
		[PER_Estado],
		[PER_Nombre],
		USU_UsuarioReg,
		USU_FechaReg
	) VALUES (	
		@PER_Estado,
		@PER_Nombre,
		@USU_UsuarioReg,
		getdate()
	)
END
ELSE
	SELECT 1





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_ListarPerfilesPorUsuario]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_ListarPerfilesPorUsuario] @codigo VARCHAR(15)
AS
SELECT Per_codigo
	,dbo.BDFGetNombrePerfil(Per_codigo) AS Nombre
FROM SGT_Perfil_Usuario
WHERE USU_Codigo = @codigo
ORDER BY PER_Codigo DESC

  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_Perfil_ListarTodosPerfiles]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_Perfil_ListarTodosPerfiles] 
AS
select 
	Per_codigo,
	Per_nombre 
from
	SGT_Perfil 
where 
	Per_Estado='A' and 
	PER_Codigo<>1

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_Seleccionar] (
	@PER_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[PER_Codigo] as intCodigo,
	[PER_Estado] as chrEstado,
	[PER_Nombre] as strNombre
FROM
	[SGT_PERFIL]
WHERE
	[PER_Codigo] = @PER_Codigo

 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFIL_TieneOpciones]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[BDS_SGT_PERFIL_TieneOpciones] (
	@PER_Codigo int,
	@opciones int output
)

AS

SET NOCOUNT ON

if ( not exists(select * from sgt_opcion_perfil where PER_Codigo=@PER_Codigo) )
    begin
    if(not exists(select * from sgt_perfil_usuario where PER_Codigo=@PER_Codigo ))
        begin
        
        	set @opciones=0
	  
        
	end
	END
else
	begin 
	set @opciones=1
	
	end

 





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILCARGA_ListarPerfilesCargaPorUsuario]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_PERFILCARGA_ListarPerfilesCargaPorUsuario] 
		@codigo varchar(15)
		AS
		select 
			Pfc_codigo,
			dbo.BDFGetNombrePerfilCarga(Pfc_codigo) as Nombre 
		From 
			SGT_PERFILCARGA_USUARIO 
		Where 
			USU_Codigo=@codigo

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PerfilCarga_ListarTodosPerfilescarga]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PerfilCarga_ListarTodosPerfilescarga]
		AS
		Select
		 pfc_codigo,
		 pfc_nombre
		from
		sgt_perfilcarga
		where
		pfc_estado='A'

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILCARGAUSUARIO_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PERFILCARGAUSUARIO_Eliminar]   
		 @PFC_Codigo int,  
		 @USU_Codigo varchar(15)  
		  
		  
		AS  
		  
		Delete From SGT_PERFILCARGA_USUARIO where Pfc_codigo=@PFC_Codigo and Usu_Codigo=@USU_Codigo  

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILCARGAUSUARIO_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PERFILCARGAUSUARIO_Insertar] (
			@PFC_Codigo int,
			@USU_Codigo varchar(15)
		)

		AS

		SET NOCOUNT ON

		INSERT INTO [SGT_PERFILCARGA_USUARIO] (
			[PFC_Codigo],
			[USU_Codigo],
			[USU_FechaReg]
		) VALUES (
			@PFC_Codigo,
			@USU_Codigo,
			getdate()
		)


		select * from [SGT_PERFILCARGA_USUARIO]

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_Actualizar] (
	@PFR_Codigo int,
	@PFR_Nombre varchar(25),	
	@PFR_Estado char(1),
	@USU_UsuarioAct varchar(30)

	
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_PERFILREPORTE]
SET
	[PFR_Estado] = @PFR_Estado,
	[PFR_Nombre] = @PFR_Nombre,
	USU_UsuarioAct = @USU_UsuarioAct,
	USU_FechaAct =getdate()
WHERE
	 [PFR_Codigo] = @PFR_Codigo








GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_BusquedaXNombre]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_BusquedaXNombre] 
@PFR_Nombre varchar(50)=null,
@CodigoUser	varchar(20)

AS
	select 
		Pfr_codigo 			as intCodigo,
		Pfr_nombre 			as strNombre,
		Pfr_Estado 			as chrEstado,
		Pfr_CodigoInterno		as strCodigoInterno

	from 	SGT_PerfilReporte 
	where	(Pfr_Nombre like '%' + coalesce(@PFR_Nombre,Pfr_Nombre) + '%')
and (@CodigoUser='ADMIN' or Pfr_Codigo<>1)














GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_Eliminar] 
(
@PFR_Codigo int
)

AS

SET NOCOUNT ON

If ( Not Exists (Select * From sgt_opcion_perfilreporte Where PFR_Codigo=@PFR_Codigo))
Begin 
    If(Not Exists(Select * From sgt_perfilreporte_usuario Where PfR_Codigo=@PFR_Codigo))
    Begin 
		Delete From [SGT_PERFILREPORTE] Where [PFR_Codigo] = @PFR_Codigo
	End 
    Else 
	Begin 
		Delete From sgt_perfilREPORTE_usuario where PFR_Codigo=@PFR_Codigo	
		Delete From [SGT_PERFILREPORTE] Where [PFR_Codigo] = @PFR_Codigo
	End
End 
Else 
Begin 
	Delete From sgt_opcion_perfilreporte Where PFR_Codigo=@PFR_Codigo
	Delete From sgt_perfilreporte_usuario Where PFR_Codigo=@PFR_Codigo	
	Delete From [SGT_PERFILREPORTE] Where [PFR_Codigo] = @PFR_Codigo
End 

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_INSERTAR]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_INSERTAR] (

	@PFR_Nombre varchar(25),	
	@PFR_Estado char(1),
	@USU_UsuarioReg varchar(30)
)

AS

SET NOCOUNT ON
if not exists( select * from SGT_PERFILREPORTE WHERE PFR_NOMBRE= @PFR_NOMBRE)
BEGIN

	INSERT INTO [SGT_PERFILREPORTE] (
		
		[PFR_Estado],
		[PFR_Nombre],
		USU_UsuarioReg,
		USU_FechaReg
	) VALUES (	
		@PFR_Estado,
		@PFR_Nombre,
		@USU_UsuarioReg,
		getdate()
	)
END
ELSE
	SELECT 1



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_ListarPerfilesReportePorUsuario]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_ListarPerfilesReportePorUsuario] 
@codigo varchar(15)
AS
select 
	Pfr_codigo,
	dbo.BDFGetNombrePerfilReporte(Pfr_codigo) as Nombre 
From 
	SGT_PERFILREPORTE_USUARIO 
Where 
	USU_Codigo=@codigo





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PerfilREporte_ListarTodosPerfilesreporte]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[BDS_SGT_PerfilREporte_ListarTodosPerfilesreporte] 
AS
select 
	Pfr_codigo,
	Pfr_nombre 
from
	SGT_Perfilreporte 
where 
	Pfr_Estado='A' 
	
















GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_Seleccionar] (
	@PFR_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[PFR_Codigo] as intCodigo,
	[PFR_Estado] as chrEstado,
	[PFR_Nombre] as strNombre
FROM
	[SGT_PERFILREPORTE]
WHERE
	[PFR_Codigo] = @PFR_Codigo

 

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTE_TieneOpciones]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTE_TieneOpciones] (
	@PFR_Codigo int,
	@opciones int output
)

AS

SET NOCOUNT ON

if ( not exists(select * from sgt_opcion_perfilreporte where PFR_Codigo=@PFR_Codigo) )
    begin
    if(not exists(select * from sgt_perfilreporte_usuario where PFR_Codigo=@PFR_Codigo ))
        begin
        
        	set @opciones=0
	  
        
	end
	END
else
	begin 
	set @opciones=1
	
	end


 








GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTEUSUARIO_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTEUSUARIO_Eliminar]   
 @PFR_Codigo int,  
 @USU_Codigo varchar(15)  
  
  
AS  
  
Delete From SGT_PERFILREPORTE_USUARIO where Pfr_codigo=@PFR_Codigo and Usu_Codigo=@USU_Codigo  
   

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILREPORTEUSUARIO_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[BDS_SGT_PERFILREPORTEUSUARIO_Insertar] (
	@PFR_Codigo int,
	@USU_Codigo varchar(15)
)

AS

SET NOCOUNT ON

INSERT INTO [SGT_PERFILREPORTE_USUARIO] (
	[PFR_Codigo],
	[USU_Codigo],
	[USU_FechaReg]
) VALUES (
	@PFR_Codigo,
	@USU_Codigo,
	getdate()
)


select * from [SGT_PERFILREPORTE_USUARIO]








GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILUSUARIO_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_PERFILUSUARIO_Eliminar]   
 @PER_Codigo int,  
 @USU_Codigo varchar(15)  
  
  
AS  
  
Delete From SGT_PERFIL_USUARIO where Per_codigo=@PER_Codigo and Usu_Codigo=@USU_Codigo  
   
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_PERFILUSUARIO_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[BDS_SGT_PERFILUSUARIO_Insertar] (
	@PER_Codigo int,
	@USU_Codigo varchar(15)
)

AS

SET NOCOUNT ON

INSERT INTO [SGT_PERFIL_USUARIO] (
	[PER_Codigo],
	[USU_Codigo]
) VALUES (
	@PER_Codigo,
	@USU_Codigo
)







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/***************************************
*Descripcion: Atualizar opcion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
*****************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_Actualizar] (
	@REP_Codigo int,	
	@REP_Name varchar(100),
    @REP_Url varchar(500),
    @REP_Parameter char(1),
    @REP_Descripcion varchar(100),
    @REP_Estado char(1),
    @CAT_Codigo int,
    @SIS_Codigo int,    
    @USU_UsuarioAct varchar(15),      
    @USU_FechaAct  smalldatetime,
	@REP_Exportable char(1),
	@REP_Prompt char(1)  
)

AS

SET NOCOUNT ON


   UPDATE [WMSCUSSEG].[dbo].[SGT_REPORT]
      SET [REP_Name] = @REP_Name,
		  [REP_Url] = @REP_Url, 
		  [REP_Parameter] = @REP_Parameter,
		  [REP_Descripcion] = @REP_Descripcion,
		  [REP_Estado] = @REP_Estado,
		  [CAT_Codigo] = @CAT_Codigo, 
		  [SIS_Codigo] = @SIS_Codigo,       
		  [USU_UsuarioAct] = @USU_UsuarioAct,
		  [USU_FechaAct] = @USU_FechaAct,
		  [REP_Exportable] = @REP_Exportable,
		  [REP_Prompt] = @REP_Prompt 
    WHERE [REP_Codigo] = @REP_Codigo


GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_ASOCIADO_PERFIL]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/***************************************
*Descripcion: BDS_SGT_OPCION_TieneOpciones, verifica que no haya data que contenga a esta opcion
*Fecha Crea: 15/01/2007
*Parametros:  	@opc_codigo 	int		
*Salida	  :	@opciones  1 hay data relacionada
			   0 NO hay data relacionada		
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_ASOCIADO_PERFIL] (
	@REP_Codigo int	,
	@opciones int output
)
as
  if ( not exists(select * from SGT_PERFILREPORTE_REPORT where REP_Codigo=@REP_Codigo) )
    begin
		if(not exists(select * from SGT_REPORT where REP_Codigo=@REP_Codigo ))       
			begin 
				 set  @opciones=0	  
			end	   
		else 
            begin 
				  set @opciones=1
			end
    end
  else
	begin
		  set @opciones=1
	end
		
select @opciones


 













GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/***************************************
*Descripcion: Elimina opciones y sus posibles relaciones
*Fecha Crea: 01/10/2006
*Fecha Modif :	16/10/2009
*Parametros: 
*Autor:	Isaac Principe Capa
***************************************/

-- exec BDS_SGT_OPCION_Eliminar 303

ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_Eliminar] (
	@REP_Codigo int
)
as

-- borrando los perfiles asociados a los hijos de la opcion
 
if not exists (select pf.REP_codigo from SGT_PERFILREPORTE_REPORT pf				
				where pf.REP_codigo = @REP_Codigo)
	begin
		delete from sgt_Report 
			  where REP_Codigo = @REP_Codigo
	end 
else
	begin 

		delete from sgt_Report 
			  where REP_Codigo = @REP_Codigo;

		delete from SGT_PERFILREPORTE_REPORT
		where  REP_codigo = @REP_Codigo;
	end



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_ObtenerPorCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_ObtenerPorCodigo] (
	@REP_Codigo int
)
as
		SELECT rp.[REP_Codigo]
			  ,rp.[REP_Name]
			  ,rp.[REP_Url]
			  ,rp.[REP_Parameter]
			  ,rp.[REP_Descripcion]
			  ,rp.[REP_Estado]
			  ,rp.[REP_Exportable]
			  ,rp.[CAT_Codigo]
			  ,rp.[SIS_Codigo]
			  ,rp.[USU_UsuarioReg]
			  ,rp.[USU_UsuarioAct]
			  ,rp.[USU_FechaReg]
			  ,rp.[USU_FechaAct]
			  ,rp.[REP_Prompt]
		  FROM [WMSCUSSEG].[dbo].[SGT_REPORT] rp
	inner join SGT_SISTEMA ss
	on ss.SIS_Codigo=rp.SIS_Codigo
WHERE
	rp.[REP_Codigo] = @REP_Codigo
ORDER BY 1


 


















GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_ObtenerPorSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_ObtenerPorSistema] 
(
	@sis_codigo int,
	@cod_usuario varchar(50)
)

AS

SET NOCOUNT ON


begin
	SELECT		
		[REP_Codigo],
		[REP_Name],
		[REP_Descripcion],
		[SIS_Codigo],
		[REP_Estado]		
	FROM
		[SGT_REPORT]
	WHERE
		([SIS_Codigo] = @sis_Codigo)

	ORDER BY [REP_Name]
end



GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_EliminarXPerfilReporteySistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_EliminarXPerfilReporteySistema] 
	@PFR_Codigo 	int,
	@SIS_Codigo	int
as
	
	delete SGT_PERFILREPORTE_REPORT
	where  pfr_codigo = @PFR_Codigo and
	       REP_codigo in (select REP_codigo 
			      from SGT_REPORT
			      where SIS_codigo=@SIS_Codigo)


	
	
------------------------------------------------------------------------------------
 










GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_Insertar] (
	@PFR_Codigo int,
	@REP_Codigo int		
)

AS
--declare @opc_padre int
 
SET NOCOUNT ON
if( not exists (select [PFR_Codigo], [REP_Codigo] from SGT_PERFILREPORTE_REPORT
		 where [PFR_Codigo]=@PFR_Codigo and [REP_Codigo]=@REP_Codigo )
   )
begin 
	INSERT INTO [SGT_PERFILREPORTE_REPORT] (
		[PFR_Codigo],
		[REP_Codigo],
		[UPR_FechaRegistro],
		[RPR_Estado]
	) VALUES (
		@PFR_Codigo,
		@REP_Codigo,
		getdate(),
		'A'
	)

--	set @opc_padre=(select O.OPC_OpcionPadre from SGT_OPCION O
--			where @OPC_Codigo=O.OPC_Codigo)
--		
--	if( @opc_padre is not null )
--	begin		
--		EXEC dbo.[BDS_SGT_OPCION_PERFIL_Insertar] @PER_Codigo,@opc_padre							    
--		
--	end

end






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_listarAsignadas]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[BDS_SGT_REPORTE_PERFILREPORTE_listarAsignadas] 
@pfr_codigo int
 AS
	Select  P.REP_Codigo 			as codigo,
		    R.REP_Name  			as nombre,
			R.REP_Descripcion		as descripcion,
			R.SIS_Codigo		 	as Sistema 			
	from 
		SGT_PERFILREPORTE_REPORT P
	inner join
		SGT_REPORT R
	on	
		P.REP_Codigo=R.REP_Codigo 
	where
		P.PFR_Codigo = @pfr_codigo 
 


GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_Actualizar] (
	@SIS_Codigo int,
	@SIS_Nombre varchar(50),
	@SIS_Descripcion varchar(200),
	@SIS_Estado varchar(100),
	@USU_UsuarioAct varchar(10)
	
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_SISTEMA]
SET
	[SIS_Nombre] = @SIS_Nombre,
	[SIS_Descripcion] = @SIS_Descripcion,
	[SIS_Estado] = @SIS_Estado,	
	[USU_FechaAct] = getdate(),
	[USU_UsuarioAct] = @USU_UsuarioAct
	
WHERE
	 [SIS_Codigo] = @SIS_Codigo









GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_BusquedaXNombre]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_BusquedaXNombre]
@SIS_Nombre varchar(100)=null
AS

SET NOCOUNT ON

SELECT
	[SIS_Codigo],
	[SIS_Nombre],
	[SIS_Descripcion],
	[SIS_Estado],
	[USU_FechaReg],
	[USU_FechaAct],
	[USU_UsuarioAct],
	[USU_UsuarioReg]
FROM
	[SGT_SISTEMA]
where
	(SIS_Nombre LIKE coalesce   ('%' + @SIS_Nombre,SIS_Nombre)+ '%')
order by SIS_Nombre









GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/***************************************
*Descripcion: Eliminar sistema y sus posibles relaciones
*Fecha Crea: 01/10/2006
*Fecha Modif: 15/01/2007
	Descr : agregar las eliminaciones de las acciones,
		acciones usuario, opciones usuario pertenecientes 
		a un sistema.
*Parametros: sis_codigo int 
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_Eliminar] (
	@SIS_Codigo int
)
AS

SET NOCOUNT ON
if(not exists(select * from sgt_opcion where SIS_Codigo=@SIS_Codigo))
   begin
    
	DELETE FROM
		[SGT_SISTEMA]
	WHERE
		[SIS_Codigo] = @SIS_Codigo
   end
else
     begin
	DELETE FROM SGT_USUARIO_ACCION_OPCION
	WHERE	OPC_CODIGO in ( SELECT OPC_CODIGO
				FROM SGT_OPCION
				WHERE	SIS_CODIGO=@SIS_Codigo
			       )
	
	DELETE FROM SGT_ACCION_OPCION
	WHERE	OPC_CODIGO in ( SELECT OPC_CODIGO
				FROM SGT_OPCION
				WHERE	SIS_CODIGO=@SIS_Codigo
			       )
	
	delete from SGT_OPCION_PERFIL 
	where 	opc_codigo in (SELECT OPC_CODIGO  
			       FROM SGT_OPCION 
			       WHERE sis_codigo=@SIS_Codigo
			       )

	DELETE FROM SGT_USUARIO_PERFIL_OPCION	
	WHERE 	 OPC_CODIGO in (SELECT 	OPC_CODIGO
				FROM	SGT_OPCION
				WHERE	SIS_CODIGO=@SIS_Codigo
				)
	DELETE FROM SGT_OPCION 
	WHERE	sis_codigo=@SIS_Codigo
	

	DELETE FROM [SGT_SISTEMA]
	WHERE	[SIS_Codigo] = @SIS_Codigo
     end
print 'error'






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_Insertar] (
	
	@strNombre varchar(50),
	@strDescripcion varchar(200),
	@chrEstado varchar(100),	
	@USU_UsuarioReg varchar(10)
)

AS

SET NOCOUNT ON
if  exists(select upper(sis_nombre) 
from sgt_sistema where  upper(sis_nombre)=upper(@strNombre))
begin
print 'Ya existe el mismo nombre'
end
else
begin
INSERT INTO [SGT_SISTEMA] (	
	[SIS_Nombre],
	[SIS_Descripcion],
	[SIS_Estado],	
	[USU_UsuarioReg],
	[USU_FechaReg]
) VALUES (
	
	@strnombre,
	@strDescripcion,
	@chrEstado,	
	@USU_UsuarioReg,
	getdate()
)

end







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_ObtenerPorSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_ObtenerPorSistema]
@intcodigo int

as
	select  SIS_Codigo as intCodigo,
	        SIS_Nombre as strNombre,
		SIS_Descripcion as strDescripcion,
		SIS_Estado as strEstado
	from SGT_SISTEMA
	where SIS_Codigo=@intcodigo



 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_Seleccionar]

AS

SET NOCOUNT ON

SELECT
	[SIS_Codigo],
	[SIS_Nombre],
	[SIS_Descripcion],
	[SIS_Estado],
	[USU_FechaReg],
	[USU_FechaAct],
	[USU_UsuarioAct],
	[USU_UsuarioReg]
FROM
	[SGT_SISTEMA]


 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_SISTEMA_Tiene_Opciones]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





--select * from sgt_sistema
--[BDS_SGT_SISTEMA_Tiene_Opciones] 14,0
ALTER PROCEDURE [dbo].[BDS_SGT_SISTEMA_Tiene_Opciones] (
	@SIS_Codigo int,
	@opciones int  output
)
AS
-- 1 tiene opciones
-- 0 no tiene opciones
SET NOCOUNT ON
if(exists(select opc_codigo from sgt_opcion where SIS_Codigo=@SIS_Codigo))
   begin
     set @opciones=1
	
   end
else
     begin
     	set @opciones=0
     end
select @opciones









GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_TECNICO_ListarTodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[BDS_SGT_TECNICO_ListarTodos]
as
SELECT 0 as ven_secuencial,'-' as Vendedor 
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_EliminarXUsuarioOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************
*Descripcion: Eliminar Usuario_Accion_Opcion por usuario y opcion
*Fecha Crea: 12/01/2007
*Parametros:  	@usu_codigo 	varchar(15)		
		@opc_codigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_EliminarXUsuarioOpcion] 
	@usu_codigo varchar(15),
	@opc_codigo int
AS
	DELETE SGT_USUARIO_ACCION_OPCION 
	WHERE 	USU_CODIGO=@usu_codigo and
		OPC_CODIGO=@opc_codigo    







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/***************************************
*Descripcion: Insertar Usuario_Accion_Opcion 
*Fecha Crea: 12/01/2007
*Parametros:  	@usu_codigo 	varchar(15)
		@acc_codigo 	int
		@opc_codigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/


ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_Insertar]
	@usu_codigo varchar(15),
	@acc_codigo int,
	@opc_codigo int
AS

SET NOCOUNT ON

IF NOT EXISTS (SELECT * FROM [SGT_USUARIO_ACCION_OPCION] 
			WHERE ACC_CODIGO= @acc_codigo and
			      OPC_CODIGO= @opc_codigo and
			      USU_CODIGO= @usu_codigo
		)
BEGIN

	INSERT INTO [SGT_USUARIO_ACCION_OPCION ] 
			( 
				[USU_CODIGO],
				[ACC_CODIGO],
				[OPC_CODIGO],
				[UAO_FechaRegistro]
				
			)
	VALUES	        (
				@usu_codigo,
				@acc_codigo,
				@opc_codigo,
				getdate()
			)
END






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_ListarXUsuarioOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************
*Descripcion: Listar Usuario_Accion_Opcion por usuario y opcion
*Fecha Crea: 12/01/2007
*Parametros:  
		@usu_codigo 	varchar 15
		@opc_codigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/


ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_ACCION_OPCION_ListarXUsuarioOpcion]
		@usu_codigo varchar(15),
		@opc_codigo int
as 
--SELECCIONA LAS ACCIONES ASIGNADAS A UNA OPCION
	select  
		UAO.ACC_CODIGO	 	as intCodigo,
		A.ACC_NOMBRE		as strNombre
	from	
		SGT_USUARIO_ACCION_OPCION UAO
		inner join SGT_ACCION A	
		on UAO.ACC_CODIGO =A.ACC_CODIGO  and
		   A.ACC_ESTADO = 'A'
	where
		UAO.USU_CODIGO = @usu_codigo and
		UAO.OPC_CODIGO = @opc_codigo
	
-- SELECCIONA LAS ACCIONES Q NO HAN SIDO ASIGANAS A UNA OPCION				
	select  
		A.ACC_CODIGO		as intCodigo,
		A.ACC_NOMBRE		as strNombre
	from
		SGT_ACCION A 		
	where
		A.ACC_ESTADO='A' and 
		A.ACC_CODIGO not in (
					select ACC_CODIGO
					from   SGT_USUARIO_ACCION_OPCION
					where  USU_Codigo = @usu_codigo and
					       OPC_CODIGO = @opc_codigo
				     )
			




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************
	CREADO POR		:	ALBERTO MACLEOD
	MODIFICADO POR		:	LORENA QUISPE ARRATEA
	FECHA MOD		:	28 DE NOVIEMBRE DE 2006
	MOTIVO			:	AGREGAR EL CODIGO INTERNO, DOMINIO Y SI SE REPLICA O NO		
*******************************************************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_Actualizar] (
	@USU_Codigo varchar(15),
	@USU_Nombres varchar(100),
	@USU_Paterno varchar(25),
	@USU_Materno varchar(25)= null,
	@USU_Contraseña varchar(2000),
	@USU_Correo varchar(50),
	@USU_NumDocumento varchar(11),
	@USU_Estado char(1),
	@USU_FechaReg datetime,
	@USU_FechaAct datetime,
	@USU_UsuarioReg varchar(15),
	@USU_UsuarioAct varchar(15),
	@USU_FechaRetiro datetime,
	@DOC_Codigo int,
	@USU_Dominio varchar(15),
	@USU_Perfil char(1),
	@USU_CodigoVendedor int,
	@USU_CodigoTecnico int , 
	@USU_InternoExterno char(1),
	@USU_ClaseUsuario char(1),
	@USU_RUC varchar(11),
	@USU_Autenticacion char(1)
)
AS

SET NOCOUNT ON

UPDATE
	[SGT_USUARIO]
SET
	[USU_Nombres] = @USU_Nombres,
	[USU_Paterno] = @USU_Paterno,
	[USU_Materno] = @USU_Materno,
	[USU_Contraseña] = @USU_Contraseña,
	[USU_Correo] = @USU_Correo,
	[USU_NumDocumento] = @USU_NumDocumento,
	[USU_Estado] = @USU_Estado,
	[USU_FechaReg] = @USU_FechaReg,
	[USU_FechaAct] = @USU_FechaAct,
	[USU_UsuarioReg] = @USU_UsuarioReg,
	[USU_UsuarioAct] = @USU_UsuarioAct,
	[USU_FechaRetiro] = @USU_FechaRetiro,
	[DOC_Codigo] = @DOC_Codigo,
	[USU_Dominio] = @USU_Dominio,
	[USU_CodigoInterno] = @USU_Dominio+'\'+@USU_Codigo,
	[USU_Perfil] = @USU_Perfil,
	[USU_CodigoVendedor] = @USU_CodigoVendedor,
	[USU_CodigoTecnico] = @USU_CodigoTecnico , 
	USU_InternoExterno = @USU_InternoExterno,
	[USU_ClaseUsuario] = @USU_ClaseUsuario,
	[USU_RUC] = @USU_RUC,
	[USU_Autenticacion] = @USU_Autenticacion
WHERE
	[USU_Codigo] = @USU_Codigo

declare @apellidos varchar(50)
set @apellidos= @USU_Paterno+' '+@USU_Materno

--IF 'S'= (select USU_Replica from sgt_usuario where USU_Codigo=@USU_Codigo)
--   exec MANTSOFT.dbo.[MANS_UsuarioModificar]@apellidos,@USU_Nombres,@USU_Contraseña,@USU_Codigo,@USU_Correo,@USU_Perfil,@USU_Estado






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_Actualizar] (
	@USU_Codigo varchar(10),
	@ARE_Codigo int,
	@USA_FechaAsign smalldatetime,
	@USA_Estado char(1),
	@USA_FechaDesasign smalldatetime
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_USUARIO_AREA]
SET
	[USA_FechaAsign] = @USA_FechaAsign,
	[USA_Estado] = @USA_Estado,
	[USA_FechaDesasign] = @USA_FechaDesasign
WHERE
	 [USU_Codigo] = @USU_Codigo	AND [ARE_Codigo] = @ARE_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_Eliminar] (
	@USU_Codigo varchar(10),
	@ARE_Codigo int
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_AREA]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [ARE_Codigo] = @ARE_Codigo

 




GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_EliminarTodosPorARE_Codigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_EliminarTodosPorARE_Codigo] (
	@ARE_Codigo int
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_AREA]
WHERE
	[ARE_Codigo] = @ARE_Codigo







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_Insertar] (
	@USU_Codigo varchar(15),
	@ARE_Codigo int,
	@USA_FechaAsign smalldatetime,
	@USA_Estado char(1),
	@USA_FechaDesasign smalldatetime
)

AS

SET NOCOUNT ON

if not exists(	select * from sgt_usuario_Area where [USU_Codigo]=@USU_Codigo
	and [ARE_Codigo]=@ARE_Codigo)
begin

INSERT INTO [SGT_USUARIO_AREA] (
	[USU_Codigo],
	[ARE_Codigo],
	[USA_FechaAsign],
	[USA_Estado],
	[USA_FechaDesasign]
) VALUES (
	@USU_Codigo,
	@ARE_Codigo,
	@USA_FechaAsign,
	@USA_Estado,
	@USA_FechaDesasign
)







end
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_Listar]

AS

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[ARE_Codigo],
	[USA_FechaAsign],
	[USA_Estado],
	[USA_FechaDesasign]
FROM
	[SGT_USUARIO_AREA]






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_ListarTodosPorARE_Codigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_ListarTodosPorARE_Codigo] (
	@ARE_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[ARE_Codigo],
	[USA_FechaAsign],
	[USA_Estado],
	[USA_FechaDesasign]
FROM
	[SGT_USUARIO_AREA]
WHERE
	[ARE_Codigo] = @ARE_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_ListarTodosPorUSU_Codigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_ListarTodosPorUSU_Codigo] 
	@USU_Codigo varchar(10)
AS

SET NOCOUNT ON

SELECT
	usuarea.USU_Codigo,
	area.ARE_Nombre,
	usuarea.ARE_Codigo,
	usuarea.USA_FechaAsign,
	usuarea.USA_Estado,
	usuarea.USA_FechaDesasign
FROM
	SGT_USUARIO_AREA usuarea,SGT_AREA area
WHERE
area.are_codigo=usuarea.are_Codigo and
	[USU_Codigo] = @USU_Codigo





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_AREA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_AREA_Seleccionar] (
	@USU_Codigo varchar(10),
	@ARE_Codigo int
)

AS

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[ARE_Codigo],
	[USA_FechaAsign],
	[USA_Estado],
	[USA_FechaDesasign]
FROM
	[SGT_USUARIO_AREA]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [ARE_Codigo] = @ARE_Codigo






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_BUSCARPORCODIGO]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_BUSCARPORCODIGO]
@codigo varchar(10),
@resultado int output
as
if exists(select USU_Codigo from SGT_USUARIO where USU_Codigo=@codigo)
begin
set @resultado=1
end
else
begin
set @resultado=0
end





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_BUSQUEDA]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_BUSQUEDA]
@USU_Nombre varchar(100)=null,
@USU_Paterno varchar(100)=null,
@USU_Materno varchar(100)=null
AS


/***************************************
*Descripcion: Buscar accion
*Fecha Crea: 27/09/2006
*Parametros: 
*				
*Autor:	Alberto Mac Leod
***************************************/
SET NOCOUNT ON

SELECT
	[USU_Codigo] 		as Codigo,
	[USU_Nombres] 		as Nombres,
	[USU_Paterno]	as Paterno,
	[USU_Materno]		as Materno,
	[USU_Contraseña]		as Contraseña,
[USU_Correo]		as Correo,
EMP_Codigo as Empresa,
[USU_NumDocumento]		as NumeroDocumento,

dbo.BDFGetNombreEstado(USU_Estado)		as Estado,
[Doc_Codigo]		as CodigoDocumento

FROM
	[SGT_USUARIO]
where	
	(USU_Nombres like  coalesce (@USU_Nombre,USU_Nombres)+ '%') 
	and (USU_Paterno like  coalesce (@USU_Paterno,USU_Paterno)+ '%')
	--and (USU_Materno like  coalesce (@USU_Materno,USU_Materno)+ '%')
    and ((USU_Materno like  @USU_Materno + '%') or (@USU_Materno  is null))

order by USU_Nombres





GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_BUSQUEDA_AD]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- SELECT IDUsuario FROM Usuarios Where Nombre=@Nombre AND Pass=@Pass
--ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_BUSQUEDA_AD]  -- FMCR
--@USU_Nombre varchar(100)=null,
--@USU_Paterno varchar(100)=null,
--@USU_Materno varchar(100)=null
--AS 
----		CODIGO_USUARIO = @CODIGO_USUARIO AND 
----		PASSWORD = @PASSWORD

--select 
--	   displayName as Nombres ,
--	   sAMAccountName as usuario,department as Departamento--,adspath as Path ,distinguishedName as Grupo ,company as Empresa ,   mail as Correo, 	
--			 FROM OPENROWSET('ADSDSOObject','User ID= domnep\adminad;Password =Admin$ystem10;adsdatasource;', 'SELECT company,adspath,sAMAccountName, mail,distinguishedName, displayName,department FROM ''LDAP://OU=Callao,OU=Usuarios,OU=Organizacion Neptunia,DC=NEPTUNIA,DC=COM,DC=PE'' where objectCategory = ''user'' and company = ''Neptunia S.A'' order by name ') 
--            WHERE department is not null 
--              AND department not in ('Almacen','División Transporte','Gerencia General','Printer 911','RODRIGUEZ BARDALES','Tecnologías de Información','Triton Transports','Gerencia Legal')
--         ORDER BY department 

----select company as Empresa ,department as Departamento, 
----	   displayName as Usuario ,distinguishedName as Grupo ,
----	   mail as Correo, sAMAccountName as usuario,adspath as Path 
----			 FROM OPENROWSET('ADSDSOObject','User ID= domnep\adminad;Password =Admin$ystem10;adsdatasource;', 'SELECT company,adspath,sAMAccountName, mail,distinguishedName, displayName,department FROM ''LDAP://DC=NEPTUNIA,DC=COM,DC=PE'' where objectCategory = ''user'' and company = ''Neptunia S.A'' and CN = ''Admin*'' order by name ') 

--GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_Eliminar] (
	@USU_Codigo varchar(15)
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO]
WHERE
	[USU_Codigo] = @USU_Codigo

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************
	CREADO POR		:	LORENA QUISPE ARRATEA
	MODIFICADO POR	:	LORENA QUISPE ARRATEA
	FECHA MOD		:	28 DE NOVIEMBRE DE 2006
	MOTIVO			:	AGREGAR EL CODIGO INTERNO, DOMINIO Y SI SE REPLICA O NO		
************************************************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_Insertar] (
	@USU_Codigo varchar(15),		
	@USU_Nombres varchar(100),
	@USU_Paterno varchar(25),
	@USU_Materno varchar(25)=null,
	@USU_Contraseña varchar(2000),
	@USU_Correo varchar(50),
	@USU_NumDocumento varchar(11),
	@USU_Estado char(1),
	@USU_FechaReg datetime,
	@USU_FechaAct datetime,
	@USU_UsuarioReg varchar(15),
	@USU_UsuarioAct varchar(15),
	@USU_FechaRetiro datetime,
	@DOC_Codigo int,
	@USU_Dominio varchar(15),
	@USU_Replica char(1),
	@USU_Perfil  char(1),
	@USU_CodigoVendedor int,
	@USU_CodigoTecnico int , 
	@USU_InternoExterno char(1),
	@USU_ClaseUsuario char(1),
	@USU_RUC varchar(11),
	@USU_Autenticacion char(1)
)

AS

SET NOCOUNT ON

DECLARE @ErrorSave INT
SET @ErrorSave = 0

 IF NOT EXISTS (SELECT * FROM SGT_USUARIO WHERE USU_CODIGO=@USU_Codigo )
begin	
	
		INSERT INTO [SGT_USUARIO] (
			[USU_Codigo],
			[USU_Nombres],
			[USU_Paterno],
			[USU_Materno],
			[USU_Contraseña],
			[USU_Correo],
			[USU_NumDocumento],
			[USU_Estado],
			[USU_FechaReg],
			[USU_FechaAct],
			[USU_UsuarioReg],
			[USU_UsuarioAct],
			[USU_FechaRetiro],
			[DOC_Codigo],
			[USU_CodigoInterno],
			[USU_Dominio],
			[USU_Replica],
			[USU_Perfil],
			[USU_CodigoVendedor],
			[USU_CodigoTecnico]	, 
			[USU_InternoExterno],
			[USU_ClaseUsuario],
			[USU_RUC],
			[USU_AUTENTICACION]
		) VALUES (
			@USU_Codigo,
			@USU_Nombres,
			@USU_Paterno,
			@USU_Materno,
			@USU_Contraseña,
			@USU_Correo,
			@USU_NumDocumento,
			@USU_Estado,
			@USU_FechaReg,
			@USU_FechaAct,
			@USU_UsuarioReg,
			@USU_UsuarioAct,
			@USU_FechaRetiro,
			@DOC_Codigo,
			@USU_Dominio+'\'+@USU_Codigo,
			@USU_Dominio,
			@USU_Replica,
			@USU_Perfil,
			@USU_CodigoVendedor,
			@USU_CodigoTecnico , 
			@USU_InternoExterno,
			@USU_ClaseUsuario,
			@USU_RUC,
			@USU_Autenticacion			
		)	

	
		declare @apellidos varchar(50)
		set @apellidos= @USU_Paterno+' '+@USU_Materno

--		IF @USU_Replica='S'		
--			exec MANTSOFT.dbo.[MANS_UsuarioInsertar]@apellidos,@USU_Nombres,@USU_Contraseña,@USU_Codigo,@USU_Correo,@USU_Perfil,@USU_Estado
--		IF (@@ERROR <> 0)
--		BEGIN	
--			DELETE MANTSOFT.dbo.Man_Usuario WHERE US_Login=@USU_Codigo
--			delete SGT_USUARIO WHERE USU_Codigo=@USU_Codigo
--			select 4 -- no se puedo realizar la insercion
--		END     
			
END
ELSE
	SELECT  1 -- usuario repetido
GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_ListarporCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_ListarporCodigo] (
	@USU_Codigo varchar(15)
)

AS

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[USU_Nombres],
	[USU_Paterno],
	[USU_Materno],
	[USU_Contraseña],
	[USU_Correo],
	[EMP_Codigo],
	[USU_NumDocumento],
	[USU_Estado],
	[DOC_Codigo],	
	Usu_FechaAct,
	Usu_FechaReg,	
	[USU_FechaRetiro],
	[USU_Dominio],
	[USU_Replica],
	[USU_Perfil],
	ISNULL([USU_CodigoVendedor],0) as [USU_CodigoVendedor],
	ISNULL([USU_CodigoTecnico],0) as [USU_CodigoTecnico] , 
	USU_InternoExterno,
	[USU_ClaseUsuario],
	[USU_RUC],
	[USU_AUTENTICACION]	
FROM
	[SGT_USUARIO]
WHERE
	[USU_Codigo] = @USU_Codigo














GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_ListarTodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_ListarTodos]

AS

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[USU_Nombres],
	[USU_Paterno],
	[USU_Materno],
	[USU_Contraseña],
	[USU_Correo],
	[EMP_Codigo],
	[USU_NumDocumento],
	[USU_Estado],
	[DOC_Codigo],	
	Usu_FechaAct,
	Usu_FechaReg,	
	[USU_FechaRetiro],
	[USU_Dominio]
	

FROM
	[SGT_USUARIO]







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_OPCION_PERFIL_ExisteCambios]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_OPCION_PERFIL_ExisteCambios]--1,'usprueba'
	(@PER_Codigo int,	
	@USU_codigo varchar(20)
	
	
)

AS


/***************************************
*Descripcion: Existe Cambios
*Fecha Crea: 20/09/2006
*Parametros: 
*Creado por : Lorena Quispe Arratea	
***************************************/
SET NOCOUNT ON
if( exists (select per_codigo, opc_codigo from SGT_USUARIO_OPCION_PERFIL
	WHERE @PER_Codigo =per_codigo and usu_codigo=@USU_Codigo ))

select * from SGT_USUARIO_OPCION_PERFIL
else

	select * from SGT_USUARIO_OPCION_PERFIL
WHERE @PER_Codigo =per_codigo and usu_codigo=@USU_Codigo







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************
*Descripcion: Elimina las opciones filtradas por usuario y perfil 
*Fecha Crea: 12/01/2007
*Parametros: 	@usu_codigo 	int
		@per_codigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_Eliminar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int
)

AS

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_PERFIL_OPCION]
WHERE
	[PER_Codigo] = @PER_Codigo and
	[USU_Codigo] = @USU_Codigo







GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/***************************************
*Descripcion:Inserta las opciones perfil para un usuario 
*Fecha Crea: 12/01/2007
*Parametros: 	@usu_codigo 	varchar(15)
		@per_codigo 	int
		@opc_codigo	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_Insertar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int,
	@OPC_Codigo int
		
)

AS
declare @opc_padre int
SET NOCOUNT ON
if( not exists (select * from sgt_usuario_perfil_opcion
		 where per_codigo=@PER_Codigo and 
			opc_codigo=@OPC_Codigo and
			usu_codigo=@usu_codigo
		)
   )
BEGIN
	INSERT INTO [SGT_USUARIO_PERFIL_OPCION] (
		[OPC_Codigo],
		[PER_Codigo],
		[USU_Codigo],
		[UPO_FECHAREGISTRO]
	) VALUES (
		@OPC_Codigo,
		@PER_Codigo,
		@USU_Codigo,
		getdate()
	)
	
	if( (select O.OPC_FlagMenu from SGT_OPCION O
		 	where @OPC_Codigo=O.OPC_Codigo)= 0
		  )
		begin
			
			set @opc_padre=(select O.OPC_OpcionPadre from SGT_OPCION O
				where @OPC_Codigo=O.OPC_Codigo)
			
			EXEC dbo.[BDS_SGT_USUARIO_PERFIL_OPCION_Insertar]@USU_CODIGO, @PER_Codigo,@opc_padre
								    
			
		end
 
END






GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_ListarXUsuarioPerfil]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/***************************************
*Descripcion: Lista las opciones filtradas por usuario y perfil 
*Fecha Crea: 08/01/2007
*Parametros: 	@usu_codigo 	int
		@per_codigo 	int
*				
*Autor:	Lorena Quispe Arratea
***************************************/
--BDS_SGT_USUARIO_PERFIL_OPCION_ListarXUsuarioPerfil 'ADMIN', 1,4
		
ALTER PROCEDURE [dbo].[BDS_SGT_USUARIO_PERFIL_OPCION_ListarXUsuarioPerfil]
		@usu_codigo varchar(15),
		@per_codigo int,
		@sis_codigo int
 AS

--SELECCIONA LAS ACCIONES ASIGNADAS A UNA OPCION
	select  
		UPO.OPC_CODIGO	 	as intCodigo,
		O.OPC_NOMBRE		as strNombre
	from	
		SGT_USUARIO_PERFIL_OPCION UPO
		inner join SGT_OPCION O	
		on UPO.OPC_CODIGO =O.OPC_CODIGO	and O.OPC_flagMenu=0 
			and O.SIS_CODIGO = @sis_codigo
	where
		UPO.USU_CODIGO = @usu_codigo and
		UPO.PER_CODIGO = @per_codigo 
		 
	
-- SELECCIONA LAS ACCIONES Q NO HAN SIDO ASIGANAS A UNA OPCION				
	select  
		OP.OPC_CODIGO		as intCodigo,
		O.OPC_NOMBRE		as strNombre
	from
		SGT_OPCION_PERFIL OP				
		inner join SGT_OPCION O
		ON OP.OPC_CODIGO= O.OPC_CODIGO and
		   O.SIS_CODIGO=@sis_codigo and O.OPC_flagMenu=0
	where	OP.PER_CODIGO=@per_codigo and
		OP.OPC_CODIGO not in (
					select OPC_CODIGO
					from   SGT_USUARIO_PERFIL_OPCION
					where  USU_Codigo = @usu_codigo and
					       PER_CODIGO = @per_codigo
				     )
			










GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_VENDEDOR_ListarTodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BDS_SGT_VENDEDOR_ListarTodos]
as
SELECT 0 as ven_secuencial,'-' as Vendedor 
/*FROM SIC_Produccion.dbo.vta_vendedor
where ven_flageliminado=0
order by ven_apaterno + ' ' + ven_amaterno + ' ' + ven_nombres*/

GO
/****** Object:  StoredProcedure [dbo].[BDS_SGT_VerificaEmpresaEliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BDS_SGT_VerificaEmpresaEliminar] 
@EMP_CODIGO INT 
As 
	Select 
			* 
	From 
			SGT_SCHEMAS_EMPRESA 
	Where 
			emp_codigo = @EMP_CODIGO
GO
/****** Object:  StoredProcedure [dbo].[COPIAR_PERFILES_USUARIO]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[COPIAR_PERFILES_USUARIO] --'stuchoffen','mayamunaque'
(@USUARIO_NUEVO VARCHAR(15),@PERFIL_SIMILAR VARCHAR(15))  
 AS
 BEGIN
	--DECLARE @USUARIO_NUEVO VARCHAR(15)
	--DECLARE @PERFIL_SIMILAR VARCHAR(15)
	--SET @USUARIO_NUEVO='pruebacre'
	--SET	@PERFIL_SIMILAR='rorivalles'
	
	--Copiar Acciones
	IF EXISTS (SELECT * FROM  SGT_USUARIO_ACCION_OPCION WHERE USU_CODIGO=@USUARIO_NUEVO)
	BEGIN
		DELETE SGT_USUARIO_ACCION_OPCION WHERE USU_CODIGO=@USUARIO_NUEVO
	END
	
	INSERT INTO SGT_USUARIO_ACCION_OPCION
	SELECT @USUARIO_NUEVO, ACC_Codigo,OPC_Codigo,GETDATE(),NULL FROM SGT_USUARIO_ACCION_OPCION WHERE USU_CODIGO=@PERFIL_SIMILAR
	
	--Copiar Opciones
	IF EXISTS (SELECT * FROM  SGT_USUARIO_ACCION_OPCION WHERE USU_CODIGO=@USUARIO_NUEVO)
	BEGIN
		DELETE SGT_USUARIO_PERFIL_OPCION WHERE USU_CODIGO=@USUARIO_NUEVO
	END
	
	INSERT INTO SGT_USUARIO_PERFIL_OPCION
	SELECT @USUARIO_NUEVO,PER_Codigo,OPC_Codigo,GETDATE(),NULL FROM SGT_USUARIO_PERFIL_OPCION WHERE USU_CODIGO=@PERFIL_SIMILAR
	
	--SELECT * FROM SGT_USUARIO  WHERE USU_Nombres LIKE  '%BIRKTRANS%'
	--SELECT * FROM SGT_USUARIO  WHERE USU_Nombres LIKE  '%vanguard%'
	--update SGT_USUARIO set USU_Correo='leslie.delacruz@neptunia.com.pe; giancarlo.taipe@neptunia.com.pe' WHERE USU_Nombres LIKE  '%BIRKTRANS%'
	
	
 END

GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_Actualizar] (
	@OPC_Codigo int,	
	@OPC_Nombre varchar(25),
	@OPC_Descripcion varchar(50),
	@OPC_Estado char(1),
	@OPC_Enlace varchar(50),
	@OPC_Visibilidad char(1)
)

AS

SET NOCOUNT ON

UPDATE
	[SGT_OPCION]
SET
	[OPC_Estado] = @OPC_Estado,
	[OPC_Descripcion] = @OPC_Descripcion,
	[OPC_Nombre] = @OPC_Nombre,			
	opc_enlace=@OPC_Enlace ,
	[USU_FechaAct] = getdate(),
	OPC_Visibilidad=@OPC_Visibilidad
WHERE
	 [OPC_Codigo] = @OPC_Codigo





GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/***************************************
*Descripcion: Elimina opciones y sus posibles relaciones
*Fecha Crea: 01/10/2006
*Fecha Modif :	15/01/2007
*Parametros: 
*				
*Autor:	Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_Eliminar] (
	@OPC_Codigo int
)
as

-- borrando los perfiles asociados a los hijos de la opcion
		delete sgt_opcion_perfil where OPC_Codigo in (select OPC_codigo from sgt_opcion where OPC_OpcionPadre=@OPC_Codigo)
--borrando las acciones de la opcion por usuario
		delete sgt_usuario_accion_opcion where OPC_Codigo=@OPC_Codigo
--borrando las acciones de la opciones hijas
		delete sgt_accion_opcion where OPC_Codigo=@OPC_Codigo
-- borrando las opciones hijas
		delete sgt_opcion where OPC_OpcionPadre=@OPC_Codigo
-- borrando los perfiles asociados a la opcion
		delete sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo
-- borrando la opcion
		delete sgt_opcion where OPC_Codigo=@OPC_Codigo

		
/*
  if ( not exists(select * from sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo) )
    begin
    	        if(not exists(select * from sgt_opcion where OPC_OpcionPadre=@OPC_Codigo))
		          begin
		           delete sgt_opcion where OPC_Opcion=@OPC_Codigo
		   end
		ELSE
			BEGIN 
			delete FROM sgt_opcion where OPC_OpcionPadre=@OPC_Codigo
			delete from sgt_opcion where OPC_Codigo=@OPC_Codigo
			
			
			
			END
	
        end
     
END
else
	begin
		
		
		delete sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo
  		
		delete sgt_opcion where OPC_Codigo=@OPC_Codigo
		delete sgt_opcion where OPC_OpcionPadre=@OPC_Codigo
	      end
		
*/







GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/***************************************
*Descripcion: Insertar opcion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Lorena
***************************************/

ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_Insertar] (
	@OPC_Estado char(1),
	@OPC_Descripcion varchar(50),
	@OPC_Nombre varchar(25),
	@SIS_Codigo int,
	@OPC_OpcionPadre int,
	@OPC_Enlace varchar(100),
	@OPC_FlagMenu char(1)
)

AS

SET NOCOUNT ON
IF ( NOT EXISTS (SELECT * FROM SGT_OPCION WHERE OPC_NOMBRE=@OPC_NOMBRE AND SIS_CODIGO=@SIS_CODIGO))
BEGIN
	INSERT INTO [SGT_OPCION] (
		[OPC_Estado],
		[OPC_Descripcion],
		[OPC_Nombre],
		[SIS_Codigo],
		[OPC_OpcionPadre],
		[OPC_Enlace],
		[USU_FechaReg],
		[USU_FechaAct],
		[OPC_FlagMenu] ) 
	VALUES (
		@OPC_Estado,
		@OPC_Descripcion,
		@OPC_Nombre,
		@SIS_Codigo,
		@OPC_OpcionPadre,
		@OPC_Enlace,
		getdate(),
		getdate(),
		@OPC_FlagMenu 
	)
	SELECT SCOPE_IDENTITY()
END
ELSE
	SELECT -1




GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_ObtenerPorCodigo]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_ObtenerPorCodigo] (
	@OPC_Codigo int
)

as

SELECT
	so.[OPC_Estado] 		as chrEstado,
	so.[OPC_Descripcion]       as strDescripcion,
	so.[OPC_Nombre]		as strNombre,
	so.[OPC_Codigo]		as intCodigo,
	so.[SIS_Codigo]		as intSisCodigo,
	isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
	isnull(so2.OPC_Nombre,'[Es un Menu]')as 'OPC_Nombre_Padre',
	isnull(so.OPC_Enlace,'No existe enlace')as strEnlace,
	ss.SIS_Nombre		as strSisNombre,
	so.OPC_Visibilidad 	as booVisibilidad
		
	
FROM
	[SGT_OPCION] so
	inner join SGT_SISTEMA ss
	on ss.SIS_Codigo=so.SIS_Codigo
	left join [SGT_OPCION] so2
	on so2.OPC_Codigo=so.OPC_OpcionPadre
WHERE
	so.[OPC_Codigo] = @OPC_Codigo

ORDER BY 1



 





GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_ObtenerPorSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_ObtenerPorSistema] 
(
	@sis_codigo int
)

AS

SET NOCOUNT ON

SELECT
	[OPC_Estado],
	[OPC_Descripcion],
	[OPC_Nombre],
	[OPC_Codigo],
	[SIS_Codigo]
	
FROM
	[SGT_OPCION]
WHERE
	[SIS_Codigo] = @sis_Codigo and
	[OPC_FlagMenu]=0






GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_PERFIL_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_PERFIL_Eliminar] (
	@OPC_Codigo int,
	@PER_Codigo int
)

AS

SET NOCOUNT ON
declare @opc_padre int 
update sgt_Opcion_Perfil set ope_estado='I' 
WHERE
	[OPC_Codigo] = @OPC_Codigo
	AND [PER_Codigo] = @PER_Codigo

set @opc_padre=(select O.OPC_OpcionPadre from SGT_OPCION O
			where @OPC_Codigo=O.OPC_Codigo)
update sgt_Opcion_Perfil set ope_estado='I'
	where opc_codigo=@opc_padre
	






GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_Seleccionar]
as
/***************************************
*Descripcion: Lista las Opciones existentes
*Fecha Crea: 23/08/2005
*Parametros: 	
*				
*Autor:	Reyes Avalos Gisella Rub{i 	
***************************************/

select so.OPC_Codigo,so.OPC_Nombre,ss.SIS_Nombre,so.OPC_Estado,
so.SIS_Codigo,isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
isnull(so2.OPC_Nombre,'[Es un Menu]')as 'OPC_Nombre_Padre',
isnull(so.OPC_Enlace,'[Sin enlace]')as 'OPC_Enlace',
case 
when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='0' then  '[Menú]' 
when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu='0' then  '[Sub-Menú]' 
when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu<>'0' then  '[Opción Simple]' 
end as 'TipoMenu'
from sgt_opcion so
inner join sgt_sistema ss
on ss.SIS_Codigo=so.SIS_Codigo
left join sgt_opcion so2
on so2.OPC_Codigo=so.OPC_OpcionPadre
--order by 2




GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_OPCION_TieneOpciones]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/***************************************
*Descripcion: DBS_SGT_OPCION_TieneOpciones, verifica que no haya data que contenga a esta opcion
*Fecha Crea: 15/01/2007
*Parametros:  	@opc_codigo 	int		
*Salida	  :	@opciones  1 hay data relacionada
			   0 NO hay data relacionada		
*				
*Autor:	Lorena Quispe Arratea
***************************************/


ALTER PROCEDURE [dbo].[DBS_SGT_OPCION_TieneOpciones] (
	@OPC_Codigo int	,
	@opciones int output
)
as
  if ( not exists(select * from sgt_opcion_perfil where OPC_Codigo=@OPC_Codigo) )
    begin
    if(not exists(select * from sgt_accion_opcion where OPC_Codigo=@OPC_Codigo ))
        begin
	        if(not exists(select * from sgt_opcion where OPC_OpcionPadre=@OPC_Codigo))
	      	 set  @opciones=0
		else set @opciones=1
	
        end
     
	else set @opciones=1
    end
else
	begin
	      set @opciones=1
	      end
		
select @opciones


 





GO
/****** Object:  StoredProcedure [dbo].[DBS_SGT_USUARIO_OPCION_PERFIL_ExisteCambios]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[DBS_SGT_USUARIO_OPCION_PERFIL_ExisteCambios]--1,'usprueba'
	(@PER_Codigo int,	
	@USU_codigo varchar(20)
	
	
)

AS

SET NOCOUNT ON
if( exists (select per_codigo, opc_codigo from SGT_USUARIO_OPCION_PERFIL
	WHERE @PER_Codigo =per_codigo and usu_codigo=@USU_Codigo ))

select * from SGT_USUARIO_OPCION_PERFIL
else

	select * from SGT_USUARIO_OPCION_PERFIL
WHERE @PER_Codigo =per_codigo and usu_codigo=@USU_Codigo







GO
/****** Object:  StoredProcedure [dbo].[GET_METADATA]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[GET_METADATA]
	@TABLE_NAME VARCHAR(200)

AS

SELECT 
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE,
	isnull(CHARACTER_MAXIMUM_LENGTH,0),
	ISNULL((SELECT 'Y' FROM SYSFOREIGNKEYS WHERE FKEYID =ID AND FKEY=COLID),'N') as 'IsForeignKey',
	Ordinal_Position,
	dbo.fnIsColumnPrimaryKey(@TABLE_NAME,COLUMN_NAME) AS 'IsPK'
	
FROM  
	SYSCOLUMNS,
	(SELECT
		COLUMN_NAME,
		IS_NULLABLE,
		DATA_TYPE,
		CHARACTER_MAXIMUM_LENGTH,
		Ordinal_Position
		
	FROM 
		INFORMATION_SCHEMA.COLUMNS
		
	WHERE
		TABLE_NAME =@Table_Name) AS A
	
WHERE 
	ID 
IN
	(SELECT 
		ID 
	FROM 
		SYSOBJECTS 
	WHERE 
		TYPE='U'
 		AND NAME =@Table_Name
	) 

AND
	A.COLUMN_NAME =NAME

Order By
	Ordinal_Position		






 




GO
/****** Object:  StoredProcedure [dbo].[GET_TABLENAME]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE 
	[dbo].[GET_TABLENAME]
AS
	SELECT
		TABLE_NAME as 'WASTE'
	FROM
		INFORMATION_SCHEMA.TABLES
	WHERE
		TABlE_TYPE='BASE TABLE'	AND
		TABLE_NAME <> 'dtproperties'










GO
/****** Object:  StoredProcedure [dbo].[pruebastore]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[pruebastore]  AS
select * from sgt_usuario





GO
/****** Object:  StoredProcedure [dbo].[SGS_OPCION_BusquedasoloOpcionxSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







--[SGS_OPCION_BusquedasoloOpcionxSistema] null,'pr'

ALTER PROCEDURE [dbo].[SGS_OPCION_BusquedasoloOpcionxSistema]

@OPC_Nombre varchar(200)=null,
@SIS_Nombre varchar(100)=null

as 
	
select so.OPC_Codigo,
		so.OPC_Nombre,
		ss.SIS_Nombre,
		so.OPC_Estado,
		so.SIS_Codigo,
		isnull(so.OPC_OpcionPadre,'')as 'OPC_OpcionPadre' ,
		isnull(so2.OPC_Nombre,' - ') +' '+
		case 
			when so2.OPC_OpcionPadre is null and  so2.OPC_FlagMenu='1' then  '[Menú]' 
			when so2.OPC_OpcionPadre is not null and  so2.OPC_FlagMenu<>'0' then  '[Sub-Menú]' 
			when so2.OPC_OpcionPadre is not null and  so2.OPC_FlagMenu='0' then  '[Opción Simple]' 
		else ''
		end
		as 'OPC_Nombre_Padre',
		so.opc_flagmenu as 'OPC_FlagMenu',
		isnull(so.OPC_Enlace,'No existe enlace')as 'OPC_Enlace',
		case 
		when so.OPC_OpcionPadre is null and  so.OPC_FlagMenu='1' then  '[Menú]' 
		when so.OPC_OpcionPadre is not null and  so.OPC_FlagMenu<>'0' then  '[Sub-Menú]' 
		when so.OPC_OpcionPadre  is not null and  so.OPC_FlagMenu='0' then  '[Opción Simple]' 
		else ''
		end as 'TipoMenu'

from	 
		sgt_opcion so
		inner join sgt_sistema ss
		on ss.SIS_Codigo=so.SIS_Codigo
		left join sgt_opcion so2
		on so2.OPC_Codigo=so.OPC_OpcionPadre
where 	  
		(so.OPC_Nombre like coalesce( @OPC_Nombre,so.OPC_Nombre)+ '%')
 		and (ss.SIS_Nombre = coalesce (@SIS_Nombre,ss.SIS_Nombre))
order by 	so.OPC_codigo


 






GO
/****** Object:  StoredProcedure [dbo].[SGT_REPORTE_TRANSACCIONES]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









--[SGT_REPORTE_TRANSACCIONES] 4,9,73

ALTER PROCEDURE [dbo].[SGT_REPORTE_TRANSACCIONES]
@sistema int,
@perfil int,
@opcion int =null,
@fecha1 datetime=null,
@fecha2 datetime=null
AS

if(@opcion is not null)
begin

	select   Logt.Log_secuencial 			as Identificador,
		 Logt.Usu_COdigo 			as Usuario,
		 (Usu.USU_Nombres + ' '+USU.USU_Paterno+' ' + Usu.Usu_Materno) as Nombres,
		 [dbo].[BDFGetOpcion](@opcion)       	as Opcion,
		 SIS.SIS_Nombre				as Sistema,
		 ACC_Nombre 				as Accion, 
		 Logt.Log_IP 				as IP,
		 Logt.Log_fechahora 			as Fecha 
	
	from	 SGT_LOG_transaccion Logt, SGT_USUARIO USU,SGT_ACCION ACC,
		 SGT_PERFIL_USUARIO PERUS,SGT_SISTEMA SIS , sgt_opcion OPC
	
	where   
		Logt.USU_Codigo=USU.USU_codigo and 	
		Logt.Acc_codigo=Acc.Acc_codigo and 
		logt.USU_Codigo=PERUS.USU_CODIGO and 
		PERUS.PER_CODIGO=@perfil and
		Logt.OPC_Codigo=@opcion and 
		OPC.OPC_codigo=LOGT.OPC_Codigo and
		SIS.SIS_Codigo=@sistema and
		SIS.SIS_Codigo=OPC.SIS_Codigo and
		Logt.Log_FechaHora
		between coalesce(@Fecha1,Logt.Log_FechaHora) and 
		coalesce(@Fecha2,Logt.Log_FechaHora)
	
	order by fecha desc
end
else

	select   Logt.Log_secuencial 			as Identificador,
		 Logt.Usu_Codigo 			as Usuario,
		 (Usu.USU_Nombres + ' '+USU.USU_Paterno+' ' + Usu.Usu_Materno) as Nombres,
		 [dbo].[BDFGetOpcion](coalesce(@opcion,LOGT.OPC_Codigo))       as Opcion,
		 SIS.SIS_Nombre				as Sistema,
		 ACC_Nombre 				as Accion, 
		 Logt.Log_IP 				as IP,
		 Logt.Log_fechahora 			as Fecha 
	
	from	 SGT_LOG_transaccion Logt, SGT_USUARIO USU,SGT_ACCION ACC,
		 SGT_PERFIL_USUARIO PERUS,SGT_SISTEMA SIS 
	
	where   
		Logt.USU_Codigo=USU.USU_codigo and 	
		Logt.Acc_codigo=Acc.Acc_codigo and 
		logt.USU_Codigo=PERUS.USU_CODIGO and 
		PERUS.PER_CODIGO=@perfil and		 
		SIS.SIS_Codigo=@sistema and
		Logt.Log_FechaHora
		between coalesce(@Fecha1,Logt.Log_FechaHora) and 
		coalesce(@Fecha2,Logt.Log_FechaHora)
	
	order by fecha desc





GO
/****** Object:  StoredProcedure [dbo].[SGTS_Carga_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[SGTS_Carga_Listar]
	@CRG_NAME varchar(100),
	@CTC_Codigo int,
	@SIS_Codigo int,
    @USU_Codigo varchar(15)
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_CARGA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

if @CRG_NAME is null and @CTC_Codigo = 0

	BEGIN

	  SELECT r.[CRG_Codigo],
			 r.[CRG_Name] as CRG_Name,
			 r.[CRG_Prefijo] ,
			 r.[CRG_Plantilla] as CRG_Plantilla,
			 c.[CTC_Nombre] as CTC_Category,
			 case when r.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],	
			 r.[CRG_Ruta],		
			 r.[CRG_Tipo],
			 r.[CRG_Descripcion],
			 c.[CTC_Codigo],
			 r.[SIS_Codigo],
			 r.[USU_UsuarioReg],
			 r.[USU_UsuarioAct],
			 r.[USU_FechaReg],
			 r.[USU_FechaAct]
		FROM [SGT_CARGA] r 
  inner join [SGT_CARGA_CATEGORIA] c
		  ON r.[CTC_Codigo] = c.[CTC_Codigo]      
  		 AND r.[SIS_Codigo] = @SIS_Codigo
		 AND r.[CRG_Estado] = 'A'
  inner join [SGT_PERFILCARGA_CARGA] pc
		  ON pc.[CRG_Codigo] = r.[CRG_Codigo]	  
		 AND pc.[RPR_Estado] = 'A'
  inner join [SGT_PERFILCARGA_USUARIO] p
          ON P.[USU_Codigo] = @USU_Codigo
		 AND p.[PFC_CODIGO] = pc.[PFC_CODIGO]      
  		 



	END

ELSE

	BEGIN

	IF @CTC_Codigo = 0 
		BEGIN

		   SELECT r.[CRG_Codigo],
			 r.[CRG_Name] as CRG_Name,
			 r.[CRG_Prefijo] ,
			 r.[CRG_Plantilla] as CRG_Plantilla,
			 c.[CTC_Nombre] as CTC_Category,
			 case when r.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],	
			 r.[CRG_Ruta],		
			 r.[CRG_Tipo],
			 r.[CRG_Descripcion],
			 c.[CTC_Codigo],
			 r.[SIS_Codigo],
			 r.[USU_UsuarioReg],
			 r.[USU_UsuarioAct],
			 r.[USU_FechaReg],
			 r.[USU_FechaAct]
		FROM [SGT_CARGA] r 
  inner join [SGT_CARGA_CATEGORIA] c
		  ON r.[CTC_Codigo] = c.[CTC_Codigo]      
  		 AND r.[SIS_Codigo] = @SIS_Codigo
		 AND r.[CRG_Estado] = 'A'
  inner join [SGT_PERFILCARGA_CARGA] pc
		  ON pc.[CRG_Codigo] = r.[CRG_Codigo]	  
		 AND pc.[RPR_Estado] = 'A'
  inner join [SGT_PERFILCARGA_USUARIO] p
          ON P.[USU_Codigo] = @USU_Codigo
		 AND p.[PFC_CODIGO] = pc.[PFC_CODIGO]   	  
		   WHERE r.[CRG_Name] LIKE '%'+ isnull(@CRG_NAME,'') +'%'             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
		     AND r.[CRG_Estado] = 'A'
			
		END    

	ELSE

		BEGIN
			
		   SELECT r.[CRG_Codigo],
			 r.[CRG_Name] as CRG_Name,
			 r.[CRG_Prefijo] ,
			 r.[CRG_Plantilla] as CRG_Plantilla,
			 c.[CTC_Nombre] as CTC_Category,
			 case when r.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],	
			 r.[CRG_Ruta],		
			 r.[CRG_Tipo],
			 r.[CRG_Descripcion],
			 c.[CTC_Codigo],
			 r.[SIS_Codigo],
			 r.[USU_UsuarioReg],
			 r.[USU_UsuarioAct],
			 r.[USU_FechaReg],
			 r.[USU_FechaAct]
		FROM [SGT_CARGA] r 
  inner join [SGT_CARGA_CATEGORIA] c
		  ON r.[CTC_Codigo] = c.[CTC_Codigo]      
  		 AND r.[SIS_Codigo] = @SIS_Codigo
		 AND r.[CRG_Estado] = 'A'
  inner join [SGT_PERFILCARGA_CARGA] pc
		  ON pc.[CRG_Codigo] = r.[CRG_Codigo]	  
		 AND pc.[RPR_Estado] = 'A'
  inner join [SGT_PERFILCARGA_USUARIO] p
          ON P.[USU_Codigo] = @USU_Codigo
		 AND p.[PFC_CODIGO] = pc.[PFC_CODIGO]      
		   WHERE r.[CRG_Name] LIKE '%'+ isnull(@CRG_NAME,'') +'%'
			 AND r.[CTC_Codigo] = @CTC_Codigo             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
			 AND r.[CRG_Estado] = 'A'
		 
		END    

	END




   








GO
/****** Object:  StoredProcedure [dbo].[SGTS_Carga_Listartodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_Carga_Listartodos]
	@CRG_NAME varchar(100),
	@CTC_Codigo int,
	@SIS_Codigo int,
    @USU_Codigo varchar(15),
	@CRG_ESTADO varchar(1)
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_CARGA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

if @CRG_NAME is null and @CTC_Codigo = 0

	BEGIN

	  SELECT cr.[CRG_Codigo],
			 cr.[CRG_Name] as CRG_Nombre,
			 cr.[CRG_Tipo] ,
			 cr.[CRG_Descripcion],
			 cr.[CRG_Ruta],
			 c.[CTC_Nombre] as CRG_Category,
			 case when cr.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],
			 cr.[USU_UsuarioReg],
			 cr.[USU_UsuarioAct],
			 cr.[USU_FechaReg],
			 cr.[USU_FechaAct]		
		     FROM [SGT_CARGA] cr 
  inner join [SGT_CARGA_CATEGORIA] c
		  ON cr.[CTC_Codigo] = c.[CTC_Codigo]      
  		 AND cr.[SIS_Codigo] = @SIS_Codigo
		
	END

ELSE

	BEGIN

	IF @CTC_Codigo = 0 
		BEGIN

		 SELECT cr.[CRG_Codigo],
				 cr.[CRG_Name] as CRG_Nombre,
				 cr.[CRG_Tipo] ,
				 cr.[CRG_Descripcion],
				 c.[CTC_Nombre] as CRG_Category,
				 case when cr.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],
				 cr.[USU_UsuarioReg],
				 cr.[USU_UsuarioAct],
				 cr.[USU_FechaReg],
				 cr.[USU_FechaAct]		
			FROM [SGT_CARGA] cr 
	  inner join [SGT_CARGA_CATEGORIA] c
			  ON cr.[CTC_Codigo] = c.[CTC_Codigo] 	
		   WHERE cr.[CRG_Name] LIKE '%'+ isnull(@CRG_NAME,'') +'%'             
	  		 AND cr.[SIS_Codigo] = @SIS_Codigo
		     			
		END    

	ELSE

		BEGIN
			
		  SELECT cr.[CRG_Codigo],
				 cr.[CRG_Name] as CRG_Nombre,
				 cr.[CRG_Tipo] ,
				 cr.[CRG_Descripcion],
				 c.[CTC_Nombre] as CRG_Category,
				 case when cr.[CRG_Estado] = 'A' then 'Activo' else 'Inactivo' end [CRG_Estado],
				 cr.[USU_UsuarioReg],
				 cr.[USU_UsuarioAct],
				 cr.[USU_FechaReg],
				 cr.[USU_FechaAct]		
			FROM [SGT_CARGA] cr 
	  inner join [SGT_CARGA_CATEGORIA] c
			  ON cr.[CTC_Codigo] = c.[CTC_Codigo] 	  
		   WHERE cr.[CRG_Name] LIKE '%'+ isnull(@CRG_NAME,'') +'%'
			 AND cr.[CTC_Codigo] = @CTC_Codigo             
	  		 AND cr.[SIS_Codigo] = @SIS_Codigo
			 
		 
		END    

	END
GO
/****** Object:  StoredProcedure [dbo].[SGTS_CARGA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SGTS_CARGA_Seleccionar] (

	@CRG_Codigo varchar(15)
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_CARGA
*Fecha Crea  : 15/02/2011
*Fecha Mod   : 
*Parametros  : 
*		CRG_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[CRG_Codigo],
	[CRG_Name],
	[CRG_Tipo],
	[CRG_Ruta],
	[CRG_Descripcion],
	[CRG_Plantilla],
	[CRG_Prefijo],
	[CRG_Estado],
	[CTC_Codigo],
	[SIS_Codigo],
	[USU_UsuarioReg],
	[USU_UsuarioAct],
	[USU_FechaReg],
	[USU_FechaAct]
FROM
	[SGT_CARGA]
WHERE
	[CRG_Codigo] = @CRG_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[SGTS_EMPRESA_Actualizar] (  
 @EMP_Codigo int,  
 @EMP_Nombre varchar(100),  
 @EMP_Descripcion varchar(50),  
 @EMP_Ruc varchar(11),  
 @EMP_Direccion varchar(100),  
 @EMP_Estado char(1),  
 @EMP_FechaSuscripcion smalldatetime,  
 @EMP_Telf1 varchar(8),  
 @EMP_Contacto varchar(30), 
 @EMP_email varchar(100),   
 @USU_UsuarioAct varchar(15),  
 @IMAGEN image ,   
 @EMP_RUTAIMAGEN varchar(250),  
 @EMP_NomImagen varchar(50),  
 @DECIMAL nvarchar(2),  
 @STORERKEY nvarchar(50)  
)  
  
AS  
/*********************************  
*Descripcion : Actualiza un Registro de la Tabla SGT_EMPRESA  
*Fecha Crea  : 10/11/2009  
*Fecha Mod   :   
*Parametros  :   
*  EMP_Codigo  :   
*  EMP_Nombre  :   
*  EMP_Descripcion  :   
*  EMP_Ruc  :   
*  EMP_Direccion  :   
*  EMP_Estado  :   
*  EMP_FechaSuscripcion  :   
*  EMP_Telf1  :   
*  EMP_Contacto  :   
*  EMP_email  :   
*  IMAGEN  :   
*  EMP_RUTAIMAGEN  :   
*  DECIMAL  :   
*  STORERKEY  :   
*  USU_UsuarioReg  :   
*  USU_UsuarioAct  :   
*  USU_FechaReg  :   
*  USU_FechaAct  :   
*Autor       :   
*********************************/  
  
SET NOCOUNT ON  
  
UPDATE  
 [SGT_EMPRESA]  
SET  
 [EMP_Nombre] = @EMP_Nombre,  
 [EMP_Descripcion] = @EMP_Descripcion,  
 [EMP_Ruc] = @EMP_Ruc,  
 [EMP_Direccion] = @EMP_Direccion,  
 [EMP_Estado] = @EMP_Estado,  
 [EMP_FechaSuscripcion] = @EMP_FechaSuscripcion,  
 [EMP_Telf1] = @EMP_Telf1,  
 [EMP_Contacto] = @EMP_Contacto,  
 [EMP_email] = @EMP_email,  
 [IMAGEN] = @IMAGEN,  
 [EMP_RUTAIMAGEN] = @EMP_RUTAIMAGEN,  
 EMP_NomImagen = @EMP_NomImagen ,   
 [DECIMAL] = @DECIMAL,  
 [STORERKEY] = @STORERKEY,  
 [USU_UsuarioAct] = @USU_UsuarioAct,  
 [USU_FechaAct] = getdate()  
WHERE  
  [EMP_Codigo] = @EMP_Codigo  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_EMPRESA_Eliminar] (
	@EMP_Codigo int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_EMPRESA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_EMPRESA]
WHERE
	[EMP_Codigo] = @EMP_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_EMPRESA_Insertar] (  
 @EMP_Nombre varchar(100),  
 @EMP_Descripcion varchar(50),  
 @EMP_Ruc varchar(11),  
 @EMP_Direccion varchar(100),  
 @EMP_Estado char(1),  
 @EMP_FechaSuscripcion smalldatetime,  
 @EMP_Telf1 varchar(8),    
 @EMP_Contacto varchar(30),
 @EMP_email varchar(100),  
 @IMAGEN image,  
 @EMP_RUTAIMAGEN varchar(250),  
 @EMP_NomImagen varchar(50) ,   
 @DECIMAL nvarchar(2),  
 @STORERKEY nvarchar(50),  
 @USU_UsuarioReg varchar(15)  
)  
  
AS  
/*********************************  
*Descripcion : Inserta un Registro de la Tabla SGT_EMPRESA  
*Fecha Crea  : 10/11/2009  
*Fecha Mod   :   
*Parametros  :   
*  EMP_Codigo  :   
*  EMP_Nombre  :   
*  EMP_Descripcion  :   
*  EMP_Ruc  :   
*  EMP_Direccion  :   
*  EMP_Estado  :   
*  EMP_FechaSuscripcion  :   
*  EMP_Telf1  :   
*  EMP_Contacto  :   
*  EMP_email  :   
*  IMAGEN  :   
*  EMP_RUTAIMAGEN  :   
*  DECIMAL  :   
*  STORERKEY  :   
*  USU_UsuarioReg  :   
*  USU_UsuarioAct  :   
*  USU_FechaReg  :   
*  USU_FechaAct  :   
*Autor       :   
*********************************/  
  
SET NOCOUNT ON  
  
declare @EMP_Codigo int  
  
select @EMP_Codigo = Isnull(Max(EMP_Codigo), 0 ) + 1  from [SGT_EMPRESA]   
  
  
INSERT INTO [SGT_EMPRESA] (  
 [EMP_Codigo],  
 [EMP_Nombre],  
 [EMP_Descripcion],  
 [EMP_Ruc],  
 [EMP_Direccion],  
 [EMP_Estado],  
 [EMP_FechaSuscripcion],  
 [EMP_Telf1],  
 [EMP_Contacto],  
 [EMP_email],  
 [IMAGEN],  
 [EMP_RUTAIMAGEN],  
 EMP_NomImagen ,  
 [DECIMAL],  
 [STORERKEY],  
 [USU_UsuarioReg],  
 [USU_FechaReg]  
) VALUES (  
 @EMP_Codigo,  
 @EMP_Nombre,  
 @EMP_Descripcion,  
 @EMP_Ruc,  
 @EMP_Direccion,  
 @EMP_Estado,  
 @EMP_FechaSuscripcion,  
 @EMP_Telf1,  
 @EMP_Contacto,  
 @EMP_email,  
 @IMAGEN,  
 @EMP_RUTAIMAGEN,  
 @EMP_NomImagen ,  
 @DECIMAL,  
 @STORERKEY,  
 @USU_UsuarioReg,  
 getdate()  
   
)  
  
select @EMP_Codigo EMP_Codigo   
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_EMPRESA_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_EMPRESA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[EMP_Codigo],
	[EMP_Nombre],
	[EMP_Descripcion],
	[EMP_Ruc],
	[EMP_Direccion],
	[EMP_Estado],
	[EMP_FechaSuscripcion],
	[EMP_Telf1],
	[EMP_Contacto],
	[EMP_email],
	[IMAGEN],
	[EMP_RUTAIMAGEN],
	[DECIMAL],
	[STORERKEY],
	[USU_UsuarioReg],
	[USU_UsuarioAct],
	[USU_FechaReg],
	[USU_FechaAct]
FROM
	[SGT_EMPRESA]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_ListarBuscar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SGTS_EMPRESA_ListarBuscar 
-- exec SGTS_EMPRESA_ListarBuscar @EMP_Codigo=NULL,@EMP_Nombre='sony'

ALTER PROCEDURE [dbo].[SGTS_EMPRESA_ListarBuscar]
@EMP_Codigo Varchar(10) = NULL  , 
@EMP_Nombre varchar(100) = null  
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_EMPRESA
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

Select 
	[EMP_Codigo],
	[EMP_Nombre],
	[EMP_Ruc],
	[EMP_Direccion],
	[EMP_Telf1],
	[EMP_Contacto] ,
	[EMP_Estado]
	
From 
	[SGT_EMPRESA]
Where 
	(
		CONVERT(VARCHAR(10),@EMP_Codigo) Is Null  Or
		(CONVERT(VARCHAR(10),@EMP_Codigo) <> '' And  EMP_Codigo = @EMP_Codigo)
	) 
	And 
	(
		@EMP_Nombre Is Null  Or
		(@EMP_Nombre  <> '' And EMP_Nombre like '%' + ISNULL(@EMP_Nombre,'') + '%')
	)

GO
/****** Object:  StoredProcedure [dbo].[SGTS_EMPRESA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_EMPRESA_Seleccionar] (
	@EMP_Codigo int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_EMPRESA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[EMP_Codigo],
	[EMP_Nombre],
	[EMP_Descripcion],
	[EMP_Ruc],
	[EMP_Direccion],
	[EMP_Estado],
	[EMP_FechaSuscripcion],
	[EMP_Telf1],
	[EMP_Contacto],
	[EMP_email],
	[IMAGEN],
	[EMP_RUTAIMAGEN],
	[EMP_NomImagen],
	[DECIMAL],
	[STORERKEY],
	[USU_UsuarioReg],
	[USU_UsuarioAct],
	[USU_FechaReg],
	[USU_FechaAct]
FROM
	[SGT_EMPRESA]
WHERE
	[EMP_Codigo] = @EMP_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_LOGTRANSACCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[SGTS_LOGTRANSACCION_Insertar]
@USR_ID varchar(15),
@OPC_ID int,
@ACC_ID int,
@LOG_IP varchar(20),
@err int output

/***************************************
*Descripcion: Registrar la transaccion
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Alberto MacLead 	
***************************************/
as
	set @err = 0

	if @OPC_ID=-1 
	begin
		insert into SGT_LOG_TRANSACCION 
			(USU_CODIGO,OPC_Codigo,ACC_Codigo,LOG_FechaHora,LOG_IP)
		values	(@USR_ID,null,@ACC_ID,getdate(),@LOG_IP)
	end
	else
		insert into SGT_LOG_TRANSACCION 
			(USU_CODIGO,OPC_Codigo,ACC_Codigo,LOG_FechaHora,LOG_IP)
		values	(@USR_ID,@OPC_ID,@ACC_ID,getdate(),@LOG_IP)

	
	if(@@error<>0)
	begin
		set @err=1
	end 

print @err






GO
/****** Object:  StoredProcedure [dbo].[SGTS_MENUObtenerMenusHijosbyUser]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************************
*Descripcion: Obtener Menu Hijos
*Fecha Crea: 20/09/2006
*Fecha Modif: 15/01/2007
*Parametros: 
*				
*Autor:	Alberto MacLead 	
*Modificado: Lorena Quispe Arratea 
***************************************************/

ALTER PROCEDURE [dbo].[SGTS_MENUObtenerMenusHijosbyUser] --admin,8
@USR_ID varchar(15),
@SIS_ID int

as

IF ( EXISTS (  select * from SGT_USUARIO_PERFIL_OPCION 	   
	       where USU_CODIGO = @USR_ID and
	      	     PER_CODIGO in ( SELECT PER_Codigo 
				     FROM SGT_PERFIL_USUARIO 
				     WHERE USu_Codigo=@USR_ID
				   )
	    )
    )

    BEGIN

--		SELECT distinct UPO.OPC_Codigo,  
--			   OP.OPC_Nombre, 
--			   OP.OPC_Enlace,
--			   OP.OPC_OpcionPadre, 
--			   @USR_ID as USR_ID ,
--			   OP.OPC_Visibilidad
--		  FROM SGT_USUARIO_PERFIL_OPCION UPO  
--	INNER JOIN SGT_OPCION OP
--			ON OP.OPC_Codigo = UPO.OPC_Codigo 
--		   AND UPO.USU_Codigo = @USR_ID
--	INNER JOIN SGT_OPCION_PERFIL OPF
--			ON OPF.OPC_Codigo = OP.OPC_Codigo	
--		   AND OPF.OPC_Codigo = UPO.OPC_Codigo	
--	       AND OPF.PER_Codigo = UPO.PER_Codigo
--	INNER JOIN SGT_PERFIL PF
--	        ON OPF.PER_Codigo = PF.PER_Codigo	
--	       AND PF.PER_Estado = 'A'
--	     WHERE OP.OPC_OpcionPadre = @SIS_ID  
--           AND OP.OPC_Estado='A'  
--	       AND UPO.PER_Codigo in ( SELECT PER_Codigo 
--									 FROM SGT_PERFIL_USUARIO 
--									WHERE USU_Codigo=@USR_ID)
	   
	SELECT distinct OP.OPC_Codigo,  
                     OP.OPC_Nombre, 
                     OP.OPC_Enlace,
                     OP.OPC_OpcionPadre, 
                     @USR_ID as USR_ID ,
                     OP.OPC_Visibilidad
	FROM SGT_OPCION OP INNER JOIN SGT_OPCION_PERFIL OPF ON OP.OPC_Codigo = OPF.OPC_Codigo
	INNER JOIN SGT_PERFIL PF ON PF.PER_Codigo = OPF.PER_Codigo
	INNER JOIN SGT_PERFIL_USUARIO PU ON PU.PER_Codigo = OPF.PER_Codigo
	INNER JOIN SGT_USUARIO_PERFIL_OPCION UPO ON UPO.USU_Codigo = PU.USU_Codigo AND UPO.PER_Codigo = PU.PER_Codigo AND UPO.OPC_Codigo = OP.OPC_Codigo
	WHERE OP.OPC_OpcionPadre = @SIS_ID AND OP.OPC_Estado='A'
	AND PU.USU_Codigo=@USR_ID
	AND PF.PER_Estado = 'A'

    END

ELSE

    BEGIN

--	SELECT distinct OP.OPC_Codigo,  
--		   OP.OPC_Nombre, 
--		   OP.OPC_Enlace,
--		   OP.OPC_OpcionPadre, 
--		   @USR_ID as USR_ID,
--		   OP.OPC_Visibilidad
--	  FROM SGT_OPCION OP		
--	 WHERE OP.OPC_Codigo in (SELECT PO.OPC_Codigo 
--							   FROM SGT_OPCION_PERFIL PO
--							  WHERE PO.PER_Codigo in (SELECT PER_Codigo 
--														FROM SGT_PERFIL_USUARIO 
--													   WHERE USu_Codigo=@USR_ID))
--	   AND OP.OPC_OpcionPadre = @SIS_ID 
--	   AND OP.OPC_Estado='A'   

		SELECT distinct OP.OPC_Codigo,  
                     OP.OPC_Nombre, 
                     OP.OPC_Enlace,
                     OP.OPC_OpcionPadre, 
                     @USR_ID as USR_ID ,
                     OP.OPC_Visibilidad
		FROM SGT_OPCION OP INNER JOIN SGT_OPCION_PERFIL OPF ON OP.OPC_Codigo = OPF.OPC_Codigo
		INNER JOIN SGT_PERFIL PF ON PF.PER_Codigo = OPF.PER_Codigo
		INNER JOIN SGT_PERFIL_USUARIO PU ON PU.PER_Codigo = OPF.PER_Codigo
		WHERE OP.OPC_OpcionPadre = @SIS_ID AND OP.OPC_Estado='A'
		AND PU.USU_Codigo=@USR_ID
		AND PF.PER_Estado = 'A'

    END
GO
/****** Object:  StoredProcedure [dbo].[SGTS_MENUObtenerMenusPadresbyUser]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/***************************************
*Descripcion: Obtener Menu Padres
*Fecha Crea: 20/09/2006
*Fecha Modif: 15/01/2007
*Parametros: 
*				
*Autor:	Alberto MacLead 	
*Modificado: Lorena Quispe Arratea
***************************************/

ALTER PROCEDURE [dbo].[SGTS_MENUObtenerMenusPadresbyUser]
	@USR_ID varchar(15),
	@SIS_ID int
as

IF ( EXISTS (  select * from SGT_USUARIO_PERFIL_OPCION 	   
	       where USU_CODIGO = @USR_ID and
	      	     PER_CODIGO in ( SELECT PER_Codigo 
				     FROM SGT_PERFIL_USUARIO 
				     WHERE USu_Codigo=@USR_ID
				   )
	    )
    )
BEGIN
	SELECT DISTINCT 
            UPO.OPC_Codigo, 
			OP.OPC_Nombre, 
			OP.OPC_Enlace, 
			OP.OPC_OpcionPadre, 
			@USR_ID AS USR_ID, 
			OP.OPC_Visibilidad, 
            dbo.SGT_SISTEMA.SIS_Estado
	FROM    
			dbo.SGT_SISTEMA INNER JOIN
            dbo.SGT_OPCION AS OP ON dbo.SGT_SISTEMA.SIS_Codigo = OP.SIS_Codigo RIGHT OUTER JOIN
            dbo.SGT_USUARIO_PERFIL_OPCION AS UPO ON OP.OPC_Codigo = UPO.OPC_Codigo
	WHERE   
			OP.OPC_OpcionPadre IS NULL and
			OP.OPC_FlagMenu=1 and
			OP.SIS_Codigo = @SIS_ID and 
			OP.OPC_Estado='A'  and  
			UPO.PER_Codigo in ( SELECT PER_Codigo 
				    FROM SGT_PERFIL_USUARIO 
				    WHERE USu_Codigo=@USR_ID
				   )
END
ELSE
BEGIN
	SELECT DISTINCT 
			OPE.OPC_Codigo, 
			OP.OPC_Nombre, 
			OP.OPC_Enlace, 
			OP.OPC_OpcionPadre, 
			OP.OPC_Visibilidad, 
			dbo.SGT_SISTEMA.SIS_Estado
	FROM    
		    dbo.SGT_OPCION_PERFIL AS OPE INNER JOIN
            dbo.SGT_OPCION AS OP ON OP.OPC_Codigo = OPE.OPC_Codigo INNER JOIN
            dbo.SGT_SISTEMA ON OP.SIS_Codigo = dbo.SGT_SISTEMA.SIS_Codigo
	WHERE   (OP.OPC_OpcionPadre is null) and 
			OP.OPC_FlagMenu=1 and		
			(OP.SIS_Codigo = @SIS_ID)  and OP.OPC_Estado='A' 
			and OPE.PER_Codigo in (SELECT PER_Codigo 
							FROM SGT_PERFIL_USUARIO 
							WHERE USU_Codigo=@USR_ID)
END


--[SGTS_MENUObtenerMenusPadresbyUser]'tecnico3',2
--select * from sgt_opcion_perfil where per_codigo=2












GO
/****** Object:  StoredProcedure [dbo].[SGTS_OPCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_OPCION_Actualizar] (
	@OPC_Codigo int,
	@OPC_Nombre varchar(100),
	@OPC_Descripcion varchar(250),
	@SIS_Codigo int,
	@OPC_OpcionPadre int,
	@OPC_Enlace varchar(250),
	@OPC_Estado char(1),
	@OPC_FlagMenu char(1),
	@OPC_Visibilidad bit,
	@OPC_Nivel int,
	@USU_FechaReg datetime,
	@USU_FechaAct datetime
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		OPC_Codigo  : 
*		OPC_Nombre  : 
*		OPC_Descripcion  : 
*		SIS_Codigo  : 
*		OPC_OpcionPadre  : 
*		OPC_Enlace  : 
*		OPC_Estado  : 
*		OPC_FlagMenu  : 
*		OPC_Visibilidad  : 
*		OPC_Nivel  : 
*		USU_FechaReg  : 
*		USU_FechaAct  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_OPCION]
SET
	[OPC_Nombre] = @OPC_Nombre,
	[OPC_Descripcion] = @OPC_Descripcion,
	[SIS_Codigo] = @SIS_Codigo,
	[OPC_OpcionPadre] = @OPC_OpcionPadre,
	[OPC_Enlace] = @OPC_Enlace,
	[OPC_Estado] = @OPC_Estado,
	[OPC_FlagMenu] = @OPC_FlagMenu,
	[OPC_Visibilidad] = @OPC_Visibilidad,
	[OPC_Nivel] = @OPC_Nivel,
	[USU_FechaReg] = @USU_FechaReg,
	[USU_FechaAct] = @USU_FechaAct
WHERE
	 [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_OPCION_Eliminar] (
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_OPCION]
WHERE
	[OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_OPCION_Insertar] (
	@OPC_Codigo int OUTPUT,
	@OPC_Nombre varchar(100),
	@OPC_Descripcion varchar(250),
	@SIS_Codigo int,
	@OPC_OpcionPadre int,
	@OPC_Enlace varchar(250),
	@OPC_Estado char(1),
	@OPC_FlagMenu char(1),
	@OPC_Visibilidad bit,
	@OPC_Nivel int,
	@USU_FechaReg datetime,
	@USU_FechaAct datetime
)

AS
/*********************************
*Descripcion : Inserta un Registro de la Tabla SGT_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		OPC_Codigo  : 
*		OPC_Nombre  : 
*		OPC_Descripcion  : 
*		SIS_Codigo  : 
*		OPC_OpcionPadre  : 
*		OPC_Enlace  : 
*		OPC_Estado  : 
*		OPC_FlagMenu  : 
*		OPC_Visibilidad  : 
*		OPC_Nivel  : 
*		USU_FechaReg  : 
*		USU_FechaAct  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

INSERT INTO [SGT_OPCION] (
	[OPC_Nombre],
	[OPC_Descripcion],
	[SIS_Codigo],
	[OPC_OpcionPadre],
	[OPC_Enlace],
	[OPC_Estado],
	[OPC_FlagMenu],
	[OPC_Visibilidad],
	[OPC_Nivel],
	[USU_FechaReg],
	[USU_FechaAct]
) VALUES (
	@OPC_Nombre,
	@OPC_Descripcion,
	@SIS_Codigo,
	@OPC_OpcionPadre,
	@OPC_Enlace,
	@OPC_Estado,
	@OPC_FlagMenu,
	@OPC_Visibilidad,
	@OPC_Nivel,
	@USU_FechaReg,
	@USU_FechaAct
)

SET @OPC_Codigo = SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[SGTS_OPCION_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_OPCION_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[OPC_Codigo],
	[OPC_Nombre],
	[OPC_Descripcion],
	[SIS_Codigo],
	[OPC_OpcionPadre],
	[OPC_Enlace],
	[OPC_Estado],
	[OPC_FlagMenu],
	[OPC_Visibilidad],
	[OPC_Nivel],
	[USU_FechaReg],
	[USU_FechaAct]
FROM
	[SGT_OPCION]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_OPCION_Seleccionar] (
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[OPC_Codigo],
	[OPC_Nombre],
	[OPC_Descripcion],
	[SIS_Codigo],
	[OPC_OpcionPadre],
	[OPC_Enlace],
	[OPC_Estado],
	[OPC_FlagMenu],
	[OPC_Visibilidad],
	[OPC_Nivel],
	[USU_FechaReg],
	[USU_FechaAct]
FROM
	[SGT_OPCION]
WHERE
	[OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_Reporte_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[SGTS_Reporte_Insertar]	
	@REP_Name varchar(100),
    @REP_Url varchar(500),
    @REP_Parameter char(1),
    @REP_Descripcion varchar(100),
    @REP_Estado char(1),
    @CAT_Codigo int,
    @SIS_Codigo int,
    @USU_UsuarioReg varchar(15),   
    @USU_FechaReg datetime,
	@REP_Exportable char(1),
	@REP_Prompt char(1)   
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_REPORT
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON


		INSERT INTO [WMSCUSSEG].[dbo].[SGT_REPORT]
				   ([REP_Name],
					[REP_Url],
					[REP_Parameter],
					[REP_Descripcion],
					[REP_Estado],
					[CAT_Codigo],
					[SIS_Codigo],
					[USU_UsuarioReg],
					[USU_FechaReg],
				    [REP_Exportable],
					[REP_Prompt]
				   )
			 VALUES
				   (@REP_Name
				   ,@REP_Url
				   ,@REP_Parameter
				   ,@REP_Descripcion
				   ,@REP_Estado
				   ,@CAT_Codigo
				   ,@SIS_Codigo
				   ,@USU_UsuarioReg           
				   ,@USU_FechaReg
				   ,@REP_Exportable
				   ,@REP_Prompt)








GO
/****** Object:  StoredProcedure [dbo].[SGTS_Reporte_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SGTS_Reporte_Listar]
	@REP_NAME varchar(100),
	@CAT_Codigo int,
	@SIS_Codigo int,
    @USU_Codigo varchar(15)
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_REPORT
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

if @REP_NAME is null and @CAT_Codigo = 0

	BEGIN

	  SELECT r.[REP_Codigo],
			 r.[REP_Name] as REP_Nombre,
			 r.[REP_Url] ,
			 r.[REP_Parameter] as REP_Parametros,
			 c.[CAT_Nombre] as REP_Category,
			 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
			 r.[REP_prompt],
			 r.[USU_UsuarioReg],
			 r.[USU_UsuarioAct],
			 r.[USU_FechaReg],
			 r.[USU_FechaAct]
		FROM [SGT_REPORT] r 
  inner join [SGT_REPORT_CATEGORIA] c
		  ON r.[CAT_Codigo] = c.[CAT_Codigo]      
  		 AND r.[SIS_Codigo] = @SIS_Codigo
		 AND r.[REP_Estado] = 'A'
  inner join [SGT_PERFILREPORTE_REPORT] pr
		  ON pr.[REP_Codigo] = r.[REP_Codigo]	  
		 AND pr.[RPR_Estado] = 'A'
  inner join [SGT_PERFILREPORTE_USUARIO] p
          ON P.[USU_Codigo] = @USU_Codigo
		 AND p.[PFR_CODIGO] = pr.[PFR_CODIGO]      
  		 



	END

ELSE

	BEGIN

	IF @CAT_Codigo = 0 
		BEGIN

		 SELECT r.[REP_Codigo],
				 r.[REP_Name] as REP_Nombre,
				 r.[REP_Url] ,
				 r.[REP_Parameter] as REP_Parametros,
				 c.[CAT_Nombre] as REP_Category,
				 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
				 r.[REP_prompt],
				 r.[USU_UsuarioReg],
				 r.[USU_UsuarioAct],
				 r.[USU_FechaReg],
				 r.[USU_FechaAct]		
			FROM [SGT_REPORT] r 
	  inner join [SGT_REPORT_CATEGORIA] c
			  ON r.[CAT_Codigo] = c.[CAT_Codigo] 
	  inner join [SGT_PERFILREPORTE_REPORT] pr
			  ON pr.[REP_Codigo] = r.[REP_Codigo]	  
			 AND pr.[RPR_Estado] = 'A'
	  inner join [SGT_PERFILREPORTE_USUARIO] pu
		      ON pu.[USU_Codigo] = @USU_Codigo
			 AND pu.[PFR_CODIGO] = pr.[PFR_CODIGO] 	  
		   WHERE r.[REP_Name] LIKE '%'+ isnull(@REP_NAME,'') +'%'             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
		     AND r.[REP_Estado] = 'A'
			
		END    

	ELSE

		BEGIN
			
		  SELECT r.[REP_Codigo],
				 r.[REP_Name] as REP_Nombre,
				 r.[REP_Url] ,
				 r.[REP_Parameter] as REP_Parametros,
				 c.[CAT_Nombre] as REP_Category,
				 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
				 r.[REP_prompt],
				 r.[USU_UsuarioReg],
				 r.[USU_UsuarioAct],
				 r.[USU_FechaReg],
				 r.[USU_FechaAct]		
			FROM [SGT_REPORT] r 
	  inner join [SGT_REPORT_CATEGORIA] c
			  ON r.[CAT_Codigo] = c.[CAT_Codigo] 
	  inner join [SGT_PERFILREPORTE_REPORT] pr
			  ON pr.[REP_Codigo] = r.[REP_Codigo]	  
			 AND pr.[RPR_Estado] = 'A'
	  inner join [SGT_PERFILREPORTE_USUARIO] pu
		      ON pu.[USU_Codigo] = @USU_Codigo
			 AND pu.[PFR_CODIGO] = pr.[PFR_CODIGO]    
		   WHERE r.[REP_Name] LIKE '%'+ isnull(@REP_NAME,'') +'%'
			 AND r.[CAT_Codigo] = @CAT_Codigo             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
			 AND r.[REP_Estado] = 'A'
		 
		END    

	END




   






GO
/****** Object:  StoredProcedure [dbo].[SGTS_Reporte_Listartodos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[SGTS_Reporte_Listartodos]
	@REP_NAME varchar(100),
	@CAT_Codigo int,
	@SIS_Codigo int,
    @USU_Codigo varchar(15),
	@REP_ESTADO varchar(1)
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_REPORT
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

if @REP_NAME is null and @CAT_Codigo = 0

	BEGIN

	  SELECT r.[REP_Codigo],
			 r.[REP_Name] as REP_Nombre,
			 r.[REP_Url] ,
			 r.[REP_Parameter] as REP_Parametros,
			 c.[CAT_Nombre] as REP_Category,
			 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
			 r.[USU_UsuarioReg],
			 r.[USU_UsuarioAct],
			 r.[USU_FechaReg],
			 r.[USU_FechaAct]		
		FROM [SGT_REPORT] r 
  inner join [SGT_REPORT_CATEGORIA] c
		  ON r.[CAT_Codigo] = c.[CAT_Codigo]      
  		 AND r.[SIS_Codigo] = @SIS_Codigo
		 
  		 



	END

ELSE

	BEGIN

	IF @CAT_Codigo = 0 
		BEGIN

		 SELECT r.[REP_Codigo],
				 r.[REP_Name] as REP_Nombre,
				 r.[REP_Url] ,
				 r.[REP_Parameter] as REP_Parametros,
				 c.[CAT_Nombre] as REP_Category,
				 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
				 r.[USU_UsuarioReg],
				 r.[USU_UsuarioAct],
				 r.[USU_FechaReg],
				 r.[USU_FechaAct]		
			FROM [SGT_REPORT] r 
	  inner join [SGT_REPORT_CATEGORIA] c
			  ON r.[CAT_Codigo] = c.[CAT_Codigo] 	
		   WHERE r.[REP_Name] LIKE '%'+ isnull(@REP_NAME,'') +'%'             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
		     
			
		END    

	ELSE

		BEGIN
			
		  SELECT r.[REP_Codigo],
				 r.[REP_Name] as REP_Nombre,
				 r.[REP_Url] ,
				 r.[REP_Parameter] as REP_Parametros,
				 c.[CAT_Nombre] as REP_Category,
				 case when r.[REP_Estado] = 'A' then 'Activo' else 'Inactivo' end [REP_Estado],
				 r.[USU_UsuarioReg],
				 r.[USU_UsuarioAct],
				 r.[USU_FechaReg],
				 r.[USU_FechaAct]		
			FROM [SGT_REPORT] r 
	  inner join [SGT_REPORT_CATEGORIA] c
			  ON r.[CAT_Codigo] = c.[CAT_Codigo] 	  
		   WHERE r.[REP_Name] LIKE '%'+ isnull(@REP_NAME,'') +'%'
			 AND r.[CAT_Codigo] = @CAT_Codigo             
	  		 AND r.[SIS_Codigo] = @SIS_Codigo
			 
		 
		END    

	END




   






GO
/****** Object:  StoredProcedure [dbo].[SGTS_Reporte_ListarxSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





 ALTER PROCEDURE [dbo].[SGTS_Reporte_ListarxSistema]	
	@SIS_Codigo int
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_REPORT
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON



	BEGIN

SELECT   r.[REP_Codigo] as REP_Codigo,
		 r.[REP_Name] as REP_Nombre,			 			 
		 r.[REP_Descripcion] as REP_Descripcion,	
		 r.[USU_UsuarioReg],
		 r.[USU_UsuarioAct],
		 r.[USU_FechaReg],
		 r.[USU_FechaAct]

		FROM [SGT_REPORT] r 
  inner join [SGT_REPORT_CATEGORIA] c
		  ON r.[CAT_Codigo] = c.[CAT_Codigo]      
  		  AND r.[SIS_Codigo] = @SIS_Codigo
		  



	END

   






GO
/****** Object:  StoredProcedure [dbo].[SGTS_Reporte_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[SGTS_Reporte_Seleccionar] (
	@REP_Codigo varchar(15)
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_EMPRESA
*Fecha Crea  : 10/11/2009
*Fecha Mod   : 
*Parametros  : 
*		REP_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON


SELECT
	[REP_Codigo],
	[REP_Name] as REP_Nombre,
	[REP_Url] ,
	[REP_Parameter] as REP_Parametros,
	[CAT_Codigo] as REP_Category,
	[REP_Estado] ,
	[REP_Prompt],
	[USU_UsuarioReg],
	[USU_UsuarioAct],
	[USU_FechaReg],
	[USU_FechaAct],
	[REP_Exportable]
FROM
	[SGT_REPORT]
WHERE
	[REP_Codigo] = @REP_Codigo


GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_Actualizar] (
	@n_id_schema int,
	@v_descripcion_schema varchar(50),
	@v_schema varchar(10),
	@v_usuario_creacion varchar(15)
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_SCHEMAS
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*		v_descripcion_schema  : 
*		v_schema
*		v_usuario_creacion  : 
*		d_fecha_creacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_SCHEMAS]
SET
	[v_descripcion_schema] = @v_descripcion_schema,
	[v_schema]= @v_schema,
	[v_usuario_creacion] = @v_usuario_creacion,
	[d_fecha_creacion] = getdate()
WHERE
	 [n_id_schema] = @n_id_schema

GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_Eliminar] (
	@n_id_schema int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_SCHEMAS
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_SCHEMAS]
WHERE
	[n_id_schema] = @n_id_schema

GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_Actualizar] (
	@n_id_schema int,
	@EMP_Codigo int,
	@v_usuario_creacion varchar(15),
	@d_fecha_creacion datetime
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*		EMP_Codigo  : 
*		v_usuario_creacion  : 
*		d_fecha_creacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_SCHEMAS_EMPRESA]
SET
	[v_usuario_creacion] = @v_usuario_creacion,
	[d_fecha_creacion] = @d_fecha_creacion
WHERE
	 [n_id_schema] = @n_id_schema	AND [EMP_Codigo] = @EMP_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_Eliminar] (
	@n_id_schema int,
	@EMP_Codigo int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*		EMP_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_SCHEMAS_EMPRESA]
WHERE
	[n_id_schema] = @n_id_schema
	AND [EMP_Codigo] = @EMP_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec SGTS_SCHEMAS_EMPRESA_Insertar @n_id_schema=3,@EMP_Codigo=2,@v_usuario_creacion='Admin'
exec SGTS_SCHEMAS_EMPRESA_Insertar @n_id_schema=1,@EMP_Codigo=2,@v_usuario_creacion='Admin'
*/
ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_Insertar] (
	@n_id_schema int,
	@EMP_Codigo int,
	@v_usuario_creacion varchar(15)
)

AS
/*********************************
*Descripcion : Inserta un Registro de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*		EMP_Codigo  : 
*		v_usuario_creacion  : 
*		d_fecha_creacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON


If Not Exists 
		(
		Select 
			* 
		From  
			SGT_SCHEMAS_EMPRESA 
		Where 
			n_id_schema = @n_id_schema And EMP_Codigo = @EMP_Codigo 
		)
Begin 
		INSERT INTO [SGT_SCHEMAS_EMPRESA] (
			[n_id_schema],
			[EMP_Codigo],
			[v_usuario_creacion],
			[d_fecha_creacion]
		) VALUES (
			@n_id_schema,
			@EMP_Codigo,
			@v_usuario_creacion,
			getdate() 
		)
End 
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[n_id_schema],
	[EMP_Codigo],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_SCHEMAS_EMPRESA]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_ListarBuscar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [SGTS_SCHEMAS_EMPRESA_ListarBuscar] 3

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_ListarBuscar]
@EMP_Codigo int = null 
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	S.n_id_schema , 
	s.v_schema,
	S.v_descripcion_schema ,
	Se.[EMP_Codigo] , 
	E.EMP_Nombre 
FROM
	[SGT_SCHEMAS_EMPRESA] SE Inner Join dbo.SGT_SCHEMAS S
	On S.n_id_schema = se.n_id_schema Inner Join SGT_EMPRESA E 
	On E.EMP_Codigo = SE.EMP_Codigo
Where 
	SE.EMP_Codigo = @EMP_Codigo



GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_EMPRESA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_EMPRESA_Seleccionar] (
	@n_id_schema int,
	@EMP_Codigo int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_SCHEMAS_EMPRESA
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*		EMP_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[n_id_schema],
	[EMP_Codigo],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_SCHEMAS_EMPRESA]
WHERE
	[n_id_schema] = @n_id_schema
	AND [EMP_Codigo] = @EMP_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_Insertar] (    
 @v_descripcion_schema varchar(50), 
 @v_schema varchar(10), 
 @v_usuario_creacion varchar(15)
)  
  
AS  
/*********************************  
*Descripcion : Inserta un Registro de la Tabla SGT_SCHEMAS  
*Fecha Crea  : 28/10/2009  
*Fecha Mod   :   
*Parametros  :   
*  n_id_schema  :   
*  v_descripcion_schema  :
*  v_schema:   
*  v_usuario_creacion  :   
*  d_fecha_creacion  :   
*Autor       :   
*********************************/  
  
SET NOCOUNT ON  
  
INSERT INTO [SGT_SCHEMAS] (   
 [v_descripcion_schema],
 [v_schema],  
 [v_usuario_creacion],  
 [d_fecha_creacion]  
) VALUES (    
 @v_descripcion_schema,  
 @v_schema,
 @v_usuario_creacion,  
 getdate() 
)  
GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_SCHEMAS
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[n_id_schema],
	[v_descripcion_schema],
	[v_schema],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_SCHEMAS]

GO
/****** Object:  StoredProcedure [dbo].[SGTS_SCHEMAS_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGTS_SCHEMAS_Seleccionar] (
	@n_id_schema int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_SCHEMAS
*Fecha Crea  : 28/10/2009
*Fecha Mod   : 
*Parametros  : 
*		n_id_schema  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[n_id_schema],
	[v_descripcion_schema],
	[v_schema],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_SCHEMAS]
WHERE
	[n_id_schema] = @n_id_schema

GO
/****** Object:  StoredProcedure [dbo].[SGTS_URL_RetornarOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[SGTS_URL_RetornarOpcion]
@url as varchar(100),
@opcion as int output
 AS
select @opcion=opc_codigo from sgt_opcion where opc_enlace=@url




GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_AccesoOpcion]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_AccesoOpcion] 
@usuario varchar(15),
@opcion int
AS
select 
		count(*) 
from 
		sgt_opcion o, sgt_opcion_perfil op, sgt_perfil_usuario up
where 
		up.usu_codigo=@usuario and  
		up.per_codigo=op.per_codigo and   
		op.opc_codigo=o.opc_codigo and 
		o.opc_codigo=@opcion







GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_AccesoSistema]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_AccesoSistema] 
@usuario varchar(15),
@sistema int,
@ValorActivo	varchar(50)
AS

begin

SET NOCOUNT ON

select case when sis_estado=@ValorActivo then 1 else 0 end as Result from sgt_sistema
where sis_codigo=@sistema

end
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION]
	@usuario varchar(15),
	@opcion int
 AS
--SELECCIONA LAS ACCIONES ASIGNADAS A UNA OPCION
	SELECT 	
		UAO.[ACC_CODIGO],
		A.[ACC_NOMBRE]
	FROM	
		SGT_USUARIO_ACCION_OPCION UAO
		INNER JOIN  SGT_ACCION A
		ON UAO.ACC_CODIGO=A.ACC_CODIGO and
		   A.ACC_ESTADO='A'
	WHERE	
		UAO.USU_CODIGO=@usuario and
		UAO.OPC_CODIGO=@opcion

--SELECCIONA LAS ACCIONES ASIGNADAS A UNA OPCION POR USUARIO
	SELECT  
		AO.ACC_CODIGO,
		A.ACC_NOMBRE		
	FROM	
		SGT_ACCION_OPCION AO
		inner join SGT_ACCION A	
		on AO.ACC_CODIGO =A.ACC_CODIGO  and
		   A.ACC_ESTADO = 'A'
	WHERE
		AO.OPC_CODIGO=@opcion
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION_Actualizar] (
	@USU_Codigo varchar(15),
	@ACC_Codigo int,
	@OPC_Codigo int,
	@UAO_FechaRegistro smalldatetime,
	@UAO_FechaActualizacion smalldatetime
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_USUARIO_ACCION_OPCION
*Fecha Crea  : 03/11/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		ACC_Codigo  : 
*		OPC_Codigo  : 
*		UAO_FechaRegistro  : 
*		UAO_FechaActualizacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_USUARIO_ACCION_OPCION]
SET
	[UAO_FechaRegistro] = @UAO_FechaRegistro,
	[UAO_FechaActualizacion] = @UAO_FechaActualizacion
WHERE
	 [USU_Codigo] = @USU_Codigo	AND [ACC_Codigo] = @ACC_Codigo	AND [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION_Eliminar] (
	@USU_Codigo varchar(15),
	@ACC_Codigo int,
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_USUARIO_ACCION_OPCION
*Fecha Crea  : 03/11/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		ACC_Codigo  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_ACCION_OPCION]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [ACC_Codigo] = @ACC_Codigo
	AND [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION_Insertar] (
	@USU_Codigo varchar(15),
	@ACC_Codigo int,
	@OPC_Codigo int,
	@UAO_FechaRegistro smalldatetime,
	@UAO_FechaActualizacion smalldatetime
)

AS
/*********************************
*Descripcion : Inserta un Registro de la Tabla SGT_USUARIO_ACCION_OPCION
*Fecha Crea  : 03/11/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		ACC_Codigo  : 
*		OPC_Codigo  : 
*		UAO_FechaRegistro  : 
*		UAO_FechaActualizacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

INSERT INTO [SGT_USUARIO_ACCION_OPCION] (
	[USU_Codigo],
	[ACC_Codigo],
	[OPC_Codigo],
	[UAO_FechaRegistro],
	[UAO_FechaActualizacion]
) VALUES (
	@USU_Codigo,
	@ACC_Codigo,
	@OPC_Codigo,
	@UAO_FechaRegistro,
	@UAO_FechaActualizacion
)
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_USUARIO_ACCION_OPCION
*Fecha Crea  : 03/11/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[ACC_Codigo],
	[OPC_Codigo],
	[UAO_FechaRegistro],
	[UAO_FechaActualizacion]
FROM
	[SGT_USUARIO_ACCION_OPCION]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ACCION_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SGTS_USUARIO_ACCION_OPCION_Seleccionar] (
	@USU_Codigo varchar(15),
	@ACC_Codigo int,
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_USUARIO_ACCION_OPCION
*Fecha Crea  : 03/11/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		ACC_Codigo  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[ACC_Codigo],
	[OPC_Codigo],
	[UAO_FechaRegistro],
	[UAO_FechaActualizacion]
FROM
	[SGT_USUARIO_ACCION_OPCION]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [ACC_Codigo] = @ACC_Codigo
	AND [OPC_Codigo] = @OPC_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_ActualizarLogueado]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/***************************************
*Descripcion: Actualizar el estado de logueado del usuario
*Fecha Crea: 13/03/2008
*Parametros: 
*				
*Autor:	Lorena Quispe	
***************************************/

ALTER PROCEDURE [dbo].[SGTS_USUARIO_ActualizarLogueado]
@USU_Codigo varchar(15),
@USU_Contraseña varchar(2000),
@USU_Logueado bit

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

UPDATE	SGT_USUARIO
SET		[USU_Logeado] = @USU_Logueado
WHERE 	[USU_Codigo] = @USU_Codigo
 		AND [USU_Contraseña] = @USU_Contraseña











GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_CambioPassword]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[SGTS_USUARIO_CambioPassword] 

@login varchar(15),
@password varchar(400),
@nuevopass varchar(2000),
@actualizado varchar(1)  output

/***************************************
*Descripcion: CAMBIO de Clave
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Alberto MacLead 	
***************************************/
AS

if exists (select * from SGT_USUARIO where ltrim(rtrim(USU_Codigo))=@Login AND ltrim(rtrim(USU_Contraseña))=@password) 
begin
--	print 'entro'
	update SGT_USUARIO
	set USU_Contraseña=@nuevopass
	where 	USU_Codigo=@Login
		AND USU_Contraseña=@password

	set @actualizado='0'
end
else
begin
--	print 'no entro'
	set @actualizado='1'
end

print @actualizado






GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_Actualizar] (
	@EMP_Codigo int,
	@USU_Codigo varchar(5),
	@v_usuario_creacion varchar(30)
	
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*		USU_Codigo  : 
*		v_usuario_creacion  : 
*		d_fecha_creacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_USUARIO_EMPRESA]
SET
	[v_usuario_creacion] = @v_usuario_creacion
WHERE
	 [EMP_Codigo] = @EMP_Codigo	AND [USU_Codigo] = @USU_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec SGTS_USUARIO_EMPRESA_Eliminar @EMP_Codigo=3,@USU_Codigo='jcarr'

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_Eliminar] (
	@EMP_Codigo int,
	@USU_Codigo varchar(30)
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*		USU_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_EMPRESA]
WHERE
	[EMP_Codigo] = @EMP_Codigo  AND 
	[USU_Codigo] = @USU_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_Insertar] (
	@EMP_Codigo int,
	@USU_Codigo varchar(30),
	@v_usuario_creacion varchar(30)
)

AS
/*********************************
*Descripcion : Inserta un Registro de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*		USU_Codigo  : 
*		v_usuario_creacion  : 
*		d_fecha_creacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

If 
	Not Exists
	( 
		Select 
				emp_codigo 
		From 
				[SGT_USUARIO_EMPRESA] 
		Where 
				emp_codigo = @EMP_Codigo And USU_Codigo = @USU_Codigo
	)
Begin 
	INSERT INTO [SGT_USUARIO_EMPRESA] (
		[EMP_Codigo],
		[USU_Codigo],
		[v_usuario_creacion],
		[d_fecha_creacion]
	) VALUES (
		@EMP_Codigo,
		@USU_Codigo,
		@v_usuario_creacion,
		getdate() 
	)
End 

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[EMP_Codigo],
	[USU_Codigo],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_USUARIO_EMPRESA]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_ListarBuscar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [SGTS_USUARIO_EMPRESA_ListarBuscar] 'iprincipe'

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_ListarBuscar]
@USU_Codigo varchar(30)
AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	E.[EMP_Codigo],
	E.EMP_Nombre ,
	U.[USU_Codigo] , 
	'USU_Nombre' = u.USU_Paterno + ' '+ u.USU_Materno + ',' + U.USU_Nombres 
FROM
	[SGT_USUARIO_EMPRESA] UE Inner Join dbo.SGT_USUARIO U 
	On UE.USU_Codigo = U.USU_Codigo Inner Join dbo.SGT_EMPRESA E 
	On E.EMP_Codigo = UE.EMP_Codigo
Where 
	UE.USU_Codigo = @USU_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_Seleccionar] (
	@EMP_Codigo int,
	@USU_Codigo varchar(5)
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_USUARIO_EMPRESA
*Fecha Crea  : 29/10/2009
*Fecha Mod   : 
*Parametros  : 
*		EMP_Codigo  : 
*		USU_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[EMP_Codigo],
	[USU_Codigo],
	[v_usuario_creacion],
	[d_fecha_creacion]
FROM
	[SGT_USUARIO_EMPRESA]
WHERE
	[EMP_Codigo] = @EMP_Codigo
	AND [USU_Codigo] = @USU_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Eliminar]
	@USU_Codigo VARCHAR(15)
AS

DELETE FROM SGT_USUARIO_EMPRESA_SUCURSAL_NPT WHERE USU_Codigo = @USU_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Insertar]
	@USU_Codigo VARCHAR(15),
	@NPT_Empresa INT,
	@NPT_Sucursal INT
AS

INSERT INTO SGT_USUARIO_EMPRESA_SUCURSAL_NPT (USU_Codigo,NPT_Empresa,NPT_Sucursal)
VALUES (@USU_Codigo,@NPT_Empresa,@NPT_Sucursal)

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_EMPRESA_SUCURSAL_NPT_Seleccionar]
	@USU_Codigo VARCHAR(15)
AS

SELECT	USU_Codigo, NPT_Empresa IdEmpresa, NPT_Sucursal IdSucursal, 
		EMP.Descripcion DesEmpresa,
		SUC.Descripcion DesSucursal
FROM SGT_USUARIO_EMPRESA_SUCURSAL_NPT SEG
INNER JOIN  dbo.Empresa EMP ON SEG.NPT_Empresa = EMP.IdEmpresa
INNER JOIN  dbo.Sucursal SUC ON SEG.NPT_Sucursal = SUC.IdSucursal
WHERE USU_Codigo = @USU_Codigo

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_Login]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SGTS_USUARIO_Login] --'VGARAY','VGARAY'  
	@vchUsuario VARCHAR(15)
	,@vchPass VARCHAR(2000)
	--@SIS_ID INT,  
	--@EMP_ID INT  
	/***************************************  
*Descripcion: Login  
*Fecha Crea: 20/09/2006  
*Parametros:   
*      
*Autor: Alberto MacLead    
***************************************/
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @ESALMACEN INT

IF EXISTS (
		SELECT sgt_perfil_usuario.PER_Codigo
		FROM sgt_usuario
		INNER JOIN sgt_perfil_usuario ON sgt_usuario.usu_codigo = sgt_perfil_usuario.usu_codigo
			AND (sgt_usuario.USU_Codigo = @vchUsuario)
			AND (sgt_usuario.USU_Contraseña = @vchPass)
			AND (sgt_perfil_usuario.PER_Codigo = 11)
		)
BEGIN
	-- valida login  
	SELECT u.USU_Codigo
		,u.USU_Codigo
		,isnull(USU_Nombres, '') AS USU_Nombres
		,isnull(USU_Paterno, '') AS USU_Paterno
		,isnull(USU_Materno, '') AS USU_Materno
		,USU_Contraseña
		,USU_Estado AS USU_Estado
		,EMP_Codigo
		,USU_Correo
		,[USU_Dominio]
		,Per_Codigo AS [USU_Perfil]
		,[USU_CodigoVendedor]
		,[USU_CodigoTecnico]
		,[USU_Logeado]
		,[USU_Identity]
		,[USU_ClaseUsuario]
		,[USU_RUC]
	FROM SGT_USUARIO u
	INNER JOIN SGT_PERFIL_USUARIO pu ON u.usu_codigo = pu.usu_codigo
	WHERE (u.USU_Codigo = @vchUsuario)
		AND (u.USU_Contraseña = @vchPass)
	ORDER BY Per_Codigo DESC
END
ELSE IF EXISTS (
		SELECT sgt_perfil_usuario.PER_Codigo
		FROM sgt_usuario
		INNER JOIN sgt_perfil_usuario ON sgt_usuario.usu_codigo = sgt_perfil_usuario.usu_codigo
			AND (sgt_usuario.USU_Codigo = @vchUsuario)
			AND (sgt_usuario.USU_Contraseña = @vchPass)
			AND (sgt_perfil_usuario.PER_Codigo = 14)
		)
BEGIN
	-- valida login  
	SELECT u.USU_Codigo
		,u.USU_Codigo
		,isnull(USU_Nombres, '') AS USU_Nombres
		,isnull(USU_Paterno, '') AS USU_Paterno
		,isnull(USU_Materno, '') AS USU_Materno
		,USU_Contraseña
		,USU_Estado AS USU_Estado
		,EMP_Codigo
		,USU_Correo
		,[USU_Dominio]
		,Per_Codigo AS [USU_Perfil]
		,[USU_CodigoVendedor]
		,[USU_CodigoTecnico]
		,[USU_Logeado]
		,[USU_Identity]
		,[USU_ClaseUsuario]
		,[USU_RUC]
	FROM SGT_USUARIO u
	INNER JOIN SGT_PERFIL_USUARIO pu ON u.usu_codigo = pu.usu_codigo
	WHERE (u.USU_Codigo = @vchUsuario)
		AND (u.USU_Contraseña = @vchPass)
		ORDER BY Per_Codigo DESC
END
ELSE
BEGIN
	-- valida login  
	SELECT u.USU_Codigo
		,u.USU_Codigo
		,isnull(USU_Nombres, '') AS USU_Nombres
		,isnull(USU_Paterno, '') AS USU_Paterno
		,isnull(USU_Materno, '') AS USU_Materno
		,USU_Contraseña
		,USU_Estado AS USU_Estado
		,EMP_Codigo
		,USU_Correo
		,[USU_Dominio]
		,Per_Codigo AS [USU_Perfil]
		,[USU_CodigoVendedor]
		,[USU_CodigoTecnico]
		,[USU_Logeado]
		,[USU_Identity]
		,[USU_ClaseUsuario]
		,[USU_RUC]
	FROM SGT_USUARIO u
	INNER JOIN SGT_PERFIL_USUARIO pu ON u.usu_codigo = pu.usu_codigo
	WHERE (u.USU_Codigo = @vchUsuario)
		AND (u.USU_Contraseña = @vchPass)
		ORDER BY Per_Codigo DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_LoginWindows]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[SGTS_USUARIO_LoginWindows]

@vchUsuario varchar(100)

/***************************************
*Descripcion: Login
*Fecha Crea:02/10/2006
*Parametros: 
*				
*Autor:	Alberto MacLead 	
***************************************/

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

-- valida login
select 	USU_Codigo,
	USU_Codigo,
	isnull(USU_Nombres,'') as USU_Nombres,
	isnull(USU_Paterno,'') as USU_Paterno,
	isnull(USU_Materno,'') as USU_Materno,
	USU_Contraseña ,
	USU_Estado	       as USU_Estado,
	EMP_Codigo,
	USU_Correo

from 	SGT_USUARIO 
where 	USU_Codigo=@vchUsuario





GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_Perfil]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[SGTS_USUARIO_Perfil]

@perfil as int,
@usuario as varchar(20) = null
/***************************************
*Descripcion: Login
*Fecha Crea: 20/10/2006
*Parametros: 
*				
*Autor:	Alberto Mac Leod 	
***************************************/

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

-- valida login
select distinct PER.PER_Codigo,USU.USU_Codigo as Usuario,
(USU.USU_Nombres+' '+USU.USU_Paterno+' '+USU.USU_Materno)as NombresCompletos,
USU.USU_Correo as Mail from SGT_USUARIO USU,SGT_Perfil_Usuario PER 
where   USU.USU_Estado='A' and 
	USU.USU_Codigo=PER.USU_Codigo and 
	PER_Codigo=@perfil and ((USU_Nombres +' '+ USU_Paterno + ' ' + USU_Materno LIKE coalesce (@usuario,USU_Nombres)+ '%')
	 or (USU_Nombres LIKE coalesce (@usuario,USU_Nombres)+ '%')
	 or(USU_Paterno LIKE coalesce (@usuario,USU_Paterno)+ '%') or (USU_Materno LIKE coalesce (@usuario,USU_Materno)+ '%'))
order by   NombresCompletos








GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_PERFIL_OPCION_Actualizar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_PERFIL_OPCION_Actualizar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int,
	@OPC_Codigo int,
	@UPO_FechaRegistro smalldatetime,
	@UPO_FechaActualizacion smalldatetime
)

AS
/*********************************
*Descripcion : Actualiza un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		PER_Codigo  : 
*		OPC_Codigo  : 
*		UPO_FechaRegistro  : 
*		UPO_FechaActualizacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

UPDATE
	[SGT_USUARIO_PERFIL_OPCION]
SET
	[UPO_FechaRegistro] = @UPO_FechaRegistro,
	[UPO_FechaActualizacion] = @UPO_FechaActualizacion
WHERE
	 [USU_Codigo] = @USU_Codigo	AND [PER_Codigo] = @PER_Codigo	AND [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_PERFIL_OPCION_Eliminar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_PERFIL_OPCION_Eliminar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int,
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Elimina un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		PER_Codigo  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

DELETE FROM
	[SGT_USUARIO_PERFIL_OPCION]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [PER_Codigo] = @PER_Codigo
	AND [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_PERFIL_OPCION_Insertar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_PERFIL_OPCION_Insertar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int,
	@OPC_Codigo int,
	@UPO_FechaRegistro smalldatetime,
	@UPO_FechaActualizacion smalldatetime
)

AS
/*********************************
*Descripcion : Inserta un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		PER_Codigo  : 
*		OPC_Codigo  : 
*		UPO_FechaRegistro  : 
*		UPO_FechaActualizacion  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

INSERT INTO [SGT_USUARIO_PERFIL_OPCION] (
	[USU_Codigo],
	[PER_Codigo],
	[OPC_Codigo],
	[UPO_FechaRegistro],
	[UPO_FechaActualizacion]
) VALUES (
	@USU_Codigo,
	@PER_Codigo,
	@OPC_Codigo,
	@UPO_FechaRegistro,
	@UPO_FechaActualizacion
)
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_PERFIL_OPCION_Listar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_PERFIL_OPCION_Listar]

AS
/*********************************
*Descripcion : Lista Todos los Registros de la Tabla SGT_USUARIO_PERFIL_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[PER_Codigo],
	[OPC_Codigo],
	[UPO_FechaRegistro],
	[UPO_FechaActualizacion]
FROM
	[SGT_USUARIO_PERFIL_OPCION]
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_PERFIL_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SGTS_USUARIO_PERFIL_OPCION_Seleccionar] (
	@USU_Codigo varchar(15),
	@PER_Codigo int,
	@OPC_Codigo int
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION
*Fecha Crea  : 30/10/2009
*Fecha Mod   : 
*Parametros  : 
*		USU_Codigo  : 
*		PER_Codigo  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT
	[USU_Codigo],
	[PER_Codigo],
	[OPC_Codigo],
	[UPO_FechaRegistro],
	[UPO_FechaActualizacion]
FROM
	[SGT_USUARIO_PERFIL_OPCION]
WHERE
	[USU_Codigo] = @USU_Codigo
	AND [PER_Codigo] = @PER_Codigo
	AND [OPC_Codigo] = @OPC_Codigo
GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_RetornarDatos]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/***************************************
*Descripcion: Retorna los Datos del usuario
*Fecha Crea: 05/01/2007
*Parametros: codigo de usuario.
*				
*Autor:	Lorena Qusipe 	
***************************************/
ALTER PROCEDURE [dbo].[SGTS_USUARIO_RetornarDatos]
@USU_Codigo varchar(15)

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

select 	USU_Codigo		as  USU_Codigo,	
	isnull(USU_Nombres,'') 	as USU_Nombres,
	isnull(USU_Paterno,'')  	as USU_Paterno,
	isnull(USU_Materno,'') 	as USU_Materno,
	USU_NumDocumento	as USU_DNI,
	DOC_Codigo		as DOC_Codigo,
	USU_Contraseña 	as USU_Contraseña,
	USU_Estado	        	as USU_Estado,
	EMP_Codigo		as EMP_Codigo, 
	USU_Correo		as USU_Correo,
	USU_FechaRetiro	as USU_FechaRetiro

from 	SGT_USUARIO 
where 	(USU_Codigo=@USU_Codigo)



GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_RetornarMail]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[SGTS_USUARIO_RetornarMail]

@usuario varchar(30),
@Mail varchar(100) output
/***************************************
*Descripcion: Login
*Fecha Crea: 20/10/2006
*Parametros: 
*				
*Autor:	Alberto Mac Leod 	
***************************************/

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

-- valida login
select @Mail= Rtrim(USU_Correo)  from SGT_USUARIO  where USU_Codigo=@usuario





GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_RetornarNombres]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/***************************************
*Descripcion: Login
*Fecha Crea: 20/10/2006
*Parametros: 
*				
*Autor:	Alberto Mac Leod 	
***************************************/

ALTER PROCEDURE [dbo].[SGTS_USUARIO_RetornarNombres]

@usuario varchar(30),
@Nombres varchar(100) output

AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

	SELECT	@Nombres = (USU_Nombres+' '+USU_Paterno+' '+USU_Materno)
	FROM 	SGT_USUARIO 
	WHERE 	USU_Codigo=@usuario
 





GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_RetornarPerfiles]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[SGTS_USUARIO_RetornarPerfiles]
@usuario varchar(15),
@sistema int
 AS

select distinct pu.PER_Codigo,P.Per_Nombre 
      from sgt_perfil_usuario pu 
inner join sgt_perfil p
		on p.PER_Codigo = pu.PER_Codigo
 where pu.Usu_codigo=@usuario


--select distinct P.per_codigo,P.Per_Nombre from sgt_perfil_usuario PU,sgt_opcion_perfil OP, sgt_opcion O, sgt_sistema S, sgt_perfil P
--where PU.Usu_codigo=@usuario and PU.per_codigo=op.per_codigo and P.per_codigo=op.per_codigo  and op.opc_codigo=O.opc_codigo and O.sis_codigo=S.sis_codigo
--and S.sis_codigo=@sistema

GO
/****** Object:  StoredProcedure [dbo].[SGTS_USUARIO_Verificar_URL]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[SGTS_USUARIO_Verificar_URL] 
@usuario varchar(100),
@sistema int
AS
select distinct opc_enlace,o.opc_codigo from sgt_perfil_usuario PU,sgt_opcion_perfil OP, sgt_opcion O, sgt_sistema S, sgt_perfil P
where PU.Usu_codigo=@usuario and PU.per_codigo=op.per_codigo and P.per_codigo=op.per_codigo  and op.opc_codigo=O.opc_codigo and O.sis_codigo=S.sis_codigo
and S.sis_codigo=@sistema and opc_enlace<>''




GO
/****** Object:  StoredProcedure [dbo].[SGTS_VerificarPerfil]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





ALTER PROCEDURE [dbo].[SGTS_VerificarPerfil]

@vchUsuario varchar(100),
@vchPerfil int,
@existencia int output

/***************************************
*Descripcion: Login
*Fecha Crea: 20/09/2006
*Parametros: 
*				
*Autor:	Alberto Mac Leod 	
***************************************/

AS

-- valida login
if exists (select USU_Codigo from SGT_PERFIL_USUARIO where PER_CODIGO=@vchperfil and USU_Codigo=@vchUsuario)
set @existencia=1
else
set @existencia=0
 




GO
/****** Object:  StoredProcedure [dbo].[SIOT_TARIFARIO_PROV_ListarEmpresa]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- MODIFICAR STORES PROCEDURES
ALTER PROCEDURE [dbo].[SIOT_TARIFARIO_PROV_ListarEmpresa]
	
AS
SELECT	IdEmpresa, Descripcion, CodigoEmpresa, Estado
FROM	dbo.Empresa
WHERE	Estado = 3

GO
/****** Object:  StoredProcedure [dbo].[SIOT_TARIFARIO_PROV_ListarSucursal]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SIOT_TARIFARIO_PROV_ListarSucursal]
	@IdEmpresa int
AS
SELECT	IdSucursal,IdEmpresa,Descripcion,CodigoSucursal
FROM	dbo.Sucursal
WHERE	IdEmpresa = @IdEmpresa

GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT001_SGT_SISTEMA]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_INT3_INT001_SGT_SISTEMA]  
(@CodigoSistema int)  
AS  
select sis_codigo as int_CodigoSistema, sis_nombre as vch_Nombre, sis_descripcion as vch_Descripcion ,sis_estado as ch_Estado   
from sgt_sistema  
where sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT002_SGT_OPCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
ALTER PROCEDURE [dbo].[SP_INT3_INT002_SGT_OPCION]      
(@CodigoSistema int)      
AS      
      
select opc_nombre as vch_Nombre, opc_descripcion as vch_Descripcion, opc_enlace as vch_Enlace,      
opc_estado as ch_Estado, opc_codigo as int_CodigoOpcion, OPC_FlagMenu as ch_FlagMenu,      
SIS_Codigo as int_CodigoSistema,Convert(varchar,OPC_Visibilidad)  as ch_Visibilidad,OPC_OpcionPadre  as int_OpcionPadre,      
OPC_Nivel as int_Nivel      
from sgt_opcion       
where sis_codigo =  @CodigoSistema     
order by int_opcionPadre asc 
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT003_SGT_ACCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT003_SGT_ACCION]  
(@CodigoSistema int)  
AS  
  
select Distinct c.ACC_Codigo as int_CodigoAccion, c.ACC_Nombre as vch_Nombre, c.ACC_Descripcion as vch_Descripcion, c.ACC_Estado as ch_Estado  
from sgt_accion_opcion a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
inner join sgt_accion c on c.ACC_Codigo = a.ACC_Codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT004_SGT_ACCION_OPCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT004_SGT_ACCION_OPCION]  
(@CodigoSistema int)  
AS  
  
select a.ACC_Codigo as int_CodigoAccion, a.OPC_Codigo as int_CodigoOpcion  
from sgt_accion_opcion a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT005_SGT_PERFIL]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT005_SGT_PERFIL]  
(@CodigoSistema int)  
AS  
  
select distinct c.PER_Codigo as int_Codigo, c.PER_Estado as ch_Estado, c.PER_Nombre as vch_Nombre, c.PER_CodigoInterno as vch_CodigoInterno  
from sgt_opcion_perfil a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
inner join sgt_perfil c on c.PER_Codigo = a.PER_Codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT006_SGT_OPCION_PERFIL]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT006_SGT_OPCION_PERFIL]  
(@CodigoSistema int)  
AS  
  
select a.PER_Codigo as int_Codigo, a.OPC_Codigo as int_CodigoOpcion, a.OPE_Estado as ch_Estado  
from sgt_opcion_perfil a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT007_SGT_USUARIO]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT007_SGT_USUARIO]  
(@CodigoSistema int)  
AS  
  
select distinct e.USU_Codigo as vch_CodUsuario, (e.USU_Nombres + ' ' +  e.USU_Paterno + ' ' +  e.USU_Materno ) as vch_NombreUsuario, e.USU_Contraseña as vch_Clave, e.USU_Correo as vch_Correo, e.USU_NumDocumento as vch_NumDocumento,
e.USU_Estado as ch_Estado, e.USU_CodigoInterno as vch_CodigoInterno,e.USU_Dominio as vch_Dominio  
from sgt_opcion_perfil a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
inner join sgt_perfil c on c.PER_Codigo = a.PER_Codigo  
inner join sgt_perfil_usuario d on d.PER_Codigo = c.PER_Codigo  
inner join sgt_usuario e on e.USU_Codigo = d.USU_Codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT008_SGT_PERFIL_USUARIO]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT008_SGT_PERFIL_USUARIO]  
(@CodigoSistema int)  
AS  
  
select distinct d.PER_Codigo as int_Codigo, d.USU_Codigo as vch_CodUsuario, d.PUS_Estado as ch_Estado  
from sgt_opcion_perfil a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
inner join sgt_perfil c on c.PER_Codigo = a.PER_Codigo  
inner join sgt_perfil_usuario d on d.PER_Codigo = c.PER_Codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT009_SGT_USUARIO_PERFIL_OPCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER PROCEDURE [dbo].[SP_INT3_INT009_SGT_USUARIO_PERFIL_OPCION]  
(@CodigoSistema int)  
AS  
Select distinct a.USU_Codigo as vch_CodUsuario, a.PER_Codigo as int_Codigo, a.OPC_Codigo as int_CodigoOpcion  
from sgt_usuario_perfil_opcion a inner join sgt_opcion b on a.opc_codigo = b.opc_codigo  
where b.sis_codigo = @CodigoSistema  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_INT3_INT010_SGT_USUARIO_ACCION_OPCION]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
      
ALTER PROCEDURE [dbo].[SP_INT3_INT010_SGT_USUARIO_ACCION_OPCION]    
(@CodigoSistema int)      
AS      
Select distinct a.USU_Codigo as vch_CodUsuario, a.ACC_Codigo as int_CodigoAccion, a.OPC_Codigo as int_CodigoOpcion      
from sgt_usuario_accion_opcion a   
inner join sgt_opcion b on a.opc_codigo = b.opc_codigo   
 where b.sis_codigo = @CodigoSistema 
GO
/****** Object:  StoredProcedure [dbo].[sp_WMSCUS_GetAllUsuariosAppLog]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



					   
ALTER PROCEDURE [dbo].[sp_WMSCUS_GetAllUsuariosAppLog] (
@Propietario varchar(10)
)

AS BEGIN
/*********************************

*Autor       : 
*********************************/

SET NOCOUNT ON

SELECT DISTINCT U.USU_Codigo as 'CODIGOUSUARIO',
 U.USU_Nombres + ' ' + U.USU_Nombres as 'NOMBREUSUARIO',
 U.USU_InternoExterno AS 'INTERNOEXTERNO', 
 --P.PER_Codigo as 'CODIGOPERFIL',
 --P.PER_Nombre as 'NOMBREPERFIL',
 U.USU_ClaseUsuario as 'CLASEUSUARIO',
 U.USU_Correo as 'CORREOUSUARIO'
FROM SGT_USUARIO_PERFIL_OPCION UPO inner join SGT_PERFIL_USUARIO PU
ON UPO.PER_Codigo = PU.PER_Codigo inner join SGT_USUARIO U
ON PU.USU_Codigo = U.USU_Codigo inner join SGT_PERFIL P
ON UPO.PER_Codigo = P.PER_Codigo inner join SGT_OPCION O
ON UPO.OPC_Codigo = O.OPC_Codigo
WHERE O.SIS_Codigo = 16 and U.USU_Estado = 'A' and P.PER_Estado = 'A'
ORDER BY U.USU_Codigo

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [dbo].[WMS_OPCION_Seleccionar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[WMS_OPCION_Seleccionar] (
	@USU_Codigo char(20),
	@PER_Codigo int 
)

AS
/*********************************
*Descripcion : Selecciona un Registro de la Tabla SGT_OPCION
*Fecha Crea  : 02/11/2009
*Fecha Mod   : 
*Parametros  : 
*		OPC_Codigo  : 
*Autor       : 
*********************************/
SET @USU_Codigo = 'ADMIN'
SET @PER_CODIGO = 1

SET NOCOUNT ON

SELECT
	B.[USU_Codigo],
	B.[PER_Codigo],
	B.[OPC_Codigo],
	B.[UPO_FechaRegistro],
	B.[UPO_FechaActualizacion],
	A.[OPC_Codigo],
	A.[OPC_Nombre],
	A.[OPC_Descripcion],
	A.[SIS_Codigo],
	A.[OPC_OpcionPadre],
	A.[OPC_Enlace],
	A.[OPC_Estado],
	A.[OPC_FlagMenu],
	A.[OPC_Visibilidad],
	A.[OPC_Nivel],
	A.[USU_FechaReg],
	A.[USU_FechaAct]
FROM
	[SGT_OPCION] A inner join [SGT_USUARIO_PERFIL_OPCION] B on A.[OPC_Codigo]=B.[OPC_Codigo]
WHERE
	B.[USU_Codigo] = @USU_Codigo and B.[PER_Codigo] = @PER_Codigo
GO
/****** Object:  StoredProcedure [dbo].[WMS_OPCION_Seleccionar_G]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[WMS_OPCION_Seleccionar_G] (  
 @USU_Codigo char(20),  
 @PER_Codigo int,
 @OPC_OpcionPadre int
   
)  
  
AS  
/*********************************  
*Descripcion : Selecciona un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION  
*Fecha Crea  : 06/11/2009  
*Fecha Mod   :   
*Parametros  :   
*  OPC_Codigo  :   
*Autor       :   Christian Flores
*********************************/  
/*SET @USU_Codigo = 'ADMIN'  
SET @PER_CODIGO = 1
set @OPC_OpcionPadre = 341  
*/
SET NOCOUNT ON  
  
select a.USU_Codigo, (b.USU_Nombres + ' ' + b.USU_Paterno +' '+ b.USU_Materno) Nombres ,a.PER_Codigo, c.PER_Nombre, 
c. PER_Estado,a.OPC_Codigo, d.OPC_Nombre, d.OPC_Descripcion, d.SIS_Codigo, d.OPC_OpcionPadre, d.OPC_Enlace, d.OPC_Estado
from dbo.SGT_USUARIO_PERFIL_OPCION a inner join dbo.SGT_USUARIO b on a.USU_Codigo = b.USU_Codigo 
inner join dbo.SGT_PERFIL c on a.PER_Codigo = c.PER_Codigo 
inner join dbo.SGT_OPCION d on a.OPC_Codigo = d.OPC_Codigo 
where a.USU_Codigo =@USU_Codigo and a.PER_Codigo =@PER_CODIGO and d.OPC_OpcionPadre = @OPC_OpcionPadre

/*SELECT  
 B.[USU_Codigo],  
 B.[PER_Codigo],  
 B.[OPC_Codigo],  
 B.[UPO_FechaRegistro],  
 B.[UPO_FechaActualizacion],  
 A.[OPC_Codigo],  
 A.[OPC_Nombre],  
 A.[OPC_Descripcion],  
 A.[SIS_Codigo],  
 A.[OPC_OpcionPadre],  
 A.[OPC_Enlace],  
 A.[OPC_Estado],  
 A.[OPC_FlagMenu],  
 A.[OPC_Visibilidad],  
 A.[OPC_Nivel],  
 A.[USU_FechaReg],  
 A.[USU_FechaAct]  
FROM  
 [SGT_OPCION] A inner join [SGT_USUARIO_PERFIL_OPCION] B on A.[OPC_Codigo]=B.[OPC_Codigo]  
WHERE  
 B.[USU_Codigo] = @USU_Codigo and B.[PER_Codigo] = @PER_Codigo
*/
GO
/****** Object:  StoredProcedure [dbo].[WMS_OPCION_Seleccionar_G_Buscar]    Script Date: 10/03/2019 01:15:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.WMS_OPCION_Seleccionar_G_Buscar 'cflores',27,341,'Stock'
*/
ALTER PROCEDURE [dbo].[WMS_OPCION_Seleccionar_G_Buscar] (  
 @USU_Codigo char(20),  
 @PER_Codigo int,
 @OPC_OpcionPadre int,
 @TIT_Informe Varchar(100) = Null 
   
)  

AS  
/*********************************  
*Descripcion : Selecciona un Registro de la Tabla SGT_USUARIO_PERFIL_OPCION  
*Fecha Crea  : 06/11/2009  
*Fecha Mod   :   
*Parametros  :   
*  OPC_Codigo  :   
*Autor       :   Christian Flores
*********************************/  
SET NOCOUNT ON  
  
select 
		a.[USU_Codigo], 
		(b.[USU_Nombres] + ' ' + b.[USU_Paterno] +' '+ b.[USU_Materno]) Nombres ,
		a.[PER_Codigo], 
		c.[PER_Nombre], 
		c.[PER_Estado],
		a.[OPC_Codigo], 
		d.[OPC_Nombre], 
		d.[OPC_Descripcion], 
		d.[SIS_Codigo], 
		d.[OPC_OpcionPadre], 
		d.[OPC_Enlace], 
		d.[OPC_Estado]
from	
		[SGT_USUARIO_PERFIL_OPCION] a inner join [SGT_USUARIO] b on a.[USU_Codigo] = b.[USU_Codigo] 
		inner join [SGT_PERFIL] c on a.[PER_Codigo] = c.[PER_Codigo] 
		inner join [SGT_OPCION] d on a.[OPC_Codigo] = d.[OPC_Codigo] 
where 
	
		a.[USU_Codigo] =@USU_Codigo and 
		a.[PER_Codigo] =@PER_CODIGO and 
		d.[OPC_OpcionPadre] = @OPC_OpcionPadre and 
		d.[OPC_Descripcion] like '%' +  isnull(@TIT_Informe,'') + '%'


GO
