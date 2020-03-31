--  
CREATE PROCEDURE [dbo].[SP_TMDOCU_PRRE_INTE_T01]            
/*---------------------------------------------------------*/              
/*---Empresa              : OFISIS S.A.                  --*/              
/*---Cliente              : OFISIS S.A.                  --*/              
/*---Sistema              : Tesoreria                    --*/              
/*---M÷dulo               : Empresa                      --*/              
/*---Programa             : Transferencia de documentos  --*/              
/*---                       a la tabla TMDOCU_PRRE       --*/              
/*---Script               : ttproc_i.sql                 --*/              
/*---Nombre SP            : SP_TMDOCU_PRRE_INTE_T01      --*/              
/*---Desarrollado por     : Guido Loayza Silva           --*/              
/*---Fecha Creaci÷n       : 06/10/2011                   --*/              
/*---Base Datos           : Microsoft Sql Server         --*/              
/*---Versi÷n              : 9.0                          --*/              
/*---Invoca a SP          :                              --*/              
/*---------------------------------------------------------*/              
/*---Modificado 1 por     : C.Timana                     --*/              
/*---Fecha Modificaciön   : 07/03/2012                   --*/              
/*---Detalle Modificaciön : Se corrigio para el caso de afectos, para          
que considere tambien los importe impuesto                             --*/              
/*---------------------------------------------------------*/                
/*---Modificado 1 por     : WALTER FLORES       */              
/*---Fecha Modificaciön   : 25/09/2013                     */              
/*---Detalle Modificaciön : Se retiro la validacion de "YA         
  Existe documento en el OFITESO         */        
/*---------------------------------------------------------*/              
/*---Drop Proc SP_TMDOCU_PRRE_INTE_T01                   --*/              
/*---Grant all on SP_TMDOCU_PRRE_INTE_T01 to public      --*/               
/*---SP_TMDOCU_PRRE_I03                                  --*/              
/*---------------------------------------------------------*/             
/*---Modificado 1 por     : WALTER FLORES       */              
/*---Fecha Modificaciön   : 30/01/2015                     */              
/*---Detalle Modificaciön : CAMBIO DE SERVER A COSMOS-DB   */        
/*---------------------------------------------------------*/             
--with ENCRYPTION          
            
AS      
      
DECLARE            
/* DOC. PROVEEDOR */            
@CSCO_EMPR  TD_VC_002,            
@CSCO_PROV  TD_VC_020,            
@CSCO_TIPO_DOCU TD_VC_003,            
@CSNU_DOCU_PROV TD_VC_020,            
@CDFE_EMIS  TD_DT_001,            
@CSCO_COND_PAGO TD_VC_003,            
@CSCO_UNID_CONC TD_VC_003,            
@CDFE_VENC  TD_DT_001,            
@CNFA_TIPO_CAMB TD_NU_015_006,            
@CSCO_MONE  TD_VC_003,            
@CNIM_BRUT_AFEC TD_NU_016_004,            
@CDFE_PROG_PAGO TD_DT_001,            
@CNIM_BRUT_INAF TD_NU_016_004,            
@CDFE_REGI_COMP TD_DT_001,            
@CNPC_IMP1  TD_NU_009_004,            
@CNIM_IMP1  TD_NU_016_004,            
@CSCO_IMP1  TD_VC_003,            
@CNPC_IMP2  TD_NU_009_004,            
@CNIM_IMP2  TD_NU_016_004,            
@CSCO_IMP2  TD_VC_003,            
@CNPC_IMP3  TD_NU_009_004,            
@CNIM_IMP3  TD_NU_016_004,            
@CSCO_IMP3  TD_VC_003,            
@CNIM_TOTA  TD_NU_016_004,            
@CNIM_PAGA  TD_NU_016_004,            
@CSTI_DOCU_ORIG TD_VC_003,            
@CSNU_DOCU_ORIG TD_VC_020,            
@CDFE_DOCU_ORIG TD_DT_001,            
@CSDE_OBSE  TD_VC_100,            
@CSTI_SITU  TD_VC_003,            
@CSCO_ENTI_APRO TD_VC_020,            
@CSTI_ENTI_APRO TD_VC_001,            
@CSST_APRO  TD_VC_001,            
@CSCO_ESTA_DOCU TD_VC_003,            
@CSCO_ENTI_GENE TD_VC_020,            
@CSTI_ENTI_GENE TD_VC_001,            
@CDFE_CTRL  TD_DT_001,            
@CSST_ENVI_OFIS TD_VC_001,           
@CSNU_DOCU_MAXI TD_VC_020,            
@CNNU_LINE_MAXI TD_IN_001,            
/* ORD. COMPRA*/            
@CSCO_PROV_ORCO   TD_VC_020,            
@CSCO_TIPO_DOCU_ORCO TD_VC_003,            
@CSNU_DOCU_PROV_ORCO TD_VC_020,            
@CSCO_TIPO_ORCO   TD_VC_003,            
@CSNU_ORCO    TD_VC_020,               
@CSTI_DOCU_ORCO   TD_VC_003,                
@CSNU_DOCU_ORCO   TD_VC_020,            
@CNIM_DOCU_ORCO   TD_NU_016_004,               
@CSCO_UNID_ORCO   TD_VC_003,                
@CSCO_ALMA_ORCO   TD_VC_003,            
@CSNU_DOCU_MAXI_ORCO TD_VC_020,              
@CNNU_LINE_MAXI_ORCO TD_IN_001,            
/* --- DOCUMENTOS DE ALMACEN --- */            
@CSCO_ALMA    TD_VC_020,              
@CSCO_ITEM    TD_VC_020,               
@CSCO_UNME_MOVI   TD_VC_010,              
@CNCA_DOCU_MOVI   TD_NU_016_004,            
@CSCO_UNME    TD_VC_020,              
@CNCA_DOCU_ALMA   TD_NU_016_004,             
@CNIM_COST_COMP   TD_NU_016_004,              
@CNIM_COST_ALMA   TD_NU_016_004,            
@CNNU_SECU    TD_IN_001,              
@CSNU_GUIA_PROV   TD_VC_020,             
@CSNU_CNTA_CNTB   TD_VC_020,              
@CSTI_AUXI_EMPR   TD_VC_001,            
@CSCO_AUXI_EMPR   TD_VC_020,             
@CSCO_ORDE_SERV   TD_VC_020,            
@CSST_ENVI_OFIS_ALMA TD_VC_001,            
@CSNU_DOCU_MAXI_ALMA TD_VC_020,            
@CNNU_LINE_MAXI_ALMA TD_IN_001,            
@VSCO_ERROR  TD_IN_001,            
@VNCA_TRANS  TD_IN_001,            
@VNNU_PROC_MAXI TD_IN_001,            
@VDFE_PROC_MAXI TD_DT_001,            
@VNIM_ORDE_COMP TD_NU_016_004,            
@VNIM_DOCU_ALMA TD_NU_016_004,            
@VSST_AUXI_EMPR TD_VC_001,            
@VSST_DOCU_CNTB TD_VC_001,            
@VSST_ORDE_SERV TD_VC_001,          
@VNNU_LONG TD_IN_001,          
@VNNU_LONG_SERI TD_IN_001,          
@VSST_SERI TD_VC_001,          
@VSDE_GUIO TD_VC_001,          
@VSST_CIER_CNTB TD_VC_001,          
@VSTI_SITU_DOCU TD_VC_003,          
@VSNU_SERI_PROV TD_VC_020,          
@VSNU_DOLO_PROV TD_VC_020,          
@VNNU_ERRO_DETA TD_IN_001    
    
    
/* --- CUENTAS CONTABLES --- */            
/* --- CURSOR FUERA      ----*/  
DECLARE @CONTADOR INTEGER  
SET @CONTADOR = 0  
  
PRINT '****  INICIO PROCESOS    ***************************************************'  
PRINT ' '  
PRINT ' '  
  
          
DECLARE CU_SP_TMDOCU_PRRE_INTE_T01 CURSOR             
FOR            
 SELECT DISTINCT      
   CO_EMPR,  CO_PROV,  CO_TIPO_DOCU,  NU_DOCU_PROV,            
   FE_EMIS,  'C02', CO_UNID_CONC,  FE_VENC,            
   FA_TIPO_CAMB, CO_MONE,  IM_BRUT_AFEC,  FE_PROG_PAGO,            
   IM_BRUT_INAF, FE_REGI_COMP, PC_IMP1,   IM_IMP1,            
   CO_IMP1,  PC_IMP2,  IM_IMP2,   CO_IMP2,            
   PC_IMP3,  IM_IMP3,  CO_IMP3,   IM_TOTA,            
   IM_PAGA,  TI_DOCU_ORIG, NU_DOCU_ORIG,  FE_DOCU_ORIG,            
   DE_OBSE,  TI_SITU,  CO_ENTI_APRO,  TI_ENTI_APRO,            
   ST_APRO,  CO_ESTA_DOCU, CO_ENTI_GENE,  TI_ENTI_GENE,            
   FE_CTRL,  ST_ENVI_OFIS, NU_DOCU_MAXI            
 FROM TMDOCU_PRRE_INTE            
 WHERE ST_ENVI_OFIS = 'N'     
 AND CO_ESTA_DOCU='ACT'  
 AND CONVERT(VARCHAR(8),FE_EMIS,112)>'20180101'       
 -- AND NU_DOCU_MAXI NOT IN (  
 --  SELECT NU_DOCU_MAXI FROM TDORDE_FACT_INTE  
 --  WHERE CO_EMPR='16'  
 --  GROUP BY NU_DOCU_MAXI  
 --   HAVING COUNT(*)>200  
 --)  --2018.03.13: Exceden los registros a procesar       
 --ORDER BY NU_DOCU_MAXI DESC   
  
