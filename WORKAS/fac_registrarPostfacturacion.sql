  
CREATE PROCEDURE FAC_RegistrarPostFacturacion          
    (@IdentDocumento int,@GenerarOrden bit)          
AS          
BEGIN          
 DECLARE @Serie int          
 DECLARE @Numero int          
 DECLARE @IdentTipoDocumento int          
 DECLARE @IdentTipoFacturacion int          
 DECLARE @IdentTipoSustento int          
 DECLARE @Sustento varchar(50)          
 DECLARE @Cliente nvarchar(20)          
 DECLARE @Emision datetime          
 DECLARE @Importe money          
 DECLARE @Moneda varchar(3)          
 DECLARE @Hoy datetime          
 DECLARE @Despachador varchar(50)        
 DECLARE @IdentConfiguracion int  --CAMBIO          
 DECLARE @IdentUnidadNegocio_Forwarders int              
 DECLARE @IdentUnidadNegocio_CargaProyectos int                    
 DECLARE @IdentTipoFacturacion_Operacion int                    
 DECLARE @IdentUnidadNegocio_Operacion int              
       
 ----IV 24/09/12      
 DECLARE @Ident_Configuracion_Expo VARCHAR(5)      
   
 ----IV 17/11/14 -Fact.Manual      
 DECLARE @I030_Sustento int -- 94:Orden de facturacion  
       
--193853         
         
 SET @Hoy = getdate()           
          
 SELECT @Serie = s.Numero,          
   @Numero = d.Numero,          
   @IdentTipoDocumento = s.Ident_TipoDocumento,          
   @IdentTipoFacturacion = c.Ident_TipoFacturacion,          
   @IdentTipoSustento = o.I021_Sustento,          
   @Sustento = o.Sustento,          
   @Cliente = d.Ident_Cliente,          
   @Emision = d.Emision,          
   @Importe = d.Importe,          
   @Moneda = dc.Moneda,      
   ----IV 24/09/12      
   @Ident_Configuracion_Expo=c.Ident_Configuracion, --Se usara solo cuando sea forwarder flat expo, para diferenciarlo      
   ----IV 17/11/14 -Fact.Manual  
   @I030_Sustento = d.I030_Sustento  
 FROM FAC_Documento d          
 INNER JOIN FAC_Contabilizacion dc ON dc.Ident_Documento = d.Ident_Documento          
 INNER JOIN FAC_Serie s ON d.Ident_Serie = s.Ident_Serie          
 INNER JOIN FAC_Operacion o ON o.Ident_Operacion = d.Sustento          
 INNER JOIN FAC_Configuracion c ON o.Ident_Configuracion = c.Ident_Configuracion          
 WHERE d.Ident_Documento = @IdentDocumento          
          
 SELECT @Despachador = MAX(CXC.Valor)          
 FROM FAC_CntDocumento CNT          
 INNER JOIN FAC_CntDocumentoXCondicion CXC ON CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
 WHERE CXC.Ident_Condicion = 60 --Despachador          
 AND  CNT.Ident_Documento = @IdentDocumento          
          
 DECLARE @TipoFacturacion_Descarga int          
 DECLARE @TipoFacturacion_Embarque int          
 DECLARE @TipoFacturacion_DevolucionCnt int          
 DECLARE @TipoFacturacion_RetiroCnt int          
 DECLARE @TipoFacturacion_TransporteCnt int          
 DECLARE @TipoFacturacion_OrdenServicioExpo int          
 DECLARE @TipoFacturacion_OrdenServicioImpo int          
 DECLARE @TipoFacturacion_Vigencia int          
 DECLARE @TipoFacturacion_Balex int          
 DECLARE @TipoFacturacion_ForwarderFlat int          
 DECLARE @TipoFacturacion_LineaVacios int          
 DECLARE @TipoFacturacion_LineaReefer int          
 DECLARE @TipoFacturacion_Manual int --IV 17/11/14 -Fact.Manual  
          
 SET @TipoFacturacion_Descarga = 2          
 SET @TipoFacturacion_Embarque = 4          
 SET @TipoFacturacion_DevolucionCnt = 5          
 SET @TipoFacturacion_RetiroCnt = 6          
 SET @TipoFacturacion_TransporteCnt = 7          
 SET @TipoFacturacion_OrdenServicioExpo = 9          
 SET @TipoFacturacion_OrdenServicioImpo = 46          
 SET @TipoFacturacion_Vigencia = 48          
 SET @TipoFacturacion_Balex = 11          
 SET @TipoFacturacion_ForwarderFlat = 12          
 SET @TipoFacturacion_LineaVacios = 14          
 SET @TipoFacturacion_LineaReefer = 15          
         
 IF (@IdentTipoFacturacion=12)        
 BEGIN        
 SET @GenerarOrden=0        
 END        
          
 DECLARE @IdentTipoDocumento_Factura int          
 SET @IdentTipoDocumento_Factura = dbo.FAC_ObtenerParametro_Valor('IdentTipoDocumento_Factura')          
          
