
CREATE procedure [dbo].[mxof_sp_sendinvoices]   
/*  
EXEC mxof_sp_sendinvoices  
*/  
AS  
BEGIN  
  
/* ------------------------------------------------------------------------------------  
 FEcha :26.09.2014  
 Autor : DEV  
 Purpose : Evitar registros duplicados incluyendo el numero de la linea de item de OC  
 ------------------------------------------------------------------------------------  
 FEcha :30.09.2014  
 Autor : DEV  
 Purpose : Evitar registros duplicados incluyendo el numero de revision de la OC  
 ------------------------------------------------------------------------------------  
 FEcha :18.05.2015  
 Autor : Walter Flores  
 Purpose : Retransferir una factura modificada desde el maximo  
    ------------------------------------------------------------------------------------  
 FEcha :04.01.2017  
 Autor : Walter Flores  
 Purpose : Cambio de IP a [10.100.16.221]  
    ------------------------------------------------------------------------------------  
 FEcha :04.01.2017  
 Autor : Herbert Medina  
 Purpose : Restringir a solo transacciones COSMOS   
    ------------------------------------------------------------------------------------  */  
  
/* BEGIN: Jimmy Julca - 16/09/2014 */  
/* SE PROCEDE A COMENTAR EL CODIGO UBICADO LINEAS ABAJO */  
/* LAS NUEVAS LINEAS DE CODIGO  */  
/*  
 select *,  
   ( select  max(poline.storeloc) --poline.storeloc  
    from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
    where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum and poline.siteid = mxof_invoice_all.siteid  
   ) storeloc,  
   ISNULL(( select  max(poline.pl1) --poline.pl1  
    from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
    where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum and poline.siteid = mxof_invoice_all.siteid  
   ),'001') sucursal,  
   ISNULL(( select  max(poline.issue) --poline.issue  
    from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
    where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum and poline.siteid = mxof_invoice_all.siteid  
   ),'001') issue  
 into #mxof_invoice_all_temp  
 from mxof_invoice_all  
 where ponum is not null  
   --and il_linetype = 'ARTÍCULO'   
   and (il_linetype = 'ARTÍCULO' or (il_linetype in ('SERV.EST') and convert(datetime,enterdate) > CONVERT(Datetime, '2014-08-28 16:30:00', 120) and il_itemnum like 'S1%'))  
   and co_senttoofisis = 0  
   and invoicenum not in (select nu_docu_maxi from tmdocu_prre_inte)  
   and il_invoiceqty<>0  
  
/* BEGIN: Jimmy Julca - 28/08/2014 */  
   AND SUBSTRING(SUBSTRING(ic_gldebitacct, 8, 6), 5, 2) <> '08'  
/* END: Jimmy Julca - 28/08/2014 */  
   ---and invoicenum not in (2092);  
*/  
/* END: Jimmy Julca - 16/09/2014 */  
  