SET NOCOUNT ON        
BEGIN            
         
exec MI_TMDOCU_PRRE_U01          
PRINT '--**PREVIO: SE EJECUTO CON EXITO SP: MI_TMDOCU_PRRE_U01 *******************************************************'               
  
        
 SELECT @VNNU_PROC_MAXI =  ISNULL(MAX(NU_PROC_MAXI),0)+ 1,          
  @VDFE_PROC_MAXI = GETDATE()          
 FROM TTPROC_MAXI            
  
  
            
 OPEN CU_SP_TMDOCU_PRRE_INTE_T01            
 FETCH CU_SP_TMDOCU_PRRE_INTE_T01            
 INTO             
 @CSCO_EMPR,   @CSCO_PROV,   @CSCO_TIPO_DOCU, @CSNU_DOCU_PROV,             
 @CDFE_EMIS,   @CSCO_COND_PAGO, @CSCO_UNID_CONC, @CDFE_VENC,            
 @CNFA_TIPO_CAMB, @CSCO_MONE,   @CNIM_BRUT_AFEC, @CDFE_PROG_PAGO,            
 @CNIM_BRUT_INAF, @CDFE_REGI_COMP, @CNPC_IMP1,   @CNIM_IMP1,            
 @CSCO_IMP1,   @CNPC_IMP2,   @CNIM_IMP2,   @CSCO_IMP2,            
 @CNPC_IMP3,   @CNIM_IMP3,   @CSCO_IMP3,   @CNIM_TOTA,            
 @CNIM_PAGA,   @CSTI_DOCU_ORIG, @CSNU_DOCU_ORIG, @CDFE_DOCU_ORIG,            
 @CSDE_OBSE,   @CSTI_SITU,   @CSCO_ENTI_APRO, @CSTI_ENTI_APRO,            
 @CSST_APRO,   @CSCO_ESTA_DOCU, @CSCO_ENTI_GENE, @CSTI_ENTI_GENE,            
 @CDFE_CTRL,   @CSST_ENVI_OFIS, @CSNU_DOCU_MAXI            
            
 While @@Fetch_Status = 0            
 Begin            
  If @@Fetch_Status < 0            
   Begin            
    Close CU_SP_TMDOCU_PRRE_INTE_T01            
    Deallocate CU_SP_TMDOCU_PRRE_INTE_T01            
   End                
PRINT ' '   
PRINT ' '  
SET @CONTADOR = @CONTADOR  + 1  
PRINT '--****************   INICIO PRIMER CURSOR NIVEL 1 *******************************************************'                 
PRINT 'OCURRENCIA NRO:  ' + CONVERT(VARCHAR(5),@CONTADOR)     
PRINT @CSNU_DOCU_MAXI  
  /* --- CODIGO DE EMPRESA --- */            
          
   --IF @CSCO_EMPR != '01'                  
   --BEGIN            
   -- INSERT INTO TMDOCU_MAXI_ERRO(            
   -- CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
   -- NU_DOCU_MAXI,   DE_ERRO,      CO_USUA_CREA,            
   -- FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
   -- FE_PROC_MAXI)            
   -- VALUES            
   -- (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   --  @CSNU_DOCU_MAXI,  'Codigo de Empresa Incorrecto',user,            
   --  getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   --  @VDFE_PROC_MAXI)                
   --END               
          
   /* --- CODIGO DE PROVEEDOR --- */            
   PRINT 'VALIDACION 1 :  CODIGO DE PROVEEDOR '  
     
   SELECT @VSCO_ERROR = 0                  
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMAUXI_EMPR            
   WHERE CO_EMPR =  @CSCO_EMPR            
   AND  TI_AUXI_EMPR = 'P'            
   AND  CO_AUXI_EMPR =  @CSCO_PROV            
               
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,   DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI, @CSCO_PROV+ ': Codigo de Proveedor no Existe en el OFISIS solicitar su Ingreso',user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
            
   /* --- TIPO DE DOCUMENTO --- */            
   PRINT 'VALIDACION 2 :  TIPO DE DOCUMENTO '  
     
   SELECT @VSCO_ERROR = 0                  
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTDOCU_CNTB            
   WHERE TI_DOCU IN (@CSCO_TIPO_DOCU, @CSTI_DOCU_ORIG)            
                  
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Tipo de Documento no Existe', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
 ELSE          
 BEGIN          
   SELECT @VSST_SERI = ST_SERI,   
  @VNNU_LONG_SERI = NU_LONG_SERI,          
  @VNNU_LONG = NU_LONG          
   FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTDOCU_CNTB          
   WHERE TI_DOCU = @CSCO_TIPO_DOCU              
  
 PRINT '@VSST_SERI  '  
 PRINT @VSST_SERI    
    
          
  IF @VSST_SERI = 'S'          
  BEGIN          
  
  
          
   /* --- BUSCO DONDE ESTA EL GUION  --- */          
   PRINT 'VALIDACION 3 :  DONDE ESTA EL GUION  '  
     
   SELECT @VSDE_GUIO = SubString(ISNULL(@CSNU_DOCU_PROV,''), @VNNU_LONG_SERI +1,1)             
    PRINT @VSDE_GUIO         
--   SELECT @VSDE_GUIO  = CHARINDEX('-', @CSNU_DOCU_PROV)             
             
--   SELECT @VSNU_SERI_PROV = REPLICATE('0', @VNNU_LONG_SERI - (@VSDE_GUIO-1)) + LEFT(@CSNU_DOCU_PROV, @VSDE_GUIO-1)          
--   SELECT @VSNU_DOLO_PROV = REPLICATE('0', @VNNU_LONG - LEN(SubString(@CSNU_DOCU_PROV,@VSDE_GUIO+1,LEN(@CSNU_DOCU_PROV)))) +          
--          SubString(@CSNU_DOCU_PROV,@VSDE_GUIO+1,LEN(@CSNU_DOCU_PROV))            
--            
--   SELECT @CSNU_DOCU_PROV = @VSNU_SERI_PROV + '-' + @VSNU_DOLO_PROV          
--   SELECT @VSDE_GUIO = SubString(ISNULL(@CSNU_DOCU_PROV,''), @VNNU_LONG_SERI +1,1)             
            
   IF @VSDE_GUIO != '-' OR LEN(SubString(@CSNU_DOCU_PROV,@VNNU_LONG_SERI+2,LEN(@CSNU_DOCU_PROV))) != @VNNU_LONG          
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Formato de Numero Incorrecto / No Valido', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)             
          
   END          
  END          
  
--PRINT '@CSCO_COND_PAGO  '  
--PRINT @CSCO_COND_PAGO    
 END          
          
            
   /* --- CONDICION DE PAGO  --- */            
PRINT 'VALIDACION 4 :  CONDICION DE PAGO  '     
   SELECT @VSCO_ERROR = 0                  
                 
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTCOND_PAGO            
   WHERE CO_EMPR = @CSCO_EMPR            
   AND  CO_COND_PAGO  = @CSCO_COND_PAGO            
     
   IF @VSCO_ERROR <= 0            
   BEGIN             
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,    CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),           
     @CSNU_DOCU_MAXI,  'Condicion de Pago no Existe', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                 
   END            
    
   /* ---- MONEDA --- */            
  PRINT 'VALIDACION 5 :  MONEDA  '     
    
   SELECT @VSCO_ERROR = 0                  
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTMONE            
   WHERE CO_MONE = @CSCO_MONE             
            
   IF @VSCO_ERROR <= 0            
   BEGIN             
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Moneda no Existe', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)           
   END            
  
  
   /* ---- IMPUESTO --- */            
  PRINT 'VALIDACION 6 :  IMPUESTO '  
          
   SELECT @VSCO_ERROR = 0                  
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTIMPT            
   WHERE CO_IMPT IN (@CSCO_IMP1, @CSCO_IMP2, @CSCO_IMP3)            
            
   IF @VSCO_ERROR <= 0            
   BEGIN             
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Impuesto no Existe', user,            
     getdate(),   user,    getdate(),     @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                 
   END            
  
   /* --- IMPORTES POSITIVOS --- */              
  PRINT 'VALIDACION 7 :  IMPORTES POSITIVOS '  
  
   IF (@CNIM_TOTA <= 0) OR (@CNIM_PAGA != 0)           
   BEGIN          
     INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Tiene un Importe Incorrecto es Menor o igual a CERO', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)          
   END          
    
       
   IF @CNIM_BRUT_AFEC > 0 AND ((@CNIM_IMP1 + @CNIM_IMP2 + @CNIM_IMP3) <= 0)          
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI, CONVERT(VARCHAR(15),@CNIM_BRUT_AFEC) +': Tiene un Importe (Afecto o Impuesto) Incorrecto', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)               
   END            
    
         
  IF (@CNIM_BRUT_AFEC  + @CNIM_BRUT_INAF) <= 0          
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Tiene un Importe Incorrecto', user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)               
   END           
              
         
 /* --- FACTOR DE CAMBIO --- */          
