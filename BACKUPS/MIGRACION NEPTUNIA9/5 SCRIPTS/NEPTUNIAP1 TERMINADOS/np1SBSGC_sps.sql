ALTER PROCEDURE [dbo].[sp_Reclamos_CargarNotasCredito]  
AS  
 DECLARE @FECHA DATETIME  
 SELECT TOP 1 @FECHA=aprobacionNC FROM SGC_NOTASCREDITOAPROBADASULTRAGESTION  
 ORDER BY aprobacionNC DESC  
 IF (@FECHA IS null) SET @FECHA= '2006/01/01'  
  
 INSERT INTO SGC_NotasCreditoAprobadasUltragestion  
 SELECT DISTINCT   
  dn_numero_documento AS 'Numero N/C',   
  MAX(df_emision_docto) AS 'Fecha Emision',    
  MAX(df_autorizacion) AS 'Fecha Aprobacion'  
 FROM CALW12SQLCORP.NEPT9_bd_nept.dbo.tb_mov_aux_clin   
 WHERE dc_tipo_documento = 7 and   
  dc_periodo >= '200601' and  
  dm_debe_haber= 'H'and   
  dm_estado_Cdc = 'A' AND  
  df_autorizacion > @FECHA  
 GROUP BY   
  dn_numero_documento  
 ORDER BY  
  dn_numero_documento  
  