USE [EXTENSION_CRM]
GO
/****** Object:  View [dbo].[CABFACTURA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[CABFACTURA]      
AS
SELECT      
 CAS.TicketNumber FACNROCASO,      
 CAS.CREATEDON FECHACREACIONCASO,      
 USU.DomainName CASOCREADOPOR,      
 FACCAB.Nep_TipoDocumento FACTIPODOC,      
 FACCAB.Nep_NroFactura FACNUMERO,      
 FACCAB.Nep_Ruc FACNRORUC,      
 'FACMONEDA' = CASE FACCAB.Nep_TipoMoneda WHEN 1 THEN 'SOL' ELSE 'DOL' END,      
 FACCAB.Nep_SeRefactura FACSEREFACTURA,      
 FACCAB.Nep_TipoImpuesto1 FACTIPOIMPUESTO1,      
 FACCAB.Nep_Impuesto1 FACIMPUESTO1,      
 FACCAB.Nep_TipoImpuesto2 FACTIPOIMPUESTO2,      
 FACCAB.Nep_Impuesto2 FACIMPUESTO2,      
 FACCAB.Nep_TipoImpuesto3 FACTIPOIMPUESTO3,      
 FACCAB.Nep_Impuesto3 FACIMPUESTO3,      
 FACCAB.Nep_MontoNotaDeCredito FACMONTONOTACREDITOCONIGV,      
 FACCAB.Nep_MontoNotaDeCreditoSinIGV FACMONTONOTACREDITOSINIGV,      
 FACCAB.Nep_Estado FACESTADO,      
 CAS.STATECODE ESTADOCASO,
 CAS.StatusCode,
 FACCAB.nep_observaciones as FACOBSERVACIONES     
FROM NEPTUNIA_MSCRM.dbo.nep_facturaasociadaalcaso FACCAB      
INNER JOIN NEPTUNIA_MSCRM.dbo.INCIDENT CAS ON CAS.INCIDENTID=FACCAB.NEP_CASOID      
INNER JOIN NEPTUNIA_MSCRM.dbo.SYSTEMUSER USU ON CAS.OWNERID=USU.SYSTEMUSERID      
WHERE FACCAB.DeletionStateCode=0     
      AND CAS.DeletionStateCode=0     
      --AND CAS.StateCode = 0 --Activo    
      AND (CAS.StatusCode = '200006' OR CAS.StatusCode = '200008' or CAS.StatusCode='200010') --Aprobado Contablemente, Aprobado por gerencia, Nota de credito emitida
GO
/****** Object:  View [dbo].[CLIENTES]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[CLIENTES]  
AS  
SELECT     CLIE.AccountNumber AS RUC, CLIE.Name AS RAZONSOCIAL, CLIE.Address1_Name AS DIRECCION, CLIE.StateCode AS ESTADO, DIVI.ID_DIVISA  
FROM         Neptunia_MSCRM.dbo.Account AS CLIE INNER JOIN  
                      dbo.DIVISA AS DIVI ON DIVI.IDCRM_DIVISA = CLIE.TransactionCurrencyId  
WHERE     (CLIE.DeletionStateCode = 0)  
GO
/****** Object:  View [dbo].[CLIENTES_FAC]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[CLIENTES_FAC]
AS
SELECT 
A.ACCOUNTNUMBER		RUC,
A.NAME				RAZONSOCIAL, 
A.Address1_Name		DIRECCION,
U.NEP_CODUBIGEO		UBIGEO,
ID_DIVISA			MONEDA,
A.CREATEDON			FECHACREACION,
A.MODIFIEDON		FECHAMODIFICACION
FROM NEPTUNIA_MSCRM.dbo.Account A
LEFT JOIN NEPTUNIA_MSCRM.dbo.NEP_UBIGEO U ON A.NEP_UBIGEOCUENTAID = U.NEP_UBIGEOID
INNER JOIN EXTENSION_CRM.dbo.DIVISA D ON A.TRANSACTIONCURRENCYID = IDCRM_DIVISA
WHERE A.DELETIONSTATECODE = 0 AND A.STATECODE = 0
GO
/****** Object:  View [dbo].[CLIENTES_OPORTUNIDADES_TERMINAL]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[CLIENTES_OPORTUNIDADES_TERMINAL]
AS
SELECT     CLIE.AccountNumber AS RUC, 
			OPO.EstimatedCloseDate AS FECHAESTIMADADECIERRE, 
			OPO.CreatedOn AS FECHACREACION, 
            OPO.Nep_Diasporvencerorigen AS DIASPORVENCERORIGEN, OPO.Name AS NOMBREOPORTUNIDAD, 
            OPO.nep_unidadnegociooportunidadidName AS UNIDADNEGOCIO
FROM        Neptunia_MSCRM.dbo.Account AS CLIE 
INNER JOIN  Neptunia_MSCRM.dbo.Opportunity AS OPO ON OPO.CustomerId = CLIE.AccountId
WHERE     (CLIE.DeletionStateCode = 0) AND (OPO.DeletionStateCode = 0) AND (OPO.Nep_Escreadoporbatch = 1)
GO
/****** Object:  View [dbo].[CLIENTES_PAITA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[CLIENTES_PAITA]
AS
SELECT     RUC, RAZONSOCIAL, DIRECCION, ESTADO, ID_DIVISA
FROM         dbo.CLIENTE_PAITA
GO
/****** Object:  View [dbo].[CLIENTES_TT]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[CLIENTES_TT]

AS

SELECT 
ACCOUNTNUMBER	RUC,
NAME			RAZONSOCIAL, 
STATECODE		ESTADO 
FROM NEPTUNIA_MSCRM.dbo.Account
WHERE DELETIONSTATECODE =0 AND STATECODE = 0 and nep_requieretracktrace = 1 and customertypecode = 5
GO
/****** Object:  View [dbo].[CLIENTES_TT_FW]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[CLIENTES_TT_FW]

AS

SELECT 
ACCOUNTNUMBER	RUC,
NAME			RAZONSOCIAL, 
STATECODE		ESTADO 
FROM NEPTUNIA_MSCRM.dbo.Account
WHERE DELETIONSTATECODE =0 AND STATECODE = 0 and nep_requieretracktrace = 1 and customertypecode = 4
GO
/****** Object:  View [dbo].[CONCEPTOS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[CONCEPTOS]
AS
SELECT    DISTINCT CON.Nep_IdConcepto AS ID_CONCEPTO, CON.Nep_name AS NAMECONCEPTO, CON.Nep_Iniciales AS INICIALCONCEPTO, 
           CON.nep_unidadnegocioconceptoidName AS UNIDADNEGOCIONAME, CON.nep_unidadnegocioconceptoid AS UNIDADNEGOCIOID, 
           UNE.Nep_CodigoOFISIS AS UNIDADNEGOCIOCODIGOOFISIS
FROM         Neptunia_MSCRM.dbo.Nep_conceptoun AS CON LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.Nep_unidadnegocioExtensionBase AS UNE ON UNE.Nep_unidadnegocioId = CON.nep_unidadnegocioconceptoid


GO
/****** Object:  View [dbo].[COTIZACION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[COTIZACION]
AS
SELECT     COTI.QuoteId, COTI.Nep_Correlativo AS NROCOTIZACION, CLIE.AccountNumber AS RUC, CLIE.Name AS CLIENTE, SMAPC.Value AS TIPOCLIENTE, 
                      CLIE.CustomerTypeCode AS COD_TIPOCLIENTE, COTI.nep_niveltarifarioofertaidName AS NIVELTARIFARIO, 
                      COTI.nep_niveltarifarioofertaid AS COD_NIVELTARIFARIO, UNNE.Nep_name AS UNIDADNEGOCIO, 
                      UNNE.nep_unidaddenegociounidadnegocioid AS COD_UNIDADNEGOCIO, UNNE.Nep_Iniciales AS INCIAL_UNINEG, UNNE.Nep_IdUN AS IDUN, 
                      CONC.Nep_name AS CONCEPTO, CONC.Nep_conceptounId AS COD_CONCEPTO, CONC.Nep_Iniciales AS INICIAL_CONCEPTO, 
                      CONC.Nep_IdConcepto AS IDCONCEPTO, DIVI.ID_DIVISA AS DIVISA, COTI.EffectiveFrom AS FECHAINICIOVIG, COTI.EffectiveTo AS FECHAFINVIG, 
                      COTI.Nep_Estado AS IDESTADO, SMAP.Value AS ESTADO, LOCAL.Nep_CodigoOrigen AS LOCAL, TIPFAC.Nep_CodigoenOFISIS AS TIPOFACTURACION, 
					  SMAPCC.Value as TRATAMIENTOCONTACTO,
                      CLIE.PrimaryContactIdName AS CONTACTOPRINCIPAL, 
					  COTI.OwnerIdName AS PROPIETARIOCOTIZACION, 
					  USU.Title AS CARGOPROPIETARIO, 
                      COTI.CreatedOn, 
					  USU.InternalEMailAddress AS EMAILUSU, 
					  USU.HomePhone AS TELEFONOPARTICULARUSU, 
                      USU.Address1_Telephone1 AS TELEFONOPRINCIPALUSU, 
					  USU.MobilePhone AS MOVILUSU
FROM         Neptunia_MSCRM.dbo.Quote AS COTI 
LEFT OUTER JOIN       Neptunia_MSCRM.dbo.StringMap AS SMAP ON SMAP.AttributeName = 'nep_estado' AND SMAP.ObjectTypeCode = 1084 AND SMAP.AttributeValue = COTI.Nep_Estado 
INNER JOIN            Neptunia_MSCRM.dbo.Account AS CLIE ON CLIE.AccountId = COTI.AccountId 
LEFT OUTER JOIN       Neptunia_MSCRM.dbo.StringMap AS SMAPC ON SMAPC.AttributeName = 'customertypecode' AND SMAPC.ObjectTypeCode = 1 AND SMAPC.AttributeValue = CLIE.CustomerTypeCode 
left outer join		  NEPTUNIA_MSCRM.dbo.contact CTO on CTO.contactid = CLIE.primarycontactid
left outer join		  NEPTUNIA_MSCRM.dbo.StringMap SMAPCC on (SMAPCC.AttributeName = 'nep_tratamiento' and SMAPCC.ObjectTypeCode = 2 and CTO.nep_tratamiento = SMAPCC.AttributeValue)
LEFT OUTER JOIN       Neptunia_MSCRM.dbo.Nep_local AS LOCAL ON COTI.Nep_LocalId = LOCAL.Nep_localId 
LEFT OUTER JOIN       Neptunia_MSCRM.dbo.Nep_facturacion AS TIPFAC ON TIPFAC.Nep_facturacionId = COTI.Nep_TipoFacturacinId 
INNER JOIN            Neptunia_MSCRM.dbo.Nep_unidadnegocio AS UNNE ON UNNE.Nep_unidadnegocioId = COTI.nep_unidadnegocioquoteid 
INNER JOIN            Neptunia_MSCRM.dbo.Nep_conceptoun AS CONC ON CONC.Nep_conceptounId = COTI.nep_conceptounquoteid 
INNER JOIN            dbo.DIVISA AS DIVI ON DIVI.IDCRM_DIVISA = COTI.TransactionCurrencyId 
INNER JOIN            Neptunia_MSCRM.dbo.SystemUser AS USU ON USU.SystemUserId = COTI.OwnerId
WHERE     (COTI.DeletionStateCode = 0)

GO
/****** Object:  View [dbo].[COTIZACIONALERTA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[COTIZACIONALERTA]
AS
SELECT     COTI.QuoteId, COTI.Nep_Correlativo AS NROCOTIZACION, CLIE.AccountNumber AS RUC, CLIE.Name AS CLIENTE, SMAPC.Value AS TIPOCLIENTE, 
                      CLIE.CustomerTypeCode AS COD_TIPOCLIENTE, COTI.nep_niveltarifarioofertaidName AS NIVELTARIFARIO, 
                      COTI.nep_niveltarifarioofertaid AS COD_NIVELTARIFARIO, UNNE.Nep_name AS UNIDADNEGOCIO, 
                      UNNE.nep_unidaddenegociounidadnegocioid AS COD_UNIDADNEGOCIO, UNNE.Nep_Iniciales AS INCIAL_UNINEG, UNNE.Nep_IdUN AS IDUN, 
                      CONC.Nep_name AS CONCEPTO, CONC.Nep_conceptounId AS COD_CONCEPTO, CONC.Nep_Iniciales AS INICIAL_CONCEPTO, 
                      CONC.Nep_IdConcepto AS IDCONCEPTO, DIVI.ID_DIVISA AS DIVISA, COTI.EffectiveFrom AS FECHAINICIOVIG, COTI.EffectiveTo AS FECHAFINVIG, 
                      COTI.Nep_Estado AS IDESTADO, SMAP.Value AS ESTADO, LOCAL.Nep_CodigoOrigen AS LOCAL, TIPFAC.Nep_CodigoenOFISIS AS TIPOFACTURACION, 
                      SMAPCC.Value AS TRATAMIENTOCONTACTO, CLIE.PrimaryContactIdName AS CONTACTOPRINCIPAL, COTI.OwnerIdName AS PROPIETARIOCOTIZACION,
                       USU.Title AS CARGOPROPIETARIO, COTI.CreatedOn, USU.InternalEMailAddress AS EMAILUSU, USU.HomePhone AS TELEFONOPARTICULARUSU, 
                      USU.Address1_Telephone1 AS TELEFONOPRINCIPALUSU, USU.MobilePhone AS MOVILUSU, COTI.Nep_Alertaporfacturacion, 
                      COTI.Nep_Estimadoafacturar, COTI.Nep_Fechaaceptacioncotizacion
FROM         Neptunia_MSCRM.dbo.Quote AS COTI LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.StringMap AS SMAP ON SMAP.AttributeName = 'nep_estado' AND SMAP.ObjectTypeCode = 1084 AND 
                      SMAP.AttributeValue = COTI.Nep_Estado INNER JOIN
                      Neptunia_MSCRM.dbo.Account AS CLIE ON CLIE.AccountId = COTI.AccountId LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.StringMap AS SMAPC ON SMAPC.AttributeName = 'customertypecode' AND SMAPC.ObjectTypeCode = 1 AND 
                      SMAPC.AttributeValue = CLIE.CustomerTypeCode LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.Contact AS CTO ON CTO.ContactId = CLIE.PrimaryContactId LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.StringMap AS SMAPCC ON SMAPCC.AttributeName = 'nep_tratamiento' AND SMAPCC.ObjectTypeCode = 2 AND 
                      CTO.Nep_Tratamiento = SMAPCC.AttributeValue LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.Nep_local AS LOCAL ON COTI.nep_localid = LOCAL.Nep_localId LEFT OUTER JOIN
                      Neptunia_MSCRM.dbo.Nep_facturacion AS TIPFAC ON TIPFAC.Nep_facturacionId = COTI.nep_tipofacturacinid INNER JOIN
                      Neptunia_MSCRM.dbo.Nep_unidadnegocio AS UNNE ON UNNE.Nep_unidadnegocioId = COTI.nep_unidadnegocioquoteid INNER JOIN
                      Neptunia_MSCRM.dbo.Nep_conceptoun AS CONC ON CONC.Nep_conceptounId = COTI.nep_conceptounquoteid INNER JOIN
                      dbo.DIVISA AS DIVI ON DIVI.IDCRM_DIVISA = COTI.TransactionCurrencyId INNER JOIN
                      Neptunia_MSCRM.dbo.SystemUser AS USU ON USU.SystemUserId = COTI.OwnerId
WHERE     (COTI.DeletionStateCode = 0)
GO
/****** Object:  View [dbo].[DETFACTURA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[DETFACTURA]      
AS
SELECT      
 CAS.TicketNumber FACNROCASO,      
 FACCAB.Nep_TipoDocumento FACTIPODOC,      
 FACCAB.Nep_NroFactura FACNUMERO,      
 FACCAB.Nep_Ruc FACNRORUC,      
 FACDET.Nep_CodigoServicio DETCODSERVICIO,      
 FACDET.Nep_DescripcionServicio DETNOMSERVICIO,      
 FACDET.Nep_UnidadNegocioOFISIS DETUNEGOCIO,      
 FACDET.Nep_LocalTienda DETLOCAL,      
 FACDET.Nep_TipoImpuesto1 DETTIPOIMP1,      
 FACDET.Nep_AfectoImpuesto1 DETAFECTOIMP1,      
 FACDET.Nep_Impuesto1 DETIMP1,      
 FACDET.Nep_TipoImpuesto2 DETTIPOIMP2,      
 FACDET.Nep_AfectoImpuesto2 DETAFECTOIMP2,      
 FACDET.Nep_Impuesto2 DETIMP2,      
 FACDET.Nep_TipoImpuesto3 DETTIPOIMP3,      
 FACDET.Nep_AfectoImpuesto3 DETAFECTOIMP3,      
 FACDET.Nep_Impuesto3 DETIMP3,      
 FACDET.Nep_Cantidad DETCANTIDAD,      
 FACDET.Nep_PrecioVentaSinImpuestos DETPRECIOVENTASINIGV,      
 FACDET.Nep_TotalPorLinea DETTOTALPORLINEA,       
 --FACDET.Nep_MontoADevolver DETMONTODEVOLVER      
 FACDET.Nep_MontoCorrecto DETMONTOCORRECTO,
 CAS.StatusCode  
FROM NEPTUNIA_MSCRM.dbo.nep_detallefacturaasociadaalcaso FACDET      
INNER JOIN NEPTUNIA_MSCRM.dbo.nep_facturaasociadaalcaso FACCAB ON FACCAB.nep_facturaasociadaalcasoid=FACDET.nep_facturaasociadaalcasoId      
INNER JOIN NEPTUNIA_MSCRM.dbo.INCIDENT CAS ON CAS.INCIDENTID=FACCAB.NEP_CASOID      
WHERE FACDET.DeletionStateCode=0     
      AND FACCAB.DeletionStateCode=0     
      AND CAS.DeletionStateCode=0      
      --AND CAS.StateCode = 0 --Activo  
      AND (CAS.StatusCode = '200006' OR CAS.StatusCode = '200008' or CAS.StatusCode='200010') --Aprobado Contablemente y Aprobado por gerencia
GO
/****** Object:  View [dbo].[ESTADOSCOTIZACION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ESTADOSCOTIZACION]  
AS  
 
SELECT  SMAP.AttributeValue COD_ESTADOCOT,
		SMAP.Value ESTADOCOT
FROM NEPTUNIA_MSCRM.dbo.StringMap SMAP 
WHERE (SMAP.AttributeName = 'nep_estado' and SMAP.ObjectTypeCode = 1084)  

GO
/****** Object:  View [dbo].[ESTADOSRECLAMO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[ESTADOSRECLAMO]
AS
SELECT  
 SMP.AttributeValue ESTCODIGO,  
 SMP.VALUE ESTNOMBRE  
FROM neptunia_mscrm..stringmap SMP  
WHERE SMP.objecttypecode='112' 
  and SMP.attributename='statuscode' 
  AND (SMP.AttributeValue not in ('200001','200000', '6','2'))
  --and (SMP.AttributeValue='200006' or --APROBADO CONTABLEMENTE
--		SMP.AttributeValue='200008' or --APROBADO POR GERENCIA
--		SMP.AttributeValue='200010'or  --NOTA DE CREDITO EMITIDA
--		SMP.AttributeValue='5' or --ATENDIDO
--		SMP.AttributeValue='1' --EN CURSO
--		)
GO
/****** Object:  View [dbo].[FAC_ClientesXMonedaAlterna]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[FAC_ClientesXMonedaAlterna]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : CRM - Facturacion       
  Nombre Vista         : FAC_CientesXMonedaAlterna
  Descripcion Vista    : Muestra las monedas alternas de los clientes CRM
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 27/09/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from FAC_ClientesXMonedaAlterna
=============================================================================*/ 
AS

SELECT     
 C.AccountNumber Ruc 
,CON.Nep_IdConcepto ConceptoId
,M.Nep_ConceptoUNIdName
,DD.ID_DIVISA MonedaAlternaId
,M.Nep_DivisaIdName MonedaAlterna
FROM  Neptunia_MSCRM.dbo.Account C
INNER JOIN dbo.DIVISA D ON D.IDCRM_DIVISA = C.TransactionCurrencyId
INNER JOIN Neptunia_MSCRM.dbo.nep_account_nep_monedaalterna MC ON C.accountid = MC.accountid
INNER JOIN Neptunia_MSCRM.dbo.nep_MonedaAlterna M ON M.nep_monedaalternaid = MC.nep_monedaalternaid and M.statecode = 0
INNER JOIN Neptunia_MSCRM.dbo.nep_conceptoUN CON ON M.nep_conceptoUNId = CON.nep_conceptoUnId
INNER JOIN dbo.DIVISA DD ON DD.IDCRM_DIVISA = M.Nep_DivisaId
WHERE C.DeletionStateCode <> 2




