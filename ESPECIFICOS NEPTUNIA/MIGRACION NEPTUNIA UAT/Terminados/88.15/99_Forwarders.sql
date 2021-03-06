USE [Forwarders]
GO
/****** Object:  StoredProcedure [dbo].[usp_fwd_listaFichaConsolidacion]    Script Date: 22/03/2019 02:53:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_fwd_listaFichaConsolidacion] (    
@FichaConsolidacion INT    
,@Booking varchar(6)    
)    
AS
BEGIN
   IF (@FichaConsolidacion = 0 or  @FichaConsolidacion is null or ltrim(rtrim(@Booking))='' or @Booking is null)
   BEGIN
      RETURN
   END 

   DECLARE		@FILAS			INT
   DECLARE		@bkgcom13		VARCHAR(25)
   DECLARE		@Pla_Vehi		VARCHAR(07)
   DECLARE		@codarm10		VARCHAR(03)

   SET @FILAS		= 0
   SET @bkgcom13	= ''
   SET @Pla_Vehi	= ''
   SET @codarm10	= ''
   
   SELECT 
      @FILAS = COUNT(*)
   FROM
      Forwarders.dbo.Ficha_Consolidacion a    
      INNER JOIN Forwarders.dbo.Ficha_Ingreso b ON a.Cod_Fico = b.Cod_Fico    
   WHERE a.Cod_Fico = @FichaConsolidacion    
      and b.nro_book = @Booking
   
   IF (@FILAS > 0)
   BEGIN
      SELECT  
         cast(a.Cod_Fico as varchar) AS vch_FichaConsolidacion    
         ,b.Pla_Vehi AS vch_Placa    
         ,e.NOMBRE AS vch_Consolidador    
         ,d.bkgcom13 AS vch_BookingCompleto    
         ,d.codarm10 AS vch_Linea    
         ,a.cod_pue AS vch_Puerto    
         ,f.NOMBRE AS vch_Cliente    
         ,d.conten13 AS vch_Producto    
         ,(convert(varchar, a.Fec_Fico, 101) + ' ' + convert(varchar(5), a.Fec_Fico, 108)) AS vch_Fecha    
      FROM
         Forwarders.dbo.Ficha_Consolidacion a    
         LEFT JOIN Forwarders.dbo.Ficha_Ingreso b ON a.Cod_Fico = b.Cod_Fico    
         LEFT JOIN descarga.dbo.edauting14 c ON b.aut_ingr collate database_default = c.nroaut14 collate database_default    
         LEFT JOIN descarga.dbo.edbookin13 d ON c.genbkg13 = d.genbkg13    
         LEFT JOIN descarga.dbo.aaclientesaa e ON a.Cod_Cons collate database_default = e.CONTRIBUY collate database_default    
         LEFT JOIN descarga.dbo.aaclientesaa f ON d.codemc12 collate database_default = f.CONTRIBUY collate database_default    
      WHERE a.Cod_Fico = @FichaConsolidacion    
         AND b.nro_book = @Booking -- or isnull(@Booking, '') = '')   
   END
   ELSE
   BEGIN
      SELECT TOP 1
		@bkgcom13 = B.BKGCOM13,
		--A.NROAUT14,
		@Pla_Vehi   = a.nropla81,
		@codarm10	= b.codarm10
	  FROM
		DESCARGA..EDAUTING14 A
		INNER JOIN DESCARGA..EDBOOKIN13 B ON A.GENBKG13 = B.GENBKG13
		INNER JOIN DESCARGA..EDLLENAD16 C ON A.NROAUT14 = C.NROAUT14
	  WHERE 
       B.BOOKIN13=@Booking
	ORDER BY a.NROAUT14

      SELECT  
         cast(a.Cod_Fico as varchar) AS vch_FichaConsolidacion    
         ,@Pla_Vehi AS vch_Placa    
         ,e.NOMBRE AS vch_Consolidador    
         ,@bkgcom13 AS vch_BookingCompleto  
         ,@codarm10 AS vch_Linea    
         ,a.cod_pue AS vch_Puerto    
         ,'' AS vch_Cliente   --f.NOMBRE AS vch_Cliente    
         ,'' AS vch_Producto  -- d.conten13 AS vch_Producto    
         ,(convert(varchar, a.Fec_Fico, 101) + ' ' + convert(varchar(5), a.Fec_Fico, 108)) AS vch_Fecha    
      FROM Forwarders.dbo.Ficha_Consolidacion a    
         LEFT JOIN descarga.dbo.aaclientesaa e ON a.Cod_Cons collate database_default = e.CONTRIBUY collate database_default    
      WHERE a.Cod_Fico = @FichaConsolidacion
   END
END 
GO

USE [Forwarders]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Consultar_FiinEXPO_WEB_EXPO]    Script Date: 22/03/2019 03:40:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Consultar_FiinEXPO_WEB_EXPO] -- '00393417'
   @Nroaut VARCHAR(8)
AS
BEGIN

SELECT DISTINCT 
       b.nropla81 AS vch_Placa
		,g.NOMBRE AS vch_Consolidador
		,h.desnav08 AS vch_Nave
		,f.numvia11 AS vch_Viaje
		,c.bookin13 AS vch_Booking
		,e.NOMBRE AS vch_Embarcador
		,i.vch_TipoRegimen AS vch_Regimen
		,convert(varchar(10),i.Cod_Fiin) as vch_FichaIngreso
		,i.Est_Fiin
    into #temporal
	FROM descarga.dbo.edauting14 b
	INNER JOIN descarga.dbo.EDBOOKIN13 c ON b.genbkg13 collate Modern_Spanish_CI_AS = c.genbkg13 collate Modern_Spanish_CI_AS
	LEFT JOIN terminal..AACLIENTESAA g ON g.CONTRIBUY = c.ruccli13
	LEFT JOIN terminal..AACLIENTESAA e ON e.CONTRIBUY = c.codemc12
	INNER JOIN terminal..DDCABMAN11 f ON f.navvia11 = c.navvia11
	INNER JOIN terminal..DQNAVIER08 h ON h.codnav08 = f.codnav08
	LEFT JOIN Ficha_Ingreso i ON b.nroaut14 collate Modern_Spanish_CI_AS = i.Aut_Ingr collate Modern_Spanish_CI_AS
	WHERE b.nroaut14 = @Nroaut 

	select 
	   vch_Placa
	   ,vch_Consolidador
	   ,vch_Nave
	   ,vch_Viaje
	   ,vch_Booking
	   ,vch_Embarcador
	   ,vch_Regimen
	   ,vch_FichaIngreso
    FROM
	   #temporal
    where
	   isnull(Est_Fiin,'') <> 'C'
END
GO