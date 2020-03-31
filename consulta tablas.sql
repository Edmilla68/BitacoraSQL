SELECT SO.NAME TABLA, SC.NAME COLUMNA, ST.NAME TIPO, SC.max_length
FROM sys.objects SO 
INNER JOIN sys.columns SC ON SO.OBJECT_ID = SC.OBJECT_ID
INNER JOIN sys.types ST ON ST.user_type_id = SC.user_type_id
WHERE SO.TYPE = 'U'
ORDER BY SO.NAME, SC.NAME

select * from sys.columns
select * from sys.types