PRINT 'VALIDACION 8 :  FACTOR DE CAMBIO  '   
 IF @CNFA_TIPO_CAMB IS NULL OR LEN(RTRIM(LTRIM(@CNFA_TIPO_CAMB))) = 0 OR @CNFA_TIPO_CAMB <= 0.00          
 BEGIN          
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Factor de Cambio Incorrecto', user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)            
 END          
            
   /* --- TIPO DE ENTIDAD --- */             
PRINT 'VALIDACION 9 :  TIPO DE ENTIDAD  '       
   SELECT @VSCO_ERROR = 0                  
            
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTAUXI_EMPR            
   WHERE CO_EMPR =  @CSCO_EMPR            
   AND  TI_AUXI_EMPR IN(@CSTI_ENTI_APRO, @CSTI_ENTI_GENE)            
               
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,   DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Tipo de Entidad no Existe',user,      
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,         @VDFE_PROC_MAXI)                
   END            
    
            
   /* --- CODIGO DE ENTIDAD APRUEBA --- */            
PRINT 'VALIDACION 10 :  CODIGO DE ENTIDAD APRUEBA '          
   SELECT @VSCO_ERROR = 0                  
            
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMAUXI_EMPR            
   WHERE CO_EMPR =  @CSCO_EMPR            
   AND  TI_AUXI_EMPR = @CSTI_ENTI_APRO            
   AND  CO_AUXI_EMPR =  @CSCO_ENTI_APRO            
               
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Codigo de Entidad que Aprueba no Existe',user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
    
   /* --- FECHA DE EMISION --- */          
PRINT 'VALIDACION 11 :  FECHA DE EMISION --- '                  
 IF @CDFE_EMIS IS NULL OR LEN(LTRIM(RTRIM(@CDFE_EMIS))) = 0          
 BEGIN          
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Fecha de Emision Incorrecta',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)           
 END          
          
--SP_TMDOCU_PRRE_INTE_T01          
   /* --- FECHA DE VENCIMIENTO  --- */          
PRINT 'VALIDACION 12 :  FECHA DE VENCIMIENTO  --- '                     
           
 select  @CDFE_VENC =convert(datetime, dateadd (day, 30, @CDFE_EMIS),103)          
 IF @CDFE_VENC IS NULL OR LEN(LTRIM(RTRIM(@CDFE_VENC))) = 0          
 BEGIN          
            
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Fecha de Vencimiento Incorrecta',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)           
 END          
    
   /* --- FECHA DE PROGRAMACION --- */          
PRINT 'VALIDACION 13 :  FECHA DE PROGRAMACION --- '                       
                 
 select @CDFE_PROG_PAGO =convert(datetime, dateadd (day, 30, @CDFE_EMIS),103)            
 IF @CDFE_PROG_PAGO IS NULL OR LEN(LTRIM(RTRIM(@CDFE_PROG_PAGO))) = 0          
 BEGIN          
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Fecha de Programacion Incorrecta',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)           
 END          
   /* --- FECHA DE REGISTRO DE COMPRA --- */          
PRINT 'VALIDACION 14 :  FECHA DE REGISTRO DE COMPRA --- '                           
----BY:WALTER FLORES          
----COMMENT: PARA MAXIMO SE ENVIA FECHA EMISIÓN COMO FECHA DE REGISTRO DE COMPRA  -2018.02.28  
  
SET @CDFE_REGI_COMP =@CDFE_EMIS  
 IF (@CDFE_REGI_COMP IS NULL OR LEN(LTRIM(RTRIM(@CDFE_REGI_COMP))) = 0) OR MONTH(@CDFE_EMIS) != MONTH(@CDFE_REGI_COMP)          
 BEGIN          
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Fecha de Registro de Compras Incorrecta',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)           
 END            
 ELSE          
 BEGIN          
  Select @VSST_CIER_CNTB =  IsNull(T2.ST_CIER_CNTB,'')          
  From OFITESO..TDTIPO_OPER T1 ,OFITESO..TCFECH_PROC T2          
  Where  T1.CO_EMPR = T2.CO_EMPR          
  And T1.CO_OPRC_CNTB = T2.CO_OPRC_CNTB          
  And T1.CO_EMPR = @CSCO_EMPR          
  And T2.NU_CNTB_EMPR = 1          
  And T2.CO_UNID_CNTB = @CSCO_UNID_CONC          
  And T2.NU_ANNO = YEAR(@CDFE_REGI_COMP)          
  And T2.NU_MESE = MONTH(@CDFE_REGI_COMP)          
  And EXISTS (          
  SELECT * FROM OFICONT..TTIDEN_OPER T4          
  WHERE T4.CO_EMPR = T2.CO_EMPR          
  AND T4.CO_OPRC_CNTB = T2.CO_OPRC_CNTB          
  AND T4.NU_CNTB_EMPR =  T2.NU_CNTB_EMPR          
  AND T4.ID_OPRC = '001')          
            
  
PRINT 'VALIDACION 15 :  PERIODO CERRADO--- '                           
            
  IF @VSST_CIER_CNTB = 'S'          
  BEGIN           
   INSERT INTO TMDOCU_MAXI_ERRO(            
   CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
   NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
   FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
   FE_PROC_MAXI)            
   VALUES            
   (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
    @CSNU_DOCU_MAXI,  'Periodo de Registro de Compras esta Cerrado',user,            
    getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,         
    @VDFE_PROC_MAXI)           
  
 --UPDATE TMDOCU_PRRE_INTE SET ST_ENVI_OFIS = 'E' WHERE NU_DOCU_MAXI=@CSNU_DOCU_MAXI  
 --PRINT 'BREAK POR PERIODO CERRADO'  
 ----BREAK  
   
  END          
--  IF ISNULL(@VSST_CIER_CNTB,'') = ''          
--  BEGIN             
--   INSERT INTO TMDOCU_MAXI_ERRO(            
--   CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
--   NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
--   FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
--   FE_PROC_MAXI)            
--   VALUES            
--   (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
--    @CSNU_DOCU_MAXI,  'Periodo de Registro de Compras no esta Aperturado',user,            
--    getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
--    @VDFE_PROC_MAXI)           
--  END          
 END          
          
 /* --- OBSERVACION  --- */          
 PRINT 'VALIDACION 16 :  OBSERVACION  --- '                           
          
 IF LEN(LTRIM(RTRIM(@CSDE_OBSE))) = 0 OR @CSDE_OBSE IS NULL          
 BEGIN           
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Observación / Glosa en Blanco',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)           
 END           
  
   /* --- CODIGO DE ENTIDAD GENERA --- */            
PRINT 'VALIDACION 17 :  CODIGO DE ENTIDAD GENERA   --- '                              
   SELECT @VSCO_ERROR = 0                  
            
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMAUXI_EMPR            
   WHERE CO_EMPR =  @CSCO_EMPR            
   AND  TI_AUXI_EMPR = @CSTI_ENTI_GENE            
   AND  CO_AUXI_EMPR =  @CSCO_ENTI_GENE            
               
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Codigo de Entidad que Genera no Existe',user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
    
   /* --- TOTAL ORDENES DE COMPRA --- */           
PRINT 'VALIDACION 18 :  TOTAL ORDENES DE COMPRA --- '                                   
  
   SELECT  @VNIM_ORDE_COMP =  ROUND(SUM(IM_DOCU),1)          
   FROM TDORDE_FACT_INTE            
   WHERE             
    CO_EMPR = @CSCO_EMPR            
   AND CO_PROV = @CSCO_PROV            
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
   AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
   GROUP BY CO_EMPR, CO_PROV, CO_TIPO_DOCU, NU_DOCU_PROV, NU_DOCU_MAXI            
        
         
        
   /* --- DETALLE DE ORDENES DE COMPRA --- */             
