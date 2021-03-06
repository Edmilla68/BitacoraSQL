USE [Forwarders]
GO
/****** Object:  UserDefinedFunction [dbo].[TGEN_FN_OBTENER_CORRELATIVO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--44 TARJA EXPO
--===> PARA EJECUTAR ESTA FUNCION LOS SERVIDORES TIENEN QUE ESTAR LINKEADOS(VINCULADOS)
    --   NEPTUNIA1 DEBE ESTAR VINCULADO A NEPTUNIA2 Y  calw3bdwcf001

ALTER FUNCTION [dbo].[TGEN_FN_OBTENER_CORRELATIVO]  
(  
    @pint_CodigoTarja INT ,   
    @pvch_HBL VARCHAR(20),  
 @pvch_CodigoIdentificador varchar(50)  
)  
RETURNS varchar(50)  
AS  
BEGIN  
   
 DECLARE @Resultado varchar(50)   
    
    
  IF  @pvch_CodigoIdentificador = 'PI'  
  BEGIN   
    
   IF EXISTS (SELECT int_CodigoCorrelativo FROM BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO WHERE  vch_CodigoIdentificador = @pvch_CodigoIdentificador   
              AND int_CodigoTarja =  @pint_CodigoTarja AND vch_HBL = @pvch_HBL )  
              BEGIN  
       SELECT @Resultado = @pvch_CodigoIdentificador + CAST (int_Valor AS varchar)    
       FROM BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO  WHERE   vch_CodigoIdentificador = @pvch_CodigoIdentificador  
       AND int_CodigoTarja =  @pint_CodigoTarja AND vch_HBL = @pvch_HBL  
              END   
              ELSE  
              BEGIN   
       SET @Resultado = @pvch_CodigoIdentificador + CAST (1 AS varchar)   
              END  
                               
  END  
  ELSE  
  BEGIN  
    IF @pvch_CodigoIdentificador = 'LPNIMPO'  
    BEGIN  
       SELECT @Resultado = CAST (int_Valor AS varchar)    
       FROM BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO  WHERE   vch_CodigoIdentificador = @pvch_CodigoIdentificador  
    END  
    ELSE  
    BEGIN   
       SELECT @Resultado =  right( '0000000000' + cast( int_Valor  AS varchar(10)), 10 )    
       FROM BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO  WHERE   vch_CodigoIdentificador = @pvch_CodigoIdentificador  
       SET @Resultado ='EXP'+ @Resultado + 'X'  
    END  
  END    
  RETURN @Resultado  
  
END


GO
/****** Object:  UserDefinedFunction [dbo].[uf_Altertas_ObtenerEmailConsolidador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[uf_Altertas_ObtenerEmailConsolidador] (@RucConsolidador CHAR(11))
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @return VARCHAR(255)

	IF (
			@RucConsolidador = '20252062077'
			OR @RucConsolidador = '20513151978'
			OR @RucConsolidador = '20556687529'
			OR @RucConsolidador = '20556788716'
			) -- TRANSITARIO INTERNACIONAL MULTIMODAL S.A.C.                                            
	BEGIN
		SET @return = 'operexpo@tpsac.com.pe; mrh@tpsac.com.pe; team3@tpsac.com.pe; estela.palomino@neptunia.com.pe; anthony.peche@neptunia.com.pe'
	END
	ELSE IF @RucConsolidador = '20517966089' -- SSL CONSOLIDATION SERVICE S.A.C.                                            
	BEGIN
		SET @return = 'jaime.quino@sslconsolidation.com.pe; alvaro.inti@sslconsolidation.com.pe;lyanne.ordinola@sslconsolidation.com.pe'
	END
	ELSE IF @RucConsolidador = '20510049226' -- MSL                                             
	BEGIN
		SET @return = 'emo@mslcorporate.com.pe; diego.vivar@neptunia.com.pe'
	END
	ELSE IF @RucConsolidador = '20504721834' -- MAGELLAN                                              
	BEGIN
		SET @return = 'customer-expo@magellanlineperu.com; pclgc@magellanlineperu.com; pclgc@magellanlineperu.com; headassist@magellanlineperu.com; customer-impo@magellanlineperu.com; mlpmc@magellanlineperu.com'
	END
	ELSE IF @RucConsolidador = '20507205781'
		OR @RucConsolidador = '20392696432' -- INTERNATIONAL FREIGHT SHIPPING SAC - LOGISTIC                                             
	BEGIN
		SET @return = 'fcadillo@ifssac.com; jcotrina@ifssac.com; cruiz@ifssac.com; aquispe@ifssac.com; gojeda@ifssac.com; leslie.delacruz@neptunia.com.pe; marilyn.mallcco@neptunia.com.pe'
	END
	ELSE IF @RucConsolidador = '20101960944' -- TRISMARE PERU                                             
	BEGIN
		SET @return = 'comercial@trismareperu.com'
	END
	ELSE IF @RucConsolidador = '20554008659' -- VANGUARD                
	BEGIN
		SET @return = 'jose.andia@vanguardlogistics.com; natalia.vargas@vanguardlogistics.com; renzo.nunez@vanguardlogistics.com; marilyn.mallcco@neptunia.com.pe; leslie.delacruz@neptunia.com.pe; rosario.pachas@vanguardlogistics.com'
	END
	ELSE
	BEGIN
		SET @return = 'Leslie.delacruz@neptunia.com.pe;diego.vivar@neptunia.com.pe'
	END

	RETURN @return
END

GO
/****** Object:  UserDefinedFunction [dbo].[uf_Forwarders_Altertas_ObtenerUrlFichaIngreso]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[uf_Forwarders_Altertas_ObtenerUrlFichaIngreso]()
RETURNS VARCHAR(500)
BEGIN
      --RETURN 'http://www.neptunia.com.pe/web_forwarders/frmRedireccionarContenedor.aspx?codigo='
      RETURN 'http://www.neptunia.com.pe/web_forwarderscliente/frmRedireccionarContenedor.aspx?codigo='
END


GO
/****** Object:  UserDefinedFunction [dbo].[uf_sf_dev_PesoBal_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[uf_sf_dev_PesoBal_Fiin]
(
	@Cod_Fiin int
)
RETURNS DECIMAL(8, 2)
AS
BEGIN

	declare @nroaut14 varchar(8), @Return DECIMAL(8, 2)

	select @nroaut14 = right('00000000' + Aut_Ingr,8) from Ficha_Ingreso where Cod_Fiin = @Cod_Fiin

	select @Return = pesnet18 from descarga.dbo.DDTICKET18 where nroaut14 = @nroaut14

	RETURN @Return

END

GO
/****** Object:  UserDefinedFunction [dbo].[uf_sf_dev_PesoBal_Fiin_Aux]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[uf_sf_dev_PesoBal_Fiin_Aux]
(
	@Cod_Carg int,
	@Cod_Emba varchar(11),
	@Cod_Fiin int,
	@Cod_Fico int,
	@Cod_Cont varchar(11)
)
RETURNS DECIMAL(8, 2)
AS
BEGIN

	declare @Cod_Carg_aux int, @decReturn DECIMAL(8, 2)

	select top 1 @Cod_Carg_aux = a.Cod_Carg
	from cargas a inner join ficha_ingreso b on a.Cod_Fiin = b.Cod_Fiin
	where a.Cod_Fico = @Cod_Fico and a.Cod_Cont = @Cod_Cont and b.Cod_Fiin = @Cod_Fiin and b.Cod_Emba = @Cod_Emba
	order by b.Cod_Emba, b.Cod_Fiin, a.Cod_Carg

	IF @Cod_Carg = @Cod_Carg_aux
		BEGIN
			SELECT @decReturn = dbo.uf_sf_dev_PesoBal_Fiin(@Cod_Fiin)
		END
	ELSE
		BEGIN
			SET @decReturn = 0
		END

	RETURN @decReturn

END

GO
/****** Object:  UserDefinedFunction [web].[uf_Altertas_ObtenerEmailConsolidador_OLD]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [web].[uf_Altertas_ObtenerEmailConsolidador_OLD]

(

      @RucConsolidador CHAR(11)

)

RETURNS VARCHAR(200)

AS

BEGIN

      RETURN 'didi2120@hotmail.com, didi2120@gmail.com, dicaceres@neptunia.com.pe, mcheel@neptunia.com.pe, aporras@neptunia.com.pe'

END

 



GO
/****** Object:  View [dbo].[EVFWDFOT18]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EVFWDFOT18]
as
select a.ruta as codrut18, a.Cod_Foto as codfot18, b.Aut_Ingr as nroaut14 from Fotos a (nolock) 
inner join Ficha_Ingreso b (nolock) on (a.Cod_Fiin=b.Cod_Fiin)

GO
/****** Object:  View [dbo].[Sf_V_Cargas]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Forwareder  Vistas
--VISTAS  MODIFICADOS POR G&S----
/*rdelacuba 07/08/2007: Se incluye el campo de ubicación por almacén  
rdelacuba 02/01/2008: Se incluye el dato de marca*/
ALTER VIEW [dbo].[Sf_V_Cargas]
AS
SELECT dbo.Cargas.Cod_Carg
	,dbo.Cargas.Cod_Fico
	,dbo.Cargas.Cod_Fiin
	,dbo.Cargas.Po_Carg
	,dbo.Cargas.Sty_Carg
	,dbo.Cargas.Can_Carg
	,dbo.Cargas.Pes_Carg
	,dbo.Cargas.Alt_Carg
	,dbo.Cargas.Anc_Carg
	,dbo.Cargas.Lar_Carg
	,dbo.Cargas.Cod_Tica
	,dbo.Cargas.Des_Carg
	,dbo.Tipo_Carga.Des_Tica
	,dbo.Tipo_Carga.Cod_Bulto
	,dbo.Cargas.Cod_Fior
	,dbo.Cargas.Cod_Fiio
	,dbo.Cargas.Cod_Cont
	,dbo.Cargas.Ubi_Alma
	,CONVERT(VARCHAR(10), dbo.Cargas.Lar_Carg) + ' x ' + CONVERT(VARCHAR(10), dbo.Cargas.Anc_Carg) + ' x ' + CONVERT(VARCHAR(10), dbo.Cargas.Alt_Carg) AS Medidas
	,dbo.Cargas.Est_Carg
	,dbo.Cargas.Ing_Nept
	,dbo.Cargas.Cod_Prod
	,dbo.Cargas.Flg_Impr
	,dbo.Cargas.ubi_conte
	,dbo.Cargas.marca
	,dbo.Ficha_Ingreso.nro_book
	,dbo.Cargas.lpn
FROM dbo.Cargas (NOLOCK)
LEFT OUTER JOIN dbo.Tipo_Carga (NOLOCK) ON dbo.Cargas.Cod_Tica = dbo.Tipo_Carga.Cod_Tica
LEFT OUTER JOIN dbo.Ficha_Ingreso (NOLOCK) ON dbo.Cargas.Cod_Fiin = dbo.Ficha_Ingreso.Cod_Fiin

GO
/****** Object:  View [dbo].[Sf_V_Cargas_Imprimir]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_V_Cargas_Imprimir]
AS
SELECT     dbo.Cargas.Cod_Carg, dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin, dbo.Cargas.Po_Carg, dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, 
                      dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, dbo.Cargas.Cod_Tica, dbo.Cargas.Des_Carg, 
                      dbo.Cargas.Cod_Fior, dbo.Cargas.Cod_Fiio, dbo.Cargas.Cod_Cont, dbo.Cargas.Ubi_Alma, dbo.Cargas.Est_Carg, dbo.Cargas.Cod_Prod, 
                      dbo.Cargas.Ing_Nept, dbo.Cargas.Flg_Impr, dbo.Ficha_Ingreso.Est_Fiin
FROM         dbo.Cargas LEFT OUTER JOIN
                      dbo.Ficha_Ingreso ON dbo.Cargas.Cod_Fiin = dbo.Ficha_Ingreso.Cod_Fiin


GO
/****** Object:  View [dbo].[Sf_v_Cargas_Transf]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_v_Cargas_Transf]
AS
SELECT     dbo.Cargas.Cod_Carg, dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin, dbo.Cargas.Po_Carg, dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, 
                      dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, dbo.Cargas.Cod_Tica, dbo.Cargas.Des_Carg, 
                      dbo.Tipo_Carga.Des_Tica, dbo.Cargas.Cod_Fior, dbo.Cargas.Cod_Fiio, dbo.Cargas.Cod_Cont, dbo.Cargas.Ubi_Alma, CONVERT(varchar(10), 
                      dbo.Cargas.Lar_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Anc_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Alt_Carg) AS Medidas, 
                      dbo.Cargas.Est_Carg, dbo.Cargas.Ing_Nept, dbo.Cargas.Cod_Prod, dbo.Ficha_Ingreso.Cod_Emba,dbo.Ficha_Ingreso.nro_book
FROM         dbo.Cargas LEFT OUTER JOIN
                      dbo.Ficha_Ingreso ON dbo.Cargas.Cod_Fiin = dbo.Ficha_Ingreso.Cod_Fiin LEFT OUTER JOIN
                      dbo.Tipo_Carga ON dbo.Cargas.Cod_Tica = dbo.Tipo_Carga.Cod_Tica


GO
/****** Object:  View [dbo].[Sf_V_Contenedores]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--rdelacuba 07/08/2007: Se incluye el campo de estado de contenedor  
ALTER VIEW [dbo].[Sf_V_Contenedores]
AS
--rdelacuba 07/08/2007: Se incluye el campo de estado de contenedor  
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta  
SELECT DISTINCT CTR.Cod_Cont
	,CTR.Cod_Fico
	,CTR.Cod_Alma
	,ALM.Nom_Alma
	,CTR.Cod_Tipo
	,CTR.Cod_Tama
	,TAM.destam09 AS Nom_Tama
	,TIP.destip05 AS Nom_Tipo
	,CTR.Est_Cont
	,CTR.Payload
	,CTR.Precinto
	,FIC.cod_pue
	,NAV.desnav08 AS Nave
	,CAB.numvia11 AS Viaje
	,NULL AS DUA
	,NULL AS Nro_Autor --q.nroaut14 AS Nro_Autor  
FROM dbo.Contenedores CTR (NOLOCK)
LEFT OUTER JOIN Terminal.dbo.DQTAMCON09 TAM (NOLOCK) ON CTR.Cod_Tama COLLATE SQL_Latin1_General_CP1_CI_AS = TAM.codtam09
LEFT OUTER JOIN Terminal.dbo.DQTIPCON05 TIP (NOLOCK) ON CTR.Cod_Tipo = TIP.codtip05 COLLATE Modern_Spanish_CI_AS
LEFT OUTER JOIN dbo.Almacenes ALM (NOLOCK) ON CTR.Cod_Alma = ALM.Cod_Alma
INNER JOIN dbo.ficha_Consolidacion FIC (NOLOCK) ON FIC.Cod_Fico = CTR.Cod_Fico
---Incluye nave viaje  
INNER JOIN dbo.Ficha_Ingreso ING (NOLOCK) ON FIC.Cod_Fico = ING.Cod_Fico AND (ING.transferido IS NULL OR ING.transferido = 0 )
LEFT OUTER JOIN Terminal.dbo.ddcabman11 CAB (NOLOCK) ON CAB.navvia11 COLLATE Modern_Spanish_CI_AS = ING.navvia11 --(r.navvia11=q.navvia11)  
LEFT OUTER JOIN Terminal.dbo.dqnavier08 NAV (NOLOCK) ON NAV.codnav08 = CAB.codnav08 AND NAV.codnav08 <> 'FTBN'
--WHERE
 --NAV.codnav08 <> 'FTBN'
--AND (
--	ING.transferido IS NULL
--	OR ING.transferido = 0
--	)

GO
/****** Object:  View [dbo].[Sf_V_Detalle_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
--////////////////////////////////////////////////////////                      
                      
 ALTER VIEW [dbo].[Sf_V_Detalle_Carga]
AS
SELECT     dbo.Cargas.Cod_Carg, dbo.Detalle_Carga.Cod_Corr, dbo.Cargas.Cod_Fiin, TERMINAL.dbo.AACONSOL02.NOMBRE AS Nom_Cons, dbo.Cargas.Po_Carg, 
                      dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, 
                      dbo.Cargas.Ubi_Alma, dbo.Cargas.Est_Carg, dbo.Cargas.Ing_Nept, dbo.Cargas.Cod_Prod, dbo.Cargas.Cod_Tica, 
                      dbo.Tipo_Carga.Des_Tica AS Nom_Tica, dbo.Cargas.Des_Carg, dbo.Cargas.marca, dbo.Ficha_Consolidacion.Cod_Fico, dbo.Embarcadores.Nro_Book, 
                      dbo.Ficha_Consolidacion.cod_pue, dbo.Ficha_Ingreso.Fec_Fiin, dbo.Cargas.lpn
FROM         TERMINAL.dbo.AACONSOL02 RIGHT OUTER JOIN
                      dbo.Ficha_Consolidacion ON 
                      TERMINAL.dbo.AACONSOL02.CONTRIBUY COLLATE Modern_Spanish_CI_AS = dbo.Ficha_Consolidacion.Cod_Cons RIGHT OUTER JOIN
                      dbo.Detalle_Carga RIGHT OUTER JOIN
                      dbo.Cargas ON dbo.Detalle_Carga.Cod_Carg = dbo.Cargas.Cod_Carg INNER JOIN
                      dbo.Ficha_Ingreso ON dbo.Cargas.Cod_Fiin = dbo.Ficha_Ingreso.Cod_Fiin ON 
                      dbo.Ficha_Consolidacion.Cod_Fico = dbo.Ficha_Ingreso.Cod_Fico INNER JOIN
                      dbo.Embarcadores ON dbo.Ficha_Ingreso.Cod_Fico = dbo.Embarcadores.Cod_Fico AND 
                      dbo.Ficha_Ingreso.Cod_Emba = dbo.Embarcadores.Cod_Emba AND dbo.Ficha_Ingreso.nro_book = dbo.Embarcadores.Nro_Book INNER JOIN
                      dbo.Tipo_Carga ON dbo.Cargas.Cod_Tica = dbo.Tipo_Carga.Cod_Tica



GO
/****** Object:  View [dbo].[Sf_v_Detalle_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_v_Detalle_Simulacion2]
AS
SELECT     dbo.Detalle_Simulacion2.Cod_Sim2, dbo.Detalle_Simulacion2.Cod_Carg, dbo.Simulacion2.Nom_Usua, dbo.Simulacion2.Cod_Fico, 
                      dbo.Cargas.Cod_Fiin, dbo.Cargas.Po_Carg, dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, 
                      dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, dbo.Cargas.Cod_Tica, dbo.Cargas.Des_Carg, dbo.Cargas.Cod_Fior, dbo.Cargas.Cod_Fiio, 
                      dbo.Cargas.Cod_Cont, dbo.Cargas.Ubi_Alma, dbo.Cargas.Est_Carg, dbo.Cargas.Ing_Nept, dbo.Cargas.Cod_Prod, dbo.Tipo_Carga.Des_Tica,CONVERT(varchar(10), 
                      dbo.Cargas.Lar_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Anc_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Alt_Carg) AS Medidas
FROM         dbo.Tipo_Carga RIGHT OUTER JOIN
                      dbo.Cargas ON dbo.Tipo_Carga.Cod_Tica = dbo.Cargas.Cod_Tica RIGHT OUTER JOIN
                      dbo.Detalle_Simulacion2 LEFT OUTER JOIN
                      dbo.Simulacion2 ON dbo.Detalle_Simulacion2.Cod_Sim2 = dbo.Simulacion2.Cod_Sim2 ON dbo.Cargas.Cod_Carg = dbo.Detalle_Simulacion2.Cod_Carg



GO
/****** Object:  View [dbo].[Sf_V_DetalleCarga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_V_DetalleCarga]
AS
SELECT     dbo.Cargas.Cod_Carg, dbo.Detalle_Carga.Cod_Corr, RIGHT('000000000000' + CONVERT(varchar(12), dbo.Detalle_Carga.Cod_Corr), 12) AS correlativo,
	   dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin, dbo.Cargas.Po_Carg, dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, 
           dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, dbo.Cargas.Cod_Tica, dbo.Cargas.Des_Carg, 
           dbo.Tipo_Carga.Des_Tica, dbo.Cargas.Cod_Fior, dbo.Cargas.Cod_Fiio, dbo.Cargas.Cod_Cont, dbo.Cargas.Ubi_Alma, CONVERT(varchar(10), 
           dbo.Cargas.Lar_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Anc_Carg) + ' x ' + CONVERT(varchar(10), dbo.Cargas.Alt_Carg) AS Medidas, 
           dbo.Cargas.Est_Carg, dbo.Cargas.Ing_Nept, dbo.Cargas.Cod_Prod,dbo.Cargas.Flg_Impr,dbo.Cargas.ubi_conte
FROM         dbo.Cargas (nolock) LEFT OUTER JOIN
             dbo.Tipo_Carga (nolock) ON dbo.Cargas.Cod_Tica = dbo.Tipo_Carga.Cod_Tica INNER JOIN
	     dbo.Detalle_Carga (nolock) on dbo.Cargas.Cod_Carg = dbo.Detalle_Carga.Cod_Carg


GO
/****** Object:  View [dbo].[Sf_V_Embarcadores]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
                      
--////////////////////////////////////////////////////////       
  
  -- View

ALTER VIEW [dbo].[Sf_V_Embarcadores]  
AS  
--rdelacuba 31/07/2007: Se incluye campo co_load  
--LBC 17-04-2012 Se agrego columna dbo.Embarcadores.Book_Madre
SELECT     dbo.Embarcadores.Cod_Fico, dbo.Embarcadores.Cod_Emba, dbo.Embarcadores.Cod_CoLoad, dbo.Embarcadores.Nro_Book,   
                      e.NOMBRE AS Nom_Emba, c.nombre as Co_Loader, dbo.Ficha_Consolidacion.Est_Fico,dbo.Embarcadores.Book_Madre  
FROM         dbo.Embarcadores INNER JOIN  
      dbo.Ficha_Consolidacion ON dbo.Embarcadores.Cod_Fico = dbo.Ficha_Consolidacion.Cod_Fico LEFT OUTER JOIN  
             Terminal.dbo.AACLIENTESAA e ON dbo.Embarcadores.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = e.CONTRIBUY LEFT OUTER JOIN  
      Terminal.dbo.AACLIENTESAA c ON dbo.Embarcadores.Cod_CoLoad COLLATE SQL_Latin1_General_CP1_CI_AS = c.CONTRIBUY  
WHERE  dbo.Embarcadores.Cod_Emba <>  '11111111111' --Req Luis Carrillo

GO
/****** Object:  View [dbo].[Sf_V_Ficha_Consolidacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[Sf_V_Ficha_Consolidacion]    
AS    
SELECT DISTINCT dbo.Ficha_Consolidacion.Cod_Fico    
 ,dbo.Ficha_Consolidacion.Cod_Cons    
 ,dbo.Ficha_Consolidacion.Fec_Fico    
 ,dbo.Ficha_Consolidacion.Fec_Emba    
 ,dbo.Ficha_Consolidacion.Usu_Creo    
 ,Terminal.dbo.AACONSOL02.NOMBRE AS Nom_Cons    
 ,dbo.Ficha_Consolidacion.Est_Fico    
 ,isnull(dbo.Ficha_Consolidacion.Cod_Pue, '') AS Cod_Pue    
 ,isnull(p.despue02, '') AS Nom_Pue    
 ,s.desnav08 AS Nave    
 ,r.numvia11 AS Viaje    
 ,s.codnav08    
 ,dbo.Ficha_Ingreso.transferido    
 ,    
 --se agrega contenedor y fecha de destino      
 t.Cod_Cont --,v.fecsal18      
FROM dbo.Ficha_Consolidacion    
LEFT OUTER JOIN contenedores t ON (t.Cod_Fico = dbo.Ficha_Consolidacion.Cod_Fico)    
--inner JOIN contenedores t ON (t.Cod_Fico = dbo.Ficha_Consolidacion.Cod_Fico)    
LEFT OUTER JOIN Terminal.dbo.AACONSOL02 ON dbo.Ficha_Consolidacion.Cod_Cons = Terminal.dbo.AACONSOL02.CONTRIBUY COLLATE Modern_Spanish_CI_AS    
--descarga.dbo.dqpuerto02 p ON dbo.Ficha_Consolidacion.Cod_Pue = p.codpue02 COLLATE Modern_Spanish_CI_AS    
LEFT JOIN descarga.dbo.TM_PUERTO p ON dbo.Ficha_Consolidacion.Cod_Pue = p.codpue02 COLLATE Modern_Spanish_CI_AS    
---Incluye nave viaje      
LEFT OUTER JOIN dbo.Ficha_Ingreso ON (    
  dbo.Ficha_Consolidacion.Cod_Fico = dbo.Ficha_Ingreso.Cod_Fico    
  AND (    
   dbo.Ficha_Ingreso.transferido IS NULL    
   OR dbo.Ficha_Ingreso.transferido = 0    
   )    
  )    
LEFT OUTER JOIN Terminal.dbo.ddcabman11 r ON (r.navvia11 = Ficha_Ingreso.navvia11 COLLATE Modern_Spanish_CI_AS)    
LEFT OUTER JOIN Terminal.dbo.dqnavier08 s ON (s.codnav08 = r.codnav08)    
--Se invluye cotnenedor      
--Se incluye fecha de salida      
--      left outer join descarga.dbo.DRCTRTMC90 u on (t.Cod_Cont=u.codcon04 COLLATE Modern_Spanish_CI_AS) and u.navvia11 = r.navvia11      
--      left outer join balanza.dbo.ddticket18 v on (u.nrotkt28=v.nrotkt18)      
WHERE dbo.Ficha_Consolidacion.visible = 1 and  dbo.Ficha_Consolidacion.Fec_Fico>'20160101' 
GO
/****** Object:  View [dbo].[Sf_V_Ficha_Ingreso]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[Sf_V_Ficha_Ingreso]
AS
--rdelacuba 31/12/2007: Se incluyen los datos de nave-viaje y peso de la balanza
--lmalpartida 08/04/2009: Cambiar fecha para mostrar, no la de la ficha de ingreso sino la de la autorización
SELECT     dbo.Ficha_Ingreso.Cod_Fiin, dbo.Ficha_Ingreso.Cod_Fico, z.fecaut14 as Fec_Fiin, dbo.Ficha_Ingreso.Gui_Remi, dbo.Ficha_Ingreso.Usu_Crea, 
           dbo.Ficha_Ingreso.Cod_Emba, dbo.Ficha_Ingreso.Des_Carg, dbo.Ficha_Ingreso.Pla_Vehi, AACLIENTESAA_2.NOMBRE AS Nom_Emba, 
           dbo.Ficha_Ingreso.Emb_Nore, AACLIENTESAA_1.NOMBRE AS Nom_Nore, dbo.Ficha_Ingreso.Aut_Ingr, dbo.Ficha_Ingreso.Est_Fiin,
	   dbo.Ficha_Ingreso.navvia11, v.numvia11, dbo.Ficha_Ingreso.codnav08, n.desnav08,dbo.Ficha_Ingreso.Nro_Book
FROM         dbo.Ficha_Ingreso LEFT OUTER JOIN
             Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON 
              dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY LEFT OUTER JOIN
              Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON 
              dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY LEFT OUTER JOIN
	      descarga.dbo.ddcabman11 v ON 
	      dbo.Ficha_Ingreso.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = v.navvia11 LEFT OUTER JOIN
	      descarga.dbo.dqnavier08 n ON 
	      dbo.Ficha_Ingreso.codnav08 COLLATE SQL_Latin1_General_CP1_CI_AS = n.codnav08
	      inner join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14
--WHERE n.codnav08 <>'FTBN'

GO
/****** Object:  View [dbo].[Sf_v_Log]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_v_Log]
AS
SELECT     dbo.[Log].Cod_Regi, dbo.[Log].Des_Regi, dbo.[Log].Cod_Cont, dbo.[Log].Fec_Regi, dbo.[Log].Cod_Fico, dbo.[Log].Cod_Fiin, dbo.[Log].Cod_Tilo, 
                      dbo.Tipo_Log.Nom_Tilo, dbo.Tipo_Log.Cod_Tire
FROM         dbo.[Log] LEFT OUTER JOIN
                      dbo.Tipo_Log ON dbo.[Log].Cod_Tilo = dbo.Tipo_Log.Cod_Tilo


GO
/****** Object:  View [dbo].[Sf_V_Simulacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_V_Simulacion]
AS
SELECT     dbo.Cargas.Cod_Carg, dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin, dbo.Cargas.Po_Carg, dbo.Cargas.Sty_Carg, dbo.Cargas.Can_Carg, 
                      dbo.Cargas.Pes_Carg, dbo.Cargas.Alt_Carg, dbo.Cargas.Anc_Carg, dbo.Cargas.Lar_Carg, dbo.Cargas.Cod_Tica, dbo.Tipo_Carga.Des_Tica, 
                      dbo.Cargas.Des_Carg, dbo.Cargas.Cod_Fior, dbo.Cargas.Cod_Fiio, dbo.Cargas.Cod_Cont, dbo.Cargas.Ubi_Alma, dbo.Simulacion1.Nom_Usua
FROM         dbo.Cargas LEFT OUTER JOIN
                      dbo.Tipo_Carga ON dbo.Cargas.Cod_Tica = dbo.Tipo_Carga.Cod_Tica LEFT OUTER JOIN
                      dbo.Simulacion1 ON dbo.Cargas.Cod_Carg = dbo.Simulacion1.Cod_Carg



GO
/****** Object:  View [dbo].[Sf_v_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Sf_v_Simulacion2]
AS
SELECT     dbo.Simulacion2.Cod_Sim2, dbo.Simulacion2.Nom_Usua, dbo.Simulacion2.Cod_Fico, dbo.Simulacion2.Cod_Tama, dbo.Simulacion2.Cod_Tipo, 
                      Terminal.dbo.DQTAMCON09.destam09 AS Nom_Tama, Terminal.dbo.DQTIPCON05.destip05 AS Nom_Tipo, dbo.Volumen_Maximo.Cap_Maxi
FROM         dbo.Simulacion2 LEFT OUTER JOIN
                      dbo.Volumen_Maximo ON dbo.Simulacion2.Cod_Tipo = dbo.Volumen_Maximo.Cod_Tipo AND 
                      dbo.Simulacion2.Cod_Tama = dbo.Volumen_Maximo.Cod_Tama LEFT OUTER JOIN
                      Terminal.dbo.DQTIPCON05 ON dbo.Simulacion2.Cod_Tipo = Terminal.dbo.DQTIPCON05.codtip05 COLLATE Modern_Spanish_CI_AS LEFT OUTER JOIN
                      Terminal.dbo.DQTAMCON09 ON dbo.Simulacion2.Cod_Tama COLLATE SQL_Latin1_General_CP1_CI_AS = Terminal.dbo.DQTAMCON09.codtam09


GO
/****** Object:  View [dbo].[w_temporal_borrala_xD]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[w_temporal_borrala_xD]
as
select u.codcon04,v.fecsal18 from
descarga.dbo.DRCTRTMC90 u
left outer join balanza.dbo.ddticket18 v on u.nrotkt28=v.nrotkt18
GO
/****** Object:  StoredProcedure [dbo].[DemoSP_ValidarBooking]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 --43 TARJA EXPO
 
  -- DemoSP_ValidarBooking '00639727',''
ALTER PROCEDURE [dbo].[DemoSP_ValidarBooking]  
@CodAutorizacion varchar(50),   
@booking varchar(50) output       
AS  
BEGIN  


SET @booking=(SELECT 
	--top 50 v.numvia11,v.codnav08,nav.desnav08,a.nroaut14,a.navvia11,a.nropla81,a.codemc12,a.nrogui14,a.conten13,FI.Aut_Ingr,
	fi.nro_book    
FROM descarga.dbo.EDAUTING14 a 
INNER JOIN descarga.dbo.ddcabman11 v ON a.navvia11 = v.navvia11    
LEFT JOIN  descarga.dbo.dqnavier08 nav ON (v.codnav08 = nav.codnav08)  
LEFT JOIN Ficha_Ingreso FI ON FI.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS =a.nroaut14
WHERE a.nroaut14 = @CodAutorizacion)

--select  * from descarga.dbo.dqnavier08
--select  * from descarga.dbo.ddcabman11
--select  * from descarga.dbo.dqnavier08
--select  * from Ficha_Ingreso 
	--select @booking as NroBooking

END


GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_addtosourcecontrol]
    @vchSourceSafeINI varchar(255) = '',
    @vchProjectName   varchar(255) ='',
    @vchComment       varchar(255) ='',
    @vchLoginName     varchar(255) ='',
    @vchPassword      varchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* ALTER Project in SS */
    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'AddProjectToSourceSafe',
											NULL,
											@vchSourceSafeINI,
											@vchProjectName output,
											@@SERVERNAME,
											@vchDatabaseName,
											@vchLoginName,
											@vchPassword,
											@vchComment


    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties
    
    select @iObjectCount = 0;

CleanUp:
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_addtosourcecontrol_u]
    @vchSourceSafeINI nvarchar(255) = '',
    @vchProjectName   nvarchar(255) ='',
    @vchComment       nvarchar(255) ='',
    @vchLoginName     nvarchar(255) ='',
    @vchPassword      nvarchar(255) =''

as
	-- This procedure should no longer be called;  dt_addtosourcecontrol should be called instead.
	-- Calls are forwarded to dt_addtosourcecontrol to maintain backward compatibility
	set nocount on
	exec dbo.dt_addtosourcecontrol 
		@vchSourceSafeINI, 
		@vchProjectName, 
		@vchComment, 
		@vchLoginName, 
		@vchPassword



GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Add an object to the dtproperties table
*/
ALTER PROCEDURE [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** ALTER the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity

GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject_vcs]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_adduserobject_vcs]
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** ALTER the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn



GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_checkinobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '', /* ALTER stream */
    @txStream3     Text = ''  /* grant stream  */


