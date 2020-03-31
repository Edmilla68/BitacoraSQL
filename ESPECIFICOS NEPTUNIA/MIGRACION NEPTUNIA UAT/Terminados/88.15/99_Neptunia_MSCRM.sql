ALTER PROCEDURE usp_IntN4_RegistrarCliente       
@CodUsuarioWS varchar(100)        
,@PassUsuarioWS varchar(100)        
,@Name NVARCHAR(320)      
,@Nep1to1_apellidopaterno NVARCHAR(100)      
,@Nep1to1_apellidomaterno NVARCHAR(100)      
,@Nep1to1_nombres NVARCHAR(100)      
,@Name_address NVARCHAR(200)      
,@EMailAddress1 NVARCHAR(200)      
,@Nep1to1_tipodocumento INT      
,@AccountNumber NVARCHAR(40)      
      
--,@Moneda INT      
      
,@TipoCodigo int      
,@Codigo Nvarchar(10)      
,@Tipo int --1:Registro, 2:Actualizacion, 3:cancelacion        
,@IdResul varchar(3) OUTPUT        
,@DesResul varchar(500) OUTPUT        
      
AS      
BEGIN      
      
DECLARE @Exists int        
         
/*Incializando Variables de Salida*/        
SET @IdResul = '0'        
SET @DesResul = 'OK'        
      
