USE [TRITON]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CantContxViaje]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_CantContxViaje]
(@nrogui01 as varchar(10))
returns int
begin
declare @valor int
select @valor = count(nrogui01) from DDGUITTR01 (nolock)
where nrogui01 = @nrogui01
return @valor
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CantContxViajeTam]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [dbo].[fn_CantContxViajeTam]  

(@nrogui01 as varchar(10))  

returns varchar(6)  

begin  

declare @tam varchar(6)  

select @Tam=codtam01  

from DDGUITTR01  

where nrogui01 = @nrogui01

group by codtam01  

return @Tam  

end  

GO
/****** Object:  UserDefinedFunction [dbo].[fn_ListaDetFact]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_ListaDetFact]        
(@NroFactura varchar(10))              
returns table          
as             
return        
(select           
--e.codcco06,          
a.cantid01 as Cantidad, a.preuni01,         
a.cantid01 * a.preuni01 as subTotal, b.nropla01, b.brevet01,         
(select codtam01 from DDGUITTR01 where nrogui01 = b.nrogui01 group by codtam01) as codtam01,            
codrut01, kilometros as Kilometros, d.desrut01,            
convert(varchar(3),h.dc_centro_costo) as centroCosto, cencos01 as codultra            
from dbo.DDFACTTR01 as a             
inner join dbo.DCGUITTR01 as b on a.nrodet01 = b.nrodet01             
inner join dbo.CQCIRCUI01 as d on b.idcircuito = d.idcircuito            
left join terminal.dbo.ddcabman11 as e on b.navvia11 = e.navvia11            
--left join dbo.DDGUITTR01 as c on b.nrogui01 = c.nrogui01            
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                      
on substring(b.nropla01,1,2)+'-'+substring(b.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS        
or substring(b.nropla01,1,3)+'-'+substring(b.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS                      
where nrofac01 = @NroFactura --'0010055184'         
) 
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ListaDetFact_OFISIS]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_ListaDetFact_OFISIS] ()          
returns table                
as                   
return           
(select a.nrofac01 factura,   
  m.ruccli01,   
  m.fecemi01,   
  m.tipdoc01,          
  a.cantid01 as Cantidad,   
  a.preuni01,               
  a.cantid01 * a.preuni01 as subTotal,   
  b.nropla01,   
  b.brevet01,               
  (select codtam01 from DDGUITTR01 where nrogui01 = b.nrogui01 group by codtam01) as codtam01,                  
  codrut01,   
  kilometros as Kilometros,   
  d.desrut01,                  
  convert(varchar(3),h.dc_centro_costo) as centroCosto,   
  cencos01 as codultra                  
from dbo.DDFACTTR01 as a           
inner join  dbo.DcFACTTR01 as m on ( a.nrofac01 = m.nrofac01  and a.tipdoc01=m.tipdoc01 and a.idconta01=m.idconta01)                
left join dbo.DCGUITTR01 as b on a.nrodet01 = b.nrodet01                   
left join dbo.CQCIRCUI01 as d on b.idcircuito = d.idcircuito                  
left join terminal.dbo.ddcabman11 as e on b.navvia11 = e.navvia11                  
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                            
on substring(b.nropla01,1,2)+'-'+substring(b.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                            
or substring(b.nropla01,1,3)+'-'+substring(b.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS  
where m.fecemi01>='20090101'            
and m.fecemi01<='20091031'       
AND m.flages01 <> 'A'     
and a.tipser01 = 'T'  -- agregado ultimo   
)     
  
union   
  
select a.nrofac01 factura,  
  m.ruccli01,  
  m.fecemi01,      
  m.tipdoc01,                            
  a.cantid01 as Cantidad,                        
  a.preuni01,                                           
  a.cantid01 * a.preuni01 as SubTotal,    
  '' as nropla01,                      
  '' as brevet01,                  
  0 as codtam01,                        
  '' as codrut01,                        
  0 as kilometros,   
  '' as desrut01,  
  case when a.tipser01 = 'S' then f.cod_tipo_comb                      
    else '0' end as centrocosto,     
  case when d.idtikets is null then b.cod_ultra                           
    when d.idtikets is not null then f.cod_ultra  end as codultra                      
from DDFACTTR01 as a   
inner join  dbo.DcFACTTR01 as m on ( a.nrofac01 = m.nrofac01  and a.tipdoc01=m.tipdoc01 and a.idconta01=m.idconta01)                
inner join TQTIPSER01 as b ON a.tipser01 = b.tipser01           
left join TQTIKETS AS d on a.nrodet01 = d.nrofactu           
left join TQCOMBUS as f on d.idcombus = f.idcombus                    
where m.fecemi01>='20090101'            
and m.fecemi01<='20091031'       
AND m.flages01 <> 'A'     
and a.tipser01 <> 'T'  
GO
/****** Object:  View [dbo].[COMISION_TRITON]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[COMISION_TRITON]
as 
select YY=year(FECGEN01), MM=month(FECGEN01), DD=day(FECGEN01),
MMDD=substring(convert(char(8),FECGEN01,112),5,4),
B.BREVET01,                       
d.Nombre+', '+d.Apellido AS CHOFER,                       
B.DESCIRCU AS DESRUT01,                       
B.NROGUI01,                       
isnull(E.codtam01,0) as codtam01,                  
B.COMISION AS COMISION40,                       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                       
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
F.NOMBRE AS ALIAS,
TelefCelu as Cod_plan ,
'' as Circuito ,
'' as Servicio                                            
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
--where convert(varchar(8), FECGEN01, 112) BETWEEN '20051028' AND '20051031'AND                      
WHERE  
year(FECGEN01)=year(getdate())
AND                
B.descircu is not null  and b.idcircuito <> 14    
   and f.Nombre is not null           
                       
UNION                      
                      
SELECT  
YY=year(FECGEN01), MM=month(FECGEN01), DD=day(FECGEN01),
MMDD=substring(convert(char(8),FECGEN01,112),5,4),
B.BREVET01,                       
d.Nombre+', '+d.Apellido AS CHOFER,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
isnull(B.COMISION,0),                       
isnull(B.COMISION,0)/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                        
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
f.Nombre as Alias,
TelefCelu as Cod_plan  ,
'' as Circuito  ,  
'' as Servicio                                                                                                                                                     
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA              
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito      
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where 
year(FECGEN01)=year(getdate()) 
and b.idcircuito <> 14                      
 and f.Nombre is not null 
GO
/****** Object:  View [dbo].[TMTIEN]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TMTIEN] As    
SELECT [DC_SUCURSAL], [DE_TIEN] as dg_sucursal, [CO_TIEN], [CO_UNID], [CO_EMPR], [DE_TIEN], [DE_TIEN_LARG], [DE_DIRE], [CO_UBIC_GEOG],    
       [DE_CIUD], [DE_DPTO], [CO_PAIS], [NU_TLF1], [NU_TLF2], [NU_FAXS], [DE_DIRE_MAIL],    
       [TI_AUXI_EMPR], [CO_AUXI_EMPR], [NU_SERI_NCON], [CO_VEND_DEFA], [CO_CLIE_DEFA],    
       [ST_PUNT_VENT], [DG_ALIAS_SUCURSAL], [DF_VIGENCIA_INICIO], [DF_VIGENCIA_TERMINO],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN]   
WHERE  [CO_EMPR] = '02'
GO
/****** Object:  View [dbo].[TMUNID_RECA]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TMUNID_RECA] As    
Select [CO_UNID], [CO_EMPR], [DE_UNID], [TI_AUXI_EMPR], [CO_AUXI_EMPR],    
       [SUCCON01], [CODSED01], [FLGACT01],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMUNID_RECA]    
WHERE  [CO_EMPR] = '02'
GO
/****** Object:  View [dbo].[TRUNNE_SERV]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TRUNNE_SERV] As     
SELECT t2.DC_SERVICIO, t3.DC_SUCURSAL as dc_sucursal_imputacion,       
                t4.DC_CENTRO_COSTO as dc_centro_costo_imputacion,      
       t1.[dm_detraccion], t1.[afecto_igv], t1.[df_inicio_vigencia], t1.[df_final_vigencia],      
       t1.[dc_porcentaje_detraccion],      
       t1.[CO_ACTI_DETR], t1.[CO_TIPO_DETR]      
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1      
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 On      
       (      t2.CO_SERV = t1.CO_SERV )      
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 On      
       (      t3.CO_TIEN = t1.CO_TIEN      
       And    t3.CO_UNID = t1.CO_UNID      
       And    t3.CO_EMPR = t1.CO_EMPR )      
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 On      
       (      t4.CO_UNNE = t1.CO_UNNE      
       And    t4.CO_EMPR = t1.CO_EMPR )  
WHERE  t1.CO_EMPR = '02'  
GO
/****** Object:  View [dbo].[TTCIRC]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTCIRC] As        
SELECT CO_CIRC, CO_EMPR, DE_CIRC, CO_USUA_CREA, FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI      
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTCIRC]
WHERE CO_EMPR = '02' 
GO
/****** Object:  View [dbo].[TTSERV]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTSERV] As      
SELECT [dc_servicio], [DE_SERV] as dg_servicio, [CO_SERV],       
       [dg_servicio_ingles], [dc_moneda_servicio],      
       [df_vigencia_inicio], [df_vigencia_termino],      
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI], CO_CIRC      
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV]      
WHERE CO_EMPR = '02'  
GO
/****** Object:  View [dbo].[TTUNID_NEGO]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TTUNID_NEGO] As    
SELECT [dc_centro_costo], [DE_UNNE] as dg_centro_costo, [CO_UNNE], [CO_EMPR],  [CO_DINE],    
       [dc_division_negocio], [df_inicio_vigencia],    
       [df_termino_vigencia], [dg_alias_centro_costo],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO]  
WHERE  [CO_EMPR] = '02'
GO
/****** Object:  StoredProcedure [dbo].[ sp_Trit_c3]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ sp_Trit_c3]
@nrogui01 varchar(10),                    
@nrogui73 varchar(10),                    
@codcco06 varchar(8),                    
@navvia11 char(6) ,                    
@nropla01 char(7) ,                    
@fecgen01 char(17),                    
@client01 char(11),                    
@brevet01 char(9) ,                    
@idcircuito integer,                    
@codnav08 char(4) ,                    
@remolq73 char(10),                    
@nrodet01 int,                  
@flagEstra char(1),                  
@DesCircu varchar(100),                  
@PrecioCir decimal(15,2),                  
@PrecioCir_S decimal(15,2),                  
@Comision decimal (15,2),                  
@FlagVicon char(1),                  
@Observacion varchar(255),          
@IdTarifa as integer,      
@TipoMerc char(1),    
@usumod varchar (30),    
@PtoOrigen varchar(150),    
@PtoDestino varchar(150),    
@ValRef decimal(12,2),  
@Peaje decimal(5,2)  
as       
                 
UPDATE DCGUITTR01 SET              
nrogui73 = @nrogui73,                       
codcco06 = @codcco06,                        
navvia11 = @navvia11,                        
nropla01 = @nropla01,                        
fecgen01 = @fecgen01,                        
client01 = @client01,                        
brevet01 = @brevet01,                        
idcircuito = @idcircuito,      
codnav08 = @codnav08,                        
remolq73 = @remolq73,                        
nrodet01 = @nrodet01,                      
flagEstra = @flagEstra,                    
DesCircu = @DesCircu,                    
PrecioCir = @PrecioCir,                    
PrecioCir_S = @PrecioCir_S,                    
Comision = @Comision,                    
FlagVicon  = @FlagVicon,                  
observacion = @Observacion,            
idtarifa = @IdTarifa,          
TipoMerc = @TipoMerc,    
usumod = @usumod,    
fecmod01 = getdate(),    
PtoOrigen = @PtoOrigen,    
PtoDestino = @PtoDestino,    
ValRef = @ValRef,  
peaje = @peaje  
WHERE nrogui01 = @nrogui01                 
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[ sp_Triton_]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ sp_Triton_]
as
select * from CQTARCIR01 where idcircuito=7
GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_adduserobject]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_adduserobject_vcs]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_checkinobject]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_checkinobject_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_droppropertiesbyid]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_dropuserobjectbyid]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_generateansiname]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_removefromsourcecontrol]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_vcsenabled]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_verstamp006]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_verstamp007]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout_u]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[Listar_ConPago]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Listar_ConPago]
as
select conpag01, descri01, diasve01 from TQCONPAG01 return 0 
GO
/****** Object:  StoredProcedure [dbo].[Listar_DetFacturaByNroFac]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[Listar_DetFacturaByNroFac]                  
                                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
@nrofac01 char(10),                  
                                                                                                                                                                                                                        
    
                                                                                                                                                                                                                                                         
@tipdoc01 char(2),                  
                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
@idconta01 int                  
                                                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
as                  
                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
        
                                                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                         
select a.nrodet01,                   
                                                                                                                                                                                                                        
    
                                                                                                                                                                                                                                                         
a.cantid01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.preuni01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.tipser01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.desart01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
a.cantid01 * a.preuni01 as Total,                  
                                                                                                                                                                                                          
    
                                                                                                                                                                                                                                                         
b.descri01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
c.nrogui01,                  
                                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
c.idcircuito,            
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
d.idtikets,                
                                                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
h.dc_tipo_identificacion_bien as nropla01,                
                                                                                                                                                                                                   
    
                                                                                                                                                                                                                                                         
c.brevet01,            
                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
g.kilometros,            
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
g.codrut01,            
                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
c.codcco06,               
                                                                                                                                                                                                                                   
    
                                                                                                                                                                                                                                                         
case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra                  
                                                                                                                                                                       
    
                                                                                                                                                                                                                                                         
     when d.idtikets is not null then f.cod_ultra                  
                                                                                                                                                                                          
    
                                                                                                                                                                                                                                                         
     when c.nrogui01 is not null then g.cencos01 end as cod_ultra,         
                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
case when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)    
                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
     when a.tipser01 = 'S' then f.cod_tipo_comb            
                                                                                                                                                                                                  
    
                                                                                                                                                                                                                                                         
     else '0' end as centrocosto,            
                                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
        
                                                                                                                                                                                                                                                     
case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)            
                                                                                                                                              
    
                                                                                                                                                                                                                                                         
     else 0 end as codtam01,             
                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)            
                                                                                                                                             
    
                                                                                                                                                                                                                                                         
     else 0 end as cantidad             
                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
from DDFACTTR01 as a inner join TQTIPSER01 as b                 
                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
ON a.tipser01 = b.tipser01     
                                                                                                                                                                                                                              
    
                                                                                                                                                                                                                                                         
left join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01     
                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                         
left join TQTIKETS AS d on a.nrodet01 = d.nrofactu     
                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
--left join TQPRECOMB as e on d.idprecio  =  e.idprecio      
                                                                                                                                                                                                
    
                                                                                                                                                                                                                                                         
left join TQCOMBUS as f on d.idcombus = f.idcombus              
                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                         
left join cqcircui01 as g on c.idcircuito = g.idcircuito            
                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h            
                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS            
                                                                                                                  
    
                                                                                                                                                                                                                                                         
where  a.idconta01 = @idconta01             
                                                                                                                                                                                                                 
    
                                                                                                                                                                                                                                                         
and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01                 
                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                         
return 0            
                                                                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[Listar_DetFacturaByNroFac_Optimizado]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[Listar_DetFacturaByNroFac_Optimizado]                                                                                                                                                                                                  
@nrofac01 char(10),                                                                                                                                                                                                                                             
@tipdoc01 char(2),                                                                                                                                                                                                                                             
@idconta01 int                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
as                
                                                                                                                                                                                                                                                           
Declare @TipoServicio char(1)    
                                                                                                                                                                                                                                                             
set @TipoServicio = (select top 1 tipser01 from DDFACTTR01                                                                                                                                                                                                       
where  idconta01 = @idconta01                                                                                                                                                                                                                                    
and tipdoc01 = @tipdoc01 and  nrofac01 = @nrofac01)    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
if @TipoServicio = 'T'                                                                                                                                                                                                                                          
begin                                                                                                                                                                                                                                                            
	select a.nrodet01,                                                                                                                                       
	a.cantid01,                                                                                                                                                                                                                                                     
	a.preuni01,                                                                                                                                                                                                                                                      
	a.tipser01,                                                                                                                                                                                                                                                     
	a.desart01,                                                                                                                                                                                                                                                     
	a.cantid01 * a.preuni01 as Total,                                                                                                                                                                                                                               
	b.descri01,                                                                                                                                                                                                                                                      
	c.nrogui01,                                                                                                                                                                                                                                                     
	c.idcircuito,                                                                                                                                                                                                                                                    
	'' as idtikets,                                                                                                                                                                                                                                                 
	h.dc_tipo_identificacion_bien as nropla01,                                                                                                                                                                                                                       
	c.brevet01,                                                                                                                                                                                                                                                      
	g.kilometros,                                                                                                                                                                                                                                                   
	g.codrut01,                                                                                                                                                                                                                                                      
	c.codcco06,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	/*case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra                      	                                                                                                                                                                     
		 when d.idtikets is not null then f.cod_ultra                      	                                                                                                                                                                                          
		 when c.nrogui01 is not null then g.cencos01 end as cod_ultra,                                                                                                                                                                                              
	*/                                                                                                                                                                                                                                                              
	g.cencos01  as cod_ultra,                                                                                                                                                                                                                                       
	convert(varchar(3),h.dc_centro_costo)  as centrocosto,                                                                                                                                                                                                           
	/*case when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)        	                                                                                                                                                                                  
		 when a.tipser01 = 'S' then f.cod_tipo_comb                                                                                                                                                                                                                
		 else '0' end as centrocosto,                                                                                                                                                                                                                               
	*/                                                                                                                                                                                                                                                              
	x.codtam01,                                                                                                                                                                                                                                                      
	count(c.nrogui01) as cantidad,                                                                                                                                                                                                                                   
	a.ctrCostoOtros /*case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)                                                                                                                                       
		 else 0 end as codtam01                                                                                                                                                                                                                              
	case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)                                                                                                                                                         
		 else 0 end as cantidad             */                                                                                    
	from DDFACTTR01 as a inner join TQTIPSER01 as b                                                                                                                                                                                                                 
	ON a.tipser01 = b.tipser01                                                                                                                                                                                                                                       
	inner join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01                                                                                                                                                                                                           
	left join DDGUITTR01 as x on c.nrogui01 = x.nrogui01                                                                                                                                                                                                             
	--left join TQTIKETS AS d on a.nrodet01 = d.nrofactu                                                                                                                                                                                                             
	--left join TQCOMBUS as f on d.idcombus = f.idcombus                                                                                                                                                                                                             
	inner join cqcircui01 as g on c.idcircuito = g.idcircuito                                                                                                                                                                                                       
	inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                                                                                                                                                                                                
	on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                                                 
	or substring(c.nropla01,1,3)+'-'+substring(c.nropla01,4,4) = h.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                                                
	where  a.idconta01 = @idconta01                                                                                                                                                                                                                                 
	and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	/*where  a.idconta01 = '1'                                                                                                                                                                                                                                       
	and a.tipdoc01 = '01' and  a.nrofac01 = '0010061338'                                                                                                                                                                                                            
	*/                                                                                                                                                                                                                                                                                                                                                                                                                                                          
	group by                                                                                                                                                                                                                                                        
	a.nrodet01,                                                                                                                                                                                                                                                     
	a.cantid01,                                                                                                                                                                                                                                                      
	a.preuni01,                                                                                                                                                                                                                                                      
	a.tipser01,                                                                                                                                                                                                                                                     
	a.desart01,                                                                                                                                                                                                                                                     
	a.cantid01,                                                                                                                                                                                                                                                      
	a.preuni01 ,                                                                                                                                                                                                                                                     
	b.descri01,                                                                                                                                                                                                                                                      
	c.nrogui01,                                                                                                                                                                                                                                                      
	c.idcircuito,                                                                                                                                                                                                                                                   
	--d.idtikets,                                                                                                                                                                                                                                                    
	h.dc_tipo_identificacion_bien ,                                                                                                                                                                                                                                
	c.brevet01,                                                          
	g.kilometros,                                                                                                                                                                                                                                                    
	g.codrut01,                                                                                                                                                                                                                                                      
	c.codcco06,                                                                                                                                                                                                                                                      
	g.cencos01,                                                                                                                                                                                                                                                      
	convert(varchar(3),h.dc_centro_costo),                                                                                                                                                                                                                          
	x.codtam01,                                                                                                                                                                                                                                                      
	a.ctrCostoOtros                                                                                                                                                                                                                                                  
end                                                                                                                                                                                                                                                                 
else                                                                                                                                                                                                                                                              
begin                                                                                                                                                                                                                                                           
	select a.nrodet01,                                                                                                                                                                                                                                               
	a.cantid01,                                                                                                                                                                                                                                                      
	a.preuni01,                                                                                                                                                                                   
	a.tipser01,                                                                                                                                                                                                                                                     
	a.desart01,                                                                                                                                                                                                                                                      
	a.cantid01 * a.preuni01 as Total,                                                                                                                                                                                                                                
	b.descri01,                                                                                                                                                                                                                                                      
	'' as nrogui01,                                                                                                                                                                                                                                                  
	'' as idcircuito,                                                                                                                                                                                                                                                
	d.idtikets,                                                                                                                                                                                                                                                      
	'' as nropla01,                                                                                                                                                                                                                                                  
	'' as brevet01,                                                                                                                                                                                                                                                  
	'' as kilometros,                                                                                                                                                                                                                                               
	'' as codrut01,                                                                                                                                                                                                                                                  
	'' as codcco06,                                                                                                                                                                                                                                                 
	--case when d.idtikets is null and c.nrogui01 is null then b.cod_ultra,                                                                                                                                                                                         
	case when d.idtikets is null then b.cod_ultra                                                                                                                                                                                                                    
		 when d.idtikets is not null then f.cod_ultra  end as cod_ultra,              
	--when c.nrogui01 is not null then g.cencos01 end as cod_ultra,                                                                                                                                                                                                                                                                      
	--when a.tipser01 = 'T' then convert(varchar(3),h.dc_centro_costo)                                                                                                                                                                                             
	case when a.tipser01 = 'S' then f.cod_tipo_comb                                                                                                                                                                                                             
		 else '0' end as centrocosto,                                                                                                                                                                                                                                                                
	/*case when a.tipser01 = 'T' then (select top 1 codtam01 from DDGUITTR01 where nrogui01 = c.nrogui01)                                                                                                                                                       
		 else 0 end as codtam01,                                                                                                                                                                                                                                
	case when a.tipser01 = 'T' then (select count(nrogui01) from DDGUITTR01 where nrogui01 = c.nrogui01)                                                                                                                                                       
		 else 0 end as cantidad               */                                                                                                                                                                                                                                                           
	0 as codtam01,                                                                                                                                                                                                                                           
	0 as cantidad ,                                                                                                                                                                                                                                                  
	a.ctrCostoOtros                                                                                                                                   
	from DDFACTTR01 as a inner join TQTIPSER01 as b                                                                                                                                                                                                                  
	ON a.tipser01 = b.tipser01                                                                                                                                                                                                                                       
	--left join DCGUITTR01 AS c on a.nrodet01 = c.nrodet01                                                                                                                                                                                                    
	left join TQTIKETS AS d on a.nrodet01 = d.nrofactu                                                                                                                                                                                                             
	--left join TQPRECOMB as e on d.idprecio  =  e.idprecio                                                                                                                                                                                                        
	left join TQCOMBUS as f on d.idcombus = f.idcombus                                                                                                                                                                                                             
	--left join cqcircui01 as g on c.idcircuito = g.idcircuito                                                                                                                                                                                                   
	--left join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as h                                                                                                                                                                                             
	--on substring(c.nropla01,1,2)+'-'+substring(c.nropla01,3,4) = h.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                                                                                                                                                                                                 
	where  a.idconta01 = @idconta01                                                                                                                                                                                                                        
	and a.tipdoc01 = @tipdoc01 and  a.nrofac01 = @nrofac01                                                                                                                                                                                                                                                                                  
end                                                                                                                                                                                                                                                            
return 0                
                                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                          
   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
GO
/****** Object:  StoredProcedure [dbo].[Listar_FacturaByNroFac]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Listar_FacturaByNroFac]      
@nrofac01 char(10),      
@tipdoc01 char (2),      
@idconta01 int      
as      
select      
A.ruccli01,      
A.fecemi01,      
A.fecven01,      
A.conpag01,      
A.moneda01,      
A.tipcam01,      
A.valfac01,      
A.impven01,      
A.totven01,      
A.flages01,      
A.afecim01,      
A.atenci01,      
A.flagCont,      
A.observ01,    
A.nroRef01,  
A.FecRef01,  
B.idconta01,
c.DesEstado      
FROM DCFACTTR01 AS A INNER JOIN DCCONTTRI01 AS B on A.tipdoc01 = B.tipodoc01 and a.idconta01 = b.idconta01       
left join TQESTADOS as c on a.flages01 = c.idEstado
where nrofac01 = @nrofac01 and tipdoc01 = @tipdoc01 and b.idconta01 = @idconta01      
GO
/****** Object:  StoredProcedure [dbo].[Listar_TipoDoc]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Listar_TipoDoc]
as
select tipdoc01, descri01 from TQTIPDOC01 return 0 
GO
/****** Object:  StoredProcedure [dbo].[Listar_TipoServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Listar_TipoServ]    
as    
select tipser01, descri01,cod_ultra from tqtipser01    
order by 2  
return 0  
GO
/****** Object:  StoredProcedure [dbo].[probando]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[probando]
@nrogui01 char(10)  
as 
declare @validanrogui01 char(10)
declare @dd char(10)
select @validanrogui01 = nrogui01, @dd = len(nrogui01) from DCGUITTR01 where nrogui01 = @nrogui01
select @validanrogui01, len(@validanrogui01), len(@nrogui01), @dd

GO
/****** Object:  StoredProcedure [dbo].[sp_Actualiza_tqcontrolguia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Actualiza_tqcontrolguia]          
@Falg char(1),     
@Servidor char(1)       
as          
if @Servidor = 'T'    
   begin    
 update TQCONTROLGUIA set          
 ServTerm =  @Servidor,    
 fechaTermAct = getdate(), flag='N' ,  HoraFin='08:00:00',  FechaFin=convert(char(8),dateadd(day,1,getdate()),112)
   end    
if @Servidor = 'O'    
   begin    
 update TQCONTROLGUIA set          
 Flag = @Falg,     
 ServOceani = @Servidor,    
 fechaOceaAct = getdate()       
   end    
if @Servidor = ''    
   begin    
 update TQCONTROLGUIA set          
 ServTerm = '',     
 fechaTermAct = null,  
 ServOceani = '',    
 fechaOceaAct = null,
 flag = @Falg
   end    
return 0  






GO
/****** Object:  StoredProcedure [dbo].[sp_Actualiza_VargenericabyFlag]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Actualiza_VargenericabyFlag]
@flagmanual char(1),
@Usuario varchar(30)
as
update TQVARGENERICA set
flagmanual = @flagmanual,
UsuMod  = @Usuario,
fecchamod = getdate()
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizaAll_tqcontrolguia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_ActualizaAll_tqcontrolguia]    
@Falg char(1),
@FechaFin varchar (8),
@HoraFin varchar(8)
as    
update TQCONTROLGUIA set    
Flag = @Falg,     
FechaFin = @FechaFin,
HoraFin	= @HoraFin
return 0    
GO
/****** Object:  StoredProcedure [dbo].[sp_Actualizar_ErrorFic]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_Actualizar_ErrorFic]
@nrofac01 char(10),  
@tipdoc01 char(2),  
@idConta01 int ,  
@ErrorFic varchar(200),  
@coduse01 varchar(50)  
as
update DCFACTTR01 set  
ErrorFic = @ErrorFic,  
coduse01 = @coduse01  
where  
nrofac01 = @nrofac01 and   
tipdoc01 = @tipdoc01 and   
idconta01 = @idconta01  
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Actualizar_Llanta_EstadoByIdLlanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Actualizar_Llanta_EstadoByIdLlanta]
@IdLlanta int,
@disponible int
as
update CDLLANTA  set 
disponible = @disponible
where idllanta = @idllanta
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_CamionLlanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_agregar_CamionLlanta]      
@id_Llanta int,      
@id_Motivo int,      
@PlacaUnidad int,      
@FechaAsigna varchar(10),      
@Horometro  Decimal(9,1),      
@OdoExterno Decimal(9,1),      
@OdoInterno Decimal(9,1),      
@Posicion Int,      
@Usuario VarChar(50),      
@Estado int,    
@Id_Llanta_Sal int,
@IdCamionLlanta int output      
as      
insert into tqllanta (      
id_llanta,      
id_motivo,      
IdPlaAut,      
FechaAsigna,      
Horometro,      
OdoExterno,      
OdoInterno,      
Posicion,      
FechaRegistro,      
Usuario,    
Estado,
Id_Llanta_Sal     
)      
values       
(      
@id_Llanta,      
@id_Motivo,      
@PlacaUnidad,      
@FechaAsigna,      
@Horometro,      
@OdoExterno,      
@OdoInterno,      
@Posicion,      
getdate(),      
@Usuario,    
@Estado,
@Id_Llanta_Sal
)       
select @IdCamionLlanta = @@identity      

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Chofer]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Chofer]  
@Brevete char(9),  
@dni char(8),        
@Nombre varchar(50),  
@Apellido varchar(70),        
@Direccion varchar(70),        
@TelefCasa varchar(15),       
@TelefCelu varchar(15),        
@FechaIngreso VARCHAR (8),  
@UsuarioReg varchar(30),  
@Estado char(1),      
@IdChofer int OUTPUT  
AS  
INSERT INTO TQCHOFER  
(  
Brevete,  
dni,  
Nombre,  
Apellido,  
Direccion,  
TelefCasa,  
TelefCelu,  
FechaIngreso,  
FechaReg,  
UsuarioReg,
Estado  
)  
VALUES   
(  
@Brevete,  
@dni,  
@Nombre,  
@Apellido,  
@Direccion,  
@TelefCasa,  
@TelefCelu,  
@FechaIngreso,  
GETDATE(),  
@UsuarioReg,
@Estado
)  
SELECT @IdChofer = @@IDENTITY  
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Circuito]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Circuito]  
@Tipocir01         char(1),  
@codrut01         char(5),  
@desrut01         varchar(100),  
@ptopar01         varchar(10),  
@ptodes01        varchar(10),  
@automa01       char(1),  
@ficsol01            char(3),  
@ficdol03           char(3),  
@succon01        char(2),  
@cencos01        char(3),  
@condcntr         char(1),  
@kilometros     numeric(9,2),  
@PtoPartida      varchar(80),  
@DistPartida     varchar(80),  
@PtoLlegada     varchar(80),  
@DistLlegada    varchar(80),  
@UauarioReg   varchar(30),  
@ptoorigen       varchar(150),  
@ptodestino     varchar(150),  
@idcircuito         int output  
as  
insert into CQCIRCUI01(  
Tipocir01,  
codrut01,  
desrut01,  
ptopar01,  
ptodes01,  
automa01,  
ficsol01,  
ficdol03,  
succon01,  
cencos01,  
condcntr,  
kilometros,  
PtoPartida,  
DistPartida,  
PtoLlegada,  
DistLlegada,  
fechaReg,  
UauarioReg,  
PtoOrigen,  
PtoDestino,
flgAutomatico   
)  
values  
(  
@Tipocir01,  
@codrut01,  
@desrut01,  
@ptopar01,  
@ptodes01,  
'0',  
@ficsol01,  
@ficdol03,  
@succon01,  
@cencos01,  
@condcntr,  
@kilometros,  
@PtoPartida,  
@DistPartida,  
@PtoLlegada,  
@DistLlegada,  
getdate(),  
@UauarioReg,  
@ptoorigen,  
@ptodestino,
@automa01  
)  
select @idcircuito = @@identity  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Cliente]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Cliente]
@rucclien char(11),
@razonsoc varchar(100),
@direcci0 varchar(100),
@distrit0 varchar(50),
@telefon0 varchar(15),
@atencion varchar(50),
@usuaregi varchar (50)
as
insert into TQCLIENTE
(
rucclien, 
razonsoc,
direcci0,
distrit0,
telefon0,
atencion,
usuaregi,
fechareg 
)
values
(
@rucclien, 
@razonsoc,
@direcci0,
@distrit0,
@telefon0,
@atencion,
@usuaregi,
getdate()
)

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_DetFactura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_DetFactura]      
@nrofac01 char(10),      
@tipdoc01 char(2),      
@idconta01 int,      
@cantid01 decimal(12,3),      
@preuni01 decimal(12,3),      
@tipser01 char(1),      
@desart01 varchar(100),      
@coduse01 varchar(50),    
@ctrCosto varchar(10),     
@nrodet01 int output   
  
as      
declare @tiposervotros char(1)


if	@tipser01 = 'A' 
	set @tiposervotros = 'O'
else if @tipser01 = 'C'
	set @tiposervotros = 'O' 
else if @tipser01 = 'I'
	set @tiposervotros = 'O' 
else if @tipser01 = 'O'
	set @tiposervotros = 'O' 
else
set @tiposervotros = @tipser01

	

insert into DDFACTTR01      
(      
nrofac01,      
tipdoc01,      
idconta01,      
cantid01,      
preuni01,      
tipser01,      
desart01,      
coduse01,  
ctrCostoOtros      
)      
values      
(@nrofac01,      
@tipdoc01,      
@idconta01,      
@cantid01,      
@preuni01,      
@tiposervotros,    
@desart01,      
@coduse01,  
@ctrCosto  
)      
  
select @nrodet01 = @@identity from DDFACTTR01    


  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_DetFactura_bk]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_DetFactura_bk]      
@nrofac01 char(10),      
@tipdoc01 char(2),      
@idconta01 int,      
@cantid01 decimal(12,3),      
@preuni01 decimal(12,3),      
@tipser01 char(1),      
@desart01 varchar(100),      
@coduse01 varchar(50),    
@ctrCosto varchar(10),     
@nrodet01 int output   
  
as      
insert into DDFACTTR01      
(      
nrofac01,      
tipdoc01,      
idconta01,      
cantid01,      
preuni01,      
tipser01,      
desart01,      
coduse01,  
ctrCostoOtros      
)      
values      
(@nrofac01,      
@tipdoc01,      
@idconta01,      
@cantid01,      
@preuni01,      
@tipser01,      
@desart01,      
@coduse01,  
@ctrCosto  
)      
  
select @nrodet01 = @@identity from DDFACTTR01    
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_DetGuia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_DetGuia]  
@nrogui01 varchar(10),  
@codcon01 char(11),  
@codtam01 char(2),  
@codDet01 int output    
as   

declare @fecgen char(8)
declare @circuito integer
begin
insert into DDGUITTR01  
(  
nrogui01,  
codcon01,  
codtam01  
)  
values   
(  
@nrogui01,  
@codcon01,  
@codtam01  
)  

selecT @fecgen =convert(char(8),fecgen01,112),@circuito = idcircuito from DCGUITTR01 where nrogui01 = @nrogui01

exec sp_ValidaGuiaxMesxAnio @fecgen,@circuito,@codcon01,@nrogui01


select @codDet01 = @@identity from DDGUITTR01  

return 0   
  
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Diseniollanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Diseniollanta]
@Descripcion varchar(30),
@Usuario varchar(30),
@IdDisenio int output 
as
insert into TQDISENIOLLANTA
(
Descripcion,
Usuario,
Fechareg
)
values 
(
@Descripcion,
@Usuario,
getdate()
)
select @IdDisenio = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_EmpServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_EmpServ]
@ruc	varchar(11),
@Nombre	varchar	(50),
@Direccion varchar(50),
@Telefono varchar(15),
@Contacto varchar(50),
@Usuario varchar(30),
@idEmpServ int output
as
insert into TQEMPSERV
(
ruc,
Nombre,
Direccion,
Telefono,
Contacto,
Usuario,
fechareg

)
values
(
@ruc,
@Nombre,
@Direccion,
@Telefono,
@Contacto,
@Usuario,
getdate()
)
select @idEmpServ = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Eventos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Eventos]  
@idTipoEvent int,  
@IdChofer int,  
@idPlacaAut int,  
@Descripcion varchar (50),  
@Fecha varchar(8),  
@Hora varchar(8),  
@UsuarioReg varchar(30),  
@IdServicio int,  
@Idtikets int,  
@EstadoServicio varchar(1),
@idEvento int output  
as  
insert into DCEVENTOS  
(  
idTipoEvent,  
IdChofer,  
idPlacaAut,  
Descripcion,  
Fecha,  
Hora,  
FechaReg,  
UsuarioReg,  
IdServicio,  
Idtikets,
EstadoServicio  
)  
values  
(@idTipoEvent,  
@IdChofer,  
@idPlacaAut,  
@Descripcion,  
@Fecha,  
@Hora,  
getdate(),  
@UsuarioReg,  
@IdServicio,  
@Idtikets,
@EstadoServicio
)  
select @idEvento = @@identity  

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Factura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Factura]        
@nrofac01 char(10),        
@tipdoc01 char(2),        
@idconta01 int,      
@ruccli01 char(11),        
@fecemi01 varchar(8),        
@fecven01 varchar(8),        
@conpag01 char(2),        
@moneda01 char(1),        
@tipcam01 decimal (6,3),        
@valfac01 decimal(12,2),        
@impven01 decimal (5,2),        
@totven01 decimal(12,2),        
@flages01 char(1),        
@afecim01 char(1),        
@atenci01 varchar(50),        
@flagCont char(1),        
@coduse01 varchar(50),    
@observ01 varchar(255),  
@nroRef01 varchar(10),  
@FecRef01 varchar(8)  
as      
insert into DCFACTTR01        
(nrofac01,        
tipdoc01,        
idconta01,      
ruccli01,        
fecemi01,        
fecven01,        
conpag01,        
moneda01,        
tipcam01,        
valfac01,        
impven01,        
totven01,        
flages01,        
afecim01,        
atenci01,        
flagCont,        
coduse01,    
observ01,  
nroRef01,  
FecRef01)        
values        
(@nrofac01,        
@tipdoc01,        
@idconta01,      
@ruccli01,        
@fecemi01,        
@fecven01,        
@conpag01,        
@moneda01,        
@tipcam01,        
@valfac01,        
@impven01,        
@totven01,        
@flages01,        
@afecim01,        
@atenci01,        
@flagCont,        
@coduse01,    
@observ01,  
@nroRef01,  
@FecRef01)    
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Guia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Agregar_Guia]                  
@nrogui01 varchar(10),                  
@nrogui73 varchar(10),                  
@codcco06 varchar(8),                  
@navvia11 char(6) ,                  
@nropla01 char(7) ,                  
@fecgen01 char(17),                  
@client01 char(11),                  
@brevet01 char(9) ,                  
@idcircuito integer,                  
@codnav08 char(4) ,                  
@remolq73 char(10),                  
@nrodet01 int,                
@flagEstra char(1),                
@DesCircu varchar(100),                
@PrecioCir decimal(15,2),                
@Comision decimal (15,2),                
@FlagVicon char(1),            
@observacion varchar(255),          
@IdTarifa int,      
@TipoMerc char(1),    
@Usucrea varchar(30),    
@PtoOrigen varchar(150),    
@PtoDestino varchar(150),    
@ValRef decimal(12,2),  
@peaje decimal(5,2)    
as                  
insert into DCGUITTR01 (                  
nrogui01,                   
nrogui73,                   
codcco06,                  
navvia11,                  
nropla01,                  
fecgen01,                  
client01,                  
brevet01,                  
idcircuito,      
codnav08,                  
remolq73,                  
nrodet01,                
flagEstra,                
DesCircu,                
PrecioCir,                
Comision,                
FlagVicon,            
observacion,          
IdTarifa,      
TipoMerc,    
Usucrea,    
fecreg01,    
PtoOrigen,    
PtoDestino,    
ValRef,  
peaje    
)                  
values                  
(                  
@nrogui01,                   
@nrogui73,                   
@codcco06,                  
@navvia11,                  
@nropla01,                  
@fecgen01,    
@client01,                  
@brevet01,                  
@idcircuito,                 
@codnav08,                  
@remolq73,                  
@nrodet01,                  
@flagEstra,                
@DesCircu,                
@PrecioCir,                
@Comision,                
@FlagVicon,            
@observacion,          
@IdTarifa,      
@TipoMerc,    
@Usucrea,    
getdate(),    
@PtoOrigen,    
@PtoDestino,    
@ValRef,  
@peaje  
)                  
return 0                  

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Llanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Llanta]      
@Codigo int,      
@IdMedida int,      
@IdMarca  int,      
@IdDisenio int,      
@Cocada_mm int,      
@N_R varchar(1),      
@FechaIngreso varchar(8),      
@usuareg varchar(50),    
@idLlanta int output  
as      
insert into CDLLANTA      
(      
Codigo,      
IdMedida,      
IdMarca,      
IdDisenio,      
Cocada_mm,      
N_R,      
FechaIngreso,    
FechaRegistro,    
Usuario      
)      
values      
(      
@Codigo,      
@IdMedida,      
@IdMarca,      
@IdDisenio,      
@Cocada_mm,      
@N_R,      
@FechaIngreso,      
getdate(),
@usuareg    
)    
select @idLlanta = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_LlantaAsignada]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[sp_Agregar_LlantaAsignada]
--@id_camionllanta	int,
--@id_Llanta	int,
--@id_Motivo	int,
--@PlacaUnidad	char(7),
--@FechaAsigna	datetime,
--@Horometro	decimal(9,2),
--@OdoExterno	decimal(9,2),
--@OdoInterno	decimal(9,2),
--@Posicion	int,
--@Usuario	varchar(50)
--as
--insert into tqllanta 
--(
--id_camionllanta,
--id_Llanta,
--id_Motivo,
--PlacaUnidad,
--FechaAsigna,
--Horometro,
--OdoExterno,
--OdoInterno,
--Posicion,
--FechaRegistro,
--Usuario
--)
--values
--(
--@id_camionllanta,
--@id_Llanta,
--@id_Motivo,
--@PlacaUnidad,
--@FechaAsigna,
--@Horometro,
--@OdoExterno,
--@OdoInterno,
--@Posicion,
--getdate(),
--@Usuario	
--)
--GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Marca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Marca]
@Descripcion varchar(70),
@Usuario varchar (30),
@IdMarca int output 
as
insert into TQMARCA
(
Descripcion,
Usuario,
FechaReg
)
values 
(@Descripcion,
@Usuario,
getdate()
)
select @IdMarca = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Medida]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Medida]
@Descripcion varchar(10),
@Usuario varchar(30),
@IdMedida int output 
as
insert into TQMEDIDA
(
Descripcion,
usuario,
fechareg
)
values 
(@Descripcion,
@Usuario,
getdate()
)
select @IdMedida = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Permisos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[sp_Agregar_Permisos]  
@IdUsuario int ,  
@IdMenu int ,  
@UsuarioReg varchar(30),  
@IdPermisos int output  
as  
insert into TQPERMISOS   
(IdUsuario,IdMenu ,UsuarioReg ,Fecreg )  
values  
(@IdUsuario,@IdMenu ,@UsuarioReg ,getdate())  
  
select @IdPermisos = @@identity  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_PlacaAutorizada]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_PlacaAutorizada]        
@codage19 char(11),        
@nropla81 char(7),        
@esactivo char(1),        
@usuaregi varchar(50),        
@tablero char(1),        
@externo char(1),        
@Nombre varchar(50),      
@ValorProm numeric (8,3),   
@Marca varchar (30),  
@Certificado varchar (15),  
@idconf int,  
@idPlaAut int output        
as   
  
--rdelacuba 06/10/2006: Se incluye la configuración vehicular       
insert into TQPLAAUT        
(        
codage19,        
nropla81,        
esactivo,        
usuaregi,        
fechareg,        
UodoTablero,        
UodoExterno,      
Nombre,    
ValorProm,  
Marca,  
Certificado,  
idconf  
)        
values        
(        
@codage19,        
@nropla81,        
@esactivo,        
@usuaregi,        
getdate(),        
@tablero,        
@externo,      
@Nombre,    
@ValorProm,        
@Marca,  
@Certificado,  
@idconf  
)        
select @idPlaAut = @@identity        

EXEC NPT9_bd_trit.DBO.USP_GENERACIONPLACA @nropla81,@Nombre
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_PrecioCombustible]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_PrecioCombustible]
@idcombus int,
@idforpag char(1),
@precioco decimal (12,2),
@Fechaing varchar(8),
@usuaregi varchar(50),
@idprecio int output 
as
insert into TQPRECOMB
(
idcombus,
idforpag,
precioco,
Fechaing,
usuaregi,
fechareg
)
values
(
@idcombus,
@idforpag,
@precioco,
@Fechaing,
@usuaregi,
getdate()
)
select @idprecio = @@identity
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Servicio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Servicio]  
@NombServ varchar (50),  
@IdUnitControl int,  
@Cantidad decimal (8,2),  
@UsuarioReg varchar (30),  
@Control int,
@idTipoServ int output  
as  
insert into tqservicio  
(  
NombServ,  
IdUnitControl,  
Cantidad,  
UsuarioReg,  
FechaReg,
Control  
)  
values  
(  
@NombServ,  
@IdUnitControl,  
@Cantidad,  
@UsuarioReg,  
getdate(),
@Control  
)  
select @idTipoServ = @@identity  
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Servicios]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Servicios]
@FechaIni varchar(8),
@HoraIni varchar(8),
@IdChofer int,
@IdPlacaAut int,
@Carreta varchar (50),
@IdTipoServ int,	
@IdEmpresaServ	int,
@Contacto varchar(50),
@HorometroIni decimal (8,2),
@OdometroIni decimal(8,2),
@Estado	char(1),
@FechaFin varchar(8),
@HoraFin varchar(8),
@HorometroFin	decimal	(8,2),
@OdometroFin	decimal	(8,2),
@ObservacioIni	varchar	(255),
@ObservacionFin	varchar	(255),
@UsuarioReg	varchar	(30),
@NroServicio	int output 
as
insert into DCSERVICIOS (
FechaIni,
HoraIni,
IdChofer,
IdPlacaAut,
Carreta,
IdTipoServ,
IdEmpresaServ,
Contacto,
HorometroIni,
OdometroIni,
Estado,
FechaFin,
HoraFin,
HorometroFin,
OdometroFin,
ObservacioIni,
ObservacionFin,
FechaReg,
UsuarioReg
)
values 
(
@FechaIni,
@HoraIni,
@IdChofer,
@IdPlacaAut,
@Carreta,
@IdTipoServ,	
@IdEmpresaServ,
@Contacto,
@HorometroIni,
@OdometroIni,
@Estado,
@FechaFin,
@HoraFin,
@HorometroFin,
@OdometroFin,
@ObservacioIni,
@ObservacionFin,
getdate (),
@UsuarioReg
)
select @NroServicio = @@identity


GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Tarifa]    
@idcircuito int,  
--@codrut01 char(3),    
@flgigv01 char(1),    
@comision20 numeric(12,2),    
@comision40 numeric(12,2),    
@tarifa20 numeric(12,2),    
@tarifa40 numeric(12,2),    
@comisionxviaje char(1),    
@flagCirViaje char(1),   
@Usuario varchar(30),   
@valRef numeric(12,2),  
@Idtarifa int output    
as    
  
--rdelacuba 04/10/2006: Se agregó campo valRef  
insert into cqtarcir01    
(    
idcircuito,  
--codrut01,    
flgigv01,    
comision20,    
comision40,    
tarifa20,    
tarifa40,    
comisionxviaje,    
Usuario,    
fecreg,  
flagCirViaje,  
valRef    
)    
Values    
(   
@idcircuito,   
--@codrut01,    
@flgigv01,    
@comision20,    
@comision40,    
@tarifa20,    
@tarifa40,    
@comisionxviaje,    
@Usuario,    
getdate(),  
@flagCirViaje,  
@valRef    
)    
    
select @idtarifa = @@identity    
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_Tikets]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_Tikets]        
@idplaaut int,         
@idprecio int,         
@cantidad decimal (12,6),        
@tipocamb decimal (8,3),        
@nrofactu char(10),        
@fecfactu char(8),        
@nrovalet char(20),        
@flagesta char(1),        
@usuaregi varchar(50),        
@fechvale char(8),      
@horavale char(8),      
@OActual  decimal (9,1),    
@OAnterior decimal (9,1),    
@OActualTablero decimal (9,1),    
@OAnteriorTablero decimal (9,1),     
@HActual decimal (9,1),    
@HAnterior decimal (9,1),    
@PUnitario decimal(14,3),  
@IdCombus int,  
@IdValeaut int,
@idtikets int output        
  
as        
insert into TQTIKETS        
(        
fechareg,        
idplaaut,         
idprecio,         
cantidad,        
tipocamb,        
nrofactu,        
fecfactu,        
nrovalet,        
flagesta,        
usuaregi,      
fechvale,      
horavale,    
OActual,    
OAnterior,    
OActualTablero,    
OAnteriorTablero,    
HActual,    
HAnterior,  
PUnitario,  
IdCombus, 
idvaleaut  
)        
values        
(        
getdate(),        
@idplaaut,         
@idprecio,         
@cantidad,        
@tipocamb,        
@nrofactu,        
@fecfactu,        
@nrovalet,        
@flagesta,        
@usuaregi,      
@fechvale,        
@horavale,    
@OActual,    
@OAnterior,    
@OActualTablero,    
@OAnteriorTablero,    
@HActual,    
@HAnterior,  
@PUnitario,  
@idCombus,
@IdValeaut    
)           
select @idtikets = @@identity        

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_TipoEvento]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_TipoEvento]
@DescripcionEvent varchar(50),
@Usuario varchar(30),
@idTipoEvent int output
as
insert into tqtipoevento
(
DescripcionEvent,
Usuario,
FechaReg
)
values
(
@DescripcionEvent,
@Usuario,
getdate()
)
select @idTipoEvent = @@identity

GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_UnidadControl]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[sp_Agregar_UnidadControl]  
@DescripcionControl varchar (70),  
@Usuario varchar (30),  
@UniConver char(1),
@valorConver decimal(8,3),
@idUnidadControl int output  
as  
insert into tqunitcont  
(  
DescripcionControl,  
Usuario,  
FechaReg,
UniConver, 
valorConver
  
)  
values  
(  
@DescripcionControl,  
@Usuario,  
getdate(),
@UniConver, 
@valorConver  
)  
select @idUnidadControl = @@identity  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_usuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Agregar_usuario]  
@Nombre varchar(50),  
@Apellidos varchar(100),  
@Login Varchar(30),  
@Pass varchar(15),  
@UsurioReg varchar(30),  
@Estado char(1),  
@usuTrans char(1),
@usuCombs char(1),
@idUsuario int OUTPUT  
AS  
INSERT INTO TQUSUARIO
(  
Nombre,  
Apellidos,  
Login,  
Pass,  
UsurioReg,  
Estado,  
FecReg,  
usuTrans,
usuCombs 

)  
VALUES  
(  
@Nombre,  
@Apellidos,  
@Login,  
@Pass,  
@UsurioReg,  
@Estado,  
GETDATE(),  
@usuTrans,
@usuCombs 
)  
SELECT @idUsuario = @@IDENTITY  
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Agregar_ValeAut]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Agregar_ValeAut]
@IdPlaAut int,
@FlagExtra char (1),
@Fecha varchar(8),
@TableroAnt decimal(10,1),
@TableroAct decimal(10,1),
@ExternoAnt decimal(10,1),
@ExternoAct decimal(10,1),
@HoroAnt decimal(10,1),
@HoroAct decimal(10,1),
@Cantidad decimal (12,6),
@Rendimiento decimal(8,3),
@Usuario Varchar(30),
@IdVale int output
as
insert into TQVALESAUT
(
IdPlaAut,
FlagExtra,
Fecha ,
TableroAnt,
TableroAct,
ExternoAnt,
ExternoAct,
HoroAnt,
HoroAct,
Cantidad,
Rendimiento,
Usuario,
FechaReg
)
values
(
@IdPlaAut,
@FlagExtra,
@Fecha ,
@TableroAnt,
@TableroAct,
@ExternoAnt,
@ExternoAct,
@HoroAnt,
@HoroAct,
@Cantidad,
@Rendimiento,
@Usuario,
getdate()
)
select @IdVale = @@identity
GO
/****** Object:  StoredProcedure [dbo].[sp_AgregaTktContado]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*ALTER PROCEDURE   [dbo].[sp_AgregaTktContado]        
as        
        
SELECT          
A.FECHA_REAL,         
--A.HORA,         
ltrim(A.RUC) as RUC,         
ltrim(A.RAZON_SOCIAL) as RAZON_SOCIAL,         
ROUND(SUM(A.CANTIDAD) * PRECIO_UNIT,2) AS IMPORTE_TOTAL,        
round(sum(A.IMPORTE_NETO),2) as IMPORTE_NETO,        
ROUND(SUM(A.IGV),2) AS IGV,        
--A.PRODUCTO,        
ROUND(SUM(A.CANTIDAD),3) AS CANTIDAD,        
ROUND(A.PRECIO_UNIT, 2) AS PRECIO_UNIT,        
12 AS TIPO_DOC,          
CASE WHEN A.TIPO_DOC = 'TBOL' and SERIE_DOC = '001' THEN '001'        
     WHEN A.TIPO_DOC = 'TFAC' and SERIE_DOC = '001' THEN '002'     
     WHEN A.TIPO_DOC = 'TBOL' and SERIE_DOC = '002' THEN '003'        
     WHEN A.TIPO_DOC = 'TFAC' and SERIE_DOC = '002' THEN '004' END AS SERIE_DOC,          
A.NUMERO_DOC,        
B.COD_ULTRA,        
B.COD_TIPO_COMB,        
A.ESTADO_ANUL,        
A.TIPO_DOC +     
CASE WHEN A.TIPO_DOC = 'TBOL' and SERIE_DOC = '001' THEN '001'        
     WHEN A.TIPO_DOC = 'TFAC' and SERIE_DOC = '001' THEN '002'     
     WHEN A.TIPO_DOC = 'TBOL' and SERIE_DOC = '002' THEN '003'        
     WHEN A.TIPO_DOC = 'TFAC' and SERIE_DOC = '002' THEN '004' END + CONVERT(VARCHAR(10),numero_doc) + A.ESTADO_ANUL as CORRELATIVO        
INTO #TEMCONTABILIZADOR        
FROM neptunia1.ZEUS.dbo.TRITON_CONTAB AS A INNER JOIN TQCOMBUS AS B        
ON A.PRODUCTO COLLATE SQL_Latin1_General_CP1_CI_AS = B.DESCOMBU COLLATE SQL_Latin1_General_CP1_CI_AS        
where tipo_doc <> 'NDES'        
group by A.FECHA_REAL,         
A.HORA,         
A.RUC,         
A.RAZON_SOCIAL,         
A.TIPO_DOC,        
A.SERIE_DOC,        
A.NUMERO_DOC,        
A.PRECIO_UNIT,        
--A.IMPORTE_NETO,        
A.PRODUCTO,        
A.ESTADO_ANUL,        
B.COD_ULTRA,        
B.COD_TIPO_COMB        
order by tipo_doc,numero_doc        
        
Insert into TQCONTABILIZADOR(        
Fecha_enision,        
rut_facturar,        
Nombre_facturar,        
Monto_total_importe,        
Monto_total_SinIGV,        
Igv_documento,        
cantidad ,        
precio_Unitario,        
TipoDocumento,        
numeroSerie ,        
Numero_documento ,        
codigo_ultra_comb,        
codigo_tipo_combu,        
Estado,        
correlativo        
)        
Select * from #TEMCONTABILIZADOR     
where correlativo is not null and     
coalesce(CORRELATIVO,'') COLLATE SQL_Latin1_General_CP1_CI_AS + convert(varchar(4), COD_ULTRA) not in (Select coalesce(CORRELATIVO,'') COLLATE SQL_Latin1_General_CP1_CI_AS + convert(varchar(4),  codigo_ultra_comb) from TQCONTABILIZADOR)        
--and COD_ULTRA   not in (Select codigo_ultra_comb from TQCONTABILIZADOR)        
Drop table #TEMCONTABILIZADOR        
RETURN 0    
  

GO*/
/****** Object:  StoredProcedure [dbo].[sp_Alertas_Triton_Guias]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Alertas_Triton_Guias]  
@Titulo char (50),  
@Glosa char(500)  
AS            
exec master.dbo.xp_smtp_sendmail            
 @FROM   = N'alertas@neptunia.com.pe',   
 @FROM_NAME  = N'Neptunia Servicio de Alertas - Guias Triton',   
 @TO   = N'apalaciosm@neptunia.com.pe',   
 @replyto         = N'',            
 @CC   = N'',            
 @BCC   = N'lmalpartida@neptunia.com.pe',            
 @priority  = N'NORMAL',            
 @subject  = @Titulo,            
 @message  = @Glosa,            
 @messagefile  = N'',            
 @type   = N'text/plain',            
 @attachment  = N'',            
 @attachments  = N'',            
 @codepage  = 0,            
 @server   = N'correo.neptunia.com.pe'
GO
/****** Object:  StoredProcedure [dbo].[sp_Anular_Factura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Anular_Factura]
@nrofac01 char(10),
@tipdoc01 char(2),
@idconta01 int,
@flages01 char(1),
@coduse01 varchar(50)
as
update DCFACTTR01 set
flages01 = @flages01,
coduse01 = @coduse01
where
nrofac01 = @nrofac01 and
tipdoc01 = @tipdoc01 and
idconta01 = @idconta01
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Busca_IdCombustible]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Busca_IdCombustible]
@descombu varchar(50)
as
select idCombus from TQCOMBUS
where descombu = @descombu
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_BuscaNroVale]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BuscaNroVale]  
@NroVale varchar(20),  
@IdCombus int 
as  
select idtikets from TQTIKETS  
where nrovalet = @NroVale  AND IDCOMBUS = @IdCombus
order by nrovalet
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscaNroValePlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BuscaNroValePlaca]  
@NroVale varchar(20),
@idplaaut int
as  
select idtikets from TQTIKETS  
where nrovalet = @NroVale  and idplaaut = @idplaaut
return 0 


GO
/****** Object:  StoredProcedure [dbo].[sp_Buscar_Cliente_byRuc]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Buscar_Cliente_byRuc]
@rucclien char(11)
as
select rucclien from TQCLIENTE
where rucclien = @rucclien 
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Buscar_PlacaAutorizada_ByPlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Buscar_PlacaAutorizada_ByPlaca]  
@Placa char(7)  
as  
select a.idPlaAut, a.codage19, a.nropla81  
from TQPLAAUT as a   
where a.nropla81 = @Placa  
GO
/****** Object:  StoredProcedure [dbo].[sp_Buscar_UltimoNroBySerie]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Buscar_UltimoNroBySerie]
@idconta01 int
as
select numerdo01 from DCCONTTRI01
where idconta01 = @idconta01


GO
/****** Object:  StoredProcedure [dbo].[sp_BuscaUltimosValesxCamion]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BuscaUltimosValesxCamion]  
-- Procedimiento para buscar el ultimo valor de los odometros  
@idplaaut int
as  
select TableroAct,ExternoAct,HoroAct, Fecha from TQVALESAUT
where idplaaut=@idplaaut and fecha=(  
select max(a.fecha)  
from TQVALESAUT a   
where a.idplaaut = @idplaaut)  

GO
/****** Object:  StoredProcedure [dbo].[sp_BuscaUltimosValores]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BuscaUltimosValores]    
-- Procedimiento para buscar el ultimo valor de los odometros    
@placa as int  
as    
select fechvale, OActual, OactualTablero, Hactual   from TQTIKETS  
where fechvale = (select max(a.fechvale)    
from tqtikets a where   idplaaut = @placa and hactual > 0) and  
 idplaaut = @placa and hactual > 0
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscaUltimosValoresModi]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BuscaUltimosValoresModi]    
-- Procedimiento para buscar el ultimo valor de los odometros    
@placa int,  
@Idtikets int
as    
select fechvale, OActual, OactualTablero, Hactual   from TQTIKETS  
where fechvale = (select max(a.fechvale)    
from tqtikets a where   idplaaut = @placa and hactual > 0) and  
 idplaaut = @placa and hactual > 0 and idtikets <> @Idtikets
GO
/****** Object:  StoredProcedure [dbo].[sp_Calcular_Total_TiketsByRuc_Estado]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Calcular_Total_TiketsByRuc_Estado]
@codage19 char (11),
@flagesta char (1)
as
select sum(a.cantidad * b.precioco) as TOTAL
from TQTIKETS as a inner join TQPRECOMB as b
on a.idprecio = b.idprecio inner join TQPLAAUT AS c
on a.idplaaut = c.idplaaut
where c.codage19 = @codage19 and a.flagesta = @flagesta

GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_GUIAS_TRITON]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CARGA_GUIAS_TRITON]
@viGuiatriton VARCHAR(10),
@viGuiaCliente VARCHAR(10),
@viCodCircuito VARCHAR(5),
@viNave VARCHAR(4),
@viViaje VARCHAR(10),
@viFecha VARCHAR(8),
@viBrevete VARCHAR(9),
@viPlaca VARCHAR(7),
@viPlacaCarreta VARCHAR(10),
@viRUC VARCHAR(11),
@viContenedor VARCHAR(11),
@viTamanoCtr VARCHAR(3),
@viDetalleCircuito VARCHAR(100),
@viTipoMerc VARCHAR(100),
@viMoneda VARCHAR(1),
@viTarifaD DECIMAL(15,2),
@viTarifaS DECIMAL(15,2),
@viComision DECIMAL(15,2)
AS
BEGIN
	--|SETEO DE VARIABLES
	SET @viGuiatriton = LTRIM(RTRIM(@viGuiatriton))
	SET @viGuiaCliente = LTRIM(RTRIM(@viGuiaCliente))
	SET @viCodCircuito = LTRIM(RTRIM(@viCodCircuito))
	SET @viViaje = LTRIM(RTRIM(@viViaje))
	SET @viBrevete = LTRIM(RTRIM(@viBrevete))
	SET @viPlaca = LTRIM(RTRIM(@viPlaca))
	SET @viPlacaCarreta = LTRIM(RTRIM(@viPlacaCarreta))
	SET @viRUC = LTRIM(RTRIM(@viRUC))
	SET @viContenedor = LTRIM(RTRIM(@viContenedor))
	SET @viTamanoCtr = LTRIM(RTRIM(@viTamanoCtr))
	SET @viDetalleCircuito = LTRIM(RTRIM(@viDetalleCircuito))
	SET @viTipoMerc = LTRIM(RTRIM(@viTipoMerc))
	--|
	
	--|OBTENER PLACA REMOLQUE
	/*
	IF EXISTS(SELECT *FROM DCGUITTR01 WHERE nrogui73 = @viGuiaCliente)
	BEGIN
		SELECT @viPlacaCarreta = ISNULL(LTRIM(RTRIM(remolq73)),'')
		FROM DCGUITTR01 WITH (NOLOCK)
		WHERE nrogui73 = @viGuiaCliente
	END
	ELSE
	BEGIN
		SET @viPlacaCarreta = ''
	END
	*/
	--|
	
	DECLARE @NAVVIA VARCHAR(6), @CODCON VARCHAR(8)
	
	--|OBTENER NAVVIA Y CODCON
	select @CODCON = codcco06,
	@NAVVIA = navvia11 
	from Terminal..DDCABMAN11 WITH (NOLOCK)
	where codnav08 = @viNave 
	AND numvia11 = @viViaje      
	and feclle11 > GETDATE()-800
	and codcco06 <> ''        
	and codcco06 is not null      
	--|
	
	IF ISNULL(@CODCON,'')=''
	BEGIN
		SET @CODCON = '' 
	END
		
	IF ISNULL(@NAVVIA,'')=''
	BEGIN
		SET @NAVVIA = '' 
	END
	
	DECLARE @IDCIRCUITO INT, @IDTARIFA INT
	--|OBTENER EL IDCIRCUITO Y EL IDTARIFA
	select         
	@IDTARIFA = a.Idtarifa,        
	@IDCIRCUITO = a.idcircuito
	from cqtarcir01 as a WITH (NOLOCK) 
	inner join CQCIRCUI01 as b WITH (NOLOCK) on a.idcircuito = b.idcircuito    
	where b.codrut01 = @viCodCircuito 
	and a.fecreg = (select max(Z.fecreg) from cqtarcir01 Z where Z.idcircuito = b.idcircuito)
	--|
	
	DECLARE @TIPOMERC VARCHAR(1)
	--|OBTENER CAMPOS TIPO MERCADERIA
	
	IF @viTipoMerc = ''
	BEGIN	
		SET @TIPOMERC = NULL
	END
	IF @viTipoMerc = 'CNTR LLENOS'
	BEGIN	
		SET @TIPOMERC = 'L'
	END
	IF @viTipoMerc = 'CNTR VACIOS'
	BEGIN	
		SET @TIPOMERC = 'V'
	END
	IF @viTipoMerc = 'OTRA MERCADERIA'
	BEGIN	
		SET @TIPOMERC = 'O'
	END
	--|
	
	IF @viRUC = '' OR LEN(@viRUC)<>11
	BEGIN	
		SET @viRUC = '20100010217'
	END
	
	IF NOT EXISTS(SELECT *FROM DCGUITTR01 WHERE nrogui01 = @viGuiatriton)
	BEGIN
		insert into DCGUITTR01 (                      
		nrogui01,                       
		nrogui73,                       
		codcco06,                      
		navvia11,                      
		nropla01,                      
		fecgen01,                      
		client01,                      
		brevet01,                      
		idcircuito,          
		codnav08,                      
		remolq73,                      
		nrodet01,                    
		flagEstra,                    
		DesCircu,                    
		PrecioCir,                    
		Comision,                    
		FlagVicon,                
		observacion,              
		IdTarifa,          
		TipoMerc,        
		Usucrea,        
		fecreg01,        
		PtoOrigen,        
		PtoDestino,        
		ValRef,      
		peaje,    
		PrecioCir_S        
		)                      
		values                      
		(                      
		@viGuiatriton,                       
		@viGuiaCliente,                       
		@CODCON,                      
		@NAVVIA,                      
		@viPlaca,                      
		@viFecha,        
		@viRUC,                      
		@viBrevete,                      
		@IDCIRCUITO,                     
		@viNave,                      
		@viPlacaCarreta,                      
		NULL,                      
		NULL,                    
		@viDetalleCircuito,                    
		@viTarifaD,                    
		@viComision,                    
		'N',                
		NULL,              
		@IDTARIFA,          
		@TIPOMERC,        
		'webAut',        
		getdate(),        
		NULL,        
		NULL,        
		0,      
		0,      
		@viTarifaS                    
		)    
		
		EXEC USP_CARGA_DET_GUIA_TRITON @viGuiatriton, @viContenedor, @viTamanoCtr                  
	END
	ELSE
	BEGIN
		UPDATE DCGUITTR01 SET                                             
		nrogui73 = @viGuiaCliente,                       
		codcco06 = @CODCON,                      
		navvia11 = @NAVVIA,                      
		nropla01 = @viPlaca,                      
		fecgen01 = @viFecha,                      
		client01 = @viRUC,                      
		brevet01 = @viBrevete,                      
		idcircuito = @IDCIRCUITO,          
		codnav08 = @viNave,                      
		remolq73 = @viPlacaCarreta,                                        
		DesCircu = @viDetalleCircuito,                    
		PrecioCir = @viTarifaD,                    
		Comision = @viComision,                                              
		IdTarifa = @IDTARIFA,          
		TipoMerc = @TIPOMERC,                 
		PrecioCir_S = @viTarifaS       
		WHERE nrogui01 = @viGuiatriton
		
		--|ELIMNAR DATA DE CONTENEDORES ANTES DE REALIZAR LA ACTUALIZACION
		delete from DDGUITTR01    
		where  nrogui01 = @viGuiatriton  
		--|
		
		EXEC USP_CARGA_DET_GUIA_TRITON @viGuiatriton, @viContenedor, @viTamanoCtr  
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CARGAR_DETALLE_GUIAS_TRITON]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CARGAR_DETALLE_GUIAS_TRITON]            
      
AS            

RETURN;
      
CREATE TABLE #DDGUITTR01 (            
 nrogui01 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,            
 codcon01 char (11) COLLATE SQL_Latin1_General_CP1_CI_AS,            
 codtam01 char (2) COLLATE SQL_Latin1_General_CP1_CI_AS )            
      
Insert into #DDGUITTR01            
EXEC terminal..SP_CIRCUITOS_FAC_DBF_DET            
    
Insert into #DDGUITTR01            
EXEC descarga.dbo.SP_CIRCUITOS_FAC_DBF_08_DET           
      
--Insert into #DDGUITTR01            
--EXEC Oceanica1.descarga.dbo.SP_CIRCUITOS_FAC_DBF_DET          
      
Insert into ddguittr01(nrogui01,codcon01, codtam01 )            
Select * from #DDGUITTR01 where nrogui01+codcon01 not in (Select nrogui01+codcon01 from ddguittr01)            
      
Drop table #DDGUITTR01            
      
return 0
GO
/****** Object:  StoredProcedure [dbo].[SP_CARGAR_GUIAS_TRITON]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CARGAR_GUIAS_TRITON]               
@fecfin varchar(8),               
@horaFin varchar(8)                             
AS                 
    
--declare @fecfin varchar(8),@horaFin varchar(8)    
--set @fecfin='20160319'     
--set @horaFin='15:45'    
  
RETURN;  
      
Declare @Fecha datetime                                     
                                
set @Fecha = convert(datetime, @fecfin + ' ' + @horaFin)      
         
create TABLE #DCGUITTR01 (                    
 nrogui01 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS, -- PRIMARY KEY  CLUSTERED WITH FILLFACTOR= 85,                    
 nrogui73 char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 codcco06 varchar (8) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 navvia11 char (6) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 nropla01 char (7) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 fecgen01 datetime NOT NULL ,                    
 client01 char (11) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 brevet01 varchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 idcircuito int,                    
 codnav08 char (4) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 remolq73 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,                      
 idtarifa int,            
 UsuCrea varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS)                
            
      
create TABLE #DCGUITTR02 (                    
 nrogui01 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS, -- PRIMARY KEY  CLUSTERED WITH FILLFACTOR= 85,                    
 nrogui73 char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 codcco06 varchar (8) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 navvia11 char (6) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 nropla01 char (7) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 fecgen01 datetime NOT NULL ,                    
 client01 char (11) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 brevet01 varchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 idcircuito int,                    
 codnav08 char (4) COLLATE SQL_Latin1_General_CP1_CI_AS,                    
 remolq73 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,                      
 idtarifa int,            
 UsuCrea varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS)                
      
Insert into #DCGUITTR01                    
EXEC terminal.dbo.SP_CIRCUITOS_FAC_DBF_CAB @fecfin, @horaFin                   
            
insert into #DCGUITTR01                    
EXEC descarga.dbo.SP_CIRCUITOS_FAC_DBF_08 @fecfin, @horaFin                   
                    
--Insert into #DCGUITTR01                    
--EXEC Oceanica1.descarga.dbo.SP_CIRCUITOS_FAC_DBF_CAB @fecfin, @horaFin                   
          
CREATE TABLE #DDGUITTR01 (              
 nrogui01 char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,              
 codcon01 char (11) COLLATE SQL_Latin1_General_CP1_CI_AS,              
 codtam01 char (2) COLLATE SQL_Latin1_General_CP1_CI_AS )              
        
Insert into #DDGUITTR01              
EXEC terminal.dbo.SP_CIRCUITOS_FAC_DBF_DET_FECHA @fecfin, @horaFin                
      
Insert into #DDGUITTR01              
EXEC descarga.dbo.SP_CIRCUITOS_FAC_DBF_08_DET_FECHA  @fecfin, @horaFin            
        
--Insert into #DDGUITTR01              
--EXEC Oceanica1.descarga.dbo.SP_CIRCUITOS_FAC_DBF_DET_FECHA  @fecfin, @horaFin              
        
          
/** No existen Guias  009  **/          
delete  from #DCGUITTR01          
where SUBSTRING(nrogui01,1,3) = '009' AND FECGEN01 >= '20080701'          
          
/** guias antiguas  **/          
delete  from #DCGUITTR01          
where nrogui01 <= '0010001500' and            
SUBSTRING(nrogui01,1,3) = '001' and FECGEN01 >= '20080701'          
          
          
declare @nro int, @nrogui01 varchar(10)              
DECLARE cursor_guia CURSOR for               
              
select count (nrogui01) as Nro, nrogui01 from #DCGUITTR01              
group by nrogui01              
having count(nrogui01) > 1              
              
OPEN cursor_guia              
FETCH NEXT FROM cursor_guia              
INTO @Nro, @Nrogui01              
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
 Insert into ERRGUITTR01(nrogui01,nrogui73,codcco06,navvia11,nropla01,fecgen01,client01,brevet01,idcircuito,codnav08,remolq73, idtarifa, UsuCrea)                    
 Select * from #DCGUITTR01 where nrogui01 = @nrogui01            
            
 delete from #DCGUITTR01              
 where nrogui01 = @nrogui01              
            
 FETCH NEXT FROM cursor_Guia              
 INTO @Nro, @NroGui01              
end              
CLOSE cursor_guia              
DEALLOCATE cursor_guia              
                  
      
/***********valida si ya existe una guia con el mismo contenedor circuito en en mismo mes******/      
      
/*      
declare @guia varchar(10) , @fecgen01 char(8) ,@contenedor char(11), @idCircuito int      
DECLARE cursor_guia_circuito_cntr CURSOR for               
              
select a.nrogui01,a.idcircuito,convert(char(8),a.fecgen01,112) as fecgen01,b.codcon01  from #DCGUITTR01  as a inner join #DDGUITTR01 as b on  a.nrogui01 = b.nrogui01            
where a.fecgen01 between convert(varchar(8),dateadd(d, -8,@Fecha),112)and convert(datetime, @fecfin + ' ' + @horaFin)      
              
OPEN cursor_guia_circuito_cntr              
FETCH NEXT FROM cursor_guia_circuito_cntr              
INTO @guia, @idCircuito, @fecgen01,@contenedor              
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
 exec sp_ValidaGuiaxMesxAnio @fecgen01, @idCircuito, @contenedor, @guia      
      
 FETCH NEXT FROM cursor_guia_circuito_cntr              
 INTO @guia, @idCircuito, @fecgen01,@contenedor          
end              
CLOSE cursor_guia_circuito_cntr              
DEALLOCATE cursor_guia_circuito_cntr              
 */      
      
      
/************ Valida los valores   *************/        
      
CREATE TABLE #condicion (              
Condicionvalida varchar (22) COLLATE SQL_Latin1_General_CP1_CI_AS )         
      
insert into #condicion      
select codcon01+convert(varchar(3), idcircuito)+ convert(char(8), fecgen01, 112)       
from DCGUITTR01 as a inner join DDGUITTR01 as b on a.nrogui01 = b.nrogui01      
where  a.fecgen01 between convert(varchar(8),dateadd(d, -8,@Fecha),112)and convert(datetime, @fecfin + ' ' + @horaFin)      
      
insert into  #DCGUITTR02      
Select * from #DCGUITTR01 where nrogui01 not in (Select nrogui01 from DCGUITTR01)        
    
delete from #DCGUITTR02      
from #DCGUITTR02 as a inner join #DDGUITTR01 as b on a.nrogui01 = b.nrogui01      
where codcon01+convert(varchar(3), idcircuito)+ convert(char(8), fecgen01, 112) in       
(select Condicionvalida from #condicion)      
      
          
Insert into DCGUITTR01(nrogui01,nrogui73,codcco06,navvia11,nropla01,fecgen01,client01,brevet01,idcircuito,    
codnav08,remolq73, UsuCrea,idtarifa,PrecioCir,PrecioCir_S,DesCircu,Comision,FlagVicon)                    
Select     
a.nrogui01                    
,a.nrogui73               
,a.codcco06                   
,a.navvia11                    
,a.nropla01                   
,a.fecgen01                   
,a.client01                    
,a.brevet01                    
,a.idcircuito                   
,a.codnav08                   
,a.remolq73                           
,'PRUEBA'    
,b.idtarifa    
,case when e.flgAutomatico='1' then (case when isnull(d.nroguia,'')<>''     
          then d.tarifacobrar     
          else b.tarifa40    
          end     
         )    
          else NULL    
          end as PrecioCir    
,case when e.flgAutomatico='1' then b.tarifa40_S    
          else 0    
          end as PrecioCir_S    
,substring(e.desrut01,1,100) as DesCircu    
,case when e.flgAutomatico='1' then b.comision40     
          else NULL    
          end as Comision    
,b.comisionxviaje    
from #DCGUITTR02 a    
--|Modificacion para cargar Tarifas correctas Triton    
inner join CQTARCIR01 b with (nolock) on a.idcircuito=b.idcircuito    
left join terminal..camionajetotal d with (nolock) on d.nroguia= substring(a.nrogui01,2,len(a.nrogui01)) and d.RucTransporte='20138322000'    
inner join CQCIRCUI01 e with (nolock) on e.idcircuito = a.idcircuito    
where     
b.fecReg = (select MAX(c.fecReg) from CQTARCIR01 c where b.idcircuito=c.idcircuito)     
and a.nrogui01 not in (Select nrogui01 from DCGUITTR01)                    
      
Drop table #DCGUITTR01                    
Drop table #DCGUITTR02                    
Drop table #DDGUITTR01                    
Drop table #condicion                    
      
      
      
RETURN 0    
GO
/****** Object:  StoredProcedure [dbo].[sp_cargarGuias]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_cargarGuias]              
as              
declare @flag char(1),            
@FechaFin varchar(8),        
@HoraFin varchar(8)
         
select @flag =  flag,             
@FechaFin = FechaFin,            
@HoraFin = HoraFin           
from tqcontrolguia  
            
if @flag = 'N'               
   begin      
   exec sp_Actualiza_tqcontrolguia 'P', ''            
   exec SP_CARGAR_GUIAS_TRITON  @FechaFin, @HoraFin           
   exec SP_CARGAR_DETALLE_GUIAS_TRITON            
   exec sp_Actualiza_tqcontrolguia 'S', 'T'        
   exec terminal.dbo.EnviaCorreo_CargaGuiasTriton        
  end
return 0    


GO
/****** Object:  StoredProcedure [dbo].[sp_CircuitosByAll]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER PROCEDURE [dbo].[sp_CircuitosByAll]  

as  

select idcircuito, codrut01, desrut01, succon01, condcntr 

from CQCIRCUI01  

order by codRut01  

return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_CircuitosByAlltarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_CircuitosByAlltarifa]      
@flgigv varchar(1)
as      
IF @flgigv = ''
BEGIN
select a.idcircuito, a.codrut01, a.desrut01, b.comisionxviaje,   
a.automa01, a.cencos01, a.kilometros, b.flgigv01  ,substring(a.codrut01,1,1)
from CQCIRCUI01 as a  inner join cqtarcir01 as b  
on a.idcircuito = b.idcircuito and   
b.idtarifa = (select max(idtarifa) from cqtarcir01 where idcircuito = a.idcircuito)  
order by substring(a.codrut01,1,1), a.idcircuito 
END
ELSE
BEGIN
select a.idcircuito, a.codrut01, a.desrut01, b.comisionxviaje,   
a.automa01, a.cencos01, a.kilometros, b.flgigv01  
from CQCIRCUI01 as a  inner join cqtarcir01 as b  
on a.idcircuito = b.idcircuito and   
b.idtarifa = (select max(idtarifa) from cqtarcir01 where idcircuito = a.idcircuito)  
--where b.flgigv01 = @flgigv
order by substring(a.codrut01,1,1), a.idcircuito    
END
return 0 

GO
/****** Object:  StoredProcedure [dbo].[sp_CircuitosByTipo]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_CircuitosByTipo]      
@TipoCir01 char(1)
as      
select idcircuito, codrut01, desrut01
from CQCIRCUI01      
where TipoCir01 = @TipoCir01
order by idcircuito      
return 0 
GO
/****** Object:  StoredProcedure [dbo].[sp_consulta_byFechaCircuitoCntr]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_consulta_byFechaCircuitoCntr]   
@fecgen01 char(8),   
@idcircuito int,    
@codcon01 char(11)   
as   
	select a.nrogui01   
	from DCGUITTR01 as a   
	inner join DDGUITTR01 as b on a.nrogui01 = b.nrogui01    
	where convert(char(8),fecgen01,112) = @fecgen01    
	and idcircuito = @idcircuito and codcon01 = @codcon01
	and substring(a.nrogui01,1,4)<>'0001'  
GO
/****** Object:  StoredProcedure [dbo].[sp_consulta_byGuiaNeptunia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_consulta_byGuiaNeptunia]

@nrogui73 varchar(10)

as

select a.nrogui01

from DCGUITTR01 as a (nolock)

where nrogui73 = @nrogui73
GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_CabeceraFactura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Consultar_CabeceraFactura] 
@Id_Fact char(10)  ,
@TipoDoc char(2)                                  
as                                    
--Creado Renzo Tello
select  
A.nrofac01,
A.tipdoc01 as TipoDoc,
A.ruccli01,
A.moneda01,      
A.fecemi01,      
A.fecven01,      
A.conpag01,      
A.moneda01,      
A.tipcam01,      
A.valfac01,      
A.impven01,      
A.totven01,      
A.flages01,      
A.afecim01,      
A.atenci01,      
A.flagCont,      
A.observ01,    
A.nroRef01,  
A.FecRef01,  
B.idconta01,
c.DesEstado,
A.nroRef01 as CodRefer      
FROM DCFACTTR01 AS A INNER JOIN DCCONTTRI01 AS B 
  on A.tipdoc01 = B.tipodoc01 and a.idconta01 = b.idconta01   left join TQESTADOS as c 
  on a.flages01 = c.idEstado
where nrofac01 = @Id_Fact AND
      tipdoc01 = @TipoDoc

GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_Contenedor]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_Consultar_Contenedor]   --FMCR
--@codcon01 char(11)  
--as  
--select c.nrofac01, convert(char(10), d.fecemi01, 103)as FechaFac,  
--b.nrogui01, convert(char(10), b.fecgen01, 103) as FechaGuia,   
--b.usucrea + '/' + b.usumod as usuario, a.codcon01, a.codtam01, 
--e.codrut01, b.nropla01, b.brevet01, f.Nombre as Chofer,
--CASE WHEN b.idcircuito = 1     THEN (select codusu17 from terminal..ddticket18 t where '00' + t.nrotkt18 = b.nrogui01 )     end  usuario_c01,
--CASE WHEN b.idcircuito = 132   THEN(select codusu17 from OCEANICA1.DESCARGA.DBO.ADGUIASR99 g where g.triton99 = b.nrogui01 ) end   usuario_c23
--/*(CASE WHEN b.idcircuito = 1   THEN (select codusu17 from terminal..ddticket18 t where '00' + t.nrotkt18 = b.nrogui01 )
--      WHEN b.idcircuito = 132 THEN (select codusu17 from OCEANICA1.DESCARGA.DBO.ADGUIASR99 g where g.triton99 = b.nrogui01 ) end)   usuario_guia
--*/

--from dbo.DDGUITTR01 as a   
--inner join dbo.DCGUITTR01 as b on a.nrogui01 = b.nrogui01  
--inner join dbo.CQCIRCUI01 as e on b.idcircuito = e.idcircuito    
--left join logistica.dbo.sb_conductor as f on b.brevet01 = f.numerolicencia and f.estado='A' and persona = 67 
--left join dbo.DDFACTTR01 as c on b.nrodet01 = c.nrodet01  
--left join dbo.DCFACTTR01 as  d on c.nrofac01 = d.nrofac01  
--where a.codcon01 = @codcon01  
--return 0
--GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_DetFactura01]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Consultar_DetFactura01]
@Id_factura char(10),      
@TipoDoc char(2)      

as 

Select B.desart01,
       B.nrofac01,
       B.tipdoc01,
   sum(B.cantid01) as cantidad,
      (B.preuni01) as preuni01,
   sum(B.cantid01 * B.preuni01) as Total,
       B.tipser01,
       G.Cencos01 as centrocosto,
       B.desart01 as dg_servicio,
      '*' as codtipocntr, 
      '*' as codtam09,
      '*' as codbol03,
      '*' as coduni54,
       1  as Sucursal   
 From DDFACTTR01 as B 
 LEFT JOIN DCGUITTR01 AS C ON  B.nrodet01 = C.nrodet01
 LEFT join CQCIRCUI01 as g on c.idcircuito = g.idcircuito 
Where NroFac01 = @Id_factura
Group by B.desart01,B.nrofac01,B.tipdoc01,B.preuni01,B.tipser01 ,G.Cencos01 


GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_FechasContabiliza]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Consultar_FechasContabiliza]
as 
select '20010101' as FeciniUltra, '20010101' as FecfinUltra,  
'20090101' FecIniOfisis, '20200101' as FecFinOfisis
GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_GuiasErradas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Consultar_GuiasErradas]  

@Fecini char(8),

@FecFin char(8)  

as  

select distinct b.nrogui01, b.nrogui73, convert(char(10), b.fecgen01, 103) as FechaGuia,   

e.codrut01, b.nropla01, b.brevet01, f.apellido +', '+ f.Nombre as Chofer

from dbo.ERRGUITTR01 as b 

inner join dbo.CQCIRCUI01 as e on b.idcircuito = e.idcircuito    

left join dbo.TQCHOFER as f on b.brevet01 = f.brevete

where b.fecgen01 between @fecini and @fecfin 

return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_usuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Consultar_usuario]      

@Login varchar(30),      

@pass varchar(15)      

as      

select     

idusuario,       

login,      

pass,

usuTrans,

usuCombs       

from TQUSUARIO      

where login = @login and pass = @pass      

and estado <> 'X'       

return 0      

GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_UsuarioxLogin]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Consultar_UsuarioxLogin]  
@Login varchar(30)  
as  
select    
Nombre,  
Apellidos  
from TQUSUARIO  
where login = @login  
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Elimar_Circuito]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Elimar_Circuito]
@idcircuito int
as
declare @Existe int
declare @existe1 int

select @Existe = count (*) from CQTARCIR01 
where idcircuito = @idcircuito 

select @Existe1 = count (*) from DCGUITTR01 
where idcircuito = @idcircuito 

if @Existe = 0 and @Existe1 = 0
begin 
delete CQCIRCUI01
where idcircuito = @idcircuito 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_CamionLlanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_CamionLlanta]
@IdCamionLlanta int
as
delete from  TQLLANTA where id_camionllanta = @IdCamionLlanta

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Chofer]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Chofer]
@Idchofer int
as  
declare @Existe  int  
select @existe = count(Idchofer) from DCSERVICIOS
where idchofer = @Idchofer
if @existe = 0   
begin  
   delete from  TQCHOFER where idchofer = @Idchofer
end    
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_cliente]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_cliente]
@rucclien char(11)
as
declare @Existe  int
select @existe = count (codage19) from TQPLAAUT
where codage19 = @rucclien
if @existe = 0 
begin
   delete from  TQCLIENTE where rucclien = @rucclien  
end  
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_DetFactura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_DetFactura]  
@nrofac01 char(10),  
@tipdoc01 char(2),  
@idconta01 int  
as  
delete DDFACTTR01  
where nrofac01 = @nrofac01 and  
tipdoc01 = @tipdoc01 and  
idconta01 = @idconta01  

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_DetGuia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_DetGuia]  
@nrogui01 char(10)  
as   
delete from DDGUITTR01  
where  nrogui01 = @nrogui01
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Diseniollanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Diseniollanta]
@IdDisenio int
as
declare @Existe  int    
select @existe = count(IdDisenio) from cdllanta
where IdDisenio = @IdDisenio  
if @existe = 0     
begin    
   delete from TQDISENIOLLANTA where IdDisenio = @IdDisenio
end 

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_EmpServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_EmpServ]
@idEmpServ int
as  
declare @Existe  int  
select @existe = count(idEmpresaServ) from DCSERVICIOS
where idEmpresaServ = @idEmpServ
if @existe = 0   
begin  
   delete from  TQEMPSERV where idEmpServ = @idEmpServ
end   
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Eventos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Eliminar_Eventos]
@idEvento  int
as
delete from DCEVENTOS
where idEvento = @idEvento 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Eventos_Servicio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Eventos_Servicio]  
@idServicio  int,
@Estado char (1)
as  
delete from DCEVENTOS  
where idServicio = @idServicio and EstadoServicio = @Estado



GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Eventos_Ticket]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Eventos_Ticket]
@Idtikets int
as  
delete from DCEVENTOS  
where Idtikets = @Idtikets

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Guia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Eliminar_Guia]  
@nrogui01 char(10)  
as   
delete from DCGUITTR01  
where  nrogui01 = @nrogui01
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Llanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Llanta]
@idllanta int
as
declare @Existe int
select @existe = count (*) from cdllanta
where idllanta = @idllanta
if @existe > 0 
begin
   delete cdllanta where idllanta = @idllanta
end  
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Marca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Marca]
@IdMarca int
as
declare @Existe  int    
select @existe = count(IdMarca) from cdllanta
where IdMarca = @IdMarca
if @existe = 0     
begin    
   delete from TQMARCA where IdMarca = @IdMarca
end 

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Medida]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Medida]
@IdMedida int
as
declare @Existe  int    
select @existe = count(IdMarca) from cdllanta
where IdMedida = @IdMedida
if @existe = 0     
begin    
   delete from TQMEDIDA where IdMedida = @IdMedida
end 

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Permisos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Eliminar_Permisos]  
@IdPermisos int   
as  
delete from  TQPERMISOS   
where IdPermisos = @IdPermisos  
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_PlacaAutorizada]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_PlacaAutorizada]
@idPlaAut int
as
declare @Existe  int
 
select @existe = count (idPlaAut) from TQTIKETS
where idPlaAut = @idPlaAut
if @existe = 0 
   delete from TQPLAAUT where idPlaAut =  @idPlaAut 
 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_PrecioCombustible]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_PrecioCombustible]  
@idprecio int  
as  
declare @Existe int  
select @Existe = count (idprecio) from TQTIKETS  
where @idprecio = idprecio   
if @existe = 0    
   delete from TQPRECOMB where @idprecio = idprecio   

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Servicio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Servicio]
@idServicio int  
as    
declare @Existe  int    
select @existe = count(idtiposerv) from DCservicios  
where idtiposerv = @idservicio    
if @existe = 0     
begin    
   delete from  tqservicio where idTiposerv = @idservicio
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_Tarifa]
@IdTarifa int
as  
declare @Existe  int  
select @existe = count(IdTarifa) from DCGUITTR01
where idTarifa = @IdTarifa  
if @existe = 0   
begin  
   delete from  cqtarcir01 where idTarifa = @IdTarifa     
end    

GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Tickets]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Eliminar_Tickets]
@idtikets int
as
delete from TQTIKETS
where idtikets = @idtikets
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_TipoEvento]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_TipoEvento]
@idTipoEvent int
as  
declare @Existe  int  
select @existe = count(idTipoEvent) from DCEVENTOS
where idTipoEvent = @idTipoEvent  
if @existe = 0   
begin  
   delete from  tqtipoevento where idTipoEvent = @idTipoEvent  
end    
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_UnidadControl]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_UnidadControl]  
@idUnidadControl int    
as      
declare @Existe  int      
select @existe = count(idunitcontrol) from tqservicio    
where idunitcontrol = @idUnidadControl  
if @existe = 0       
begin      
   delete from  tqunitcont where idunidadcontrol = @idUnidadControl  
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Usuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Eliminar_Usuario]  
@idUsuario int,  
@Estado char(1),  
@UsurioReg varchar(30)  
AS  
update TQUSUARIO set  
estado = @Estado,  
UsurioReg = @UsurioReg,  
FecReg = GETDATE()  
where idUsuario = @idUsuario   
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_ValeAut]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eliminar_ValeAut]
@IdVale int
as
declare @Existe  int    
select @existe = count(idValeAut) from TQTIKETS
where IdValeAut = @IdVale   
if @existe = 0     
begin    
   delete from TQVALESAUT where IdVale = @IdVale
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Habilita_NoContabilizados]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Habilita_NoContabilizados]
as
update TQCONTABILIZADOR set 
codigoultragestion = null,
glosa = null,
fechacont = null
where codigoultragestion = 0
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_ImpresionFactura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ImpresionFactura]                      
@nroFac01 char(10),                      
@tipdoc01 char(2),                      
@idconta01 int                      
as                  
              
DECLARE @flg_igv char(1), @val_ref numeric(12,2), @tot_fac decimal(12,2),               
 @tot_gui int, @tot_val_ref numeric(12,2), @tipo_cir char(1) , @auto  int        
              
--rdelacuba 05/10/2006: Verificar si el circuito aplica IGV, obtener el valor referencial y el total facturado en soles              
--rdelacuba 11/10/2006: Verificar el tipo de circuito              
    
create table #fact    
(    
flgigv01 varchar(1),    
valorref decimal(12,2),    
Tipocir varchar (1),    
TotalFact decimal(12,2)    
)    
    
insert into  #fact    
SELECT --top 1        
flg_igv = case when q.automa01 = 1 then T.flgigv01        
               when q.automa01 = 0 then A.afecim01 end,        
val_ref = case when q.tipocir01 = 'C' and isnull(C.valref,0) = 0 then isnull(T.valref,0)        
	       when q.tipocir01 = 'C' and isnull(C.valref,0) <> 0 then c.valref        	              
	       when q.tipocir01 = 'E' and isnull(C.valref,0) <> 0 then isnull(C.valref,0)  
               when q.tipocir01 = 'E' and isnull(C.valref,0) = 0 then T.valref end ,    
              
tipo_cir = Q.Tipocir01,              
tot_fac = CASE A.moneda01 WHEN 1 THEN isnull(totven01,0)               
                          WHEN 2 THEN isnull(totven01,0) * isnull(tipcam01,0) END    
--@auto = q.automa01        
FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
inner JOIN CQCIRCUI01 AS Q (NOLOCK) ON C.idcircuito = Q.idcircuito              
left join CQTARCIR01 AS T (NOLOCK) ON C.idtarifa = T.idtarifa              
WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01               
order by  q.automa01      
--Si el circuito aplica IGV y no es extraordinaria, calcular el valor referencial total en función del total de guías relacionadas              
--Si el cicuito aplica IGV y es extraordinaria, calcular el valor referencial total en función del valor de las guías              
    
select top 1 @flg_igv = flgigv01    
from #fact    
    
IF @flg_igv = 1              
BEGIN              
/* IF @auto = 1              
    BEGIN              
    SELECT @tot_gui = count(*)              
    FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
    A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
    INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
    WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01               
              
    IF @val_ref = 0              
       SET @tot_val_ref = @val_ref --@tot_fac  --EPM            
    ELSE              
       SET @tot_val_ref = isnull(@tot_gui,0) * isnull(@val_ref,0)               
    END              
  ELSE              
    BEGIN              
    SELECT @tot_val_ref = SUM(isnull(C.ValRef,0))              
    FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
    A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
    INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
    WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01      
 END */    
    
 select @flg_igv = flgigv01,     
 @tot_val_ref =  sum(valorref),     
 @tot_fac = totalfact    
 from #fact    
 group by flgigv01, totalfact    
    
END              
ELSE              
BEGIN              
 SET @tot_val_ref = 0              
END              
      
drop table #fact    
            
--rdelacuba 05/10/2006: Considerar el valor referencial                  
SELECT DISTINCT A.nrofac01,                      
A.tipdoc01,                      
A.ruccli01,             
A.fecemi01,                      
A.fecven01,                      
A.conpag01,                      
A.moneda01,                      
A.tipcam01,                      
A.valfac01,                      
A.impven01,                      
A.totven01,                      
A.afecim01,         
A.atenci01,                      
A.observ01,                    
B.cantid01,                      
B.preuni01,                      
B.tipser01,                      
B.desart01,                      
D.codtam01,                      
E.razonsoc AS NOMBRE,                      
E.direcci0 AS DIRECCION,                      
f.descri01,                      
b.nrodet01,              
g.codrut01,            
@tot_val_ref AS VALREF              
            
FROM DCFACTTR01 AS A INNER JOIN DDFACTTR01 as B ON                      
A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                      
INNER join TQCONPAG01 AS F ON A.conpag01 = F.conpag01                      
LEFT join TQCLIENTE AS E ON A.ruccli01 = E.rucclien                      
LEFT join DCGUITTR01 AS C ON  B.nrodet01 = C.nrodet01                      
LEFT JOIN DDGUITTR01 AS D ON C.nrogui01 = D.nrogui01            
left join CQCIRCUI01 as g on c.idcircuito = g.idcircuito            
WHERE                      
A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01                       
              
return 0      
      
    
  
  

GO
/****** Object:  StoredProcedure [dbo].[sp_ImpresionFacturaResum]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ImpresionFacturaResum]                      
@nroFac01 char(10),                      
@tipdoc01 char(2),                      
@idconta01 int                      
as                  
              
DECLARE @flg_igv char(1), @val_ref numeric(12,2), @tot_fac decimal(12,2),               
 @tot_gui int, @tot_val_ref numeric(12,2), @tipo_cir char(1) , @auto  int        
              
--rdelacuba 05/10/2006: Verificar si el circuito aplica IGV, obtener el valor referencial y el total facturado en soles              
--rdelacuba 11/10/2006: Verificar el tipo de circuito              
    
create table #fact    
(    
flgigv01 varchar(1),    
valorref decimal(12,2),    
Tipocir varchar (1),    
TotalFact decimal(12,2)    
)    
    
insert into  #fact    
SELECT --top 1        
flg_igv = case when q.automa01 = 1 then T.flgigv01        
               when q.automa01 = 0 then A.afecim01 end,        
val_ref = case when q.tipocir01 = 'C' and isnull(C.valref,0) = 0 then isnull(T.valref,0)        
	       when q.tipocir01 = 'C' and isnull(C.valref,0) <> 0 then c.valref        	              
	       when q.tipocir01 = 'E' and isnull(C.valref,0) <> 0 then isnull(C.valref,0)  
               when q.tipocir01 = 'E' and isnull(C.valref,0) = 0 then T.valref end ,    
              
tipo_cir = Q.Tipocir01,              
tot_fac = CASE A.moneda01 WHEN 1 THEN isnull(totven01,0)               
                          WHEN 2 THEN isnull(totven01,0) * isnull(tipcam01,0) END    
--@auto = q.automa01        
FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
inner JOIN CQCIRCUI01 AS Q (NOLOCK) ON C.idcircuito = Q.idcircuito              
left join CQTARCIR01 AS T (NOLOCK) ON C.idtarifa = T.idtarifa              
WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01               
order by  q.automa01      
--Si el circuito aplica IGV y no es extraordinaria, calcular el valor referencial total en función del total de guías relacionadas              
--Si el cicuito aplica IGV y es extraordinaria, calcular el valor referencial total en función del valor de las guías              
    
select top 1 @flg_igv = flgigv01    
from #fact    
    
IF @flg_igv = 1              
BEGIN              
    
 select @flg_igv = flgigv01,     
 @tot_val_ref =  sum(valorref),     
 @tot_fac = totalfact    
 from #fact    
 group by flgigv01, totalfact    
    
END              
ELSE              
BEGIN          
 SET @tot_val_ref = 0              
END              
      
drop table #fact    
            
--rdelacuba 05/10/2006: Considerar el valor referencial                  
SELECT DISTINCT A.nrofac01,                      
A.tipdoc01,                      
A.ruccli01,             
A.fecemi01,                      
A.fecven01,                      
A.conpag01,                      
A.moneda01,                      
A.tipcam01,                      
A.valfac01,                      
A.impven01,                      
A.totven01,                      
A.afecim01,         
A.atenci01,                      
A.observ01,                    
E.razonsoc AS NOMBRE,                      
E.direcci0 AS DIRECCION,                      
f.descri01,                      
@tot_val_ref AS VALREF              
FROM DCFACTTR01 AS A 
INNER join TQCONPAG01 AS F ON A.conpag01 = F.conpag01                      
LEFT join TQCLIENTE AS E ON A.ruccli01 = E.rucclien                      
WHERE                      
A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01                       
              
return 0      
      

GO
/****** Object:  StoredProcedure [dbo].[sp_Insertar_Lista_GuiaByRucCircuitoMan]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[sp_Insertar_Lista_GuiaByRucCircuitoMan]    
                                                                                                                                                                                                      
@client01 char(11),                            
                                                                                                                                                                                                                  
@idcircuito int,                        
                                                                                                                                                                                                                         
@fecini char(8),                        
                                                                                                                                                                                                                         
@fecfin char(8),                    
                                                                                                                                                                                                                             
@horaIni char(8),                    
                                                                                                                                                                                                                            
@horaFin char(8),    
                                                                                                                                                                                                                                            
@Moneda char(1),    
                                                                                                                                                                                                                                             
@Usuario varchar(30)                        
                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                             
as                                  
                                                                                                                                                                                                                             
/*    
                                                                                                                                                                                                                                                           
set @client01 = '20100010217'                   
                                                                                                                                                                                                                 
set @idcircuito = '127'                      
                                                                                                                                                                                                                    
set @fecini = '20080901'                      
                                                                                                                                                                                                                   
set @fecfin = '20080930'               
                                                                                                                  
set @horaIni = '00:00:00'    
                                                                                                                                                                                                                                    
set @horaFin = '00:00:00'    
                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                             
*/    
                                                                                                                                                                                                                                                           
    
                                                                                                                                                                                                                                                             
delete from ListaCircuitoManual    
                                                                                                                                                                                                                              
where Usuario = @Usuario    
                                                                                                                                                                                                                                     
    
                                                                                                                                                                                                                                                             
    
                                                                                                                                                                                                                                                             
Insert into ListaCircuitoManual               
                                                                                                                                                                                                                   
select                         
                                                                                                                                                                                                                                  
A.nrogui01,                            
                                                                                                                                                                                                                          
A.Nropla01,                          
                                                                                                                                                                                                                            
A.Brevet01,                          
                                                                                                                                                                                                                            
convert(varchar(10), A.fecgen01, 103) as fecgen01,                         
                                                                                                                                                                                      
A.codnav08,     
                                                                                                                                                                                                                              
A.navvia11,                         
                                                                                                                                                                                                                             
B.desrut01,                         
                                                                                                                                                                                                                             
B.codrut01,                         
                                                                                                                                                                                                                             
isnull(g.codtam01, '') as codtam01,                    
                                                                                                                                                                                                          
/*Count (a.nrogui01) as cantidad,                  
                                                                                                                                                                                                              
case when a.flagvicon = 'S' then precioCir                        
                                                                                                                                                                                               
     when a.flagvicon = 'N' and Count (a.nrogui01)= 0 then precioCir                         
                                                                                                                                                                    
     when a.flagvicon = 'N' and Count (a.nrogui01)> 0 then precioCir * Count (a.nrogui01)                        
                                                                                                                                                
     end as tarifa,                           
                                                                                                                                                                                                                   
*/    
                                                                                                                                                                                                                                                           
a.flagvicon,    
                                                                                                                                                                                                                                                 
e.numvia11,      -- '' as numvia11,     
                                                                                                                                                                                                                         
f.dc_centro_costo as centroCosto,                        
                                                                                                                                                                                                        
f.dc_tipo_identificacion_bien,                        
                                                                                                                                                                                                           
a.codcco06,    
                                                                                 
    
                                                                                                                                                                                                                                                             
case when a.flagvicon = 'S' and g.codtam01 = '40' then g.codcon01    
                                                                                                                                                                                            
     when a.flagvicon = 'S' and g.codtam01 <> '40' then ''    
                                                                                                                                                                                                   
     when a.flagvicon = 'N' then g.codcon01 end as codcon01,     
                                                                                                                                                                                                
@Usuario,    
                                                                                                                                                                                                                                                    
    
                                                                                                                                                                                                                                                             
case when @Moneda = 'S' then precioCir_S    
                                                                                                                                                                                                                     
     else precioCir end precioCir    
                                                                                                                                                                                                                            
    
                                                                                                                                                                                                                                                             
from DCGUITTR01 as A (NOLOCK)              
                                                                                                                                                                                                                      
left join DDGUITTR01 as G (nolock) on (A.nrogui01=g.nrogui01)                
                                                                                                                                                                                    
inner join CQCIRCUI01 as B (NOLOCK) on A.idcircuito = B.idcircuito                        
                                                                                                                                                                       
left join  TERMINAL.DBO.DDCABMAN11 AS E (NOLOCK) on a.navvia11 = e.navvia11                        
                                                                                                                                                              
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f                        
                                                                                                                                                                        
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS         
                                                                                                                         
or substring(a.nropla01,1,3)+'-'+substring(a.nropla01,4,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                         
                                                                                                         
where A.nrodet01 is null                        
                                                                                                                                                                                                                 
and A.client01 = @client01                            
                                                                                                                                                                                                           
and a.idcircuito = @idcircuito                        
                                                                                                                                                                                                           
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)                    
                                                                                                                                                                             
and convert(datetime, @fecfin + ' ' + @horaFin)                    
                                                                                                                                                                                              
return 0                                                                                                                                                                                                                                                      
   
----                                                                                                                                                                                                                                                           
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Lista_DocByTipodoc]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Lista_DocByTipodoc]    
@tipodoc01 char(2)    
as    
select * from DCCONTTRI01    
where tipodoc01 = @tipodoc01    
--and idconta01 in (23,24,25,26,27,28,29,30,31,32)  
    
GO
/****** Object:  StoredProcedure [dbo].[sp_Lista_DocByTipodocxUsua]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Lista_DocByTipodocxUsua] @tipodoc01 CHAR(2)    
 ,@TipUser CHAR(1)    
AS    
SELECT *    
FROM DCCONTTRI01    
WHERE tipodoc01 = @tipodoc01    
 AND TipUser = @TipUser    
 --AND idconta01 in (23,24,25,26,27,28,29,30,31,32) 
GO
/****** Object:  StoredProcedure [dbo].[sp_Lista_NoContabilizados]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Lista_NoContabilizados]
as
select distinct rut_facturar, Nombre_Facturar  from TQCONTABILIZADOR
where codigoultragestion = 0
order by Nombre_Facturar
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Lista_RendimientoxCamion]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Lista_RendimientoxCamion]
@FechaIni varchar(8),
@FechaFin Varchar(8)
as
select a.idplaaut, a.flagextra, a.fecha, 
(a.Externoact - a.externoant) as dif, 
a.cantidad , b.nropla81
from TQVALESAUT as a inner join TQPLAAUT as b on a.idplaaut = b.idplaaut
where fecha between @FechaIni and @FechaFin
GO
/****** Object:  StoredProcedure [dbo].[sp_Lista_UltimoValexPlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Lista_UltimoValexPlaca]
@Placa int,
@Fecha varchar(10)
as
select top 1 * from TQVALESAUT
where idplaaut = @Placa and fecha < @Fecha
order by fecha desc
GO
/****** Object:  StoredProcedure [dbo].[sp_listaDetalleFacturaConta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_listaDetalleFacturaConta]   
@NroFactura varchar(10)       
as     
select sum(Cantidad) as cantidad, preuni01,   
sum(subTotal) as subTotal,  nropla01, 0 as  brevet01,   
codtam01, codrut01, sum(kilometros) as Kilometros, desrut01,      
centroCosto, codultra      
from  dbo.fn_ListaDetFact(@NroFactura)  
group by  nropla01, codtam01,     
codrut01, preuni01, desrut01, centroCosto, codultra      
return   

GO
/****** Object:  StoredProcedure [dbo].[sp_listaDetalleFacturaContatemp]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_listaDetalleFacturaContatemp]
@NroFactura varchar(10) 
as
select * from prueba


GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Chofer]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Chofer]  
AS  
SELECT IdChofer, Brevete, Nombre + ' ' + Apellido as Nombre
FROM TQCHOFER  
return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_ChoferAll]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_ChoferAll]    
as    
select     
IdChofer,    
Brevete,    
dni,    
Nombre,    
Apellido,    
Direccion,    
TelefCasa,    
TelefCelu,    
FechaIngreso,    
FechaReg,    
UsuarioReg,
Estado    
from TQCHOFER    
return 0    
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Circuito]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE  [dbo].[sp_Listar_Circuito]
as
SELECT 
idcircuito,
Tipocir01,
codrut01,
desrut01,
ptopar01,
ptodes01,
automa01,
ficsol01,
ficdol03,
succon01,
cencos01,
condcntr,
kilometros,
PtoPartida,
DistPartida,
PtoLlegada,
DistLlegada,
PtoOrigen,
PtoDestino
FROM CQCIRCUI01
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_CircuitoxTipo]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE  [dbo].[sp_Listar_CircuitoxTipo]
@Tipocir01 char(1)
as
select 
idcircuito,
Tipocir01,
codrut01,
desrut01,
ptopar01,
ptodes01,
automa01,
ficsol01,
ficdol03,
succon01,
cencos01,
condcntr,
kilometros,
PtoPartida,
DistPartida,
PtoLlegada,
DistLlegada
from CQCIRCUI01
where Tipocir01 = @Tipocir01
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_ClienteAll]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_ClienteAll]  
as  
select rucclien, razonsoc from TQCLIENTE  
order by razonsoc
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_ClienteAll_Large]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_ClienteAll_Large]
as
select rucclien, 
razonsoc,
direcci0,
distrit0,
telefon0,
atencion,
usuaregi,
fechareg 
from TQCLIENTE
order by 2
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Detalle_facturas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Detalle_facturas]
@nrofac01 varchar(10)
as
select b.nrogui01, b.nropla01, b.brevet01, a.desart01, codcon01, 
c.codtam01, 
f.razonsoc,
e.desnav08, d.numvia11,
a.nrofac01, z.fecemi01
from dbo.DCFACTTR01 as z 
inner join DDFACTTR01 as a on  z.nrofac01 = a.nrofac01
and Z.tipdoc01 = a.tipdoc01 and z.idconta01 = a.idconta01              
inner join DCGUITTR01 as b on a.nrodet01 = b.nrodet01
left join dbo.DDGUITTR01 as c on b.nrogui01 = c.nrogui01
left join terminal..ddcabman11 as d on b.navvia11 = d.navvia11
left join terminal..dqnavier08 as e on d.codnav08 = e.codnav08
inner join dbo.TQCLIENTE as f on z.ruccli01 = f.rucclien
where a.nrofac01 = @nrofac01
order by c.codcon01, b.nrogui01
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_DetGuiaByNrogui01]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_DetGuiaByNrogui01]
@nrogui01 char(10)
as
select
codDet01,
codcon01,
codtam01
from DDGUITTR01
where nrogui01 = @nrogui01 
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Diseniollanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Diseniollanta]
as
select iddisenio, descripcion from TQDISENIOLLANTA
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_EmpresaServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_EmpresaServ]
as
select idEmpServ, Ruc,Nombre,Direccion, Contacto from tqempserv
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_EmpServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_EmpServ]
as
select 
idEmpServ,ruc,
Nombre,
Direccion,
Telefono,
Contacto
from TQEMPSERV
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_EventosByIdEvento]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_EventosByIdEvento]
@idEvento int
as
select idTipoEvent,
IdChofer,
idPlacaAut,
Descripcion,
Fecha,
Hora,
FechaReg,
UsuarioReg,
IdServicio,
Idtikets
from DCEVENTOS
where idEvento = @idEvento


GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_EventosByPlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_EventosByPlaca]    
@IdPlacaAut int    
as    
select     
A.IdEvento,    
A.idTipoEvent,    
A.IdChofer,    
A.idPlacaAut,    
A.Descripcion,    
convert (varchar(10), A.Fecha,103) as Fecha,    
convert (varchar(10), A.Hora,108) as Hora,    
A.FechaReg,    
A.UsuarioReg,    
A.IdServicio,    
A.Idtikets,    
B.NroPla81,    
C.nombre + ' ' + c.Apellido as chofer,    
D.DescripcionEvent,
B.Nombre   
from DCEVENTOS  AS A inner join TQPLAAUT AS B ON A.idPlacaAut = B.idplaaut     
inner join TQCHOFER AS C ON  A.IdChofer = C.IdChofer    
inner join TQTIPOEVENTO AS D on A.idTipoEvent =  D.idTipoEvent    
where IdPlacaAut = @IdPlacaAut    
order by Fecha desc    
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_EventosByUltimos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_EventosByUltimos]    
@IdPlacaAut int    
as    
select     
A.IdEvento,    
A.idTipoEvent,    
A.IdChofer,    
A.idPlacaAut,    
A.Descripcion,    
convert(varchar(10), A.Fecha, 103) as Fecha,    
convert(varchar(10), A.Hora, 108) as Hora,    
A.FechaReg,    
A.UsuarioReg,    
A.IdServicio,    
A.Idtikets,    
B.NroPla81,    
C.nombre + ' ' + c.Apellido as chofer,    
D.DescripcionEvent,
B.Nombre    
from DCEVENTOS  AS A inner join TQPLAAUT AS B ON A.idPlacaAut = B.idplaaut     
inner join TQCHOFER AS C ON  A.IdChofer = C.IdChofer    
inner join TQTIPOEVENTO AS D on A.idTipoEvent =  D.idTipoEvent    
where A.IdPlacaAut = @IdPlacaAut and     
A.Fecha + A.Hora = (select Max(Fecha + Hora)from DCEVENTOS  where IdPlacaAut = @IdPlacaAut)    
order by Fecha desc    
 
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Facturas_Por_Contabilizar]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ALTER PROCEDURE [dbo].[sp_Listar_Facturas_Por_Contabilizar]  --FMCR
--as  
--select distinct top 1 a.nrofac01,A.ruccli01,c.razonsoc, a.idconta01,   
--convert(char(8), A.fecemi01, 112) as fecemi01,A.moneda01,A.valfac01,  
--A.impven01, A.totven01, A.flages01, A.afecim01,  isnull(convert(char(8), A.FecRef01, 112), '') as FecRef01 ,  A.nroRef01, b.tipser01, a.tipdoc01   
--from DCFACTTR01 as a inner join DDFACTTR01 as b on a.nrofac01 = b.nrofac01 and a.tipdoc01 = b.tipdoc01   
--inner join TQCLIENTE as c on a.ruccli01 = c.rucclien   
--Where a.flagcont is null and a.flages01 in ('I', 'F') and b.tipser01 = 'T'   
--Order by a.fecemi01   
--return 0  
--GO
/****** Object:  StoredProcedure [dbo].[sp_listar_FormaPago]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_listar_FormaPago]
as
select idforpag, desforpa 
from TQFORPAGO
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByNrogui01]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_GuiaByNrogui01]                
      
@nrogui01 char(10)                
      
as                
      
SELECT      
a.nrogui01,                
a.nrogui73,            
a.codcco06,                
a.navvia11,                
a.nropla01,                
a.fecgen01,                
a.client01,                
a.brevet01,                
a.idcircuito,                
a.codnav08,                
a.remolq73,                
a.nrodet01,                
a.flagEstra,              
isnull(a.DesCircu,'') DesCircu,              
a.PrecioCir,              
--a.Comision,              
Comision=isnull(a.Comision,0),              
a.FlagVicon,              
b.nroFac01,                 
c.descri01,          
a.observacion,      
a.tipomerc,      
a.PtoOrigen,      
a.PtoDestino,      
a.ValRef,    
isnull(a.peaje, 0) as peaje,  
a.PrecioCir_S  
FROM DCGUITTR01 as a left join DDFACTTR01 as b                  
ON a.nrodet01 = b.nrodet01 left join TQTIPDOC01 as c                  
ON b.tipdoc01 = c.tipdoc01                
WHERE nrogui01 = @nrogui01                 
      
RETURN 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByNroguiNeptunia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_GuiaByNroguiNeptunia]               
      
@nrogui73 char(10)                
      
as                
      
SELECT      
a.nrogui01,                
a.nrogui73,            
a.codcco06,                
a.navvia11,                
a.nropla01,                
a.fecgen01,                
a.client01,                
a.brevet01,                
a.idcircuito,                
a.codnav08,                
a.remolq73,                
a.nrodet01,                
a.flagEstra,              
a.DesCircu,              
a.PrecioCir,              
--a.Comision,              
Comision=isnull(a.Comision,0),              
a.FlagVicon,              
b.nroFac01,                 
c.descri01,          
a.observacion,      
a.tipomerc,      
a.PtoOrigen,      
a.PtoDestino,      
a.ValRef,    
isnull(a.peaje, 0) as peaje,  
a.PrecioCir_S  
FROM DCGUITTR01 as a left join DDFACTTR01 as b                  
ON a.nrodet01 = b.nrodet01 left join TQTIPDOC01 as c                  
ON b.tipdoc01 = c.tipdoc01                
WHERE nrogui73 = @nrogui73               
order by fecgen01    
RETURN 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByRuc_afecto_bk]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[sp_Listar_GuiaByRuc_afecto_bk]      -- FMCR
--@client01 char(11),      
--@flgigv01 char(1),  
--@circui01 char(3),  
--@dtfecini char(10),  
--@dtfecfin char(10)      
--as      
--select A.nrogui01,      
--A.Nropla01,    
--A.Brevet01,    
--convert(varchar(10), A.fecgen01, 103) as fecgen01, A.navvia11, B.desrut01, B.codrut01, sum (case when B.comisionxviaje = 'S' then B.tarifa20      
--     when B.comisionxviaje = 'N' and C.codtam01 = 20 then  B.tarifa20      
--     when B.comisionxviaje = 'N' and C.codtam01 = 40 then  B.tarifa40 end) as tarifa      
      
--from DCGUITTR01 as A inner join CQCIRCUI01 as B on A.circui01 = B.codrut01 inner join DDGUITTR01 AS C on A.nrogui01 = c.NroGui01       
--where A.client01 = @client01   
--and B.flgigv01 = @flgigv01   
--and A.nrodet01 is null      
--and a.circui01 = @circui01  
--and convert(varchar,a.fecreg01,105) between convert(varchar,@dtfecini,105) and convert(varchar,@dtfecfin,105)
--group by A.nrogui01,      
--A.fecgen01,      
--A.navvia11,      
--B.desrut01,      
--B.codrut01,      
--A.nrodet01,    
--A.Nropla01,    
--A.Brevet01      
--order by tarifa
--return 0  



--GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByRucCircuitoCont]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[sp_Listar_GuiaByRucCircuitoCont]              
                                                                                                                                                                                                   
@client01 char(11),                  
                                                                                                                                                                                                                            
@idcircuito int,              
                                                                                                                                                                                                                                   
@fecini char(8),              
                                                                                                                                                                                                                                   
@fecfin char(8),              
                                                                                                                                                                                                                                   
@horaIni char(8),      
                                                                                                                                                                                                                                          
@horaFin char(8)      
                                                                                                                                                                                                                                           
as                  
                                                                                                                                                                                                                                             
select               
                                                                                                                                                                                                                                            
A.nrogui01,                  
                                                                                                                                                                                                                                    
A.Nropla01,                
                                                                                                                                                                                                                                      
A.Brevet01,                
                                                                                                                                                                                                                                      
convert(varchar(10), A.fecgen01, 103) as fecgen01,               
                                                                                                                                                                                                
A.codnav08,              
                                                                                                                                                                                                                                        
A.navvia11,               
                                                                                                                                                                                                                                       
B.desrut01,               
                                                                                                                  
B.codrut01,               
                                                                                                                                                                                                                                       
D.codtam01,              
                                                                                                                                                                                                                                        
--dbo.fn_CantContxViaje(A.nrogui01) as cantidad,              
                                                                                                                                                                                                   
1 as cantidad,        
                                                                                                                                                                                                                                           
case when c.flagCirViaje = 1 then              
                                                                                                                                                                                                                  
     (case when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20                  
                                                                                                                                                    
           when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40                  
                                                                                                                                                    
           when D.codtam01 = 40 then  c.tarifa40 end)              
                                                                                                                                                                                              
           when c.flagCirViaje = 0 then              
                                                                                                                                                                                                            
     (case when D.codtam01 = 20 then  c.tarifa20                  
                                                                                                                                                                                               
           when D.codtam01 = 40 then  c.tarifa40 end)              
                                                                                                                                                                                              
           end as tarifa,                 
                                                                                                                                                                                                                       
e.numvia11,              
                                                                                                                                                                                                                                        
f.dc_centro_costo as centroCosto,              
                                                                                                                                                                                                                  
f.dc_tipo_identificacion_bien,              
                                                                                                                                                                                                                     
a.codcco06,       
                                                                                                                                                                                                                                  
d.codcon01,  
                                                                                                                                                                                                                                                    
case when c.flagCirViaje = 1 then              
                                                                                                                                                                                                                  
     (case when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20_S  
                                                                                                                                                                  
           when D.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40_S  
                                                                                                                                                                  
           when D.codtam01 = 40 then  c.tarifa40_S end)              
                                                                                                                                                                                            
           when c.flagCirViaje = 0 then              
                                                                                                                                                                                                            
     (case when D.codtam01 = 20 then  c.tarifa20_S                  
                                                                                                                                                                                             
           when D.codtam01 = 40 then  c.tarifa40_S end)              
                                                                                                                                                                                            
           end as tarifa_S                   
                                                                                                                                                                                                                    
from DCGUITTR01 as A (nolock) inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito              
                                                                                                                                                            
inner join CQTARCIR01 AS C (nolock)  ON c.idcircuito = b.idcircuito--a.idtarifa = c.idtarifa              
                                                                                                                                                       
inner join DDGUITTR01 AS d (nolock)  on A.nrogui01 = d.NroGui01                   
                                                                                                                                                                               
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f              
                                                                                                                                                                                  
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS              
                                                                                                                    
left join TERMINAL.DBO.DDCABMAN11 AS E on a.navvia11 = e.navvia11              
                                                                            
where A.nrodet01 is null       
                                                                                                                                                                                                                                  
and A.client01 = @client01       
                                                                                                                                                                                                                                
and a.idcircuito = @idcircuito  
                                                                                                                                                                                                                                 
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)      
                                                                                                                                                                                           
and convert(datetime, @fecfin + ' ' + @horaFin)     
                                                                                                                                                                                                             
and c.fecreg = (select max(fecreg) from cqtarcir01 where idcircuito = @idcircuito )           
                                                                                                                                                                   
order by               
                                                                                                                                                                                                                                          
A.codnav08,              
                                                                                                                                                                                                                                        
A.navvia11,      
                                                                                                                                                                                                                                                
d.codcon01     
                                                                                                                                                                                                                                                  
  
                                                                                                                                                                                                                                                               
/**  
                                                                                                                                                                                                                                                            
from DCGUITTR01 as A (nolock) inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito              
                                                                                                                                                            
inner join CQTARCIR01 AS C (nolock)  ON a.idtarifa = c.idtarifa              
                                                                                                                                                                                    
inner join DDGUITTR01 AS d (nolock)  on A.nrogui01 = d.NroGui01                   
                                                                                                                                                                               
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as f      
                                                                                                                                                                                  
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = f.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS              
                                                                                                                    
left join TERMINAL.DBO.DDCABMAN11 AS E on a.navvia11 = e.navvia11              
                                                                                                                                                                                  
where A.nrodet01 is null       
                                                                                                                                                                                                                                  
and A.client01 = @client01       
                                                                                                                                                                                                                                
and a.idcircuito = @idcircuito              
                                                                                                                                                                                                                     
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)      
                                                                                                                                                                                           
and convert(datetime, @fecfin + ' ' + @horaFin)      
                                                                                                                                                                                                            
order by               
                                                                                                                                                                                                                                          
A.codnav08,              
                                                                                                                                                                                                                                        
A.navvia11,      
                                                                                                                                                                                                                                                
d.codcon01    
                                                                                                                                                                                                                                                   
  
                                                                                                                                                                                                                                                              
 
*/  
                                                                                                                                                                                                                                                             
     
                                                                                                                                                                                                                                                            
return 0  
                                      
----                                                                                                                                                                                                                                                           
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByRucCircuitoMan]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Listar_GuiaByRucCircuitoMan]                    
@client01 char(11),                        
@idcircuito int,                    
@fecini char(8),                    
@fecfin char(8),                
@horaIni char(8),                
@horaFin char(8),                    
@Usuario varchar(30)
as                              
/*
set @client01 = '20100010217'               
set @idcircuito = '127'                  
set @fecini = '20080901'                  
set @fecfin = '20080930'           
set @horaIni = '00:00:00'
set @horaFin = '00:00:00'

*/


select nrogui01 , 
nropla01 ,            
brevet01 ,            
fecgen01 ,            
codnav08 ,            
navvia11 ,            
desrut01 , 
codrut01 ,                     
codtam01 ,    
Count (nrogui01) as cantidad,
  

case when flagvicon = 'S' then precioCir                    
     when flagvicon = 'N' and codtam01 = '40' then precioCir                    
     when flagvicon = 'N' and Count (nrogui01)= 0 then precioCir                     
     when flagvicon = 'N' and Count (nrogui01)> 0 then precioCir * Count (nrogui01)                    
     end as tarifa,                       
        
numvia11 ,            
centroCosto , 
dc_tipo_identificacion_bien ,            
codcco06 ,             
codcon01 
from ListaCircuitoManual
where Usuario = @Usuario 
group by           
nrogui01,                        
Nropla01,                      
Brevet01,                      
fecgen01,          
codnav08,                    
navvia11,                     
desrut01,                     
codrut01,                     
flagvicon,          
numvia11,                    
centroCosto,             
dc_tipo_identificacion_bien,                    
codcco06,                
codcon01,          
codtam01,          
precioCir              
order by                     
fecgen01                    

return 0   
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiaByRucCircuitoViaje]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[sp_Listar_GuiaByRucCircuitoViaje]                
                                                                                                                                                                                                
@client01 char(11),                    
                                                                                                                                                                                                                          
@idcircuito int,                
                                                                                                                                                                                                                                 
@fecini char(8),                
                                                                                                                                                                                                                                 
@fecfin char(8),                
                                                                                                                                                                                                                                 
@horaIni char(8),      
                                                                                                                                                                                                                                          
@horaFin char(8)      
                                                                                                                                                                                                                                           
as                   
                                                                                                                                                                                                                                            
if @idcircuito=130  
                                                                                                                                                                                                                                             
begin  
                                                                                                                                                                                                                                                          
select                 
                                                                                                                                                                                                                                          
A.nrogui01,                    
                                                                                                                                                                                                                                  
A.Nropla01,                  
                                                                                                                                                                                                                                    
A.Brevet01,                  
                                                                                                                                                                                                                                    
convert(varchar(10), A.fecgen01, 103) as fecgen01,                 
                                                                                                                                                                                              
A.codnav08,                
                                                                                                                  
A.navvia11,                 
                                                                                                                                                                                                                                     
B.desrut01,                 
                                                                                                                                                                                                                                     
B.codrut01,   
                                                                                                                                                                                                                                                   
'' as codtam01,             
                                                                                                                                                                                                                                     
1 as cantidad,       
                                                                                                                                                                                                                                            
c.tarifa20 as tarifa,                    
                                                                                                                                                                                                                        
D.numvia11,                
                                                                                                                                                                                                                                      
e.dc_centro_costo as centroCosto,                
                                                                                                                                                                                                                
--dbo.fn_CantContxViajeTam (A.nrogui01) as codtam01,                              
                                                                                                                                                                               
--count(g.nrogui01) as cantidad,            
                                                                                                                                                                                                                     
--g.codtam01,            
                                                                                                                                                                                                                                        
e.dc_tipo_identificacion_bien,                
                                                                                                                                                                                                                   
a.codcco06,      
                                                                                                                                                                                                                                                
g.codcon01  
                                                                                                                                                                                                                                                     
from DCGUITTR01 as A inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito                
                                                                                                                                                                   
inner join CQTARCIR01 AS C ON a.idtarifa = c.idtarifa                
                                                                                                                                                                                            
left join  TERMINAL.DBO.DDCABMAN11 AS D on a.navvia11 = d.navvia11                
                                                                                                                                                                               
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as e                
                                                                                                                                                                                
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = e.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                
                                                                                                                  
--left join DDGUITTR01 as g on A.nrogui01 = g.nrogui01            
                                                                                                                                                                                               
inner join DDGUITTR01 as G (nolock) on (A.nrogui01=g.nrogui01)  
                                                                                                                                                                                                 
where A.nrodet01 is null                
                                                                                                                                                                                                                         
and A.client01 = @client01                    
                                                                                                                                                                                                                   
and A.idcircuito = @idcircuito                
                                                                                                                                                                                                                   
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)      
                                                                                                                                                                                           
and convert(datetime, @fecfin + ' ' + @horaFin)     --@fecini and @fecfin                
                                                                                                                                                                        
order by A.codnav08, A.navvia11          
                                                                                                                                                                                                                        
end  
                                                                                                                                                                                                                                                            
  
                                                                                                                                                                                                                                                               
if @idcircuito<>130  
                                                                                                                                                                                                                                            
begin  
                                                                            
select                 
                                                                                                                                                                                                                                          
A.nrogui01,                    
                                                                                                                                                                                                                                  
A.Nropla01,                  
                                                                                                                                                                                                                                    
A.Brevet01,                  
                                                                                                                                                                                                                                    
convert(varchar(10), A.fecgen01, 103) as fecgen01,                 
                                                                                                                                                                                              
A.codnav08,                
                                                                                                                                                                                                                                      
A.navvia11,                 
                                                                                                                                                                                                                                     
B.desrut01,                 
                                                                                                                                                                                                                                     
B.codrut01,   
                                                                                                                                                                                                                                                   
'' as codtam01,             
                                                                                                                                                                                                                                     
1 as cantidad,       
                                                                                                                                                                                                                                            
c.tarifa20 as tarifa,                    
                                                                                                                                                                                                                        
D.numvia11,                
                                                                                                                                                                                                                                      
e.dc_centro_costo as centroCosto,                
                                                                                                                                                                                                                
--dbo.fn_CantContxViajeTam (A.nrogui01) as codtam01,                              
                                                                                                                                                                               
--count(g.nrogui01) as cantidad,            
                                                                                                                                                                                            
--g.codtam01,            
                                                                                                                                                                                                                                        
e.dc_tipo_identificacion_bien,                
                                                                                                                                                                                                                   
a.codcco06,      
                                                                                                                                                                                                                                                
'' as codcon01  
                                                                                                                                                                                                                                                 
from DCGUITTR01 as A inner join CQCIRCUI01 as B on A.idcircuito = B.idcircuito                
                                                                                                                                                                   
inner join CQTARCIR01 AS C ON a.idtarifa = c.idtarifa                
                                                                                                                                                                                            
left join  TERMINAL.DBO.DDCABMAN11 AS D on a.navvia11 = d.navvia11                
                                                                                                                                                                               
inner join NPT9_bd_trit.dbo.tb_tipo_identificacion_bien as e                
                                                                                                                                                                                
on substring(a.nropla01,1,2)+'-'+substring(a.nropla01,3,4) = e.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS                
                                                                                                                  
--left join DDGUITTR01 as g on A.nrogui01 = g.nrogui01            
                                                                                                                                                                                               
where A.nrodet01 is null                
                                                                                                                                                                                                                         
and A.client01 = @client01                    
                                                                                                                                                                                                                   
and A.idcircuito = @idcircuito                
                                                                                                                                                                                                                   
and fecgen01 between convert(datetime, @fecini + ' ' + @horaIni)      
                                                                                                                                                                                           
and convert(datetime, @fecfin + ' ' + @horaFin)     --@fecini and @fecfin                
                                      
order by A.codnav08, A.navvia11          
                                                                                                                                                                                                                        
end  
                                                                                                                                                                                                                                                            
  
                                                                                                                                                                                                                                                               
return 0              
                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                               
  
                                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_GuiasNOFacturadas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_GuiasNOFacturadas]  
as  
select distinct a.nrogui01, a.fecgen01, a.fecreg01, a.client01,   
d.razonsoc, a.nropla01, a.brevet01,   
apellido + ', ' + Nombre as Chofer,  
a.descircu,   
b.desrut01,   
isnull(case when automa01 = 1 then   
                (case when comisionxviaje = 'S' then c.tarifa20  
                      when comisionxviaje = 'N' then   
                               (case when c.flagCirViaje = 1 then                
                                               (case when f.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20                    
                                     when f.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40                    
                                     when f.codtam01 = 40 then  c.tarifa40 end)                
                                     when c.flagCirViaje = 0 then                
                                               (case when f.codtam01 = 20 then  c.tarifa20                    
                                             when f.codtam01 = 40 then  c.tarifa40 end)           
                end)  
                end)  
     when automa01 = 0 then  
                (case when a.flagvicon = 'S' then precioCir            
                      when a.flagvicon = 'N' and dbo.fn_CantContxViaje(A.nrogui01)= 0 then precioCir             
                      when a.flagvicon = 'N' and dbo.fn_CantContxViaje(A.nrogui01)> 0 then precioCir * dbo.fn_CantContxViaje(A.nrogui01)            
                      end)  
  
end, 0) as Total,
isnull(case when automa01 = 1 then   
                (case when comisionxviaje = 'S' then c.tarifa20_S  
                      when comisionxviaje = 'N' then   
                               (case when c.flagCirViaje = 1 then                
                                               (case when f.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 2  then  c.tarifa20_S                    
                                     when f.codtam01 = 20 and dbo.fn_CantContxViaje(A.nrogui01) = 1  then  c.tarifa40_S                    
                                     when f.codtam01 = 40 then  c.tarifa40_S end)                
                                     when c.flagCirViaje = 0 then                
                                               (case when f.codtam01 = 20 then  c.tarifa20_S                    
                                             when f.codtam01 = 40 then  c.tarifa40_S end)           
                end)  
                end)  
     when automa01 = 0 then  
                (case when a.flagvicon = 'S' then precioCir_S            
                      when a.flagvicon = 'N' and dbo.fn_CantContxViaje(A.nrogui01)= 0 then precioCir_S             
                      when a.flagvicon = 'N' and dbo.fn_CantContxViaje(A.nrogui01)> 0 then precioCir_S * dbo.fn_CantContxViaje(A.nrogui01)            
                      end)  
end, 0) as Total_S  
from DCGUITTR01 as a   
inner join TQCLIENTE as d on a.client01 = d.rucclien  
inner join dbo.CQCIRCUI01 as b on a.idcircuito = b.idcircuito   
inner join dbo.TQCHOFER as e on a.brevet01 = e.brevete  
left join dbo.CQTARCIR01 as c on a.idtarifa = c.idtarifa  
left join DDGUITTR01 AS f on A.nrogui01 = f.NroGui01    
where convert(char(8), fecreg01, 112) between  dateadd(d,-65, getdate()) and dateadd(d,-3, getdate()) and nrodet01 is null  
order by a.nrogui01  



GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_itemgastosUltragstion]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[sp_Listar_itemgastosUltragstion]
                                                                                                                                                                                                             
@Periodo char(6)
                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
select dc_periodo, 
                                                                                                                                                                                                                                          
dc_tipo_identificacion_bien, 
                                                                                                                                                                                                                                
dg_item_gasto, 
                                                                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor,
                                                                                                                                                                                                                                             
dc_sucursal_imputacion, 
                                                                                                                                                                                                                                     
dc_centro_costo_imputacion, 
                                                                                                                                                                                                                                 
dg_razon_social, dg_centro_Costo, 
                                                                                                                                                                                                                           
dg_sucursal
                                                                                                                                                                                                                                                  
from NPT9_bd_trit.dbo.tb_mov_aux_MANT as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_MAN1 as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_proveedor = c.dc_rut
                                                                                                                                                                            
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                  
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                    
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_comb as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                    
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_MARE as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_acreedor = c.dc_rut
                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_acreedor, dc_sucursal_imputacion, 
                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
--order by dc_periodo
                                                                                                                                                                                                                                        
union
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
select dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, 
                                                                                                                                                                                              
sum (case when dm_debe_haber = 'H' then dq_monto_moneda_base * -1
                                                                                                                                                                                            
else dq_monto_moneda_base end) as monto, 
                                                                                                                                                                                                                    
dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                                                                                   
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
from NPT9_bd_trit.dbo.tb_mov_aux_SERT as a 
                                                                                                                                                                                                             
inner join NPT9_bd_trit.dbo.tb_item_gasto as b on a.dc_item_gasto = b.dc_item_gasto
                                                                                                                                                                     
inner join NPT9_bd_trit.dbo.tb_persona as c on a.dc_rut_proveedor = c.dc_rut
                                                                                                                                                                            
inner join NPT9_bd_trit.dbo.tb_centro_costo as d on a.dc_centro_costo_imputacion = d.dc_centro_costo
                                                                                                                                                    
inner join NPT9_bd_inst.dbo.tb_sucursal_INST as e on a.dc_sucursal_imputacion = e.dc_sucursal
                                                                                                                                                           
where dc_tipo_identificacion_bien <> '0'
                                                                                                                                                                                                                     
and dc_periodo = @Periodo and dm_estado_cdc = 'A'
                                                                                                                                                                                                            
group by dc_periodo, dc_tipo_identificacion_bien, dg_item_gasto, dc_rut_proveedor, dc_sucursal_imputacion, 
                                                                                                                                                  
dc_centro_costo_imputacion, dg_razon_social, dg_centro_Costo, dg_sucursal
                                                                                                                                                                                    
order by dc_periodo
                                                                                                                                                                                                                                          
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Llantas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Llantas]  
as  
select   
A.Codigo,  
A.idMedida,  
A.idMarca,  
A.idDisenio,  
A.Cocada_mm,  
A.N_R,  
A.FechaIngreso,  
A.idLlanta,  
B.DESCRIPCION AS MARCA,
C.DESCRIPCION AS MEDIDA,
D.DESCRIPCION AS DISENIO
from CDLLANTA as a inner join TQMARCA AS B ON B.IDMARCA = A.IDMARCA
INNER JOIN TQMEDIDA AS C ON A.IDMEDIDA = C.IDMEDIDA 
INNER JOIN TQDISENIOLLANTA AS D ON A.IDDISENIO = D.IDDISENIO
return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_listar_llantas_asignadas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_listar_llantas_asignadas]     
@idPlaca int      
as      
select       
a.id_camionllanta,      
a.IdPlaAut,      
a.id_Motivo,    
a.id_llanta,      
convert (varchar(10), a.FechaAsigna, 103) as FechaAsigna,     
a.Horometro,      
a.OdoExterno,      
a.OdoInterno,      
a.Posicion,      
b.codigo,       
c.descripcion,      
d.nropla81,  
a.Estado,
a.Id_llanta_sal,    
e.codigo as Codigosal       
from tqllanta as a inner join  cdllanta as b on     
a.id_llanta = b.idllanta  inner join  tqmovcam  as c on     
a.id_Motivo = c.idMotivo inner join tqplaaut d   on    
a.Idplaaut = d.idplaaut  inner join  cdllanta as e on     
a.id_llanta_sal = e.idllanta     
where       
a.Idplaaut = @idPlaca  and a.estado = 1    

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Llantas_disponibles]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Llantas_disponibles]    
@Disponible as int
as    
select  
A.Codigo,    
A.idMedida,    
A.idMarca,    
A.idDisenio,    
A.Cocada_mm,    
A.N_R,    
A.FechaIngreso,    
A.idLlanta,    
B.DESCRIPCION AS MARCA,  
C.DESCRIPCION AS MEDIDA,  
D.DESCRIPCION AS DISENIO  
from CDLLANTA as A inner join TQMARCA AS B ON B.IDMARCA = A.IDMARCA  
INNER JOIN TQMEDIDA AS C ON A.IDMEDIDA = C.IDMEDIDA   
INNER JOIN TQDISENIOLLANTA AS D ON A.IDDISENIO = D.IDDISENIO  
where a.disponible = @Disponible    
return 0    
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Llantas_disponiblesbyIdLlanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_Listar_Llantas_disponiblesbyIdLlanta] --FMCR
--@Idllanta int  
--as  
--select   
--idLlanta,  
--Codigo,  
--Medida,  
--Marca,  
--Diseno,  
--Cocada_mm,  
--N_R,  
--FechaIngreso  
--from CDLLANTA where idllanta = @IdLlanta
--return 0  

--GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Marca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Marca]
as
select idMarca, descripcion from TQMARCA
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Medida]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Medida]
as
select IdMedida, descripcion from TQMEDIDA
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Menu]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Listar_Menu]  
as  
select   
IdMenu,  
CodMenu,  
Descripcion  
from  TQMENU   
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Motivos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_Motivos]
as
select 
idMotivo,
Descripcion
from tqmovcam 
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_OrdenesServcio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_OrdenesServcio]
@NroOrden as integer
as
select 
FechaIni,
HoraIni,
IdChofer,
IdPlacaAut,
Carreta,
IdTipoServ,
IdEmpresaServ,
Contacto,
HorometroIni,
OdometroIni,
Estado,
FechaFin,
HoraFin,
HorometroFin,
OdometroFin,
ObservacioIni,
ObservacionFin,
FechaReg,
UsuarioReg,
FechaMod,
UsuarioMod
from DCSERVICIOS
where NroServicio = @NroOrden

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Permisosxusuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[sp_Listar_Permisosxusuario]    
@IdUsuario int     
as    
select a.idPermisos, a.IdMenu, b.codmenu    
from  TQPERMISOS  as a inner join TQMENU as b  
on a.idmenu = b.idmenu  
where a.idusuario = @idusuario  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_PlacaAutorizada_ByCliente]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_PlacaAutorizada_ByCliente]          
@codage19 char(11)          
as       
 --rdelacuba 06/10/2006: Se incluye join con la configuración vehicular    
 SELECT a.idPlaAut, a.codage19, a.nropla81,         
 a.esactivo, b.razonsoc ,a.UodoTablero, a.UodoExterno,     
 a.Nombre, a.valorprom, marca, certificado, c.idconf, c.descripcion,d.dc_centro_costo    
 FROM TQPLAAUT as a inner join  TQCLIENTE as b ON a.codage19 = b.rucclien          
 LEFT OUTER JOIN TQCONFVEHIC as c ON a.idconf = c.idconf    
 LEFT JOIN NPT9_bd_trit.DBO.tb_tipo_identificacion_bien d  
 on ( substring(a.nropla81,1,2)+'-'+substring(a.nropla81,3,4) = d.dc_tipo_identificacion_bien COLLATE SQL_Latin1_General_CP1_CI_AS        
   or substring(a.nropla81,1,3)+'-'+substring(a.nropla81,4,4) = d.dc_tipo_identificacion_bien  COLLATE SQL_Latin1_General_CP1_CI_AS )   
 WHERE codage19 = @codage19      
 ORDER BY a.codage19,a.nropla81 ASC       
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_PlacaAutorizada_ByClienteCarreta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_PlacaAutorizada_ByClienteCarreta]      
@codage19 char(11),     
@Flag char(1)     
as      
select a.idPlaAut, a.nropla81, a.Nombre    
from TQPLAAUT as a     
where a.codage19 = @codage19 and a.Carreta = @flag    
order by  a.Nombre  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_PrecioCombustible_ByForPagComb]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_PrecioCombustible_ByForPagComb]
@idcombus int,
@idforpag char(1)
as
select idprecio, idcombus, idforpag, precioco, Fechaing
from  TQPRECOMB
where idcombus = @idcombus and idforpag = @idforpag 
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_PrecioCombustible_ByForPagComb_Ultimo]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_PrecioCombustible_ByForPagComb_Ultimo]
@idcombus int,
@idforpag char(1)
as
select idprecio, idcombus, idforpag, precioco, Fechaing
from  TQPRECOMB
where idprecio = (select max(idprecio)from TQPRECOMB
where  fechaing = (select max(fechaing) from TQPRECOMB
where idcombus = @idcombus and idforpag = @idforpag ) and idcombus = @idcombus and idforpag = @idforpag )
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_Tarifa]      
@Circuito int     
as 

--rdelacuba 04/10/2006: Se agregó campo valRef    
select       
a.Idtarifa,      
a.idcircuito,    
b.codrut01,      
a.flgigv01,      
a.comision20,      
a.comision40,      
a.tarifa20,      
a.tarifa40,      
a.comisionxviaje,      
a.Usuario,      
b.desrut01,  
b.automa01,
a.flagcirviaje,
a.valRef,
a.tarifa20_S,
a.tarifa40_S  
from cqtarcir01 as a inner join CQCIRCUI01 as b on a.idcircuito = b.idcircuito  
where a.idcircuito = @Circuito and       
a.fecreg = (select max(fecreg) from cqtarcir01 where idcircuito = @Circuito)
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_Tickets]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_Tickets]          
@flagesta char(1),          
@codage19 char(11)          
as          
select a.idtikets,          
convert(varchar(10),a.fechvale,103) as fechvale,      
convert(varchar(10),a.horavale,108) as horavale,      
a.idplaaut,          
a.idprecio,          
a.cantidad,          
a.tipocamb,          
a.nrofactu,          
a.fecfactu,          
a.nrovalet,          
a.flagesta,    
a.PUnitario,          
b.codage19,          
b.nropla81,          
a.idcombuS,          
--C.idforpag,          
--C.precioco,          
a.punitario,    
round(a.cantidad * a.punitario, 2) as total,          
d.descombu,          
d.cod_ultra,          
--a.fechvale,  
--a.horavale,  
a.OActual,  
a.OAnterior,  
a.OActualTablero,  
a.OAnteriorTablero,  
a.HActual,  
a.HAnterior,  
a.IdValeAut  
           
from TQTIKETS as a inner join TQPLAAUT AS b          
ON a.idplaaut = b.idplaaut     
--inner join TQPRECOMB AS C ON a.idprecio = C.idprecio     
inner join TQCOMBUS AS D ON a.idcombuS = D.idcombuS         
where flagesta = @flagesta and codage19 = @codage19          
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_TicketsFact]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_TicketsFact]            
@flagesta char(1),            
@codage19 char(11)            
as            
select a.idtikets,            
convert(varchar(10),a.fechvale,103) as fechvale,        
convert(varchar(10),a.horavale,108) as horavale,        
a.idplaaut,            
a.idprecio,            
a.cantidad,            
a.tipocamb,            
a.nrofactu,            
a.fecfactu,            
a.nrovalet,            
a.flagesta,            
a.PUnitario,  
b.codage19,            
b.nropla81,            
a.idcombuS,            
--C.idforpag,            
--C.precioco,            
round(a.cantidad * a.punitario, 2) as total,            
d.descombu,            
d.cod_ultra,    
d.cod_tipo_comb    
             
from TQTIKETS as a inner join TQPLAAUT AS b            
ON a.idplaaut = b.idplaaut   
--inner join TQPRECOMB AS C ON a.idprecio = C.idprecio   
inner join TQCOMBUS AS D ON a.idcombuS = D.idcombuS           
where   
--(C.idforpag = 'R' or C.idforpag = 'M') and           
flagesta = @flagesta and codage19 = @codage19            
--order by fechvale  , horavale  , nropla81
order by nropla81 ,fechvale , horavale
return 0           
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_TicketsxFact]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_TicketsxFact]  

@nrofac01 char(10),   

@tipdoc01 char (2)

as  

select a.idtikets,            

convert(varchar(10),a.fechvale,103) as fechvale,        

convert(varchar(10),a.horavale,108) as horavale,        

a.idplaaut,            

c.nropla81,            

round(a.cantidad * a.punitario, 2) as total,  

d.descombu,a.nrovalet   

from TQTIKETS as a   

inner join DDFACTTR01 as b on a.nrofactu = b.nrodet01  

inner join TQPLAAUT AS c ON a.idplaaut = c.idplaaut    

inner join TQCOMBUS AS D ON a.idcombuS = D.idcombuS    

where nrofac01 = @nrofac01 and tipdoc01 = @tipdoc01

return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_listar_TipoCombustible]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_listar_TipoCombustible]
as
select idcombus,descombu 
from TQCOMBUS
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_TipoEvento]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Listar_TipoEvento]
as
select 
idTipoEvent,
DescripcionEvent
from TQTIPOEVENTO
Where idTipoEvent > 2 
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_TipoServbyUd]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_TipoServbyUd]  
@tipser01 char(1),  
@tipser02 char(1)  
as    
select tipser01, descri01,cod_ultra from tqtipser01    
where tipser01 <> @tipser01 and tipser01 <> @tipser02
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_TipoServicios]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_TipoServicios]  
as  
select  
a.idtiposerv,   
a.NombServ,  
a.IdUnitControl,  
a.Cantidad,  
a.UsuarioReg,  
a.FechaReg,  
b.descripcioncontrol,
a.Control  
from tqservicio as a inner join tqunitcont as b  
on b.idunidadcontrol = a.idunitcontrol  
  


GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_UnidadControl]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_UnidadControl]  
as  
select idUnidadControl, DescripcionControl, UniConver, 
valorConver from tqunitcont  
return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_usuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_Listar_usuario]    
@estado char(1)    
as    
select    
idUsuario,   
Nombre,    
Apellidos,    
Login,    
Pass,  
usuTrans,
usuCombs 
from TQUSUARIO
where estado <> @estado    
return 0    
GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_ValeAut]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_ValeAut]
as
select 
a.IdVale,
a.IdPlaAut,
a.FlagExtra,
a.Fecha ,
a.TableroAnt,
a.TableroAct,
a.ExternoAnt,
a.ExternoAct,
a.HoroAnt,
a.HoroAct,
a.Cantidad,
a.Rendimiento,
a.Usuario,
a.FechaReg,
b.nropla81,
b.Nombre
from TQVALESAUT as a inner join TQPLAAUT as b
on a.idplaaut = b.idplaaut
where IdVale not in (select IdValeaut FROM TQTIKETS WHERE IDVALEAUT IS NOT NULL)
return 0


GO
/****** Object:  StoredProcedure [dbo].[sp_Listar_VarGenerica]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Listar_VarGenerica]  
as  
select HoraIni, HoraFin, FlagManual, convert(char(8), getdate(), 108) as  horaActual, 
DATEDIFF(hh,fecchamod, getdate()) as DifHoras
From TQVARGENERICA  
return   
GO
/****** Object:  StoredProcedure [dbo].[SP_ListarCircuitoByFechas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ListarCircuitoByFechas]          
@FECHA_INI CHAR(8),          
@FECHA_FIN CHAR(8),  
@idCircuito int,          
@flag char(1)  
AS           
  
if @idcircuito = 0 and @flag = 'G'  
begin          
SELECT DISTINCT C.DESNAV08, A.NUMVIA11,           
B.BREVET01,           
B.DESCIRCU AS DESRUT01,           
E.NROGUI01, E.codtam01, B.COMISION AS COMISION40, B.PRECIOCIR, b.PrecioCir_S,                  
B.FLAGVICON AS  COMISIONXVIAJE, B.FECREG01, B.NROPLA01, B.FECGEN01,          
E.CODCON01,          
H.NOMBRE,        
'' as codrut01      
FROM DCGUITTR01 AS B inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as C on b.codnav08 = c.codnav08          
LEFT join tqplaaut as H  ON  B.NROPLA01 = H.NROPLA81        
where B.descircu is not null AND     
convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               

UNION          
SELECT  h.DESNAV08, A.NUMVIA11,  B.BREVET01,           
--D.NOMBRE30,           
C.DESRUT01,           
E.NROGUI01, E.codtam01, I.COMISION40,           
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20           
WHEN E.codtam01 = '40' THEN I.TARIFA40 END AS PRECIOCIR,  
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20_S           
WHEN E.codtam01 = '40' THEN I.TARIFA40_S END AS PrecioCir_S,         
I.COMISIONXVIAJE,           
B.FECREG01, B.NROPLA01, B.FECGEN01 , E.CODCON01,          
J.NOMBRE,    
C.codrut01          
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I         
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA        
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito         
inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as h on b.codnav08 = h.codnav08          
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81        
where B.descircu is null and    
convert(varchar(8), B.FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
order by B.FECGEN01
end  
  
if @idcircuito = 0 and @flag = 'R'  
begin          
SELECT DISTINCT C.DESNAV08, A.NUMVIA11,           
B.BREVET01,           
--D.NOMBRE30,           
B.DESCIRCU AS DESRUT01,           
E.NROGUI01, E.codtam01, B.COMISION AS COMISION40, B.PRECIOCIR,  b.PrecioCir_S,        
B.FLAGVICON AS  COMISIONXVIAJE, B.FECREG01, B.NROPLA01, B.FECGEN01,          
E.CODCON01,          
H.NOMBRE,        
'' as codrut01      
FROM DCGUITTR01 AS B inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as C on b.codnav08 = c.codnav08          
LEFT join tqplaaut as H  ON  B.NROPLA01 = H.NROPLA81        
where B.descircu is not null AND     
convert(varchar(8), B.FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               

UNION          
SELECT  h.DESNAV08, A.NUMVIA11,  B.BREVET01,           
--D.NOMBRE30,           
C.DESRUT01,           
E.NROGUI01, E.codtam01, I.COMISION40,           
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20           
WHEN E.codtam01 = '40' THEN I.TARIFA40 END AS PRECIOCIR, 
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20_S           
WHEN E.codtam01 = '40' THEN I.TARIFA40_S END AS PrecioCir_S,          
I.COMISIONXVIAJE,           
B.FECREG01, B.NROPLA01, B.FECGEN01 , E.CODCON01,          
J.NOMBRE,    
C.codrut01          
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I         
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA        
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito         
inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as h on b.codnav08 = h.codnav08          
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81        
where B.descircu is null and    
convert(varchar(8), B.FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
order by B.FECREG01
end  
  
if @idcircuito > 0 and @flag = 'R'  
begin          
  
SELECT  h.DESNAV08, A.NUMVIA11,  B.BREVET01,           
--D.NOMBRE30,           
C.DESRUT01,           
E.NROGUI01, E.codtam01, I.COMISION40,           
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20           
WHEN E.codtam01 = '40' THEN I.TARIFA40 END AS PRECIOCIR, 
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20_S           
WHEN E.codtam01 = '40' THEN I.TARIFA40_S END AS PrecioCir_S,          
I.COMISIONXVIAJE,           
B.FECREG01, B.NROPLA01, B.FECGEN01 , E.CODCON01,          
J.NOMBRE,    
C.codrut01          
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I         
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA        
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito         
inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as h on b.codnav08 = h.codnav08          
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81        
where B.descircu is null and    
convert(varchar(8), B.FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
and B.idcircuito = @idcircuito 
order by B.FECREG01 
end  
  
if @idcircuito > 0 and @flag = 'G'  
begin          
SELECT  h.DESNAV08, A.NUMVIA11,  B.BREVET01,           
--D.NOMBRE30,           
C.DESRUT01,           
E.NROGUI01, E.codtam01, I.COMISION40,           
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20           
WHEN E.codtam01 = '40' THEN I.TARIFA40 END AS PRECIOCIR, 
CASE          
WHEN E.codtam01 = '20' THEN I.TARIFA20_S           
WHEN E.codtam01 = '40' THEN I.TARIFA40_S END AS PrecioCir_S,           
I.COMISIONXVIAJE,           
B.FECREG01, B.NROPLA01, B.FECGEN01 , E.CODCON01,          
J.NOMBRE,    
C.codrut01          
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I         
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA        
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito         
inner join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01          
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01           
LEFT join TERMINAL..DDCABMAN11 as A on A.navvia11 = b.navvia11           
LEFT join TERMINAL..dqnavier08 as h on b.codnav08 = h.codnav08          
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81        
where B.descircu is null and    
convert(varchar(8), B.FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
and B.idcircuito = @idcircuito  
order by B.FECGEN01
end  
RETURN 0           



GO
/****** Object:  StoredProcedure [dbo].[sp_ListarEventosxAll]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListarEventosxAll]  
@FechaIni varchar(10),  
@FechaFin Varchar(10)  
as  
select   
a.idEvento,  
a.idTipoEvent,  
a.IdChofer,  
a.idPlacaAut,  
a.Descripcion,  
convert (varchar(10), a.Fecha, 103) as Fecha,  
convert (varchar(10), a.Hora, 108) as Hora,  
a.IdServicio,  
a.Idtikets,  
a.EstadoServicio,  
d.descripcionevent,  
c.nropla81,  
b.brevete,  
b.Nombre + ' ' + b.Apellido AS Nombre,  
c.Nombre as Alias
from dceventos as a inner join tqtipoEvento as d on a.idtipoevent = d.Idtipoevent  
inner join tqchofer as b on a.IdChofer = b.IdChofer  
inner join tqplaaut as c on a.IdPlacaAut = c.idplaaut   
where Fecha between @FechaIni and @FechaFin  

GO
/****** Object:  StoredProcedure [dbo].[sp_ListarEventosxIdPlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListarEventosxIdPlaca]  
@IdPlacaaut int,  
@FechaIni varchar(10),  
@FechaFin Varchar(10)  
as  
select   
a.idEvento,  
a.idTipoEvent,  
a.IdChofer,  
a.idPlacaAut,  
a.Descripcion,  
convert (varchar(10), a.Fecha, 103) as Fecha,  
convert (varchar(10), a.Hora, 108) as Hora,  
a.IdServicio,  
a.Idtikets,  
a.EstadoServicio,  
d.descripcionevent,  
c.nropla81,  
b.brevete,  
b.Nombre + ' ' + b.Apellido AS Nombre,
c.Nombre as Alias  
from dceventos as a inner join tqtipoEvento as d on a.idtipoevent = d.Idtipoevent  
inner join tqchofer as b on a.IdChofer = b.IdChofer  
inner join tqplaaut as c on a.IdPlacaAut = c.idplaaut   
where a.Idplacaaut = @IdPlacaaut  and  
Fecha between @FechaIni and @FechaFin  

GO
/****** Object:  StoredProcedure [dbo].[SP_ListarFacturasByFechas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ListarFacturasByFechas]
@FECHA_INI CHAR(8),
@FECHA_FIN CHAR(8)
AS 
select  
a.nrofac01, 
b.cantid01,
b.preuni01,
b.desart01,
c.nrogui01, 
c.brevet01,
e.cantidad
from DCFACTTR01 as a inner join DDFACTTR01 as b
on a.nrofac01 = b.nrofac01 and a.tipdoc01 = b.tipdoc01 and a.idconta01 = b.idconta01
inner join DCGUITTR01 as c on b.nrodet01 = c.nrodet01 
left join TQPLAAUT as d on c.nropla01 = d.nropla81 
inner join TQTIKETS as e on e.idplaaut = d.idplaaut
where a.fecemi01 between @FECHA_INI and @FECHA_FIN and e.fechvale between @FECHA_INI and @FECHA_FIN


GO
/****** Object:  StoredProcedure [dbo].[sp_ListarFic]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER        procedure [dbo].[sp_ListarFic]  
--Creado Renzo Tello

@TipoRuc char(1),    

@Moneda char(1),    

@Detraccion char(1),    

@Porcentaje int,    

@TipoDoc varchar(3),    

@ServInt varchar(1), 

@MOnto decimal (15,2) 

as    


select Fic from dbo.DQFICFACTURAS    

where TipoRuc =  @TipoRuc and    

Moneda = @Moneda and    

Detraccion = @Detraccion and    

Porcentaje = @Porcentaje and    

TipoDoc = @TipoDoc and   

servint = @ServInt  and montominimo < @MOnto and Montomaximo >= @MOnto 


return 0




GO
/****** Object:  StoredProcedure [dbo].[sp_ListarServiciosxAll]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListarServiciosxAll]  
@FechaIni varchar(10),  
@FechaFin Varchar(10)  
as  
select   
a.NroServicio,  
convert(varchar(10), a.FechaIni, 103) as FechaIni,  
convert(varchar(10), a.HoraIni, 108) as Horaini,  
a.IdChofer,  
a.IdPlacaAut,  
a.Carreta,  
a.IdTipoServ,  
a.IdEmpresaServ,  
a.Contacto,  
a.HorometroIni,  
a.OdometroIni,  
a.Estado,  
convert(varchar(10), a.FechaFin, 103) as FechaFin,  
convert(varchar(10), a.HoraFin, 108) as HoraFin,  
a.HorometroFin,  
a.OdometroFin,  
a.ObservacioIni,  
a.ObservacionFin,  
e.nombserv,  
d.nombre,  
c.nropla81,  
b.brevete,  
b.Nombre + ' ' + b.Apellido AS Nombre,  
c.Nombre as Alias
from DCSERVICIOS as a inner join tqchofer as b on a.IdChofer = b.IdChofer  
inner join tqplaaut as c on a.IdPlacaAut = c.idplaaut   
inner join tqempserv as d on a.IdEmpresaServ = d.idEmpServ  
inner join tqservicio as e on a.IdTipoServ = e.IdTipoServ  
where FechaIni between @FechaIni and @FechaFin  

GO
/****** Object:  StoredProcedure [dbo].[sp_ListarServiciosxPlaca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListarServiciosxPlaca]  
@IdPlacaaut int,  
@FechaIni varchar(10),  
@FechaFin Varchar(10)  
as  
select   
a.NroServicio,  
convert(varchar(10), a.FechaIni, 103) as FechaIni,  
convert(varchar(10), a.HoraIni, 108) as Horaini,  
a.IdChofer,  
a.IdPlacaAut,  
a.Carreta,  
a.IdTipoServ,  
a.IdEmpresaServ,  
a.Contacto,  
a.HorometroIni,  
a.OdometroIni,  
a.Estado,  
convert(varchar(10), a.FechaFin, 103) as FechaFin,  
convert(varchar(10), a.HoraFin, 108) as HoraFin,  
a.HorometroFin,  
a.OdometroFin,  
a.ObservacioIni,  
a.ObservacionFin,  
e.nombserv,  
d.nombre,  
c.nropla81,  
b.brevete,  
b.Nombre + ' ' + b.Apellido AS Nombre,
c.Nombre as Alias
from DCSERVICIOS as a inner join tqchofer as b on a.IdChofer = b.IdChofer  
inner join tqplaaut as c on a.IdPlacaAut = c.idplaaut   
inner join tqempserv as d on a.IdEmpresaServ = d.idEmpServ  
inner join tqservicio as e on a.IdTipoServ = e.IdTipoServ  
where a.Idplacaaut = @IdPlacaaut  and  
FechaIni between @FechaIni and @FechaFin  

GO
/****** Object:  StoredProcedure [dbo].[sp_ListaServicioControl]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListaServicioControl]
as
select idTiposerv from TQSERVICIO
where control = 1

GO
/****** Object:  StoredProcedure [dbo].[sp_ListaServicioEnvioCorreo]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ListaServicioEnvioCorreo]
@Idplacaaut int,
@Idtiposervicio int
as
select Horometrofin, odometrofin, convert(varchar(10), fechafin,103) + ' ' + convert(varchar(10), Horafin, 108)  as Fecha ,
c.Uniconver, c.valorconver, b.cantidad, b.nombserv, a.Idtiposerv, a.idplacaaut
from DCSERVICIOS as a
inner join TQSERVICIO as b on a.idtiposerv = b.idtiposerv 
inner join TQUNITCONT as c on b.idunitcontrol = c.idUnidadcontrol
where a.idplacaaut = @Idplacaaut  and convert(varchar(10), fechafin,103) + ' ' + convert(varchar(10), horafin, 108) = (select  Max(convert(varchar(10), fechafin,103)+ ' ' +convert(varchar(10), horafin, 108)) from DCSERVICIOS where idtiposerv = @Idtiposervicio)
and a.Idtiposerv = @Idtiposervicio

GO
/****** Object:  StoredProcedure [dbo].[sp_Modficar_DetFactura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modficar_DetFactura]  
@nrodet01 int,  
@nrofac01 char(10),  
@tipdoc01 char(2),  
@idconta01 int,  
@cantid01 decimal(12,3),    
@preuni01 decimal(12,3),  
@tipser01 char(1),  
@desart01 varchar(100),  
@coduse01 varchar(50)  
as  
update DDFACTTR01 set  
nrofac01 = @nrofac01,  
tipdoc01 = @tipdoc01,  
idconta01 = @idconta01,  
cantid01 = @cantid01,  
preuni01 = @preuni01,  
tipser01 = @tipser01,  
desart01 = @desart01,  
coduse01 = @coduse01  
  
where  nrodet01 = @nrodet01
GO
/****** Object:  StoredProcedure [dbo].[sp_Modifica_guiaByNroFac]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modifica_guiaByNroFac]
@nrogui01 char(10),
@nrodet01 int
as
update DCGUITTR01 SET
nrodet01 = @nrodet01
where nrogui01 = @nrogui01
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Modifica_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modifica_Tarifa]  
@Idtarifa int,  
--@codrut01 char(3),  
@idcircuito int,
@flgigv01 char(1),  
@comision20 numeric(12,2),  
@comision40 numeric(12,2),  
@tarifa20 numeric(12,2),  
@tarifa40 numeric(12,2),  
@comisionxviaje char(1),  
@flagCirViaje char(1), 
@Usuario varchar(30),
@valRef numeric(12,2)  
as  

--rdelacuba 04/10/2006: Se agregó campo valRef
update cqtarcir01 set  
--codrut01 = @codrut01,  
idcircuito = @idcircuito,
flgigv01 = @flgigv01,  
comision20 = @comision20,  
comision40 = @comision40,  
tarifa20 = @tarifa20,  
tarifa40 = @tarifa40,  
comisionxviaje = @comisionxviaje,  
flagCirViaje = @flagCirViaje, 
valRef = @valRef,
usuario = @Usuario,  
fecreg = getdate()  
where idtarifa = @idtarifa  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modifica_TipoEvento]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modifica_TipoEvento]
@idTipoEvent int,
@DescripcionEvent varchar(50),
@Usuario varchar(30)
as
update tqtipoevento set
DescripcionEvent = @DescripcionEvent,
Usuario = @Usuario,
FechaReg = getdate()
where idTipoEvent = @idTipoEvent 

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_CamionLlanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_CamionLlanta]      
@IdCamionLlanta int,      
@id_Llanta int,      
@id_Motivo int,      
@PlacaUnidad int,      
@FechaAsigna varchar(10),      
@Horometro  Decimal(9,1),      
@OdoExterno Decimal(9,1),      
@OdoInterno Decimal(9,1),      
@Posicion Int,      
@Usuario VarChar(50),    
@Estado int,
@Id_Llanta_Sal int      
as      
update tqllanta set      
id_llanta   = @id_Llanta,      
id_motivo   = @id_Motivo,      
IdPlaaut = @PlacaUnidad,      
FechaAsigna = @FechaAsigna,      
Horometro   = @Horometro,      
OdoExterno  = @OdoExterno,      
OdoInterno  = @OdoInterno,      
Posicion    = @Posicion,      
FechaRegistro = getdate(),      
Usuario     = @Usuario,      
Estado = @Estado,    
Id_Llanta_Sal = @Id_Llanta_Sal
where       
id_camionllanta = @IdCamionLlanta       
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Chofer]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Chofer]  
@IdChofer int,  
@Brevete char(9),  
@dni char(8),        
@Nombre varchar(50),  
@Apellido varchar(70),        
@Direccion varchar(70),        
@TelefCasa varchar(15),       
@TelefCelu varchar(15),        
@FechaIngreso VARCHAR (8),  
@UsuarioReg varchar(30),
@Estado char(1)
AS  
update TQCHOFER set  
  
Brevete = @Brevete,  
dni = @dni,  
Nombre = @Nombre,  
Apellido = @Apellido,  
Direccion = @Direccion,  
TelefCasa = @TelefCasa,  
TelefCelu = @TelefCelu,  
FechaIngreso = @FechaIngreso,  
FechaReg = GETDATE(),  
UsuarioReg = @UsuarioReg,
Estado = @Estado  
  
where  IdChofer = @IdChofer   
  
  


GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Circuito]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Circuito]  
@idcircuito int,  
@Tipocir01 char(1),  
@codrut01 char(5),  
@desrut01 varchar(100),  
@ptopar01 varchar(10),  
@ptodes01 varchar(10),  
@automa01 char(1),  
@ficsol01 char(3),  
@ficdol03 char(3),  
@succon01 char(2),  
@cencos01 char(3),  
@condcntr char(1),  
@kilometros numeric(9,2),  
@PtoPartida varchar(80),  
@DistPartida varchar(80),  
@PtoLlegada varchar(80),  
@DistLlegada varchar(80),  
@UauarioMod  varchar(30),  
@PtoOrigen  varchar(150),  
@PtoDestino  varchar(150)  
as  
  
UPDATE CQCIRCUI01 SET  
Tipocir01= @Tipocir01,  
codrut01 = @codrut01,  
desrut01 = @desrut01,  
ptopar01 = @ptopar01,  
ptodes01 = @ptodes01,  
--automa01 = @automa01,  
ficsol01 = @ficsol01,  
ficdol03 = @ficdol03,  
succon01 = @succon01,  
cencos01 = @cencos01,  
condcntr = @condcntr,  
kilometros = @kilometros,  
PtoPartida = @PtoPartida,  
DistPartida = @DistPartida,  
PtoLlegada = @PtoLlegada,  
DistLlegada = @DistLlegada,  
fechaMod = getdate(),  
UauarioMod = @UauarioMod,  
PtoOrigen = @PtoOrigen,  
PtoDestino = @PtoDestino,
flgAutomatico=@automa01  
WHERE idcircuito = @idcircuito   
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Cliente]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Cliente]
@rucclien char(11),
@razonsoc varchar(100),
@direcci0 varchar(100),
@distrit0 varchar(50),
@telefon0 varchar(15),
@atencion varchar(50),
@usuaregi varchar (50)
as
update TQCLIENTE set
razonsoc = @razonsoc,
direcci0 = @direcci0,
distrit0 = @distrit0,
telefon0 = @telefon0,
atencion = @atencion,
usuaregi = @usuaregi,
fechareg = getdate()
where rucclien = @rucclien  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_DetGuia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_DetGuia]
@codDet01 int,
@nrogui01 char(10),
@codcon01 char(11),
@codtam01 char(2)
as 
update DDGUITTR01 set
nrogui01 = @nrogui01,
codcon01 = @codcon01,
codtam01 = @codtam01
where codDet01 = @codDet01 
return 0 

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Diseniollanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Diseniollanta]
@IdDisenio int,
@Descripcion varchar(30),
@Usuario varchar(30)
as
update TQDISENIOLLANTA set
Descripcion = @Descripcion,
Usuario = @Usuario,
Fechareg = getdate()
where  IdDisenio = @IdDisenio

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_EmpServ]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_EmpServ]
@idEmpServ int,
@ruc	varchar(11),
@Nombre	varchar	(50),
@Direccion varchar(50),
@Telefono varchar(15),
@Contacto varchar(50),
@Usuario varchar(30)
as
update TQEMPSERV set
ruc = @ruc,
Nombre = @Nombre,
Direccion = @Direccion,
Telefono = @Telefono,
Contacto = @Contacto,
Usuario = @Usuario,
fechareg = getdate()

where idEmpServ = @idEmpServ 
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Eventos]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Eventos]  
@idEvento int,  
@idTipoEvent int,  
@IdChofer int,  
@idPlacaAut int,  
@Descripcion varchar (50),  
@Fecha varchar(8),  
@Hora varchar(8),  
@UsuarioReg varchar(30),  
@IdServicio int,  
@Idtikets int,
@EstadoServicio varchar(1)
as  
update DCEVENTOS set  
  
idTipoEvent = @idTipoEvent,  
IdChofer = @IdChofer,  
idPlacaAut = @idPlacaAut,  
Descripcion = @Descripcion,  
Fecha = @Fecha,  
Hora = @Hora,  
FechaReg  = getdate(),  
UsuarioReg = @UsuarioReg,  
IdServicio = @IdServicio,  
Idtikets = @Idtikets,
EstadoServicio = @EstadoServicio
where idEvento = @idEvento   
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Factura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Factura]    
 @nrofac01 char(10),    
 @tipdoc01 char(2),    
 @idconta01 int,    
 @ruccli01 char(11),    
 @fecemi01 char(8),    
 @fecven01 char(8),    
 @conpag01 char(2),    
 @moneda01 char(1),    
 @tipcam01 decimal (6,3),    
 @valfac01 decimal(12,2),    
 @impven01 decimal (5,2),    
 @totven01 decimal(12,2),    
 @flages01 char(1),    
 @afecim01 char(1),    
 @atenci01 varchar(50),    
 @flagCont char(1),    
 @coduse01 varchar(50),    
 @observ01 varchar(255),  
 @nroRef01 varchar(10),
 @FecRef01 varchar(8)
 as    
 update DCFACTTR01 set    
 ruccli01 = @ruccli01,    
 fecemi01 = @fecemi01,    
 fecven01 = @fecven01,    
 conpag01 = @conpag01,    
 moneda01 = @moneda01,    
 tipcam01 = @tipcam01,    
 valfac01 = @valfac01,    
 impven01 = @impven01,    
 totven01 = @totven01,    
 flages01 = @flages01,    
 afecim01 = @afecim01,    
 atenci01 = @atenci01,    
 flagCont = @flagCont,    
 coduse01 = @coduse01,    
 observ01 = @observ01,  
 nroRef01 = @nroRef01,
 FecRef01 = @FecRef01
 where    
 nrofac01 = @nrofac01 and     
 tipdoc01 = @tipdoc01 and    
 idconta01= @idconta01    
 return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Factura_bk]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Factura_bk]      
 @nrofac01 char(10),      
 @tipdoc01 char(2),      
 @idconta01 int,      
 @ruccli01 char(11),      
 @fecemi01 char(8),      
 @fecven01 char(8),      
 @conpag01 char(2),      
 @moneda01 char(1),      
 @tipcam01 decimal (6,3),      
 @valfac01 decimal(12,2),      
 @impven01 decimal (5,2),      
 @totven01 decimal(12,2),      
 @flages01 char(1),      
 @afecim01 char(1),      
 @atenci01 varchar(50),      
 @flagCont char(1),      
 @coduse01 varchar(50),      
 @observ01 varchar(255),    
 @nroRef01 varchar(10),  
 @FecRef01 varchar(8)  
 as      
 update DCFACTTR01 set      
 ruccli01 = @ruccli01,      
 fecemi01 = @fecemi01,      
 fecven01 = @fecven01,      
 conpag01 = @conpag01,      
 moneda01 = @moneda01,      
 tipcam01 = @tipcam01,      
 valfac01 = @valfac01,      
 impven01 = @impven01,      
 totven01 = @totven01,      
 flages01 = @flages01,      
 afecim01 = @afecim01,      
 atenci01 = @atenci01,      
 flagCont = @flagCont,      
 coduse01 = @coduse01,      
 observ01 = @observ01,    
 nroRef01 = @nroRef01,  
 FecRef01 = @FecRef01  
 where      
 nrofac01 = @nrofac01 and       
 tipdoc01 = @tipdoc01 and      
 idconta01= @idconta01      
 return 0    
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_FacturabyNroFlagOfisis]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_FacturabyNroFlagOfisis]
@nrofac01 char(10),
@tipdoc01 char(2),
@idConta01 int ,
@flagCont char(1),
@coduse01 varchar(50),
@Glosa  varchar (255),
@NroFic varchar(20)

as
update DCFACTTR01 set
flagCont = @flagCont,
coduse01 = @coduse01 ,
NroOfisis =  @NroFic,
GlosaOfisis =  @Glosa     
where
nrofac01 = @nrofac01 and 
tipdoc01 = @tipdoc01 and 
idconta01 = @idconta01
return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_FacturabyNroFlagUltra]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modificar_FacturabyNroFlagUltra]
@nrofac01 char(10),
@tipdoc01 char(2),
@idConta01 int ,
@flagCont char(1),
@coduse01 varchar(50)
as
update DCFACTTR01 set
flagCont = @flagCont,
coduse01 = @coduse01
where
nrofac01 = @nrofac01 and 
tipdoc01 = @tipdoc01 and 
idconta01 = @idconta01
return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Guia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Guia]                    
@nrogui01 varchar(10),                    
@nrogui73 varchar(10),                    
@codcco06 varchar(8),                    
@navvia11 char(6) ,                    
@nropla01 char(7) ,                    
@fecgen01 char(17),                    
@client01 char(11),                    
@brevet01 char(9) ,                    
@idcircuito integer,                    
@codnav08 char(4) ,                    
@remolq73 char(10),                    
@nrodet01 int,                  
@flagEstra char(1),                  
@DesCircu varchar(100),                  
@PrecioCir decimal(15,2),                  
@Comision decimal (15,2),                  
@FlagVicon char(1),                  
@Observacion varchar(255),          
@IdTarifa as integer,      
@TipoMerc char(1),    
@usumod varchar (30),    
@PtoOrigen varchar(150),    
@PtoDestino varchar(150),    
@ValRef decimal(12,2),  
@Peaje decimal(5,2)  
as       
                 
UPDATE DCGUITTR01 SET              
nrogui73 = @nrogui73,                       
codcco06 = @codcco06,                        
navvia11 = @navvia11,                        
nropla01 = @nropla01,                        
fecgen01 = @fecgen01,                        
client01 = @client01,                        
brevet01 = @brevet01,                        
idcircuito = @idcircuito,      
codnav08 = @codnav08,                        
remolq73 = @remolq73,                        
nrodet01 = @nrodet01,                      
flagEstra = @flagEstra,                    
DesCircu = @DesCircu,                    
PrecioCir = @PrecioCir,                    
PrecioCir_S = @PrecioCir,                    
Comision = @Comision,                    
FlagVicon  = @FlagVicon,                  
observacion = @Observacion,            
idtarifa = @IdTarifa,          
TipoMerc = @TipoMerc,    
usumod = @usumod,    
fecmod01 = getdate(),    
PtoOrigen = @PtoOrigen,    
PtoDestino = @PtoDestino,    
ValRef = @ValRef,  
peaje = @peaje  
WHERE nrogui01 = @nrogui01                 
RETURN 0         


GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Llanta]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Llanta]    
@IdLlanta int,  
@Codigo int,    
@IdMedida varchar(30),    
@IdMarca  varchar(30),    
@IdDisenio varchar(30),    
@Cocada_mm int,    
@N_R varchar(1),    
@FechaIngreso varchar(8),    
@usuareg varchar(50)  
as    
update CDLLANTA set  
Codigo = @Codigo,  
IdMedida = @IdMedida,    
IdMarca  = @IdMarca,    
IdDisenio = @IDDisenio,    
Cocada_mm = @Cocada_mm,    
N_R = @N_R,    
FechaIngreso = @FechaIngreso,  
fecharegistro = getdate(),        
Usuario  = @usuareg  
where IdLlanta =  @idLlanta
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_logtkt]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modificar_logtkt]
@nrofac01 char(10),
@idtikets int,
@flagestadoant char(1),
@flagestadonue char(1),
@usuaregi varchar(30),
@razonCamb varchar(255)
as
insert into TQLOGTKT
(nrofac01,idtikets,flagestadoant ,flagestadonue ,usuaregi, fechregi, razonCamb)
values
(@nrofac01,@idtikets,@flagestadoant ,@flagestadonue ,@usuaregi, getdate(),@razonCamb)
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Marca]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Marca]
@IdMarca int,
@Descripcion varchar(70),
@Usuario varchar (30)
as
update TQMARCA set
Descripcion = @Descripcion,
Usuario = @Usuario ,
FechaReg = getdate()
where  IdMarca = @IdMarca

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Medida]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Medida]
@IdMedida int,
@Descripcion varchar(70),
@Usuario varchar(30)
as
update TQMEDIDA set
Descripcion = @Descripcion,
Usuario = @Usuario,
Fechareg = getdate()
where  IdMedida = @IdMedida
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_OrdenServicioNroOfisis]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_OrdenServicioNroOfisis]    

@NroFact char(10),        

@tipdoc01 char(1),      

@NroOfisis integer,    

@GlosaOfisis varchar (255)
       

as     

begin

update DCFACTTR01 SET        

Nroofisis = @NroOfisis,    

Glosaofisis = @GlosaOfisis    

where NroFac01 = @NroFact        
And   tipdoc01 = @tipdoc01
end

return 0

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_PlacaAutorizada]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_PlacaAutorizada]      
@idPlaAut int,      
@codage19 char(11),      
@nropla81 char(7),      
@esactivo char(1),      
@usuaregi varchar(50),      
@tablero char(1),      
@externo char(1),    
@Nombre varchar(50),  
@ValorProm numeric (8,3),      
@Marca varchar (30),
@Certificado varchar (15),
@idconf int
as      

UPDATE TQPLAAUT SET      
codage19 = @codage19,      
nropla81 = @nropla81,      
esactivo = @esactivo,      
usuaregi = @usuaregi,      
fechareg = getdate(),      
UodoTablero = @tablero,      
UodoExterno = @externo,      
Nombre = @Nombre,  
ValorProm = @ValorProm,            
Marca = @Marca,
Certificado = @Certificado,
idconf = @idconf
WHERE idPlaAut =  @idPlaAut 
      
return 0    

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_PrecioCombustible]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_PrecioCombustible]
@idprecio int,
@idcombus int,
@idforpag char(1),
@precioco decimal (12,2),
@Fechaing varchar(8),
@usuaregi varchar(50)
as
update TQPRECOMB set

idcombus = @idcombus,
idforpag = @idforpag,
precioco = @precioco,
Fechaing = @Fechaing,
usuaregi = @usuaregi,
fechareg = getdate()

where idprecio = @idprecio 
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Servicio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Servicio]  
@idTipoServ int,  
@NombServ varchar (50),  
@IdUnitControl int,  
@Cantidad decimal (8,2),  
@UsuarioReg varchar (30),
@Control int  
  
as  
update tqservicio set  
NombServ = @NombServ,  
IdUnitControl = @IdUnitControl,  
Cantidad = @Cantidad,  
UsuarioReg = @UsuarioReg,  
FechaReg = getdate(),  
control = @control
where idTipoServ =  @idTipoServ   
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Servicios]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Servicios]  
@NroServicio int,
@FechaIni varchar(8),  
@HoraIni varchar(8),  
@IdChofer int,  
@IdPlacaAut int,  
@Carreta varchar (50),  
@IdTipoServ int,   
@IdEmpresaServ int,  
@Contacto varchar(50),  
@HorometroIni decimal (8,2),  
@OdometroIni decimal(8,2),  
@Estado char(1),  
@FechaFin varchar(8),  
@HoraFin varchar(8),  
@HorometroFin decimal (8,2),  
@OdometroFin decimal (8,2),  
@ObservacioIni varchar (255),  
@ObservacionFin varchar (255),  
@UsuarioMod varchar (30)  

as  
update DCSERVICIOS set  
FechaIni = @FechaIni,  
HoraIni = @HoraIni,  
IdChofer = @IdChofer,  
IdPlacaAut = @IdPlacaAut,  
Carreta = @Carreta,  
IdTipoServ = @IdTipoServ,  
IdEmpresaServ = @IdEmpresaServ,  
Contacto = @Contacto,  
HorometroIni = @HorometroIni,  
OdometroIni = @OdometroIni,  
Estado = @Estado,  
FechaFin = @FechaFin,  
HoraFin = @HoraFin,  
HorometroFin = @HorometroFin,  
OdometroFin = @OdometroFin,  
ObservacioIni = @ObservacioIni,  
ObservacionFin = @ObservacionFin,  
FechaMod = getdate(),  
UsuarioMod = UsuarioMod  
where NroServicio =  @NroServicio  
  
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Servicios_Estado]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Servicios_Estado]
@NroServicio int,
@Estado char(1),
@UsuarioMod varchar(30)
as
update DCSERVICIOS set
Estado = @Estado,
UsuarioMod = @UsuarioMod,
FechaMod = getdate()
where NroServicio =  @NroServicio
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Tikets]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Tikets]        
@idtikets int,        
@idplaaut int,         
@idprecio int,         
@cantidad decimal (12,6),        
@tipocamb decimal (8,3),        
@nrofactu char(10),        
@fecfactu char(8),        
@nrovalet char(20),        
@flagesta char(1),        
@usuaregi varchar(50),      
@fechvale varchar(8),        
@horavale varchar(8),      
@OActual  decimal (9,1),    
@OAnterior decimal (9,1),    
@OActualTablero decimal (9,1),    
@OAnteriorTablero decimal (9,1),     
@HActual decimal (9,1),    
@HAnterior decimal (9,1),    
@PUnitario decimal (14,3),  
@IdCombus int,
@IdValeaut int  
as        
update TQTIKETS set        
fechareg = getdate(),        
idplaaut = @idplaaut,         
idprecio = @idprecio,         
cantidad = @cantidad,        
tipocamb = @tipocamb,        
nrofactu = @nrofactu,        
fecfactu = @fecfactu,        
nrovalet = @nrovalet,        
flagesta = @flagesta,        
usuaregi = @usuaregi,        
fechvale = @fechvale,      
horavale = @horavale,         
OActual =  @OActual,       
OAnterior = @OAnterior,    
OActualTablero = @OActualTablero,    
OAnteriorTablero = @OAnteriorTablero,    
HActual = @HActual,    
HAnterior = @HAnterior,  
PUnitario = @PUnitario,  
IdCombus = @IdCombus,
IdValeaut = @IdValeaut    
where idtikets =  @idtikets        


GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Tikets_ByEstado]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_Tikets_ByEstado]
@idtikets int,
@flagesta char(1),
@usuaregi varchar(50)
as
update TQTIKETS set
fechareg = getdate(),
flagesta = @flagesta,
usuaregi = @usuaregi

where idtikets =  @idtikets
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_TiketsByNro]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Modificar_TiketsByNro]  
@idtikets int,  
@nrofactu varchar (10),  
@fecfactu varchar (8),    
@flagesta char(1),  
@usuaregi varchar(50)    
as  
update TQTIKETS set  
nrofactu = @nrofactu,  
fecfactu = @fecfactu,  
flagesta = @flagesta,  
usuaregi = @usuaregi,
fechareg = getdate()    
where idtikets =  @idtikets  
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_UltimoNroBySerie]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_UltimoNroBySerie]
@idconta01 int,
@numerdo01 int
as
update DCCONTTRI01 set
numerdo01 = @numerdo01
where idconta01 = @idconta01
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_UnidadControl]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[sp_Modificar_UnidadControl]  
@idUnidadControl int,  
@DescripcionControl varchar (70),  
@Usuario varchar (30),
@UniConver char(1),
@valorConver decimal(8,3)
as  
update tqunitcont set  
DescripcionControl = @DescripcionControl,  
Usuario = @Usuario,  
FechaReg = getdate(),  
UniConver = @UniConver, 
valorConver = @valorConver    
where idUnidadControl =  @idUnidadControl  

GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_Usuario]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[sp_Modificar_Usuario]  
@idUsuario int,  
@Nombre varchar(50),  
@Apellidos varchar(100),  
@Login Varchar(30),  
@Pass varchar(15),  
@Estado char(1),  
@UsurioReg varchar(30),
@usuTrans char(1),
@usuCombs char(1)

AS  
update TQUSUARIO set  
Nombre = @Nombre,  
Apellidos = @Apellidos,  
Login = @Login,  
Pass = @Pass,  
UsurioReg = @UsurioReg,  
estado = @Estado,  
FecReg = GETDATE(),
usuTrans = @usuTrans,
usuCombs = @usuCombs
where idUsuario = @idUsuario   
return 0  
GO
/****** Object:  StoredProcedure [dbo].[sp_Modificar_ValeAut]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Modificar_ValeAut]
@IdVale int,
@IdPlaAut int,
@FlagExtra char (1),
@Fecha varchar(8),
@TableroAnt decimal(10,1),
@TableroAct decimal(10,1),
@ExternoAnt decimal(10,1),
@ExternoAct decimal(10,1),
@HoroAnt decimal(10,1),
@HoroAct decimal(10,1),
@Cantidad decimal (12,6),
@Rendimiento decimal(8,3),
@Usuario Varchar(30)
as
update TQVALESAUT set
IdPlaAut = @IdPlaAut,
FlagExtra = @FlagExtra,
Fecha  = @Fecha ,
TableroAnt = @TableroAnt,
TableroAct = @TableroAct,
ExternoAnt = @ExternoAnt,
ExternoAct = @ExternoAct,
HoroAnt = @HoroAnt,
HoroAct = @HoroAct,
Cantidad = @Cantidad,
Rendimiento = @Rendimiento,
Usuario = @Usuario,
FechaReg = getdate()
where IdVale = @IdVale

GO
/****** Object:  StoredProcedure [dbo].[sp_Mostrar_Tickets]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Mostrar_Tickets]    
@idtikets     int
as    
select a.idtikets,    
convert(varchar(10),a.fechvale,103) as fechvale,
convert(varchar(8),a.horavale,108) as horavale,
a.idplaaut,    
a.idprecio,    
a.cantidad,    
a.tipocamb,    
a.nrofactu,    
a.fecfactu,    
a.nrovalet,    
a.flagesta,    
b.codage19,    
b.nropla81,    
C.idcombuS,    
C.idforpag,    
C.precioco,    
round(a.cantidad * C.precioco, 2) as total,    
descombu,    
cod_ultra,    
E.razonsoc     
from TQTIKETS as a inner join TQPLAAUT AS b    
ON a.idplaaut = b.idplaaut inner join TQPRECOMB AS C     
ON a.idprecio = C.idprecio inner join TQCOMBUS AS D    
ON C.idcombuS = D.idcombuS inner join TQCLIENTE AS E  
ON b.codage19 = E.rucclien
where a.idtikets = @idtikets 
return 0    


GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerDetraccion]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_ObtenerDetraccion]
	@nroFac01 char(10),                      
@tipdoc01 char(2),                      
@idconta01 int                      
as                  
         
--sp_ObtenerDetraccion '0090001204', '01', '09'

--sp_ImpresionFactura '0090001204', '01', '09'
     
DECLARE @flg_igv char(1), @val_ref numeric(12,2), @tot_fac decimal(12,2),               
 @tot_gui int, @tot_val_ref numeric(12,2), @tipo_cir char(1) , @auto  int        
              
--rdelacuba 05/10/2006: Verificar si el circuito aplica IGV, obtener el valor referencial y el total facturado en soles              
--rdelacuba 11/10/2006: Verificar el tipo de circuito              
    
create table #fact    
(    
flgigv01 varchar(1),    
valorref decimal(12,2),    
Tipocir varchar (1),    
TotalFact decimal(12,2)    
)    
    
insert into  #fact    
SELECT --top 1        
flg_igv = case when q.automa01 = 1 then T.flgigv01        
               when q.automa01 = 0 then A.afecim01 end,        
val_ref = case when q.tipocir01 = 'C' and isnull(C.valref,0) = 0 then isnull(T.valref,0)        
	       when q.tipocir01 = 'C' and isnull(C.valref,0) <> 0 then c.valref        	              
	       when q.tipocir01 = 'E' and isnull(C.valref,0) <> 0 then isnull(C.valref,0)  
               when q.tipocir01 = 'E' and isnull(C.valref,0) = 0 then T.valref end ,    
              
tipo_cir = Q.Tipocir01,              
tot_fac = CASE A.moneda01 WHEN 1 THEN isnull(totven01,0)               
                          WHEN 2 THEN isnull(totven01,0) * isnull(tipcam01,0) END    
--@auto = q.automa01        
FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
inner JOIN CQCIRCUI01 AS Q (NOLOCK) ON C.idcircuito = Q.idcircuito              
left join CQTARCIR01 AS T (NOLOCK) ON C.idtarifa = T.idtarifa              
WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01               
order by  q.automa01      
--Si el circuito aplica IGV y no es extraordinaria, calcular el valor referencial total en función del total de guías relacionadas              
--Si el cicuito aplica IGV y es extraordinaria, calcular el valor referencial total en función del valor de las guías              
    
select top 1 @flg_igv = flgigv01    
from #fact    
    
IF @flg_igv = 1              
BEGIN              
/* IF @auto = 1              
    BEGIN              
    SELECT @tot_gui = count(*)              
    FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
    A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
    INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
    WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01               
              
    IF @val_ref = 0              
       SET @tot_val_ref = @val_ref --@tot_fac  --EPM            
    ELSE              
       SET @tot_val_ref = isnull(@tot_gui,0) * isnull(@val_ref,0)               
    END              
  ELSE              
    BEGIN              
    SELECT @tot_val_ref = SUM(isnull(C.ValRef,0))              
    FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON                      
    A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                  
    INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01                      
    WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01      
 END */    
    
 select @flg_igv = flgigv01,     
 @tot_val_ref =  sum(valorref),     
 @tot_fac = totalfact    
 from #fact    
 group by flgigv01, totalfact    
    
END              
ELSE              
BEGIN              
 SET @tot_val_ref = 0              
END              
      
drop table #fact    
            
--rdelacuba 05/10/2006: Considerar el valor referencial                  
SELECT DISTINCT A.tipcam01,@tot_val_ref AS VALREF              
            
FROM DCFACTTR01 AS A 
--INNER JOIN DDFACTTR01 as B ON                      
--A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01                 
--INNER join TQCONPAG01 AS F ON A.conpag01 = F.conpag01  
--LEFT join TQCLIENTE AS E ON A.ruccli01 = E.rucclien                      
--LEFT join DCGUITTR01 AS C ON  B.nrodet01 = C.nrodet01                      
--LEFT JOIN DDGUITTR01 AS D ON C.nrogui01 = D.nrogui01            
--left join CQCIRCUI01 as g on c.idcircuito = g.idcircuito     
WHERE                      
A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01                       
              
return 0      
      
    
  
GO
/****** Object:  StoredProcedure [dbo].[SP_PRODUCCIONCAMIONES]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_PRODUCCIONCAMIONES]        
@FECHA_INI CHAR(8),                    
@FECHA_FIN CHAR(8),                    
@TIPOFECHA CHAR(1)      
AS      
      
if @TIPOFECHA='R'      
begin      
SELECT                     
B.BREVET01,                     
D.apellido+' '+d.nombre as NOMBRE30,                     
B.DESCIRCU AS DESRUT01,                     
B.NROGUI01,                     
isnull(E.codtam01,0) as codtam01,              
B.PrecioCir as Tarifa,                       
case when flagvicon = 'S' then B.PrecioCir            
     when flagvicon = 'N' then B.PrecioCir * count(E.nrogui01) end Total,            
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,                     
--E.CODCON01,                    
count(E.nrogui01) as cantidad,          
J.NOMBRE,  
isnull(b.Peaje, 0) as Peaje
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                    
LEFT JOIN tqchofer AS D ON d.brevete = B.BREVET01                     
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81          
where B.descircu is not null                     
AND convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
group by                     
B.BREVET01,                     
D.apellido+' '+d.nombre,      
B.DESCIRCU,                     
B.NROGUI01,                     
E.codtam01,                     
B.PrecioCir,             
b.flagvicon,                    
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,          
J.NOMBRE,          
b.Peaje            
  
UNION                    
                    
SELECT  B.BREVET01,                     
D.apellido+' '+d.nombre as NOMBRE30,                     
C.DESRUT01,                     
B.NROGUI01,                     
E.codtam01,                     
case             
   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20            
   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40            
   when I.comisionxViaje = 'S' then I.tarifa20 end Tarifa,            
            
case             
   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20 * count(e.nrogui01)            
   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40 * count(e.nrogui01)            
   when I.comisionxViaje = 'S' then I.tarifa20 end toral,            
--C.tarifa20,                     
--c.tarifa40,            
--c.comisionxViaje,            
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,                      
--E.CODCON01                    
count(e.nrogui01)as cantidad,          
J.NOMBRE,  
isnull(b.Peaje, 0) as Peaje
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I           
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA          
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito    
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                    
LEFT JOIN tqchofer AS D ON d.brevete = B.BREVET01                     
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81          
where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN                    
            
group by                     
B.BREVET01,                     
D.apellido+' '+d.nombre,                     
C.DESRUT01,                     
B.NROGUI01,                     
E.codtam01,                     
I.tarifa20,                     
I.tarifa40,            
I.comisionxViaje,            
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,          
J.NOMBRE,  
b.Peaje  
end      
      
else      
      
begin      
SELECT                     
B.BREVET01,                     
D.apellido+' '+d.nombre as NOMBRE30,                     
B.DESCIRCU AS DESRUT01,                     
B.NROGUI01,                     
isnull(E.codtam01,0) as codtam01,              
B.PrecioCir as Tarifa,                       
case when flagvicon = 'S' then B.PrecioCir            
     when flagvicon = 'N' then B.PrecioCir * count(E.nrogui01) end Total,            
B.FECREG01,                     
B.NROPLA01,    
B.FECGEN01,                     
--E.CODCON01,                    
count(E.nrogui01) as cantidad,          
J.NOMBRE,  
isnull(b.Peaje,0) as Peaje
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                    
LEFT JOIN tqchofer AS D ON d.brevete = B.BREVET01                     
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81          
where B.descircu is not null AND                    
convert(varchar(8), FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN               
group by                     
B.BREVET01,                     
D.apellido+' '+d.nombre,                    
B.DESCIRCU,                     
B.NROGUI01,                     
E.codtam01,                     
B.PrecioCir,             
b.flagvicon,                    
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,          
J.NOMBRE,          
b.Peaje  
                     
UNION                    
                    
SELECT  B.BREVET01,                     
D.apellido+' '+d.nombre as NOMBRE30,                     
C.DESRUT01,                     
B.NROGUI01,                     
E.codtam01,                     
case             
   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20            
   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40            
   when I.comisionxViaje = 'S' then I.tarifa20 end Tarifa,            
            
case             
   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20 * count(e.nrogui01)            
   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40 * count(e.nrogui01)            
   when I.comisionxViaje = 'S' then I.tarifa20 end toral,            
--C.tarifa20,                     
--c.tarifa40,            
--c.comisionxViaje,            
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,                      
--E.CODCON01                    
count(e.nrogui01)as cantidad,          
J.NOMBRE,  
isnull(b.Peaje, 0)as Peaje            
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I           
ON  B.idcircuito = I.idcircuito AND B.IDTARIFA = I.IDTARIFA          
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = I.idcircuito    
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                    
LEFT JOIN tqchofer AS D ON d.brevete = B.BREVET01                     
LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81          
where convert(varchar(8), FECGEN01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN                    
            
group by                     
B.BREVET01,                     
D.apellido+' '+d.nombre,                     
C.DESRUT01,                     
B.NROGUI01,                     
E.codtam01,                     
I.tarifa20,                     
I.tarifa40,            
I.comisionxViaje,            
B.FECREG01,                     
B.NROPLA01,                     
B.FECGEN01,          
J.NOMBRE,  
b.Peaje  
end      
RETURN 0                     
  

GO
/****** Object:  StoredProcedure [dbo].[SP_PRODUCCIONCAMIONES_bk]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[SP_PRODUCCIONCAMIONES_bk]    
--@FECHA_INI CHAR(8),            
--@FECHA_FIN CHAR(8)            
--AS             
--SELECT             
--B.BREVET01,             
--D.NOMBRE30,             
--B.DESCIRCU AS DESRUT01,             
--B.NROGUI01,             
--isnull(E.codtam01,0) as codtam01,      
--B.PrecioCir as Tarifa,               
--case when flagvicon = 'S' then B.PrecioCir    
--     when flagvicon = 'N' then B.PrecioCir * count(E.nrogui01) end Total,    
--B.FECREG01,             
--B.NROPLA01,             
--B.FECGEN01,             
----E.CODCON01,            
--count(E.nrogui01) as cantidad,  
--J.NOMBRE            
--FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01            
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01             
--LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81  
--where B.FLAGESTRA = '1' AND            
--convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN       
----convert(varchar(8), FECREG01, 112) BETWEEN '20050429' AND '20050504'            
--group by             
--B.BREVET01,             
--D.NOMBRE30,             
--B.DESCIRCU,             
--B.NROGUI01,             
--E.codtam01,             
--B.PrecioCir,     
--b.flagvicon,            
--B.FECREG01,             
--B.NROPLA01,             
--B.FECGEN01,  
--J.NOMBRE  
             
--UNION            
            
--SELECT  B.BREVET01,             
--D.NOMBRE30,             
--C.DESRUT01,             
--B.NROGUI01,             
--E.codtam01,             
--case     
--   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20    
--   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40    
--   when I.comisionxViaje = 'S' then I.tarifa20 end Tarifa,    
    
--case     
--   when I.comisionxViaje = 'N' and codtam01 = 20 then I.tarifa20 * count(e.nrogui01)    
--   when I.comisionxViaje = 'N' and codtam01 = 40 then I.tarifa40 * count(e.nrogui01)    
--   when I.comisionxViaje = 'S' then I.tarifa20 end toral,    
----C.tarifa20,             
----c.tarifa40,    
----c.comisionxViaje,    
--B.FECREG01,             
--B.NROPLA01,             
--B.FECGEN01,              
----E.CODCON01            
--count(e.nrogui01)as cantidad,  
--J.NOMBRE    
--FROM DCGUITTR01 AS B inner join CQTARCIR01 AS I   
--ON  B.Circui01 = I.CODRUT01 AND B.IDTARIFA = I.IDTARIFA  
--INNER JOIN CQCIRCUI01 AS C ON C.CODRUT01 = I.CODRUT01   
--left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01            
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01             
--LEFT join tqplaaut as J  ON  B.NROPLA01 = J.NROPLA81  
--where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN            
    
--group by             
--B.BREVET01,             
--D.NOMBRE30,             
--C.DESRUT01,             
--B.NROGUI01,             
--E.codtam01,             
--I.tarifa20,             
--I.tarifa40,    
--I.comisionxViaje,    
--B.FECREG01,             
--B.NROPLA01,             
--B.FECGEN01,  
--J.NOMBRE  
--RETURN 0             
   

--GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONES]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONES]  --'20070215','20070228', 'R'                  

@FECHA_INI CHAR(8),                      
@FECHA_FIN CHAR(8),        
@TIPO CHAR(1)                      
AS                       
                   
IF @TIPO = 'R'        
BEGIN        
SELECT                       
B.BREVET01,                       
d.Apellido+', '+d.Nombre as CHOFER,                       
B.DESCIRCU AS DESRUT01,                       
B.NROGUI01,                       
isnull(E.codtam01,0) as codtam01,                  
B.COMISION AS COMISION40,                       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                       
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
F.NOMBRE AS ALIAS,
TelefCelu as Cod_plan,
s.co_circ as Circuito ,
t.servicio as Servicio                        
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81  
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = B.idcircuito   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON
INNER JOIN ttserv as S ON S.dc_servicio = c.cencos01  --20091007 / RTELLO / NUEVOS SERVICIOS TRITON         
INNER JOIN TSTRITON as T ON T.id = s.co_circ   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON                                 
WHERE convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN AND                
B.descircu is not null  and b.idcircuito <> 14   
             
UNION                      
                      
SELECT  B.BREVET01,                       
d.Apellido+', '+d.Nombre AS CHOFER,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
G.COMISION40,                       
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                        
E.CODCON01,  
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
f.Nombre as Alias,                      
TelefCelu as Cod_plan ,
s.co_circ as Circuito ,
t.servicio as Servicio                                             
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA              
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito      
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81  
INNER JOIN ttserv as S ON S.dc_servicio = c.cencos01     --20091007 / RTELLO / NUEVOS SERVICIOS TRITON        
INNER JOIN TSTRITON as T ON T.id = s.co_circ   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON        
where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN  
and  b.idcircuito <> 14                     
END        
                  
IF @TIPO = 'G'        
BEGIN        
SELECT                       
B.BREVET01,                       
d.Nombre+', '+d.Apellido AS CHOFER,                       
B.DESCIRCU AS DESRUT01,                       
B.NROGUI01,                       
isnull(E.codtam01,0) as codtam01,                  
B.COMISION AS COMISION40,                       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                       
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
F.NOMBRE AS ALIAS,
TelefCelu as Cod_plan ,
'' as Circuito ,
'' as Servicio                                            
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
--where convert(varchar(8), FECGEN01, 112) BETWEEN '20051028' AND '20051031'AND                      
WHERE convert(varchar(8), FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN AND                
B.descircu is not null  and b.idcircuito <> 14    
   and f.Nombre is not null           
                       
UNION                      
                      
SELECT  B.BREVET01,                       
d.Nombre+', '+d.Apellido AS CHOFER,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
isnull(B.COMISION,0),                       
isnull(B.COMISION,0)/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,  
  
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                        
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,            
f.Nombre as Alias,
TelefCelu as Cod_plan  ,
'' as Circuito  ,  
'' as Servicio                                                                                                                                                     
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA              
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito      
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where convert(varchar(8), FECGEN01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN and b.idcircuito <> 14                      
 and f.Nombre is not null 
END        
RETURN 0                       






GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONES_bk]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONES_bk]  --'20070215','20070228', 'R'                    
  
@FECHA_INI CHAR(8),                        
@FECHA_FIN CHAR(8),          
@TIPO CHAR(1)                        
AS                         
                     
IF @TIPO = 'R'          
BEGIN          
SELECT                         
B.BREVET01,                         
d.Apellido+', '+d.Nombre as CHOFER,                         
B.DESCIRCU AS DESRUT01,                         
B.NROGUI01,                         
isnull(E.codtam01,0) as codtam01,                    
B.COMISION AS COMISION40,                         
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
B.FECREG01,                         
B.NROPLA01,                         
B.FECGEN01,                         
E.CODCON01,                        
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS,  
TelefCelu as Cod_plan,  
s.co_circ as Circuito ,  
t.servicio as Servicio                          
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                        
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                         
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81    
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = B.idcircuito   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON  
INNER JOIN ttserv as S ON S.dc_servicio = c.cencos01  --20091007 / RTELLO / NUEVOS SERVICIOS TRITON           
INNER JOIN TSTRITON as T ON T.id = s.co_circ   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON                                   
WHERE convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN AND                  
B.descircu is not null  and b.idcircuito <> 14     
               
UNION                        
                        
SELECT  B.BREVET01,                         
d.Apellido+', '+d.Nombre AS CHOFER,                         
C.DESRUT01,                         
B.NROGUI01,                         
E.codtam01,                         
G.COMISION40,                         
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
    
B.FECREG01,                         
B.NROPLA01,                         
B.FECGEN01,                          
E.CODCON01,    
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
f.Nombre as Alias,                        
TelefCelu as Cod_plan ,  
s.co_circ as Circuito ,  
t.servicio as Servicio                                               
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA                
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito        
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                        
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                         
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81    
INNER JOIN ttserv as S ON S.dc_servicio = c.cencos01     --20091007 / RTELLO / NUEVOS SERVICIOS TRITON          
INNER JOIN TSTRITON as T ON T.id = s.co_circ   --20091007 / RTELLO / NUEVOS SERVICIOS TRITON          
where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN    
and  b.idcircuito <> 14                       
END          
                    
IF @TIPO = 'G'          
BEGIN          
SELECT                         
B.BREVET01,                         
d.Nombre+', '+d.Apellido AS CHOFER,                         
B.DESCIRCU AS DESRUT01,                         
B.NROGUI01,                         
isnull(E.codtam01,0) as codtam01,                    
B.COMISION AS COMISION40,                         
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
    
B.FECREG01,                         
B.NROPLA01,                         
B.FECGEN01,                         
E.CODCON01,                        
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS,  
TelefCelu as Cod_plan ,  
'' as Circuito ,  
'' as Servicio                                              
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                        
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                         
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81                
--where convert(varchar(8), FECGEN01, 112) BETWEEN '20051028' AND '20051031'AND                        
WHERE convert(varchar(8), FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN AND                  
B.descircu is not null  and b.idcircuito <> 14      
               
                         
UNION                        
                        
SELECT  B.BREVET01,                         
d.Nombre+', '+d.Apellido AS CHOFER,                         
C.DESRUT01,                         
B.NROGUI01,                         
E.codtam01,                         
G.COMISION40,                         
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
    
B.FECREG01,                         
B.NROPLA01,                         
B.FECGEN01,                          
E.CODCON01,                        
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
f.Nombre as Alias,  
TelefCelu as Cod_plan  ,  
'' as Circuito  ,    
'' as Servicio                                                                                                                                                       
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA                
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito        
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                        
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                         
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81                
where convert(varchar(8), FECGEN01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN and b.idcircuito <> 14                        
    
END          
RETURN 0                         
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONES_FACT]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONES_FACT]  --'20070215','20070228', 'R'                            
@FECHA_INI CHAR(8),                                
@FECHA_FIN CHAR(8),                  
@TIPO CHAR(1)                                
AS                                 
select distinct UM.* from  
(      
SELECT                                 
D.BREVETE AS BREVET01, d.Apellido+', '+d.Nombre as CHOFER, B.DESCIRCU AS DESRUT01, B.NROGUI01, isnull(E.codtam01,0) as codtam01, B.COMISION AS COMISION40,       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1   else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,            
B.FECREG01,  B.NROPLA01, B.FECGEN01, E.CODCON01, (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,     
--F.NOMBRE AS ALIAS,      
ALIAS=(SELECT TOP 1 FF.NOMBRE FROM tqplaaut FF WHERE B.NROPLA01 = FF.NROPLA81),    
TelefCelu as Cod_plan, y.nrofac01, y.fecemi01      
FROM DCGUITTR01 AS B       
inner join dbo.DDFACTTR01 as x on b.nrodet01 = x.nrodet01     
inner join dbo.DCFACTTR01 as y on x.nrofac01 = y.nrofac01     
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01     
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01       
--LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81                        
WHERE convert(varchar(8), y.fecemi01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN AND B.descircu is not null  and b.idcircuito <> 14             
      
                       
UNION                                
                                
SELECT  D.BREVETE AS BREVET01,  d.Apellido+', '+d.Nombre AS CHOFER, B.DESCIRCU AS DESRUT01, B.NROGUI01, E.codtam01,  
B.COMISION AS COMISION40 --G.COMISION40    
--, G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1        
--else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
,B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1   else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
,B.FECREG01, B.NROPLA01, B.FECGEN01,     
E.CODCON01,(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,    
Alias=(SELECT TOP 1 FF.NOMBRE FROM tqplaaut FF WHERE B.NROPLA01 = FF.NROPLA81),    
--f.Nombre as Alias,                            
TelefCelu as Cod_plan, y.nrofac01, y.fecemi01                                                    
FROM DCGUITTR01 AS B       
inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA      
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito      
inner join dbo.DDFACTTR01 as x on b.nrodet01 = x.nrodet01      
inner join dbo.DCFACTTR01 as y on x.nrofac01 = y.nrofac01     
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01      
--LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81                        
where convert(varchar(8), y.fecemi01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN and  b.idcircuito <> 14                               
) UM     
  
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONES_FACT_RESUM]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONES_FACT_RESUM]  --'20070215','20070228', 'R'                      
@FECHA_INI CHAR(17),
@FECHA_FIN CHAR(17),
@COMISION  DECIMAL(12,2),
@TIPOFECHA CHAR(1)

AS         
BEGIN                  
create table #COMISIONES    
(    
BREVETE char(9),
CHOFER  varchar(130),
COD_PLAN varchar (15),
COMISION decimal(12,2),
COMISIONTOTAL decimal(12,2) 
)    
    
INSERT INTO #COMISIONES

SELECT                           
D.BREVETE AS BREVET01, 
d.Apellido+', '+d.Nombre as CHOFER, 
TelefCelu as Cod_plan,
B.COMISION,
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) = 0 then 1   else (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
FROM DCGUITTR01 AS B (NOLOCK)
inner join dbo.DDFACTTR01 as x (NOLOCK) on b.nrodet01 = x.nrodet01 
inner join dbo.DCFACTTR01 as y (NOLOCK) on x.nrofac01 = y.nrofac01 
left join DDGUITTR01 AS E (NOLOCK) ON B.NROGUI01 = E.NROGUI01 
LEFT JOIN tqchofer AS D (NOLOCK) ON D.brevete = B.BREVET01   
LEFT join tqplaaut as F (NOLOCK) ON  B.NROPLA01 = F.NROPLA81                  
WHERE (CASE WHEN @TIPOFECHA = 'R'  THEN b.fecreg01 ELSE b.fecgen01 END) BETWEEN @FECHA_INI AND @FECHA_FIN  -- '20090104' AND '20090105'
AND B.descircu is not null  and b.idcircuito <> 14       
UNION                
SELECT  D.BREVETE AS BREVET01,  
d.Apellido+', '+d.Nombre AS CHOFER,
TelefCelu as Cod_plan,
G.COMISION40,
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) = 0 then 1  else (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK)  WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
FROM DCGUITTR01 AS B (NOLOCK)
inner join CQTARCIR01 AS G (NOLOCK) ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA  
INNER JOIN CQCIRCUI01 AS C (NOLOCK) ON C.idcircuito = G.idcircuito  
inner join dbo.DDFACTTR01 as x (NOLOCK) on b.nrodet01 = x.nrodet01
inner join dbo.DCFACTTR01 as y (NOLOCK) on x.nrofac01 = y.nrofac01 
left join DDGUITTR01 AS E (NOLOCK) ON B.NROGUI01 = E.NROGUI01  
LEFT JOIN tqchofer AS D (NOLOCK) ON D.brevete = B.BREVET01  
LEFT join tqplaaut as F (NOLOCK) ON  B.NROPLA01 = F.NROPLA81                  
where 
(CASE WHEN @TIPOFECHA = 'R'  THEN b.fecreg01 ELSE b.fecgen01 END)  BETWEEN  @FECHA_INI AND @FECHA_FIN   --'20090104' AND '20090105'
and  b.idcircuito <> 14       


SELECT BREVETE,CHOFER,COD_PLAN,SUM(COMISIONTOTAL) as COMISION FROM #COMISIONES
GROUP BY BREVETE,CHOFER,COD_PLAN
HAVING  SUM(COMISIONTOTAL) >= @COMISION    

DROP TABLE  #COMISIONES            
RETURN 0

END


GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONESXCHOFER]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONESXCHOFER]              
@FECHA_INI CHAR(8),                      
@FECHA_FIN CHAR(8),                
@BREVETE CHAR(9),          
@TIPO CHAR(1)                       
AS                
IF @TIPO = 'R'          
BEGIN                 
SELECT                       
B.BREVET01,                       
d.Apellido +', '+ d.Nombre AS chofer,                       
B.DESCIRCU AS DESRUT01,                       
B.NROGUI01,                       
isnull(E.codtam01,0) as codtam01,                  
B.COMISION AS COMISION40,                       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                       
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS                      
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where B.descircu is not null AND                      
convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN                 
AND B.BREVET01 = @BREVETE   and b.idcircuito <> 14             
    
/*group by                       
B.BREVET01,                       
d.Nombre+' '+d.Apellido,                       
B.DESCIRCU,                       
B.NROGUI01,                       
E.codtam01,                       
B.COMISION,                       
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,              
F.NOMBRE                       
*/    
                       
UNION                      
                      
SELECT  B.BREVET01,                       
d.Apellido + ', ' + d.Nombre AS chofer,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
G.COMISION40,                       
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                        
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS                              
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA              
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito        
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN                      
--where convert(varchar(8), FECREG01, 112) BETWEEN  '20060115' AND '20060130'                      
AND B.BREVET01 = @BREVETE    and b.idcircuito <> 14            
  
--AND B.BREVET01 = 'Q08667469'    
--ORDER BY B.NROGUI01    
/*group by                       
B.BREVET01,                       
d.Nombre + ' ' + d.Apellido ,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
G.COMISION40,                       
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,              
F.NOMBRE,     
E.CODCON01    
ORDER BY B.NROGUI01    
*/    
    
end           
          
IF @TIPO = 'G'          
BEGIN                 
SELECT                       
B.BREVET01,                       
d.Apellido +', '+ d.Nombre AS chofer,                       
B.DESCIRCU AS DESRUT01,         
B.NROGUI01,                       
isnull(E.codtam01,0) as codtam01,                  
B.COMISION AS COMISION40,                       
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                       
E.CODCON01,                      
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS                      
FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where B.descircu is not null AND             
convert(varchar(8), FECGEN01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN                 
AND B.BREVET01 = @BREVETE     and b.idcircuito <> 14           
/*group by                       
B.BREVET01,               
d.Nombre+' '+d.Apellido,                       
B.DESCIRCU,                       
B.NROGUI01,                       
E.codtam01,                       
B.COMISION,                       
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,              
F.NOMBRE                       
*/                       
UNION                      
                      
SELECT  B.BREVET01,                       
d.Apellido+', '+d.Nombre AS chofer,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
G.COMISION40,                       
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1    
             else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,    
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,                        
E.CODCON01,    
(SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,              
F.NOMBRE AS ALIAS                              
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA              
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito        
left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                      
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                       
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81              
where convert(varchar(8), FECGEN01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN                      
AND B.BREVET01 = @BREVETE       and b.idcircuito <> 14         
/*group by                       
B.BREVET01,                       
d.Nombre+' '+d.Apellido,                       
C.DESRUT01,                       
B.NROGUI01,                       
E.codtam01,                       
G.COMISION40,                       
B.FECREG01,                       
B.NROPLA01,                       
B.FECGEN01,              
F.NOMBRE        */    
end           
RETURN 0             

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONESXCHOFER_BK]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONESXCHOFER_BK]      --FMCR  
--@FECHA_INI CHAR(8),        
--@FECHA_FIN CHAR(8),  
--@BREVETE CHAR(9)        
--AS         
--SELECT         
--B.BREVET01,         
--D.NOMBRE30,         
--B.DESCIRCU AS DESRUT01,         
--B.NROGUI01,         
--isnull(E.codtam01,0) as codtam01,    
--B.COMISION AS COMISION40,         
--B.FECREG01,         
--B.NROPLA01,         
--B.FECGEN01,         
----E.CODCON01,        
--count(E.nrogui01) as cantidad,
--F.NOMBRE AS ALIAS        
--FROM DCGUITTR01 AS B left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01        
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01         
--LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81
--where B.FLAGESTRA = '1' AND        
--convert(varchar(8), FECREG01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN   
--and B.NROPLA01 not like 'MU%'              
--AND B.BREVET01 = @BREVETE  
----where convert(varchar(8), FECREG01, 112) BETWEEN '20050429' AND '20050504'        
--group by         
--B.BREVET01,         
--D.NOMBRE30,         
--B.DESCIRCU,         
--B.NROGUI01,         
--E.codtam01,         
--B.COMISION,         
--B.FECREG01,         
--B.NROPLA01,         
--B.FECGEN01,
--F.NOMBRE         
         
--UNION        
        
--SELECT  B.BREVET01,         
--D.NOMBRE30,         
--C.DESRUT01,         
--B.NROGUI01,         
--E.codtam01,         
--G.COMISION40,         
--B.FECREG01,         
--B.NROPLA01,         
--B.FECGEN01,          
----E.CODCON01        
--count(e.nrogui01)as cantidad,
--F.NOMBRE AS ALIAS                
--FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.Circui01 = G.CODRUT01 AND B.IDTARIFA = G.IDTARIFA
--INNER JOIN CQCIRCUI01 AS C ON C.CODRUT01 = G.CODRUT01 
--left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01        
--LEFT JOIN TERMINAL..EQBREVET30 AS D ON D.CODBRE30 = B.BREVET01         
--LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81
--where convert(varchar(8), FECREG01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN        
--and B.NROPLA01 not like 'MU%'  
--AND B.BREVET01 = @BREVETE  
----where FECGEN01 BETWEEN '20050207' AND '20050211'        
--group by         
--B.BREVET01,         
--D.NOMBRE30,         
--C.DESRUT01,         
--B.NROGUI01,         
--E.codtam01,         
--G.COMISION40,         
--B.FECREG01,         
--B.NROPLA01,         
--B.FECGEN01,
--F.NOMBRE       
--RETURN 0         
--GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_COMISIONESXCHOFER_FACT]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_COMISIONESXCHOFER_FACT]  
@FECHA_INI CHAR(8),                          
@FECHA_FIN CHAR(8),                    
@BREVETE CHAR(9),              
@TIPO CHAR(1)                           
AS                    
              
SELECT D.BREVETE AS BREVET01,        
d.Apellido +', '+ d.Nombre AS chofer, B.DESCIRCU AS DESRUT01, B.NROGUI01,  isnull(E.codtam01,0) as codtam01, B.COMISION AS COMISION40,  B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal, B.FECREG01,  B.NROPLA01,  B.FECGEN01,  E.CODCON01, (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad,  F.NOMBRE AS ALIAS,  y.nrofac01, y.fecemi01
FROM DCGUITTR01 AS B  
inner join dbo.DDFACTTR01 as x on b.nrodet01 = x.nrodet01 inner join dbo.DCFACTTR01 as y on x.nrofac01 = y.nrofac01 left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01 LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01                           
LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81  where B.descircu is not null AND  convert(varchar(8), y.fecemi01, 112) BETWEEN @FECHA_INI AND @FECHA_FIN  AND D.BREVETE = @BREVETE   and b.idcircuito <> 14    
        
UNION                          
                          
SELECT  D.BREVETE AS BREVET01,  d.Apellido + ', ' + d.Nombre AS chofer,                           
C.DESRUT01, B.NROGUI01, E.codtam01, G.COMISION40,  G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) = 0 then 1  else (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) end ) as comisiontotal,        
B.FECREG01, B.NROPLA01, B.FECGEN01, E.CODCON01, (SELECT count(nrogui01) FROM DDGUITTR01 WHERE nrogui01 = B.nrogui01) as cantidad, F.NOMBRE AS ALIAS,y.nrofac01, y.fecemi01                                
FROM DCGUITTR01 AS B inner join CQTARCIR01 AS G ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA  
INNER JOIN CQCIRCUI01 AS C ON C.idcircuito = G.idcircuito  inner join dbo.DDFACTTR01 as x on b.nrodet01 = x.nrodet01 inner join dbo.DCFACTTR01 as y on x.nrofac01 = y.nrofac01  left join DDGUITTR01 AS E ON B.NROGUI01 = E.NROGUI01                          
LEFT JOIN tqchofer AS D ON D.brevete = B.BREVET01 LEFT join tqplaaut as F  ON  B.NROPLA01 = F.NROPLA81  where convert(varchar(8), y.fecemi01, 112) BETWEEN  @FECHA_INI AND @FECHA_FIN                          
AND D.BREVETE = @BREVETE    and b.idcircuito <> 14  


RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[sp_Reporte_DiasCamionChofer]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Reporte_DiasCamionChofer]  
@Fecha varchar(8)  
as  
select b.nombre, c.nombre + ' ' + c.apellido as NombreChofer,   
case when len(convert(varchar(2), DATENAME(day, fecgen01))) = 1 then  convert(varchar(2), '0'+DATENAME(day, fecgen01))+ ' ' + DATENAME(dw, fecgen01)
     else convert(varchar(2), DATENAME(day, fecgen01)) + ' ' + DATENAME(dw, fecgen01) end as Dias , fecgen01  
from dbo.DCGUITTR01 as a   
inner join dbo.TQPLAAUT as b on a.nropla01 = b.nropla81   
inner join dbo.TQCHOFER as c on a.brevet01 = c.brevete  
where DATENAME(month, fecgen01) = DATENAME(month, @Fecha)  and DATENAME(year, fecgen01) = DATENAME(year, @Fecha)
order by fecgen01
return 0  

GO
/****** Object:  StoredProcedure [dbo].[sp_reporte_llantas_asignadas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_reporte_llantas_asignadas]  
--@camion varchar(7)  
--as  
  
--if @camion = '*'  
--begin  
--select   
--c.nropla81,   
--a.Posicion,   
--a.FechaAsigna,   
--b.Codigo,  
--b.Medida,  
--b.Marca,  
--b.Diseno,  
--b.FechaIngreso,  
--b.Cocada_mm,  
--d.descripcion,  
--a.Horometro,  
--a.OdoExterno,  
--a.OdoInterno,
--c.Nombre  
--from TQLLANTA a, cdLLANTA b, tqPlaAut c, tqmovcam d  
--where c.idPlaAut   =   a.idPlaAut  
--and   a.id_Llanta   =   b.idLlanta  
--and   a.id_motivo   =   d.idmotivo     
--end  
  
--if @camion <> ''  
--begin  
--select   
--c.nropla81,   
--a.Posicion,   
--a.FechaAsigna,   
--b.Codigo,  
--b.Medida,  
--b.Marca,  
--b.Diseno,  
--b.FechaIngreso,  
--b.Cocada_mm,  
--d.descripcion,  
--a.Horometro,  
--a.OdoExterno,  
--a.OdoInterno,
--c.Nombre  
--from TQLLANTA a, cdLLANTA b, tqPlaAut c, tqmovcam d  
--where c.idPlaAut   =   a.idPlaAut  
--and   a.id_Llanta   =   b.idLlanta  
--and   a.id_motivo   =   d.idmotivo     
--and   c.nropla81 = @camion  
--end  
--GO
/****** Object:  StoredProcedure [dbo].[sp_reporte_ticketes]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_reporte_ticketes]  
@FECHA_INI CHAR(8),  
@FECHA_FIN CHAR(8),  
@RUCCLIE CHAR(11),  
@ESTADO CHAR(1)  
as  
  
IF @ESTADO <> 'T'   
BEGIN  
select  
a.idtikets,  
a.idplaaut,  
a.idprecio,  
a.cantidad,  
f.nrofac01,  
a.fecfactu,  
a.nrovalet,  
a.flagesta,  
a.fechvale,  
convert(varchar(10),a.horavale, 108) as horavale,  
a.PUnitario,  
c.descombu,  
round(a.PUnitario * a.cantidad, 3) as Total,  
e.rucclien,  
e.razonsoc,  
d.nropla81  
from TQTIKETS as a 
--inner join TQPRECOMB as b  on a.idprecio = b.idprecio 
inner join TQCOMBUS as c  
on a.idcombuS = c.idcombus INNER JOIN TQPLAAUT AS d  
ON a.idPlaAut = d.idPlaAut inner join TQCLIENTE as e  
on d.codage19 = e.rucclien left join DDFACTTR01 as f  
on a.nrofactu = f.nrodet01  
where a.fechvale between @FECHA_INI AND @FECHA_FIN  
AND e.rucclien = @RUCCLIE AND a.flagesta = @ESTADO  
order by d.nropla81,a.nrovalet
END  
  
IF @ESTADO = 'T'   
BEGIN  
select  
a.idtikets,  
a.idplaaut,  
a.idprecio,  
a.cantidad,  
f.nrofac01,  
a.fecfactu,  
a.nrovalet,  
a.flagesta,  
a.fechvale,  
convert(varchar(10),a.horavale, 108) as horavale,  
a.PUnitario,  
c.descombu,  
round(a.PUnitario * a.cantidad, 3) as Total,  
e.rucclien,  
e.razonsoc,  
d.nropla81  
from TQTIKETS as a 
--inner join TQPRECOMB as b  on a.idprecio = b.idprecio inner 
inner join TQCOMBUS as c  on a.idcombuS = c.idcombus INNER JOIN TQPLAAUT AS d  
ON a.idPlaAut = d.idPlaAut inner join TQCLIENTE as e  
on d.codage19 = e.rucclien left join DDFACTTR01 as f  
on a.nrofactu = f.nrodet01  
where a.fechvale between @FECHA_INI AND @FECHA_FIN  
AND e.rucclien = @RUCCLIE   
order by d.nropla81,a.nrovalet
END  
GO
/****** Object:  StoredProcedure [dbo].[sp_reporte_ticketesAnt]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_reporte_ticketesAnt]    
@FECHA_INI CHAR(8),    
@FECHA_FIN CHAR(8),    
@RUCCLIE CHAR(11),    
@ESTADO CHAR(1)    
as    
    
IF @ESTADO <> 'T'     
BEGIN    
select    
a.idtikets,    
a.idplaaut,    
a.idprecio,    
a.cantidad,    
f.nrofac01,    
a.fecfactu,    
a.nrovalet,    
a.flagesta,    
a.fechvale,    
convert(varchar(10),a.horavale, 108) as horavale,    
b.Precioco,    
c.descombu,    
round(b.Precioco * a.cantidad, 3) as Total,    
e.rucclien,    
e.razonsoc,    
d.nropla81    
from TQTIKETS as a   
inner join TQPRECOMB as b  on a.idprecio = b.idprecio   
inner join TQCOMBUS as c  on b.idcombuS = c.idcombus INNER JOIN TQPLAAUT AS d    
ON a.idPlaAut = d.idPlaAut inner join TQCLIENTE as e    
on d.codage19 = e.rucclien left join DDFACTTR01 as f    
on a.nrofactu = f.nrodet01    
where a.fechvale between @FECHA_INI AND @FECHA_FIN    
AND e.rucclien = @RUCCLIE AND a.flagesta = @ESTADO    
END    
    
IF @ESTADO = 'T'     
BEGIN    
select    
a.idtikets,    
a.idplaaut,    
a.idprecio,    
a.cantidad,    
f.nrofac01,    
a.fecfactu,    
a.nrovalet,    
a.flagesta,    
a.fechvale,    
convert(varchar(10),a.horavale, 108) as horavale,    
b.Precioco,    
c.descombu,    
round(b.Precioco * a.cantidad, 3) as Total,    
e.rucclien,    
e.razonsoc,    
d.nropla81    
from TQTIKETS as a   
inner join TQPRECOMB as b  on a.idprecio = b.idprecio    
inner join TQCOMBUS as c  on b.idcombuS = c.idcombus INNER JOIN TQPLAAUT AS d    
ON a.idPlaAut = d.idPlaAut inner join TQCLIENTE as e    
on d.codage19 = e.rucclien left join DDFACTTR01 as f    
on a.nrofactu = f.nrodet01    
where a.fechvale between @FECHA_INI AND @FECHA_FIN    
AND e.rucclien = @RUCCLIE     
END    

GO
/****** Object:  StoredProcedure [dbo].[SP_Resumen_Movimientos_Diarios]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Resumen_Movimientos_Diarios]  
  
   @dFecIni Char( 8 ),  
   @dFecFin Char( 8 ),  
   @cNroPla VarChar( 7 )  
  
As  
  
SET NOCOUNT ON  
  
/*  
Declare @dFecIni Char( 8 )  
Declare @dFecFin Char( 8 )  
Declare @cNroPla VarChar( 7 )  
  
Set @dFecIni = '20070101'  
Set @dFecFin = '20070301'  
Set @cNroPla =  'YI4980'  
*/  
  
If ( @cNroPla = '' ) Begin  
   Select Convert( Char( 8 ), fecgen01, 112 ) as FecGen01,   
          nropla01, a.idcircuito, b.codrut01 + ' - ' + b.desrut01 as desrut01,  Count( nrogui01 ) as NroMov  
   From dbo.DCGUITTR01  a   
        inner join dbo.CQCIRCUI01 b on a.idcircuito = b.idcircuito  
        inner join  dbo.TQCHOFER  c on a.brevet01 = c.brevete  
   Where Convert( Char( 8 ), fecgen01, 112 )between  @dFecIni And  @dFecFin  
   Group by Convert( Char( 8 ), fecgen01, 112 ), nropla01, a.idcircuito, desrut01, b.codrut01  
   Order by Convert( Char( 8 ), fecgen01, 112 ), nropla01, a.idcircuito, desrut01  
End  
Else Begin  
   Select Convert( Char( 8 ), fecgen01, 112 ) as FecGen01,  nropla01, 
	a.idcircuito,  b.codrut01 + ' - ' + b.desrut01 as desrut01, Count( nrogui01 ) as NroMov  
   From dbo.DCGUITTR01  a   
        inner join dbo.CQCIRCUI01 b on a.idcircuito = b.idcircuito  
        inner join  dbo.TQCHOFER  c on a.brevet01 = c.brevete  
   Where Convert( Char( 8 ), fecgen01, 112 )between  @dFecIni And  @dFecFin And  
         nropla01 = @cNroPla  
   Group by Convert( Char( 8 ), fecgen01, 112 ), nropla01, a.idcircuito, desrut01, b.codrut01
   Order by Convert( Char( 8 ), fecgen01, 112 ), nropla01, a.idcircuito, desrut01  
End  
  
  
  
SET NOCOUNT OFF  

GO
/****** Object:  StoredProcedure [dbo].[sp_rptListaSunad]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_rptListaSunad]  
@fechaini varchar(8),  
@fechaFin varchar(8)  
as  
select   
C.CODRUT01,  
TipoDocumento='31',  
SerieGRT='0' + substring(A.nrogui01,1,3),  
NroGRT=substring(A.nrogui01,4,7),  
'Dpto Pto Partida' =  C.PtoPartida,  
'Distrito Pto Partida' = C.DistPartida,  
'Dpto Pto Llegada' = C.PtoLlegada,  
'Distrito Pto Llegada' = C.DistLlegada,  
'Marca Veh.' = V.Marca,  
'Placa Veh.' = V.nropla81,  
'Nro Certif. Veh.' = V.Certificado,  
'RUC Remitente' = a.Client01,  
'Razón Social Cliente' = G.RAZONSOC,  
'Serie Factura' = '0' + substring(H.NroFac01,1,3),  
'Nro Factura' = substring(H.NroFac01,4,7),  
'V.Venta' = F.valfac01 * tipcam01,   
Igv = (f.totven01 - F.valfac01) * tipcam01,  
fecgen01,  
fecreg01,  
A.NroFact001,  
A.nrogui01, tipcam01  
from DCGUITTR01 AS A INNER JOIN TQPLAAUT AS V ON A.NROPLA01 = V.nropla81  
inner JOIN CQCIRCUI01 AS C ON A.IDCIRCUITO = C.IDCIRCUITO  
INNER JOIN TQCLIENTE AS G ON G.RUCCLIEN = A.CLIENT01  
INNER JOIN DDFACTTR01 AS H ON A.NRODET01 = H.NRODET01  
INNER join DCFACTTR01 as F on F.nrofac01  = H.NroFac01  
where fecreg01 between @FechaIni and @FechaFin  
order by A.IDCIRCUITO, fecreg01  
return 0  



GO
/****** Object:  StoredProcedure [dbo].[sp_TareaEnviaGuias_NoFacturadas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_TareaEnviaGuias_NoFacturadas]               
AS              
--exec sp_EjecutarDTS 'ListaGuias_Nofacturadas_Triton'              
exec master.dbo.xp_smtp_sendmail              
 @FROM   = N'aneptunia@neptunia.com.pe', --N'MyEmail@MyDomain.com',              
 @FROM_NAME  = N'Neptunia Servicio de Alertas', --N'Joe Mailman',              
 @TO   = N'Triton@neptunia.com.pe; almapc2002@hotmail.com; jeanfranz.rojas@gestionysistemas.com',   
 @replyto         = N'Triton@neptunia.com.pe',              
 @CC   = N'epalao@neptunia.com.pe',              
 --@BCC   = N'pmelendez@neptunia.com.pe',              
 @priority  = N'NORMAL',              
 @subject  = N'Lista de Guias No Facturadas',              
 @message  = N'Lista de Guias No Facturadas',              
 @messagefile  = N'',              
 @type   = N'text/plain',              
 @attachment  = N'\\neptunia1\Archivo\ListaGuiasNoFacturadas_Triton.xls',              
 @attachments  = N'',              
 @codepage  = 0,              
 @server   = N'correo.neptunia.com.pe'--N'mail.mydomain.com'              
  
GO
/****** Object:  StoredProcedure [dbo].[sp_TotalKmxCamionByFecha]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_TotalKmxCamionByFecha] --FMCR
--@Placa char(7),
--@Fecha char(8)
--as
--select sum(kilometros) as Total from DCGUITTR01 as a inner join CQCIRCUI01 as b on a.circui01 = b.codrut01
--where fecgen01 > @Fecha and nropla01 = @Placa
--return 0


--GO
/****** Object:  StoredProcedure [dbo].[sp_Trit_C5]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Trit_C5]
as
select * from CQTARCIR01 where idcircuito=5
GO
/****** Object:  StoredProcedure [dbo].[sp_Trit_C6]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Trit_C6]
as
select * from CQTARCIR01 where idcircuito=6
GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Agregar_Factura]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Triton_Factura_Agregar_Factura]  
@nrogui01 varchar(10),                    
@nrogui73 varchar(10),                    
@codcco06 varchar(8),                    
@navvia11 char(6) ,                    
@nropla01 char(7) ,                    
@fecgen01 char(17),                    
@client01 char(11),                    
@brevet01 char(9) ,                    
@idcircuito integer,                    
@codnav08 char(4) ,                    
@remolq73 char(10),                    
@nrodet01 int,                  
@flagEstra char(1),                  
@DesCircu varchar(100),                  
@PrecioCir decimal(15,2),                  
@Comision decimal (15,2),                  
@FlagVicon char(1),              
@observacion varchar(255),            
@IdTarifa int,        
@TipoMerc char(1),      
@Usucrea varchar(30),      
@PtoOrigen varchar(150),      
@PtoDestino varchar(150),      
@ValRef decimal(12,2),    
@peaje decimal(5,2),      
@PrecioCir_S decimal(12,2)                    
as    

if @PrecioCir is null
begin
	set @PrecioCir = 0
end

if @PrecioCir_S is null
begin
	set @PrecioCir_S = 0
end
                
insert into DCGUITTR01 (                    
nrogui01,                     
nrogui73,                     
codcco06,                    
navvia11,                    
nropla01,                    
fecgen01,                    
client01,                    
brevet01,                    
idcircuito,        
codnav08,                    
remolq73,                    
nrodet01,                  
flagEstra,                  
DesCircu,                  
PrecioCir,                  
Comision,                  
FlagVicon,              
observacion,            
IdTarifa,        
TipoMerc,      
Usucrea,      
fecreg01,      
PtoOrigen,      
PtoDestino,      
ValRef,    
peaje,  
PrecioCir_S      
)                    
values                    
(                    
@nrogui01,                     
@nrogui73,                     
@codcco06,                    
@navvia11,                    
@nropla01,                    
@fecgen01,      
@client01,                    
@brevet01,                    
@idcircuito,                   
@codnav08,                    
@remolq73,                    
@nrodet01,                    
@flagEstra,                  
@DesCircu,                  
@PrecioCir,                  
@Comision,                  
@FlagVicon,              
@observacion,            
@IdTarifa,        
@TipoMerc,      
@Usucrea,      
getdate(),      
@PtoOrigen,      
@PtoDestino,      
@ValRef,    
@peaje,    
@PrecioCir_S                  
)                    
return 0                    
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Agregar_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Triton_Factura_Agregar_Tarifa]  
@idcircuito int,
@flgigv01 char(1),  
@comision20 numeric(12,2),  
@comision40 numeric(12,2),  
@tarifa20 numeric(12,2),  
@tarifa40 numeric(12,2),  
@comisionxviaje char(1),  
@flagCirViaje char(1), 
@Usuario varchar(30), 
@valRef numeric(12,2),
@tarifa20S numeric(12,2),   
@tarifa40S numeric(12,2),     
@Idtarifa int output  
as  

insert into cqtarcir01  
(  
idcircuito,
--codrut01,  
flgigv01,  
comision20,  
comision40,  
tarifa20,  
tarifa40,  
comisionxviaje,  
Usuario,  
fecreg,
flagCirViaje,
valRef,
tarifa20_S,
tarifa40_S 
  
)  
Values  
( 
@idcircuito, 
--@codrut01,  
@flgigv01,  
@comision20,  
@comision40,  
@tarifa20,  
@tarifa40,  
@comisionxviaje,  
@Usuario,  
getdate(),
@flagCirViaje,
@valRef,
@tarifa20S,  
@tarifa40S    
  
)  
  
select @idtarifa = @@identity  

GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Lista_Guias_Soles]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_Triton_Factura_Lista_Guias_Soles]     --FMCR               
--@client01 char(11),                        
--@idcircuito int,                    
--@fecini char(8),                    
--@fecfin char(8),                
--@horaIni char(8),                
--@horaFin char(8),
--@Usuario varchar(30)                    

--as                              
--/*
--set @client01 = '20100010217'               
--set @idcircuito = '127'                  
--set @fecini = '20080901'                  
--set @fecfin = '20080930'           
--set @horaIni = '00:00:00'
--set @horaFin = '00:00:00'

--*/

--select nrogui01 , 
--nropla01 ,            
--brevet01 ,            
--fecgen01 ,            
--codnav08 ,            
--navvia11 ,            
--desrut01 , 
--codrut01 ,                     
--codtam01 ,    
--Count (nrogui01) as cantidad,
  

--case when flagvicon = 'S' then precioCir_S                    
--     when flagvicon = 'N' and codtam01 = '40' then precioCir_S                    
--     when flagvicon = 'N' and Count (nrogui01)= 0 then precioCir_S                     
--     when flagvicon = 'N' and Count (nrogui01)> 0 then precioCir_S * Count (nrogui01)                    
--     end as tarifa,                       
        
--numvia11 ,            
--centroCosto , 
--dc_tipo_identificacion_bien ,            
--codcco06 ,             
--codcon01 
--from ListaCircuitoManual
--where Usuario = @Usuario
--group by           
--nrogui01,                        
--Nropla01,                      
--Brevet01,                      
--fecgen01,          
--codnav08,                    
--navvia11,                     
--desrut01,                     
--codrut01,                     
--flagvicon,          
--numvia11,                    
--centroCosto,             
--dc_tipo_identificacion_bien,                    
--codcco06,                
--codcon01,          
--codtam01,          
--precioCir_S              
--order by                     
--fecgen01                    

--GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Listado_Factura_x_Fechas]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Triton_Factura_Listado_Factura_x_Fechas]
@sFecIni char(8),  
@sFecFin char(8)  
as
select substring(a.nrofac01,1,3) as Serie, substring(a.nrofac01,4,7) as numero, fecemi01, nombre, ruccli01, desart01, cantid01, Mon=
case moneda01 when '1' then 'Soles' else 'Dolares' end, preuni01, totven01, a.coduse01 
from DCFACTTR01  a (nolock)
inner join DDFACTTR01 b (nolock) on (a.nrofac01=b.nrofac01 and a.tipdoc01=b.tipdoc01)
inner join terminal..aaclientesaa c (nolock) on (a.ruccli01=c.contribuy)
where a.tipdoc01='01' and fecemi01>=@sFecIni and fecemi01<@sFecFin
GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Modifica_Tarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Triton_Factura_Modifica_Tarifa]  
@Idtarifa int,  
--@codrut01 char(3),  
@idcircuito int,
@flgigv01 char(1),  
@comision20 numeric(12,2),  
@comision40 numeric(12,2),  
@tarifa20 numeric(12,2),  
@tarifa40 numeric(12,2),  
@comisionxviaje char(1),  
@flagCirViaje char(1), 
@Usuario varchar(30),
@valRef numeric(12,2) , 
@tarifa20S numeric(12,2),  
@tarifa40S numeric(12,2)  
as  

update cqtarcir01 set  
idcircuito = @idcircuito,
flgigv01 = @flgigv01,  
comision20 = @comision20,  
comision40 = @comision40,  
tarifa20 = @tarifa20,  
tarifa40 = @tarifa40,  
comisionxviaje = @comisionxviaje,  
flagCirViaje = @flagCirViaje, 
valRef = @valRef,
usuario = @Usuario,  
fecreg = getdate(),
tarifa20_S = @tarifa20S,  
tarifa40_S = @tarifa40S    
where idtarifa = @idtarifa
GO
/****** Object:  StoredProcedure [dbo].[sp_Triton_Factura_Modificar_Guia]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Triton_Factura_Modificar_Guia]
@nrogui01 varchar(10),                    
@nrogui73 varchar(10),                    
@codcco06 varchar(8),                    
@navvia11 char(6) ,                    
@nropla01 char(7) ,                    
@fecgen01 char(17),                    
@client01 char(11),                    
@brevet01 char(9) ,                    
@idcircuito integer,                    
@codnav08 char(4) ,                    
@remolq73 char(10),                    
@nrodet01 int,                  
@flagEstra char(1),                  
@DesCircu varchar(100),                  
@PrecioCir decimal(15,2),                  
@PrecioCir_S decimal(15,2),                  
@Comision decimal (15,2),                  
@FlagVicon char(1),                  
@Observacion varchar(255),          
@IdTarifa as integer,      
@TipoMerc char(1),    
@usumod varchar (30),    
@PtoOrigen varchar(150),    
@PtoDestino varchar(150),    
@ValRef decimal(12,2),  
@Peaje decimal(5,2)  
as       
                 
UPDATE DCGUITTR01 SET              
nrogui73 = @nrogui73,                       
codcco06 = @codcco06,                        
navvia11 = @navvia11,                        
nropla01 = @nropla01,                        
fecgen01 = @fecgen01,                        
client01 = @client01,                        
brevet01 = @brevet01,                        
idcircuito = @idcircuito,      
codnav08 = @codnav08,                        
remolq73 = @remolq73,                        
nrodet01 = @nrodet01,                      
flagEstra = @flagEstra,                    
DesCircu = @DesCircu,                    
PrecioCir = @PrecioCir,                    
PrecioCir_S = @PrecioCir_S,                    
Comision = @Comision,                    
FlagVicon  = @FlagVicon,                  
observacion = @Observacion,            
idtarifa = @IdTarifa,          
TipoMerc = @TipoMerc,    
usumod = @usumod,    
fecmod01 = getdate(),    
PtoOrigen = @PtoOrigen,    
PtoDestino = @PtoDestino,    
ValRef = @ValRef,  
peaje = @peaje  
WHERE nrogui01 = @nrogui01                 
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[sp_UltimosValoresTkt]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_UltimosValoresTkt]
@IdPlaca int,
@Fecha varchar(8)
as
select fechvale, OActual, OactualTablero, Hactual   from TQTIKETS
where fechvale < '20050503' and idplaaut = 339
order by fechvale desc
GO
/****** Object:  StoredProcedure [dbo].[sp_ValidaGuiaxMesxAnio]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ValidaGuiaxMesxAnio]
@fecgen01 char(8),
@idcircuito int,
@codcon01 char(11),
@guiaN    char(10)

as
declare  @guia varchar(10)
declare  @circuito char(4)
declare  @glosa varchar(500)
declare  @fecha char(12)
declare  @usuario varchar(30)
declare  @crlf varchar(10)    
set @guia = ''
select @guia = a.nrogui01, @fecha = convert(char(12),fecgen01,103),@usuario = upper(rtrim(UsuCrea))
from DCGUITTR01 as a
inner join DDGUITTR01 as b on a.nrogui01 = b.nrogui01
where  month(convert(char(8),fecgen01,112)) = month(@fecgen01)
and    year(convert(char(8),fecgen01,112)) = year(@fecgen01)
and a.idcircuito = @idcircuito and b.codcon01 = @codcon01
and a.nrogui01 <> @guiaN and b.codcon01 <> 'XXXX'

if @guia <> '' 
begin
-- set @circuito  = convert(char(4),@idcircuito)
select @circuito = codrut01  from cqcircui01 where  idcircuito = @idcircuito
 select @crlf = char(10)+char(13)    
 set @glosa = 'EL USUARIO: ' + @usuario + ' ACABA DE GENERAR LA GUIA: ' + @guiaN + ', PARA EL CONTENEDOR: ' + @codcon01 
 set @glosa = @glosa + ' EN EL CIRCUITO: ' + @circuito + ',' + @crlf + ' EXISTIENDO UNA GUIA: ' + @guia 
 set @glosa = @glosa + ' CON EL MISMO CONTENEDOR Y CIRCUITO EN LA FECHA : ' + @fecha 
 exec sp_Alertas_Triton_Guias 'ALERTA GUIAS TRITON',@glosa

end

return 0
GO
/****** Object:  StoredProcedure [dbo].[sp_VerifaTarifa]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_VerifaTarifa]
@IdTarifa int
as  
select count(IdTarifa) as Cantidad from DCGUITTR01
where idTarifa = @IdTarifa  

GO
/****** Object:  StoredProcedure [dbo].[usp_Agregar_ConfVehicular]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Agregar_ConfVehicular]
(@descripcion varchar(10),
@cargaUtil decimal(12,2),
@usuario varchar(30),
@idconf int output)
AS

INSERT INTO TQCONFVEHIC
(descripcion,
cargautil,
usuario,
fecMod)
VALUES
(@descripcion,
@cargaUtil,
@usuario,
getdate())

SELECT @idconf = @@identity  

GO
/****** Object:  StoredProcedure [dbo].[USP_ARMARTRAMA_CANCELACION]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_ARMARTRAMA_CANCELACION '0090010532','01'
ALTER PROCEDURE [dbo].[USP_ARMARTRAMA_CANCELACION]
@NROFAC VARCHAR(10)
,@TIPO VARCHAR(2)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @1_FECHA_BAJA VARCHAR(10)
	,@2_FECHAEMISION VARCHAR(10)
	,@3_ID VARCHAR(25)
	
	,@4_NAME_EMISOR VARCHAR(100)
	,@5_NAME_COMERCIAL VARCHAR(100)
	,@6_RUC_EMISOR VARCHAR(11)
	,@7_COD_UBIGEO VARCHAR(6)
	,@8_DIR_EMISOR VARCHAR(100)
	,@10_DEP_EMISOR VARCHAR(30)
	,@11_PROV_EMISOR VARCHAR(30)
	,@12_DIST_EMISOR VARCHAR(30)
	,@13_PAIS_EMISOR VARCHAR(30)
	,@14_USUARIO_SOL VARCHAR(30)
	,@15_CLAVE_SOL VARCHAR(30)
	
	,@17_TIP_DOC VARCHAR(2)
	,@18_SERIE VARCHAR(4)
	,@19_CORRELATIVO VARCHAR(8)
	,@20_MOTIVO VARCHAR(35)
	
	DECLARE @DOC_ANTERIOR VARCHAR(13)
	,@TIP_DOC_ANTERIOR VARCHAR(2)
	,@TIPO_DOCUMENTO VARCHAR(2)
	
	IF @TIPO = '07' OR @TIPO = '08'
	BEGIN
		SELECT @DOC_ANTERIOR = nroRef01
		FROM DCFACTTR01 WITH (NOLOCK)
		WHERE nrofac01 = @NROFAC AND tipdoc01 = @TIPO
		
		SELECT @TIP_DOC_ANTERIOR = tipdoc01
		FROM DCFACTTR01 WITH (NOLOCK)
		WHERE nrofac01 = @DOC_ANTERIOR AND tipdoc01 = '01'
		
		IF @TIP_DOC_ANTERIOR = '01'
		BEGIN
			SET @18_SERIE = 'F' + SUBSTRING(@NROFAC,1,3)
		END
		IF @TIP_DOC_ANTERIOR = '03'
		BEGIN
			SET @18_SERIE = 'B' + SUBSTRING(@NROFAC,1,3)
		END
	END
	ELSE
	BEGIN
		IF @TIPO = '01'
		BEGIN
			SET @18_SERIE = 'F' + SUBSTRING(@NROFAC,1,3)
		END
		IF @TIPO = '03'
		BEGIN
			SET @18_SERIE = 'B' + SUBSTRING(@NROFAC,1,3)
		END
	END

	--//DATOS DE CABECERA
	SELECT 
	@1_FECHA_BAJA = ISNULL(CONVERT(VARCHAR(10), GETDATE(), 103),'')
	,@2_FECHAEMISION = ISNULL(CONVERT(VARCHAR(10), fecemi01, 103),'')
	,@17_TIP_DOC = ISNULL(A.tipdoc01,'')
	,@19_CORRELATIVO = RIGHT('00000000' + ltrim(rtrim(SUBSTRING(@NROFAC,4,7))), 8)
	,@20_MOTIVO = 'CANCELACION'
	FROM DCFACTTR01 A WITH (NOLOCK)
	LEFT JOIN TQCLIENTE B WITH (NOLOCK) ON A.ruccli01 = B.rucclien
	WHERE nrofac01 = @NROFAC AND tipdoc01 = @TIPO
	--//
	
	--//DATOS DEL EMISOR
	SELECT 
	@4_NAME_EMISOR = LTRIM(RTRIM(ISNULL(razonsoc,'')))
	,@5_NAME_COMERCIAL = LTRIM(RTRIM(ISNULL(razonsoc,'')))
	,@6_RUC_EMISOR = ISNULL(rucclien,'')
	,@7_COD_UBIGEO = '70101'
	,@8_DIR_EMISOR = LTRIM(RTRIM(ISNULL(direcci0,'')))
	,@10_DEP_EMISOR = 'CALLAO'
	,@11_PROV_EMISOR = 'CALLAO'
	,@12_DIST_EMISOR = 'CALLAO'
	,@13_PAIS_EMISOR = 'PE'
	,@14_USUARIO_SOL = '20138322000'
	,@15_CLAVE_SOL = 'w9PJpb2UnI'
	FROM TQCLIENTE WITH (NOLOCK) 
	WHERE rucclien = '20138322000' --RUC TRITON
	--// 
	
	--//OBTENER ID DE CANCELACION
	DECLARE @DAT VARCHAR(15)
	EXEC USP_OBTENER_ID_CANCELACION @DAT OUT
	SET @3_ID = 'RA-' + CONVERT(VARCHAR(8),GETDATE(),112) + '-' + @DAT
	--//
	
	--//ARMAR TRAMAS CON COMAS
	
	--//DATOS DE LA FACTURA
	DECLARE @TRAMA VARCHAR(MAX)
	SET @TRAMA = ''
	
	SET @TRAMA = @TRAMA + ISNULL(@1_FECHA_BAJA,'') + ',' + ISNULL(@2_FECHAEMISION,'') + ',' + LTRIM(RTRIM(ISNULL(@3_ID,''))) + ',' + CHAR(13)
	
	--//DATOS DEL EMISOR
	+ REPLACE(ISNULL(@4_NAME_EMISOR,''),',','') + ',' + REPLACE(ISNULL(@5_NAME_COMERCIAL,''),',','') + ',' + ISNULL(@6_RUC_EMISOR,'') + ',' + ISNULL(@7_COD_UBIGEO,'') + ',' 
	+ REPLACE(ISNULL(@8_DIR_EMISOR,''),',','') + ',,' + ISNULL(@10_DEP_EMISOR,'') + ',' + ISNULL(@11_PROV_EMISOR,'') + ',' + REPLACE(ISNULL(@12_DIST_EMISOR,''),',','') + ','
	+ ISNULL(@13_PAIS_EMISOR,'') + ',' + ISNULL(@14_USUARIO_SOL,'') + ',' + ISNULL(@15_CLAVE_SOL,'') + ',' + CHAR(13)
	
	--//DATOS DEL DOCUMENTO
	+ '1,' + ISNULL(@17_TIP_DOC,'') + ',' + ISNULL(@18_SERIE,'') + ',' + ISNULL(@19_CORRELATIVO,'') + ',' 
	+ ISNULL(@20_MOTIVO,'')    
	
	SELECT @TRAMA AS TRAMA
	PRINT @TRAMA
	
SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_ARMARTRAMA_FE_FACT_BOL]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_ARMARTRAMA_FE_FACT_BOL '0090013283','01'      
ALTER PROCEDURE [dbo].[USP_ARMARTRAMA_FE_FACT_BOL] @NROFAC VARCHAR(10)
	,@TIPO VARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @1_FECHAEMISION VARCHAR(10)
		,@2_NRODOCUMENTO VARCHAR(13)
		,@3_TIPDOC VARCHAR(2)
		,@4_TIPMONEDA VARCHAR(3)
		,@5_SUMATORIA_IGV VARCHAR(15)
		,@6_SUBTOTAL_IGV VARCHAR(15)
		,@7_TIPMONIGV VARCHAR(3)
		,@14_IMPVENTA VARCHAR(15)
		,@22_TOTGRAV VARCHAR(15)
		,@23_TOTINAFEC VARCHAR(15)
		,@26_SUBTOTAL_VENTA VARCHAR(15)
		,@31_DET_MONTO DECIMAL(10, 2)
		,@32_DET_PORCENTAJE VARCHAR(2)
		,@33_DET_NUM_BANCO VARCHAR(15)
		,@34_DET_MONTO_TOTAL DECIMAL(10, 2)
		,@38_FECHA_VENCIMIENTO VARCHAR(10)
		,@39_PTO_PARTIDA VARCHAR(100)
		,@42_PTO_PARTIDA_DEP VARCHAR(30)
		,@43_PTO_PARTIDA_DIST VARCHAR(30)
		,@46_PTO_LLEGADA VARCHAR(100)
		,@49_PTO_LLEGADA_DEP VARCHAR(30)
		,@50_PTO_LLEGADA_DIST VARCHAR(30)
		,@52_VEH_PLACA VARCHAR(10)
		,@54_VEHICULO_MARCA VARCHAR(50)
		,@55_NRO_LICENCIA VARCHAR(30)
		,@56_TRANS_RUC VARCHAR(11)
		,@57_TRANS_TIP_DOC VARCHAR(2)
		,@58_TRANS_RAZON_SOCIAL VARCHAR(100)
		,@59_REMISION_NRO VARCHAR(100)
		,@60_REMISION_TIPO VARCHAR(2)
		,@61_OTRA_OP_DOC VARCHAR(15)
		,@62_OTRO_OP_TIPO VARCHAR(2)
		,@64_NAME_EMISOR VARCHAR(100)
		,@65_NAME_COMERCIAL VARCHAR(100)
		,@66_RUC_EMISOR VARCHAR(11)
		,@67_COD_UBIGEO VARCHAR(6)
		,@68_DIR_EMISOR VARCHAR(100)
		,@70_DEP_EMISOR VARCHAR(30)
		,@71_PROV_EMISOR VARCHAR(30)
		,@72_DIST_EMISOR VARCHAR(30)
		,@73_PAIS_EMISOR VARCHAR(30)
		,@74_USUARIO_SOL VARCHAR(30)
		,@75_CLAVE_SOL VARCHAR(30)
		,@76_RUC_RECEP VARCHAR(11)
		,@77_TIP_DOC_RECEP VARCHAR(1)
		,@78_RAZONSOCIAL_RECEP VARCHAR(100)
		,@79_NOMBRE_COMER_RECEP VARCHAR(100)
		,@81_DIRECCION_RECEP VARCHAR(100)
		,@86_PAIS_RECEP VARCHAR(2)
		,@87_CORREO_RECEP VARCHAR(100)
		,@88_LEYENDA_1000 VARCHAR(250)
		,@125_INF_ATENCION VARCHAR(50)
		,@126_INF_COND_PAGO VARCHAR(150)
		,@127_INF_ORDEN_COMPRA VARCHAR(150)
		,@128_INF_OBSERVACIONES VARCHAR(255)
		,@129_INF_FECHA_CANCELACION VARCHAR(10)
		,@155_ID_LINEA VARCHAR(3)
		,@156_UNIDAD_LINEA VARCHAR(100)
		,@157_CANT_LINEA VARCHAR(10)
		,@158_DESC_LINEA VARCHAR(250)
		,@159_PRECIO_VENTA_LINEA VARCHAR(25)
		,@160_CODIGO_PRECIO_VENTA VARCHAR(2)
		,@163_MONTO_TOTAL_IGV_LINEA VARCHAR(15)
		,@164_SUB_TOTAL_IGV_LINEA VARCHAR(15)
		,@165_TIPO_AFEC_IGV_LINEA VARCHAR(2)
		,@166_TIP_TRIBUTO_IGV VARCHAR(4)
		,@167_PROCENTAJE_LINEA VARCHAR(2)
		,@174_VAL_UNI_LINEA VARCHAR(15)
		,@175_VAL_VENTA_LINEA VARCHAR(15)
		,@177_TOTAL_LINEA VARCHAR(15)
		,@TOTAL_LINEA_IGV VARCHAR(15)

	--//OBTENER CODIFICACION DE FACTURA O BOLETA      
	CREATE TABLE #DOCUMENTO (NRODOCUMENTO VARCHAR(13))

	INSERT INTO #DOCUMENTO
	EXEC USP_CODIGO_NRODOCUMENTO @NROFAC
		,@TIPO

	IF @TIPO = '01'
	BEGIN
		SELECT @2_NRODOCUMENTO = NRODOCUMENTO
		--SELECT @2_NRODOCUMENTO = NRODOCUMENTO    
		FROM #DOCUMENTO
	END

	IF @TIPO = '03'
	BEGIN
		SELECT @2_NRODOCUMENTO = NRODOCUMENTO
		--SELECT @2_NRODOCUMENTO = NRODOCUMENTO    
		FROM #DOCUMENTO
	END

	DROP TABLE #DOCUMENTO

	--//      
	--//DATOS DE CABECERA      
	SELECT @1_FECHAEMISION = ISNULL(CONVERT(VARCHAR(10), A.fecemi01, 103), '')
		,@3_TIPDOC = ISNULL(CAST(CAST(A.tipdoc01 AS INT) AS VARCHAR), '')
		,@4_TIPMONEDA = CASE 
			WHEN A.moneda01 = 1
				THEN 'PEN'
			WHEN A.moneda01 = 2
				THEN 'USD'
			ELSE ''
			END
		,@5_SUMATORIA_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
		,@6_SUBTOTAL_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
		--,@163_MONTO_TOTAL_IGV_LINEA = CAST((A.totven01 - A.valfac01) AS VARCHAR)      
		--,@164_SUB_TOTAL_IGV_LINEA = CAST((A.totven01 - A.valfac01) AS VARCHAR)      
		,@7_TIPMONIGV = CASE 
			WHEN A.moneda01 = 1
				THEN 'PEN'
			WHEN A.moneda01 = 2
				THEN 'USD'
			ELSE ''
			END
		,@14_IMPVENTA = CAST(A.totven01 AS VARCHAR)
		,@22_TOTGRAV = CASE 
			WHEN A.afecim01 = '1'
				THEN CAST(A.valfac01 AS VARCHAR)
			ELSE ''
			END
		,@23_TOTINAFEC = CASE 
			WHEN A.afecim01 = '0'
				THEN CAST(A.valfac01 AS VARCHAR)
			ELSE ''
			END
		,@26_SUBTOTAL_VENTA = CAST(valfac01 AS VARCHAR)
		--//DATOS RECEPTOR      
		,@76_RUC_RECEP = CASE 
			WHEN A.tipdoc01 = '01'
				THEN ISNULL(A.ruccli01, '')
			ELSE (
					CASE 
						WHEN SUBSTRING(A.ruccli01, 1, 3) = '000'
							THEN SUBSTRING(A.ruccli01, 4, 8)
						ELSE ISNULL(A.ruccli01, '')
						END
					)
			END
		,@77_TIP_DOC_RECEP = CASE 
			WHEN A.tipdoc01 = '01'
				THEN '6'
			ELSE '1'
			END
		,@78_RAZONSOCIAL_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc, '')))
		,@79_NOMBRE_COMER_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc, '')))
		,@81_DIRECCION_RECEP = LTRIM(RTRIM(ISNULL(B.direcci0, '')))
		,@86_PAIS_RECEP = ISNULL(B.codpai07, '')
		,@87_CORREO_RECEP = CASE 
			WHEN ISNULL(B.correo, '') = ''
				THEN 'letty.valderrama@tritontransports.com.pe'
			ELSE LTRIM(RTRIM(ISNULL(B.correo, '')))
			END
		,@88_LEYENDA_1000 = LTRIM(RTRIM(ISNULL(C.total_letras_FE, '')))
		,@31_DET_MONTO = CASE 
			WHEN ISNULL(C.flgdetraccion_FE, 0) > 0
				THEN ROUND((A.totven01 * C.porc_det_FE), 2, 2)
			ELSE 0
			END
		,@32_DET_PORCENTAJE = CASE 
			WHEN ISNULL(C.flgdetraccion_FE, 0) > 0
				THEN CAST(CAST((C.porc_det_FE * 100) AS INT) AS VARCHAR)
			ELSE ''
			END
		,@33_DET_NUM_BANCO = CASE 
			WHEN ISNULL(C.flgdetraccion_FE, 0) > 0
				THEN '00000362085'
			ELSE ''
			END
		,@34_DET_MONTO_TOTAL = CASE 
			WHEN ISNULL(C.flgdetraccion_FE, 0) > 0
				THEN (A.totven01 - ROUND((A.totven01 * C.porc_det_FE), 2, 2))
			ELSE 0
			END
		,@38_FECHA_VENCIMIENTO = ISNULL(CONVERT(VARCHAR(10), A.fecven01, 103), '')
		,@125_INF_ATENCION = A.atenci01
		,@126_INF_COND_PAGO = ISNULL(C.condicion_pago_FE, '')
		,@127_INF_ORDEN_COMPRA = ISNULL(C.orden_compra_FE, '')
		,@128_INF_OBSERVACIONES = REPLACE(ISNULL(A.observ01, ''), ',', ' ')
		,@129_INF_FECHA_CANCELACION = ''
		,@59_REMISION_NRO = LTRIM(RTRIM(ISNULL(C.guia_remision_FE, '')))
	FROM DCFACTTR01 A WITH (NOLOCK)
	LEFT JOIN TQCLIENTE B WITH (NOLOCK) ON A.ruccli01 = B.rucclien
	LEFT JOIN DCFACTTR01_FE C WITH (NOLOCK) ON LTRIM(RTRIM(C.nrofac_FE)) = A.nrofac01
		AND C.tipodoc_FE = A.tipdoc01
	WHERE nrofac01 = @NROFAC
		AND tipdoc01 = @TIPO

	--//      
	--//DATOS DEL EMISOR      
	SELECT @64_NAME_EMISOR = LTRIM(RTRIM(ISNULL(razonsoc, '')))
		,@65_NAME_COMERCIAL = LTRIM(RTRIM(ISNULL(razonsoc, '')))
		,@66_RUC_EMISOR = ISNULL(rucclien, '')
		,@67_COD_UBIGEO = '70101'
		,@68_DIR_EMISOR = LTRIM(RTRIM(ISNULL(direcci0, '')))
		,@70_DEP_EMISOR = 'CALLAO'
		,@71_PROV_EMISOR = 'CALLAO'
		,@72_DIST_EMISOR = 'CALLAO'
		,@73_PAIS_EMISOR = 'PE'
		,@74_USUARIO_SOL = '20138322000'
		,@75_CLAVE_SOL = 'd1d26c06e65b8f01'
	FROM TQCLIENTE WITH (NOLOCK)
	WHERE rucclien = '20138322000' --RUC TRITON      
		--//       

	--//DATOS DE GUIA      
	SELECT @39_PTO_PARTIDA = LTRIM(RTRIM(ISNULL(B.PtoOrigen, '')))
		,@42_PTO_PARTIDA_DEP = LTRIM(RTRIM(ISNULL(B.PtoPartida, '')))
		,@43_PTO_PARTIDA_DIST = LTRIM(RTRIM(ISNULL(B.DistPartida, '')))
		,@46_PTO_LLEGADA = LTRIM(RTRIM(ISNULL(B.PtoDestino, '')))
		,@49_PTO_LLEGADA_DEP = LTRIM(RTRIM(ISNULL(B.PtoLlegada, '')))
		,@50_PTO_LLEGADA_DIST = LTRIM(RTRIM(ISNULL(B.DistLlegada, '')))
		,@52_VEH_PLACA = LTRIM(RTRIM(ISNULL(A.nropla01, '')))
		,@54_VEHICULO_MARCA = LTRIM(RTRIM(ISNULL(C.Marca, '')))
		,@55_NRO_LICENCIA = LTRIM(RTRIM(ISNULL(A.brevet01, '')))
		,@56_TRANS_RUC = LTRIM(RTRIM(ISNULL(C.codage19, '')))
		,@57_TRANS_TIP_DOC = '06'
		,@58_TRANS_RAZON_SOCIAL = LTRIM(RTRIM(ISNULL(D.razonsoc, '')))
		--,@59_REMISION_NRO = LTRIM(RTRIM(ISNULL(A.nrogui01,'')))      
		,@60_REMISION_TIPO = '09'
		,@61_OTRA_OP_DOC = LTRIM(RTRIM(ISNULL(A.nrogui73, '')))
		,@62_OTRO_OP_TIPO = '09'
	FROM DCGUITTR01 A WITH (NOLOCK)
	LEFT JOIN CQCIRCUI01 B WITH (NOLOCK) ON A.idcircuito = B.idcircuito
	LEFT JOIN TQPLAAUT C WITH (NOLOCK) ON C.nropla81 = A.nropla01
	LEFT JOIN TQCLIENTE D WITH (NOLOCK) ON D.rucclien = C.codage19
	WHERE nrodet01 IN (
			SELECT nrodet01
			FROM DDFACTTR01
			WHERE nrofac01 = @NROFAC
				AND tipdoc01 = @TIPO
			)

	--//      
	--//DATOS DEL DETALLE      
	SELECT B.afecim01
		,CAST(SUM(A.cantid01) AS INT) AS cantid01
		--,CAST(A.cantid01 AS INT) AS cantid01    
		,A.desart01
		,CAST(A.preuni01 AS DECIMAL(10, 2)) AS preuni01
		,SUM(B.totven01) AS totven01
		--,B.totven01 AS totven01    
		,B.impven01
		,IDENTITY(INT, 1, 1) AS ID
	INTO #DETALLE
	FROM DDFACTTR01 A WITH (NOLOCK)
	INNER JOIN DCFACTTR01 B WITH (NOLOCK) ON A.nrofac01 = B.nrofac01
		AND A.tipdoc01 = B.tipdoc01
	WHERE A.nrofac01 = @NROFAC
		AND A.tipdoc01 = @TIPO
	GROUP BY B.afecim01
		,A.desart01
		,A.preuni01
		,B.impven01

	--//      
	--//ARMAR TRAMAS CON COMAS      
	DECLARE @TRAMA VARCHAR(MAX)

	SET @TRAMA = ''
	--//DATOS DE LA FACTURA      
	SET @TRAMA = @TRAMA + ISNULL(@1_FECHAEMISION, '') + ',' + ISNULL(@2_NRODOCUMENTO, '') + ',' + ISNULL(@3_TIPDOC, '') + ',' + ISNULL(@4_TIPMONEDA, '') + ',' + ISNULL(@5_SUMATORIA_IGV, '') + ',' + ISNULL(@6_SUBTOTAL_IGV, '') + ',' + ISNULL(@7_TIPMONIGV, '') + ',,,,,,,' + ISNULL(@14_IMPVENTA, '') + ',,,,,,,,' + ISNULL(@22_TOTGRAV, '') + ',' + ISNULL(@23_TOTINAFEC, '') + ',,,' + ISNULL(@26_SUBTOTAL_VENTA, '') + ',,,,,' + CASE 
			WHEN ISNULL(@31_DET_MONTO, 0) = 0
				THEN ''
			ELSE CAST(@31_DET_MONTO AS VARCHAR)
			END + ',' + ISNULL(@32_DET_PORCENTAJE, '') + ',' + ISNULL(@33_DET_NUM_BANCO, '') + ',' + CASE 
			WHEN ISNULL(@34_DET_MONTO_TOTAL, 0) = 0
				THEN ''
			ELSE CAST(@34_DET_MONTO_TOTAL AS VARCHAR)
			END + ',,,,' + @38_FECHA_VENCIMIENTO + CHAR(13) + ','
		--//PARTIDA GUIAS      
		--+ ISNULL(@39_PTO_PARTIDA,'') + ',,,' + ISNULL(@42_PTO_PARTIDA_DEP,'') + ',' + ISNULL(@43_PTO_PARTIDA_DIST,'') + ',,,' + ISNULL(@46_PTO_LLEGADA,'') + ',,,'      
		--+ ISNULL(@49_PTO_LLEGADA_DEP,'') + ',' + ISNULL(@50_PTO_LLEGADA_DIST,'') + ',,' + ISNULL(@52_VEH_PLACA,'') + ',,' + ISNULL(@54_VEHICULO_MARCA,'') + ','      
		--+ ISNULL(@55_NRO_LICENCIA,'') + ',' + ISNULL(@56_TRANS_RUC,'') + ',' + ISNULL(@57_TRANS_TIP_DOC,'') + ',' + ISNULL(@58_TRANS_RAZON_SOCIAL,'') + ','      
		--+ ISNULL(@59_REMISION_NRO,'') + ',' + ISNULL(@60_REMISION_TIPO,'') + ',' + ISNULL(@61_OTRA_OP_DOC,'') + ',' + ISNULL(@62_OTRO_OP_TIPO,'') + ',,'      
		+ ',,,,,,,,,,,,,,,,,,,,' + CHAR(13)
		--//GUIA DE REMISION      
		+ ISNULL(@59_REMISION_NRO, '') + ',' + CASE 
			WHEN ISNULL(@59_REMISION_NRO, '') <> ''
				THEN '09'
			ELSE ''
			END + ',,,' + CASE 
			WHEN ISNULL(@59_REMISION_NRO, '') <> ''
				THEN 'ATTACH_DOC'
			ELSE ''
			END + CHAR(13)
		--//DATOS DEL EMISOR      
		+ REPLACE(ISNULL(@64_NAME_EMISOR, ''), ',', ' ') + ',' + REPLACE(ISNULL(@65_NAME_COMERCIAL, ''), ',', ' ') + ',' + ISNULL(@66_RUC_EMISOR, '') + ',' 
		+ ISNULL(@67_COD_UBIGEO, '') + ',' + REPLACE(ISNULL(@68_DIR_EMISOR, ''), ',', ' ') + ',,' + ISNULL(@70_DEP_EMISOR, '') + ',' + ISNULL(@71_PROV_EMISOR, '') + ',' 
		+ ISNULL(@72_DIST_EMISOR, '') + ',' + ISNULL(@73_PAIS_EMISOR, '') + ',' + ISNULL(@74_USUARIO_SOL, '') + ',' + ISNULL(@75_CLAVE_SOL, '') + ',' + CHAR(13)
		--//DATOS DEL CLIENTE      
		+ LTRIM(RTRIM(ISNULL(@76_RUC_RECEP, ''))) + ',' + ISNULL(@77_TIP_DOC_RECEP, '') + ',' + REPLACE(ISNULL(@78_RAZONSOCIAL_RECEP, ''), ',', ' ') + ',' + REPLACE(ISNULL(@79_NOMBRE_COMER_RECEP, ''), ',', ' ') + ',,' 
		+ CASE 
			WHEN ISNULL(@81_DIRECCION_RECEP, '') = ''
				OR @81_DIRECCION_RECEP = '.'
				THEN 'DIRECCION'
			ELSE REPLACE(ISNULL(@81_DIRECCION_RECEP, ''), ',', ' ')
			END

	IF @TIPO = '01'
	BEGIN
		SET @TRAMA = @TRAMA + ',,,,,' + ISNULL(@86_PAIS_RECEP, '') + ',' + ISNULL(@87_CORREO_RECEP, '') + ',' + CHAR(13)
	END
	ELSE
	BEGIN
		SET @TRAMA = @TRAMA + ',,' + ISNULL(@86_PAIS_RECEP, '') + ',' + ISNULL(@87_CORREO_RECEP, '') + ',' + CHAR(13)
	END

	--//LEYANDAS SUNAT 37      
	SET @TRAMA = @TRAMA + REPLACE(@88_LEYENDA_1000, ',', ' ') + ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' + CHAR(13)
	--//INFORMACION ADICIONAL      
	SET @TRAMA = @TRAMA + LTRIM(RTRIM(ISNULL(REPLACE(@125_INF_ATENCION, ',', ' '), ''))) + ',' + LTRIM(RTRIM(ISNULL(@126_INF_COND_PAGO, ''))) + ',' + LTRIM(RTRIM(ISNULL(@127_INF_ORDEN_COMPRA, ''))) + ',' + LTRIM(RTRIM(REPLACE(REPLACE(@128_INF_OBSERVACIONES, CHAR(10), ' '), CHAR(13), ' '))) + ',' + ISNULL(@129_INF_FECHA_CANCELACION, '') + ',,,,,,,,,,,,,,,,,,,,,,,,,,' + CHAR(13)

	--//DATOS DEL PRODUCTO      
	DECLARE @ICONT INT
		,@ICONT_TOT INT
		,@MONTO_TOTAL_IGV_LINEA_DEC DECIMAL(10, 2)
		,@TOTAL_LINEA_IGV_DEC DECIMAL(10, 2)
		,@TOTAL_LINEA_DEC DECIMAL(10, 2)
		,@IGV_PRECIO_UNITARIO DECIMAL(10, 2)
		,@VAL_UNI_LINEA DECIMAL(10, 2)

	SET @ICONT = 1

	SELECT @ICONT_TOT = COUNT(*)
	FROM #DETALLE

	WHILE @ICONT <= @ICONT_TOT
	BEGIN
		SELECT @155_ID_LINEA = CAST(@ICONT AS VARCHAR)
			,@156_UNIDAD_LINEA = 'UNID'
			,@157_CANT_LINEA = CAST(CAST(cantid01 AS INT) AS VARCHAR)
			,@158_DESC_LINEA = LTRIM(RTRIM(ISNULL(desart01, '')))
			,@160_CODIGO_PRECIO_VENTA = '01'
			,@165_TIPO_AFEC_IGV_LINEA = CASE 
				WHEN afecim01 = '0'
					THEN '30'
				ELSE '10'
				END
			,@166_TIP_TRIBUTO_IGV = '1000'
			,@167_PROCENTAJE_LINEA = CAST((impven01 * 100) AS VARCHAR) --'18'      
			,@174_VAL_UNI_LINEA = CAST(preuni01 AS VARCHAR)
			,@175_VAL_VENTA_LINEA = CAST((cantid01 * preuni01) AS VARCHAR)
			,@IGV_PRECIO_UNITARIO = CASE 
				WHEN afecim01 = '1'
					THEN ROUND((preuni01 * impven01), 2, 2)
				ELSE 0
				END
			,@VAL_UNI_LINEA = preuni01
			,@TOTAL_LINEA_DEC = ROUND((cantid01 * preuni01), 2, 2)
			,@MONTO_TOTAL_IGV_LINEA_DEC = CASE 
				WHEN afecim01 = '1'
					THEN ROUND(((cantid01 * preuni01) * impven01), 2, 2)
				ELSE 0
				END
		FROM #DETALLE
		WHERE ID = @ICONT

		SET @159_PRECIO_VENTA_LINEA = CAST((@VAL_UNI_LINEA + @IGV_PRECIO_UNITARIO) AS VARCHAR)
		SET @163_MONTO_TOTAL_IGV_LINEA = CAST(@MONTO_TOTAL_IGV_LINEA_DEC AS VARCHAR)
		SET @164_SUB_TOTAL_IGV_LINEA = CAST(@IGV_PRECIO_UNITARIO AS VARCHAR)
		SET @TOTAL_LINEA_IGV_DEC = @TOTAL_LINEA_DEC + @MONTO_TOTAL_IGV_LINEA_DEC
		SET @177_TOTAL_LINEA = CAST(@TOTAL_LINEA_IGV_DEC AS VARCHAR)
		SET @TRAMA = @TRAMA + ISNULL(@155_ID_LINEA, '') + ',' + ISNULL(@156_UNIDAD_LINEA, '') + ',' + ISNULL(@157_CANT_LINEA, '') + ',' + REPLACE(ISNULL(@158_DESC_LINEA, '') ,',',' ')
		+ ',' + ISNULL(@159_PRECIO_VENTA_LINEA, '') + ',' + ISNULL(@160_CODIGO_PRECIO_VENTA, '') + ',,,' + ISNULL(@163_MONTO_TOTAL_IGV_LINEA, '') + ',' + ISNULL(@163_MONTO_TOTAL_IGV_LINEA, '') 
		+ ',' + ISNULL(@165_TIPO_AFEC_IGV_LINEA, '') + ',' + ISNULL(@166_TIP_TRIBUTO_IGV, '') + ',' + ISNULL(@167_PROCENTAJE_LINEA, '') + ',,,,,,,' 
		+ ISNULL(@174_VAL_UNI_LINEA, '') + ',' + ISNULL(@175_VAL_VENTA_LINEA, '') + ',,' + ISNULL(@177_TOTAL_LINEA, '') + ',,,,,,,,,,,' + CHAR(13)
		--IF @ICONT = @ICONT_TOT      
		--BEGIN      
		-- SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' --//SEPARADOR DE ITEM      
		--END      
		--ELSE      
		--BEGIN      
		-- SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' + ',' + CHAR(13) --//SEPARADOR DE ITEM      
		--END      
		SET @ICONT = @ICONT + 1
	END

	SET @TRAMA = @TRAMA + 'FF00FF'

	DROP TABLE #DETALLE

	PRINT @TRAMA

	SELECT @TRAMA AS TRAMA

	SET NOCOUNT OFF;
END
	--GO      
	--GRANT ALL ON USP_ARMARTRAMA_FE_FACT_BOL TO PUBLIC      
GO
/****** Object:  StoredProcedure [dbo].[USP_ARMARTRAMA_FE_FACT_BOL_NEW]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_ARMARTRAMA_FE_FACT_BOL_NEW '0090013102','01'
ALTER PROCEDURE [dbo].[USP_ARMARTRAMA_FE_FACT_BOL_NEW]
@NROFAC VARCHAR(10)
,@TIPO VARCHAR(2)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE 
	@1_FECHAEMISION VARCHAR(10)
	,@2_NRODOCUMENTO VARCHAR(13)
	,@3_TIPDOC VARCHAR(2)
	,@4_TIPMONEDA VARCHAR(3)
	
	,@5_SUMATORIA_IGV VARCHAR(15)
	,@6_SUBTOTAL_IGV  VARCHAR(15)
	
	,@7_TIPMONIGV VARCHAR(3)
	,@14_IMPVENTA VARCHAR(15)
	,@22_TOTGRAV VARCHAR(15)
	,@23_TOTINAFEC VARCHAR(15)
	,@26_SUBTOTAL_VENTA VARCHAR(15)
	
	,@31_DET_MONTO DECIMAL(10,2)
	,@32_DET_PORCENTAJE VARCHAR(2)
	,@33_DET_NUM_BANCO VARCHAR(15)
	,@34_DET_MONTO_TOTAL DECIMAL(10,2)
	
	,@39_PTO_PARTIDA VARCHAR(100)
	,@42_PTO_PARTIDA_DEP VARCHAR(30)
	,@43_PTO_PARTIDA_DIST VARCHAR(30)
	,@46_PTO_LLEGADA VARCHAR(100)
	,@49_PTO_LLEGADA_DEP VARCHAR(30)
	,@50_PTO_LLEGADA_DIST VARCHAR(30)
	,@52_VEH_PLACA VARCHAR(10)
	,@54_VEHICULO_MARCA VARCHAR(50)
	,@55_NRO_LICENCIA VARCHAR(30)
	,@56_TRANS_RUC VARCHAR(11)
	,@57_TRANS_TIP_DOC VARCHAR(2)
	,@58_TRANS_RAZON_SOCIAL VARCHAR(100)
	,@59_REMISION_NRO VARCHAR(15)
	,@60_REMISION_TIPO VARCHAR(2)
	,@61_OTRA_OP_DOC VARCHAR(15)
	,@62_OTRO_OP_TIPO VARCHAR(2)
	
	,@64_NAME_EMISOR VARCHAR(100)
	,@65_NAME_COMERCIAL VARCHAR(100)
	,@66_RUC_EMISOR VARCHAR(11)
	,@67_COD_UBIGEO VARCHAR(6)
	,@68_DIR_EMISOR VARCHAR(100)
	,@70_DEP_EMISOR VARCHAR(30)
	,@71_PROV_EMISOR VARCHAR(30)
	,@72_DIST_EMISOR VARCHAR(30)
	,@73_PAIS_EMISOR VARCHAR(30)
	,@74_USUARIO_SOL VARCHAR(30)
	,@75_CLAVE_SOL VARCHAR(30)
	
	,@76_RUC_RECEP VARCHAR(11)
	,@77_TIP_DOC_RECEP VARCHAR(1)
	,@78_RAZONSOCIAL_RECEP VARCHAR(100)
	,@79_NOMBRE_COMER_RECEP VARCHAR(100)
	,@81_DIRECCION_RECEP VARCHAR(100)	
	,@86_PAIS_RECEP VARCHAR(2)
	,@87_CORREO_RECEP VARCHAR(100)
	
	,@88_LEYENDA_1000 VARCHAR(250)
	
	,@125_INF_ATENCION VARCHAR(50)
	,@126_INF_COND_PAGO VARCHAR(150)
	,@127_INF_ORDEN_COMPRA VARCHAR(150)
	,@128_INF_OBSERVACIONES VARCHAR(255)
	,@129_INF_FECHA_CANCELACION VARCHAR(10)
	
	,@155_ID_LINEA VARCHAR(3)
	,@156_UNIDAD_LINEA VARCHAR(100)
	,@157_CANT_LINEA VARCHAR(10)
	,@158_DESC_LINEA VARCHAR(250)
	,@159_PRECIO_VENTA_LINEA VARCHAR(25)
	,@160_CODIGO_PRECIO_VENTA VARCHAR(2)
	
	,@163_MONTO_TOTAL_IGV_LINEA VARCHAR(15)
	,@164_SUB_TOTAL_IGV_LINEA VARCHAR(15)
	
	,@165_TIPO_AFEC_IGV_LINEA VARCHAR(2)
	,@166_TIP_TRIBUTO_IGV VARCHAR(4)
	,@167_PROCENTAJE_LINEA VARCHAR(2)
	,@174_VAL_UNI_LINEA VARCHAR(15)
	,@175_VAL_VENTA_LINEA VARCHAR(15)
	,@177_TOTAL_LINEA VARCHAR(15)
	
	,@TOTAL_LINEA_IGV VARCHAR(15)
	
	--//OBTENER CODIFICACION DE FACTURA O BOLETA
	CREATE TABLE #DOCUMENTO
	(
	NRODOCUMENTO VARCHAR(13)
	)
	
	INSERT INTO #DOCUMENTO
	EXEC USP_CODIGO_NRODOCUMENTO @NROFAC,@TIPO
	
	SELECT @2_NRODOCUMENTO = NRODOCUMENTO FROM #DOCUMENTO
	DROP TABLE #DOCUMENTO
	--//
	
	--//DATOS DE CABECERA
	SELECT 
	@1_FECHAEMISION = ISNULL(CONVERT(VARCHAR(10), A.fecemi01, 103),'')
	,@3_TIPDOC = ISNULL(CAST(CAST(A.tipdoc01 AS INT) AS VARCHAR),'')
	,@4_TIPMONEDA = CASE WHEN A.moneda01 = 1 THEN 'PEN'
						 WHEN A.moneda01 = 2 THEN 'USD'
						 ELSE ''
						 END
	,@5_SUMATORIA_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
	,@6_SUBTOTAL_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
	--,@163_MONTO_TOTAL_IGV_LINEA = CAST((A.totven01 - A.valfac01) AS VARCHAR)
	--,@164_SUB_TOTAL_IGV_LINEA = CAST((A.totven01 - A.valfac01) AS VARCHAR)
	,@7_TIPMONIGV = CASE WHEN A.moneda01 = 1 THEN 'PEN'
						 WHEN A.moneda01 = 2 THEN 'USD'
						 ELSE ''
						 END
	,@14_IMPVENTA = CAST(A.totven01 AS VARCHAR)
	,@22_TOTGRAV = CASE WHEN A.afecim01 = '1'
						THEN CAST(A.valfac01 AS VARCHAR)
						ELSE ''
						END
	,@23_TOTINAFEC = CASE WHEN A.afecim01 = '0'
						THEN CAST(A.valfac01 AS VARCHAR)
						ELSE ''
						END
	,@26_SUBTOTAL_VENTA = CAST(valfac01 AS VARCHAR)
	--//DATOS RECEPTOR
	,@76_RUC_RECEP = CASE WHEN A.tipdoc01 = '01' THEN ISNULL(A.ruccli01,'')
												 ELSE (CASE WHEN SUBSTRING(A.ruccli01,1,3) = '000'
															THEN SUBSTRING(A.ruccli01,4,8)
															ELSE ISNULL(A.ruccli01,'')
															END
													   )
												 END
	,@77_TIP_DOC_RECEP = CASE WHEN A.tipdoc01 = '01' THEN '6'
													 ELSE '1'
													 END
	,@78_RAZONSOCIAL_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc,'')))
	,@79_NOMBRE_COMER_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc,'')))
	,@81_DIRECCION_RECEP = LTRIM(RTRIM(ISNULL(B.direcci0,'')))
	,@86_PAIS_RECEP = ISNULL(B.codpai07,'')
	,@87_CORREO_RECEP = 'franklin.milla@neptunia.com.pe' --LTRIM(RTRIM(ISNULL(B.correo,'')))
	,@88_LEYENDA_1000 = LTRIM(RTRIM(ISNULL(C.total_letras_FE,'')))
	,@31_DET_MONTO = CASE WHEN ISNULL(C.flgdetraccion_FE,0) > 0
						  THEN ROUND((A.totven01 * C.porc_det_FE),2,2)
						  ELSE 0
						  END
	,@32_DET_PORCENTAJE = CASE WHEN ISNULL(C.flgdetraccion_FE,0) > 0
							   THEN CAST( CAST((C.porc_det_FE * 100) AS INT) AS VARCHAR)
							   ELSE ''
							   END
	,@33_DET_NUM_BANCO = CASE WHEN ISNULL(C.flgdetraccion_FE,0) > 0
							  THEN '00000362085'
							  ELSE ''
							  END
	,@34_DET_MONTO_TOTAL = CASE WHEN ISNULL(C.flgdetraccion_FE,0) > 0
								THEN (A.totven01 - ROUND((A.totven01 * C.porc_det_FE),2,2) )
								ELSE 0
								END
	
	,@125_INF_ATENCION = A.atenci01
	,@126_INF_COND_PAGO = ISNULL(C.condicion_pago_FE,'')
	,@127_INF_ORDEN_COMPRA = ISNULL(C.orden_compra_FE,'')
	,@128_INF_OBSERVACIONES = REPLACE(ISNULL(A.observ01,''),',',' ')
	,@129_INF_FECHA_CANCELACION = ''
	
	FROM DCFACTTR01 A WITH (NOLOCK)
	LEFT JOIN TQCLIENTE B WITH (NOLOCK) ON A.ruccli01 = B.rucclien
	LEFT JOIN DCFACTTR01_FE C WITH (NOLOCK) ON LTRIM(RTRIM(C.nrofac_FE)) = A.nrofac01 AND C.tipodoc_FE = A.tipdoc01
	WHERE nrofac01 = @NROFAC AND tipdoc01 = @TIPO
	--//

	--//DATOS DEL EMISOR
	SELECT 
	@64_NAME_EMISOR = LTRIM(RTRIM(ISNULL(razonsoc,'')))
	,@65_NAME_COMERCIAL = LTRIM(RTRIM(ISNULL(razonsoc,'')))
	,@66_RUC_EMISOR = ISNULL(rucclien,'')
	,@67_COD_UBIGEO = '70101'
	,@68_DIR_EMISOR = LTRIM(RTRIM(ISNULL(direcci0,'')))
	,@70_DEP_EMISOR = 'CALLAO'
	,@71_PROV_EMISOR = 'CALLAO'
	,@72_DIST_EMISOR = 'CALLAO'
	,@73_PAIS_EMISOR = 'PE'
	,@74_USUARIO_SOL = '20138322000'
	,@75_CLAVE_SOL = 'w9PJpb2UnI'
	FROM TQCLIENTE WITH (NOLOCK) 
	WHERE rucclien = '20138322000' --RUC TRITON
	--// 
	
	--//DATOS DE GUIA
	SELECT 
	@39_PTO_PARTIDA = LTRIM(RTRIM(ISNULL(B.PtoOrigen,'')))
	,@42_PTO_PARTIDA_DEP = LTRIM(RTRIM(ISNULL(B.PtoPartida,'')))
	,@43_PTO_PARTIDA_DIST = LTRIM(RTRIM(ISNULL(B.DistPartida,'')))
	,@46_PTO_LLEGADA = LTRIM(RTRIM(ISNULL(B.PtoDestino,'')))
	,@49_PTO_LLEGADA_DEP = LTRIM(RTRIM(ISNULL(B.PtoLlegada,'')))
	,@50_PTO_LLEGADA_DIST = LTRIM(RTRIM(ISNULL(B.DistLlegada,'')))
	,@52_VEH_PLACA = LTRIM(RTRIM(ISNULL(A.nropla01,'')))
	,@54_VEHICULO_MARCA = LTRIM(RTRIM(ISNULL(C.Marca,'')))
	,@55_NRO_LICENCIA = LTRIM(RTRIM(ISNULL(A.brevet01,'')))
	,@56_TRANS_RUC = LTRIM(RTRIM(ISNULL(C.codage19,'')))
	,@57_TRANS_TIP_DOC = '06'
	,@58_TRANS_RAZON_SOCIAL = LTRIM(RTRIM(ISNULL(D.razonsoc,'')))
	,@59_REMISION_NRO = LTRIM(RTRIM(ISNULL(A.nrogui01,'')))
	,@60_REMISION_TIPO = '09'
	,@61_OTRA_OP_DOC = LTRIM(RTRIM(ISNULL(A.nrogui73,'')))
	,@62_OTRO_OP_TIPO = '09'
	FROM DCGUITTR01 A WITH (NOLOCK)
	LEFT JOIN CQCIRCUI01 B WITH (NOLOCK) ON A.idcircuito = B.idcircuito
	LEFT JOIN TQPLAAUT C WITH (NOLOCK) ON C.nropla81 = A.nropla01
	LEFT JOIN TQCLIENTE D WITH (NOLOCK) ON D.rucclien = C.codage19
	WHERE 
	nrodet01 in (select nrodet01 from DDFACTTR01 where nrofac01 = @NROFAC AND tipdoc01 = @TIPO)
	--//
	
	--//DATOS DEL DETALLE
	SELECT B.afecim01
	,CAST(A.cantid01 AS INT) AS cantid01
	,A.desart01
	,CAST(A.preuni01 AS DECIMAL(10,2)) AS preuni01
	,B.totven01
	,B.impven01
	,IDENTITY(int,1,1) as ID
		INTO #DETALLE
	FROM DDFACTTR01 A WITH (NOLOCK)
	INNER JOIN DCFACTTR01 B WITH (NOLOCK) ON A.nrofac01 = B.nrofac01 AND A.tipdoc01 = B.tipdoc01
	WHERE A.nrofac01 = @NROFAC AND A.tipdoc01 = @TIPO
	--//
	
	--//ARMAR TRAMAS CON COMAS
	DECLARE @TRAMA VARCHAR(MAX)
	SET @TRAMA = ''
	
	--//DATOS DE LA FACTURA
	SET @TRAMA = @TRAMA + ISNULL(@1_FECHAEMISION,'') + ',' + ISNULL(@2_NRODOCUMENTO,'') + ',' + ISNULL(@3_TIPDOC,'') + ',' + ISNULL(@4_TIPMONEDA,'') + ','
	+ ISNULL(@5_SUMATORIA_IGV,'') + ',' + ISNULL(@6_SUBTOTAL_IGV,'') + ','
	+ ISNULL(@7_TIPMONIGV,'') + ',,,,,,,' + ISNULL(@14_IMPVENTA,'') +',,,,,,,,' + ISNULL(@22_TOTGRAV,'') + ',' + ISNULL(@23_TOTINAFEC,'') + ',,,'
	+ ISNULL(@26_SUBTOTAL_VENTA,'') + ',,,,,' 
	+ CASE WHEN ISNULL(@31_DET_MONTO,0) = 0 THEN ''
											ELSE CAST(@31_DET_MONTO AS VARCHAR)
											END
	+ ',' + ISNULL(@32_DET_PORCENTAJE,'') + ',' + ISNULL(@33_DET_NUM_BANCO,'') + ',' 
	+ CASE WHEN ISNULL(@34_DET_MONTO_TOTAL,0) = 0 THEN ''
											ELSE CAST(@34_DET_MONTO_TOTAL AS VARCHAR)
											END
	+ ',,,,' + CHAR(13) + ',' 
	
	--//PARTIDA GUIAS
	--+ ISNULL(@39_PTO_PARTIDA,'') + ',,,' + ISNULL(@42_PTO_PARTIDA_DEP,'') + ',' + ISNULL(@43_PTO_PARTIDA_DIST,'') + ',,,' + ISNULL(@46_PTO_LLEGADA,'') + ',,,'
	--+ ISNULL(@49_PTO_LLEGADA_DEP,'') + ',' + ISNULL(@50_PTO_LLEGADA_DIST,'') + ',,' + ISNULL(@52_VEH_PLACA,'') + ',,' + ISNULL(@54_VEHICULO_MARCA,'') + ','
	--+ ISNULL(@55_NRO_LICENCIA,'') + ',' + ISNULL(@56_TRANS_RUC,'') + ',' + ISNULL(@57_TRANS_TIP_DOC,'') + ',' + ISNULL(@58_TRANS_RAZON_SOCIAL,'') + ','
	--+ ISNULL(@59_REMISION_NRO,'') + ',' + ISNULL(@60_REMISION_TIPO,'') + ',' + ISNULL(@61_OTRA_OP_DOC,'') + ',' + ISNULL(@62_OTRO_OP_TIPO,'') + ',,'
	+ ',,,,,,,,,,,,,,,,,,,,' + CHAR(13) + ',,,,,' + CHAR(13)
	
	
	--//DATOS DEL EMISOR
	+ REPLACE(ISNULL(@64_NAME_EMISOR,''),',',' ') + ',' + REPLACE(ISNULL(@65_NAME_COMERCIAL,''),',',' ') + ',' + ISNULL(@66_RUC_EMISOR,'') + ',' + ISNULL(@67_COD_UBIGEO,'') + ',' 
	+ REPLACE(ISNULL(@68_DIR_EMISOR,''),',',' ') + ',,' + ISNULL(@70_DEP_EMISOR,'') + ',' + ISNULL(@71_PROV_EMISOR,'') + ',' + ISNULL(@72_DIST_EMISOR,'') + ','
	+ ISNULL(@73_PAIS_EMISOR,'') + ',' + ISNULL(@74_USUARIO_SOL,'') + ',' + ISNULL(@75_CLAVE_SOL,'') + ',' + CHAR(13)
	
	--//DATOS DEL CLIENTE
	+ LTRIM(RTRIM(ISNULL(@76_RUC_RECEP,''))) + ',' + ISNULL(@77_TIP_DOC_RECEP,'') + ',' + REPLACE(ISNULL(@78_RAZONSOCIAL_RECEP,''),',',' ') + ',' + REPLACE(ISNULL(@79_NOMBRE_COMER_RECEP,''),',',' ') + ',,'
	+ CASE WHEN ISNULL(@81_DIRECCION_RECEP,'') = '' OR @81_DIRECCION_RECEP = '.'
		   THEN 'DIRECCION'
		   ELSE REPLACE(ISNULL(@81_DIRECCION_RECEP,''),',',' ') 
		   END 

	IF @TIPO = '01'
	BEGIN
		SET @TRAMA = @TRAMA + ',,,,,' + ISNULL(@86_PAIS_RECEP,'') + ',' + ISNULL(@87_CORREO_RECEP,'') + ',' + CHAR(13)
	END
	ELSE
	BEGIN
		SET @TRAMA = @TRAMA + ',,' + ISNULL(@86_PAIS_RECEP,'') + ',' + ISNULL(@87_CORREO_RECEP,'') + ',' + CHAR(13)
	END
	
	--//LEYANDAS SUNAT 37
	SET @TRAMA = @TRAMA + REPLACE(@88_LEYENDA_1000,',',' ') + ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' + CHAR(13)
	
	--//INFORMACION ADICIONAL
	SET @TRAMA = @TRAMA + LTRIM(RTRIM(ISNULL(REPLACE(@125_INF_ATENCION,',',' '),''))) + ',' + LTRIM(RTRIM(ISNULL(@126_INF_COND_PAGO,''))) + ',' + LTRIM(RTRIM(ISNULL(@127_INF_ORDEN_COMPRA,''))) + ',' +
	LTRIM(RTRIM(REPLACE(REPLACE(@128_INF_OBSERVACIONES,CHAR(10),''),CHAR(13),''))) + ',' + ISNULL(@129_INF_FECHA_CANCELACION,'') 
	+ ',,,,,,,,,,,,,,,,,,,,,,,,,,' + CHAR(13)
	
	--//DATOS DEL PRODUCTO
	DECLARE @ICONT INT
	,@ICONT_TOT INT
	,@MONTO_TOTAL_IGV_LINEA_DEC DECIMAL(10,2)
	,@TOTAL_LINEA_IGV_DEC DECIMAL(10,2)
	,@TOTAL_LINEA_DEC DECIMAL(10,2)
	,@IGV_PRECIO_UNITARIO DECIMAL(10,2)
	,@VAL_UNI_LINEA DECIMAL(10,2)
	
	SET @ICONT = 1
	SELECT @ICONT_TOT = COUNT(*) FROM #DETALLE
	
	WHILE @ICONT <= @ICONT_TOT
	BEGIN
		SELECT 
		@155_ID_LINEA = CAST(@ICONT AS VARCHAR)
		,@156_UNIDAD_LINEA = 'SERVICIO'
		,@157_CANT_LINEA = CAST(CAST(cantid01 AS INT) AS VARCHAR)
		,@158_DESC_LINEA = LTRIM(RTRIM(ISNULL(desart01,'')))
		,@160_CODIGO_PRECIO_VENTA = '01'
		,@165_TIPO_AFEC_IGV_LINEA = CASE WHEN afecim01 = '0' THEN '30'
															 ELSE '10'
															 END
		,@166_TIP_TRIBUTO_IGV = '1000'
		,@167_PROCENTAJE_LINEA = CAST((impven01 * 100) AS VARCHAR) --'18'
		,@174_VAL_UNI_LINEA = CAST(preuni01 AS VARCHAR)
		,@175_VAL_VENTA_LINEA = CAST((cantid01 * preuni01) AS VARCHAR)
		,@IGV_PRECIO_UNITARIO = CASE WHEN afecim01 ='1' THEN ROUND((preuni01*impven01),2,2)
														ELSE 0
														END
		,@VAL_UNI_LINEA = preuni01
		,@TOTAL_LINEA_DEC = ROUND( (cantid01 * preuni01),2,2)
		,@MONTO_TOTAL_IGV_LINEA_DEC = CASE WHEN afecim01 ='1' THEN ROUND( ((cantid01 * preuni01) * impven01),2,2)
															  ELSE 0
															  END
		FROM #DETALLE
		WHERE ID = @ICONT
		
		SET @159_PRECIO_VENTA_LINEA = CAST((@VAL_UNI_LINEA + @IGV_PRECIO_UNITARIO) AS VARCHAR)
		SET @163_MONTO_TOTAL_IGV_LINEA = CAST(@MONTO_TOTAL_IGV_LINEA_DEC AS VARCHAR)
		SET @164_SUB_TOTAL_IGV_LINEA = CAST(@IGV_PRECIO_UNITARIO AS VARCHAR)
		
		SET @TOTAL_LINEA_IGV_DEC = @TOTAL_LINEA_DEC + @MONTO_TOTAL_IGV_LINEA_DEC
		SET @177_TOTAL_LINEA = CAST(@TOTAL_LINEA_IGV_DEC AS VARCHAR)
		
		
		SET @TRAMA = @TRAMA + ISNULL(@155_ID_LINEA ,'') + ',' + ISNULL(@156_UNIDAD_LINEA,'') + ','
		+ ISNULL(@157_CANT_LINEA,'') + ',' + ISNULL(@158_DESC_LINEA,'') + ',' + ISNULL(@159_PRECIO_VENTA_LINEA,'') + ',' + ISNULL(@160_CODIGO_PRECIO_VENTA,'') + ',,,'
		+ ISNULL(@163_MONTO_TOTAL_IGV_LINEA,'') + ',' + ISNULL(@163_MONTO_TOTAL_IGV_LINEA,'') + ','
		+ ISNULL(@165_TIPO_AFEC_IGV_LINEA,'') + ',' + ISNULL(@166_TIP_TRIBUTO_IGV,'') + ',' + ISNULL(@167_PROCENTAJE_LINEA,'') + ',,,,,,,' + ISNULL(@174_VAL_UNI_LINEA,'')  + ','
		+ ISNULL(@175_VAL_VENTA_LINEA,'') + ',,' + ISNULL(@177_TOTAL_LINEA,'') + ',,,,,,,,,,,' + CHAR(13)
		
		--IF @ICONT = @ICONT_TOT
		--BEGIN
		--	SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' --//SEPARADOR DE ITEM
		--END
		--ELSE
		--BEGIN
		--	SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' + ',' + CHAR(13) --//SEPARADOR DE ITEM
		--END
		
		SET @ICONT = @ICONT + 1
	END
	
	SET @TRAMA = @TRAMA + 'FF00FF'
	
	DROP TABLE #DETALLE
	PRINT @TRAMA
	
	SELECT @TRAMA AS TRAMA
	
SET NOCOUNT OFF;
END

--GO
--GRANT ALL ON USP_ARMARTRAMA_FE_FACT_BOL TO PUBLIC

GO
/****** Object:  StoredProcedure [dbo].[USP_ARMARTRAMA_FE_ND_DC]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_ARMARTRAMA_FE_ND_DC '0010001835','07'    
ALTER PROCEDURE [dbo].[USP_ARMARTRAMA_FE_ND_DC] @NROFAC VARCHAR(10)
	,@TIPO VARCHAR(2)
	--,@TIPO_ND VARCHAR(2)      
	--,@DESCRIPCION VARCHAR(150)      
AS
BEGIN
	SET NOCOUNT ON;

	--SET @DESCRIPCION = LTRIM(RTRIM(@DESCRIPCION))      
	DECLARE @1_FECHAEMISION VARCHAR(10)
		,@2_NRODOCUMENTO VARCHAR(13)
		,@3_TIPDOC VARCHAR(2)
		,@4_TIPMONEDA VARCHAR(3)
		,@5_SUMATORIA_IGV VARCHAR(15)
		,@6_SUBTOTAL_IGV VARCHAR(15)
		,@7_TIPMONIGV VARCHAR(3)
		,@14_IMPVENTA VARCHAR(15)
		,@22_TOTGRAV VARCHAR(15)
		,@23_TOTINAFEC VARCHAR(15)
		,@26_SUBTOTAL_VENTA VARCHAR(15)
		,@39_PTO_PARTIDA VARCHAR(100)
		,@42_PTO_PARTIDA_DEP VARCHAR(30)
		,@43_PTO_PARTIDA_DIST VARCHAR(30)
		,@46_PTO_LLEGADA VARCHAR(100)
		,@49_PTO_LLEGADA_DEP VARCHAR(30)
		,@50_PTO_LLEGADA_DIST VARCHAR(30)
		,@52_VEH_PLACA VARCHAR(10)
		,@54_VEHICULO_MARCA VARCHAR(50)
		,@55_NRO_LICENCIA VARCHAR(30)
		,@56_TRANS_RUC VARCHAR(11)
		,@57_TRANS_TIP_DOC VARCHAR(2)
		,@58_TRANS_RAZON_SOCIAL VARCHAR(100)
		,@59_REMISION_NRO VARCHAR(15)
		,@60_REMISION_TIPO VARCHAR(2)
		,@61_OTRA_OP_DOC VARCHAR(15)
		,@62_OTRO_OP_TIPO VARCHAR(2)
		,@64_NAME_EMISOR VARCHAR(100)
		,@65_NAME_COMERCIAL VARCHAR(100)
		,@66_RUC_EMISOR VARCHAR(11)
		,@67_COD_UBIGEO VARCHAR(6)
		,@68_DIR_EMISOR VARCHAR(100)
		,@70_DEP_EMISOR VARCHAR(30)
		,@71_PROV_EMISOR VARCHAR(30)
		,@72_DIST_EMISOR VARCHAR(30)
		,@73_PAIS_EMISOR VARCHAR(30)
		,@74_USUARIO_SOL VARCHAR(30)
		,@75_CLAVE_SOL VARCHAR(30)
		,@76_RUC_RECEP VARCHAR(11)
		,@77_TIP_DOC_RECEP VARCHAR(1)
		,@78_RAZONSOCIAL_RECEP VARCHAR(100)
		,@79_NOMBRE_COMER_RECEP VARCHAR(100)
		,@81_DIRECCION_RECEP VARCHAR(100)
		,@86_PAIS_RECEP VARCHAR(2)
		,@87_CORREO_RECEP VARCHAR(100)
		,@88_INFORMACION VARCHAR(100)
		,@89_INF_ATENCION VARCHAR(50)
		,@90_INF_TIP_DOCREF VARCHAR(50)
		,@91_INF_OBSERVACIONES VARCHAR(255)
		,@100_INF_FECHA_CAN VARCHAR(10)
		,@155_ID_LINEA VARCHAR(3)
		,@156_UNIDAD_LINEA VARCHAR(100)
		,@157_CANT_LINEA VARCHAR(10)
		,@158_DESC_LINEA VARCHAR(250)
		,@159_PRECIO_VENTA_LINEA VARCHAR(25)
		,@160_CODIGO_PRECIO_VENTA VARCHAR(2)
		,@163_MONTO_TOTAL_IGV_LINEA VARCHAR(15)
		,@164_SUB_TOTAL_IGV_LINEA VARCHAR(15)
		,@165_TIPO_AFEC_IGV_LINEA VARCHAR(2)
		,@166_TIP_TRIBUTO_IGV VARCHAR(4)
		,@167_PROCENTAJE_LINEA VARCHAR(2)
		,@174_VAL_UNI_LINEA VARCHAR(15)
		,@175_VAL_VENTA_LINEA VARCHAR(15)
		,@177_TOTAL_LINEA VARCHAR(15)
		,@DOC_AFECTACION VARCHAR(13)
		,@TIP_DOC_AFECTACION VARCHAR(2)
		,@TIP_AFECTACION VARCHAR(2)
		,@MOTIVO_AFECTACION VARCHAR(30)
		,@RELATED_DOC VARCHAR(25)
		,@DESCRIPCION VARCHAR(150)
		,@DOC_ANTERIOR VARCHAR(13)
		,@TOTAL_LINEA_IGV VARCHAR(15)

	SELECT @DOC_ANTERIOR = nroRef01
	FROM DCFACTTR01 WITH (NOLOCK)
	WHERE nrofac01 = @NROFAC
		AND tipdoc01 = @TIPO

	--SELECT @TIP_DOC_AFECTACION = tipdoc01    
	--FROM DCFACTTR01 WITH (NOLOCK)    
	--WHERE nrofac01 = @DOC_ANTERIOR    
	-- AND tipdoc01 = '01'    
	--//OBTENER TIPO DE DOCUMENTO ANTERIOR    
	SELECT @TIP_DOC_AFECTACION = CASE 
			WHEN prefijo_FE = 'F'
				THEN '01'
			WHEN prefijo_FE = 'B'
				THEN '03'
			ELSE ''
			END
	FROM DCFACTTR01_FE WITH (NOLOCK)
	WHERE nrofac_FE = @NROFAC
		AND tipodoc_FE = @TIPO

	--//    
	--//OBTENER CODIFICACION DE NC O NB      
	CREATE TABLE #DOCUMENTO (NRODOCUMENTO VARCHAR(13))

	INSERT INTO #DOCUMENTO
	EXEC USP_CODIGO_NRODOCUMENTO @NROFAC
		,@TIP_DOC_AFECTACION

	IF @TIPO = '07'
	BEGIN
		SELECT @2_NRODOCUMENTO = NRODOCUMENTO
		FROM #DOCUMENTO
	END

	IF @TIPO = '08'
	BEGIN
		SELECT @2_NRODOCUMENTO = NRODOCUMENTO
		FROM #DOCUMENTO
	END

	DROP TABLE #DOCUMENTO

	--//      
	--//OBTENER CODIFICACION DE FACTURA O BOLETA REFERENCIA      
	CREATE TABLE #DOCUMENTO1 (NRODOCUMENTO VARCHAR(13))

	INSERT INTO #DOCUMENTO1
	EXEC USP_CODIGO_NRODOCUMENTO @DOC_ANTERIOR
		,@TIP_DOC_AFECTACION

	SELECT @DOC_AFECTACION = NRODOCUMENTO
	FROM #DOCUMENTO1

	DROP TABLE #DOCUMENTO1

	--//      
	--//DATOS DE CABECERA     
	SELECT @1_FECHAEMISION = ISNULL(CONVERT(VARCHAR(10), fecemi01, 103), '')
		,@3_TIPDOC = ISNULL(CAST(CAST(A.tipdoc01 AS INT) AS VARCHAR), '')
		,@4_TIPMONEDA = CASE 
			WHEN moneda01 = 1
				THEN 'PEN'
			WHEN moneda01 = 2
				THEN 'USD'
			ELSE ''
			END
		,@5_SUMATORIA_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
		,@6_SUBTOTAL_IGV = CAST((A.totven01 - A.valfac01) AS VARCHAR)
		,@7_TIPMONIGV = CASE 
			WHEN moneda01 = 1
				THEN 'PEN'
			WHEN moneda01 = 2
				THEN 'USD'
			ELSE ''
			END
		,@14_IMPVENTA = CAST(totven01 AS VARCHAR)
		,@22_TOTGRAV = CASE 
			WHEN A.afecim01 = '1'
				THEN CAST(A.valfac01 AS VARCHAR)
			ELSE ''
			END
		,@23_TOTINAFEC = CASE 
			WHEN A.afecim01 = '0'
				THEN CAST(A.valfac01 AS VARCHAR)
			ELSE ''
			END
		,@26_SUBTOTAL_VENTA = CAST(valfac01 AS VARCHAR)
		--//DATOS RECEPTOR      
		,@76_RUC_RECEP = CASE 
			WHEN @TIP_DOC_AFECTACION = '01'
				THEN ISNULL(A.ruccli01, '')
			ELSE (
					CASE 
						WHEN SUBSTRING(A.ruccli01, 1, 3) = '000'
							THEN SUBSTRING(A.ruccli01, 4, 8)
						ELSE ISNULL(A.ruccli01, '')
						END
					)
			END
		,@77_TIP_DOC_RECEP = CASE 
			WHEN @TIP_DOC_AFECTACION = '01'
				THEN '6'
			ELSE '1'
			END
		,@78_RAZONSOCIAL_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc, '')))
		,@79_NOMBRE_COMER_RECEP = LTRIM(RTRIM(ISNULL(b.razonsoc, '')))
		,@81_DIRECCION_RECEP = LTRIM(RTRIM(ISNULL(B.direcci0, '')))
		,@86_PAIS_RECEP = ISNULL(B.codpai07, '')
		,@87_CORREO_RECEP = CASE 
			WHEN ISNULL(B.correo, '') = ''
				THEN 'letty.valderrama@tritontransports.com.pe'
			ELSE LTRIM(RTRIM(ISNULL(B.correo, '')))
			END
		,@88_INFORMACION = LTRIM(RTRIM(C.total_letras_FE))
		,@89_INF_ATENCION = A.atenci01
		,@90_INF_TIP_DOCREF = CASE 
			WHEN @TIP_DOC_AFECTACION = '01'
				THEN 'FACTURA'
			ELSE 'BOLETA'
			END
		,@91_INF_OBSERVACIONES = REPLACE(ISNULL(A.observ01, ''), ',', ' ')
		,@100_INF_FECHA_CAN = ''
		,@TIP_DOC_AFECTACION = CAST(CAST(@TIP_DOC_AFECTACION AS INT) AS VARCHAR)
		,@TIP_AFECTACION = CAST(CAST(D.codigo00 AS INT) AS VARCHAR)
		,@DESCRIPCION = LTRIM(RTRIM(ISNULL(C.Descripcion_FE, '')))
		,@RELATED_DOC = 'RELATED_DOC'
	FROM DCFACTTR01 A WITH (NOLOCK)
	LEFT JOIN TQCLIENTE B WITH (NOLOCK) ON A.ruccli01 = B.rucclien
	LEFT JOIN DCFACTTR01_FE C WITH (NOLOCK) ON LTRIM(RTRIM(C.nrofac_FE)) = A.nrofac01
		AND C.tipodoc_FE = A.tipdoc01
	LEFT JOIN COD_NC_ND_00 D WITH (NOLOCK) ON LTRIM(RTRIM(D.descripcion00)) = LTRIM(RTRIM(C.Descripcion_FE))
		AND D.tipodoc = @TIPO
	WHERE nrofac01 = @NROFAC
		AND tipdoc01 = @TIPO

	--//      
	--SELECT @TIP_AFECTACION = CAST(CAST(codigo00 AS INT) AS VARCHAR)      
	--FROM COD_NC_ND_00  WITH (NOLOCK)      
	--WHERE descripcion00 = LTRIM(RTRIM(@DESCRIPCION))      
	--AND tipodoc = @TIPO      
	--//DATOS DEL EMISOR      
	SELECT @64_NAME_EMISOR = LTRIM(RTRIM(ISNULL(razonsoc, '')))
		,@65_NAME_COMERCIAL = LTRIM(RTRIM(ISNULL(razonsoc, '')))
		,@66_RUC_EMISOR = ISNULL(rucclien, '')
		,@67_COD_UBIGEO = '70101'
		,@68_DIR_EMISOR = LTRIM(RTRIM(ISNULL(direcci0, '')))
		,@70_DEP_EMISOR = 'CALLAO'
		,@71_PROV_EMISOR = 'CALLAO'
		,@72_DIST_EMISOR = 'CALLAO'
		,@73_PAIS_EMISOR = 'PE'
		,@74_USUARIO_SOL = '20138322000'
		,@75_CLAVE_SOL = 'd1d26c06e65b8f01'
	FROM TQCLIENTE WITH (NOLOCK)
	WHERE rucclien = '20138322000' --RUC TRITON      
		--//       

	--//DATOS DE GUIA      
	SELECT @39_PTO_PARTIDA = LTRIM(RTRIM(ISNULL(B.PtoOrigen, '')))
		,@42_PTO_PARTIDA_DEP = LTRIM(RTRIM(ISNULL(B.PtoPartida, '')))
		,@43_PTO_PARTIDA_DIST = LTRIM(RTRIM(ISNULL(B.DistPartida, '')))
		,@46_PTO_LLEGADA = LTRIM(RTRIM(ISNULL(B.PtoDestino, '')))
		,@49_PTO_LLEGADA_DEP = LTRIM(RTRIM(ISNULL(B.PtoLlegada, '')))
		,@50_PTO_LLEGADA_DIST = LTRIM(RTRIM(ISNULL(B.DistLlegada, '')))
		,@52_VEH_PLACA = LTRIM(RTRIM(ISNULL(A.nropla01, '')))
		,@54_VEHICULO_MARCA = LTRIM(RTRIM(ISNULL(C.Marca, '')))
		,@55_NRO_LICENCIA = LTRIM(RTRIM(ISNULL(A.brevet01, '')))
		,@56_TRANS_RUC = LTRIM(RTRIM(ISNULL(C.codage19, '')))
		,@57_TRANS_TIP_DOC = '06'
		,@58_TRANS_RAZON_SOCIAL = LTRIM(RTRIM(ISNULL(D.razonsoc, '')))
		,@59_REMISION_NRO = LTRIM(RTRIM(ISNULL(A.nrogui01, '')))
		,@60_REMISION_TIPO = '09'
		,@61_OTRA_OP_DOC = LTRIM(RTRIM(ISNULL(A.nrogui73, '')))
		,@62_OTRO_OP_TIPO = '09'
	FROM DCGUITTR01 A WITH (NOLOCK)
	LEFT JOIN CQCIRCUI01 B WITH (NOLOCK) ON A.idcircuito = B.idcircuito
	LEFT JOIN TQPLAAUT C WITH (NOLOCK) ON C.nropla81 = A.nropla01
	LEFT JOIN TQCLIENTE D WITH (NOLOCK) ON D.rucclien = C.codage19
	WHERE nrodet01 IN (
			SELECT nrodet01
			FROM DDFACTTR01
			WHERE nrofac01 = @NROFAC
				AND tipdoc01 = @TIPO
			)

	--//      
	--//DATOS DEL DETALLE      
	SELECT B.afecim01
		,CAST(A.cantid01 AS INT) AS cantid01
		,A.desart01
		,CAST(A.preuni01 AS DECIMAL(10, 2)) AS preuni01
		,B.totven01
		,B.impven01
		,IDENTITY(INT, 1, 1) AS ID
	INTO #DETALLE
	FROM DDFACTTR01 A WITH (NOLOCK)
	INNER JOIN DCFACTTR01 B WITH (NOLOCK) ON A.nrofac01 = B.nrofac01
		AND A.tipdoc01 = B.tipdoc01
	WHERE A.nrofac01 = @NROFAC
		AND A.tipdoc01 = @TIPO

	--//      
	--//ARMAR TRAMAS CON COMAS      
	DECLARE @TRAMA VARCHAR(MAX)

	SET @TRAMA = ''

	--//DATOS DE LA FACTURA      
	SELECT @TRAMA = @TRAMA + ISNULL(@1_FECHAEMISION, '') + ',' + ISNULL(@2_NRODOCUMENTO, '') + ',' + ISNULL(@4_TIPMONEDA, '') + ',' + ISNULL(@5_SUMATORIA_IGV, '') + ',' + ISNULL(@6_SUBTOTAL_IGV, '') + ',' + ISNULL(@7_TIPMONIGV, '') + ',,,,,,,' + ISNULL(@14_IMPVENTA, '') + ',,,' + ISNULL(@22_TOTGRAV, '') + ',' + ISNULL(@23_TOTINAFEC, '') + ',,,' + ISNULL(@26_SUBTOTAL_VENTA, '') + ',,,,,,,,,,,' + CHAR(13)
		--//PARTIDA GUIAS      
		--+ ISNULL(@59_REMISION_NRO,'') + ',' + ISNULL(@60_REMISION_TIPO,'') + ',' + ISNULL(@61_OTRA_OP_DOC,'') + ',' + ISNULL(@62_OTRO_OP_TIPO,'') + ',,'      
		+ ',,,,,' + CHAR(13)
		--//DATOS DEL EMISOR      
		+ REPLACE(ISNULL(@64_NAME_EMISOR, ''), ',', ' ') + ',' + REPLACE(ISNULL(@65_NAME_COMERCIAL, ''), ',', ' ') + ',' + ISNULL(@66_RUC_EMISOR, '') + ',' + ISNULL(@67_COD_UBIGEO, '') + ',' + REPLACE(ISNULL(@68_DIR_EMISOR, ''), ',', ' ') + ',,' + ISNULL(@70_DEP_EMISOR, '') + ',' + ISNULL(@71_PROV_EMISOR, '') + ',' + ISNULL(@72_DIST_EMISOR, '') + ',' + ISNULL(@73_PAIS_EMISOR, '') + ',' + ISNULL(@74_USUARIO_SOL, '') + ',' + ISNULL(@75_CLAVE_SOL, '') + ',' + CHAR(13)
		--//DATOS DEL CLIENTE      
		+ LTRIM(RTRIM(ISNULL(@76_RUC_RECEP, ''))) + ',' + ISNULL(@77_TIP_DOC_RECEP, '') + ',' + REPLACE(ISNULL(@78_RAZONSOCIAL_RECEP, ''), ',', ' ') + ',' + REPLACE(ISNULL(@79_NOMBRE_COMER_RECEP, ''), ',', ' ') + ',,' + CASE 
			WHEN ISNULL(@81_DIRECCION_RECEP, '') = ''
				OR @81_DIRECCION_RECEP = '.'
				THEN 'DIRECCION'
			ELSE REPLACE(ISNULL(@81_DIRECCION_RECEP, ''), ',', ' ')
			END + ',,,,,' + ISNULL(@86_PAIS_RECEP, '') + ',' + ISNULL(@87_CORREO_RECEP, '') + ',' + CHAR(13)
		--//INFORMACION      
		+ @88_INFORMACION + ',' + CHAR(13) + LTRIM(RTRIM(ISNULL(@89_INF_ATENCION, ''))) + ',' + LTRIM(RTRIM(@90_INF_TIP_DOCREF)) + ',' + LTRIM(RTRIM(REPLACE(REPLACE(@91_INF_OBSERVACIONES, CHAR(10), ' '), CHAR(13), ' '))) + ',' + @100_INF_FECHA_CAN 
		+ ',,,,,,,,,,,,,,,,,' + CHAR(13)
		--//DOCUMENTO DE REFERENCIA      
		+ ISNULL(@DOC_AFECTACION, '') + ',' + ISNULL(@TIP_DOC_AFECTACION, '') + ',' + ISNULL(@TIP_AFECTACION, '') + ',' + ISNULL(@DESCRIPCION, '') + ',' + @RELATED_DOC + ',' + CHAR(13)

	--//DATOS DEL PRODUCTO      
	DECLARE @ICONT INT
		,@ICONT_TOT INT
		,@MONTO_TOTAL_IGV_LINEA_DEC DECIMAL(10, 2)
		,@TOTAL_LINEA_IGV_DEC DECIMAL(10, 2)
		,@TOTAL_LINEA_DEC DECIMAL(10, 2)
		,@IGV_PRECIO_UNITARIO DECIMAL(10, 2)
		,@VAL_UNI_LINEA DECIMAL(10, 2)

	SET @ICONT = 1

	SELECT @ICONT_TOT = COUNT(*)
	FROM #DETALLE

	WHILE @ICONT <= @ICONT_TOT
	BEGIN
		SELECT @155_ID_LINEA = CAST(@ICONT AS VARCHAR)
			,@156_UNIDAD_LINEA = 'UNID'
			,@157_CANT_LINEA = CAST(cantid01 AS VARCHAR)
			,@158_DESC_LINEA = LTRIM(RTRIM(ISNULL(desart01, '')))
			,@160_CODIGO_PRECIO_VENTA = '01'
			,@165_TIPO_AFEC_IGV_LINEA = CASE 
				WHEN afecim01 = '0'
					THEN '30'
				ELSE '10'
				END
			,@166_TIP_TRIBUTO_IGV = '1000'
			,@167_PROCENTAJE_LINEA = CAST((impven01 * 100) AS VARCHAR) --'18'      
			,@174_VAL_UNI_LINEA = CAST(preuni01 AS VARCHAR)
			,@175_VAL_VENTA_LINEA = CAST((cantid01 * preuni01) AS VARCHAR)
			,@IGV_PRECIO_UNITARIO = CASE 
				WHEN afecim01 = '1'
					THEN ROUND((preuni01 * impven01), 2, 2)
				ELSE 0
				END
			,@VAL_UNI_LINEA = preuni01
			,@TOTAL_LINEA_DEC = ROUND((cantid01 * preuni01), 2, 2)
			,@MONTO_TOTAL_IGV_LINEA_DEC = CASE 
				WHEN afecim01 = '1'
					THEN ROUND(((cantid01 * preuni01) * impven01), 2, 2)
				ELSE 0
				END
		FROM #DETALLE
		WHERE ID = @ICONT

		SET @159_PRECIO_VENTA_LINEA = CAST((@VAL_UNI_LINEA + @IGV_PRECIO_UNITARIO) AS VARCHAR)
		SET @163_MONTO_TOTAL_IGV_LINEA = CAST(@MONTO_TOTAL_IGV_LINEA_DEC AS VARCHAR)
		SET @164_SUB_TOTAL_IGV_LINEA = CAST(@IGV_PRECIO_UNITARIO AS VARCHAR)
		SET @TOTAL_LINEA_IGV_DEC = @TOTAL_LINEA_DEC + @MONTO_TOTAL_IGV_LINEA_DEC
		SET @177_TOTAL_LINEA = CAST(@TOTAL_LINEA_IGV_DEC AS VARCHAR)
		SET @TRAMA = @TRAMA + ISNULL(@155_ID_LINEA, '') + ',' + ISNULL(@156_UNIDAD_LINEA, '') + ',' + ISNULL(@157_CANT_LINEA, '') + ',' + REPLACE(ISNULL(@158_DESC_LINEA, ''),',',' ') + ',' 
		+ ISNULL(@159_PRECIO_VENTA_LINEA, '') + ',' + ISNULL(@160_CODIGO_PRECIO_VENTA, '') + ',,,' + ISNULL(@163_MONTO_TOTAL_IGV_LINEA, '') + ',' + ISNULL(@163_MONTO_TOTAL_IGV_LINEA, '') + ',' + ISNULL(@165_TIPO_AFEC_IGV_LINEA, '') + ',' + ISNULL(@166_TIP_TRIBUTO_IGV, '') + ',' 
		+ ISNULL(@167_PROCENTAJE_LINEA, '') + ',,,,,,,' + ISNULL(@174_VAL_UNI_LINEA, '') + ',' + ISNULL(@175_VAL_VENTA_LINEA, '') + ',,' + ISNULL(@177_TOTAL_LINEA, '') + ',,,,,,,,,,,' + CHAR(13)
		--IF @ICONT = @ICONT_TOT      
		--BEGIN      
		-- SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' --//SEPARADOR DE ITEM      
		--END      
		--ELSE      
		--BEGIN      
		-- SET @TRAMA = @TRAMA + CHAR(13) + 'FF00FF' + ',' + CHAR(13) --//SEPARADOR DE ITEM      
		--END      
		SET @ICONT = @ICONT + 1
	END

	SET @TRAMA = @TRAMA + 'FF00FF'

	DROP TABLE #DETALLE

	PRINT @TRAMA

	SELECT @TRAMA AS TRAMA

	SET NOCOUNT OFF;
END
	--GO      
	--GRANT ALL ON USP_ARMARTRAMA_FE_ND_DC TO PUBLIC      
GO
/****** Object:  StoredProcedure [dbo].[USP_CARGA_DET_GUIA_TRITON]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CARGA_DET_GUIA_TRITON]
@viGuiatriton VARCHAR(10),
@viContenedor VARCHAR(11),
@viTamanoCtr VARCHAR(2)
AS
BEGIN
	declare @fecgen char(8)  
	declare @circuito integer  
	
	IF NOT EXISTS(SELECT *FROM DDGUITTR01 WHERE nrogui01 = @viGuiatriton AND codcon01 = @viContenedor)
	BEGIN
		insert into DDGUITTR01    
		(    
		nrogui01,    
		codcon01,    
		codtam01    
		)    
		values     
		(    
		@viGuiatriton,    
		@viContenedor,    
		@viTamanoCtr    
		)   
	END 
	ELSE
	BEGIN
		UPDATE DDGUITTR01 SET codtam01 = @viTamanoCtr
		WHERE nrogui01 = @viGuiatriton AND codcon01 = @viContenedor
	END
  
	selecT @fecgen =convert(char(8),fecgen01,112),@circuito = idcircuito from DCGUITTR01 where nrogui01 = @viGuiatriton  
  
	exec sp_ValidaGuiaxMesxAnio @fecgen,@circuito,@viContenedor,@viGuiatriton  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_CODIGO_NRODOCUMENTO]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CODIGO_NRODOCUMENTO] @NROFAC VARCHAR(10)
	,@TIPO VARCHAR(2)
AS
BEGIN
	SET @NROFAC = LTRIM(RTRIM(@NROFAC))

	DECLARE @SERIE VARCHAR(3)
		,@NUMERO VARCHAR(7)
		,@PREFIJO VARCHAR(1)

	SET @SERIE = SUBSTRING(@NROFAC, 1, 3)
	SET @NUMERO = SUBSTRING(@NROFAC, 4, 7)
	
	IF SUBSTRING(@SERIE,1,1) IN ('A','V','D','C')
	BEGIN
		IF @TIPO = '01'
		BEGIN
			SET @PREFIJO = 'F'
		END
		ELSE IF @TIPO = '03'
		BEGIN
			SET @PREFIJO = 'B'
		END
	END
	ELSE
	BEGIN
		SET @PREFIJO = ''
	END
	
	SELECT (@PREFIJO + '' + @SERIE + '-' + RIGHT('00000000' + ltrim(rtrim(@NUMERO)), 8)) AS DOCUMENTO
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CRE_TRITON_CORRELATIVO]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CRE_TRITON_CORRELATIVO] @DOCUMENTO VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SERIE VARCHAR(4)
		,@NUMERO VARCHAR(10)

	SET @SERIE = 'R' + SUBSTRING(@DOCUMENTO, 2, 3)
	SET @NUMERO = SUBSTRING(@DOCUMENTO, 8, 8)

	SELECT NRO = @SERIE + '-' + @NUMERO

	SET NOCOUNT OFF;
END

GRANT ALL ON USP_CRE_TRITON_CORRELATIVO TO PUBLIC
GO
/****** Object:  StoredProcedure [dbo].[USP_DET_FE]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DET_FE] @viiFacturas VARCHAR(12)
	,@viiTipo VARCHAR(2)
	,@viiFlgDet INT
	,@viiPorcentaje DECIMAL(10, 2)
	,@viiValor DECIMAL(10, 2)
	,@viiPrefijo INT
	,@viiDescripcion VARCHAR(100)
	,@viiSQL VARCHAR(2)
	,@viiTotalLetras VARCHAR(200)
	,@viiOC VARCHAR(150)
	,@viiCondPago VARCHAR(150)
	,@viiGuiaRemision VARCHAR(100)
AS
BEGIN
	SET @viiFacturas = LTRIM(RTRIM(@viiFacturas))
	SET @viiDescripcion = LTRIM(RTRIM(@viiDescripcion))
	SET @viiTotalLetras = LTRIM(RTRIM(@viiTotalLetras))
	SET @viiOC = LTRIM(RTRIM(@viiOC))
	SET @viiCondPago = LTRIM(RTRIM(@viiCondPago))
	SET @viiGuiaRemision = LTRIM(RTRIM(@viiGuiaRemision))

	DECLARE @VIIFLG_NCND VARCHAR(1)
	DECLARE @VIIDESC_PREFIJO VARCHAR(1)

	IF @viiTipo = '07'
		OR @viiTipo = '08'
	BEGIN
		SET @VIIFLG_NCND = '1'
	END
	ELSE
	BEGIN
		SET @VIIFLG_NCND = '0'
	END

	IF @viiPrefijo = '1'
	BEGIN
		SET @VIIDESC_PREFIJO = 'B'
	END
	ELSE IF @viiPrefijo = '2'
	BEGIN
		SET @VIIDESC_PREFIJO = 'F'
	END
	ELSE IF @viiPrefijo = '3'
	BEGIN
		SET @VIIDESC_PREFIJO = 'B'
	END
	ELSE IF @viiPrefijo = '4'
	BEGIN
		SET @VIIDESC_PREFIJO = 'F'
	END
	ELSE
	BEGIN
		IF @viiTipo = '01'
		BEGIN
			SET @VIIDESC_PREFIJO = 'F'
		END
		ELSE IF @viiTipo = '03'
		BEGIN
			SET @VIIDESC_PREFIJO = 'B'
		END
	END

	IF @viiSQL = 'I'
	BEGIN
		INSERT INTO DCFACTTR01_FE (
			prefijo_FE
			,nrofac_FE
			,tipodoc_FE
			,flgdetraccion_FE
			,porc_det_FE
			,valor_det_FE
			,flg_NCND_FE
			,Descripcion_FE
			,flg_Trans_FE
			,PDF417_FE
			,respuesta_FE
			,total_letras_FE
			,condicion_pago_FE
			,orden_compra_FE
			,guia_remision_FE
			)
		VALUES (
			@VIIDESC_PREFIJO
			,@viiFacturas
			,@viiTipo
			,@viiFlgDet
			,@viiPorcentaje
			,@viiValor
			,@VIIFLG_NCND
			,@viiDescripcion
			,'0'
			,NULL
			,NULL
			,@viiTotalLetras
			,@viiCondPago
			,@viiOC
			,@viiGuiaRemision
			)
	END

	IF @viiSQL = 'M'
	BEGIN
		UPDATE DCFACTTR01_FE
		SET prefijo_FE = @VIIDESC_PREFIJO
			,flgdetraccion_FE = @viiFlgDet
			,porc_det_FE = @viiPorcentaje
			,valor_det_FE = @viiValor
			,flg_NCND_FE = @VIIFLG_NCND
			,Descripcion_FE = @viiDescripcion
			,total_letras_FE = @viiTotalLetras
			,condicion_pago_FE = @viiCondPago
			,orden_compra_FE = @viiOC
			,guia_remision_FE = @viiGuiaRemision
		WHERE nrofac_FE = @viiFacturas
			AND tipodoc_FE = @viiTipo
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DET_FEE]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DET_FEE]
@viiFacturas VARCHAR(12)
,@viiTipo VARCHAR(2)
,@viiFlgDet INT
,@viiPorcentaje DECIMAL(10,2)
,@viiValor DECIMAL(10,2)
,@viiPrefijo INT 
,@viiDescripcion VARCHAR(100)
,@viiSQL VARCHAR(2)
,@viiTotalLetras VARCHAR(200)
,@viiOC VARCHAR(150)
,@viiCondPago VARCHAR(150)
AS
BEGIN
	SET @viiFacturas = LTRIM(RTRIM(@viiFacturas))
	SET @viiDescripcion = LTRIM(RTRIM(@viiDescripcion))
	SET @viiTotalLetras = LTRIM(RTRIM(@viiTotalLetras))
	SET @viiOC = LTRIM(RTRIM(@viiOC))
	SET @viiCondPago = LTRIM(RTRIM(@viiCondPago))
	
	DECLARE @VIIFLG_NCND VARCHAR(1)
	DECLARE @VIIDESC_PREFIJO VARCHAR(1)
	
	IF @viiTipo = '07' OR @viiTipo = '08'
	BEGIN
		SET @VIIFLG_NCND = '1'
	END
	ELSE
	BEGIN
		SET @VIIFLG_NCND = '0'
	END
	
	IF @viiPrefijo = '1'
	BEGIN
		SET @VIIDESC_PREFIJO = 'B'
	END
	ELSE IF @viiPrefijo = '2'
	BEGIN
		SET @VIIDESC_PREFIJO = 'F'
	END
	ELSE IF @viiPrefijo = '3'
	BEGIN
		SET @VIIDESC_PREFIJO = 'B'
	END
	ELSE IF @viiPrefijo = '4'
	BEGIN
		SET @VIIDESC_PREFIJO = 'F'
	END
	ELSE
	BEGIN
		IF @viiTipo = '01'
		BEGIN
			SET @VIIDESC_PREFIJO = 'F'
		END
		ELSE IF @viiTipo = '03'
		BEGIN	
			SET @VIIDESC_PREFIJO = 'B'
		END
	END
	
	IF @viiSQL = 'I'
	BEGIN
		INSERT INTO DCFACTTR01_FE
		(
		prefijo_FE,
		nrofac_FE,
		tipodoc_FE,
		flgdetraccion_FE,
		porc_det_FE,
		valor_det_FE,
		flg_NCND_FE,
		Descripcion_FE,
		flg_Trans_FE,
		PDF417_FE,
		respuesta_FE,
		total_letras_FE,
		condicion_pago_FE,
		orden_compra_FE
		)
		VALUES
		(
		@VIIDESC_PREFIJO
		,@viiFacturas
		,@viiTipo
		,@viiFlgDet
		,@viiPorcentaje
		,@viiValor
		,@VIIFLG_NCND
		,@viiDescripcion
		,'0'
		,NULL
		,NULL
		,@viiTotalLetras
		,@viiCondPago
		,@viiOC
		)
	END
	
	IF @viiSQL = 'M'
	BEGIN
		UPDATE DCFACTTR01_FE
		SET
			prefijo_FE = @VIIDESC_PREFIJO
			,flgdetraccion_FE = @viiFlgDet
			,porc_det_FE = @viiPorcentaje
			,valor_det_FE = @viiValor
			,flg_NCND_FE = @VIIFLG_NCND
			,Descripcion_FE = @viiDescripcion
			,total_letras_FE = @viiTotalLetras
			,condicion_pago_FE = @viiCondPago
			,orden_compra_FE = @viiOC
		WHERE 
		nrofac_FE = @viiFacturas
		AND tipodoc_FE = @viiTipo
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Eliminar_ConfVehicular]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Eliminar_ConfVehicular]
(@idconf int)
AS

DECLARE @Existe int  


SELECT @existe = count(idConf) 
FROM TQPLAAUT (NOLOCK)
WHERE idConf = @idConf 

IF @existe = 0   
BEGIN
   DELETE TQCONFVEHIC WHERE idconf = @idconf    
END  

GO
/****** Object:  StoredProcedure [dbo].[USP_FE_COMBO_ND_NC]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_COMBO_ND_NC] 
@TIPO VARCHAR(2)
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
	descripcion00 AS descripcion
	FROM COD_NC_ND_00 WITH (NOLOCK)
	WHERE tipodoc = @TIPO
	ORDER BY descripcion00 ASC
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_COMBOPAIS]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_COMBOPAIS]
AS
BEGIN
SET NOCOUNT ON;
	SELECT despai07 AS pais
	FROM TERMINAL..DQPAISES07
	ORDER BY despai07 ASC
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_COMBOPORCENTAJE]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_COMBOPORCENTAJE]    
AS    
BEGIN    
  SELECT '4' AS porcentaje 
  UNION    
  SELECT '12' AS porcentaje   
  UNION    
  SELECT '10' AS porcentaje    
  UNION  
  SELECT '15' AS porcentaje    
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_MENSAJE_ERROR]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_MENSAJE_ERROR]
@NROFAC VARCHAR(12)
,@TIPO VARCHAR(2)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @MENSAJE VARCHAR(200)
	,@ICONT INT
	
	SET @MENSAJE = ''
	SET @NROFAC = LTRIM(RTRIM(@NROFAC))
	
	SELECT @ICONT = COUNT(*)
	FROM DCFACTTR01_FE WITH (NOLOCK)
	WHERE nrofac_FE = @NROFAC and tipodoc_FE = @TIPO
	AND ISNULL(flg_Trans_FE,'0') ='0' AND ISNULL(respuesta_FE,'') <> ''
	AND ISNULL(codigo_respuesta,1) <> 0
	
	IF @ICONT > 0
	BEGIN
		SELECT @MENSAJE = ( 'Factura Electronica: ' + prefijo_FE + SUBSTRING(nrofac_FE,1,3) + '-' + RIGHT('00000000' + SUBSTRING(nrofac_FE,4,7),8) + CHAR(13) + 'Error:' + CHAR(13) + ISNULL(respuesta_FE,'') )
		FROM DCFACTTR01_FE WITH (NOLOCK)
		WHERE nrofac_FE = @NROFAC and tipodoc_FE = @TIPO
	END
	
	SELECT @MENSAJE AS mensaje
	
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_MOSTRAR_MENSAJE_ERROR]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_MOSTRAR_MENSAJE_ERROR] @NROFAC VARCHAR(12)
	,@TIPO VARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MENSAJE VARCHAR(200)
		,@ICONT INT

	SET @MENSAJE = ''
	SET @NROFAC = LTRIM(RTRIM(@NROFAC))

	SELECT @ICONT = COUNT(*)
	FROM DCFACTTR01_FE WITH (NOLOCK)
	WHERE nrofac_FE = @NROFAC
		AND tipodoc_FE = @TIPO
		--AND ISNULL(flg_Trans_FE, '0') = '0'
		--AND ISNULL(respuesta_FE, '') <> ''
		AND ISNULL(codigo_respuesta, 1) = 0
		AND ISNULL(cod_estado_FE,'') <> ''
		
	IF @ICONT > 0
	BEGIN
		SELECT @MENSAJE = B.desc_estado_FE
		FROM DCFACTTR01_FE A WITH (NOLOCK)
		INNER JOIN DDDESCCODFACT_FE00 B WITH (NOLOCK) ON A.cod_estado_FE = B.cod_estado_FE
		WHERE LTRIM(RTRIM(nrofac_FE)) = LTRIM(RTRIM(@NROFAC))
			AND tipodoc_FE = @TIPO
		
		SELECT @MENSAJE AS mensaje
	END
	ELSE
	BEGIN
		SELECT @MENSAJE AS mensaje
	END

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_OBTENER_CORREOPAIS]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_OBTENER_CORREOPAIS]
@RUC VARCHAR(11)
AS
BEGIN
SET NOCOUNT ON;
	SELECT despai07 AS pais
	,IDENTITY(INT,1,1) AS ID
		INTO #PAIS
	FROM TERMINAL..DQPAISES07
	ORDER BY despai07 ASC
	
	SELECT 
	correo_des = ISNULL(A.correo,'')
	,CASE WHEN B.pais IS NULL THEN 104
							  ELSE B.ID - 1
							  END AS Index_des
	FROM TQCLIENTE A WITH (NOLOCK)
	LEFT JOIN #PAIS B ON LTRIM(RTRIM(A.despai07)) = LTRIM(RTRIM(B.pais))
	WHERE rucclien = @RUC
	
	DROP TABLE #PAIS
	
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_OBTENER_DET]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_OBTENER_DET] @FACT VARCHAR(12)
	,@TIPO VARCHAR(2)
AS
BEGIN
	SET @FACT = LTRIM(RTRIM(@FACT))

	IF EXISTS (
			SELECT nrofac_FE
			FROM DCFACTTR01_FE WITH (NOLOCK)
			WHERE nrofac_FE = @FACT
				AND tipodoc_FE = @TIPO
			)
	BEGIN
		SELECT 'SI' AS dato
			,porcentaje = CASE 
				WHEN porc_det_FE * 100 = 10 THEN 0
				WHEN porc_det_FE * 100 = 15 THEN 1
				ELSE 2
				END
			,valorref = valor_det_FE
			,flag_Det = flgdetraccion_FE
			,nro_orden = ISNULL(orden_compra_FE, '')
			,guia_remision = ISNULL(guia_remision_FE, '')
		FROM DCFACTTR01_FE WITH (NOLOCK)
		WHERE nrofac_FE = @FACT
			AND tipodoc_FE = @TIPO
	END
	ELSE
	BEGIN
		SELECT 'NO' AS dato
			,porcentaje = 0
			,valorref = 0
			,flag_Det = 0
			,nro_orden = ''
			,guia_remision = ''
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FE_OBTENER_DETRACCION]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[USP_FE_OBTENER_DETRACCION] --FMCR
--@FACT VARCHAR(12)
--,@TIPO VARCHAR(2)
--AS
--BEGIN
--	SET @FACT = LTRIM(RTRIM(@FACT))
--	IF EXISTS (
--				SELECT nrofac01
--				FROM DCFACTTR01 WITH (NOLOCK)
--				WHERE nrofac01 = @FACT  AND tipdoc01 = @TIPO
--				AND pocref01 IS NOT NULL
--			   )
--	BEGIN
--		SELECT 'SI' AS dato
--		,porcentaje = CASE WHEN pocref01 * 100 = 4 THEN 0
--												   ELSE 1
--												   END
--		,valorref = valref01
--		FROM DCFACTTR01 WITH (NOLOCK)
--		WHERE nrofac01 = @FACT  AND tipdoc01 = @TIPO
--	END
--	ELSE
--	BEGIN
--		SELECT 'no' AS dato
--		,porcentaje = 0
--		,valorref = 0
--	END
--END
--GO
/****** Object:  StoredProcedure [dbo].[USP_FE_REGISTRO_CLIENTES]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_FE_REGISTRO_CLIENTES]
@RUC VARCHAR(11)
,@CORREO VARCHAR(100)
,@PAIS VARCHAR(30)
AS
BEGIN
	DECLARE @CODPAI VARCHAR(2)
	
	SET @CORREO = LTRIM(RTRIM(@CORREO))
	SET @PAIS = LTRIM(RTRIM(@PAIS))
	
	SELECT @CODPAI = codpai07
	FROM TERMINAL..DQPAISES07
	WHERE LTRIM(RTRIM(despai07)) = @PAIS
	
	UPDATE TQCLIENTE
	SET codpai07 = @CODPAI
	,despai07 = @PAIS
	,correo = @CORREO
	WHERE rucclien = @RUC
END

GO
/****** Object:  StoredProcedure [dbo].[USP_FE_UPDATE_DETRACCION]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[USP_FE_UPDATE_DETRACCION]  --FMCR
--@FACT VARCHAR(12)
--,@TIPO VARCHAR(2)
--,@PORCENTAJE DECIMAL (10,2)
--,@VALOR DECIMAL(10,2)
--AS
--BEGIN
--	SET @FACT = LTRIM(RTRIM(@FACT))
--	UPDATE DCFACTTR01
--	SET pocref01 = @PORCENTAJE
--	,valref01 = @VALOR
--	WHERE nrofac01 = @FACT  AND tipdoc01 = @TIPO
--END
--GO
/****** Object:  StoredProcedure [dbo].[usp_Listar_ConfVehicular]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Nuevos Stored Procedures*/
ALTER PROCEDURE [dbo].[usp_Listar_ConfVehicular]
AS

SELECT * FROM TQCONFVEHIC (NOLOCK) ORDER BY descripcion

GO
/****** Object:  StoredProcedure [dbo].[usp_Modificar_ConfVehicular]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Modificar_ConfVehicular]
(@idconf int,  
@descripcion varchar(10),
@cargaUtil decimal(12,2),
@usuario varchar(30))
AS

UPDATE TQCONFVEHIC
SET descripcion = @descripcion,
    cargaUtil = @cargaUtil,
    usuario = @usuario,
    fecMod = getdate()
WHERE idconf = @idconf

GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_DOC_TRANSMITIDO]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_DOC_TRANSMITIDO]
@NRODOC  VARCHAR(25)
,@TIPO VARCHAR(2)
AS
BEGIN
	SET @NRODOC = LTRIM(RTRIM(@NRODOC))
	
	--//OBTENER CODIFICACION DEL DOCUMENTO
	CREATE TABLE #DOCUMENTO
	(
	NRODOCUMENTO VARCHAR(15)
	)
	
	IF @TIPO = '20'
	BEGIN
		INSERT INTO #DOCUMENTO
		EXEC USP_CRE_TRITON_CORRELATIVO @NRODOC
	END
	ELSE
	BEGIN
		DECLARE @PREFIJO VARCHAR(1)
		,@TIP VARCHAR(2)
		
		SELECT @PREFIJO = prefijo_FE
		FROM DCFACTTR01_FE WITH (NOLOCK)
		WHERE tipodoc_FE = @TIPO
		AND LTRIM(RTRIM(nrofac_FE)) = LTRIM(RTRIM(@NRODOC))
		
		IF @PREFIJO = 'F'
		BEGIN
			SET @TIP = '01'
		END
		ELSE
		BEGIN
			SET @TIP = '03'
		END
		
		INSERT INTO #DOCUMENTO
		EXEC USP_CODIGO_NRODOCUMENTO @NRODOC,@TIP
	END

	SELECT NRODOCUMENTO FROM #DOCUMENTO
	DROP TABLE #DOCUMENTO
	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_ID_CANCELACION]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_ID_CANCELACION]
@ID_NUMERO VARCHAR(15) OUT
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @FEC VARCHAR(8)
	DECLARE @NUM INT
	
	SET @FEC = CONVERT(VARCHAR(8),GETDATE(),112)
	
	IF EXISTS(
				SELECT *
				FROM CORR_CANCE00 WITH (NOLOCK)
				WHERE FECHA = @FEC
			  )
	BEGIN
		SELECT @NUM = NUMERO + 1
		FROM CORR_CANCE00 WITH (NOLOCK)
		WHERE FECHA = @FEC
		
		UPDATE CORR_CANCE00 SET NUMERO = @NUM
		WHERE FECHA = @FEC
	END
	ELSE
	BEGIN
		SET @NUM = 1
		
		INSERT INTO CORR_CANCE00
		VALUES(@FEC,@NUM)
	END
	
	SET @ID_NUMERO = RIGHT('00000' + ltrim(rtrim( CAST(@NUM AS VARCHAR) )), 5)
	RETURN @ID_NUMERO
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_NAME_MONEY]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_NAME_MONEY]
@TIPO VARCHAR(1)
AS
BEGIN
SET NOCOUNT ON;
	IF @TIPO = '1'
	BEGIN
		SELECT 'SOLES' AS 'NameMoney'
		RETURN;
	END
	IF @TIPO = '2'
	BEGIN
		SELECT 'DOLARES AMERICANOS' AS 'NameMoney'
		RETURN;
	END
	SELECT '' AS 'NameMoney'
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_NRODOC_PREF_OFISIS]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_OBTENER_NRODOC_PREF_OFISIS '0009-0000013102','01','009','0090013102'  
ALTER PROCEDURE [dbo].[USP_OBTENER_NRODOC_PREF_OFISIS] @DOC_OFISIS VARCHAR(20)
	,@TIPDOC VARCHAR(2)
	,@SERIE VARCHAR(4)
	,@NRODOC VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;
	SET @DOC_OFISIS = LTRIM(RTRIM(@DOC_OFISIS))
	SET @SERIE = LTRIM(RTRIM(@SERIE))
	SET @NRODOC = LTRIM(RTRIM(@NRODOC))

	DECLARE @DOCUMENTO_FE VARCHAR(20)
	DECLARE @PREFIJO AS VARCHAR(1)
	DECLARE @SERIE_FE VARCHAR(3)
	--|OBTENER VARIABLES    
	DECLARE @cadena VARCHAR(1000)
		,@caracter VARCHAR(1)

	SET @caracter = '-'
	SET @cadena = LTRIM(RTRIM(@DOC_OFISIS))

	DECLARE @NUMERO_OF VARCHAR(11)
	DECLARE @pos INT
		,@valor VARCHAR(10)

	SET @cadena = @cadena + @caracter
	SET @pos = charindex(@caracter, @cadena)
	SET @cadena = substring(@cadena, @pos + 1, len(@cadena))
	SET @pos = charindex(@caracter, @cadena)
	--|OBTENER NUMERO SIN SERIE   
	SET @NUMERO_OF = substring(@cadena, 1, @pos - 1)

	--//BUSCAR SERIE  
	IF EXISTS (
			SELECT *
			FROM DCFACTTR01_FE WITH (NOLOCK)
			WHERE tipodoc_FE = @TIPDOC
				AND LTRIM(RTRIM(nrofac_FE)) = @NRODOC
			)
	BEGIN
		SELECT @PREFIJO = LTRIM(RTRIM(prefijo_FE))
		FROM DCFACTTR01_FE WITH (NOLOCK)
		WHERE tipodoc_FE = @TIPDOC
			AND LTRIM(RTRIM(nrofac_FE)) = @NRODOC

		SET @SERIE_FE = RIGHT('000' + ltrim(rtrim(@SERIE)), 3)
		SET @DOCUMENTO_FE = @PREFIJO + @SERIE_FE + '-' + @NUMERO_OF  
		--SET @DOCUMENTO_FE = @DOC_OFISIS
	END
	ELSE
	BEGIN
		SET @DOCUMENTO_FE = @DOC_OFISIS
	END

	--//  
	SELECT @DOCUMENTO_FE AS nrodoc

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_NRODOC_PREF_OFISIS_DOCASOCIADO]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_OBTENER_NRODOC_PREF_OFISIS_DOCASOCIADO 'A020000001'    
ALTER PROCEDURE [dbo].[USP_OBTENER_NRODOC_PREF_OFISIS_DOCASOCIADO] 
	@NRODOCREFERENCIA VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SERIE VARCHAR(3)
	,@NROFAC VARCHAR(10)
	,@DOCUMENTO_FE VARCHAR(20)
	
	SET @SERIE = SUBSTRING(@NRODOCREFERENCIA,1,3)
	SET @NROFAC = (right('0000000000'+ (SUBSTRING(@NRODOCREFERENCIA,4,7)) ,(10)))
	
	IF SUBSTRING(@NRODOCREFERENCIA,1,1) = 'A'
	BEGIN
		SET @DOCUMENTO_FE = 'F' + @SERIE + '-' + @NROFAC
	END
	ELSE IF SUBSTRING(@NRODOCREFERENCIA,1,1) = 'V'
	BEGIN
		SET @DOCUMENTO_FE = 'B' + @SERIE + '-' + @NROFAC
	END
	ELSE
	BEGIN
		SET @DOCUMENTO_FE = '0' + @SERIE + '-' + @NROFAC
	END
   
	SELECT @DOCUMENTO_FE AS nrodoc

	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_PENDIENTES_FE_DOC]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_PENDIENTES_FE_DOC]
AS
BEGIN
	SET NOCOUNT ON;

	--//OBTENER SOLO LAS FACTURAS QUE SE ENCUENTREN CONTABILIZADAS SIN ANULACION    
	SELECT nrofactura = a.nrofac01
		,nrodoc = a.tipdoc01
		,user_SOL = '20138322000'
		,pass_SOL = 'd1d26c06e65b8f01'
	FROM DCFACTTR01 A WITH (NOLOCK)
	INNER JOIN DCFACTTR01_FE B WITH (NOLOCK) ON A.nrofac01 = LTRIM(RTRIM(B.nrofac_FE))
		AND A.tipdoc01 = B.tipodoc_FE
	WHERE ISNULL(B.flg_Trans_FE, '0') <> '1'
		AND A.flagCont = 'U'
		AND A.flages01 <> 'A'
		AND A.fecemi01 >= '20170820'
		AND SUBSTRING(a.nrofac01,1,3) IN ('A01','A02','A03','V01','C01','C02','C03','D01','D02','D03')
	--AND ISNULL(A.NroOfisis,0) > 0    
	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_PENDIENTES_FE_GETSTATUS]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_PENDIENTES_FE_GETSTATUS]
AS
BEGIN
	SET NOCOUNT ON;

	--//OBTENER SOLO LAS FACTURAS QUE SE HAN TRANSMITIDAS AL WEB SERVICE DE EFACT    
	--//CUYO ESTADO NO SEHA 213: DADO DE BAJA, 220: APROBADO POR SUNAT          
	SELECT nrofactura = a.nrofac01
		,nrodoc = a.tipdoc01
		,user_SOL = '20138322000'
		,pass_SOL = 'd1d26c06e65b8f01'
	FROM DCFACTTR01 A WITH (NOLOCK)
	INNER JOIN DCFACTTR01_FE B WITH (NOLOCK) ON A.nrofac01 = LTRIM(RTRIM(B.nrofac_FE))
		AND A.tipdoc01 = B.tipodoc_FE
	WHERE ISNULL(B.flg_Trans_FE, '0') = '1'
		AND ISNULL(B.cod_estado_FE, '') NOT IN (
			'13'
			,'40'
			,'41'
			)
		--AND LTRIM(RTRIM(B.nrofac_FE)) = '0010065365'    
		--AND B.tipodoc_FE='01'      
		AND B.fecha_Envio_FE >= DATEADD(MONTH, - 1, GETDATE())
		AND A.fecemi01 >= '20170820'    
		AND SUBSTRING(a.nrofac01,1,3) IN ('A01','A02','A03','V01','C01','C02','C03','D01','D02','D03')
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_REPORTE_DOC_FE]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REPORTE_DOC_FE]
AS
BEGIN
	SELECT TIPO_DOCUMENTO = CASE 
			WHEN A.tipodoc_FE = '01'
				THEN 'FACTURA'
			WHEN A.tipodoc_FE = '03'
				THEN 'BOLETA'
			WHEN A.tipodoc_FE = '07'
				THEN 'NOTA DE CREDITO'
			WHEN A.tipodoc_FE = '08'
				THEN 'NOTA DE DEBITO'
			ELSE 'SN'
			END
		,NRO_DOCUMENTO = (A.prefijo_FE + '' + SUBSTRING(nrofac_FE, 1, 3) + '-' + RIGHT('00000000' + ltrim(rtrim(SUBSTRING(nrofac_FE, 4, 7))), 8))
		,ESTADO = B.desc_estado_FE
		,A.fecha_Envio_FE AS FECHA_TRANSMISION
	FROM DCFACTTR01_FE A WITH (NOLOCK)
	INNER JOIN DDDESCCODFACT_FE00 B WITH (NOLOCK) ON A.cod_estado_FE = B.cod_estado_FE
	WHERE A.fecha_Envio_FE >= DATEADD(MONTH, - 1, GETDATE())
	ORDER BY fecha_Envio_FE DESC
END
GO
/****** Object:  StoredProcedure [dbo].[usp_rpt_viajes_facturados]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[usp_rpt_viajes_facturados]
(@nroFac01 char(10),
@tipdoc01 char(2),
@idconta01 int
)
AS
BEGIN


DECLARE @tipo_cir char(1)

--rdelacuba 12/10/2006: Ubicando el tipo de circuito
SELECT @tipo_cir = Q.Tipocir01
FROM DCFACTTR01 AS A (NOLOCK) INNER JOIN DDFACTTR01 as B (NOLOCK) ON        
	A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01    
	INNER join DCGUITTR01 AS C (NOLOCK) ON  B.nrodet01 = C.nrodet01        
	INNER join CQTARCIR01 AS T (NOLOCK) ON C.idtarifa = T.idtarifa
	INNER JOIN CQCIRCUI01 AS Q (NOLOCK) ON T.idcircuito = Q.idcircuito
WHERE A.nroFac01 = @nroFac01 AND A.tipdoc01 = @tipdoc01 AND A.idconta01 = @idconta01 


--rdelacuba 12/10/2006: Diferenciar los datos de valor referencial por tipo de circuito, así como los puntos origen y destino
IF  @tipo_cir = 'C'
BEGIN
--obtener el valor referencial del maestro de tarifas
SELECT A.nrofac01, 
B.nrodet01,
C.idcircuito,
D.PtoOrigen,
D.PtoDestino,
C.nropla01,
F.idconf,
G.descripcion,
G.cargautil,
(isnull(B.cantid01,0) * isnull(B.preuni01,0)) * (1 + isnull(A.impven01,0)) AS FACTURADO,
E.valref
FROM DCFACTTR01 AS A INNER JOIN DDFACTTR01 AS B ON A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01        
		     INNER JOIN DCGUITTR01 AS C ON B.nrodet01 = C.nrodet01        
		     INNER JOIN CQCIRCUI01 AS D ON C.idcircuito = D.idcircuito
		     INNER JOIN CQTARCIR01 AS E ON D.idcircuito = E.idcircuito and C.idtarifa = E.idtarifa
		     INNER JOIN TQPLAAUT AS F ON C.nropla01 = F.nropla81
		     LEFT OUTER JOIN TQCONFVEHIC AS G ON F.idconf = G.idconf
WHERE A.nroFac01 = @nroFac01 
AND A.tipdoc01 = @tipdoc01 
AND A.idconta01 = @idconta01  

END
ELSE
BEGIN
--obtener el valor referencial de las guías
SELECT A.nrofac01, 
B.nrodet01,
C.idcircuito,
D.PtoOrigen,
D.PtoDestino,
C.nropla01,
F.idconf,
G.descripcion,
G.cargautil,
(isnull(B.cantid01,0) * isnull(B.preuni01,0)) * (1 + isnull(A.impven01,0)) AS FACTURADO,
C.valref
FROM DCFACTTR01 AS A INNER JOIN DDFACTTR01 AS B ON A.nrofac01 = B.nrofac01 and A.tipdoc01 = B.tipdoc01 and A.idconta01 = B.idconta01        
		     INNER JOIN DCGUITTR01 AS C ON B.nrodet01 = C.nrodet01        
		     INNER JOIN CQCIRCUI01 AS D ON C.idcircuito = D.idcircuito
		     INNER JOIN CQTARCIR01 AS E ON D.idcircuito = E.idcircuito and C.idtarifa = E.idtarifa
		     INNER JOIN TQPLAAUT AS F ON C.nropla01 = F.nropla81
		     LEFT OUTER JOIN TQCONFVEHIC AS G ON F.idconf = G.idconf
WHERE A.nroFac01 = @nroFac01 
AND A.tipdoc01 = @tipdoc01 
AND A.idconta01 = @idconta01  

END
   
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_FEDOC]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_FEDOC]
@NROFAC VARCHAR(10)
,@TIPO VARCHAR(2)
,@ERROREFACT VARCHAR(5000)
,@PDFFILE VARCHAR(7000)
,@ERRORSUNAT VARCHAR(5000)
,@CODRESPUESTA INT
,@TRAZA VARCHAR(7000)
AS
BEGIN
	DECLARE @FLGENVIO VARCHAR(1)
	
	IF @CODRESPUESTA = 0
	BEGIN
		SET @FLGENVIO = '1'
	END
	ELSE
	BEGIN
		SET @FLGENVIO = '0'
	END
	
	IF EXISTS(
				SELECT *
				FROM DCFACTTR01_FE WITH (NOLOCK)
				WHERE LTRIM(RTRIM(nrofac_FE)) = @NROFAC
				AND tipodoc_FE = @TIPO
			 )
	BEGIN
		UPDATE DCFACTTR01_FE
		SET PDF417_FE = @PDFFILE
		,respuesta_FE = @ERROREFACT
		,error_sunat = @ERRORSUNAT
		,codigo_respuesta = @CODRESPUESTA
		,flg_Trans_FE = '1'
		,fecha_Envio_FE = GETDATE()
		WHERE LTRIM(RTRIM(nrofac_FE)) = @NROFAC
		AND tipodoc_FE = @TIPO
		
		--//ENVIAR CORREO
		EXEC TERMINAL..USP_SEND_MAIL_FEDOC @ERROREFACT,@TRAZA,@CODRESPUESTA,@NROFAC,@TIPO
		--//
		
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_STATUS_FE]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_STATUS_FE]  
@NROFAC VARCHAR(15)  
,@TIPO VARCHAR(2)  
,@ERROREFACT VARCHAR(5000)  
,@PDFFILE VARCHAR(7000)  
,@CODSTATUS VARCHAR(10)  
,@TRAZA VARCHAR(7000)  
AS  
BEGIN  
	 DECLARE @COD_ESTADO VARCHAR(2)
	 
	 SET @CODSTATUS = LTRIM(RTRIM(@CODSTATUS))
	 SET @COD_ESTADO = RIGHT(@CODSTATUS,2) 
	 
	 UPDATE DCFACTTR01_FE  
	 SET   
	 cod_estado_FE = @COD_ESTADO  
	 WHERE LTRIM(RTRIM(nrofac_FE)) = LTRIM(RTRIM(@NROFAC))  
	 AND tipodoc_FE = @TIPO  
	   
	 --//ENVIAR CORREO  
	 EXEC TERMINAL..USP_SEND_MAIL_FEDOC_GETSTATUS @ERROREFACT,@TRAZA,@COD_ESTADO,@NROFAC,@TIPO  
	 --//  
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDACION_CARGAAUT_TRITON_CAB]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_VALIDACION_CARGAAUT_TRITON_CAB]
@viGuiatriton VARCHAR(10),
@viGuiaCliente VARCHAR(10),
@viCodCircuito VARCHAR(5),
@viNave VARCHAR(4),
@viViaje VARCHAR(10),
@viFecha VARCHAR(8),
@viBrevete VARCHAR(9),
@viPlaca VARCHAR(7),
@viPlacaCarreta VARCHAR(10),
@viRUC VARCHAR(11),
@viContenedor VARCHAR(11),
@viTamanoCtr VARCHAR(3),
@viDetalleCircuito VARCHAR(100),
@viTipoMerc VARCHAR(100),
@viMoneda VARCHAR(1),
@viTarifaD DECIMAL(15,2),
@viTarifaS DECIMAL(15,2),
@viComision DECIMAL(15,2)
AS
BEGIN
SET NOCOUNT ON;
	--|SETEO DE VARIABLES
	SET @viGuiatriton = LTRIM(RTRIM(@viGuiatriton))
	SET @viGuiaCliente = LTRIM(RTRIM(@viGuiaCliente))
	SET @viCodCircuito = LTRIM(RTRIM(@viCodCircuito))
	SET @viViaje = LTRIM(RTRIM(@viViaje))
	SET @viBrevete = LTRIM(RTRIM(@viBrevete))
	SET @viPlaca = LTRIM(RTRIM(@viPlaca))
	SET @viPlacaCarreta = LTRIM(RTRIM(@viPlacaCarreta))
	SET @viRUC = LTRIM(RTRIM(@viRUC))
	SET @viContenedor = LTRIM(RTRIM(@viContenedor))
	SET @viTamanoCtr = LTRIM(RTRIM(@viTamanoCtr))
	SET @viDetalleCircuito = LTRIM(RTRIM(@viDetalleCircuito))
	SET @viTipoMerc = LTRIM(RTRIM(@viTipoMerc))
	SET @viMoneda = LTRIM(RTRIM(@viMoneda))
	--|
	
	DECLARE @MENSAJE VARCHAR(2000)
	SET @MENSAJE = ''
	
	--|VALIDACION GUIA DE TRITON
	IF @viGuiatriton = ''
	BEGIN
		SET @MENSAJE = 'No se ha Ingresado la Guia de Triton'
	END
	--|
	
	--|VALIDACION CODIGO CIRCUITO
	IF @viCodCircuito = ''
	BEGIN
		SET @MENSAJE = 'No se ha Ingresado el Código de Circuito'
	END
	
	IF NOT EXISTS(SELECT * FROM CQCIRCUI01 WHERE LTRIM(RTRIM(codrut01)) = @viCodCircuito)
	BEGIN
		SET @MENSAJE = 'El código de circuito ingresado: ' + @viCodCircuito + ', No existe o no se encuentra Registrado'
	END
	--|
	
	--|VALIDACION BREVETE
	IF @viBrevete = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado el Brevete'
	END
	
	IF NOT EXISTS(SELECT * FROM Terminal..EQBREVET30 WHERE LTRIM(RTRIM(codbre30)) = @viBrevete)
	BEGIN
		SET @MENSAJE = 'El Brevete ingresado: ' + @viBrevete + ', No existe o no se encuentra Registrado'
	END
	--|
	
	--|VALIDACION PLACA
	IF @viPlaca = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado la Placa'
	END
	
	IF NOT EXISTS(SELECT * FROM tqplaaut WHERE LTRIM(RTRIM(nropla81)) = @viPlaca)
	BEGIN
		SET @MENSAJE = 'La placa ingresada: ' + @viPlaca + ', No existe o no se encuentra Registrado'
	END
	--|
	
	--|VALIDACION CLIENTE
	IF @viRUC = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado el RUC del Cliente'
	END
	
	IF NOT EXISTS(SELECT * FROM TQCLIENTE WHERE LTRIM(RTRIM(rucclien)) = @viRUC)
	BEGIN
		SET @MENSAJE = 'La RUC de Cliente Ingresado: ' + @viRUC + ', No existe o no se encuentra Registrado'
	END
	--|
	
	--|VALIDACION CONTENEDOR
	IF @viContenedor = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado el Contenedor'
	END
	--|
	
	--|VALIDACION TAMAÑO CONTENEDOR
	IF @viTamanoCtr = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado el tamaño del Contenedor'
	END
	--|

	--|VALIDACION DETALLE DEL CIRCUITO
	IF @viDetalleCircuito = ''
	BEGIN	
		SET @MENSAJE = 'No se ha Ingresado el detalle del Circuito'
	END
	--|	
	
	--|VALIDACION TIPO DE MERCADERIA
	IF @viTipoMerc<>'' AND @viTipoMerc <> 'CNTR LLENOS' AND @viTipoMerc <> 'CNTR VACIOS' AND @viTipoMerc <> 'OTRA MERCADERIA'
	BEGIN	
		SET @MENSAJE = 'El tipo de Mercadería ingresado: ' + @viTipoMerc + ', No es Valido ( Ingresar: CNTR LLENOS o CNTR VACIOS o OTRA MERCADERIA)'
	END
	--|
	
	--|VALIDACION MONEDA
	IF @viMoneda = ''
	BEGIN
		SET @MENSAJE = 'No se ha Ingresado la Moneda'
	END
	
	IF @viMoneda <> 'D' AND @viMoneda<>'S'
	BEGIN
		SET @MENSAJE = 'El tipo de Moneda Ingresado: ' + @viMoneda + ', No es Valido ( Ingresar: D o S)'
	END
	--|
	
	--|VALIDACION TARIFA
	IF @viMoneda = 'S'
	BEGIN
		IF @viTarifaS = 0
		BEGIN
			SET @MENSAJE = 'No se ha Ingresado la Tarifa en Soles (Debe ser mayor a cero)'
		END
	END
	IF @viMoneda = 'D'
	BEGIN
		IF @viTarifaD = 0
		BEGIN
			SET @MENSAJE = 'No se ha Ingresado la Tarifa en Dolares (Debe ser mayor a cero)'
		END
	END
	--|
	
	
	SELECT LTRIM(RTRIM(@MENSAJE)) AS 'Mensaje'
	
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDACION_CARGAAUT_TRITON_DET]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_VALIDACION_CARGAAUT_TRITON_DET]
@viGuiatriton VARCHAR(10),
@viContenedor VARCHAR(11),
@viTamanoCtr VARCHAR(2)
AS
BEGIN
SET NOCOUNT ON;
	SET @viGuiatriton = LTRIM(RTRIM(@viGuiatriton))
	SET @viContenedor = LTRIM(RTRIM(@viContenedor))
	SET @viTamanoCtr = LTRIM(RTRIM(@viTamanoCtr))
	
	DECLARE @MENSAJE VARCHAR(2000)
	SET @MENSAJE = ''
	
	IF @viGuiatriton = ''
	BEGIN
		SET @MENSAJE = 'No se ha ingresado la Guia de Triton'
	END
	
	IF @viContenedor = ''
	BEGIN
		SET @MENSAJE = 'No se ha ingresado el Contenedor'
	END
	
	IF @viContenedor = ''
	BEGIN
		SET @MENSAJE = 'No se ha ingresado tamaño del Contenedor'
	END
	
	SELECT @MENSAJE AS 'Mensaje'
	
SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [web].[SP_REPORTE_COMISIONES_FACT_RESUM]    Script Date: 08/03/2019 08:26:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[SP_REPORTE_COMISIONES_FACT_RESUM]  --'20070215','20070228', 'R'                      
@FECHA_INI CHAR(17),
@FECHA_FIN CHAR(17),
@COMISION  DECIMAL(12,2),
@TIPOFECHA CHAR(1)

AS         
BEGIN                  
create table #COMISIONES    
(    
BREVETE char(9),
CHOFER  varchar(130),
COD_PLAN varchar (15),
COMISION decimal(12,2),
COMISIONTOTAL decimal(12,2) 
)    
    
INSERT INTO #COMISIONES

SELECT                           
D.BREVETE AS BREVET01, 
d.Apellido+', '+d.Nombre as CHOFER, 
TelefCelu as Cod_plan,
B.COMISION,
B.COMISION/(case when (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) = 0 then 1   else (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
FROM DCGUITTR01 AS B (NOLOCK)
inner join dbo.DDFACTTR01 as x (NOLOCK) on b.nrodet01 = x.nrodet01 
inner join dbo.DCFACTTR01 as y (NOLOCK) on x.nrofac01 = y.nrofac01 
left join DDGUITTR01 AS E (NOLOCK) ON B.NROGUI01 = E.NROGUI01 
LEFT JOIN tqchofer AS D (NOLOCK) ON D.brevete = B.BREVET01   
LEFT join tqplaaut as F (NOLOCK) ON  B.NROPLA01 = F.NROPLA81                  
WHERE (CASE WHEN @TIPOFECHA = 'R'  THEN b.fecreg01 ELSE b.fecgen01 END) BETWEEN @FECHA_INI AND @FECHA_FIN  -- '20090104' AND '20090105'
AND B.descircu is not null  and b.idcircuito <> 14       
UNION                
SELECT  D.BREVETE AS BREVET01,  
d.Apellido+', '+d.Nombre AS CHOFER,
TelefCelu as Cod_plan,
G.COMISION40,
G.COMISION40/(case when (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK) WHERE nrogui01 = B.nrogui01) = 0 then 1  else (SELECT count(nrogui01) FROM DDGUITTR01 (NOLOCK)  WHERE nrogui01 = B.nrogui01) end ) as comisiontotal
FROM DCGUITTR01 AS B (NOLOCK)
inner join CQTARCIR01 AS G (NOLOCK) ON  B.idcircuito = G.idcircuito AND B.IDTARIFA = G.IDTARIFA  
INNER JOIN CQCIRCUI01 AS C (NOLOCK) ON C.idcircuito = G.idcircuito  
inner join dbo.DDFACTTR01 as x (NOLOCK) on b.nrodet01 = x.nrodet01
inner join dbo.DCFACTTR01 as y (NOLOCK) on x.nrofac01 = y.nrofac01 
left join DDGUITTR01 AS E (NOLOCK) ON B.NROGUI01 = E.NROGUI01  
LEFT JOIN tqchofer AS D (NOLOCK) ON D.brevete = B.BREVET01  
LEFT join tqplaaut as F (NOLOCK) ON  B.NROPLA01 = F.NROPLA81                  
where 
(CASE WHEN @TIPOFECHA = 'R'  THEN b.fecreg01 ELSE b.fecgen01 END)  BETWEEN  @FECHA_INI AND @FECHA_FIN   --'20090104' AND '20090105'
and  b.idcircuito <> 14       


SELECT BREVETE,CHOFER,COD_PLAN,SUM(COMISIONTOTAL) as COMISION FROM #COMISIONES
GROUP BY BREVETE,CHOFER,COD_PLAN
HAVING  SUM(COMISIONTOTAL) >= @COMISION    

DROP TABLE  #COMISIONES            
RETURN 0

END

GO