as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0
	declare @iStreamObjectId int

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iPropertyObjectId int
	select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    declare @iReturnValue	  int
    declare @pos			  int
    declare @vchProcLinePiece varchar(255)

    
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, ALTER Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT
        if @iReturn <> 0 GOTO E_OAError
        
        if @iActionFlag = 1
        begin
            
            declare @iStreamLength int
			
			select @pos=1
			select @iStreamLength = datalength(@txStream2)
			
			if @iStreamLength > 0
			begin
			
				while @pos < @iStreamLength
				begin
						
					select @vchProcLinePiece = substring(@txStream2, @pos, 255)
					
					exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
            		if @iReturn <> 0 GOTO E_OAError
            		
					select @pos = @pos + 255
					
				end
            
				exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
														'CheckIn_StoredProcedure',
														NULL,
														@sProjectName = @vchProjectName,
														@sSourceSafeINI = @vchSourceSafeINI,
														@sServerName = @vchServerName,
														@sDatabaseName = @vchDatabaseName,
														@sObjectName = @vchObjectName,
														@sComment = @vchComment,
														@sLoginName = @vchLoginName,
														@sPassword = @vchPassword,
														@iVCSFlags = @iVCSFlags,
														@iActionFlag = @iActionFlag,
														@sStream = ''
                                        
			end
        end
        else
        begin
        
            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin                
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255                  
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
													'CheckIn_StoredProcedure',
													NULL,
													@sProjectName = @vchProjectName,
													@sSourceSafeINI = @vchSourceSafeINI,
													@sServerName = @vchServerName,
													@sDatabaseName = @vchDatabaseName,
													@sObjectName = @vchObjectName,
													@sComment = @vchComment,
													@sLoginName = @vchLoginName,
													@sPassword = @vchPassword,
													@iVCSFlags = @iVCSFlags,
													@iActionFlag = @iActionFlag,
													@sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
	return

E_Compile_Fail:
	declare @lerror int
	select @lerror = @@error
	rollback tran compile_all
	RAISERROR (@lerror,16,-1)
	goto CleanUp

E_OAError:
	if @iActionFlag = 1 rollback tran compile_all
	exec dbo.dt_displayoaerror @iObjectId, @iReturn
	goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_checkinobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     text = '',  /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     text = '',  /* ALTER stream */
    @txStream3     text = ''   /* grant stream  */

as	
	-- This procedure should no longer be called;  dt_checkinobject should be called instead.
	-- Calls are forwarded to dt_checkinobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkinobject
		@chObjectType,
		@vchObjectName,
		@vchComment,
		@vchLoginName,
		@vchPassword,
		@iVCSFlags,
		@iActionFlag,   
		@txStream1,		
		@txStream2,		
		@txStream3		



GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_checkoutobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId =0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @vchTempText varchar(255)

	/* this is for our strings */
	declare @iStreamObjectId int
	select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, ALTER Stream, GRANT stream */

        exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'CheckOut_StoredProcedure',
												NULL,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sComment = @vchComment,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword,
												@iVCSFlags = @iVCSFlags,
												@iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        CREATE table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #commenttext (sourcecode) select @vchTempText
        end

        select 'VCS'=sourcecode from #commenttext order by id
        select 'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_checkoutobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	-- This procedure should no longer be called;  dt_checkoutobject should be called instead.
	-- Calls are forwarded to dt_checkoutobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkoutobject
		@chObjectType,  
		@vchObjectName, 
		@vchComment,    
		@vchLoginName,  
		@vchPassword,  
		@iVCSFlags,    
		@iActionFlag 



GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_displayoaerror]
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = master.dbo.sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return


GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_displayoaerror_u]
    @iObject int,
    @iresult int
as
	-- This procedure should no longer be called;  dt_displayoaerror should be called instead.
	-- Calls are forwarded to dt_displayoaerror to maintain backward compatibility.
	set nocount on
	exec dbo.dt_displayoaerror
		@iObject,
		@iresult



GO
/****** Object:  StoredProcedure [dbo].[dt_droppropertiesbyid]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
ALTER PROCEDURE [dbo].[dt_droppropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property


GO
/****** Object:  StoredProcedure [dbo].[dt_dropuserobjectbyid]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Drop an object from the dbo.dtproperties table
*/
ALTER PROCEDURE [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id

GO
/****** Object:  StoredProcedure [dbo].[dt_generateansiname]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
ALTER PROCEDURE [dbo].[dt_generateansiname](@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = 'MSDT-A-' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = 'DIAGRAM' 
	goto Leave 

GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve the owner object(s) of a given property
*/
ALTER PROCEDURE [dbo].[dt_getobjwithprop]
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value

GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve the owner object(s) of a given property
*/
ALTER PROCEDURE [dbo].[dt_getobjwithprop_u]
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_u]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property

GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_vcs]
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )


GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_getpropertiesbyid_vcs_u]
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    -- This procedure should no longer be called;  dt_getpropertiesbyid_vcsshould be called instead.
	-- Calls are forwarded to dt_getpropertiesbyid_vcs to maintain backward compatibility.
	set nocount on
    exec dbo.dt_getpropertiesbyid_vcs
		@id,
		@property,
		@value output


GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_isundersourcecontrol]
    @vchLoginName varchar(255) = '',
    @vchPassword  varchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName = '')	set @vchProjectName		= null
    if (@vchSourceSafeINI = '') set @vchSourceSafeINI	= null
    if (@vchServerName = '')	set @vchServerName		= null
    if (@vchDatabaseName = '')	set @vchDatabaseName	= null
    
    if (@vchProjectName is null) or (@vchSourceSafeINI is null) or (@vchServerName is null) or (@vchDatabaseName is null)
    begin
        RAISERROR('Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'GetListOfObjects',
												NULL,
												@vchProjectName,
												@vchSourceSafeINI,
												@vchServerName,
												@vchDatabaseName,
												@vchLoginName,
												@vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        CREATE table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_isundersourcecontrol_u]
    @vchLoginName nvarchar(255) = '',
    @vchPassword  nvarchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as
	-- This procedure should no longer be called;  dt_isundersourcecontrol should be called instead.
	-- Calls are forwarded to dt_isundersourcecontrol to maintain backward compatibility.
	set nocount on
	exec dbo.dt_isundersourcecontrol
		@vchLoginName,
		@vchPassword,
		@iWhoToo 



GO
/****** Object:  StoredProcedure [dbo].[dt_removefromsourcecontrol]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_removefromsourcecontrol]

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0



GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
ALTER PROCEDURE [dbo].[dt_setpropertybyid]
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end


GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
ALTER PROCEDURE [dbo].[dt_setpropertybyid_u]
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if 'DtgSchemaNAME' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end

GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_validateloginparams]
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'ValidateLoginParams',
											NULL,
											@sSourceSafeINI = @vchSourceSafeINI,
											@sLoginName = @vchLoginName,
											@sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_validateloginparams_u]
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

	-- This procedure should no longer be called;  dt_validateloginparams should be called instead.
	-- Calls are forwarded to dt_validateloginparams to maintain backward compatibility.
	set nocount on
	exec dbo.dt_validateloginparams
		@vchLoginName,
		@vchPassword 



GO
/****** Object:  StoredProcedure [dbo].[dt_vcsenabled]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_vcsenabled]

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iReturn int
    exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('', 16, -1) /* Can't Load Helper DLLC */



GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp006]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by legacy versions of the Microsoft
**	Visual Database Tools.  Version is 7.0.00.
*/
ALTER PROCEDURE [dbo].[dt_verstamp006]
as
	select 7000

GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp007]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by the the Microsoft Visual Database Tools.
**	Version is 7.0.05.
*/
ALTER PROCEDURE [dbo].[dt_verstamp007]
as
	select 7005

GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_whocheckedout]
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = master.dbo.sp_OAALTER @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'WhoCheckedOut',
												@vchReturnValue OUT,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp



GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout_u]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[dt_whocheckedout_u]
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

	-- This procedure should no longer be called;  dt_whocheckedout should be called instead.
	-- Calls are forwarded to dt_whocheckedout to maintain backward compatibility.
	set nocount on
	exec dbo.dt_whocheckedout
		@chObjectType, 
		@vchObjectName,
		@vchLoginName, 
		@vchPassword  



GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Fwd_Foto_Llenado_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER PROCEDURE [dbo].[sp_Expo_Fwd_Foto_Llenado_Contenedor] --'00934739', 'HASU1050888'
@sNroAut char(8),
@sCodCon char(11)
as
select b.ruta,b.Cod_Foto from Ficha_Ingreso a (nolock)
inner join Fotos b (nolock) on (a.Cod_Fico=b.Cod_Fico)
where a.Aut_Ingr=ltrim(rtrim(@sNroAut)) and b.Cod_Cont=@sCodCon
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Fwd_Foto_Tarja_x_Autorizacion_Ingreso]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Fwd_Foto_Tarja_x_Autorizacion_Ingreso]
@sNroAut char(8) 
AS
select a.ruta as 
codrut18, a.Cod_Foto as codfot18, b.Aut_Ingr 
as nroaut14 
from Fotos a (nolock)   
inner join Ficha_Ingreso b (nolock) on (a.Cod_Fiin=b.Cod_Fiin) 
where b.aut_ingr=@sNroAut
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Fwd_Observacion_x_Aut_Ingreso]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Fwd_Observacion_x_Aut_Ingreso]

@sNroAut char(8)
as
Begin
select top 1 Des_Regi from Ficha_Ingreso fic (nolock)
inner join Log lg (nolock) on fic.Cod_Fico=lg.Cod_Fico and fic.Cod_Fiin=lg.Cod_Fiin
where fic.Aut_Ingr=@sNroAut

End


GO
/****** Object:  StoredProcedure [dbo].[sp_Forwarders_enviarAltertaRetiroCamion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Forwarders_enviarAltertaRetiroCamion]    
AS    
--return  
BEGIN    
 DECLARE @Min INT    
  ,@Max INT    
  ,@RucConsolidador CHAR(11)    
  ,@NombreConsolidador VARCHAR(80)    
  ,@Cod_Fiin INT    
  ,@Contenedor VARCHAR(100)    
  ,@NaveViaje VARCHAR(6)    
  ,@eMail VARCHAR(200)    
  ,@body VARCHAR(4000)    
  ,@url VARCHAR(500)    
  ,@enviado BIT    
  ,@RC INT    
  ,@nro_book VARCHAR(25)    
  ,@book_cmpl VARCHAR(25) --AGREGADO 07-05-2015    
  ,@Aut_Ingr VARCHAR(8)    
  --Se llenan los consolidadores y el codigo de la ficha de ingreso                                  
 DECLARE @Consolidadores TABLE (    
  Indice INT IDENTITY(1, 1) PRIMARY KEY    
  ,RucConsolidador CHAR(11)    
  ,Cod_Fiin INT    
  ,Contenedor VARCHAR(100)    
  ,NaveViaje VARCHAR(6)    
  ,nro_book VARCHAR(25)    
  ,bookin_Completo VARCHAR(25)    
  )    
    
 INSERT @Consolidadores    
 SELECT DISTINCT EN.ruccli13    
  ,--ruc consolidador                                  
  Ficha_Ingreso.Cod_Fiin    
  ,EN.codcon04    
  ,EN.navvia11    
  ,isnull(EN.bookin13, Ficha_Ingreso.nro_book)    
  ,--Ficha_Ingreso.nro_book       --AGREGADO 07-05-2015                               
  ISNULL(EN.bkgcom13, EN.bookin13) AS bkgcom13    
 FROM DESCARGA.DBO.USP_FwdExpoenviarAlterta EN     
 INNER JOIN Ficha_Ingreso ON Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = EN.nroaut14    
  AND Ficha_Ingreso.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = EN.BOOnavvia11    
 WHERE EN.fecsal18 BETWEEN dateadd(HOUR, - 24, getdate())    
   AND getdate()    
  AND EN.ruccli13 IS NOT NULL    
  AND EN.nrosal52 IS NULL    
  and Ficha_Ingreso.Est_Fiin='C' --Solicitud HBendezu  
    
 SET @Max = @@RowCount    
 SET @Min = 1    
    
 SELECT @url = dbo.uf_Forwarders_Altertas_ObtenerUrlFichaIngreso()    
    
 WHILE @Min <= @Max    
 BEGIN    
  SELECT @RucConsolidador = RucConsolidador    
   ,@Cod_Fiin = Cod_Fiin    
   ,@Contenedor = Contenedor    
   ,@NaveViaje = NaveViaje    
   ,@nro_book = nro_book    
   ,@book_cmpl = bookin_Completo    
  FROM @Consolidadores    
  WHERE Indice = @Min    
    
  -- Verifico si ya fue enviada la alerta                                  
  SELECT @enviado = ISNULL(enviado, 0),@Aut_Ingr=ISNULL(Aut_Ingr, '')    
  FROM Ficha_Ingreso    
  WHERE Cod_Fiin = @Cod_Fiin    
    
  IF @enviado = 0    
   --Si no fue enviada, procedo a enviarla                                  
  BEGIN    
   SELECT @NombreConsolidador = NOMBRE    
   FROM TERMINAL..AACONSOL02    
   WHERE CONTRIBUY = @RucConsolidador    
    
   SELECT @eMail = dbo.uf_Altertas_ObtenerEmailConsolidador(@RucConsolidador)    
    
   SELECT @body = '<html><body>    
<p style="font-family: Calibri; vertical-align: middle;">Estimado Cliente: ' + @NombreConsolidador + '<br />    
Por medio de la presente informamos que se ha efectuado un ingreso de carga consolidada en nuestros almacenes.<br />    
Para ver el detalle, ingrese a consultar nuestra ficha de ingreso, clic aquí <strong>    
<span style="font-size: 24pt">&rArr;</span></strong>&nbsp;<a  href="' + @url + convert(VARCHAR(10), @Cod_Fiin) + '">    
<img alt="Consultar ficha de ingreso" src="http://www.neptunia.com.pe/web_forwarderscliente/FotosForwarders/Temp/FiIn_small.jpg"  style="vertical-align: middle" /></a></p>    
<p style="font-family: Calibri; vertical-align: middle;">Booking : ' + ltrim(rtrim(@nro_book)) + '<br/><p style="font-family: Calibri; vertical-align: middle;">Atte.</p><p style="font-family: Calibri; vertical-align: middle;">NEPTUNIA S.A.</p></body></htm

  
l>'    
    
   DECLARE @cabecera VARCHAR(200)    
    
   SET @cabecera = 'Notificación de ingreso de carga consolidada - Booking Completo: ' + @book_cmpl    
    
   INSERT INTO Ficha_Correo (    
    Cod_Fiin    
    ,eMail    
    ,cabecera    
    ,FechaEnvio    
    )    
   VALUES (    
    ISNULL(@Cod_Fiin, 0)    
    ,ISNULL(@eMail, '')    
    ,ISNULL(@cabecera, '')    
    ,GETDATE()    
    )    
    
   EXECUTE @rc = master.dbo.xp_smtp_sendmail @FROM = 'aneptunia@neptunia.com.pe'    
    ,@TO = @eMail    
    ,@BCC = 'nelida.felices@neptunia.com.pe; pedro.mercado@neptunia.com.pe; patio.forwarders@neptunia.com.pe; grissel.padilla@neptunia.com.pe ;leslie.delacruz@neptunia.com.pe; manuel.cuya@neptunia.com.pe'    
    ,@message = @body    
    ,@subject = @cabecera    
    ,@priority = 'HIGH'    
    ,@type = 'text/html'    
    ,@server = 'correo.neptunia.com.pe'    
    
   UPDATE Ficha_Ingreso    
   SET enviado = 1    
   WHERE Cod_Fiin = @Cod_Fiin    
    
   UPDATE Descarga.dbo.ddticket18    
   SET nrosal52 = '1'    
   WHERE codcon04 = @Contenedor    
    AND navvia11 = @NaveViaje    
    AND nroaut14 = @Aut_Ingr    
  END    
    
  SET @Min = @Min + 1    
 END    
END 


GO
/****** Object:  StoredProcedure [dbo].[Sp_Int2_Int001_TARJA_MODIFICADETALLE_FORWARDERS]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Int2_Int001_TARJA_MODIFICADETALLE_FORWARDERS]   
@TipoModificacion char(1), --Para indicar que modificacion se va a realizar: 1-->Modificacion / 2-->Desdoble / 3-->Acondicionamiento  
@LPN varchar(18),    
@TipoBulto varchar(3), -- (CTN, VEH, BLD,...)    
@NumeroBulto int,    
@Peso decimal(9,3),    
@Marcas varchar(100),    
@Estado char(1),  
@Largo decimal(9,3),    
@Ancho decimal(9,3),    
@Alto decimal(9,3),    
@Observacion varchar(80),  
@cod_carg int,  
@Usuario varchar(25)  
AS  
declare @Volumen float  
declare @Mensaje varchar(500)    
declare @cod_tica tinyint, @Cod_Fico int, @Cod_Fiin int, @Cod_Fior int, @Cod_Fiio int  
declare @Cod_Cont varchar(11), @Ubi_Alma varchar(10), @Ing_Nept varchar(1), @Cod_Prod varchar(5)  
declare @Existe integer  
  
BEGIN  
 select @Cod_tica=cod_tica from Tipo_Carga where Cod_bulto=@TipoBulto  
  
 select @Cod_Fico = Cod_Fico, @Cod_Fiin = Cod_Fiin, @Cod_Fior = Cod_Fior, @Cod_Fiio = Cod_Fiio,   
 @Cod_Cont = Cod_Cont, @Ubi_Alma = Ubi_Alma, @Ing_Nept = Ing_Nept, @Cod_Prod = Cod_Prod  
 from cargas where cod_carg = @cod_carg --and lpn=@LPN   
  
 --Modificar LPN  
 if @TipoModificacion='1'  
 Begin  
  update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,   
  Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
  where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN  
  
  if @@RowCount = 0   
  Begin  
   Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
   RAISERROR (@Mensaje, 16, 1)    
   return   
  End   
  
  select @cod_carg  
 End -- fin modificacion  
  
   --Desdoble LPN   
 if @TipoModificacion='2'  
 Begin  
--  declare @Existe integer  
  select @Existe=count(*) from Cargas where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN   
  If @Existe > 0   
  Begin  
   if @NumeroBulto > 0 --and @Peso > 0  
   Begin  
    update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,    
    Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
    where cod_carg = @cod_carg --and lpn=@LPN  and cod_tica=@Cod_tica  
 --   set @Mensaje=''  
 --   return @Mensaje  
    select @cod_carg  
   end  
   else  
   begin  
    delete from Cargas where cod_carg = @cod_carg --and lpn=@LPN and cod_tica=@Cod_tica  
    select @cod_carg  
   end  
  End  
  Else  
  Begin  
   if @NumeroBulto > 0 --and @Peso > 0  
   Begin  
    if not (@cod_carg is null) and @cod_carg > 0 -- Si no existe y es diferente de nulo o blanco error por descuadre  
    Begin  
     Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End   
  
	if @cod_carg is null
    Begin  
     Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no debe ser nulo'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End  

	if @cod_carg < 0 -- para el caso de la paleta nueva del desdoble.
	begin
		-- obtenemos los datos de la carga de la paleta padre.
		select @Cod_Fico = Cod_Fico, @Cod_Fiin = Cod_Fiin, @Cod_Fior = Cod_Fior, @Cod_Fiio = Cod_Fiio,   
		@Cod_Cont = Cod_Cont, @Ubi_Alma = Ubi_Alma, @Ing_Nept = Ing_Nept, @Cod_Prod = Cod_Prod  
		from cargas where cod_carg = @cod_carg*(-1) --and lpn=@LPN   

		insert Cargas(Can_Carg, Lar_Carg, Anc_Carg, Alt_Carg, marca, Pes_Carg, cod_tica, Est_Carg, lpn,Cod_Fico,   
		Cod_Fiin, Cod_Fior, Cod_Fiio, Cod_Cont, Ubi_Alma, Ing_Nept, Cod_Prod, usuario_modificacion, fecha_modificacion)   
		values (@NumeroBulto, @Largo, @Ancho, @Alto, @Marcas, @Peso, @Cod_tica, @Estado, @LPN,  
		@Cod_Fico, @Cod_Fiin, @Cod_Fior, @Cod_Fiio, @Cod_Cont, @Ubi_Alma, @Ing_Nept, @Cod_Prod, @usuario, getdate())  
	end
--    set @Mensaje=''  
--    return @Mensaje  
    SET @cod_carg = @@IDENTITY  
    /* if isnull(@cod_carg, '') = ''   
    select @cod_carg = max(cod_carg) from Cargas*/  
    select @cod_carg  
   End  
   Else  
   Begin  
    Set @Mensaje = 'La cantidad de bultos y/o peso no deben ser 0.'  
    RAISERROR (@Mensaje, 16, 1)    
    return   
   End  
  End  
 End -- Fin desdoble   
  
   --Acondicionamiento LPN  
 if @TipoModificacion='3'  
 Begin  
  if @NumeroBulto > 0  
  Begin        
   if not(@cod_carg is null) and @cod_carg > 0 -- si el registro es nuevo por deferentes tipo de bulto  
   begin  
    --declare @Existe integer  
    select @Existe=count(*) from Cargas where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN   
    If @Existe = 0   
    Begin  
     Set @Mensaje = 'Error al hacer el acondicionamiento, el codigo de carga (PDA FWD) no es valido o no existe'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End   
     
    update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,    
    Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
    where cod_carg = @cod_carg --and lpn=@LPN  and cod_tica=@Cod_tica  
   end  
   else -- Si es nulo para los nuevos registros  
   Begin
   
	If @cod_carg is null   
    Begin  
     Set @Mensaje = 'Error al hacer el acondicionamiento, el codigo de carga (PDA FWD) no debe ser nulo'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End

	if @cod_carg < 0 -- para el caso de la paleta nueva del acondicionamiento.
	begin
		select @Cod_Fico = Cod_Fico, @Cod_Fiin = Cod_Fiin, @Cod_Fior = Cod_Fior, @Cod_Fiio = Cod_Fiio,   
		@Cod_Cont = Cod_Cont, @Ubi_Alma = Ubi_Alma, @Ing_Nept = Ing_Nept, @Cod_Prod = Cod_Prod  
		from cargas where cod_carg = @cod_carg*(-1) --and lpn=@LPN   
	  
		insert Cargas(Can_Carg, Lar_Carg, Anc_Carg, Alt_Carg, marca, Pes_Carg, cod_tica, Est_Carg, lpn,   
		Cod_Fico, Cod_Fiin, Cod_Fior, Cod_Fiio, Cod_Cont, Ubi_Alma, Ing_Nept, Cod_Prod, usuario_modificacion, fecha_modificacion)   
		values (@NumeroBulto, @Largo, @Ancho, @Alto, @Marcas, @Peso, @Cod_tica, @Estado, @LPN,  
		@Cod_Fico, @Cod_Fiin, @Cod_Fior, @Cod_Fiio, @Cod_Cont, @Ubi_Alma, @Ing_Nept, @Cod_Prod, @usuario, getdate())  
		
		SET @cod_carg = @@IDENTITY 
	end
     
     /* if isnull(@cod_carg, '') = ''   
     select @cod_carg = max(cod_carg) from Cargas*/  
   End   
--    set @Mensaje=''  
--    return @Mensaje  
   select @cod_carg  
  End -- Fin NumeroBulto > 0  
  Else  
  Begin  
   -- borramos el registro porque la cantidad es cero  
   delete from Cargas where cod_carg = @cod_carg --and lpn=@LPN and cod_tica=@Cod_tica  
   if @@RowCount = 0  
   Begin  
    Set @Mensaje = 'Error al hacer el acondicionamiento, el codigo de carga (PDA FWD) no es valido o no existe'  
    RAISERROR (@Mensaje, 16, 1)    
    return   
   End   
   select @cod_carg  
  End  
 End -- Fin de acondicionamiento  
END  
  
 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Int2_Int001_TARJA_MODIFICADETALLE_FORWARDERS_2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Int2_Int001_TARJA_MODIFICADETALLE_FORWARDERS_2]   
@TipoModificacion char(1), --Para indicar que modificacion se va a realizar: 1-->Modificacion / 2-->Desdoble / 3-->Acondicionamiento  
@LPN varchar(18),    
@TipoBulto varchar(3), -- (CTN, VEH, BLD,...)    
@NumeroBulto int,    
@Peso decimal(9,3),    
@Marcas varchar(100),    
@Estado char(1),  
@Largo decimal(9,3),    
@Ancho decimal(9,3),    
@Alto decimal(9,3),    
@Observacion varchar(80),  
@cod_carg int,  
@Usuario varchar(25)  
AS  
declare @Volumen float  
declare @Mensaje varchar(500)    
declare @cod_tica tinyint, @Cod_Fico int, @Cod_Fiin int, @Cod_Fior int, @Cod_Fiio int  
declare @Cod_Cont varchar(11), @Ubi_Alma varchar(10), @Ing_Nept varchar(1), @Cod_Prod varchar(5)  
declare @Existe integer  
  
BEGIN  
 select @Cod_tica=cod_tica from Tipo_Carga where Cod_bulto=@TipoBulto  
  
 select @Cod_Fico = Cod_Fico, @Cod_Fiin = Cod_Fiin, @Cod_Fior = Cod_Fior, @Cod_Fiio = Cod_Fiio,   
 @Cod_Cont = Cod_Cont, @Ubi_Alma = Ubi_Alma, @Ing_Nept = Ing_Nept, @Cod_Prod = Cod_Prod  
 from cargas where cod_tica=@Cod_tica --and lpn=@LPN   
  
 --Modificar LPN  
 if @TipoModificacion='1'  
 Begin  
  update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,   
  Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
  where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN  
  
  if @@RowCount = 0   
  Begin  
   Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
   RAISERROR (@Mensaje, 16, 1)    
   return   
  End   
  
  select @cod_carg  
 End -- fin modificacion  
  
   --Desdoble LPN   
 if @TipoModificacion='2'  
 Begin  
--  declare @Existe integer  
  select @Existe=count(*) from Cargas where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN   
  If @Existe > 0   
  Begin  
   if @NumeroBulto > 0 --and @Peso > 0  
   Begin  
    update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,    
    Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
    where cod_carg = @cod_carg --and lpn=@LPN  and cod_tica=@Cod_tica  
 --   set @Mensaje=''  
 --   return @Mensaje  
    select @cod_carg  
   end  
   else  
   begin  
    delete from Cargas where cod_carg = @cod_carg --and lpn=@LPN and cod_tica=@Cod_tica  
    select @cod_carg  
   end  
  End  
  Else  
  Begin  
   if @NumeroBulto > 0 --and @Peso > 0  
   Begin  
    if not (@cod_carg is null)-- Si no existe y es diferente de nulo o blanco error por descuadre  
    Begin  
     Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End   
  
    insert Cargas(Can_Carg, Lar_Carg, Anc_Carg, Alt_Carg, marca, Pes_Carg, cod_tica, Est_Carg, lpn,Cod_Fico,   
    Cod_Fiin, Cod_Fior, Cod_Fiio, Cod_Cont, Ubi_Alma, Ing_Nept, Cod_Prod, usuario_modificacion, fecha_modificacion)   
    values (@NumeroBulto, @Largo, @Ancho, @Alto, @Marcas, @Peso, @Cod_tica, @Estado, @LPN,  
    @Cod_Fico, @Cod_Fiin, @Cod_Fior, @Cod_Fiio, @Cod_Cont, @Ubi_Alma, @Ing_Nept, @Cod_Prod, @usuario, getdate())  
--    set @Mensaje=''  
--    return @Mensaje  
    SET @cod_carg = @@IDENTITY  
    /* if isnull(@cod_carg, '') = ''   
    select @cod_carg = max(cod_carg) from Cargas*/  
    select @cod_carg  
   End  
   Else  
   Begin  
    Set @Mensaje = 'La cantidad de bultos y/o peso no deben ser 0.'  
    RAISERROR (@Mensaje, 16, 1)    
    return   
   End  
  End  
 End -- Fin desdoble   
  
   --Acondicionamiento LPN  
 if @TipoModificacion='3'  
 Begin  
  if @NumeroBulto > 0  
  Begin        
   if not(@cod_carg is null) -- si el registro es nuevo por deferentes tipo de bulto  
   begin  
    --declare @Existe integer  
    select @Existe=count(*) from Cargas where cod_carg = @cod_carg --and cod_tica=@Cod_tica and lpn=@LPN   
    If @Existe = 0   
    Begin  
     Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
     RAISERROR (@Mensaje, 16, 1)    
     return   
    End   
     
    update Cargas set Can_Carg=@NumeroBulto, Lar_Carg=@Largo, Anc_Carg=@Ancho, Alt_Carg=@Alto, marca=@Marcas,    
    Pes_Carg=@Peso, cod_tica=@Cod_tica, Est_Carg = @Estado, usuario_modificacion = @usuario, fecha_modificacion = getdate()  
    where cod_carg = @cod_carg --and lpn=@LPN  and cod_tica=@Cod_tica  
   end  
   else -- Si es nulo para los nuevos registros  
   Begin  
    insert Cargas(Can_Carg, Lar_Carg, Anc_Carg, Alt_Carg, marca, Pes_Carg, cod_tica, Est_Carg, lpn,   
    Cod_Fico, Cod_Fiin, Cod_Fior, Cod_Fiio, Cod_Cont, Ubi_Alma, Ing_Nept, Cod_Prod, usuario_modificacion, fecha_modificacion)   
    values (@NumeroBulto, @Largo, @Ancho, @Alto, @Marcas, @Peso, @Cod_tica, @Estado, @LPN,  
    @Cod_Fico, @Cod_Fiin, @Cod_Fior, @Cod_Fiio, @Cod_Cont, @Ubi_Alma, @Ing_Nept, @Cod_Prod, @usuario, getdate())  
    SET @cod_carg = @@IDENTITY  
     /* if isnull(@cod_carg, '') = ''   
     select @cod_carg = max(cod_carg) from Cargas*/  
   End   
--    set @Mensaje=''  
--    return @Mensaje  
   select @cod_carg  
  End -- Fin NumeroBulto > 0  
  Else  
  Begin  
   -- borramos el registro porque la cantidad es cero  
   delete from Cargas where cod_carg = @cod_carg --and lpn=@LPN and cod_tica=@Cod_tica  
   if @@RowCount = 0  
   Begin  
    Set @Mensaje = 'Error al hacer el desdoble, el codigo de carga (PDA FWD) no es valido o no existe'  
    RAISERROR (@Mensaje, 16, 1)    
    return   
   End   
   select @cod_carg  
  End  
 End -- Fin de acondicionamiento  
END  
  
 
GO
/****** Object:  StoredProcedure [dbo].[SP_INT2_INT001_TarjaEnvioCab]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
  
    --36 TARJA EXPO
    
  
ALTER PROCEDURE [dbo].[SP_INT2_INT001_TarjaEnvioCab]                  
(@pCod_Fiin integer)                    
AS                  
BEGIN                  
SELECT FI.Cod_Fiin, FI.Cod_Fico, FI.codnav08 AS Nave,  FI.navvia11,FI.nro_book as NroBooking,FI.Aut_IngR as Aut_Ingr --, BOOK.codarm10 AS Linea, AUTING.CODCON14 AS NroCtr, BOOK.genbkg13 AS BookingInterno,                   
/*BOOK.bookin13 AS NroBooking*/, FI.Cod_Emba AS Embarcador--, AUTING.CODAGE19 AS Agente,BOOK.cod_producto AS Producto,                   
/*BOOK.cod_subproducto AS Subproducto, AUTING.codemb06 AS TipoBulto, CONT.PESBRT04 AS PesoCtr*/, SUM(C.Can_Carg) as NroBultos,                  
0 as BultosCtr, GETDATE() as FechaLlenado,                  
'' as Observacion,              
--(case FUMI.FLGFUM17 when '1' then FUMI.PROFUM17 else '' end) as ProductoFumigated,                  
'0' as TipoLlenado,                
'1' as Via,                
 --BOOK.sucursal as Sucursal,                  
ISNULL(FI.vch_TipoRegimen, 'N') AS Regimen                  
FROM ficha_ingreso FI                   
--INNER JOIN Descarga.dbo.DDCABMAN11 TD11 ON (FI.navvia11 = TD11.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS)                  
--INNER JOIN Descarga.dbo.EDBOOKIN13 BOOK  ON (FI.nro_book = BOOK.bookin13 COLLATE SQL_Latin1_General_CP1_CI_AS AND FI.navvia11 = BOOK.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS)                  
--INNER JOIN Descarga.dbo.EDAUTING14 AUTING ON (FI.Aut_IngR COLLATE SQL_Latin1_General_CP1_CI_AS = AUTING.NROAUT14 AND BOOK.genbkg13 = AUTING.genbkg13)                  
--INNER JOIN Descarga.dbo.EDCONTEN04 CONT ON CONT.CODCON04 = AUTING.CODCON14                  
--INNER JOIN Descarga.dbo.ERCONASI17 FUMI ON BOOK.genbkg13 = FUMI.genbkg13                  
INNER JOIN Cargas C (NOLOCK) ON FI.Cod_Fiin = C.Cod_Fiin AND FI.Cod_Fico = C.Cod_Fico AND FI.Cod_Fiin = @pCod_Fiin                  
                
GROUP BY                  
FI.Cod_Fiin, FI.Cod_Fico,FI.codnav08, FI.navvia11,FI.nro_book,FI.Aut_IngR --, BOOK.codarm10, AUTING.CODCON14, BOOK.genbkg13,                   
/*BOOK.bookin13*/, FI.Cod_Emba, /*AUTING.CODAGE19,BOOK.cod_producto, BOOK.cod_subproducto, AUTING.codemb06 ,                   
CONT.PESBRT04, FUMI.FLGFUM17, FUMI.PROFUM17,  BOOK.sucursal,*/ FI.vch_TipoRegimen                  
END 