GO
/****** Object:  View [dbo].[FAC_ItemReclamo]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[FAC_ItemReclamo]
AS
SELECT     CAS.TicketNumber AS CasoNumero, FACCAB.Nep_NroFactura AS DocumentoNumero, FACCAB.Nep_tipodocumento AS DocumentoTipo, 
                      FACDET.Nep_CodigoServicio AS Servicio, FACDET.Nep_UnidadNegocioOFISIS AS UnidadNegocio, FACDET.Nep_LocalTienda AS Local, 
                      FACDET.Nep_AfectoImpuesto1 AS AfectoIgv, FACDET.Nep_TotalPorLinea AS Importe, FACDET.Nep_MontoCorrecto AS ImporteCorrecto
FROM         Neptunia_MSCRM.dbo.Nep_detallefacturaasociadaalcaso AS FACDET INNER JOIN
                      Neptunia_MSCRM.dbo.Nep_facturaasociadaalcaso AS FACCAB ON 
                      FACCAB.Nep_facturaasociadaalcasoId = FACDET.Nep_FacturaasociadaalcasoId INNER JOIN
                      Neptunia_MSCRM.dbo.Incident AS CAS ON CAS.IncidentId = FACCAB.nep_casoid
WHERE     (FACDET.DeletionStateCode = 0) AND (FACCAB.DeletionStateCode = 0) AND (CAS.DeletionStateCode = 0) 
			AND (CAS.StatusCode not in ('200001','200000', '6','2'))
			--AND (CAS.StatusCode = '200006' OR
            --     CAS.StatusCode = '200008' OR
            --     CAS.StatusCode = '200010' OR CAS.StatusCode = '1')
GO
/****** Object:  View [dbo].[FAC_Reclamo]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[FAC_Reclamo]
AS
SELECT     CAS.TicketNumber AS CasoNumero, CAS.CreatedOn AS CasoFecha, USU.DomainName AS CasoUsuario, CAS.StateCode AS CasoEstado, 
                      FACCAB.Nep_NroFactura AS DocumentoNumero, FACCAB.Nep_tipodocumento AS DocumentoTipo, FACCAB.Nep_Ruc AS DocumentoCliente, 
                      CASE FACCAB.Nep_TipoMoneda WHEN 1 THEN 'SOL' ELSE 'DOL' END AS DocumentoMoneda, FACCAB.Nep_impuesto1 AS DocumentoIgv, 
                      ISNULL(FACCAB.Nep_FechadeEmision, GETDATE()) AS DocumentoFecha, ISNULL(FACCAB.Nep_TotalFactura, 0) AS DocumentoImporte, 
                      FACCAB.Nep_Observaciones AS DocumentoObservacion, FACCAB.Nep_Serefactura AS Refacturar, CAS.StatusCode AS EstadoReclamo
FROM         Neptunia_MSCRM.dbo.Nep_facturaasociadaalcaso AS FACCAB INNER JOIN
                      Neptunia_MSCRM.dbo.Incident AS CAS ON CAS.IncidentId = FACCAB.nep_casoid INNER JOIN
                      Neptunia_MSCRM.dbo.SystemUser AS USU ON CAS.OwnerId = USU.SystemUserId
WHERE     (FACCAB.DeletionStateCode = 0) AND (CAS.DeletionStateCode = 0) 
		   AND (CAS.StatusCode not in ('200001','200000', '6','2'))
		   AND (FACCAB.StatusCode not in ('200001','200000', '6','2')) --> Agregado - jlazo - 20121221
		   and  CAS.TicketNumber not in ('CAS-01303-68987Y')
GO
/****** Object:  View [dbo].[TIPOCLIENTE]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TIPOCLIENTE]

AS
SELECT 
AttributeValue COD_TIPCLIENTE, 
Value TIPCLIENTE
FROM NEPTUNIA_MSCRM.dbo.stringmap 
WHERE objectTypeCode=1 and AttributeName='customertypecode'
GO
/****** Object:  View [dbo].[UNIDADNEGOCIOS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[UNIDADNEGOCIOS]

AS
SELECT 
NEP_IDUN			ID_UN, 
NEP_NAME			NOMBREUN, 
NEP_INICIALES		INICIALUN,
NEP_UNIDADNEGOCIOID COD_UN,
Nep_CodigoOFISIS    COD_ORIGEN
FROM NEPTUNIA_MSCRM.dbo.NEP_UNIDADNEGOCIO
WHERE
STATUSCODE = 1

GO
/****** Object:  View [dbo].[USUARIOXUN]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[USUARIOXUN]      
AS
	SELECT      
	A.SYSTEMUSERID, A.FULLNAME AS NOMBRE, UPPER(RIGHT(A.DOMAINNAME,LEN(A.DOMAINNAME)-7)) AS LOGIN, A.NICKNAME AS INICIALES, A.TITLE AS CARGO, A.INTERNALEMAILADDRESS AS EMAIL, A.BUSINESSUNITIDDSC AS COD_DIVISION, A.BUSINESSUNITIDNAME AS NOM_DIVISION,
	D.NEP_CODIGOOFISIS AS COD_UN, D.NEP_NAME AS NOM_UN
	FROM 
	NEPTUNIA_MSCRM.DBO.SYSTEMUSER A
	INNER JOIN NEPTUNIA_MSCRM.DBO.NEP_NEP_UNIDADNEGOCIO_SYSTEMUSERBASE B
	ON A.SYSTEMUSERID = B.SYSTEMUSERID
	AND A.ISDISABLED = 0
	INNER JOIN NEPTUNIA_MSCRM.DBO.NEP_UNIDADNEGOCIOBASE C
	ON B.NEP_UNIDADNEGOCIOID = C.NEP_UNIDADNEGOCIOID
	AND C.STATECODE = 0
	INNER JOIN NEPTUNIA_MSCRM.DBO.NEP_UNIDADNEGOCIOEXTENSIONBASE D
	ON C.NEP_UNIDADNEGOCIOID = D.NEP_UNIDADNEGOCIOID
GO
/****** Object:  View [dbo].[View_IndicadoresxCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_IndicadoresxCaso]  
AS  

SELECT  
T.TICKETNUMBER,
T.AccountIdName,
T.nep_unidaddenegocioidName,
T.CreatedOn,
T.Nep_Fechadeaprobacion,
T.ActualEnd,
T.Nep_MotivoPadre,
T.ContadorCaso,
T.ITAR,
T.ITAPR 
FROM (
SELECT     i.TicketNumber, i.AccountIdName, i.nep_unidaddenegocioidName, i.CreatedOn, i.Nep_Fechadeaprobacion, ir.ActualEnd, i.Nep_MotivoPadre,
			ROW_NUMBER() over(
            PARTITION  BY i.TicketNumber 
	        ORDER BY i.TicketNumber ASC )  AS ContadorCaso,
	        isnull (DATEDIFF(hour, i.CreatedOn, ir.ActualEnd),0) AS ITAR,
	       isnull( DATEDIFF(hour, i.CreatedOn, i.Nep_Fechadeaprobacion),0) AS ITAPR 
FROM         Neptunia_MSCRM.dbo.Incident AS i INNER JOIN  
                      Neptunia_MSCRM.dbo.IncidentResolution AS ir ON i.IncidentId = ir.IncidentId  
WHERE     (i.StateCode = '1')   AND (I.DELETIONSTATECODE<>2) 
GROUP BY i.TicketNumber,i.AccountIdName, i.nep_unidaddenegocioidName, i.CreatedOn, i.Nep_Fechadeaprobacion, ir.ActualEnd, i.Nep_MotivoPadre
) T 
WHERE T.ContadorCaso=1



GO
/****** Object:  View [dbo].[View_ReporteActividadesporCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_ReporteActividadesporCaso]      
AS      
 select 
count(t.temahito) contadortemas,
--t.ticketnumber,
t.OWNERIDNAME,
CASE WHEN LEN(t.temahito)=0 THEN 'No Definido'
ELSE T.TEMAHITO END AS TEMAHITO,
t.rangodias, 
T.nep_motivopadre,
T.FECHACREACIONCASO
  FROM  
(SELECT  TSK.ACTIVITYID CodigoTemaHito,      
CAS.TicketNumber,     
CAS.CreatedOn FechaCreacionCaso,    
CASE     
CAS.statecode    
When 0 then 'Activo'     
When 1 then 'Resuelto'     
When 2 then 'Cancelado'     
else null     
END as [Estado],    
CASE CAS.statuscode    
When 1 then 'En curso'     
When 2 then 'Abierto'     
When 3 then 'Pendiente de aprobacin contable'     
When 4 then 'Observado'     
When 5 then 'Atendido'     
When 6 then 'Cancelado'     
When 200000 then 'Rechazado'     
When 200001 then 'No procede'     
When 200002 then 'Pendiente de cierre'     
When 200003 then 'Pendiente de aprobacin'     
When 200004 then 'Aprobado'     
When 200006 then 'Aprobado contablemente'     
When 200007 then 'Pendiente de aprobacin gerencial'     
When 200008 then 'Aprobado por gerencia'     
When 200009 then 'Apelado'     
When 200010 then 'Nota de crdito emitada'     
else null     
END as [RaznEstado],    
CAS.accountidname,   
ACC.nep_ejecutivoventaportuarioidname,   
ACC.nep_ejecutivoservicioportuarioidname,   
ACC.nep_ejecutivoventalogisticoidname,   
ACC.nep_ejecutivoserviciologisticoidname,   
CAS.nep_unidaddenegocioidname,    
CASE CAS.caseorigincode     
WHEN 1 THEN 'Telfono'     
WHEN 2 THEN 'Correo electrnico'     
WHEN 3 THEN 'Web'     
WHEN 200000 THEN 'Carta'     
WHEN 200001 THEN 'Presencial'     
WHEN 200002 THEN 'Neptunia'     
ELSE null     
END as [OrigenCaso],    
CAS.nep_motivopadre,   
CAS.subjectidname,   
FAC.Nep_NroFactura,   
CONVERT(VARCHAR(10), FAC.nep_fechadeemision, 103) as [FechaEmisionFactura],   
FAC.nep_totalfactura,    
CASE FAC.nep_tipomoneda     
WHEN 1 THEN 'Soles'     
WHEN 2 THEN 'Dlares'     
ELSE null END as [TipoMoneda],    
FAC.nep_nronotadecredito,   
CONVERT(VARCHAR(10), FAC.nep_fechaemisionnotacredito, 103) as [FechaEmisionNotaCredito],   
FAC.nep_montonotadecredito1,     
CASE WHEN len(TSK.subject)=0 then 'No Definido'
ELSE substring(TSK.subject ,0 , charindex ('CAS-', TSK.subject)) END AS TemaHito,     
TSK.owneridname,     
CONVERT(VARCHAR(10), TSK.createdon, 103) as [FechaCreacionHito],   
CONVERT(VARCHAR(10), TSK.actualend, 103) as [FechaFinRealHito],   
(TSK.scheduleddurationminutes/60/24) as [DuracionProgramada],   
DATEDIFF(day, TSK.createdon, TSK.actualend) AS Duracion ,  
  
 ROW_NUMBER() over(  
        PARTITION  BY CAS.TicketNumber,TSK.ACTIVITYID   
     ORDER BY CAS.TicketNumber ASC )  AS ContadorTareas,  
case when DATEDIFF(day, TSK.createdon, TSK.actualend)>=0 and DATEDIFF(day, TSK.createdon, TSK.actualend)<=5 then '0-5 dias'  
 when DATEDIFF(day, TSK.createdon, TSK.actualend)>=6 and DATEDIFF(day, TSK.createdon, TSK.actualend)<=10 then '6-10 dias'  
 when DATEDIFF(day, TSK.createdon, TSK.actualend)>=11 and DATEDIFF(day, TSK.createdon, TSK.actualend)<=15 then '11-15 dias'  
 when DATEDIFF(day, TSK.createdon, TSK.actualend) >=16 then  '16-Mas dias'  
 ELSE '0-5 dias' END AS RangoDias  
from neptunia_mscrm.dbo.nep_facturaasociadaalcaso FAC     
INNER JOIN neptunia_mscrm.dbo.incident CAS ON FAC.nep_casoid =CAS.incidentid    
join neptunia_mscrm.dbo.account ACC on acc.accountid = cas.accountid    
join neptunia_mscrm.dbo.task TSK ON CAS.incidentid= TSK.regardingobjectid    
where FAC.DeletionStateCode <> 2    
--AND FAC.nep_totalfactura IS NOT NULL    
--AND FAC.nep_fechaemisionnotacredito IS NOT NULL    
AND tsk.DeletionStateCode <> 2    
--AND cas.incidentid like '%9612CD78-498C-DE11-A074-0050568B2462%'    
--AND TSK.subject LIKE '%validar%'    
and tsk.statecode = '1'    
--and owneridname like @Usuario    
--order by accountidname  
--and TSK.owneridname like '%Gisella Guffanti Vargas%'
) T
WHERE T.CONTADORTAREAS=1
group by 
--t.ticketnumber,
t.temahito,
--t.duracion,
t.rangodias,
t.OWNERIDNAME,
T.nep_motivopadre,
T.FECHACREACIONCASO


GO
/****** Object:  View [dbo].[VWBI_CLIENTE]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_CLIENTE]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_Cliente
  Descripcion Vista    : Copia al stage los campos de la entidad cliente de CRM
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : Yesenia Quispe M.
  Fecha Modificación   : 25/05/2010
  Detalle Modificación : Se excluye clientes inactivos
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_Cliente
=============================================================================*/    
AS
SELECT
ACC.accountid,
ACC.accountnumber,
ACC.name,
ACC.address1_name,
ACC.emailaddress1,
ACC.telephone1,
ACC.telephone2,
ACC.telephone3,
ACC.fax,
ACC.nep_grupoeconomico,
SMPGE.Value AS nep_grupoeconomiconame,
ACC.nep_montoestimadofacturacion,
ACC.nep_niveltarifarioactualid,
ACC.nep_niveltarifariopropuestoid,
ACC.nep_ubigeocuentaid,
ACC.websiteurl,
ACC.nep_rubro,
SMPRU.Value AS nep_rubroname,
ACC.nep_segmento,
SMPSE.Value AS nep_segmentoname,
ACC.nep_clientesegunacuerdo,
SMPCA.Value AS nep_clientesegunacuerdoname,
ACC.nep_codigociiiuid,
ACC.nep_codigociiiuidname,
ACC.nep_codigoerp,
ACC.nep_facturacionanterior,
ACC.nep_ejecutivoserviciologisticoid,
ACC.nep_ejecutivoserviciologisticoidname,
ACC.nep_ejecutivoservicioportuarioid,
ACC.nep_ejecutivoservicioportuarioidname,
ACC.nep_ejecutivoventalogisticoid,
ACC.nep_ejecutivoventalogisticoidname,
ACC.nep_ejecutivoventaportuarioid,
ACC.nep_ejecutivoventaportuarioidname,
ACC.nep_persona,
SMPPE.Value as nep_personaname,
ACC.industrycode,
SMPIN.Value as industrycodename,
ACC.customertypecode,
SMPCU.Value as customertypecodename,
ACC.accountcategorycode,
SMPAC.Value as accountcategorycodename,
ACC.statuscode,
SMPST.Value as statuscodename,
ACC.defaultpricelevelid,
ACC.defaultpricelevelidname,
ACC.modifiedby,
ACC.modifiedbyname,
ACC.modifiedon,
ACC.ownerid,
ACC.owneridname
FROM NEPTUNIA_MSCRM.dbo.Account AS ACC
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPGE ON (ACC.nep_grupoeconomico = SMPGE.AttributeValue AND SMPGE.AttributeName = 'nep_grupoeconomico' and SMPGE.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPRU ON (ACC.nep_rubro = SMPRU.AttributeValue AND SMPRU.AttributeName = 'nep_rubro' and SMPRU.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSE ON (ACC.nep_segmento = SMPSE.AttributeValue AND SMPSE.AttributeName = 'nep_segmento' and SMPSE.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPCA ON (ACC.nep_clientesegunacuerdo = SMPCA.AttributeValue AND SMPCA.AttributeName = 'nep_clientesegunacuerdo' and SMPCA.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPPE ON (ACC.nep_persona = SMPPE.AttributeValue AND SMPPE.AttributeName = 'nep_persona' and SMPPE.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPIN ON (ACC.industrycode = SMPIN.AttributeValue AND SMPIN.AttributeName = 'industrycode' and SMPIN.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPCU ON (ACC.customertypecode = SMPCU.AttributeValue AND SMPCU.AttributeName = 'customertypecode' and SMPCU.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPAC ON (ACC.accountcategorycode = SMPAC.AttributeValue AND SMPAC.AttributeName = 'accountcategorycode' and SMPAC.ObjectTypeCode = 1)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (ACC.statuscode = SMPST.AttributeValue AND SMPST.AttributeName = 'statuscode' and SMPST.ObjectTypeCode = 1)  
WHERE ACC.DeletionStateCode = 0 and ACC.StateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_CONCEPTOUN]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_CONCEPTOUN]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_CONCEPTOUN
  Descripcion Vista    : Copia al stage los campos de la entidad conceptos
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_CONCEPTOUN
=============================================================================*/    
AS
SELECT
	CON.nep_conceptounid,
	CON.nep_idconcepto,
	CON.nep_name,
	CON.nep_iniciales,
	CON.nep_unidadnegocioconceptoid,
	UN.nep_CodigoOFISIS as nep_idunidadnegocio,
	CON.modifiedby,
	CON.modifiedbyname,
	CON.modifiedon 
FROM Neptunia_MSCRM.dbo.Nep_conceptoun as CON
inner join Neptunia_MSCRM.dbo.Nep_unidadnegocio UN on UN.nep_unidadnegocioid = CON.nep_unidadnegocioconceptoid
WHERE CON.DeletionStateCode = 0


GO
/****** Object:  View [dbo].[VWBI_CONTACTO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_CONTACTO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_CONTACTO
  Descripcion Vista    : Copia al stage los campos de la entidad Contacto
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_CONTACTO
=============================================================================*/    
AS
SELECT
	CON.contactid,
	CON.nep_apepaterno,
	CON.nep_apematerno,
	CON.fullname,
	CON.firstname,
	CON.lastname,
	CON.nep_nrodedocumento,
	CON.nep_tipodedocumento,
	SMP.Value AS nep_tipodedocumentoname,
	CON.address1_name,
	CON.accountid,
	CON.modifiedby,
	CON.modifiedbyname,
	CON.modifiedon,
	CON.ownerid,
	CON.owneridname  
From NEPTUNIA_MSCRM.dbo.Contact AS CON
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMP ON CON.nep_tipodedocumento = SMP.AttributeValue AND (SMP.AttributeName = 'nep_tipodedocumento' and SMP.ObjectTypeCode = 2)  
WHERE CON.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_COTIZACION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_COTIZACION]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_COTIZACION
  Descripcion Vista    : Copia al stage los campos de la entidad Cotizacion
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_COTIZACION
=============================================================================*/ 
AS
SELECT
COTI.quoteid,
COTI.quotenumber,
COTI.name,
COTI.accountid,
COTI.customerid,
COTI.customeridname,
COTI.customeridtype,
COTI.discountpercentage,
COTI.nep_alertaporvencimiento,
SMPAV.Value AS nep_alertaporvencimientoname,
COTI.nep_fechaaceptacioncotizacion,
COTI.nep_fechaaprobacioncotizacion,
COTI.nep_correlativo,
COTI.nep_estado,
SMPES.Value AS nep_estadoname,
COTI.nep_estimadoafacturar,
COTI.nep_kpifillrate,
COTI.nep_kpiira,
COTI.nep_kpiotd,
COTI.nep_montontcliente,
COTI.nep_montontcotizacion,
COTI.totalamount,
COTI.totalamount_base,
COTI.totalamountlessfreight,
COTI.totalamountlessfreight_base,
COTI.totaldiscountamount,
COTI.totaldiscountamount_base,
COTI.totallineitemamount,
COTI.totallineitemamount_base,
COTI.totallineitemdiscountamount,
COTI.totallineitemdiscountamount_base,
COTI.totaltax,
COTI.totaltax_base,
COTI.nep_conceptounquoteid,
COTI.nep_conceptounquoteidname,
COTI.nep_unidadnegocioquoteid,
COTI.nep_unidadnegocioquoteidname,
COTI.nep_niveltarifarioofertaid,
COTI.nep_niveltarifarioofertaidname,
COTI.opportunityid,
COTI.opportunityidname,
COTI.pricelevelid,
COTI.pricelevelidname,
COTI.nep_nrorevision,
COTI.nep_razonrechazo,
COTI.statecode,
SMPST.Value as statecodename,
COTI.statuscode,
SMPSC.Value as statuscodename,
COTI.modifiedby,
COTI.modifiedbyname,
COTI.modifiedon,
COTI.ownerid,
COTI.owneridname,
COTI.createdon
FROM NEPTUNIA_MSCRM.dbo.Quote as COTI
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPAV ON (COTI.nep_alertaporvencimiento = SMPAV.AttributeValue AND SMPAV.AttributeName = 'nep_alertaporvencimiento' and SMPAV.ObjectTypeCode = 1084)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPES ON (COTI.nep_estado = SMPES.AttributeValue AND SMPES.AttributeName = 'nep_estado' and SMPES.ObjectTypeCode = 1084)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (COTI.statecode = SMPST.AttributeValue AND SMPST.AttributeName = 'statecode' and SMPST.ObjectTypeCode = 1084)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSC ON (COTI.statuscode = SMPSC.AttributeValue AND SMPSC.AttributeName = 'statuscode' and SMPSC.ObjectTypeCode = 1084)  
WHERE COTI.deletionstatecode = 0

GO
/****** Object:  View [dbo].[VWBI_CUOTA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_CUOTA]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_CUOTA
  Descripcion Vista    : Copia al stage los campos de la entidad Cuota de CRM
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_CUOTA
=============================================================================*/    
AS
SELECT
	CUO.nep_cuotaid,
	CUO.nep_cuota,
	CUO.nep_ejecutivoventaid,
	CUO.nep_ejecutivoventaidname,
	CUO.nep_name,
	CUO.nep_unidadnegocioid,
	CUO.nep_unidadnegocioidname,
	CUO.nep_anodecuota,
	SMPAC.Value as nep_anodecuotaname,
	CUO.nep_enero,
	CUO.nep_febrero,
	CUO.nep_marzo,
	CUO.nep_abril,
	CUO.nep_mayo,
	CUO.nep_junio,
	CUO.nep_julio,
	CUO.nep_agosto,
	CUO.nep_setiembre,
	CUO.nep_octubre,
	CUO.nep_noviembre,
	CUO.nep_diciembre,
	CUO.nep_clenero,
	CUO.nep_clfebrero,
	CUO.nep_clmarzo,
	CUO.nep_clabril,
	CUO.nep_clmayo,
	CUO.nep_cljunio,
	CUO.nep_cljulio,
	CUO.nep_clagosto,
	CUO.nep_clsetiembre,
	CUO.nep_cloctubre,
	CUO.nep_clnoviembre,
	CUO.nep_cldiciembre,
	CUO.nep_vienero,
	CUO.nep_vifebrero,
	CUO.nep_vimarzo,
	CUO.nep_viabril,
	CUO.nep_vimayo,
	CUO.nep_vijunio,
	CUO.nep_vijulio,
	CUO.nep_viagosto,
	CUO.nep_visetiembre,
	CUO.nep_vioctubre,
	CUO.nep_vinoviembre,
	CUO.nep_vidiciembre,
	CUO.statecode,
	SMPST.Value as statecodename,
	CUO.createdon,
	CUO.modifiedby,
	CUO.modifiedbyname,
	CUO.modifiedon,
	CUO.ownerid,
	CUO.owneridname
FROM NEPTUNIA_MSCRM.dbo.Nep_cuota CUO
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPAC ON (CUO.nep_anodecuota = SMPAC.AttributeValue AND SMPAC.AttributeName = 'nep_anodecuota' and SMPAC.ObjectTypeCode = 10010)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (CUO.statecode = SMPST.AttributeValue AND SMPST.AttributeName = 'statecode' and SMPST.ObjectTypeCode = 10010)  
WHERE CUO.deletionstatecode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_DIVISION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_DIVISION]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_DIVISION
  Descripcion Vista    : Copia al stage los campos de la entidad Division CRM
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_DIVISION
=============================================================================*/    
AS
SELECT     
		DIVI.businessunitid,
		DIVI.name,
		DIVI.modifiedby,
		DIVI.modifiedbyname,
		DIVI.modifiedon
FROM    Neptunia_MSCRM.dbo.BusinessUnit AS DIVI 
WHERE   (DIVI .DeletionStateCode = 0)
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_INCIDENTE]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[VWBI_INCIDENTE]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_INCIDENTE
  Descripcion Vista    : Copia al stage los campos de la entidad Incidente(Reclamo)
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_INCIDENTE
=============================================================================*/  
AS
SELECT
CAS.incidentid,
CAS.incidentstagecode,
SMPIN.Value AS incidentstagecodename,
CAS.description,
CAS.caseorigincode,
SMPOR.Value as caseorigincodename,
CAS.casetypecode,
SMPTC.Value AS casetypecodename,
CAS.nep_accionescorrectivas,
CAS.nep_afectatributario,
SMPAT.Value AS nep_afectatributarioname,
CAS.nep_apelado,
SMPAP.Value AS nep_apeladoname,
--,nep_causasdereclamo
CAS.nep_escala,
SMPES.Value AS nep_escalaname,
--,nep_fase
--,nep_fasename
CAS.nep_fechaentreganotadecredito,
CAS.nep_local,
SMPLO.Value AS nep_localname,
CAS.nep_montofiniquito,
CAS.nep_montototaldereclamoincigv,
CAS.nep_motivopadre,
CAS.nep_necesitacheque,
SMPNC.Value as nep_necesitachequename,
CAS.nep_nrocheque,
CAS.nep_observaciones,
CAS.nep_sucursal,
SMPSU.Value as nep_sucursalname,
CAS.nep_tipomoneda,
CAS.nep_tipomonedamontofiniquito,
SMPMF.Value as nep_tipomonedamontofiniquitoname,
SMPTM.Value as nep_tipomonedaname,
CAS.nep_unidaddenegocioid,
CAS.nep_unidaddenegocioidname,
CAS.prioritycode,
SMPPC.Value as prioritycodename,
CAS.responsiblecontactid,
CAS.responsiblecontactidname,
CAS.statecode,
SMPSC.Value as statecodename,
CAS.statuscode,
SMPST.Value as statuscodename,
case when statecode=1 then modifiedon
else null end fecha_cierre,
case when statecode=1 and statuscode=200000 then modifiedon
else null end fecha_rechazo,
CAS.subjectid,
CAS.subjectidname,
CAS.ticketnumber,
CAS.title,
CAS.accountid,
CAS.accountidname,
CAS.customerid,
CAS.customeridname,
CAS.customeridtype,
CAS.customersatisfactioncode,
SMPSA.Value as customersatisfactioncodename,
CAS.modifiedby,
CAS.modifiedbyname,
CAS.modifiedon,
CAS.ownerid,
CAS.owneridname,
CAS.createdon
From NEPTUNIA_MSCRM.dbo.Incident CAS
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPIN ON (CAS.incidentstagecode = SMPIN.AttributeValue AND SMPIN.AttributeName = 'incidentstagecode' and SMPIN.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPOR ON (CAS.caseorigincode = SMPOR.AttributeValue AND SMPOR.AttributeName = 'caseorigincode' and SMPOR.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPTC ON (CAS.casetypecode = SMPTC.AttributeValue AND SMPTC.AttributeName = 'casetypecode' and SMPTC.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPAT ON (CAS.nep_afectatributario = SMPAT.AttributeValue AND SMPAT.AttributeName = 'nep_afectatributario' and SMPAT.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPAP ON (CAS.nep_apelado = SMPAP.AttributeValue AND SMPAP.AttributeName = 'nep_apelado' and SMPAP.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPES ON (CAS.nep_escala = SMPES.AttributeValue AND SMPES.AttributeName = 'nep_escala' and SMPES.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPLO ON (CAS.nep_local = SMPLO.AttributeValue AND SMPLO.AttributeName = 'nep_local' and SMPLO.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPNC ON (CAS.nep_necesitacheque = SMPNC.AttributeValue AND SMPNC.AttributeName = 'nep_necesitacheque' and SMPNC.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSU ON (CAS.nep_sucursal = SMPSU.AttributeValue AND SMPSU.AttributeName = 'nep_sucursal' and SMPSU.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPMF ON (CAS.nep_tipomonedamontofiniquito = SMPMF.AttributeValue AND SMPMF.AttributeName = 'nep_tipomonedamontofiniquito' and SMPMF.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPTM ON (CAS.nep_tipomoneda = SMPTM.AttributeValue AND SMPTM.AttributeName = 'nep_tipomoneda' and SMPTM.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPPC ON (CAS.prioritycode = SMPPC.AttributeValue AND SMPPC.AttributeName = 'prioritycode' and SMPPC.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSC ON (CAS.statecode = SMPSC.AttributeValue AND SMPSC.AttributeName = 'statecode' and SMPSC.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (CAS.statuscode = SMPST.AttributeValue AND SMPST.AttributeName = 'statuscode' and SMPST.ObjectTypeCode = 112)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSA ON (CAS.customersatisfactioncode = SMPSA.AttributeValue AND SMPSA.AttributeName = 'customersatisfactioncode' and SMPSA.ObjectTypeCode = 112)  
/*-------------------------------------FIN-----------------------------------*/
WHERE CAS.deletionstatecode = 0








GO
/****** Object:  View [dbo].[VWBI_NIVELTARIFARIO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_NIVELTARIFARIO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_NIVELTARIFARIO
  Descripcion Vista    : Copia al stage los campos de la Entidad Nivel Tarifario
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_NIVELTARIFARIO
=============================================================================*/   
AS
SELECT
	NTA.nep_niveltarifarioid,
	NTA.nep_name,
	NTA.nep_montont,
	NTA.nep_montomaximo,
	NTA.nep_montominimo,
	NTA.modifiedby,
	NTA.modifiedbyname,
	NTA.modifiedon 
FROM Neptunia_MSCRM.dbo.Nep_niveltarifario as NTA
WHERE NTA.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_OPORTUNIDAD]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_OPORTUNIDAD]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_OPORTUNIDAD
  Descripcion Vista    : Copia al stage los campos de la Entidad Oportunidad
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_OPORTUNIDAD
=============================================================================*/   
AS
SELECT
OPO.opportunityid,
OPO.name,
OPO.opportunityratingcode,
SMPRC.Value as opportunityratingcodename,
OPO.actualclosedate,
OPO.estimatedclosedate,
OPO.estimatedvalue,
OPO.estimatedvalue_base,
OPO.nep_estimadoafacturar,
OPO.nep_kpifillrate,
OPO.nep_kpiira,
OPO.nep_kpiotd,
OPO.nep_montodecredito,
OPO.nep_flujodecaja,
SMPFC.Value as nep_flujodecajaname,
OPO.nep_conceptounoportunidadid,
OPO.nep_niveltarifarioid,
OPO.nep_requierecredito,
OPO.nep_unidadnegociooportunidadid,
OPO.pricelevelid,
OPO.pricelevelidname,
OPO.statecode,
SMPST.Value as statecodename,
OPO.statuscode,
SMPSU.Value as statuscodename,
OPO.accountid,
OPO.customerid,
OPO.customeridname,
OPO.modifiedby,
OPO.modifiedbyname,
OPO.modifiedon,
OPO.ownerid,
OPO.owneridname,
OPO.createdon
FROM NEPTUNIA_MSCRM.dbo.Opportunity AS OPO
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPRC ON (OPO.opportunityratingcode = SMPRC.AttributeValue AND SMPRC.AttributeName = 'opportunityratingcode' and SMPRC.ObjectTypeCode = 3)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPFC ON (OPO.nep_flujodecaja = SMPFC.AttributeValue AND SMPFC.AttributeName = 'nep_flujodecaja' and SMPFC.ObjectTypeCode = 3)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (OPO.statecode = SMPST.AttributeValue AND SMPST.AttributeName = 'statecode' and SMPST.ObjectTypeCode = 3)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSU ON (OPO.statuscode = SMPSU.AttributeValue AND SMPSU.AttributeName = 'statuscode' and SMPSU.ObjectTypeCode = 3)  
WHERE OPO.deletionstatecode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_ROL]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_ROL]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_ROL
  Descripcion Vista    : Copia al stage los campos de la Entidad Roles
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_ROL
=============================================================================*/   
AS
SELECT
	ROL.roleid,
	ROL.name,
	ROL.parentroleid,
	ROL.parentroleidname,
	ROL.businessunitid,
	ROL.modifiedby,
	ROL.modifiedbyname,
	--ROL.modifiedon
	case when ROL.modifiedon is NULL then 
		(Select P.modifiedon from NEPTUNIA_MSCRM.dbo.Role P where P.roleid = ROL.parentroleid)
	 else ROL.modifiedon
	end as modifiedon
from NEPTUNIA_MSCRM.dbo.Role as ROL
WHERE ROL.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_UBIGEO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_UBIGEO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_UBIGEO
  Descripcion Vista    : Copia al stage los campos de la Entidad Ubigeo
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_UBIGEO
=============================================================================*/   
AS
SELECT
	UBI.nep_ubigeoid,
	UBI.nep_codubigeo,
	UBI.nep_departamento,
	UBI.nep_distrito,
	UBI.nep_provincia,
	UBI.nep_name,
	UBI.modifiedby,
	UBI.modifiedbyname,
	UBI.modifiedon 
FROM Neptunia_MSCRM.dbo.Nep_ubigeo AS UBI
WHERE UBI.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_UNIDADNEGOCIO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_UNIDADNEGOCIO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_UNIDADNEGOCIO
  Descripcion Vista    : Copia al stage los campos de la Entidad Nivel Tarifario
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_UNIDADNEGOCIO
=============================================================================*/   
AS
SELECT
UN.nep_unidaddenegociounidadnegocioid,
UN.nep_unidaddenegociounidadnegocioidname,
UN.nep_unidadnegocioid,
UN.nep_name as unidadnegocioname,
UN.nep_iniciales as unidadnegocioiniciales,
UN.nep_CodigoOFISIS as codigoofisis,
UN.modifiedby,
UN.modifiedbyname,
UN.modifiedon 
FROM Neptunia_MSCRM.dbo.Nep_unidadnegocio as UN
WHERE UN.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_UNIDADNEGOCIO_USUARIO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_UNIDADNEGOCIO_USUARIO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_UNIDADNEGOCIO_USUARIO
  Descripcion Vista    : Copia al stage los campos de la Relacion Unidad de Negocio Usuario
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_UNIDADNEGOCIO_USUARIO
=============================================================================*/   
AS
SELECT
UNSU.nep_nep_unidadnegocio_systemuserid,
UNSU.nep_unidadnegocioid,
UNSU.systemuserid
FROM NEPTUNIA_MSCRM.dbo.nep_nep_unidadnegocio_systemuser AS UNSU
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_USUARIO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_USUARIO]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_USUARIO
  Descripcion Vista    : Copia al stage los campos de la Entidad Usuario
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_USUARIO
=============================================================================*/   
AS
SELECT
US.systemuserid,
US.fullname,
US.domainname,
US.address1_line1,
US.address1_stateorprovince,
US.address1_telephone1,
US.internalemailaddress,
US.nickname,
US.businessunitid,
US.parentsystemuserid,
US.parentsystemuseridname,
US.isdisabled,
SMP.Value as isdisabledname,
US.modifiedby,
US.modifiedbyname,
US.modifiedon
FROM NEPTUNIA_MSCRM.dbo.SystemUser US
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMP ON (US.isdisabled = SMP.AttributeValue AND SMP.AttributeName = 'isdisabled' and SMP.ObjectTypeCode = 8)  
WHERE US.DeletionStateCode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_USUARIO_ROL]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_USUARIO_ROL]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_USUARIO_ROL
  Descripcion Vista    : Copia al stage los campos de la Relacion Usuario Rol
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_USUARIO_ROL
=============================================================================*/   
AS
SELECT
USUROL.systemuserroleid,
USUROL.roleid,
USUROL.systemuserid
FROM NEPTUNIA_MSCRM.dbo.SystemUserRoles AS USUROL
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  View [dbo].[VWBI_VISITA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VWBI_VISITA]
/*=============================================================================    
  Empresa     	       : GESFOR OSMOS
  Cliente     	       : NEPTUNIA    
  Sistema              : Sistema de Gestion Comercial
  Módulo               : BI - Analisis Comercial       
  Nombre Vista         : VWBI_VISITA
  Descripcion Vista    : Copia al stage los campos de la Entidad Visita
  Desarrollado por     : Yesenia Quispe   
  Fecha Creacion       : 01/03/2010    
  Base Datos           : SQL Server 2005    
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación : 
------------------------------------------------------------------------------        
  Modificado por       : 
  Fecha Modificación   : 
  Detalle Modificación :         
------------------------------------------------------------------------------      
 Select top 100 * from VWBI_VISITA
=============================================================================*/   
AS
SELECT
	CIT.activityid,
	CIT.subject,
	CIT.description,
	CIT.location,
	CIT.createdon,
	CIT.scheduleddurationminutes,
	CIT.scheduledend,
	CIT.scheduledstart,
	CIT.actualdurationminutes,
	CIT.actualend,
	CIT.actualstart,
	--,nep_estadodevisita
	--,nep_estadodevisitaname
	CIT.nep_tipodevisita,
	SMPTV.Value as nep_tipodevisitaname,
	CIT.statecode,
	SMPST.Value as statecodename,
	CIT.statuscode,
	SMPSC.Value as statuscodename,
	CIT.nep_unidaddenegocioid,
	CIT.nep_unidaddenegocioidname,
	CIT.owningbusinessunit,
	CIT.regardingobjectid,
	CIT.regardingobjectidname,
	CIT.regardingobjecttypecode,
	CIT.ownerid,
	CIT.modifiedby,
	CIT.modifiedbyname,
	CIT.modifiedon
FROM NEPTUNIA_MSCRM.dbo.Appointment CIT
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPTV ON (CIT.nep_tipodevisita = SMPTV.AttributeValue AND SMPTV.AttributeName = 'nep_tipodevisita' and SMPTV.ObjectTypeCode = 4201)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPST ON (CIT.statecode = SMPST.AttributeValue AND SMPST.AttributeName = 'statecode' and SMPST.ObjectTypeCode = 4201)  
LEFT OUTER JOIN NEPTUNIA_MSCRM.dbo.StringMap SMPSC ON (CIT.statuscode = SMPSC.AttributeValue AND SMPSC.AttributeName = 'statuscode' and SMPSC.ObjectTypeCode = 4201)  
WHERE CIT.deletionstatecode = 0
/*-------------------------------------FIN-----------------------------------*/

GO
/****** Object:  StoredProcedure [dbo].[CRM_CasosFacturaCRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                                
Obj. : Casos con factura asociada        
Autor: GOS(YQM)                                
Fecha: 09/09/2009                                
BD   : EXTENSION_CRM                                
**********************************************************/
-- CRM_CasosFacturaCRM 'F137-0000023795'  --CAS-11989-T549FP, CAS-11988-L6ZMNY,       
-- CRM_CasosFacturaCRM '0137-0000023795'  --CAS-11989-T549FP, CAS-11988-L6ZMNY,       
ALTER PROCEDURE [dbo].[CRM_CasosFacturaCRM] @NUMFACTURA NVARCHAR(15)
AS
DECLARE @NUMFACTURA_ NVARCHAR(15)

--SET @NUMFACTURA = '0137-0000023795'
SET @NUMFACTURA_ = SUBSTRING(@NUMFACTURA, 2, 16)

--SELECT @NUMFACTURA

DECLARE @Caso VARCHAR(1000)

SET @Caso = ''

SELECT @Caso = CAS.TicketNumber + ', ' + @Caso
FROM Neptunia_MSCRM.dbo.nep_facturaasociadaalcaso FAC
INNER JOIN Neptunia_MSCRM.dbo.incident CAS ON CAS.incidentid = FAC.nep_casoid
WHERE (
		FAC.deletionstatecode = 0
		AND FAC.statecode = 0
		)
	AND SUBSTRING(FAC.nep_nrofactura, 2, 16) LIKE @NUMFACTURA_
	AND CAS.Nep_MotivodeCancelacin IS NULL
GROUP BY CAS.TicketNumber

SELECT @Caso
GO
/****** Object:  StoredProcedure [dbo].[CRM_EventoPostCreateCotizacion]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PRODUCCION  
  
--CRM_EventoPostCreateCotizacion '{EB717A5F-E529-DE11-B058-0050568B6497}'  
ALTER PROCEDURE [dbo].[CRM_EventoPostCreateCotizacion]    
@IdCotizacion UNIQUEIDENTIFIER    
AS
--Contener la Logica de Crear el Secuencial de la Cotizacion  
--Actualizar ese campo en la cotizacion  
--Retornar el Valor Creado  
  
DECLARE @AnioUltimo  DATETIME  
DECLARE @AnioActual  DATETIME  
  
SELECT @AnioUltimo = ISNULL(MAX(CreatedOn), GETDATE()), @AnioActual = GETDATE()   
FROM Neptunia_MSCRM.dbo.quote   
WHERE DeletionStateCode <> 2  
--and quoteid <> @IdCotizacion  
  
DECLARE @correlativo varchar(4)  
  
IF YEAR(@AnioUltimo) <> YEAR(@AnioActual) OR ( ( SELECT COUNT(*) FROM Neptunia_MSCRM.dbo.quote WHERE DeletionStateCode <> 2 ) = 1 )  
BEGIN  
 SET @correlativo = '0001'  
END  
ELSE  
BEGIN   
 DECLARE @cantidad   INT  
 DECLARE @ultimocorrelativo  VARCHAR(25)  
  
 --SELECT @ultimocorrelativo = SUBSTRING(NEP_CORRELATIVO, CHARINDEX('-',NEP_CORRELATIVO) + 1,5)   
 --FROM Neptunia_MSCRM.dbo.quote WHERE CreatedOn = @AnioUltimo and NEP_CORRELATIVO is not null  

-- SELECT top 1 @ultimocorrelativo =SUBSTRING(NEP_CORRELATIVO, CHARINDEX('-',NEP_CORRELATIVO) + 1,5)     
-- FROM Neptunia_MSCRM.dbo.quote   
-- WHERE NEP_CORRELATIVO is not null    
-- order by CreatedOn desc, NEP_CORRELATIVO   

 SELECT @ultimocorrelativo=SUBSTRING(NEP_CORRELATIVO, CHARINDEX('-',NEP_CORRELATIVO) + 1,5)     
 FROM Neptunia_MSCRM.dbo.quote   
 WHERE CreatedOn = (select max(createdOn) FROM Neptunia_MSCRM.dbo.quote where NEP_CORRELATIVO is not null and nep_cotizacionheredadaid is null)
 order by CreatedOn desc, NEP_CORRELATIVO   
 
 DECLARE @correlativoInt  INT  
 SET  @correlativoInt = CONVERT(INT,@ultimocorrelativo) + 1  
   
 SET  @correlativo = REPLICATE('0', 4 - LEN(@correlativoInt))   
  
 SET  @correlativo = @correlativo + CONVERT(VARCHAR,@correlativoInt)  
  
END  
  
DECLARE @NroCorrelativo VARCHAR(30)  
  
--Unidad de Negocio = Centro de Distribucion  
IF ((SELECT nep_unidadnegociooportunidadid FROM Neptunia_MSCRM.dbo.OPPORTUNITY WHERE opportunityId = @IdCotizacion) = '704FF08D-A04B-DE11-9E86-0050568B2462')  
BEGIN  
 SELECT @NroCorrelativo = UN.nep_iniciales + CASE Cop.nep_iniciales WHEN '-' THEN '' ELSE Cop.nep_iniciales END + ' - ' + @correlativo + ' - ' + [user].nickname + ' - ' + RIGHT(CONVERT(VARCHAR,YEAR(GETDATE())),2)  
 FROM Neptunia_MSCRM.dbo.OPPORTUNITY [cot]  
 JOIN Neptunia_MSCRM.dbo.systemuser [user] ON [cot].nep_responsableoportunidadId = [user].systemuserid  
 JOIN Neptunia_MSCRM.dbo.nep_unidadnegocio UN on [cot].nep_unidadnegociooportunidadid = UN.nep_unidadnegocioid  
 JOIN Neptunia_MSCRM.dbo.nep_conceptoun Cop on [Cot].nep_conceptounoportunidadid = Cop.nep_conceptounid  
 WHERE opportunityId = @IdCotizacion  
END  
  
ELSE --Unidad de Negocio = Resto  
BEGIN  
 SELECT @NroCorrelativo = UN.nep_iniciales + CASE Cop.nep_iniciales WHEN '-' THEN '' ELSE Cop.nep_iniciales END + ' - ' + @correlativo + ' - ' + [user].nickname + ' - ' + RIGHT(CONVERT(VARCHAR,YEAR(GETDATE())),2)  
 FROM Neptunia_MSCRM.dbo.OPPORTUNITY [cot]  
 JOIN Neptunia_MSCRM.dbo.systemuser [user] ON [cot].ownerid = [user].systemuserid  
 JOIN Neptunia_MSCRM.dbo.nep_unidadnegocio UN on [cot].nep_unidadnegociooportunidadid = UN.nep_unidadnegocioid  
 JOIN Neptunia_MSCRM.dbo.nep_conceptoun Cop on [Cot].nep_conceptounoportunidadid = Cop.nep_conceptounid  
 WHERE opportunityId = @IdCotizacion  
END  
  
SELECT @NroCorrelativo AS [Correlativo]
GO
/****** Object:  StoredProcedure [dbo].[CRM_EventoPostCreateRucCliente]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CRM_EventoPostCreateRucCliente]  

AS  

DECLARE @correlativo varchar(5)

IF(( SELECT COUNT(*) FROM Neptunia_MSCRM.dbo.account WHERE DeletionStateCode <> 2 and AccountNumber like 'CRM%') = 0 )
BEGIN
	SET @correlativo = '00001'
END
ELSE
BEGIN 
	DECLARE @cantidad			INT
	DECLARE @ultimocorrelativo  VARCHAR(5)

	SELECT	@ultimocorrelativo = SUBSTRING(ACCOUNTNUMBER, CHARINDEX('M',ACCOUNTNUMBER) + 1,5) FROM Neptunia_MSCRM.dbo.account 
	WHERE DeletionStateCode <> 2 and AccountNumber like 'CRM%'

	DECLARE	@correlativoInt		INT
	SET		@correlativoInt = CONVERT(INT,@ultimocorrelativo) + 1
	
	SET		@correlativo = REPLICATE('0', 5 - LEN(@correlativoInt))

	SET		@correlativo = @correlativo + CONVERT(VARCHAR,@correlativoInt)

END

DECLARE	@NroCorrelativo	VARCHAR(8)

SET @NroCorrelativo = 'CRM' + @correlativo

SELECT	@NroCorrelativo	AS	[Correlativo]
GO
/****** Object:  StoredProcedure [dbo].[CRM_ImputableaxCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                            
Obj. : Imputable por casos    
Autor: VECA                            
Fecha: 12/12/2011                            
BD   : EXTENSION_CRM                            
**********************************************************/ 
--prueba: CRM_ImputableaxCaso null,null,null,null,null,null,'portuario'
ALTER PROCEDURE [dbo].[CRM_ImputableaxCaso]
@Cliente Varchar(150),
@MotivoPadre Varchar(30),
@UnidadNegocio varchar(100),
@Imputable int,
@FechaInicio datetime,
@FechaFin datetime,
@Division varchar(50)

as
BEGIN

--DECLARE @Cliente Varchar(150)
--DECLARE @MotivoPadre Varchar(30)
--DECLARE @UnidadNegocio varchar(100)
--DECLARE @FechaInicio datetime
--DECLARE @FechaFin datetime
--DECLARE @Imputable int


--SET  @Cliente =null
--SET @MotivoPadre=NULL
--SET @UnidadNegocio=NULL
--SET  @FechaInicio =null
--SET @FechaFin =null
--SET @Imputable=null

DECLARE @IMPUTABLEPORCASO TABLE (

Cliente varchar(150),
NumeroCaso varchar(15),
MotivoPadre varchar(30),
UnidadNegocio varchar(100),
CodImputable int ,
NombreImputable varchar(50),
FechaCreacion datetime,
owneridyominame varchar(50),
NombreEstado varchar(200),
NombreSegmento varchar(200),
division varchar(50)

) 
--DECLARE UNA TIPO TABLA DEL STATUS Y segmento 
DECLARE @Estado TABLE (
CodEstado int ,
NombreEstado varchar(50)
)

DECLARE @Segmento TABLE (
CodSegmento int ,
NombreSegmento varchar(50)
)

IF (@UnidadNegocio='TODOS')
BEGIN 
SET @UnidadNegocio=NULL
END

IF (@MotivoPadre='TODOS')
BEGIN 
SET @MotivoPadre=NULL
END
IF (@Cliente='')
BEGIN 
SET @Cliente=NULL
END

IF (@MotivoPadre='')
BEGIN 
SET @MotivoPadre=NULL
END

IF (@UnidadNegocio='')
BEGIN 
SET @UnidadNegocio=NULL
END

IF (@Imputable=99)
BEGIN 
SET @Imputable=NULL
END

IF (@Division='TODOS')
BEGIN 
SET @Division=NULL
END

--INSERTAR datos de statuscode y segmento
INSERT @Estado(
CodEstado,
NombreEstado
)
 select  AttributeValue ,Value  from Neptunia_MSCRM.dbo.stringmap
 where Attributename='statuscode' and objecttypecode=112
INSERT @Segmento
(CodSegmento,
NombreSegmento) 
 select AttributeValue ,Value  from Neptunia_MSCRM.dbo.stringmap
 where Attributename='nep_segmento' and objecttypecode=112

INSERT @IMPUTABLEPORCASO(Cliente,
NumeroCaso,
MotivoPadre,
UnidadNegocio,
CodImputable,
NombreImputable,
FechaCreacion,
owneridyominame,
NombreEstado,
NombreSegmento,
division)

select i.AccountIdName Cliente,
substring(i.ticketnumber,1,9) as NumeroCaso,
i.nep_motivopadre as MotivoPadre,
i.nep_unidaddenegocioidName as UnidadNegocio, 
case when i.nep_imputable>=1 then i.nep_imputable
else 0 end as CodImputable,
case i.nep_imputable 
when 1 then 'Cliente'
when 2 then 'Neptunia'
when 3 then 'Linea'
else 'No Definido' end as NombreImputable,
i.CreatedOn as FechaCreacion,
i.owneridyominame as PropietarioCaso,
--i.statuscode as EstadoCaso,
--i.nep_segmento as Segmento,
MAPstatus.NombreEstado,
MAPsegmento.NombreSegmento,
u.nep_unidaddenegociounidadnegocioidname

from Neptunia_MSCRM.dbo.incident i
inner join @Estado MAPstatus on i.statuscode=MAPstatus.CodEstado
inner join @Segmento MAPsegmento on i.nep_segmento=MAPsegmento.CodSegmento
--select i.incidentid,i.nep_unidaddenegocioid,i.nep_unidaddenegocioidname,u.nep_unidaddenegociounidadnegocioidname, * from incident i 
inner join  Neptunia_MSCRM.dbo.nep_unidadnegocio u on i.nep_unidaddenegocioid = u.nep_unidadnegocioid 
--inner join Neptunia_MSCRM.dbo.nep_UnidadNegocio un on (un.nep_unidadnegocioid = i.nep_unidaddenegocioid)
--inner join Neptunia_MSCRM.dbo.BusinessUnit as b on (b.businessunitid=un.nep_unidaddenegociounidadnegocioid)

where i.DELETIONSTATECODE <> 2 

--and u.nep_unidadnegocioid=u.nep_unidaddenegociounidadnegocioidname
and (@FechaInicio is null or i.CreatedOn>=@FechaInicio)
and (@FechaFin is null or i.CreatedOn<=@FechaFin)
and (@Division is null or u.nep_unidaddenegociounidadnegocioidname=@Division)

SELECT  
A.Cliente,
A.NumeroCaso,
A.MotivoPadre,
A.UnidadNegocio,
A.NombreImputable,
A.owneridyominame,
A.NombreEstado,
A.NombreSegmento,
G.CODIMPUTABLE,
G. NUMEROPORIMPUTABLE,

(SELECT 
COUNT(T.CodImputable) NUMEROPORIMPUTABLETOTAL
FROM  @IMPUTABLEPORCASO T) NUMEROPORIMPUTABLETOTAL,

FechaCreacion,
a.division

FROM @IMPUTABLEPORCASO A

INNER JOIN (SELECT T.CODIMPUTABLE
,COUNT(T.CodImputable) NUMEROPORIMPUTABLE
FROM  @IMPUTABLEPORCASO T
GROUP  BY  T.CodImputable
) G ON A.CODIMPUTABLE=G.CODIMPUTABLE
WHERE 
(@Cliente is null or A.Cliente like '%'+@Cliente+'%')
and (@MotivoPadre is null or A.MotivoPadre =@MotivoPadre)
and (@UnidadNegocio is null or A.UnidadNegocio =@UnidadNegocio)
and (@Imputable is null or G.CODIMPUTABLE =@Imputable)
and (@FechaInicio is null or FechaCreacion>=@FechaInicio)
and (@FechaFin is null or FechaCreacion<=@FechaFin)


END
GO
/****** Object:  StoredProcedure [dbo].[CRM_IndicadorexCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                            
Obj. : Indicadores por caso    
Autor: VECA                            
Fecha: 12/12/2011                            
BD   : EXTENSION_CRM                            
**********************************************************/ 
--   CRM_IndicadorexCaso null,null,null,'20111201','20111231',null,'PORTUARIO'
ALTER PROCEDURE [dbo].[CRM_IndicadorexCaso]
@Cliente Varchar(150),
@MotivoPadre Varchar(30),
@UnidadNegocio varchar(100),
@FechaInicio datetime,
@FechaFin datetime,
@Imputable int,
@Division varchar(50)
as
BEGIN


IF (@UnidadNegocio='TODOS')
BEGIN 
SET @UnidadNegocio=NULL
END

IF (@Cliente='')
BEGIN 
SET @Cliente=NULL
END

IF (@MotivoPadre='')
BEGIN 
SET @MotivoPadre=NULL
END


IF (@Division='TODOS')
BEGIN 
SET @Division=NULL
END

IF (@UnidadNegocio='')
BEGIN 
SET @UnidadNegocio=NULL
END

IF (@Imputable='')
BEGIN 
SET @Imputable=NULL
END

IF (@Division='')
BEGIN 
SET @Division=NULL
END

IF (@Imputable=99)
BEGIN 
SET @Imputable=NULL
END

declare @cont0 int
declare @cont1 int
declare @cont2 int
declare @cont3 int
declare @cont4 int

declare @indicador table(
numerocaso varchar(20),
nombrecliente varchar(200),
unidadnegocio varchar(50),
fechacreacion datetime,
fechaaprobacion datetime,
fechacierre datetime,
motivopadre varchar(30),
fechaaprobcontable datetime null,--fechafinContingencia
fechafinanalizardev datetime null,
fechafinevalreclamo datetime null,
fechafinregacciones datetime null,
fechafinAprobAnalisis datetime null,
--fechafinContingencia datetime null,
fechafinCreacionNC datetime null,
fechafinEntregaNC datetime null,
fechafinAprobAcciones datetime null,
imputable varchar(50),
division varchar(50)
)

---------- Para a creacion de la tabla temporal de Actividades
declare @actividades table (
tipoactividad int,
fechafinal datetime,
idreclamo uniqueidentifier,
creacion datetime
)
insert into @actividades
select 
case 
when substring(subject,1,31)= 'Analizar importe de devolucion' then 1
when substring(subject,1,15)='Evaluar reclamo' then 2
when substring(subject,1,30)= 'Registrar Acciones Correctivas' then 3
when (substring(subject,1,42)= 'Aprobar analisis de importe de Devolucion' or substring(subject,1,43)= 'Aprobar analisis del importe de Devolucion') then 4
when (substring(subject,1,15)= 'Indicar si Caso' or substring(subject,1,28)= 'Indicar si el reclamo genera')  then 5
when substring(subject,1,22)= 'Emitir nota de Credito' or substring(subject,1,34)='Registrar Fecha de entrega de Nota' then 6
when substring(subject,1,25)= 'Confirmar entrega de Nota' then 7
when substring(subject,1,28)= 'Aprobar acciones Correctivas' then 8
else 0 end,
actualend,
regardingObjectId,
createdon
from 
neptunia_mscrm.dbo.ActivityPointerBase
where activitytypecode=4212
and createdon>@fechainicio
and actualend is not null
delete from @actividades where tipoactividad=0

--query principal de datos

insert into @indicador
SELECT  
substring(i.ticketnumber,1,9), 
i.AccountIdName, 
i.nep_unidaddenegocioidName, 
CONVERT(VARCHAR(23),i.CreatedOn,121), 
CONVERT(VARCHAR(23),i.Nep_Fechadeaprobacion,121), 
CONVERT(VARCHAR(23),ir.ActualEnd,121), i.Nep_MotivoPadre,
--(select top 1 actualend from Neptunia_MSCRM.dbo.task as t where i.IncidentId=t.regardingobjectid and subject like 'indicar si el reclamo%' order by createdon desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=5 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=1 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=2 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=3 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=4 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=6 order by creacion desc),
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=7 order by creacion desc),
--i.nep_fechaentreganotadecredito,
(select top 1 fechafinal from @actividades a where a.idreclamo=i.IncidentId and tipoactividad=8 order by creacion desc),
case 
when i.nep_imputable =1 then 'Cliente'
when i.nep_imputable =2 then 'Neptunia'
when i.nep_imputable =3 then 'Linea'
else 'No Definido' end as NombreImputable,
u.nep_unidaddenegociounidadnegocioidname
--b.name

--case 
--when b.businessunitid =DFFC34EE-0F4B-DE11-9E86-0050568B2462 then 'LOGISTICA'
--when b.businessunitid =E0FC34EE-0F4B-DE11-9E86-0050568B2462 then 'Neptunia'
--when b.businessunitid =04D3A8DF-9278-DE11-A074-0050568B2462 then 'Linea'
--else 'No Definido' end as NombreImputable

FROM         
Neptunia_MSCRM.dbo.Incident AS i 
INNER JOIN Neptunia_MSCRM.dbo.IncidentResolution AS ir ON i.IncidentId = ir.IncidentId
inner join  Neptunia_MSCRM.dbo.nep_unidadnegocio u on i.nep_unidaddenegocioid = u.nep_unidadnegocioid 
--inner join Neptunia_MSCRM.dbo.nep_UnidadNegocio un on (un.nep_unidadnegocioid = i.nep_unidaddenegocioid)
--inner join Neptunia_MSCRM.dbo.BusinessUnit as b on (b.businessunitid=un.nep_unidaddenegociounidadnegocioid)

WHERE     (i.StateCode = '1') AND (I.DELETIONSTATECODE <> 2) AND ( I.STATUSCODE!=200000) 
--and i.owningbusinessunit='b.name'
and (@Cliente is null or i.AccountIdName like '%'+@Cliente+'%')
and (@MotivoPadre is null or i.Nep_MotivoPadre =@MotivoPadre)
and (@UnidadNegocio is null or i.nep_unidaddenegocioidName =@UnidadNegocio)
and (@FechaInicio is null or i.CreatedOn>=@FechaInicio)
and (@FechaFin is null or i.CreatedOn<=@FechaFin)
and (@Imputable is null or i.nep_imputable =@Imputable)
and (@Division is null or u.nep_unidaddenegociounidadnegocioidname=@Division)



--select @cont0=case when count(fechacreacion)=0 then 1 else count(fechacreacion) end from @indicador
select @cont1=case when count(fechacierre)=0 then 1 else count(fechacierre) end from @indicador where fechacierre is not null
select @cont2=case when count(fechaaprobacion)=0 then 1 else count(fechaaprobacion) end from @indicador where fechaaprobacion is not null
select @cont3=case when count(fechaaprobcontable)=0 then 1 else count(fechaaprobcontable) end from @indicador where fechaaprobcontable is not null
select @cont4=case when count(fechafinEntregaNC)=0 then 1 else count(fechaaprobcontable) end from @indicador where fechafinEntregaNC is not null

--print @cont1


select 
nombrecliente,
numerocaso,
motivopadre,
unidadnegocio,

case when CONVERT(DECIMAL(10,3),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechacierre),0),121)) >0 then  
ROUND(CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechacierre),0),121))*1.0/@cont1,4)
when CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechacierre),0),121)) =0
and CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechacierre),0),121)) >0
then  ROUND(((CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechacierre),0),121))*1.0)/@cont1)/24,4)
when CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechacierre),0),121) =0 and 
CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechacierre),0),121)=0 then 0.04
end as ITAR,--fechacreacion,fechacierre,datediff(minute,fechacreacion,fechacierre),datediff(hour,fechacreacion,fechacierre),datediff(day,fechacreacion,fechacierre),
--diferencia de fechas para el itar
case 
when datediff(minute,fechacreacion,fechacierre)<60 then 0.04
when datediff(hour,fechacreacion,fechacierre)<24 then convert(decimal(10,3),datediff(hour,fechacreacion,fechacierre))/24
else datediff(day,fechacreacion,fechacierre) end
ITARfecha,

