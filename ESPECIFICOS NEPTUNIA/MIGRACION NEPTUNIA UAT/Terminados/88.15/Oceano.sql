USE [Oceano]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SplitGenerico]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_SplitGenerico](@cadena varchar(100), @caracter varchar(1)) 
RETURNS @t TABLE (id INT IDENTITY(1,1), valor varchar(10))
AS
BEGIN
declare @pos int, @valor varchar(10)
         
set @cadena = @cadena + @caracter
set  @pos = charindex(@caracter,@cadena)
         
while(@pos <> 0)
begin
set @valor = substring(@cadena,1,@pos - 1)
insert into @t(valor) values(@valor)
set @cadena = substring(@cadena,@pos+1,len(@cadena))
set @pos = charindex(@caracter,@cadena)
end
    return
END
GO
/****** Object:  View [dbo].[TI_INCIDENCIAS_SERVICIOS_M]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TI_INCIDENCIAS_SERVICIOS_M]                
as                
select * from TI_INCIDENCIAS_SERVICIOS                
where year(fecha_sol)=year(getdate())           
--and month(fecha_sol)= month(getdate())
GO
/****** Object:  View [dbo].[v_Escomar_E02]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[v_Escomar_E02]    
as    
    
select motonave, bandera, f_salida, mes, anho, cia_nav, age_port, pto_emb, pto_desc,     
    con_emb, consignata,embarcador, det_prod, tip_prod, nom_prod, sectores, tipobienes,     
    cargapry, cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pdes, pais_pdfin,     
    no_manif, dest_fin, guia_mast, consolid, cons_dest, embarc_mix,     
    term_almac, teus, feus,     
    rec, viaje, num_manif, det_sunad,     
    custom1, custom2, fecha_carga    
from T_ESCOMAR_E02  
where anho>=2011
GO
/****** Object:  View [dbo].[v_Escomar_I02]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_Escomar_I02]        
as        
select distinct 
	motonave,		bandera,		f_llegada,		mes,			anho,			cia_nav,		
	age_port,		pto_emb,		proceden,		pto_desc,       con_emb,		consignata,		
	embarcador, 
    det_prod, 
    tip_prod, 
    part_aranc, 
    nom_prod, 
    sectores, 
    tipobienes,         
    cargapry, 
    cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pemb, pais_proc,         
    no_manif, det_sunad, guia_mast, consolid, cons_orig, consig_mix, notify, cli_final,         
    term_almac, teus, feus, no_dua,         
    f_numera, f_embarque, nom_decl, ruc_import, nom_import, dir_import, p_neto, fob, flete, seguro, cif, nandina, desc_part, des_mercdu,         
    custom1, custom2, fecha_carga        
from T_ESCOMAR_I02     
where anho >= YEAR(DATEADD ( MM, -24, GETDATE()))

GO
/****** Object:  View [dbo].[v_Escomar_I02_2011]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[v_Escomar_I02_2011]    
as    
select distinct motonave, bandera, f_llegada, mes, anho, cia_nav, age_port, pto_emb, proceden, pto_desc,     
    con_emb, consignata, embarcador, det_prod, tip_prod, part_aranc, nom_prod, sectores, tipobienes,     
    cargapry, cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pemb, pais_proc,     
    no_manif, det_sunad, guia_mast, consolid, cons_orig, consig_mix, notify, cli_final,     
    term_almac, teus, feus, no_dua,     
    f_numera, f_embarque, nom_decl, ruc_import, nom_import, dir_import, p_neto, fob, flete, seguro, cif, nandina, desc_part, des_mercdu,     
    custom1, custom2, fecha_carga    
from T_ESCOMAR_I02 
where anho=2011
GO
/****** Object:  View [dbo].[v_Escomar_I02_2012]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[v_Escomar_I02_2012]    
as    
select distinct motonave, bandera, f_llegada, mes, anho, cia_nav, age_port, pto_emb, proceden, pto_desc,     
    con_emb, consignata, embarcador, det_prod, tip_prod, part_aranc, nom_prod, sectores, tipobienes,     
    cargapry, cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pemb, pais_proc,     
    no_manif, det_sunad, guia_mast, consolid, cons_orig, consig_mix, notify, cli_final,     
    term_almac, teus, feus, no_dua,     
    f_numera, f_embarque, nom_decl, ruc_import, nom_import, dir_import, p_neto, fob, flete, seguro, cif, nandina, desc_part, des_mercdu,     
    custom1, custom2, fecha_carga    
from T_ESCOMAR_I02 
where anho=2012
GO
/****** Object:  View [dbo].[v_Escomar_I02_2013]    Script Date: 07/03/2019 04:06:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[v_Escomar_I02_2013]    
as    
select distinct motonave, bandera, f_llegada, mes, anho, cia_nav, age_port, pto_emb, proceden, pto_desc,     
    con_emb, consignata, embarcador, det_prod, tip_prod, part_aranc, nom_prod, sectores, tipobienes,     
    cargapry, cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pemb, pais_proc,     
    no_manif, det_sunad, guia_mast, consolid, cons_orig, consig_mix, notify, cli_final,     
    term_almac, teus, feus, no_dua,     
    f_numera, f_embarque, nom_decl, ruc_import, nom_import, dir_import, p_neto, fob, flete, seguro, cif, nandina, desc_part, des_mercdu,     
    custom1, custom2, fecha_carga    
from T_ESCOMAR_I02 
where anho=2013
GO
/****** Object:  View [dbo].[v_Escomar_P02]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[v_Escomar_P02]  
as  
  
select motonave, bandera, f_salida, mes, anho, cia_nav, age_port, pto_emb, pto_desc,   
    con_emb, consignata, embarcador, det_prod, tip_prod, nom_prod, sectores, tipobienes,   
    cargapry, cont_20, cont_40, convert(int,contenedores) Contenedores, stat_cont, cant_bulto, embalaje, peso, pais_pdes, pais_dfin,   
    no_manif, dest_fin, guia_mast, consolid, embarc_mix,   
    term_almac, teus, feus,   
    rec, viaje, num_manif, det_sunad,  
    custom1, custom2, fecha_carga  
from T_ESCOMAR_P02
where anho>=2013
GO
/****** Object:  StoredProcedure [dbo].[sp_Actualiza_Tiempo_Incidencias]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT sp_Actualiza_Tiempo_Incidencias

ALTER PROCEDURE [dbo].[sp_Actualiza_Tiempo_Incidencias]              
 as              
             
declare @iCant int            
set @iCant=0            
 select @iCant=count(*) from TI_INCIDENCIAS_SERVICIOS where anyo IN ('2013','2014') and             
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and             
 FECHA_ATE is null  
        
             
 if @iCant> 0            
 begin            
 return            
 end            
-- print 'pasa'               
update TI_INCIDENCIAS_SERVICIOS set TIEMPO_ATE=datediff(mi,FECHA_SOL,FECHA_ATE),           
TIEMPO_ATE_SD=datediff(mi,FECHA_SOL,FECHA_ATE) where anyo IN ('2013','2014') and               
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PROYECTOS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and               
 FECHA_ATE is not null              
PRINT 'FILAS AFECTADAS 1 : ' + CONVERT(VARCHAR,@@ROWCOUNT)               
 --Actualiza Tiempo Atencion cuando es Fuera de Horario              
               
update TI_INCIDENCIAS_SERVICIOS set TIEMPO_ATE=0,OBSERVACION='FUERA DE HORARIO'              
where anyo IN ('2013','2014') and               
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and              
 substring(CONVERT(char(8),FECHA_SOL,108),1,2) in ('19','20','21','22','23','00','01','02','03','04','05','06','07')              
PRINT 'FILAS AFECTADAS 2 : ' + CONVERT(VARCHAR,@@ROWCOUNT)                              
 --Actualiza Tiempo Atencion cuando es sabado y domigo              
              
update TI_INCIDENCIAS_SERVICIOS set TIEMPO_ATE=0,OBSERVACION='DOMINGO' where anyo IN ('2013','2014') and               
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and               
DATEPART(dw,FECHA_SOL)=1              
PRINT 'FILAS AFECTADAS 3 : ' + CONVERT(VARCHAR,@@ROWCOUNT)                              
              
update TI_INCIDENCIAS_SERVICIOS set TIEMPO_ATE=0,OBSERVACION='SABADO' where anyo IN ('2013','2014') and               
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and               
DATEPART(dw,FECHA_SOL)=7
PRINT 'FILAS AFECTADAS 4 : ' + CONVERT(VARCHAR,@@ROWCOUNT)                                   
    
update TI_INCIDENCIAS_SERVICIOS set TIEMPO_ATE=0 where anyo IN ('2013','2014') and               
 SISTEMA in ('OPERACIONES','FACTURACION','BALANZA','ADUANAS','PAGONET','DATA OPERATIVA E','DATA OPERATIVA I') and               
 OBSERVACION like '%PTIS%' 
 PRINT 'FILAS AFECTADAS 5 : ' + CONVERT(VARCHAR,@@ROWCOUNT)                              
 --select DATEPART(dw,getdate()) 
  
  
GO
/****** Object:  StoredProcedure [dbo].[sp_AddArea]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddArea]  
@area varchar(50)  
as  
insert into Area values (@area)  
GO
/****** Object:  StoredProcedure [dbo].[sp_AddEmpresa]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddEmpresa]  
@empresa varchar(50)  
as  
insert into Empresa values (@empresa)  
GO
/****** Object:  StoredProcedure [dbo].[sp_AddLocal]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddLocal]
@local varchar(50)
as
insert into local values (@local)
GO
/****** Object:  StoredProcedure [dbo].[sp_AddMarca]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddMarca]  
@marca varchar(50)  
as  
insert into marca values (@marca)
GO
/****** Object:  StoredProcedure [dbo].[sp_AddMicroprocesador]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddMicroprocesador]  
@micro varchar(100)    
as    
insert into Microprocesador values (@micro) 
GO
/****** Object:  StoredProcedure [dbo].[sp_AddModelo]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddModelo] 
@modelo varchar(50)  
as  
insert into Modelo values (@modelo) 
GO
/****** Object:  StoredProcedure [dbo].[sp_AddSistemaOperativo]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddSistemaOperativo]
@sistemaoperativo varchar(50)  
as  
insert into SistemaOperativo values (@sistemaoperativo) 
GO
/****** Object:  StoredProcedure [dbo].[sp_ESCOMAR_Actualiza_Info]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ESCOMAR_Actualiza_Info]    
@anho int  
as    
  
delete T_ESCOMAR_I02 where anho = @anho  
  
declare @sFecha as smalldatetime    
select @sFecha=getdate()    
insert into T_ESCOMAR_I02    
select     
motonave,    
bandera,    
f_llegada,    
mes=month(f_llegada),    
anho=year(f_llegada),    
cia_nav,    
age_port,    
pto_emb,    
proceden,    
pto_desc,    
con_emb,    
consignata,    
embarcador,    
det_prod,    
tip_prod,    
part_aranc,    
nom_prod,    
sectores='',    
tipobienes='',    
cargapry='',    
cont_20,    
cont_40,    
contenedores=cont_20+cont_40,    
stat_cont,    
cant_bulto,    
embalaje,    
peso,    
pais_pemb,    
pais_proc,    
no_manif,    
det_sunad,    
guia_mast,    
consolid,    
cons_orig,    
consig_mix,    
notify,    
cli_final,    
term_almac,    
teus,    
feus,    
no_dua,    
f_numera,    
f_embarque,    
nom_decl,    
ruc_import,    
nom_import,    
dir_import,    
p_neto,    
fob,    
flete,    
seguro,    
cif,    
nandina,    
desc_part,    
des_mercdu,    
custom1,    
custom2,    
@sFecha    
from T_ESCOMAR_I01 WITH(NOLOCK)   
    
delete T_ESCOMAR_I01    
    
update T_ESCOMAR_I02 set sectores=b.Rubro,    
       tipobienes=b.Tipo_Bienes           
from    
T_ESCOMAR_I02 a    
inner join T_ESCOMAR_MATRIZ_I b on (a.nom_prod=b.Nombre_Producto)    
where a.fecha_carga=@sFecha    
    
update T_ESCOMAR_I02 set cargapry=b.discrimina    
from    
T_ESCOMAR_I02 a    
inner join T_ESCOMAR_DISCRIMINA_I b on (a.nom_prod=b.Producto)    
where a.fecha_carga=@sFecha    
    
    
           
GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Actualiza_Producto]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Actualiza_Producto]
@TipoOperacion char(1)
as
begin
BEGIN TRANSACTION  
 
	declare @sFecha smalldatetime
	select distinct top 1 @sFecha = fecha_carga from T_ESCOMAR_I02 order by fecha_carga desc

	if @TipoOperacion = 'I'
	begin
		update T_ESCOMAR_I02 set sectores=b.Rubro, tipobienes=b.Tipo_Bienes           
		from   T_ESCOMAR_I02 a    
		inner join T_ESCOMAR_MATRIZ_I b on (a.nom_prod=b.Nombre_Producto)    
		where a.fecha_carga=@sFecha    
		    
		update T_ESCOMAR_I02 set cargapry=b.discrimina    
		from   T_ESCOMAR_I02 a    
		inner join T_ESCOMAR_DISCRIMINA_I b on (a.nom_prod=b.Producto)    
		where a.fecha_carga=@sFecha    
	end
	if @TipoOperacion = 'E'
	begin
		update T_ESCOMAR_E02 set sectores=b.Rubro, tipobienes=b.Tipo_Bienes             
		from   T_ESCOMAR_E02 a      
		inner join T_ESCOMAR_MATRIZ_E b on (a.nom_prod=b.Nombre_Producto)      
		where a.fecha_carga=@sFecha      
	end
	if @TipoOperacion = 'P'
	begin
		update T_ESCOMAR_P02 set sectores=b.Rubro, tipobienes=b.Tipo_Bienes             
		from   T_ESCOMAR_P02 a      
		inner join T_ESCOMAR_MATRIZ_E b on (a.nom_prod=b.Nombre_Producto)      
		where a.fecha_carga=@sFecha 
	end

	IF @@ERROR != 0 --check @@ERROR variable after each DML statements..    
	  BEGIN    
		ROLLBACK TRANSACTION --RollBack Transaction if Error..    
		RETURN    
	  END    
	ELSE    
	  BEGIN    
		COMMIT TRANSACTION --finally, Commit the transaction if Success..    
		RETURN    
	  END    
END 


GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Actualizar_Productos]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Actualizar_Productos]
@Producto varchar(50),
@Rubro varchar(50),
@TipoBien varchar(50),
@CargaProyecto char(2),
@TipoOperacion char(1),
@ProductoAnt varchar(50)
as
if @TipoOperacion = 'I'
begin
	update T_ESCOMAR_DISCRIMINA_I set Producto = @Producto,  Discrimina = @CargaProyecto where Producto =  @ProductoAnt
	update T_ESCOMAR_MATRIZ_I set nombre_producto = @Producto, rubro = @Rubro, tipo_bienes = @TipoBien where nombre_producto = @ProductoAnt
end

if @TipoOperacion = 'E'
begin
	update T_ESCOMAR_MATRIZ_E set nombre_producto = @Producto, rubro = @Rubro, tipo_bienes = @TipoBien where nombre_producto = @ProductoAnt
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Eliminar_Productos]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Eliminar_Productos]
@TipoOperacion char(1),
@ProductoAnt varchar(50)
as
if @TipoOperacion = 'I'
begin
	delete T_ESCOMAR_DISCRIMINA_I  where Producto =  @ProductoAnt
	delete T_ESCOMAR_MATRIZ_I  where nombre_producto = @ProductoAnt
end

if @TipoOperacion = 'E'
begin
	delete T_ESCOMAR_MATRIZ_E  where nombre_producto = @ProductoAnt
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ESCOMAR_Expo_Actualiza_Info]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ESCOMAR_Expo_Actualiza_Info]    
@anho int
as   

delete T_ESCOMAR_E02 where anho = @anho
 
declare @sFecha as smalldatetime    
select @sFecha=getdate()    
insert into T_ESCOMAR_E02    
select   
*,   
mes=month(f_salida),  
anho=year(f_salida),  
sectores='',  
tipobienes='',  
cargapry='NO',  
contenedores=cont_20+cont_40,  
@sFecha  
from T_ESCOMAR_E01  
    
delete T_ESCOMAR_E01    
    
update T_ESCOMAR_E02 set sectores=b.Rubro,    
       tipobienes=b.Tipo_Bienes           
from    
T_ESCOMAR_E02 a    
inner join T_ESCOMAR_MATRIZ_E b on (a.nom_prod=b.Nombre_Producto)    
where a.fecha_carga=@sFecha    
  
GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Expo_Consulta]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Expo_Consulta]
@Producto varchar(200) = '',
@Rubro varchar(100) = ''
as
select distinct Discrimina = '', Nombre_Producto,Rubro, Tipo_Bienes
from T_ESCOMAR_MATRIZ_E 
where (Nombre_Producto like '%' + @Producto + '%') and
(Rubro like '%'+ @Rubro +'%')
order by nombre_producto
GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Impo_Consulta]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Impo_Consulta]
@CargaProyecto char(2) = ' ',
@Producto varchar(200) = '',
@Rubro varchar(100) = ''
as

select distinct Discrimina, Nombre_Producto, Rubro, Tipo_Bienes
from T_ESCOMAR_MATRIZ_I a 
inner join T_ESCOMAR_DISCRIMINA_I b on a.nombre_producto = b.producto
where (discrimina = @CargaProyecto or @CargaProyecto = ' ' ) and 
(Nombre_Producto like '%' + @Producto + '%') and
(Rubro like '%'+ @Rubro +'%')
order by nombre_producto

GO
/****** Object:  StoredProcedure [dbo].[sp_Escomar_Insertar_Productos]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Escomar_Insertar_Productos]
@Producto varchar(50),
@Rubro varchar(50),
@TipoBien varchar(50),
@CargaProyecto char(2),
@TipoOperacion char(1)
as
if @TipoOperacion = 'I'
begin
	insert into T_ESCOMAR_DISCRIMINA_I (Producto, Discrimina) values (@Producto,@CargaProyecto)
	insert into T_ESCOMAR_MATRIZ_I (nombre_producto, rubro, tipo_bienes) values (@Producto,@Rubro,@TipoBien)
end

if @TipoOperacion = 'E'
begin
	insert into T_ESCOMAR_MATRIZ_E (nombre_producto, rubro, tipo_bienes) values (@Producto,@Rubro,@TipoBien)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ESCOMAR_Provincia_Actualiza_Info]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ESCOMAR_Provincia_Actualiza_Info]    
@anho int
as    

delete T_ESCOMAR_P02 where anho = @anho

declare @sFecha as smalldatetime    
select @sFecha=getdate()    
insert into T_ESCOMAR_P02    
select   
*,   
mes=month(f_salida),  
anho=year(f_salida),  
sectores='',  
tipobienes='',  
cargapry='NO',  
contenedores=cont_20+cont_40,  
@sFecha  
from T_ESCOMAR_P01  
    
delete T_ESCOMAR_P01    
  
update T_ESCOMAR_P02 set sectores=b.Rubro,    
       tipobienes=b.Tipo_Bienes           
from    
T_ESCOMAR_P02 a    
inner join T_ESCOMAR_MATRIZ_E b on (a.nom_prod=b.Nombre_Producto)    
where a.fecha_carga=@sFecha    
GO
/****** Object:  StoredProcedure [dbo].[sp_ListarTeclado]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[sp_ListarTeclado]  -FMCR
--as
--select id_taclado,Descripcion from teclado
--GO
/****** Object:  StoredProcedure [dbo].[STPR_INSERT_EXPORT_GYS_ESCOMAR]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[STPR_INSERT_EXPORT_GYS_ESCOMAR]
(
@motonave varchar(20)='',
@bandera varchar(15)='',
@f_salida VARCHAR(10)='', -- smalldatetime] NULL,
@cia_nav varchar(15)='',
@age_port varchar(30) ='',
@pto_emb varchar(15)='',
@pto_desc varchar(15)='',
@dest_fin varchar(15)='',
@con_emb varchar(25)='',
@embarcador varchar(32)='',
@consignata varchar(32)='',
@det_prod varchar(40)='',
@tip_prod char(1)='',
@nom_prod varchar(22)='',
@cont_20 int=0, 
@cont_40 int=0,
@stat_cont varchar(3)='',
@cant_bulto float=0,
@embalaje varchar(15)='', 
@peso float=0,
@pais_pdes varchar(18)='',
@pais_pdfin varchar(18)='',
@rec float=0,
@viaje varchar(8)='',
@teus int=0,
@feus smallmoney=0,
@num_manif varchar(4)='',
@no_manif varchar(20)='',
@det_sunad varchar(10)='',
@guia_mast varchar(25)='',
@consolid varchar(40)='',
@cons_dest varchar(40)='',
@embarc_mix varchar(40)='',
@term_almac varchar(50)='',
@custom1 varchar(50)='',
@custom2 varchar(50)=''
)
AS 
BEGIN 
SET NOCOUNT ON 

BEGIN TRANSACTION [REG_EXPOS]
	INSERT INTO [dbo].[T_ESCOMAR_E01] 
	VALUES (
		@motonave , 
		@bandera , 
		SUBSTRING(@f_salida , 7,4) + SUBSTRING(@f_salida ,4 ,2 ) + SUBSTRING(@f_salida ,1 ,2 ) , 
		--convert(datetime,CONVERT(varchar(10), @f_salida,126)),
		@cia_nav ,
		@age_port ,
		@pto_emb ,
		@pto_desc ,
		@dest_fin ,
		@con_emb ,
		@embarcador ,
		@consignata ,
		@det_prod ,
		@tip_prod ,
		@nom_prod ,
		@cont_20 ,
		@cont_40 ,
		@stat_cont ,
		@cant_bulto ,
		@embalaje ,
		@peso ,
		@pais_pdes ,
		@pais_pdfin ,
		@rec ,
		@viaje ,
		@teus ,
		convert(int , @feus) ,
		@num_manif ,
		@no_manif ,
		@det_sunad ,
		@guia_mast ,
		@consolid ,
		@cons_dest ,
		@embarc_mix ,
		@term_almac ,
		@custom1 ,
		@custom2 
		)
	
IF @@ERROR = 0
COMMIT TRANSACTION [REG_EXPOS]

ELSE 
ROLLBACK TRANSACTION [REG_EXPOS]

END 
GO
/****** Object:  StoredProcedure [dbo].[STPR_INSERT_IMPORT_GYS_ESCOMAR]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************
/*
SELECT * FROM [DBO].[T_ESCOMAR_I01]
SELECT COUNT(*) FROM [dbo].[T_ESCOMAR_I01]
TRUNCATE TABLE [T_ESCOMAR_I01] 

GRANT EXECUTE ON OBJECT::[DBO].[STPR_INSERT_IMPORT_GYS_ESCOMAR]
TO escomar;
*/
ALTER PROCEDURE [dbo].[STPR_INSERT_IMPORT_GYS_ESCOMAR](
@motonave varchar(20)='', 
@bandera varchar(15)='',
@f_llegada  varchar(10), --smalldatetime
@cia_nav varchar(15)='' ,
@age_port varchar(30)='' ,
@pto_emb varchar(15)='' ,
@proceden varchar(15)='' ,
@pto_desc varchar(15)='' ,
@con_emb varchar(25)='' ,
@consignata varchar(32)='' ,
@embarcador varchar(32)='' ,
@det_prod varchar(40)='' ,
@tip_prod char(1)='' ,
@part_aranc varchar(12)='' ,
@nom_prod varchar(22)='' ,
@cont_20 int =0,
@cont_40 int =0,
@stat_cont varchar(3) ='',
@cant_bulto float =0,
@embalaje varchar(15) ='',
@peso float =0,
@pais_pemb varchar(18) ='',
@pais_proc varchar(18) ='',
@no_manif varchar(20) ='',
@det_sunad varchar(10) ='',
@guia_mast varchar(25) ='',
@consolid varchar(50) ='',
@cons_orig varchar(50) ='',
@consig_mix varchar(50) ='',
@notify varchar(50) ='',
@cli_final varchar(50) ='',
@term_almac varchar(50) ='',
@teus int =0,
@feus smallmoney =0,
@no_dua varchar(20) ='',
@f_numera varchar(10)='', --smalldatetime ='',
@f_embarque varchar(10)='',--smalldatetime ='',
@nom_decl varchar(50)='',
@ruc_import varchar(15)='',
@nom_import varchar(50)='',
@dir_import varchar(150)='',
@p_neto int=0,
@fob decimal(12, 0)=0,
@flete decimal(12, 2)=0,
@seguro decimal(12,2)=0,
@cif decimal(12, 2)=0,
@nandina varchar(20)='',
@desc_part varchar(150)='',
@des_mercdu varchar(100)='',
@custom1 varchar(50)='',
@custom2 varchar(50)=''
)
AS BEGIN 
SET NOCOUNT ON 

