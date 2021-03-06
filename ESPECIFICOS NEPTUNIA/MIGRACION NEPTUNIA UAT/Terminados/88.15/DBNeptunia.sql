USE [DBNeptunia]
GO
/****** Object:  UserDefinedFunction [configuracion].[fn_obtener_descripcion_multiuso]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [configuracion].[fn_obtener_descripcion_multiuso]
(
	@mlt_int_id_padre bigint,
	@mlt_str_valor varchar(1000)
)
returns varchar(1000)
as
begin
    Declare @mlt_str_nombre varchar(50);
    select @mlt_str_nombre = m.mlt_str_nombre 
    from configuracion.tbl_multiuso m
    where	m.mlt_int_id_padre = @mlt_int_id_padre 
			and upper(m.mlt_str_valor) = upper(rtrim(ltrim(@mlt_str_valor)))  

    RETURN  @mlt_str_nombre

end



GO
/****** Object:  UserDefinedFunction [configuracion].[fn_split]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from  [configuracion].[fn_split] ('1,2,3', ',')

ALTER FUNCTION [configuracion].[fn_split] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(value_data NVARCHAR(MAX)) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (value_data)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END



GO
/****** Object:  UserDefinedFunction [seguridad].[sf_decrypt]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [seguridad].[sf_decrypt](@encryp varbinary(8000))
returns nvarchar(4000)
as 
begin 
	declare @key varchar(10) 
	declare @res nvarchar(4000)
	set @key = 'coolbox2016'
	set @res = decryptbypassphrase(@key, @encryp)
	return @res
end;




GO
/****** Object:  UserDefinedFunction [seguridad].[sf_encrypt]    Script Date: 07/03/2019 03:04:49 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER FUNCTION [seguridad].[sf_encrypt](@str nvarchar(4000))
--returns varbinary(2000)
--as
--begin 
	
--	declare @key varchar(10) 
--	declare @res varbinary(2000)
	
--	set @key = 'coolbox2016'
--	set @res = encryptbypassphrase(@key, @str)
--	return @res
--end;



GO
/****** Object:  UserDefinedFunction [seguridad].[sf_obtenerclaverol]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [seguridad].[sf_obtenerclaverol]
(
	@idrol bigint
)
returns nvarchar(4000)
as 
begin
	
	declare @res  nvarchar(4000);
	
	select @res = seguridad.sf_decrypt(p.rol_str_pass)
	from seguridad.tbl_seg_rol p
	where p.rol_int_id = @idrol;
	
	return @res;
	
end;




GO
/****** Object:  UserDefinedFunction [seguridad].[sf_obtenerclaveusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*funcion que obtiene la clave del usuario*/
ALTER FUNCTION [seguridad].[sf_obtenerclaveusuario] ( @usr_str_red varchar(50) ) 
returns nvarchar(4000)
as
begin
	declare @pwd varbinary(8000);
	--verifica que el alias del usuario ingresado exista
	if not exists(select * from seguridad.tbl_usuario where usr_str_red = @usr_str_red)
		return 'E~No existe el usuario con el alias ingresado';
	
	--obtiene el password en forma binaria
	select @pwd = u.usr_str_password
	from seguridad.tbl_usuario u
	where u.usr_str_red = @usr_str_red;
	
	--desencripta el passwword del usuario obtenido
	return '0~' + seguridad.sf_decrypt(@pwd); -- @pwd
 
end;