case when CONVERT(DECIMAL(10,3),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechaaprobacion),0),121)) >0 then  
ROUND(CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechaaprobacion),0),121))*1.0/@cont2,4)
when CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechaaprobacion),0),121)) =0
and CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechaaprobacion),0),121)) >0
then  ROUND(((CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechaaprobacion),0),121))*1.0)/@cont2)/24,4)
when CONVERT(VARCHAR(23),isnull(datediff(day,fechacreacion,fechaaprobacion),0),121) =0 and 
CONVERT(VARCHAR(23),isnull(datediff(hour,fechacreacion,fechaaprobacion),0),121)=0 then 0.04
end as ITAPR,--fechacreacion,fechaaprobacion,
--diferencia de fechas para el itapr
case 
when datediff(minute,fechacreacion,fechaaprobacion)<60 then 0.04
when datediff(hour,fechacreacion,fechaaprobacion)<24 then convert(decimal(10,3),datediff(hour,fechacreacion,fechaaprobacion))/24
else datediff(day,fechacreacion,fechaaprobacion) end
ITAPRfecha,fechacreacion,fechaaprobacion,


case when CONVERT(DECIMAL(10,3),CONVERT(VARCHAR(23),isnull(datediff(day,fechaaprobacion,fechaaprobcontable),121))) >0 then  
ROUND(CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechaaprobacion,fechaaprobcontable),121)))*1.0/@cont3,4)
when CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(day,fechaaprobacion,fechaaprobcontable),121))) =0
and CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechaaprobacion,fechaaprobcontable),121))) >0
then  ROUND(((CONVERT(DECIMAL(10,4),CONVERT(VARCHAR(23),isnull(datediff(hour,fechaaprobacion,fechaaprobcontable),121)))*1.0)/@cont3)/24,4)
when CONVERT(VARCHAR(23),isnull(datediff(day,fechaaprobacion,fechaaprobcontable),121)) =0 and 
CONVERT(VARCHAR(23),isnull(datediff(hour,fechaaprobacion,fechaaprobcontable),121))=0 then 0.04
end as ITACR,
--diferencia de fechas para el ITACR
case 
when datediff(minute,fechaaprobacion,fechaaprobcontable)<60 then 0.04
when datediff(hour,fechaaprobacion,fechaaprobcontable)<24 then convert(decimal(10,3),datediff(hour,fechaaprobacion,fechaaprobcontable))/24
else datediff(day,fechaaprobacion,fechaaprobcontable) end
ITACRfecha,
case 
when (datediff(minute,fechacreacion,fechafinanalizardev)<60 and motivoPadre='Facturacion') then 0.04
when (datediff(hour,fechacreacion,fechafinanalizardev)<24  and motivoPadre='Facturacion') then (datediff(hour,fechacreacion,fechafinanalizardev)*1.0)/@cont1/24
when motivoPadre='Facturacion' then (datediff(day,fechacreacion,fechafinanalizardev)*1.0)/@cont1 
when (datediff(minute,fechafinevalreclamo,fechafinregacciones)<60 and motivoPadre!='Facturacion') then 0.04
when (datediff(hour,fechafinevalreclamo,fechafinregacciones)<24  and motivoPadre!='Facturacion') then (datediff(hour,fechacreacion,fechafinregacciones)*1.0)/@cont1/24
when motivoPadre!='Facturacion' then (datediff(day,fechafinevalreclamo,fechafinregacciones)*1.0)/@cont1
else 0 end
EVAN,
--diferencia de fechas para el EVAN
case 
when (datediff(minute,fechacreacion,fechafinanalizardev)<60 and motivoPadre='Facturacion') then 0.04
when (datediff(hour,fechacreacion,fechafinanalizardev)<24  and motivoPadre='Facturacion') then (datediff(hour,fechacreacion,fechafinanalizardev)*1.0)/24
when motivoPadre='Facturacion' then datediff(day,fechacreacion,fechafinanalizardev)
when (datediff(minute,fechafinevalreclamo,fechafinregacciones)<60 and motivoPadre!='Facturacion') then 0.04
when (datediff(hour,fechafinevalreclamo,fechafinregacciones)<24  and motivoPadre!='Facturacion') then (datediff(hour,fechacreacion,fechafinregacciones)*1.0)/24
when motivoPadre!='Facturacion' then datediff(day,fechafinevalreclamo,fechafinregacciones) 
else 0 end
EVANfecha,
case 
when (datediff(minute,fechafinanalizardev,fechafinAprobAnalisis)<60 and motivoPadre='Facturacion') then 0.04
when (datediff(hour,fechafinanalizardev,fechafinAprobAnalisis)<24 and motivoPadre='Facturacion') then (datediff(hour,fechafinanalizardev,fechafinAprobAnalisis)*1.0)/@cont1/24
when motivopadre='Facturacion' then (datediff(day,fechafinanalizardev,fechafinAprobAnalisis)*1.0)/@cont1 
when (datediff(minute,fechafinregacciones,fechafinAprobAcciones)<60 and motivoPadre!='Facturacion') then 0.04
when (datediff(hour,fechafinregacciones,fechafinAprobAcciones)<24 and motivoPadre!='Facturacion') then (datediff(hour,fechafinregacciones,fechafinAprobAcciones)*1.0)/@cont1/24
when motivopadre!='Facturacion' then (datediff(day,fechafinregacciones,fechafinAprobAcciones)*1.0)/@cont1 end
APROBACION,
case 
when (datediff(minute,fechafinanalizardev,fechafinAprobAnalisis)<60 and motivoPadre='Facturacion') then 0.04
when (datediff(hour,fechafinanalizardev,fechafinAprobAnalisis)<24 and motivoPadre='Facturacion') then (datediff(hour,fechafinanalizardev,fechafinAprobAnalisis)*1.0)/24
when motivopadre='Facturacion' then datediff(day,fechafinanalizardev,fechafinAprobAnalisis) 
when (datediff(minute,fechafinregacciones,fechafinAprobAcciones)<60 and motivoPadre!='Facturacion') then 0.04
when (datediff(hour,fechafinregacciones,fechafinAprobAcciones)<24 and motivoPadre!='Facturacion') then (datediff(hour,fechafinregacciones,fechafinAprobAcciones)*1.0)/24
when motivopadre!='Facturacion' then datediff(day,fechafinregacciones,fechafinAprobAcciones) end
APROBACIONfecha,
case 
when (datediff(minute,fechafinAprobAnalisis,fechaaprobcontable)<60) then 0.04
when (datediff(hour,fechafinAprobAnalisis,fechaaprobcontable)<24) then (datediff(hour,fechafinAprobAnalisis,fechaaprobcontable)*1.0)/@cont1/24
else (datediff(day,fechafinAprobAnalisis,fechaaprobcontable)*1.0)/@cont1 end
APROBCONT,
case 
when datediff(minute,fechafinAprobAnalisis,fechaaprobcontable)<60 then 0.04
when datediff(hour,fechafinAprobAnalisis,fechaaprobcontable)<24 then (datediff(hour,fechafinAprobAnalisis,fechaaprobcontable)*1.0)/24
else datediff(day,fechafinAprobAnalisis,fechaaprobcontable) end
APROBCONTfecha,
case 
when (datediff(minute,fechafinCreacionNC,fechafinEntregaNC)<60) then 0.04
when (datediff(hour,fechafinCreacionNC,fechafinEntregaNC)<24) then (datediff(hour,fechafinCreacionNC,fechafinEntregaNC)*1.0)/@cont1/24
else (datediff(day,fechafinCreacionNC,fechafinEntregaNC)*1.0)/@cont1 end
ENC,
case 
when datediff(minute,fechafinCreacionNC,fechafinEntregaNC)<60 then 0.04
when datediff(hour,fechafinCreacionNC,fechafinEntregaNC)<24 then (datediff(hour,fechafinCreacionNC,fechafinEntregaNC)*1.0)/24
else datediff(day,fechafinCreacionNC,fechafinEntregaNC) end
ENCfecha,
imputable,
division

