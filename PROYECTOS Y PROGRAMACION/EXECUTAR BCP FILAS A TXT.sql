use master
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE Executa_bcp
	@Archivo varchar(255), 
	@Query varchar(1000)	
--with encryption 

AS
BEGIN TRY
 
	declare @Sql nvarchar(1000);
	declare @Resultado nvarchar(50);
	
	set @Sql = 'exec master..xp_cmdshell ' + char(39) + 'bcp "'+ @Query +
		'" queryout "' + @Archivo + '" -c -t -T ' + char(39)
	PRINT @Sql;
	EXECUTE sp_executesql @Sql;
 
	SET @Resultado = 'Exito'
	select @Resultado as Resultado;
 
END TRY
BEGIN CATCH
 
	SET @Resultado = 'Error'
	select @Resultado as Resultado;
 
END CATCH