BEGIN TRANSACTION [REG_IMPORT]
	INSERT INTO [dbo].[T_ESCOMAR_I01]
	VALUES
	(
		@motonave, 
		@bandera ,
		SUBSTRING(@f_llegada , 7,4) + SUBSTRING(@f_llegada ,4 ,2 ) + SUBSTRING(@f_llegada ,1 ,2 ) , 
		@cia_nav ,
		@age_port ,
		@pto_emb ,
		@proceden ,
		@pto_desc ,
		@con_emb ,
		@consignata ,
		@embarcador ,
		@det_prod ,
		@tip_prod ,
		@part_aranc ,
		@nom_prod ,
		@cont_20 , --int =0,
		@cont_40 , --int =0,
		@stat_cont ,
		@cant_bulto ,
		@embalaje ,
		@peso ,
		@pais_pemb ,
		@pais_proc ,
		@no_manif ,
		@det_sunad ,
		@guia_mast ,
		@consolid ,
		@cons_orig ,
		@consig_mix ,
		@notify ,
		@cli_final ,
		@term_almac ,
		@teus , --int =0,
		convert(int , @feus) ,	--int =0,
		@no_dua ,
		SUBSTRING(@f_numera , 7,4) + SUBSTRING(@f_numera ,4 ,2 ) + SUBSTRING(@f_numera ,1 ,2 ) , 
		SUBSTRING(@f_embarque , 7,4) + SUBSTRING(@f_embarque ,4 ,2 ) + SUBSTRING(@f_embarque ,1 ,2 ) , 
		@nom_decl ,
		@ruc_import ,
		@nom_import ,
		@dir_import ,
		@p_neto ,	--int=0,
		@fob ,		--decimal(12, 0)=0,
		@flete ,	--decimal(12, 2)=0,
		@seguro ,	--decimal(12,2)=0,
		@cif ,		--decimal(12, 2)=0,
		@nandina ,
		@desc_part ,
		@des_mercdu ,
		@custom1 ,
		@custom2 
	) 