GO
/****** Object:  StoredProcedure [dbo].[SP_INT2_INT002_EnvioInformacionTarjaEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  


    --37 TARJA EXPO
    
    
ALTER PROCEDURE [dbo].[SP_INT2_INT002_EnvioInformacionTarjaEXPO]  
AS  
BEGIN   
  
SELECT FI.Cod_Fiin,FI.Cod_Fico,FI.Fec_Fiin,FI.Gui_Remi,FI.Usu_Crea,  
  FI.Cod_Emba,FI.Des_Carg,FI.Pla_Vehi,FI.Emb_Nore,FI.Aut_Ingr,  
  FI.Est_Fiin,FI.Tip_Fiin,FI.navvia11,FI.codnav08,FI.nro_book,  
  FI.navvia11_old,FI.transferido,FI.enviado,FI.vch_TipoRegimen    
FROM FICHA_INGRESO FI  
  
  
SELECT C.Cod_Carg,C.Cod_Fico,C.Cod_Fiin,C.Po_Carg,C.Sty_Carg,C.Can_Carg,  
  C.Pes_Carg,C.Alt_Carg,C.Anc_Carg,C.Lar_Carg,C.Cod_Tica,Tc.Des_Tica ,C.Des_Carg,  
  C.Cod_Fior,C.Cod_Fiio,C.Cod_Cont,C.Ubi_Alma,C.Est_Carg,C.Ing_Nept,  
  C.Cod_Prod,C.Flg_Impr,C.ubi_conte,C.marca,C.lpn    
FROM CARGAS C  
INNER JOIN TIPO_CARGA TC ON (TC.Cod_Tica = C.Cod_Tica)  
  
END 



GO
/****** Object:  StoredProcedure [dbo].[SP_INT2_INT002_TarjaEnvioCab]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  --38 TARJA EXPO
  
  
ALTER PROCEDURE [dbo].[SP_INT2_INT002_TarjaEnvioCab]      
(@pCod_Fiin integer)      
AS      
BEGIN      
select FI.Cod_Fiin, FI.nro_book, NULL Contenedor, FI.Cod_Fico,  
FI.navvia11 , FI.codnav08 , FI.Fec_Fiin, AC.NOMBRE AS Nom_Cons , FI.Aut_Ingr /*ticket de ingreso*/      
FROM ficha_ingreso FI      
INNER JOIN Ficha_Consolidacion FC ON (FI.Cod_Fico = FC.Cod_Fico)      
INNER JOIN Terminal.dbo.AACONSOL02 AC ON (FC.Cod_Cons = AC.CONTRIBUY COLLATE Modern_Spanish_CI_AS)      
WHERE FI.Cod_Fiin = @pCod_Fiin      
      
END 


GO
/****** Object:  StoredProcedure [dbo].[SP_INT2_INT002_TarjaEnvioDet]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  --39 TARJA EXPO

--[SP_INT2_INT002_TarjaEnvioDet] 1      
      
ALTER PROCEDURE [dbo].[SP_INT2_INT002_TarjaEnvioDet]      
      
(@pCod_Fiin integer)      
      
AS      
      
BEGIN      
      
select C.Cod_Carg, C.Cod_Tica ,C.Can_Carg, C.Pes_Carg , C.marca , C.lpn, C.Po_Carg, C.Sty_Carg,      
      
C.Lar_Carg, C.Anc_Carg, C.Alt_Carg , C.Est_Carg  , TC.Cod_Bulto    
      
FROM Cargas C      
INNER JOIN Tipo_Carga TC ON C.Cod_Tica = TC.Cod_Tica    
      
WHERE Cod_Fiin = @pCod_Fiin      
      
END 


GO
/****** Object:  StoredProcedure [dbo].[sp_IntN4_ActualizarFicha]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_IntN4_ActualizarFicha] @GENBKG VARCHAR(6)
	,@CODEMB VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @codfico int
	,@booking varchar(30)

	select
		@codfico = c.Cod_Fico,
		@booking = a.bookin13
	from
		descarga.dbo.edbookin13 a,
		descarga.dbo.edauting14 b,
		Ficha_Ingreso c
	where a.genbkg13 = @GENBKG
		and a.genbkg13 = b.genbkg13
		and b.nroaut14 = c.aut_ingr collate SQL_Latin1_General_CP1_CI_AS
		and c.nro_book = a.bookin13

	update Embarcadores
		set Cod_Emba = @CODEMB
	where nro_book = @booking
		and Cod_Fico = @codfico

	UPDATE Ficha_Ingreso
	SET Cod_Emba = @CODEMB
	FROM Ficha_Ingreso a
	INNER JOIN Descarga.dbo.EDAUTING14 b ON b.nroaut14 collate Modern_Spanish_CI_AS = a.Aut_Ingr
	WHERE b.genbkg13 = @GENBKG

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_Booking]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_Booking]
(
      @Cod_Fico int,
      @Cod_Emba varchar(11),
      @Nro_Book varchar(6),
      @Nro_Book_Old varchar(6)
)
As
BEGIN

	--Se verifica que el booking nuevo sea correcto
	DECLARE
		@Cod_Pue CHAR(3),
		@Cod_EmbaB varchar(11)

	SELECT @Cod_Pue = Cod_Pue FROM Ficha_Consolidacion (NOLOCK) WHERE Cod_Fico = @Cod_Fico

	SELECT @Cod_EmbaB = codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue

	IF NOT EXISTS(SELECT codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue AND codemc12 = @Cod_Emba)
		BEGIN
			SELECT 1 AS error, 'El Booking seleccionado no corresponde con el puerto o con el Embarcador' AS mensaje
		RETURN
	END

	--Se actualiza el booking de la tabla embarcador y la tabla ficha de ingreso
	UPDATE
		Embarcadores
	SET
		Nro_Book = @Nro_Book
	WHERE
		cod_fico = @Cod_Fico
		and cod_emba = @Cod_Emba
		and Nro_Book = @Nro_Book_Old

	UPDATE
		Ficha_Ingreso
	SET
		nro_book = @Nro_Book
	WHERE
		Cod_Fico = @Cod_Fico
		AND Cod_Emba = @Cod_Emba
		AND Nro_Book = @Nro_Book_Old

	--Se actualiza el navvia y el codnave que pudieron haber cambiado
	update
		Ficha_Ingreso
	set
		navvia11 = b.navvia11
	from
		Ficha_Ingreso a
		inner join descarga.dbo.edauting14 b on a.Aut_Ingr = b.nroaut14 collate SQL_Latin1_General_CP1_CI_AS
	where
		a.Cod_Fico = @Cod_Fico
		and a.navvia11 <> b.navvia11  collate SQL_Latin1_General_CP1_CI_AS
		and a.navvia11 is not null

	update
		Ficha_Ingreso
	set
		codnav08 = b.codnav08
	from
		Ficha_Ingreso a
		inner join terminal..ddcabman11 b on a.navvia11 = b.navvia11 collate SQL_Latin1_General_CP1_CI_AS
	where
		a.Cod_Fico = @Cod_Fico
		and a.codnav08 <> b.codnav08 collate SQL_Latin1_General_CP1_CI_AS

	update
		Ficha_Consolidacion
	set
		navvia11 = b.navvia11
	from
		Ficha_Consolidacion a
		inner join Ficha_Ingreso b on a.Cod_Fico = b.Cod_Fico
	where
		a.Cod_Fico = @Cod_Fico
		and isnull(a.navvia11,'') <> isnull(b.navvia11,'') collate SQL_Latin1_General_CP1_CI_AS
		and b.navvia11 is not null

	SELECT 0 as error, '' as mensaje

END



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_Carga]
@Cod_Carg int,
@Po_Carg varchar(10),
@Sty_Carg varchar(10),
@Can_Carg smallint,
@Pes_Carg decimal(9,2),
@Alt_Carg decimal(9,2),
@Anc_Carg decimal(9,2),
@Lar_Carg decimal(9,2),
@Cod_Tica tinyint,
@Des_Carg varchar(50),
@Ubi_alma varchar(10),
@Est_Carg char(1),
@Ing_Nept char(1),
@Cod_Prod varchar(5),
@Marca varchar(50)

AS

update Cargas
set Po_Carg=@Po_Carg,Sty_carg=@Sty_Carg,Can_Carg=@Can_Carg,Pes_Carg=@Pes_Carg,Alt_Carg=@Alt_Carg,Anc_Carg=@Anc_Carg,Lar_Carg=@Lar_Carg,Cod_Tica=@Cod_Tica,Des_Carg=@Des_Carg, Ubi_Alma=@Ubi_Alma, Est_Carg=@Est_Carg, Ing_Nept=@Ing_Nept,Cod_prod=@Cod_prod,Marca=@Marca
where Cod_Carg=@Cod_Carg



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_CargaEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Procedimientos Forwarder    
--Procedimientos nuevos que se han reutilizado ------    
--PROCEDIMIENTO TARJAEXPO Nª 5        
/*Modificacion: Mes    
Se agrego parametro de entrada @Lpn a procedimiento almacenado    
*/
ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_CargaEXPO] @Cod_Carg INT
	,@Po_Carg VARCHAR(10)
	,@Sty_Carg VARCHAR(10)
	,@Can_Carg SMALLINT
	,@Pes_Carg DECIMAL(9, 2)
	,@Alt_Carg DECIMAL(9, 2)
	,@Anc_Carg DECIMAL(9, 2)
	,@Lar_Carg DECIMAL(9, 2)
	,@Cod_Tica TINYINT
	,@Des_Carg VARCHAR(50)
	,@Ubi_alma VARCHAR(10)
	,@Est_Carg CHAR(1)
	,@Ing_Nept CHAR(1)
	,@Cod_Prod VARCHAR(5)
	,@Marca VARCHAR(50)
	,@Lpn VARCHAR(50)
AS
--//enviar correo si se modifica la tarja
EXEC USP_SEND_MAIL_MODIFICACION_TARJA_PDA @Lpn,@Can_Carg,@Pes_Carg,@Lar_Carg,@Anc_Carg,@Alt_Carg,@Cod_Carg
--//

UPDATE Cargas
SET Po_Carg = @Po_Carg
	,Sty_carg = @Sty_Carg
	,Can_Carg = @Can_Carg
	,Pes_Carg = @Pes_Carg
	,Alt_Carg = @Alt_Carg
	,Anc_Carg = @Anc_Carg
	,Lar_Carg = @Lar_Carg
	,Cod_Tica = @Cod_Tica
	,Des_Carg = @Des_Carg
	,Ubi_Alma = @Ubi_Alma
	,Est_Carg = @Est_Carg
	,Ing_Nept = @Ing_Nept
	,Cod_prod = @Cod_prod
	,Marca = @Marca
	,lpn = @Lpn
WHERE Cod_Carg = @Cod_Carg


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_Contenedor]
@Cod_Fico int,
@Cod_Alma int,
@Cod_Cont varchar(11),
@Cod_Tipo varchar(2),
@Cod_Tama varchar(2),
@payload decimal(5, 3),
@Precinto varchar(20)
AS

Update Contenedores
set Cod_alma=@Cod_Alma,Cod_Tipo=@Cod_Tipo,Cod_Tama=@Cod_Tama, payload = @payload, precinto = @precinto
where Cod_Cont=@Cod_Cont and Cod_Fico=@Cod_Fico


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_Fiin] @Cod_Fiin INT  
 ,@Gui_Remi VARCHAR(20)  
 ,@Usu_Crea VARCHAR(20)  
 ,@Cod_Emba VARCHAR(11)  
 ,@Pla_Vehi VARCHAR(7)  
 ,@Emb_Nore VARCHAR(11)  
 ,@Aut_Ingr VARCHAR(8)  
 ,@Nro_Book VARCHAR(6)  
AS  
INSERT INTO forwarderAuditoria (Cod_Fiin,Gui_Remi,Usu_Crea,Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Nro_Book,TipoRegimen,FECHA)  
SELECT Cod_Fiin,Gui_Remi,Usu_Crea,Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Nro_Book,vch_TipoRegimen,GETDATE() FROM Ficha_Ingreso WHERE Cod_Fiin = @Cod_fiin  
  /*
UPDATE Ficha_Ingreso  
SET Gui_Remi = @Gui_Remi  
 ,Usu_Crea = @Usu_Crea  
 ,Cod_Emba = @Cod_Emba  
 ,Pla_Vehi = @Pla_Vehi  
 ,Emb_Nore = @Emb_Nore  
 ,Aut_Ingr = @Aut_Ingr  
 ,Nro_Book = @Nro_Book  
WHERE Cod_Fiin = @Cod_fiin
*/
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Actualizar_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 6     
/*    
Modificacion: Miguel E:     
Accion:  Se agrego campo a tabla ficha de ingreso y se agrego @tipoRegimen al Sp    
para su registro.    
*/  
ALTER PROCEDURE [dbo].[Sp_Sf_Actualizar_FiinEXPO] (  
 @Cod_Fiin INT  
 ,@Gui_Remi VARCHAR(20)  
 ,@Usu_Crea VARCHAR(20)  
 ,@Cod_Emba VARCHAR(11)  
 ,@Pla_Vehi VARCHAR(7)  
 ,@Emb_Nore VARCHAR(11)  
 ,@Aut_Ingr VARCHAR(8)  
 ,@Nro_Book VARCHAR(6)  
 ,@TipoRegimen VARCHAR(15)  
 )  
AS  
  
INSERT INTO forwarderAuditoria (Cod_Fiin,Gui_Remi,Usu_Crea,Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Nro_Book,TipoRegimen,FECHA)  
SELECT Cod_Fiin,Gui_Remi,Usu_Crea,Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Nro_Book,vch_TipoRegimen,GETDATE() FROM Ficha_Ingreso WHERE Cod_Fiin = @Cod_fiin  

/*UPDATE Ficha_Ingreso  
SET Gui_Remi = @Gui_Remi  
 ,Usu_Crea = @Usu_Crea  
 ,Cod_Emba = @Cod_Emba  
 ,Pla_Vehi = @Pla_Vehi  
 ,Emb_Nore = @Emb_Nore  
 ,Aut_Ingr = @Aut_Ingr  
 ,Nro_Book = @Nro_Book  
 ,vch_TipoRegimen = @TipoRegimen  
WHERE Cod_Fiin = @Cod_fiin  
*/
  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Agregar_Carga_Simulacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Agregar_Carga_Simulacion]
@Cod_Fico int,
@Nom_Usua varchar(20),
@cod_Carg int
AS

Insert Simulacion1(Cod_Fico,Nom_Usua,Cod_Carg)
values(@Cod_Fico,@Nom_Usua,@Cod_Carg)

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Agregar_Carga_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Agregar_Carga_Simulacion2]
@Cod_Sim2 int,
@cod_Carg int
AS

Insert Detalle_Simulacion2(Cod_Sim2,Cod_Carg)
values(@Cod_Sim2,@Cod_Carg)

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Agregar_Contenedor_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Agregar_Contenedor_Simulacion2]
@Cod_Fico int,
@Nom_usua varchar(20),
@Cod_Tama char(2),
@Cod_Tipo char(2)
AS

Insert Simulacion2(Cod_Fico,Nom_Usua,Cod_tama,Cod_Tipo)
values(@Cod_Fico,@Nom_Usua,@Cod_Tama,@Cod_tipo)

select @@identity

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Agregar_Detalle_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Agregar_Detalle_Carga]
@cod_Carg int
AS
-- 18/05/5009 dicaceres: Evitar que se creen mas detalles de carga que los necesarios,
-- para eso, el maximo numeor de detalles sera igual a la cantidad de la carga.
declare @newId INT, @cant1 INT, @cant2 INT

SELECT @cant1 = count(Cod_Corr) from Detalle_Carga where Cod_Carg = @cod_Carg

SELECT @cant2 = Can_Carg from Cargas where Cod_Carg = @cod_Carg

IF @cant1 < @cant2
	begin
		Insert Detalle_Carga(Cod_Carg)values(@Cod_Carg)

		select @@identity
	end
else
	begin
		select max(Cod_Corr) from Detalle_Carga where Cod_Carg = @cod_Carg
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Asignar_Carga_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Asignar_Carga_Contenedor] 
	@Cod_Carg INT
	,@Cod_Cont VARCHAR(11)
	,@Cod_Fico INT
	,@Ubi_Cont VARCHAR(11)
AS
--rdelacuba 07/08/2007: Considerar actualización de ubicación relativa  
UPDATE Cargas
SET Cod_Cont = @Cod_Cont
	,Ubi_Conte = @Ubi_Cont
WHERE Cod_Carg = @Cod_Carg
	AND Cod_Fico = @Cod_Fico

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_BuscaFichaConsolidacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_BuscaFichaConsolidacion]
(
      @Cod_Fico int,
      @Cod_Nave varchar(4),
      @Num_Viaje varchar(6)
)
AS
BEGIN

      DECLARE
            @Cod_Cons varchar(11),
            @cod_pue varchar(3),
            @navvia11 char(6)

      SELECT @Cod_Cons = Cod_Cons, @cod_pue = cod_pue FROM Ficha_Consolidacion WHERE Cod_Fico = @Cod_Fico

      SELECT @navvia11 = navvia11 FROM terminal..ddcabman11 WHERE codnav08 = @Cod_Nave and numvia11 = @Num_Viaje

      SELECT Cod_Fico FROM Ficha_Consolidacion where Cod_Cons = @Cod_Cons and cod_pue = @cod_pue and navvia11 = @navvia11

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Cerrar_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Cerrar_Contenedor] 
@Cod_Fico int,
@Cod_Cont varchar(11)
AS
update Contenedores set Est_Cont='C' 
where Cod_Cont=@Cod_cont and Cod_Fico=@Cod_Fico



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Cerrar_Fico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Cerrar_Fico] 
@Cod_Fico int
AS

update Ficha_Consolidacion set Est_Fico='C' 
where Cod_Fico=@Cod_Fico

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Cerrar_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Cerrar_Fiin]
@Cod_Fiin int
AS
update Ficha_Ingreso set Est_Fiin='C' 
where Cod_Fiin=@Cod_Fiin


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Cerrar_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 7        
ALTER PROCEDURE [dbo].[Sp_Sf_Cerrar_FiinEXPO] @Cod_Fiin INT
AS
BEGIN
	UPDATE Ficha_Ingreso
	SET Est_Fiin = 'C'
	WHERE Cod_Fiin = @Cod_Fiin

	EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_ASNEXPO @Cod_Fiin
		,'INT2.INT002'

	EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_EXPO @Cod_Fiin
		,'INT2.INT001'

	-------------      
	DECLARE @mensaje VARCHAR(max)
	DECLARE @Aut_Ingr VARCHAR(8)
	DECLARE @nro_book VARCHAR(6)

	SELECT @Aut_Ingr = Aut_Ingr
		,@nro_book = nro_book
	FROM Ficha_Ingreso
	WHERE Cod_Fiin = @Cod_Fiin

	DECLARE @valores VARCHAR(1000)

	SELECT @valores = COALESCE(@valores + ', ', '') + lpn
	FROM Cargas
	WHERE Cod_Fiin = @Cod_Fiin

	--select ltrim(rtrim(@valores)) as valores      
	SELECT @mensaje = '                                      
    <html>                                      
   <table>            
   <tbody>            
   <tr><td><span style="font-size: 9.0pt; color: gray;">Estimados se Finalizo la Tarja</span></td></tr>            
   <tr><td>&nbsp;</td></tr>            
   <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Se informa que la tarja para la autorizacion: ' + @Aut_Ingr + ' y numero booking ' + @nro_book + '</span></td></tr>              
   <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Con los siguientes LPNs registrados :' + @valores + ' ha finalizado</span></td></tr>            
   <tr><td>&nbsp;</td></tr>               
   </tbody>            
   </table>                            
    </html>'

	DECLARE @ASUNTO VARCHAR(100)

	SET @ASUNTO = 'Finalizacion de Tarja - Autorizacion: ' + @Aut_Ingr + ' - Booking: ' + @nro_book

	EXEC master.dbo.xp_smtp_sendmail @FROM = N'giancarlo.taipe@neptunia.com.pe'
		,@FROM_NAME = N'NEPTUNIA S.A'
		,@TO = N'auxiliaresfoexpo@neptunia.com.pe'
		--,@BCC = N''              
		,@BCC = N'giancarlo.taipe@neptunia.com.pe'
		,@priority = N'HIGH'
		,@subject = @ASUNTO
		,@message = @mensaje
		,@type = N'text/html'
		,@attachments = N''
		,@codepage = 0
		,@server = N'correo.neptunia.com.pe'
		-----------------------       
END

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Cerrar_FiinEXPO_N1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 7          
ALTER PROCEDURE [dbo].[Sp_Sf_Cerrar_FiinEXPO_N1] @Cod_Fiin INT  
AS  
BEGIN  
 UPDATE Ficha_Ingreso  
 SET Est_Fiin = 'C'  
 WHERE Cod_Fiin = @Cod_Fiin  
  
 EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_ASNEXPO @Cod_Fiin  
  ,'INT2.INT002'  
  
 EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_EXPO @Cod_Fiin  
  ,'INT2.INT001'  
  
 -------------        
 DECLARE @mensaje VARCHAR(max)  
 DECLARE @Aut_Ingr VARCHAR(8)  
 DECLARE @nro_book VARCHAR(6)  
  
 SELECT @Aut_Ingr = Aut_Ingr  
  ,@nro_book = nro_book  
 FROM Ficha_Ingreso  
 WHERE Cod_Fiin = @Cod_Fiin  
  
 DECLARE @valores VARCHAR(1000)  
  
 SELECT @valores = COALESCE(@valores + ', ', '') + lpn  
 FROM Cargas  
 WHERE Cod_Fiin = @Cod_Fiin  
  
 --select ltrim(rtrim(@valores)) as valores        
 SELECT @mensaje = '                                        
    <html>                                        
   <table>              
   <tbody>              
   <tr><td><span style="font-size: 9.0pt; color: gray;">Estimados se Finalizo la Tarja</span></td></tr>              
   <tr><td>&nbsp;</td></tr>              
   <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Se informa que la tarja para la autorizacion: ' + @Aut_Ingr + ' y numero booking ' + @nro_book + '</span></td></tr>                
   <tr><td style="padding: 0cm 5.4pt 0cm 5.4pt;"><span style="font-size: 9.0pt; color: gray;">Con los siguientes LPNs registrados :' + @valores + ' ha finalizado</span></td></tr>              
   <tr><td>&nbsp;</td></tr>                 
   </tbody>              
   </table>                              
    </html>'  
  
 DECLARE @ASUNTO VARCHAR(100)  
  
 SET @ASUNTO = 'Finalizacion de Tarja - Autorizacion: ' + @Aut_Ingr + ' - Booking: ' + @nro_book  
  
 EXEC master.dbo.xp_smtp_sendmail @FROM = N'giancarlo.taipe@neptunia.com.pe'  
  ,@FROM_NAME = N'NEPTUNIA S.A'  
  ,@TO = N'auxiliaresfoexpo@neptunia.com.pe'  
  --,@BCC = N''                
  ,@BCC = N'giancarlo.taipe@neptunia.com.pe'  
  ,@priority = N'HIGH'  
  ,@subject = @ASUNTO  
  ,@message = @mensaje  
  ,@type = N'text/html'  
  ,@attachments = N''  
  ,@codepage = 0  
  ,@server = N'correo.neptunia.com.pe'  
  -----------------------         

  SELECT '0' as Respuesta
END  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Consultar_Cargas_N1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Consultar_Cargas_N1]   
 @Cod_Fico INT  
 ,@NroAut varchar(8)  
AS  
begin  
 select   
 cast(b.Cod_Carg as varchar) as vch_CodigoCarga  
 ,cast(b.Can_Carg as varchar) as vch_Cantidad  
 ,isnull(c.Des_Tica, '') as vch_Tipo  
 ,cast(b.Lar_Carg as varchar) as vch_Lago  
 ,cast(b.Anc_Carg as varchar) as vch_Ancho  
 ,cast(b.Alt_Carg as varchar) as vch_Alto  
 ,cast(b.Pes_Carg as varchar) as vch_Peso  
 ,b.marca as vch_Marca  
 ,vch_Estado = case when b.Est_Carg = 'B' then 'OK' else 'DAÑADO' end   
 ,b.lpn as vch_Lpn  
 from Ficha_Ingreso a (nolock)  
 inner join Cargas b (nolock) on a.Cod_Fico = b.Cod_Fico and a.Cod_Fiin = b.Cod_Fiin  
 left join Tipo_Carga c on  b.Cod_Tica = c.Cod_Tica  
 where a.Aut_Ingr = @NroAut  
 and a.Cod_Fico = @Cod_Fico  
 order by b.fecha_modificacion desc  
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Consultar_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Sp_Sf_Consultar_FiinEXPO '',122645
ALTER PROCEDURE [dbo].[Sp_Sf_Consultar_FiinEXPO]
@Nroaut varchar(8)
as
begin
	select distinct
	b.nropla81 as vch_Placa
	,g.NOMBRE as vch_Consolidador
	,h.desnav08 as vch_Nave
	,f.numvia11 as vch_Viaje
	,c.bookin13 as vch_Booking
	,e.NOMBRE as vch_Embarcador
	from descarga.dbo.edauting14 b
	inner join descarga.dbo.EDBOOKIN13 c on b.genbkg13 collate Modern_Spanish_CI_AS = c.genbkg13 collate Modern_Spanish_CI_AS
	left join terminal..AACLIENTESAA g on g.CONTRIBUY = c.ruccli13
	left join terminal..AACLIENTESAA e on e.CONTRIBUY = c.codemc12
	inner join terminal..DDCABMAN11 f on f.navvia11 = c.navvia11
	inner join terminal..DQNAVIER08 h on h.codnav08 = f.codnav08 
	where b.nroaut14 = @Nroaut
end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Consultar_FiinEXPO_WEB_EXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Consultar_FiinEXPO_WEB_EXPO] -- '00393417'
   @Nroaut VARCHAR(8)
AS
BEGIN
	SELECT DISTINCT b.nropla81 AS vch_Placa
		,g.NOMBRE AS vch_Consolidador
		,h.desnav08 AS vch_Nave
		,f.numvia11 AS vch_Viaje
		,c.bookin13 AS vch_Booking
		,e.NOMBRE AS vch_Embarcador
		,i.vch_TipoRegimen AS vch_Regimen
		,convert(varchar(10),i.Cod_Fiin) as vch_FichaIngreso
	FROM descarga.dbo.edauting14 b
	INNER JOIN descarga.dbo.EDBOOKIN13 c ON b.genbkg13 collate Modern_Spanish_CI_AS = c.genbkg13 collate Modern_Spanish_CI_AS
	LEFT JOIN terminal..AACLIENTESAA g ON g.CONTRIBUY = c.ruccli13
	LEFT JOIN terminal..AACLIENTESAA e ON e.CONTRIBUY = c.codemc12
	INNER JOIN terminal..DDCABMAN11 f ON f.navvia11 = c.navvia11
	INNER JOIN terminal..DQNAVIER08 h ON h.codnav08 = f.codnav08
	LEFT JOIN Ficha_Ingreso i ON b.nroaut14 collate Modern_Spanish_CI_AS = i.Aut_Ingr collate Modern_Spanish_CI_AS
	   and i.Est_Fiin='A'
	WHERE b.nroaut14 = @Nroaut --'00393417' -- '00000019'
    
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Correo_Cliente]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Correo_Cliente] 
@Contribuy varchar(11)
AS
select Email  from terminal..aaclientesaa where contribuy=@contribuy

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Booking_x_Embarcador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Booking_x_Embarcador]
@Cod_Fico int,
@Cod_Emba char(11)
AS
select Nro_Book from Sf_V_Embarcadores where Cod_Fico = @Cod_Fico and Cod_Emba = @Cod_Emba


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Booking_x_EmbarcadorEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--PROCEDIMIENTO TARJAEXPO Nª 8    
    
--se comento la  condicion hasta validar  
    
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Booking_x_EmbarcadorEXPO]    
@Cod_Fico int,    
@Cod_Emba varchar(50)    
AS    
--Identificador TARJA | : Trae solo Hijos --    
declare @Hijos int    
set @Hijos= CHARINDEX('|',@Cod_Emba)    
set @Cod_Emba= REPLACE(@Cod_Emba,'|','')    
    
select Nro_Book from Sf_V_Embarcadores where Cod_Fico = @Cod_Fico and Cod_Emba = @Cod_Emba     
--and Book_Madre = (CASE WHEN @Hijos>0 THEN 0 ELSE Book_Madre END)    
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Can_Fico_Abiertas]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Can_Fico_Abiertas]
@Cod_Cons varchar(11), @cod_Pue varchar(3)
AS
--rdelacuba 16/07/2007: Filtrar por estado
select * from Ficha_Consolidacion 
where Cod_Cons =@Cod_Cons and isnull(Cod_Pue,'') = @cod_Pue and Est_Fico = 'A' 
-- 27/03/2009 requerimiento HBendezu, crear fichas para diferentes naves a u mismo puertos
and navvia11 is null



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga]
@Cod_Fiin int
AS
select * from Sf_V_Cargas where Cod_Fiin=@Cod_Fiin

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Asignada]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Asignada]
@Cod_Fico int
AS
select * from sf_v_cargas where Cod_Fico=@Cod_fico

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Asignada_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Asignada_Contenedor]
@Cod_Fico int,
@Cod_Cont varchar(11)
AS
select * from sf_v_cargas where Cod_Fico=@Cod_fico and Cod_Cont=@Cod_Cont

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Pendiente]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Pendiente] 
@Cod_Fico int

AS
select * from sf_v_cargas where Cod_Fico=@Cod_fico and isnull(Cod_Cont,'x')='x'

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Pendiente_Transf]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Pendiente_Transf]  
-- dicaceres 08/04/2009: se obtiene la carga de todas las ochas de consolidacion  
--@Cod_Fico int  
(  
 @Cod_Cons varchar(11),  
 @cod_pue varchar(3)  
)  
AS  
BEGIN  
  
--select * from sf_v_cargas_transf where Cod_Fico=@Cod_fico and isnull(Cod_Cont,'x')='x'  
  
 select distinct  
  c.*  
 from  
  sf_v_cargas_transf c  
  inner join Sf_V_Ficha_Consolidacion f on c.Cod_Fico = f.Cod_Fico  
 where  
  f.Est_Fico ='A' and f.cod_pue = @cod_pue and f.Cod_Cons=@Cod_Cons  
  and isnull(c.Cod_Cont,'x')='x'
  order by c.nro_book asc   
  
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Por_Imprimir]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Por_Imprimir]
AS
select * from Sf_V_Cargas_Imprimir where Flg_Impr=0 and Est_Fiin='C'
order by Cod_Fiin



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Simulacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Simulacion]
@Cod_Fico int,
@Nom_Usua varchar(20)
AS
select * from sf_v_cargas where Cod_Fico=@Cod_fico
select * from simulacion1 where Cod_Fico=@Cod_Fico and Nom_Usua=@Nom_Usua

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Carga_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Carga_Simulacion2]
@Cod_Fico int,
@Nom_Usua varchar(20)
AS
--Cabecera de Simulacion...
select * from sf_v_simulacion2 where Cod_Fico=@Cod_Fico and Nom_Usua=@Nom_Usua
order by cod_sim2
-- Carga de la ficha de consolidación
select * from sf_v_cargas where Cod_Fico=@Cod_fico
-- Detalle de la Simulacion..Carga...
select * from Sf_v_Detalle_Simulacion2 where Cod_Fico=@Cod_Fico and Nom_Usua=@Nom_Usua
order by Cod_Sim2

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Contenedores_Fico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Contenedores_Fico]
@Cod_Fico varchar(11)
AS
select * from Sf_V_Contenedores  where Cod_Fico=@Cod_Fico

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_Dato_Embarcador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_sf_Dev_Dato_Embarcador]
@Cod_Fico int,
@Cod_Emba varchar(11),
@Nro_book varchar(6)
AS

 select * from Sf_V_Embarcadores where Cod_Fico=@Cod_Fico and Cod_Emba=@Cod_Emba and Nro_Book = @Nro_book


GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_Datos_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_dev_Datos_Fiin] (@Cod_Fiin INT)
AS
BEGIN
	-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta    
	--select * from Sf_V_Ficha_Ingreso where Cod_Fiin = @Cod_Fiin    
	DECLARE @numvia11 VARCHAR(50)
		,@desnav08 VARCHAR(50)
		,@navvia11 CHAR(6)
		,@codnav08 CHAR(4)

	SELECT @navvia11 = navvia11
		,@codnav08 = codnav08
	FROM Ficha_Ingreso
	WHERE Cod_Fiin = @Cod_Fiin

	SELECT TOP 1 @numvia11 = numvia11
	FROM descarga.dbo.ddcabman11
	WHERE navvia11 = @navvia11

	SELECT TOP 1 @desnav08 = desnav08
	FROM descarga.dbo.dqnavier08
	WHERE codnav08 = @codnav08

	SELECT dbo.Ficha_Ingreso.Cod_Fiin
		,dbo.Ficha_Ingreso.Cod_Fico
		,z.fecaut14 AS Fec_Fiin
		,dbo.Ficha_Ingreso.Gui_Remi
		,dbo.Ficha_Ingreso.Usu_Crea
		,dbo.Ficha_Ingreso.Cod_Emba
		,dbo.Ficha_Ingreso.Des_Carg
		,dbo.Ficha_Ingreso.Pla_Vehi
		,AACLIENTESAA_2.NOMBRE AS Nom_Emba
		,dbo.Ficha_Ingreso.Emb_Nore
		,AACLIENTESAA_1.NOMBRE AS Nom_Nore
		,dbo.Ficha_Ingreso.Aut_Ingr
		,dbo.Ficha_Ingreso.Est_Fiin
		,dbo.Ficha_Ingreso.navvia11
		,@numvia11 AS numvia11
		,--v.numvia11,    
		dbo.Ficha_Ingreso.codnav08
		,@desnav08 AS desnav08
		,--n.desnav08,    
		/*dbo.Ficha_Ingreso.Nro_Book*/
		-- Nro_Book = dbo.Ficha_Ingreso.Nro_Book + '-' + isnull((Select bkgcom13 from descarga.dbo.edbookin13 WITH(NOLOCK) where bookin13 COLLATE MODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.Nro_Book COLLATE MODERN_SPANISH_CI_AS  and navvia11 COLLATE MODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.navvia11 COLLATE MODERN_SPANISH_CI_AS and len(bkgcom13)>0 ),'')  
		--Nro_Book = isnull((
		--		SELECT TOP 1 bkgcom13
		--		FROM descarga.dbo.edbookin13 WITH (NOLOCK)
		--		WHERE bookin13 COLLATE MODERN_SPANISH_CI_AS = dbo.Ficha_Ingreso.Nro_Book COLLATE MODERN_SPANISH_CI_AS
		--			AND navvia11 COLLATE MODERN_SPANISH_CI_AS = dbo.Ficha_Ingreso.navvia11 COLLATE MODERN_SPANISH_CI_AS
		--			AND len(bkgcom13) > 0
		--		ORDER BY fecusu00 DESC
		--		), '')
		Nro_Book=ISNULL(Z.bkgcom13,'')
		,dbo.Ficha_Ingreso.vch_TipoRegimen
	FROM dbo.Ficha_Ingreso
	LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY
	LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY
	--inner join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14 
	LEFT JOIN descarga.dbo.VW_BOOKING_AUTORIZACION z ON dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14
	WHERE Cod_Fiin = @Cod_Fiin
