USE [max76prd]
GO

DECLARE @financialperiod	VARCHAR(6)
DECLARE @getdate			DATETIME
DECLARE @getdate_string		VARCHAR(8)
DECLARE @year				INT
DECLARE @month				INT

--SELECT transfer_data_id [id], financialperiod, transdate, begin_date, end_date FROM transfer_data_neptunia ORDER BY transdate DESC

---------------------------------------------------------------
--Variables
SET @getdate = '20190130'			--Fecha de Transferencia
SET @financialperiod = '201901'		--Periodo de Transferencia
---------------------------------------------------------------

SET @getdate_string = CONVERT(VARCHAR, YEAR(@getdate)) +
				REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, MONTH(@getdate)))) + CONVERT(VARCHAR, MONTH(@getdate)) +
				REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, DAY(@getdate)))) + CONVERT(VARCHAR, DAY(@getdate))

IF @financialperiod IS NULL 
BEGIN
	SET @financialperiod = (SELECT TOP 1 financialperiod FROM transfer_data_neptunia ORDER BY transfer_data_id DESC)
	SELECT '1',@financialperiod
END
ELSE
BEGIN
	SELECT '2',@financialperiod
END

	SELECT @getdate, @getdate_string, @financialperiod

IF EXISTS(SELECT financialperiod FROM financialperiods WHERE financialperiod = @financialperiod AND periodclosedate IS NULL)
BEGIN
	PRINT '01'
	IF NOT EXISTS(SELECT financialperiod FROM transfer_data_neptunia WHERE financialperiod = @financialperiod AND transdate = @getdate_string)
	BEGIN
		PRINT 'INSERT 01'
		INSERT INTO transfer_data_neptunia(financialperiod, transdate, begin_date)
		VALUES (@financialperiod, @getdate_string, GETDATE())	
	END
	
	EXEC co_of_sp_getjournalentries_pruebas_np @getdate_string, @financialperiod, ''

	IF EXISTS(SELECT financialperiod FROM transfer_data_neptunia WHERE financialperiod = @financialperiod AND transdate = @getdate_string)
	BEGIN
		PRINT 'UPDATE 01 inicio'
		PRINT @getdate_string
		UPDATE transfer_data_neptunia
			SET end_date = GETDATE()
		WHERE financialperiod = @financialperiod AND transdate = @getdate_string
		PRINT 'UPDATE 01 fin'
	END
END
ELSE
BEGIN
	SET @year = SUBSTRING(@financialperiod, 1, 4)
	SET @month = SUBSTRING(@financialperiod, 5, 2)

	IF @month < 12
	BEGIN
		SET @month = @month + 1
	END
	ELSE
	IF @month = 12
	BEGIN
		SET @year = @year + 1
		SET @month = 1
	END

	SET @financialperiod = CONVERT(VARCHAR, @year) + 
							REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, @month))) + CONVERT(VARCHAR, @month)
	
	IF NOT EXISTS(SELECT financialperiod FROM transfer_data_neptunia WHERE financialperiod = @financialperiod AND transdate = @getdate_string)
	BEGIN
		PRINT 'INSERT 02'
		INSERT INTO transfer_data_neptunia(financialperiod, transdate, begin_date)
		VALUES (@financialperiod, @getdate_string, GETDATE())	
	END
	
	--Proceso ITCONSOL
	EXEC co_of_sp_getjournalentries_pruebas_np @getdate_string, @financialperiod, ''

	IF EXISTS(SELECT financialperiod FROM transfer_data_neptunia WHERE financialperiod = @financialperiod AND transdate = @getdate_string)
	BEGIN
		PRINT 'UPDATE 02'
		UPDATE transfer_data_neptunia
			SET end_date = GETDATE()
		WHERE financialperiod = @financialperiod AND transdate = @getdate_string
	END
END