IF @@ERROR = 0 
	COMMIT TRANSACTION [REG_IMPORT]
ELSE 
	ROLLBACK TRANSACTION [REG_IMPORT]

END 
GO
/****** Object:  StoredProcedure [dbo].[STPR_INSERT_PROV_GYS_ESCOMAR]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************
/*
SELECT * FROM [DBO].[T_ESCOMAR_P01]
SELECT COUNT(*) FROM [DBO].[T_ESCOMAR_P01]

GRANT EXECUTE ON OBJECT::[DBO].[STPR_INSERT_PROV_GYS_ESCOMAR]
TO escomar;
*/
ALTER PROCEDURE [dbo].[STPR_INSERT_PROV_GYS_ESCOMAR](
@motonave varchar(20) ='',
@bandera varchar(15) ='',
@f_salida VARCHAR(10) ='',
@cia_nav varchar(15) ='',
@age_port varchar(30) ='',
@pto_emb varchar(15) ='',
@pto_desc varchar(15) ='',
@dest_fin varchar(15) ='',
@con_emb varchar(25) ='',
@embarcador varchar(32) ='',
@consignata varchar(32) ='',
@det_prod varchar(40) ='',
@tip_prod char(1) ='',
@nom_prod varchar(22) ='',
@cont_20 int =0,
@cont_40 int =0,
@stat_cont varchar(3) ='',
@cant_bulto float =0,
@embalaje varchar(15) ='',
@peso float =0,
@pais_pdes varchar(18) ='',
@pais_dfin varchar(18) ='',
@rec float =0,
@viaje varchar(8) ='',
@teus int =0,
@feus smallmoney =0,
@num_manif varchar(4) ='',
@no_manif varchar(20) ='',
@det_sunad varchar(10) ='',
@guia_mast varchar(25) ='',
@consolid varchar(40) ='',
@embarc_mix varchar(40) ='',
@term_almac varchar(50) ='',
@custom1 varchar(50) ='',
@custom2 varchar(50) =''
)
AS 
BEGIN 
SET NOCOUNT ON 