PRINT 'VALIDACION 19 :  DETALLE DE ORDENES DE COMPRA --- '                                   
  
   SELECT @VSCO_ERROR = 0              
            
   SELECT @VSCO_ERROR = COUNT(*) FROM TDORDE_FACT_INTE          
   WHERE             
     CO_EMPR = @CSCO_EMPR            
   AND ST_ENVI_OFIS = 'N'            
   AND CO_PROV = @CSCO_PROV            
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
   AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
          
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
    FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Documento no Tiene Ordenes de Compra',user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
    
--   IF @VNIM_ORDE_COMP != (@CNIM_BRUT_AFEC  + @CNIM_BRUT_INAF)            
   IF @VNIM_ORDE_COMP != ROUND((@CNIM_BRUT_AFEC  + @CNIM_BRUT_INAF),1)          
   BEGIN               
  PRINT 'WFLORES'        
PRINT '   /* --- DETALLE DE ORDENES DE COMPRA --- */            '        
print @CSNU_DOCU_MAXI      
PRINT @VNIM_ORDE_COMP        
PRINT @CNIM_BRUT_INAF        
PRINT @CNIM_BRUT_AFEC        
PRINT '   /* --- DETALLE DE ORDENES DE COMPRA --- */            '        
        
  --ACA          
  --  INSERT INTO TMDOCU_MAXI_ERRO(            
  --  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  --  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  --  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  --  FE_PROC_MAXI)            
  --  VALUES            
  --  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
  --   @CSNU_DOCU_MAXI,  'Total de O/C no es Igual al Imp. Afecto / Inafecto del Doc. ' +  @CSCO_TIPO_DOCU,user,            
  --   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
  --   @VDFE_PROC_MAXI)        
  --print 'Total de O/C no es Igual al Imp. Afecto / Inafecto del Doc. '        
  --print @VNIM_ORDE_COMP        
  --print (@CNIM_BRUT_AFEC  + @CNIM_BRUT_INAF)            
   END              
          
   /* --- CODIGO DE UNIDAD --- */            
PRINT 'VALIDACION 20 :  CODIGO DE UNIDAD --- '                                   
     
   SELECT @VSCO_ERROR = 0                  
            
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMUNID_CNTB            
   WHERE CO_EMPR =  @CSCO_EMPR            
   AND  CO_UNID_CNTB = @CSCO_UNID_CONC                 
               
   IF @VSCO_ERROR <= 0            
   BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
    CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
    NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
    FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,              FE_PROC_MAXI)            
    VALUES            
    (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
     @CSNU_DOCU_MAXI,  'Codigo de Sucursal no Existe',user,            
     getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
     @VDFE_PROC_MAXI)                
   END            
  
   /* --- DOCUMENTO SI YA EXISTE EN OFITESO --- */            
PRINT 'VALIDACION 21 :  DOCUMENTO SI YA EXISTE EN OFITESO --- '                                      
   SELECT @VSCO_ERROR = 0             
            
   SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PROV            
   WHERE             
    CO_EMPR   = @CSCO_EMPR            
   AND CO_PROV   = @CSCO_PROV            
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
          
   --IF @VSCO_ERROR > 0            
   --BEGIN            
   -- INSERT INTO TMDOCU_MAXI_ERRO(            
   -- CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
   -- NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
   -- FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
   -- FE_PROC_MAXI)            
   -- VALUES            
   -- (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   --  @CSNU_DOCU_MAXI,  'Documento Proveedor ya Existe en OFITESO', user,            
   --  getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   --  @VDFE_PROC_MAXI)          
   --END            
          
   SELECT @VSCO_ERROR = 0             
            
   SELECT @VSCO_ERROR = COUNT(*), @VSTI_SITU_DOCU = MAX(TI_SITU) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE           
   WHERE             
    CO_EMPR   = @CSCO_EMPR            
   AND CO_PROV   = @CSCO_PROV            
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
            
   IF @VSCO_ERROR > 0            
   BEGIN             IF @VSTI_SITU_DOCU !=  'APR'          
 BEGIN          
  DELETE FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE          
  WHERE             
   CO_EMPR   = @CSCO_EMPR            
  AND CO_PROV   = @CSCO_PROV            
  AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
  AND NU_DOCU_PROV = @CSNU_DOCU_PROV             
  INSERT INTO TMDOCU_MAXI_TRANS(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI,  'Documento Proveedor ya Existe en OFITESO - Recepcion / Se Elimino', user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)             
 END            
 ELSE          
 BEGIN          
  INSERT INTO TMDOCU_MAXI_ERRO(            
   CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
   NU_DOCU_MAXI,    DE_ERRO,      CO_USUA_CREA,            
   FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
   FE_PROC_MAXI)            
   VALUES            
   (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
    @CSNU_DOCU_MAXI,  'Documento Proveedor ya Existe en OFITESO - Recepcion / Aprobado', user,            
    getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
    @VDFE_PROC_MAXI)             
            
 END          
           
   END            
  
  
  
