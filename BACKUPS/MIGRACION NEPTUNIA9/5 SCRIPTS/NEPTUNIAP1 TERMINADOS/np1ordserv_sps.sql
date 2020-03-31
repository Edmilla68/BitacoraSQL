----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------
                                                                                                                                                                           
GO  
 ALTER procedure  dbo.SP_GASTOS_ListaGastosFiltrado   
                                                                                                                                                                                                        
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
                                                                                                                                                             
	set @inner = ' inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = g.CODIGO_de_ultragestion'  
                                                                                                                                  
  end  
                                                                                                                                                                                                                                                      
  
                                                                                                                                                                                                                                                           
if @intCenCos <> ''  
                                                                                                                                                                                                                                        
  begin  
                                                                                                                                                                                                                                                    
	 if @where =''  
                                                                                                                                                                                                                                            
	  	set @where = ' where sc.centro_costos ='+ @intCenCos  
                                                                                                                                                                                                   
	 else   
                                                                                                                                                                                                                                                    
	  	set @where = @where + ' and sc.centro_costos ='+@intCenCos   
                                                                                                                                                                                            
	 if @inner =''  
                                                                                                                                                                                                                                            
	  	set @inner = ' inner join CALW12SQLCORP.NPT9_bd_nept.dbo.gasto_sucursal_cencos sc on sc.item_de_gasto = g.CODIGO_de_ultragestion'  
                                                                                                                               
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
                                                                                                                                                                                                                                     
from CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES g  
                                                                                                                                                                                                     
'  
                                                                                                                                                                                                                                                          
print(@select + @inner + @where )  
                                                                                                                                                                                                                          
exec(@select + @inner + @where )  
                                                                                                                                                                                                                           
-----------------------------------------------------------------------------------------------------
                                                                                                                                                        

                                                                                                                                                                                                                                                             
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO  
 ALTER procedure  SP_GASTOS_MantenimientoLista  --4,'20050101','20051116','',57,'',5
                                                                                                                                                                          
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
                                                                                                                                                                                                   
	inner join neptunia1.seguridad.dbo.sgt_area as A on A.ARE_CODIGOINTERNO = O.ARE_CODIGOINTERNO
                                                                                                                                                               
	inner join OST_ORDEN_SERVICIO_HIJO as S on S.ose_Codigo = O.Ose_codigo 
                                                                                                                                                                                     
	inner join CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES as TS ON TS.id_codigo = s.CON_Codigo
                                                                                                                                                             
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
 ALTER procedure  dbo.SP_GASTOS_ObtenerListaGastos
                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
select 'con_servicio' = id_codigo,
                                                                                                                                                                                                                           
	'con_nombre'	= glosa_de_operaciones
                                                                                                                                                                                                                         
from  CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES
                                                                                                                                                                                                        
