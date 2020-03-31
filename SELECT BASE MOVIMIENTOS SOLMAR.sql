--SELECT * FROM PERSONAL_2014 WHERE dni_personal = '09973467'
SELECT * FROM PERSONAL_2014
where es_autorizante = 1

--SELECT * FROM MOVIMIENTOS_2014 WHERE codigo_personal = 24557


 SELECT 
 fecha_movimiento, 
 --M.codigo_tipo_movimiento, 
 TM.tipo_movimiento, 
 --M.codigo_tipo_motivo, 
 TMO.tipo_motivo,
 --M.codigo_empresa,  
 EMP.razon_social,
 es_vehicular, 
 --autorizado_por, 
 --M.CodigoAreaVisitada, 
 AR.nombre_area,
 codigo_personal 
 FROM MOVIMIENTOS_2014 M  
 INNER JOIN TIPOS_MOVIMIENTOS_2014 TM ON TM.codigo_tipo_movimiento = M.codigo_tipo_movimiento
 INNER JOIN TIPOS_MOTIVOS_2014 TMO ON TMO.codigo_tipo_motivo = M.codigo_tipo_motivo
 INNER JOIN EMPRESAS_2014 EMP ON EMP.codigo_empresa = M.codigo_empresa
 INNER JOIN AREAS_2014 AR ON AR.codigo_area = M.CodigoAreaVisitada
 WHERE codigo_personal = 24557
 
 
 order by fecha_movimiento desc

SELECT * FROM TIPOS_MOVIMIENTOS_2014
SELECT * FROM TIPOS_MOTIVOS_2014
SELECT * FROM EMPRESAS_2014
SELECT * FROM AREAS_2014

SELECT * FROM AUTORIZACION_PERSONAS
where cod_personal = 24557
order by cod_autorizacion desc

SELECT * FROM AUTORIZACION_CABECERA
where codigo_autorizacion = 1824