DECLARE @ERRN1 INTEGER  
SET @ERRN1 = 0  
  
    
PRINT '--****************   INICIO SEGUNDO CURSOR NIVEL 2********************************************************'               
          
    DECLARE CU_SP_TDORDE_FACT_INTE_T01 CURSOR             
    FOR            
    SELECT             
    CO_TIPO_DOCU_ORCO, NU_ORCO,   TI_DOCU,   NU_DOCU,                
    IM_DOCU,   CO_UNID,   CO_ALMA , NU_LINE_MAXI          
    FROM TDORDE_FACT_INTE            
    WHERE             
  ST_ENVI_OFIS = 'N'           
    AND CO_EMPR   = @CSCO_EMPR            
    AND CO_PROV   = @CSCO_PROV            
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
          
    OPEN CU_SP_TDORDE_FACT_INTE_T01            
    FETCH CU_SP_TDORDE_FACT_INTE_T01            
    INTO             
    @CSCO_TIPO_ORCO, @CSNU_ORCO,   @CSTI_DOCU_ORCO,  @CSNU_DOCU_ORCO,              
    @CNIM_DOCU_ORCO, @CSCO_UNID_ORCO, @CSCO_ALMA_ORCO, @CNNU_LINE_MAXI          
          
    While (@@Fetch_Status = 0)            
    Begin            
               
     If (@@Fetch_Status < 0)            
      Begin            
       RAISERROR 20001 'Error'        
       Close CU_SP_TDORDE_FACT_INTE_T01            
       Deallocate CU_SP_TDORDE_FACT_INTE_T01            
       RETURN            
      End            
              
    PRINT   '/* --- TIPO DE DOCUMENTO --- */          '  
      SELECT @VSCO_ERROR = 0                  
            
      SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TTDOCU_CNTB            
      WHERE TI_DOCU IN (@CSTI_DOCU_ORCO, @CSCO_TIPO_ORCO)                      
          
      IF @VSCO_ERROR <= 0            
      BEGIN            
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
       (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Tipo de Documento O/C no Existe', user,            
        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,          
        @VDFE_PROC_MAXI)                
          
        SET @ERRN1 = @ERRN1  + 1  
         IF @ERRN1 > 3   
         BEGIN  
     PRINT 'BREAK DEMASIADOS ERRORES NIVEL 2'  
     BREAK  
   END       
   ELSE  
     CONTINUE  
  
          
      END            
            
      /* --- IMPORTES POSITIVOS --- */                  
      IF @CNIM_DOCU_ORCO <= 0            
      BEGIN            
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
       (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Importe Incorrecto O/C', user,            
        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
        @VDFE_PROC_MAXI)               
          
        SET @ERRN1 = @ERRN1  + 1  
         IF @ERRN1 > 3   
         BEGIN  
           PRINT 'BREAK DEMASIADOS ERRORES NIVEL 2'  
     BREAK  
   END       
   ELSE  
     CONTINUE  
          
      END            
            
      /* --- UNIDAD O/C --- */            
      SELECT @VSCO_ERROR = 0                  
            
      SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMUNID_CNTB            
      WHERE             
       CO_EMPR = @CSCO_EMPR            
      AND CO_UNID_CNTB = @CSCO_UNID_ORCO            
                  
      IF @VSCO_ERROR <= 0            
      BEGIN            
    INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
       (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Codigo de Unidad O/C no Existe', user,            
        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
        @VDFE_PROC_MAXI)                
          
        SET @ERRN1 = @ERRN1  + 1  
         IF @ERRN1 > 3   
         BEGIN  
     PRINT 'BREAK DEMASIADOS ERRORES NIVEL 2'  
     BREAK  
   END   
   ELSE  
     CONTINUE  
      END            
           
  /*   
  -- NO FUNCIONA CON 2 OC EL @VNIM_ORDE_COMP SE DEBE CAMBIAR A OC X OC ESTA TOMANDO EL TOTAL DE TODO EL DOCUMENTO  
  -- 2012.08.29 By WFLORES  change: IM_COST_ALMA),2        
    SELECT @VNIM_DOCU_ALMA = Round(SUM(CA_DOCU_ALMA * IM_COST_ALMA),1) FROM TDDOCU_ALMA_INTE          
    WHERE  CO_EMPR = @CSCO_EMPR           
    AND ST_ENVI_OFIS = 'N'             
    AND CO_PROV = @CSCO_PROV            
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
    AND NU_LINE_MAXI = @CNNU_LINE_MAXI            
    AND CO_TIPO_DOCU_ORCO = @CSCO_TIPO_ORCO          
    AND NU_ORCO = @CSNU_ORCO          
          
   IF Round(@VNIM_ORDE_COMP,0) !=  Round(@VNIM_DOCU_ALMA,0)          
   BEGIN         
   PRINT '---------------'         
   PRINT @CSNU_DOCU_MAXI        
   PRINT @VNIM_ORDE_COMP        
   PRINT @VNIM_DOCU_ALMA        
   PRINT '---------------'         
   DECLARE @DIF NUMERIC(14,4)        
   SET @DIF= @VNIM_ORDE_COMP-@VNIM_DOCU_ALMA        
   IF @DIF<1        
   BEGIN        
   SET @DIF=@DIF*-1        
   END        
          
  PRINT @DIF    
          
   IF @DIF>2 --2016.05.02 : WALTER FLORES        
    BEGIN        
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,     
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, '02- Total de Item''s no Coincide con O/C',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)               
   END         
   END          
   */     
    
  SELECT @VSCO_ERROR = 0              
          
  SELECT @VSCO_ERROR = COUNT(*) FROM TDDOCU_ALMA_INTE          
  WHERE             
   CO_EMPR = @CSCO_EMPR           
    AND ST_ENVI_OFIS = 'N'             
    AND CO_PROV = @CSCO_PROV            
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU            
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV            
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
    AND NU_LINE_MAXI = @CNNU_LINE_MAXI            
    AND CO_TIPO_DOCU_ORCO = @CSCO_TIPO_ORCO          
    AND NU_ORCO = @CSNU_ORCO          
          
    IF @VSCO_ERROR <= 0            
    BEGIN            
 PRINT '---------------------------------------------'        
 PRINT @CSCO_PROV            
    PRINT @CSCO_TIPO_DOCU            
    PRINT @CSNU_DOCU_PROV            
    PRINT @CSNU_DOCU_MAXI            
    PRINT @CNNU_LINE_MAXI            
    PRINT @CSCO_TIPO_ORCO          
    PRINT @CSNU_ORCO          
        
 PRINT '---------------------------------------------'        
        
        
  INSERT INTO TMDOCU_MAXI_ERRO(            
  CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
  NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
  FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
  FE_PROC_MAXI)            
  VALUES            
  (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
   @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Documento O/C no Tiene Detalle de Item''s',user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)                
     
   SET @ERRN1 = @ERRN1  + 1  
         IF @ERRN1 > 3   
         BEGIN  
     PRINT 'BREAK DEMASIADOS ERRORES NIVEL 2'  
     BREAK  
   END   
   ELSE  
     CONTINUE  
  
     
    END              
  
  
  
SELECT @VSCO_ERROR = 0              
           
 SELECT @VSCO_ERROR = COUNT(*) FROM TMDOCU_MAXI_ERRO          
 WHERE           
  CO_EMPR   = @CSCO_EMPR          
 AND CO_PROV   = ISNULL(@CSCO_PROV,'')          
 AND CO_TIPO_DOCU =  ISNULL(@CSCO_TIPO_DOCU,'')          
 AND NU_DOCU_PROV =  ISNULL(@CSNU_DOCU_PROV,'')          
 AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI           
 AND NU_PROC_MAXI = @VNNU_PROC_MAXI          
   
   
  
PRINT  '--****  NRO DE ERRORES ANTES DE ENTRAR AL NIVEL 3 .....  **********************'  
PRINT  @VSCO_ERROR          
 IF @VSCO_ERROR >= 5     
 BEGIN  
  BREAK  
  PRINT 'BREAK DEMASIADOS ERRORES ANTES DE ENTRAR A NIVEL 3'  
END   
   
   
     FETCH CU_SP_TDORDE_FACT_INTE_T01            
     INTO             
     @CSCO_TIPO_ORCO, @CSNU_ORCO,   @CSTI_DOCU_ORCO,  @CSNU_DOCU_ORCO,              
     @CNIM_DOCU_ORCO, @CSCO_UNID_ORCO, @CSCO_ALMA_ORCO,  @CNNU_LINE_MAXI          
             
                
    End /* WHILE ORD. COMPRA */            
    Close CU_SP_TDORDE_FACT_INTE_T01             
    Deallocate CU_SP_TDORDE_FACT_INTE_T01             
   
   
              
DECLARE @ERRN2 INTEGER  
SET @ERRN2 = 0  
  
  
PRINT '---*************  INICIO TERCER CURSOR NIVEL3 ***************************************************************************'              
              
   DECLARE CU_SP_TDDOCU_ALMA_INTE_T01 CURSOR             
      FOR            
    SELECT            
    CO_ALMA,  CO_ITEM,  CO_UNME_MOVI,  CA_DOCU_MOVI,            
    CO_UNME,  CA_DOCU_ALMA, IM_COST_COMP,  IM_COST_ALMA,            
    NU_SECU,  NU_GUIA_PROV, NU_CNTA_CNTB,  TI_AUXI_EMPR,       
    CO_AUXI_EMPR, CO_ORDE_SERV            
    FROM TDDOCU_ALMA_INTE            
    WHERE               
    ST_ENVI_OFIS  = 'N'            
    AND CO_EMPR    = @CSCO_EMPR            
    AND CO_PROV    = @CSCO_PROV            
    AND CO_TIPO_DOCU  = @CSCO_TIPO_DOCU            
    AND NU_DOCU_PROV  = @CSNU_DOCU_PROV            
    AND CO_TIPO_DOCU_ORCO = @CSCO_TIPO_ORCO            
    AND NU_ORCO    = @CSNU_ORCO            
    AND NU_DOCU_MAXI  = @CSNU_DOCU_MAXI            
    AND NU_LINE_MAXI  = @CNNU_LINE_MAXI            
            
      OPEN CU_SP_TDDOCU_ALMA_INTE_T01            
      FETCH CU_SP_TDDOCU_ALMA_INTE_T01            
      INTO             
      @CSCO_ALMA,   @CSCO_ITEM,   @CSCO_UNME_MOVI, @CNCA_DOCU_MOVI,            
      @CSCO_UNME,   @CNCA_DOCU_ALMA, @CNIM_COST_COMP, @CNIM_COST_ALMA,            
      @CNNU_SECU,   @CSNU_GUIA_PROV, @CSNU_CNTA_CNTB, @CSTI_AUXI_EMPR,            
      @CSCO_AUXI_EMPR, @CSCO_ORDE_SERV            
            
      While @@Fetch_Status = 0            
      Begin            
       If @@Fetch_Status < 0            
        Begin            
         Close CU_SP_TDDOCU_ALMA_INTE_T01            
         Deallocate CU_SP_TDDOCU_ALMA_INTE_T01            
        End                      
        
        
      PRINT'--SUBNIVEL3: VALIDACION 1'  
        
      IF @CNCA_DOCU_MOVI <= 0 or @CNIM_COST_ALMA  <= 0             
      BEGIN            
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
       (@CSCO_EMPR, ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, CONVERT(VARCHAR(11),@CNIM_COST_ALMA) +': Cantidad de Item Incorrecta', user,            
        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
        @VDFE_PROC_MAXI)              
          
        SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
      END            
            
--      /* --- UNIDADES DE MEDIDA --- */            
--      SELECT @VSCO_ERROR = 0            --            
--      SELECT @VSCO_ERROR = COUNT(*) FROM OFITESO..TTUNID_MEDI            
--      WHERE CO_UNME IN (@CSCO_UNME, @CSCO_UNME_MOVI)            
--                  
-- IF @VSCO_ERROR <= 0            
--      BEGIN            
--       INSERT INTO TMDOCU_MAXI_ERRO(            
--       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
--       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
--       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
--       FE_PROC_MAXI)            
--       VALUES            
--       (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
--        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Unidad de Medida no Existe', user,            
--        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
--        @VDFE_PROC_MAXI)                
--      END            
--                  
  
     PRINT' --SUBNIVEL3: VALIDACION 2'  
      IF @CNIM_COST_ALMA <= 0 OR @CNIM_COST_COMP <= 0            
      BEGIN            
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
       (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
        @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Importe de Item Incorrecto', user,            
        getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
        @VDFE_PROC_MAXI)             
          
        SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
          
      END            
        
   
      /* --- UNIDADES DE MEDIDA --- */            
      SELECT @VSCO_ERROR = 0              
      SELECT @VSCO_ERROR = COUNT(*)             
       FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMPLAN_EMPR            
      WHERE            
       CO_EMPR   = @CSCO_EMPR            
      AND CO_CNTA_EMPR = @CSNU_CNTA_CNTB            
        
        
 -- SELECT *  FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMPLAN_EMPR            
 --   WHERE        
 --    CO_EMPR   = @CSCO_EMPR            
 --   AND CO_CNTA_EMPR = @CSNU_CNTA_CNTB            
 --PRINT @CSNU_CNTA_CNTB        
 --PRINT @CSCO_EMPR            
        
      IF @VSCO_ERROR <= 0             
    BEGIN            
            
--PRINT 'WFLORES'        
--PRINT @CSNU_CNTA_CNTB        
--PRINT @CSCO_EMPR            
        
      INSERT INTO TMDOCU_MAXI_ERRO(            
      CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
      NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
      FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
      FE_PROC_MAXI)            
      VALUES            
      (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
    @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI,@CSNU_CNTA_CNTB+ ': Cuenta Contable no Existe', user,            
    getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
    @VDFE_PROC_MAXI)       
      
      SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
        
    END            
      ELSE            
    BEGIN             
    SELECT           
     @VSST_AUXI_EMPR = ST_AUXI_EMPR,            
     @VSST_DOCU_CNTB = ST_DOCU_CNTB,            
     @VSST_ORDE_SERV = ST_ORDE_SERV            
    FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMPLAN_EMPR            
    WHERE            
     CO_EMPR   = @CSCO_EMPR            
    AND CO_CNTA_EMPR = @CSNU_CNTA_CNTB            
              
    IF @VSST_AUXI_EMPR = 'S' AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_AUXI_EMPR)),''))= 0          
     BEGIN          
      INSERT INTO TMDOCU_MAXI_ERRO(            
      CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
      NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
      FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
      FE_PROC_MAXI)            
      VALUES            
        (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
      @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Cuenta Contable lleva Auxiliar', user,            
      getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
      @VDFE_PROC_MAXI)     
        
        SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
                   
     END          
    ELSE if @VSST_AUXI_EMPR = 'S' AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_AUXI_EMPR)),'')) != 0          
     BEGIN          
         /* --- AUXILIARES --- */            
      SELECT @VSCO_ERROR = 0              
          
      SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMAUXI_EMPR          
      WHERE           
       CO_EMPR   = @CSCO_EMPR          
      AND TI_AUXI_EMPR = @CSTI_AUXI_EMPR          
      AND CO_AUXI_EMPR = @CSCO_AUXI_EMPR          
                        
      IF @VSCO_ERROR <= 0           
      BEGIN          
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
         (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
       @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, @CSTI_AUXI_EMPR+'-'+@CSCO_AUXI_EMPR+ ': Auxiliar Contable no Existe', user,            
       getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
       @VDFE_PROC_MAXI)    
         
         SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
                   
      END          
     END           
    Else if @VSST_AUXI_EMPR = 'N'AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_AUXI_EMPR)),'')) != 0          
     BEGIN          
      UPDATE          
      TDDOCU_ALMA_INTE          
      SET          
      TI_AUXI_EMPR = NULL,          
      CO_AUXI_EMPR = NULL          
      WHERE           
       CO_EMPR   = @CSCO_EMPR          
      AND CO_PROV   = @CSCO_PROV          
      AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
      AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
      AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
      AND NU_LINE_MAXI = @CNNU_LINE_MAXI           
     END          
          
          
    IF @VSST_ORDE_SERV = 'S' AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_ORDE_SERV)),''))= 0          
     BEGIN          
      INSERT INTO TMDOCU_MAXI_ERRO(            
      CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
      NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
      FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
      FE_PROC_MAXI)            
      VALUES            
        (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
      @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, 'Cuenta Contable lleva Orden de Servicio', user,            
      getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
      @VDFE_PROC_MAXI)     
        SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
                   
     END          
    ELSE IF @VSST_ORDE_SERV = 'S' AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_ORDE_SERV)),''))!= 0          
     BEGIN          
         /* --- AUXILIARES --- */            
      SELECT @VSCO_ERROR = 0              