from @indicador

END
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerCabeceraFacturaCRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************        
Obj. : Obtiene datos la cabecera de la factura  
Autor: GOS(YQM)        
Fecha: 09/09/2009        
BD   : EXTENSION_CRM        
**********************************************************/      
--CRM_ObtenerCabeceraFacturaCRM '5CD1B5AF-B89C-DE11-B160-0050568B306D'    
ALTER PROCEDURE [dbo].[CRM_ObtenerCabeceraFacturaCRM]    
@GUIDFACTURA nvarchar(36)    
AS    
SELECT    
 FAC.Nep_facturaasociadaalcasoid,    
 STM.Value,    
 FAC.OwnerId ,    
 FAC.nep_casoid    
FROM Neptunia_MSCRM..nep_facturaasociadaalcaso FAC    
LEFT JOIN Neptunia_MSCRM..stringmap STM ON (FAC.Nep_TipoMoneda=STM.Attributevalue AND STM.ObjectTypeCode=10000 AND STM.attributename='nep_tipomoneda')    
WHERE FAC.nep_facturaasociadaalcasoid=@GUIDFACTURA    
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                  
Obj. : Obtiene Datos de Caso de factura asociada          
Autor: GOS(YQM)                  
Fecha: 09/09/2009                  
BD   : EXTENSION_CRM                  
**********************************************************/                
--CRM_ObtenerCaso 'D292A9A2-B89C-DE11-B160-0050568B306D'          
ALTER PROCEDURE [dbo].[CRM_ObtenerCaso]              
@GUIDCASO nvarchar(36)              
as          
SELECT  STM.Value,     
    CAS.ownerid,    
    'nep_montototaldereclamoincigv'=isnull(CAS.nep_montototaldereclamoincigv,0),    
	'nep_montototaldereclamoincigv1'=isnull(CAS.nep_montototaldereclamoincigv1,0),    
    isnull(ACC.AccountNumber,'') AccountNumber,  
    case SUB.ParentSubjectName when 'Facturacion' then '1' else '0' end Facturacion  
FROM Neptunia_MSCRM..incident CAS          
LEFT JOIN Neptunia_MSCRM..stringmap STM ON (CAS.Nep_TipoMoneda=STM.Attributevalue AND STM.ObjectTypeCode=112 AND STM.attributename='nep_tipomoneda')          
LEFT JOIN Neptunia_MSCRM..accountbase ACC ON (ACC.AccountId = CAS.AccountId)    
LEFT JOIN Neptunia_MSCRM..subject SUB ON (SUB.subjectid = CAS.subjectid)  
WHERE CAS.incidentid = @GUIDCASO    
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerClientesMoneda]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************                
Obj. : Obtiene Clientes con o sin moneda alterna        
Autor: GOS(YQM)                
Fecha: 30/10/2010                
BD   : EXTENSION_CRM                
exec [dbo].[CRM_ObtenerClientesMoneda] 0
**********************************************************/     
ALTER PROCEDURE [dbo].[CRM_ObtenerClientesMoneda]  
    @SinMoneda as int
AS
BEGIN

  IF (@SinMoneda = 0) --Sin Moneda alterna
  BEGIN
     SELECT a.accountid, a.accountnumber, statuscode
     FROM Neptunia_MSCRM.dbo.account a
     LEFT JOIN Neptunia_MSCRM.dbo.nep_account_nep_monedaalterna m on (a.accountid = m.accountid) 
     WHERE m.accountid is null  and a.deletionstatecode <> 2 and statuscode=1
     --and a.transactioncurrencyid='513801D4-014B-DE11-B20B-0050568B2462'
  END
  ELSE
  BEGIN
     IF (@SinMoneda = 1) --Con Moneda Alterna
     BEGIN
        SELECT distinct a.accountid, a.accountnumber, statuscode
        FROM Neptunia_MSCRM.dbo.account a
        LEFT JOIN Neptunia_MSCRM.dbo.nep_account_nep_monedaalterna m on (a.accountid = m.accountid) 
        WHERE m.accountid is not null  and a.deletionstatecode <> 2 and statuscode=1
     END
  END
END
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerConceptosSoles]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                
Obj. : Obtiene conceptos con divisa en soles
Autor: GOS(YQM)                
Fecha: 30/10/2010                
BD   : EXTENSION_CRM                
exec [dbo].[CRM_ObtenerConceptosSoles]  
**********************************************************/     
ALTER PROCEDURE [dbo].[CRM_ObtenerConceptosSoles]  
AS
BEGIN
   SELECT
     nep_monedaalternaid
    ,nep_name
   FROM Neptunia_MSCRM.dbo.nep_monedaalterna
   WHERE nep_divisaId = '513801D4-014B-DE11-B20B-0050568B2462'
   AND deletionstatecode <> 2 and statuscode = 1
END
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerCotizacionCliente]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CRM_ObtenerCotizacionCliente]
@IdCliente	UNIQUEIDENTIFIER
AS
SELECT	'~/imgs/Acuerdos.gif'			AS [Imagen]
		,NEP_Correlativo				AS [CodCotizacion]
		,Nep_UnidadNegocioQuoteIdName	AS [UnidadNegocio]
		,Name
		,CONVERT(VARCHAR(10),EffectiveFrom,103)	AS [Desde]
		,CONVERT(VARCHAR(10),EffectiveTo,103)	AS [Hasta]
FROM	neptunia_mscrm.dbo.quote
WHERE	deletionstatecode <> 2 and statecode = 2 and statuscode = 4
		AND CustomerId = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerCotizacionClienteEstimacionFacturada]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--[CRM_ObtenerCotizacionClienteEstimacionFacturada] 'SIII - 0007 - ADM - 11'       
ALTER PROCEDURE [dbo].[CRM_ObtenerCotizacionClienteEstimacionFacturada]      
@NroCotizacion NVARCHAR(30)    
AS    
SELECT convert(varchar,A.Nep_FechaAceptacionCotizacion,112) AS NEP_FECHA_ACEP,    
--SELECT SUBSTRING(CONVERT(VARCHAR(16),A.Nep_FechaAceptacionCotizacion),8,4) AS NEP_FECHA_ACEP,    
A.Nep_EstimadoaFacturar,    
CASE WHEN A.Nep_AlertaporFacturacion IS NULL 
THEN 1 ELSE A.Nep_AlertaporFacturacion END AS Nep_AlertaporFacturacion,    
A.IDCONCEPTO,    
A.Ruc,    
B.COD_ORIGEN  ,  
A.QUOTEID  
 FROM  dbo.COTIZACIONALERTA A     
 INNER JOIN dbo.UNIDADNEGOCIOS B ON A.IDUN = B.ID_UN    
 WHERE NROCOTIZACION=@NroCotizacion    
--and IDESTADO=7    
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerCotizacionesAceptadas]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--[CRM_ObtenerCotizacionClienteEstimacionFacturada] 'SIII - 0007 - ADM - 11'       
ALTER PROCEDURE [dbo].[CRM_ObtenerCotizacionesAceptadas]      
  
AS  
DECLARE @FechaPase  DATETIME
  
SET @FechaPase='20110711'  -- Fecha del Pase a Produccion de Alerta de CRM   
SELECT NROCOTIZACION   
FROM dbo.CotizacionAlerta
WHERE idestado=7   
AND nrocotizacion is not null   
AND nep_fechaaceptacioncotizacion is not null  
AND nep_fechaaceptacioncotizacion >=@FechaPase
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerFacturasDelCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CRM_ObtenerFacturasDelCaso]    
@CASOID AS UNIQUEIDENTIFIER    
AS    
    
    
SELECT CAS.TicketNumber,FAC.nep_facturaasociadaalcasoid,FAC.Nep_NroFactura,FAC.Nep_SeRefactura    
FROM neptunia_mscrm.dbo.nep_facturaasociadaalcaso FAC    
INNER JOIN neptunia_mscrm.dbo.incident CAS ON FAC.nep_casoid =CAS.incidentid    
WHERE nep_casoid=@CASOID
and FAC.DeletionStateCode <> 2
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerFormatoMailCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                  
Obj. : Obtiene Datos de Caso de factura asociada          
Autor:                
Fecha:             
BD   : EXTENSION_CRM                  
**********************************************************/                
--CRM_ObtenerCaso 'D292A9A2-B89C-DE11-B160-0050568B306D' 
--CRM_ObtenerFormatoMailCaso '8F7FFADA-B823-426E-9EB9-2376B59D1B6F'         
ALTER PROCEDURE [dbo].[CRM_ObtenerFormatoMailCaso]              
@GUIDUSUARIO nvarchar(36)

as          
DECLARE @html varchar(max)
set @html='<table border="1">'
select  
@html=@html+'<tr><td>'+LTRIM(RTRIM(inc.ticketnumber))+'</td>',
@html=@html+'<td>'+LTRIM(RTRIM(cli.name))+'</td>',
@html=@html+'<td>'+convert(nvarchar(max),act.scheduledend)+'</td>',
@html=@html+'<td>'+LTRIM(RTRIM(seg.value))+'</td>',
@html=@html+'<td>'+LTRIM(RTRIM(act.subject))+'</td></tr>'

from neptunia_mscrm.dbo.ActivityPointerBase act
inner join neptunia_mscrm.dbo.Incident inc on (regardingObjectid=incidentid)
inner join neptunia_mscrm.dbo.AccountBase cli on (cli.accountid=inc.accountId)
inner join neptunia_mscrm.dbo.incidentextensionBase incex on (incex.incidentid=inc.incidentid)
inner join neptunia_mscrm.dbo.stringmap seg on (objecttypecode=112 and attributename='nep_segmento' and attributevalue=incex.nep_segmento)
where 
act.statecode=0
--and act.owningUser=@GUIDUSUARIO
set @html=@html+'</table>'
select @html as mensaje
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerIdNivelTarifario]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************  
Objetivo: Obtener GUID de Nivel Tarifario  
Autor: GOS(YQM)  
Fecha: 11/08/2009  
*****************************************************/  
ALTER PROCEDURE [dbo].[CRM_ObtenerIdNivelTarifario]  
@NT as char  
AS  
  
Select nep_niveltarifarioid  
From Neptunia_MSCRM.dbo.Nep_NivelTarifario  
Where substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)=@NT  
  
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerMonedaAlternaXCliente]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                
Obj. : Obtiene conceptos con divisa en soles
Autor: GOS(YQM)                
Fecha: 30/10/2010                
BD   : EXTENSION_CRM                
exec [dbo].[CRM_ObtenerMonedaAlternaXCliente] 'EC43C08A-2782-DE11-B160-0050568B306D'
**********************************************************/     
ALTER PROCEDURE [dbo].[CRM_ObtenerMonedaAlternaXCliente]  
  @IDCliente varchar(36)
AS
BEGIN
   SELECT nep_monedaalternaid
   FROM Neptunia_MSCRM.dbo.nep_account_nep_monedaalterna
   where accountid = @IDCliente
END
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerMotivoPadre]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************      
Objetivo: Obtener GUID del motivo padre    
Autor: GOS(YQM)      
Fecha: 11/08/2009      
*****************************************************/      
--CRM_ObtenerMotivoPadre '{D96D99EC-AA4B-DE11-9E86-0050568B2462}'    
ALTER PROCEDURE [dbo].[CRM_ObtenerMotivoPadre]    
@Motivo as nvarchar(100)    
AS      
      
Select ParentSubject    
From Neptunia_MSCRM.dbo.subject    
Where subjectid = @Motivo    
      
    
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerNumeroCaso]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                  
Obj. : Obtiene Caso de factura asociada          
Autor: GOS(YQM)                  
Fecha: 22/09/2009                  
BD   : EXTENSION_CRM                  
**********************************************************/                
--CRM_ObtenerNumeroCaso 'c6a4cf2a-b0a7-de11-84b3-005056a73a64'    
ALTER PROCEDURE [dbo].[CRM_ObtenerNumeroCaso]    
@IdFactura as UNIQUEIDENTIFIER    
AS    
BEGIN    
    
SELECT CAS.TicketNumber,FAC.Nep_NroFactura,FAC.Nep_SeRefactura  
FROM Neptunia_MSCRM.dbo.Nep_FacturaAsociadaAlCaso FAC    
INNER JOIN Neptunia_MSCRM.dbo.Incident CAS ON CAS.IncidentId = FAC.Nep_CasoId    
WHERE FAC.Nep_FacturaAsociadaAlCasoId = @IdFactura    
    
END
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerServiciosFactura]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                            
Obj. : Obtener servicios de factura            
Autor: GOS(YQM)                            
Fecha: 19/09/2009                            
BD   : EXTENSION_CRM                            
**********************************************************/                            
--CRM_ObtenerServiciosFactura '00F06B45-81AE-DE11-84B3-005056A73A64'            
ALTER PROCEDURE [dbo].[CRM_ObtenerServiciosFactura]            
@IdFactura UNIQUEIDENTIFIER            
AS            
BEGIN            
SELECT '~/imgs/ico_16_1080_d.gif'   AS [Imagen],          
 isnull(nep_descripcionservicio,'') as [NombreServicio],            
 --nep_Cantidad as [CantServicio],        
 isnull(nep_DescripcionUnidadNegocio,'') as [NomUNegocio],        
 isnull(nep_DescripcionLocalTienda,'') as [NomLocal],        
 nep_totalporlinea as [MontoFacturado],          
 --nep_Montoadevolver as [MontoDevolver]          
 nep_MontoCorrecto as [MontoCorrecto]          
FROM Neptunia_MSCRM.dbo.nep_detallefacturaasociadaalcaso            
WHERE Nep_Facturaasociadaalcasoid=@IdFactura            
END 
GO
/****** Object:  StoredProcedure [dbo].[CRM_ObtenerTipoCliente]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CRM_ObtenerTipoCliente]     
@RucCliente NVARCHAR(11)      
AS      
  
Declare @Numero INT  
  
Select @Numero=count(1)  
from Neptunia_MSCRM.dbo.AccountBase AB  
inner join Neptunia_MSCRM.dbo.AccountExtensionBase AEB  
on AB.AccountId = AEB.AccountId  
and LTRIM(RTRIM(AB.AccountNumber)) = @RucCliente --'20104420282'  
  
  
If @Numero > 0   
Begin  
 Select --AB.AccountNumber, AB.Name, Nep_Segmento,  
 @RucCliente as Ruc_Cliente ,  
 Case Nep_Segmento  
  When 1  then '2' --'VIP'  
  When 2  then '0' --'VIP'  
  When 3  then '1' --'Normal'  
  When 4  then '1' --'Normal'  
 End as Tipo_Cliente  
 from Neptunia_MSCRM.dbo.AccountBase AB  
 inner join Neptunia_MSCRM.dbo.AccountExtensionBase AEB  
 on AB.AccountId = AEB.AccountId  
 and LTRIM(RTRIM(AB.AccountNumber)) = @RucCliente --'20104420282'  
End  
else  
Begin   
-- Select @RucCliente as Ruc_Cliente, 'NULL' as Tipo_Cliente  
 Select @RucCliente as Ruc_Cliente, '1' as Tipo_Cliente  
End  
  
GO
/****** Object:  StoredProcedure [dbo].[CRM_TiempoAtencion]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                                
Obj. : Tiempo de atencion de tarea       
Autor: VECA                                
Fecha: 12/12/2011                                
BD   : EXTENSION_CRM                                
**********************************************************/     
--prueba: CRM_TiempoAtencion null,null,null,null,null,null,null,'2',null,null,null
ALTER PROCEDURE [dbo].[CRM_TiempoAtencion]    
    
@Cliente Varchar(150),    
@MotivoPadre Varchar(30),    
@UnidadNegocio varchar(100),    
@Caso varchar(50),    
@PropietarioCaso varchar(50),    
@PropietarioTarea varchar(50),    
@Sucursal int,    
@Imputabilidad int,    
@FechaInicio datetime,    
@FechaFin datetime,
@division varchar(50)    
    
as    
--pasar el valor null a TODOS    
IF (@MotivoPadre='TODOS')    
BEGIN     
SET @MotivoPadre=NULL    
END    
IF (@UnidadNegocio='TODOS')    
BEGIN     
SET @UnidadNegocio=NULL    
END    
IF (@PropietarioTarea='TODOS')    
BEGIN     
SET @PropietarioTarea=NULL    
END    
IF (@PropietarioCaso='TODOS')    
BEGIN     
SET @PropietarioCaso=NULL    
END    
IF (@Sucursal=0)    
BEGIN     
SET @Sucursal=NULL    
END    
--hacer que acepte valor 0 el null    
IF (@Cliente='')    
BEGIN     
SET @Cliente=NULL    
END    
    
IF (@MotivoPadre='')    
BEGIN     
SET @MotivoPadre=NULL    
END    
    
IF (@UnidadNegocio='')    
BEGIN     
SET @UnidadNegocio=NULL    
END    
    
IF (@Caso='')    
BEGIN     
SET @Caso=NULL    
END    
    
IF (@PropietarioCaso='')    
BEGIN     
SET @PropietarioCaso=NULL    
END    
    
IF (@PropietarioTarea='')    
BEGIN     
SET @PropietarioTarea=NULL    
END    

IF (@Imputabilidad=99)
BEGIN 
SET @Imputabilidad=NULL
END

IF (@Division='TODOS')
BEGIN 
SET @Division=NULL
END   
    
select     
t.accountidname,     
t.nep_sucursal,     
t.ticketnumber,    
CASE WHEN LEN(t.temahito)=0 THEN 'No Definido'    
ELSE T.TEMAHITO END AS TEMAHITO,    
t.OWNERIDNAME,    
--t.owneridyominame,    
--t.FechaCreacionHito,    
--t.nep_motivopadre,     
--t.nep_unidaddenegocioidname,    
case when t.duracion<0  then 0   
when t.duracion<1 and t.temahito like '%Indicar si el reclamo genera contingencia tributaria%' then 0  
--when t.duracion>=0 and t.duracion<1  then 1   
else t.duracion end as duracion,    
t.createdon,
t.NombreImputable,
t.divnombre    
FROM      
(SELECT  TSK.ACTIVITYID CodigoTemaHito,    
substring(CAS.TicketNumber,1,9) ticketnumber,    
--CAS.TicketNumber,         
CAS.CreatedOn FechaCreacionCaso,    
    
CASE         
CAS.statecode        
When 0 then 'Activo'         
When 1 then 'Resuelto'         
When 2 then 'Cancelado'         
else null         
END as [Estado],        
CASE CAS.statuscode        
When 1 then 'En curso'         
When 2 then 'Abierto'         
When 3 then 'Pendiente de aprobacin contable'         
When 4 then 'Observado'         
When 5 then 'Atendido'         
When 6 then 'Cancelado'         
When 200000 then 'Rechazado'         
When 200001 then 'No procede'         
When 200002 then 'Pendiente de cierre'         
When 200003 then 'Pendiente de aprobacin'         
When 200004 then 'Aprobado'         
When 200006 then 'Aprobado contablemente'         
When 200007 then 'Pendiente de aprobacin gerencial'         
When 200008 then 'Aprobado por gerencia'         
When 200009 then 'Apelado'         
When 200010 then 'Nota de crdito emitada'         
else null         
END as [RaznEstado],   
--case when CAS.nep_imputable>=1 then CAS.nep_imputable
--else 0 end as CodImputable,
case CAS.nep_imputable 
when 1 then 'Cliente'
when 2 then 'Neptunia'
when 3 then 'Linea'
else 'No Definido' end as NombreImputable,     
CAS.accountidname,     
MAP.Value as Nep_Sucursal,    
--CAS.nep_sucursal,      
CAS.nep_unidaddenegocioidname,          
CAS.nep_motivopadre, 
--CAS.nep_imputablea,       
CAS.subjectidname,     
CAS.owneridyominame,      
CASE WHEN len(TSK.subject)=0 then 'No Definido'    
ELSE substring(TSK.subject ,0 , charindex ('CAS-', TSK.subject)) END AS TemaHito,         
TSK.owneridname,         
CONVERT(VARCHAR(10), TSK.createdon, 103) as [FechaCreacionHito],       
CONVERT(VARCHAR(10), TSK.actualend, 103) as [FechaFinRealHito],       
(TSK.scheduleddurationminutes/60/24) as [DuracionProgramada],       
--DATEDIFF(day, TSK.createdon, TSK.actualend) AS Duracion ,    
case 
when datediff(minute,TSK.createdon,TSK.actualend)<60 then 0.04
when datediff(hour,TSK.createdon,TSK.actualend)<24 then convert(decimal(10,3),datediff(hour,TSK.createdon,TSK.actualend))/24
else datediff(day,TSK.createdon,TSK.actualend) end as Duracion,
u.nep_unidaddenegociounidadnegocioidname divnombre,
TSK.createdon    
    
from neptunia_mscrm.dbo.nep_facturaasociadaalcaso FAC         
INNER JOIN neptunia_mscrm.dbo.incident CAS ON FAC.nep_casoid =CAS.incidentid    
inner join neptunia_mscrm.dbo.stringmap MAP on CAS.nep_sucursal= MAP.attributevalue       
join neptunia_mscrm.dbo.account ACC on acc.accountid = cas.accountid        
join neptunia_mscrm.dbo.task TSK ON CAS.incidentid= TSK.regardingobjectid
inner join  Neptunia_MSCRM.dbo.nep_unidadnegocio u on CAS.nep_unidaddenegocioid = u.nep_unidadnegocioid 
--inner join Neptunia_MSCRM.dbo.nep_UnidadNegocio un on (un.nep_unidadnegocioid = CAS.nep_unidaddenegocioid)
--inner join Neptunia_MSCRM.dbo.BusinessUnit as b on (b.businessunitid=un.nep_unidaddenegociounidadnegocioid)
     
where FAC.DeletionStateCode <> 2         
AND tsk.DeletionStateCode <> 2       
and tsk.statecode = '1'
and CAS.DeletionStateCode <> 2
and CAS.statuscode='5'
--and cas.statecode='4' 
and (@Cliente is null or CAS.AccountIdName like '%'+@Cliente+'%')    
and (@MotivoPadre is null or CAS.Nep_MotivoPadre =@MotivoPadre)    
and (@UnidadNegocio is null or CAS.nep_unidaddenegocioidname =@UnidadNegocio)    
and (@Caso is null or substring(CAS.TicketNumber,1,9)  like '%'+@Caso+'%')    
and (@PropietarioCaso is null or CAS.owneridyominame =@PropietarioCaso)    
and (@PropietarioTarea is null or TSK.owneridname =@PropietarioTarea)    
and (@Sucursal is null or  Nep_Sucursal=@Sucursal)    
and (@Imputabilidad is null or CAS.nep_imputable =@Imputabilidad)    
and (@FechaInicio is null or CAS.CreatedOn>=@FechaInicio)    
and (@FechaFin is null or CAS.CreatedOn<=@FechaFin)    
and MAP.atTributename='nep_sucursal'
and (@Division is null or u.nep_unidaddenegociounidadnegocioidname=@Division)
    
) T    
--WHERE 
----T.CONTADORTAREAS=1     
 
group by     
t.accountidname,     
t.nep_sucursal,     
t.ticketnumber,    
t.temahito,    
t.duracion,    
t.OWNERIDNAME,    
--T.nep_motivopadre,    
--t.owneridyominame,    
--t.FechaCreacionHito,    
--t.nep_motivopadre,     
--t.nep_unidaddenegocioidname,    
--T.FECHACREACIONCASO,    
t.createdon,
T.NombreImputable,
divnombre
    
    
GO
/****** Object:  StoredProcedure [dbo].[CRM_VerificarDetalleFacturaCRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                            
Obj. : Verificar si la Factura buscada ya está asociada                  
       al caso.                      
Autor: GOS(YQM)                            
Fecha: 09/09/2009                            
BD   : EXTENSION_CRM                            
**********************************************************/                          
--CRM_VerificarDetalleFacturaCRM '0015-0000030987', 'D292A9A2-B89C-DE11-B160-0050568B306D'                  
ALTER PROCEDURE [dbo].[CRM_VerificarDetalleFacturaCRM]                        
@NUMFACTURA nvarchar(15),                      
@GUIDCASO nvarchar(36)                        
AS      
SELECT          
 DET.Nep_Ruc as RUCCODIGO,                    
 FAC.Nep_NroFactura as NUMDOCCOMPLETO,            
 DET.Nep_Cantidad as CANTIDADSERVICIO,                      
 isnull(DET.Nep_DescripcionServicio,'') as NOMSERVICIOOFISIS,                      
 isnull(DET.nep_descripcionunidadnegocio,'') as NOMUNIDADNEGOCIO,          
 isnull(DET.nep_descripcionlocaltienda,'') as NOMLOCALTIENDA,          
 DET.Nep_TotalPorLinea as TOTALPORLINEA,                      
 DET.Nep_Montocorrecto as MONTODEVOLVER,      
 CASE FAC.nep_serefactura WHEN 0 THEN (DET.Nep_TotalPorLinea - DET.Nep_Montocorrecto) ELSE DET.Nep_Montocorrecto END MONTOCORRECTODEVOLVER,       
 DET.Nep_AfectoImpuesto1 AFECTOIMP1,      
 DET.Nep_Impuesto1 IMPUESTO1,       
 CASE FAC.nep_serefactura WHEN 0     
 THEN CASE DET.Nep_AfectoImpuesto1     
      WHEN 'S' THEN ((DET.Nep_TotalPorLinea - DET.Nep_Montocorrecto) + (DET.Nep_TotalPorLinea - DET.Nep_Montocorrecto)* DET.Nep_Impuesto1/100)     
      ELSE (DET.Nep_TotalPorLinea - DET.Nep_Montocorrecto)     
      END    
 ELSE CASE DET.Nep_AfectoImpuesto1     
      WHEN 'S' THEN (DET.Nep_Montocorrecto + DET.Nep_Montocorrecto * DET.Nep_Impuesto1/100)    
      ELSE DET.Nep_Montocorrecto    
      END    
 END MONTOCORRECTODEVOLVERIGV,      
 FAC.nep_casoid,FAC.Nep_NroFactura                  
FROM Neptunia_MSCRM..nep_detallefacturaasociadaalcaso DET                  
INNER JOIN Neptunia_MSCRM..nep_facturaasociadaalcaso FAC ON FAC.nep_facturaasociadaalcasoid=DET.nep_facturaasociadaalcasoid                  
WHERE (FAC.deletionstatecode=0 and FAC.statecode = 0)       
 AND FAC.nep_casoid=@GUIDCASO AND FAC.Nep_NroFactura=@NUMFACTURA      
    
    
GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerFacturacionFwdFcLc_Periodo]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Victor Clerque  
-- Description:   
-- Valores de Prueba:  
-- Fecha de Creacion: 17/08/2009  
-- Fecha de Modificacion :  
--    
-- =============================================  
  