GO
/****** Object:  UserDefinedFunction [seguridad].[Split]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [seguridad].[Split] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END




GO
/****** Object:  View [dbo].[vw_tb_reserva_booking_realizadas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER VIEW [dbo].[vw_tb_reserva_booking_realizadas]
 as
 select * from contenedor.tbl_reserva_booking (nolock)
 where rb_str_oficina='NEPCLL' and rb_str_usuario_creacion <> 'gcuentasj' and rb_str_usuario_creacion like '20%' 
 or rb_str_usuario_creacion in ('aurbina','C.20510049226','cpelaez','anurbina','dillaguento','bevillacorta','rasueldo','digallegos')
 and rb_dat_fecha_creacion between GETDATE()-91 and getdate()
GO
/****** Object:  View [dbo].[vw_tbl_reserva_booking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[vw_tbl_reserva_booking]
AS
	SELECT *FROM contenedor.tbl_reserva_booking WITH (NOLOCK)
GO
/****** Object:  StoredProcedure [auditoria].[pa_generarTablasAudit]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [auditoria].[pa_generarTablasAudit]
(
	@ptable_name sysname,
	@preset smallint
)
AS
  DECLARE @CREATE_AUDIT_TABLE_SQL VARCHAR(MAX)
   ,@CREATE_TRIGGER_SQL VARCHAR(MAX)
   ,@TABLE_NAME sysname
   ,@SCHEMA_NAME sysname
   ,@TRIGGER_SELECT_COL_CURRENT VARCHAR(MAX)
   ,@CREATE_AUDIT_COL_OLD VARCHAR(MAX)
   ,@TRIGGER_SELECT_COL_OLD VARCHAR(MAX)
   ,@COLUMN VARCHAR(MAX)
   ,@COLUMN_NAME VARCHAR(50)
   -- VARIABLES PARA ASIGNAR
   ,@TABLE_AUDIT_NAME VARCHAR(100)
   ,@TABLE_AUDIT_TRIGGER_NAME VARCHAR(100)
   ,@TABLE_AUDIT_ID INT
   --VARIABLES DE PREFIJO
   ,@SCHEMA_AUDIT_NAME VARCHAR(50)
   ,@PRE_TABLE_AUDIT_NAME VARCHAR(50)
   ,@PRE_TRIGGER_AUDIT_NAME VARCHAR(50); 
   
  SET NOCOUNT ON;

  SET @SCHEMA_AUDIT_NAME = '[auditoria]';
  SET @PRE_TABLE_AUDIT_NAME = 'audit_';
  SET @PRE_TRIGGER_AUDIT_NAME = 'tgr_iud_audit_';

	--SELECCIONE TODAS LAS TABLAS DE LA BASE DE DATOS, PERO LAS TABLAS DE AUDITORÍA Y LA MESA SYSDIAGRAM
  SELECT  @TABLE_NAME = MIN(TABLE_NAME)
         ,@SCHEMA_NAME = MIN(TABLE_SCHEMA)
  FROM    INFORMATION_SCHEMA.TABLES
  WHERE   TABLE_TYPE = 'BASE TABLE'
          AND ( TABLE_NAME != 'SYSDIAGRAMS'
                AND LEFT(TABLE_NAME, 6) != @PRE_TABLE_AUDIT_NAME )
          AND TABLE_NAME = @ptable_name;

	--BUCLE A TRAVÉS DE LAS TABLAS
  WHILE @TABLE_NAME IS NOT NULL
    BEGIN
    
      
      IF @TABLE_AUDIT_NAME IS NULL
        BEGIN 
          SET @TABLE_AUDIT_NAME = @SCHEMA_AUDIT_NAME + '.' + @PRE_TABLE_AUDIT_NAME + @TABLE_NAME;
          SET @TABLE_AUDIT_TRIGGER_NAME = @PRE_TRIGGER_AUDIT_NAME + @TABLE_NAME;
        END;

		
	  -- INICIALIZAR / REINICIAR LAS VARIABLES
      SET @CREATE_AUDIT_TABLE_SQL = 'CREATE TABLE ' + @TABLE_AUDIT_NAME + '(';
      SET @CREATE_AUDIT_COL_OLD = '';
      SET @TRIGGER_SELECT_COL_OLD = '';
      SET @TRIGGER_SELECT_COL_CURRENT = '';

	-- CREAR UN CURSOR PARA RECORRER A TRAVÉS DE LAS COLUMNAS EN LA TABLA
      DECLARE COLUMNINFO_CURSOR CURSOR
      FOR
        SELECT  CASE
	-- LA CREACIÓN DE LA LÍNEA DE LA COLUMNA CON FORMATO PARA CREAR UNA COLUMNA DE LA TABLA
                     WHEN DATA_TYPE IN ( 'DECIMAL', 'NUMERIC' )
                     THEN CONVERT(VARCHAR(MAX), COLUMN_NAME + ' ' + DATA_TYPE
                          + '(' + CONVERT(VARCHAR(10), NUMERIC_PRECISION)
                          + ',' + CONVERT(VARCHAR(10), NUMERIC_SCALE) + '), ')
                     WHEN CHARACTER_MAXIMUM_LENGTH IS NULL
                          OR DATA_TYPE = 'IMAGE'
                          OR DATA_TYPE IN ( 'NTEXT', 'IMAGE', 'TEXT', 'XML',
                                            'SQL_VARIANT' )
                     THEN CONVERT(VARCHAR(MAX), COLUMN_NAME + ' ' + DATA_TYPE
                          + ', ')
                     WHEN CHARACTER_MAXIMUM_LENGTH = -1
                     THEN CONVERT(VARCHAR(MAX), COLUMN_NAME + ' ' + DATA_TYPE
                          + '(MAX), ')
                     ELSE CONVERT(VARCHAR(MAX), COLUMN_NAME + ' ' + DATA_TYPE
                          + '('
                          + CONVERT(VARCHAR(10), CHARACTER_MAXIMUM_LENGTH)
                          + '), ')
                END
               ,COLUMN_NAME
        FROM    INFORMATION_SCHEMA.COLUMNS
        WHERE   TABLE_NAME = @TABLE_NAME
        ORDER BY ORDINAL_POSITION;

      OPEN COLUMNINFO_CURSOR;

      FETCH NEXT FROM COLUMNINFO_CURSOR
	INTO @COLUMN, @COLUMN_NAME;

      WHILE @@FETCH_STATUS = 0
        BEGIN
          SET @CREATE_AUDIT_TABLE_SQL = @CREATE_AUDIT_TABLE_SQL + @COLUMN;
          SET @CREATE_AUDIT_COL_OLD = @CREATE_AUDIT_COL_OLD + 'old' + @COLUMN;
          SET @TRIGGER_SELECT_COL_CURRENT = @TRIGGER_SELECT_COL_CURRENT
            + @COLUMN_NAME + ', ';
          SET @TRIGGER_SELECT_COL_OLD = @TRIGGER_SELECT_COL_OLD + 'old'
            + @COLUMN_NAME + ', ';

          FETCH NEXT FROM COLUMNINFO_CURSOR
	INTO @COLUMN, @COLUMN_NAME;

        END;

	--AÑADIR A MÁS FILAS A LA TABLA PARA UNA MARCA DE FECHA Y HORA
      SET @CREATE_AUDIT_TABLE_SQL = @CREATE_AUDIT_TABLE_SQL
        + 'au_int_id BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL, ' + 
        + 'auditdate DATETIME DEFAULT (GETDATE()), ' +
        + 'audittype CHAR(1), ' +
        + 'username VARCHAR(100), ' +
        + @CREATE_AUDIT_COL_OLD + ')';

		SELECT @CREATE_AUDIT_TABLE_SQL;

      CLOSE COLUMNINFO_CURSOR;
      DEALLOCATE COLUMNINFO_CURSOR;

	-- UNCOMMENT OUT THE CODE LINE BELOW IF YOU WANT TO DROP YOUR AUDIT TABLES
	-- WARNING: YOU WILL LOSE ALL HISTORY OF THE AUDIT TABLE IF YOU DO THIS
	 IF @preset = 1 
	 BEGIN 
		EXEC('IF OBJECT_ID (''' + @TABLE_AUDIT_NAME + ''') IS NOT NULL DROP TABLE ' + @TABLE_AUDIT_NAME)
	 END;
	-- CREATE THE AUDIT TABLE IF IT DOESN'T EXIST. DO NOT CREATE AUDIT TABLES FOR AUDIT TABLES
      IF NOT EXISTS ( SELECT  *
                      FROM    INFORMATION_SCHEMA.TABLES
                      WHERE   TABLE_NAME = @TABLE_AUDIT_NAME )  --@TABLE_NAME + '_AUDIT' )
        AND LEFT(@TABLE_NAME, 6) != @PRE_TABLE_AUDIT_NAME
        BEGIN
	-- PRINT @CREATE_AUDIT_TABLE_SQL
          SELECT  @CREATE_AUDIT_TABLE_SQL;
          EXEC(@CREATE_AUDIT_TABLE_SQL);

        END;

	-- CREATE TRIGGERS FOR ALL TABLES EXCEPT THE AUDIT TABLES
      IF LEFT(@TABLE_NAME, 6) != @PRE_TABLE_AUDIT_NAME
        BEGIN
	-- DELETE THE TRIGGER IF IT EXIST
		EXEC('IF EXISTS (SELECT * FROM dbo.sysobjects WHERE Name = ''' + @TABLE_AUDIT_TRIGGER_NAME + ''' AND type = ''TR'') DROP TRIGGER [' + @SCHEMA_NAME + '].' + @TABLE_AUDIT_TRIGGER_NAME);
    --  EXEC('IF OBJECT_ID (''' + @TABLE_AUDIT_TRIGGER_NAME + ''', ''TR'') IS NOT NULL DROP TRIGGER [' + @SCHEMA_NAME + '].' + @PRE_TRIGGER_AUDIT_NAME);

	-- CREATE THE TRIGGER
          SET @CREATE_TRIGGER_SQL = 'CREATE TRIGGER ' + @TABLE_AUDIT_TRIGGER_NAME
            + ' ON  [' + @SCHEMA_NAME + '].[' + @TABLE_NAME
            + '] FOR INSERT, UPDATE, DELETE
	AS


	DECLARE @AUDITTYPE CHAR(1), @PKCOLS VARCHAR(MAX), @SQL VARCHAR(MAX), @USERNAME VARCHAR(100);
	
	SET @USERNAME = system_user;

	--FIND THE PRIMARY KEYS TO BE USED IN THE INSERTED AND DELETED OUTER JOIN
	SELECT @PKCOLS = COALESCE(@PKCOLS + '' AND'', '' ON'') + '' I.'' + C.COLUMN_NAME + '' = D.'' + C.COLUMN_NAME
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ,
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE C
	WHERE PK.TABLE_NAME = ''' + @TABLE_NAME + '''
	AND CONSTRAINT_TYPE = ''PRIMARY KEY''
	AND C.TABLE_NAME = PK.TABLE_NAME
	AND C.CONSTRAINT_NAME = PK.CONSTRAINT_NAME

	SELECT * INTO #INS FROM INSERTED
	SELECT * INTO #DEL FROM DELETED

	IF EXISTS (SELECT * FROM INSERTED)
	IF EXISTS (SELECT * FROM DELETED)
	SET @AUDITTYPE = ''U''
	ELSE
	SET @AUDITTYPE = ''I''
	ELSE
	SET @AUDITTYPE = ''D''

	EXEC(''INSERT INTO ' + @TABLE_AUDIT_NAME + '(';

	-- ADD THE COLUMNS - CURRENT AND OLD TO THE SELECT
          SET @CREATE_TRIGGER_SQL = @CREATE_TRIGGER_SQL
            + @TRIGGER_SELECT_COL_CURRENT + @TRIGGER_SELECT_COL_OLD
            + ' AUDITTYPE, USERNAME)

	SELECT I.*, D.*, '''''' + @AUDITTYPE + '''''', '''''' + @USERNAME + '''''' 
	FROM #INS I 
	FULL OUTER JOIN #DEL D '' + @PKCOLS )';

	-- PRINT @CREATE_TRIGGER_SQL
          SELECT  @CREATE_TRIGGER_SQL;
          EXEC(@CREATE_TRIGGER_SQL);

        END;

	-- NEXT TABLE
      SELECT  @TABLE_NAME = MIN(TABLE_NAME)
             ,@SCHEMA_NAME = MIN(TABLE_SCHEMA)
      FROM    INFORMATION_SCHEMA.TABLES
      WHERE   TABLE_NAME > @TABLE_NAME
              AND TABLE_TYPE = 'BASE TABLE'
              AND TABLE_NAME != 'SYSDIAGRAMS'
              AND TABLE_NAME = 'TBL_ALERTA';
    END; 







GO
/****** Object:  StoredProcedure [auditoria].[pa_insertarlog]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [auditoria].[pa_insertarlog]
(
 @thread varchar(255),
 @hostname varchar(255),
 @log_level varchar(50),
 @logger varchar(255),
 @message varchar(MAX),
 @exception varchar(MAX)
)
AS
  INSERT  INTO auditoria.Logs
          (Date,
           Thread,
           Level,
           Logger,
           Message,
           Exception,
           Source,
           HostName)
  VALUES  (GETDATE(), -- Date - datetime
           @thread, -- Thread - varchar(255)
           @log_level, -- Level - varchar(50)
           @logger, -- Logger - varchar(255)
           @message, -- Message - nvarchar(max)
           @exception, -- Exception - nvarchar(max)
           'LOG SOURCE', -- Source - varchar(100)
           @hostname  -- HostName - nvarchar(255)
           );
           




GO
/****** Object:  StoredProcedure [bienes].[pa_listarBienesFiscalizados]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[bienes].[pa_listarBienesFiscalizados]  null,null,null,null 
ALTER PROCEDURE [bienes].[pa_listarBienesFiscalizados]    
@idEstado int ,  
@idEnvio int,  
@inicio datetime,  
@fin datetime  
as  
select   
bf_int_id  
,bf_str_tipoOperacion  
,bf_str_codEstablecimiento  
,bf_str_codtipoTransaccion  
,bf_str_numeroruc  
,bf_str_descripruc  
,bf_int_codpresentacion  
,bf_str_descproducto  
,bf_dec_cantpresentaciones  
,bif_int_peso  
,bf_str_tipodocasociado  
,bf_str_numdocasociado  
,convert(varchar,bf_dat_fectransaccion,103) bf_dat_fectransaccion
,bf_str_numructransportista  
,bf_str_tipoguiarem  
,bf_str_numeroguiarem  
,bf_str_placavehiculo  
,bf_str_numlic  
,bf_str_observaciones  
,bf_str_codigoIncidencia  
,case when bf_bit_generado = 1 then 'Generado' else 'No Generado' end Generado
, estado
 from [bienes].[TBL_BIENESFISCALIZADOS]  bif
 inner join [bienes].[TBL_ESTADO] est on est.id_int_estado = bif.bf_int_estado


 where (@idEnvio is null or env_int_id = @idEnvio)   
 and (@idEstado is null or bf_int_estado = @idEstado)  
 and (@inicio is null or bf_dat_fectransaccion >= @inicio)    
 and (@fin is null or bf_dat_fectransaccion <= @fin)  
  


GO
/****** Object:  StoredProcedure [bienes].[pa_listarBienesFiscalizados_15042016]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_listarBienesFiscalizados_15042016] 
@idEstado int ,
@idEnvio int
as
select 
bf_int_id
,bf_str_tipoOperacion
,bf_str_codEstablecimiento
,bf_str_codtipoTransaccion
,bf_str_descripruc
,bf_int_codpresentacion
,bf_str_descproducto
,bf_dec_cantpresentaciones
,bif_int_peso
,bf_str_tipodocasociado
,bf_str_numdocasociado
,bf_dat_fectransaccion
,bf_str_numructransportista
,bf_str_tipoguiarem
,bf_str_numeroguiarem
,bf_str_placavehiculo
,bf_str_numlic
,bf_str_observaciones
,bf_str_codigoIncidencia
,bf_bit_generado
,bf_int_estado
 from [bienes].[TBL_BIENESFISCALIZADOS]
 --where (@idEnvio is null or env_int_id = @idEnvio)




GO
/****** Object:  StoredProcedure [bienes].[pa_ListarCodPresentacion]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [bienes].[pa_ListarCodPresentacion]  
 as  
 select   
 pre_ind_id  
 ,cod_str_unidadmedida  
   from [bienes].[TBL_CODPRESENTACION_PRODUCTO]


GO
/****** Object:  StoredProcedure [bienes].[pa_listarContenedor]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_listarContenedor]
@navvia varchar(20),
@conte varchar(20)


as
select distinct b.codcon04---, a.ruccli12,  a.navvia11    
from NPT1_TERMINAL.DBO.dddetall12 a (nolock)    
inner join NPT1_TERMINAL.DBO.drblcont15 b (nolock) on (a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12)    
where a.navvia11=@navvia   and b.codcon04 like'%' +  @conte+ '%'




GO
/****** Object:  StoredProcedure [bienes].[pa_listarenvios]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_listarenvios]
@idEstado int,
@inicio datetime,
@fin datetime
as
select env_int_id
, convert(nvarchar,env_dat_fecha,103) as env_dat_fecha 
,estado 
,env_int_cantbienes
, env_bit_eliminado 
from [bienes].[TBL_ENVIO] env
inner join bienes.TBL_ESTADO est on est.id_int_estado = env.env_int_estado
where  (@idEstado is null or env_int_estado = @idEstado)
 and (@inicio is null or env_dat_fecha >= @inicio)  
 and (@fin is null or env_dat_fecha <= @fin) 
 order by env_int_id  desc




GO
/****** Object:  StoredProcedure [bienes].[pa_ListarEstablecimientos]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_ListarEstablecimientos]  
as  
select   
cod_establecimiento  
,des_establecimiento  
 from [bienes].[TBL_ESTABLECIMIENTO]


GO
/****** Object:  StoredProcedure [bienes].[pa_listarEstados]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_listarEstados]
as
select id_int_estado, estado from [bienes].[TBL_ESTADO]




GO
/****** Object:  StoredProcedure [bienes].[pa_listarFechasAlerta]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[pa_listarFechasAlerta]   
@anio int  
as  
select al_int_id 
,CONVERT(datetime, convert(varchar, @anio)   
+ '/'    
+ convert(varchar,al_int_mes)   
+ '/'   
+ convert(varchar,al_int_dia) )   as  
al_int_mes
,al_str_correos 
,al_int_dias
from [bienes].[TBL_ALERTA]  
where al_int_ano = @anio  
  


GO
/****** Object:  StoredProcedure [bienes].[pa_ListarTipoDocumento]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [bienes].[pa_ListarTipoDocumento]  
as  
select   
td_str_codigo  
,td_str_descripcion  
 from [bienes].[TBL_TIPODOCUMENTO]  


GO
/****** Object:  StoredProcedure [bienes].[PA_NEP_GENERAR_ENVIO]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bienes].[PA_NEP_GENERAR_ENVIO] 
@ENV_INT_ID INT
AS
BEGIN

SELECT 

    '5' + '|' +
    ISNULL(bf_str_codEstablecimiento,'') + '|' +
    ISNULL(bf_str_codtipoTransaccion,'') + '|' +
    ISNULL(bf_str_numeroruc,'')          + '|' +
    ISNULL(CONVERT(VARCHAR,bf_int_codpresentacion),'')    + '|' +
    ISNULL(CONVERT(VARCHAR,bf_dec_cantpresentaciones),'') + '|' +
    ISNULL(bf_str_tipodocasociado,'') + '|' +
    ISNULL(bf_str_numdocasociado,'')  + '|' +
    ISNULL(CONVERT(VARCHAR,bf_dat_fectransaccion,103),'') + '|' +
    ISNULL(bf_str_numructransportista,'')  + '|' +
    ISNULL(bf_str_tipoguiarem,'')    + '|' +
    ISNULL(bf_str_numeroguiarem,'')  + '|' +
    ISNULL(bf_str_placavehiculo,'')  + '|' +
    ISNULL(bf_str_numlic,'')  + '|' +
    ISNULL(bf_str_observaciones,'')  + '|' +
    ISNULL(bf_str_codigoIncidencia,'') AS LINEA
FROM 
  BIENES.TBL_BIENESFISCALIZADOS WITH(NOLOCK) 
WHERE  
  ENV_INT_ID = @ENV_INT_ID

END




GO
/****** Object:  StoredProcedure [configuracion].[pa_listar_multiuso]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [configuracion].[pa_listar_multiuso]
as
select	m.mlt_int_id
		,m.mlt_int_id_padre
		,m.mlt_str_nombre
		,m.mlt_str_descripcion
		,m.mlt_str_valor
		,m.mlt_str_alcance
		,m.mlt_dat_fecha_creacion
		,m.mlt_str_usuario_creacion 
		,m.mlt_str_estado
from configuracion.tbl_multiuso m
where m.mlt_str_estado = 'A'




GO
/****** Object:  StoredProcedure [configuracion].[pa_listar_multiuso_tipo]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [configuracion].[pa_listar_multiuso_tipo]
(
	@mlt_str_tipo char(1)  = null
	,@mlt_int_id_padre varchar(5) = null
)
as
select	m.mlt_int_id
		,m.mlt_int_id_padre
		,m.mlt_str_nombre
		,m.mlt_str_descripcion
		,m.mlt_str_valor
		,m.mlt_str_valor2
		,m.mlt_str_tipo
		,m.mlt_str_alcance
		,m.mlt_dat_fecha_creacion
		,m.mlt_str_usuario_creacion 
		,m.mlt_str_estado
from configuracion.tbl_multiuso m
where m.mlt_str_estado = 'A' and (@mlt_str_tipo is null or m.mlt_str_tipo = @mlt_str_tipo)
      and (@mlt_int_id_padre is null or m.mlt_int_id_padre = @mlt_int_id_padre)




GO
/****** Object:  StoredProcedure [contenedor].[EliminarBookingWS]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [contenedor].[EliminarBookingWS] 'MSC','NEPCLL'    
ALTER PROCEDURE [contenedor].[EliminarBookingWS] (@IdReserva bigint)
AS
BEGIN
	SET NOCOUNT ON;

	--------------||       
	BEGIN TRY
		DELETE
		FROM contenedor.tbl_reserva_booking_adjuntos
		WHERE rb_int_id = @IdReserva

		DELETE
		FROM contenedor.tbl_reserva_booking
		WHERE rb_int_id = @IdReserva

		SELECT 'OK' AS Result
	END TRY

	BEGIN CATCH
		SELECT 'KO' AS Result
	END CATCH

	--------------||      
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [contenedor].[pa_datos_basicos_booking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [contenedor].[pa_datos_basicos_booking]
(
	@rb_int_id varchar(20)
)
as 

select	b.rb_int_id, 
		b.rb_str_numero_booking, 
		b.rb_int_espacios, 
		b.rb_int_identificador_terminal,
		rb_int_espacios_ocupados = count(bd.rb_int_id),  
		rb_int_espacios_disponibles = b.rb_int_espacios - count(bd.rb_int_id)  
from contenedor.tbl_reserva_booking b
left join contenedor.tbl_reserva_booking_detalle bd on bd.rb_int_id = b.rb_int_id
where b.rb_int_id = @rb_int_id
group by b.rb_int_id, b.rb_str_numero_booking, b.rb_int_espacios , b.rb_int_identificador_terminal



GO
/****** Object:  StoredProcedure [contenedor].[pa_datos_booking__pago]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [contenedor].[pa_datos_booking__pago]
(
	@rb_str_numero_booking varchar(20),
	@rbp_int_id bigint
)
as 
	

	select	 b.rb_int_id 
			,b.rb_str_numero_booking 
			,p.rbp_int_id
			,p.rbp_str_cip
			,p.rb_str_codigo_cliente_operacion
			,p.rb_str_codigo_cliente_operacion_cif
			,p.rb_str_codigo_cliente_operacion_descripcion
			,p.rb_str_codigo_cliente_factura
			,p.rb_str_codigo_cliente_factura_cif
			,p.rb_str_codigo_cliente_factura_descripcion
			,p.rb_str_codigo_cliente_tarifa
			,p.rb_str_codigo_cliente_tarifa_cif
			,p.rb_str_codigo_cliente_tarifa_descripcion
			,p.rbp_dec_importe_final
			,p.rpb_str_estado_pago
			,p.rbp_dat_fecha_creacion
			,p.rbp_str_usuario_creacion
	from contenedor.tbl_reserva_booking b
	   inner join [contenedor].[tbl_reserva_booking_pago] p
		on p.rb_int_id =  b.rb_int_id
	where b.rb_str_numero_booking = @rb_str_numero_booking
		and p.rbp_int_id = @rbp_int_id

GO
/****** Object:  StoredProcedure [contenedor].[pa_datos_booking_resumen_pago]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [contenedor].[pa_datos_booking_resumen_pago] --'test30','284'

(

	@rb_str_numero_booking varchar(20),

    @rbd_int_id_array varchar(max)

)

as 

	declare  @reserva bigint

    declare  @estado_pago varchar(50)



	set	     @reserva     = (select rb_int_id from contenedor.tbl_reserva_booking where rb_str_numero_booking = @rb_str_numero_booking)

	set	     @estado_pago = isnull((select top 1 rpb_str_estado_pago from [contenedor].[tbl_reserva_booking_pago] where rb_int_id  = @reserva),'')





	select	b.rb_int_id 

			,b.rb_str_numero_booking 

			,b.rb_str_codigo_buque 

			,b.rb_str_codigo_buque_descripcion

			,b.rb_str_viaje

			,rb_str_tipo_facturacion = null 

			,rb_str_unidad_negocio = null 

			,rb_str_concepto = null 

			,b.rb_str_depot 

			,b.rb_str_depot_descripcion

			,rb_str_codigo_agente_carga as rb_str_codigo_cliente

			,rb_str_codigo_agente_carga_descripcion as rb_str_codigo_cliente_descripcion 

			,rb_str_codigo_cliente_factura = au.rb_str_cod_cliente_factura

			,rb_str_codigo_cliente_factura_descripcion = au.rb_str_cliente_factura_descripcion 

			,rb_str_codigo_cliente_tarifa = b.rb_str_codigo_agente_carga

			,rb_str_codigo_cliente_tarifa_descripcion = b.rb_str_codigo_agente_carga_descripcion 

   	from  contenedor.tbl_reserva_booking b

	inner join tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal



	where b.rb_str_numero_booking = @rb_str_numero_booking;









	select  bd.rb_int_id

			,bd.rbd_int_id

			,bd.rbd_str_matricula_equipamiento

			,bd.rb_int_identificador_terminal

			,bd.rbd_int_tamanyo

			,bd.rbd_str_tipo



	from contenedor.tbl_reserva_booking_detalle bd

	inner join contenedor.tbl_reserva_booking b on b.rb_int_id = bd.rb_int_id

	inner join configuracion.fn_split(@rbd_int_id_array, ',') ids on ids.value_data = bd.rbd_int_id

	where b.rb_str_numero_booking = @rb_str_numero_booking;







	--if (@estado_pago = 'PG')



	--begin

	--	select   bd.rbd_int_id

	--		,bs.rbsa_int_id

	--		,bs.rbsa_str_codigo_servicio_adicional

	--		,bs.rbsa_str_codigo_servicio_adicional_descripcion

	--		,bs.rbsa_dec_importe_tarifa

	--		,bs.rbsa_str_usuario_creacion

	--		,bs.rbsa_dat_fecha_creacion

	--	from contenedor.tbl_reserva_booking b

	--	inner join contenedor.tbl_reserva_booking_detalle bd on bd.rb_int_id = b.rb_int_id

	--	inner join configuracion.fn_split(@rbd_int_id_array, ',')  ids on ids.value_data = bd.rbd_int_id

	--	inner join contenedor.tbl_reserva_booking_servicio_adicional bs on bs.rbd_int_id = bd.rbd_int_id 

	--	where  b.rb_str_numero_booking = @rb_str_numero_booking;





	--end



	--else



	--begin



				select   bd.rbd_int_id

				,bs.rbsa_int_id

				,rbsa_str_codigo_servicio_adicional = trsa.trsa_str_codigo_servicio

				,bs.rbsa_str_codigo_servicio_adicional_descripcion

				,bs.rbsa_dec_importe_tarifa

				,bs.rbsa_str_usuario_creacion

				,bs.rbsa_dat_fecha_creacion

		from contenedor.tbl_reserva_booking b



		inner join contenedor.tbl_reserva_booking_detalle bd on bd.rb_int_id = b.rb_int_id

		inner join contenedor.tbl_tipo_reserva_servicio_adicional trsa on trsa.trsa_str_tipo_reserva = b.rb_str_tipo_reserva

		inner join configuracion.fn_split(@rbd_int_id_array, ',')  ids on ids.value_data = bd.rbd_int_id

		left join contenedor.tbl_reserva_booking_servicio_adicional bs on bs.rbd_int_id = bd.rbd_int_id 



		--where bs.rbsa_int_id is null and b.rb_str_numero_booking = @rb_str_numero_booking;

		where  b.rb_str_numero_booking = @rb_str_numero_booking;



	--end






GO
/****** Object:  StoredProcedure [contenedor].[pa_eliminar_booking_completo]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_eliminar_booking_completo]
@nrobooking varchar (20)
as
declare @rb_int_id int
declare @rbd_int_id int

select @rb_int_id=rb_int_id from contenedor.tbl_reserva_booking where rb_str_numero_booking=@nrobooking
select @rbd_int_id=rbd_int_id from contenedor.tbl_reserva_booking_detalle where rb_int_id=@rb_int_id

delete from contenedor.tbl_reserva_status_historial where rbd_int_id=@rbd_int_id
delete from contenedor.tbl_reserva_booking_adjuntos where rb_int_id=@rb_int_id
delete from contenedor.tbl_reserva_booking_detalle where rb_int_id=@rb_int_id
delete from contenedor.tbl_reserva_booking where rb_int_id=@rb_int_id
GO
/****** Object:  StoredProcedure [contenedor].[pa_eliminardetallebooking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_eliminardetallebooking]
@rbd_int_id bigint
as
delete [contenedor].[tbl_reserva_status_historial]
where rbd_int_id =  @rbd_int_id


delete [contenedor].[tbl_reserva_booking_servicio_adicional]
where rbd_int_id = @rbd_int_id 

delete [contenedor].[tbl_reserva_booking_detalle]
where rbd_int_id = @rbd_int_id  
 
select @@identity

GO
/****** Object:  StoredProcedure [contenedor].[pa_eliminardocumentobooking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_eliminardocumentobooking]
@rba_int_id bigint
as
delete from [contenedor].[tbl_reserva_booking_adjuntos]
where rba_int_id = @rba_int_id
select @rba_int_id as result

GO
/****** Object:  StoredProcedure [contenedor].[pa_eliminarPago]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_eliminarPago]
@rbd_int_id bigint 
as
--obtener detalle
declare @iddetalle bigint
declare @idpago bigint



---obtener pago y borrarlo

select @idpago = rbp_int_id from  [contenedor].[tbl_reserva_booking_servicio_adicional]
where rbd_int_id = @rbd_int_id

 delete from [contenedor].[tbl_reserva_booking_servicio_adicional]
 where rbd_int_id = @rbd_int_id

delete from [contenedor].[tbl_reserva_booking_pago]
where rbp_int_id = @idpago





GO
/****** Object:  StoredProcedure [contenedor].[pa_insertadjuntos]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_insertadjuntos]
(
	@booking varchar(30),
	@mlt_int_id_tipo_documento bigint ,
	@mlt_str_valor_tipo_documento char(4) ,
	@rba_str_nombre_archivo varchar(100) ,
	@rba_str_usuario_creacion varchar(100)
)
as
declare @rb_int_id bigint
select @rb_int_id=rb_int_id from contenedor.tbl_reserva_booking where rb_str_numero_booking=@booking
insert into contenedor.tbl_reserva_booking_adjuntos values(@rb_int_id,@mlt_int_id_tipo_documento,@mlt_str_valor_tipo_documento,@rba_str_nombre_archivo,getdate(),	@rba_str_usuario_creacion )
GO
/****** Object:  StoredProcedure [contenedor].[pa_insertaraux]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






  ALTER PROCEDURE [contenedor].[pa_insertaraux]
  ( @rb_int_identificador_terminal bigint 
,@rb_str_cod_cliente_factura  varchar(20)
,@rb_str_cliente_factura_descripcion varchar(100)
,@rb_str_cod_consolidador varchar(20)
,@rb_str_consolidador_descripcion varchar(100)
,@rb_str_cod_operador_logistivo varchar(20)
,@rb_str_cod_operador_descripcion varchar(100)
,@rb_str_cod_agente_aduana varchar(20) 
,@rb_str_cod_agente_aduana_descripcion varchar(100)
,@rb_str_cif_agente_aduana varchar(20)
,@rb_str_cif_agente_carga varchar(20)
)
as
declare @existe int 
select @existe = count(rb_int_identificador_terminal) from contenedor.tbl_reserva_booking_aux
where rb_int_identificador_terminal =  @rb_int_identificador_terminal

if @existe = 1 
begin

update contenedor.tbl_reserva_booking_aux 
set rb_str_cod_cliente_factura = @rb_str_cod_cliente_factura
, rb_str_cliente_factura_descripcion = @rb_str_cliente_factura_descripcion
,rb_str_cod_consolidador = @rb_str_cod_consolidador
,rb_str_consolidador_descripcion = @rb_str_consolidador_descripcion
,rb_str_cod_operador_logistivo = @rb_str_cod_operador_logistivo
,rb_str_cod_operador_descripcion = @rb_str_cod_operador_descripcion
,rb_str_cod_agente_aduana = @rb_str_cod_agente_aduana
,rb_str_cod_agente_aduana_descripcion = @rb_str_cod_agente_aduana_descripcion
,rb_str_cif_agente_aduana= @rb_str_cif_agente_aduana
,rb_str_cif_agente_carga = @rb_str_cif_agente_carga
where 
rb_int_identificador_terminal = @rb_int_identificador_terminal
end
else
begin
--select * from contenedor.tbl_reserva_booking_aux

		  insert into contenedor.tbl_reserva_booking_aux(rb_int_identificador_terminal
		,rb_str_cod_cliente_factura
		,rb_str_cliente_factura_descripcion
		,rb_str_cod_consolidador
		,rb_str_consolidador_descripcion
		,rb_str_cod_operador_logistivo
		,rb_str_cod_operador_descripcion
		,rb_str_cod_agente_aduana
		,rb_str_cod_agente_aduana_descripcion
		,rb_str_cif_agente_aduana 
		,rb_str_cif_agente_carga
		)
		values ( @rb_int_identificador_terminal
		,@rb_str_cod_cliente_factura
		,@rb_str_cliente_factura_descripcion
		,@rb_str_cod_consolidador
		,@rb_str_consolidador_descripcion
		,@rb_str_cod_operador_logistivo
		,@rb_str_cod_operador_descripcion
		,@rb_str_cod_agente_aduana
		,@rb_str_cod_agente_aduana_descripcion
		,@rb_str_cif_agente_aduana
        ,@rb_str_cif_agente_carga)

end


GO
/****** Object:  StoredProcedure [contenedor].[pa_insertbooking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER PROCEDURE [contenedor].[pa_insertbooking]
	(
	@rb_str_numero_booking varchar(20),
	@rb_str_oficina varchar(20)  ,
	@rb_str_oficina_descripcion varchar(500) ,
	@rb_str_depot varchar(20)  ,
	@rb_str_depot_descripcion varchar(500) ,
	--@rb_str_tipo_reserva varchar(3)  ,
	--@rb_str_tipo_reserva_descripcion varchar(500) ,
	--@rb_str_fecha_reserva varchar(8) ,
	--@rb_str_hora_reserva varchar(6) ,
	@rb_str_codigo_cliente varchar(30) ,
	@rb_str_codigo_cliente_cif varchar(30) ,
	@rb_str_codigo_cliente_descripcion varchar(500) ,
	@rb_str_codigo_agente_carga varchar(30) ,
	@rb_str_codigo_agente_carga_descripcion varchar(500) ,
	@rb_str_codigo_buque varchar(30) ,
	@rb_str_codigo_buque_descripcion varchar(500) ,
	@rb_str_viaje varchar(30) ,
	@rb_str_codigo_puerto_origen varchar(30) ,
	@rb_str_codigo_puerto_origen_descripcion varchar(500) ,
	@rb_str_codigo_puerto_destino varchar(30) ,
	@rb_str_codigo_puerto_destino_descripcion varchar(500) ,
	@rb_str_codigo_puerto_destino_final varchar(30) ,
	@rb_str_codigo_puerto_destino_final_descripcion varchar(500) ,
	@rb_str_fecha_eta varchar(8) ,
	@rb_str_hora_eta varchar(6) ,
	@rb_str_producto varchar(20) ,
	@rb_str_subproducto varchar(20) ,
	@rb_int_espacios int  ,
	@rb_str_ws_estado varchar(20) ,
	@rb_str_consolidador varchar(20) ,
	@rb_str_operador_logistico varchar(20) ,
	@rb_str_agente_aduana varchar(20) ,


	--@mlt_int_id_estado_reserva bigint  ,
	--@mlt_str_estado_reserva char(2)  ,
	--@rb_int_identificador_terminal numeric(9, 0) ,
		@rb_int_identificador_terminal varchar(10) ,

	--@rb_dat_fecha_creacion datetime ,
	@rb_str_usuario_creacion varchar(100),
	@rb_str_mercancia varchar(500)='',
	@rb_str_tipo_usuario varchar(4)='E'
	)
	as 
	If @rb_int_identificador_terminal=''
	BEGIN
	SET @rb_int_identificador_terminal=NULL
	END
	insert into contenedor.tbl_reserva_booking (rb_str_numero_booking ,
	rb_str_oficina ,
	rb_str_oficina_descripcion ,
	rb_str_depot  ,
	rb_str_depot_descripcion  ,

	rb_str_codigo_cliente ,
	rb_str_codigo_cliente_cif ,
	rb_str_codigo_cliente_descripcion  ,
	rb_str_codigo_agente_carga  ,
	rb_str_codigo_agente_carga_descripcion  ,
	rb_str_codigo_buque ,
	rb_str_codigo_buque_descripcion  ,
	rb_str_viaje  ,
	rb_str_codigo_puerto_origen ,
	rb_str_codigo_puerto_origen_descripcion ,
	rb_str_codigo_puerto_destino  ,
	rb_str_codigo_puerto_destino_descripcion ,
	rb_str_codigo_puerto_destino_final ,
	rb_str_codigo_puerto_destino_final_descripcion  ,
	rb_str_fecha_eta ,
	rb_str_hora_eta  ,
	rb_str_producto  ,
	rb_str_subproducto,
	rb_int_espacios  ,
	rb_str_ws_estado  ,
	rb_str_consolidador  ,
	rb_str_operador_logistico  ,
	rb_str_agente_aduana  ,
	rb_int_identificador_terminal  ,

	rb_dat_fecha_creacion  ,
	rb_str_mercancia,
	rb_str_usuario_creacion)
	values(@rb_str_numero_booking ,
	@rb_str_oficina ,
	@rb_str_oficina_descripcion ,
	@rb_str_depot  ,
	@rb_str_depot_descripcion  ,

	@rb_str_codigo_cliente ,
	@rb_str_codigo_cliente_cif ,
	@rb_str_codigo_cliente_descripcion  ,
	@rb_str_codigo_agente_carga  ,
	@rb_str_codigo_agente_carga_descripcion  ,
	@rb_str_codigo_buque ,
	@rb_str_codigo_buque_descripcion  ,
	@rb_str_viaje  ,
	@rb_str_codigo_puerto_origen ,
	@rb_str_codigo_puerto_origen_descripcion ,
	@rb_str_codigo_puerto_destino  ,
	@rb_str_codigo_puerto_destino_descripcion ,
	@rb_str_codigo_puerto_destino_final ,
	@rb_str_codigo_puerto_destino_final_descripcion  ,
	@rb_str_fecha_eta ,
	@rb_str_hora_eta  ,
	@rb_str_producto  ,
	@rb_str_subproducto,
	@rb_int_espacios  ,
	@rb_str_ws_estado  ,
	@rb_str_consolidador  ,
	@rb_str_operador_logistico  ,
	@rb_str_agente_aduana  ,
	@rb_int_identificador_terminal  ,

	getdate()  ,
	@rb_str_mercancia,
	@rb_str_usuario_creacion)

	--select * from contenedor.tbl_reserva_booking
GO
/****** Object:  StoredProcedure [contenedor].[pa_listar_booking_detalle_adjuntos]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [contenedor].[pa_listar_booking_detalle_adjuntos]
(
	@rb_int_id bigint
)
as 
	select	a.rba_int_id
			,a.rb_int_id
			,a.mlt_int_id_tipo_documento
			,tdoc.mlt_str_nombre  as mlt_str_valor_tipo_documento
			,a.rba_str_nombre_archivo
			,a.rba_dat_fecha_creacion
			,a.rba_str_usuario_creacion
			,mlt_str_tipo_documento_descripcion = configuracion.fn_obtener_descripcion_multiuso(a.mlt_int_id_tipo_documento, a.mlt_str_valor_tipo_documento)  
			,b.rb_str_numero_booking
	from contenedor.tbl_reserva_booking_adjuntos a
	inner join contenedor.tbl_reserva_booking b on b.rb_int_id = a.rb_int_id
	inner join configuracion.tbl_multiuso tdoc
		on tdoc.mlt_str_valor = a.mlt_str_valor_tipo_documento
	where b.rb_int_id = @rb_int_id;

GO
/****** Object:  StoredProcedure [contenedor].[pa_listar_booking_detalle_despacho]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [contenedor].[pa_listar_booking_detalle_despacho]
(
	@rb_str_numero_booking varchar(10),
	@rbd_int_id bigint = null
)
as 

	select  d.rbd_int_id
			,d.rb_int_id
			,d.rbd_str_matricula_equipamiento
			,d.rbd_str_fecha_estimada
			,d.rbd_str_estado_bookingdet
			,d.rbd_str_ent_cif_transportista
			--,d.rbd_str_ent_nombre_transportista
			,d.rbd_str_trans_matricula_camion
			,d.rbd_str_trans_nif_conductor
			,d.rbd_str_trans_nombre_conductor
			,d.rbd_str_fecha_recojo
			,d.rbd_str_hora_recojo
			,b.rb_str_numero_booking
	from contenedor.tbl_reserva_booking_detalle d
	inner join contenedor.tbl_reserva_booking b on b.rb_int_id = d.rb_int_id
	where	b.rb_str_numero_booking = @rb_str_numero_booking
			and (@rbd_int_id is null or d.rbd_int_id = @rbd_int_id)
	-- sp_help 'contenedor.tbl_reserva_booking_detalle'
	


GO
/****** Object:  StoredProcedure [contenedor].[pa_listar_datos_booking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
exec [contenedor].pa_listar_datos_booking null,null,null,null,'gcuentasj'    
exec [contenedor].pa_listar_datos_booking null,null,null,null,'gcuentasj'    
exec [contenedor].pa_listar_datos_booking_mg null,null,null,null,'Demo'    
*/
ALTER PROCEDURE [contenedor].[pa_listar_datos_booking] (
	@rb_str_numero_booking VARCHAR(20) = NULL
	,@rb_dat_fecha_reserva_inicio DATETIME = NULL
	,@rb_dat_fecha_reserva_fin DATETIME = NULL
	,@mlt_str_estado_reserva CHAR(2) = NULL
	,@sp_str_Usuario VARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	---|    
	DECLARE @viIdUsuario INT;
	DECLARE @viTipoUsuario VARCHAR(10);
	DECLARE @viRucUsuario VARCHAR(20);

	---|    
	SELECT @viIdUsuario = usr_int_id
		,@viTipoUsuario = usr_str_tipoacceso
	FROM seguridad.tbl_usuario
	WHERE UPPER(RTRIM(LTRIM(usr_str_red))) = UPPER(RTRIM(LTRIM(@sp_str_Usuario)))

	----------------------------    
	IF (@sp_str_Usuario = 'gcuentasj')
	BEGIN
		SET @viTipoUsuario = 'AD'
	END

	----------------------------    
	---|    
	IF (@viTipoUsuario = 'EX')
	BEGIN
		--|    
		SET @viRucUsuario = '0';

		-- select *  from [dbo].[tbl_usuario_cliente]     
		SELECT TOP 1 @viRucUsuario = ruc_str_numero
		FROM [dbo].[tbl_usuario_cliente]
		WHERE usr_int_id = @viIdUsuario
		ORDER BY ucl_int_id ASC;

		----|    
		--IF (@viRucUsuario = '0')    
		-- BEGIN    
		--  SELECT   b.rb_int_id    
		--     ,b.rb_str_numero_booking    
		--     ,b.rb_int_espacios    
		--     ,b.mlt_int_id_estado_reserva    
		--     ,b.mlt_str_estado_reserva    
		--     ,mlt_str_estado_reserva_nombre  = configuracion.fn_obtener_descripcion_multiuso(b.mlt_int_id_estado_reserva, b.mlt_str_estado_reserva)    
		--     ,b.rb_dat_fecha_creacion    
		--     ,b.rb_str_usuario_creacion    
		--  FROM  contenedor.tbl_reserva_booking b    
		--  WHERE  1 = 2;    
		--  RETURN;    
		-- END    
		--|    
		SELECT TOP 100 b.rb_int_id
			,b.rb_str_numero_booking
			,b.rb_int_espacios
			,b.mlt_int_id_estado_reserva
			--,b.mlt_str_estado_reserva    
			,mlt_str_estado_reserva = CASE 
				WHEN (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
							AND pago.rpb_str_estado_pago = 'PG'
						) =
					 (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
					 ) AND (
								SELECT COUNT(*)
								FROM contenedor.tbl_reserva_booking_pago pago
								WHERE pago.rb_int_id = b.rb_int_id
									AND pago.rpb_str_estado_pago = 'PG'
							) > 0
					THEN 'PG'
				ELSE b.mlt_str_estado_reserva
				END
			,mlt_str_estado_reserva_nombre = CASE 
				WHEN (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
							AND pago.rpb_str_estado_pago = 'PG'
					 )
						=
					 (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
					 ) AND (
								SELECT COUNT(*)
								FROM contenedor.tbl_reserva_booking_pago pago
								WHERE pago.rb_int_id = b.rb_int_id
									AND pago.rpb_str_estado_pago = 'PG'
							) > 0
					THEN configuracion.fn_obtener_descripcion_multiuso(1, 'PG')
				ELSE (
						CASE 
							WHEN b.mlt_str_estado_reserva = 'PE'
								THEN 'Pendiente'
							ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
							END
						)
				END
			--,CASE     
			-- WHEN b.mlt_str_estado_reserva = 'PE'    
			--  THEN 'Pendiente'    
			-- ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)    
			-- END mlt_str_estado_reserva_nombre    
			,b.rb_dat_fecha_creacion
			,b.rb_str_usuario_creacion
		INTO #TEMPORAL
		FROM contenedor.tbl_reserva_booking b
		INNER JOIN contenedor.tbl_reserva_booking_aux a ON b.rb_int_identificador_terminal = a.rb_int_identificador_terminal
		WHERE (
				@rb_str_numero_booking IS NULL
				OR b.rb_str_numero_booking = rtrim(ltrim(@rb_str_numero_booking))
				)
			--AND (    
			-- @mlt_str_estado_reserva IS NULL    
			-- OR b.mlt_str_estado_reserva = @mlt_str_estado_reserva    
			-- )    
			AND (
				b.rb_str_usuario_creacion = @sp_str_Usuario
				OR a.rb_str_cif_agente_aduana = @viRucUsuario
				OR a.rb_str_cif_agente_carga = @viRucUsuario
				)
		ORDER BY b.rb_dat_fecha_creacion DESC

		SELECT *
		FROM #TEMPORAL
		WHERE (
				@mlt_str_estado_reserva IS NULL
				OR mlt_str_estado_reserva = @mlt_str_estado_reserva
				)
		ORDER BY rb_dat_fecha_creacion DESC

		DROP TABLE #TEMPORAL
	END
	ELSE
	BEGIN
		SELECT TOP 20 b.rb_int_id
			,b.rb_str_numero_booking
			,b.rb_int_espacios
			,b.mlt_int_id_estado_reserva
			,mlt_str_estado_reserva = CASE 
				WHEN (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
							AND pago.rpb_str_estado_pago = 'PG'
						) =
					 (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
					 ) AND (
								SELECT COUNT(*)
								FROM contenedor.tbl_reserva_booking_pago pago
								WHERE pago.rb_int_id = b.rb_int_id
									AND pago.rpb_str_estado_pago = 'PG'
							) > 0
					THEN 'PG'
				ELSE b.mlt_str_estado_reserva
				END
			,mlt_str_estado_reserva_nombre = CASE 
				WHEN (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
							AND pago.rpb_str_estado_pago = 'PG'
					 )
						=
					 (
						SELECT COUNT(*)
						FROM contenedor.tbl_reserva_booking_pago pago
						WHERE pago.rb_int_id = b.rb_int_id
					 ) AND (
								SELECT COUNT(*)
								FROM contenedor.tbl_reserva_booking_pago pago
								WHERE pago.rb_int_id = b.rb_int_id
									AND pago.rpb_str_estado_pago = 'PG'
							) > 0
					THEN configuracion.fn_obtener_descripcion_multiuso(1, 'PG')
				ELSE (
						CASE 
							WHEN b.mlt_str_estado_reserva = 'PE'
								THEN 'Pendiente'
							ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
							END
						)
				END
			--,b.mlt_str_estado_reserva    
			--,CASE     
			-- WHEN b.mlt_str_estado_reserva = 'PE'    
			--  THEN 'Pendiente'    
			-- ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)    
			-- END mlt_str_estado_reserva_nombre    
			,b.rb_dat_fecha_creacion
			,b.rb_str_usuario_creacion
		INTO #TEMPORAL1
		FROM contenedor.tbl_reserva_booking b
		WHERE (
				@rb_str_numero_booking IS NULL
				OR b.rb_str_numero_booking = rtrim(ltrim(@rb_str_numero_booking))
				)
			AND (
				@mlt_str_estado_reserva IS NULL
				OR b.mlt_str_estado_reserva = @mlt_str_estado_reserva
				)
		ORDER BY b.rb_dat_fecha_creacion DESC

		SELECT *
		FROM #TEMPORAL1
		WHERE (
				@mlt_str_estado_reserva IS NULL
				OR mlt_str_estado_reserva = @mlt_str_estado_reserva
				)
		ORDER BY rb_dat_fecha_creacion DESC

		DROP TABLE #TEMPORAL1
	END;

	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [contenedor].[pa_listar_datos_booking_detalle]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_listar_datos_booking_detalle]