--       PRINT '@CSCO_ORDE_SERV '  
--       PRINT @CSCO_EMPR  
--       PRINT @CSCO_ORDE_SERV  
      SELECT @VSCO_ERROR = COUNT(*) FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMORDE_SERV          
  WHERE           
       CO_EMPR   = @CSCO_EMPR               
      AND CO_ORDE_SERV = @CSCO_ORDE_SERV          
      AND TI_SITU = 'ACT'          
          
      IF @VSCO_ERROR <= 0           
      BEGIN          
       INSERT INTO TMDOCU_MAXI_ERRO(            
       CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
       NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
       FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
       FE_PROC_MAXI)            
       VALUES            
         (@CSCO_EMPR,  ISNULL(@CSCO_PROV,''),   ISNULL(@CSCO_TIPO_DOCU,''),    ISNULL(@CSNU_DOCU_PROV,''),            
       @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, @CSCO_ORDE_SERV +': Orden de Servicio (Quiebre) No Existe', user,            
       getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
       @VDFE_PROC_MAXI)    
         
         SET @ERRN2 = @ERRN2  + 1  
         IF @ERRN2 > 0   
     BREAK  
   ELSE  
     CONTINUE  
                   
      END          
     END           
    ELSE IF @VSST_ORDE_SERV = 'N' AND LEN(ISNULL(LTRIM(RTRIM(@CSCO_ORDE_SERV)),''))!= 0          
     BEGIN          
      UPDATE          
      TDDOCU_ALMA_INTE          
      SET          
      CO_ORDE_SERV = NULL          
      WHERE           
       CO_EMPR   = @CSCO_EMPR          
      AND CO_PROV   = @CSCO_PROV          
      AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
      AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
      AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
      AND NU_LINE_MAXI = @CNNU_LINE_MAXI           
     END          
    END               
            
      FETCH CU_SP_TDDOCU_ALMA_INTE_T01            
      INTO             
      @CSCO_ALMA,   @CSCO_ITEM,   @CSCO_UNME_MOVI, @CNCA_DOCU_MOVI,            
      @CSCO_UNME,   @CNCA_DOCU_ALMA, @CNIM_COST_COMP, @CNIM_COST_ALMA,            
      @CNNU_SECU,   @CSNU_GUIA_PROV, @CSNU_CNTA_CNTB, @CSTI_AUXI_EMPR,            
      @CSCO_AUXI_EMPR, @CSCO_ORDE_SERV            
            
      End            
      Close CU_SP_TDDOCU_ALMA_INTE_T01            
      Deallocate CU_SP_TDDOCU_ALMA_INTE_T01             
              
   
   
   
    -- FETCH CU_SP_TDORDE_FACT_INTE_T01            
    -- INTO             
    -- @CSCO_TIPO_ORCO, @CSNU_ORCO,   @CSTI_DOCU_ORCO,  @CSNU_DOCU_ORCO,              
    -- @CNIM_DOCU_ORCO, @CSCO_UNID_ORCO, @CSCO_ALMA_ORCO,  @CNNU_LINE_MAXI          
             
                
    --End /* WHILE ORD. COMPRA */            
    --Close CU_SP_TDORDE_FACT_INTE_T01             
    --Deallocate CU_SP_TDORDE_FACT_INTE_T01             
          
   
   
   
 /* ---  SI NO HAY ERRORES PARA EL DOC SE INSERTA EN LA TABLAS DE OFITESO  --- */          
          
 SELECT @VSCO_ERROR = 0              
           
 SELECT @VSCO_ERROR = COUNT(*) FROM TMDOCU_MAXI_ERRO          
 WHERE           
  CO_EMPR   = @CSCO_EMPR          
 AND CO_PROV   = ISNULL(@CSCO_PROV,'')          
 AND CO_TIPO_DOCU =  ISNULL(@CSCO_TIPO_DOCU,'')          
 AND NU_DOCU_PROV =  ISNULL(@CSNU_DOCU_PROV,'')          
 AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI           
 AND NU_PROC_MAXI = @VNNU_PROC_MAXI          
          
 IF @VSCO_ERROR = 0           
  BEGIN           
   SELECT @VNNU_ERRO_DETA = 0          
PRINT 'DOCUMENTO INICIO'        
 PRINT @CSCO_PROV        
 PRINT @CSNU_DOCU_PROV        
 PRINT @CSNU_DOCU_MAXI      
 --PRINT '-----------------------'    
   --SELECT   distinct       
   --CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, FE_EMIS,          
   --'C02',   CO_UNID_CONC, @CDFE_VENC,  FA_TIPO_CAMB, CO_MONE,          
   --IM_BRUT_AFEC, @CDFE_PROG_PAGO, IM_BRUT_INAF, CASE WHEN YEAR(FE_EMIS)=2017 THEN '20180101' ELSE FE_EMIS END --BY :WFLORES --31/01/2018        
   --, PC_IMP1,          
   --ISNULL(IM_IMP1,0),  ISNULL(PC_IMP2,0),  CO_IMP1,  ISNULL(IM_IMP2,0),  ISNULL(PC_IMP3,0),          
   --CO_IMP2,  ISNULL(IM_IMP3,0),  IM_TOTA,  IM_PAGA,  CO_IMP3,          
   --TI_DOCU_ORIG, NU_DOCU_ORIG, FE_DOCU_ORIG, @CSDE_OBSE,  'ENV',          
   --CO_ENTI_APRO, TI_ENTI_APRO, ST_APRO,  '',    CO_ESTA_DOCU,          
   --CO_ENTI_GENE, TI_ENTI_GENE, FE_CTRL,  '',    CO_USUA_CREA,          
   --FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI, 'S',   NU_DOCU_MAXI,          
   --NU_LINE_MAXI, @VNNU_PROC_MAXI,GETDATE()          
   --FROM TMDOCU_PRRE_INTE          
   --WHERE           
   -- CO_EMPR   = @CSCO_EMPR          
   --AND CO_PROV   = @CSCO_PROV          
   --AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
   --AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
   --AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
          