/* BEGIN: Walter Flores - 18/05/2015 */  
  
 -- SELECCCIONAMOS LAS FACTURAS REINGRESADAS  
   
 SELECT DISTINCT invoicenum    
 INTO #invoicenum  
 FROM mxof_invoice_all    
 WHERE co_senttoofisis=0 AND orgid = 'COSMOS'   
 AND invoicenum in (select nu_docu_maxi from tmdocu_prre_inte where co_empr = '01')  
 AND NOT EXISTS(select nu_docu_maxi from OFITESO..TMDOCU_PROV where co_empr = '01' and nu_docu_maxi=invoicenum)  
 AND il_invoiceqty <> 0 --2018.03.14  
 AND ic_unitcost<>0--2018.03.14 : WFLORES no se aceptan facturas con detalle cero  
   
 --ELIMINAMOS LA ANTERIOR TRANSFERENCIA  
 --DECLARE @NU_DOCU_MAXI VARCHAR(5)  SET @NU_DOCU_MAXI='28707'   
 DELETE FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TMDOCU_PRRE_INTE    WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TDORDE_FACT_INTE  WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM [COSMOS-DB\SQL2008].OFITESO.DBO.TDDOCU_ALMA_INTE WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM tmdocu_prre_inte WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM tdorde_fact_inte WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
 DELETE FROM tddocu_alma_inte WHERE NU_DOCU_MAXI IN (SELECT invoicenum FROM #invoicenum)  
/* BEGIN: Walter Flores - 18/05/2015 */  
  
  
  
 SELECT  
  table1.apcontrolacct, table1.approvalnum, table1.apsuspenseacct, table1.bankaccount, table1.banknum,  
  table1.basetotalcost, table1.changeby, table1.changedate, table1.checkcode, table1.checknum,  
  table1.contact, table1.contractrefid, table1.contractrefnum, table1.contractrefrev, table1.co_interrormsg,  
  table1.co_senttoofisis, table1.currencycode,  
  CASE  
   WHEN table1.worktype = 'PY' AND table1.il_linetype = 'SERV.EST'  
    THEN LEFT( LTRIM(RTRIM(table1.glcomp02)) + '-' +  
       LTRIM(RTRIM(table1.comptext_glcomp03)) + ': ' +  
       LTRIM(RTRIM(table1.invoicedesc))  
       , 100)  
   -- + '7890123456788012345678901234567100123456789'  
   ELSE table1.invoicedesc  
     
  END AS 'invoicedesc',  
  table1.aplongdesc, table1.discount,  
  table1.discountdate  
  --, table1.documenttype-- 2015.05.22: WALTER FLORES - ADICION DEL TIPO INVOICE  
  ,CASE WHEN LEFT(table1.vendor,1)<>'C' THEN  table1.documenttype ELSE 'INV' END documenttype  
  , table1.duedate, table1.einvoice, table1.enterby,  
  table1.enterdate, table1.exchangedate, table1.exchangerate, table1.exchangerate2, table1.externalrefid,  
  table1.financialperiod, table1.glpostdate, table1.historyflag, table1.inclusive1, table1.inclusive2,  
  table1.inclusive3, table1.inclusive4, table1.inclusive5, table1.invoicedate, table1.invoiceid,  
  table1.invoicenum, table1.np_description, table1.np_glpostdate, table1.np_invoicenum, table1.np_isreverse,  
  table1.np_revreason, table1.np_status, table1.memo, table1.orgid, table1.originvoicenum,  
  table1.ownersysid, table1.paid, table1.paiddate, table1.paymentterms, table1.ponum,  
  table1.positeid, table1.revinvoicenum, table1.revreason, table1.scheduleid, table1.schedulenum,  
  table1.schedulerev, table1.sendersysid, table1.siteid, table1.sourcesysid, table1.status,  
  table1.statusdate, table1.statusiface, table1.syscode, table1.targinvstatus, table1.tax1gl,  
  table1.tax2gl, table1.tax3gl, table1.tax4gl, table1.tax5gl, table1.totalcost,  
  table1.totaltax1, table1.totaltax2, table1.totaltax3, table1.totaltax4, table1.totaltax5,  
  table1.vendor, table1.vendorinvoicenum, table1.il_classstructureid, table1.il_commodity, table1.il_commoditygroup,  
  table1.il_conditioncode, table1.il_constransid, table1.il_contractrefid, table1.il_contractrefnum, table1.il_contractrefrev,  
  table1.il_contreflineid, table1.il_conversion, table1.il_costoverreceived, table1.il_description, table1.il_aplinelongdesc,  
  table1.il_ivol_enterby, table1.il_enterdate, table1.il_invoicelin1, table1.il_invoicelin2, table1.il_invoicelin3,  
  table1.il_invoicelin4, table1.il_invoicelin5, table1.il_invoicelin6, table1.il_invoicelin7, table1.il_invoicelin8,  
  table1.il_invoicelin9, table1.il_invoicelineid, table1.il_invoicelinenum, table1.il_invoiceqty, table1.il_invoiceunit,  
  table1.il_itemnum, table1.il_itemsetid, table1.il_leaseasset, table1.il_invoicelinecost, table1.il_linecost2,  
  table1.il_linetype, table1.il_loadedcost, table1.il_orgid, table1.il_originator, table1.il_polinenum,  
  table1.il_invoicelineponum, table1.il_porevisionnum, table1.il_positeid, table1.il_potoleranceline, table1.il_pricevar,  
  table1.il_proratecost, table1.il_prorated, table1.il_prorateservice, table1.il_qtyoverreceived, table1.il_receiptreqd,  
  table1.il_tax1, table1.il_tax1code, table1.il_tax2, table1.il_tax2code, table1.il_tax3,  
  table1.il_tax3code, table1.il_tax4, table1.il_tax4code, table1.il_tax5, table1.il_tax5code,  
  table1.il_taxexempt, table1.il_invoiceunitcost, table1.il_vendor, table1.ic_assetnum, table1.ic_chargestore,  
  table1.ic_costlinenum, table1.ic_enteredastask, table1.ic_fincntrlid, table1.ic_glcreditacct,  
  CASE  
   WHEN table1.worktype = 'PY' AND table1.il_linetype = 'SERV.EST'  
    THEN REPLACE(table1.ic_gldebitacct, table1.glcomp01, '339211')  
   ELSE table1.ic_gldebitacct  
  END AS 'ic_gldebitacct',  
  table1.ic_ict1, table1.ic_ict2, table1.ic_ict3, table1.ic_invoicecostid, table1.ic_linecost,  
  table1.ic_location, table1.ic_memo, table1.ic_orgid, table1.ic_percentage, table1.ic_positeid,  
  table1.ic_quantity, table1.ic_refwo, table1.ic_tositeid, table1.ic_unitcost, table1.ic_vendor,  
  table1.transid, table1.transseq,  
  table1.storeloc, table1.sucursal, table1.issue,  
  table1.worktype  
 into #mxof_invoice_all_temp  
 FROM  
 (  
  select mxof_invoice_all.*,  
    ( select  max(poline.storeloc) --poline.storeloc  
     from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
     where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum and poline.siteid = mxof_invoice_all.siteid  
    ) storeloc,  
    ISNULL(( select  max(poline.pl1) --poline.pl1  
     from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
     where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum and poline.siteid = mxof_invoice_all.siteid  
    ),'001') sucursal,  
    ISNULL(( select  max(poline.issue) --poline.issue  
     from  [10.100.16.221].[max76prd].[dbo].[poline] poline  
     where  poline.ponum = mxof_invoice_all.ponum and poline.polinenum = mxof_invoice_all.il_polinenum /*and poline.siteid = mxof_invoice_all.siteid*/  
    ),'001') issue,  
/* BEGIN: Jimmy Julca - 15/09/2014 */  
    CHARTOFACCOUNTS.glcomp01, CHARTOFACCOUNTS.glcomp02,  
    CHARTOFACCOUNTS.glcomp03, GLCOMPONENTS.comptext AS 'comptext_glcomp03',  
    WORKORDER.worktype  
/* BEGIN: Jimmy Julca - 15/09/2014 */  
  FROM mxof_invoice_all mxof_invoice_all (nolock)  
--  INNER JOIN [10.100.16.221].[max76prd].[dbo].[PO] PO  
--  ON po.ponum = mxof_invoice_all.ponum  
  INNER JOIN [10.100.16.221].[max76prd].[dbo].[POLINE] POL  
  ON pol.ponum = mxof_invoice_all.ponum  
   AND pol.itemnum = mxof_invoice_all.il_itemnum  
   AND pol.polinenum = mxof_invoice_all.il_polinenum  --DEV 26.09.2014  
   AND pol.revisionnum = mxof_invoice_all.il_porevisionnum -- DEV 30.09.2014  
  INNER JOIN [10.100.16.221].[max76prd].[dbo].[CHARTOFACCOUNTS] CHARTOFACCOUNTS  
  ON CHARTOFACCOUNTS.orgid = mxof_invoice_all.orgid and CHARTOFACCOUNTS.GLACCOUNT = mxof_invoice_all.ic_gldebitacct  
  INNER JOIN [10.100.16.221].[max76prd].[dbo].[GLCOMPONENTS] GLCOMPONENTS  
  ON GLCOMPONENTS.orgid = CHARTOFACCOUNTS.orgid and GLCOMPONENTS.compvalue = CHARTOFACCOUNTS.glcomp03  
  LEFT OUTER JOIN [10.100.16.221].[max76prd].[dbo].[WORKORDER] WORKORDER  
  ON WORKORDER.wonum = pol.pl5  
  where mxof_invoice_all.ponum is not null  
          AND mxof_invoice_all.orgid = 'COSMOS'  
    --and il_linetype = 'ARTÍCULO'   
    AND (mxof_invoice_all.il_linetype = 'ARTÍCULO'  
     OR (mxof_invoice_all.il_linetype IN ('SERV.EST')  
      AND CONVERT(DATETIME, mxof_invoice_all.enterdate) > CONVERT(DATETIME, '2014-08-28 16:30:00', 120)  
      AND mxof_invoice_all.il_itemnum LIKE 'S1%'))  
    and co_senttoofisis = 0  
    and invoicenum not in (select nu_docu_maxi from tmdocu_prre_inte)  
    and il_invoiceqty <> 0  
 /* BEGIN: Jimmy Julca - 28/08/2014 */  
     --AND NOT SUBSTRING(SUBSTRING(ic_gldebitacct, 8, 6), 3, 4) IN ( 'V108','E108') --2016.03.23 - WF: SE HABILITA(COMENTA) PARA TODOS LOS CASOS  
 /* END: Jimmy Julca - 28/08/2014 */  
    ---and invoicenum not in (2092);  
 /* CODE PRUEBA */  
--    AND mxof_invoice_all.ponum = '29073' --'28516' --'28510' --'29213'  
 /* CODE PRUEBA */  
  
 ) table1  
  
--SELECT * FROM #mxof_invoice_all_temp  
--EXEC mxof_sp_sendinvoices  
 select top 0 * into #tmdocu_prre_inte_temp from tmdocu_prre_inte;  
 select top 0 * into #tdorde_fact_inte_temp from tdorde_fact_inte;  
 select top 0 * into #tddocu_alma_inte_temp from tddocu_alma_inte;  
  
 begin try  
  
-- PRINT 'paso 1'  
  
/*CASO: SE ELIMINA LAS DUPLICIDADES X NUMERO DE TRANSFERENCIA: WFLORES -2018.03.22*/  
 --PASO 1: Se almacena en un temporal  
 SELECT *  
 INTO #mxof_invoice_all_temp_del  
 FROM #mxof_invoice_all_temp  
 WHERE invoicenum+ CONVERT(VARCHAR(10),transid) NOT IN  
 (SELECT MAX(invoicenum)+ CONVERT(VARCHAR(10),MAX(transid)) AS CLAVE FROM #mxof_invoice_all_temp GROUP BY vendor,documenttype,vendorinvoicenum )  
   
 --Paso 2: Se elimina para no transferirlo  
 DELETE FROM #mxof_invoice_all_temp  
 WHERE invoicenum+ CONVERT(VARCHAR(10),transid) NOT IN  
 (SELECT MAX(invoicenum)+ CONVERT(VARCHAR(10),MAX(transid)) AS CLAVE FROM #mxof_invoice_all_temp GROUP BY vendor,documenttype,vendorinvoicenum )  
  
/*FIN: DE ELIMINACION DE DUPLICIDADES: Se conserva la ultima transid*/  
  
  insert into #tmdocu_prre_inte_temp  
  (  
   co_empr, co_prov, co_tipo_docu, nu_docu_prov, fe_emis, co_cond_pago, co_unid_conc, fe_venc, fa_tipo_camb, co_mone,  
   im_brut_afec, fe_prog_pago, im_brut_inaf, fe_regi_comp, pc_imp1, im_imp1, co_imp1, pc_imp2, im_imp2, co_imp2,  
   pc_imp3, im_imp3, co_imp3, im_tota, im_paga, ti_docu_orig, nu_docu_orig, fe_docu_orig, de_obse, ti_situ, co_enti_apro,  
   ti_enti_apro, st_apro, co_esta_docu, co_enti_gene, ti_enti_gene, fe_ctrl, st_envi_ofis, nu_docu_maxi, nu_line_maxi,  
   co_usua_crea, fe_usua_crea, co_usua_modi, fe_usua_modi  
  )  
   select distinct  
     '01', -- codigo de la empresa  
     temp.vendor, -- codigo del proveedor  
     temp.documenttype, -- tipo de documento  
     temp.vendorinvoicenum, -- nro de factura del proveedor  
     temp.invoicedate, -- fecha de emision  
     null, -- condicion de pago  
     --case when temp.invoicenum=1835 then '011' else temp.sucursal end sucursal,  
     temp.sucursal, -- sucursal  
     temp.duedate, -- fecha de vencimiento  
     case temp.currencycode  
      when 'SOL' then (select exchange.exchangerate from [10.100.16.221].[max76prd].[dbo].[exchange] exchange where exchange.currencycode = 'USD' and exchange.currencycodeto = 'PES' and temp.invoicedate >= exchange.activedate and temp.invoicedate < exchan
ge.expiredate  and temp.orgid = exchange.orgid )  
      when 'DOL' then (select exchange.exchangerate from [10.100.16.221].[max76prd].[dbo].[exchange] exchange where exchange.currencycode = 'USD' and exchange.currencycodeto = 'PES' and temp.invoicedate >= exchange.activedate and temp.invoicedate < exchan
ge.expiredate  and temp.orgid = exchange.orgid )  
     end, -- tipo de cambio  
     temp.currencycode, -- moneda  
     case temp.inclusive1  
      when 1 then (temp.totalcost - temp.totaltax1)  
      else 0  
     end, -- importe bruto afecto  
     temp.paiddate, -- fecha de pago  
     case temp.inclusive1  
      when 0 then temp.totalcost  
      else 0  
     end, -- importe bruto inafecto  
     null, -- fecha de la oc  
     case temp.inclusive1  
      when 1 then (select tax.taxrate from [10.100.16.221].[max76prd].[dbo].[tax] tax where tax.typecode = 1 and tax.orgid = temp.orgid)  
      else 0  
     end, -- tasa del impuesto1  
     case temp.inclusive1  
      when 1 then temp.totaltax1  
      else 0  
     end, -- importe  del impuesto1  
     'IGV', -- codigo del impuesto1  
     null, -- tasa del impuesto2  
     0, -- importe del impuesto2  
     null, -- codigo del impuesto2  
     null, -- tasa del impuesto3  
     0, -- importe del impuesto3  
     null, -- codigo del impuesto3  
     temp.totalcost, -- importe total  
     0, -- importepagado  
     case temp.documenttype  
      when 'NCR' then 'FAC'  
      else null  
     end, -- tipo de documento de la factura de referencia  
     case temp.documenttype  
      when 'NCR' then temp.originvoicenum  
      else null  
     end, -- factura de referencia  
     case temp.documenttype  
      when 'NCR' then (select invoice.invoicedate from [10.100.16.221].[max76prd].[dbo].[invoice] invoice where invoice.orgid = temp.orgid and invoice.siteid = temp.siteid and invoice.invoicenum = temp.originvoicenum)  
      else null  
     end, -- fecha factura de referencia  
     temp.invoicedesc,--aplongdesc, -- observaciones  
     'ENV', -- situacion (estado en ofisis)  
     '04776', -- codigo usuario  
     'E', -- tipo entidad que aprueba  
     null, -- estado de aprobado  
     'ACT', -- estado del documento  
     '04776', -- codigo usuario  
     'E', -- tipo entidad  
     null, -- fecha de control  
     'N', -- estado de enviado  
     temp.invoicenum, -- nro factura de MX  
     null, -- nro de la linea de la factura de MX  
     '04776', -- codigo usuario  
     temp.enterdate, -- fecha de registro  
     '04776', -- codigo usuario  
     temp.enterdate -- fecha de registro  
   from #mxof_invoice_all_temp temp;  
  
-- PRINT 'paso 2'  
  insert into #tdorde_fact_inte_temp (  
   co_empr, co_prov, co_tipo_docu, nu_docu_prov, co_tipo_docu_orco, nu_orco, ti_docu, nu_docu, im_docu, fe_docu, co_unid,  
   co_alma, st_envi_ofis, co_usua_crea, fe_usua_crea, co_usua_modi, fe_usua_modi, nu_docu_maxi, nu_line_maxi, co_mone  
  )  
   select distinct  
     '01', -- codigo de la empresa  
     temp.vendor, -- codigo del proveedor  
     temp.documenttype, -- tipo de documento  
     temp.vendorinvoicenum, -- nro de factura del proveedor  
     'OCM', -- codigo del tipo de documento OC de Ofisis  
     ('0000-' + right('0000000000' + temp.ponum, 10)), -- nro de la OC  
     'VIN', -- codigo del tipo de almacen  
     1, -- nro de documento  
     (temp.totalcost - temp.totaltax1), -- importe del documento  
     temp.invoicedate, -- fecha del documento  
     temp.sucursal, -- sucursal  
     --case when temp.invoicenum=1835 then '011' else temp.sucursal end sucursal,  
     dbo.mxof_fn_control_validstoreloc(temp.storeloc), -- codigo del almacen (referencial)  
     'N', -- estado de enviado  
     '04776', -- codigo usuario  
     temp.enterdate, -- fecha de registro  
     '04776', -- codigo usuario  
     temp.enterdate, -- fecha de registro  
     temp.invoicenum, -- nro de la factura de MX  
     1, -- nro de linea de la factura de MX  
     temp.currencycode -- moneda  
   from #mxof_invoice_all_temp temp;  
  
-- PRINT 'paso 3'  
  insert into #tddocu_alma_inte_temp (  
   co_empr, co_prov, co_tipo_docu, nu_docu_prov, co_tipo_docu_orco, nu_orco, co_alma, fe_docu, co_item, de_item --10  
   , co_unme_movi, ca_docu_movi, co_unme, ca_docu_alma, im_cost_comp  , im_cost_alma, nu_secu,  --7  
   nu_guia_prov, nu_cnta_cntb, ti_auxi_empr, co_auxi_empr, co_orde_serv,  
   st_envi_ofis, co_usua_crea, fe_usua_crea, co_usua_modi, fe_usua_modi, nu_docu_maxi, nu_line_maxi  
  )  
   select '01', -- codigo de la empresa 1  
     temp.vendor, -- codigo del proveedor 2  
     temp.documenttype, -- tipo de documento 3  
     temp.vendorinvoicenum, -- nro de factura del proveedor 4  
     'OCM', -- codigo del tipo de documento OC de Ofisis 5  
     ('0000-' + right('0000000000' + temp.ponum, 10)), -- nro de la OC 6  
     dbo.mxof_fn_control_validstoreloc(temp.storeloc), -- codigo del almacen 7  
     temp.invoicedate, -- fecha del documento 8  
     isnull(temp.il_itemnum, ''), -- codigo del item 9  
     substring(temp.il_description, 1, 100), -- descripcion del item 10  
     substring(temp.il_invoiceunit, 1, 3), -- unidad de compra 11  
     temp.il_invoiceqty, -- cantidad 12  
     substring(temp.il_invoiceunit, 1, 3), -- unidad del almacen 13  
     temp.il_invoiceqty, -- cantidad recibida 14  
     (temp.il_invoicelinecost / temp.il_invoiceqty),--temp.il_invoiceunitcost, -- importe 15  
     (temp.il_invoicelinecost / temp.il_invoiceqty),--temp.il_invoiceunitcost, -- importe recepcionado 16*/  
        --ic_unitcost, --ADD BY:WFLORES FROM:29/11/2012   16  
     temp.il_invoicelinenum, -- nro de linea 17  
     null, -- nro guia del proveedor  
  
/*  
     case when temp.issue = 0 then  
      --(select co_rubro.co_cta_pte from [10.100.16.221].[max76prd].[dbo].[item] item left join [10.100.16.221].[max76prd].[dbo].[co_rubro] co_rubro on item.co_tipo=co_rubro.co_tipo and item.co_rubro=co_rubro.co_rubro where item.itemnum=temp.il  
  
  
  
_itemnum)  --SE REEMPLAZA PARA OBTENER CTA DE COMODITIES  
      (select commodities.co_cta_pte from [10.100.16.221].[max76prd].[dbo].[item] item left join [10.100.16.221].[max76prd].[dbo].commodities on item.commodity=commodities.commodity where item.itemnum=temp.il_itemnum)  
     else  
      substring(temp.ic_gldebitacct, 1, 6)  
     end, -- cta contable  
  
     case  
      when temp.issue = 0 then 'P'  
      else 'K'  
     end, -- auxiliar  
  
     case  
      when temp.issue = 0 then temp.vendor  
      else substring(temp.ic_gldebitacct, 8, 6)  
     end, -- centro de costo  
  
     case  
      when temp.issue = 0 then null  
      else substring(temp.ic_gldebitacct, 15, 5)  
     end,  -- quiebre / actividad  
*/  
  
     case  
/* BEGIN: JIMMY JULCA - 17/09/2014 */  
      WHEN temp.worktype = 'PY' AND temp.il_linetype = 'SERV.EST' THEN SUBSTRING(temp.ic_gldebitacct, 1, 6)  
/* END: JIMMY JULCA - 17/09/2014 */  
      when temp.issue = 0 then  
       (select commodities.co_cta_pte  
        from [10.100.16.221].[max76prd].[dbo].[item] item  
        left join [10.100.16.221].[max76prd].[dbo].commodities  
         on item.commodity=commodities.commodity  
         where item.itemnum=temp.il_itemnum)  
      else  
       substring(temp.ic_gldebitacct, 1, 6)  
     end, -- cta contable  
  
     case  
/* BEGIN: JIMMY JULCA - 17/09/2014 */  
      WHEN temp.worktype = 'PY' AND temp.il_linetype = 'SERV.EST' THEN NULL  
/* END: JIMMY JULCA - 17/09/2014 */  
      when temp.issue = 0 then 'P'  
      else 'K'  
     end, -- auxiliar  
  
     case  
/* BEGIN: JIMMY JULCA - 17/09/2014 */  
      WHEN temp.worktype = 'PY' AND temp.il_linetype = 'SERV.EST' THEN NULL  
/* END: JIMMY JULCA - 17/09/2014 */  
      when temp.issue = 0 then temp.vendor  
      else substring(temp.ic_gldebitacct, 8, 6)  
     end, -- centro de costo  
  
     case  
/* BEGIN: JIMMY JULCA - 17/09/2014 */  
      WHEN temp.worktype = 'PY' AND temp.il_linetype = 'SERV.EST' THEN NULL  
/* END: JIMMY JULCA - 17/09/2014 */  
      when temp.issue = 0 then null  
      else substring(temp.ic_gldebitacct, 15, 5)  
     end,  
  
  
     'N', -- estado de enviado  
     '04776', -- codigo usuario  
     temp.enterdate, -- fecha de registro  
     '04776', -- codigo usuario  
     temp.enterdate, -- fecha de registro  
     temp.invoicenum, -- nro de la factura de MX  
     1 --temp.il_invoicelinenum -- nro de linea de la factura de MX  
   from #mxof_invoice_all_temp temp;  
--'PASO 4' :Se actualiza el tipo de acitividad a a proyectos para la cuenta 339211  
 --UPDATE #tddocu_alma_inte_temp SET TI_AUXI_EMPR='W' WHERE NU_CNTA_CNTB='339211'  
---PASO 4: FIN  
  insert into tmdocu_prre_inte  
   select * from #tmdocu_prre_inte_temp order by nu_docu_maxi;  
    
  insert into tdorde_fact_inte  
   select * from #tdorde_fact_inte_temp order by nu_docu_maxi;  
    
  insert into tddocu_alma_inte  
   select * from #tddocu_alma_inte_temp order by nu_docu_maxi;  
  
--Paso 5: Se adiciona registro eliminados para su marca como transferido - 2018.03.15  
  INSERT INTO #mxof_invoice_all_temp   
  SELECT * FROM #mxof_invoice_all_temp_del  
--Paso 5: Se adiciona registro eliminados para su marca como transferido - 2018.03.15  
  
  
  update mxof_invoice_all set co_senttoofisis = 1  
  from mxof_invoice_all tb1  
  inner join #mxof_invoice_all_temp tb2 on tb1.transid = tb2.transid and tb1.transseq = tb2.transseq;  
  
    
 end try  
 begin catch  
  print '------------------------------------------'  
  print @@error  
  print error_message()  
  print '------------------------------------------'  
 end catch;  
  
END;  
  