(
	@rb_int_id bigint 
)
as 
	select	bd.rbd_int_id
			,bd.rb_int_id
			--,ROW_NUMBER() OVER(ORDER BY bd.rbd_int_id DESC)
			,'CNT' + convert(nvarchar,ROW_NUMBER() OVER(ORDER BY bd.rbd_int_id DESC))   as  rbd_str_matricula_equipamiento
			,bd.rbd_str_fecha_estimada
			,bd.rbd_int_tamanyo
			,bd.rbd_str_tipo
			,bd.rbd_str_precintos
			,bd.rbd_str_temperatura
			,bd.rbd_str_unidad_temperatura
			,bd.rbd_str_humedad
			,bd.rbd_str_ventilacion
			,bd.rbd_str_tipo_carga
			,(SELECT descripcion 
				FROM CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsidescripcionidiomasvaloresaplicacion dva 
				INNER JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsiclavesvaloresaplicacion cva on dva.idcva =cva.id   
				INNER JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsivaloresaplicacion va on cva.idva = va.id 
				WHERE	dva.estado not like 'B%' 
						and cva.estado not like 'B%' 
						and idioma = 'ES'
						and UPPER(va.tipova) = 'TECNOLOGIACONTROLATMOSFERA' and cva.clave=bd.rbd_str_tipo_carga COLLATE SQL_Latin1_General_CP1_CI_AS) AS rbd_str_tipo_tecnologia 
			,bd.rbd_str_reefers
			,bd.rbd_str_estado_bookingdet
			,es.mlt_str_nombre as rbd_str_estado_bookingdet_descripcion
			,bd.rbd_str_ent_cif_transportista
			--,bd.rbd_str_ent_nombre_transportista
			,bd.rbd_str_trans_matricula_camion
			,bd.rbd_str_trans_nif_conductor
			,bd.rbd_str_trans_nombre_conductor
			,bd.rbd_str_fecha_recojo
			,bd.rbd_str_hora_recojo
			,bd.rbd_dat_fecha_creacion
			,bd.rbd_str_usuario_creacion
			,bd.rbd_str_co2
			,rbd_str_o2
	from contenedor.tbl_reserva_booking_detalle bd
	     left join configuracion.tbl_multiuso es
			on es.mlt_str_valor = bd.rbd_str_estado_bookingdet

	where bd.rb_int_id = @rb_int_id