ALTER PROCEDURE [dbo].[FAC_ObtenerFacturacionFwdFcLc_Periodo] (@periodo_ini datetime,@periodo_fin datetime)  
as  
begin  
  SET NOCOUNT ON;  
 -- Resuelto: Importes sin IGV  
 -- Resuelto: Sin considerar servicios que se cobrar como "porcentaje del subtotal de la factura" ya que no estan en función al cnt  
  
 -- Asumiendo una misma Moneda  
  
 declare @estado_contabilizado int  
 declare @sustento_operacion int  
 declare @condicion_fwd int  
 declare @condicion_condicioncnt int  
 declare @valorcondicion_fc int  
 declare @valorcondicion_lc int  
 declare @fc money  
 declare @lc money  
 declare @fwd nvarchar(20)  
 declare @msg nvarchar(100)  
  
 select @estado_contabilizado=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentEstadoDocumento_Contabilizado'  
 select @sustento_operacion=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentSustentoDocumento_Operacion'  
 select @condicion_fwd=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentCondicion_Fwd'  
 select @condicion_condicioncnt=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentCondicion_CondicionCnt'  
 select @valorcondicion_fc=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentValorCondicion_CondicionCnt_FCL'  
 select @valorcondicion_lc=Valor from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro where Nombre='IdentValorCondicion_CondicionCnt_LCL'  

 begin try  

  begin transaction   
  declare cur cursor for  
  select ruc from EXTENSION_CRM.dbo.CLIENTE_FORWARDER  
  open cur  
  fetch next from cur into @fwd  
  while @@FETCH_STATUS=0  
  begin  
   select @fc=isnull(sum(case when coc.Ident_ValorCondicion=@valorcondicion_fc then Importe else 0 end),0),  
       @lc=isnull(sum(case when coc.Ident_ValorCondicion=@valorcondicion_lc then Importe else 0 end),0)  
   from (select cd.Ident_CntDocumento,sum(cd.Importe) as Importe  
      from  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Documento d   
      inner join openquery([SP3TDA-DBSQL01],'select ident_documento,ident_itemdocumento from Neptunia_SGC_Produccion.dbo.FAC_ItemDocumento') id on id.Ident_Documento=d.Ident_Documento  
      inner join openquery([SP3TDA-DBSQL01],'select ident_cntdocumento,ident_itemdocumento,importe from Neptunia_SGC_Produccion.dbo.FAC_CntDocumentoXItemDocumento') cd on id.Ident_ItemDocumento=cd.Ident_ItemDocumento        
      where d.I023_Estado=@estado_contabilizado  
      and d.I030_Sustento=@sustento_operacion  
      and d.Ident_Cliente=@fwd  
      and datediff(d,@periodo_ini,d.Emision)>=0 and datediff(d,@periodo_fin,d.Emision)<=0  
      group by cd.Ident_CntDocumento  
      union all  
      select cd.Ident_CntDocumento,sum(cd.Importe) as Importe  
      from  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Documento d   
      inner join  openquery([SP3TDA-DBSQL01],'select ident_documento,ident_itemdocumento from Neptunia_SGC_Produccion.dbo.FAC_ItemDocumento') id on d.Ident_Documento=id.Ident_Documento  
      inner join  openquery([SP3TDA-DBSQL01],'select ident_cntdocumento,ident_itemdocumento,importe from Neptunia_SGC_Produccion.dbo.FAC_CntDocumentoXItemDocumento') cd on id.Ident_ItemDocumento=cd.Ident_ItemDocumento  
      inner join  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_CntDocumento co on co.Ident_CntDocumento=cd.Ident_CntDocumento  
      inner join  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_CntDocumentoXCondicion coc on co.Ident_CntDocumento=coc.Ident_CntDocumento  
      inner join  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_ValorCondicion vc on vc.Ident_ValorCondicion=coc.Ident_ValorCondicion  
      where d.I023_Estado=@estado_contabilizado  
      and d.Ident_Cliente<>@fwd and coc.Ident_Condicion=@condicion_fwd  
      and vc.Codigo collate Modern_Spanish_CI_AI=@fwd collate Modern_Spanish_CI_AI  
      and datediff(d,@periodo_ini,d.Emision)>=0 and datediff(d,@periodo_fin,d.Emision)<=0  
      group by cd.Ident_CntDocumento) cnt  
    inner join  [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_CntDocumentoXCondicion coc on cnt.Ident_CntDocumento=coc.Ident_CntDocumento and coc.Ident_Condicion=@condicion_condicioncnt  
   set @msg=@fwd+' fc '+cast(@fc as nvarchar)+' lc '+cast(@lc as nvarchar)  
   print @msg  
   update EXTENSION_CRM.dbo.CLIENTE_FORWARDER set Facturacion_FCL=@fc,Facturacion_LCL=@lc where RUC=@fwd  
   fetch next from cur into @fwd  
  end  
  close cur  
  deallocate cur  
  commit transaction  
 end try  
  
 begin catch  
  set @msg=ERROR_MESSAGE()  
  rollback transaction  
  raiserror (@msg,11,1)  
 end catch  
  
 SET NOCOUNT OFF;  
 print 'Final'  
  
end  
GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerNotaCreditoRefactura_ReclamoXFactura]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
ALTER PROCEDURE [dbo].[FAC_ObtenerNotaCreditoRefactura_ReclamoXFactura]  
                                                                                                                                                                                   
    (@caso nvarchar(100),@factura nvarchar(100))  
                                                                                                                                                                                                           
AS  
                                                                                                                                                                                                                                                         
BEGIN  
                                                                                                                                                                                                                                                      
 SET NOCOUNT ON;  
                                                                                                                                                                                                                                           
  
                                                                                                                                                                                                                                                           
 DECLARE @Serie int  
                                                                                                                                                                                                                                        
 DECLARE @Numero int  
                                                                                                                                                                                                                                       
 DECLARE @Reclamo varchar(50)  
                                                                                                                                                                                                                              
 DECLARE @Documento varchar(50)  
                                                                                                                                                                                                                            
 SET @Serie=CAST(left(@factura,4) as int)  
                                                                                                                                                                                                                  
 SET @Numero=CAST(right(@factura,10) as int)  
                                                                                                                                                                                                               
 SET @Documento=REPLICATE('0',3-LEN(@Serie))+CAST(@Serie AS varchar)+' - '+REPLICATE('0',7-LEN(@Numero))+CAST(@Numero AS varchar)  
                                                                                                                          
 SET @Reclamo = CAST(@caso as varchar)  
                                                                                                                                                                                                                     
  
                                                                                                                                                                                                                                                           
 DECLARE @EstadoDocumento_Anulado int    
                                                                                                                                                                                                                    
 DECLARE @EstadoOrdenNotaCredito_Anulada int    
                                                                                                                                                                                                             
 DECLARE @EstadoOrdenFacturacion_Anulada int    
                                                                                                                                                                                                             
 DECLARE @SustentoDocumento_OrdenNotaCredito int    
                                                                                                                                                                                                         
 DECLARE @SustentoDocumento_OrdenFacturacion int    
                                                                                                                                                                                                         
 DECLARE @TipoDocumento_Factura int
                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
 SELECT @EstadoDocumento_Anulado = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentEstadoDocumento_Anulado'
                                                                                                             
 SELECT @EstadoOrdenNotaCredito_Anulada = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentEstadoOrdenNotaCredito_Anulada'
                                                                                               
 SELECT @EstadoOrdenFacturacion_Anulada = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentEstadoOrdenFacturacion_Anulada'
                                                                                               
 SELECT @SustentoDocumento_OrdenNotaCredito = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentSustentoDocumento_OrdenNotaCredito'
                                                                                       
 SELECT @SustentoDocumento_OrdenFacturacion = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentSustentoDocumento_OrdenFacturación'
                                                                                       
 SELECT @TipoDocumento_Factura = Valor FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Parametro WHERE Nombre = 'IdentTipoDocumento_Factura'
                                                                                                                 

                                                                                                                                                                                                                                                             
 DECLARE @NotaCredito varchar(50)  
                                                                                                                                                                                                                          
 DECLARE @OrdenRefacturacion varchar(50)  
                                                                                                                                                                                                                   
 DECLARE @Refactura varchar(50)  
                                                                                                                                                                                                                            
 DECLARE @MontoRefacturado money  
                                                                                                                                                                                                                           
 DECLARE @MontoOrdenRefacturacion money  
                                                                                                                                                                                                                    
 DECLARE @RazonSocial nvarchar(160)  
                                                                                                                                                                                                                        
 DECLARE @FechaNotaCredito datetime  
                                                                                                                                                                                                                        
 DECLARE @FechaRefactura datetime  
                                                                                                                                                                                                                          
 DECLARE @FechaOrdenRefacturacion datetime
                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
 SELECT @NotaCredito = REPLICATE('0',3-LEN(snc.Numero))+CAST(snc.Numero AS varchar)+' - '+REPLICATE('0',7-LEN(nc.Numero))+CAST(nc.Numero AS varchar),
                                                                                                        
		@FechaNotaCredito = nc.Emision
                                                                                                                                                                                                                             
 FROM	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_OrdenNotaCredito onc
                                                                                                                                                                                        
 LEFT JOIN	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Documento nc ON nc.Sustento = onc.Ident_OrdenNotaCredito AND nc.I030_Sustento = @SustentoDocumento_OrdenNotaCredito AND nc.I023_Estado <> @EstadoDocumento_Anulado
                                     
 LEFT JOIN	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Serie snc ON snc.Ident_Serie = nc.Ident_Serie
                                                                                                                                                          
 WHERE	onc.I032_Estado <> @EstadoOrdenNotaCredito_Anulada
                                                                                                                                                                                                    
 AND	onc.Reclamo COLLATE DATABASE_DEFAULT = @Reclamo COLLATE DATABASE_DEFAULT
                                                                                                                                                                                
 AND	onc.Factura COLLATE DATABASE_DEFAULT = @Documento COLLATE DATABASE_DEFAULT
                                                                                                                                                                              
 AND	onc.Ident_TipoDocumento = @TipoDocumento_Factura
                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
 SELECT @Refactura = REPLICATE('0',3-LEN(srf.Numero))+CAST(srf.Numero AS varchar)+' - '+REPLICATE('0',7-LEN(rf.Numero))+CAST(rf.Numero AS varchar),
                                                                                                          
		@OrdenRefacturacion = orf.Numero,
                                                                                                                                                                                                                          
		@MontoRefacturado = rf.Importe,
                                                                                                                                                                                                                            
		@MontoOrdenRefacturacion = orf.Importe,
                                                                                                                                                                                                                    
		@RazonSocial = c.RazonSocial,
                                                                                                                                                                                                                              
		@FechaRefactura = rf.Emision,
                                                                                                                                                                                                                              
		@FechaOrdenRefacturacion = orf.Fecha
                                                                                                                                                                                                                       
 FROM	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_OrdenFacturacion orf
                                                                                                                                                                                        
 LEFT JOIN	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Documento rf ON rf.Sustento = orf.Ident_OrdenFacturacion AND rf.I030_Sustento = @SustentoDocumento_OrdenFacturacion AND rf.I023_Estado <> @EstadoDocumento_Anulado
                                     
 LEFT JOIN	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Serie srf ON srf.Ident_Serie = rf.Ident_Serie
                                                                                                                                                          
 LEFT JOIN	[SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.FAC_Cliente c ON c.Ruc = rf.Ident_Cliente
                                                                                                                                                                  
 WHERE	orf.I028_Estado <> @EstadoOrdenFacturacion_Anulada
                                                                                                                                                                                                    
 AND	orf.Reclamo COLLATE DATABASE_DEFAULT = @Reclamo COLLATE DATABASE_DEFAULT
                                                                                                                                                                                
 AND	orf.Factura COLLATE DATABASE_DEFAULT = @Documento COLLATE DATABASE_DEFAULT
                                                                                                                                                                              
 AND	orf.Ident_TipoDocumento = @TipoDocumento_Factura
                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
 IF @NotaCredito IS NOT NULL OR @OrdenRefacturacion IS NOT NULL
                                                                                                                                                                                              
 BEGIN
                                                                                                                                                                                                                                                       
	 SELECT @NotaCredito AS NumeroNotaCredito,  
                                                                                                                                                                                                                
		 @FechaNotaCredito AS FechaNotaCredito,  
                                                                                                                                                                                                                  
		 @OrdenRefacturacion AS NumeroOrdenRefacturacion,  
                                                                                                                                                                                                        
		 @FechaOrdenRefacturacion AS FechaOrdenRefacturacion,  
                                                                                                                                                                                                    
		 @MontoOrdenRefacturacion AS MontoOrdenRefacturacion,
                                                                                                                                                                                                      
		 @Refactura AS NumeroRefactura,  
                                                                                                                                                                                                                          
		 @FechaRefactura AS FechaRefactura,  
                                                                                                                                                                                                                      
		 @MontoRefacturado AS MontoRefacturado,  
                                                                                                                                                                                                                  
		 @RazonSocial AS RazonSocialRefactura  
                                                                                                                                                                                                                    
 END
                                                                                                                                                                                                                                                         
END                                                                                                                                                                                                                                                            
GO
/****** Object:  StoredProcedure [dbo].[OFI_ObtenerCabeceraFacturaOFISIS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OFI_ObtenerCabeceraFacturaOFISIS]                                        
@NUMFACTURA NVARCHAR(15),                          
@TIPMONEDA NVARCHAR(3),            
@RUCCODIGO NVARCHAR(11)                      
AS            
BEGIN             
 IF (@TIPMONEDA = 'DÓL')              
    SELECT @TIPMONEDA = 'DOL'              
     
 set @NUMFACTURA = right(@NUMFACTURA,len(@NUMFACTURA)-1)    
            
 SELECT TCDOCU_CLIE.TI_DOCU TIPODOC,                          
  TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                          
  SubString(TCDOCU_CLIE.NU_DOCU,1,4) SERIEDOC,                          
  SubString(TCDOCU_CLIE.NU_DOCU,6,10) NUMERODOC,                          
  TCDOCU_CLIE.CO_CLIE RUCCODIGO,                           
  TCDOCU_CLIE.CO_MONE MONEDA,                          
  TCDOCU_CLIE.CO_IMP1 TIPOIMPUESTO1,                             
  TCDOCU_CLIE.PC_IMP1 IMPUESTO1,                             
  TCDOCU_CLIE.CO_IMP2 TIPOIMPUESTO2,                             
  TCDOCU_CLIE.PC_IMP2 IMPUESTO2,                             
  TCDOCU_CLIE.CO_IMP3 TIPOIMPUESTO3,                             
  TCDOCU_CLIE.PC_IMP3 IMPUESTO3,                             
  TCDOCU_CLIE.CO_ESTA_DOCU ESTADODOC,              
  TCDOCU_CLIE.FE_DOCU FECHAEMISION,              
  TCDOCU_CLIE.IM_TOTA TOTALFACTURA 
  INTO #TEMP_COSMOS_DB             
 FROM OFIRECA.dbo.TCDOCU_CLIE                            
 WHERE TCDOCU_CLIE.CO_EMPR = '16'                    
  AND TCDOCU_CLIE.TI_DOCU = 'FAC'                  
  AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                
  AND TCDOCU_CLIE.NU_DOCU like '%' + @NUMFACTURA                          
  AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                          
  AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO   
  --UNION
  
   SELECT TCDOCU_CLIE.TI_DOCU TIPODOC,                          
  TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                          
  SubString(TCDOCU_CLIE.NU_DOCU,1,4) SERIEDOC,                          
  SubString(TCDOCU_CLIE.NU_DOCU,6,10) NUMERODOC,                          
  TCDOCU_CLIE.CO_CLIE RUCCODIGO,                           
  TCDOCU_CLIE.CO_MONE MONEDA,                          
  TCDOCU_CLIE.CO_IMP1 TIPOIMPUESTO1,                             
  TCDOCU_CLIE.PC_IMP1 IMPUESTO1,                             
  TCDOCU_CLIE.CO_IMP2 TIPOIMPUESTO2,                             
  TCDOCU_CLIE.PC_IMP2 IMPUESTO2,                             
  TCDOCU_CLIE.CO_IMP3 TIPOIMPUESTO3,                             
  TCDOCU_CLIE.PC_IMP3 IMPUESTO3,                             
  TCDOCU_CLIE.CO_ESTA_DOCU ESTADODOC,              
  TCDOCU_CLIE.FE_DOCU FECHAEMISION,              
  TCDOCU_CLIE.IM_TOTA TOTALFACTURA 
  INTO #TEMP_CALW3ERP001              
 FROM OFIRECA.dbo.TCDOCU_CLIE                            
 WHERE TCDOCU_CLIE.CO_EMPR = '01'                    
  AND TCDOCU_CLIE.TI_DOCU = 'FAC'                  
  AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                
  AND TCDOCU_CLIE.NU_DOCU like '%' + @NUMFACTURA                          
  AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                          
  AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO 
  
  SELECT * FROM #TEMP_COSMOS_DB
  UNION
  SELECT * FROM #TEMP_CALW3ERP001 WHERE NUMDOCCOMPLETO NOT IN( SELECT NUMDOCCOMPLETO FROM #TEMP_COSMOS_DB)
  
  DROP TABLE #TEMP_COSMOS_DB
  DROP TABLE #TEMP_CALW3ERP001
           
END 


GO
/****** Object:  StoredProcedure [dbo].[OFI_ObtenerDetalleFacturaOFISIS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                                                          
Obj.		: Obtener Detalle de Factura de OFISIS                                                      
Autor		: GOS(YQM)                                                          
Fecha		: 09/09/2009                                                          
BD			: EXTENSION_CRM      
OPTIMIZADO	: 12ENERO2018 EDUARDOMILLAM
**********************************************************/
--OFI_ObtenerDetalleFacturaOFISIS '0032-0000089727','SOL','20162348931',2,2                                                        
ALTER PROCEDURE [dbo].[OFI_ObtenerDetalleFacturaOFISIS] @NUMFACTURA NVARCHAR(15)
	,@TIPMONEDA NVARCHAR(3)
	,@RUCCODIGO NVARCHAR(11)
	,@PARAM INT
	,@REFACTURA INT
AS
--@PARAM = 1 Todo                                                        
--@PARAM = 2 Solo campos para CRM                                                        
--@REFACTURA = 1 No Refactura                          
--@REFACTURA = 2 Si Refactura                          
BEGIN
	IF (@TIPMONEDA = 'DÓL')
		SELECT @TIPMONEDA = 'DOL'

	IF (@PARAM = 1)
	BEGIN
		SET @NUMFACTURA = right(@NUMFACTURA, len(@NUMFACTURA) - 1)

		SELECT CABDOC.TI_DOCU TIPODOC
			,CABDOC.NU_DOCU NUMDOCCOMPLETO
			,MAX(SubString(CABDOC.NU_DOCU, 1, 4)) SERIEDOC
			,MAX(SubString(CABDOC.NU_DOCU, 6, 10)) NUMERODOC
			,MAX(CABDOC.CO_CLIE) RUCCODIGO
			,MAX(CABDOC.CO_MONE) MONEDA
			,DETDOC.CO_SERV CODSERVICIOOFISIS
			,SERV.DE_SERV NOMSERVICIOOFISIS
			,DETDOC.CO_UNNE UNIDADNEGOCIO
			,UNEG.DE_UNNE NOMUNIDADNEGOCIO
			,DETDOC.CO_TIEN LOCALTIENDA
			,TIEN.DE_TIEN NOMLOCALTIENDA
			,MAX(CABDOC.CO_IMP1) TIPOIMPUESTO1
			,
			--MAX(DETDOC.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(DETDOC.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado                    
			CASE 
				WHEN sum(CABDOC.IM_BRUT_AFEC) > 0
					THEN 'S'
				ELSE 'N'
				END AFECTOIMP1
			,CASE 
				WHEN MAX(CABDOC.FE_DOCU) >= '20110301'
					THEN MAX(CABDOC.PC_IMP1)
				ELSE 19
				END IMPUESTO1
			,--MAX(CABDOC.PC_IMP1) IMPUESTO1,                                                             
			MAX(CABDOC.CO_IMP2) TIPOIMPUESTO2
			,MAX(DETDOC.ST_IMP2) AFECTOIMP2
			,MAX(CABDOC.PC_IMP2) IMPUESTO2
			,MAX(CABDOC.CO_IMP3) TIPOIMPUESTO3
			,MAX(DETDOC.ST_IMP3) AFECTOIMP3
			,MAX(CABDOC.PC_IMP3) IMPUESTO3
			,SUM(DETDOC.CA_DOCU) CANTIDAD
			,SUM(DETDOC.PR_VENT) / count(*) PRECIOVENTASINIMP
			,SUM(DETDOC.IM_TOTA_DETA) TOTALPORLINEA
			,MAX(CABDOC.CO_ESTA_DOCU) ESTADODOC
		INTO #TEMP_COSMOS_DB
		FROM OFIRECA.dbo.TDDOCU_CLIE AS DETDOC
		INNER JOIN OFIRECA.dbo.TCDOCU_CLIE AS CABDOC ON (CABDOC.NU_DOCU = DETDOC.NU_DOCU)
			AND (CABDOC.TI_DOCU = DETDOC.TI_DOCU)
			AND (CABDOC.CO_UNID = DETDOC.CO_UNID)
			AND (CABDOC.CO_EMPR = DETDOC.CO_EMPR)
		INNER JOIN OFIRECA.dbo.TTSERV AS SERV ON (DETDOC.CO_EMPR = SERV.CO_EMPR)
			AND (DETDOC.CO_SERV = SERV.CO_SERV)
		INNER JOIN OFIRECA.dbo.TTUNID_NEGO AS UNEG ON (DETDOC.CO_EMPR = UNEG.CO_EMPR)
			AND (DETDOC.CO_UNNE = UNEG.CO_UNNE)
		INNER JOIN OFIRECA.dbo.TMTIEN AS TIEN ON (DETDOC.CO_EMPR = TIEN.CO_EMPR)
			AND (DETDOC.CO_TIEN = TIEN.CO_TIEN)
		WHERE CABDOC.CO_EMPR = '16'
			AND CABDOC.TI_DOCU = 'FAC'
			AND (
				CABDOC.CO_ESTA_DOCU = 'ACT'
				OR CABDOC.CO_ESTA_DOCU = 'PAG'
				)
			AND CABDOC.NU_DOCU LIKE '%' + @NUMFACTURA
			AND CABDOC.CO_MONE = @TIPMONEDA
			AND CABDOC.CO_CLIE = @RUCCODIGO
			AND TIEN.DE_TIEN <> 'OLI PLUSPETROL'
		GROUP BY CABDOC.TI_DOCU
			,CABDOC.NU_DOCU
			,DETDOC.CO_SERV
			,DETDOC.CO_UNNE
			,DETDOC.CO_TIEN
			,SERV.DE_SERV
			,UNEG.DE_UNNE
			,TIEN.DE_TIEN
		ORDER BY DETDOC.CO_SERV 
		
		--UNION
		
		SELECT CABDOC.TI_DOCU TIPODOC
			,CABDOC.NU_DOCU NUMDOCCOMPLETO
			,MAX(SubString(CABDOC.NU_DOCU, 1, 4)) SERIEDOC
			,MAX(SubString(CABDOC.NU_DOCU, 6, 10)) NUMERODOC
			,MAX(CABDOC.CO_CLIE) RUCCODIGO
			,MAX(CABDOC.CO_MONE) MONEDA
			,DETDOC.CO_SERV CODSERVICIOOFISIS
			,SERV.DE_SERV NOMSERVICIOOFISIS
			,DETDOC.CO_UNNE UNIDADNEGOCIO
			,UNEG.DE_UNNE NOMUNIDADNEGOCIO
			,DETDOC.CO_TIEN LOCALTIENDA
			,TIEN.DE_TIEN NOMLOCALTIENDA
			,MAX(CABDOC.CO_IMP1) TIPOIMPUESTO1
			,
			--MAX(DETDOC.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(DETDOC.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado                    
			CASE 
				WHEN sum(CABDOC.IM_BRUT_AFEC) > 0
					THEN 'S'
				ELSE 'N'
				END AFECTOIMP1
			,CASE 
				WHEN MAX(CABDOC.FE_DOCU) >= '20110301'
					THEN MAX(CABDOC.PC_IMP1)
				ELSE 19
				END IMPUESTO1
			,--MAX(CABDOC.PC_IMP1) IMPUESTO1,                                                             
			MAX(CABDOC.CO_IMP2) TIPOIMPUESTO2
			,MAX(DETDOC.ST_IMP2) AFECTOIMP2
			,MAX(CABDOC.PC_IMP2) IMPUESTO2
			,MAX(CABDOC.CO_IMP3) TIPOIMPUESTO3
			,MAX(DETDOC.ST_IMP3) AFECTOIMP3
			,MAX(CABDOC.PC_IMP3) IMPUESTO3
			,SUM(DETDOC.CA_DOCU) CANTIDAD
			,SUM(DETDOC.PR_VENT) / count(*) PRECIOVENTASINIMP
			,SUM(DETDOC.IM_TOTA_DETA) TOTALPORLINEA
			,MAX(CABDOC.CO_ESTA_DOCU) ESTADODOC
		INTO #TEMP_CALW3ERP001
		FROM OFIRECA.dbo.TDDOCU_CLIE AS DETDOC
		INNER JOIN OFIRECA.dbo.TCDOCU_CLIE AS CABDOC ON (CABDOC.NU_DOCU = DETDOC.NU_DOCU)
			AND (CABDOC.TI_DOCU = DETDOC.TI_DOCU)
			AND (CABDOC.CO_UNID = DETDOC.CO_UNID)
			AND (CABDOC.CO_EMPR = DETDOC.CO_EMPR)
		INNER JOIN OFIRECA.dbo.TTSERV AS SERV ON (DETDOC.CO_EMPR = SERV.CO_EMPR)
			AND (DETDOC.CO_SERV = SERV.CO_SERV)
		INNER JOIN OFIRECA.dbo.TTUNID_NEGO AS UNEG ON (DETDOC.CO_EMPR = UNEG.CO_EMPR)
			AND (DETDOC.CO_UNNE = UNEG.CO_UNNE)
		INNER JOIN OFIRECA.dbo.TMTIEN AS TIEN ON (DETDOC.CO_EMPR = TIEN.CO_EMPR)
			AND (DETDOC.CO_TIEN = TIEN.CO_TIEN)
		WHERE CABDOC.CO_EMPR = '01'
			AND CABDOC.TI_DOCU = 'FAC'
			AND (
				CABDOC.CO_ESTA_DOCU = 'ACT'
				OR CABDOC.CO_ESTA_DOCU = 'PAG'
				)
			AND CABDOC.NU_DOCU LIKE '%' + @NUMFACTURA
			AND CABDOC.CO_MONE = @TIPMONEDA
			AND CABDOC.CO_CLIE = @RUCCODIGO
			AND TIEN.DE_TIEN <> 'OLI PLUSPETROL'
		GROUP BY CABDOC.TI_DOCU
			,CABDOC.NU_DOCU
			,DETDOC.CO_SERV
			,DETDOC.CO_UNNE
			,DETDOC.CO_TIEN
			,SERV.DE_SERV
			,UNEG.DE_UNNE
			,TIEN.DE_TIEN
		ORDER BY DETDOC.CO_SERV 
		
		SELECT * FROM #TEMP_COSMOS_DB
		UNION
		SELECT * FROM #TEMP_CALW3ERP001 WHERE NUMDOCCOMPLETO NOT IN( SELECT NUMDOCCOMPLETO FROM #TEMP_COSMOS_DB)
				
		DROP TABLE #TEMP_COSMOS_DB
		DROP TABLE #TEMP_CALW3ERP001
		
	END
	ELSE IF (@PARAM = 2)
	BEGIN
		SET @NUMFACTURA = right(@NUMFACTURA, len(@NUMFACTURA) - 1)

		SELECT Max(CABDOC.CO_CLIE) RUCCODIGO
			,CABDOC.NU_DOCU NUMDOCCOMPLETO
			,SUM(Convert(INT, DETDOC.CA_DOCU)) CANTIDADSERVICIO
			,SERV.DE_SERV NOMSERVICIOOFISIS
			,DETDOC.CO_SERV CODSERVICIOOFISIS
			,UNEG.DE_UNNE NOMUNIDADNEGOCIO
			,TIEN.DE_TIEN NOMLOCALTIENDA
			,SUM(DETDOC.IM_TOTA_DETA) TOTALPORLINEA
			,--Esta es sin IGV
			SUM(DETDOC.IM_TOTA_DETA) MONTODEVOLVER
			,--Este es el Monto Correcto
			CASE @Refactura
				WHEN 1
					THEN 0
				ELSE SUM(DETDOC.IM_TOTA_DETA)
				END MONTOCORRECTODEVOLVER
			,--Este es el Monto a Devolver  --'S' AFECTOIMP1,--MAX(DETDOC.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS
			CASE 
				WHEN SUM(CABDOC.IM_BRUT_AFEC) > 0
					THEN 'S'
				ELSE 'N'
				END AFECTOIMP1
			,CASE 
				WHEN MAX(CABDOC.FE_DOCU) >= '20110301'
					THEN MAX(CABDOC.PC_IMP1)
				ELSE 19
				END IMPUESTO1
			,--MAX(CABDOC.PC_IMP1) IMPUESTO1,
			CASE @Refactura
				WHEN 1
					THEN 0
				ELSE CASE MAX(DETDOC.ST_IMP1)
						WHEN 'N'
							THEN SUM(DETDOC.IM_TOTA_DETA) + MAX(CABDOC.PC_IMP1) * SUM(DETDOC.IM_TOTA_DETA) / 100 --SUM(DETDOC.IM_TOTA_DETA)--GOS(YQM) Modificado por Error en OFISIS
						ELSE SUM(DETDOC.IM_TOTA_DETA) + MAX(CABDOC.PC_IMP1) * SUM(DETDOC.IM_TOTA_DETA) / 100
						END
				END MONTOCORRECTODEVOLVERIGV
		INTO #TEMP_COSMOS_DB_1 
		FROM OFIRECA.dbo.TDDOCU_CLIE AS DETDOC
		INNER JOIN OFIRECA.dbo.TCDOCU_CLIE AS CABDOC ON (CABDOC.NU_DOCU = DETDOC.NU_DOCU)
			AND (CABDOC.TI_DOCU = DETDOC.TI_DOCU)
			AND (CABDOC.CO_UNID = DETDOC.CO_UNID)
			AND (CABDOC.CO_EMPR = DETDOC.CO_EMPR)
		INNER JOIN OFIRECA.dbo.TTSERV AS SERV ON (DETDOC.CO_EMPR = SERV.CO_EMPR)
			AND (DETDOC.CO_SERV = SERV.CO_SERV)
		INNER JOIN OFIRECA.dbo.TTUNID_NEGO AS UNEG ON (DETDOC.CO_EMPR = UNEG.CO_EMPR)
			AND (DETDOC.CO_UNNE = UNEG.CO_UNNE)
		INNER JOIN OFIRECA.dbo.TMTIEN AS TIEN ON (DETDOC.CO_EMPR = TIEN.CO_EMPR)
			AND (DETDOC.CO_TIEN = TIEN.CO_TIEN)
		WHERE CABDOC.CO_EMPR = '16'
			AND CABDOC.TI_DOCU = 'FAC'
			AND (
				CABDOC.CO_ESTA_DOCU = 'ACT'
				OR CABDOC.CO_ESTA_DOCU = 'PAG'
				)
			AND CABDOC.NU_DOCU LIKE '%' + @NUMFACTURA
			AND CABDOC.CO_MONE = @TIPMONEDA
			AND CABDOC.CO_CLIE = @RUCCODIGO
			AND TIEN.DE_TIEN <> 'OLI PLUSPETROL'
		GROUP BY CABDOC.TI_DOCU
			,CABDOC.NU_DOCU
			,DETDOC.CO_SERV
			,DETDOC.CO_UNNE
			,DETDOC.CO_TIEN
			,SERV.DE_SERV
			,UNEG.DE_UNNE
			,TIEN.DE_TIEN			
		ORDER BY DETDOC.CO_SERV 
		
		SELECT Max(CABDOC.CO_CLIE) RUCCODIGO
			,CABDOC.NU_DOCU NUMDOCCOMPLETO
			,SUM(Convert(INT, DETDOC.CA_DOCU)) CANTIDADSERVICIO
			,SERV.DE_SERV NOMSERVICIOOFISIS
			,DETDOC.CO_SERV CODSERVICIOOFISIS
			,UNEG.DE_UNNE NOMUNIDADNEGOCIO
			,TIEN.DE_TIEN NOMLOCALTIENDA
			,SUM(DETDOC.IM_TOTA_DETA) TOTALPORLINEA
			,--Esta es sin IGV
			SUM(DETDOC.IM_TOTA_DETA) MONTODEVOLVER
			,--Este es el Monto Correcto
			CASE @Refactura
				WHEN 1
					THEN 0
				ELSE SUM(DETDOC.IM_TOTA_DETA)
				END MONTOCORRECTODEVOLVER
			,--Este es el Monto a Devolver  --'S' AFECTOIMP1,--MAX(DETDOC.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS
			CASE 
				WHEN SUM(CABDOC.IM_BRUT_AFEC) > 0
					THEN 'S'
				ELSE 'N'
				END AFECTOIMP1
			,CASE 
				WHEN MAX(CABDOC.FE_DOCU) >= '20110301'
					THEN MAX(CABDOC.PC_IMP1)
				ELSE 19
				END IMPUESTO1
			,--MAX(CABDOC.PC_IMP1) IMPUESTO1,
			CASE @Refactura
				WHEN 1
					THEN 0
				ELSE CASE MAX(DETDOC.ST_IMP1)
						WHEN 'N'
							THEN SUM(DETDOC.IM_TOTA_DETA) + MAX(CABDOC.PC_IMP1) * SUM(DETDOC.IM_TOTA_DETA) / 100 --SUM(DETDOC.IM_TOTA_DETA)--GOS(YQM) Modificado por Error en OFISIS
						ELSE SUM(DETDOC.IM_TOTA_DETA) + MAX(CABDOC.PC_IMP1) * SUM(DETDOC.IM_TOTA_DETA) / 100
						END
				END MONTOCORRECTODEVOLVERIGV
		INTO #TEMP_CALW3ERP001_1
		FROM OFIRECA.dbo.TDDOCU_CLIE AS DETDOC
		INNER JOIN OFIRECA.dbo.TCDOCU_CLIE AS CABDOC ON (CABDOC.NU_DOCU = DETDOC.NU_DOCU)
			AND (CABDOC.TI_DOCU = DETDOC.TI_DOCU)
			AND (CABDOC.CO_UNID = DETDOC.CO_UNID)
			AND (CABDOC.CO_EMPR = DETDOC.CO_EMPR)
		INNER JOIN OFIRECA.dbo.TTSERV AS SERV ON (DETDOC.CO_EMPR = SERV.CO_EMPR)
			AND (DETDOC.CO_SERV = SERV.CO_SERV)
		INNER JOIN OFIRECA.dbo.TTUNID_NEGO AS UNEG ON (DETDOC.CO_EMPR = UNEG.CO_EMPR)
			AND (DETDOC.CO_UNNE = UNEG.CO_UNNE)
		INNER JOIN OFIRECA.dbo.TMTIEN AS TIEN ON (DETDOC.CO_EMPR = TIEN.CO_EMPR)
			AND (DETDOC.CO_TIEN = TIEN.CO_TIEN)
		WHERE CABDOC.CO_EMPR = '01'
			AND CABDOC.TI_DOCU = 'FAC'
			AND (
				CABDOC.CO_ESTA_DOCU = 'ACT'
				OR CABDOC.CO_ESTA_DOCU = 'PAG'
				)
			AND CABDOC.NU_DOCU LIKE '%' + @NUMFACTURA
			AND CABDOC.CO_MONE = @TIPMONEDA
			AND CABDOC.CO_CLIE = @RUCCODIGO
			AND TIEN.DE_TIEN <> 'OLI PLUSPETROL'
		GROUP BY CABDOC.TI_DOCU
			,CABDOC.NU_DOCU
			,DETDOC.CO_SERV
			,DETDOC.CO_UNNE
			,DETDOC.CO_TIEN
			,SERV.DE_SERV
			,UNEG.DE_UNNE
			,TIEN.DE_TIEN
		ORDER BY DETDOC.CO_SERV 
		
		SELECT *
		FROM #TEMP_COSMOS_DB_1
		UNION
		SELECT *
		FROM #TEMP_CALW3ERP001_1 WHERE NUMDOCCOMPLETO NOT IN( SELECT NUMDOCCOMPLETO FROM #TEMP_COSMOS_DB_1)
		ORDER BY CODSERVICIOOFISIS ASC
  
		DROP TABLE #TEMP_COSMOS_DB_1
		DROP TABLE #TEMP_CALW3ERP001_1
		
	END
	

	
END
	/*
  --***** SCRIPT ORIGINAL *********************************************************************************************************************************************
  
   SELECT  TCDOCU_CLIE.TI_DOCU TIPODOC,                                                             
         TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                             
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,1,4)) SERIEDOC,                                                          
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,6,10)) NUMERODOC,                                                          
         MAX(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                             
         MAX(TCDOCU_CLIE.CO_MONE) MONEDA,                                                             
         TDDOCU_CLIE.CO_SERV CODSERVICIOOFISIS,                                             
         TTSERV.DE_SERV NOMSERVICIOOFISIS,                                          
         TDDOCU_CLIE.CO_UNNE UNIDADNEGOCIO,                                      
         TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                                                         
         TDDOCU_CLIE.CO_TIEN LOCALTIENDA,                                  
         TMTIEN.DE_TIEN NOMLOCALTIENDA,                                                             
         MAX(TCDOCU_CLIE.CO_IMP1) TIPOIMPUESTO1,                                                             
         --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado                    
  case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,                     
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1,    --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,                                                             
         MAX(TCDOCU_CLIE.CO_IMP2) TIPOIMPUESTO2,                                                             
         MAX(TDDOCU_CLIE.ST_IMP2) AFECTOIMP2,                                                             
         MAX(TCDOCU_CLIE.PC_IMP2) IMPUESTO2,                
         MAX(TCDOCU_CLIE.CO_IMP3) TIPOIMPUESTO3,                                   
         MAX(TDDOCU_CLIE.ST_IMP3) AFECTOIMP3,                                                             
         MAX(TCDOCU_CLIE.PC_IMP3) IMPUESTO3,                                                       
         SUM(TDDOCU_CLIE.CA_DOCU) CANTIDAD,                                                           
         SUM(TDDOCU_CLIE.PR_VENT)/count(*) PRECIOVENTASINIMP,           
         SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA,                          
         MAX(TCDOCU_CLIE.CO_ESTA_DOCU) ESTADODOC 
    FROM OFIRECA.dbo.TDDOCU_CLIE,                                                             
       OFIRECA.dbo.TCDOCU_CLIE,                                          
         OFIRECA.dbo.TTSERV,                                          
         OFIRECA.dbo.TTUNID_NEGO,                                  
         OFIRECA.dbo.TMTIEN                                        
 WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                            
         ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                                                            
         ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                            
         ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                                                           
         AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                            
         AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                                        
 AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                                          
         AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                                  
         AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                                  
         AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                                 
         AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                                          
     AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                                
         AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                              
         AND TCDOCU_CLIE.NU_DOCU  like '%' + @NUMFACTURA                                                          
         AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                                                          
         AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO                   
         AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                                
 GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                                
 --ORDER BY TTSERV.DE_SERV  
  
  */

GO
/****** Object:  StoredProcedure [dbo].[OFI_ObtenerDetalleFacturaOFISIS_PRUEBA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************                                              
Obj. : Obtener Detalle de Factura de OFISIS                                          
Autor: GOS(YQM)                                              
Fecha: 09/09/2009                                              
BD   : EXTENSION_CRM                                              
**********************************************************/                                              
--OFI_ObtenerDetalleFacturaOFISIS '0032-0000089727','SOL','20162348931',2,2                                            
ALTER PROCEDURE [dbo].[OFI_ObtenerDetalleFacturaOFISIS_PRUEBA]                                                    
@NUMFACTURA NVARCHAR(15),                                            
@TIPMONEDA NVARCHAR(3),                       
@RUCCODIGO NVARCHAR(11),                                           
@PARAM INT,                                             
@REFACTURA INT              
AS              
--@PARAM = 1 Todo                                            
--@PARAM = 2 Solo campos para CRM                                            
--@REFACTURA = 1 No Refactura              
--@REFACTURA = 2 Si Refactura              
BEGIN                                 
IF (@TIPMONEDA = 'DÓL')                            
    SELECT @TIPMONEDA = 'DOL'                            
                            
IF (@PARAM=1)                                            
BEGIN                                            
 SELECT  TCDOCU_CLIE.TI_DOCU TIPODOC,                                                 
         TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                 
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,1,4)) SERIEDOC,                                              
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,6,10)) NUMERODOC,                                              
         MAX(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                 
         MAX(TCDOCU_CLIE.CO_MONE) MONEDA,                                                 
         TDDOCU_CLIE.CO_SERV CODSERVICIOOFISIS,                                 
         TTSERV.DE_SERV NOMSERVICIOOFISIS,                              
         TDDOCU_CLIE.CO_UNNE UNIDADNEGOCIO,                          
         TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                                             
         TDDOCU_CLIE.CO_TIEN LOCALTIENDA,                      
         TMTIEN.DE_TIEN NOMLOCALTIENDA,                                                 
         MAX(TCDOCU_CLIE.CO_IMP1) TIPOIMPUESTO1,                                                 
         --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado        
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,         
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1,    --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,                                                 
         MAX(TCDOCU_CLIE.CO_IMP2) TIPOIMPUESTO2,                                                 
         MAX(TDDOCU_CLIE.ST_IMP2) AFECTOIMP2,                                                 
         MAX(TCDOCU_CLIE.PC_IMP2) IMPUESTO2,                                                 
         MAX(TCDOCU_CLIE.CO_IMP3) TIPOIMPUESTO3,                                                 
         MAX(TDDOCU_CLIE.ST_IMP3) AFECTOIMP3,                                                 
         MAX(TCDOCU_CLIE.PC_IMP3) IMPUESTO3,                                                 
         SUM(TDDOCU_CLIE.CA_DOCU) CANTIDAD,                                                 
         SUM(TDDOCU_CLIE.PR_VENT)/count(*) PRECIOVENTASINIMP,                                                 
         SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA,                 
         MAX(TCDOCU_CLIE.CO_ESTA_DOCU) ESTADODOC                                                 
    FROM OFIRECA.dbo.TDDOCU_CLIE,          
         OFIRECA.dbo.TCDOCU_CLIE,                              
         OFIRECA.dbo.TTSERV,                              
         OFIRECA.dbo.TTUNID_NEGO,                      
         OFIRECA.dbo.TMTIEN                            
 WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                
         ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                                                
         ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                
         ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                                               
         AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                
         AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                            
         AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                              
         AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                      
         AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                      
         AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                     
         AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                              
     AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                    
         AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                  
         AND TCDOCU_CLIE.NU_DOCU = @NUMFACTURA                                              
         AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                                              
         AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO       
         AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                    
 GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                    
END                                         
ELSE                                            
    IF (@PARAM=2)                                            
 BEGIN                                            
   SELECT Max(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                             
          TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                               
          SUM(Convert(int,TDDOCU_CLIE.CA_DOCU)) CANTIDADSERVICIO,                      
          TTSERV.DE_SERV NOMSERVICIOOFISIS,                           
          TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                    
          TMTIEN.DE_TIEN NOMLOCALTIENDA,                               
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA, --Esta es sin IGV                                          
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) MONTODEVOLVER, --Este es el Monto Correcto              
          CASE @Refactura WHEN 1 THEN 0 ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) END MONTOCORRECTODEVOLVER, --Este es el Monto a Devolver              
          --'S' AFECTOIMP1,--MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS               
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,           
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1, --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,              
          CASE @Refactura WHEN 1 THEN 0               
          ELSE CASE MAX(TDDOCU_CLIE.ST_IMP1) WHEN 'N' THEN SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 --SUM(TDDOCU_CLIE.IM_TOTA_DETA)--GOS(YQM) Modificado por Error en OFISIS          
               ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 END              
          END MONTOCORRECTODEVOLVERIGV                                        
   FROM OFIRECA.dbo.TDDOCU_CLIE,       
        OFIRECA.dbo.TCDOCU_CLIE,                              
        OFIRECA.dbo.TTSERV,                      
        OFIRECA.dbo.TTUNID_NEGO,                      
        OFIRECA.dbo.TMTIEN                                              
   WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                
   ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and               
   ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                
   ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                        
   AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                              
   AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                       
   AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                              
   AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                      
   AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                      
   AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                               
   AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                       
   AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                           
   AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                       
   AND TCDOCU_CLIE.NU_DOCU = @NUMFACTURA                                              
   AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                      
   AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO                                           
   GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                    
 END                               
END 
GO
/****** Object:  StoredProcedure [dbo].[OFI_ObtenerDetalleFacturaOFISIS_PRUEBA1]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*********************************************************                                                        
Obj. : Obtener Detalle de Factura de OFISIS                                                    
Autor: GOS(YQM)                                                        
Fecha: 09/09/2009                                                        
BD   : EXTENSION_CRM                                                        
**********************************************************/                                                        
--OFI_ObtenerDetalleFacturaOFISIS '0032-0000089727','SOL','20162348931',2,2                                                      
ALTER PROCEDURE [dbo].[OFI_ObtenerDetalleFacturaOFISIS_PRUEBA1]                                                              
@NUMFACTURA NVARCHAR(15),                                                      
@TIPMONEDA NVARCHAR(3),                                 
@RUCCODIGO NVARCHAR(11),                                                     
@PARAM INT,                                                       
@REFACTURA INT                        
AS                        
--@PARAM = 1 Todo                                                      
--@PARAM = 2 Solo campos para CRM                                                      
--@REFACTURA = 1 No Refactura                        
--@REFACTURA = 2 Si Refactura                        
BEGIN                                           
IF (@TIPMONEDA = 'DÓL')                                      
    SELECT @TIPMONEDA = 'DOL'                                      
                                      
IF (@PARAM=1)                                                      
BEGIN                    
 set @NUMFACTURA = right(@NUMFACTURA,len(@NUMFACTURA)-1)                                              
 SELECT  TCDOCU_CLIE.TI_DOCU TIPODOC,                                                           
         TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                           
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,1,4)) SERIEDOC,                                                        
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,6,10)) NUMERODOC,                                                        
         MAX(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                           
         MAX(TCDOCU_CLIE.CO_MONE) MONEDA,                                                           
         TDDOCU_CLIE.CO_SERV CODSERVICIOOFISIS,                                           
         TTSERV.DE_SERV NOMSERVICIOOFISIS,                                        
         TDDOCU_CLIE.CO_UNNE UNIDADNEGOCIO,                                    
         TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                                                       
         TDDOCU_CLIE.CO_TIEN LOCALTIENDA,                                
         TMTIEN.DE_TIEN NOMLOCALTIENDA,                                                           
         MAX(TCDOCU_CLIE.CO_IMP1) TIPOIMPUESTO1,                                                           
         --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado                  
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,                   
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1,    --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,                                                           
         MAX(TCDOCU_CLIE.CO_IMP2) TIPOIMPUESTO2,                                                           
         MAX(TDDOCU_CLIE.ST_IMP2) AFECTOIMP2,                                                           
         MAX(TCDOCU_CLIE.PC_IMP2) IMPUESTO2,                                                           
         MAX(TCDOCU_CLIE.CO_IMP3) TIPOIMPUESTO3,       
         MAX(TDDOCU_CLIE.ST_IMP3) AFECTOIMP3,                                                           
         MAX(TCDOCU_CLIE.PC_IMP3) IMPUESTO3,                                                           
         SUM(TDDOCU_CLIE.CA_DOCU) CANTIDAD,                                                         
         SUM(TDDOCU_CLIE.PR_VENT)/count(*) PRECIOVENTASINIMP,                                                           
         SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA,                        
         MAX(TCDOCU_CLIE.CO_ESTA_DOCU) ESTADODOC                     
    FROM OFIRECA.dbo.TDDOCU_CLIE,                                                           
       OFIRECA.dbo.TCDOCU_CLIE,                                        
         OFIRECA.dbo.TTSERV,                                        
         OFIRECA.dbo.TTUNID_NEGO,                                
         OFIRECA.dbo.TMTIEN                                      
 WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                          
         ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                                                          
         ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                          
         ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                                                         
         AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                          
         AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                                      
         AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                                        
         AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                                
         AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                                
         AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                               
         AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                                        
     AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                              
         AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                            
         AND TCDOCU_CLIE.NU_DOCU  like '%' + @NUMFACTURA                                                        
         AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                                                        
         AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO                 
         AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                              
 GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                              
 ORDER BY TTSERV.DE_SERV        
END                                                   
ELSE                                                      
    IF (@PARAM=2)                                                      
 BEGIN                 
             
 set @NUMFACTURA = right(@NUMFACTURA,len(@NUMFACTURA)-1)            
                                                  
   SELECT Max(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                       
          TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                         
          SUM(Convert(int,TDDOCU_CLIE.CA_DOCU)) CANTIDADSERVICIO,                                
          TTSERV.DE_SERV NOMSERVICIOOFISIS,                                     
          TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                              
          TMTIEN.DE_TIEN NOMLOCALTIENDA,                                         
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA, --Esta es sin IGV                                                    
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) MONTODEVOLVER, --Este es el Monto Correcto                        
          CASE @Refactura WHEN 1 THEN 0 ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) END MONTOCORRECTODEVOLVER, --Este es el Monto a Devolver                        
          --'S' AFECTOIMP1,--MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS                         
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,                     
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1, --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,          
          CASE @Refactura WHEN 1 THEN 0                         
          ELSE CASE MAX(TDDOCU_CLIE.ST_IMP1) WHEN 'N' THEN SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 --SUM(TDDOCU_CLIE.IM_TOTA_DETA)--GOS(YQM) Modificado por Error en OFISIS                    
               ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 END                        
 END MONTOCORRECTODEVOLVERIGV                                                                                
   FROM OFIRECA.dbo.TDDOCU_CLIE,                                                           
        OFIRECA.dbo.TCDOCU_CLIE,                                        
        OFIRECA.dbo.TTSERV,                                
        OFIRECA.dbo.TTUNID_NEGO,                                
        OFIRECA.dbo.TMTIEN                                                        
   WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                          
   ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                         
   ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                          
   ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                                  
   AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                                        
   AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                                 
   AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                                        
   AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                                
   AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                                
   AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                                         
   AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                                 
   AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                                     
   AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                                 
   AND TCDOCU_CLIE.NU_DOCU  like '%' + @NUMFACTURA                                                        
   AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                                
   AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO                 
    AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                                                        
   GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                              
   ORDER BY TTSERV.DE_SERV  ,TTUNID_NEGO.DE_UNNE      
 END                                         
