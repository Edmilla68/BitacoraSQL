CREATE        procedure sp_TR_ReporteCamionajeCalle_MGRCMS    
@Transportista int,     
@FechaIni datetime,    
@FechaFin datetime, @secuencial int    
as    
begin     
    
 declare @ruc_proveedor varchar(40), @ruc_transportista varchar(20), @empresa varchar(10), @TipoServicioExterno varchar(20), @igv varchar(1), @NumeroCircuito varchar(20), @aux_empresa varchar(40)     
 declare @FecFin datetime    
 declare @unidad varchar(20), @naveviaje varchar(20), @entidad varchar(7), @unidadmedida varchar(20)    
 declare @registrados int    
    
    
    
 set @FecFin = convert(datetime, convert(varchar(10), @FechaFin + 1, 21) + ' 14:00', 21)    
    
 create table #t_reporte (Fila int IDENTITY (1, 1), NombreTransportista varchar(255) null, zonaid int, Contacto varchar(1000) null, Email varchar(1000) null,    
  Viaje int null, FechaViaje datetime null, Transportista int null, Camionaje varchar(1) null, Vehiculo int null,    
  FechaTarifa datetime null, Tarifa decimal(19,2) null, Proveedor int null, OrdenServicio int null,    
  NroOrdenServicio int null, FechaOrden datetime null, Placa varchar(10) null, NombreCliente varchar(255) null,    
  Zona varchar(50) null, Mercaderia varchar(1000) null, NombreServicio varchar(255) null,    
  PuntoOrigen varchar(255) null, PuntoDestino varchar(255) null, ConfigVehicular varchar(20) null, ValorReferencia decimal(19,4) , clienteid int, tipomovimiento int)    
    
 insert #t_reporte    
 (NombreTransportista, zonaid, Contacto, Email,Viaje, FechaViaje , Transportista, Camionaje , Vehiculo , FechaTarifa , Tarifa , Proveedor, OrdenServicio,    
 NroOrdenServicio , FechaOrden , Placa , NombreCliente , Zona , Mercaderia , NombreServicio , PuntoOrigen , PuntoDestino , ConfigVehicular , ValorReferencia , clienteid, tipomovimiento )    
 select distinct tr.nombre as NombreTransportista, z.zona, null as Contacto, null as Email,    
 v.viaje, v.fecha as FechaViaje, v.persona as Transportista, v.camionaje,    
 v.vehiculo, t.ultimafecha as FechaTarifa, convert(decimal(19,2),case when z.tarifa is null then t.tarifa else z.tarifa end) as tarifa, t.proveedor, vp.ordenservicio,    
 vp.nroordenservicio, o.fechaActual as FechaOrden, ve.placa, pe.nombre as NombreCliente, z.nombre as Zona,    
 null, s.nombre as NombreServicio,     
 case when o.tipomovimiento = sc.tipomovexportacion then o.direccionentrega           
      else o.direccionorigen end as lugarorigen,    
 case when o.tipomovimiento = sc.tipomovimportacion then o.direccionentrega     
      else o.direccionfinal end as lugardestino,    
 tv.codigo as configvehicular,     
 (select top 1 (isnull(monto, 0) * isnull(factorretorno, 0))    
 from TR_ValorReferencia VR    
 where VR.tipomercaderia = o.tipomercaderia    
 and (VR.flagconfigvehicular = 'N' or tipovehiculo = ve.tipovehiculo)    
 and cargamaxima >= (select sum(peso) from tr_viajearticulo (nolock), tr_viajepunto (nolock)     
    where tr_viajearticulo.viajepunto = tr_viajepunto.viajepunto    
    and tr_viajepunto.viaje = v.viaje and tr_viajepunto.viajepunto =     
    (select min(viajepunto)    
     from tr_viajepunto (nolock) where viaje = v.viaje))    
 and lugaridentity in (select lugaridentity    
         from tr_lugar    
         where flagvalorreferencial = 'S'    
    and lugaridentity = o.lugarorigen    
        /*union     
        select lugaridentity    
        from tr_lugar    
        where flagvalorreferencial = 'S'    
    and lugaridentity = o.lugardestino*/)) as valorreferencia, pe.persona, o.tipomovimiento    
 from   
tr_viaje v (nolock)  
inner join tr_viajepunto vp (nolock) on (v.viaje = vp.viaje)  
inner join tr_vehiculo ve (nolock) on (v.vehiculo = ve.vehiculo)   
inner join sb_persona tr (nolock) on (v.persona = tr.persona)   
inner join ca_ordenservicio o (nolock) on (vp.ordenservicio = o.ordenservicio)   
inner join sb_persona pe (nolock) on (o.cliente = pe.persona)   
inner join sb_zona z (nolock) on (v.zona = z.zona)  
inner join tr_recursoviaje t (nolock) on (v.viaje = t.viaje)  
inner join ta_servicio s (nolock) on (t.servicio = s.servicio)   
left  join tr_tipovehiculo tv (nolock) on (ve.tipovehiculo = tv.tipovehiculo )    
left  join sb_configuracion sc (nolock) on (sc.configuracion=1)   
 where    