END

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_Datos_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_dev_Datos_FiinEXPO]      
(      
 @Cod_Fiin int      
)      
AS      
BEGIN      
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta      
--select * from Sf_V_Ficha_Ingreso where Cod_Fiin = @Cod_Fiin      
      
declare @numvia11 varchar(50), @desnav08 varchar(50), @navvia11 char(6), @codnav08 char(4)      
select @navvia11 = navvia11, @codnav08 = codnav08 from Ficha_Ingreso WITH(NOLOCK) where Cod_Fiin = @Cod_Fiin      
select top 1 @numvia11 = numvia11 from descarga.dbo.ddcabman11 WITH(NOLOCK) where navvia11 = @navvia11      
select top 1 @desnav08 = desnav08 from descarga.dbo.dqnavier08 WITH(NOLOCK) where codnav08 = @codnav08       
      
SELECT      
 dbo.Ficha_Ingreso.Cod_Fiin,      
 dbo.Ficha_Ingreso.Cod_Fico,      
 z.fecaut14 as Fec_Fiin,      
 dbo.Ficha_Ingreso.Gui_Remi,      
 dbo.Ficha_Ingreso.Usu_Crea,      
 dbo.Ficha_Ingreso.Cod_Emba,      
 dbo.Ficha_Ingreso.Des_Carg,      
 dbo.Ficha_Ingreso.Pla_Vehi,      
 AACLIENTESAA_2.NOMBRE AS Nom_Emba,      
 dbo.Ficha_Ingreso.Emb_Nore,      
 AACLIENTESAA_1.NOMBRE AS Nom_Nore,      
 dbo.Ficha_Ingreso.Aut_Ingr,      
 dbo.Ficha_Ingreso.Est_Fiin,      
 dbo.Ficha_Ingreso.navvia11,      
 @numvia11 as numvia11,--v.numvia11,      
 dbo.Ficha_Ingreso.codnav08,      
 @desnav08 as desnav08,--n.desnav08,      
-- Nro_Book = dbo.Ficha_Ingreso.Nro_Book + '-' + isnull((Select top 1 bkgcom13 from descarga.dbo.edbookin13 WITH(NOLOCK) where bookin13 COLLATE MODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.Nro_Book COLLATE MODERN_SPANISH_CI_AS  and navvia11 COLLATEMODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.navvia11 COLLATE MODERN_SPANISH_CI_AS and len(bkgcom13)>0 order by genbkg13 desc),''),    
 Nro_Book = isnull((Select top 1 bkgcom13 from descarga.dbo.edbookin13 WITH(NOLOCK) where bookin13 COLLATE MODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.Nro_Book COLLATE MODERN_SPANISH_CI_AS  and navvia11 COLLATE MODERN_SPANISH_CI_AS  = dbo.Ficha_Ingreso.navvia11 COLLATE MODERN_SPANISH_CI_AS and len(bkgcom13)>0 order by genbkg13 desc),''),    
 dbo.Ficha_Ingreso.vch_TipoRegimen      
FROM      
 dbo.Ficha_Ingreso      
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 WITH(NOLOCK) ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY      
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 WITH(NOLOCK) ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY        
 --inner join descarga.dbo.edauting14 z WITH(NOLOCK) on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14      
 LEFT JOIN descarga.dbo.EDAUTIN00 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14
WHERE      
 Cod_Fiin = @Cod_Fiin      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Carga]
@Cod_Carg int
AS
select * from Sf_V_Detalle_Carga where Cod_Carg=@Cod_Carg

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Contenedor]
@Cod_Cont varchar(11)
AS
select * from Sf_V_Contenedores where Cod_Cont = @Cod_Cont order by Cod_Fico desc


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Fico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Fico] 
@Cod_Fico int
AS
select * from Sf_V_Ficha_Consolidacion where Cod_Fico = @Cod_Fico

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Fiin]
@Cod_Fiin int
AS
-- dicaceres 15/05/2009: Modificado para aumentar la velocidad en la consulta
--select * from Sf_V_Ficha_Ingreso where Cod_Fiin = @Cod_Fiin
exec Sp_sf_dev_Datos_Fiin @Cod_Fiin

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Fiin_Aut]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Fiin_Aut]
@Cod_Aut varchar(8)
AS

SELECT v.numvia11,v.codnav08,a.nroaut14,a.navvia11,a.nropla81,a.codemc12,a.nrogui14,a.conten13
FROM descarga.dbo.EDAUTING14 a INNER JOIN descarga.dbo.ddcabman11 v ON a.navvia11 = v.navvia11 
WHERE a.nroaut14 = @Cod_Aut

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Fiin_AutEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 10    
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Fiin_AutEXPO] @Cod_Aut VARCHAR(8)
AS
--SELECT TOP 50 v.numvia11
--	,v.codnav08
--	,nav.desnav08
--	,a.nroaut14
--	,a.navvia11
--	,a.nropla81
--	,a.codemc12
--	,a.nrogui14
--	,a.conten13
--	,FI.Aut_Ingr
--FROM descarga.dbo.EDAUTING14 a
--INNER JOIN BALANZA.DBO.DDTICKET18 TIK ON TIK.nroaut14 = A.nroaut14 ---20160921 AÑADIR EL TICKET DE INGRESO  
--INNER JOIN descarga.dbo.ddcabman11 v ON a.navvia11 = v.navvia11
--LEFT JOIN descarga.dbo.dqnavier08 nav ON (v.codnav08 = nav.codnav08)
--LEFT JOIN Ficha_Ingreso FI ON FI.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = a.nroaut14
--WHERE a.nroaut14 = @Cod_Aut

SELECT  DAT.numvia11
	,DAT.codnav08
	,DAT.desnav08
	,DAT.nroaut14
	,DAT.navvia11
	,DAT.nropla81
	,DAT.codemc12
	,DAT.nrogui14
	,DAT.conten13
	,FI.Aut_Ingr
FROM descarga.dbo.usp_vw_WebForwardersAutorizacion DAT
LEFT JOIN Ficha_Ingreso FI ON FI.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = DAT.nroaut14
WHERE DAT.nroaut14 = @Cod_Aut
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_FiinEXPO]  
@Cod_Fiin int  
AS  
-- dicaceres 15/05/2009: Modificado para aumentar la velocidad en la consulta  
--select * from Sf_V_Ficha_Ingreso where Cod_Fiin = @Cod_Fiin  
exec Sp_sf_dev_Datos_Fiinexpo @Cod_Fiin  


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Detalle_Log]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Detalle_Log] 
@Cod_Regi int
AS
select * from Sf_v_Log where Cod_Regi=@Cod_Regi

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_DetalleCarga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_DetalleCarga]
@Cod_fico int,
@Cod_Cont varchar(11)
AS	

SELECT '' as Selector,* 
FROM Sf_V_DetalleCarga 
WHERE Cod_Fico=@Cod_fico and Cod_Cont=@Cod_Cont 
ORDER BY Cod_Corr ASC



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Eliminar_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Eliminar_Contenedor]
@Cod_Fico int,
@Cod_Cont varchar(11)
AS
begin
delete from contenedores where Cod_Fico=@Cod_fico and Cod_Cont=@Cod_Cont
update Cargas set Cod_Cont = null where  Cod_Fico=@Cod_fico and Cod_Cont=@Cod_Cont
select * from Sf_V_Contenedores  where Cod_Fico=@Cod_Fico
end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Embarcador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Embarcador] 
@Contribuy varchar(11)

AS
select nombre from terminal.dbo.aaclientesaa where contribuy=@contribuy

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Embarcadores]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Embarcadores]
@Cod_Fico int  
AS  
select *  from Sf_V_Embarcadores where Cod_Fico=@Cod_Fico


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Embarcadores_Fico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Embarcadores_Fico]  
@Cod_Fico int  
AS  
select DISTINCT Cod_Fico,Cod_Emba,Cod_CoLoad,Nom_Emba,Co_Loader,Est_Fico  from Sf_V_Embarcadores where Cod_Fico=@Cod_Fico



GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_EmbarcadoresEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--PROCEDIMIENTO TARJAEXPO Nª 11  
 --book_madre le puse cero si es null para que traiga datos.
ALTER PROCEDURE [dbo].[Sp_sf_Dev_EmbarcadoresEXPO] --68649  
@Cod_Fico int      
AS  
--LBC 17-04-2012 Se agrego filtro de columna book_madre=0  
select *  from Sf_V_Embarcadores where Cod_Fico=@Cod_Fico   and isnull(book_madre,0)=0-- and book_madre=0  
  
  
 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_Abiertas]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_Abiertas]
AS
select * from Sf_V_Ficha_Consolidacion where Est_Fico ='A' order by Cod_Fico desc

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_Abiertas_Consolidador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_Abiertas_Consolidador]
(@Cod_Cons varchar(11), @cod_pue varchar(3))
AS
select top 1 Cod_Fico from Sf_V_Ficha_Consolidacion where Est_Fico ='A' and cod_pue = @cod_pue and Cod_Cons=@Cod_Cons order by Cod_Fico desc


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_AbiertasEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_AbiertasEXPO]        
AS        
SELECT TOP 1000 * FROM Sf_V_Ficha_Consolidacion where Est_Fico ='A' order by Cod_Fico desc 

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_All]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_All] (@Cod_Cons VARCHAR(11))
	WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON

	--select nroaut14    ,navvia11    
	SELECT nroaut14
		,a.navvia11
	INTO #edauting14
	FROM descarga.dbo.edauting14 a(NOLOCK)
	--INNER JOIN descarga.dbo.edbookin13 b(NOLOCK) ON (a.genbkg13 = b.genbkg13)
	WHERE a.fecusu00 >= DATEADD(MM, - 2, GETDATE())
		--AND b.ruccli13 = @Cod_Cons

	CREATE CLUSTERED INDEX ak_#prueba ON #edauting14 (
		nroaut14
		,navvia11
		)

	UPDATE Ficha_Ingreso
	SET navvia11 = b.navvia11
	FROM Ficha_Ingreso a
	INNER JOIN #edauting14 b ON a.Aut_Ingr = b.nroaut14 collate SQL_Latin1_General_CP1_CI_AS
	WHERE a.navvia11 <> b.navvia11 collate SQL_Latin1_General_CP1_CI_AS
		AND a.navvia11 IS NOT NULL

	UPDATE Ficha_Ingreso
	SET codnav08 = b.codnav08
	FROM Ficha_Ingreso a
	INNER JOIN terminal..ddcabman11 b ON a.navvia11 = b.navvia11 collate SQL_Latin1_General_CP1_CI_AS
	WHERE a.codnav08 <> b.codnav08 collate SQL_Latin1_General_CP1_CI_AS

	UPDATE Ficha_Consolidacion
	SET navvia11 = b.navvia11
	FROM Ficha_Consolidacion a
	INNER JOIN Ficha_Ingreso b ON a.Cod_Fico = b.Cod_Fico
	WHERE isnull(a.navvia11, '') <> isnull(b.navvia11, '') collate SQL_Latin1_General_CP1_CI_AS
		AND b.navvia11 IS NOT NULL

	DECLARE @temp TABLE (
		Cod_Fico INT
		,fecsal18 DATETIME
		,cod_cons VARCHAR(11)
		)

	INSERT @temp
	SELECT DISTINCT a.Cod_Fico
		,d.fecsal18
		,b.Cod_Cont
	FROM ficha_consolidacion a WITH (NOLOCK)
	inner join contenedores b with (nolock) on a.Cod_Fico = b.Cod_Fico    
	INNER JOIN Ficha_Ingreso x ON (a.Cod_Fico = x.Cod_Fico)
	--INNER JOIN descarga.dbo.edauting14 w ON (x.Aut_Ingr collate Modern_Spanish_CI_AS = w.nroaut14)
	LEFT JOIN balanza.dbo.TICKET00 d WITH (NOLOCK) ON b.Cod_Cont = d.codcon04 COLLATE Modern_Spanish_CI_AS
		AND d.navvia11 = a.navvia11
	--left outer join descarga.dbo.DRCTRTMC90 c with (nolock) on b.Cod_Cont=c.codcon04 COLLATE Modern_Spanish_CI_AS and c.navvia11 = a.navvia11                          
	--left outer join balanza.dbo.ddticket18 d with (nolock) on c.nrotkt28=d.nrotkt18 and c.navvia11 = d.navvia11 and YEAR(d.fecsal18)>=YEAR(GETDATE())-1                          
	WHERE a.Cod_Cons = @Cod_Cons -- AND A.Fec_Fico>'20140101'    

	--select distinct a.Cod_Fico, d.fecsal18,a.cod_Cons from                            
	--ficha_consolidacion a with (nolock) inner join contenedores b with (nolock) on a.Cod_Fico = b.Cod_Fico                            
	--left outer join descarga.dbo.DRCTRTMC90 c with (nolock) on b.Cod_Cont=c.codcon04 COLLATE Modern_Spanish_CI_AS and c.navvia11 = a.navvia11                            
	--left outer join balanza.dbo.ddticket18 d with (nolock) on c.nrotkt28=d.nrotkt18 and YEAR(d.fecsal18)>=YEAR(GETDATE())-1                            
	--where a.Cod_Cons=@Cod_Cons          
	UPDATE Embarcadores
	SET Cod_Coload = NULL
	WHERE Cod_Coload = ''

	--select *from ficha_consolidacion                        
	--rdelacuba 31/12/2007: Ordenar por fecha                            
	--dcaceres 02/07/2009: agregar contenedor y fecha de salida                            
	SELECT a.*
		,b.fecsal18
	FROM Sf_V_Ficha_Consolidacion a WITH (NOLOCK)
	LEFT OUTER JOIN @temp b ON a.Cod_Fico = b.Cod_Fico
		AND a.cod_cons = b.cod_cons COLLATE Modern_Spanish_CI_AS -- retello                            
		AND a.Cod_Cont collate Modern_Spanish_CI_AS = b.cod_cons collate Modern_Spanish_CI_AS
	WHERE a.Cod_Cons = @Cod_Cons
		AND (
			codnav08 IS NULL
			OR codnav08 <> 'FTBN'
			)
	ORDER BY Fec_Fico DESC
		--                            
		--select * from Sf_V_Ficha_Consolidacion where Cod_Cons=@Cod_Cons and (codnav08 is null or codnav08 <>'FTBN')                            
		--order by Fec_Fico desc                            
END

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_All_1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_All_1]
(
	@Cod_Cons varchar(11)
)
AS
BEGIN
SET NOCOUNT ON 
select  * into #edauting14 from descarga.dbo.edauting14 where fecusu00 >=DATEADD(MM,-5,GETDATE())
update
	Ficha_Ingreso
set
	navvia11 = b.navvia11
from
	Ficha_Ingreso a
	inner join  #edauting14 b on a.Aut_Ingr = b.nroaut14 collate SQL_Latin1_General_CP1_CI_AS
where
	a.navvia11 <> b.navvia11  collate SQL_Latin1_General_CP1_CI_AS
	and a.navvia11 is not null

update
	Ficha_Ingreso
set
	codnav08 = b.codnav08
from
	Ficha_Ingreso a
	inner join terminal..ddcabman11 b on a.navvia11 = b.navvia11 collate SQL_Latin1_General_CP1_CI_AS
where
	a.codnav08 <> b.codnav08 collate SQL_Latin1_General_CP1_CI_AS

update
	Ficha_Consolidacion
set
	navvia11 = b.navvia11
from
	Ficha_Consolidacion a
	inner join Ficha_Ingreso b on a.Cod_Fico = b.Cod_Fico
where
	isnull(a.navvia11, '') <> isnull(b.navvia11, '') collate SQL_Latin1_General_CP1_CI_AS
	and b.navvia11 is not null

declare @temp table
(
	Cod_Fico int,
	fecsal18 datetime,
    cod_cons varchar(11)
)
insert @temp
select distinct a.Cod_Fico, d.fecsal18,a.cod_Cons from
ficha_consolidacion a inner join contenedores b on a.Cod_Fico = b.Cod_Fico
left outer join descarga.dbo.DRCTRTMC90 c on b.Cod_Cont=c.codcon04 COLLATE Modern_Spanish_CI_AS and c.navvia11 = a.navvia11
left outer join balanza.dbo.ddticket18 d on c.nrotkt28=d.nrotkt18

update Embarcadores set Cod_Coload=null where Cod_Coload=''


--rdelacuba 31/12/2007: Ordenar por fecha
--dcaceres 02/07/2009: agregar contenedor y fecha de salida
select a.*,b.fecsal18 from Sf_V_Ficha_Consolidacion a left outer join @temp b on a.Cod_Fico = b.Cod_Fico 
and a.cod_cons = b.cod_cons COLLATE Modern_Spanish_CI_AS -- retello
where 
a.Cod_Cons=@Cod_Cons and (codnav08 is null or codnav08 <>'FTBN')
order by Fec_Fico desc


--
--select * from Sf_V_Ficha_Consolidacion where Cod_Cons=@Cod_Cons and (codnav08 is null or codnav08 <>'FTBN')
--order by Fec_Fico desc

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_All_test]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_All_test]                    
(                    
 @Cod_Cons varchar(11)                    
)             
WITH RECOMPILE                   
AS                    
BEGIN                    
SET NOCOUNT ON                     
 /*                                 
select nroaut14    ,navvia11  into #edauting14                     
from openquery(neptunia2,'select nroaut14  ,navvia11 from descarga.dbo.edauting14(nolock) where fecusu00 >=DATEADD(MM,-2,GETDATE())')                    
                    
ALTER clustered index ak_#prueba on #edauting14 (nroaut14,navvia11)                     
update                    
 Ficha_Ingreso                    
set                    
 navvia11 = b.navvia11                    
from                    
 Ficha_Ingreso a           
 inner join  #edauting14 b on a.Aut_Ingr = b.nroaut14 collate SQL_Latin1_General_CP1_CI_AS                    
where                    
 a.navvia11 <> b.navvia11  collate SQL_Latin1_General_CP1_CI_AS                    
 and a.navvia11 is not null                    
                    
                 
update                    
 Ficha_Ingreso                    
set                    
 codnav08 = b.codnav08                    
from                    
 Ficha_Ingreso a                 
 inner join terminal..ddcabman11 b on a.navvia11 = b.navvia11 collate SQL_Latin1_General_CP1_CI_AS                    
where                    
 a.codnav08 <> b.codnav08 collate SQL_Latin1_General_CP1_CI_AS                    
                   
update                    
 Ficha_Consolidacion                    
set                    
 navvia11 = b.navvia11                    
from                    
 Ficha_Consolidacion a                    
 inner join Ficha_Ingreso b on a.Cod_Fico = b.Cod_Fico                    
where                    
 isnull(a.navvia11, '') <> isnull(b.navvia11, '') collate SQL_Latin1_General_CP1_CI_AS                    
 and b.navvia11 is not null                    
                   
declare @temp table                    
(                    
 Cod_Fico int,                    
 fecsal18 datetime,                    
    cod_cons varchar(11)                    
)                    
insert @temp 
*/                   
select distinct a.Cod_Fico,a.cod_Cons,d.fecsal18 from                    
ficha_consolidacion a with (nolock) inner join contenedores b with (nolock) on a.Cod_Fico = b.Cod_Fico 
left join balanza.dbo.TICKET00 d with (nolock) on b.Cod_Cont=d.codcon04 COLLATE Modern_Spanish_CI_AS and d.navvia11 = a.navvia11                  
--left outer join descarga.dbo.DRCTRTMC90 c with (nolock) on b.Cod_Cont=c.codcon04 COLLATE Modern_Spanish_CI_AS and c.navvia11 = a.navvia11                    
--left outer join balanza.dbo.ddticket18 d with (nolock) on c.nrotkt28=d.nrotkt18 and c.navvia11 = d.navvia11 and YEAR(d.fecsal18)>=YEAR(GETDATE())-1                    
where a.Cod_Cons=@Cod_Cons  
/*                    
update Embarcadores set Cod_Coload=null where Cod_Coload=''                    
    --select *from ficha_consolidacion                
                    
--rdelacuba 31/12/2007: Ordenar por fecha                    
--dcaceres 02/07/2009: agregar contenedor y fecha de salida                    
select a.*,b.fecsal18 from Sf_V_Ficha_Consolidacion a with (nolock) left outer join @temp b on a.Cod_Fico = b.Cod_Fico                     
and a.cod_cons = b.cod_cons COLLATE Modern_Spanish_CI_AS -- retello                    
where                     
a.Cod_Cons=@Cod_Cons and (codnav08 is null or codnav08 <>'FTBN')                    
order by Fec_Fico desc                    
                      
--                    
--select * from Sf_V_Ficha_Consolidacion where Cod_Cons=@Cod_Cons and (codnav08 is null or codnav08 <>'FTBN')                    
--order by Fec_Fico desc                    
 */                   
END 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_Embarcadas]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_Embarcadas]
AS
select * from Sf_V_Ficha_Consolidacion where Est_Fico ='E'

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_ObtenerCantidadFiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_ObtenerCantidadFiin]
(
	@Cod_Fico int
)
AS
BEGIN

SELECT COUNT(Cod_Fiin) FROM ficha_ingreso WHERE cod_fico = @Cod_Fico and transferido = 0

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fico_OcultarFico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fico_OcultarFico]
(
	@Cod_Fico int
)
AS
BEGIN

UPDATE ficha_consolidacion SET visible = 0, Est_Fico = 'C' WHERE cod_fico = @Cod_Fico

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fiin]  
(  
 @Cod_Fico int  
)  
AS  
BEGIN  
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta  
  
-- select * from Sf_V_Ficha_Ingreso where Cod_Fico=@Cod_Fico  
  
declare @numvia11 varchar(50), @desnav08 varchar(50), @navvia11 char(6), @codnav08 char(4)  
  
select @navvia11 = navvia11 from Ficha_Consolidacion where Cod_Fico = @Cod_Fico  
  
select top 1 @numvia11 = numvia11, @codnav08 = codnav08 from descarga.dbo.ddcabman11 where navvia11 = @navvia11  
  
select top 1 @desnav08 = desnav08 from descarga.dbo.dqnavier08 where codnav08 = @codnav08  
  
SELECT  
 dbo.Ficha_Ingreso.Cod_Fiin,  
 dbo.Ficha_Ingreso.Cod_Fico,  
 z.fecaut14 as Fec_Fiin,  
 dbo.Ficha_Ingreso.Gui_Remi,  
 dbo.Ficha_Ingreso.Usu_Crea,  
 dbo.Ficha_Ingreso.Cod_Emba,  
 dbo.Ficha_Ingreso.Des_Carg,  
 dbo.Ficha_Ingreso.Pla_Vehi,  
 AACLIENTESAA_2.NOMBRE AS Nom_Emba,  
 dbo.Ficha_Ingreso.Emb_Nore,  
 AACLIENTESAA_1.NOMBRE AS Nom_Nore,  
 dbo.Ficha_Ingreso.Aut_Ingr,  
 dbo.Ficha_Ingreso.Est_Fiin,  
 dbo.Ficha_Ingreso.navvia11,  
 @numvia11 as numvia11,--v.numvia11,  
 dbo.Ficha_Ingreso.codnav08,  
 @desnav08 as desnav08,--n.desnav08,  
 dbo.Ficha_Ingreso.Nro_Book  
FROM  
 dbo.Ficha_Ingreso  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY  
-- LEFT OUTER JOIN descarga.dbo.ddcabman11 v ON dbo.Ficha_Ingreso.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = v.navvia11  
-- LEFT OUTER JOIN descarga.dbo.dqnavier08 n ON dbo.Ficha_Ingreso.codnav08 COLLATE SQL_Latin1_General_CP1_CI_AS = n.codnav08  
 --left outer join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14  
 LEFT JOIN descarga.dbo.EDAUTIN00 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14 
WHERE  
 Cod_Fico = @Cod_Fico  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_Fiin_Embarcador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_Dev_Fiin_Embarcador]  
(  
 @Cod_Fico int,  
 @Cod_Emba varchar(11),  
 @Nro_book varchar(6)  
)  
AS  
BEGIN  
-- dicaceres 29/04/2009: Modificado para aumentar la velocidad en la consulta  
  
--If @Cod_Emba <> ''  
-- select * from Sf_V_Ficha_Ingreso where Cod_Fico=@Cod_Fico and Cod_Emba=@Cod_Emba and Nro_book = @Nro_book  
--else  
-- select * from Sf_V_Ficha_Ingreso where Cod_Fico=@Cod_Fico  
  
IF @Cod_Emba = ''  
 BEGIN  
  SELECT @Cod_Emba = NULL, @Nro_book = NULL  
 END  
  
declare @numvia11 varchar(50), @desnav08 varchar(50), @navvia11 char(6), @codnav08 char(4)  
  
select @navvia11 = navvia11 from Ficha_Consolidacion where Cod_Fico = @Cod_Fico  
  
select top 1 @numvia11 = numvia11, @codnav08 = codnav08 from descarga.dbo.ddcabman11 where navvia11 = @navvia11  
  
select top 1 @desnav08 = desnav08 from descarga.dbo.dqnavier08 where codnav08 = @codnav08  
  
SELECT  
 dbo.Ficha_Ingreso.Cod_Fiin,  
 dbo.Ficha_Ingreso.Cod_Fico,  
 z.fecaut14 as Fec_Fiin,  
 dbo.Ficha_Ingreso.Gui_Remi,  
 dbo.Ficha_Ingreso.Usu_Crea,  
 dbo.Ficha_Ingreso.Cod_Emba,  
 dbo.Ficha_Ingreso.Des_Carg,  
 dbo.Ficha_Ingreso.Pla_Vehi,  
 AACLIENTESAA_2.NOMBRE AS Nom_Emba,  
 dbo.Ficha_Ingreso.Emb_Nore,  
 AACLIENTESAA_1.NOMBRE AS Nom_Nore,  
 dbo.Ficha_Ingreso.Aut_Ingr,  
 dbo.Ficha_Ingreso.Est_Fiin,  
 dbo.Ficha_Ingreso.navvia11,  
 @numvia11 as numvia11,--v.numvia11,  
 dbo.Ficha_Ingreso.codnav08,  
 @desnav08 as desnav08,--n.desnav08,  
 dbo.Ficha_Ingreso.Nro_Book  
FROM  
 dbo.Ficha_Ingreso  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY   
 --left outer join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14  
 LEFT JOIN descarga.dbo.EDAUTIN00 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14
WHERE  
 Cod_Fico = @Cod_Fico  
 AND (@Cod_Emba IS NULL OR Cod_Emba = @Cod_Emba)  
 AND (@Nro_book IS NULL OR Nro_book = @Nro_book)  
  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Fiin_test]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Fiin_test]  
(  
 @Cod_Fico int  
)  
AS  
BEGIN  
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta  
  
-- select * from Sf_V_Ficha_Ingreso where Cod_Fico=@Cod_Fico  
  
declare @numvia11 varchar(50), @desnav08 varchar(50), @navvia11 char(6), @codnav08 char(4)  
  
select @navvia11 = navvia11 from Ficha_Consolidacion where Cod_Fico = @Cod_Fico  
  
select top 1 @numvia11 = numvia11, @codnav08 = codnav08 from descarga.dbo.ddcabman11 where navvia11 = @navvia11  
  
select top 1 @desnav08 = desnav08 from descarga.dbo.dqnavier08 where codnav08 = @codnav08  
  
SELECT  
 dbo.Ficha_Ingreso.Cod_Fiin,  
 dbo.Ficha_Ingreso.Cod_Fico,  
 z.fecaut14 as Fec_Fiin,  
 dbo.Ficha_Ingreso.Gui_Remi,  
 dbo.Ficha_Ingreso.Usu_Crea,  
 dbo.Ficha_Ingreso.Cod_Emba,  
 dbo.Ficha_Ingreso.Des_Carg,  
 dbo.Ficha_Ingreso.Pla_Vehi,  
 AACLIENTESAA_2.NOMBRE AS Nom_Emba,  
 dbo.Ficha_Ingreso.Emb_Nore,  
 AACLIENTESAA_1.NOMBRE AS Nom_Nore,  
 dbo.Ficha_Ingreso.Aut_Ingr,  
 dbo.Ficha_Ingreso.Est_Fiin,  
 dbo.Ficha_Ingreso.navvia11,  
 @numvia11 as numvia11,--v.numvia11,  
 dbo.Ficha_Ingreso.codnav08,  
 @desnav08 as desnav08,--n.desnav08,  
 dbo.Ficha_Ingreso.Nro_Book  
FROM  
 dbo.Ficha_Ingreso  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY  
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY  
-- LEFT OUTER JOIN descarga.dbo.ddcabman11 v ON dbo.Ficha_Ingreso.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = v.navvia11  
-- LEFT OUTER JOIN descarga.dbo.dqnavier08 n ON dbo.Ficha_Ingreso.codnav08 COLLATE SQL_Latin1_General_CP1_CI_AS = n.codnav08  
 --left outer join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14  
 LEFT JOIN descarga.dbo.EDAUTIN00 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14 
WHERE  
 Cod_Fico = @Cod_Fico  
  
END 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_FiinTarjaExpo]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_FiinTarjaExpo]  --  65586  
(      
 @Cod_Fico int      
)      
AS      
BEGIN      
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta      
      
-- select * from Sf_V_Ficha_Ingreso where Cod_Fico=@Cod_Fico      
      
declare @numvia11 varchar(50), @desnav08 varchar(50), @navvia11 char(6), @codnav08 char(4)      
      
select @navvia11 = navvia11 from Ficha_Consolidacion where Cod_Fico = @Cod_Fico      
      
select top 1 @numvia11 = numvia11, @codnav08 = codnav08 from descarga.dbo.ddcabman11 where navvia11 = @navvia11      
      
select top 1 @desnav08 = desnav08 from descarga.dbo.dqnavier08 where codnav08 = @codnav08      
      
SELECT      
 dbo.Ficha_Ingreso.Cod_Fiin,      
 dbo.Ficha_Ingreso.Cod_Fico,      
 z.fecaut14 as Fec_Fiin,      
 dbo.Ficha_Ingreso.Gui_Remi,      
 dbo.Ficha_Ingreso.Usu_Crea,      
 dbo.Ficha_Ingreso.Cod_Emba,      
 dbo.Ficha_Ingreso.Des_Carg,      
 dbo.Ficha_Ingreso.Pla_Vehi,      
 AACLIENTESAA_2.NOMBRE AS Nom_Emba,      
 dbo.Ficha_Ingreso.Emb_Nore,      
 AACLIENTESAA_1.NOMBRE AS Nom_Nore,      
 dbo.Ficha_Ingreso.Aut_Ingr,      
 dbo.Ficha_Ingreso.Est_Fiin,      
 dbo.Ficha_Ingreso.navvia11,      
 @numvia11 as numvia11,--v.numvia11,      
 dbo.Ficha_Ingreso.codnav08,      
 @desnav08 as desnav08,--n.desnav08,      
 dbo.Ficha_Ingreso.Nro_Book      
FROM      
 dbo.Ficha_Ingreso      
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_2 ON dbo.Ficha_Ingreso.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_2.CONTRIBUY      
 LEFT OUTER JOIN Terminal.dbo.AACLIENTESAA AACLIENTESAA_1 ON dbo.Ficha_Ingreso.Emb_Nore COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA_1.CONTRIBUY          
 --left outer join descarga.dbo.edauting14 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14      
 LEFT JOIN descarga.dbo.EDAUTIN00 z on dbo.Ficha_Ingreso.Aut_Ingr COLLATE SQL_Latin1_General_CP1_CI_AS = z.nroaut14
WHERE      
 Cod_Fico = @Cod_Fico      
      
END      
GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_fotos]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[Sp_sf_dev_fotos]     
@Cod_Fico int,    
@Cod_Fiin int,    
@Cod_Cont varchar(11),    
@Tip_Foto char(1)    
    
AS    
    
If @Tip_Foto = 'I' -- Ficha de Ingreso    
 --select * from Fotos where Cod_Fico=@cod_Fico and Cod_Fiin=@Cod_Fiin    
 --select  case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as Cod_Foto,  
 -- Cod_Fico ,Cod_Fiin,Tip_Foto,Cod_Cont,ruta, case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as ruta_foto from Fotos where  Cod_Fico=@cod_Fico and Cod_Fiin=@Cod_Fiin      
   select  case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else ruta+CAST(cod_foto AS varchar(10)) end as Cod_Foto,  
  Cod_Fico ,Cod_Fiin,Tip_Foto,Cod_Cont,ruta, case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else  ruta+CAST(cod_foto AS varchar(10)) end as ruta_foto 
   from Fotos where  Cod_Fico=@cod_Fico and Cod_Fiin=@Cod_Fiin
   
else -- Llenado    
 --select * from Fotos where Cod_Fico=@cod_Fico and Cod_cont=@Cod_cont    
 --select  case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as Cod_Foto,  
 -- Cod_Fico ,Cod_Fiin,Tip_Foto,Cod_Cont,ruta, case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as ruta_foto from Fotos where  Cod_Fico=@cod_Fico and Cod_cont=@Cod_cont       
   select  case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else ruta+CAST(cod_foto AS varchar(10)) end as Cod_Foto,  
  Cod_Fico ,Cod_Fiin,Tip_Foto,Cod_Cont,ruta, case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else  ruta+CAST(cod_foto AS varchar(10)) end as ruta_foto 
  from Fotos where  Cod_Fico=@cod_Fico and Cod_cont=@Cod_cont 
    
GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_fotos_ruta]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[Sp_sf_dev_fotos_ruta]   
@Cod_Fico int,  
@Cod_Fiin int,  
@Cod_Cont varchar(11),  
@Tip_Foto char(1)  
  