END   
GO
/****** Object:  StoredProcedure [dbo].[OFI_ObtenerDetalleFacturaOFISIS1]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT OFI_ObtenerDetalleFacturaOFISIS1  
  
ALTER PROCEDURE [dbo].[OFI_ObtenerDetalleFacturaOFISIS1]                                                          
@NUMFACTURA NVARCHAR(15),                                                  
@TIPMONEDA NVARCHAR(3),                             
@RUCCODIGO NVARCHAR(11),                                                 
@PARAM INT,                                                   
@REFACTURA INT                    
AS                    
--@PARAM = 1 Todo                                                  
--@PARAM = 2 Solo campos para CRM                                                  
--@REFACTURA = 1 No Refactura                    
--@REFACTURA = 2 Si Refactura                    
BEGIN                                       
IF (@TIPMONEDA = 'DÓL')                                  
    SELECT @TIPMONEDA = 'DOL'                                  
                                  
IF (@PARAM=1)                                                  
BEGIN                
 set @NUMFACTURA = right(@NUMFACTURA,len(@NUMFACTURA)-1)                                          
 SELECT  TCDOCU_CLIE.TI_DOCU TIPODOC,                                                       
         TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                       
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,1,4)) SERIEDOC,                                                    
         MAX(SubString(TCDOCU_CLIE.NU_DOCU,6,10)) NUMERODOC,                                                    
         MAX(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                       
         MAX(TCDOCU_CLIE.CO_MONE) MONEDA,                                                       
         TDDOCU_CLIE.CO_SERV CODSERVICIOOFISIS,                                       
         TTSERV.DE_SERV NOMSERVICIOOFISIS,                                    
         TDDOCU_CLIE.CO_UNNE UNIDADNEGOCIO,                                
         TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                                                   
         TDDOCU_CLIE.CO_TIEN LOCALTIENDA,                            
         TMTIEN.DE_TIEN NOMLOCALTIENDA,                                                       
         MAX(TCDOCU_CLIE.CO_IMP1) TIPOIMPUESTO1,                                                       
         --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado              
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,               
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1,    --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,                                                       
         MAX(TCDOCU_CLIE.CO_IMP2) TIPOIMPUESTO2,                                                       
         MAX(TDDOCU_CLIE.ST_IMP2) AFECTOIMP2,                                                       
         MAX(TCDOCU_CLIE.PC_IMP2) IMPUESTO2,                                                       
         MAX(TCDOCU_CLIE.CO_IMP3) TIPOIMPUESTO3,                                                       
         MAX(TDDOCU_CLIE.ST_IMP3) AFECTOIMP3,                                                       
         MAX(TCDOCU_CLIE.PC_IMP3) IMPUESTO3,                                                       
         SUM(TDDOCU_CLIE.CA_DOCU) CANTIDAD,                                                       
         SUM(TDDOCU_CLIE.PR_VENT)/count(*) PRECIOVENTASINIMP,                                                       
         SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA,                    
         MAX(TCDOCU_CLIE.CO_ESTA_DOCU) ESTADODOC                 
    FROM OFIRECA.dbo.TDDOCU_CLIE,                                                       
       OFIRECA.dbo.TCDOCU_CLIE,                                    
         OFIRECA.dbo.TTSERV,                                    
         OFIRECA.dbo.TTUNID_NEGO,                            
         OFIRECA.dbo.TMTIEN                                  
 WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                      
         ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                                                      
         ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                      
         ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                                                     
         AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                      
         AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                                  
         AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                                    
         AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                            
         AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                            
         AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                           
         AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                                    
     AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                          
         AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                        
         AND TCDOCU_CLIE.NU_DOCU  like '%' + @NUMFACTURA                                                    
         AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                                                    
         AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO             
         AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                          
 GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                          
 ORDER BY TTSERV.DE_SERV    
END                                               
ELSE                                                  
    IF (@PARAM=2)                                                  
 BEGIN             
         
 set @NUMFACTURA = right(@NUMFACTURA,len(@NUMFACTURA)-1)        
                                              
   SELECT Max(TCDOCU_CLIE.CO_CLIE) RUCCODIGO,                                                   
          TCDOCU_CLIE.NU_DOCU NUMDOCCOMPLETO,                                                     
          SUM(Convert(int,TDDOCU_CLIE.CA_DOCU)) CANTIDADSERVICIO,                            
          TTSERV.DE_SERV NOMSERVICIOOFISIS,                                 
          TTUNID_NEGO.DE_UNNE NOMUNIDADNEGOCIO,                          
          TMTIEN.DE_TIEN NOMLOCALTIENDA,                                     
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) TOTALPORLINEA, --Esta es sin IGV                                                
          SUM(TDDOCU_CLIE.IM_TOTA_DETA) MONTODEVOLVER, --Este es el Monto Correcto                    
          CASE @Refactura WHEN 1 THEN 0 ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) END MONTOCORRECTODEVOLVER, --Este es el Monto a Devolver                    
          --'S' AFECTOIMP1,--MAX(TDDOCU_CLIE.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS                     
        case when sum(TCDOCU_CLIE.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,                 
  case when MAX(TCDOCU_CLIE.FE_DOCU) >= '20110301' THEN MAX(TCDOCU_CLIE.PC_IMP1) ELSE 19 END IMPUESTO1, --MAX(TCDOCU_CLIE.PC_IMP1) IMPUESTO1,                    
          CASE @Refactura WHEN 1 THEN 0                     
          ELSE CASE MAX(TDDOCU_CLIE.ST_IMP1) WHEN 'N' THEN SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 --SUM(TDDOCU_CLIE.IM_TOTA_DETA)--GOS(YQM) Modificado por Error en OFISIS                
               ELSE SUM(TDDOCU_CLIE.IM_TOTA_DETA) + MAX(TCDOCU_CLIE.PC_IMP1) * SUM(TDDOCU_CLIE.IM_TOTA_DETA)/100 END                    
 END MONTOCORRECTODEVOLVERIGV                                                                            
   FROM OFIRECA.dbo.TDDOCU_CLIE,      
        OFIRECA.dbo.TCDOCU_CLIE,                                    
        OFIRECA.dbo.TTSERV,                            
        OFIRECA.dbo.TTUNID_NEGO,                            
        OFIRECA.dbo.TMTIEN                                                    
   WHERE ( TCDOCU_CLIE.NU_DOCU = TDDOCU_CLIE.NU_DOCU ) and                                                      
   ( TCDOCU_CLIE.TI_DOCU = TDDOCU_CLIE.TI_DOCU ) and                     
   ( TCDOCU_CLIE.CO_UNID = TDDOCU_CLIE.CO_UNID ) and                                                      
   ( TCDOCU_CLIE.CO_EMPR = TDDOCU_CLIE.CO_EMPR )                              
   AND (TDDOCU_CLIE.CO_EMPR = TTSERV.CO_EMPR)                                    
   AND (TDDOCU_CLIE.CO_SERV = TTSERV.CO_SERV)                             
   AND (TDDOCU_CLIE.CO_EMPR = TTUNID_NEGO.CO_EMPR)                                    
   AND (TDDOCU_CLIE.CO_UNNE = TTUNID_NEGO.CO_UNNE)                            
   AND (TDDOCU_CLIE.CO_EMPR = TMTIEN.CO_EMPR)                            
   AND (TDDOCU_CLIE.CO_TIEN = TMTIEN.CO_TIEN)                                                     
   AND ( ( TCDOCU_CLIE.CO_EMPR = '16' ) )                                             
   AND TCDOCU_CLIE.TI_DOCU = 'FAC'                                                 
   AND (TCDOCU_CLIE.CO_ESTA_DOCU = 'ACT' OR TCDOCU_CLIE.CO_ESTA_DOCU = 'PAG')                                             
   AND TCDOCU_CLIE.NU_DOCU  like '%' + @NUMFACTURA                                                    
   AND TCDOCU_CLIE.CO_MONE = @TIPMONEDA                            
   AND TCDOCU_CLIE.CO_CLIE = @RUCCODIGO             
    AND TMTIEN.DE_TIEN <>  'OLI PLUSPETROL'                                                    
   GROUP BY TCDOCU_CLIE.TI_DOCU, TCDOCU_CLIE.NU_DOCU, TDDOCU_CLIE.CO_SERV, TDDOCU_CLIE.CO_UNNE, TDDOCU_CLIE.CO_TIEN,TTSERV.DE_SERV,TTUNID_NEGO.DE_UNNE,TMTIEN.DE_TIEN                          
 END                                     
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_CAMPOSESPECIALESCREDITO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************  
Autor: GOS(YQM)        
Fecha: 20/07/2009      
Obj. : Actualizar fecha de modificación de cliente creado en CRM          
*********************************************************************/          
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_CAMPOSESPECIALESCREDITO]          
@AccountId  nvarchar(36),        
@ModifiedOn  datetime              
AS    
    
BEGIN    
--Declaraciones    
declare @msg nvarchar(100)      
--Proceso    
begin try      
  begin transaction    
 UPDATE Neptunia_MSCRM.dbo.AccountBase          
 SET ModifiedOn=@ModifiedOn             
 WHERE AccountId=@AccountId    
  commit transaction    
end try    
begin catch      
  set @msg=ERROR_MESSAGE()      
  rollback transaction      
  raiserror (@msg,11,1)      
 end catch      
END    
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_CAMPOSESPECIALESCUENTA]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------      
Objetivo: Actualizar fecha de creción y modificación      
          de cliente creado en CRM      
Fecha: 20/07/2009      
Autor: GOS(YQM)      
---------------------------------------------------*/      
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_CAMPOSESPECIALESCUENTA]      
@AccountId  nvarchar(36),            
@CreatedOn  datetime,            
@ModifiedOn  datetime          
AS              
BEGIN  
--Declaraciones  
declare @msg nvarchar(100)    
--Proceso     
 begin try    
  begin transaction  
 UPDATE Neptunia_MSCRM.dbo.AccountBase      
 SET CreatedOn=@CreatedOn,            
 ModifiedOn=@ModifiedOn         
 WHERE AccountId=@AccountId   
  commit transaction  
 end try  
 begin catch    
  set @msg=ERROR_MESSAGE()    
  rollback transaction    
  raiserror (@msg,11,1)    
 end catch    
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_CREDITO]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************  
Objetivo: Lee la tabla CREDITO para actualizar en CRM        
Autor: GOS(YQM)        
Fecha: 2009-07-16        
****************************************************************/        
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_CREDITO]        
AS        
--Actualizado:     
--   0 - Error      
--   1 - Actualizado      
BEGIN    
declare @msg nvarchar(100)      
BEGIN TRY    
  BEGIN TRANSACTION     
 --Recupero solo clientes existentes en CRM        
 SELECT A.AccountID,'Fecha_Modificacion'=dateadd(dd,-1,getdate()),C.*      
 FROM dbo.CREDITO C      
 inner join Neptunia_MSCRM.dbo.Account A on C.Ruc = A.AccountNumber Collate Latin1_general_CI_AS      
 Where deletionstatecode=0      
      
 --Actualizo los clientes que no existen en CRM      
 UPDATE dbo.CREDITO      
 SET Actualizado = 0, Observacion='Error - Cliente no existe en CRM'      
 Where RUC in (SELECT C.Ruc FROM dbo.CREDITO C      
   left join Neptunia_MSCRM.dbo.Account A on C.Ruc = A.AccountNumber Collate Latin1_general_CI_AS      
    where A.AccountNumber is null)      
  COMMIT TRANSACTION    