GO
/****** Object:  StoredProcedure [contenedor].[pa_listar_despacho_reservas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [contenedor].[pa_listar_despacho_reservas]
(
	@rb_str_numero_booking varchar(10)
)
as 

	select  d.rbd_int_id
			,d.rb_int_id
			,d.rbd_str_matricula_equipamiento
			,d.rbd_str_fecha_estimada
			,d.rbd_str_estado_bookingdet
			,d.rbd_str_ent_cif_transportista
			,d.rbd_str_trans_matricula_camion
			,d.rbd_str_trans_nif_conductor
			,d.rbd_str_trans_nombre_conductor
			,d.rbd_str_fecha_recojo
			,d.rbd_str_hora_recojo
			,b.rb_str_numero_booking
	from contenedor.tbl_reserva_booking_detalle d
		 inner join contenedor.tbl_reserva_booking b on b.rb_int_id = d.rb_int_id
	where	
		( b.rb_str_numero_booking = @rb_str_numero_booking or @rb_str_numero_booking is null)
	      and isnull(d.rbd_bit_transporteasignado,0) = 1


GO
/****** Object:  StoredProcedure [contenedor].[pa_listaraux]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [contenedor].[pa_listaraux]
@rb_int_identificador_terminal bigint 
as
select 
rb_int_identificador_terminal
,rb_str_cod_cliente_factura
,rb_str_cliente_factura_descripcion
,rb_str_cod_consolidador
,rb_str_consolidador_descripcion
,rb_str_cod_operador_logistivo
,rb_str_cod_operador_descripcion
,rb_str_cod_agente_aduana
,rb_str_cod_agente_aduana_descripcion
  from  contenedor.tbl_reserva_booking_aux
  where rb_int_identificador_terminal = @rb_int_identificador_terminal

GO
/****** Object:  StoredProcedure [contenedor].[pa_obtener_datos_booking]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [contenedor].[pa_obtener_datos_booking]
(
	@numerobooking varchar(20)--,
	--@valor int
)
as 
--if(@valor = 0)
--begin
	declare @mlt_int_id_tipo_documento  bigint;
	select top 1 @mlt_int_id_tipo_documento = mlt_int_id  
	from configuracion.tbl_multiuso where mlt_str_valor2 = 'TIPO_DOCUMENTO'


	Select  b.rb_int_id
			,b.rb_str_numero_booking
			,b.rb_str_oficina
			,b.rb_str_oficina_descripcion
			,b.rb_str_depot
			,b.rb_str_depot_descripcion
			,b.rb_str_tipo_reserva
			,b.rb_str_tipo_reserva_descripcion
			--,b.rb_dat_fecha_reserva
			,b.rb_str_fecha_reserva
			,b.rb_str_codigo_cliente
			,b.rb_str_codigo_cliente_descripcion
			


			,rb_str_cod_cliente_factura  as rb_str_codigo_cliente_factura
			,rb_str_cliente_factura_descripcion as rb_str_codigo_cliente_factura_descripcion

			,rb_str_cod_consolidador
			,rb_str_consolidador_descripcion
			,rb_str_cod_operador_logistivo as rb_str_operador_logistico
			,rb_str_cod_operador_descripcion as rb_str_operador_logistico_descripcion
			,rb_str_cod_agente_aduana as rb_str_agente_aduana 
			,rb_str_cod_agente_aduana_descripcion as rb_str_agente_aduana_descripcion


			,b.rb_str_codigo_agente_carga
			,b.rb_str_codigo_agente_carga_descripcion
			,b.rb_str_codigo_buque
			,b.rb_str_codigo_buque_descripcion
			,b.rb_str_viaje
			,b.rb_str_codigo_puerto_origen
			,b.rb_str_codigo_puerto_origen_descripcion
			,b.rb_str_codigo_puerto_destino
			,b.rb_str_codigo_puerto_destino_descripcion
			,b.rb_str_codigo_puerto_destino_final
			,b.rb_str_codigo_puerto_destino_final_descripcion
			,b.rb_str_fecha_eta
			,b.rb_str_hora_eta
			,b.rb_str_producto
			,b.rb_str_subproducto
			,b.rb_int_espacios
			,b.rb_str_ws_estado
			,b.rb_str_consolidador
			,b.rb_str_operador_logistico
			,b.rb_str_agente_aduana
			,b.rb_str_mercancia
			,b.rb_dec_peso
			,b.rb_bit_checkimo
			,b.rb_str_codigoimo
			,b.rb_bit_servicio_integral
			,b.rb_str_numero_servicio_integral
			,b.rb_str_condicion_origen
			,b.rb_str_local_asignado
			,b.rb_str_embarque_via
			,b.rb_str_movilizado
			,b.rb_str_nombre_contacto
			,b.rb_str_telefono_contacto
			,b.rb_str_email_contacto
			,b.mlt_int_id_estado_reserva
			,b.mlt_str_estado_reserva
			--,mlt_str_estado_reserva_descripcion = configuracion.fn_obtener_descripcion_multiuso(1,b.mlt_str_estado_reserva) 
			,CASE WHEN b.mlt_str_estado_reserva = 'PE' THEN 'Pendiente' ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva) END mlt_str_estado_reserva_descripcion 
			,b.rb_dat_fecha_creacion
			,b.rb_str_usuario_creacion
	from contenedor.tbl_reserva_booking b
	inner join contenedor.tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal

	where b.[rb_str_numero_booking] = @numerobooking

		



	select	ba.rba_int_id 
			,ba.rb_int_id 

			,ba.mlt_int_id_tipo_documento



			,ba.mlt_str_valor_tipo_documento



			--,mlt_str_descripcion_tipo_documento = configuracion.fn_obtener_descripcion_multiuso(1, ba.mlt_str_valor_tipo_documento)
			,CASE WHEN ba.mlt_str_valor_tipo_documento = 'PE' THEN 'Pendiente' ELSE configuracion.fn_obtener_descripcion_multiuso(1, ba.mlt_str_valor_tipo_documento) END mlt_str_descripcion_tipo_documento 


			,ba.rba_str_nombre_archivo 



			,ba.rba_str_usuario_creacion



			,ba.rba_dat_fecha_creacion 



	from contenedor.tbl_reserva_booking_adjuntos ba



	inner join contenedor.tbl_reserva_booking b on b.rb_int_id = ba.rb_int_id



	where b.[rb_str_numero_booking] = @numerobooking



--end
--else
--begin
--		select	--rb_int_identificador_terminal = r.id,
--		--rb_str_numero_booking = r.booking, 
--		rb_str_oficina = r.idoficina,
--		rb_str_oficina_descripcion= o.descripcion, 
--		rb_str_depot = r.idalmacen,
--		rb_str_depot_descripcion = a.nombre,
--		rb_str_tipo_reserva = r.tiporeserva,
--		rb_str_tipo_reserva_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.tiporeserva, 'TIPORESERVADEPOT'),
--		rb_str_fecha_reserva = r.fechareserva,
--		rb_str_hora_reserva = r.horareserva,
--		rb_str_codigo_cliente= r.idcliente,
--		rb_str_codigo_cliente_cif= ent.CIF,
--		rb_str_codigo_cliente_descripcion = ent.nombre,
--		rb_str_codigo_agente_carga = r.idagentecarga,
--		rb_str_codigo_agente_carga_descripcion = entnav.Nombre, 
--		rb_str_codigo_buque= r.idbuque,
--		rb_str_codigo_buque_descripcion = buque.Nombre,
--		rb_str_viaje= r.viaje,
--		rb_str_codigo_puerto_origen = r.idpuertoorigen,
--		rb_str_codigo_puerto_origen_descripcion = po.nombre,
--		rb_str_codigo_puerto_destino = r.idpuertodestino,
--		rb_str_codigo_puerto_destino_descripcion = pd.nombre,
--		rb_str_codigo_puerto_destino_final = r.idpuertodestinofinal,
--		rb_str_codigo_puerto_destino_final_descripcion = pdf.nombre,
--		rb_str_fecha_eta = r.fechaeta,
--		rb_str_hora_eta = r.horaeta,
--		rb_str_producto = r.producto,
--		rb_str_subproducto= r.subproducto,
--		rb_str_ws_estado = r.estado,
--		rb_str_consolidador = r.idconsolidador,
--		rb_str_operador_logistico = r.idoperador,
--		rb_str_agente_aduana = r.idagenteaduana,
--		rb_str_mercancia = r.mercancia,
--		rb_dec_peso = r.peso,
--		rb_bit_checkimo = convert(bit, r.snimo), 
--		rb_str_codigoimo = r.numeroimo,
--		rb_bit_servicio_integral = convert(bit, r.snserviciointegral),
--		rb_str_numero_servicio_integral = r.serviciointegral,
--		rb_str_condicion_origen= r.condicionorigen,
--		rb_str_condicion_origen_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.condicionorigen, 'TIPOCONDICIONORIGEN'),
--		rb_str_local_asignado = r.localasignado,
--		rb_str_embarque_via= r.embarquevia,
--		rb_str_embarque_via_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.embarquevia, 'TIPOEMBARQUEVIA'),
--		rb_str_movilizado = r.movilizadoa,
--		rb_str_movilizado_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.movilizadoa, 'TIPOMOVILIZADOA')
--		from CALW12BDSOLPORT.SPOPERATIONS.DBO.spedreservas r
--		inner join CALW12BDSOLPORT.SPOPERATIONS.DBO.spsioficina o on o.id = r.idoficina
--		inner join CALW12BDSOLPORT.SPOPERATIONS.DBO.spalalmacenes a on a.id = r.idalmacen and a.tipoalmacen = 'D'
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spcoentidades ent on ent.id = r.idCliente
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spcoentidades entNav on entNav.id = r.idagentecarga 
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spbmbuque buque on buque.id = r.idBuque 
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 po on po.id = r.idpuertoorigen and po.id > '0'
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 pd on pd.id = r.idpuertodestino and po.id > '0'
--		left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 pdf on pdf.id = r.idpuertodestinofinal and po.id > '0'
--		where r.tiporeserva = 'EPA' and booking is not null and booking = @numerobooking
--end



--sp_help 'contenedor.tbl_reserva_booking'






GO
/****** Object:  StoredProcedure [contenedor].[pa_obtener_datos_booking_Cooperations]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [contenedor].[pa_obtener_datos_booking_Cooperations]  
(  
 @numerobooking varchar(20)  
)  
as   
Select top 1  
rb_str_numero_booking ,  
 rb_str_oficina ,  
 rb_str_oficina_descripcion ,  
 rb_str_depot  ,  
 rb_str_depot_descripcion  ,  
  
 rb_str_codigo_cliente ,  
 rb_str_codigo_cliente_cif ,  
 rb_str_codigo_cliente_descripcion  ,  
 rb_str_codigo_agente_carga  ,  
 rb_str_codigo_agente_carga_descripcion  ,  
 rb_str_codigo_buque ,  
 rb_str_codigo_buque_descripcion  ,  
 rb_str_viaje  ,  
 rb_str_codigo_puerto_origen ,  
 rb_str_codigo_puerto_origen_descripcion ,  
 rb_str_codigo_puerto_destino  ,  
 rb_str_codigo_puerto_destino_descripcion ,  
 rb_str_codigo_puerto_destino_final ,  
 rb_str_codigo_puerto_destino_final_descripcion  ,  
 rb_str_fecha_eta ,  
 rb_str_hora_eta  ,  
 rb_str_producto  ,  
 rb_str_subproducto,  
 rb_int_espacios  ,  
 rb_str_ws_estado  ,  
 b.rb_int_identificador_terminal  ,  
  
 rb_dat_fecha_creacion  ,  
 rb_str_usuario_creacion,  
 rb_str_consolidador  
   ,rb_str_operador_logistico  
   ,rb_str_agente_aduana  
   ,ed.codtam09 rbd_int_tamanyo  
   ,ed.codtip05 rbd_str_tipo  
   ,rb_str_mercancia  
   into #probooking  
 From contenedor.tbl_reserva_booking b  
 --inner join contenedor.tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal  
 left join contenedor.tbl_reserva_booking_detalle det on b.rb_int_id=det.rb_int_id  
 --inner join neptunia2.descarga.dbo.EDBOOKIN13 ed on b.rb_str_numero_booking=ed.BKGCOM13  
 --FEM
 --inner join neptunia2.descarga.dbo.EDPREBOOK13 ed on b.rb_str_numero_booking=ed.bookincomple13  
 inner join Descarga.dbo.EDPREBOOK13 ed on b.rb_str_numero_booking=ed.bookincomple13  
   where b.[rb_str_numero_booking] =@numerobooking--'BOOKING6970'  
   group by rb_str_numero_booking ,  
 rb_str_oficina ,  
 rb_str_oficina_descripcion ,  
 rb_str_depot  ,  
 rb_str_depot_descripcion  ,  
  
 rb_str_codigo_cliente ,  
 rb_str_codigo_cliente_cif ,  
 rb_str_codigo_cliente_descripcion  ,  
 rb_str_codigo_agente_carga  ,  
 rb_str_codigo_agente_carga_descripcion  ,  
 rb_str_codigo_buque ,  
 rb_str_codigo_buque_descripcion  ,  
 rb_str_viaje  ,  
 rb_str_codigo_puerto_origen ,  
 rb_str_codigo_puerto_origen_descripcion ,  
 rb_str_codigo_puerto_destino  ,  
 rb_str_codigo_puerto_destino_descripcion ,  
 rb_str_codigo_puerto_destino_final ,  
 rb_str_codigo_puerto_destino_final_descripcion  ,  
 rb_str_fecha_eta ,  
 rb_str_hora_eta  ,  
 rb_str_producto  ,  
 rb_str_subproducto,  
 rb_int_espacios  ,  
 rb_str_ws_estado  ,  
 b.rb_int_identificador_terminal  ,  
  
 rb_dat_fecha_creacion  ,  
 rb_str_usuario_creacion,  
 rb_str_consolidador  
   ,rb_str_operador_logistico  
   ,rb_str_agente_aduana  
   ,ed.codtam09  
   ,ed.codtip05  
   ,rb_str_mercancia  
   --select * from contenedor.tbl_reserva_booking where rb_str_numero_booking = 'BOOKING6970'  
   --select * from contenedor.tbl_reserva_booking_aux where rb_int_identificador_terminal=202326  
   -- select * from contenedor.tbl_reserva_booking_detalle where rb_int_id=2718  
  
   --select * from neptunia2.descarga.dbo.EDBOOKIN13  
   declare @contar int  
   select @contar=count(*) from #probooking  
   if (@contar>0)   
   begin  
   select * from #probooking  
   end  
   else  
   begin  
   select bkgcom13 as rb_str_numero_booking ,  
 '' rb_str_oficina ,  
 '' rb_str_oficina_descripcion ,  
 '' rb_str_depot  ,  
 '' rb_str_depot_descripcion  ,  
  
 '' rb_str_codigo_cliente ,  
 '' rb_str_codigo_cliente_cif ,  
 '' rb_str_codigo_cliente_descripcion  ,  
 '' rb_str_codigo_agente_carga  ,  
 '' rb_str_codigo_agente_carga_descripcion  ,  
 '' rb_str_codigo_buque ,  
 '' rb_str_codigo_buque_descripcion  ,  
 '' rb_str_viaje  ,  
 '' rb_str_codigo_puerto_origen ,  
 '' rb_str_codigo_puerto_origen_descripcion ,  
 '' rb_str_codigo_puerto_destino  ,  
 '' rb_str_codigo_puerto_destino_descripcion ,  
 '' rb_str_codigo_puerto_destino_final ,  
 '' rb_str_codigo_puerto_destino_final_descripcion  ,  
 '' rb_str_fecha_eta ,  
 '' rb_str_hora_eta  ,  
 '' rb_str_producto  ,  
 '' rb_str_subproducto,  
 '' rb_int_espacios  ,  
 '' rb_str_ws_estado  ,  
 '' rb_int_identificador_terminal  ,  
  
 '' rb_dat_fecha_creacion  ,  
 '' rb_str_usuario_creacion,  
 '' rb_str_consolidador  
   ,'' rb_str_operador_logistico  
   ,'' rb_str_agente_aduana  
   ,''  rbd_int_tamanyo  
   ,''  rbd_str_tipo  
   --FEM
   --,'' rb_str_mercancia from neptunia2.descarga.dbo.EDBOOKIN13 where bkgcom13=@numerobooking  
   ,'' rb_str_mercancia from descarga.dbo.EDBOOKIN13 where bkgcom13=@numerobooking  
   end  
   drop table #probooking



-- exec  [contenedor].[pa_obtener_datos_booking_Cooperations] 'BOOK28ENE05' 


--select * from Descarga.dbo.EDPREBOOK13
GO
/****** Object:  StoredProcedure [contenedor].[pa_obtener_datos_booking_detalle]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [contenedor].[pa_obtener_datos_booking_detalle]
(
	@rbd_int_id bigint 
)
as 
	select	bd.rbd_int_id
			,bd.rb_int_id
			,b.rb_str_codigo_cliente_descripcion
			,b.rb_str_numero_booking
			,bd.rbd_str_matricula_equipamiento
			,bd.rbd_str_fecha_estimada
			,bd.rbd_str_hora_estimada
			,bd.rbd_int_tamanyo
			,bd.rbd_str_tipo
			,bd.rbd_str_precintos
			,bd.rbd_str_temperatura
			,bd.rbd_str_unidad_temperatura
			,bd.rbd_str_humedad
			,bd.rbd_str_ventilacion
			,bd.rbd_str_tipo_carga
			,bd.rbd_str_reefers
			,bd.rbd_str_estado_bookingdet
			,es.mlt_str_nombre as rbd_str_estado_bookingdet_descripcion
			,bd.rb_int_identificador_terminal as rb_int_identificador_terminal_detalle
			,b.rb_int_identificador_terminal as rb_int_identificador_terminal
			,bd.rbd_str_ent_cif_transportista
			,bd.rbd_str_ent_cif_transportista_descripcion
			,bd.rbd_str_trans_matricula_camion
			,bd.rbd_str_trans_nif_conductor
			,bd.rbd_str_trans_nombre_conductor
			,bd.rbd_str_fecha_recojo
			,bd.rbd_str_hora_recojo
			,bd.rbd_dat_fecha_creacion
			,bd.rbd_str_usuario_creacion
	from contenedor.tbl_reserva_booking_detalle bd
		 inner join  contenedor.tbl_reserva_booking b
		    on b.rb_int_id = bd.rb_int_id
	     left join configuracion.tbl_multiuso es
			on es.mlt_str_valor = bd.rbd_str_estado_bookingdet
	where bd.rbd_int_id = @rbd_int_id




GO
/****** Object:  StoredProcedure [contenedor].[pa_obtener_datos_booking_plantilla]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [contenedor].[pa_obtener_datos_booking_plantilla]
(
	@numerobooking varchar(20) 
)
as 
	--declare @mlt_int_id_tipo_documento  bigint;
	--select top 1 @mlt_int_id_tipo_documento = mlt_int_id  
	--from configuracion.tbl_multiuso where mlt_str_valor2 = 'TIPO_DOCUMENTO'


	--Select  --b.rb_int_id
	--		--,b.rb_str_numero_booking
	--		--,
	--		b.rb_str_oficina
	--		,b.rb_str_oficina_descripcion
	--		,b.rb_str_depot
	--		,b.rb_str_depot_descripcion
	--		,b.rb_str_tipo_reserva
	--		,b.rb_str_tipo_reserva_descripcion
	--		--,b.rb_dat_fecha_reserva
	--		--,b.rb_str_fecha_reserva
	--		,b.rb_str_codigo_cliente
	--		,b.rb_str_codigo_cliente_descripcion
	--		,rb_str_cod_cliente_factura  as rb_str_codigo_cliente_factura
	--		,rb_str_cliente_factura_descripcion as rb_str_codigo_cliente_factura_descripcion
	--		,rb_str_cod_consolidador
	--		,rb_str_consolidador_descripcion
	--		,rb_str_cod_operador_logistivo as rb_str_operador_logistico
	--		,rb_str_cod_operador_descripcion as rb_str_operador_logistico_descripcion
	--		,rb_str_cod_agente_aduana as rb_str_agente_aduana 
	--		,rb_str_cod_agente_aduana_descripcion as rb_str_agente_aduana_descripcion
	--		,b.rb_str_codigo_agente_carga
	--		,b.rb_str_codigo_agente_carga_descripcion
	--		,b.rb_str_codigo_buque
	--		,b.rb_str_codigo_buque_descripcion
	--		,b.rb_str_viaje
	--		,b.rb_str_codigo_puerto_origen
	--		,b.rb_str_codigo_puerto_origen_descripcion
	--		,b.rb_str_codigo_puerto_destino
	--		,b.rb_str_codigo_puerto_destino_descripcion
	--		,b.rb_str_codigo_puerto_destino_final
	--		,b.rb_str_codigo_puerto_destino_final_descripcion
	--		,b.rb_str_fecha_eta
	--		,b.rb_str_hora_eta
	--		,b.rb_str_producto
	--		,b.rb_str_subproducto
	--		,b.rb_int_espacios
	--		,b.rb_str_ws_estado
	--		,b.rb_str_consolidador
	--		,b.rb_str_operador_logistico
	--		,b.rb_str_agente_aduana
	--		,b.rb_str_mercancia
	--		,b.rb_dec_peso
	--		,b.rb_bit_checkimo
	--		,b.rb_str_codigoimo
	--		,b.rb_bit_servicio_integral
	--		,b.rb_str_numero_servicio_integral
	--		,b.rb_str_condicion_origen
	--		,b.rb_str_local_asignado
	--		,b.rb_str_embarque_via
	--		,b.rb_str_movilizado
	--		,b.rb_str_nombre_contacto
	--		,b.rb_str_telefono_contacto
	--		,b.rb_str_email_contacto
	--		,b.mlt_int_id_estado_reserva
	--		,'PE' mlt_str_estado_reserva
	--		--,mlt_str_estado_reserva_descripcion = configuracion.fn_obtener_descripcion_multiuso(1,b.mlt_str_estado_reserva) 
	--		,'Pendiente' mlt_str_estado_reserva_descripcion 
	--		,b.rb_dat_fecha_creacion
	--		,b.rb_str_usuario_creacion
	--from contenedor.tbl_reserva_booking b
	--inner join contenedor.tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal
	--where b.[rb_str_numero_booking] = @numerobooking

		
	--select	ba.rba_int_id 
	--		,ba.rb_int_id 
	--		,ba.mlt_int_id_tipo_documento
	--		,ba.mlt_str_valor_tipo_documento
	--		--,mlt_str_descripcion_tipo_documento = configuracion.fn_obtener_descripcion_multiuso(1, ba.mlt_str_valor_tipo_documento)
	--		,  'Pendiente' mlt_str_descripcion_tipo_documento 
	--		,ba.rba_str_nombre_archivo 
	--		,ba.rba_str_usuario_creacion
	--		,ba.rba_dat_fecha_creacion 
	--from contenedor.tbl_reserva_booking_adjuntos ba
	--inner join contenedor.tbl_reserva_booking b on b.rb_int_id = ba.rb_int_id
	--where b.[rb_str_numero_booking] = @numerobooking



		
select	--rb_int_identificador_terminal = r.id,
		--rb_str_numero_booking = r.booking, 
		rb_str_oficina = r.idoficina,
		rb_str_oficina_descripcion= o.descripcion, 
		rb_str_depot = r.idalmacen,
		rb_str_depot_descripcion = a.nombre,
		rb_str_tipo_reserva = r.tiporeserva,
		rb_str_tipo_reserva_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.tiporeserva, 'TIPORESERVADEPOT'),
		rb_str_fecha_reserva = r.fechareserva,
		rb_str_hora_reserva = r.horareserva,
		rb_str_codigo_cliente= r.idcliente,
		rb_str_codigo_cliente_cif= ent.CIF,
		rb_str_codigo_cliente_descripcion = ent.nombre,
		rb_str_codigo_agente_carga = r.idagentecarga,
		rb_str_codigo_agente_carga_descripcion = entnav.Nombre, 
		rb_str_codigo_buque= r.idbuque,
		rb_str_codigo_buque_descripcion = buque.Nombre,
		rb_str_viaje= r.viaje,
		rb_str_codigo_puerto_origen = r.idpuertoorigen,
		rb_str_codigo_puerto_origen_descripcion = po.nombre,
		rb_str_codigo_puerto_destino = r.idpuertodestino,
		rb_str_codigo_puerto_destino_descripcion = pd.nombre,
		rb_str_codigo_puerto_destino_final = r.idpuertodestinofinal,
		rb_str_codigo_puerto_destino_final_descripcion = pdf.nombre,
		rb_str_fecha_eta = r.fechaeta,
		rb_str_hora_eta = r.horaeta,
		rb_str_producto = r.producto,
		rb_str_subproducto= r.subproducto,
		rb_str_ws_estado = r.estado,
		rb_str_consolidador = r.idconsolidador,
		rb_str_operador_logistico = r.idoperador,
		rb_str_agente_aduana = r.idagenteaduana,
		rb_str_mercancia = r.mercancia,
		rb_dec_peso = r.peso,
		rb_bit_checkimo = convert(bit, r.snimo), 
		rb_str_codigoimo = r.numeroimo,
		rb_bit_servicio_integral = convert(bit, r.snserviciointegral),
		rb_str_numero_servicio_integral = r.serviciointegral,
		rb_str_condicion_origen= r.condicionorigen,
		rb_str_condicion_origen_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.condicionorigen, 'TIPOCONDICIONORIGEN'),
		rb_str_local_asignado = r.localasignado,
		rb_str_embarque_via= r.embarquevia,
		rb_str_embarque_via_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.embarquevia, 'TIPOEMBARQUEVIA'),
		rb_str_movilizado = r.movilizadoa,
		rb_str_movilizado_descripcion = dbo.sf_nol_obtener_descripcion_clave_app(r.movilizadoa, 'TIPOMOVILIZADOA')
from CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spedreservas r
inner join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsioficina o on o.id = r.idoficina
inner join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spalalmacenes a on a.id = r.idalmacen and a.tipoalmacen = 'D'
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spcoentidades ent on ent.id = r.idCliente
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spcoentidades entNav on entNav.id = r.idagentecarga 
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spbmbuque buque on buque.id = r.idBuque 
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.poblaciones2 po on po.id = r.idpuertoorigen and po.id > '0'
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.poblaciones2 pd on pd.id = r.idpuertodestino and po.id > '0'
left join CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.poblaciones2 pdf on pdf.id = r.idpuertodestinofinal and po.id > '0'
where r.tiporeserva = 'EPA' and booking is not null and booking = @numerobooking


--select  rb_int_identificador_terminal= rc.id, 
--		rbd_str_matricula_equipamiento = rc.matricula,
--		rbd_str_fecha_estimada = rc.fechaestimada,--isnull(convert(datetime, rc.fechaestimada), convert(datetime, rc.fechamovimiento)),
--		rbd_str_hora_estimada = rc.horaestimada,
--		rbd_int_tamanyo = rc.tamañocontenedor,
--		rbd_str_tipo = rc.tipocontenedor,
--		--rbd_str_tipo_descripcion = null,
--		rbd_str_precintos = rc.precintos,
--		rbd_str_temperatura = rc.temperatura,
--		rbd_str_unidad_temperatura_descripcion = temp.descripcion,
--		rbd_str_unidad_temperatura = rc.unidadmedidatemperatura,
--		rbd_str_humedad = rc.humedad,
--		rbd_str_ventilacion = rc.ventilacion,
--		rbd_str_tipo_carga = null,--rc.
--		rbd_str_reefers = rc.referencia,
--		rbd_str_ent_cif_transportista = rc.idtransportista,
--		rbd_str_ent_cif_transportista_descripcion = rc.transportista,
--		rbd_str_trans_matricula_camion = rc.matriculacamion,
--		rbd_str_trans_nif_conductor = rc.nifconductor,
--		rbd_str_trans_nombre_conductor = rc.conductor,
--		rbd_str_fecha_recojo = rc.fechaasignacion,
--		rbd_str_hora_recojo = rc.HoraAsignacion,
--		rbd_str_estado_bookingdet = null,
--		rbd_str_usuario_creacion = lower(rc.usuario),
--		rbd_dat_fecha_creacion = rc.timestamp,
--		rbd_str_co2 = CO2,
--		rbd_str_o2 = O2
--from spedreservascontenedor rc
--inner join spedreservas r on r.id = rc.idreserva
--left join 
--(
--	SELECT	cva.clave, descripcion FROM spsidescripcionidiomasvaloresaplicacion dva 
--	INNER JOIN spsiclavesvaloresaplicacion cva on dva.idcva =cva.id   
--	INNER JOIN spsivaloresaplicacion va on cva.idva = va.id 
--	WHERE	dva.estado not like 'B%'  and cva.estado not like 'B%' and idioma = 'ES' and UPPER(va.tipova) = 'UNIDADTEMPERATURA'
--) temp on temp.clave = rc.unidadmedidatemperatura
----where rc.fechamovimiento is not null and rc.idtransportista is not null -- and fechaestimada is not null
--where r.booking = @nrobooking; --idReserva in ( select id from spedreservas where booking like 'GUS%')





--sp_help 'contenedor.tbl_reserva_booking'






GO
/****** Object:  StoredProcedure [contenedor].[pa_obtener_datos_booking_prueba]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[pa_obtener_datos_booking_prueba] (
	@numerobooking VARCHAR(20)
	,@valor INT
	)
AS
DECLARE @rb_int_id INT

IF (@valor = 0)
BEGIN
	DECLARE @mlt_int_id_tipo_documento BIGINT;

	SELECT TOP 1 @mlt_int_id_tipo_documento = mlt_int_id
	FROM configuracion.tbl_multiuso
	WHERE mlt_str_valor2 = 'TIPO_DOCUMENTO'

	SELECT b.rb_int_id
		,b.rb_str_numero_booking
		,b.rb_str_oficina
		,b.rb_str_oficina_descripcion
		,b.rb_str_depot
		,b.rb_str_depot_descripcion
		,b.rb_str_tipo_reserva
		,b.rb_str_tipo_reserva_descripcion
		--,b.rb_dat_fecha_reserva
		,b.rb_str_fecha_reserva
		,b.rb_str_codigo_cliente
		,b.rb_str_codigo_cliente_descripcion
		,rb_str_cod_cliente_factura AS rb_str_codigo_cliente_factura
		,rb_str_cliente_factura_descripcion AS rb_str_codigo_cliente_factura_descripcion
		,rb_str_cod_consolidador
		,rb_str_consolidador_descripcion
		,rb_str_cod_operador_logistivo AS rb_str_operador_logistico
		,rb_str_cod_operador_descripcion AS rb_str_operador_logistico_descripcion
		,rb_str_cod_agente_aduana AS rb_str_agente_aduana
		,rb_str_cod_agente_aduana_descripcion AS rb_str_agente_aduana_descripcion
		,b.rb_str_codigo_agente_carga
		,b.rb_str_codigo_agente_carga_descripcion
		,b.rb_str_codigo_buque
		,b.rb_str_codigo_buque_descripcion
		,b.rb_str_viaje
		,b.rb_str_codigo_puerto_origen
		,b.rb_str_codigo_puerto_origen_descripcion
		,b.rb_str_codigo_puerto_destino
		,b.rb_str_codigo_puerto_destino_descripcion
		,b.rb_str_codigo_puerto_destino_final
		,b.rb_str_codigo_puerto_destino_final_descripcion
		,b.rb_str_fecha_eta
		,b.rb_str_hora_eta
		,b.rb_str_producto
		,b.rb_str_subproducto
		,b.rb_int_espacios
		,b.rb_str_ws_estado
		,b.rb_str_consolidador
		,b.rb_str_operador_logistico
		,b.rb_str_agente_aduana
		,b.rb_str_mercancia
		,b.rb_dec_peso
		,b.rb_bit_checkimo
		,b.rb_str_codigoimo
		,b.rb_bit_servicio_integral
		,b.rb_str_numero_servicio_integral
		,b.rb_str_condicion_origen
		,b.rb_str_local_asignado
		,b.rb_str_embarque_via
		,b.rb_str_movilizado
		,b.rb_str_nombre_contacto
		,b.rb_str_telefono_contacto
		,b.rb_str_email_contacto
		,b.mlt_int_id_estado_reserva
		,b.mlt_str_estado_reserva
		--,mlt_str_estado_reserva_descripcion = configuracion.fn_obtener_descripcion_multiuso(1,b.mlt_str_estado_reserva) 
		,CASE 
			WHEN b.mlt_str_estado_reserva = 'PE'
				THEN 'Pendiente'
			ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
			END mlt_str_estado_reserva_descripcion
		,b.rb_dat_fecha_creacion
		,b.rb_str_usuario_creacion
	FROM contenedor.tbl_reserva_booking b
	INNER JOIN contenedor.tbl_reserva_booking_aux au ON b.rb_int_identificador_terminal = au.rb_int_identificador_terminal
	WHERE b.[rb_str_numero_booking] = @numerobooking

	SELECT ba.rba_int_id
		,ba.rb_int_id
		,ba.mlt_int_id_tipo_documento
		,ba.mlt_str_valor_tipo_documento
		--,mlt_str_descripcion_tipo_documento = configuracion.fn_obtener_descripcion_multiuso(1, ba.mlt_str_valor_tipo_documento)
		,CASE 
			WHEN ba.mlt_str_valor_tipo_documento = 'PE'
				THEN 'Pendiente'
			ELSE configuracion.fn_obtener_descripcion_multiuso(14, ba.mlt_str_valor_tipo_documento)
			END mlt_str_descripcion_tipo_documento
		,ba.rba_str_nombre_archivo
		,ba.rba_str_usuario_creacion
		,ba.rba_dat_fecha_creacion
	FROM contenedor.tbl_reserva_booking_adjuntos ba
	INNER JOIN contenedor.tbl_reserva_booking b ON b.rb_int_id = ba.rb_int_id
	WHERE b.[rb_str_numero_booking] = @numerobooking
END

IF @valor = 1
BEGIN
	----declare  int
	----set @rb_int_id = (select max(rb_int_id) + 1 from contenedor.tbl_reserva_booking)
	--		--insert into contenedor.tbl_reserva_booking (
	--		----rb_int_id ,
	--		--rb_str_numero_booking, 
	--		--rb_str_oficina ,
	--		--rb_str_oficina_descripcion, 
	--		--rb_str_depot ,
	--		--rb_str_depot_descripcion ,
	--		--rb_str_tipo_reserva ,
	--		--rb_str_tipo_reserva_descripcion ,--(select [CALW12BDSOLPORT].[SPOPERATIONS].[dbo].[sf_nol_obtener_descripcion_clave_app]('PE', 'TIPORESERVADEPOT')),
	--		--rb_str_fecha_reserva ,
	--		--rb_str_hora_reserva ,
	--		--rb_int_espacios,
	--		--rb_str_codigo_cliente,
	--		--rb_str_codigo_cliente_cif,
	--		--rb_str_codigo_cliente_descripcion ,
	--		--rb_str_codigo_agente_carga ,
	--		--rb_str_codigo_agente_carga_descripcion , 
	--		--rb_str_codigo_buque,
	--		--rb_str_codigo_buque_descripcion ,
	--		--rb_str_viaje,
	--		--rb_str_codigo_puerto_origen ,
	--		--rb_str_codigo_puerto_origen_descripcion ,
	--		--rb_str_codigo_puerto_destino ,
	--		--rb_str_codigo_puerto_destino_descripcion,
	--		--rb_str_codigo_puerto_destino_final ,
	--		--rb_str_codigo_puerto_destino_final_descripcion ,
	--		--rb_str_fecha_eta ,
	--		--rb_str_hora_eta ,
	--		--rb_str_producto ,
	--		--rb_str_subproducto,
	--		--rb_str_ws_estado ,
	--		--rb_str_consolidador ,
	--		--rb_str_operador_logistico ,
	--		--rb_str_agente_aduana ,
	--		--rb_str_mercancia ,
	--		--rb_dec_peso ,
	--		--rb_bit_checkimo , 
	--		--rb_str_codigoimo ,
	--		--rb_bit_servicio_integral ,
	--		--rb_str_numero_servicio_integral ,
	--		--rb_str_condicion_origen,
	--		--rb_str_condicion_origen_descripcion ,--(CALW12BDSOLPORT.SPOPERATIONS.DBO.sf_nol_obtener_descripcion_clave_app(r.condicionorigen, 'TIPOCONDICIONORIGEN')),
	--		--rb_str_local_asignado ,
	--		--rb_str_embarque_via,
	--		--rb_str_movilizado  )
	--		--select	--rb_int_id = @rb_int_id,
	--		--rb_str_numero_booking = r.booking, 
	--		--rb_str_oficina = r.idoficina,
	--		--rb_str_oficina_descripcion= o.descripcion, 
	--		--rb_str_depot = r.idalmacen,
	--		--rb_str_depot_descripcion = a.nombre,
	--		--rb_str_tipo_reserva = r.tiporeserva,
	--		--rb_str_tipo_reserva_descripcion = '',--(select [CALW12BDSOLPORT].[SPOPERATIONS].[dbo].[sf_nol_obtener_descripcion_clave_app]('PE', 'TIPORESERVADEPOT')),
	--		--rb_str_fecha_reserva = r.fechareserva,
	--		--rb_str_hora_reserva = r.horareserva,
	--		--rb_int_espacios=1,
	--		--rb_str_codigo_cliente= r.idcliente,
	--		--rb_str_codigo_cliente_cif= ent.CIF,
	--		--rb_str_codigo_cliente_descripcion = ent.nombre,
	--		--rb_str_codigo_agente_carga = r.idagentecarga,
	--		--rb_str_codigo_agente_carga_descripcion = entnav.Nombre, 
	--		--rb_str_codigo_buque= r.idbuque,
	--		--rb_str_codigo_buque_descripcion = buque.Nombre,
	--		--rb_str_viaje= r.viaje,
	--		--rb_str_codigo_puerto_origen = r.idpuertoorigen,
	--		--rb_str_codigo_puerto_origen_descripcion = po.nombre,
	--		--rb_str_codigo_puerto_destino = r.idpuertodestino,
	--		--rb_str_codigo_puerto_destino_descripcion = pd.nombre,
	--		--rb_str_codigo_puerto_destino_final = r.idpuertodestinofinal,
	--		--rb_str_codigo_puerto_destino_final_descripcion = pdf.nombre,
	--		--rb_str_fecha_eta = r.fechaeta,
	--		--rb_str_hora_eta = r.horaeta,
	--		--rb_str_producto = r.producto,
	--		--rb_str_subproducto= r.subproducto,
	--		--rb_str_ws_estado = r.estado,
	--		--rb_str_consolidador = r.idconsolidador,
	--		--rb_str_operador_logistico = r.idoperador,
	--		--rb_str_agente_aduana = r.idagenteaduana,
	--		--rb_str_mercancia = r.mercancia,
	--		--rb_dec_peso = r.peso,
	--		--rb_bit_checkimo = convert(bit, r.snimo), 
	--		--rb_str_codigoimo = r.numeroimo,
	--		--rb_bit_servicio_integral = convert(bit, r.snserviciointegral),
	--		--rb_str_numero_servicio_integral = r.serviciointegral,
	--		--rb_str_condicion_origen= r.condicionorigen,
	--		--rb_str_condicion_origen_descripcion = '',--(CALW12BDSOLPORT.SPOPERATIONS.DBO.sf_nol_obtener_descripcion_clave_app(r.condicionorigen, 'TIPOCONDICIONORIGEN')),
	--		--rb_str_local_asignado = r.localasignado,
	--		--rb_str_embarque_via= r.embarquevia,
	--		--rb_str_movilizado = r.movilizadoa
	--		--from CALW12BDSOLPORT.SPOPERATIONS.DBO.spedreservas r
	--		--inner join CALW12BDSOLPORT.SPOPERATIONS.DBO.spsioficina o on o.id = r.idoficina
	--		--inner join CALW12BDSOLPORT.SPOPERATIONS.DBO.spalalmacenes a on a.id = r.idalmacen and a.tipoalmacen = 'D'
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spcoentidades ent on ent.id = r.idCliente
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spcoentidades entNav on entNav.id = r.idagentecarga 
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.spbmbuque buque on buque.id = r.idBuque 
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 po on po.id = r.idpuertoorigen and po.id > '0'
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 pd on pd.id = r.idpuertodestino and po.id > '0'
	--		--left join CALW12BDSOLPORT.SPOPERATIONS.DBO.poblaciones2 pdf on pdf.id = r.idpuertodestinofinal and po.id > '0'
	--		--where r.tiporeserva = 'EPA' and booking is not null and booking = '7LIMWA0363'
	--		--set @rb_int_id = @@IDENTITY
	SELECT b.rb_int_id
		,b.rb_str_numero_booking
		,b.rb_str_oficina
		,b.rb_str_oficina_descripcion
		,b.rb_str_depot
		,b.rb_str_depot_descripcion
		,b.rb_str_tipo_reserva
		,b.rb_str_tipo_reserva_descripcion
		--,b.rb_dat_fecha_reserva
		,b.rb_str_fecha_reserva
		,b.rb_str_codigo_cliente
		,b.rb_str_codigo_cliente_descripcion
		--, rb_str_codigo_cliente_factura
		--,rb_str_cliente_factura_descripcion as rb_str_codigo_cliente_factura_descripcion
		--,rb_str_cod_consolidador
		--,rb_str_consolidador_descripcion
		--,rb_str_cod_operador_logistivo as rb_str_operador_logistico
		--,rb_str_cod_operador_descripcion as rb_str_operador_logistico_descripcion
		--,rb_str_cod_agente_aduana as rb_str_agente_aduana 
		--,rb_str_cod_agente_aduana_descripcion as rb_str_agente_aduana_descripcion
		,b.rb_str_codigo_agente_carga
		,b.rb_str_codigo_agente_carga_descripcion
		,b.rb_str_codigo_buque
		,b.rb_str_codigo_buque_descripcion
		,b.rb_str_viaje
		,b.rb_str_codigo_puerto_origen
		,b.rb_str_codigo_puerto_origen_descripcion
		,b.rb_str_codigo_puerto_destino
		,b.rb_str_codigo_puerto_destino_descripcion
		,b.rb_str_codigo_puerto_destino_final
		,b.rb_str_codigo_puerto_destino_final_descripcion
		,b.rb_str_fecha_eta
		,b.rb_str_hora_eta
		,b.rb_str_producto
		,b.rb_str_subproducto
		,b.rb_int_espacios
		,b.rb_str_ws_estado
		,b.rb_str_consolidador
		,b.rb_str_operador_logistico
		,b.rb_str_agente_aduana
		,b.rb_str_mercancia
		,b.rb_dec_peso
		,b.rb_bit_checkimo
		,b.rb_str_codigoimo
		,b.rb_bit_servicio_integral
		,b.rb_str_numero_servicio_integral
		,b.rb_str_condicion_origen
		,b.rb_str_local_asignado
		,b.rb_str_embarque_via
		,b.rb_str_movilizado
		,b.rb_str_nombre_contacto
		,b.rb_str_telefono_contacto
		,b.rb_str_email_contacto
		,b.mlt_int_id_estado_reserva
		,b.mlt_str_estado_reserva
		--,mlt_str_estado_reserva_descripcion = configuracion.fn_obtener_descripcion_multiuso(1,b.mlt_str_estado_reserva) 
		,CASE 
			WHEN b.mlt_str_estado_reserva = 'PE'
				THEN 'Pendiente'
			ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
			END mlt_str_estado_reserva_descripcion
		,b.rb_dat_fecha_creacion
		,b.rb_str_usuario_creacion
	FROM contenedor.tbl_reserva_booking b
	--	--inner join contenedor.tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal
	WHERE b.[rb_str_numero_booking] = @numerobooking
END

--sp_help 'contenedor.tbl_reserva_booking'
IF (@valor = 2)
BEGIN
	SELECT rb_int_id = NULL
		,b.rb_str_numero_booking
		,b.rb_str_oficina
		,b.rb_str_oficina_descripcion
		,b.rb_str_depot
		,b.rb_str_depot_descripcion
		,b.rb_str_tipo_reserva
		,b.rb_str_tipo_reserva_descripcion
		--,b.rb_dat_fecha_reserva
		,rb_str_fecha_reserva = CONVERT(VARCHAR(8),getdate(),112)
		,b.rb_str_codigo_cliente
		,b.rb_str_codigo_cliente_descripcion
		,rb_str_cod_cliente_factura AS rb_str_codigo_cliente_factura
		,rb_str_cliente_factura_descripcion AS rb_str_codigo_cliente_factura_descripcion
		,rb_str_cod_consolidador
		,rb_str_consolidador_descripcion
		,rb_str_cod_operador_logistivo AS rb_str_operador_logistico
		,rb_str_cod_operador_descripcion AS rb_str_operador_logistico_descripcion
		,rb_str_cod_agente_aduana AS rb_str_agente_aduana
		,rb_str_cod_agente_aduana_descripcion AS rb_str_agente_aduana_descripcion
		,b.rb_str_codigo_agente_carga
		,b.rb_str_codigo_agente_carga_descripcion
		,b.rb_str_codigo_buque
		,b.rb_str_codigo_buque_descripcion
		,b.rb_str_viaje
		,b.rb_str_codigo_puerto_origen
		,b.rb_str_codigo_puerto_origen_descripcion
		,b.rb_str_codigo_puerto_destino
		,b.rb_str_codigo_puerto_destino_descripcion
		,b.rb_str_codigo_puerto_destino_final
		,b.rb_str_codigo_puerto_destino_final_descripcion
		,b.rb_str_fecha_eta
		,b.rb_str_hora_eta
		,b.rb_str_producto
		,b.rb_str_subproducto
		,b.rb_int_espacios
		,b.rb_str_ws_estado
		,b.rb_str_consolidador
		,b.rb_str_operador_logistico
		,b.rb_str_agente_aduana
		,b.rb_str_mercancia
		,b.rb_dec_peso
		,b.rb_bit_checkimo
		,b.rb_str_codigoimo
		,rb_bit_servicio_integral=null
		,rb_str_numero_servicio_integral=null
		,b.rb_str_condicion_origen
		,b.rb_str_local_asignado
		,b.rb_str_embarque_via
		,b.rb_str_movilizado
		,b.rb_str_nombre_contacto
		,b.rb_str_telefono_contacto
		,b.rb_str_email_contacto
		,b.mlt_int_id_estado_reserva
		,mlt_str_estado_reserva = 'PE'
		,mlt_str_estado_reserva_descripcion = 'Pendiente'
		--,CASE 
		--	WHEN b.mlt_str_estado_reserva = 'PE'
		--		THEN 'Pendiente'
		--	ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
		--	END mlt_str_estado_reserva_descripcion
		,b.rb_dat_fecha_creacion
		,b.rb_str_usuario_creacion
	FROM contenedor.tbl_reserva_booking b
	INNER JOIN contenedor.tbl_reserva_booking_aux au ON b.rb_int_identificador_terminal = au.rb_int_identificador_terminal
	WHERE b.[rb_str_numero_booking] = @numerobooking
	
	SELECT ba.rba_int_id
		,rb_int_id = NULL
		,ba.mlt_int_id_tipo_documento
		,ba.mlt_str_valor_tipo_documento
		--,mlt_str_descripcion_tipo_documento = configuracion.fn_obtener_descripcion_multiuso(1, ba.mlt_str_valor_tipo_documento)
		,CASE 
			WHEN ba.mlt_str_valor_tipo_documento = 'PE'
				THEN 'Pendiente'
			ELSE configuracion.fn_obtener_descripcion_multiuso(14, ba.mlt_str_valor_tipo_documento)
			END mlt_str_descripcion_tipo_documento
		,ba.rba_str_nombre_archivo
		,ba.rba_str_usuario_creacion
		,ba.rba_dat_fecha_creacion
	FROM contenedor.tbl_reserva_booking_adjuntos ba
	INNER JOIN contenedor.tbl_reserva_booking b ON b.rb_int_id = ba.rb_int_id
	WHERE b.[rb_str_numero_booking] = @numerobooking
	
END

IF @valor = 3
BEGIN
	SELECT rb_int_id = NULL
		,b.rb_str_numero_booking
		,b.rb_str_oficina
		,b.rb_str_oficina_descripcion
		,b.rb_str_depot
		,b.rb_str_depot_descripcion
		,b.rb_str_tipo_reserva
		,b.rb_str_tipo_reserva_descripcion
		--,b.rb_dat_fecha_reserva
		,rb_str_fecha_reserva = CONVERT(VARCHAR(8),getdate(),112)
		,b.rb_str_codigo_cliente
		,b.rb_str_codigo_cliente_descripcion
		--, rb_str_codigo_cliente_factura
		--,rb_str_cliente_factura_descripcion as rb_str_codigo_cliente_factura_descripcion
		--,rb_str_cod_consolidador
		--,rb_str_consolidador_descripcion
		--,rb_str_cod_operador_logistivo as rb_str_operador_logistico
		--,rb_str_cod_operador_descripcion as rb_str_operador_logistico_descripcion
		--,rb_str_cod_agente_aduana as rb_str_agente_aduana 
		--,rb_str_cod_agente_aduana_descripcion as rb_str_agente_aduana_descripcion
		,b.rb_str_codigo_agente_carga
		,b.rb_str_codigo_agente_carga_descripcion
		,b.rb_str_codigo_buque
		,b.rb_str_codigo_buque_descripcion
		,b.rb_str_viaje
		,b.rb_str_codigo_puerto_origen
		,b.rb_str_codigo_puerto_origen_descripcion
		,b.rb_str_codigo_puerto_destino
		,b.rb_str_codigo_puerto_destino_descripcion
		,b.rb_str_codigo_puerto_destino_final
		,b.rb_str_codigo_puerto_destino_final_descripcion
		,b.rb_str_fecha_eta
		,b.rb_str_hora_eta
		,b.rb_str_producto
		,b.rb_str_subproducto
		,b.rb_int_espacios
		,b.rb_str_ws_estado
		,b.rb_str_consolidador
		,b.rb_str_operador_logistico
		,b.rb_str_agente_aduana
		,b.rb_str_mercancia
		,b.rb_dec_peso
		,b.rb_bit_checkimo
		,b.rb_str_codigoimo
		,rb_bit_servicio_integral=null
		,rb_str_numero_servicio_integral=null
		,b.rb_str_condicion_origen
		,b.rb_str_local_asignado
		,b.rb_str_embarque_via
		,b.rb_str_movilizado
		,b.rb_str_nombre_contacto
		,b.rb_str_telefono_contacto
		,b.rb_str_email_contacto
		,b.mlt_int_id_estado_reserva
		,mlt_str_estado_reserva = 'PE'
		,mlt_str_estado_reserva_descripcion = 'Pendiente'
		,CASE 
			WHEN b.mlt_str_estado_reserva = 'PE'
				THEN 'Pendiente'
			ELSE configuracion.fn_obtener_descripcion_multiuso(1, b.mlt_str_estado_reserva)
			END mlt_str_estado_reserva_descripcion
		,b.rb_dat_fecha_creacion
		,b.rb_str_usuario_creacion
	FROM contenedor.tbl_reserva_booking b
	--	--inner join contenedor.tbl_reserva_booking_aux au on b.rb_int_identificador_terminal = au.rb_int_identificador_terminal
	WHERE b.[rb_str_numero_booking] = @numerobooking
END

GO
/****** Object:  StoredProcedure [contenedor].[USP_NOL_LISTAR_DESPACHADORES]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[USP_NOL_LISTAR_DESPACHADORES]
@RUC VARCHAR(500)
AS
BEGIN

--EXEC TERMINAL.DBO.USP_NOL_LISTAR_DESPACHADORES 'LOO ARROYO PATRICIA'
EXEC TERMINAL.DBO.USP_NOL_LISTAR_DESPACHADORES @RUC

END
GO
/****** Object:  StoredProcedure [contenedor].[usp_NOL_ObtenerMsgAlertaStock]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[usp_NOL_ObtenerMsgAlertaStock] (
	@rb_int_id VARCHAR(20)
	)
AS
BEGIN
	DECLARE @Msg VARCHAR(250)
	,@sucursal VARCHAR(6)
	
	SET @Msg = ''
	
	SELECT @sucursal = rb_str_oficina
	FROM contenedor.tbl_reserva_booking
	WHERE rb_int_id = @rb_int_id
	
	IF @sucursal = 'NEPPAI'
	BEGIN
		SET @Msg = 'NST - Por favor para terminar la reserva comunicarse al correo:  ejecutivodelineapaita@neptunia.com.pe, asignaciones.paita@neptunia.com.pe  o al 073-213285'
	END
	IF @sucursal = 'NEPCLL'
	BEGIN
		SET @Msg = 'NST - Por favor para terminar la reserva comunicarse al correo asignaciones@neptunia.com.pe o al 614-2800 Anexos:4812/4816/4817/4823'
	END
	SELECT @Msg AS 'Mensaje'
END

GO
/****** Object:  StoredProcedure [contenedor].[usp_NOL_StockContenedores]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [contenedor].[usp_NOL_StockContenedores] 367,'40','ST',null
ALTER PROCEDURE [contenedor].[usp_NOL_StockContenedores]
(
--@linea VARCHAR(15)
@rb_int_id varchar(20)
,@tamanyo INT
,@tipctr VARCHAR(6)
,@tecnoctr varchar(6)=''
--,@sucursal VARCHAR(6)
)
AS
BEGIN
IF @tecnoctr IS NULL 
	BEGIN 
	SET @tecnoctr=''
	END
DECLARE @linea VARCHAR(15)
DECLARE @sucursal VARCHAR(6)

SELECT @sucursal=rb_str_oficina,@linea=rb_str_codigo_cliente FROM contenedor.tbl_reserva_booking WHERE rb_int_id=@rb_int_id
--PRINT @linea
--PRINT @sucursal

EXEC CALW8BDSOLPORT.SpOperations_Paralelo2.dbo.usp_NOL_StockContenedores @linea,@tamanyo,@tipctr,@sucursal,@tecnoctr

END
GO
/****** Object:  StoredProcedure [contenedor].[usp_tipo_Contenedor]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [contenedor].[usp_tipo_Contenedor]
as
Select Tipo + ' - ' + descripcion as Tipo from contenedor.tbl_reserva_tipo_contenedores
GO
/****** Object:  StoredProcedure [dbo].[busca_OBJTYPE]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:				EDUARDO MILLA
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[busca_OBJTYPE]
@OBJNAME			VARCHAR(250),
@OBJTYPE			VARCHAR(150) OUT,
@OBJSCRP			VARCHAR(MAX) OUT

AS

BEGIN
SET NOCOUNT ON;
	
	SELECT DISTINCT 
		@OBJTYPE = o.type_desc ,
		@OBJSCRP = m.definition 
	FROM sys.sql_modules m  
	INNER JOIN sys.objects  o ON m.object_id=o.object_id 
	WHERE o.name = @OBJNAME
	
END



GO
/****** Object:  StoredProcedure [dbo].[pa_serv_extraer_fotos]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[pa_serv_extraer_fotos]  
AS  
BEGIN  
 --SELECT   
 -- RESER.rb_str_fecha_reserva  
 -- ,FOT.rba_str_nombre_archivo  
 --FROM [contenedor].[tbl_reserva_booking] RESER    
 --INNER JOIN [contenedor].[tbl_reserva_booking_adjuntos] FOT ON RESER.rb_int_id=FOT.rb_int_id  
 --WHERE RESER.rb_str_fecha_reserva = CONVERT(VARCHAR(8),GETDATE(),112) 
 
  SELECT   
  RESER.rb_str_fecha_reserva  
  ,FOT.rba_str_nombre_archivo  
 FROM [contenedor].[tbl_reserva_booking] RESER    
 INNER JOIN [contenedor].[tbl_reserva_booking_adjuntos] FOT ON RESER.rb_int_id=FOT.rb_int_id  
 WHERE substring(FOT.rba_str_nombre_archivo,1,8) = REPLACE(CONVERT(CHAR(10), GETDATE(), 103), '/', '') 
  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_RESERVAS_PEGASO]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REPORT_RESERVAS_PEGASO] @local VARCHAR(6)
AS
BEGIN
	SELECT b.idOficina AS OFICINA
		,b.booking AS BOOKING
		,rb_str_codigo_buque_descripcion AS BUQUE
		,rb_str_viaje AS VIAJE
		,b.fechaETA AS FECHA_ETA
		,b.estado AS ESTADO
		,b.idcliente AS LINEA
		,c.matricula AS CONTENEDOR
		,c.tipocontenedor AS TIPO_CONTENEDOR
		,c.tamañocontenedor AS TAMAÑO_CONTENEDOR
		,c.estado AS ESTADO_CONTENEDOR
		,(cast((convert(DATE, c.FechaEstimada, 121)) AS VARCHAR) + ' ' + SUBSTRING(c.HoraEstimada, 1, 2) + ':' + SUBSTRING(c.HoraEstimada, 4, 2)) AS FECHA_ESTIMADA
		,d.nombre AS AGENTE_DE_CARGA
		,E.nombre AS OPERADOR_LOGISTICO
		,CASE 
			WHEN c.snPagado = 1
				THEN 'SI'
			ELSE 'NO'
			END AS PAGADO
		,c.Factura AS FACTURA
		,g.descripcion AS SUBPRODUCTO
		,b.mercancia AS MERCANCIA
		,rb_str_nombre_contacto AS NOMBRE_CONTACTO
		,rb_str_telefono_contacto AS TELEFONO_CONTACTO
		,rb_str_email_contacto AS EMAIl_CONTACTO
		,rb_dat_fecha_creacion AS FECHA_CREACION
		,ORIGEN = case when isnull(rb_str_nombre_contacto,'') = '' then 'Cooperations'
																   else 'Pegaso'
																   end
	FROM contenedor.tbl_reserva_booking a WITH (NOLOCK)
	INNER JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spedreservas b WITH (NOLOCK) ON b.id = a.rb_int_identificador_terminal
	LEFT JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spedreservascontenedor c WITH (NOLOCK) ON c.idreserva = a.rb_int_identificador_terminal
	LEFT JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spcoentidades d WITH (NOLOCK) ON d.id = a.rb_str_codigo_agente_carga collate SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spcoentidades e WITH (NOLOCK) ON e.id = a.rb_str_operador_logistico collate SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsiclavesvaloresaplicacion f WITH (NOLOCK) ON f.clave = b.producto
		AND f.ClaveJerarquica = b.subproducto
	LEFT JOIN CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spsidescripcionidiomasvaloresaplicacion g WITH (NOLOCK) ON g.idcva = f.id
	WHERE rb_dat_fecha_creacion >= '2016-09-27 14:27'
		AND year(rb_dat_fecha_creacion) = year(getdate())
		AND rb_str_oficina = @local
		AND (
			b.estado = 'PE'
			OR ISNULL(b.estado, '') = ''
			)
	ORDER BY rb_dat_fecha_creacion ASC
END

GO
/****** Object:  StoredProcedure [ordenes].[guardar_detalleos]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [ordenes].[guardar_detalleos]
@pNroOr32 char(6)
,@pValing32 decimal(10,2)
,@sNroCar_ char(6)
,@sNroSec_ char(2)
,@sSucursal_ char(2)
as

exec terminal.dbo.sp_Impo_OS_Guarda_Detalle 
 @sCodGenerado= @pNroOr32
,@sCodServicio=N'SUPERVISIÓN DE CARGA'
,@sMonHBL=@pValing32
,@sNroCar=@sNroCar_ 
,@sNroSec=@sNroSec_
,@sSucursal=@sSucursal_
GO
/****** Object:  StoredProcedure [ordenes].[guardar_detalles]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[guardar_detalles]
@pNroOr32 char(6)
,@pValing32 decimal(10,2)
,@sNroCar_ char(6)
,@sNroSec_ char(2)
,@sSucursal_ char(2)
as

exec terminal.dbo.sp_Impo_OS_Guarda_Detalle 
 @sCodGenerado= @pNroOr32
,@sCodServicio=N'SUPERVISIÓN DE CARGA'
,@sMonHBL=@pValing32
,@sNroCar=@sNroCar_ 
,@sNroSec=@sNroSec_
,@sSucursal=@sSucursal_		
GO
/****** Object:  StoredProcedure [ordenes].[listar_cargas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[listar_cargas]   
@navvia char(6)  
,@nrodet char(3) 
,@codcon varchar(50) 
as  

declare @nrocar varchar(20)


select @nrocar = nrocar16 from terminal.dbo.DDCARGAS16   
--where navvia11='054454' and nrodet12='027'  
where navvia11=@navvia  and nrodet12=@nrodet  and codcon04=@codcon

select nrocar16, sucursal, nrosec22 as NroSec  from terminal.dbo.DDCARTAR22  where nrocar16 = @nrocar

--select * from npt1_terminal.dbo.DDCARGAS16
--select * from DDCARGAS16  where navvia11='054454' and nrodet12='083'
GO
/****** Object:  StoredProcedure [ordenes].[pa_actualizarHBL]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_actualizarHBL]   
(  
    @pNroOr32 char(6),  
    @pValing32 decimal(10,2),  
    @pvaling32_2 decimal(10,2),
	@navvia char(6),
	@nrodet char(3),
	@codcon varchar(50) 
)  
as  
/*
-------

declare @pNroOr32 char(6) ='S92592' 
declare @pValing32 decimal(10,2)=322
declare @pvaling32_2 decimal(10,2)=0
declare	@navvia char(6)='055910'
declare	@nrodet char(3)=104
declare	@codcon varchar(50) ='CGMU4945517'

------
*/