DECLARE @IdentSustentoOperacion_Volante int          
 SET @IdentSustentoOperacion_Volante = dbo.FAC_ObtenerParametro_Valor('IdentSustentoOperacion_Volante')          
          
 SET @IdentUnidadNegocio_Forwarders = dbo.FAC_ObtenerParametro_Valor('IdentUnidadNegocio_Forwarders')                    
 SET @IdentUnidadNegocio_CargaProyectos = dbo.FAC_ObtenerParametro_Valor('IdentUnidadNegocio_CargaProyectos')                     
         
       
          
 DECLARE @MensajeError varchar(MAX)          
           
 --Transporte          
 IF @IdentTipoFacturacion = @TipoFacturacion_TransporteCnt          
 BEGIN          
  BEGIN TRY          
   DECLARE @Resultado_1 int, @Mensaje_1 varchar(255)          
   DECLARE @NroOrdenTransporte int          
  SET @NroOrdenTransporte = CAST (@Sustento AS int)          
   EXEC FAC_RegistrarPostFacturacion_LOG @NroOrdenTransporte, @Resultado_1 output, @Mensaje_1 output          
   IF @Resultado_1 = -1          
    RAISERROR(@Mensaje_1, 11, 1)          
  END TRY          
  BEGIN CATCH          
   SET @MensajeError = ERROR_MESSAGE()          
   RAISERROR (@MensajeError, 11, 1)          
  END CATCH          
 END          
          
 /*Inicio Pagonet*/          
 DECLARE @Condicion_Pagonet int,          
   @Condicion_CreditoPagonet int,          
   @Condicion_NumeroPrefacturaPagonet varchar(50)          
 DECLARE @IdentPagonet_SI int,          
   @IdentCreditoPagonet_NO int,          
   @IdentNumeroPrefacturaPagonet int          
          
 SET @IdentPagonet_SI = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_Pagonet_Si');          
 SET @IdentCreditoPagonet_NO = dbo.FAC_ObtenerParametro_Valor('IdentValorCondicion_CreditoPagonet_No');          
 SET @IdentNumeroPrefacturaPagonet = dbo.FAC_ObtenerParametro_Valor('IdenCondicion_NumeroPrefacturaPagonet');          
          
 SELECT TOP(1) @Condicion_Pagonet=cdc.Ident_ValorCondicion           
 FROM FAC_Documento d          
 INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento          
 iNNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento          
 WHERE d.Ident_Documento = @IdentDocumento          
 AND cdc.Ident_ValorCondicion = @IdentPagonet_SI          
          
 SELECT TOP(1) @Condicion_CreditoPagonet=cdc.Ident_ValorCondicion           
 FROM FAC_Documento d          
 INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento          
 iNNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento          
 WHERE d.Ident_Documento = @IdentDocumento          
 AND cdc.Ident_ValorCondicion = @IdentCreditoPagonet_NO          
          
 SELECT TOP(1) @Condicion_NumeroPrefacturaPagonet=cdc.Valor           
 FROM FAC_Documento d          
 INNER JOIN FAC_CntDocumento cd ON cd.Ident_Documento = d.Ident_Documento          
 iNNER JOIN FAC_CntDocumentoXCondicion cdc ON cdc.Ident_CntDocumento = cd.Ident_CntDocumento          
 WHERE d.Ident_Documento = @IdentDocumento          
 AND cdc.Ident_Condicion = @IdentNumeroPrefacturaPagonet          
          
 IF  @Condicion_Pagonet IS NOT NULL          
 AND @IdentTipoFacturacion = @TipoFacturacion_DevolucionCnt --GateIn          
 BEGIN          
  DECLARE @TABLA_CNT_GATEIN TABLE          
  (          
   Row int IDENTITY(1,1) PRIMARY KEY NOT NULL,          
   CNTR_CODIGO char(11),          
   CNTR_NAVEVIAJE char(6),          
   CNTR_TAMANIO char(2),          
   CNTR_USUARIO varchar(30),          
   CNTR_IDDOC int,          
   CNTR_NRODOC varchar(6),          
   CNTR_VALORIZA int,          
   CNTR_FACTURA char(9),          
   CNTR_SERVEXTRA char(1),          
   CNTR_LINEA varchar(4),          
   CNTR_CONDICION varchar(2),          
   CNTR_TIPO varchar(2),          
   CNTR_BL varchar(25),          
   CNTR_PREMEMO char(4),          
   CNTR_NROMEMO char(10),          
   CNTR_VIGMEMO datetime,          
   CNTR_LOCAL int,          
   CNTR_FLGREINGRESO int          
  )          
          
  INSERT INTO @TABLA_CNT_GATEIN          
  SELECT CAST(CNT.Codigo AS char(11)) CNTR_CODIGO,          
    CAST(          
    (          
     SELECT CXC.Valor          
     FROM FAC_CntDocumentoXCondicion CXC          
     WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
     AND  CXC.Ident_Condicion = 67 --Nave Viaje          
     AND  CXC.Valor IS NOT NULL          
    ) AS char(6)) CNTR_NAVEVIAJE,          
    CAST(          
    (          
     SELECT VC.Codigo          
     FROM FAC_CntDocumentoXCondicion CXC          
     INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion          
 WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
     AND  CXC.Ident_Condicion = 31 --Tamaño Contenedor          
    ) AS char(2)) CNTR_TAMANIO,          
    CAST(D.Usuario AS varchar(30)) CNTR_USUARIO,          
    CAST(          
    CASE WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante          
     THEN 1          
     ELSE 3          
    END AS int) CNTR_IDDOC,          
    CAST(          
    CASE WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante          
     THEN O.Sustento          
     ELSE          
      (          
       SELECT CXC.Valor          
       FROM FAC_CntDocumentoXCondicion CXC          
       WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
       AND  CXC.Ident_Condicion = 67 --Nave Viaje          
       AND  CXC.Valor IS NOT NULL          
      )          
    END AS varchar(6)) CNTR_NRODOC,          
    CAST(null AS int) CNTR_VALORIZA,          
    CAST(dbo.FAC_FormatoCeroIzquierda(S.Numero,3) + dbo.FAC_FormatoCeroIzquierda(D.Numero,6) AS char(9)) CNTR_FACTURA,          
    CAST('0' AS char(1)) CNTR_SERVEXTRA,          
    CAST(          
    (          
     SELECT VC.Codigo          
     FROM FAC_CntDocumentoXCondicion CXC          
     INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion          
     WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
     AND  CXC.Ident_Condicion = 17 --Línea          
    ) AS varchar(4)) CNTR_LINEA,          
    CAST(          
    (          
     SELECT VC.Codigo          
     FROM FAC_CntDocumentoXCondicion CXC          
     INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion          
     WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
     AND  CXC.Ident_Condicion = 33 --Condición Contenedor          
    ) AS varchar(2)) CNTR_CONDICION,          
    CAST(          
    (          
     SELECT VC.Codigo          
     FROM FAC_CntDocumentoXCondicion CXC          
     INNER JOIN FAC_ValorCondicion VC ON VC.Ident_ValorCondicion = CXC.Ident_ValorCondicion          
     WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
     AND  CXC.Ident_Condicion = 30 --Tipo Contenedor          
    ) AS varchar(2)) CNTR_TIPO,          
    CAST(          
    CASE WHEN O.I021_Sustento = @IdentSustentoOperacion_Volante          
     THEN O.Sustento          
     ELSE          
      (          
       SELECT CXC.Valor          
       FROM FAC_CntDocumentoXCondicion CXC          
       WHERE CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
       AND  CXC.Ident_Condicion = 67 --Nave Viaje          
       AND  CXC.Valor IS NOT NULL          
      )          
    END AS varchar(6)) CNTR_BL,          
    CAST(null AS char(4)) CNTR_PREMEMO,          
    CAST(null AS char(10)) CNTR_NROMEMO,          
    CAST(null AS datetime) CNTR_VIGMEMO,          
    CAST(S.Ident_Local AS int) CNTR_LOCAL,          
    CAST(0 AS int) CNTR_FLGREINGRESO          
  FROM FAC_Documento D          
  INNER JOIN FAC_CntDocumento CNT ON CNT.Ident_Documento = D.Ident_Documento          
  INNER JOIN FAC_Operacion O ON O.Ident_Operacion = D.Sustento          
  INNER JOIN FAC_Serie S ON S.Ident_Serie = D.Ident_Serie          
  WHERE CNT.Ident_Documento = @IdentDocumento          
          
  DECLARE @cont int          
  DECLARE @max int          
  SET @cont = 1          
  SELECT @max = COUNT(*) FROM @TABLA_CNT_GATEIN          
          
  WHILE @cont <= @max          
  BEGIN          
   DECLARE @CNTR_CODIGO char(11)          
   DECLARE @CNTR_NAVEVIAJE char(6)          
   DECLARE @CNTR_TAMANIO char(2)          
   DECLARE @CNTR_USUARIO varchar(30)          
   DECLARE @CNTR_IDDOC int          
   DECLARE @CNTR_NRODOC varchar(6)          
   DECLARE @CNTR_VALORIZA int          
   DECLARE @CNTR_FACTURA char(9)          
   DECLARE @CNTR_SERVEXTRA char(1)          
   DECLARE @CNTR_LINEA varchar(4)          
   DECLARE @CNTR_CONDICION varchar(2)          
   DECLARE @CNTR_TIPO varchar(2)          
   DECLARE @CNTR_BL varchar(25)          
   DECLARE @CNTR_PREMEMO char(4)          
   DECLARE @CNTR_NROMEMO char(10)          
   DECLARE @CNTR_VIGMEMO datetime          
   DECLARE @CNTR_LOCAL int          
   DECLARE @CNTR_FLGREINGRESO int          
   DECLARE @CNTR_IDCNTR int          
          
   SELECT @CNTR_CODIGO = CNTR_CODIGO,          
     @CNTR_NAVEVIAJE = CNTR_NAVEVIAJE,          
     @CNTR_TAMANIO = CNTR_TAMANIO,          
     @CNTR_USUARIO = CNTR_USUARIO,          
     @CNTR_IDDOC = CNTR_IDDOC,          
     @CNTR_NRODOC = CNTR_NRODOC,          
     @CNTR_VALORIZA = CNTR_VALORIZA,          
     @CNTR_FACTURA = CNTR_FACTURA,          
     @CNTR_SERVEXTRA = CNTR_SERVEXTRA,          
     @CNTR_LINEA = CNTR_LINEA,          
     @CNTR_CONDICION = CNTR_CONDICION,          
     @CNTR_TIPO = CNTR_TIPO,          
     @CNTR_BL = CNTR_BL,          
     @CNTR_PREMEMO = CNTR_PREMEMO,          
     @CNTR_NROMEMO = CNTR_NROMEMO,          
     @CNTR_VIGMEMO = CNTR_VIGMEMO,          
     @CNTR_LOCAL = CNTR_LOCAL,          
     @CNTR_FLGREINGRESO = CNTR_FLGREINGRESO          
   FROM @TABLA_CNT_GATEIN          
   WHERE Row = @cont          
          
   EXEC FAC_InsertarCntGateIn_PAGONET @CNTR_CODIGO,          
            @CNTR_NAVEVIAJE,          
            @CNTR_TAMANIO,          
            @CNTR_USUARIO,          
            @CNTR_IDDOC,          
            @CNTR_NRODOC,          
         @CNTR_VALORIZA,          
            @CNTR_FACTURA,          
            @CNTR_SERVEXTRA,          
            @CNTR_LINEA,          
            @CNTR_CONDICION,          
            @CNTR_TIPO,          
            @CNTR_BL,          
            @CNTR_PREMEMO,          
            @CNTR_NROMEMO,          
            @CNTR_VIGMEMO,          
            @CNTR_LOCAL,          
            @CNTR_FLGREINGRESO,          
            @CNTR_IDCNTR OUTPUT          
          
   SET @cont = @cont + 1          
  END          
 END          
          