AS  
  
If @Tip_Foto = 'I' -- Ficha de Ingreso  
 --select *,case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as ruta_foto from Fotos where Cod_Fico=@cod_Fico and Cod_Fiin=@Cod_Fiin  
  select  case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as Cod_Foto,
  Cod_Fico ,Cod_Fiin,Tip_Foto,Cod_Cont,ruta, case when isnull(ruta,'')='' then CAST(cod_foto AS varchar(10)) else SUBSTRING(ruta,30,(LEN( ruta)+1)-30)+CAST(cod_foto AS varchar(10)) end as ruta_foto from Fotos where  Cod_Fico=@cod_Fico and Cod_Fiin=@Cod_Fiin    

  
else -- Llenado  
 select * from Fotos where Cod_Fico=@cod_Fico and Cod_cont=@Cod_cont  
  
  
GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_Info_Carga_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_Dev_Info_Carga_Contenedor](@cod_fico int, @cod_cont varchar(11))  
AS  
BEGIN
-- SELECT dbo.Sf_V_Embarcadores.Nro_Book,dbo.Sf_V_Ficha_Ingreso.Nro_Book ,dbo.Sf_V_Ficha_Ingreso.Cod_Emba,dbo.Sf_V_Embarcadores.Nom_Emba,dbo.Sf_V_Cargas.Cod_Fiin,  
--        dbo.Sf_V_Cargas.Cod_Carg,dbo.Sf_V_Cargas.Can_Carg,dbo.Sf_V_Cargas.Cod_Tica,dbo.Sf_V_Cargas.Des_Tica,  
--        dbo.Sf_V_Cargas.Medidas,dbo.Sf_V_Cargas.Pes_Carg,dbo.Sf_V_Cargas.ubi_conte,  
--        dbo.Sf_V_Cargas.alt_carg,dbo.Sf_V_Cargas.anc_carg,dbo.Sf_V_Cargas.lar_carg  
-- FROM dbo.Sf_V_Cargas INNER JOIN  
--      dbo.Sf_V_Ficha_Ingreso ON dbo.Sf_V_Cargas.cod_fico = dbo.Sf_V_Ficha_Ingreso.cod_fico and dbo.Sf_V_Cargas.Cod_Fiin = dbo.Sf_V_Ficha_Ingreso.Cod_Fiin INNER JOIN  
--      dbo.Sf_V_Embarcadores ON dbo.Sf_V_Cargas.cod_fico = dbo.Sf_V_Embarcadores.cod_fico and dbo.Sf_V_Embarcadores.Cod_Emba = dbo.Sf_V_Ficha_Ingreso.Cod_Emba and dbo.Sf_V_Embarcadores.Nro_Book = dbo.Sf_V_Ficha_Ingreso.Nro_Book  
-- WHERE dbo.Sf_V_Cargas.Cod_Fico = @cod_fico and dbo.Sf_V_Cargas.Cod_Cont = @cod_cont  
-- ORDER BY dbo.Sf_V_Embarcadores.Nom_Emba,dbo.Sf_V_Cargas.Cod_Fiin

-- dicaceres 29/04/2009: Modificado para aumentar la velocidad en la consulta

DECLARE @Aut1 TABLE
(
	Aut_Ingr varchar(8) primary key
)

DECLARE @Aut2 TABLE
(
	Aut_Ingr varchar(8),
	notemb16 varchar(13)
)

INSERT @Aut1
SELECT DISTINCT
	Sf_V_Ficha_Ingreso.Aut_Ingr
FROM
	Sf_V_Cargas
	INNER JOIN Sf_V_Ficha_Ingreso ON Sf_V_Cargas.Cod_Fico = Sf_V_Ficha_Ingreso.Cod_Fico AND Sf_V_Cargas.Cod_Fiin = Sf_V_Ficha_Ingreso.Cod_Fiin
WHERE
	dbo.Sf_V_Cargas.Cod_Fico = @cod_fico
	and dbo.Sf_V_Cargas.Cod_Cont = @cod_cont

insert @Aut2
select
	a.Aut_Ingr,
	t.notemb16
from
	@Aut1 a
	inner JOIN descarga.dbo.ERLLEORD53 AS t ON a.Aut_Ingr = t.nroaut14 COLLATE Modern_Spanish_CI_AS


SELECT     Sf_V_Embarcadores.Nro_Book, Sf_V_Ficha_Ingreso.Nro_Book AS Expr1, Sf_V_Ficha_Ingreso.Cod_Emba, Sf_V_Embarcadores.Nom_Emba, 
                      Sf_V_Cargas.Cod_Fiin, Sf_V_Cargas.Cod_Carg, Sf_V_Cargas.Can_Carg, Sf_V_Cargas.Cod_Tica, Sf_V_Cargas.Des_Tica, Sf_V_Cargas.Medidas, 
                      Sf_V_Cargas.Pes_Carg, Sf_V_Cargas.ubi_conte, Sf_V_Cargas.Alt_Carg, Sf_V_Cargas.Anc_Carg, Sf_V_Cargas.Lar_Carg, aut.notemb16 AS DUA,--t.notemb16 AS DUA, 
                      Sf_V_Ficha_Ingreso.Aut_Ingr AS Nro_Autor,
                      dbo.uf_sf_dev_PesoBal_Fiin_Aux(Sf_V_Cargas.Cod_Carg, Sf_V_Ficha_Ingreso.Cod_Emba, Sf_V_Cargas.Cod_Fiin,Sf_V_Cargas.Cod_Fico,Sf_V_Cargas.Cod_Cont) as Pes_Cl
FROM         Sf_V_Cargas INNER JOIN
                      Sf_V_Ficha_Ingreso ON Sf_V_Cargas.Cod_Fico = Sf_V_Ficha_Ingreso.Cod_Fico AND Sf_V_Cargas.Cod_Fiin = Sf_V_Ficha_Ingreso.Cod_Fiin INNER JOIN
                      Sf_V_Embarcadores ON Sf_V_Cargas.Cod_Fico = Sf_V_Embarcadores.Cod_Fico AND 
                      Sf_V_Embarcadores.Cod_Emba = Sf_V_Ficha_Ingreso.Cod_Emba AND 
                      Sf_V_Embarcadores.Nro_Book = Sf_V_Ficha_Ingreso.Nro_Book LEFT OUTER JOIN
                      --descarga.dbo.ERLLEORD53 AS t ON Sf_V_Ficha_Ingreso.Aut_Ingr = t.nroaut14 COLLATE Modern_Spanish_CI_AS
                      @Aut2 aut on Sf_V_Ficha_Ingreso.Aut_Ingr = aut.Aut_Ingr COLLATE Modern_Spanish_CI_AS
 WHERE dbo.Sf_V_Cargas.Cod_Fico = @cod_fico and dbo.Sf_V_Cargas.Cod_Cont = @cod_cont  
 ORDER BY dbo.Sf_V_Embarcadores.Nom_Emba,dbo.Sf_V_Cargas.Cod_Fiin,Sf_V_Cargas.Cod_Carg

END


GO
/****** Object:  StoredProcedure [dbo].[sp_sf_dev_info_contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_sf_dev_info_contenedor](@cod_fico int, @cod_cont varchar(11))
AS
	SELECT dbo.Sf_V_contenedores.Cod_Fico, dbo.Sf_V_contenedores.Cod_Cont,  dbo.Sf_V_contenedores.Cod_Alma, dbo.Sf_V_contenedores.Nom_Alma, dbo.Sf_V_contenedores.Cod_Tipo, 
               dbo.Sf_V_contenedores.Cod_Tama, dbo.Sf_V_contenedores.Nom_Tama, dbo.Sf_V_contenedores.Nom_Tipo, 
	       CASE dbo.Sf_V_contenedores.Est_Cont WHEN 'A' THEN 'Aperturado' WHEN 'C' THEN 'Cerrado' END as Est_Cont,
	       dbo.Sf_V_contenedores.Payload, dbo.Sf_V_contenedores.Precinto, dbo.Sf_V_contenedores.cod_pue, Nave, Viaje, dua
	FROM   dbo.Sf_V_contenedores
	WHERE dbo.Sf_V_contenedores.cod_fico = @cod_fico and dbo.Sf_V_contenedores.Cod_Cont = @cod_cont




GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_Info_Llenado]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_Dev_Info_Llenado](@cod_fico int)
AS
BEGIN
DECLARE @tot_cont int, @tot_contc int

SELECT @tot_cont = count(*)
FROM sf_v_contenedores
WHERE cod_fico = @cod_fico

IF @tot_cont = 0
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT @tot_contc = count(*)
	FROM sf_v_contenedores
	WHERE cod_fico = @cod_fico and est_cont = 'C'

	IF @tot_contc = @tot_cont
		SELECT @tot_cont
	ELSE
		SELECT 0
END

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Log]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Log] 
@Cod_Fico int,
@Cod_Fiin int,
@Cod_Cont varchar(11),
@Cod_Tire char(1)

AS
select * from Sf_v_Log where Cod_Fico=@Cod_Fico and Cod_Fiin=@Cod_Fiin and Cod_Cont=@cod_Cont and Cod_Tire=@Cod_Tire

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_PesoBal_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_dev_PesoBal_Fiin]
(
	@Cod_Fiin int
)
AS
BEGIN
-- dicaceres 28/04/2009: Modificado para aumentar la velocidad en la consulta

--select
--	t.pesnet18
--from
--	dbo.Ficha_Ingreso
--	LEFT OUTER JOIN descarga.dbo.DDTICKET18 t ON replicate('0',8-len(rtrim(dbo.Ficha_Ingreso.Aut_Ingr)))+ rtrim(dbo.Ficha_Ingreso.Aut_Ingr) = t.nroaut14 COLLATE DATABASE_DEFAULT
--
-- where Cod_Fiin = @Cod_Fiin

	declare @nroaut14 varchar(8)

	select @nroaut14 = right('00000000' + Aut_Ingr,8) from Ficha_Ingreso where Cod_Fiin = @Cod_Fiin

	select pesnet18 from descarga.dbo.DDTICKET18 where nroaut14 = @nroaut14

END

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Productos]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Productos]

AS

--temporal, debe ser neptunia2
--select Cod_producto, Des_Producto from terminal.dbo.producto -- TEMPORAL
select Cod_producto, Des_Producto from descarga.dbo.producto


GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_Resumen_Fico_Cont]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_dev_Resumen_Fico_Cont](@cod_fico int, @cod_cont varchar(11))    
AS
BEGIN
-- SELECT   sum(dbo.Sf_V_Cargas.Can_Carg) as Can_Carg, sum(dbo.Sf_V_Cargas.alt_carg*dbo.Sf_V_Cargas.anc_carg*dbo.Sf_V_Cargas.lar_carg *dbo.Sf_V_Cargas.Can_Carg) as volumen ,sum(dbo.Sf_V_Cargas.Pes_Carg) as Pes_Carg  
-- FROM dbo.Sf_V_Cargas INNER JOIN    
--      dbo.Sf_V_Ficha_Ingreso ON dbo.Sf_V_Cargas.cod_fico = dbo.Sf_V_Ficha_Ingreso.cod_fico and dbo.Sf_V_Cargas.Cod_Fiin = dbo.Sf_V_Ficha_Ingreso.Cod_Fiin INNER JOIN    
--      dbo.Sf_V_Embarcadores ON dbo.Sf_V_Cargas.cod_fico = dbo.Sf_V_Embarcadores.cod_fico and dbo.Sf_V_Embarcadores.Cod_Emba = dbo.Sf_V_Ficha_Ingreso.Cod_Emba and dbo.Sf_V_Embarcadores.Nro_Book = dbo.Sf_V_Ficha_Ingreso.Nro_Book     
-- WHERE dbo.Sf_V_Cargas.Cod_Fico = @cod_fico and dbo.Sf_V_Cargas.Cod_Cont = @cod_cont    

--14/05/2009 dicaceres: Se ha modificado para mostrar el otro peso, no el de la balanza de patio

	SELECT
		SUM(Can_Carg) as Can_Carg,
		SUM(volumen) as volumen,
		SUM(dbo.uf_sf_dev_PesoBal_Fiin(Cod_Fiin)) as Pes_Carg,
		SUM(Pes_Carg) AS Pes_Carg2
	FROM
	(	SELECT
			b.Cod_Fiin,
			SUM(b.Can_Carg) as Can_Carg,
			SUM(b.alt_carg * b.anc_carg * b.lar_carg * b.Can_Carg) as volumen,
			SUM(Pes_Carg) as Pes_Carg
		FROM
			Cargas b
		WHERE
			b.Cod_Fico = @cod_fico AND b.Cod_Cont = @cod_cont
		GROUP BY
			b.Cod_Fiin	) TOTAL


END

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_dev_Resumen_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_dev_Resumen_Fiin]  
@Cod_Fiin int  
AS  
 select sum(can_carg*(alt_carg*anc_carg*lar_carg)) as volumen,sum(Pes_Carg) as peso,sum(can_carg) AS bultos  
 from Sf_V_Cargas   
 where Cod_Fiin = @Cod_Fiin  


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Tipo_Log]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Tipo_Log] 
@Cod_Tire char(1)
AS
select * from Tipo_Log where Cod_tire=@Cod_Tire

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Tipo_usuario]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Tipo_usuario] 
@Nom_Usua varchar(20)

AS
select Cod_Cons from usuarios where Nom_usua=@Nom_usua

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Tipos_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Tipos_Carga] 

AS

select * from Tipo_Carga

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Tipos_Carga_N1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Tipos_Carga_N1]    
AS  
select  
Cod_Tica = cast(Cod_Tica as varchar)
,Des_Tica
,Cod_Bulto
from Tipo_Carga  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Tot_Carga_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Tot_Carga_Fiin]
@Cod_Fiin int
AS

SELECT     dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin, sum(dbo.Cargas.Can_Carg) as tot_carg
FROM   dbo.Cargas LEFT OUTER JOIN
       dbo.Ficha_Ingreso ON dbo.Cargas.Cod_Fiin = dbo.Ficha_Ingreso.Cod_Fiin
WHERE  	dbo.Ficha_Ingreso.Cod_Fiin = @Cod_Fiin and Flg_Impr=0 and Est_Fiin='C'
GROUP BY dbo.Cargas.Cod_Fico, dbo.Cargas.Cod_Fiin



GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Dev_Transferido_Totalmente]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_sf_Dev_Transferido_Totalmente](@cod_fico int)
AS
BEGIN
      DECLARE
            @ft INT,
            @ftr INT

      select @ft = count(Cod_Fiin) from Ficha_Ingreso where cod_fico = @cod_fico

      if @ft = 0
            begin
                  select 0
                  return
            end

      select @ftr = count(Cod_Fiin) from Ficha_Ingreso where cod_fico = @cod_fico and transferido = 1

      if @ft = @ftr
            select 1
      else
            select 0

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Dev_Volumen_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Dev_Volumen_Contenedor]
@Cod_Tipo char(2),
@Cod_Tama char(2)
AS

select Cap_Maxi  from Volumen_Maximo where Cod_Tipo=@Cod_Tipo and Cod_Tama=@Cod_Tama

GO
/****** Object:  StoredProcedure [dbo].[SP_SF_ELIMINAR_CARGA_WEB_EXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SF_ELIMINAR_CARGA_WEB_EXPO] 
  @Cod_Carga INT
AS  
BEGIN  
 
   DECLARE  @Error   INT  
   DECLARE  @LpnOut  VARCHAR(8000)
  
   --INICIALIZAMOS PARÁMETROS    
   SET @Error = 0  
   SET XACT_ABORT ON  
  
   BEGIN TRAN  
  
      DELETE FROM cargas 
      WHERE Cod_Carg = @Cod_Carga
      
      DELETE FROM descarga.dbo.edmarcas18
      WHERE cod_Carga18 = @Cod_Carga
      
      SET @Error = @@ERROR  
       
         IF (@Error <> 0)  
            GOTO TratarError 
      
      SET @LpnOut = @Cod_Carga
      SELECT @LpnOut as LpnOut  
      COMMIT TRAN  
  
      TratarError:  
  
      IF @@Error <> 0  
         BEGIN  
            SET @LpnOut = ''  
            SELECT @LpnOut as LpnOut  
  
            ROLLBACK TRAN  
         END  
END  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Eliminar_Foto]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
  
  --34 TARJA EXPO
   
ALTER PROCEDURE [dbo].[Sp_Sf_Eliminar_Foto]    
@Cod_Foto int  
    
AS    
    
delete from Fotos where cod_foto =   @Cod_Foto


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Carga] 
@Cod_Fico int,
@Cod_Fiin int,
@Po_Carg varchar(10),
@Sty_Carg varchar(10),
@Can_Carg smallint,
@Pes_Carg decimal(9,2),
@Alt_Carg decimal(9,2),
@Anc_Carg decimal(9,2),
@Lar_Carg decimal(9,2),
@Cod_Tica tinyint,
@Des_Carg varchar(50),
@Ubi_alma varchar(10),
@Est_Carg char(1),
@Ing_Nept char(1),
@Cod_Prod varchar(5),
@Marca varchar(50)


AS

insert into Cargas(Cod_Fico,Cod_Fiin,Po_Carg,Sty_carg,Can_Carg,Pes_Carg,Alt_Carg,Anc_Carg,Lar_Carg,Cod_Tica,Des_Carg,Cod_Fior,Cod_fiio,Ubi_Alma,Est_Carg,Ing_Nept,Cod_prod,flg_Impr,Marca)
values(@Cod_Fico,@Cod_Fiin,@Po_Carg,@Sty_carg,@Can_Carg,@Pes_Carg,@Alt_Carg,@Anc_Carg,@Lar_Carg,@Cod_Tica,@Des_Carg,@Cod_Fico,@Cod_Fiin,@Ubi_Alma,@Est_Carg,@Ing_Nept,@Cod_prod,0,@Marca)



GO
/****** Object:  StoredProcedure [dbo].[SP_SF_GRABAR_CARGA_MOVIL]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  --40 TARJA EXPO
  
/*Modificacion :  Mes  Se agrego parametro de ingreso y registro a procedimiento */       
ALTER PROCEDURE [dbo].[SP_SF_GRABAR_CARGA_MOVIL]         
@Cod_Fico int,        
@Cod_Fiin int,        
@Po_Carg varchar(10),        
@Sty_Carg varchar(10),        
@Can_Carg smallint,        
@Pes_Carg decimal(9,2),        
@Alt_Carg decimal(9,2),        
@Anc_Carg decimal(9,2),        
@Lar_Carg decimal(9,2),        
@Cod_Tica tinyint,        
@Des_Carg varchar(50),        
@Ubi_alma varchar(10),        
@Est_Carg char(1),        
@Ing_Nept char(1),        
@Cod_Prod varchar(5),        
@Marca varchar(100),        
@Lpn varchar(50)  ,      
@LpnOut varchar(50) output,      
@Cod_CargOut integer output      
        
AS      
BEGIN      
  SET @Cod_CargOut = 0      
  SET @LpnOut = 'LPN'      
      
      
  DECLARE @vLPN varchar(50)      
 PRINT 'LPN INGRESO: ' + CAST( LEN(isnull(@Lpn,'')) as varchar)    
  IF LEN(isnull(@Lpn,'')) = 0 --Si no obtiene tiene tarja se obtiene      
  BEGIN       
    PRINT ' ANTES DE GENERAR LPN : '     
    SET @vLPN = dbo.TGEN_FN_OBTENER_CORRELATIVO ( NULL, NULL , 'LPNEXPO')     
    PRINT ' LPN GENE: ' + cast (@vLPN as varchar)     
    
    UPDATE BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1       
    WHERE vch_CodigoIdentificador = 'LPNEXPO'      
    
  END      
  ELSE      
  BEGIN       
   SET @vLPN = @Lpn      
  END      
        
      
   INSERT INTO CARGAS( Cod_Fico,Cod_Fiin,Po_Carg,Sty_carg,Can_Carg,      
        Pes_Carg,Alt_Carg,Anc_Carg,Lar_Carg,Cod_Tica,      
        Des_Carg,Cod_Fior,Cod_fiio,Ubi_Alma,Est_Carg,      
        Ing_Nept,Cod_prod,flg_Impr,Marca, lpn)        
   VALUES     ( @Cod_Fico,@Cod_Fiin,@Po_Carg,@Sty_carg,@Can_Carg,      
        @Pes_Carg,@Alt_Carg,@Anc_Carg,@Lar_Carg,@Cod_Tica,      
        @Des_Carg,@Cod_Fico,@Cod_Fiin,@Ubi_Alma,@Est_Carg,      
        @Ing_Nept,@Cod_prod,0,@Marca, @vLPN)        
           
  SET @Cod_CargOut = scope_identity()      
  SET @LpnOut = @vLpn      
      
END      



GO
/****** Object:  StoredProcedure [dbo].[SP_SF_GRABAR_CARGA_MOVIL_EXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SF_GRABAR_CARGA_MOVIL_EXPO]         
@Cod_Fico int,        
@Cod_Fiin int,        
@Po_Carg varchar(10),        
@Sty_Carg varchar(10),        
@Can_Carg smallint,        
@Pes_Carg decimal(9,2),        
@Alt_Carg decimal(9,2),        
@Anc_Carg decimal(9,2),        
@Lar_Carg decimal(9,2),        
@Cod_Tica tinyint,        
@Des_Carg varchar(50),        
@Ubi_alma varchar(10),        
@Est_Carg char(1),        
@Ing_Nept char(1),        
@Cod_Prod varchar(5),        
@Marca varchar(100),        
@Lpn varchar(50),
@Cant_Repetidos int,
@LpnOut varchar(8000) output      
--,@Cod_CargOut integer output      
AS      
BEGIN 

	DECLARE @Contador INT, 
			@pSalida VARCHAR(8000), 
			@vLPN VARCHAR(20), 
			@pCodCarga INT
			
	IF ISNULL(@Cant_Repetidos,0) = 0 SET @Cant_Repetidos = 1
	DECLARE @Error int	
	--INICIALIZAMOS PARÁMETROS
	SET @Contador = 0
	SET @pSalida = ''
	SET @Error = 0	
	
	SET XACT_ABORT ON
	
	BEGIN TRAN 
		
		WHILE (@Contador < @Cant_Repetidos)
		BEGIN		
			IF LEN(ISNULL(@Lpn,'')) = 0    
			BEGIN       	    
				-- SI NO TIENE LPN LE VAMOS A ASIGNAR UNO
				SET @vLPN = dbo.TGEN_FN_OBTENER_CORRELATIVO ( NULL, NULL , 'LPNEXPO')     		
				--PROD
				UPDATE BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1        
				--UPDATE [GYS-PC18].BD_WMS_FWD_TEST.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1       
				WHERE vch_CodigoIdentificador = 'LPNEXPO'
			END      
			ELSE      
			BEGIN       
				SET @vLPN = @Lpn  				  
			END			
		
			INSERT INTO CARGAS( Cod_Fico,Cod_Fiin,Po_Carg,Sty_carg,Can_Carg,      
				Pes_Carg,Alt_Carg,Anc_Carg,Lar_Carg,Cod_Tica,      
				Des_Carg,Cod_Fior,Cod_fiio,Ubi_Alma,Est_Carg,      
				Ing_Nept,Cod_prod,flg_Impr,Marca, lpn, fecha_modificacion1, usuario_modificacion1)        
			VALUES     ( @Cod_Fico,@Cod_Fiin,@Po_Carg,@Sty_carg,@Can_Carg,      
				@Pes_Carg,@Alt_Carg,@Anc_Carg,@Lar_Carg,@Cod_Tica,      
				@Des_Carg,@Cod_Fico,@Cod_Fiin,@Ubi_Alma,@Est_Carg,      
				@Ing_Nept,@Cod_prod,0,@Marca, @vLPN, GETDATE(), 'O') -- AGREGADO PARA DARLE SEGUIMIENTO; O-> ONLINE
		
			SET @pCodCarga = SCOPE_IDENTITY()
			SET @pSalida = @pSalida + @vLPN + '%' + CAST(@pCodCarga AS VARCHAR(10)) + '|'
			SET @Contador = @Contador + 1
			SET @Lpn = ''
			SET @Error=@@ERROR
			IF (@Error<>0) GOTO TratarError
		END
		
		SET @LpnOut = SUBSTRING(@pSalida,1,LEN(@pSalida)-1)		
	COMMIT TRAN
	
	TratarError:
		If @@Error<>0 
		BEGIN
			SET @LpnOut = ''		
			ROLLBACK TRAN
		END	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SF_GRABAR_CARGA_MOVIL_EXPO_N1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SF_GRABAR_CARGA_MOVIL_EXPO_N1] @Cod_Fico INT
	,@Cod_Fiin INT
	,@Po_Carg VARCHAR(10)
	,@Sty_Carg VARCHAR(10)
	,@Can_Carg SMALLINT
	,@Pes_Carg DECIMAL(9, 2)
	,@Alt_Carg DECIMAL(9, 2)
	,@Anc_Carg DECIMAL(9, 2)
	,@Lar_Carg DECIMAL(9, 2)
	,@Cod_Tica TINYINT
	,@Des_Carg VARCHAR(50)
	,@Ubi_alma VARCHAR(10)
	,@Est_Carg CHAR(1)
	,@Ing_Nept CHAR(1)
	,@Cod_Prod VARCHAR(5)
	,@Marca VARCHAR(100)
	,@Lpn VARCHAR(50)
	,@Cant_Repetidos INT
	--,@LpnOut VARCHAR(8000) OUTPUT
	--,@Cod_CargOut integer output        
AS
BEGIN
	DECLARE @Contador INT
		,@pSalida VARCHAR(8000)
		,@vLPN VARCHAR(20)
		,@pCodCarga INT
		,@LpnOut VARCHAR(8000)

	IF ISNULL(@Cant_Repetidos, 0) = 0
		SET @Cant_Repetidos = 1

	DECLARE @Error INT

	--INICIALIZAMOS PARÁMETROS  
	SET @Contador = 0
	SET @pSalida = ''
	SET @Error = 0
	SET XACT_ABORT ON

	BEGIN TRAN

	WHILE (@Contador < @Cant_Repetidos)
	BEGIN
		IF LEN(ISNULL(@Lpn, '')) = 0
		BEGIN
			-- SI NO TIENE LPN LE VAMOS A ASIGNAR UNO  
			SET @vLPN = dbo.TGEN_FN_OBTENER_CORRELATIVO(NULL, NULL, 'LPNEXPO')

			--PROD  
			UPDATE BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO
			SET int_Valor = int_Valor + 1
			--UPDATE [GYS-PC18].BD_WMS_FWD_TEST.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1         
			WHERE vch_CodigoIdentificador = 'LPNEXPO'
		END
		ELSE
		BEGIN
			SET @vLPN = @Lpn
		END

		INSERT INTO CARGAS (
			Cod_Fico
			,Cod_Fiin
			,Po_Carg
			,Sty_carg
			,Can_Carg
			,Pes_Carg
			,Alt_Carg
			,Anc_Carg
			,Lar_Carg
			,Cod_Tica
			,Des_Carg
			,Cod_Fior
			,Cod_fiio
			,Ubi_Alma
			,Est_Carg
			,Ing_Nept
			,Cod_prod
			,flg_Impr
			,Marca
			,lpn
			,fecha_modificacion1
			,usuario_modificacion1
			)
		VALUES (
			@Cod_Fico
			,@Cod_Fiin
			,@Po_Carg
			,@Sty_carg
			,@Can_Carg
			,@Pes_Carg
			,@Alt_Carg
			,@Anc_Carg
			,@Lar_Carg
			,@Cod_Tica
			,@Des_Carg
			,@Cod_Fico
			,@Cod_Fiin
			,@Ubi_Alma
			,@Est_Carg
			,@Ing_Nept
			,@Cod_prod
			,0
			,@Marca
			,@vLPN
			,GETDATE()
			,'O'
			) -- AGREGADO PARA DARLE SEGUIMIENTO; O-> ONLINE  

		SET @pCodCarga = SCOPE_IDENTITY()
		SET @pSalida = @pSalida + @vLPN + '%' + CAST(@pCodCarga AS VARCHAR(10)) + '|'
		SET @Contador = @Contador + 1
		SET @Lpn = ''
		SET @Error = @@ERROR

		IF (@Error <> 0)
			GOTO TratarError
	END

	SET @LpnOut = SUBSTRING(@pSalida, 1, LEN(@pSalida) - 1)

	SELECT @LpnOut as LpnOut

	COMMIT TRAN

	TratarError:

	IF @@Error <> 0
	BEGIN
		SET @LpnOut = ''
		SELECT @LpnOut as LpnOut

		ROLLBACK TRAN
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SF_GRABAR_CARGA_WEB_EXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SF_GRABAR_CARGA_WEB_EXPO] 
  @Cod_Fico INT  
 ,@Cod_Fiin INT  
 ,@Po_Carg VARCHAR(10)  
 ,@Sty_Carg VARCHAR(10)  
 ,@Can_Carg SMALLINT  
 ,@Pes_Carg DECIMAL(9, 2)  
 ,@Alt_Carg DECIMAL(9, 2)  
 ,@Anc_Carg DECIMAL(9, 2)  
 ,@Lar_Carg DECIMAL(9, 2)  
 ,@Cod_Tica TINYINT  
 ,@Des_Carg VARCHAR(50)  
 ,@Ubi_alma VARCHAR(10)  
 ,@Est_Carg CHAR(1)  
 ,@Ing_Nept CHAR(1)  
 ,@Cod_Prod VARCHAR(5)  
 ,@Marca VARCHAR(100)  
 ,@Lpn VARCHAR(50)  
 ,@Cant_Repetidos INT  
 --,@LpnOut VARCHAR(8000) OUTPUT  
 --,@Cod_CargOut integer output          
AS  
BEGIN  
   DECLARE @Contador    INT  
          ,@pSalida     VARCHAR(8000)  
          ,@vLPN        VARCHAR(20)  
          ,@pCodCarga   INT  
          ,@LpnOut      VARCHAR(8000)
          ,@autoriza    VARCHAR(10)
          ,@Cod_Bulto   VARCHAR(3)
          ,@volume18    DECIMAL(9, 2)
          ,@pesop16     DECIMAL(9, 2)
          ,@flgtra99    VARCHAR(1)
          ,@TipoBulto   int
          ,@estado18    VARCHAR(2)
          ,@nroitm16    VARCHAR(3)
          ,@nroitm18    VARCHAR(3)
          ,@sucursal    VARCHAR(1)
          
   IF ISNULL(@Cant_Repetidos, 0) = 0  
      SET @Cant_Repetidos = 1  
  
   DECLARE @Error INT  
  
   --INICIALIZAMOS PARÁMETROS    
   SET @Contador = 0  
   SET @pSalida = ''  
   SET @Error = 0  
   SET XACT_ABORT ON  
  
   BEGIN TRAN  
  
      WHILE (@Contador < @Cant_Repetidos)  
      BEGIN  
         IF LEN(ISNULL(@Lpn, '')) = 0  
         BEGIN  
            -- SI NO TIENE LPN LE VAMOS A ASIGNAR UNO    
            SET @vLPN = dbo.TGEN_FN_OBTENER_CORRELATIVO(NULL, NULL, 'LPNEXPO')  
      
            --PROD    
            UPDATE BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO  
            SET int_Valor = int_Valor + 1  
            --UPDATE [GYS-PC18].BD_WMS_FWD_TEST.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1           
            WHERE vch_CodigoIdentificador = 'LPNEXPO'  
         END     
         ELSE  
         BEGIN  
            SET @vLPN = @Lpn  
         END  
      
         INSERT INTO CARGAS (  
            Cod_Fico  
            ,Cod_Fiin  
            ,Po_Carg  
            ,Sty_carg  
            ,Can_Carg  
            ,Pes_Carg  
            ,Alt_Carg  
            ,Anc_Carg  
            ,Lar_Carg  
            ,Cod_Tica  
            ,Des_Carg  
            ,Cod_Fior  
            ,Cod_fiio  
            ,Ubi_Alma  
            ,Est_Carg  
            ,Ing_Nept  
            ,Cod_prod  
            ,flg_Impr  
            ,Marca  
            ,lpn  
            ,fecha_modificacion1  
            ,usuario_modificacion1  
            )  
         VALUES (  
            @Cod_Fico  
            ,@Cod_Fiin  
            ,@Po_Carg  
            ,@Sty_carg  
            ,@Can_Carg  
            ,@Pes_Carg  
            ,@Alt_Carg  
            ,@Anc_Carg  
            ,@Lar_Carg  
            ,@Cod_Tica  
            ,@Des_Carg  
            ,@Cod_Fico  
            ,@Cod_Fiin  
            ,@Ubi_Alma  
            ,@Est_Carg  
            ,@Ing_Nept  
            ,@Cod_prod  
            ,0  
            ,@Marca  
            ,@vLPN  
            ,GETDATE()  
            ,'O'  
            ) -- AGREGADO PARA DARLE SEGUIMIENTO; O-> ONLINE    
         
         SET @pCodCarga = SCOPE_IDENTITY()  
         SET @pSalida = @pSalida + @vLPN + '%' + CAST(@pCodCarga AS VARCHAR(10)) + '|'  
         SET @Contador = @Contador + 1  
         SET @Lpn = ''  
         SET @Error = @@ERROR  
          
         IF (@Error <> 0)  
            GOTO TratarError 
      
            --=======================================================================================================================================
            -- GRABA DESCARGA.EDMARCAS18
            --=======================================================================================================================================
            
            -- OBTIENE EL NUMERO DE AUTORIZACION
            select
               distinct @autoriza = Aut_Ingr
            from
               Ficha_Ingreso
            where
               Cod_Fiin = @Cod_Fiin
               and Cod_Fico = @Cod_Fico
      
            -- OBTIENE EL CODIGO DE BULTO VALIDO PARA EDMARCAS18
            select
               @Cod_Bulto = Cod_Bulto
            from
               Tipo_Carga
            where
               Cod_Tica = @Cod_Tica
         
            SET @nroitm16 = '001'
            SET @volume18 = @Lar_Carg * @Anc_Carg * @Alt_Carg 
            SET @pesop16  = 0
            SET @flgtra99 = 'U'
            SET @sucursal = '1'
            if (@Est_Carg = 'M')
               SET @estado18 = 'DD'
            else
               SET @estado18 = 'OK'
            
            select
               @nroitm18 = RIGHT('000'+convert(varchar(3),isnull(max(convert(int,nroitm18)),0) + 1),3)
            from 
               descarga.dbo.edmarcas18
            where
               nroaut14 = @autoriza 
         
            insert into descarga.dbo.edmarcas18
            (nroaut14, nroitm16,  marcas16,  longi116,  longi216, longi316, nrobul16, nroitm18,  flgtra99,
            fectra99,  sucursal,  volume18,  pesop16,   idPO16,   style16,  ubimer16, estmer16,  rucven16, nrolpn18,
            estado18,  Modifwd18, ModiEmb18, Modiwms18, fecusu99, usu99,    zonmer16, TipoBulto, cod_carga18)
            VALUES
            (@autoriza, @nroitm16, @Marca, @Lar_Carg, @Anc_Carg, @Alt_Carg, @Can_Carg, @nroitm18, @flgtra99,
            GETDATE(), @sucursal, @volume18, @pesop16, '', '', null, null, null, @vLPN, 
            @estado18, 'S', 'S', 'S', null, null, null, @Cod_Bulto, @pCodCarga)
      
            SET @Error = @@ERROR  
             
            IF (@Error <> 0)  
               GOTO TratarError 
            --=======================================================================================================================================
         END  
  
         SET @LpnOut = SUBSTRING(@pSalida, 1, LEN(@pSalida) - 1)  
  
         SELECT @LpnOut as LpnOut  
  
         COMMIT TRAN  
  
         TratarError:  
  
         IF @@Error <> 0  
         BEGIN  
            SET @LpnOut = ''  
            SELECT @LpnOut as LpnOut  
  
            ROLLBACK TRAN  
         END  
   -- END TRANSACTION
END  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Contenedor]  
@Cod_Fico int,  
@Cod_Alma int,  
@Cod_Cont varchar(11),  
@Cod_Tipo varchar(2),  
@Cod_Tama varchar(2) ,
@payload decimal(5, 3),
@Precinto varchar(30) 
AS  
  
Insert Contenedores(Cod_Cont,Cod_Fico,Cod_alma,Cod_Tipo,Cod_Tama,Est_Cont,Payload,Precinto)  
values(@Cod_Cont,@Cod_Fico,@Cod_Alma,@Cod_Tipo,@Cod_Tama,'A',@payload,@Precinto)

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Embarcador]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Embarcador]
@Cod_Fico int,
@Cod_Emba varchar(11),
@Nro_Book varchar(6),
@Cod_Coload varchar(11)
AS
BEGIN

DECLARE @mensaje varchar(100)

--rdelacuba 31/12/2007: Diferenciar inserción de actualización siempre que la ficha de ingreso no esté cerrada
IF EXISTS(SELECT * FROM Embarcadores (NOLOCK) WHERE cod_fico = @Cod_Fico and cod_emba = @Cod_Emba and Nro_Book = @Nro_Book)
	BEGIN
	
		IF NOT EXISTS(SELECT * FROM ficha_ingreso (NOLOCK) WHERE cod_fico = @Cod_Fico and cod_emba = @Cod_Emba and Nro_Book = @Nro_Book and est_fiin = 'C')
		BEGIN		
			UPDATE Embarcadores
			SET Cod_CoLoad = @Cod_Coload
			WHERE cod_fico = @Cod_Fico and cod_emba = @Cod_Emba
		END
	END
ELSE
	BEGIN
		--rdelacuba 31/07/2007: Considerar también el co-loader
		INSERT Embarcadores(Cod_Fico,Cod_emba,Nro_Book,Cod_CoLoad)
		VALUES(@Cod_Fico,@Cod_emba,@Nro_Book,@Cod_Coload)
	END

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Fico]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Fico] 
@Cod_Cons varchar(11),
@Usu_Creo varchar(20),
@Cod_Pue varchar(3),
@cod_Fico as int
AS

IF @cod_Fico = 0 
BEGIN
	Insert Ficha_Consolidacion(Cod_Cons,Fec_Fico,Usu_Creo,cod_pue)
	values(@Cod_Cons,getdate(),@Usu_Creo,@Cod_Pue)

	Select @@identity
END
ELSE
BEGIN
	UPDATE Ficha_Consolidacion
	SET cod_pue = @Cod_Pue
	WHERE Cod_Fico = @cod_Fico

	Select @cod_Fico
END



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Fiin]
@Cod_Fico int,
@Gui_Remi varchar(20),
@Usu_Crea varchar(20),
@Cod_Emba varchar(11),
@Pla_Vehi varchar(7),
@Emb_Nore varchar(11),
@Aut_Ingr varchar(8),
@Cod_Nave varchar(4),
@Num_Viaje varchar(6),
@Nro_Book varchar(6)
AS

Insert Ficha_Ingreso(Cod_Fico,Fec_Fiin,Gui_Remi, Usu_Crea, Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Est_Fiin,Tip_Fiin,navvia11,codnav08,Nro_Book)
values(@Cod_fico,getdate(),@Gui_Remi,@Usu_Crea,@Cod_Emba,@Pla_Vehi,@Emb_Nore,@Aut_ingr,'A','R',@Num_Viaje,@Cod_Nave,@Nro_Book)

update Ficha_Consolidacion set navvia11 = @Num_Viaje where Cod_Fico = @Cod_Fico

Select @@identity


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 14
/*
Modificacion: Miguel E: 
Accion:  Se agrego campo a tabla ficha de ingreso y se agrego @tipoRegimen al Sp
para su registro.
*/
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_FiinEXPO]  
@Cod_Fico int,  
@Gui_Remi varchar(20),  
@Usu_Crea varchar(20),  
@Cod_Emba varchar(11),  
@Pla_Vehi varchar(7),  
@Emb_Nore varchar(11),  
@Aut_Ingr varchar(8),  
@Cod_Nave varchar(4),  
@Num_Viaje varchar(6),  
@Nro_Book varchar(6) , 
@TipoRegimen varchar(50) 
AS  
	DECLARE @COD_FIIN INT
	SELECT @COD_FIIN = COD_FIIN FROM FICHA_INGRESO WHERE Cod_Fico = @Cod_Fico AND Aut_Ingr = @Aut_Ingr
	
	IF(ISNULL(@COD_FIIN,0) = 0)
	BEGIN
		INSERT Ficha_Ingreso (Cod_Fico,Fec_Fiin,Gui_Remi, Usu_Crea, Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Est_Fiin,Tip_Fiin,navvia11,codnav08,Nro_Book, vch_TipoRegimen)  
		VALUES(@Cod_fico,getdate(),@Gui_Remi,@Usu_Crea,@Cod_Emba,@Pla_Vehi,@Emb_Nore,@Aut_ingr,'A','R',@Num_Viaje,@Cod_Nave,@Nro_Book, @TipoRegimen )  
		
		UPDATE Ficha_Consolidacion SET navvia11 = @Num_Viaje WHERE Cod_Fico = @Cod_Fico  
		
		SELECT SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @COD_FIIN
	END
	