declare @nrocar varchar(20)

declare @fecors32 datetime  
declare @codcon35 char(5)  
declare @navvia11 char(6)  
declare @nrodet12 char(3)  
declare @ruccli32 char(11)  
declare @sucursal char(1)  
declare @codcon15 char(1)  
declare @rucpro12 char(11)  

DECLARE @CANTIDAD INT,
@TOT_PAR DECIMAL(10,2),
@resulta DECIMAL(10,2),
@resid DECIMAL(10,2),
@final DECIMAL(10,2),
@i INT = 1;

DECLARE @nrocar16 varchar(20),
@tipo varchar(2) ='M',
@NroSec varchar(20);

--//Actualizar el Volante
if exists(
			select *
			from terminal..DDVOLDES23 
			where navvia11 = @navvia and nrodet12 = @nrodet
		  )
begin
	update TERMINAL..DDORDSER32 set nrosec23 = b.nrosec23
	from terminal..DDORDSER32 a
	inner join TERMINAL..DDVOLDES23 b on a.navvia11 = b.navvia11 and a.nrodet12 = b.nrodet12
	where a.nroors32 = @pNroOr32 and a.status32 <> 'A'
end
--//


select @nrocar = nrocar16 from terminal.dbo.DDCARGAS16   
where navvia11=@navvia  and nrodet12=@nrodet  and codcon04=@codcon