-- IF  @Condicion_Pagonet IS NOT NULL          
-- AND @Condicion_CreditoPagonet IS NOT NULL          
-- AND @Condicion_NumeroPrefacturaPagonet IS NOT NULL          
-- BEGIN          
--  BEGIN TRY          
--   DECLARE @ISTI_DOCU varchar(3)          
--   SET @ISTI_DOCU =          
--    CASE WHEN @IdentTipoDocumento = @IdentTipoDocumento_Factura          
--     THEN 'FAC'          
--     ELSE 'BOL'          
--    END          
--          
--   DECLARE @ISNU_DOCU varchar(20)          
--   SET @ISNU_DOCU = dbo.FAC_FormatoCeroIzquierda(@Serie, 4) + '-' + dbo.FAC_FormatoCeroIzquierda(@Numero, 10)          
--          
--   DECLARE @Resultado_2 int, @Mensaje_2 varchar(255)                  
--   --EXEC FAC_RegistrarAplicacionAnticipo_OFISIS @Cliente, @Condicion_NumeroPrefacturaPagonet, @Hoy, @Moneda, @Importe, '001', @Resultado_2 output, @Mensaje_2 output          
--   EXEC FAC_RegistrarAplicacionAnticipo_OFISIS @ISTI_DOCU, @ISNU_DOCU, @Condicion_NumeroPrefacturaPagonet, @Resultado_2 output, @Mensaje_2 output          
--   IF @Resultado_2 = 1          
--    RAISERROR(@Mensaje_2, 11, 1)          
--             
--  END TRY          
--  BEGIN CATCH          
--   SET @MensajeError = ERROR_MESSAGE()          
--   RAISERROR (@MensajeError, 11, 1)          
--  END CATCH          
-- END          
 /*Fin Pagonet*/          
          
 IF @IdentTipoFacturacion IN          
  (          
   @TipoFacturacion_Descarga,          
   @TipoFacturacion_Embarque,          
   @TipoFacturacion_DevolucionCnt,          
   @TipoFacturacion_RetiroCnt,          
   @TipoFacturacion_OrdenServicioExpo,          
   @TipoFacturacion_Balex,          
   @TipoFacturacion_ForwarderFlat,          
   @TipoFacturacion_OrdenServicioImpo,          
   @TipoFacturacion_Vigencia,          
   @TipoFacturacion_LineaVacios          
  )          
 BEGIN          
  DECLARE @IdentCondicion_FechaIngresoCarga int          
  SET @IdentCondicion_FechaIngresoCarga = dbo.FAC_ObtenerParametro_Valor('IdentCondicion_FechaIngresoCarga')          
          
  DECLARE @NroFac char(9)          
  SET @NroFac = dbo.FAC_FormatoCeroIzquierda(@Serie, 3) + dbo.FAC_FormatoCeroIzquierda(@Numero, 6)          
            
  DECLARE @TipFac char(3)          
  SET @TipFac =           
   CASE @IdentTipoFacturacion          
    WHEN @TipoFacturacion_Descarga THEN 'FIM'          
    WHEN @TipoFacturacion_Embarque THEN 'FDU'          
    WHEN @TipoFacturacion_DevolucionCnt THEN 'FGI'          
    WHEN @TipoFacturacion_RetiroCnt THEN 'FGO'          
    WHEN @TipoFacturacion_OrdenServicioExpo THEN 'FSX'          
    WHEN @TipoFacturacion_Balex THEN 'FBA'       
    WHEN @TipoFacturacion_ForwarderFlat THEN 'FFI'  ---Forwarder flat Impo         
    WHEN @TipoFacturacion_OrdenServicioImpo THEN 'FSE'          
    WHEN @TipoFacturacion_Vigencia THEN          
     CASE          
      WHEN @IdentTipoSustento = @IdentSustentoOperacion_Volante THEN 'FIM'          
      ELSE 'FVI'          
     END          
    WHEN @TipoFacturacion_LineaVacios THEN 'FAL'          
   END          
         
 ------IV--- 24/09/12--Forwarder flat Expo - Lo unico q lo diferencia es el ID de configuracion      
 If @IdentTipoFacturacion='12' and @Ident_Configuracion_Expo='104'      
 BEGIN      
 set @TipFac ='FFE' --- Forwarder Flat Expo      
 END     ---    
   
  ----IV 17/11/14 -Fact.Manual  
  If @I030_Sustento = 94  
  Begin  
  set @TipFac ='FMA' --- Facturacion manual   
  End  
          
  DECLARE @TipDoc char(2)          
  SET @TipDoc =          
   CASE WHEN @IdentTipoDocumento = @IdentTipoDocumento_Factura          
    THEN 'FA'          
    ELSE 'BV'          
   END          
          
  DECLARE @FecAlm char(8)          
  IF @TipFac = 'FAL'          
  BEGIN          
   SELECT @FecAlm = CONVERT(char(8),CONVERT(datetime,MIN(CXC.Valor),120),112)          
   FROM FAC_CntDocumento CNT          
   INNER JOIN FAC_CntDocumentoXCondicion CXC ON CXC.Ident_CntDocumento = CNT.Ident_CntDocumento          
   WHERE CXC.Ident_Condicion = @IdentCondicion_FechaIngresoCarga          
   AND  CNT.Ident_Documento = @IdentDocumento          
  END          
          
  DECLARE @coddespa varchar(15)          
  SET @coddespa = CAST(@Despachador AS varchar(15))          
          
  DECLARE @esPagonet bit          
  IF @Condicion_Pagonet IS NULL          
   SET @esPagonet = 0          
  ELSE          
   SET @esPagonet = 1          
          
  BEGIN          
   BEGIN TRY                 
    EXEC FAC_RegistrarPostFacturacion_NEP @NroFac,@TipDoc,@FecAlm,@TipFac,@coddespa,@GenerarOrden,@IdentDocumento,@esPagonet          
   END TRY          
   BEGIN CATCH          
    SET @MensajeError = ERROR_MESSAGE()          
    RAISERROR (@MensajeError, 11, 1)          
   END CATCH          
  END          
 END          
          
  --Registra Orden de Retiro en Citas y Facturacion          
  --Cambio Carga Suelta        
        
 SELECT  @IdentTipoFacturacion_Operacion=CONF.Ident_TipoFacturacion,        
 @IdentUnidadNegocio_Operacion=CONF.Ident_UnidadNegocio               
 FROM Fac_Documento D         
 INNER JOIN Fac_Operacion O ON D.Sustento=O.Ident_Operacion              
 INNER JOIN FAC_CONFIGURACION CONF ON O.Ident_Configuracion=CONF.Ident_Configuracion              
 WHERE D.IDENT_Documento= @IdentDocumento         
        
        
           
 --IF (@GenerarOrden =1 AND @IdentTipoFacturacion=2 AND @IdentConfiguracion in (91,92,95,96)   ) --cambio        
         
 IF (@GenerarOrden =1         
     AND @IdentTipoFacturacion_Operacion=@TipoFacturacion_Descarga          
     AND(@IdentUnidadNegocio_Operacion=@IdentUnidadNegocio_Forwarders OR @IdentUnidadNegocio_Operacion=@IdentUnidadNegocio_CargaProyectos ) )        
 BEGIN        
    EXEC FAC_RegistrarOrdenRetiroBulto @IdentDocumento         
 END        
 ELSE        
 BEGIN         
    EXEC FAC_RegistrarOrdenRetiroContenedor @IdentDocumento    
    ----17/05/13    
    EXEC FAC_RegularizaOR_Contenedores_tercero_PostFact @IdentDocumento    ---**      
 END        
         
         
          
          
          
          
             
END          
          
          
          
          
          
          
    -------------------------------------************************************************************************      
          