PRINT 'DOCUMENTO INICIO INSERCCION TMDOCU_PRRE'        
          
   INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE (          
   CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, FE_EMIS,          
   CO_COND_PAGO, CO_UNID_CONC, FE_VENC,  FA_TIPO_CAMB, CO_MONE,          
   IM_BRUT_AFEC, FE_PROG_PAGO, IM_BRUT_INAF, FE_REGI_COMP, PC_IMP1,          
   IM_IMP1,  PC_IMP2,  CO_IMP1,  IM_IMP2,  PC_IMP3,          
   CO_IMP2,  IM_IMP3,  IM_TOTA,  IM_PAGA,  CO_IMP3,          
   TI_DOCU_ORIG, NU_DOCU_ORIG, FE_DOCU_ORIG, DE_OBSE,  TI_SITU,          
   CO_ENTI_APRO, TI_ENTI_APRO, ST_APRO,  NU_CORR_PROV, CO_ESTA_DOCU,          
   CO_ENTI_GENE, TI_ENTI_GENE, FE_CTRL,  NU_CORR_COMP, CO_USUA_CREA,          
   FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI, ST_DOCU_MAXI, NU_DOCU_MAXI,          
   NU_LINE_MAXI, NU_PROC_MAXI, FE_PROC_MAXI)          
   SELECT   distinct       
   CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, FE_EMIS,          
   'C02',   CO_UNID_CONC, @CDFE_VENC,  FA_TIPO_CAMB, CO_MONE,          
   IM_BRUT_AFEC, @CDFE_PROG_PAGO, IM_BRUT_INAF, CASE WHEN YEAR(FE_EMIS)=2017 THEN '20180101' ELSE FE_EMIS END --BY :WFLORES --31/01/2018        
   , PC_IMP1,          
   ISNULL(IM_IMP1,0),  ISNULL(PC_IMP2,0),  CO_IMP1,  ISNULL(IM_IMP2,0),  ISNULL(PC_IMP3,0),          
   CO_IMP2,  ISNULL(IM_IMP3,0),  IM_TOTA,  IM_PAGA,  CO_IMP3,          
   TI_DOCU_ORIG, NU_DOCU_ORIG, FE_DOCU_ORIG, @CSDE_OBSE,  'ENV',          
   CO_ENTI_APRO, TI_ENTI_APRO, ST_APRO,  '',    CO_ESTA_DOCU,          
   CO_ENTI_GENE, TI_ENTI_GENE, FE_CTRL,  '',    CO_USUA_CREA,          
   FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI, 'S',   NU_DOCU_MAXI,          
   NU_LINE_MAXI, @VNNU_PROC_MAXI,GETDATE()          
   FROM TMDOCU_PRRE_INTE          
   WHERE           
    CO_EMPR   = @CSCO_EMPR          
   AND CO_PROV   = @CSCO_PROV          
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
   AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
          
   SELECT @VNNU_ERRO_DETA = COUNT(CO_EMPR)           
   FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE          
   WHERE           
    CO_EMPR   = @CSCO_EMPR          
   AND CO_PROV   = @CSCO_PROV          
   AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
   AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
   AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
   AND ST_DOCU_MAXI = 'S'          
   AND NU_PROC_MAXI = @VNNU_PROC_MAXI          
   
 PRINT @VNNU_ERRO_DETA   
SELECT TOP 55 * FROM OFITESO..TMDOCU_PRRE WHERE NU_DOCU_MAXI=@CSNU_DOCU_MAXI   
  
PRINT 'DOCUMENTO FIN DE INSERCCION TMDOCU_PRRE'        
         
   IF @VNNU_ERRO_DETA > 0          
   BEGIN              
          
 PRINT 'INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE_INTE'  
  
    INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE_INTE            
    (CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, FE_EMIS,            
    CO_COND_PAGO, CO_UNID_CONC, FE_VENC,  FA_TIPO_CAMB, CO_MONE,            
    IM_BRUT_AFEC, FE_PROG_PAGO, IM_BRUT_INAF, FE_REGI_COMP, PC_IMP1,          
    IM_IMP1,  CO_IMP1,  PC_IMP2,  IM_IMP2,  CO_IMP2,          
    PC_IMP3,  IM_IMP3,  CO_IMP3,  IM_TOTA,  IM_PAGA,          
    TI_DOCU_ORIG, NU_DOCU_ORIG, FE_DOCU_ORIG, DE_OBSE,  TI_SITU,          
    CO_ENTI_APRO, TI_ENTI_APRO, ST_APRO,  CO_ESTA_DOCU, CO_ENTI_GENE,          
    TI_ENTI_GENE, FE_CTRL,  ST_ENVI_OFIS, NU_DOCU_MAXI, NU_LINE_MAXI,          
    CO_USUA_CREA, FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI, NU_PROC_MAXI,          
    FE_PROC_MAXI)          
    SELECT          
    CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, FE_EMIS,            
    'C02',   CO_UNID_CONC, FE_VENC,  FA_TIPO_CAMB, CO_MONE,            
    IM_BRUT_AFEC, FE_PROG_PAGO, IM_BRUT_INAF, FE_EMIS,  PC_IMP1,          
    IM_IMP1,  CO_IMP1,  PC_IMP2,  IM_IMP2,  CO_IMP2,          
    PC_IMP3,  IM_IMP3,  CO_IMP3,  IM_TOTA,  IM_PAGA,          
    TI_DOCU_ORIG, NU_DOCU_ORIG, FE_DOCU_ORIG, @CSDE_OBSE,  TI_SITU,          
    CO_ENTI_APRO, TI_ENTI_APRO, ST_APRO,  CO_ESTA_DOCU, CO_ENTI_GENE,          
    TI_ENTI_GENE, FE_CTRL,  'S',   NU_DOCU_MAXI, NU_LINE_MAXI,          
    CO_USUA_CREA, FE_USUA_CREA, CO_USUA_MODI, FE_USUA_MODI, @VNNU_PROC_MAXI,          
    GETDATE ()          
    FROM TMDOCU_PRRE_INTE          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI            
    
    
   PRINT 'INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TDORDE_FACT_INTE '           
    INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TDORDE_FACT_INTE (          
    CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, CO_TIPO_DOCU_ORCO,          
    NU_ORCO,  TI_DOCU,  NU_DOCU,  IM_DOCU,  FE_DOCU,          
    CO_UNID,  CO_ALMA,  ST_ENVI_OFIS, CO_USUA_CREA, FE_USUA_CREA,          
    CO_USUA_MODI, FE_USUA_MODI, CO_MONE,  NU_PROC_MAXI, FE_PROC_MAXI,          
    NU_DOCU_MAXI, NU_LINE_MAXI)          
    SELECT           
    CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, CO_TIPO_DOCU_ORCO,          
    NU_ORCO,  TI_DOCU,  NU_DOCU,  IM_DOCU,  FE_DOCU,          
    CO_UNID,  CO_ALMA,  'S',   CO_USUA_CREA, FE_USUA_CREA,          
    CO_USUA_MODI, FE_USUA_MODI, CO_MONE,  @VNNU_PROC_MAXI,GETDATE(),          
    NU_DOCU_MAXI, NU_LINE_MAXI          
    FROM TDORDE_FACT_INTE          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
    --AND NU_LINE_MAXI = @CNNU_LINE_MAXI            
             