--select nrocar16, sucursal,nrosec22   from npt1_terminal.dbo.DDCARTAR22  where nrocar16 = @nrocar

SELECT @CANTIDAD = COUNT(*)
FROM terminal..DDDETORS33 WHERE nroors32 = @pNroOr32 

--print '@CANTIDAD1'
--print @CANTIDAD
IF (@CANTIDAD=0)
BEGIN 
	SELECT @CANTIDAD=COUNT(*)  FROM terminal.dbo.DDCARTAR22  WHERE nrocar16 = @nrocar
	SET @tipo = 'I';
END

--print '@CANTIDAD'
--print @CANTIDAD

SET @TOT_PAR = (@pValing32 + @pvaling32_2) / @CANTIDAD
--print '@TOT_PAR'
--print @TOT_PAR

SET @resulta = @TOT_PAR;
--print '@resulta'
--print @resulta

SET @resid = (@resulta * @CANTIDAD);
--print '@resid'
--print @resid

SET @final = 0;

IF (@resid > (@pValing32 + @pvaling32_2))
	BEGIN
		SET @final = @resulta - (@resid - (@pValing32 + @pvaling32_2));
	END
ELSE
	BEGIN
		IF (@resid < (@pValing32 + @pvaling32_2))
			BEGIN
				SET @final = ((@pValing32 + @pvaling32_2) - @resid) + @resulta;
			END
		ELSE
			BEGIN
				SET @final = @resulta;
			END
	END
--print 'final'
--print @final
DECLARE @nrosec22 VARCHAR(3)

IF (@tipo ='I')
BEGIN 
--select nrocar16, sucursal,nrosec22   from terminal.dbo.DDCARTAR22  where nrocar16 = @nrocar
	DECLARE registro_cursor CURSOR FOR 

	select nrocar16, sucursal,nrosec22   from terminal.dbo.DDCARTAR22  where nrocar16 = @nrocar

	OPEN registro_cursor
	FETCH NEXT FROM registro_cursor INTO @nrocar16,@sucursal,@NroSec	
	WHILE @@FETCH_STATUS = 0
	BEGIN
			IF(@i<@CANTIDAD)
			BEGIN
					--IF (@tipo ='I')
					--BEGIN
					--print '@nrocar16'
					--print @nrocar16
					--print '@sucursal'
					--print @sucursal
					--print '@NroSec'
					--print @NroSec
					--print '@pNroOr32'
					--print @pNroOr32
					--	print '@resulta1'
					--	print @resulta
						EXEC [ordenes].[guardar_detalles] @pNroOr32,@resulta,@nrocar16,@NroSec,@sucursal
					--END
					--ELSE
					--BEGIN

						--UPDATE npt1_terminal..DDDETORS33
						--SET valcal33 = @resulta
						--WHERE nroors32 = @pNroOr32 AND nrosec22=@nrosec22
					--END
					SET @i=@i+1
			END
			ELSE
			BEGIN
					--IF (@tipo ='I')
										--BEGIN
					--print '@nrocar16'
					--print @nrocar16
					--print '@sucursal'
					--print @sucursal-
					--print '@NroSec'
					--print @NroSec
					--print '@pNroOr32'
					--print @pNroOr32	
					--					print '@final'
					--	print @final
						--EXEC [ordenes].[guardar_detalles] @pNroOr32,@final,@nrocar16,@NroSec,@sucursal
						EXEC [ordenes].[guardar_detalles] @pNroOr32,@resulta,@nrocar16,@NroSec,@sucursal
						
					--END
					--ELSE
					--BEGIN

						--UPDATE npt1_terminal..DDDETORS33
						--SET valcal33 = @final
						--WHERE nroors32 = @pNroOr32 AND nrosec22=@nrosec22
					--END
			END
	FETCH NEXT FROM registro_cursor INTO @nrocar16,@sucursal,@NroSec	
	END
	CLOSE registro_cursor
	DEALLOCATE registro_cursor
END
ELSE
BEGIN
	DECLARE registro_cursor CURSOR FOR 

	SELECT nrosec22 FROM terminal..DDDETORS33 WHERE nroors32 = @pNroOr32

	OPEN registro_cursor
	FETCH NEXT FROM registro_cursor INTO @nrosec22 	
	WHILE @@FETCH_STATUS = 0
	BEGIN
			IF(@i<@CANTIDAD)
			BEGIN
					--IF (@tipo ='I')
					--BEGIN
					--	EXEC [ordenes].[guardar_detalles] @pNroOr32,@resulta,@nrocar,@nrosec22,@sucursal
					--END
					--ELSE
					--BEGIN
						---print '@resulta1'
						---print @resulta
						UPDATE terminal..DDDETORS33
						SET valcal33 = @resulta
						WHERE nroors32 = @pNroOr32 AND nrosec22=@nrosec22
					--END
					SET @i=@i+1
			END
			ELSE
			BEGIN
					--IF (@tipo ='I')
					--BEGIN
					--	EXEC [ordenes].[guardar_detalles] @pNroOr32,@resulta,@nrocar,@nrosec22,@sucursal
					--END
					--ELSE
					--BEGIN
						---print '@final'
						---print @final
						UPDATE terminal..DDDETORS33
						--SET valcal33 = @final
						SET valcal33 =@resulta
						WHERE nroors32 = @pNroOr32 AND nrosec22=@nrosec22
					--END
			END
	FETCH NEXT FROM registro_cursor INTO @nrosec22
	END
	CLOSE registro_cursor
	DEALLOCATE registro_cursor
