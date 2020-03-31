  
CREATE PROCEDURE [usp_gwc_almafin_wms](  
@INI_DATE      DATETIME,  
@FIN_DATE      DATETIME  
)  
AS  
BEGIN  
  
  SELECT 'SERVICE DISABLED - Contact system aministrator' AS RESULT  
  RETURN  
  
  DECLARE @ALMAFIN TABLE(  
                          nu_movimiento       VARCHAR(20),  
                          tipo_movimiento     VARCHAR(10),  
                          fecha_wms           VARCHAR(20),  
                          no_almacen          VARCHAR(20),  
                          nu_vin              VARCHAR(20),  
                          nu_dua              VARCHAR(20),  
                          no_marca            VARCHAR(50),  
                          no_modelo           VARCHAR(50),  
                          an_fab              VARCHAR(20),  
                          an_modelo           VARCHAR(20))  
  
    
  SET NOCOUNT ON  
  INSERT INTO @ALMAFIN  
    SELECT   
      RECEIPT.RECEIPTKEY AS nu_movimiento,  
      'I' AS tipo_movimiento,  
      CONVERT(VARCHAR(20), RECEIPT.RECEIPTDATE, 103) + ' '  + CONVERT(VARCHAR(5), RECEIPT.RECEIPTDATE, 108) AS fecha_wms,  
      CASE LOWER(RECEIPT.WHSEID)  
        WHEN 'wmwhse1' THEN 'NEPTUNIA'  
        WHEN 'wmwhse16' THEN 'OPORSA'  
        ELSE 'NEPTUNIA' END AS no_almacen,  
      RECEIPTDETAIL.ID AS nu_vin,  
      ISNULL(RECEIPT.SUSR2,'') AS nu_dua,  
      SKU.ITEMCHARACTERISTIC1 AS no_marca,  
      RECEIPTDETAIL.LOTTABLE01 AS no_modelo,  
      CONVERT(VARCHAR(04), RECEIPTDETAIL.LOTTABLE04, 120) AS an_fab,  
      RECEIPTDETAIL.SUSR1 AS an_modelo  
    FROM wmwhse1.RECEIPT RECEIPT   
      INNER JOIN wmwhse1.RECEIPTDETAIL RECEIPTDETAIL ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY  
      INNER JOIN wmwhse1.SKU SKU ON RECEIPTDETAIL.SKU = SKU.SKU  
    WHERE RECEIPT.STATUS >= 9  
      AND (RECEIPT.TYPE = '1001' OR RECEIPT.TYPE = '1002')  
      AND RECEIPT.RECEIPTDATE >= @INI_DATE  
      AND RECEIPT.RECEIPTDATE <= @FIN_DATE  
  
  INSERT INTO @ALMAFIN  
    SELECT   
      ORDERS.ORDERKEY AS nu_movimiento,  
      'S' AS tipo_movimiento,  
      CONVERT(VARCHAR(20), ORDERS.DELIVERYDATE, 103) + ' '  + CONVERT(VARCHAR(5), ORDERS.DELIVERYDATE, 108) AS fecha_wms,  
      CASE LOWER(ORDERS.WHSEID)  
        WHEN 'wmwhse1' THEN 'NEPTUNIA'  
        WHEN 'wmwhse16' THEN 'OPORSA'  
        ELSE 'NEPTUNIA' END AS no_almacen,  
      ORDERDETAIL.LOTTABLE02 AS nu_vin,  
      RECEIPT.SUSR2 AS nu_dua,     --DE DONDE SALE?  
      SKU.ITEMCHARACTERISTIC1 AS no_marca,  
      SKU.ITEMCHARACTERISTIC2 AS no_modelo,  
      CONVERT(VARCHAR(04), RECEIPTDETAIL.LOTTABLE04, 120) AS an_fab,  
      RECEIPTDETAIL.SUSR1 AS an_modelo  
    FROM wmwhse1.ORDERS ORDERS  
      INNER JOIN wmwhse1.ORDERDETAIL ORDERDETAIL ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY  
      INNER JOIN wmwhse1.SKU SKU ON ORDERDETAIL.SKU = SKU.SKU  
      LEFT OUTER JOIN wmwhse1.RECEIPTDETAIL RECEIPTDETAIL ON RECEIPTDETAIL.ID = (SELECT TOP 1 ID FROM wmwhse1.RECEIPTDETAIL WHERE ID = ORDERDETAIL.LOTTABLE02) AND RECEIPTDETAIL.SKU <> 'LLAVES'  
      LEFT OUTER JOIN wmwhse1.RECEIPT RECEIPT ON RECEIPT.WAREHOUSEREFERENCE = (SELECT TOP 1 WAREHOUSEREFERENCE FROM wmwhse1.RECEIPT WHERE WAREHOUSEREFERENCE = ORDERDETAIL.LOTTABLE02) AND (RECEIPT.TYPE = '1001' OR RECEIPT.TYPE = '1002')  
    WHERE ORDERS.STATUS >= 95  
      AND ORDERS.TYPE = 'SALIDA'   
      AND ORDERS.DELIVERYDATE IS NOT NULL  
      AND ORDERS.DELIVERYDATE >= @INI_DATE  
      AND ORDERS.DELIVERYDATE <= @FIN_DATE    
  
  SET NOCOUNT OFF  
  SELECT *   
    FROM @ALMAFIN  
    ORDER BY fecha_wms  
  
END  
  