-- para sql 2000
-- listar tablas e indices

-- Resumen de todas las BDs
exec sp_helpdb

-- Cantidad de Tablas de BD
SELECT * FROM sysobjects 
WHERE TYPE = 'U'          --'F' para FK

-- Tablas con Indice CLUSTER
select TABS.name 
from sysobjects as TABS 
left outer join sysindexes AS IDX on (TABS.id = IDX.id) 
WHERE TABS.TYPE = 'U' AND (IDX.indid = 1) 


-- Tablas con Relecion FK
SELECT parent_obj, count(*) FROM sysobjects 
WHERE TYPE = 'F' 
group by parent_obj


---- Objetos analisy

 
SELECT
CASE 
WHEN TYPE = 'D' THEN 'DEFAULT constraint'
WHEN TYPE = 'IF' THEN 'Inlined table-function'
WHEN TYPE = 'U' THEN 'User table'
WHEN TYPE = 'K' THEN 'Primary Key'
WHEN TYPE = 'S' THEN 'System Table'
WHEN TYPE = 'TR' THEN 'Trigger'
WHEN TYPE = 'P' THEN 'Store Procedure'
WHEN TYPE = 'FN' THEN 'Scalar Function'
WHEN TYPE = 'F' THEN 'Foreing Key'
WHEN TYPE = 'V' THEN 'Vista'
WHEN TYPE = 'TF' THEN 'Table Function'
END AS TIPO, 
count(*) FROM sysobjects
group by TYPE 
having TYPE in ('K', 'TR','P','F','V')
ORDER BY TIPO