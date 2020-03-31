----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure sp_fill_inventarios_gastos  
                                                                                                                                                                                                                
as  
                                                                                                                                                                                                                                                         
begin  
                                                                                                                                                                                                                                                      
	declare @periodo char(6)  
                                                                                                                                                                                                                                  
	select @periodo = '200601'  
                                                                                                                                                                                                                                
	
                                                                                                                                                                                                                                                            
	-- borrar data previa  
                                                                                                                                                                                                                                     
	delete from inventarios_gastos   
                                                                                                                                                                                                                           
	where periodo >= @periodo  
                                                                                                                                                                                                                                 
	
                                                                                                                                                                                                                                                            
	-- buscar tipo de cambio fin de mes  
                                                                                                                                                                                                                       
	select convert(char(6), df_vigencia, 112) as periodo,  
                                                                                                                                                                                                     
	max(df_vigencia) as fechamax  
                                                                                                                                                                                                                              
	into #tc_fecha  
                                                                                                                                                                                                                                            
	from CALW12SQLCORP.NEPT9_bd_inst.dbo.tb_tipo_cambio_inst x   
                                                                                                                                                                                                         
	where x.dc_tipo_paridad='CIEVEN'   
                                                                                                                                                                                                                         
	group by convert(char(6), x.df_vigencia, 112)  
                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
	select   
                                                                                                                                                                                                                                                   
	convert(char(6), df_vigencia, 112) as periodo,  
                                                                                                                                                                                                            
	dq_tipo_de_cambio as tc  
                                                                                                                                                                                                                                   
	into #tc  
                                                                                                                                                                                                                                                  
	from CALW12SQLCORP.NEPT9_bd_inst.dbo.tb_tipo_cambio_inst x,  #tc_fecha y  
                                                                                                                                                                                            
	where dc_tipo_paridad='CIEVEN'  
                                                                                                                                                                                                                            
		and dc_moneda_origen=1 and dc_moneda=2  
                                                                                                                                                                                                                   
		and convert(char(6), df_vigencia, 112) = y.periodo  
                                                                                                                                                                                                       
		and df_vigencia = y.fechamax  
                                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
	-- tipo de gasto  
                                                                                                                                                                                                                                          
	create table #tgasto  
                                                                                                                                                                                                                                      
	(codigo int null,  
                                                                                                                                                                                                                                         
		descripcion char(50) null)  
                                                                                                                                                                                                                               
	
                                                                                                                                                                                                                                                            
	insert into #tgasto values(3001, 'Combustible Diesel')  
                                                                                                                                                                                                    
	insert into #tgasto values(3002, 'Combustible Gas')  
                                                                                                                                                                                                       
	insert into #tgasto values(3003, 'Combustible Gasolina')  
                                                                                                                                                                                                  
	insert into #tgasto values(3004, 'Filtros')  
                                                                                                                                                                                                               
	insert into #tgasto values(3005, 'Herramientas y Equipos de Taller')  
                                                                                                                                                                                      
	insert into #tgasto values(3006, 'Llantas Nuevas')  
                                                                                                                                                                                                        
	insert into #tgasto values(3007, 'Llantas Reencauchadas')  
                                                                                                                                                                                                 
	insert into #tgasto values(3008, 'Lubricantes')  
                                                                                                                                                                                                           
	insert into #tgasto values(3009, 'Materiales')  
                                                                                                                                                                                                            
	insert into #tgasto values(3010, 'REPARACION DE MOTOR')  
                                                                                                                                                                                                   
	insert into #tgasto values(3011, 'Repuestos')  
                                                                                                                                                                                                             
	insert into #tgasto values(3012, 'Trabajo de Terceros/Servicios')  
                                                                                                                                                                                         
	
                                                                                                                                                                                                                                                            
	-- centro de costo  
                                                                                                                                                                                                                                        
	create table #cc  
                                                                                                                                                                                                                                          
	(codigo int null, descripcion char(100) null)  
                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
	insert into #cc values (1, 'IMPORTACION CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                                       
	insert into #cc values (2, 'EXPORTACION CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                                       
	insert into #cc values (3, 'VACIOS DEPOSITO DE VACIOS DEPOT')  
                                                                                                                                                                                             
	insert into #cc values (4, 'REEFER DEPOSITO DE VACIOS ANEXO')  
                                                                                                                                                                                             
	insert into #cc values (5, '5')  
                                                                                                                                                                                                                           
	insert into #cc values (6, 'PAÑOL PAÑOL')  
                                                                                                                                                                                                                 
	insert into #cc values (7, 'ESTIBA / DESESTIBA CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                                
	insert into #cc values (8, '8')  
                                                                                                                                                                                                                           
	insert into #cc values (9, '9')  
                                                                                                                                                                                                                           
	insert into #cc values (10, '10')  
                                                                                                                                                                                                                         
	insert into #cc values (11, '11')  
                                                                                                                                                                                                                         
	insert into #cc values (12, '12')  
                                                                                                                                                                                                                         
	insert into #cc values (13, 'FORWARDER CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                                        
	insert into #cc values (14, '14')  
                                                                                                                                                                                                                         
	insert into #cc values (15, 'FILETAINER')  
                                                                                                                                                                                                                 
	insert into #cc values (16, 'MULTITAINER')  
                                                                                                                                                                                                                
	insert into #cc values (17, 'ALMACEN / CENTROS DE DISTRIBUCION CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                
	insert into #cc values (18, 'ALMACEN / DEPOSITO ADUANERO CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                      
	insert into #cc values (19, 'ALMACEN / DEPOSITO SIMPLE CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                        
	insert into #cc values (20, 'ALMACEN EN FRIO')  
                                                                                                                                                                                                            
	insert into #cc values (21, 'CARGA DE PROYECTOS CENTRO LOGISTICO AV. ARG.')  
                                                                                                                                                                               
	insert into #cc values (22, '22')  
                                                                                                                                                                                                                         
	insert into #cc values (23, '23')  
                                                                                                                                                                                                                         
	insert into #cc values (24, '24')  
                                                                                                                                                                                                                         
	insert into #cc values (25, 'GASTOS ADMINISTRATIVOS')  
                                                                                                                                                                                                     
	insert into #cc values (26, 'SERVICIO INTEGRAL')  
                                                                                                                                                                                                          
	insert into #cc values (27, 'TERMINAL AEREO')  
                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
	-- guardar info  
                                                                                                                                                                                                                                           
	insert into inventarios_gastos  
                                                                                                                                                                                                                            
	select   
                                                                                                                                                                                                                                                   
		convert(int, left(dc_periodo,4)) as anio,  
                                                                                                                                                                                                                
		convert(int, substring(dc_periodo,5,2)) as mes,  
                                                                                                                                                                                                          
		datepart(d, df_emision_docto) as dia,  
                                                                                                                                                                                                                    
		0 as hora,  
                                                                                                                                                                                                                                               
		'OTROS GASTOS' as tipomovimiento,  
                                                                                                                                                                                                                        
		dc_rut as persona,  
                                                                                                                                                                                                                                       
		dg_movimiento as articulo,  
                                                                                                                                                                                                                               
		'' as maquina,  
                                                                                                                                                                                                                                           
		dn_cantidad as cantidad,  
                                                                                                                                                                                                                                 
		'' as unidad,  
                                                                                                                                                                                                                                            