END TRY    
BEGIN CATCH    
  set @msg=ERROR_MESSAGE()      
  rollback transaction      
  raiserror (@msg,11,1)      
END CATCH     
      
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_CREDITO_CLIENTE_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------------------------------------------------  
Objetivo: Actualiza el campo Ingresado  
       1 = Actualizado en CRM  
       0 = Error al Actualizar Créditos en CRM  
Autor: GOS(YQM)  
Fecha: 2009-07-16  
------------------------------------------------------*/  
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_CREDITO_CLIENTE_CRM]  
@Ruc as nvarchar(20),  
@Actualizado as char(1),  
@Mensaje as nvarchar(100)  
as  
  
UPDATE dbo.CREDITO  
Set Actualizado = @Actualizado,   
    Observacion = @Mensaje  
Where Ruc = @Ruc
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_FORWARDERS_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------    
Objetivo: Lee los clientes Fordwarder de la BD   
          Intermedia para insertarlos en CRM.    
-------------------------------------------------------*/  
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_FORWARDERS_CRM]  
as  
  
SELECT A.AccountId,'Fecha_Modificacion'=dateadd(dd,-1,getdate()),CF.*   
FROM CLIENTE_FORWARDER CF  
INNER JOIN Neptunia_MSCRM.dbo.accountbase A ON CF.RUC=A.AccountNumber collate Latin1_general_CI_AS  
where A.deletionstatecode = 0 --No Eliminados
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_INGRESO_CLIENTE_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------------------------------------  
Objetivo: Actualizar el Proceso de inserción  
          y el mensaje de error o éxito  
Fecha: 20/07/2009  
Autor: GOS(YQM)  
-------------------------------------------*/  
  
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_INGRESO_CLIENTE_CRM]  
@Ruc as nvarchar(20),  
@Ingresado as char(1),  
@Mensaje as nvarchar(100)  
AS  
--1 = Creado en CRM  
--0 = Error al Crear en CRM  
UPDATE INTERFACE_CLIENTE  
Set Ingresado = @Ingresado,   
    Observacion = @Mensaje  
Where Ruc = @Ruc  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIO_MAIL_CLIENTES_CREDITOS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/**************************************************************************************                                
 Objetivo: Envía email a operario con los registros de créditos de clientes no        
           actualizados.            
 Autor: GOS(YQM)            
 Fecha Creacion: 20/07/2009            
***************************************************************************************/                               
ALTER PROCEDURE [dbo].[SP_ENVIO_MAIL_CLIENTES_CREDITOS]            
as  
--Declaración de Variables            
declare @fechaProceso char(10),                                
  @mensaje varchar(200),                                
  @email_destino varchar(100),                                
  @SentenciaSql varchar(1000),                                
  @nombre_archivo varchar(50)                                
                                
set @fechaProceso = convert(char(10), getdate(), 103)            
set @email_destino = 'yesenia.quispe@osmos.com'            
        
set @mensaje = 'Al ' + @fechaProceso + ' los créditos de los clientes listados en el archivo adjunto no han sido actualizadas en CRM.'            
set @SentenciaSql = 'select RUC, Actualizado, Observacion from EXTENSION_CRM.dbo.credito where Actualizado=0'          
set @nombre_archivo = 'Creditos_Clientes_NoReplicados_' + Convert(char(8),getdate(),112) + '.txt'            
        
EXEC msdb.dbo.sp_send_dbmail --@profile_name = 'ProfilePrueba',      
 @recipients = @email_destino,                   
 @subject = 'Alerta Créditos Clientes CRM No Replicados',    
 @body = @mensaje,                              
 @query = @SentenciaSql,                                
 @attach_query_result_as_file = 1,                              
 @query_attachment_filename = @nombre_archivo  
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIO_MAIL_CLIENTES_CRM_OFISIS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/**************************************************************************************                                  
 Objetivo: Envía email a operario con los registros no creados              
 Autor: GOS(YQM)              
 Fecha Creacion: 20/07/2009              
***************************************************************************************/                                  
ALTER PROCEDURE [dbo].[SP_ENVIO_MAIL_CLIENTES_CRM_OFISIS]              
as      
--Declaración de Variables              
declare @fechaProceso char(10),                                  
  @mensaje varchar(200),                                  
  @email_destino varchar(100),                                  
  @CCemail varchar(100),  
  @SentenciaSql varchar(1000),                                  
  @nombre_archivo varchar(50)                                  
                                  
set @fechaProceso = convert(char(10), getdate(), 103)              
set @email_destino = 'yesenia.quispe@osmos.com'    
set @CCemail = 'sgc.notificaciones@gruponeptunia.com'  
--enviando email con documentos a provisionar                                  
--set @mensaje = 'Al ' + @fechaProceso + ' los clientes listados en el archivo adjunto aun no han sido replicados en OFISIS o CRM.'              
--set @SentenciaSql = 'select RUC, Fecha_de_Ingreso,Sistema, Observacion, Ingresado from EXTENSION_CRM.dbo.INTERFACE_CLIENTE where Ingresado=0 OR Ingresado is null order by Fecha_de_Ingreso'            
--set @nombre_archivo = 'Clientes_CRM_OFISIS_NoReplicados_' + Convert(char(8),getdate(),112) + '.txt'              

set @mensaje = 'Al ' + @fechaProceso + ' los clientes listados en el archivo adjunto han sido procesados en OFISIS y CRM.'              
set @SentenciaSql = 'select RUC, Fecha_de_Ingreso,(CASE Sistema WHEN 1 THEN ''CRM'' ELSE ''OFISIS'' END) AS Cliente_de, (CASE Ingresado WHEN 1 THEN ''SI'' ELSE ''NO'' END) AS Ingresado, Observacion from EXTENSION_CRM.dbo.INTERFACE_CLIENTE order by Fecha_de_Ingreso'            
set @nombre_archivo = 'ReplicacionClientes-CRM-OFISIS-' + Convert(char(8),getdate(),112) + '.txt'              
              
          
EXEC msdb.dbo.sp_send_dbmail --@profile_name = 'ProfilePrueba',          
 @recipients = @email_destino,                     
 @copy_recipients = @CCemail,  
 --@subject = 'Alerta Clientes CRM - OFISIS No Replicados',              
 @subject = 'Alerta Replicacion de Clientes CRM-OFISIS',              
 @body = @mensaje,                                
 @query = @SentenciaSql,                                  
 @attach_query_result_as_file = 1,                                
 @query_attachment_filename = @nombre_archivo   
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIO_MAIL_MASIVO_TAREAS_PENDIENTES]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
--/**************************************************************************************                                    
-- Objetivo: Envía email a usuarios con tareas pendientes  
-- Autor: Diego Arango              
-- Fecha Creacion: 02-12-2011            
--***************************************************************************************/                                    
--ALTER PROCEDURE [dbo].[SP_ENVIO_MAIL_MASIVO_TAREAS_PENDIENTES]                
--as        
----Declaración de Variables                
--declare @fechaProceso char(10),                                    
--  @mensaje nvarchar(max),                                    
--  @email_destino varchar(100),                                    
--  @CCemail varchar(100),                                      
--  @nombre_archivo varchar(50),  
--  @recipients varchar(50),  
--  @copy_recipients varchar(50)  
--  
----todos los viernes   
--declare @i int  
--declare @codigo uniqueidentifier   
--declare @identificador INT   
--declare @mail varchar(200)  
--declare @usuarios table (  
--identificador int identity(1,1),  
--codigo uniqueidentifier,  
--nombre varchar(200),   
--mail varchar(200)  
--)  
--declare @tablatareas table(mensaje nvarchar(max))  
--insert @usuarios(codigo,nombre,mail)  
--select distinct apb.owninguser,  
--                su.fullname,  
--                su.internalemailaddress  
--       
--       from neptunia_mscrm.dbo.ActivityPointerBase   apb  
--inner join neptunia_mscrm.dbo.systemuser su on  apb.owninguser=su.systemuserid  
--inner join neptunia_mscrm.dbo.Incident inc on (apb.regardingObjectid=inc.IncidentId)  
--  
--where apb.statecode=0  
--and su.isdisabled=0  
--and apb.regardingobjecttypecode=112  
--and apb.activitytypecode=4212  
--and apb.deletionstatecode<>2  
--and su.deletionstatecode<>2  
--and inc.statecode=0  
--  
--set @i=1  
--select @identificador=count(*) from @usuarios  
--while (@i<= @identificador)    
--begin   
--  select @codigo= codigo from @usuarios where identificador=@i  
--  select @mensaje = 'Estimado ' + nombre  + ':<br>' +  'A la fecha de hoy usted tiene como pendientes las siguientes tareas:<br><br>'  from @usuarios where identificador=@i  select @mail =mail from @usuarios where identificador=@i  
--  insert into @tablatareas exec SP_OBTENER_FORMATO_MAIL_TAREAS @codigo  
--  select top 1 @mensaje=@mensaje+mensaje from @tablatareas  
--  set @mensaje=@mensaje+'<br><br>Si Ud. desea atender esta(s) tarea(s) por favor ingresar a : <a href="http://calw3appcrm001:5555">http://calw3appcrm001:5555</a> ó ingresar al área de trabajo mediante la bandeja de CRM en el cliente Outlook.<br>Agradecemos su atención para el cierre oportuno del caso.<br><br>Atte.<br>Administrador CRM'  
--  delete from @tablatareas  
--EXEC msdb.dbo.sp_send_dbmail --@profile_name = 'ProfilePrueba',            
-- @recipients = @mail,                       
-- @copy_recipients = 'admincrm@gruponeptunia.com',                 
-- @subject = 'Actividades Pendiente Caso CRM',                
-- @body = @mensaje,  
-- @body_format='HTML'  
--  set @i=@i+1  
--  
--end 
--GO
/****** Object:  StoredProcedure [dbo].[sp_guardar_clientes_crm_matarani]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_guardar_clientes_crm_matarani]
@ruc varchar(40),
@razonsocial varchar(320)
as
insert into CLIENTE_PAITA 
values (@ruc,@razonsocial,null,0,2)
GO
/****** Object:  StoredProcedure [dbo].[SP_GUARDAR_CLIENTES_OFISIS_A_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************          
Objetivo: Guarda los clientes de la BD Temporal de OFISIS a CRM, actualizados y creados día          
    antes a la fecha de proceso.                              
Autor: GOS(YQM)                              
Fecha_Creacion: 2009-07-15                              
**********************************************************************************************/                              
ALTER PROCEDURE [dbo].[SP_GUARDAR_CLIENTES_OFISIS_A_CRM]                              
AS                              
                              
if exists (select 1 from tempdb..sysobjects where name like '#TMP_CLIENTES_ACTUALIZAR' and type='U')                                      
   drop table #TMP_CLIENTES_ACTUALIZAR                          
if exists (select 1 from tempdb..sysobjects where name like '#TMP_CLIENTES_ACTUALIZAR' and type='U')                                      
   drop table #TMP_CLIENTES_INSERTAR            
        
--Obtener el menor nivel tarifario        
declare  @monmin as decimal        
declare  @MenorNivelTarifarioId as uniqueidentifier        
        
select @monmin=min(nep_montominimo)        
from Neptunia_MSCRM.dbo.nep_niveltarifario        
        
select @MenorNivelTarifarioId=nep_niveltarifarioid        
from Neptunia_MSCRM.dbo.nep_niveltarifario        
where nep_montominimo= @monmin        
                      
--Clientes a Actualizar                          
SELECT                
 C.Ruc,                            
 C.Origen,  -- 1=Nacional - 0=Extranjero                              
 C.Persona, -- 0=Juridica - 1=Natural                            
 C.Razon_Social,                            
 C.Linea_De_Credito,                            
 C.Plazo,                            
 C.Direccion,                            
 'Nep_UbigeoId'=U.Nep_UbigeoId,                            
 C.Correo,                            
 'EjeVenPortuarioId'=(select top 1 systemuserid from Neptunia_MSCRM.dbo.systemuser where deletionstatecode=0 AND isdisabled=0 AND ini_ej_po= nickname collate SQL_Latin1_General_CP1_CI_AS),                            
 'EjeVenLogisticoId'=(select top 1 systemuserid from Neptunia_MSCRM.dbo.systemuser where deletionstatecode=0 AND isdisabled=0 ANd ini_ej_lo=nickname collate SQL_Latin1_General_CP1_CI_AS),                          
 A.AccountID,                        
 C.Fecha_de_ingreso                        
INTO #TMP_CLIENTES_ACTUALIZAR                          
FROM INTERFACE_CLIENTE C                            
LEFT JOIN Neptunia_MSCRM.dbo.Nep_ubigeoextensionBase U ON C.Ubigeo=U.Nep_CodUbigeo collate SQL_Latin1_General_CP1_CI_AS                            
INNER JOIN Neptunia_MSCRM.dbo.Account A ON C.Ruc = A.AccountNumber collate Latin1_general_CI_AS                          
WHERE A.DeletionStateCode=0 AND A.statecode=0 AND A.StateCode=0 AND C.Sistema = 0 AND (isnull(Ingresado,'')='' OR Ingresado=0)--Clientes de OFISIS                              
                
--Clientes a Insertar                        
SELECT DISTINCT                            
 C.Ruc,                            
 C.Origen,  -- 1=Nacional - 0=Extranjero                              
 C.Persona, -- 0=Juridica - 1=Natural                            
 C.Razon_Social,                            
 C.Linea_De_Credito,                            
 C.Plazo,                            
 C.Direccion,                            
 'Nep_UbigeoId'=U.Nep_UbigeoId,                            
 C.Correo,                            
 'EjeVenPortuarioId'=(select top 1 systemuserid from Neptunia_MSCRM.dbo.systemuser where deletionstatecode=0 AND isdisabled=0 AND ini_ej_po= nickname collate SQL_Latin1_General_CP1_CI_AS),                            
 'EjeVenLogisticoId'=(select top 1 systemuserid from Neptunia_MSCRM.dbo.systemuser where deletionstatecode=0 AND isdisabled=0 ANd ini_ej_lo=nickname collate SQL_Latin1_General_CP1_CI_AS),                          
 A.AccountNumber,              
 C.Fecha_de_ingreso,        
 'NivelTarifarioId' = @MenorNivelTarifarioId,                         
 'NivelTarifarioActualId' = @MenorNivelTarifarioId      
INTO #TMP_CLIENTES_INSERTAR                          
FROM INTERFACE_CLIENTE C                            
LEFT JOIN Neptunia_MSCRM.dbo.Nep_ubigeoextensionBase U ON C.Ubigeo=U.Nep_CodUbigeo collate SQL_Latin1_General_CP1_CI_AS                            
LEFT JOIN Neptunia_MSCRM.dbo.Account A ON C.Ruc = A.AccountNumber collate Latin1_general_CI_AS                          
WHERE (A.AccountNumber is null AND Sistema = 0 AND (isnull(Ingresado,'')='' OR Ingresado=0)) OR --Nuevos y Clientes de OFISIS                              
 ((A.DeletionStateCode <> 0 AND not exists(select deletionstatecode from Neptunia_MSCRM.dbo.Account R              
where C.Ruc=R.accountnumber collate Latin1_general_CI_AS  AND R.deletionstatecode=0))AND Sistema = 0 AND A.AccountNumber is not null AND (isnull(Ingresado,'')=''  OR Ingresado=0 OR Ingresado='')) --Eliminados en CRM y Creados en OFISIS                   
   
                            
SELECT * from #TMP_CLIENTES_ACTUALIZAR                          
SELECT * FROM #TMP_CLIENTES_INSERTAR
GO
/****** Object:  StoredProcedure [dbo].[SP_GUARDAR_FORWARDERS_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------  
Objetivo: Limpiar Tabla y Obtener los clientes   
          Fordwarder de CRM.  
-------------------------------------------------------*/  
ALTER PROCEDURE [dbo].[SP_GUARDAR_FORWARDERS_CRM]  
AS  
  
--Limpiamos Tabla  
Delete from dbo.CLIENTE_FORWARDER  
  
--Insertamos clientes FWD  
Insert Into dbo.CLIENTE_FORWARDER (RUC)  
Select accountnumber   
From Neptunia_mscrm.dbo.account  
Where deletionstatecode=0 AND statecode = 0 AND customertypecode=4 
GO
/****** Object:  StoredProcedure [dbo].[SP_INTERFACE_CRM_OFISIS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*----------------------------------------------------    
Objetivo: Limpia la tabla: NEP_INTERFACE_CLIENTES    
Autor: GOS(YQM)    
Fecha_Creacion: 2009/07    
----------------------------------------------------*/    
ALTER PROCEDURE [dbo].[SP_INTERFACE_CRM_OFISIS]    
AS    
--Ingresado:   1 - Ingresado    0 - Error    
--Actualizado: 1 - Actualizado  0 - Error    
    
--Elimina solo los ingresados y actualizados    
DELETE FROM dbo.INTERFACE_CLIENTE   
DELETE FROM dbo.CREDITO 
GO
/****** Object:  StoredProcedure [dbo].[SP_LIMPIAR_RANKING_FACTURACION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************  
Objetivo: Obtiene los clientes con ranking de facturación  
          de semestres pasados.  
Autor: GOS(YQM)  
Fecha: 10/08/2009  
***********************************************************/  
ALTER PROCEDURE [dbo].[SP_LIMPIAR_RANKING_FACTURACION]  
AS  
SELECT  
accountid,  
nep_rankingdefacturacindelogistica,   
nep_rankingdefacturacinportuario,  
'Fecha_Modificacion'=dateadd(dd,-1,getdate()),  
accountnumber,  
deletionstatecode  
FROM Neptunia_MSCRM.dbo.account  
WHERE ((isnull(nep_rankingdefacturacindelogistica,0) > 0) OR   
(isnull(nep_rankingdefacturacinportuario,0)>0)) and deletionstatecode=0  
GO
/****** Object:  StoredProcedure [dbo].[SP_NIVEL_TARIFARIO_RANKING_FACTURACION]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************              
Objetivo: Calcular Ranking de Facturación y Nivel Tarifario            
Autor: GOS(YQM)              
Creación: 2009/07/21              
*************************************************************/              
ALTER PROCEDURE [dbo].[SP_NIVEL_TARIFARIO_RANKING_FACTURACION]              
AS              
              
if exists (select 1 from tempdb..sysobjects where name like '#tmpRankingLog%' and type='U')                          
   drop table #tmpRankingLog              
if exists (select 1 from tempdb..sysobjects where name like '#tmpRankingPor%' and type='U')                          
   drop table #tmpRankingPor              
if exists (select 1 from tempdb..sysobjects where name like '#tmpNivelTarifario%' and type='U')                          
   drop table #tmpNivelTarifario              
--Definición de tablas temporales              
create table #tmpRankingLog              
(              
 id_Orden int identity(1,1),              
 RUC nvarchar(20),              
 Facturacion Numeric(16,3),              
    Primary Key(id_Orden)              
)              
CREATE UNIQUE INDEX indx_FacLog ON #tmpRankingLog (RUC)              
              
create table #tmpRankingPor              
(              
 id_Orden int identity(1,1),              
 RUC nvarchar(20),              
 Facturacion Numeric(16,3),              
    Primary Key(id_Orden)              
)              
CREATE UNIQUE INDEX indx_FacPor ON #tmpRankingPor (RUC)              
            
create table #tmpNivelTarifario            
(              
 RUC nvarchar(20),              
 NivelTarifario char(1),              
 Primary Key(RUC)              
)              
            
--Ranking Logistico              
Begin Transaction TRX_RankingLog              
insert into #tmpRankingLog              
SELECT RUC, Facturacion_Log              
FROM CLIENTE_FACTURACION              
ORDER BY Facturacion_Log desc              
              
UPDATE CLIENTE_FACTURACION              
SET CLIENTE_FACTURACION.Ranking_Log = (Select Id_orden from #tmpRankingLog where #tmpRankingLog.RUC = CLIENTE_FACTURACION.RUC)              
Commit Transaction TRX_RankingLog              
              
--Ranking Portuario              
Begin Transaction TRX_RankingPor              
insert into #tmpRankingPor              
SELECT RUC, Facturacion_Por              
FROM CLIENTE_FACTURACION              
ORDER BY Facturacion_Por desc              
              
UPDATE CLIENTE_FACTURACION              
SET CLIENTE_FACTURACION.Ranking_Por = (Select Id_orden from #tmpRankingPor where #tmpRankingPor.RUC = CLIENTE_FACTURACION.RUC)              
Commit Transaction TRX_RankingPor              
              
--Cálculo Nivel Tarifario            
declare @A decimal,          
  @B decimal,            
  @C decimal,           
  @D decimal          
select @A=Nep_MontoMaximo from Neptunia_MSCRM.dbo.Nep_NivelTarifario where substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)  ='A'          
select @B=Nep_MontoMaximo from Neptunia_MSCRM.dbo.Nep_NivelTarifario where substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)  ='B'          
select @C=Nep_MontoMaximo from Neptunia_MSCRM.dbo.Nep_NivelTarifario where substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)  ='C'          
select @D=Nep_MontoMaximo from Neptunia_MSCRM.dbo.Nep_NivelTarifario where substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)  ='D'          
          
Begin Transaction TRX_NivelTarifario          
Insert into #tmpNivelTarifario            
Select Ruc,            
case             
when (Facturacion_Log + Facturacion_Por + Facturacion_Com)<= @D then 'D'            
when (Facturacion_Log + Facturacion_Por + Facturacion_Com)<= @C then 'C'            
when (Facturacion_Log + Facturacion_Por + Facturacion_Com)<= @B then 'B'            
when (Facturacion_Log + Facturacion_Por + Facturacion_Com)<= @A then 'A'            
else 'A'            
end            
from CLIENTE_FACTURACION            
            