BEGIN TRANSACTION [REG_PROV]
	INSERT INTO [dbo].[T_ESCOMAR_P01]
	VALUES (
		@motonave ,
		@bandera ,
--		@f_salida , --smalldatetime ='',
		SUBSTRING(@f_salida , 7,4) + SUBSTRING(@f_salida ,4 ,2 ) + SUBSTRING(@f_salida ,1 ,2 ) , 
		@cia_nav ,
		@age_port ,
		@pto_emb ,
		@pto_desc ,
		@dest_fin ,
		@con_emb ,
		@embarcador ,
		@consignata ,
		@det_prod ,
		@tip_prod ,
		@nom_prod ,
		@cont_20 , --int =0,
		@cont_40 , --int =0,
		@stat_cont , 
		@cant_bulto , --float =0,
		@embalaje ,
		@peso ,		--float =0,
		@pais_pdes ,
		@pais_dfin ,
		@rec ,	--float =0,
		@viaje ,
		@teus , --int =0,
		convert(int , @feus) ,	--int =0,
		@num_manif ,
		@no_manif ,
		@det_sunad ,
		@guia_mast ,
		@consolid ,
		@embarc_mix ,
		@term_almac ,
		@custom1 ,
		@custom2 
	)
	
IF @@ERROR = 0 
COMMIT TRANSACTION [REG_PROV]