v.tipotransporte = 'T' and (v.camionaje is null or v.camionaje = 'N')    
   
  and s.flagcamionaje = 'S'    
  and (@Transportista = 0 or v.persona = @Transportista)    
  and convert(varchar(8), v.fecharegistro, 112) >= convert(varchar(8), @FechaIni, 112)    
  and v.fecharegistro <= @FecFin    
  and sc.empresa = 1    
  
     
 update #t_reporte    
 set Contacto = upper(dbo.Obtener_ContactosCliente(Proveedor)), Email = lower(dbo.Obtener_MailContactosCliente(Proveedor)),    
  Mercaderia = upper(dbo.Obtener_mercaderiaViaje(Viaje))    
     
     
    
 /*Insertamos en tabla de OFISIS*/    
 set @empresa = '01'    
     
 select @ruc_proveedor = ruc    
 from sb_persona    
 where persona = @Transportista    
     
 set @TipoServicioExterno = 'CAL'    
 set @igv = 'S'    
 set @NumeroCircuito = 'ZON'    
 set @aux_empresa = 'K'    
 set @unidad = '001'    
 set @naveviaje = '007171'    
 set @entidad = '7'    
 set @unidadmedida = 'VJE'    
    
 select @ruc_transportista = ruc    
 from sb_persona    
 where persona = @Transportista    
    
 select @registrados = count(*)    
 from [COSMOS-DATA].ofiteso.dbo.TCINFO_NEPT    
 where NU_secu = @secuencial and CO_PROV = @ruc_transportista     
    
     
 if isnull(@secuencial,0) > 0 and isnull(@registrados,0) = 0    
 Begin    
 insert into [COSMOS-DATA].ofiteso.dbo.TCINFO_NEPT(CO_EMPR, CO_PROV, TI_SERV_EXTE, ST_IGVS, NU_CIRC, NU_SECU , FE_INIC, FE_FINA, TI_AUXI_EMPR, CO_AUXI_EMPR,    
 TI_ITEM_GAST, CO_DEST_FINA, TI_PROD_PPTO, TI_SERV_PPTO, CO_TIPO_CCTR, CO_COND_CCTR, CO_TAMA_CCTR, CO_LINE, CO_UNID, CO_NAVE_VIAJ,    
 TI_ENTI_PPTO, CO_CLIE, NU_CANT, CO_UNME, IM_STOT, PR_UNIT, CO_ZONA, ST_TESO, TI_DOCU, NU_DOCU, FE_ACTU, NU_ORDEN, CO_USUA_CREA,FE_USUA_CREA,    
 CO_USUA_MODI,FE_USUA_MODI, NU_VIAJE )    
 select     
  @empresa,    
  (select s.ruc from tr_viaje v, sb_persona s where v.viaje = T.viaje and s.persona = v.persona) as CO_PROV,      
  @TipoServicioExterno,    
  @igv,    
  @NumeroCircuito,    
  @secuencial,    
  @FechaIni,     
  @FechaFin,    
  @aux_empresa,     
  --(select CO_AUXI_EMPR from sb_zona where zona = T.zonaid) as CO_AUXI_EMPR,    
  (select case when T.tipomovimiento = 1 then z.centrocostoimpo else z.centrocostoexpo end from sb_zona z where zona = T.zonaid) as CO_AUXI_EMPR,    
  (select TI_ITEM_GAST from sb_zona where zona = T.zonaid) as TI_ITEM_GAST,    
  NULL, NULL, NULL,    
  '*' as CO_TIPO_CCTR,    
  '*' as CO_COND_CCTR,    
  '*' as CO_TAMA_CCTR,    
  '*' as CO_LINE,    
  @unidad,    
  @naveviaje,    
  @entidad,    
  (select ruc from sb_persona where persona = T.clienteid) as CO_CLIE,    
   1 as NU_CANT,    
  @unidadmedida,    
  T.Tarifa as IM_STOT,    
  T.Tarifa as PR_UNIT,    
  T.zona as CO_ZONA,    
  'N' as ST_TESO,     
  NULL as TI_DOCU,     
  NULL as NU_DOCU,     
  NULL as FE_ACTU,    
  T.fila,    
  'usucam',    
  getdate(),    
  'usucam', getdate(), T.viaje    
      
        
 from #t_reporte T    
 where T.viaje not in (select isnull(NU_viaje,0) as NU_viaje from [COSMOS-DATA].ofiteso.dbo.TCINFO_NEPT where CO_PROV = @ruc_proveedor /*and NU_SECU = @secuencial */)    
    
    
    
 End    
    
/*    
 select * from #t_reporte    
 order by NombreTransportista, NroOrdenServicio, NombreServicio    
     
 drop table #t_reporte    
*/    
 select     
 NombreTransportista, Contacto, Email,Viaje, FechaViaje , Transportista, Camionaje , Vehiculo , FechaTarifa , Tarifa , Proveedor, OrdenServicio,    
 NroOrdenServicio , FechaOrden , Placa , NombreCliente , Zona , Mercaderia , NombreServicio , PuntoOrigen , PuntoDestino , ConfigVehicular , ValorReferencia      
 from #t_reporte    
 order by NombreTransportista, NroOrdenServicio, NombreServicio    
     
 drop table #t_reporte    
    
end    
    
    
    
    
    
    
    