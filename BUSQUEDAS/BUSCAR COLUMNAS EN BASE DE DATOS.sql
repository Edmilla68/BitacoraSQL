--Para buscar columnas en una Base de Datos

 --SQL Server 2000 
SELECT  SYSOBJECTS.NAME AS TABLA, SYSCOLUMNS.NAME AS COLUMNA
FROM SYSOBJECTS 
 INNER JOIN SYSCOLUMNS 
 ON SYSOBJECTS.ID = SYSCOLUMNS.ID 
WHERE SYSCOLUMNS.NAME LIKE '%NOMBRE_COLUMNA%'
ORDER BY SYSCOLUMNS.NAME


 --SQL Server 2008

SELECT TABLE_CATALOG AS [BASE DE DATOS], TABLE_NAME AS [TABLA], COLUMN_NAME AS COLUMNA], DATA_TYPE AS [TIPO DE DATO]
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME LIKE '%NOMBRE_COLUMNA%'

