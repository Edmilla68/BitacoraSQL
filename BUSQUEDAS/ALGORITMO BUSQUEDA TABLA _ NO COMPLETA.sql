IF OBJECT_ID('tempdb..#TODO') IS NOT NULL
    DROP TABLE #TODO

CREATE TABLE #TODO
(
textdata	 VARCHAR(MAX) NULL,
loginname	 VARCHAR(50) NULL,
SPID	     INT		 NULL,
NOMDB		 VARCHAR(50) NULL,
HOSTNAME	 VARCHAR(50) NULL,
SERVNAME	 VARCHAR(50) NULL,
NOMTABLA	 VARCHAR(50) NULL
)

DECLARE @CODIGO NVARCHAR(MAX)
DECLARE @CONTADOR INT
SET @CONTADOR = 0

DECLARE buscar_obj CURSOR
    FOR SELECT name FROM nEPTUNIAP1.terminal.SYS.objects WHERE TYPE = 'U'
    
DECLARE @name varchar(256)    
OPEN buscar_obj 
FETCH NEXT FROM buscar_obj INTO @name 
WHILE (@@fetch_status <> -1)
	BEGIN
		BEGIN
	   IF (@@fetch_status <> -2)
	   BEGIN
		SET @CONTADOR = @CONTADOR + 1	   
		SET @CODIGO = 'INSERT #TODO '	+ CHAR(13)+
					  'select textdata, LoginName, SPID, DataBaseName, HostName, ServerName, '''+@name+''' from AUDITORIA_NPT.dbo.OceanicaP1 where TextData like ''%'+@name+ '%'''+ CHAR(13)
		EXEC(@CODIGO)
		PRINT @CONTADOR 
	   END
	   FETCH NEXT FROM buscar_obj INTO @name 
	END
	END
CLOSE buscar_obj
DEALLOCATE buscar_obj

SELECT NOMTABLA, COUNT(*) ss FROM #TODO
group by NOMTABLA
order by ss desc


SELECT * FROM #TODO
where NOMTABLA like '%DDCONTEN04%'



--*********************************************************************************************************************************************************