--Insert Ficha_Ingreso(Cod_Fico,Fec_Fiin,Gui_Remi, Usu_Crea, Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Est_Fiin,Tip_Fiin,navvia11,codnav08,Nro_Book, vch_TipoRegimen)  
--values(@Cod_fico,getdate(),@Gui_Remi,@Usu_Crea,@Cod_Emba,@Pla_Vehi,@Emb_Nore,@Aut_ingr,'A','R',@Num_Viaje,@Cod_Nave,@Nro_Book, @TipoRegimen )  
--update Ficha_Consolidacion set navvia11 = @Num_Viaje where Cod_Fico = @Cod_Fico  
--Select @@identity  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_FiinEXPO_N1]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 14  
/*  
Modificacion: Miguel E:   
Accion:  Se agrego campo a tabla ficha de ingreso y se agrego @tipoRegimen al Sp  
para su registro.  
*/
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_FiinEXPO_N1] 
	@Cod_Fico INT
	,@Gui_Remi VARCHAR(20)
	,@Usu_Crea VARCHAR(20)
	--,@Cod_Emba VARCHAR(11)
	,@Pla_Vehi VARCHAR(7)
	--,@Emb_Nore VARCHAR(11)
	,@Aut_Ingr VARCHAR(8)
	--,@Cod_Nave VARCHAR(4)
	--,@Num_Viaje VARCHAR(6)
	,@Nro_Book VARCHAR(6)
	,@TipoRegimen VARCHAR(50)
AS
DECLARE @COD_FIIN INT
,@Cod_Emba VARCHAR(11)
,@Emb_Nore VARCHAR(11)
,@Cod_Nave VARCHAR(4)
,@Num_Viaje VARCHAR(6)

SELECT @COD_FIIN = COD_FIIN
FROM FICHA_INGRESO
WHERE Cod_Fico = @Cod_Fico
	AND Aut_Ingr = @Aut_Ingr

--set @COD_FIIN = 0

select 
@Cod_Emba = c.codemc12
,@Emb_Nore = ''
,@Cod_Nave = f.codnav08
,@Num_Viaje = f.numvia11
from Descarga.dbo.EDAUTING14 b
inner join Descarga.dbo.EDBOOKIN13 c on b.genbkg13 = c.genbkg13
inner join terminal..DDCABMAN11 f on f.navvia11 = c.navvia11
where b.nroaut14 = @Aut_Ingr

IF (ISNULL(@COD_FIIN, 0) = 0)
BEGIN
	INSERT Ficha_Ingreso (
		Cod_Fico
		,Fec_Fiin
		,Gui_Remi
		,Usu_Crea
		,Cod_Emba
		,Pla_Vehi
		,Emb_Nore
		,Aut_Ingr
		,Est_Fiin
		,Tip_Fiin
		,navvia11
		,codnav08
		,Nro_Book
		,vch_TipoRegimen
		)
	VALUES (
		@Cod_fico
		,getdate()
		,@Gui_Remi
		,@Usu_Crea
		,@Cod_Emba
		,@Pla_Vehi
		,@Emb_Nore
		,@Aut_ingr
		,'A'
		,'R'
		,@Num_Viaje
		,@Cod_Nave
		,@Nro_Book
		,@TipoRegimen
		)

	UPDATE Ficha_Consolidacion
	SET navvia11 = @Num_Viaje
	WHERE Cod_Fico = @Cod_Fico

	SELECT SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @COD_FIIN
END
		--Insert Ficha_Ingreso(Cod_Fico,Fec_Fiin,Gui_Remi, Usu_Crea, Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Est_Fiin,Tip_Fiin,navvia11,codnav08,Nro_Book, vch_TipoRegimen)    
		--values(@Cod_fico,getdate(),@Gui_Remi,@Usu_Crea,@Cod_Emba,@Pla_Vehi,@Emb_Nore,@Aut_ingr,'A','R',@Num_Viaje,@Cod_Nave,@Nro_Book, @TipoRegimen )    
		--update Ficha_Consolidacion set navvia11 = @Num_Viaje where Cod_Fico = @Cod_Fico    
		--Select @@identity 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Foto]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Foto]
@Cod_Fico int,
@Cod_Fiin int,
@Cod_Cont varchar(11),
@Tip_Foto char(1)

AS

Insert Fotos(Cod_Fico,Cod_Fiin,Cod_Cont,Tip_Foto)
values(@Cod_Fico,@Cod_Fiin,@Cod_Cont,@Tip_Foto)

Select @@identity

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Foto_Ruta]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Foto_Ruta]  
@Cod_Fico int,  
@Cod_Fiin int,  
@Cod_Cont varchar(11),  
@Tip_Foto char(1),
@Ruta_Foto varchar(200)  
AS  

Declare @Cod_Foto int  

Insert Fotos(Cod_Fico,Cod_Fiin,Cod_Cont,Tip_Foto,ruta)  
values(@Cod_Fico,@Cod_Fiin,@Cod_Cont,@Tip_Foto,@Ruta_Foto)  
  
Select @Cod_Foto = @@identity 

Select @Cod_Foto 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_FotoMovil]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_FotoMovil]  
@Cod_Fico int,  
@Cod_Fiin int,  
@Cod_Cont varchar(11),  
@Tip_Foto char(1),  
@cod_foto INT output       
AS  
BEGIN  
  
 Insert Fotos(Cod_Fico,Cod_Fiin,Cod_Cont,Tip_Foto)  
 values(@Cod_Fico,@Cod_Fiin,@Cod_Cont,@Tip_Foto)  
  
 SET @cod_foto = @@identity  
  
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_FotoMovil_Ruta]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_FotoMovil_Ruta]  
@Cod_Fico int,  
@Cod_Fiin int,  
@Cod_Cont varchar(11),  
@Tip_Foto char(1),  
@Ruta_Foto varchar(500),
@cod_foto INT output       
AS  
BEGIN  
 



 Insert Fotos(Cod_Fico,Cod_Fiin,Cod_Cont,Tip_Foto,ruta)  
 values(@Cod_Fico,@Cod_Fiin,@Cod_Cont,@Tip_Foto,@Ruta_Foto)  
  
 SET @cod_foto = @@identity  
  
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Grabar_Log]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Grabar_Log]  

@Des_Regi varchar(2000),  

@Cod_Fico int,  

@Cod_Fiin int,  

@Cod_Cont varchar(11),  

@Cod_Tilo tinyint,  

@Nom_Usua varchar(20)  

AS  

  

Insert Log(Des_Regi,Cod_Fico,Cod_Fiin,Cod_Cont,Cod_Tilo,Fec_Regi,Nom_Usua)  

values(@Des_Regi,@Cod_Fico,@Cod_Fiin,@Cod_Cont,@Cod_tilo,getdate(),@Nom_Usua)  

  

Select @@identity
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Imprimir_carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Imprimir_carga]
@Cod_Carg int
AS
--rdelacuba 07/08/2007: Es cargas, no carga
update Cargas set Flg_Impr=1 where Cod_Carg=@Cod_Carg



GO
/****** Object:  StoredProcedure [dbo].[sp_sf_pay_pre]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_sf_pay_pre] 
@Cod_Cont CHAR(11)  
AS  

select payloa04 from descarga.dbo.edconten04  where codcon04 = @Cod_Cont

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Quitar_Carga_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Quitar_Carga_Contenedor]
@Cod_Carg int
AS

update Cargas set Cod_Cont=Null
where Cod_Carg=@Cod_Carg

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Quitar_Carga_Simulacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Quitar_Carga_Simulacion]
@Nom_Usua varchar(20),
@cod_Carg int
AS

Delete Simulacion1 where Cod_Carg=@Cod_Carg and Nom_Usua=@Nom_Usua

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Quitar_Carga_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Quitar_Carga_Simulacion2]
@Cod_Sim2 int,
@cod_Carg int
AS

delete Detalle_Simulacion2
where Cod_Sim2=@Cod_Sim2 and Cod_Carg=@Cod_Carg

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Quitar_Contenedor_Simulacion2]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_Quitar_Contenedor_Simulacion2]
@Cod_sim2 int
AS

delete Detalle_Simulacion2 where Cod_Sim2=@Cod_Sim2
delete Simulacion2 where Cod_Sim2 = @Cod_Sim2

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Transferir_Carga]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_sf_Transferir_Carga] 
@Cod_Fico_d int,
@Cod_Fiin_d int,
@Cod_Carg int
AS

Update Cargas set Cod_Fiin=@Cod_Fiin_d, Cod_fico=@Cod_Fico_d
where Cod_Carg=@Cod_Carg

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Transferir_Fiin]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[Sp_Sf_Transferir_Fiin]  
(  
 @Cod_Fico_o int,  
 @Cod_Fico_d int,  
 @Cod_Fiin_o int, --dicaceres 03/04/2009: Se agrega ficha de ingreso de origen que se copiara en una nueva ficha de ingreso  
 @Usu_Crea varchar(20),  
 @Cod_Emba varchar(11)  
)  
AS  
BEGIN  
  
 declare   
 @cant int,  
 @nro_book varchar(10),  
 @new_fiin int,  
 @Cod_Cons_o char(11),  
 @Cod_Cons_d char(11)  
  
 select @Cod_Cons_o = Cod_Cons from Ficha_Consolidacion where Cod_Fico = @Cod_Fico_o  
  
 select @Cod_Cons_d = Cod_Cons from Ficha_Consolidacion where Cod_Fico = @Cod_Fico_d  
  
 select @nro_book = nro_book from Ficha_Ingreso where Cod_Fiin = @Cod_Fiin_o  
  
 select @cant=count(*) from embarcadores where Cod_Fico = @Cod_Fico_d and Cod_Emba = @Cod_Emba and Nro_Book = @nro_book  
  
 if @cant<=0   
 begin  
  --select @nro_book =nro_book from embarcadores where Cod_fico=@Cod_Fico_o and Cod_Emba=@Cod_Emba  
  Insert Embarcadores(Cod_Fico,Cod_emba,Nro_Book) values(@Cod_Fico_d,@Cod_emba,@Nro_Book)  
 end  
  
 --La ficha que se transfirio se marca como transferida y enviada(para que no genere alerta)  
 update ficha_ingreso set transferido = 1, enviado = 1 where cod_fiin = @Cod_Fiin_o   
  
   
 Insert Ficha_Ingreso(Cod_Fico,Fec_Fiin,Gui_Remi, Usu_Crea, Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr,Est_Fiin,Tip_Fiin,navvia11,codnav08,nro_book)  
 select @Cod_fico_d,getdate(),Gui_Remi, @Usu_Crea, @Cod_Emba,Pla_Vehi,Emb_Nore,Aut_Ingr, Est_Fiin,Tip_Fiin,navvia11,codnav08,nro_book  
 from Ficha_Ingreso where cod_fiin = @Cod_Fiin_o  
  
 set @new_fiin = @@identity  
  
 if @Cod_Cons_o <> @Cod_Cons_d  
  begin  
   update ficha_ingreso set enviado = 0 where Cod_Fiin = @new_fiin --Si es en otro consolidador generar alerta  
  end  
 else  
  begin  
   update ficha_ingreso set enviado = 1 where Cod_Fiin = @new_fiin --Si es en el mismo consolidadro ya no generar alerta  
  end  
 
 --agregado:15-04-2015 
 --la bitacora de la ficha origen, tambien debe migrar a la destino
 Insert [Log](Des_Regi,Cod_Cont,Fec_Regi,Cod_Fico,Cod_Fiin,Cod_Tilo,Nom_Usua)  
 select Des_Regi,Cod_Cont,Fec_Regi,@Cod_Fico_d,@new_fiin,Cod_Tilo,Nom_Usua from [Log] 
 where Cod_Fiin = @Cod_Fiin_o  
 --fin agregado
  
 select @new_fiin  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Almacenes]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_V_Almacenes]
AS
SELECT Cod_alma
	,Nom_Alma
FROM Almacenes (NOLOCK)

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Consolidadores]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_V_Consolidadores] 
@filtro varchar(25)
AS

select contribuy as codigo, nombre as descripcion from terminal..aaconsol02 where nombre like '%'+@filtro +'%'

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Embarcadores]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_Sf_V_Embarcadores]
@filtro varchar(25)
AS

select contribuy as codigo, nombre as descripcion from terminal..aaclientesaa where nombre like '%'+@filtro +'%'

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Puertos]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_Sf_V_Puertos] 
@filtro varchar(25)
AS

select codpue02 as codigo, despue02 as descripcion from descarga.dbo.dqpuerto02 where despue02 like '%'+@filtro +'%'



GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Tamanos_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_V_Tamanos_Contenedor]
AS
SELECT Codtam09 AS Cod_Tama
	,Destam09 AS Nom_Tama
FROM terminal.DBO.Dqtamcon09 (NOLOCK)

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_V_Tipos_Contenedor]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_V_Tipos_Contenedor]
AS
SELECT codtip05 AS Cod_Tipo
	,destip05 AS Nom_Tipo
FROM terminal.DBO.dqtipcon05 (NOLOCK)

GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Validar_DUA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_sf_Validar_DUA] 
@Cod_Carg int
AS
Declare @cant int,
@Dua varchar(13),
@Obs varchar(100),
@result varchar(1),
@Nro_Auto varchar(8),
@Cod_Fiin int


select @Cod_Fiin=Cod_Fiin from Cargas where Cod_Carg=@Cod_Carg

select @Nro_Auto=Aut_Ingr from Ficha_Ingreso where Cod_Fiin=@Cod_Fiin

select @cant=count(notemb16) from descarga.dbo.EDAUTING14 a  , descarga.dbo.ERLLEORD53 b
where a.nroaut14=b.nroaut14 
and a.nroaut14=@Nro_Auto


	If @cant > 0
	begin
		select @Dua=notemb16 from descarga.dbo.EDAUTING14 a ,descarga.dbo.ERLLEORD53 b
		where a.nroaut14=b.nroaut14 and a.nroaut14=@Nro_Auto
	end
	Else
	begin
		--Dua no documentada
		select 'X'
		return
	End 

    

	select @cant=count(NroDua) from terminal.dbo.aduana_LecturaRpt where substring(NroDua,6,6)+substring(NroDua,3,2) = Substring(@Dua, 8, 6) + Substring(@Dua, 4, 2) 

	If @cant > 0 
	begin    
		select @Dua=NroDua, @Obs=Obs  from terminal.dbo.aduana_LecturaRpt where substring(NroDua,6,6)+substring(NroDua,3,2) = Substring(@Dua, 8, 6) + Substring(@Dua, 4, 2) 

		If @Obs= 'ROJO'
		begin
			--Canal Rojo
			select @result='R'
		end
		Else
		begin
			--Canal Naranja
			select @result= 'N'
		End
	end
	Else
	begin
		select @result='C'
		-- Esta Dua Necesita que sea consultada, coordinar con Tesorería
	end

	select @result

-- select @result = 'C'


GO
/****** Object:  StoredProcedure [dbo].[Sp_sf_Validar_DuaEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO TARJAEXPO Nª 15  
ALTER PROCEDURE [dbo].[Sp_sf_Validar_DuaEXPO] 
	@Cod_Carg INT
AS
DECLARE @cant INT
DECLARE @Dua VARCHAR(13)
DECLARE	@Obs VARCHAR(100)
DECLARE	@result VARCHAR(1)
DECLARE	@Nro_Auto VARCHAR(8)
DECLARE	@Cod_Fiin INT

SELECT @Cod_Fiin = Cod_Fiin
FROM Cargas (NOLOCK)
WHERE Cod_Carg = @Cod_Carg

SELECT @Nro_Auto = Aut_Ingr
FROM Ficha_Ingreso (NOLOCK)
WHERE Cod_Fiin = @Cod_Fiin
  
SET @Dua = ''

SELECT @Dua =OBJ.notemb16
FROM descarga.dbo.vw_WebPDAForwaders OBJ
WHERE OBJ.nroaut14=@Nro_Auto
 
IF @DUA = ''
BEGIN
	--Dua no documentada    
	SELECT 'X'

	RETURN
END
 
SELECT @cant = count(NroDua),@Dua = NroDua,@Obs = Obs
FROM terminal.dbo.aduana_LecturaRpt (NOLOCK)
WHERE 
FlagMov='E'
AND DuaWebPDA = Substring(@Dua, 8, 6) + Substring(@Dua, 4, 2)
GROUP BY NroDua,Obs

IF @cant > 0
BEGIN
	--SELECT @Dua = NroDua
	--	,@Obs = Obs
	--FROM terminal.dbo.aduana_LecturaRpt (NOLOCK)
	--WHERE substring(NroDua, 6, 6) + substring(NroDua, 3, 2) = Substring(@Dua, 8, 6) + Substring(@Dua, 4, 2)

	IF @Obs = 'ROJO'
	BEGIN
		--Canal Rojo    
		SELECT @result = 'R'
	END
	ELSE
	BEGIN
		--Canal Naranja    
		SELECT @result = 'N'
	END
END
ELSE
BEGIN
	SELECT @result = 'C'
		--Esta Dua Necesita que sea consultada, coordinar con Tesorería    
END

SELECT @result
	-- select @result = 'C'    
GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_Validar_Usuario]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_Validar_Usuario] 
@Nombre varchar(50),
@Password varchar(50)
AS
Declare @res int
select @res=count(*)  from Usuarios where  nom_usua=@nombre and pas_usua=@Password

if @res<=0 
	select 'X'
Else
    begin
	insert into FWD_LOG_TRANSACCION values (@nombre,getdate())
        select 'A'
    end   

GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_VerificarBooking]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Sf_VerificarBooking] --145,'20504550681','NYC'
(
	@Cod_Fico int,
	@Cod_Emba varchar(11),
	@Nro_Book varchar(6)
)
AS
BEGIN
	-- Store que verifica el bookng respecto a un embarcador
	DECLARE
		@Cod_Pue CHAR(3),
		@Cod_EmbaB varchar(11)

	SELECT @Cod_Pue = Cod_Pue FROM Ficha_Consolidacion (NOLOCK) WHERE Cod_Fico = @Cod_Fico

	SELECT @Cod_EmbaB = codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue

	IF NOT EXISTS(SELECT codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue AND codemc12 = @Cod_Emba)
		BEGIN
			SELECT 1 AS Error, 'El Booking seleccionado no corresponde con el puerto o con el Embarcador' AS DescError
		RETURN
	END

	SELECT 0 AS Error, '' AS DescError

END


GO
/****** Object:  StoredProcedure [dbo].[Sp_Sf_VerificarBookingEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--PROCEDIMIENTO TARJAEXPO Nª 16

ALTER PROCEDURE [dbo].[Sp_Sf_VerificarBookingEXPO]
(      
 @Cod_Fico int,      --17736
 @Cod_Emba varchar(100),     --  
 @Nro_Book varchar(6)  --005555
)      
AS      
BEGIN      
 -- Store que verifica el bookng respecto a un embarcador      
 DECLARE      
  @Cod_Pue CHAR(3),      
  @Cod_EmbaB varchar(11)      

 SELECT @Cod_Pue = Cod_Pue FROM Ficha_Consolidacion (NOLOCK) WHERE Cod_Fico = @Cod_Fico      

 SELECT @Cod_EmbaB = codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue      

 IF NOT EXISTS(SELECT codemc12 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue AND nomemb13 = @Cod_Emba )
  BEGIN    
/*  
	IF @Cod_Emba = (SELECT nomemb13 FROM Descarga.dbo.EDBOOKIN13 WHERE bookin13 = @Nro_Book AND codpue02 = @Cod_Pue)
		BEGIN
			SELECT 1 AS Error, 'El Embarcador seleccionado no corresponde al Booking' AS DescError--,@Cod_EmbaB as EmBarcador     
			RETURN      
		END


END
ELSE BEGIN
*/
	SELECT 1 AS Error, 'El Booking seleccionado no corresponde con el puerto o con el Embarcador' AS DescError--,@Cod_EmbaB as EmBarcador     
	RETURN      
END      

 SELECT 0 AS Error, '' AS DescError--,@Cod_EmbaB as EmBarcador      

END    


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--27 TARJA EXPO
-- ============================================= 
-- Creado por: Eusebio Salinas Miguel 
-- Fecha Creacin: 24/11/2011 
-- Descripcin: Obtiene la fila que indica que firma o no firma y ruta de firmas de la tarja
-- Modificado por:
-- Fecha de Modificacion:
-- EXEC TEXPO_SP_BUSCAR_TARJA_IMPRESION 55
-- ============================================= 
--SELECT *  FROM  descarga.dbo.DDCABMAN11
--SELECT *  FROM  descarga.dbo.DQNAVIER08
--SELECT *  FROM  descarga.dbo.AACLIENTESAA
ALTER PROCEDURE [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION]
(@pCod_Fiin integer )
AS
BEGIN 

		SELECT	FI.Cod_Fiin ,		FI.Cod_Fico ,	FI.Fec_Fiin,	FI.Gui_Remi ,
				FI.Usu_Crea ,		FI.Cod_Emba,	FI.Des_Carg,	FI.Pla_Vehi , 
				FI.Emb_Nore,		Aut_Ingr,		FI.Est_Fiin ,	FI.Tip_Fiin ,
				FI.navvia11 ,		FI.codnav08 ,	FI.nro_book,	FI.navvia11_old, 
				FI.transferido,		FI.enviado,		FI.vch_TipoRegimen , 
                S.desnav08 AS Nave, R.numvia11 AS Viaje , 
				CLI.NOMBRE AS Nom_Emba,
				'' AS Nom_Dest
		FROM FICHA_INGRESO FI

		LEFT JOIN descarga.dbo.DDCABMAN11 AS  R ON (FI.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = R.navvia11 )
        LEFT JOIN descarga.dbo.DQNAVIER08 AS  S ON (FI.codnav08 COLLATE SQL_Latin1_General_CP1_CI_AS = S.codnav08 )
		LEFT JOIN descarga.dbo.AACLIENTESAA AS CLI ON (FI.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = CLI.CONTRIBUY )
		WHERE FI.Cod_Fiin = @pCod_Fiin


		SELECT		(SELECT COUNT(1) FROM CARGAS C_RI WHERE C_RI.Cod_Fiin = @pCod_Fiin AND C_RI.Cod_Carg <= C.Cod_Carg ) as Nro,
					C.Cod_Carg,  C.Cod_Fico ,	C.Cod_Fiin, C.Po_Carg,
					C.Sty_Carg,  C.Can_Carg,	C.Pes_Carg, C.Alt_Carg, 
					C.Anc_Carg,  C.Lar_Carg,	C.Cod_Tica, C.Des_Carg,
					C.Cod_Fior,  C.Cod_Fiio,	C.Cod_Cont, C.Ubi_Alma, 
					C.Est_Carg,  C.Ing_Nept,	C.Cod_Prod, C.Flg_Impr, 
					C.ubi_conte, C.marca,		C.lpn  , '' as  Caja_Carg
		FROM CARGAS C
		WHERE C.Cod_Fiin = @pCod_Fiin
		
		

		EXEC TEXPO_SP_OBTENER_DATOS_USUARIO @pCod_Fiin

END



GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_CABECERA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--23 TARJA EXPO  
-- =============================================         
-- select * from Ficha_Consolidacion where cod_cons = '20295070588'      
-- select * from usuarios where cod_cons = '20511536007'      
-- select * from Contenedores      
--Creado por: Quispe a.        
-- Fecha Creacin: 11/04/2012        
-- Descripcin: Lista cabecera  de tarja expo        
-- Modificado por:        
-- Fecha de Modificacion:        
-- EXEC TEXPO_SP_BUSCAR_TARJA_IMPRESION_CABECERA '9853'        
-- =============================================         
--SELECT *  FROM  descarga.dbo.DDCABMAN11        
--SELECT *  FROM  descarga.dbo.DQNAVIER08        
--SELECT *  FROM  descarga.dbo.AACLIENTESAA        
ALTER PROCEDURE [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_CABECERA] --10109        
	(@pCod_Fiin INTEGER)
AS
BEGIN
	DECLARE @VALOR CHAR(1)
	SELECT @VALOR=Est_Fiin FROM Ficha_Ingreso WHERE Cod_Fiin =@pCod_Fiin
	
	IF @VALOR='A'
	BEGIN
		EXEC Sp_Sf_Cerrar_FiinEXPO @pCod_Fiin
	END


	SELECT FI.Cod_Fiin
		,FI.Cod_Fico
		,FI.Fec_Fiin
		,FI.Gui_Remi
		,FI.Usu_Crea
		,FI.Cod_Emba
		,FI.Des_Carg
		,FI.Pla_Vehi
		,FI.Emb_Nore
		,Aut_Ingr
		,FI.Est_Fiin
		,FI.Tip_Fiin
		,FI.navvia11
		,FI.codnav08
		,FI.nro_book
		,FI.navvia11_old
		,FI.Aut_Ingr
		,FI.transferido
		,FI.enviado
		,FI.vch_TipoRegimen
		,isnull(U.Nom_Comp, '') Nom_Comp
		,FC.Cod_Cons
		,FC.cod_pue
		,CLI.NOMBRE
		,S.desnav08 AS Nave
		,R.numvia11 AS Viaje
		,isnull(CTN.Cod_Cont, 'CTRnoRegis') AS Cod_Cont
		,CLI2.NOMBRE AS AgentAduana
		,CLI.NOMBRE AS Nom_Emba
		,'' AS Nom_Dest
		,'' AS Linea
		,-- EB.codarm10 as Linea,       
		FI.Fec_Fiin AS FinOperacion
		,--ED.fectra99 as FinOperacion ,   
		CLI3.NOMBRE AS Nom_Cons
	FROM Ficha_Consolidacion FC
	INNER JOIN FICHA_INGRESO FI ON (FC.Cod_Fico = FI.Cod_Fico)
	--INNER JOIN descarga.dbo.EDBOOKIN13 EB on (EB.bookin13=FI.nro_book and FC.navvia11=EB.navvia11 and FC.cod_pue COLLATE SQL_Latin1_General_CP1_CI_AS = EB.codpue02)        
	LEFT JOIN Contenedores CTN ON (CTN.Cod_Fico = FC.Cod_Fico)
	INNER JOIN descarga.dbo.DDCABMAN11 AS R ON (FI.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS = R.navvia11)
	INNER JOIN descarga.dbo.DQNAVIER08 AS S ON (FI.codnav08 COLLATE SQL_Latin1_General_CP1_CI_AS = S.codnav08)
	INNER JOIN descarga.dbo.AACLIENTESAA AS CLI ON (FI.Cod_Emba COLLATE SQL_Latin1_General_CP1_CI_AS = CLI.CONTRIBUY)
	INNER JOIN descarga.dbo.edauting14 AS ED ON (ED.nroaut14 COLLATE SQL_Latin1_General_CP1_CI_AS = FI.Aut_Ingr)
	INNER JOIN descarga.dbo.AACLIENTESAA AS CLI2 ON (ED.codage19 COLLATE SQL_Latin1_General_CP1_CI_AS = CLI2.CONTRIBUY)
	INNER JOIN descarga.dbo.AACLIENTESAA AS CLI3 ON (FC.Cod_Cons COLLATE SQL_Latin1_General_CP1_CI_AS = CLI3.CONTRIBUY)
	LEFT JOIN USUARIOS U ON (FC.Cod_Cons = U.Cod_Cons)
	WHERE FI.Cod_Fiin = @pCod_Fiin
