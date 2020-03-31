DECLARE @ITEM_ID VARCHAR(200)  
DECLARE @SCRIPT VARCHAR(MAX)  
DECLARE @TEXTO VARCHAR(200)  
SET @TEXTO  = '10.100.16.220'
SET @SCRIPT = ''
DECLARE ITEM_CURSOR CURSOR   FOR (   SELECT name FROM SYS.databases where state_desc = 'ONLINE'
										and name not in (
										'master',
										'tempdb',
										'model',
										'msdb',
										'SharepointCloud',
										'SolarWindsOrion') 
								  )
 --SELECT ITEM_ID  FROM #ITEMS
OPEN ITEM_CURSOR -- This charges the results to memory
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- We fetch the first result
WHILE @@FETCH_STATUS = 0 --If the fetch went well then we go for it
BEGIN
 
set @SCRIPT = @SCRIPT  + 'USE ' + @ITEM_ID + ' ' +CHAR(13)+

'SELECT DISTINCT o.name AS ROUTINE_NAME, o.type_desc as ROUTINE_TYPE, '''+@ITEM_ID+ ''' AS BD
FROM sys.sql_modules m  
INNER JOIN sys.objects  o ON m.object_id=o.object_id 
WHERE m.definition LIKE ''%' +@TEXTO+'%''' +CHAR(13)+CHAR(13)
 
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- Once the work is done we fetch the next result
 
END
PRINT @SCRIPT 
-- We arrive here when @@FETCH_STATUS shows there are no more results to treat
CLOSE ITEM_CURSOR  
DEALLOCATE ITEM_CURSOR -- CLOSE and DEALLOCATE remove the data from memory and clean up the process