--		sum( case when dq_monto_otra_moneda <> 0 then dq_monto_otra_moneda else dq_monto_moneda_base / tc end) as totaldolar,  
                                                                                                                                  
		sum( dq_monto_moneda_base / tc) as totaldolar,  
                                                                                                                                                                                                           
		100 as porcentaje,  
                                                                                                                                                                                                                                       
		sum( dq_monto_moneda_base / tc) as valordistribuidodolar,  
                                                                                                                                                                                                
		dc_centro_costo_imputacion as centrocosto,  
                                                                                                                                                                                                               
		dc_item_gasto as tipogasto,  
                                                                                                                                                                                                                              
		0 as ppto_real,  
                                                                                                                                                                                                                                          
		'CONTABILIDAD' as almacen,  
                                                                                                                                                                                                                               
		'' as codigo,  
                                                                                                                                                                                                                                            
		getdate() as fechafabricacion,  
                                                                                                                                                                                                                           
		'' as tipomquina,  
                                                                                                                                                                                                                                        
		dc_periodo  as periodo  
                                                                                                                                                                                                                                   
	from CALW12SQLCORP.NEPT9_BD_NEPT.dbo.tb_mov_aux_gast x, #tc y--, #tgasto z, #cc  
                                                                                                                                                                                     
	where dc_periodo >= @periodo  
                                                                                                                                                                                                                              
		and dc_item_gasto in (3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012)  
                                                                                                                                                            
		-- and dc_cuenta_mayor = '655300'  
                                                                                                                                                                                                                        
		and dg_movimiento not like 'Consumo Kardex Valorizado%'  
                                                                                                                                                                                                  
		and x.dc_periodo *= y.periodo collate Latin1_General_CI_AS  
                                                                                                                                                                                               
		and dm_estado_cdc = 'A'  
                                                                                                                                                                                                                                  
		and dc_centro_costo_imputacion not in (25)  
                                                                                                                                                                                                               
		-- and ltrim(rtrim(z.codigo)) =* ltrim(rtrim(dc_item_gasto))  
                                                                                                                                                                                             
		-- and ltrim(rtrim(#cc.codigo)) =* ltrim(rtrim(dc_centro_costo_imputacion))  
                                                                                                                                                                              
	group by dg_movimiento,  
                                                                                                                                                                                                                                   
		dc_periodo,  
                                                                                                                                                                                                                                              
		dc_item_gasto,  
                                                                                                                                                                                                                                           
		dc_centro_costo_imputacion,  
                                                                                                                                                                                                                              
		df_emision_docto,  
                                                                                                                                                                                                                                        
		dc_rut,  
                                                                                                                                                                                                                                                  
		dn_cantidad  
                                                                                                                                                                                                                                              
	having sum(dq_monto_moneda_base / tc) <> 0  
                                                                                                                                                                                                                
	
                                                                                                                                                                                                                                                            
	update inventarios_gastos  
                                                                                                                                                                                                                                 
	set centrocosto = x.descripcion  
                                                                                                                                                                                                                           
	from #cc x, inventarios_gastos  
                                                                                                                                                                                                                            
	where ltrim(rtrim(convert(char(100),x.codigo))) = inventarios_gastos.centrocosto  
                                                                                                                                                                          
	
                                                                                                                                                                                                                                                            
	update inventarios_gastos  
                                                                                                                                                                                                                                 
	set tipogasto = x.descripcion  
                                                                                                                                                                                                                             
	from #tgasto x, inventarios_gastos  
                                                                                                                                                                                                                        
	where ltrim(rtrim(convert(char(100),x.codigo))) = inventarios_gastos.tipogasto  
                                                                                                                                                                            
end  
                                                                                                                                                                                                                                                        
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER procedure sp_TIPOCAMBIO_ULTRA 
                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
	@df_vigencia      varchar(8),  -- Formato AAAAMMDDD
                                                                                                                                                                                                         
	@dc_tipo_paridad  varchar(5),   -- Valores: 'BANCA' o 'VENTA' 
                                                                                                                                                                                              
        @imp_TipoCambio   decimal( 10, 4 ) output,
                                                                                                                                                                                                           
        @str_result       varChar( 30 )    output
                                                                                                                                                                                                            
As
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
/*
                                                                                                                                                                                                                                                           
Declare @df_vigencia      varchar(8),  -- Formato AAAAMMDDD
                                                                                                                                                                                                  
        @dc_tipo_paridad  varchar(5)   -- Valores: 'BANCA' o 'VENTA' 
                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
SET @df_vigencia = '20070401'
                                                                                                                                                                                                                                
SET @dc_tipo_paridad = 'VENTA'
                                                                                                                                                                                                                               
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Set NoCount ON
                                                                                                                                                                                                                                               
IF Exists( select dq_tipo_de_cambio 
                                                                                                                                                                                                                         
           from CALW12SQLCORP.NEPT9_bd_inst.dbo.tb_tipo_cambio_INST
                                                                                                                                                                                                    
           where df_vigencia = @df_vigencia and 
                                                                                                                                                                                                             
                 dc_moneda_origen = 1 and dc_moneda = 2
                                                                                                                                                                                                      
                 and rtrim( dc_tipo_paridad ) = @dc_tipo_paridad )
                                                                                                                                                                                           
   Begin
                                                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
			  -- select dq_tipo_de_cambio as MontoTC, 'TC Ubicado' as Texto
                                                                                                                                                                                           
			  select @imp_TipoCambio = dq_tipo_de_cambio, @str_result = 'TC Ubicado' 
                                                                                                                                                                                 
           from CALW12SQLCORP.NEPT9_bd_inst.dbo.tb_tipo_cambio_INST
                                                                                                                                                                                                    
           where df_vigencia = @df_vigencia and 
                                                                                                                                                                                                             
                 dc_moneda_origen = 1 and 
                                                                                                                                                                                                                   
                 dc_moneda = 2 and 
                                                                                                                                                                                                                          
                 rtrim( dc_tipo_paridad ) = @dc_tipo_paridad
                                                                                                                                                                                                 
   End
                                                                                                                                                                                                                                                       
Else
                                                                                                                                                                                                                                                         
   Begin
                                                                                                                                                                                                                                                     
			  -- select 0 as MontoTC, 'TC No Ubicado' as Texto
                                                                                                                                                                                                        
           Set @imp_TipoCambio = 0 
                                                                                                                                                                                                                          
           Set @str_result = 'TC No Ubicado' 
                                                                                                                                                                                                                
   End
                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
Set Nocount OFF
                                                                                                                                                                                                                                              