UPDATE CLIENTE_FACTURACION            
SET Nivel_Tarifario = (Select NivelTarifario From #tmpNivelTarifario where CLIENTE_FACTURACION.RUC=#tmpNivelTarifario.RUC)            
Commit Transaction TRX_NivelTarifario          
            
--Eliminando Temporales            
drop table #tmpRankingLog            
drop table #tmpRankingPor            
drop table #tmpNivelTarifario            
            
---Recupero Id de Niveles tarifarios            
select Nep_niveltarifarioId,'NT'=substring(reverse(Nep_name),1,charindex(' ',reverse(Nep_name))-1)            
into #tmpNY            
from Neptunia_MSCRM.dbo.Nep_NivelTarifario            
where deletionstatecode=0            
            
CREATE UNIQUE INDEX indx_NT ON #tmpNY (NT)              
            
--Clientes de CRM            
Select A.AccountId, C.RUC,C.Ranking_Log, C.Ranking_Por,C.Nivel_Tarifario,N.Nep_niveltarifarioId,'Fecha_Modificacion'=dateadd(dd,-1,getdate())            
From CLIENTE_FACTURACION C            
inner Join Neptunia_MSCRM.dbo.AccountBase A ON C.Ruc = A.AccountNumber COLLATE Latin1_general_CI_AS            
inner Join #tmpNY N ON C.Nivel_Tarifario = N.NT COLLATE Latin1_general_CI_AS       
where A.deletionstatecode=0 and A.statecode=0  
            
--Eliminando Temporales            
drop table #tmpNY   
GO
/****** Object:  StoredProcedure [dbo].[SP_OBTENER_CLIENTES_CRM]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************  
Objetivo: Obtiene y guarda los clientes actualizados y creados               
el día anterior en CRM a la BD temporal,              
tabla: INTERFACE_CLIENTE.              
Autor: GOS(YQM)              
Fecha_Creacion: 2009-07-15              
****************************************************************/              
ALTER PROCEDURE [dbo].[SP_OBTENER_CLIENTES_CRM]              
AS    
--Sistema: 0 - OFISIS          
--         1 - CRM          
--Definiciòn de Varialbes          
DECLARE           
    @mensaje_error nvarchar(100),          
    @Num_Reg int,          
    @Reg int,          
    @RUC nvarchar(20),          
    @Fecha_de_ingreso datetime,          
 @TmpFecha_de_ingreso datetime,          
    @TmpOrigen nvarchar(3),          
 @TmpPersona char(1),          
 @TmpRazon_Social nvarchar(100),          
 @TmpLinea_de_credito Numeric (16,3),          
 @TmpPlazo             Int,          
 @TmpDireccion nvarchar(200),          
 @TmpUbigeo nvarchar(10),          
 @TmpCorreo nvarchar(100),          
 @TmpIni_Ej_Po nvarchar(4),          
 @TmpIni_Ej_Lo nvarchar(4)          
          
--Definición De Tablas Temporales       
if exists (select 1 from tempdb..sysobjects where name like '#tmpClienteCRM%' and type='U')                
   drop table #tmpClienteCRM       
    
CREATE TABLE #tmpClienteCRM          
(          
 id_Reg int identity(1,1),          
 RUC  nvarchar(20),          
 Origen nvarchar(3),          
 Persona char(1),          
 Fecha_de_ingreso datetime,          
 Razon_Social nvarchar(100),          
 Linea_de_credito Numeric (16,3),          
 Plazo             Int,          
 Direccion nvarchar(200),          
 Ubigeo nvarchar(10),          
 Correo nvarchar(100),          
 Ini_Ej_Po nvarchar(4),          
 Ini_Ej_Lo nvarchar(4),          
 Sistema char(1),          
 Ingresado char(1),          
 Proceso char(1), --Ve Campo      
 Empresa nvarchar(2),        
 Primary Key(id_Reg)          
)          
BEGIN TRANSACTION Trx_CargaClientesCRM          
   INSERT INTO #tmpClienteCRM          
   SELECT A.accountnumber,A.nep_origen, A.nep_persona,              
   dateadd(hh,-5,A.Modifiedon),A.name,A.nep_lineadecredito,              
   A.nep_plazo,A.address1_name,U.nep_CodUbigeo,A.emailaddress1,              
   'nep_ejecutivoventaportuario'= (Select Nickname from Neptunia_MSCRM.dbo.SystemUser where SystemUserid=nep_ejecutivoventaportuarioid),            
   'nep_ejecutivoventalogistico'= (Select Nickname from Neptunia_MSCRM.dbo.SystemUser where SystemUserid=nep_ejecutivoventalogisticoid),            
   1, --CRM           
   NULL, --Ingresado en el sistema destinatario              
   NULL,    
   '01'              
   FROM Neptunia_MSCRM.dbo.account A              
   LEFT JOIN Neptunia_MSCRM.dbo.Nep_ubigeo U ON A.nep_ubigeocuentaid = U.Nep_ubigeoId            
   WHERE A.DeletionStatecode=0 AND convert(nvarchar(10),dateadd(hh,-5,A.Modifiedon),103)= convert(nvarchar(10),dateadd(dd,-1,getdate()),103) --AND A.nep_persona=0 --Juridica           
          
   IF @@error<>0          
   Begin          
     set @mensaje_error='Error al ingresar los clientes de CRM...'          
   End          
COMMIT TRANSACTION Trx_CargaClientesCRM          
          
--Validar Clientes a ingresar          
Select @Num_Reg = max(id_Reg) from #tmpClienteCRM          
Select @Reg = min(id_Reg) from #tmpClienteCRM          
--Recorro los clientes a insertar          
WHILE (@Reg<=@Num_Reg)          
BEGIN          
   Select @RUC=Ruc, @TmpOrigen=Origen, @TmpPersona=Persona,          
          @TmpFecha_de_ingreso=Fecha_de_ingreso, @TmpRazon_Social=Razon_Social,          
          @TmpLinea_de_credito=Linea_de_credito, @TmpPlazo=Plazo, @TmpDireccion=Direccion,          
          @TmpUbigeo=Ubigeo, @TmpCorreo=Correo, @TmpIni_Ej_Po = Ini_Ej_Po,          
          @TmpIni_Ej_Lo=Ini_Ej_Lo           
   from #tmpClienteCRM where Id_Reg=@Reg          
          
   If exists (Select 1 from dbo.INTERFACE_CLIENTE where RUC=@RUC)          
   Begin --Actualiza Cliente mas reciente          
      select @Fecha_de_ingreso=Fecha_de_ingreso from dbo.INTERFACE_CLIENTE where RUC=@RUC          
      If (@TmpFecha_de_ingreso>@Fecha_de_ingreso)          
      Begin    
         Update dbo.INTERFACE_CLIENTE          
         Set Origen=@TmpOrigen, Persona=@TmpPersona,          
    Fecha_de_ingreso=@TmpFecha_de_ingreso, Razon_Social=@TmpRazon_Social,          
             Linea_de_credito=@TmpLinea_de_credito, Plazo=@TmpPlazo ,Direccion=@TmpDireccion,          
             Ubigeo=@TmpUbigeo, Correo=@TmpCorreo, Ini_Ej_Po=@TmpIni_Ej_Po,          
             Ini_Ej_Lo=@TmpIni_Ej_Lo,Sistema=1          
         Where Ruc=@RUC          
   End    
   End          
   Else --Inserta Cliente          
   Begin          
      Insert into dbo.INTERFACE_CLIENTE     
      Values(@RUC,@TmpOrigen,@TmpPersona,@TmpFecha_de_ingreso,@TmpRazon_Social,    
    @TmpLinea_de_credito,@TmpPlazo,@TmpDireccion, @TmpUbigeo, @TmpCorreo,    
    @TmpIni_Ej_Po,@TmpIni_Ej_Lo,1,'01',NULL,NULL)    
   End          
   Select @Reg = @Reg + 1          
END    
GO
/****** Object:  StoredProcedure [dbo].[SP_OBTENER_FORMATO_MAIL_TAREAS]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/**************************************************************************************                                  
 Objetivo: Envía email 
 Autor: Diego Arango		          
 Fecha Creacion: 02-12-2011
 Prueba: SP_OBTENER_FORMATO_MAIL_TAREAS '8F7FFADA-B823-426E-9EB9-2376B59D1B6F'             
***************************************************************************************/                                  
ALTER PROCEDURE [dbo].[SP_OBTENER_FORMATO_MAIL_TAREAS]              
@GUID_USER uniqueidentifier
as  
BEGIN

declare @html nvarchar(max)
declare @cont int
set @cont=0
set @html='<font face="tahoma" size="4">
<table border="1" cellpadding="4" cellspacing="0" style="font-size: 10pt;">
<tr bgcolor="#0B0B61">
<td><font color="white">Id</font></td>
<td><font color="white">Caso</font></td>
<td><font color="white">Cliente</font></td>
<td><font color="white">Tipo de Cliente</font></td>
<td><font color="white">Tarea</font></td>
<td><font color="white">Vencimiento</font></td>
<td><font color="white">Días Vencidos</font></td>
</tr>'
select
@cont=@cont+1,
@html=@html+'<tr><td>'+convert(nvarchar,@cont)+'</td>',
@html=@html+'<td>'+substring(inc.ticketnumber,1,9)+'</td>',
@html=@html+'<td>'+cli.name+'</td>',
@html=@html+'<td>'+seg.value+'</td>',
@html=@html+ 
case 
when substring(act.subject,len(act.subject)-15,4)='CAS-' 
then '<td>'+replace (substring(act.subject,1,len(act.subject)-16),':','')+'</td>'
else '<td>'+replace(act.subject,':','')+'</td>'
end
,
@html=@html+'<td>'+isnull(convert(nvarchar(max),act.scheduledend-convert(datetime,'05:00:00'), 103),'No especificado')+'</td>',
@html=@html+
case when (act.scheduledend is null or (act.scheduledend-convert(datetime,'05:00:00'))>getdate()) then '<td>0</td></tr>'
else
'<td>'+convert(nvarchar,datediff(day,act.scheduledend-convert(datetime,'05:00:00'),getdate()))+'</td></tr>'
end
from neptunia_mscrm.dbo.ActivityPointerBase act
inner join neptunia_mscrm.dbo.Incident inc on (regardingObjectid=incidentid)
inner join neptunia_mscrm.dbo.AccountBase cli on (cli.accountid=inc.accountId)
inner join neptunia_mscrm.dbo.incidentextensionBase incex on (incex.incidentid=inc.incidentid)
inner join neptunia_mscrm.dbo.stringmap seg on (objecttypecode=112 and attributename='nep_segmento' and attributevalue=incex.nep_segmento)
where 
act.statecode=0
and act.deletionstatecode!=2
and act.owningUser=@GUID_USER
and act.activitytypecode=4212
and inc.statecode=0

set @html=@html+'</table></font>'
select @html

END 

GO
/****** Object:  StoredProcedure [dbo].[SP_OBTENER_OPORTUNIDADES_TERMINAL]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***********************************************************    
Objetivo: Obtiene las oportunidades de terminal.    
Autor: GOS(YQM)    
Fecha: 26/01/2010    
***********************************************************/    
ALTER PROCEDURE [dbo].[SP_OBTENER_OPORTUNIDADES_TERMINAL]  
AS
SELECT    
 OPO.opportunityid,  
 OPO.nep_diasporvencerorigen,  
 OPO.nep_diasporvencer,
 OPO.accountidname,
 OPO.createdon  
FROM Neptunia_MSCRM.dbo.opportunity OPO  
WHERE (  
 OPO.deletionstatecode=0  
 AND OPO.nep_escreadoporbatch = 1 --Creado por Batch Oportunidades Masivas  
 AND OPO.nep_diasporvencer > 0 --No vencidas  
 AND OPO.statecode = 0 --Abiertas  
)


GO
/****** Object:  StoredProcedure [dbo].[sp_Verif_clientes_gesfor_facturacion_utilitario]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Verif_clientes_gesfor_facturacion_utilitario] --'20296353664' 
@ruc varchar(11)
as
select ruc from CLIENTE_PAITA where
ruc = @ruc
GO
/****** Object:  StoredProcedure [dbo].[TAR_EvaluarCodigoUnidadNegocio]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
                                                                                                                                                                                                                                                         
-- =============================================    
                                                                                                                                                                                                         
-- Author:  Christian Villanueva    
                                                                                                                                                                                                                         
-- Description: Valida la Unidad de Negocio ingresada en CRM    
                                                                                                                                                                                             
-- Valores de Prueba:    
                                                                                                                                                                                                                                    
-- Fecha de Creacion: 21/08/2009    
                                                                                                                                                                                                                         
-- Fecha de Modificacion :    
                                                                                                                                                                                                                               
-- =============================================    
                                                                                                                                                                                                         
ALTER PROCEDURE [dbo].[TAR_EvaluarCodigoUnidadNegocio]    
                                                                                                                                                                                                  
 @CodigoOrigen  INT    
                                                                                                                                                                                                                                      
AS    
                                                                                                                                                                                                                                                       
BEGIN    
                                                                                                                                                                                                                                                    
     
                                                                                                                                                                                                                                                        
 DECLARE @CodResultado  INT    
                                                                                                                                                                                                                              
 SET NOCOUNT ON;    
                                                                                                                                                                                                                                         
    
                                                                                                                                                                                                                                                         
 /* VERIFICAR SI CODIGO EN EL ERP, DE NO EXISTIR DEVUELVE 0 */    
                                                                                                                                                                                           
        
                                                                                                                                                                                                                                                     
 SET @CodResultado = ( SELECT dc_centro_costo     
                                                                                                                                                                                                           
      FROM [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.TTUNID_NEGO    
                                                                                                                                                                                            
      WHERE dc_centro_costo = @CodigoOrigen    
                                                                                                                                                                                                              
      )    
                                                                                                                                                                                                                                                  
     
                                                                                                                                                                                                                                                        
 IF @CodResultado IS NULL    
                                                                                                                                                                                                                                
 BEGIN    
                                                                                                                                                                                                                                                   
  SELECT 0    
                                                                                                                                                                                                                                               
  RETURN    
                                                                                                                                                                                                                                                 
 END    
                                                                                                                                                                                                                                                     
 /* VERIFICAR SI CODIGO YA ESTA RELACIONADO EN CRM, DE EXISTIR DEVUELVE 1*/    
                                                                                                                                                                              
 SET @CodResultado = ( SELECT COD_ORIGEN     
                                                                                                                                                                                                                
      FROM EXTENSION_CRM.dbo.UNIDADNEGOCIOS    
                                                                                                                                                                                                              
      WHERE COD_ORIGEN = @CodigoOrigen    
                                                                                                                                                                                                                   
      )    
                                                                                                                                                                                                                                                  
 IF @CodResultado  IS NOT NULL    
                                                                                                                                                                                                                           
 BEGIN    
                                                                                                                                                                                                                                                   
  SELECT 1    
                                                                                                                                                                                                                                               
  RETURN    
                                                                                                                                                                                                                                                 
 END    
                                                                                                                                                                                                                                                     
 /* */    
                                                                                                                                                                                                                                                   
 SELECT 2    
                                                                                                                                                                                                                                                
 SET NOCOUNT OFF;    
                                                                                                                                                                                                                                        
END    
                                                                                                                                                                                                                                                      
GO
/****** Object:  StoredProcedure [dbo].[TAR_EvaluarFacturacionRealEstimada]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Text                                                                                                                                                                                                                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--      
--                                                                                                                                                                                                                                                       
---- =============================================      
--                                                                                                                                                                                                       
---- Author:  Juan Carlos Urrelo  
--                                                                                                                                                                                                                             
---- Description: Evaluar la facturacion estimada si se obtiene 1 quiere decir que se manda la alerta si es 0 no se realiza nada   
--                                                                                                                            
---- Valores de Prueba:    [TAR_EvaluarFacturacionRealEstimada]   '10082122830',30,11,30000,'20110607',1  
--                                                                                                                                                     
---- Fecha de Creacion: 09/06/2011      
--                                                                                                                                                                                                                       
---- Fecha de Modificacion :      
--                                                                                                                                                                                                                             
---- =============================================      
--                                                                                                                                                                                                       
--ALTER PROCEDURE [dbo].[TAR_EvaluarFacturacionRealEstimada]      
--                                                                                                                                                                                            
-- @RucCliente  NVARCHAR(11),  
--                                                                                                                                                                                                                                
-- @UnidadNegocio INT,  
--                                                                                                                                                                                                                                       
-- @Concepto INT,  
--                                                                                                                                                                                                                                            
-- @FacturacionEstimada DECIMAL(16,4),  
--                                                                                                                                                                                                                       
-- @FechaCotizacionAceptada NVARCHAR(11),  
--                                                                                                                                                                                                                    
-- @PeriodoEvaluar INT   
--                                                                                                                                                                                                                                      
--AS      
--                                                                                                                                                                                                                                                     
--BEGIN      
--                                                                                                                                                                                                                                                  
--  
--                                                                                                                                                                                                                                                           
--  DECLARE @IdUsuarioNoDefinidoPOR int  
--                                                                                                                                                                                                                      
--  DECLARE @IdUsuarioNoDefinidoLOG int  
--                                                                                                                                                                                                                      
--  DECLARE @IdClienteNoDefinidoFinal int  
--                                                                                                                                                                                                                    
--  DECLARE @RUCClienteNoDefinido varchar(4)  
--                                                                                                                                                                                                                 
--  DECLARE @NomUsuarioNoDefinidoPOR varchar(50)  
--                                                                                                                                                                                                             
--  DECLARE @NomUsuarioNoDefinidoLOG varchar(50)  
--                                                                                                                                                                                                             
--  DECLARE @NomClienteNoDefinidoFinal varchar(50)  
--                                                                                                                                                                                                           
--  DECLARE @IdUNINEGNoDefinido int   
--                                                                                                                                                                                                                         
--  DECLARE @NomUNINEGNoDefinido varchar(15)  
--                                                                                                                                                                                                                 
--  DECLARE @IdTiempoDefecto int  
--                                                                                                                                                                                                                             
--  DECLARE @IdOrganizacionNoDefinido int  
--                                                                                                                                                                                                                    
--  DECLARE @NuevaOrganizacion int   
--                                                                                                                                                                                                                          
--  DECLARE @FechaFacturacionObtenida decimal(16,4)  
--                                                                                                                                                                                                          
--  DECLARE @PeriodoReal int  
--                                                                                                                                                                                                                                 
--  
--                                                                                                                                                                                                                                                           
--  SET @IdUsuarioNoDefinidoPOR = 2  
--                                                                                                                                                                                                                          
--  SET @IdUsuarioNoDefinidoLOG = 1  
--                                                                                                                                                                                                                          
--  SET @IdTiempoDefecto = 1  
--                                                                                                                                                                                                                                 
--  SET @IdOrganizacionNoDefinido = 1  
--                                                                                                                                                                                                                        
--  SET @RUCClienteNoDefinido = 'XXX1'  
--                                                                                                                                                                                                                       
--  SET @IdUNINEGNoDefinido = 999  
--                                                                                                                                                                                                                            
--  SET @NomUNINEGNoDefinido = 'NO DEFINIDO'  
--                                                                                                                                                                                                                 
--  SELECT @IdClienteNoDefinidoFinal = Cliente_Id,@NomClienteNoDefinidoFinal=Cliente_Nombre FROM  CALW3BDSGC2.DmNeptunia.DBO.DimCliente WHERE Cliente_RUC = @RUCClienteNoDefinido  
--                                                                            
--  SELECT @NomUsuarioNoDefinidoPOR = Usuario_Nombre from CALW3BDSGC2.DmNeptunia.DBO.dimUsuario where Usuario_Id = @IdUsuarioNoDefinidoPOR  
--                                                                                                                   
--  SELECT @NomUsuarioNoDefinidoLOG = Usuario_Nombre from  CALW3BDSGC2.DmNeptunia.DBO.DimUsuario where Usuario_Id = @IdUsuarioNoDefinidoLOG  
--                                                                                                                  
--  SELECT @NuevaOrganizacion= Organizacion_Id FROM CALW3BDSGC2.DmNeptunia.dbo.DimOrganizacion where unidadnegocio_id=@UnidadNegocio and  concepto_id=@Concepto  
--                                                                                              
--  IF (@PeriodoEvaluar=1)  
--                                                                                                                                                                                                                                   
--  BEGIN  
--                                                                                                                                                                                                                                                    
--  SET @PeriodoReal=3  
--                                                                                                                                                                                                                                       
--  END  
--                                                                                                                                                                                                                                                      
--  ELSE  
--                                                                                                                                                                                                                                                     
--  BEGIN  
--                                                                                                                                                                                                                                                    
--  SET @PeriodoReal=6  
--                                                                                                                                                                                                                                       
--  END  
--                                                                                                                                                                                                                                                      
--    
--                                                                                                                                                                                                                                                         
--  IF (@PeriodoReal=3)  
--                                                                                                                                                                                                                                      
--  BEGIN  
--                                                                                                                                                                                                                                                    
--  SET @FacturacionEstimada=@FacturacionEstimada/2  
--                                                                                                                                                                                                          
--  END  
--                                                                                                                                                                                                                                                      
--  
--                                                                                                                                                                                                                                                           
--    
--                                                                                                                                                                                                                                                         
----SELECT A.veNTAS_FACTURACIONSOLES FROM (  
--                                                                                                                                                                                                                  
--SET @FechaFacturacionObtenida =(SELECT   
--                                                                                                                                                                                                                    
--  
--                                                                                                                                                                                                                                                           
--CASE DOC.I003_Moneda   
--                                                                                                                                                                                                                                      
-- WHEN 10 THEN SUM(ITE.Importe)  
--                                                                                                                                                                                                                             
-- WHEN 12 THEN SUM(CASE DOC.TipoCambio WHEN 0 THEN 0 ELSE ITE.Importe * DOC.TipoCambio END)  
--                                                                                                                                                                 
--END as Ventas_FacturacionSoles  
--                                                                                                                                                                                                                             
--  
--                                                                                                                                                                                                                                                           
--FROM CALW3BDSGC2.DmNeptunia_stg.FAC.Documento DOC --order by DOC.Ident_Cliente   
--                                                                                                                                                                            
--left join (  
--                                                                                                                                                                                                                                                
--  Select MAX(Valor) as OrdenServicio, CNT.Ident_Documento From CALW3BDSGC2.DmNeptunia_stg.FAC.CntDocumento CNT   inner join CALW3BDSGC2.DmNeptunia_stg.FAC.CntDocumentoXCondicion CXC on CNT.Ident_CntDocumento = CXC.Ident_CntDocumento   where CXC.Ident_Condicion = 13   
--                                                                                                                                                                                                                                                
--  group by CNT.Ident_Documento  
--                                                                                                                                                                                                                             
--) OrdSer on (DOC.Ident_Documento = OrdSer.Ident_Documento)  
--                                                                                                                                                                                                 
--LEFT JOIN CALW3BDSGC2.dmneptunia.dbo.DimTiempo TIE ON (  
--                                                                                                                                                                                                    
--    TIE.Tiempo_Anio = DATEPART(YEAR,DOC.Emision)   
--                                                                                                                                                                                                          
--and TIE.Tiempo_MesNumero = DATEPART(MONTH,DOC.Emision)  
--                                                                                                                                                                                                     
--and TIE.Tiempo_Dia = DATEPART(DAY,DOC.Emision)  
--                                                                                                                                                                                                             
--)  
--                                                                                                                                                                                                                                                          
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Contabilizacion CONTA ON (CONTA.Ident_Documento = DOC.Ident_Documento)  
--                                                                                                                                           
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Serie SIE ON (SIE.Ident_serie= DOC.Ident_Serie)  
--                                                                                                                                                                  
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.TipoDocumento TDOC ON (TDOC.Ident_Tipodocumento = SIE.Ident_TipoDocumento)  
--                                                                                                                                       
--left join CALW3BDSGC2.dmneptunia.dbo.DimCliente CLI ON (CLI.Cliente_RUC = DOC.Ident_Cliente )  
--                                                                                                                                                              
--LEFT JOIN (  
--                                                                                                                                                                                                                                                
--      SELECT MIN(Usuario_Id) AS Usuario_Id,Usuario_Codigo, Usuario_Nombre  
--                                                                                                                                                                                  
--      FROM CALW3BDSGC2.dmneptunia.dbo.DimUsuario  
--                                                                                                                                                                                                           
--      GROUP by Usuario_Codigo, Usuario_Nombre  
--                                                                                                                                                                                                              
-- )USU ON (CLI.Cliente_IdEjecVentaPortuario = USU.Usuario_Codigo)  
--                                                                                                                                                                                           
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Operacion OPE ON (OPE.Ident_Operacion = DOC.Sustento and I030_Sustento=93)  
--                                                                                                                                       
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Configuracion CONF ON (CONF.Ident_Configuracion=OPE.Ident_Configuracion)  
--                                                                                                                                         
--  
--                                                                                                                                                                                                                                                           
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Concepto CON ON (CONF.Ident_Concepto=CON.Ident_Concepto)  
--                                                                                                                                                         
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.ItemDocumento ITE ON (Doc.Ident_Documento = ITE.Ident_Documento)  
--                                                                                                                                                 
--inner join CALW3BDSGC2.dmneptunia.dbo.DimOrganizacion ORG ON (ORG.UnidadNegocio_Id = ITE.Ident_UnidadNegocio)  
--                                                                                                                                              
--inner join CALW3BDSGC2.DmNeptunia_stg.FAC.Servicio SER ON (SER.Ident_Servicio = ITE.Ident_Servicio)  
--                                                                                                                                                        
--where DOC.I030_Sustento=93 AND OrdSer.OrdenServicio is not null  
--                                                                                                                                                                                            
-- AND CLI.Cliente_RUC=@RucCliente  
--                                                                                                                                                                                                                           
--    AND org.Organizacion_id=@NuevaOrganizacion  
--                                                                                                                                                                                                             
--    AND DOC.Emision BETWEEN @FechaCotizacionAceptada AND dateadd(mm,@PeriodoReal, @FechaCotizacionAceptada)  
--                                                                                                                                                
-- and DOC.EstadoEliminacionFuente <> 1 --1 Eliminado  
--                                                                                                                                                                                                        
----GROUP BY TDOC.Ident_Tipodocumento,TDOC.Nombre ,CONTA.Numerodocumento, CLI.Cliente_Id, CLI.Cliente_Nombre, CLI.Cliente_RUC --,CLI.RazonSocial,CLI.Ruc, DOC.Ident_Cliente  
--                                                                                  
----,USU.Usuario_Id,USU.Usuario_Nombre,CONF.Ident_UnidadNegocio ,ORG.UnidadNegocio_Nombre,CON.Nombre ,ITE.Ident_Servicio   
--                                                                                                                                    
----,ITE.Ident_Servicio ,SER.NombreServicio ,DOC.Emision,DOC.Moneda,DOC.I003_Moneda ,org.Organizacion_id,OrdSer.OrdenServicio  
--                                                                                                                                
----,TIE.Tiempo_Id    
--                                                                                                                                                                                                                                         
--GROUP BY   
--                                                                                                                                                                                                                                                  
--DOC.I003_Moneda)  
--                                                                                                                                                                                                                                           
-- --order by Ventas_DocumentoNumero  
--                                                                                                                                                                                                                         
--  
--                                                                                                                                                                                                                                                           
----) A  
--                                                                                                                                                                                                                                                      
--  
--                                                                                                                                                                                                                                                           
--IF (@FechaFacturacionObtenida IS NULL)
--                                                                                                                                                                                                                       
--BEGIN
--                                                                                                                                                                                                                                                        
--SET @FechaFacturacionObtenida=0
--                                                                                                                                                                                                                              
--END  
--                                                                                                                                                                                                                                                        
--  
--                                                                                                                                                                                                                                                           
--IF (@FechaFacturacionObtenida>=@FacturacionEstimada)  
--                                                                                                                                                                                                       
--BEGIN  
--                                                                                                                                                                                                                                                      
--SELECT 0  
--                                                                                                                                                                                                                                                   
--  
--                                                                                                                                                                                                                                                           
--END  
--                                                                                                                                                                                                                                                        
--ELSE  
--                                                                                                                                                                                                                                                       
--BEGIN  
--                                                                                                                                                                                                                                                      
--  
--                                                                                                                                                                                                                                                           
--SELECT @FechaFacturacionObtenida  
--                                                                                                                                                                                                                           
--END  
--                                                                                                                                                                                                                                                        
--  
--                                                                                                                                                                                                                                                           
--  
--                                                                                                                                                                                                                                                           
--  
--                                                                                                                                                                                                                                                           
--END                                                                                                                                                                                                                                                            
--GO
/****** Object:  StoredProcedure [dbo].[usp_temporal]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	ALTER PROCEDURE [dbo].[usp_temporal]
	as
	Begin
		declare @sql nvarchar(max)
		set @sql = 'insert into temporal(RUC,Facturacion) select RUC, Facturacion_Log from dbo.cliente_facturacion' 
		execute sp_executesql @sql
	End

GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerDatosCliente]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************  
Autor: GOS(YQM)  
Fecha: 19/08/2009  
Actualizado: MDTECK(DJAG)
Fecha: 26/04/2012  
Obj. : Obtiene datos de Cliente y Contacto principal
App. : Web Reclamos  
************************************************/  
  
ALTER PROCEDURE [dbo].[WEB_ObtenerDatosCliente]  
@Ruc AS nvarchar(20)  
AS  
BEGIN  

Select top 1 a.AccountId, a.name,a.nep_segmento segmento,rtrim(ltrim(isnull(c.firstname,'')+' '+isnull(c.nep_apePaterno,'')+' '+isnull(c.nep_apeMaterno,''))) contacto,
isnull(c.telephone1,'') telefono,isnull(c.emailaddress1,'') mail,d.id_divisa divisa,a.nep_ejecutivoservicioportuarioid customer
from Neptunia_MSCRM.dbo.account a
left join Neptunia_MSCRM.dbo.contact c on (a.primarycontactid=c.contactid)
left join divisa d on (a.transactioncurrencyid=d.idcrm_divisa)
where a.deletionstatecode=0 and a.statuscode=1 and a.accountnumber=@Ruc  
  
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerDatosCliente_20120626]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************  
Autor: GOS(YQM)  
Fecha: 19/08/2009  
Obj. : Obtiene Id de Cliente  
App. : Web Reclamos  
************************************************/  
  
ALTER PROCEDURE [dbo].[WEB_ObtenerDatosCliente_20120626]  
@Ruc AS nvarchar(20)  
AS  
BEGIN  

Select AccountId, name --El Primero que encuentre  
from Neptunia_MSCRM.dbo.accountbase  
where deletionstatecode=0 and statuscode=1 and accountnumber=@Ruc  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerFactura]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/************************************************      
                                                                                                                                                                                                      
Autor: MDTK(DJAG)      
                                                                                                                                                                                                                                      
Fecha: 10/05/2012      
                                                                                                                                                                                                                                      
Obj. : Obtiene la fecha de emision, dias de antiguedad y ruc del cliente de una factura
                                                                                                                                                                      
Prueba: WEB_ObtenerFactura '031','0144937'
                                                                                                                                                                                                                   
************************************************/      
                                                                                                                                                                                                      
ALTER PROCEDURE [dbo].[WEB_ObtenerFactura](
                                                                                                                                                                                                                 
@serie varchar(3),
                                                                                                                                                                                                                                           
@numero varchar(7)
                                                                                                                                                                                                                                           
)
                                                                                                                                                                                                                                                            
AS      
                                                                                                                                                                                                                                                     
BEGIN    
                                                                                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
declare @fserie int
                                                                                                                                                                                                                                          
declare @fnumero int
                                                                                                                                                                                                                                         
set @fserie=convert(int,@serie)
                                                                                                                                                                                                                              
set @fnumero=convert(int,@numero)
                                                                                                                                                                                                                            
  
                                                                                                                                                                                                                                                           
select emision,DATEDIFF(DAY, emision, GETDATE()) dias, ident_cliente rucCliente,
                                                                                                                                                                             
		case when (I003_Moneda=10) then 'SOL' when (I003_Moneda=12) then 'DOL' else '' end moneda --,* 
                                                                                                                                                            
from [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.fac_documento d
                                                                                                                                                                                                  
inner join [SP3TDA-DBSQL01].Neptunia_SGC_Produccion.dbo.fac_serie s on (d.ident_serie=s.ident_serie)
                                                                                                                                                               
where d.numero=@fnumero and s.numero=@fserie
                                                                                                                                                                                                                 
END                                                                                                                                                                                                                                                            
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerImputabilidad]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************      
Autor: MDTECK(DJAG)      
Fecha: 07/05/2012
Obj. : Obtener Imputabilidad      
************************************************/      
ALTER PROCEDURE [dbo].[WEB_ObtenerImputabilidad]      
AS      
BEGIN      
SELECT AttributeValue,Value
FROM Neptunia_MSCRM.dbo.StringMap
WHERE ObjectTypeCode = 112 AND AttributeName = 'nep_imputable'
ORDER BY value    
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerLocal]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************      
Autor: MDTECK(DJAG)      
Fecha: 07/05/2012
Obj. : Obtener Local      
************************************************/     
ALTER PROCEDURE [dbo].[WEB_ObtenerLocal]      
AS      
BEGIN      
SELECT AttributeValue,Value
FROM Neptunia_MSCRM.dbo.StringMap
WHERE ObjectTypeCode = 112 AND AttributeName = 'nep_local'
ORDER BY value    
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerMoneda]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************  
Autor: MDTECK(DJAG)  
Fecha: 30/04/2012  
Obj. : Obtiene datos de las monedas
App. : Web Reclamos  
************************************************/  
  
ALTER PROCEDURE [dbo].[WEB_ObtenerMoneda]  
AS  
BEGIN  

select id_divisa,nombredivisa from divisa
  
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerMotivo]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************        
Autor: MDTEC-K(DJAG)        
Fecha: 26/04/2012        
Obj. : Obtener Motivos de reclamos del CRM   
Prueba: [WEB_ObtenerMotivo] 'de763442-a867-e111-8b79-6c626dba2601'     
************************************************/        
ALTER PROCEDURE [dbo].[WEB_ObtenerMotivo](
@motivopadre uniqueidentifier
)      
AS        
BEGIN        
SELECT subjectid,title,isnull(description,'') as description
FROM Neptunia_MSCRM.dbo.subject 
WHERE parentsubject is not null 
and parentSubject=@motivopadre
ORDER BY title      
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerSucursales]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************      
Autor: GOS(YQM)      
Fecha: 20/08/2009      
Obj. : Obtener sucursales      
************************************************/      
ALTER PROCEDURE [dbo].[WEB_ObtenerSucursales]      
AS      
BEGIN      
SELECT AttributeValue,Value
FROM Neptunia_MSCRM.dbo.StringMap
WHERE ObjectTypeCode = 112 AND AttributeName = 'nep_sucursal'
ORDER BY value    
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerTema]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************        
Autor: GOS(YQM)        
Fecha: 20/08/2009        
Obj. : Obtener unidades de negocio de CRM        
************************************************/        
ALTER PROCEDURE [dbo].[WEB_ObtenerTema]        
AS        
BEGIN        
SELECT subjectid,title,isnull(description,'') as description  
FROM Neptunia_MSCRM.dbo.subject        
WHERE parentsubject is null        
ORDER BY title      
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_ObtenerUnidadNegocio]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************      
Autor: GOS(YQM)      
Fecha: 20/08/2009      
Obj. : Obtener unidades de negocio de CRM      
************************************************/      
ALTER PROCEDURE [dbo].[WEB_ObtenerUnidadNegocio]      
AS      
BEGIN      
SELECT nep_unidadnegocioid,nep_name     
FROM Neptunia_MSCRM.dbo.nep_unidadnegocio      
where deletionstatecode=0 and statecode=0 and nep_participaenreclamos = 1    
Order By nep_name  
END
GO
/****** Object:  StoredProcedure [dbo].[WEB_VerificarFacturaRegistrada]    Script Date: 08/03/2019 01:55:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************      
Autor: MDTK(DJAG)      
Fecha: 10/05/2012      
Obj. : Obtiene la 
Prueba: WEB_VerificarFacturaRegistrada '031','0144937'
************************************************/      
ALTER PROCEDURE [dbo].[WEB_VerificarFacturaRegistrada](
@serie varchar(3),
@numero varchar(7)
)
AS      
BEGIN      
declare @factura varchar(15)
set @factura='0'+@serie+'-000'+@numero

select top 1 i.ticketnumber numeroCaso,i.statecode,i.statuscode--nep_nrofactura,statecode,statuscode, deletionstatecode,* 
from Neptunia_MSCRM.dbo.nep_facturaasociadaalcaso f
inner join Neptunia_MSCRM.dbo.incident i on (f.nep_casoid=i.incidentid)
where nep_casoidname is not null and f.deletionstatecode=0 and f.statecode=0 and f.statuscode=1 and i.deletionstatecode=0
and nep_nrofactura=@factura
END
GO