/*Validaciones Previas al Registro*/        
IF NOT EXISTS(SELECT VALUE FROM [SP3TDA-DBSQL02].Terminal.dbo.COSETTING WHERE KEY_COSETTING = 'USER_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @CodUsuarioWS)        
BEGIN        
 SET @IdResul = '-1'        
 SET @DesResul = 'Usuario de conexion N4 incorrecto'        
 RETURN;        
END        
IF NOT EXISTS(SELECT VALUE FROM [SP3TDA-DBSQL02].Terminal.dbo.COSETTING WHERE KEY_COSETTING = 'PASS_DPW_INT_N4' AND LTRIM(RTRIM(VALUE)) = @PassUsuarioWS)        
BEGIN        
 SET @IdResul = '-1'        
 SET @DesResul = 'Password de conexion N4 incorrecto'        
 RETURN;        
END         
      
  IF (LEN(@Nep1to1_tipodocumento) = 0)        
  BEGIN        
   SET @IdResul = '-1'        
   SET @DesResul = 'Debe enviar el Codigo del Tipo Documento'        
   RETURN;        
  END        
  if (@Nep1to1_tipodocumento = 0 or @Nep1to1_tipodocumento > 6)      
  begin      
 SET @IdResul = '-1'        
 SET @DesResul = 'El Codigo del Tipo Documento debe ser 1-Dni, 2-Ruc, 3-Carnet de Extranjería, 4-Pasaporte, 5-No Domiciliado, 6-Otro'        
   RETURN;        
  end      
      
  IF (LEN(@AccountNumber) = 0)        
  BEGIN        
   SET @IdResul = '-1'        
   SET @DesResul = 'Debe enviar el Nro Documento'        
   RETURN;        
  END        
      
  IF (LEN(@TipoCodigo) = 0)        
  BEGIN        
   SET @IdResul = '-1'        
   SET @DesResul = 'Debe enviar el Tipo de Codigo'        
   RETURN;        
  END       
      
 if (@TipoCodigo = 0 or @TipoCodigo > 7)      
begin      
 set @IdResul = '-1'      
 set @DesResul = 'El Tipo de Codigo debe ser 1-Operador Logistico, 2-Agente de Carga, 3-Agente de Aduana, 4-Agente Maritimo, 5-Empresa de Transporte, 6-Cliente Final, 7-Linea Naviera'      
end      
      
  if (@TipoCodigo = 2 and LEN(@Codigo) = 0)      
 begin      
  SET @IdResul = '-1'        
    SET @DesResul = 'Debe enviar el Codigo'        
    RETURN;        
 end      
 if (@TipoCodigo = 3 and LEN(@Codigo) = 0)      
 begin      
  SET @IdResul = '-1'        
    SET @DesResul = 'Debe enviar el Codigo'        
    RETURN;        
 end      
 if (@TipoCodigo = 4 and LEN(@Codigo) = 0)      
 begin      
  SET @IdResul = '-1'        
    SET @DesResul = 'Debe enviar el Codigo'        
    RETURN;        
 end      
      
       
  if (@Tipo < 1 OR @Tipo > 2 )        
 begin        
  set @IdResul = '-1'        
  set @DesResul = 'El Tipo Envio debe ser  1-Insert o 2-Update'        
  return;        
 end        
      
/*      
TipoCodigo      
1: Operador Logistico      
2: Agente de Carga      
3: Agente de Aduana      
4: Agente Maritimo      
5: Empresa de Transporte      
6: Cliente Final      
7: Linea Naviera      
      
CustomerTypeCode      
Cliente Final 5      
Forwarders 4      
Linea Naviera 3      
Otros 6      
       
Nep_Persona       
1:Nacional Dni,Pasaporte,Carnet      
0:Juridica Ruc, No Domiciliado      
       
Nep_Origen      
0:Extranjero Pasaporte, No Domiciliado      
1:Nacional Dni,Ruc,Carnet Extranjeria      
       
Nep1to1_codigodeclarantesunat      
1: Dni      
2: Ruc      
3: Pasaporte      
4: Carnet de Extranjeria      
5: Otro      
       
Nep1to1_tipodocumento      
1: Dni      
2: Ruc      
3: Carnet de Extranjería      
4: Pasaporte      
5: No Domiciliado      
6: Otro      
       
codigodeclarantesunat-tipodocumento      
Dni 1-1      
Ruc 2-2      
Pasaporte 3-4      
Carnet de Extranjeria 4-3      
No Domiciliado - Otro 5-5      
        
*/      
      
declare @CustomerTypeCode INT      
set @CustomerTypeCode = 5;      
      
if (@TipoCodigo = 2)      
begin      
 set @CustomerTypeCode = 4;      
end      
if (@TipoCodigo = 7)      
begin      
 set @CustomerTypeCode = 3;      
end      
      
      
declare @Nep1to1_codigodeclarantesunat INT      
      
if (@Nep1to1_tipodocumento = 1 or @Nep1to1_tipodocumento = 2)      
begin      
 set @Nep1to1_codigodeclarantesunat = @Nep1to1_tipodocumento      
end      
if (@Nep1to1_tipodocumento = 3)  begin      
 set @Nep1to1_codigodeclarantesunat = 4      
end      
if (@Nep1to1_tipodocumento = 4)      
begin      
 set @Nep1to1_codigodeclarantesunat = 3      
end      
if (@Nep1to1_tipodocumento > 4)      
begin      
 set @Nep1to1_codigodeclarantesunat = 5      
end      
      
declare @Nep1to1_codigoagenciaaduana NVARCHAR(200)      
declare @Nep1to1_codigoagenciacarga NVARCHAR(200)      
declare @Nep1to1_codigoagenciamartima NVARCHAR(200)      
declare @Flg_EmpresaTransporte int    
      
set @Nep1to1_codigoagenciaaduana = '';      
set @Nep1to1_codigoagenciacarga = '';      
set @Nep1to1_codigoagenciamartima = '';      
set @Flg_EmpresaTransporte = 0;    
    
if (@TipoCodigo = 2)      
begin      
 set @Nep1to1_codigoagenciacarga = @Codigo;      
end      
if (@TipoCodigo = 3)      
begin      
 set @Nep1to1_codigoagenciaaduana = @Codigo;      
end      
if (@TipoCodigo = 4)      
begin      
 set @Nep1to1_codigoagenciamartima = @Codigo;      
end      
if (@TipoCodigo = 5)    
begin    
 set @Flg_EmpresaTransporte = 1;    
end    
    
       
declare @Nep_Persona BIT      
declare @Nep_Origen BIT      
      
set @Nep_Persona = 0;      
set @Nep_Origen = 1;      
      
if (@TipoCodigo = 6)      
begin      
       
 if (@Nep1to1_tipodocumento = 1 or @Nep1to1_tipodocumento = 3 or @Nep1to1_tipodocumento = 4)      
 begin      
  set @Nep_Persona = 1;      
 end      
 if (@Nep1to1_tipodocumento = 2 or @Nep1to1_tipodocumento = 5 or @Nep1to1_tipodocumento = 6)      
 begin      
  set @Nep_Persona = 0;      
 end      
 if (@Nep1to1_tipodocumento = 4 or @Nep1to1_tipodocumento = 5)      
 begin      
  set @Nep_Origen = 0;      
 end      
 if (@Nep1to1_tipodocumento = 1 or @Nep1to1_tipodocumento = 2 or @Nep1to1_tipodocumento = 3)       
 begin      
  set @Nep_Origen = 1;      
 end      
      
end      
       
if (Len(@Name) = 0)  
 begin  
  set @Name = @Nep1to1_nombres + ' ' + @Nep1to1_apellidopaterno + ' ' + @Nep1to1_apellidomaterno  
 end   
  
      
      
DECLARE @UNIQUEX UNIQUEIDENTIFIER      
      
SET @UNIQUEX = NEWID();      
      
DECLARE @DefaultPriceLevelId UNIQUEIDENTIFIER      
DECLARE @TransactionCurrencyId UNIQUEIDENTIFIER      
       
DECLARE @ADMIN UNIQUEIDENTIFIER      
SET @ADMIN='F2773EA6-014B-DE11-B20B-0050568B2462'      
      
--IF (@Moneda = 10)      
--BEGIN      
-- SET @DefaultPriceLevelId = 'F02C4E3B-5054-DE11-8A4C-0050568B2462'      
-- SET @TransactionCurrencyId = 'F0331005-E551-DE11-8A4C-0050568B2462'      
--END      
--ELSE      
--BEGIN      
SET @DefaultPriceLevelId = 'EE5D4448-A54B-DE11-9E86-0050568B2462'      
SET @TransactionCurrencyId = '513801D4-014B-DE11-B20B-0050568B2462'      
--END      
      
      
/*********************************/        
Declare @Existe int      
declare @ExisteBDI int      
set @Existe = 0      
set @ExisteBDI = 0      
declare @AccountId uniqueidentifier      
      
      
 /*Acciones Registrar(1), Actualizar (2) o cancelar (3)*/        
IF (@Tipo = 1)        
BEGIN        
      
 IF EXISTS(SELECT AccountNumber FROM AccountBase (NOLOCK) WHERE AccountNumber = @AccountNumber)        
 BEGIN        
  SET @IdResul = '0'        
  SET @DesResul = 'OK - Codigo ya existe'        
  Set @Existe = 1      
  --RETURN;        
 END        
 IF EXISTS(SELECT Nep_CodigoERP FROM AccountExtensionBase (NOLOCK) WHERE Nep_CodigoERP = @AccountNumber)        
 BEGIN        
  SET @IdResul = '0'        
 SET @DesResul = 'OK - Codigo ya existe'        
  Set @Existe = 1      
  --RETURN;        
 END        
 IF EXISTS(SELECT cli_nrodocumento FROM NEP_MSCRM_BDI.dbo.cliente WHERE cli_nrodocumento = @AccountNumber)        
 BEGIN        
  SET @IdResul = '0'        
  SET @DesResul = 'OK - Codigo ya existe'        
  Set @ExisteBDI = 1      
  --RETURN;        
 END        
      
 /****************CRM****************/      
      
 if (@Existe = 1)      
 begin      
  Update AccountBase       
  set       
  DefaultPriceLevelId = @DefaultPriceLevelId,      
  CustomerTypeCode = @CustomerTypeCode,      
  NAME = @Name,      
  AccountNumber = @AccountNumber,      
  EMailAddress1 = @EMailAddress1      
  where  AccountNumber = @AccountNumber      
      
  set @AccountId = (select Accountid from AccountBase where AccountNumber = @AccountNumber)      
      
  select @Flg_EmpresaTransporte = cli_permitirfax from NEP_MSCRM_BDI.dbo.cliente where  cli_nrodocumento = @AccountNumber    
      
  select @Nep1to1_codigoagenciaaduana = Nep1to1_codigoagenciaaduana,       
    @Nep1to1_codigoagenciacarga = Nep1to1_codigoagenciacarga,      
    @Nep1to1_codigoagenciamartima = Nep1to1_codigoagenciamartima      
  from AccountExtensionBase where accountId= @AccountId       
      
  if (@TipoCodigo = 2)      
  begin      
   set @Nep1to1_codigoagenciacarga = @Codigo;      
  end      
  if (@TipoCodigo = 3)      
  begin      
   set @Nep1to1_codigoagenciaaduana = @Codigo;      
  end      
  if (@TipoCodigo = 4)      
  begin      
   set @Nep1to1_codigoagenciamartima = @Codigo;      
  end      
  if (@TipoCodigo = 5)    
 begin    
 set @Flg_EmpresaTransporte = 1;    
 end    
     
  Update AccountExtensionBase      
  set       
  Nep_CodigoERP = @AccountNumber,      
  Nep_Persona = @Nep_Persona,      
  Nep_Origen = @Nep_Origen,    Nep1to1_apellidomaterno = @Nep1to1_apellidomaterno,      
  Nep1to1_apellidopaterno = @Nep1to1_apellidopaterno,      
  Nep1to1_codigoagenciaaduana = @Nep1to1_codigoagenciaaduana,      
  Nep1to1_codigoagenciacarga = @Nep1to1_codigoagenciacarga,      
  Nep1to1_codigoagenciamartima = @Nep1to1_codigoagenciamartima,      
  Nep1to1_codigodeclarantesunat = @Nep1to1_codigodeclarantesunat,      
  Nep1to1_nombres = @Nep1to1_nombres,      
  Nep1to1_nrodocumentosunat = @AccountNumber,      
  Nep1to1_tipodocumento = @Nep1to1_tipodocumento      
  where  AccountId = @AccountId      
        
  update CustomerAddressBase       
  set       
  NAME = @Name_address      
  where parentid = @AccountId      
 end       
      
 /****************BDI****************/      
 if (@ExisteBDI = 1)      
 begin      
        
  update NEP_MSCRM_BDI.dbo.cliente       
  set      
  cli_tipodocumento = @Nep1to1_tipodocumento,       
  cli_nrodocumento = @AccountNumber,       
  cli_razonsocial = @Name,       
  cli_nombres = @Nep1to1_nombres,       
  cli_apellidopaterno = @Nep1to1_apellidopaterno,       
  cli_apellidomaterno = @Nep1to1_apellidomaterno,      
  cli_persona = @Nep_Persona,      
  cli_correoelectronico = @EMailAddress1,      
  cli_codigodeclarantesunat = @Nep1to1_codigodeclarantesunat,      
  cli_nrodocumentosunat = @AccountNumber,      
  cli_origen = @Nep_Origen,      
  cli_codigoerp = @AccountNumber,      
  cli_direccionfiscal = @Name_address,      
  cli_direccionentrega = @Name_address,      
  cli_codigoagenciacarga = @Nep1to1_codigoagenciacarga,      
  cli_codigoagenciaaduana = @Nep1to1_codigoagenciaaduana,      
  cli_codigoagenciamaritima = @Nep1to1_codigoagenciamartima,      
  cli_tipodecliente = @CustomerTypeCode,      
  cli_sistemamantenimiento = 0,      
  cli_sistemaerp = 0,      
  cli_sistemafacturacion = 0,    
  cli_permitirfax = @Flg_EmpresaTransporte      
  where cli_nrodocumento = @AccountNumber      
      
 end      
       
 /****************CRM****************/      
        
 if (@Existe = 0)      
 begin      
      
  INSERT INTO AccountBase (      
  AccountId,AccountCategoryCode,TerritoryId,DefaultPriceLevelId,CustomerSizeCode      
  ,PreferredContactMethodCode,CustomerTypeCode,AccountRatingCode,IndustryCode,TerritoryCode      
  ,AccountClassificationCode,DeletionStateCode,BusinessTypeCode,OwningBusinessUnit,OwningTeam      
  ,OwningUser,OriginatingLeadId,PaymentTermsCode,ShippingMethodCode,PrimaryContactId,ParticipatesInWorkflow      
  ,NAME,AccountNumber,Revenue,NumberOfEmployees,Description,SIC,OwnershipCode,MarketCap,SharesOutstanding      
  ,TickerSymbol,StockExchange,WebSiteURL,FtpSiteURL,EMailAddress1,EMailAddress2,EMailAddress3,DoNotPhone      
  ,DoNotFax,Telephone1,DoNotEMail,Telephone2,Fax,Telephone3,DoNotPostalMail,DoNotBulkEMail,DoNotBulkPostalMail      
  ,CreditLimit,CreditOnHold,IsPrivate,CreatedOn,CreatedBy,ModifiedOn,ModifiedBy,ParentAccountId,Aging30,StateCode      
  ,Aging60,StatusCode ,Aging90,PreferredAppointmentDayCode,PreferredSystemUserId,PreferredAppointmentTimeCode,Merged      
  ,DoNotSendMM,MasterId,LastUsedInCampaign,PreferredServiceId,PreferredEquipmentId,ExchangeRate,UTCConversionTimeZoneCode      
  ,OverriddenCreatedOn,TimeZoneRuleVersionNumber,ImportSequenceNumber,TransactionCurrencyId,CreditLimit_Base,Aging30_Base      
  ,Revenue_Base,Aging90_Base,MarketCap_Base,Aging60_Base,YomiName      
  )      
  VALUES (      
  @UNIQUEX,1,NULL,@DefaultPriceLevelId,1      
  ,1,@CustomerTypeCode,1,NULL,1      
  ,1,0,1,'D7663EA6-014B-DE11-B20B-0050568B2462',NULL      
  ,@ADMIN,NULL,4,1,NULL,0      
  ,@Name,@AccountNumber,NULL,NULL,NULL,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,@EMailAddress1,NULL,NULL,0      
  ,0,NULL,0,NULL,NULL,NULL,0,0,0      
  ,NULL,0,0,GETDATE(),@ADMIN,GETDATE(),@ADMIN,NULL,NULL,0      
  ,NULL,1,NULL,NULL,NULL,NULL,0      
  ,0,NULL,NULL,NULL,NULL,1,NULL      
  ,NULL,NULL,NULL,@TransactionCurrencyId,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL      
  )      
       
  INSERT INTO AccountExtensionBase (      
  AccountId,Nep_Cant,Nep_CantbookingExpo,Nep_CantcntrsFCLtrabajados,Nep_CantidadcntrsLCLtrabajados,Nep_Clientesegunacuerdo      
  ,Nep_CodigoERP,Nep_FacturacinencntrsLCL,nep_facturacinencntrslcl_Base,Nep_Facturacionanterior,Nep_FacturacionencntrsFCL,nep_facturacionencntrsfcl_Base      
  ,Nep_GrupoEconomico,Nep_MontoEstimadoFacturacion,Nep_Nombre,Nep_Productos,Nep_RankingdeFacturacindeLogistica,Nep_RankingdeFacturacinPortuario,Nep_RequiereTrackTrace      
  ,Nep_Rubro,Nep_Segmento,Nep_tempCodEjecServicio,Nep_tempCodEjeCuenta,nep_codigociiiuid,nep_niveltarifarioactualid,nep_niveltarifariopropuestoid      
  ,nep_ubigeocuentaid,nep_ejecutivoventalogisticoid,nep_ejecutivoserviciologisticoid,nep_ejecutivoventaportuarioid,nep_ejecutivoservicioportuarioid      
  ,Nep_Persona,Nep_Lineadecredito ,nep_lineadecredito_Base,Nep_Plazo,Nep_BloqueoporDeuda,Nep_DeudaTotal,nep_deudatotal_Base,Nep_DeudaVencida,nep_deudavencida_Base      
  ,Nep_CategoraLog,Nep_Clientesegunacuerdolog,Nep_Origen,Nep_OrigenProspecto,Nep_Aniversario,Nep_aniversarioanterior,Nep1to1_actualizacioncredito ,Nep1to1_altacliente      
  ,Nep1to1_apellidomaterno,Nep1to1_apellidopaterno,Nep1to1_codigoagenciaaduana,Nep1to1_codigoagenciacarga,Nep1to1_codigoagenciamartima,Nep1to1_codigodeclarantesunat      
  ,Nep1to1_DeudaTotalDolares,Nep1to1_DeudaTotalSoles,Nep1to1_DeudaVencidaDolares,Nep1to1_DeudaVencidaSoles,Nep1to1_estadocontribuyente,Nep1to1_fechaapliccredito      
  ,Nep1to1_fechaaprobcredito,Nep1to1_fechacaducredito,Nep1to1_fechainscripcion,Nep1to1_guidreqaltacliente,Nep1to1_historialcrediticio,Nep1to1_lineadecredito      
  ,Nep1to1_modificardatos,Nep1to1_modificardatoscrediticios,Nep1to1_modificarestadocontribuyente,Nep1to1_nivelsatisfaccion,Nep1to1_nombres,Nep1to1_nrodocumentosunat      
  ,Nep1to1_razoncomercial,Nep1to1_registrocompletadocomercial,Nep1to1_registrocompletadocrediticio,Nep1to1_registrocompletadogeneral,Nep1to1_registrocompletadooperativo      
  ,Nep1to1_registrocompletadosac,Nep1to1_serviciosconcredito,Nep1to1_subsector,Nep1to1_tipodocumento,Nep1to1_tipopersoneria,nep1to1_nacionalidadid,nep1to1_paisfiscalid      
  ,nep1to1_paisentregaid,nep1to1_departamentofiscalid,nep1to1_departamentoentregaid,nep1to1_provinciafiscalid,nep1to1_provinciaentregaid,nep1to1_distritofiscalid      
  ,nep1to1_distritoentregaid,nep1to1_divisafacturacionid,nep1to1_ejecutivosacid,nep1to1_ejecutivoserviciopid      
  )      
  VALUES (      
  @UNIQUEX,NULL,NULL,NULL,NULL,0      
  ,/*@Nep_CodigoERP*/@AccountNumber,NULL,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL,0      
  ,NULL,4,NULL,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL      
  ,@Nep_Persona,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL      
  ,2,0,@Nep_Origen,NULL,NULL,NULL,NULL,0      
  ,@Nep1to1_apellidomaterno,@Nep1to1_apellidopaterno,@Nep1to1_codigoagenciaaduana,@Nep1to1_codigoagenciacarga,@Nep1to1_codigoagenciamartima,@Nep1to1_codigodeclarantesunat      
  ,NULL,NULL,NULL,NULL,1,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL      
  ,0,0,0,NULL,@Nep1to1_nombres,@AccountNumber/*@Nep1to1_nrodocumentosunat*/      
  ,NULL,1,1,1,0      
  ,1,NULL,NULL,@Nep1to1_tipodocumento,2,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL      
  )      
        
  DECLARE @CustomerAddressId_1 UNIQUEIDENTIFIER      
  SET @CustomerAddressId_1 = NEWID();      
      
  --Direcccion 1      
  INSERT INTO CustomerAddressBase (      
  ParentId,CustomerAddressId,AddressNumber,ObjectTypeCode,AddressTypeCode,NAME,PrimaryContactName,Line1,Line2,Line3      
  ,City,StateOrProvince,County,Country,PostOfficeBox,PostalCode,UTCOffset,FreightTermsCode,UPSZone,Latitude      
  ,Telephone1,Longitude,ShippingMethodCode,Telephone2,Telephone3,Fax,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,DeletionStateCode      
  ,TimeZoneRuleVersionNumber,OverriddenCreatedOn,UTCConversionTimeZoneCode,ImportSequenceNumber      
  )      
  VALUES (      
  @UNIQUEX,@CustomerAddressId_1,1,1,NULL,@Name_address,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL,@ADMIN,GETDATE(),@ADMIN,GETDATE(),0      
  ,NULL,NULL,NULL,NULL      
  )      
       
  DECLARE @CustomerAddressId_2 UNIQUEIDENTIFIER      
  SET @CustomerAddressId_2 = NEWID();      
  --Direcccion 2      
  INSERT INTO CustomerAddressBase (      
  ParentId,CustomerAddressId,AddressNumber,ObjectTypeCode,AddressTypeCode,NAME,PrimaryContactName,Line1,Line2,Line3      
  ,City,StateOrProvince,County,Country,PostOfficeBox,PostalCode,UTCOffset,FreightTermsCode,UPSZone,Latitude      
  ,Telephone1,Longitude,ShippingMethodCode,Telephone2,Telephone3,Fax,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,DeletionStateCode      
  ,TimeZoneRuleVersionNumber,OverriddenCreatedOn,UTCConversionTimeZoneCode,ImportSequenceNumber      
  )      
  VALUES (      
  @UNIQUEX,@CustomerAddressId_2,2,1,1,@Name_address,NULL,NULL,NULL,NULL      
  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL      
  ,NULL,NULL,1,NULL,NULL,NULL,@ADMIN,GETDATE(),@ADMIN,GETDATE(),0      
  ,NULL,NULL,NULL,NULL      
  )      
      
 end      
      
 /****************BDI****************/      
      
 if (@ExisteBDI = 0)      
 begin      
        
  insert into NEP_MSCRM_BDI.dbo.cliente (      
  cli_tipodocumento, cli_nrodocumento, cli_razonsocial, cli_nombres, cli_apellidopaterno, cli_apellidomaterno,      
  cli_codigonacionalidad,cli_contactotipodocumento,cli_contactonrodocumento,cli_telfprincipal,cli_telfoficina,cli_telfotro,cli_persona,      
  cli_correoelectronico,cli_sitioweb,cli_fax,cli_estadocontribuyente,cli_codigodeclarantesunat,cli_nrodocumentosunat,cli_fechainscripcionsunat,      
  cli_codigociiu,cli_origen,cli_tipopersoneria,cli_codigoerp,cli_direccionfiscal,cli_refdireccionfiscal,cli_codigopaisdirfiscal,cli_codigodepadirfiscal,      
  cli_codigoprovdirfiscal,cli_codigodistdirfiscal,cli_tipodirentrega,cli_direccionentrega,cli_refdireccionentrega,cli_codigopaisdirentrega,      
  cli_codigodepadirentrega,cli_codigoprovdirentrega,cli_codigodistdirentrega,cli_codigoagenciacarga,cli_codigoagenciaaduana,cli_codigoagenciamaritima,      
  cli_divisafacturacion,cli_condicionpago,cli_fechaaprobcredito,cli_fechaapliccredito,cli_fechacaducredito,cli_lineadecredito,cli_plazo,      
  cli_deudatotalsoles,cli_deudavencidasoles,cli_bloqueopordeuda,cli_serviciosconcredito,cli_historialcrediticio,cli_tipodecliente,cli_segmento,      
  cli_sectoreconomico,cli_grupoeconomico,cli_rubro,cli_productos,cli_propiedad,cli_divisa,cli_facturacionanterior,cli_ejecutivodeventas,cli_categoriaportuario,      
  cli_rankingfactportuario,cli_clientesegunacuerdo,cli_ejecutivoservicioportuario,cli_niveltarifarioactual,cli_rankingfactlogistica,cli_categorialogistica,      
  cli_origenprospectologistica,cli_ejecutivoserviciologistica,cli_ejecutivoventalogistica,cli_ejecutivoservicioconsolidadorcarga,cli_facturacionencntrsfcl,      
  cli_cantcntrsfcltrabajados,cli_cantbookingexpo,cli_facturacinencntrslcl,cli_cantidadcntrslcltrabajados,cli_canthouseblimpo,cli_descripcionconsolidadorcarga,      
  cli_ejecutivosac,cli_aniversario,cli_nivelsatisfaccion,cli_requieretracktrace,cli_formadecontactopreferida,cli_permitiremail,cli_permitircorreomasivo,cli_permitirtelefono,      
  cli_permitirfax,cli_permitircorreo,cli_horariopreferidocontacto,cli_diapreferidocontacto,cli_propietariocliente,cli_estadocrm,cli_situacionregistro,cli_sistemamantenimiento,      
  cli_sistemaerp,cli_sistemafacturacion,cli_estadocargainicial,cli_niveltarifariopropuesto,cli_deudatotaldolares,cli_deudavencidadolares,cli_ContactoFacturacionE,cli_FechaCreacion,cli_FechaActualizacion      
  )      
  values (      
  @Nep1to1_tipodocumento, @AccountNumber, @Name,@Nep1to1_nombres,@Nep1to1_apellidopaterno,@Nep1to1_apellidomaterno,      
  NULL, NULL, NULL, NULL, NULL, NULL, @Nep_Persona,      
  @EMailAddress1, NULL, NULL, 1,@Nep1to1_codigodeclarantesunat,@AccountNumber,NULL,      
  NULL, @Nep_Origen, NULL, @AccountNumber, @Name_address, NULL, NULL, NULL,      
  NULL, NULL, NULL, @Name_address, NULL, NULL,      
  NULL, NULL,NULL, @Nep1to1_codigoagenciacarga, @Nep1to1_codigoagenciaaduana, @Nep1to1_codigoagenciamartima,       
  NULL, NULL,NULL,NULL,NULL,NULL,NULL,      
  NULL, NULL, 0, NULL, NULL, @CustomerTypeCode, 4,      
  NULL, NULL, NULL, NULL, NULL, 'USD', NULL,NULL, NULL,      
  NULL, 0, NULL, NULL, NULL, NULL,       
  NULL, NULL, NULL, NULL,NULL,      
  NULL,NULL,NULL, NULL,NULL,NULL,      
  NULL, NULL, NULL, 0, 1, 0,0,0,      
  @Flg_EmpresaTransporte, 0, NULL, NULL, 'DOMNEP\admincrm', 0, 2, 0,      
  0, 0, NULL, NULL, NULL, NULL, NULL, GETDATE(), GETDATE()      
  )      
      
 end       
end      
      
      
IF (@Tipo = 2)        
BEGIN        
      
 /****************CRM****************/      
       
 Update AccountBase       
 set       
 DefaultPriceLevelId = @DefaultPriceLevelId,      
 CustomerTypeCode = @CustomerTypeCode,      
 NAME = @Name,      
 AccountNumber = @AccountNumber,      
 EMailAddress1 = @EMailAddress1      
 where  AccountNumber = @AccountNumber      
      
 set @AccountId = (select Accountid from AccountBase where AccountNumber = @AccountNumber)      
       
 select @Nep1to1_codigoagenciaaduana = Nep1to1_codigoagenciaaduana,       
   @Nep1to1_codigoagenciacarga = Nep1to1_codigoagenciacarga,      
   @Nep1to1_codigoagenciamartima = Nep1to1_codigoagenciamartima      
 from AccountExtensionBase where accountId= @AccountId       
      
  select @Flg_EmpresaTransporte = cli_permitirfax from NEP_MSCRM_BDI.dbo.cliente where  cli_nrodocumento = @AccountNumber    
    
 if (@TipoCodigo = 2)      
 begin      
  set @Nep1to1_codigoagenciacarga = @Codigo;      
 end      
 if (@TipoCodigo = 3)      
 begin      
  set @Nep1to1_codigoagenciaaduana = @Codigo;      
 end      
 if (@TipoCodigo = 4)      
 begin      
  set @Nep1to1_codigoagenciamartima = @Codigo;      
 end      
 if (@TipoCodigo = 5)    
 begin    
  set @Flg_EmpresaTransporte = 1;    
 end    
      
 Update AccountExtensionBase      
 set       
 Nep_CodigoERP = @AccountNumber,      
 Nep_Persona = @Nep_Persona,      
 Nep_Origen = @Nep_Origen,      
 Nep1to1_apellidomaterno = @Nep1to1_apellidomaterno,      
 Nep1to1_apellidopaterno = @Nep1to1_apellidopaterno,      
 Nep1to1_codigoagenciaaduana = @Nep1to1_codigoagenciaaduana,      
 Nep1to1_codigoagenciacarga = @Nep1to1_codigoagenciacarga,      
 Nep1to1_codigoagenciamartima = @Nep1to1_codigoagenciamartima,      
 Nep1to1_codigodeclarantesunat = @Nep1to1_codigodeclarantesunat,      
 Nep1to1_nombres = @Nep1to1_nombres,      
 Nep1to1_nrodocumentosunat = @AccountNumber,      
 Nep1to1_tipodocumento = @Nep1to1_tipodocumento      
 where  AccountId = @AccountId      
        
 update CustomerAddressBase       
 set       
 NAME = @Name_address      
 where parentid = @AccountId      
       
      
 /****************BDI****************/      
      
 update NEP_MSCRM_BDI.dbo.cliente       
 set      
 cli_tipodocumento = @Nep1to1_tipodocumento,       
 cli_nrodocumento = @AccountNumber,       
 cli_razonsocial = @Name,       
 cli_nombres = @Nep1to1_nombres,       
 cli_apellidopaterno = @Nep1to1_apellidopaterno,       
 cli_apellidomaterno = @Nep1to1_apellidomaterno,      
 cli_persona = @Nep_Persona,      
 cli_correoelectronico = @EMailAddress1,      
 cli_codigodeclarantesunat = @Nep1to1_codigodeclarantesunat,      
 cli_nrodocumentosunat = @AccountNumber,      
 cli_origen = @Nep_Origen,      
 cli_codigoerp = @AccountNumber,      
 cli_direccionfiscal = @Name_address,      
 cli_direccionentrega = @Name_address,      
 cli_codigoagenciacarga = @Nep1to1_codigoagenciacarga,      
 cli_codigoagenciaaduana = @Nep1to1_codigoagenciaaduana,      
 cli_codigoagenciamaritima = @Nep1to1_codigoagenciamartima,      
 cli_tipodecliente = @CustomerTypeCode,      
 cli_sistemamantenimiento = 0,      
 cli_sistemaerp = 0,      
 cli_sistemafacturacion = 0,    
 cli_permitirfax = @Flg_EmpresaTransporte      
 where cli_nrodocumento = @AccountNumber      
        
        
end      
      
      
END 
GO
