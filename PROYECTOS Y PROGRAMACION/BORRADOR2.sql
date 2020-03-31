-- Declaracion de variables para el cursor
DECLARE @IDSER	 int
DECLARE @CNOMSER varchar(255)

-- Declaración del cursor
DECLARE cSERVIDORES CURSOR FOR
SELECT TS.IDSER, CNOMSER FROM TSERVIDOR TS
			
-- Apertura del cursor
OPEN cSERVIDORES
-- Lectura de la primera fila del cursor
FETCH cSERVIDORES INTO @IDSER, @CNOMSER

WHILE (@@FETCH_STATUS = 0 )
BEGIN

	PRINT CONVERT(VARCHAR(3),@IDSER) +'  '+ @CNOMSER
-- cuerpo

   IF NOT EXISTS ( SELECT 1 FROM sys.servers WHERE name = @CNOMSER )
	PRINT 'NO EXISTE LINKED'
	ELSE
	BEGIN
	EXEC ('select * from '+ @CNOMSER+'.MSDB.sys.databases')
	END 
-- Lectura de la siguiente fila del cursor
	FETCH cSERVIDORES INTO @IDSER, @CNOMSER
END

 
-- Cierre del cursor
CLOSE cSERVIDORES
-- Liberar los recursos
DEALLOCATE cSERVIDORES

