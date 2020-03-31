
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