---------------------------------------------------------------------------
                                                                                                                                                                                  
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO  
 ALTER procedure  dbo.SP_GASTOS_ObtenerOrdenServicio  --70140
                                                                                                                                                                                                
	@intOrden	int
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
select 	'Orden'		= os.ose_codigo,
                                                                                                                                                                                                                            
	'Servicio'	= s.nombre,
                                                                                                                                                                                                                                      
	'CenCos'	= a.are_nombre,
                                                                                                                                                                                                                                    
	'FechaRe'	= os.ose_fecha_req,
                                                                                                                                                                                                                               
	'Proveedor'	= case 
                                                                                                                                                                                                                                         
			   when isnull(dbo.fn_BuscaDatos(@intOrden,166),'')<>'' then (select dg_razon_social from  CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona where dc_rut= dbo.fn_BuscaDatos(@intOrden,166))
                                                                               
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
 ALTER procedure  SP_GASTOS_ReportePreFactura --'10249902468','20051104','20051116' --70149
                                                                                                                                                                   
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
                                                                                                                                 
				when 1 then (select glosa_de_operaciones from CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES where id_codigo =oh.con_codigo ) COLLATE Modern_Spanish_CI_AS
                                                                                              
				else (select nombre from ordenesservicio.dbo.TAV_Servicio where servicio =oh.con_codigo)--(select servicio from ordenesservicio.dbo.TAV_ServicioArea where servicioarea =oh.con_codigo ))
                                                                
			  end ,
                                                                                                                                                                                                                                                   
	'Proveedor'	= case oh.osh_flagtiposer
                                                                                                                                                                                                                       
			  	when 1 then upper(ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,167))
                                                                                                                                                                                
				else (select dg_razon_social from CALW12SQLCORP.NPT9_bd_nept.dbo.tb_persona where dc_rut = ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,166) COLLATE Modern_Spanish_CI_AS )
                                                                                    
			  end,
                                                                                                                                                                                                                                                    
	'Sucursal'	= case oh.osh_flagtiposer
                                                                                                                                                                                                                        
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,171)
                                                                                                                                                                                         
				else (select dg_sucursal from CALW12SQLCORP.NPT9_bd_inst.dbo.tb_sucursal_inst where dc_sucursal = ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,164) COLLATE Modern_Spanish_CI_AS )
                                                                             
			  end,
                                                                                                                                                                                                                                                    
	'CenCos'	= case oh.osh_flagtiposer
                                                                                                                                                                                                                          
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,172) --(select oc_valor from ordenesservicio.dbo.ost_orden_servicio_config  where ose_codigo = os.ose_codigo and cam_codigo = 171)
                                                           
				else (select are_nombre from  ordenesservicio.dbo.SGV_Lista_Area where are_codigointerno = os.are_codigointerno)
                                                                                                                                         
			  end,
                                                                                                                                                                                                                                                    
	'Monto'		= ISNULL(T.MONTO,0.00),
                                                                                                                                                                                                                            
	'TipoMerca'	= case oh.osh_flagtiposer
                                                                                                                                                                                                                       
				when 1 then ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,163) COLLATE Modern_Spanish_CI_AS + ' ' + ordenesservicio.dbo.fn_BuscaDatos(os.ose_codigo,141) COLLATE Modern_Spanish_CI_AS --(select oc_valor from ordenesservicio.dbo.ost_orden_servicio_conf
ig  where ose_codigo = os.ose_codigo and cam_codigo = 163) + ' ' + (select oc_valor from ordenesservicio.dbo.ost_orden_servicio_config  where ose_codigo = os.ose_codigo and cam_codigo = 141)
                                                               
				else t.codembalaje + ' ' +t.tamanocont
                                                                                                                                                                                                                   
			  end
                                                                                                                                                                                                                                                     
from ordenesservicio.dbo.ost_orden_servicio os
                                                                                                                                                                                                               
inner join ordenesservicio.dbo.ost_orden_servicio_hijo oh on oh.ose_codigo = os.ose_codigo
                                                                                                                                                                   
inner join ordenesservicio.dbo.ost_orden_servicio_config oc on os.ose_codigo = oc.ose_codigo
                                                                                                                                                                 
INNER JOIN ORDENESSERVICIO.DBO.OST_GRUPO_SERVICIOAREA GS ON (GS.IDSERVICIOAREA = OH.CON_CODIGO and gs.flagtiporegistro = 0) or
                                                                                                                               
							     (gs.idservicioarea=(select servicioarea from ordenesservicio.dbo.TAV_ServicioArea
                                                                                                                                                                
									   where servicio = oh.con_codigo and  area= (select are_codigo from  ordenesservicio.dbo.SGV_Lista_Area where are_codigointerno = os.are_codigointerno)
                                                                                            
							      ) and gs.flagtiporegistro = 1) 
                                                                                                                                                                                                                 
left join neptunia1.terminal.dbo.dqtarser01 t	on 
                                                                                                                                                                                                            
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
                                                                                                                                                                     
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------
                                                                                                                                                                                  
GO  
 ALTER procedure  SP_GASTOS_SeleccionaPorCodigo 
                                                                                                                                                                                                              
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
                                                                                                                                                                                                                              
	CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES CS,
                                                                                                                                                                                                         
	OST_ESTADO ES
                                                                                                                                                                                                                                               
WHERE 
                                                                                                                                                                                                                                                       
	OSH.OSE_Codigo= @OSE_Codigo
                                                                                                                                                                                                                                 
	AND OSH.CON_Codigo = CS.Id_Codigo
                                                                                                                                                                                                                           
	AND OSH.EST_CODIGO = ES.EST_CODIGO
                                                                                                                                                                                                                          
--------------------------------------------------------------------------
                                                                                                                                                                                   
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------
                                                                                                                                                                                   
GO  
 ALTER procedure  dbo.SP_GASTO_ReporteGastos
                                                                                                                                                                                                                  
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
                                                                                                                                                                                      
inner join CALW12SQLCORP.NPT9_bd_nept.dbo.ROCKY_CODIGOS_OPERACIONES as TS ON TS.id_codigo = s.CON_Codigo
                                                                                                                                                              
where 	o.ose_codigo =@intOrden
                                                                                                                                                                                                                               
--------------------------------------------------------------------------
                                                                                                                                                                                   