END

GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_DETALLE]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_DETALLE]      
(@pCod_Fiin integer )      
AS      
BEGIN       
      
      
        
  SELECT  (SELECT COUNT(1) FROM CARGAS C_RI WHERE C_RI.Cod_Fiin = @pCod_Fiin AND C_RI.Cod_Carg <= C.Cod_Carg ) as Nro,      
     C.Cod_Carg,  C.Cod_Fico , C.Cod_Fiin, C.Po_Carg,      
     C.Sty_Carg,  C.Can_Carg, C.Pes_Carg, C.Alt_Carg,       
     C.Anc_Carg,  C.Lar_Carg, C.Cod_Tica, C.Des_Carg,      
     C.Cod_Fior,  C.Cod_Fiio, C.Cod_Cont, C.Ubi_Alma,       
     C.Est_Carg,  C.Ing_Nept, C.Cod_Prod, C.Flg_Impr,      
     C.ubi_conte, C.marca,  LTRIM(RTRIM(C.lpn)) as lpn  , '' as  Caja_Carg,C. Est_Carg as EstadoLPN,TC.Des_Tica      
  FROM CARGAS C INNER JOIN dbo.Tipo_Carga TC      
  ON C.Cod_Tica=TC.Cod_Tica      
  WHERE C.Cod_Fiin = @pCod_Fiin      
  ORDER BY C.lpn, TC.Des_Tica    
END    
    
GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_FIRMA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--30 TARJA EXPO
-- ============================================= 
-- Creado por: Quispe Ambrosio Josè.
-- Fecha Creacin: 12/04/2012
-- Descripcin: Lista detalle  de tarja expo
-- Modificado por:
-- Fecha de Modificacion:
-- EXEC TEXPO_SP_BUSCAR_TARJA_IMPRESION_FIRMA '9853'
-- ============================================= 
--SELECT *  FROM  descarga.dbo.DDCABMAN11
--SELECT *  FROM  descarga.dbo.DQNAVIER08
--SELECT *  FROM  descarga.dbo.AACLIENTESAA
ALTER PROCEDURE [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_FIRMA]
(@pCod_Fiin integer )
AS
BEGIN 
	
		EXEC TEXPO_SP_OBTENER_DATOS_USUARIO @pCod_Fiin

END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_LPN_DISTINTOS]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--17 TARJA EXPO
-- ============================================= 
-- Creado por: Quispe a.
-- Fecha Creacin: 12/04/2012
-- Descripcin: Lista detalle  de tarja expo
-- Modificado por:
-- Fecha de Modificacion:
-- EXEC TEXPO_SP_BUSCAR_TARJA_IMPRESION_LPN_DISTINTOS '9936'
-- ============================================= 
--SELECT *  FROM  descarga.dbo.DDCABMAN11
--SELECT *  FROM  descarga.dbo.DQNAVIER08
--SELECT *  FROM  descarga.dbo.AACLIENTESAA
ALTER PROCEDURE [dbo].[TEXPO_SP_BUSCAR_TARJA_IMPRESION_LPN_DISTINTOS]
(@pCod_Fiin integer )
AS
BEGIN 

DECLARE @CountLPN    VARCHAR(50)  
---------------------------------------------
		SELECT @CountLPN = COUNT(DISTINCT lpn)  FROM dbo.CARGAS 
		WHERE  Cod_Fiin = @pCod_Fiin
------------------------------------------
SELECT @CountLPN as  LPN_Dist
		
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_CARGAR_DATOS_EXPO_MOVIL]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
ALTER PROCEDURE [dbo].[TEXPO_SP_CARGAR_DATOS_EXPO_MOVIL]  
AS  
BEGIN   
  
  --carga para la tabla "Tipo_carga"  
  EXEC Sp_Sf_Dev_Tipos_Carga   
  
  --carga para la tabla "producto"  
  EXEC Sp_sf_dev_Productos  
  
  --obteniene las fichas de consolidacion "Ficha_Consolidacion"  
  EXEC TEXPO_SP_OBTENER_FICHA_CONSOLIDACION  
  
  --Obtiene los embarcadores tabla "Embarcadores"  
  EXEC TEXPO_SP_OBTENER_EMBARCADORES   
    
  --Obtiene las cargas tabla "Cargas"  
  EXEC TEXPO_SP_OBTENER_CARGA  
  
  --Obtiene las fichas de ingreso tabla "Ficha_Ingreso"  
  EXEC TEXPO_SP_OBTENER_FICHA_INGRESO  
  
  --Obtiene los datos de autorizacion   
  EXEC TEXPO_SP_OBTENER_EDAUTING14   
  
  --Obtiene los datos de nave viaje  
  EXEC TEXPO_SP_OBTENER_DDCABMAN11  
  
  --Obtiene los datos de Clientes   
  EXEC TEXPO_SP_OBTENER_AACLIENTESAA  
  
  --Obtiene los datos para tabla dqpuerto02  
  EXEC TEXPO_SP_OBTENER_DQPUERTO02  
  
  --Obtiene los datos para tabla aaconsol02  
  EXEC TEXPO_SP_OBTENER_AACONSOL02  
  
  --Obtiene los datos para tabla dqnavier08  
  EXEC TEXPO_SP_OBTENER_DQNAVIER08  
  
  --Obtiene los datos para tabla contenedores  
  EXEC TEXPO_SP_OBTENER_CONTENEDORES  
  
  --Obtiene los almancees   
  EXEC TEXPO_SP_OBTENER_ALMACENES   
          
        -- Obtiene los datos para tabla DQTAMCON09  
  EXEC  TEXPO_SP_OBTENER_DQTAMCON09  
              
  -- Obtiene los datos para tabla DQTIPCON05   
  EXEC  TEXPO_SP_OBTENER_DQTIPCON05   
  
  -- Obtiene los datos para tabla TipoRegimen  
  EXEC TEXPO_SP_OBTENER_TIPO_REGIMEN  
  
  --Obtiene las impresoras  
  EXEC TMAN_SP_BUSCAR_IMPRESORAS NULL  
   
  --Obtiene los po style   
  EXEC TEXPO_SP_OBTENER_PO_STYLE  
  
    
END  
  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_DESCARGA_DATOS_EXPO_PC]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--25 TARJA EXPO  
-- =============================================   
-- Creado por: Miguel E S  
-- Fecha Creacion: 16/11/2011   
-- Descripcion: Descarga de datos de importaciones modulo PC  
-- Modificado por:  
-- Fecha de Modificacion:  
-- [TEXPO_SP_DESCARGA_DATOS_EXPO_PC] '','' , ''  
-- =============================================   
ALTER PROCEDURE [dbo].[TEXPO_SP_DESCARGA_DATOS_EXPO_PC] (
	@pXml_FichaIngreso TEXT
	,@pXml_DetalleFicha TEXT
	,@pvch_CodUsuario VARCHAR(20)
	,@pint_CodError INTEGER OUTPUT
	,@pvch_DscError VARCHAR(200) OUTPUT
	,@pvch_ResultadoFicha VARCHAR(5000) OUTPUT
	,@pvch_ResultadoCarg VARCHAR(5000) OUTPUT
	)
AS
BEGIN
	SET XACT_ABORT ON
	SET @pint_CodError = 0
	SET @pvch_DscError = 'Ok'

	SET @pvch_ResultadoFicha=''
	SET @pvch_ResultadoCarg=''

	/*
	DECLARE @IdDocXml INTEGER
	DECLARE @Cod_Fiin INTEGER
	DECLARE @Cod_Fico INTEGER
	DECLARE @Fec_Fiin DATETIME
	DECLARE @Fec_FiinDescarga VARCHAR(50)
	DECLARE @Gui_Remi VARCHAR(20)
	DECLARE @Usu_Crea VARCHAR(20)
	DECLARE @Cod_Emba VARCHAR(11)
	DECLARE @Pla_Vehi VARCHAR(7)
	DECLARE @Emb_Nore VARCHAR(11)
	DECLARE @Aut_Ingr VARCHAR(8)
	DECLARE @Est_Fiin VARCHAR(10)
	DECLARE @Tip_Fiin VARCHAR(10)
	DECLARE @Cod_Nave VARCHAR(4)
	DECLARE @Num_Viaje VARCHAR(6)
	DECLARE @Nro_Book VARCHAR(6)
	DECLARE @TipoRegimen VARCHAR(20)
	DECLARE @bit_Nuevo INTEGER
	DECLARE @bit_Modificado INTEGER
	DECLARE @bit_Descargado INTEGER

	EXEC sp_xml_preparedocument @IdDocXml OUT
		,@pXml_FichaIngreso

	SELECT Cod_Fiin
		,Cod_Fico
		,Fec_FiinDescarga
		,Gui_Remi
		,Usu_Crea
		,Cod_Emba
		,Pla_Vehi
		,Emb_Nore
		,Aut_Ingr
		,Est_Fiin
		,Tip_Fiin
		,Cod_Nave
		,Num_Viaje
		,Nro_Book
		,TipoRegimen
		,bit_Nuevo
		,bit_Modificado
		,bit_Descargado
	INTO #TMPFICHAINGRESO
	FROM OPENXML(@IdDocXml, '/FichaIngreso/FichaIngreso', 2) WITH (
			Cod_Fiin INTEGER
			,Cod_Fico INTEGER
			,Fec_FiinDescarga VARCHAR(50)
			,Gui_Remi VARCHAR(20)
			,Usu_Crea VARCHAR(20)
			,Cod_Emba VARCHAR(11)
			,Pla_Vehi VARCHAR(7)
			,Emb_Nore VARCHAR(11)
			,Aut_Ingr VARCHAR(8)
			,Est_Fiin VARCHAR(10)
			,Tip_Fiin VARCHAR(10)
			,Cod_Nave VARCHAR(4)
			,Num_Viaje VARCHAR(6)
			,Nro_Book VARCHAR(6)
			,TipoRegimen VARCHAR(20)
			,bit_Nuevo INTEGER
			,bit_Modificado INTEGER
			,bit_Descargado INTEGER
			)

	DECLARE CURFICHAINGRESO CURSOR
	FOR
	SELECT Cod_Fiin
		,Cod_Fico
		,Fec_FiinDescarga
		,Gui_Remi
		,Usu_Crea
		,Cod_Emba
		,Pla_Vehi
		,Emb_Nore
		,Aut_Ingr
		,Est_Fiin
		,Tip_Fiin
		,Cod_Nave
		,Num_Viaje
		,Nro_Book
		,TipoRegimen
		,bit_Nuevo
		,bit_Modificado
		,bit_Descargado
	FROM #TMPFICHAINGRESO

	OPEN CURFICHAINGRESO

	-- Cargar registro                  
	FETCH NEXT
	FROM CURFICHAINGRESO
	INTO @Cod_Fiin
		,@Cod_Fico
		,@Fec_FiinDescarga
		,@Gui_Remi
		,@Usu_Crea
		,@Cod_Emba
		,@Pla_Vehi
		,@Emb_Nore
		,@Aut_Ingr
		,@Est_Fiin
		,@Tip_Fiin
		,@Cod_Nave
		,@Num_Viaje
		,@Nro_Book
		,@TipoRegimen
		,@bit_Nuevo
		,@bit_Modificado
		,@bit_Descargado

	WHILE @@fetch_status = 0
	BEGIN
		--Actualizar Cabeceras  
		DECLARE @vCod_Fiin INTEGER

		/*----------------------Actualizar Cabecera-----------------------------------*/
		IF @bit_Descargado = 0 --Si no esta descargado descargar(actualizar) cabecera de la tarja  
		BEGIN
			IF @bit_Nuevo = 1
			BEGIN
				PRINT 'BOOKING : ' + cast(@Nro_Book AS VARCHAR)

				INSERT Ficha_Ingreso (
					Cod_Fico
					,Fec_Fiin
					,Gui_Remi
					,Usu_Crea
					,Cod_Emba
					,Pla_Vehi
					,Emb_Nore
					,Aut_Ingr
					,Est_Fiin
					,Tip_Fiin
					,navvia11
					,codnav08
					,Nro_Book
					,vch_TipoRegimen
					)
				VALUES (
					@Cod_fico
					,@Fec_FiinDescarga
					,@Gui_Remi
					,@Usu_Crea
					,@Cod_Emba
					,@Pla_Vehi
					,@Emb_Nore
					,@Aut_ingr
					,@Est_Fiin
					,@Tip_Fiin
					,@Num_Viaje
					,@Cod_Nave
					,@Nro_Book
					,@TipoRegimen
					)

				SELECT @vCod_Fiin = Scope_Identity()

				IF LEN(ISNULL(@pvch_ResultadoFicha, '')) = 0
				BEGIN
					SET @pvch_ResultadoFicha = cast(@Cod_Fiin AS VARCHAR) + ',' + cast(@vCod_Fiin AS VARCHAR)
				END
				ELSE
				BEGIN
					SET @pvch_ResultadoFicha = @pvch_ResultadoFicha + '-' + cast(@Cod_Fiin AS VARCHAR) + ',' + cast(@vCod_Fiin AS VARCHAR)
				END

				UPDATE Ficha_Consolidacion
				SET navvia11 = @Num_Viaje
				WHERE Cod_Fico = @Cod_Fico
			END
			ELSE
			BEGIN -- @bit_Modificado = 1  
				UPDATE Ficha_Ingreso
				SET Gui_Remi = @Gui_Remi
					,Usu_Crea = @Usu_Crea
					,Cod_Emba = @Cod_Emba
					,Pla_Vehi = @Pla_Vehi
					,Emb_Nore = @Emb_Nore
					,Aut_Ingr = @Aut_Ingr
					,Nro_Book = @Nro_Book
					,vch_TipoRegimen = @TipoRegimen
				WHERE Cod_Fiin = @Cod_fiin

				SET @vCod_Fiin = @Cod_Fiin
			END
		END
		ELSE
		BEGIN
			SET @vCod_Fiin = @Cod_Fiin
		END

		/*-------------------------------------------------------------------------------------*/
		/*-----------------------Actualizar Detalle-----------------------------------------*/
		EXEC [TEXPO_SP_GUARDAR_CARGAS_TARJA] @pXml_DetalleFicha
			,@Cod_Fiin
			,@vCod_Fiin
			,@pvch_CodUsuario
			,@pint_CodError OUTPUT
			,@pvch_DscError OUTPUT
			,@pvch_ResultadoCarg OUTPUT

		IF @Est_Fiin = 'C'
		BEGIN
			EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_ASNEXPO @vCod_Fiin,'INT2.INT002'

			EXEC BD_WMS_FWD_PROD.dbo.TGEN_SP_INSERTAR_TARJAFINALIZADAS_EXPO @vCod_Fiin,'INT2.INT001' /*Añadido 13/08/2013*/
		END

		-- Avanza un registro                  
		FETCH NEXT
		FROM CURFICHAINGRESO
		INTO @Cod_Fiin
			,@Cod_Fico
			,@Fec_FiinDescarga
			,@Gui_Remi
			,@Usu_Crea
			,@Cod_Emba
			,@Pla_Vehi
			,@Emb_Nore
			,@Aut_Ingr
			,@Est_Fiin
			,@Tip_Fiin
			,@Cod_Nave
			,@Num_Viaje
			,@Nro_Book
			,@TipoRegimen
			,@bit_Nuevo
			,@bit_Modificado
			,@bit_Descargado
	END

	-- Se cierra el cursor                  
	CLOSE CURFICHAINGRESO

	DEALLOCATE CURFICHAINGRESO

	--Liberar                  
	EXEC sp_xml_removedocument @IdDocXml

	DROP TABLE #TMPFICHAINGRESO
	*/
END

GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_GUARDAR_CARGAS_TARJA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--24 TARJA EXPO
/*            
Creacion:            
 meusebio            
DESCARGA: registro de cargas    
*/             
            
ALTER PROCEDURE [dbo].[TEXPO_SP_GUARDAR_CARGAS_TARJA]                   
(                    
       @pXml_DetalleFicha  TEXT ,      
    @pCod_Fiin       int ,     
    @pCod_FiinFinal      int ,         
    @pvch_CodUsuario   varchar(20),     
    @pint_CodError   int output,     
    @pvch_DscError   varchar(200) output  ,    
    @pvch_ResultadoCarg      varchar(5000) Output                  
)                    
AS                    
BEGIN           
             
DECLARE @vCod_Cons varchar(50)    
DECLARE @vCod_ConsAPL VARCHAR (50)     
    
    
SELECT @vCod_Cons = FC.Cod_Cons FROM Ficha_Consolidacion FC     
INNER JOIN FICHA_INGRESO FI ON (FC.Cod_Fico = FI.Cod_Fico)    
WHERE FI.Cod_Fiin = @pCod_FiinFinal    
    
SET @vCod_ConsAPL = '00000000235'    
    
SET     @pint_CodError = 0           
DECLARE @IdDocXml1 Integer     
    
DECLARE @Cod_Carg integer    
DECLARE @Cod_Fico integer      
DECLARE @Cod_Fiin integer     
DECLARE @Po_Carg varchar(10)      
DECLARE @Sty_Carg varchar(10)    
DECLARE @Can_Carg integer      
DECLARE @Pes_Carg decimal(9,2)    
DECLARE @Alt_Carg decimal(9,2)    
DECLARE @Anc_Carg decimal(9,2)      
DECLARE @Lar_Carg decimal(9,2)      
DECLARE @Cod_Tica integer    
DECLARE @Des_Carg varchar(50)      
DECLARE @Ubi_Alma varchar(10)      
DECLARE @Est_Carg varchar(1)      
DECLARE @Ing_Nept varchar(1)      
DECLARE @Cod_Prod varchar(5)    
DECLARE @Marca varchar(100)      
DECLARE @Lpn varchar(50)    
DECLARE @bit_Nuevo  integer     
DECLARE @bit_Modificado  integer     
                                 
 EXEC sp_xml_preparedocument @IdDocXml1 OUT, @pXml_DetalleFicha                    
                     
 SELECT Cod_Carg , Cod_Fico, Cod_Fiin, Po_Carg,     
  Sty_carg, Can_Carg, Pes_Carg, Alt_Carg,    
  Anc_Carg,Lar_Carg,Cod_Tica,Des_Carg,    
  Ubi_Alma,Est_Carg,Ing_Nept,Cod_prod,    
  Marca, Lpn , bit_Nuevo, bit_Modificado    
    
 INTO #TMPCARGAS                
 FROM OPENXML (@IdDocXml1, '/Cargas/Cargas', 2)                    
 WITH  (    
  Cod_Carg integer ,     
  Cod_Fico integer ,      
  Cod_Fiin integer ,     
  Po_Carg  varchar(10) ,      
  Sty_Carg varchar(10) ,     
  Can_Carg integer ,     
  Pes_Carg decimal(9,2) ,     
  Alt_Carg decimal(9,2) ,     
  Anc_Carg decimal(9,2) ,     
  Lar_Carg decimal(9,2) ,      
  Cod_Tica integer ,     
  Des_Carg varchar(50) ,       
  Ubi_Alma varchar(10) ,     
  Est_Carg varchar(1) ,    
  Ing_Nept varchar(1) ,    
  Cod_Prod varchar(5) ,    
  Marca  varchar(100) ,    
  Lpn   varchar(50) ,     
        bit_Nuevo integer ,    
        bit_Modificado integer    
 )                
    
    
    
    
--Obtiene los verdaderos LPNs generados desde BD y reemplazo los LPNs temporales generados en movil    
--Esto para todos los casos excepto para consignatario ALP que sus LPNs se ingresan manualmente    
IF @vCod_Cons <> @vCod_ConsAPL --Consignatario general    
BEGIN     
 DECLARE @vLPN varchar(50)    
 DECLARE @vintMaxRegistro integer     
 DECLARE @vintActualRegistro integer     
    
 DECLARE @vLPNAux varchar(50)    
    
 DECLARE @TMPLPN TABLE     
 ( int_Secuencial integer identity (1,1),    
  Lpn varchar(50),    
  bit_Nuevo integer     
  )     
    
 INSERT INTO @TMPLPN (Lpn, bit_Nuevo)    
 SELECT Lpn , bit_Nuevo FROM #TMPCARGAS     
 WHERE  Cod_Fiin  =   @pCod_Fiin AND isnull(bit_Nuevo,0)  = 1    
 GROUP BY Lpn, bit_Nuevo --Se agrupan por LPNs    
    
 SELECT @vintMaxRegistro = COUNT(*) FROM @TMPLPN    
 SET @vintActualRegistro = 1    
    
 WHILE @vintActualRegistro < = @vintMaxRegistro    
 BEGIN     
    
  SET  @vLPN = ''    
  SELECT @vLPNAux = Lpn     
  FROM @TMPLPN    
  WHERE int_Secuencial = @vintActualRegistro    
      
  SET @vLPN = dbo.TGEN_FN_OBTENER_CORRELATIVO ( NULL, NULL , 'LPNEXPO')    
  UPDATE BD_WMS_FWD_PROD.dbo.TGEN_TB_CORRELATIVO SET int_Valor = int_Valor + 1     
  WHERE vch_CodigoIdentificador = 'LPNEXPO'--Actualiza el correlativo    
      
  --Actualiza con el LPN generado el/los LPNs auxiliares/temporales de movil    
  UPDATE #TMPCARGAS SET Lpn = @vLPN     
  WHERE     
  Cod_Fiin  =   @pCod_Fiin     
  AND Lpn = @vLPNAux      
  AND isnull(bit_Nuevo,0) = 1    
       
  SET  @vintActualRegistro = @vintActualRegistro + 1     
    
 END      
END      
    
DECLARE CURCARGAS CURSOR FOR                    
 SELECT Cod_Carg , Cod_Fico, Cod_Fiin, Po_Carg,     
  Sty_carg, Can_Carg, Pes_Carg, Alt_Carg,    
  Anc_Carg,Lar_Carg,Cod_Tica,Des_Carg,    
  Ubi_Alma,Est_Carg,Ing_Nept,Cod_Prod,    
  Marca, Lpn , bit_Nuevo, bit_Modificado           
            
 FROM #TMPCARGAS  WHERE   Cod_Fiin  =   @pCod_Fiin     /*Solo las fichas*/       
 OPEN CURCARGAS                    
    
    
 -- Cargar registro                    
 FETCH NEXT FROM CURCARGAS         
      
  INTO   @Cod_Carg , @Cod_Fico , @Cod_Fiin , @Po_Carg ,     
   @Sty_Carg , @Can_Carg , @Pes_Carg , @Alt_Carg ,     
   @Anc_Carg ,@Lar_Carg ,  @Cod_Tica , @Des_Carg ,     
   @Ubi_Alma , @Est_Carg , @Ing_Nept , @Cod_Prod ,     
   @Marca , @Lpn ,  @bit_Nuevo, @bit_Modificado    
               
 WHILE @@fetch_status = 0                    
 BEGIN        
	DECLARE @Cod_CargNuevo integer    
	
	-- Movil: Si Marca tiene "|", se elimino la carga por movil...
	DECLARE @Cod_CargTemp integer 
	DECLARE @bit_Eliminado int
	set @bit_Eliminado= CHARINDEX('|',@Marca)
	SET @Marca= REPLACE(@Marca,'|','')

  IF isnull(@bit_Nuevo,0) = 1  
        BEGIN      
          
     print 'MARCA:  ' + cast (isnull(@Marca,'') as varchar)    
     INSERT INTO Cargas( Cod_Fico,Cod_Fiin,Po_Carg,    
          Sty_carg,Can_Carg,Pes_Carg,    
          Alt_Carg,Anc_Carg,Lar_Carg,    
          Cod_Tica,Des_Carg,Cod_Fior,    
          Cod_fiio,Ubi_Alma,Est_Carg,    
          Ing_Nept,Cod_prod,flg_Impr,    
          Marca, lpn)      
     VALUES   ( @Cod_Fico,@pCod_FiinFinal,@Po_Carg,    
          @Sty_carg,@Can_Carg,@Pes_Carg,    
          @Alt_Carg,@Anc_Carg,@Lar_Carg,    
          @Cod_Tica,@Des_Carg,@Cod_Fico,    
          @pCod_FiinFinal,@Ubi_Alma,@Est_Carg,    
          @Ing_Nept,@Cod_prod,0,    
          @Marca, @Lpn)      
      
     
     SET @Cod_CargNuevo = scope_identity()    
     IF len( isnull(@pvch_ResultadoCarg, '') ) = 0    
     BEGIN     
       SET @pvch_ResultadoCarg = cast ( @Cod_Carg  as varchar)+ ',' + cast( @Cod_CargNuevo as varchar)+ ',' + cast(@Cod_Fiin as varchar) + ','+ cast(@pCod_FiinFinal  as varchar)    
     END    
     ELSE    
     BEGIN    
            SET @pvch_ResultadoCarg = @pvch_ResultadoCarg + '-'+cast ( @Cod_Carg  as varchar)+ ',' + cast( @Cod_CargNuevo as varchar)+ ',' + cast(@Cod_Fiin as varchar) + ','+ cast(@pCod_FiinFinal  as varchar)    
     END    
		
	 SET @Cod_CargTemp=@Cod_CargNuevo      
  END    
  ELSE    
  BEGIN  
          
     UPDATE Cargas      
     SET Po_Carg=@Po_Carg,    
      Sty_carg=@Sty_Carg,    
      Can_Carg=@Can_Carg,    
      Pes_Carg=@Pes_Carg,    
      Alt_Carg=@Alt_Carg,    
      Anc_Carg=@Anc_Carg,    
      Lar_Carg=@Lar_Carg,    
      Cod_Tica=@Cod_Tica,    
      Des_Carg=@Des_Carg,     
      Ubi_Alma=@Ubi_Alma,     
      Est_Carg=@Est_Carg,     
      Ing_Nept=@Ing_Nept,    
      Cod_prod=@Cod_prod,    
      Marca=@Marca ,     
      lpn =  (CASE WHEN @vCod_Cons = @vCod_ConsAPL THEN   @Lpn  ELSE lpn END)    
     WHERE Cod_Carg=@Cod_Carg      
      --Cuando es APL es editable, cuando es general no es editable   
      
     SET @Cod_CargTemp= @Cod_Carg
  END    
    
                      
  -- Avanza un registro                    
  FETCH NEXT FROM CURCARGAS                   
  INTO      @Cod_Carg , @Cod_Fico , @Cod_Fiin , @Po_Carg ,     
   @Sty_Carg , @Can_Carg , @Pes_Carg , @Alt_Carg ,     
   @Anc_Carg ,@Lar_Carg ,  @Cod_Tica , @Des_Carg ,     
   @Ubi_alma , @Est_Carg , @Ing_Nept , @Cod_Prod ,     
   @Marca , @Lpn ,  @bit_Nuevo, @bit_Modificado    
   
   --Logica de Eliminacion: Movil--
   IF(isnull(@bit_Eliminado,0)>0)
   BEGIN
	INSERT dbo.Cargas_Eliminado(Cod_Carg,Cod_Fico,Cod_Fiin,Po_Carg,Sty_Carg,Can_Carg,Pes_Carg,Alt_Carg,Anc_Carg,
				Lar_Carg,Cod_Tica,Des_Carg,Cod_Fior,Cod_Fiio,Cod_Cont,Ubi_Alma,Est_Carg,Ing_Nept,Cod_Prod,
				Flg_Impr,ubi_conte,marca,lpn)
	SELECT Cod_Carg,Cod_Fico,Cod_Fiin,Po_Carg,Sty_Carg,Can_Carg,Pes_Carg,Alt_Carg,Anc_Carg,
				Lar_Carg,Cod_Tica,Des_Carg,Cod_Fior,Cod_Fiio,Cod_Cont,Ubi_Alma,Est_Carg,Ing_Nept,Cod_Prod,
				Flg_Impr,ubi_conte,marca,lpn
	FROM dbo.Cargas WHERE Cod_Carg=@Cod_CargTemp

	DELETE FROM dbo.Cargas where Cod_Carg=@Cod_CargTemp
   END
   
 END                    
                    
 -- Se cierra el cursor                    
 CLOSE CURCARGAS                
 DEALLOCATE CURCARGAS                 
                      
 --Liberar                    
 EXEC sp_xml_removedocument @IdDocXml1                    
 DROP TABLE #TMPCARGAS                
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_LISTAR_PO_STYLE]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--12 TARJA EXPO
-- =============================================        
-- Creado por:  Miguel Eusebio S    
-- Fecha Creación: 08/11/2011        
-- Descripción: Carga PO Style    
-- Modificado por:    
-- Fecha de Modificación:    
-- TEXPO_SP_LISTAR_PO_STYLE ''        
-- =============================================      
ALTER PROCEDURE [dbo].[TEXPO_SP_LISTAR_PO_STYLE]    
(@pvch_NumBooking Varchar(50)    
)    
AS    
BEGIN     
 --Lista de PO    
 SELECT  Distinct    
   vch_Po  
 FROM BD_WMS_FWD_PROD.dbo.TEXPO_TB_POSTYLE   WHERE vch_NumBooking = @pvch_NumBooking  
    
 --Lista de Style    
 SELECT  Distinct      
   vch_Style   
 FROM BD_WMS_FWD_PROD.dbo.TEXPO_TB_POSTYLE   WHERE vch_NumBooking = @pvch_NumBooking  
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_AACLIENTESAA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--3 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_AACLIENTESAA]
 AS  
 
	SELECT *
	FROM descarga.dbo.AACLIENTESAA
	--where fecaut14 =getdate()


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_AACONSOL02]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--6 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_AACONSOL02]
 AS  
 
	select *  from TERMINAL.dbo.AACONSOL02
	

GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_ALMACENES]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--20 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_ALMACENES]
AS
BEGIN 
 SELECT  * FROM ALMACENES
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_CARGA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--1 TARJA EXPO  
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_CARGA]    
 AS    
   
  SELECT TOP 1200 * ,  
   0 as  bit_Nuevo,0 as bit_Modificado ,1 as  bit_Descargado   
  FROM CARGAS  
  ORDER BY cod_carg desc
  
GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_CONTENEDORES]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--15 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_CONTENEDORES]  
AS  
select Cod_Cont ,Cod_Fico, Cod_Alma, 
Cod_Tipo, Cod_Tama, Est_Cont,  isnull (payload , 0.00) payload , Precinto from Contenedores


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DATOS_USUARIO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--26 TARJA EXPO
-- =============================================   
-- Creado por: Eusebio Salinas Miguel   
-- Fecha Creacin: 24/11/2011   
-- Descripcin: Obtiene la fila que indica que firma o no firma y ruta de firmas de la tarja  
-- Modificado por:  
-- Fecha de Modificacion:  
-- =============================================   
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DATOS_USUARIO]    
(  
@pCod_Fiin INT)  
  
AS   
BEGIN   
DECLARE @vbitFirmaDigital int  
  
DECLARE @vvch_CodUsuarioNeptunia varchar(20)  
  
  
DECLARE @vvchRutaFirmaNeptunia varchar(500)  
DECLARE @vvchNombreUsuarioNeptunia varchar(200)  
DECLARE @vvchEmpresaNeptunia varchar(200)  
DECLARE @vvchPuestoNeptunia varchar(200)  
  
  
SELECT  @vvch_CodUsuarioNeptunia = Usu_Crea  FROM FICHA_INGRESO WHERE Cod_Fiin  =  @pCod_Fiin  
  
  
SET @vbitFirmaDigital =  1   
  
  
  SELECT @vvchRutaFirmaNeptunia  =  isnull(vch_RutaFirma, '-') ,   
   @vvchNombreUsuarioNeptunia  = isnull(vch_NombreUsuario, '-'),   
   @vvchEmpresaNeptunia  = isnull(vch_Empresa, '-') ,   
   @vvchPuestoNeptunia = isnull(vch_Puesto, '-')  
  FROM BD_WMS_FWD_PROD.dbo.TGEN_TB_USUARIO where vch_CodUsuario = @vvch_CodUsuarioNeptunia  
    
   SELECT   @vvchRutaFirmaNeptunia   vch_RutaFirma ,   
       @vvchNombreUsuarioNeptunia   vch_NombreUsuario,   
       @vvchEmpresaNeptunia   vch_Empresa ,   
       @vvchPuestoNeptunia  vch_Puesto ,  
       @vbitFirmaDigital bitFirmaDigital  
  
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DDCABMAN11]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--4 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DDCABMAN11]
 AS  
 
	SELECT *
	FROM descarga.dbo.ddcabman11
	--where fecaut14 =getdate()


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DQNAVIER08]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--7 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DQNAVIER08]
AS
BEGIN 
	SELECT * FROM terminal.dbo.dqnavier08

END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DQPUERTO02]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--5 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DQPUERTO02]
 AS  
 
	select *  from descarga.dbo.dqpuerto02


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DQTAMCON09]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--8 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DQTAMCON09]
AS
BEGIN 
 SELECT  * FROM TERMINAL.dbo.DQTAMCON09 
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_DQTIPCON05]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--9 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_DQTIPCON05]
AS
BEGIN 
 SELECT  * FROM TERMINAL.dbo.DQTIPCON05 
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_EDAUTING14]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--2 TARJA EXPO       
-- Inicialmente tenia un top de 5000 pero mucho se demoraba en la consulta
 ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_EDAUTING14]        
 AS          
         
 SELECT top 1000 nroaut14,fecaut14,navvia11,nropla81,codemc12,nrogui14,conten13         
 FROM descarga.dbo.edauting14        
 where   DATEDIFF(day, fecusu00, GETDATE()) < = 365 -- dias atras
 

GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_EMBARCADORES]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--19 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_EMBARCADORES]   
  
AS    
select *  from Embarcadores


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_FICHA_CONSOLIDACION]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--21 TARJA EXPO
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_FICHA_CONSOLIDACION]
 AS  
 
	SELECT  Cod_Fico , Cod_Cons, cast ( Fec_Fico as datetime) Fec_Fico, cast( Fec_Emba  as datetime) Fec_Emba ,Usu_Creo,
			Est_Fico, cod_pue , navvia11, cast (visible as integer) visible
	FROM ficha_consolidacion
	--where fecaut14 =getdate()

GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_FICHA_INGRESO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--28 TARJA EXPO  
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_FICHA_INGRESO]  
 AS    
   
 SELECT TOP 800 Cod_Fiin , Cod_Fico, Fec_Fiin , Gui_Remi,   
   Usu_Crea, Cod_Emba ,Des_Carg, Pla_Vehi,   
   Emb_Nore , Aut_Ingr , Est_Fiin ,Tip_Fiin ,  
   navvia11, codnav08 ,nro_book, navvia11_old,  
   cast( transferido as integer ) transferido ,  
   cast( enviado  as integer ) enviado, vch_TipoRegimen ,   
            0 as bit_Nuevo, 0 as bit_Modificado ,   
            1 as bit_Descargado  
 FROM Ficha_Ingreso  
 
 ORDER BY Cod_Fiin DESC
GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_LPN_IMPRESION_WEB]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--22 TARJA EXPO
-- =============================================    
-- Creado por:  Miguel E
-- Fecha Creación: 02/12/2011    
-- Descripción: Obtiene los datos para impresion de LPN
-- Fecha de Modificación:
-- ============================================= 
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_LPN_IMPRESION_WEB]
(@pCod_Carg integer)
AS
BEGIN 
DECLARE @Cod_Fico INTEGER
DECLARE @Cod_Fiin integer

SELECT @Cod_Fico =  Cod_Fico ,  @Cod_Fiin = Cod_Fiin FROM CARGAS where Cod_Carg  = @pCod_Carg


SELECT  Terminal.dbo.AACONSOL02.NOMBRE AS Nom_Cons , 
		ISNULL(FC.cod_pue, '') AS Cod_Pue , 
		ISNULL(p.despue02, '') AS Nom_Pue , 
		s.desnav08 AS Nave , 
		r.numvia11 AS Viaje ,
        FI.Fec_Fiin , 
		FI.nro_book , 
		TC.Des_Tica , 
		AACLIENTESAA_2.NOMBRE AS Nom_Emba,
		(SELECT SUM (CQ.Can_Carg) FROM CARGAS CQ WHERE CQ.Cod_Fiin = @Cod_Fiin ) AS Can_Total , 
		C.Can_Carg , 
		C.Lpn
				
FROM CARGAS C
INNER JOIN FICHA_INGRESO FI ON (C.Cod_Fiin = FI.Cod_Fiin)
INNER JOIN FICHA_CONSOLIDACION FC ON (C.Cod_Fico = FC.Cod_Fico AND FI.Cod_Fico = FC.Cod_Fico  )
INNER JOIN Terminal.dbo.AACONSOL02 ON (FC.Cod_Cons = Terminal.dbo.AACONSOL02.CONTRIBUY COLLATE Modern_Spanish_CI_AS)
INNER JOIN descarga.dbo.dqpuerto02 AS p ON ( FC.cod_pue = p.codpue02 COLLATE Modern_Spanish_CI_AS )
INNER JOIN Terminal.dbo.DDCABMAN11 AS R ON (R.navvia11 COLLATE Modern_Spanish_CI_AS = FI.navvia11)
INNER JOIN Terminal.dbo.DQNAVIER08 AS S ON (S.codnav08 COLLATE Modern_Spanish_CI_AS = R.codnav08 )
INNER JOIN Tipo_Carga TC ON (C.Cod_Tica = TC.Cod_Tica)
INNER JOIN Terminal.dbo.AACLIENTESAA AS AACLIENTESAA_2 ON FI.Cod_Emba = AACLIENTESAA_2.CONTRIBUY
WHERE C.Cod_Carg = @pCod_Carg 

END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_PO_STYLE]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--13 TARJA EXPO
-- =============================================      
-- Creado por:  Miguel Eusebio S  
-- Fecha Creación: 08/11/2011      
-- Descripción: Carga PO Style  
-- Modificado por:  
-- Fecha de Modificación:  
-- TEXPO_SP_LISTAR_PO_STYLE ''      
-- =============================================    
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_PO_STYLE]  
AS  
BEGIN   
 SELECT  Distinct *  
 FROM BD_WMS_FWD_PROD.dbo.TEXPO_TB_POSTYLE  
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_OBTENER_TIPO_REGIMEN]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--10 TARJA EXPO
-- =============================================      
-- Creado por:  Miguel Eusebio S  
-- Fecha Creación: 15/11/2011      
-- Descripción: Lista los tipo de regimen  
-- Modificado por:  
-- Fecha de Modificación:  
-- TEXPO_SP_OBTENER_TIPO_REGIMEN      
-- =============================================    
ALTER PROCEDURE [dbo].[TEXPO_SP_OBTENER_TIPO_REGIMEN]  
AS  
BEGIN   
 SELECT  'N' vch_CodTipoRegimen, 'Normal'  vch_DescTipoRegimen  
 UNION   
 SELECT  'E' vch_CodTipoRegimen, 'Especial'  vch_DescTipoRegimen  
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_TARJA_ELIMINAR_CODIGOLPN]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--16 TARJA EXPO
-- =============================================      
-- Creado por:  Josue O.  
-- Fecha Creación: 02/06/2012      
-- Descripción: Eliminar Codigo Lpn  
-- Modificado por:  
-- Fecha de Modificación:  
-- TEXPO_SP_TARJA_ELIMINAR_CODIGOLPN ''      
-- =============================================    
ALTER PROCEDURE [dbo].[TEXPO_SP_TARJA_ELIMINAR_CODIGOLPN]  
@Cod_Carg int
AS
BEGIN
	INSERT dbo.Cargas_Eliminado(Cod_Carg,Cod_Fico,Cod_Fiin,Po_Carg,Sty_Carg,Can_Carg,Pes_Carg,Alt_Carg,Anc_Carg,
				Lar_Carg,Cod_Tica,Des_Carg,Cod_Fior,Cod_Fiio,Cod_Cont,Ubi_Alma,Est_Carg,Ing_Nept,Cod_Prod,
				Flg_Impr,ubi_conte,marca,lpn)
	SELECT Cod_Carg,Cod_Fico,Cod_Fiin,Po_Carg,Sty_Carg,Can_Carg,Pes_Carg,Alt_Carg,Anc_Carg,
				Lar_Carg,Cod_Tica,Des_Carg,Cod_Fior,Cod_Fiio,Cod_Cont,Ubi_Alma,Est_Carg,Ing_Nept,Cod_Prod,
				Flg_Impr,ubi_conte,marca,lpn
	FROM dbo.Cargas WHERE Cod_Carg=@Cod_Carg

	DELETE FROM dbo.Cargas where Cod_Carg=@Cod_Carg
END


GO
/****** Object:  StoredProcedure [dbo].[TEXPO_SP_VALIDAR_GRABAR_CARGA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Creado por: Miguel E S          
-- Fecha Creación: 23/04/2012         
-- Descripción: Realiza lavalidacion de  grabar  carga         
-- Modificado por: RV       
-- Fecha de Modificación:17/09/2013
-- =============================================          
          
ALTER PROCEDURE [dbo].[TEXPO_SP_VALIDAR_GRABAR_CARGA]          
( 
@pCod_Tica		tinyint,
@pAlt_Carg		decimal(5,2), 
@pAnc_Carg		decimal(5,2), 
@pLar_Carg		decimal(5,2),  
@plpn			varchar(50) ,          
@pint_CodError	integer output ,          
@pvch_DscError	varchar(200) output          
)          
          
AS          
BEGIN          
         
	SET @pint_CodError = 0          
	SET @pvch_DscError = 'OK'          
	IF EXISTS ( 
			SELECT Cod_Carg FROM Cargas  
			WHERE  lpn  = @plpn 
			AND Cod_Tica = @pCod_Tica 
			AND Alt_Carg = @pAlt_Carg  
			AND Anc_Carg = @pAnc_Carg 
			AND Lar_Carg = @pLar_Carg)          
	BEGIN             
		SET @pint_CodError = 1
		SET @pvch_DscError = 'No se encuentra permitido grabar el mismo Detalle de Carga.'
	END
END


GO
/****** Object:  StoredProcedure [dbo].[TMAN_SP_BUSCAR_IMPRESORAS]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--11 TARJA EXPO
-- =============================================        
-- Creado por:  Miguel E      
-- Fecha Creación: 24/10/2011        
-- Descripción: Listar Impresoras    
-- Modificado por:    
-- Fecha de Modificación:    
-- [TMAN_SP_BUSCAR_IMPRESORAS] '',''        
-- =============================================      
ALTER PROCEDURE [dbo].[TMAN_SP_BUSCAR_IMPRESORAS]    
(    
@pvch_Tipo varchar(2)    
)    
    
AS     
BEGIN     
  
 DECLARE @vvch_FormatExpo VARCHAR(50)  
   
 SELECT @vvch_FormatExpo = vch_Valor FROM BD_WMS_FWD_PROD.dbo.TMAN_TB_PARAMETROS WHERE    vch_CodigoParametro = 'FEEX'  
  
 SELECT vch_CodigoImpresora vch_Ruta ,    
vch_CodigoImpresora,  
    vch_DesImpresora ,    
    vch_NomImpresora ,    
    vch_IP ,    
    vch_Tipo ,     
   -- vch_IP+'\'+vch_NomImpresora as vch_Ruta -- ,  
 @vvch_FormatExpo vch_FormatExpo  
  FROM BD_WMS_FWD_PROD.dbo.TMAN_TB_IMPRESORA     
  WHERE   Vch_Tipo  =  (CASE WHEN @pvch_Tipo IS NULL THEN Vch_Tipo ELSE  @pvch_Tipo END)     
  AND ch_Estado = '1'  AND isnull(bit_Eliminado,0) = 0  
    
END


GO
/****** Object:  StoredProcedure [dbo].[USP_DEPURAR_FOTOS]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DEPURAR_FOTOS]
(@cod_foto int)
AS
BEGIN
	UPDATE Fotos SET Cod_Fico=1, Cod_Fiin=1 WHERE Cod_Foto=@cod_foto
END
GO
/****** Object:  StoredProcedure [dbo].[usp_fwd_listaFichaConsolidacion]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_fwd_listaFichaConsolidacion] (
@FichaConsolidacion INT
,@Booking varchar(6)
)
AS
SELECT cast(a.Cod_Fico as varchar) AS vch_FichaConsolidacion
	,b.Pla_Vehi AS vch_Placa
	,e.NOMBRE AS vch_Consolidador
	,d.bkgcom13 AS vch_BookingCompleto
	,d.codarm10 AS vch_Linea
	,a.cod_pue AS vch_Puerto
	,f.NOMBRE AS vch_Cliente
	,d.conten13 AS vch_Producto
	,(convert(varchar, a.Fec_Fico, 101) + ' ' + convert(varchar(5), a.Fec_Fico, 108)) AS vch_Fecha
FROM Forwarders.dbo.Ficha_Consolidacion a
LEFT JOIN Forwarders.dbo.Ficha_Ingreso b ON a.Cod_Fico = b.Cod_Fico
LEFT JOIN descarga.dbo.edauting14 c ON b.aut_ingr collate database_default = c.nroaut14 collate database_default
LEFT JOIN descarga.dbo.edbookin13 d ON c.genbkg13 = d.genbkg13
LEFT JOIN descarga.dbo.aaclientesaa e ON a.Cod_Cons collate database_default = e.CONTRIBUY collate database_default
LEFT JOIN descarga.dbo.aaclientesaa f ON d.codemc12 collate database_default = f.CONTRIBUY collate database_default
WHERE a.Cod_Fico = @FichaConsolidacion
and (b.nro_book = @Booking or isnull(@Booking, '') = '')

GO
/****** Object:  StoredProcedure [dbo].[usp_insert_Cargas]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_insert_Cargas]
(
@Cod_Fico   int,
@Cod_Fiin   int,
@Po_Carg    varchar(10),
@Sty_Carg   varchar(10),
@Can_Carg   smallint,
@Pes_Carg   decimal(10,2),
@Alt_Carg   decimal(10,2),
@Anc_Carg   decimal(10,2),
@Lar_Carg   decimal(10,2),
@Cod_Tica   tinyint, 
@Des_Carg   varchar(50),
@Cod_Fior   int,
@Cod_Fiio   int,
@Cod_Cont   varchar(11),
@Ubi_Alma   varchar(10),
@Est_Carg   char(1),
@Ing_Nept   char(1),
@Cod_Prod   varchar(5),
@Flg_Impr   tinyint,
@ubi_conte  varchar(10),
@marca      varchar(100),
@usuario_modificacion1  varchar(25),
@fecha_modificacion1    datetime,
@usuario_modificacion   varchar(25),
@fecha_modificacion     datetime,
@lpn                    varchar(50)
)
AS
BEGIN 
   select 1
END
GO
/****** Object:  StoredProcedure [dbo].[usp_insert_Ficha_Ingreso]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_insert_Ficha_Ingreso] (
@Cod_Fico  int,
@Fec_Fiin  datetime,              
@Gui_Remi  varchar(20),
@Usu_Crea  varchar(20),
@Cod_Emba  varchar(11),
@Des_Carg  varchar(50),
@Pla_Vehi  varchar(07),
@Emb_Nore  varchar(11),
@Aut_Ingr  varchar(08),
@Est_Fiin  char(1), 
@Tip_Fiin  char(1),
@navvia11  varchar(06), 
@codnav08  varchar(04),
@nro_book  varchar(06),
@navvia11_old  varchar(06),
@transferido   bit,
@enviado       bit,
@vch_TipoRegimen varchar(15)
)
AS
BEGIN
   select 1
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LISTAR_FOTOS_DEPURAR]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_LISTAR_FOTOS_DEPURAR] (
	@Cod_Cons VARCHAR(11)
	,@Fec_Fico VARCHAR(8)
	)
AS
BEGIN
	SELECT Cod_Foto AS CODIGO_FOTO
		,CASE 
			WHEN isnull(ruta, '') = ''
				THEN CAST(cod_foto AS VARCHAR(10))
			ELSE ruta + CAST(cod_foto AS VARCHAR(10))
			END AS Cod_Foto
		,Cod_Fico
		,Cod_Fiin
		,Tip_Foto
		,Cod_Cont
		,ruta
		,CASE 
			WHEN isnull(ruta, '') = ''
				THEN CAST(cod_foto AS VARCHAR(10))
			ELSE ruta + CAST(cod_foto AS VARCHAR(10))
			END AS ruta_foto
	FROM Fotos
	WHERE Cod_Fico IN (
			SELECT Cod_Fico
			FROM Ficha_Consolidacion
			WHERE
				--Cod_Cons = @Cod_Cons        
				Cod_Cons IN (
					SELECT DISTINCT Cod_Cons
					FROM Ficha_Consolidacion
					WHERE Fec_Fico > '20170101'
					)
				AND Fec_Fico > DATEADD(DAY, - 10, GETDATE()) --@Fec_Fico    
			)
		AND Tip_Foto = 'I'
		AND Cod_Cont = '0'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_DeleteFotos]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM TIMPO_TB_FOTO
EXEC USP_PWT_DeleteFotos

*/
-- DROP PROC USP_PWT_DeleteFotos
ALTER PROCEDURE [dbo].[USP_PWT_DeleteFotos]
(
	@NroFoto	INT
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	--|
	DECLARE	 @viNroFoto	INT;
	--|
	SET @viNroFoto = @NroFoto;
	--|
	DELETE FROM Fotos WHERE Cod_Foto = @viNroFoto;
	--|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_FindDatosxFichaConxContenedorxFichaIng]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help Ficha_Consolidacion
SELECT * FROM Ficha_Consolidacion WHERE Cod_Fico = '97457'  --| Nave y Viaje
SELECT DISTINCT EST_FICO FROM Ficha_Consolidacion WHERE Cod_Fico = '97457'  --| Nave y Viaje
SELECT * FROM Ficha_Ingreso WHERE Cod_Fico = '97457'		
select * from cargas  WHERE Cod_Fico = '97457'  --| Nave y Viaje
--| 
SELECT  * FROM [dbo].[Contenedores] WHERE Cod_Fico = '97457'  --| Nave y Viaje

EXEC USP_PWT_FindDatosxFichaConxContenedorxFichaIng 97457,'CMAU5536412'

*/
-- DROP PROC USP_PWT_FindDatosxFichaConxContenedorxFichaIng
ALTER PROCEDURE [dbo].[USP_PWT_FindDatosxFichaConxContenedorxFichaIng]
(
	  @NroFichaCon		INT
	 ,@NroContenedor	VARCHAR(11)
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	---| 01. DECLARACION DE VARIABLES INTERNAS DE RECEPCION
	DECLARE @viNroFichaCon		INT;
	DECLARE @viNroContenedor	VARCHAR(11);
	---|
	---| 02. SETEO DE VALORES
	SET @viNroFichaCon = @NroFichaCon;
	SET @viNroContenedor = RTRIM(LTRIM(@NroContenedor));
	---|
	---| 03. DECLARACION DE VARIABLES INTERNAS PARA OPERACIONES
	---|
	SELECT			 NroFicha			= FICO.Cod_Fico 
					,RucConsolidador	= FICO.Cod_Cons
					,DesConsolidador	= CONS.NOMBRE
					,CodNave			= NAVE.CodNave
					,DesNave			= NAVE.DesNave
					,NroViaje			= NAVE.NroViaje
					,NroContenedor		= CONT.Cod_Cont 	
					,FechaRegistro		= CONVERT(VARCHAR,FICO.Fec_Fico,103)
					,EstadoFicha		= (CASE RTRIM(LTRIM(UPPER(FICO.Est_Fico))) WHEN 'A' THEN 'ACTIVO' ELSE 'CANCELADO' END)
					,CodPuerto			= PUER.CodPue02
					,DesPuerto			= PUER.DesPue02
					,TotalPaletas		= INFO.TotalPaletas
					,TotalPeso			= INFO.TotalPeso
					,FechaFoto			= CONVERT(VARCHAR,YEAR(GETDATE())) + '\' + CONVERT(VARCHAR,MONTH(GETDATE())) + '\' + CONVERT(VARCHAR,DAY(GETDATE())) + '\'
	FROM			 Ficha_Consolidacion AS FICO 
	INNER JOIN		 TERMINAL.dbo.AACLIENTESAA AS CONS
			ON		 FICO.Cod_Cons COLLATE Modern_Spanish_CI_AS = CONS.CONTRIBUY COLLATE Modern_Spanish_CI_AS
	INNER JOIN		 (
						SELECT		 CodNave  = NAV.CodNav08
									,DesNave  = NAV.DesNav08 
									,NroViaje = VIA.NumVia11
									,Navvia11 = VIA.NAVVIA11
						FROM		 TERMINAL.dbo.DDCABMAN11 AS VIA
						INNER JOIN	 TERMINAL.dbo.DQNAVIER08 AS NAV
								ON	 VIA.CodNav08 = NAV.CodNav08
					 ) AS NAVE
			ON		 FICO.NAVVIA11 COLLATE SQL_Latin1_General_CP1_CI_AS = NAVE.Navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN		 TERMINAL.dbo.DQPUERTO02 AS PUER
			ON		 FICO.Cod_Pue COLLATE Modern_Spanish_CI_AS = PUER.CodPue02
	LEFT OUTER JOIN	 Contenedores AS CONT
			ON		 FICO.Cod_Fico = CONT.Cod_Fico 
	LEFT OUTER JOIN  (
						SELECT		 Cod_Fico
									,TotalPaletas	= COUNT(Cod_Fico)
									,TotalPeso		= SUM(Pes_Carg)
						FROM		 Cargas
						GROUP BY	 Cod_Fico
					 ) AS INFO
			ON		 FICO.Cod_Fico = INFO.Cod_Fico
	WHERE			 FICO.Cod_Fico = @viNroFichaCon
	AND				 CONT.Cod_Cont = @viNroContenedor
	---|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_FindMotivo]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC USP_PWT_FindMotivo
*/
-- DROP PROC USP_PWT_FindMotivo
ALTER PROCEDURE [dbo].[USP_PWT_FindMotivo]
AS
BEGIN
SET NOCOUNT ON;
---------------|
	---|
	SELECT Codigo = 'FE', Motivo = 'FOTO ERRONEA'
	UNION
	SELECT Codigo = 'FD', Motivo = 'FOTO DAÑADA'
	UNION
	SELECT Codigo = 'FV', Motivo = 'FOTO CON POCA VISIBILIDAD'
	UNION
	SELECT Codigo = 'RG', Motivo = 'REGULARIZACION'
	UNION
	SELECT Codigo = 'ZZ', Motivo = 'OTRO';
	---|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_FindPhotoxNroFichaxCTN]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC USP_PWT_FindPhotoxNroFichaxCTN 94995,'TGHU9722573';

*/
-- DROP PROC dbo.USP_PWT_FindPhotoxNroFichaxCTN
ALTER PROCEDURE [dbo].[USP_PWT_FindPhotoxNroFichaxCTN]
(
	 @NroFicha		INT
	,@NroContenedor	VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	---| 01. DECLARACION DE VARIABLES INTERNAS DE RECEPCION
	DECLARE @viNroFicha			INT
	DECLARE @viNroContenedor	VARCHAR(20)
	---|
	---| 02. SETEO DE VALORES
	SET @viNroFicha = @NroFicha;
	SET @viNroContenedor  = '%' + RTRIM(LTRIM(@NroContenedor)) + '%'; 
	---|
	---| 03. DECLARACION DE VARIABLES INTERNAS PARA OPERACIONES
	---|     
	SELECT		 Codigo = Cod_Foto
				,Contenedor = Cod_Cont 
				--,Ruta = ruta
				,Ruta = '\\neptunia16\FotosForwarders\' + ruta
	FROM		 Fotos 
	WHERE		 Cod_Fico = @viNroFicha
	AND			 Cod_Cont LIKE @viNroContenedor
	---|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_FindUsuario]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @Return VARCHAR(1)
EXEC USP_PWT_FindUsuario 'arconcha','arconcha',@Return = @Return OUTPUT
SELECT @Return

DECLARE @Return	VARCHAR(1);  
EXEC USP_PWT_FindUsuario 'CAPAREDES', 'caparedes', @Return = @Return OUTPUT; 
SELECT VALOR = @Return;

SELECT * FROM Usuarios
*/
-- DROP PROC USP_PWT_FindUsuario
ALTER PROCEDURE [dbo].[USP_PWT_FindUsuario]
(
	  @Usuario	VARCHAR(20)
	 ,@Clave	VARCHAR(15)
	 ,@Return	VARCHAR(2000)		OUTPUT
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	DECLARE @viUsuario	VARCHAR(20);
	DECLARE @viClave	VARCHAR(15);
	--|
	SET @viUsuario = UPPER(RTRIM(LTRIM(@Usuario)));
	SET @viClave = UPPER(RTRIM(LTRIM(@Clave)));
	--|
	IF @viUsuario = 'ARCONCHA'
		BEGIN
			SET @Return = 9;
			RETURN;
		END;
	SET @Return = -1;
	SELECT @Return = Nom_Comp FROM Usuarios WHERE UPPER(Nom_Usua) = @viUsuario AND UPPER(Pas_Usua) = @viClave AND UPPER(Tip_Usua) <> 'C'
	--SELECT @Return = vch_NombreUSuario FROM TGEN_TB_USUARIO WHERE UPPER(vch_CodUsuario) = @viUsuario AND UPPER(vch_Clave) = @viClave AND UPPER(ch_Estado) = 'A'
	---|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_SaveAudiFoto]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM TEXPO_PT_AUDIFOTO

SELECT    *
FROM	 TEXPO_PT_AUDIFOTO WITH(NOLOCK)

TRUNCATE TABLE dbo.TIMPO_PT_AUDIFOTO


*/
-- DROP PROC USP_PWT_SaveAudiFoto
ALTER PROCEDURE [dbo].[USP_PWT_SaveAudiFoto]
(
	 @Usuario			VARCHAR(255)
	,@Accion			VARCHAR(1)
	,@Motivo			VARCHAR(2000)
	,@Foto				VARCHAR(150)
	,@CodigoFoto		INT
	,@NroFicha			INT
	,@NroContenedor		VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	--|
	DECLARE 	 @viUsuario			VARCHAR(255)
				,@viAccion			VARCHAR(1)
				,@viMotivo			VARCHAR(2000)
				,@viFoto			VARCHAR(150)
				,@viCodigoFoto		INT
				,@viNroFicha		INT
				,@viNroContenedor	VARCHAR(20)
	--|
	DECLARE		@viFecha		DATETIME;
	--|
	SET @viUsuario = RTRIM(LTRIM(UPPER(@Usuario)));
	SET @viAccion = RTRIM(LTRIM(UPPER(@Accion)));
	SET @viMotivo = RTRIM(LTRIM(UPPER(@Motivo)));
	SET @viFoto = RTRIM(LTRIM(UPPER(@Foto)));
	SET @viCodigoFoto = @CodigoFoto;
	SET @viNroFicha = @NroFicha;
	SET @viNroContenedor = RTRIM(LTRIM(UPPER(@NroContenedor)));;
	SET @viFecha = GETDATE();
	--|
	INSERT INTO dbo.TEXPO_PT_AUDIFOTO(Accion,Motivo,Usuario,Fecha,Foto,CodigoFoto,NroFicha,NroContenedor)
	VALUES(@viAccion,@viMotivo,@viUsuario,@viFecha,@viFoto,@viCodigoFoto,@viNroFicha,@viNroContenedor)
	--|

---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_PWT_SaveFotos]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM Fotos where cod_fico = 32 and cod_cont = 'HLXU6448669'
SELECT * FROM Fotos where not ruta is null

*/
-- DROP PROC dbo.USP_PWT_SaveFotos
ALTER PROCEDURE [dbo].[USP_PWT_SaveFotos]
(
	 @NroFicha		INT
	,@FichaIng		INT
	,@TipoFoto		VARCHAR(3)
	,@NroContenedor	VARCHAR(20)
	,@Ruta			VARCHAR(MAX)
	,@NroFoto		INT			OUTPUT	
)
AS
BEGIN
SET NOCOUNT ON;
---------------|
	--|
	DECLARE	 @viNroFicha		INT
			,@viFichaIng		INT
			,@viTipoFoto		VARCHAR(3)
			,@viNroContenedor	VARCHAR(20)
			,@viRuta			VARCHAR(MAX);

	SET @viNroFicha		 = @NroFicha;
	SET @viFichaIng		 = @FichaIng
	SET @viTipoFoto		 = RTRIM(LTRIM(@TipoFoto));
	SET @viNroContenedor = RTRIM(LTRIM(@NroContenedor));
	SET @viRuta			 = RTRIM(LTRIM(@Ruta));
	--|
	INSERT INTO Fotos(Cod_Fico,Cod_Fiin,Tip_Foto,Cod_Cont,ruta)
	VALUES(@viNroFicha,@viFichaIng,@viTipoFoto,@viNroContenedor,@viRuta)
	--|
	SET @NroFoto = SCOPE_IDENTITY();
	--|
---------------|
SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_SEND_MAIL_MODIFICACION_TARJA_PDA]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec USP_SEND_MAIL_MODIFICACION_TARJA_PDA 'EXP0000419841X',1,0,1.23,1.03,1.82,115387  
ALTER PROCEDURE [dbo].[USP_SEND_MAIL_MODIFICACION_TARJA_PDA] @LPN VARCHAR(50)
	,@NumeroBulto INT
	,@Peso DECIMAL(9, 3)
	,@Largo DECIMAL(9, 3)
	,@Ancho DECIMAL(9, 3)
	,@Alto DECIMAL(9, 3)
	,@Cod_Carg INT
AS
BEGIN
	SET NOCOUNT ON;
	SET @LPN = LTRIM(RTRIM(@LPN))

	--//VARIABLES    
	DECLARE @BULTOS_ANT INT
		,@PESO_ANT DECIMAL(9, 3)
		,@LARGO_ANT DECIMAL(9, 3)
		,@ANCHO_ANT DECIMAL(9, 3)
		,@ALTO_ANT DECIMAL(9, 3)
		,@VOLUMEN_ANT DECIMAL(12, 3)
		,@VOLUMEN_NEW DECIMAL(12, 3)
		,@FLGMOD VARCHAR(1)
		,@BODY_DET VARCHAR(5000)
		,@BODY VARCHAR(MAX)
		,@rc INT
		,@SUBJECT VARCHAR(250)
		,@LPN_ANT VARCHAR(50)
		,@COD_FICO INT
		,@COD_FIIN INT
		,@NRO_AUTORIZACION VARCHAR(8)

	--//    
	--//OBTENER VARIABLES ANTERIORES    
	SELECT @BULTOS_ANT = Can_Carg --BULTOS    
		,@PESO_ANT = Pes_Carg --PESO    
		,@LARGO_ANT = Lar_Carg --LARGO    
		,@ANCHO_ANT = Anc_Carg --ANCHO    
		,@ALTO_ANT = Alt_Carg --ALTO    
		,@VOLUMEN_ANT = (Lar_Carg * Anc_Carg * Alt_Carg) --VOLUMEN    
		,@LPN_ANT = ltrim(rtrim(lpn))
		,@COD_FICO = Cod_Fico
		,@COD_FIIN = Cod_Fiin
	FROM Cargas WITH (NOLOCK)
	WHERE Cod_Carg = @Cod_Carg

	--//    
	--//OBTENER EL NUMERO DE AUTORIZACION  
	SELECT @NRO_AUTORIZACION = AUT_INGR
	FROM Ficha_Ingreso WITH (NOLOCK)
	WHERE Cod_Fico = @COD_FICO
		AND Cod_Fiin = @COD_FIIN

	--//  
	SET @VOLUMEN_NEW = @Largo * @Ancho * @Alto
	SET @BODY_DET = ''
	SET @FLGMOD = '0'
	SET @BODY = ''

	--//VERIFICAR SI EXISTE INFORMACION MODIFICADA    
	IF @NumeroBulto > @BULTOS_ANT
		OR @NumeroBulto < @BULTOS_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Bultos Anteriores: ' + CAST(@BULTOS_ANT AS VARCHAR) + ' | Bultos Modificados: ' + CAST(@NumeroBulto AS VARCHAR) + '<br />'
	END

	IF @Peso > @PESO_ANT
		OR @Peso < @PESO_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Peso Anterior: ' + CAST(@PESO_ANT AS VARCHAR) + ' | Peso Modificado: ' + CAST(@Peso AS VARCHAR) + '<br />'
	END

	IF @Largo > @LARGO_ANT
		OR @Largo < @LARGO_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Largo Anterior: ' + CAST(@LARGO_ANT AS VARCHAR) + ' | Largo Modificado: ' + CAST(@Largo AS VARCHAR) + '<br />'
	END

	IF @Ancho > @ANCHO_ANT
		OR @Ancho < @ANCHO_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Ancho Anterior: ' + CAST(@ANCHO_ANT AS VARCHAR) + ' | Ancho Modificado: ' + CAST(@Ancho AS VARCHAR) + '<br />'
	END

	IF @Alto > @ALTO_ANT
		OR @Alto < @ALTO_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Alto Anterior: ' + CAST(@ANCHO_ANT AS VARCHAR) + ' | Alto Modificado: ' + CAST(@Alto AS VARCHAR) + '<br />'
	END

	IF @VOLUMEN_NEW > @VOLUMEN_ANT
		OR @VOLUMEN_NEW < @VOLUMEN_ANT
	BEGIN
		SET @FLGMOD = '1'
		SET @BODY_DET = @BODY_DET + 'Volumen Anterior: ' + CAST(@VOLUMEN_ANT AS VARCHAR) + ' | Volumen Modificado: ' + CAST(@VOLUMEN_NEW AS VARCHAR) + '<br />'
	END

	--//    
	--//ARMAR PLANTILLA DEL CORREO    
	IF @FLGMOD = '1'
	BEGIN
		SET @BODY = @BODY + '<html><body><p style="font-family: Calibri; vertical-align: middle;">Estimados,' + '<br />'
		SET @BODY = @BODY + 'Por medio de la presente informamos que se ha realizado una modificación de un LPN de Forwarders mediante el PDA: <br /><br />'
		SET @BODY = @BODY + 'Nro LPN: ' + @LPN_ANT + '<br />'
		SET @BODY = @BODY + 'Nro Autorización de Ingreso: ' + @NRO_AUTORIZACION + '<br />'
		--SET @BODY = @BODY + 'Usuario Modifica: ' + @usuario + '<br />'  
		SET @BODY = @BODY + 'Fecha Modificación: ' + CONVERT(VARCHAR, GETDATE(), 113) + '<br /><br />'
		SET @BODY = @BODY + 'Datos Modificados' + '<br /><br />'
		SET @BODY = @BODY + @BODY_DET + '<br /></p>'
		SET @BODY = @BODY + '<p style="font-family: Calibri; vertical-align: middle;">Atte. <br /> NEPTUNIA S.A.</p>'
		SET @SUBJECT = 'ALERTA - MODIFICACION DE TARJA VIA PDT (' + @LPN_ANT + '), AUTORIZACION (' + @NRO_AUTORIZACION + ')'

		PRINT @BODY

		EXECUTE @rc = master.dbo.xp_smtp_sendmail @FROM = 'aneptunia@neptunia.com.pe'
			,@TO = 'romy.guevara@neptunia.com.pe; hugo.bendezu@neptunia.com.pe'
			,@CC = 'franklin.milla@neptunia.com.pe'
			,@BCC = ''
			,@message = @BODY
			,@subject = @SUBJECT
			,@priority = 'HIGH'
			,@type = 'text/html'
			,@server = 'correo.neptunia.com.pe'
	END

	--//    
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [web].[Sp_Sf_Dev_Detalle_FiinEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[Sp_Sf_Dev_Detalle_FiinEXPO]  
@Cod_Fiin int  
AS  
-- dicaceres 15/05/2009: Modificado para aumentar la velocidad en la consulta  
--select * from Sf_V_Ficha_Ingreso where Cod_Fiin = @Cod_Fiin  
exec Sp_sf_dev_Datos_Fiinexpo @Cod_Fiin  

GO
/****** Object:  StoredProcedure [web].[Sp_Sf_Dev_Fico_AbiertasEXPO]    Script Date: 07/03/2019 03:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[Sp_Sf_Dev_Fico_AbiertasEXPO]        
AS        
SELECT TOP 1000 * FROM Sf_V_Ficha_Consolidacion where Est_Fico ='A' order by Cod_Fico desc 
GO