ELSE 
ROLLBACK TRANSACTION [REG_PROV]

END 
GO
/****** Object:  StoredProcedure [web].[Lista_correos_TIServicios]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[Lista_correos_TIServicios]
as
select 0 as id_Parametro,'[Seleccione]' as ValorParametro
union
select id_Parametro,ValorParametro from parametros
where id_Parametro in (1,2,3)
GO
/****** Object:  StoredProcedure [web].[Lista_estados_TIServicios]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[Lista_estados_TIServicios]
as

select 0 as id_estado,'[Seleccione]' as Nombre_estado
union
select id_estado,Nombre_estado from estado
where flg ='1'
GO
/****** Object:  StoredProcedure [web].[sp_ActualizaEstadoAtendido_MSG]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_ActualizaEstadoAtendido_MSG]      
@ID INT,    
@id_proceso  int,  
@login_usuario varchar(50),  
@mensaje varchar(5000),
@atencion varchar(50)   
as      
---Estado Cancelado      
declare @IdEstadoAtendiendo int      
      
select @IdEstadoAtendiendo = id_estado from estado where id_estado = 4     
      
update TI_INCIDENCIAS_SERVICIOS_MAIL      
set      
id_estado=@IdEstadoAtendiendo,    
id_proceso =@id_proceso,    
FECHA_ATE = getdate(),
atencion = @atencion    
where      
ID=@ID     
  
declare @id_usuario int  
select @id_usuario=id_usuario from usuario where login_usuario = @login_usuario  
Insert into RESPUESTA_TI_INCIDENCIAS_SERVICIOS (ID,id_usuario,mensaje,flg)  
values(@ID,@id_usuario,@mensaje,'1')  
  
    
    
    
GO
/****** Object:  StoredProcedure [web].[sp_ActualizaEstadoAtendiendo_MSG]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [web].[sp_ActualizaEstadoAtendiendo_MSG]  
@ID INT  
as  
---Estado Cancelado  
declare @IdEstadoAtendiendo int  
  
select @IdEstadoAtendiendo = id_estado from estado where id_estado = 3  
  
update TI_INCIDENCIAS_SERVICIOS_MAIL  
set  
id_estado=@IdEstadoAtendiendo  
where  
ID=@ID  
GO
/****** Object:  StoredProcedure [web].[sp_ActualizaEstadoCancelado_MSG]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_ActualizaEstadoCancelado_MSG]
@ID INT
as
---Estado Cancelado
declare @IdEstadoCancelado int

select @IdEstadoCancelado = id_estado from estado where id_estado = 1

update TI_INCIDENCIAS_SERVICIOS_MAIL
set
id_estado=@IdEstadoCancelado
where
ID=@ID
GO
/****** Object:  StoredProcedure [web].[sp_ActualizaEstadoFinalizado_MSG]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [web].[sp_ActualizaEstadoFinalizado_MSG]  
@ID INT  
as  
---Estado Cancelado  
declare @IdEstadoCancelado int  
  
select @IdEstadoCancelado = id_estado from estado where id_estado = 5
  
update TI_INCIDENCIAS_SERVICIOS_MAIL  
set  
id_estado=@IdEstadoCancelado  
where  
ID=@ID  
GO
/****** Object:  StoredProcedure [web].[sp_CargarCorreoTI]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_CargarCorreoTI]  
as  
select ValorParametro,obs,id_Parametro from parametros where id_Parametro in (1,2,3) ---Correo TI SERVICIOS  
GO
/****** Object:  StoredProcedure [web].[sp_FiltroBusqueda_bandejaAdmin]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
       
ALTER PROCEDURE [web].[sp_FiltroBusqueda_bandejaAdmin]        
@incidencia varchar(150),        
@fechaEnvio smalldatetime,        
@id_estado int,        
@id_parametro int,      
@fechaEnvio2 smalldatetime          
as        
declare @SENTECIA nvarchar(4000)        
declare @SELECT nvarchar(4000)        
declare @WHERE nvarchar(4000)  
  
create table #Tabla_final  
(  
Incidencia varchar(150) null,  
FechaEnvio smalldatetime null,  
EnviadoA varchar(500) null,  
id_estado int null,  
ID decimal(18,0) null,  
correo varchar(100) null,  
Tiempo varchar(50) null,
AtendidoPor varchar(50)
)  
  
    
SET @SELECT = 'select         
TI.Descripcion as [Incidencia],TI.fecha_sol as [FechaEnvio],p.ValorParametro as [EnviadoA],e.id_estado,TI.ID,        
u.correo, u.login_usuario --, u.nombre_usuario + '''' '''' + u.Apellido_usuario        
from TI_INCIDENCIAS_SERVICIOS_MAIL TI         
inner join parametros p on TI.id_parametro = p.id_parametro        
inner join estado e on TI.id_estado = e.id_estado         
left join RESPUESTA_TI_INCIDENCIAS_SERVICIOS rt on TI.ID=rt.ID
left join usuario u on u.id_usuario = rt.id_usuario 
'         
        
IF @incidencia = '' AND @fechaEnvio IS NULL AND  @id_estado =0 AND @id_parametro=0        
BEGIN        
EXEC (@SELECT + ' order by TI.fecha_sol desc')        
RETURN        
END        
ELSE        
BEGIN        
        
declare @ExistWhere int        
set @ExistWhere = 0        
        
        
if @incidencia <> '' and @ExistWhere=1        
Begin         
SET @WHERE =@WHERE + ' and TI.descripcion like ' + '''' + '%' +  @incidencia + '%' + ''''        
end        
if @incidencia <> '' and @ExistWhere=0        
begin        
SET @WHERE = + ' TI.descripcion like ' + '''' + '%' +  @incidencia + '%' + ''''        
set @ExistWhere = 1        
end        
        
        
        
if @fechaEnvio IS NOT null and @ExistWhere=1        
Begin         
--SET @WHERE =@WHERE +  ' and TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + ''''        
SET @WHERE =@WHERE +  ' and (TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + '''' + ' and TI.FECHA_SOL <=' + '''' + CONVERT(VARCHAR,DATEADD(day,1,@fechaEnvio2)) + '''' + ') '          
end        
if @fechaEnvio IS NOT null and @ExistWhere=0        
begin        
        
--SET @WHERE =' TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + ''''        
SET @WHERE =' (TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + '''' + ' and TI.FECHA_SOL <='+ '''' + CONVERT(VARCHAR,DATEADD(day,1,@fechaEnvio2)) + '''' + ') '           
set @ExistWhere = 1        
end        
        
        
if @id_estado <> 0 and @ExistWhere=1        
Begin         
SET @WHERE =@WHERE + ' and TI.id_estado =' + CONVERT(VARCHAR,@id_estado)        
end        
if @id_estado <> 0 and @ExistWhere=0        
begin        
SET @WHERE =' TI.id_estado =' + CONVERT(VARCHAR,@id_estado)        
set @ExistWhere = 1        
end        
        
if @id_parametro <> 0 and @ExistWhere=1        
Begin         
SET @WHERE =@WHERE + ' and TI.id_parametro =' + CONVERT(VARCHAR,@id_parametro)        
end        
if @id_parametro <> 0 and @ExistWhere=0        
begin        
SET @WHERE =' TI.id_parametro =' + CONVERT(VARCHAR,@id_parametro)        
set @ExistWhere = 1        
end        
        
        
        
        
SET @SENTECIA = @SELECT + ' WHERE ' + @WHERE + ' order by TI.fecha_sol desc'        
--PRINT @SENTECIA        
--select         
--TI.Descripcion as [Incidencia],TI.fecha_sol as [FechaEnvio],p.ValorParametro as [EnviadoA],e.id_estado,TI.ID         
--from TI_INCIDENCIAS_SERVICIOS_MAIL TI         
--inner join parametros p on TI.id_parametro = p.id_parametro        
--inner join estado e on TI.id_estado = e.id_estado          
--where TI.descripcion like '%' + @incidencia + '%'        
--and TI.FECHA_SOL >= @fechaEnvio        
--and TI.id_estado = @id_estado        
--and TI.id_parametro = @id_parametro        
        
--EXEC (@SENTECIA)        
    
  Insert Into #Tabla_final(Incidencia,FechaEnvio,EnviadoA,id_estado,ID,correo,AtendidoPor)  
  EXEC (@SENTECIA)    
    
    
  ----------------------------------------------------------  
 DECLARE @IDX int              
 DECLARE cursor1 CURSOR FOR     
 select ID from #Tabla_final  
 OPEN cursor1     
 FETCH NEXT FROM cursor1 INTO @IDX     
 WHILE @@FETCH_STATUS = 0     
 BEGIN     
    
  declare @fecha_sol_1 smalldatetime  
  declare @id_estado_1 int  
  select @fecha_sol_1 = fecha_sol,@id_estado_1= id_estado from TI_INCIDENCIAS_SERVICIOS_MAIL where id=@IDX--21  
   
  declare @Minutos_pasaron int  
  if (CONVERT(varchar(11),@fecha_sol_1,101)=CONVERT(varchar(11),getdate(),101))  
  begin ---Incidencias de la fecha de hoy  
     
   if (@id_estado_1=2 or @id_estado_1=3) ---estado: recibido, proceso(atendiendo)    
   begin  
    set @Minutos_pasaron = DATEDIFF(minute, @fecha_sol_1, getdate())    
                       
    Update #Tabla_final    
    set    
    Tiempo = convert(varchar(50),@Minutos_pasaron) + ' minutos'  
    where ID = @IDX    
   end  
     
  End  
      
 FETCH NEXT FROM cursor1     
 INTO @IDX   
 END     
 CLOSE cursor1     
 DEALLOCATE cursor1   
  ----------------------------------------------------------  
    
  select * from #Tabla_final  
  drop table #Tabla_final  
        
END   
  
GO
/****** Object:  StoredProcedure [web].[sp_FiltroBusqueda_bandejaUsuario]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_FiltroBusqueda_bandejaUsuario]    
@incidencia varchar(150),    
@fechaEnvio smalldatetime,    
@id_estado int,    
@id_parametro int,  
@fechaEnvio2 smalldatetime    
  
as    
declare @SENTECIA nvarchar(4000)    
declare @SELECT nvarchar(4000)    
declare @WHERE nvarchar(4000)    
SET @SELECT = 'select     
TI.Descripcion as [Incidencia],TI.fecha_sol as [FechaEnvio],p.ValorParametro as [EnviadoA],e.id_estado,TI.ID     
from TI_INCIDENCIAS_SERVICIOS_MAIL TI     
inner join parametros p on TI.id_parametro = p.id_parametro    
inner join estado e on TI.id_estado = e.id_estado '     
    
IF @incidencia = '' AND @fechaEnvio IS NULL AND  @id_estado =0 AND @id_parametro=0    
BEGIN    
EXEC (@SELECT + ' order by TI.fecha_sol desc')    
RETURN    
END    
ELSE    
BEGIN    
    
declare @ExistWhere int    
set @ExistWhere = 0    
    
    
if @incidencia <> '' and @ExistWhere=1    
Begin     
SET @WHERE =@WHERE + ' and TI.descripcion like ' + '''' + '%' +  @incidencia + '%' + ''''    
end    
if @incidencia <> '' and @ExistWhere=0    
begin    
SET @WHERE = + ' TI.descripcion like ' + '''' + '%' +  @incidencia + '%' + ''''    
set @ExistWhere = 1    
end    
    
    
    
if @fechaEnvio IS NOT null and @ExistWhere=1    
Begin     
--SET @WHERE =@WHERE +  ' and (TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + '''' + ' and TI.FECHA_SOL <=' + '''' + CONVERT(VARCHAR,@fechaEnvio2) + '''' + ') '    
SET @WHERE =@WHERE +  ' and (TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + '''' + ' and TI.FECHA_SOL <=' + '''' + CONVERT(VARCHAR,DATEADD(day,1,@fechaEnvio2)) + '''' + ') '    
--DATEADD(day, 1, @FechaInicial)
end    
if @fechaEnvio IS NOT null and @ExistWhere=0    
begin    
    
SET @WHERE =' (TI.FECHA_SOL >=' + '''' + CONVERT(VARCHAR,@fechaEnvio) + '''' + ' and TI.FECHA_SOL <=' + '''' + CONVERT(VARCHAR,DATEADD(day,1,@fechaEnvio2)) + '''' + ') '    
set @ExistWhere = 1    
end    
    
    
if @id_estado <> 0 and @ExistWhere=1    
Begin     
SET @WHERE =@WHERE + ' and TI.id_estado =' + CONVERT(VARCHAR,@id_estado)    
end    
if @id_estado <> 0 and @ExistWhere=0    
begin    
SET @WHERE =' TI.id_estado =' + CONVERT(VARCHAR,@id_estado)    
set @ExistWhere = 1    
end    
    
if @id_parametro <> 0 and @ExistWhere=1    
Begin     
SET @WHERE =@WHERE + ' and TI.id_parametro =' + CONVERT(VARCHAR,@id_parametro)    
end    
if @id_parametro <> 0 and @ExistWhere=0    
begin    
SET @WHERE =' TI.id_parametro =' + CONVERT(VARCHAR,@id_parametro)    
set @ExistWhere = 1    
end    
    
    
    
    
SET @SENTECIA = @SELECT + ' WHERE ' + @WHERE + ' order by TI.fecha_sol desc'    
--PRINT @SENTECIA    
--select     
--TI.Descripcion as [Incidencia],TI.fecha_sol as [FechaEnvio],p.ValorParametro as [EnviadoA],e.id_estado,TI.ID     
--from TI_INCIDENCIAS_SERVICIOS_MAIL TI     
--inner join parametros p on TI.id_parametro = p.id_parametro    
--inner join estado e on TI.id_estado = e.id_estado      
--where TI.descripcion like '%' + @incidencia + '%'    
--and TI.FECHA_SOL >= @fechaEnvio    
--and TI.id_estado = @id_estado    
--and TI.id_parametro = @id_parametro    
    
EXEC (@SENTECIA)    
    
END    
GO
/****** Object:  StoredProcedure [web].[sp_Image_TI_INCIDENCIAS_SERVICIOS_MAIL]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Image_TI_INCIDENCIAS_SERVICIOS_MAIL]
@ID decimal(18,0),
@imagen image
as
Insert into Image_TI_INCIDENCIAS_SERVICIOS_MAIL(ID,imagen,flg)
values(@ID,@imagen,'1')
GO
/****** Object:  StoredProcedure [web].[sp_Ingresa_CORREO_CONTACTOS_CC]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Ingresa_CORREO_CONTACTOS_CC]
@ID decimal(18,0),
@correo_cc varchar(200)
as
Insert into CORREO_CONTACTOS_CC(correo_cc,flg,ID)
values(@correo_cc,'1',@ID)
GO
/****** Object:  StoredProcedure [web].[sp_Lista_CorreosEnviados]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Lista_CorreosEnviados]  
@login_usuario varchar(50)--, --Login del usuario  
as  
declare @id_usuario int  
select @id_usuario=id_usuario from usuario where login_usuario = @login_usuario  
  
select --e.Nombre_estado as [Estado],  
TI.Descripcion as [Incidencia],TI.fecha_sol as [FechaEnvio],  
p.ValorParametro as [EnviadoA],e.id_estado,TI.ID  
from TI_INCIDENCIAS_SERVICIOS_MAIL TI  
inner join parametros p on TI.id_parametro = p.id_parametro  
inner join estado e on TI.id_estado = e.id_estado  
where id_usuario = @id_usuario  
order by FECHA_SOL desc
GO
/****** Object:  StoredProcedure [web].[sp_Lista_Users_AD]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Lista_Users_AD]
as
select nombre,correo from usuarios_ad
where status_usuario = 'A' and nombre <> ''
order by nombre asc
GO
/****** Object:  StoredProcedure [web].[sp_ListaProceso_Sistema]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_ListaProceso_Sistema]
@id_sistema int
as
select 0 as [id_proceso],'[Seleccione]' as [Nombre_proceso]
union
select id_proceso,Nombre_proceso from PROCESO
where flg='1' and id_sistema = @id_sistema
GO
/****** Object:  StoredProcedure [web].[sp_ListaSistemas]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_ListaSistemas]
as
select 0 as [id_sistema],'[Seleccione]' as [nombre_sistema],'' as [encargado_sistema]
union
select id_sistema,nombre_sistema,encargado_sistema from SISTEMA
where flg='1'
GO
/****** Object:  StoredProcedure [web].[sp_registra_TI_INCIDENCIAS_SERVICIOS]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_registra_TI_INCIDENCIAS_SERVICIOS]    
@login_usuario varchar(50), --Login del usuario    
@DESCRIPCION varchar(150), --Mensaje - ASUNTO    
@MENSAJE varchar(5000),--cuerpo del mensaje    
@ARCHIVO_ADJUNTO_FLG char(1),  ---Verifica si tiene archivo adjunto o no : 1 o 0    
@id_Parametro int, 
@ip varchar(50), 
@ID_Salida decimal(18,0) output  
  
as    
declare @MES char(10)    
declare @id_usuario int    
DECLARE @ANYO INT    
declare @SEMANA int    
select @id_usuario=id_usuario from usuario where login_usuario = @login_usuario    
    
declare @Num_Mes int    
set @Num_Mes= MONTH(getdate())    
    
If(@Num_Mes =1)    
Begin    
 set @MES = 'ENERO'    
End    
If(@Num_Mes =2)    
Begin    
 set @MES = 'FEBRERO'    
End    
If(@Num_Mes =3)    
Begin    
 set @MES = 'MARZO'    
End    
If(@Num_Mes =4)    
Begin    
 set @MES = 'ABRIL'    
End    
If(@Num_Mes =5)    
Begin    
 set @MES = 'MAYO'    
End    
If(@Num_Mes =6)    
Begin    
 set @MES = 'JUNIO'    
End    
If(@Num_Mes =7)    
Begin    
 set @MES = 'JULIO'    
End    
If(@Num_Mes =8)    
Begin    
 set @MES = 'AGOSTO'    
End    
If(@Num_Mes =9)    
Begin    
 set @MES = 'SETIEMBRE'    
End    
If(@Num_Mes =10)    
Begin    
 set @MES = 'OCTUBRE'    
End    
If(@Num_Mes =11)    
Begin    
 set @MES = 'NOVIEMBRE'    
End    
If(@Num_Mes =12)    
Begin    
 set @MES = 'DICIEMBRE'    
End    
    
SET @ANYO = YEAR(getdate())    
    
set @SEMANA = DATEPART( wk, GETDATE() )    
    
Insert Into TI_INCIDENCIAS_SERVICIOS_MAIL(    
id_usuario,DESCRIPCION,    
FECHA_SOL,SEMANA,MES,ANYO,ARCHIVO_ADJUNTO_FLG,id_estado,id_Parametro,MENSAJE,ip)    
values(@id_usuario,@DESCRIPCION,    
getdate(),@SEMANA,@MES,@ANYO,@ARCHIVO_ADJUNTO_FLG,2,@id_Parametro,@MENSAJE,@ip)    
  
--declare @ID decimal(18,0)  
set @ID_Salida=SCOPE_IDENTITY()  
  
--SELECT @ID  
GO
/****** Object:  StoredProcedure [web].[sp_registro_usuario_limitado]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_registro_usuario_limitado]
@Nombre_usuario varchar(500),
@Apellido_usuario varchar(500),
@login_usuario varchar(50),
@pwd_usuario varchar(50),
@correo varchar(100)

as
If not exists(select id_usuario from usuario where login_usuario = @login_usuario)
Begin
	Insert into usuario(nombre_usuario,Apellido_usuario,login_usuario,pwd_usuario,local_usuario,cargo_usuario,flg,correo,administrador)
	values(@Nombre_usuario,@Apellido_usuario,@login_usuario,@pwd_usuario,'CALLAO','usuario limitado','1',@correo,null)
	return
End
Else
Begin

	Update usuario
	set
	correo =@correo,
	pwd_usuario = @pwd_usuario
	where
	login_usuario = @login_usuario
	return
End

GO
/****** Object:  StoredProcedure [web].[sp_Selecciona_Image_byte]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Selecciona_Image_byte]
@id_image int
as
select imagen from Image_TI_INCIDENCIAS_SERVICIOS_MAIL where id_image = @id_image
and flg='1'
GO
/****** Object:  StoredProcedure [web].[sp_SelectIncidencia_Atencion]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [web].[sp_SelectIncidencia_Atencion]                
@ID int                
as                
select u.correo, convert(varchar(50),TI.Fecha_sol,103) + ' ' + convert(varchar(50),TI.Fecha_sol,108),                
TI.Descripcion,TI.mensaje,                
ARCHIVO_ADJUNTO_FLG =                
      CASE TI.ARCHIVO_ADJUNTO_FLG                
         WHEN '1' THEN 'Si'                
         WHEN '0' THEN 'No'                
      END  ,              
 TI.id_proceso,convert(varchar(50),TI.FECHA_ATE,103) + ' ' + convert(varchar(50),TI.FECHA_ATE,108)            
                
from TI_INCIDENCIAS_SERVICIOS_MAIL TI                
inner join usuario u on TI.id_usuario = u.id_usuario                
where TI.ID =@ID            
          
select correo_cc from CORREO_CONTACTOS_CC where ID = @ID and flg='1'          
order by correo_cc asc          
        
select id_image,imagen from Image_TI_INCIDENCIAS_SERVICIOS_MAIL        
where ID = @ID and flg='1'         
order by id_image asc        
      
DECLARE @id_proceso int      
declare @id_sistema int      
select @id_proceso = id_proceso from TI_INCIDENCIAS_SERVICIOS_MAIL where ID =@ID      
select @id_sistema = id_sistema from proceso where id_proceso = @id_proceso      
      
select @id_sistema,@id_proceso    
    
declare @MENSAJE VARCHAR(5000)    
select @MENSAJE = mensaje from RESPUESTA_TI_INCIDENCIAS_SERVICIOS where ID=@ID    
    
select @MENSAJE    
  
  
declare @ip VARCHAR(50)    
declare @atencion varchar(50)
select @ip = IP , @atencion = atencion from TI_INCIDENCIAS_SERVICIOS_MAIL where ID=@ID    
    
select @ip 
select @atencion 


GO
/****** Object:  StoredProcedure [web].[sp_Update_ReenviarMSG]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Update_ReenviarMSG]
@ID int,
@ReenviarA int
as
Update TI_INCIDENCIAS_SERVICIOS_MAIL
set
id_parametro = @ReenviarA
where
ID=@ID
GO
/****** Object:  StoredProcedure [web].[sp_valida_InicioSesion]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_valida_InicioSesion]      
@login_usuario varchar(50),      
@pwd_usuario varchar(50),  
@admin char(1)      
as      
declare @Permite char(1)      
declare @id_usuario char(1)      
declare @correo varchar(100)
if @admin ='1'  
begin  
 select @id_usuario=id_usuario, @admin = administrador,@correo = correo from usuario       
 where login_usuario = @login_usuario and pwd_usuario = @pwd_usuario      
 and flg = '1'     
   
 if @id_usuario<>'' and @admin ='1'  
 Begin      
 select '1'    
 select 'administrador'  
 select @correo  
 return  
 End     
 Else      
 Begin      
 select '0'     
 select '0'   
 return  
 End   
   
end  
else  
begin   
 select @id_usuario=id_usuario from usuario       
 where login_usuario = @login_usuario and pwd_usuario = @pwd_usuario      
 and flg = '1' and administrador is null     
   
    
  
   
 if @id_usuario<>'' --and @admin is null      
 Begin      
 select '1'    
 select correo from usuario       
 where login_usuario = @login_usuario and pwd_usuario = @pwd_usuario      
 return  
 End    
 Else      
 Begin      
 select '0'     
 select '0'   
 return  
 End    
   
end  
     
  
      
--if @id_usuario<>'' and @admin is null      
--Begin      
-- select '1'    
-- select correo from usuario       
-- where login_usuario = @login_usuario and pwd_usuario = @pwd_usuario      
--  return  
--End     
--if @id_usuario<>'' and @admin ='1'  
--Begin      
-- select '1'    
-- select 'administrador'  
-- return  
--End     
--Else      
--Begin      
-- select '0'     
-- select '0'   
--End      
      
      
GO
/****** Object:  StoredProcedure [web].[sp_Valida_Limite_respuesta_Usuario_Finalizado]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [web].[sp_Valida_Limite_respuesta_Usuario_Finalizado]
as
Declare @fecha varchar(50)
Declare @ID decimal(18,0)
Declare @FECHA_ATE smalldatetime

set @fecha = DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))

DECLARE cursor1 CURSOR FOR   
select top 100 ID,FECHA_ATE from TI_INCIDENCIAS_SERVICIOS_MAIL where id_estado=4 -- Estado: Atendido
and fecha_sol>=@fecha --- considera a todas las incidencias del dia de hoy 00:00 horas
OPEN cursor1   
FETCH NEXT FROM cursor1 INTO @ID,@FECHA_ATE
WHILE @@FETCH_STATUS = 0   
BEGIN   
 
   --select getdate() - '2013-10-03 10:06:09.480'
   declare @fecha_resta smalldatetime
   declare @Minutos_pasaron int
   --set @fecha_resta = getdate() - convert(varchar(50),@FECHA_ATE)
   --select getdate() - convert(varchar(50),@FECHA_ATE)
   
   set @Minutos_pasaron = datepart(minute,convert(varchar(50),getdate() - convert(varchar(50),@FECHA_ATE)))
   
   
   IF @Minutos_pasaron >= 60 ---si pasaron 60 minutos con el estado de atendido - se cierra el caso (El usuario debe dar la conformidad)
   begin
	   Update TI_INCIDENCIAS_SERVICIOS_MAIL
	   set
	   id_estado = 5 ---Finalizado
	   where ID = @ID
   end
   print @Minutos_pasaron
FETCH NEXT FROM cursor1   
INTO @ID,@FECHA_ATE  
END   
CLOSE cursor1   
DEALLOCATE cursor1

GO
/****** Object:  StoredProcedure [web].[sp_validar_administrador]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_validar_administrador]
@login_usuario varchar(50)
as
select login_usuario,Administrador,flg,correo from usuario
where login_usuario = @login_usuario and flg='1'
GO
/****** Object:  StoredProcedure [web].[sp_validar_Usuario_registrador]    Script Date: 07/03/2019 04:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_validar_Usuario_registrador]  
@login_usuario varchar(50)  
as  
select login_usuario,flg,correo,cargo_usuario,Nombre_usuario,Apellido_usuario from usuario  
where login_usuario = @login_usuario and flg='1' and cargo_usuario = 'registrador'
GO
