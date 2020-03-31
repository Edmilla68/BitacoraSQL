
CREATE TABLE #TMP_DBUSERS
(
	dbname  varchar(256),
	D       numeric(10,0), 	--'DEFAULT constraint'
	ITF		numeric(10,0), 	--'Inlined table-function' -- (ITF)
	U       numeric(10,0), 	--'User table'
	K       numeric(10,0), 	--'Primary Key'
	S       numeric(10,0),  --'System Table'
	TR      numeric(10,0),  --'Trigger'
	P       numeric(10,0), 	--'Store Procedure'
	FN      numeric(10,0),  --'Scalar Function'
	F       numeric(10,0), 	--'Foreing Key'
	V       numeric(10,0), 	--'Vista'
	TF      numeric(10,0)	--'Table Function'		
)


DECLARE curDBs CURSOR
READ_ONLY
FOR SELECT name FROM master..sysdatabases

DECLARE @name varchar(256)
OPEN curDBs

FETCH NEXT FROM curDBs INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
   IF (@@fetch_status <> -2)
   BEGIN
      
   END
   FETCH NEXT FROM curDBs INTO @name
END

CLOSE curDBs
DEALLOCATE curDBs
GO