PRINT 'INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TDDOCU_ALMA_INTE'  
  
    INSERT INTO [COSMOS-DB\SQL2008].OFITESO.DBO.TDDOCU_ALMA_INTE(          
    CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, CO_TIPO_DOCU_ORCO,          
    NU_ORCO,  CO_ALMA,  FE_DOCU,  CO_ITEM,  DE_ITEM,          
    CO_UNME_MOVI, CA_DOCU_MOVI, CO_UNME,  CA_DOCU_ALMA, IM_COST_COMP,          
    IM_COST_ALMA, NU_SECU,  NU_GUIA_PROV, NU_CNTA_CNTB, TI_AUXI_EMPR,          
    CO_AUXI_EMPR, CO_ORDE_SERV, ST_ENVI_OFIS, CO_USUA_CREA, FE_USUA_CREA,          
    CO_USUA_MODI, FE_USUA_MODI, NU_PROC_MAXI, FE_PROC_MAXI, NU_DOCU_MAXI,          
    NU_LINE_MAXI)          
    SELECT           
    CO_EMPR,  CO_PROV,  CO_TIPO_DOCU, NU_DOCU_PROV, CO_TIPO_DOCU_ORCO,          
    NU_ORCO,  CO_ALMA,  FE_DOCU,  CO_ITEM,  DE_ITEM,          
    CO_UNME_MOVI, CA_DOCU_MOVI, CO_UNME,  CA_DOCU_ALMA, IM_COST_COMP,          
    IM_COST_ALMA, NU_SECU,  NU_GUIA_PROV, NU_CNTA_CNTB, TI_AUXI_EMPR,          
    CO_AUXI_EMPR, CO_ORDE_SERV, ST_ENVI_OFIS, CO_USUA_CREA, FE_USUA_CREA,          
    CO_USUA_MODI, FE_USUA_MODI, @VNNU_PROC_MAXI,GETDATE(),  NU_DOCU_MAXI,          
    NU_LINE_MAXI          
    FROM TDDOCU_ALMA_INTE          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
    --AND NU_LINE_MAXI = @CNNU_LINE_MAXI          
     
          
                
    UPDATE TMDOCU_PRRE_INTE          
    SET   ST_ENVI_OFIS = 'S'          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI           
          
    UPDATE TDORDE_FACT_INTE          
    SET   ST_ENVI_OFIS = 'S'          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
    AND NU_LINE_MAXI = @CNNU_LINE_MAXI          
          
    UPDATE TDDOCU_ALMA_INTE          
    SET    ST_ENVI_OFIS = 'S'          
    WHERE           
     CO_EMPR   = @CSCO_EMPR          
    AND CO_PROV   = @CSCO_PROV          
    AND CO_TIPO_DOCU = @CSCO_TIPO_DOCU          
    AND NU_DOCU_PROV = @CSNU_DOCU_PROV          
    AND NU_DOCU_MAXI = @CSNU_DOCU_MAXI          
 AND NU_LINE_MAXI = @CNNU_LINE_MAXI          
          
   END           
   INSERT INTO TMDOCU_MAXI_TRANS(            
   CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,            
   NU_DOCU_MAXI,  NU_LINE_MAXI,  DE_ERRO,      CO_USUA_CREA,            
   FE_USUA_CREA,  CO_USUA_MODI,  FE_USUA_MODI,     NU_PROC_MAXI,            
   FE_PROC_MAXI)            
   VALUES            
     (@CSCO_EMPR,  @CSCO_PROV,   @CSCO_TIPO_DOCU,    @CSNU_DOCU_PROV,            
   @CSNU_DOCU_MAXI, @CNNU_LINE_MAXI, NULL, user,            
   getdate(),   user,    getdate(),      @VNNU_PROC_MAXI,            
   @VDFE_PROC_MAXI)              
          
          
  END              
   FETCH CU_SP_TMDOCU_PRRE_INTE_T01            
   INTO             
   @CSCO_EMPR,   @CSCO_PROV,   @CSCO_TIPO_DOCU, @CSNU_DOCU_PROV,             
   @CDFE_EMIS,   @CSCO_COND_PAGO, @CSCO_UNID_CONC, @CDFE_VENC,            
   @CNFA_TIPO_CAMB, @CSCO_MONE,   @CNIM_BRUT_AFEC, @CDFE_PROG_PAGO,            
   @CNIM_BRUT_INAF, @CDFE_REGI_COMP, @CNPC_IMP1,   @CNIM_IMP1,            
   @CSCO_IMP1,   @CNPC_IMP2,   @CNIM_IMP2,   @CSCO_IMP2,            
   @CNPC_IMP3,   @CNIM_IMP3,   @CSCO_IMP3,   @CNIM_TOTA,            
   @CNIM_PAGA,   @CSTI_DOCU_ORIG, @CSNU_DOCU_ORIG, @CDFE_DOCU_ORIG,            
   @CSDE_OBSE,   @CSTI_SITU,   @CSCO_ENTI_APRO, @CSTI_ENTI_APRO,            
   @CSST_APRO,   @CSCO_ESTA_DOCU, @CSCO_ENTI_GENE, @CSTI_ENTI_GENE,            
   @CDFE_CTRL,   @CSST_ENVI_OFIS, @CSNU_DOCU_MAXI            
          
 END /* WHILE DOC. PROVEEDOR */     
          
          
          
 /* CONTAMOS LOS ERRORES QUE SE TIENEN POR PROCESO */          
 SELECT @VSCO_ERROR = 0          
          
 SELECT @VSCO_ERROR = COUNT(*) FROM TMDOCU_MAXI_ERRO          
 WHERE           
  CO_EMPR   = @CSCO_EMPR          
 AND NU_PROC_MAXI = @VNNU_PROC_MAXI          
 GROUP BY CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,     NU_DOCU_PROV,  NU_DOCU_MAXI          
           
          
 /* CONTAMOS LOS DOCUMENTOS TRANSFERIDOS EN EL PROCESO */          
 SELECT @VNCA_TRANS = 0          
          
 SELECT @VNCA_TRANS = COUNT(CO_EMPR) FROM TMDOCU_MAXI_TRANS          
 WHERE           
  CO_EMPR   = @CSCO_EMPR          
 AND NU_PROC_MAXI = @VNNU_PROC_MAXI          
 --GROUP BY CO_EMPR,   CO_PROV,   CO_TIPO_DOCU,    NU_DOCU_MAXI,     NU_DOCU_PROV          
          
           
 /* SI SE TRANSFIRIERON DOCUMENTOS ELIMIMO DE LA TABLA DE ERRORES LO ANTERIOR */           
          
 IF @VNCA_TRANS > 0          
  BEGIN          
   DELETE FROM TMDOCU_MAXI_ERRO          
   WHERE EXISTS           
   (SELECT * FROM TMDOCU_MAXI_TRANS          
   WHERE           
    TMDOCU_MAXI_ERRO.CO_EMPR = TMDOCU_MAXI_TRANS.CO_EMPR          
   AND TMDOCU_MAXI_ERRO.CO_PROV = TMDOCU_MAXI_TRANS.CO_PROV          
   AND TMDOCU_MAXI_ERRO.NU_DOCU_PROV = TMDOCU_MAXI_TRANS.NU_DOCU_PROV          
   AND TMDOCU_MAXI_TRANS.NU_PROC_MAXI = @VNNU_PROC_MAXI)          
   AND TMDOCU_MAXI_ERRO.CO_EMPR = @CSCO_EMPR          
   AND TMDOCU_MAXI_ERRO.NU_PROC_MAXI < @VNNU_PROC_MAXI          
  END           
          
 IF @VSCO_ERROR > 0          
  BEGIN          
   DELETE FROM TMDOCU_MAXI_ERRO          
   WHERE EXISTS           
   (SELECT * FROM TMDOCU_MAXI_ERRO T2          
   WHERE           
    TMDOCU_MAXI_ERRO.CO_EMPR = T2.CO_EMPR          
   AND TMDOCU_MAXI_ERRO.CO_PROV = T2.CO_PROV          
   AND TMDOCU_MAXI_ERRO.NU_DOCU_PROV = T2.NU_DOCU_PROV          
   AND T2.NU_PROC_MAXI = @VNNU_PROC_MAXI)          
   AND TMDOCU_MAXI_ERRO.CO_EMPR = @CSCO_EMPR          
   AND TMDOCU_MAXI_ERRO.NU_PROC_MAXI < @VNNU_PROC_MAXI          
  END           
          
          
 IF @VSCO_ERROR = 0 AND @VNCA_TRANS = 0           
  SELECT  @VSCO_ERROR = 0            
 ELSE          
 BEGIN           
          
  INSERT INTO TTPROC_MAXI (NU_PROC_MAXI, FE_PROC_MAXI) VALUES (@VNNU_PROC_MAXI, @VDFE_PROC_MAXI)          
 END          
           
 SELECT 'SE TRANSFIRIENTON ' + convert(varchar,@VNCA_TRANS) + ' DOCUMENTOS '          
          
 IF @VSCO_ERROR > 0           
  BEGIN          
   SELECT 'EXISTEN REGISTROS QUE NO FUERON TRANSFERIDOS EJECUTE LA SIGUIENTE SENTENCIA : SELECT * FROM TMDOCU_MAXI_ERRO WHERE NU_PROC_MAXI = ''' + convert(varchar,@VNNU_PROC_MAXI) +''''          
  END          
          
 Close CU_SP_TMDOCU_PRRE_INTE_T01            
 Deallocate CU_SP_TMDOCU_PRRE_INTE_T01             
            
END 