END
--WHILE (@i<@cantidad)
--	BEGIN
--	print '@resulta1'
--	print @resulta
--		UPDATE TERMINAL..DDDETORS33
--		SET valcal33 = @resulta
--		WHERE nroors32 = @pNroOr32 
--		SET @i=@i+1
--	END

--	 print '@final'
--	 print @final
--	UPDATE TERMINAL..DDDETORS33
--	SET valcal33 = @final
--	WHERE nroors32 = @pNroOr32 


delete from terminal..DDORDSER32_2 where nroors32 = @pNroOr32  
  
Select    
            [nroors32]  
           ,[fecors32]  
           ,[codcon35]  
           ,[navvia11]  
           ,[nrodet12]  
           ,[valing32]  
           ,[ruccli32]  
           ,[sucursal]  
           ,[codcon15]  
           ,[rucpro12]  
           into #temp  
  
        from   terminal..DDORDSER32  
        where nroors32 = @pNroOr32  
  

  
insert into terminal..DDORDSER32_2   
           ([nroors32]  
           ,[fecors32]  
           ,[codcon35]  
           ,[navvia11]  
           ,[nrodet12]  
           ,[valing32_2]  
           ,[ruccli32]  
           ,[sucursal]  
           ,[codcon15]  
           ,[rucpro12]
		   ,[valing32])  
       
         ( Select   
            [nroors32]  
           ,[fecors32]  
           ,[codcon35]  
           ,[navvia11]  
           ,[nrodet12]  
           ,@pvaling32_2  
           ,[ruccli32]  
           ,[sucursal]  
           ,[codcon15]  
           ,[rucpro12]
		   ,@pValing32  from #temp )   
  
 drop table #temp  

 --print 'update'
update TERMINAL.dbo.DDORDSER32  
set valing32 = @pValing32
where nroors32 = @pNroOr32  
--print'@pValing32'
--print @pValing32
--print '@pNroOr32'
--print @pNroOr32

--print @resulta
--print @CANTIDAD
--print @pValing32
--print @pvaling32_2
   
select 'OK' as Respuesta  
GO
/****** Object:  StoredProcedure [ordenes].[pa_eliminarHBL]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_eliminarHBL]

(

    @pNroOr32 char(6),

    @pValing32 decimal(10,2),

    @pvaling32_2 decimal(10,2)

)

as

--update  NPT1_TERMINAL.dbo.DDORDSER32 
--set  Valing32 = @pValing32,
--     Valing32_2 = @pvaling32_2
--WHERE NROORS32  = @pNroOr32;



select 'OK' as Respuesta




GO
/****** Object:  StoredProcedure [ordenes].[pa_eliminarordenservicio]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [ordenes].[pa_eliminarordenservicio]
@ors varchar(50)
as
delete from  TERMINAL.dbo.SERES_ServicioHBL_x_OrdenHBL where nroord32 = @ors

update TERMINAL.dbo.ddordser32
set status32 = 'A'
where  nroors32 = @ors

select 'OK' as resp

GO
/****** Object:  StoredProcedure [ordenes].[pa_eliminartotalesordenservicio]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_eliminartotalesordenservicio]
@Viaje varchar(10)
,@Consolidador varchar(11)
,@Contenedor varchar(11)
,@Numvia varchar(10)
,@Nave varchar(4)
as
begin
	set @Viaje = ltrim(rtrim(@Viaje))
	set @Consolidador = ltrim(rtrim(@Consolidador))
	set @Contenedor = ltrim(rtrim(@Contenedor))
	set @Numvia = ltrim(rtrim(@Numvia))
	set @nave = ltrim(rtrim(@nave))
	
	declare @sNavVia varchar(6)
	
	select @sNavVia = navvia11
	from TERMINAL..DDCABMAN11 with (nolock)
	where codnav08 = @nave and numvia11 = @Numvia
	
	--|Obtener Registros Asociados a los criterios
	DECLARE @IdOrden INT
	SET @IdOrden = 0

	SELECT @IdOrden = isnull(IdOrden, 0)
	FROM TERMINAL..SERES_ORDENES_REGISTRO with (nolock)
	WHERE @sNavVia = NavVia
		AND @Consolidador = Ruc
		AND CodContenedor = @Contenedor
		AND Actual = 1
		
		CREATE TABLE #TableHBL (
		nrocon12 VARCHAR(50)
		,navvia11 VARCHAR(50)
		,nroDet12 VARCHAR(50)
		,nroitm13 VARCHAR(50)
		,sucursal VARCHAR(50)
		)

	INSERT INTO #TableHBL
	EXEC TERMINAL..sp_Impo_OS_Busca_HBL_x_Consolidador @sNavVia
		,@Consolidador
		,@Contenedor

	SELECT 
		ISNULL(C.NroOrs32, '') AS NroOrs32
		,IDENTITY(int,1,1) as ID
		INTO #SERVICIOS
	FROM #TableHBL D
	LEFT OUTER JOIN (
		SELECT A.NroOrs32
			,A.NroDet12
		FROM TERMINAL..DDORDSER32 A(NOLOCK)
		LEFT JOIN TERMINAL..DDORDSER32_2 AA (NOLOCK) ON AA.NROORS32 = A.NROORS32
			AND AA.CODCON35 = A.CODCON35
			AND AA.NAVVIA11 = A.NAVVIA11
		INNER JOIN (
			SELECT NroOrd32
			FROM TERMINAL..SERES_ServicioHBL_x_OrdenHBL with (nolock)
			WHERE IdOrden = @IdOrden
				AND Actual = 1
				AND Proceso != 'Eliminado'
			) B ON A.NroOrs32 = B.NroOrd32
		WHERE A.NROORS32 LIKE 'S%' COLLATE SQL_Latin1_General_CP1_CI_AS
		) C ON D.nroDet12 COLLATE SQL_Latin1_General_CP1_CI_AS = C.NroDet12 COLLATE SQL_Latin1_General_CP1_CI_AS
	  WHERE C.NroOrs32 is not null

	DROP TABLE #TableHBL
	--|
	
	declare @icont int
	,@icont_tot int
	,@nroors32 varchar(6)
	
	set @icont  = '1'
	select @icont_tot = COUNT(*) from #SERVICIOS 
	
	While @icont <= @icont_tot
	begin
		select @nroors32 = NroOrs32
		from #SERVICIOS
		where ID = @icont
		
		--|Eliminacion de Orden de Servicio
		delete from  TERMINAL..SERES_ServicioHBL_x_OrdenHBL where nroord32 = @nroors32

		update TERMINAL.dbo.ddordser32
		set status32 = 'A'
		where  nroors32 = @nroors32
		--|
		set @icont = @icont + 1
	end
	DROP TABLE #SERVICIOS
	select 'OK' as resp
END

GO
/****** Object:  StoredProcedure [ordenes].[pa_listarConsolidadores]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [ordenes].[pa_listarConsolidadores] 
@descrip varchar(20)
as
select CONTRIBUY , NOMBRE from TERMINAL.dbo.AACONSOL02
where CONTRIBUY + NOMBRE like '%'  +  @descrip +  '%'
 order by NOMBRE asc
GO
/****** Object:  StoredProcedure [ordenes].[pa_listarContenedor]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_listarContenedor]-- '004518', ''  
@navvia varchar(20),
@sRucFwd varchar(20),
@conte varchar(20)
as
select distinct b.codcon04 --, a.ruccli12,  a.navvia11    
from TERMINAL.DBO.dddetall12 a (nolock)    
inner join TERMINAL.DBO.drblcont15 b (nolock) on (a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12)    
where a.navvia11 = @navvia   and a.ruccli12=@sRucFwd   and b.codcon04 like'%' +  @conte+ '%'

GO
/****** Object:  StoredProcedure [ordenes].[pa_listarDespachador]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_listarDespachador]
@descrip varchar(20)
as
if (@descrip = '')
begin
	select 'NEPTUNIA' AS despachador, '' nombre 
 end
 else
 select 'NEPTUNIA' AS despachador, nombre from TERMINAL.dbo.AACONSOL02
where CONTRIBUY + NOMBRE like '%' + @descrip + '%'
 order by NOMBRE asc


GO
/****** Object:  StoredProcedure [ordenes].[pa_listarHBL]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_listarHBL] 
(
    @sNavVia char(6),
    @sRucFwd char(11),
    @sCodCon varchar(11),
    @nav varchar(10),
    @numvia varchar(10)
)
AS
--exec NPT1_TERMINAL.dbo.sp_Impo_OS_ObtenerHBL @sNavVia=N'022769',@sRucFwd=N'20504721834',@sCodCon=N'SUDU1733059'
exec  TERMINAL.dbo.sp_Impo_OS_ObtenerHBL_ @sNavVia,@sRucFwd,@sCodCon,@nav,@numvia ;

GO
/****** Object:  StoredProcedure [ordenes].[pa_listarNaves]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_listarNaves] 
@descrip varchar(20)
as
select codnav08, desnav08  from TERMINAL.dbo.DQNAVIER08
where desnav08 like '%'  +  @descrip +  '%'
 order by codnav08 asc

GO
/****** Object:  StoredProcedure [ordenes].[pa_ListarServicios]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_ListarServicios]

@descripcion varchar(50)

as

select distinct codcon14,descon14 

from TERMINAL.dbo.FQCONTAR14 

where descon14 like '%' +  @descripcion + '%'
and codcon14 = 'SUPCA'
order by codcon14 asc

GO
/****** Object:  StoredProcedure [ordenes].[pa_listarViajes]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ordenes].[pa_listarViajes] 
@descrip varchar(20),
@nave varchar(20)
as
 select  numvia11, navvia11,codnav08 , fecdes11
 from TERMINAL.dbo.DDCABMAN11  where navvia11 + numvia11 like  '%' + @descrip + '%'
 and codnav08=@nave order by feclle11 desc

GO
/****** Object:  StoredProcedure [ordenes].[pa_RegistrarOrdenServicio]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [ordenes].[pa_RegistrarOrdenServicio] @CodNave VARCHAR(10)
	,@Numviaje VARCHAR(10)
	,@NavVia VARCHAR(10)
	,@Ruc VARCHAR(20)
	,@CodContenedor VARCHAR(20)
	,@UserDB VARCHAR(10)
	,@Perfil VARCHAR(10)
	,@ini DECIMAL(12, 2)
	,@fin DECIMAL(12, 2)
	,@nrode VARCHAR(10)
	,@tipo VARCHAR(2)
	,@NroOrs32 VARCHAR(20)
	--,@nroors varchar(20)
AS
DECLARE @ors VARCHAR(20)
DECLARE @id INTEGER
declare @monto decimal(12,2)
DECLARE @res VARCHAR(max) = NULL
--TABLA TEMPORAL CON UNA COLUMNA    
DECLARE @t TABLE (resultado VARCHAR(MAX))
/*
SELECT @ors = convert(INTEGER, substring(max(nroors32), 2, LEN(max(nroors32)))) + 1
FROM npt1_terminal.dbo.DDORDSER32
WHERE nroors32 LIKE 'S%'

SELECT @ors = 'S' + @ors --CONCAT('S' , @ors )    

SELECT @ors AS response
*/
IF(@tipo='I')
BEGIN 
	create table #contador
	(
	contador varchar(6)
	)

	insert into #contador
	exec terminal.dbo.sp_Impo_OS_Genera_Codigo

	select @ors = contador 
	from #contador

	drop table #contador

	SELECT @ors AS response


	--DECLARE @res VARCHAR(max) = NULL
	--TABLA TEMPORAL CON UNA COLUMNA    
	--DECLARE @t TABLE (resultado VARCHAR(MAX))

	INSERT INTO @t
	EXEC terminal.dbo.sp_Impo_OS_RegistrarOrdenServicio @CodNave
		,@Numviaje
		,@NavVia
		,@Ruc
		,@CodContenedor
		,@UserDB
		,@Perfil

	SELECT @res = resultado
	FROM @t

	--declare @monto decimal(12,2)

	set @monto = @ini + @fin

	EXEC terminal.dbo.sp_Impo_OS_Guarda_Cabecera @sCodGenerado = @ors
		,@sCodNavVia = @NavVia
		,@sCodServicio = N'SUPERVISIÓN DE CARGA'
		,@sMonHBL = @monto --@ini
		--,@sMonHBL = @monto
		,@sCodDespachador = N'NEPTUNIA'
		,@nrodet = @nrode
		,@nroitm = N'001'
		,@sSucursal = N'3'

	EXEC terminal.dbo.sp_Impo_OS_RegistrarRelacion_OrdSer_x_HBL @IdOrdenServicio = @res
		,@nroOrd32 = @ors
		,@Monto = @ini
		,@UserDB = N'INTRANET'
		,@Perfil = N'AI'
		--select * from  npt1_terminal.dbo.DDORDSER32 order by fecors32 desc    
		--select convert (integer,substring(max(nroors32),2, LEN(max(nroors32)))) + 1  from  npt1_terminal.dbo.DDORDSER32    
		--where nroors32 like 'S%'    
		
		--INSERT INTO  terminal.dbo.DDORDSER32_2 ( valing32,nroors32, navvia11,nrodet12) VALUES(@ini ,@NroOrs32 ,@NavVia,@nrode)
		
		INSERT INTO  terminal.dbo.DDORDSER32_2 ( valing32,nroors32,codcon35, navvia11,nrodet12,valing32_2) VALUES(@ini ,@ors,'SUPCA' ,@NavVia,@nrode,@fin)		
END
ELSE
BEGIN 
PRINT 'm'

	--declare @monto decimal(12,2)
	--DECLARE @res VARCHAR(max) = NULL
	--TABLA TEMPORAL CON UNA COLUMNA    
	--DECLARE @t TABLE (resultado VARCHAR(MAX))

	INSERT INTO @t
	EXEC terminal.dbo.sp_Impo_OS_RegistrarOrdenServicio @CodNave
		,@Numviaje
		,@NavVia
		,@Ruc
		,@CodContenedor
		,@UserDB
		,@Perfil

	SELECT @res = resultado
	FROM @t
	set @monto = @ini + @fin

	EXEC terminal.dbo.sp_Impo_OS_Guarda_Cabecera @sCodGenerado = @NroOrs32
		,@sCodNavVia = @NavVia
		,@sCodServicio = N'SUPERVISIÓN DE CARGA'
		,@sMonHBL = @ini
		--,@sMonHBL = @monto
		,@sCodDespachador = N'NEPTUNIA'
		,@nrodet = @nrode
		,@nroitm = N'001'
		,@sSucursal = N'3'
		--print @NroOrs32
		--print @res
		--print @ini
		EXEC terminal.dbo.sp_Impo_OS_RegistrarRelacion_OrdSer_x_HBL @IdOrdenServicio = @res
		,@nroOrd32 = @NroOrs32
		,@Monto = @ini
		,@UserDB = N'INTRANET'
		,@Perfil = N'AI'

		UPDATE terminal.dbo.DDORDSER32_2 SET valing32=@ini,valing32_2=@fin WHERE nroors32=@NroOrs32 AND  navvia11=@NavVia AND nrodet12= @nrode
	
END
GO
/****** Object:  StoredProcedure [seguridad].[pa_buscarpaginas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  --[seguridad].[pa_buscarpaginas]  '','env'
ALTER PROCEDURE [seguridad].[pa_buscarpaginas]  
@pag_str_codmenu varchar(20)  
,@pag_str_nombre varchar(20)  
as  
if(@pag_str_nombre = '')  
set @pag_str_nombre = null  
  
select   
  --pad.pag_str_codmenu , pad.pag_str_nombre,   
 hi.pag_int_id  
,hi.pag_str_codmenu   
, hi.pag_str_nombre   
, hi.pag_str_tipomenu  
, hi.pag_int_nivel  
, hi.pag_int_secuencia  
, hi.pag_str_controller  
, hi.pag_str_action  
, hi.pag_str_attributes  
  FROM [seguridad].[tbl_seg_pagina] pad   
  inner join seguridad.tbl_seg_pagina  hi  on pad.pag_str_codmenu = hi.pag_str_codmenu_padre   
  where hi.pag_str_codmenu_padre is not null  
  --and (@pag_str_codmenu is null or hi.pag_str_codmenu = @pag_str_codmenu)  
  and (@pag_str_nombre is null or hi.pag_str_nombre  like '%' + @pag_str_nombre + '%')  
  
  
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_buscarpaginas_sistemas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [seguridad].[pa_buscarpaginas_sistemas]  
as  
select   
   pag_int_id  
,pag_str_codmenu   
,pag_str_nombre   
 
  FROM [seguridad].[tbl_seg_pagina] pad   
  where pad.pag_str_codmenu_padre is  null  
  and pag_int_id <> 3

  
  
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_buscarsistemas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_buscarsistemas]  
@nombre varchar(10)  
,@alias varchar(10)  
as  
if(@nombre = '')
set @nombre = null

if(@alias = '')
set @alias = null



    SELECT  pag_int_id  
           ,pag_str_codmenu
		   ,pag_str_nombre
		   ,pag_str_descrip
		   ,pag_str_url
		   ,pag_int_secuencia 
 from seguridad.tbl_seg_pagina  
 where  
 (@nombre is null or pag_str_nombre  like '%'+ @nombre   +'%')  
 and (@alias is null or pag_str_descrip like '%' +   @alias  + '%')  
    and pag_str_tipomenu = 'M'


GO
/****** Object:  StoredProcedure [seguridad].[pa_cambiarcontrasena]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_cambiarcontrasena]
@usr_int_id int
,@password varchar(100)
as
update seguridad.tbl_usuario 
set usr_str_password = [seguridad].[sf_encrypt](@password)
where usr_int_id = @usr_int_id


GO
/****** Object:  StoredProcedure [seguridad].[pa_desbloquearusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_desbloquearusuario]
@usr_int_id int 
as
update seguridad.tbl_usuario
set usr_int_bloqueado = 0
where usr_int_id = @usr_int_id
select @usr_int_id as result

GO
/****** Object:  StoredProcedure [seguridad].[pa_eliminarPagina]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [seguridad].[pa_eliminarPagina]  
@pag_int_id int  
as

declare @existe int
select  @existe  = count(srp_int_id) from   [seguridad].[tbl_seg_sistema_rol_pagina]
where pag_int_id = @pag_int_id

if(@existe > 0)
begin
select 'NO' as Mensaje  
end
else
begin
delete from seguridad.tbl_seg_pagina  
where pag_int_id = @pag_int_id  
select 'OK' as Mensaje  
end
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_eliminarrol]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [seguridad].[pa_eliminarrol] 
@rol_int_id int
as

delete from seguridad.tbl_seg_sistema_rol
where rol_int_id = @rol_int_id

delete from seguridad.tbl_seg_sistema_rol_pagina
where rol_int_id = @rol_int_id

delete from seguridad.tbl_seg_rol
where rol_int_id = @rol_int_id 
select count(rol_int_id) count from seguridad.tbl_seg_rol










GO
/****** Object:  StoredProcedure [seguridad].[pa_eliminarusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
ALTER PROCEDURE [seguridad].[pa_eliminarusuario]  
@usr_int_id int  
as  
declare @conectado integer  
--set @conectado = null  
  
select @conectado  = count( usr_dat_ultfeclogin) from seguridad.tbl_usuario  
 where usr_int_id = @usr_int_id  
 and usr_dat_ultfeclogin is not null  
   
   
 
  
if @conectado = 0  
 begin  
  
delete from [seguridad].[tbl_seg_sistema_rol_usuario]  
where usr_int_id = @usr_int_id  
  
delete from seguridad.tbl_usuario  
where usr_int_id = @usr_int_id  
select 'OK' as Mensaje  
end  
else  
begin   
select 'Este usuario no se puede eliminar' as Mensaje  
end  


GO
/****** Object:  StoredProcedure [seguridad].[pa_establecerClaveUsuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [seguridad].[pa_establecerClaveUsuario]
(
@pusr_int_id INT,
@pusr_str_clave VARCHAR(50)
)
AS
 BEGIN
  
   UPDATE  seguridad.tbl_usuario
   SET     usr_str_password = seguridad.sf_encrypt(@pusr_str_clave)
   WHERE   usr_int_id = @pusr_int_id;
  
   SELECT  @@ROWCOUNT AS filas_afectadas;

 END;



GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_menus]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [seguridad].[pa_listar_menus] 'NEP',2
ALTER PROCEDURE [seguridad].[pa_listar_menus]  
(  
 @sis_str_siglas CHAR(3),  
 @rol_int_id INT  
)  
AS  
  DECLARE @sis_int_id INT;   
  
  SELECT  @sis_int_id = sis_int_id  
  FROM    seguridad.tbl_sistema  
  WHERE   sis_str_siglas = 'NEP';  
  
  SELECT  p.pag_int_id,  
          p.pag_str_codmenu,  
          p.pag_str_codmenu_padre,  
          p.pag_str_nombre,  
          p.pag_str_descrip,  
          p.pag_str_url,  
          p.pag_str_tipomenu,  
          p.pag_int_nivel,  
          p.pag_int_secuencia,  
          rp.rol_int_id,  
          rp.sis_int_id,  
          rp.srp_str_codpermiso,  
          p.pag_str_controller,  
          p.pag_str_action,  
          p.pag_str_attributes,  
          0 AS srp_seleccion  
  FROM    seguridad.tbl_seg_pagina p  
  LEFT JOIN seguridad.tbl_seg_sistema_rol_pagina rp  
          ON rp.pag_int_id = p.pag_int_id AND  
             rp.rol_int_id = @rol_int_id AND  
             rp.sis_int_id = @sis_int_id  
  WHERE   rp.rol_int_id IS NULL AND  
          p.pag_int_nivel > 0  
  AND	  p.pag_str_nombre <> 'PagoEfectivo'
  UNION ALL  
  SELECT  p.pag_int_id,  
          p.pag_str_codmenu,  
          p.pag_str_codmenu_padre,  
          p.pag_str_nombre,  
          p.pag_str_descrip,  
          p.pag_str_url,  
          p.pag_str_tipomenu,  
          p.pag_int_nivel,  
          p.pag_int_secuencia,  
          rp.rol_int_id,  
          rp.sis_int_id,  
          rp.srp_str_codpermiso,  
          p.pag_str_controller,  
          p.pag_str_action,  
          p.pag_str_attributes,  
          1 AS srp_seleccion  
  FROM    seguridad.tbl_seg_pagina p  
  inner JOIN seguridad.tbl_seg_sistema_rol_pagina rp  
          ON rp.pag_int_id = p.pag_int_id AND  
             rp.rol_int_id = @rol_int_id AND  
             rp.sis_int_id = @sis_int_id  
  WHERE   p.pag_int_nivel > 0
  AND	  p.pag_str_nombre <> 'PagoEfectivo';
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_roles]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listar_roles]  
(  
 @rol_str_alias VARCHAR(50)  
)  
as  
SELECT  rol_int_id,  
        rol_str_descrip,  
        rol_str_alias,  
        rol_str_usuario,  
        rol_bit_publico  ,
		rol_bit_activo
FROM    seguridad.tbl_seg_rol  
WHERE  @rol_str_alias IS NULL OR rol_str_alias LIKE '%' + @rol_str_alias + '%'  
;  
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_roles_asignables]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listar_roles_asignables]
(
 @usr_str_red VARCHAR(50),
 @sis_str_siglas VARCHAR(50),
 @rol_str_alias VARCHAR(50),
 @int_rol_sin_asignar SMALLINT -- 0 = sin asignar / 1= rol asignado
)
AS
  IF @int_rol_sin_asignar = 0
    BEGIN 
      SELECT  r.rol_int_id,
              r.rol_str_alias,
              r.rol_str_descrip
      FROM    seguridad.tbl_seg_rol r
      LEFT JOIN (SELECT r.rol_int_id,
                        r.rol_str_alias,
                        r.rol_str_descrip,
                        u.usr_int_id
                 FROM   seguridad.tbl_seg_rol r
                 INNER JOIN seguridad.tbl_seg_sistema_rol_usuario sru ON sru.rol_int_id = r.rol_int_id
                 INNER JOIN seguridad.tbl_sistema s ON s.sis_int_id = sru.sis_int_id
                 INNER JOIN seguridad.tbl_usuario u ON u.usr_int_id = sru.usr_int_id
                 WHERE  u.usr_str_red = @usr_str_red AND
                        s.sis_str_siglas = @sis_str_siglas) AS sru ON sru.rol_int_id = r.rol_int_id
      WHERE   sru.usr_int_id IS NULL AND
              (@rol_str_alias IS NULL OR
               r.rol_str_alias = @rol_str_alias); 
    END;
  ELSE
    BEGIN  
      SELECT  r.rol_int_id,
              r.rol_str_alias,
              r.rol_str_descrip
      FROM    seguridad.tbl_seg_rol r
      INNER JOIN seguridad.tbl_seg_sistema_rol_usuario sru ON sru.rol_int_id = r.rol_int_id
      INNER JOIN seguridad.tbl_sistema s ON s.sis_int_id = sru.sis_int_id
      INNER JOIN seguridad.tbl_usuario u ON u.usr_int_id = sru.usr_int_id
      WHERE   u.usr_str_red = @usr_str_red AND
              s.sis_str_siglas = @sis_str_siglas AND
              (@rol_str_alias IS NULL OR
               r.rol_str_alias = @rol_str_alias);

    END;




GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_roles_por_usuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listar_roles_por_usuario]
(
 @usr_str_red VARCHAR(50)
)
AS
  BEGIN

    DECLARE @usr_int_id INT;
		
    SELECT  @usr_int_id = ISNULL(MAX(usr_int_id), -1)
    FROM    seguridad.tbl_usuario
    WHERE   usr_str_red = @usr_str_red;
	
		
    SELECT  r.rol_int_id,
            r.rol_str_alias,
            r.rol_str_descrip
    FROM    seguridad.tbl_seg_rol r
    INNER JOIN seguridad.tbl_seg_sistema_rol_usuario sru
            ON sru.rol_int_id = r.rol_int_id
    WHERE   sru.usr_int_id = @usr_int_id
    GROUP BY r.rol_int_id,
            r.rol_str_alias,
            r.rol_str_descrip;
		
		

  
  END;




GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_sistemas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listar_sistemas]  
(  
 @pag_int_id INT = NULL  
)  
AS  
  BEGIN  
    SELECT  pag_int_id  
           ,pag_str_codmenu
		   ,pag_str_nombre
		   ,pag_str_descrip
		   ,pag_str_url
		   ,pag_int_secuencia
    FROM    seguridad.tbl_seg_pagina 
    WHERE   (@pag_int_id IS NULL OR  
            pag_int_id = @pag_int_id)  
    and pag_str_tipomenu = 'M'
  END;  
  



GO
/****** Object:  StoredProcedure [seguridad].[pa_listar_usuarios]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listar_usuarios]  
(  
 @usr_str_red VARCHAR(50),  
 @usr_str_nombre_apellido VARCHAR(100),  
 @rol_int_id INT   
   
)  
AS  
  SELECT  u.usr_int_id,  
          u.usr_str_red,  
          u.usr_str_nombre,  
          u.usr_str_apellidos,  
          u.usr_str_email,  
          u.usr_int_bloqueado,  
          u.usr_int_aprobado,  
		  case when u.usr_int_aprobado = 1 then 'Eliminado' else 'Activo' end as Activo,
          u.usr_dat_ultfeclogin,  
          u.usr_dat_ultfecbloqueo,  
          u.usr_dat_fecvctopwd,  
          u.usr_int_numintentos,  
          u.usr_dat_fecregistro,  
          --r.rol_str_alias,  
          nro_roles = COUNT(r.rol_int_id)   
  FROM    seguridad.tbl_usuario u  
  LEFT JOIN seguridad.tbl_seg_sistema_rol_usuario sru ON sru.usr_int_id = u.usr_int_id  
  LEFT JOIN seguridad.tbl_seg_sistema_rol sr ON sr.rol_int_id = sru.rol_int_id  
  LEFT JOIN seguridad.tbl_seg_rol r ON r.rol_int_id = sru.rol_int_id  
  WHERE   (@usr_str_red IS NULL OR  
           u.usr_str_red = @usr_str_red) AND  
          (@usr_str_nombre_apellido IS NULL OR  
           usr_str_nombre + ' ' + usr_str_apellidos LIKE '%' + @usr_str_nombre_apellido + '%') AND  
          (@rol_int_id IS NULL OR  
           sru.rol_int_id = @rol_int_id)  
  GROUP BY u.usr_int_id,  
          u.usr_str_red,  
          u.usr_str_nombre,  
          u.usr_str_apellidos,  
          u.usr_str_email,  
          u.usr_int_bloqueado,  
          u.usr_int_aprobado,  
          u.usr_dat_ultfeclogin,  
          u.usr_dat_ultfecbloqueo,  
          u.usr_dat_fecvctopwd,  
          u.usr_int_numintentos,  
          u.usr_dat_fecregistro--,  
          --r.rol_str_alias;  
  


GO
/****** Object:  StoredProcedure [seguridad].[pa_listarClientesUsuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [seguridad].[pa_listarClientesUsuario] @usr_int_id int
as
begin

select * from [dbo].[tbl_usuario_cliente] where usr_int_id = @usr_int_id

end

GO
/****** Object:  StoredProcedure [seguridad].[pa_listarpaginas]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_listarpaginas]
@pag_str_nombre varchar(10)
as
select  
pag_int_id
,pag_str_codmenu
,pag_str_codmenu_padre
,pag_str_nombre
,pag_str_descrip
,pag_str_url
,pag_str_tipomenu
,pag_int_nivel
,pag_int_secuencia
,pag_str_controller
,pag_str_action
,pag_str_attributes
 from [seguridad].[tbl_seg_pagina]
 where (@pag_str_nombre is null or pag_str_nombre like '%' + @pag_str_nombre + '%')



GO
/****** Object:  StoredProcedure [seguridad].[pa_listarroles]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [seguridad].[pa_listarroles]
@rol_str_descrip varchar(10)
,@rol_str_alias varchar(10)
as
select 
rol_int_id
,rol_str_descrip
,rol_str_alias
,rol_str_usuario
,rol_str_pass
,rol_bit_publico
 from [seguridad].[tbl_seg_rol]
 where (@rol_str_descrip is null or rol_str_descrip like '%'+ @rol_str_descrip + '%' )
 and (@rol_str_alias is null or rol_str_alias like '%'+ @rol_str_alias + '%' )


GO
/****** Object:  StoredProcedure [seguridad].[pa_obtener_datbas_usuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtener_datbas_usuario]
(
 @usr_int_id INT,
 @usr_str_red VARCHAR(50)
)
AS
  SELECT  u.usr_int_id,
          u.usr_str_nombre,
          u.usr_str_apellidos,
          u.usr_str_red,
          u.usr_str_email
  FROM    seguridad.tbl_usuario u
  WHERE   (@usr_int_id IS NULL OR
           u.usr_int_id = @usr_int_id) AND
          (@usr_str_red IS NULL OR
           u.usr_str_red = @usr_str_red);




GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenerpagina]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenerpagina]   
@pag_int_id int  
as  
declare @padre varchar(20)  
declare @cantidad int  
 select @padre = pag_str_codmenu_padre from  [seguridad].[tbl_seg_pagina]  
 where pag_int_id = @pag_int_id   
  
 select @cantidad = count (pag_int_id) from  [seguridad].[tbl_seg_pagina]  
 where pag_str_codmenu_padre = @padre  
  
 select   
pag_int_id  
,@cantidad as cantidad  
,pag_str_codmenu  
,pag_str_codmenu_padre  
,pag_str_nombre  
,pag_int_secuencia  
,pag_str_controller  
,pag_str_action  
,pag_str_attributes  
,pag_str_descrip
,pag_str_url
,pag_bit_activo
,pag_bit_externo
 from [seguridad].[tbl_seg_pagina]  
 where pag_int_id = @pag_int_id 


GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenerpass]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenerpass]
@usr_int_id int
as
select  [seguridad].[sf_decrypt](usr_str_password)     from seguridad.tbl_usuario
where usr_int_id = @usr_int_id 


GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenerpassxmail]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenerpassxmail]-- 'enrique.rojas@riabc.net'
@usr_str_email varchar(50)
as
select  [seguridad].[sf_decrypt](usr_str_password) as usr_str_password
,[usr_str_red]
,[usr_str_nombre]
   from seguridad.tbl_usuario
where usr_str_email = @usr_str_email 


GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenersistema]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenersistema]
@sis_int_id int
as
select 
sis_int_id
,sis_str_nombre
,sis_str_alias
,sis_str_siglas
,sis_bit_activo 
 from seguridad.tbl_sistema
 where sis_int_id = @sis_int_id 



GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenerusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenerusuario]  --'alexandra.lobaton'
(  
 @pusr_str_red VARCHAR(50),  
 @pusr_int_id INT = null  
)  
AS  
  BEGIN  
  
    DECLARE @usr_int_id INT;  
   
 IF  @pusr_int_id is null   
 BEGIN   
  SELECT  @usr_int_id = ISNULL(MAX(usr_int_id), -1)  
  FROM    seguridad.tbl_usuario  
  WHERE   usr_str_red = @pusr_str_red;  
 END  
 ELSE   
 BEGIN  
  set @usr_int_id = @pusr_int_id  
 END;  
   
  --obteniendo datos del usuario  
    SELECT  u.usr_int_id,  
            u.usr_str_nombre,  
            u.usr_str_apellidos,  
            u.usr_str_red,  
            u.usr_str_email,  
            u.usr_int_cambiarpwd,  
            u.usr_int_aprobado,  
            u.usr_int_bloqueado,  
            u.usr_int_online,  
            u.usr_dat_fecregistro,  
            u.usr_dat_ultfecbloqueo,  
            u.usr_dat_ultfeclogin,  
            u.usr_dat_fecvctopwd,  
            u.usr_int_numintentos,  
            sru.sis_int_id,  
            sru.rol_int_id, 
   u.usr_dat_fecvctousuario,  
   u.usr_str_tipoacceso ,
   uXc.ruc_str_numero
    FROM    seguridad.tbl_usuario u  
    LEFT JOIN (SELECT sru.usr_int_id,  
                      MAX(sru.rol_int_id) AS rol_int_id,  
                      MAX(sru.sis_int_id) AS sis_int_id  
               FROM   seguridad.tbl_seg_sistema_rol_usuario sru  
           --    WHERE  sru.rol_bit_prin = 1  
               GROUP BY sru.usr_int_id) sru  
            ON sru.usr_int_id = u.usr_int_id  
	LEFT JOIN tbl_usuario_cliente uXc
			ON uXc.usr_int_id= U.usr_int_id
    WHERE   u.usr_int_id = @usr_int_id;  
    
    
  END;  
  

GO
/****** Object:  StoredProcedure [seguridad].[pa_obtenerUsuario_1]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_obtenerUsuario_1]  
@usr_int_id int   
as  
select usr_int_id  
, usr_str_nombre  
,usr_str_apellidos  
,usr_str_red  
,usr_str_email  
,usr_int_bloqueado  
,usr_int_aprobado as usr_bit_aprobado
  from seguridad.tbl_usuario  
where usr_int_id = @usr_int_id


GO
/****** Object:  StoredProcedure [seguridad].[pa_regenerarapassusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [seguridad].[pa_regenerarapassusuario]
@usr_int_id int
as
declare @len int
declare   @min tinyint = 48
declare  @range tinyint = 74
declare  @exclude varchar(50) = '0:;<=>?@O[]`^\/_'
declare @output varchar(50) 
declare @char char

 set @len = 10
 set @output = ''
 
    while @len > 0 begin
       select @char = char(round(rand() * @range + @min, 0))
       if charindex(@char, @exclude) = 0 begin
           set @output += @char
           set @len = @len - 1
       end
    end
	
update seguridad.tbl_usuario 
set usr_str_password = seguridad.[sf_encrypt](@output)
where usr_int_id = @usr_int_id


select usr_str_email mail , [seguridad].[sf_decrypt](usr_str_password) password from seguridad.tbl_usuario 
where usr_int_id = @usr_int_id



GO
/****** Object:  StoredProcedure [seguridad].[pa_validarexisteusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[pa_validarexisteusuario]
@usr_str_red varchar(20)
,@usr_str_email varchar(20)
as
select count(usr_int_id) as Existe from seguridad.tbl_usuario
where usr_str_red = @usr_str_red
or usr_str_email = @usr_str_email


GO
/****** Object:  StoredProcedure [seguridad].[sp_getdatcnx]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[sp_getdatcnx]
(
	@usr_str_red varchar(30) = null, 
	@rol_int_id bigint = null,
	@sis_int_id bigint = null
)
as 
begin  
	declare @rol_invitado bit = 0;
		
	if @usr_str_red is null and @rol_int_id is null 
	begin 
		select top 1 @rol_int_id = rol_int_id   
		from seguridad.tbl_seg_rol where rol_bit_publico = 1
		set @rol_invitado = 1;
	end;
	
	if @rol_invitado = 1
		begin 
			select	r.rol_int_id,
					r.rol_str_alias, 
					r.rol_str_usuario as usuario, 
					seguridad.sf_obtenerclaverol(r.rol_int_id) as clave
			from seguridad.tbl_seg_rol r
			where r.rol_int_id = @rol_int_id;
				
		end
	else
		begin 
		
			select	r.rol_int_id,
					r.rol_str_alias, 
					r.rol_str_usuario as usuario, 
					seguridad.sf_obtenerclaverol(r.rol_int_id) as clave
			from seguridad.tbl_seg_rol r
			where r.rol_int_id = @rol_int_id;
			--select	p.idperfil,
			--		p.nombreperfil, 
			--		p.bdusrperfil as usuario, 
			--		seguridad.sf_obtenerclaveperfil(up.idperfil) as clave
			--from seguridad.perfil p
			--inner join seguridad.usuarioperfil up on up.idperfil = p.idperfil
			--inner join seguridad.usuario u on u.idusuario = up.idusuario
			--where u.codigousuario = @codigousuario and p.idperfil = @idperfil; 
		end;
		
	

end;

/****** Object:  UserDefinedFunction [seguridad].[sf_obtenerclaveusuario]    Script Date: 02/29/2016 20:32:37 ******/
SET ANSI_NULLS ON




GO
/****** Object:  StoredProcedure [seguridad].[sp_validarusuario]    Script Date: 07/03/2019 03:04:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [seguridad].[sp_validarusuario] 
(
	@usr_str_red varchar(50),
	@usr_str_password varchar(30)
) 
as 
begin
	declare @res varchar(100);
	declare @pwdclaro varchar(30);
	declare @pwdvalido smallint;
	declare @rolinvalido smallint;
	declare @usr_int_id bigint;
	declare @sis_int_id int;
		
		
	begin try		
		--validando si existe el sistema
		--if not exists(select * from seguridad.tbl_sistema where sis_str_siglas = @sis_str_siglas)
		--  raiserror ('El sistema ingresado no existe', 16, 1);
	    
		--hallando el id del sistema
		--select @sis_int_id = sis_int_id
		--from seguridad.tbl_sistema
		--where sis_str_siglas = @sis_str_siglas;
			
		--obteniendo la clave del usuario
		set @res = seguridad.sf_obtenerclaveusuario(@usr_str_red);
		if(SUBSTRING(@res,1, 1) = 'E') 
			raiserror (@res, 16, 1);
		
		--seteando las variables.		
		set @pwdclaro = SUBSTRING(@res,3,len(@res));
		
		--select @pwdclaro;
		set @pwdvalido = 1;
		if(convert(varbinary(2000), @pwdclaro) != convert(varbinary(2000),@usr_str_password))
			set @pwdvalido = 0;
		
		if (@pwdvalido = 0) 
		 begin
		   update seguridad.tbl_usuario
		   set usr_int_numintentos = usr_int_numintentos + 1
		   where usr_str_red = @usr_str_red;
		 end
		else
		 begin
		   update seguridad.tbl_usuario
		   set usr_dat_ultfeclogin = GETDATE()
		   where usr_str_red = @usr_str_red;
		 end;
		
		--obtiendo el id del usuario
		select @usr_int_id = usr_int_id
		from seguridad.tbl_usuario
		where usr_str_red = @usr_str_red	

		--obtiendo los perfiles del usuario
		set @rolinvalido = 1;
		if not exists(select * from seguridad.tbl_seg_sistema_rol_usuario where usr_int_id = @usr_int_id)
			set @rolinvalido = 0;
		 
		select  usr_int_pwdvalido  = @pwdvalido,
				usr_int_rolinvalido = @rolinvalido,
				usr_str_recordarpwd, 
				usr_int_aprobado,
				usr_int_bloqueado,
				usr_dat_fecvctopwd, 
				usr_int_numintentos,
				usr_dat_ultfeclogin,
				usr_str_red,
				usr_int_id
		from seguridad.tbl_usuario
		where usr_int_id = @usr_int_id;
		
		--select r.rol_int_id, r.rol_str_alias, r.rol_str_descrip 
		--from seguridad.tbl_seg_sistema_rol_usuario sru
		--inner join seguridad.tbl_seg_rol r on r.rol_int_id = sru.rol_int_id
		--where sru.sis_int_id = @sis_int_id and sru.usr_int_id = @usr_int_id;
			
	end try
	begin catch
		declare @errormessage nvarchar(4000);
		declare @errorseverity int;
		declare @errorstate int;

		select 
			@errormessage = error_message(),
			@errorseverity = error_severity(),
			@errorstate = error_state();

		raiserror (@errormessage, -- message text.
				   @errorseverity, -- severity.
				   @errorstate -- state.
				   );
	end catch;
		

end;




GO
