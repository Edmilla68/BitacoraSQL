USE [Tarifario]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_integracombo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_integracombo]
(
      @RUCCLI Char(11),
      @NROCOMBO INT,
      @SUCURSAL CHAR(1)
)
RETURNS VARCHAR(2000)
AS
BEGIN

      DECLARE @Min INT, @Max INT, @RETURN VARCHAR(2000), @AUX CHAR(5)

      SET @RETURN = ''

      DECLARE @temp TABLE
      (
            Indice INT IDENTITY(1,1) PRIMARY KEY,
            CONCEPTO CHAR(5)
      )
--    SELECT DISTINCT
--          CONCEPTO=b.codcon14
--    FROM 
--          tarifario..St_T_Servicios_Combo a, 
--          terminal..fqcontar14 b, 
--          tarifario..St_T_Acuerdos c
--    WHERE 
--          a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03_D
--          and a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1'
--          and b.codcon14 not in ('MINR2','MINR4','tarja')
--          and c.contribuy=@RUCCLI
--          and a.Cod_Comb = @Cod_Comb
--    ORDER BY
--          b.codcon14
      INSERT @temp
      SELECT DISTINCT
            CONCEPTO
      FROM 
            aaserint
      WHERE 
            contribuy=@RUCCLI
            AND NROCOMBO = @NROCOMBO
            AND SUCURSAL = @SUCURSAL
      ORDER BY
            CONCEPTO


      SET @Max = @@RowCount

      SET @Min = 1

      WHILE @Min <= @Max
            BEGIN
                  SELECT @RETURN = @RETURN + CONCEPTO + '&' FROM @temp WHERE Indice = @Min
                  SET @Min = @Min + 1
            END

      RETURN @RETURN

END


GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_Split](@sText varchar(8000), @sDelim varchar(20) = ' ')
RETURNS @retArray TABLE (idx smallint Primary Key, value varchar(8000))
AS
BEGIN
DECLARE @idx smallint,
@value varchar(8000),
@bcontinue bit,
@iStrike smallint,
@iDelimlength tinyint

IF @sDelim = 'Space'
BEGIN
SET @sDelim = ' '
END

SET @idx = 0
SET @sText = LTrim(RTrim(@sText))
SET @iDelimlength = DATALENGTH(@sDelim)
SET @bcontinue = 1

IF NOT ((@iDelimlength = 0) or (@sDelim = 'Empty'))
BEGIN
WHILE @bcontinue = 1
BEGIN

--If you can find the delimiter in the text, retrieve the first element and
--insert it with its index into the return table.

IF CHARINDEX(@sDelim, @sText)>0
BEGIN
SET @value = SUBSTRING(@sText,1, CHARINDEX(@sDelim,@sText)-1)
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END

--Trim the element and its delimiter from the front of the string.
--Increment the index and loop.
SET @iStrike = DATALENGTH(@value) + @iDelimlength
SET @idx = @idx + 1
SET @sText = LTrim(Right(@sText,DATALENGTH(@sText) - @iStrike))

END
ELSE
BEGIN
--If you can’t find the delimiter in the text, @sText is the last value in
--@retArray.
SET @value = @sText
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END
--Exit the WHILE loop.
SET @bcontinue = 0
END
END
END
ELSE
BEGIN
WHILE @bcontinue=1
BEGIN
--If the delimiter is an empty string, check for remaining text
--instead of a delimiter. Insert the first character into the
--retArray table. Trim the character from the front of the string.
--Increment the index and loop.
IF DATALENGTH(@sText)>1
BEGIN
SET @value = SUBSTRING(@sText,1,1)
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END
SET @idx = @idx+1
SET @sText = SUBSTRING(@sText,2,DATALENGTH(@sText)-1)

END
ELSE
BEGIN
--One character remains.
--Insert the character, and exit the WHILE loop.
INSERT @retArray (idx, value)
VALUES (@idx, @sText)
SET @bcontinue = 0 
END
END

END

RETURN
END


GO
/****** Object:  View [dbo].[TMTIEN]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- Sucursal (tb_sucursal_INST)    
ALTER VIEW [dbo].[TMTIEN] As    
SELECT [DC_SUCURSAL], [DE_TIEN] as dg_sucursal, [CO_TIEN], [CO_UNID], [CO_EMPR], [DE_TIEN], [DE_TIEN_LARG], [DE_DIRE], [CO_UBIC_GEOG],    
       [DE_CIUD], [DE_DPTO], [CO_PAIS], [NU_TLF1], [NU_TLF2], [NU_FAXS], [DE_DIRE_MAIL],    
       [TI_AUXI_EMPR], [CO_AUXI_EMPR], [NU_SERI_NCON], [CO_VEND_DEFA], [CO_CLIE_DEFA],    
       [ST_PUNT_VENT], [DG_ALIAS_SUCURSAL], [DF_VIGENCIA_INICIO], [DF_VIGENCIA_TERMINO],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN]   
WHERE  [CO_EMPR] = '01'



GO
/****** Object:  View [dbo].[TTSERV]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TTSERV] As    
SELECT [dc_servicio], [DE_SERV] as dg_servicio, [CO_SERV],     
       [dg_servicio_ingles], [dc_moneda_servicio],    
       [df_vigencia_inicio], [df_vigencia_termino],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV]    
WHERE CO_EMPR = '01'



GO
/****** Object:  View [dbo].[TTUNID_NEGO]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---- Centros de Costo (tb_centro_costo)    
ALTER VIEW [dbo].[TTUNID_NEGO] As    
SELECT [dc_centro_costo], [DE_UNNE] as dg_centro_costo, [CO_UNNE], [CO_EMPR],  [CO_DINE],    
       [dc_division_negocio], [df_inicio_vigencia],    
       [df_termino_vigencia], [dg_alias_centro_costo],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
FROM   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO]  
WHERE  [CO_EMPR] = '01'
  


GO
/****** Object:  View [dbo].[St_V_Aprobar_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Aprobar_Tarifas]
as
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_inst.dg_sucursal, tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, 
                      dbo.St_T_Acuerdos.Usu_Acue, dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, 
                      dbo.St_T_Acuerdos.Tar_Maxi, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON dbo.St_T_Acuerdos.Dc_Centro_Costo = Tb_centro_costo.dc_centro_costo
WHERE     (dbo.St_T_Acuerdos.Cod_Esta = 'P') AND (dbo.St_T_Acuerdos.Flg_Tari = 1)
ORDER BY dbo.St_T_Acuerdos.Cod_Acue

GO
/****** Object:  View [dbo].[St_V_Aprobar_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Aprobar_Acuerdos]
as
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_inst.dg_sucursal, tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, 
                      dbo.St_T_Acuerdos.Usu_Acue, dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, 
                      dbo.St_T_Acuerdos.Tar_Maxi, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte, St_T_Acuerdos.Dc_Centro_Costo_A,St_T_Acuerdos.Dc_Sucursal_A
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON dbo.St_T_Acuerdos.Dc_Centro_Costo = Tb_centro_costo.dc_centro_costo
WHERE     (dbo.St_T_Acuerdos.Cod_Esta = 'P') AND (dbo.St_T_Acuerdos.Flg_Tari = 0)
ORDER BY dbo.St_T_Acuerdos.Cod_Acue

GO
/****** Object:  View [dbo].[St_V_CI_Contribuy]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Contribuy]
AS
SELECT     nrosec20, tipent03, codent22, entida22, cantid22, criter22
FROM         Terminal.dbo.FRCNDRES22
WHERE     (tipent03 = '14')

GO
/****** Object:  View [dbo].[St_V_CI_Impo_Acue_new]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Impo_Acue_new]
AS
SELECT     fdtarser13.codtar13, fdtarser13.codpro27, fdtarser13.codemb06, fqcontar14.codsbd03, fdtarser13.codcon14, fdtarser13.codbol03, 
                      Terminal.dbo.FDDESPRG21.observ21 AS desimp13, fdtarser13.aplica13, fdtarser13.valser13, fdtarser13.tarmin13, fdtarser13.diaal113, 
                      fdtarser13.estado13, Terminal.dbo.FDDESPRG21.fecusu00, fdtarser13.tarmax13, fdtarser13.diaal213, Terminal.dbo.FDDESPRG21.codusu17, 
                      fdtarser13.finvig13, fdtarser13.inivig13, fdtarser13.sucursal, Terminal.dbo.FDDESPRG21.nrosec21, Terminal.dbo.FDDESPRG21.descto21, 
                      Terminal.dbo.FDDESPRG21.tipdsc21, Terminal.dbo.FDDESPRG21.dialib21, dbo.St_V_CI_Contribuy.codent22 AS Contribuy
FROM         Terminal.dbo.FDDESPRG21 LEFT OUTER JOIN
                      dbo.St_V_CI_Contribuy ON Terminal.dbo.FDDESPRG21.nrosec21 = dbo.St_V_CI_Contribuy.nrosec20 LEFT OUTER JOIN
                      Terminal.dbo.FDTARDES23 LEFT OUTER JOIN
                      Terminal.dbo.FDTARSER13 fdtarser13 ON Terminal.dbo.FDTARDES23.sucursal = fdtarser13.sucursal AND 
                      Terminal.dbo.FDTARDES23.codtar13 = fdtarser13.codtar13 LEFT OUTER JOIN
                      Terminal.dbo.FQCONTAR14 fqcontar14 ON fdtarser13.sucursal = fqcontar14.sucursal AND fdtarser13.codcon14 = fqcontar14.codcon14 ON 
                      Terminal.dbo.FDDESPRG21.sucursal = Terminal.dbo.FDTARDES23.sucursal AND 
                      Terminal.dbo.FDDESPRG21.nrosec21 = Terminal.dbo.FDTARDES23.nrosec21
WHERE     (dbo.St_V_CI_Contribuy.codent22 = '20307146798')

GO
/****** Object:  View [dbo].[St_V_Cu_Tarifario_Cubo_Rep]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Cu_Tarifario_Cubo_Rep]
AS
SELECT     tb_servicios.dg_servicio AS dg_Servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl, 
                      AACLIENTESAA.NOMBRE AS Cliente, ST_T_TARIFARIO_CUBO_1.*, Terminal.dbo.TB_Vendedor.NomVen AS Vendedor, aaclientesaa.vendedor as Cod_Vend
FROM         Terminal.dbo.TB_Vendedor RIGHT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON Terminal.dbo.TB_Vendedor.IdCodVen = AACLIENTESAA.VENDEDOR RIGHT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 RIGHT OUTER JOIN
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON 
                      tb_sucursal_INST_1.dc_sucursal = ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       ON 
                      AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo
WHERE     (ST_T_TARIFARIO_CUBO_1.Cod_Esta <> 'I') and St_T_Tarifario_Cubo_1.Cod_Acue<=13280 and St_T_Tarifario_Cubo_1.Dc_Servicio<>999 and St_T_Tarifario_Cubo_1.Dc_Centro_Costo_A=1



GO
/****** Object:  View [dbo].[St_V_CU_Tarifario_Cubo_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--APC20080310
ALTER VIEW [dbo].[St_V_CU_Tarifario_Cubo_old]
AS
SELECT     TOP 100 PERCENT ST_T_TARIFARIO_CUBO_1.*, tb_servicios.dg_servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, 
                      tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl, AACLIENTESAA.NOMBRE AS Cliente
FROM         TMTIEN tb_sucursal_INST_1 RIGHT OUTER JOIN
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON 
                      tb_sucursal_INST_1.dc_sucursal = ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo


GO
/****** Object:  View [dbo].[St_V_Facturas_Independientes]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--APC20080310
ALTER VIEW [dbo].[St_V_Facturas_Independientes]
as
SELECT     dbo.St_T_Facturas_Independientes.Id, dbo.St_T_Facturas_Independientes.Dc_Servicio, dbo.St_T_Facturas_Independientes.Contribuy, 
                      tb_servicios.dg_servicio AS Servicio, a.NOMBRE AS Cliente
FROM         dbo.St_T_Facturas_Independientes LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA a ON 
                      dbo.St_T_Facturas_Independientes.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = a.CONTRIBUY LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Facturas_Independientes.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS


GO
/****** Object:  View [dbo].[TRUNNE_SERV]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TRUNNE_SERV] As       
SELECT t2.DC_SERVICIO, t3.DC_SUCURSAL as dc_sucursal_imputacion,         
                t4.DC_CENTRO_COSTO as dc_centro_costo_imputacion,        
       t1.[dm_detraccion], t1.[afecto_igv], t1.[df_inicio_vigencia], t1.[df_final_vigencia],        
       t1.[dc_porcentaje_detraccion],        
       t1.[CO_ACTI_DETR], t1.[CO_TIPO_DETR]        
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TRUNNE_SERV] t1        
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTSERV] t2 On        
       (      t1.[CO_EMPR] = t2.[CO_EMPR] 
	   And    t2.CO_SERV = t1.CO_SERV )        
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMTIEN] t3 On        
       (      t3.CO_TIEN = t1.CO_TIEN        
       And    t3.CO_UNID = t1.CO_UNID        
       And    t3.CO_EMPR = t1.CO_EMPR )        
       Inner Join [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TTUNID_NEGO] t4 On        
       (      t4.CO_UNNE = t1.CO_UNNE        
       And    t4.CO_EMPR = t1.CO_EMPR )    
WHERE  t1.[CO_EMPR] = '01' 


GO
/****** Object:  View [dbo].[St_V_Tb_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tb_Servicios]
as
SELECT     tb_Servicios.dg_servicio AS dg_servicio, 

tb_Servicios.df_vigencia_inicio AS df_vigencia_inicio, 
                      tb_Servicios.df_vigencia_termino AS df_vigencia_termino, 

tb_centro_costo.dg_centro_costo AS dg_centro_costo, 
                      tb_sucursal_INST.dg_sucursal AS dg_sucursal, 

Servicio_Sucursal_Cencos.dc_servicio AS dc_servicio, 
                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion AS 

dc_sucursal_imputacion, 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion AS 

dc_centro_costo_imputacion, dc_usuario_creo='', 
                      tb_Servicios.dc_moneda_servicio AS dc_moneda_servicio, 

dbo.St_T_Moneda.Dg_Moneda_Servicio AS Dg_Moneda_Servicio
FROM         TTSERV tb_Servicios INNER JOIN
                      dbo.St_T_Moneda ON tb_Servicios.dc_moneda_servicio = 

dbo.St_T_Moneda.Dc_Moneda_Servicio LEFT OUTER JOIN
                      TRUNNE_SERV 

Servicio_Sucursal_Cencos ON 
                      tb_Servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio LEFT 

OUTER JOIN
                      TMTIEN tb_sucursal_INST ON 
                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion = 

tb_sucursal_INST.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo ON 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = 

tb_centro_costo.dc_centro_costo


GO
/****** Object:  View [dbo].[st_v_tr_Acuerdo_Servicio_Sin_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[st_v_tr_Acuerdo_Servicio_Sin_Sucursal] 
as
SELECT DISTINCT 
                      dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Dc_Centro_Costo, ISNULL(dbo.St_T_Acuerdos.Dc_Sucursal, 0) AS Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, Servicio_Sucursal_Cencos.dm_detraccion, Servicio_Sucursal_Cencos.Afecto_IGV, dbo.St_T_Acuerdos.Des_Acue, 
                      dbo.St_T_Acuerdos.Val_Acue,Servicio_Sucursal_Cencos.dc_porcentaje_detraccion
FROM         TRUNNE_SERV Servicio_Sucursal_Cencos RIGHT OUTER JOIN
                      dbo.St_T_Acuerdos ON Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = dbo.St_T_Acuerdos.Dc_Centro_Costo AND 
                      Servicio_Sucursal_Cencos.dc_servicio COLLATE Modern_Spanish_CI_AS = dbo.St_T_Acuerdos.Dc_Servicio

GO
/****** Object:  View [dbo].[St_V_Tipo_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Tipo_Servicio]
as
SELECT     Servicio_Sucursal_CenCos.dc_servicio, Servicio_Sucursal_CenCos.dc_sucursal_imputacion, Servicio_Sucursal_CenCos.dc_centro_costo_imputacion, 
                      dbo.St_T_Tipo_Servicio.Flg_Serv, tb_Servicios.dg_servicio, tb_centro_costo.dg_centro_costo, tb_Sucursal.dg_sucursal,dbo.St_T_Tipo_Servicio.Flg_SerA,dbo.St_T_Tipo_Servicio.Flg_SerT
FROM         TRUNNE_SERV Servicio_Sucursal_CenCos LEFT OUTER JOIN
                      dbo.St_T_Tipo_Servicio ON Servicio_Sucursal_CenCos.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Tipo_Servicio.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS AND 
                      Servicio_Sucursal_CenCos.dc_sucursal_imputacion = dbo.St_T_Tipo_Servicio.Dc_Sucursal AND 
                      Servicio_Sucursal_CenCos.dc_centro_costo_imputacion = dbo.St_T_Tipo_Servicio.Dc_Centro_Costo LEFT OUTER JOIN
                      TMTIEN tb_Sucursal ON 
                      tb_Sucursal.dc_sucursal = Servicio_Sucursal_CenCos.dc_sucursal_imputacion LEFT OUTER JOIN
                      TTSERV tb_Servicios ON tb_Servicios.dc_servicio = Servicio_Sucursal_CenCos.dc_servicio LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo ON 
                      tb_centro_costo.dc_centro_costo = Servicio_Sucursal_CenCos.dc_centro_costo_imputacion

GO
/****** Object:  View [dbo].[ST_V_Buscar_Asignaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_Buscar_Asignaciones]
as
SELECT     dbo.ST_T_Asignaciones.Cod_Asig, dbo.St_T_Servicios_Asignados.Cod_Seas, dbo.St_T_Servicios_Asignados.Dc_Centro_Costo, 
                      dbo.St_T_Servicios_Asignados.Dc_Sucursal, dbo.St_T_Servicios_Asignados.Dc_Servicio, dbo.St_T_Servicios_Asignados.Por_Asig, 
                      tb_centro_costo_1.dg_centro_costo, tb_sucursal_INST_1.dg_sucursal, tb_servicios_1.dg_servicio, 
                      dbo.ST_T_Asignaciones.Dc_Centro_Costo AS Dc_Centro_Costo_B, dbo.ST_T_Asignaciones.Dc_Sucursal AS Dc_Sucursal_B, 
                      dbo.ST_T_Asignaciones.Dc_Servicio AS Dc_Servicio_B, dbo.ST_T_Asignaciones.Tam_Cont, dbo.ST_T_Asignaciones.Cod_Line,dbo.ST_T_Asignaciones.Cod_Depo,dbo.ST_T_Asignaciones.Es_Inte,dbo.ST_T_Asignaciones.Otr_Line, dbo.St_T_Asignaciones.Tip_Eval
FROM         dbo.St_T_Servicios_Asignados RIGHT OUTER JOIN
                      dbo.ST_T_Asignaciones ON dbo.St_T_Servicios_Asignados.Cod_Asig = dbo.ST_T_Asignaciones.Cod_Asig LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Sucursal = tb_sucursal_INST_1.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Centro_Costo = tb_centro_costo_1.dc_centro_costo LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios_1.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS


GO
/****** Object:  View [dbo].[AACLIENTESAA]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[AACLIENTESAA]
AS
SELECT     *
FROM         Terminal.dbo.AACLIENTESAA


GO
/****** Object:  View [dbo].[St_V_CU_Centros]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_CU_Centros]
as
SELECT     dc_centro_costo, dg_centro_costo, df_inicio_vigencia, df_termino_vigencia
FROM         TTUNID_NEGO  tb_centro_costo


GO
/****** Object:  View [dbo].[St_V_CU_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_CU_Servicios]
AS
SELECT     dc_servicio,dg_servicio, df_vigencia_inicio, df_vigencia_termino, dc_usuario_creo='', dc_moneda_servicio
FROM         TTSERV tb_Servicios


GO
/****** Object:  View [dbo].[St_V_CU_sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW  [dbo].[St_V_CU_sucursal]
as
SELECT      dc_sucursal AS Dc_sucursal, dg_sucursal AS Dg_sucursal
FROM         TMTIEN tb_sucursal_INST


GO
/****** Object:  View [dbo].[ST_V_Tarifario_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_Tarifario_Cubo]
AS
SELECT     dbo.St_V_CU_Servicios.dg_servicio AS dg_servicio, dbo.St_V_CU_sucursal.Dg_sucursal AS dg_sucursal, 
                      dbo.St_V_CU_Centros.dg_centro_costo AS dg_centro_costo, dbo.AACLIENTESAA.NOMBRE AS nombre, dbo.ST_T_TARIFARIO_CUBO.*
FROM         dbo.ST_T_TARIFARIO_CUBO LEFT OUTER JOIN
                      dbo.St_V_CU_Servicios ON 
                      dbo.ST_T_TARIFARIO_CUBO.Dc_Servicio = dbo.St_V_CU_Servicios.dc_servicio COLLATE Modern_Spanish_CI_AS LEFT OUTER JOIN
                      dbo.St_V_CU_sucursal ON dbo.ST_T_TARIFARIO_CUBO.Dc_Sucursal = dbo.St_V_CU_sucursal.Dc_sucursal LEFT OUTER JOIN
                      dbo.St_V_CU_Centros ON dbo.ST_T_TARIFARIO_CUBO.Dc_Centro_Costo = dbo.St_V_CU_Centros.dc_centro_costo LEFT OUTER JOIN
                      dbo.AACLIENTESAA ON dbo.ST_T_TARIFARIO_CUBO.Contribuy = dbo.AACLIENTESAA.CONTRIBUY COLLATE Modern_Spanish_CI_AS

GO
/****** Object:  View [dbo].[St_V_Cu_Tarifario_Cubo_Rep2]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Cu_Tarifario_Cubo_Rep2]
AS
SELECT     tb_servicios.dg_servicio AS dg_servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl, 
                      AACLIENTESAA.NOMBRE AS Cliente, ST_T_TARIFARIO_CUBO_1.*, Terminal.dbo.TB_Vendedor.NomVen AS Vendedor, 
                      AACLIENTESAA.VENDEDOR AS Cod_Vend, dbo.tr_tmp_clientes_expo_2005_2006.Flag AS Flag
FROM         TTSERV tb_servicios RIGHT OUTER JOIN
                      dbo.tr_tmp_clientes_expo_2005_2006 RIGHT OUTER JOIN
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON 
                      dbo.tr_tmp_clientes_expo_2005_2006.Contribuy = ST_T_TARIFARIO_CUBO_1.Contribuy LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 ON ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a = tb_sucursal_INST_1.dc_sucursal ON 
                      tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS = ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      Terminal.dbo.TB_Vendedor RIGHT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON Terminal.dbo.TB_Vendedor.IdCodVen = AACLIENTESAA.VENDEDOR ON 
                      ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo
WHERE     (ST_T_TARIFARIO_CUBO_1.Cod_Esta <> 'I') AND (ST_T_TARIFARIO_CUBO_1.Cod_Acue <= 13280) AND 
                      (ST_T_TARIFARIO_CUBO_1.Dc_Servicio IN (465, 170, 466)) AND (ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = 2) AND 
                      (dbo.tr_tmp_clientes_expo_2005_2006.Flag = 'E') 


GO
/****** Object:  View [dbo].[St_V_Cu_Tarifario_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Cu_Tarifario_Cubo]
AS
SELECT     tb_servicios.dg_servicio AS Dg_Servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, 
                      tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl, AACLIENTESAA.NOMBRE AS Cliente, ST_T_TARIFARIO_CUBO_1.*
FROM         TMTIEN tb_sucursal_INST_1 RIGHT OUTER JOIN
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON 
                      tb_sucursal_INST_1.dc_sucursal = ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TERMINAL.dbo.AACLIENTESAA AACLIENTESAA ON 
                      ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo
WHERE     (ST_T_TARIFARIO_CUBO_1.Cod_Esta <> 'I')


GO
/****** Object:  View [dbo].[St_V_Tr_Servicio_Sin_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Tr_Servicio_Sin_Acuerdo]
AS
SELECT     tb_servicios_1.dg_servicio AS Des_Serv, Servicio_Sucursal_CenCos_1.dc_servicio, Servicio_Sucursal_CenCos_1.dc_sucursal_imputacion, 
                      Servicio_Sucursal_CenCos_1.dc_centro_costo_imputacion, Servicio_Sucursal_CenCos_1.dm_detraccion, Servicio_Sucursal_CenCos_1.Afecto_IGV, 
                      Servicio_Sucursal_CenCos_1.df_inicio_vigencia, Servicio_Sucursal_CenCos_1.df_final_vigencia, 
                      Servicio_Sucursal_CenCos_1.dc_porcentaje_detraccion
FROM         TRUNNE_SERV Servicio_Sucursal_CenCos_1 LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON Servicio_Sucursal_CenCos_1.dc_servicio = tb_servicios_1.dc_servicio


GO
/****** Object:  View [dbo].[St_V_Servicios_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Servicios_Combo]
AS
SELECT     dbo.St_T_Servicios_Combo.Cod_Comb, dbo.St_T_Servicios_Combo.Cod_Seco, dbo.St_T_Servicios_Combo.Dc_Servicio, 
                      dbo.St_T_Servicios_Combo.Cod_Acue, dbo.St_T_Servicios_Combo.Val_Seco, dbo.St_T_Acuerdos.Val_Acue,  dbo.St_T_Acuerdos.Val_Acus, dbo.St_T_Acuerdos.Des_Acue, 
                      tb_centro_costo_1.dg_centro_costo AS dg_centro_costo_A, tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_A, tb_servicios_1.dg_servicio
FROM         dbo.St_T_Servicios_Combo LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON dbo.St_T_Servicios_Combo.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios_1.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS  LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo_1 RIGHT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 RIGHT OUTER JOIN
                      dbo.St_T_Acuerdos ON tb_sucursal_INST_1.dc_sucursal = dbo.St_T_Acuerdos.Dc_Sucursal_A ON 
                      tb_centro_costo_1.dc_centro_costo = dbo.St_T_Acuerdos.Dc_Centro_Costo_A ON dbo.St_T_Servicios_Combo.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue


GO
/****** Object:  View [dbo].[St_V_servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--APC20080310
ALTER VIEW [dbo].[St_V_servicios]
as

SELECT     tb_Servicios.dg_servicio, tb_Servicios.df_vigencia_inicio, tb_Servicios.df_vigencia_termino, tb_centro_costo.dg_centro_costo, 

                      tb_sucursal_INST.dg_sucursal, Servicio_Sucursal_Cencos.dc_servicio, Servicio_Sucursal_Cencos.dc_sucursal_imputacion, 

                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion, dc_usuario_creo='', tb_Servicios.dc_moneda_servicio, 

                      dbo.St_T_Moneda.Dg_Moneda_Servicio, Servicio_Sucursal_Cencos.df_final_vigencia

FROM         TTSERV tb_Servicios RIGHT OUTER JOIN

                      TRUNNE_SERV Servicio_Sucursal_Cencos ON 

                      tb_Servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio LEFT OUTER JOIN

                      dbo.St_T_Moneda ON tb_Servicios.dc_moneda_servicio = dbo.St_T_Moneda.Dc_Moneda_Servicio LEFT OUTER JOIN

                      TMTIEN tb_sucursal_INST ON 

                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion = tb_sucursal_INST.dc_sucursal LEFT OUTER JOIN

                      TTUNID_NEGO  tb_centro_costo ON 

                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = tb_centro_costo.dc_centro_costo



GO
/****** Object:  View [dbo].[Prueba_Servicios_Existente_UG]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[Prueba_Servicios_Existente_UG]
AS
SELECT     dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_V_servicios.dg_servicio
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_V_servicios ON dbo.St_T_Acuerdos.Dc_Centro_Costo_A = dbo.St_V_servicios.dc_centro_costo_imputacion AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A = dbo.St_V_servicios.dc_sucursal_imputacion AND 
                      dbo.St_T_Acuerdos.Dc_Servicio = dbo.St_V_servicios.dc_servicio COLLATE Modern_Spanish_CI_AS
GROUP BY dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_V_servicios.dg_servicio, dbo.St_T_Acuerdos.Dc_Servicio
HAVING      (dbo.St_T_Acuerdos.Dc_Centro_Costo_A = 2) AND (dbo.St_T_Acuerdos.Dc_Sucursal_A = 7) AND (dbo.St_T_Acuerdos.Dc_Centro_Costo = 2) AND 
                      (dbo.St_T_Acuerdos.Dc_Sucursal = 4) AND (dbo.St_V_servicios.dg_servicio IS NULL)

GO
/****** Object:  View [dbo].[St_V_Entidades_Caracteristicas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Entidades_Caracteristicas]
AS
SELECT     Cod_enti, Des_enti, 'E' AS Tip_Apli
FROM         dbo.St_T_entidades
WHERE     tip_enti IN (2, 3)
UNION
SELECT     Cod_Merc, Des_Merc, 'C' AS Tip_Apli
FROM         dbo.St_T_Caracteristicas_Mercaderia
WHERE     tip_cara IN (2, 3)


GO
/****** Object:  View [dbo].[St_V_Acuerdos_Apl]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Acuerdos_Apl]
as
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.Usu_Acue, 
                      dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, dbo.St_T_Acuerdos.Tar_Maxi, 
                      dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Dc_Servicio, 
                      dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Cod_Ante, dbo.St_T_Acuerdos.Fec_Term, dbo.St_T_Acuerdos.Cod_Tari, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_T_Acuerdos.Cod_Aplc, dbo.St_T_Acuerdos.Cod_aplp, dbo.St_V_Entidades_Caracteristicas.Des_enti, 
                      dbo.St_T_Aplica.Des_Aplp, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, 
                      Tb_Sucursal_inst_A.dg_sucursal
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      TMTIEN Tb_Sucursal_inst_A ON 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A = Tb_Sucursal_inst_A.dc_sucursal LEFT OUTER JOIN
                      dbo.St_T_Aplica ON dbo.St_T_Acuerdos.Cod_aplp = dbo.St_T_Aplica.Cod_aplp LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo_A = Tb_centro_costo.dc_centro_costo LEFT OUTER JOIN
                      dbo.St_V_Entidades_Caracteristicas ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_V_Entidades_Caracteristicas.Cod_enti AND 
                      dbo.St_T_Acuerdos.Tip_Aplc = dbo.St_V_Entidades_Caracteristicas.Tip_Apli
WHERE     (dbo.St_T_Acuerdos.Flg_Tari = 0)
ORDER BY dbo.St_T_Acuerdos.Cod_Acue


GO
/****** Object:  View [dbo].[St_V_Tarifas_Apl]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Tarifas_Apl]
as

SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_inst.dg_sucursal, tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, 
                      dbo.St_T_Acuerdos.Usu_Acue, dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, 
                      dbo.St_T_Acuerdos.Tar_Maxi, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Centro_Costo_A,dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Dc_Sucursal_A, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Flg_Apli, 
                      dbo.St_T_Acuerdos.Val_Proc, dbo.St_T_Acuerdos.Flg_Proc, dbo.St_T_Acuerdos.Cod_Ante, dbo.St_T_Acuerdos.Fec_Term, dbo.St_T_Acuerdos.Cod_Aplc, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_V_Entidades_Caracteristicas.Des_enti, dbo.St_T_Acuerdos.Cod_Tar13, dbo.St_T_Acuerdos.Cod_Tari, 
                      dbo.St_T_Acuerdos.Cod_aplp, dbo.St_T_Aplica.Des_Aplp, dbo.St_T_Acuerdos.Nro_Sec21
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Aplica ON dbo.St_T_Acuerdos.Cod_aplp = dbo.St_T_Aplica.Cod_aplp LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal_A = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo_A = Tb_centro_costo.dc_centro_costo LEFT OUTER JOIN
                      dbo.St_V_Entidades_Caracteristicas ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_V_Entidades_Caracteristicas.Cod_enti AND 
                      dbo.St_T_Acuerdos.Tip_Aplc = dbo.St_V_Entidades_Caracteristicas.Tip_Apli
WHERE     (dbo.St_T_Acuerdos.Flg_Tari = 1 and dbo.St_T_Acuerdos.Cod_Esta<>'I')
ORDER BY dbo.St_T_Acuerdos.Cod_Acue


GO
/****** Object:  View [dbo].[St_V_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Tarifas]
as
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_inst.dg_sucursal, tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, 
                      dbo.St_T_Acuerdos.Usu_Acue, dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, 
                      dbo.St_T_Acuerdos.Tar_Maxi, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Flg_Apli, 
                      dbo.St_T_Acuerdos.Val_Proc, dbo.St_T_Acuerdos.Flg_Proc, dbo.St_T_Acuerdos.Cod_Ante, dbo.St_T_Acuerdos.Fec_Term, dbo.St_T_Acuerdos.Cod_Aplc, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_V_Entidades_Caracteristicas.Des_enti, dbo.St_T_Acuerdos.Cod_Tar13, dbo.St_T_Acuerdos.Cod_Tari, 
                      dbo.St_T_Acuerdos.Cod_aplp, dbo.St_T_Aplica.Des_Aplp, dbo.St_T_Acuerdos.Nro_Sec21, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A,dbo.St_T_Acuerdos.Tip_Valo,dbo.St_T_Acuerdos.Des_seri, dbo.St_T_Acuerdos.Val_Acus,dbo.St_T_Acuerdos.Val_Pros,dbo.St_T_Acuerdos.Tar_Mins,dbo.St_T_Acuerdos.Tar_Maxs
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Aplica ON dbo.St_T_Acuerdos.Cod_aplp = dbo.St_T_Aplica.Cod_aplp LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = Tb_centro_costo.dc_centro_costo LEFT OUTER JOIN
                      dbo.St_V_Entidades_Caracteristicas ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_V_Entidades_Caracteristicas.Cod_enti AND 
                      dbo.St_T_Acuerdos.Tip_Aplc = dbo.St_V_Entidades_Caracteristicas.Tip_Apli
WHERE     (dbo.St_T_Acuerdos.Flg_Tari = 1) and (dbo.St_T_Acuerdos.Cod_Esta <> 'I') 
ORDER BY dbo.St_T_Acuerdos.Cod_Acue

GO
/****** Object:  View [dbo].[St_V_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Acuerdos]
as
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.CONTRIBUY, AACLIENTESAA.NOMBRE, Tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_inst.dg_sucursal, tb_servicios.dg_servicio, dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Estados.Des_Esta, dbo.St_T_Acuerdos.Val_Acue, 
                      dbo.St_T_Acuerdos.Usu_Acue, dbo.St_T_Acuerdos.Fec_Crea, dbo.St_T_Acuerdos.Fec_Acti, dbo.St_T_Acuerdos.Fec_Apro, dbo.St_T_Acuerdos.Tar_Mini, 
                      dbo.St_T_Acuerdos.Tar_Maxi, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Cod_Ante, 
                      dbo.St_T_Acuerdos.Fec_Term, dbo.St_T_Acuerdos.Cod_Tari, dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_T_Acuerdos.Cod_Aplc, dbo.St_T_Acuerdos.Cod_aplp, 
                      dbo.St_V_Entidades_Caracteristicas.Des_enti, dbo.St_T_Aplica.Des_Aplp, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, 
                      Tb_Sucursal_inst_A.dg_sucursal AS Dg_Sucursal_A,dbo.St_T_Acuerdos.Tip_Valo,dbo.St_T_Acuerdos.Des_seri,dbo.St_T_Acuerdos.Val_Acus,dbo.St_T_Acuerdos.Val_Pros,dbo.St_T_Acuerdos.Tar_Mins,dbo.St_T_Acuerdos.Tar_Maxs
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      TMTIEN Tb_Sucursal_inst_A ON 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A = Tb_Sucursal_inst_A.dc_sucursal LEFT OUTER JOIN
                      dbo.St_T_Aplica ON dbo.St_T_Acuerdos.Cod_aplp = dbo.St_T_Aplica.Cod_aplp LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      dbo.St_T_Acuerdos.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      dbo.St_T_Estados ON 
                      dbo.St_T_Acuerdos.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.St_T_Estados.Cod_Esta COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON 
                      dbo.St_T_Acuerdos.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = Tb_centro_costo.dc_centro_costo LEFT OUTER JOIN
                      dbo.St_V_Entidades_Caracteristicas ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_V_Entidades_Caracteristicas.Cod_enti AND 
                      dbo.St_T_Acuerdos.Tip_Aplc = dbo.St_V_Entidades_Caracteristicas.Tip_Apli
WHERE     (dbo.St_T_Acuerdos.Flg_Tari = 0)
ORDER BY dbo.St_T_Acuerdos.Cod_Acue




GO
/****** Object:  View [dbo].[ST_V_NServicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_NServicios]
AS
SELECT     tb_Servicios.dc_servicio AS Codigo, tb_Servicios.dg_servicio AS Descripcion, tb_Servicios.df_vigencia_inicio AS Fecha_Inicio, 
                      tb_Servicios.df_vigencia_termino AS FechaFinal, tb_centro_costo.dg_centro_costo AS Centro_Costo, tb_sucursal_INST.dg_sucursal AS Sucursal, 
                      tb_Servicios.dc_moneda_servicio AS Moneda
FROM         TTSERV tb_Servicios LEFT OUTER JOIN
                      TRUNNE_SERV Servicio_Sucursal_Cencos ON 
                      tb_Servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST ON 
                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion = tb_sucursal_INST.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo ON 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = tb_centro_costo.dc_centro_costo


GO
/****** Object:  View [dbo].[St_V_Tb_Servicios_renombrado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tb_Servicios_renombrado]
as
/*
SELECT     Servicio_Sucursal_Cencos.dc_servicio AS Dc_Servicio, tb_servicios.dg_servicio AS Dg_Servicio, tb_servicios.dc_usuario_creo AS Dc_Usuario_Creo, 
                      tb_servicios.df_vigencia_inicio AS Df_Vigencia_Inicio, tb_servicios.df_vigencia_termino AS Df_Vigencia_Termino, 
                      tb_servicios.dc_moneda_servicio AS Dc_Moneda_Servicio,  Servicio_Sucursal_Cencos.dc_centro_costo_imputacion AS Dc_Centro_Costo_imputacion,
Servicio_Sucursal_Cencos.dc_sucursal_imputacion AS Dc_sucursal_imputacion
FROM         NEPTUNIA9.bd_nept.dbo.tb_servicios tb_servicios RIGHT OUTER JOIN
                      NEPTUNIA9.bd_nept.dbo.Servicio_Sucursal_CenCos Servicio_Sucursal_Cencos ON tb_servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio

*/

SELECT     Servicio_Sucursal_Cencos.dc_servicio AS Dc_Servicio, tb_servicios.dg_servicio AS  dg_servicio, Dc_Usuario_Creo='', 
                      tb_servicios.df_vigencia_inicio AS Df_Vigencia_Inicio, tb_servicios.df_vigencia_termino AS Df_Vigencia_Termino, 
                      tb_servicios.dc_moneda_servicio AS Dc_Moneda_Servicio,  Servicio_Sucursal_Cencos.dc_centro_costo_imputacion AS Dc_Centro_Costo_imputacion,
Servicio_Sucursal_Cencos.dc_sucursal_imputacion AS Dc_sucursal_imputacion
FROM         TTSERV tb_servicios RIGHT OUTER JOIN
                     TRUNNE_SERV   Servicio_Sucursal_Cencos ON tb_servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio


GO
/****** Object:  View [dbo].[St_V_Asignaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Asignaciones]
as
SELECT     dbo.ST_T_Asignaciones.Cod_Asig, dbo.ST_T_Asignaciones.Dc_Centro_Costo, dbo.ST_T_Asignaciones.Dc_Sucursal, 
                      dbo.ST_T_Asignaciones.Dc_Servicio, tb_centro_costo_1.dg_centro_costo, tb_sucursal_INST_1.dg_sucursal, tb_servicios_1.dg_servicio, 
                      dbo.ST_T_Asignaciones.Tam_Cont, dbo.ST_T_Asignaciones.Cod_Line, DQARMADO10_1.desarm10 AS Nom_Line,dbo.ST_T_Asignaciones.Cod_Depo,dbo.ST_T_Asignaciones.Es_Inte,dbo.ST_T_Asignaciones.Otr_Line, dbo.St_T_Asignaciones.Tip_Eval  
FROM         dbo.ST_T_Asignaciones LEFT OUTER JOIN
                      Terminal.dbo.DQARMADO10 DQARMADO10_1 ON 
                      dbo.ST_T_Asignaciones.Cod_Line COLLATE SQL_Latin1_General_CP1_CI_AS = DQARMADO10_1.codarm10 COLLATE SQL_Latin1_General_CP1_CI_AS LEFT
                       OUTER JOIN
                      TTSERV tb_servicios_1 ON 
                      dbo.ST_T_Asignaciones.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios_1.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 ON 
                      dbo.ST_T_Asignaciones.Dc_Sucursal = tb_sucursal_INST_1.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo_1 ON dbo.ST_T_Asignaciones.Dc_Centro_Costo = tb_centro_costo_1.dc_centro_costo


GO
/****** Object:  View [dbo].[St_V_sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW  [dbo].[St_V_sucursal]
as
SELECT      dc_sucursal AS Dc_sucursal, dg_sucursal AS Dg_sucursal
FROM         TMTIEN tb_sucursal_INST


GO
/****** Object:  View [dbo].[St_V_Servicios_Asignados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Servicios_Asignados]
as
SELECT     dbo.St_T_Servicios_Asignados.Cod_Seas, dbo.St_T_Servicios_Asignados.Cod_Asig, dbo.St_T_Servicios_Asignados.Dc_Centro_Costo, 
                      dbo.St_T_Servicios_Asignados.Dc_Sucursal, dbo.St_T_Servicios_Asignados.Dc_Servicio, dbo.St_T_Servicios_Asignados.Por_Asig, 
                      tb_centro_costo_1.dg_centro_costo, tb_sucursal_INST_1.dg_sucursal, tb_servicios_1.dg_servicio
FROM         dbo.St_T_Servicios_Asignados LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Sucursal = tb_sucursal_INST_1.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Centro_Costo = tb_centro_costo_1.dc_centro_costo LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON 
                      dbo.St_T_Servicios_Asignados.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios_1.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS



GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Esp]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--APC20080310
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Esp]
AS
SELECT     Servicio_Sucursal_Cencos.dm_detraccion AS Apl_Detr, Servicio_Sucursal_Cencos.Afecto_IGV AS Apl_Igv, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.ID, dbo.ST_TR_Servicios_Manuales_Especiales.ID_Item, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo, dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv, tb_servicios_1.dg_servicio AS Des_Acue, 0 AS Cod_Acue,0 as Flg_Inte, 
		Servicio_Sucursal_Cencos.dc_porcentaje_detraccion
FROM         TRUNNE_SERV Servicio_Sucursal_Cencos LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON Servicio_Sucursal_Cencos.dc_servicio = tb_servicios_1.dc_servicio RIGHT OUTER JOIN
                      dbo.ST_TR_Servicios_Manuales_Especiales ON 
                      Servicio_Sucursal_Cencos.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS  = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS  AND 
                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion  = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal AND 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo 
WHERE     (dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv <> 0)


GO
/****** Object:  View [dbo].[St_V_servicios_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_servicios_old]
as
SELECT     tb_Servicios.dg_servicio, tb_Servicios.df_vigencia_inicio, tb_Servicios.df_vigencia_termino, tb_centro_costo.dg_centro_costo, 
                      tb_sucursal_INST.dg_sucursal, Servicio_Sucursal_Cencos.dc_servicio, Servicio_Sucursal_Cencos.dc_sucursal_imputacion, 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion, dc_usuario_creo='', tb_Servicios.dc_moneda_servicio, 
                      dbo.St_T_Moneda.Dg_Moneda_Servicio
FROM         TTSERV tb_Servicios LEFT OUTER JOIN
                      dbo.St_T_Moneda ON tb_Servicios.dc_moneda_servicio = dbo.St_T_Moneda.Dc_Moneda_Servicio LEFT OUTER JOIN
                      TRUNNE_SERV Servicio_Sucursal_Cencos ON 
                      tb_Servicios.dc_servicio = Servicio_Sucursal_Cencos.dc_servicio LEFT OUTER JOIN
                      TMTIEN tb_sucursal_INST ON 
                      Servicio_Sucursal_Cencos.dc_sucursal_imputacion = tb_sucursal_INST.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  tb_centro_costo ON 
                      Servicio_Sucursal_Cencos.dc_centro_costo_imputacion = tb_centro_costo.dc_centro_costo


GO
/****** Object:  View [dbo].[St_V_Acuerdos_All]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Acuerdos_All]  
as  
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, Tb_centro_costo.dg_centro_costo AS Dg_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Centro_Costo_A,   
                      dbo.St_T_Acuerdos.Dc_Sucursal_A, Tb_Sucursal_inst_A.dg_sucursal AS Dg_Sucursal_A, dbo.St_T_Acuerdos.Des_Acue,dbo.St_t_Acuerdos.Dc_Servicio, St_T_Acuerdos.Flg_Tari, St_T_Acuerdos.Contribuy  
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN  
                      TTUNID_NEGO  Tb_centro_costo ON   
                      dbo.St_T_Acuerdos.Dc_Centro_Costo_A = Tb_centro_costo.dc_centro_costo LEFT OUTER JOIN  
                      TMTIEN Tb_Sucursal_inst_A ON dbo.St_T_Acuerdos.Dc_Sucursal_A = Tb_Sucursal_inst_A.dc_sucursal  
where cod_esta <> 'I'
ORDER BY dbo.St_T_Acuerdos.Cod_Acue  


GO
/****** Object:  View [dbo].[St_V_Cu_Tarifario_Cubo_Rep_no_int_expo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Cu_Tarifario_Cubo_Rep_no_int_expo]
AS  
SELECT     tb_servicios.dg_servicio AS dg_servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl,   
                      AACLIENTESAA.NOMBRE AS Cliente, ST_T_TARIFARIO_CUBO_1.*, Terminal.dbo.TB_Vendedor.NomVen AS Vendedor,   
                      AACLIENTESAA.VENDEDOR AS Cod_Vend, dbo.tr_tmp_clientes_expo_2005_2006.Flag AS Flag  
FROM         TTSERV tb_servicios RIGHT OUTER JOIN  
                      dbo.tr_tmp_clientes_expo_2005_2006 RIGHT OUTER JOIN  
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON   
                      dbo.tr_tmp_clientes_expo_2005_2006.Contribuy = ST_T_TARIFARIO_CUBO_1.Contribuy LEFT OUTER JOIN  
                      TMTIEN tb_sucursal_INST_1 ON ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a = tb_sucursal_INST_1.dc_sucursal ON   
                      tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS = ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS  
                       LEFT OUTER JOIN  
                      Terminal.dbo.TB_Vendedor RIGHT OUTER JOIN  
                      Terminal.dbo.AACLIENTESAA AACLIENTESAA ON Terminal.dbo.TB_Vendedor.IdCodVen = AACLIENTESAA.VENDEDOR ON   
                      ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS  
                       LEFT OUTER JOIN  
                      TTUNID_NEGO  Tb_centro_costo ON   
                      ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo  
WHERE     (ST_T_TARIFARIO_CUBO_1.Cod_Esta <> 'I') AND (ST_T_TARIFARIO_CUBO_1.Cod_Acue <= 13280) AND   
                      (ST_T_TARIFARIO_CUBO_1.Dc_Servicio not IN (465, 170, 466)) AND (ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = 2) AND   
                      (dbo.tr_tmp_clientes_expo_2005_2006.Flag = 'E')   
  

GO
/****** Object:  View [dbo].[ST_V_Buscar_Asignacionesprueba]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_Buscar_Asignacionesprueba]
as
select St_T_Servicios_Asignados.Cod_Asig
FROM    
     dbo.St_T_Servicios_Asignados  as St_T_Servicios_Asignados 
RIGHT OUTER JOIN dbo.ST_T_Asignaciones as ST_T_Asignaciones 
ON St_T_Servicios_Asignados.Cod_Asig = ST_T_Asignaciones.Cod_Asig 
LEFT OUTER JOIN  TMTIEN tb_sucursal_INST_1 ON   
St_T_Servicios_Asignados.Dc_Sucursal = tb_sucursal_INST_1.dc_sucursal 


GO
/****** Object:  View [dbo].[St_V_Centros]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[St_V_Centros]
as
SELECT     dc_centro_costo, dg_centro_costo, df_inicio_vigencia, df_termino_vigencia
FROM         TTUNID_NEGO  tb_centro_costo


GO
/****** Object:  View [dbo].[st_v_tr_Acuerdo_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW [dbo].[st_v_tr_Acuerdo_Servicio]
as  

SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Dc_Centro_Costo, ISNULL(dbo.St_T_Acuerdos.Dc_Sucursal, 0) AS Dc_Sucursal, 
                      dbo.St_T_Acuerdos.Dc_Servicio, Servicio_Sucursal_Cencos.dm_detraccion, Servicio_Sucursal_Cencos.Afecto_IGV, 
                      dbo.St_T_Acuerdos.Des_Acue AS Des_Acuerdo, dbo.St_T_Acuerdos.Val_Acue, Servicio_Sucursal_Cencos.dc_porcentaje_detraccion, 
                      tb_servicios_1.dg_servicio AS Des_Acue
FROM         TTSERV tb_servicios_1 RIGHT OUTER JOIN
                      dbo.St_T_Acuerdos ON 
                      tb_servicios_1.dc_servicio COLLATE Modern_Spanish_CI_AS = dbo.St_T_Acuerdos.Dc_Servicio COLLATE Modern_Spanish_CI_AS LEFT OUTER JOIN
                      TRUNNE_SERV Servicio_Sucursal_Cencos ON 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = Servicio_Sucursal_Cencos.dc_centro_costo_imputacion AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = Servicio_Sucursal_Cencos.dc_sucursal_imputacion AND 
                      dbo.St_T_Acuerdos.Dc_Servicio = Servicio_Sucursal_Cencos.dc_servicio COLLATE Modern_Spanish_CI_AS


GO
/****** Object:  View [dbo].[St_V_Carga_combos_Antiguos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER VIEW  [dbo].[St_V_Carga_combos_Antiguos]
as
SELECT DISTINCT 
                      TOP 100 PERCENT dbo.St_T_Combos.Cod_Comb, dbo.St_T_Combos.Contribuy, dbo.St_T_Servicios_Combo.Dc_Servicio, 
                      GQCONTAR14_NT_1.codcon14, tb_servicios_1.dg_servicio, dbo.St_T_Combos.Tip_Comb, dbo.St_T_Acuerdos.Dc_Centro_Costo_A
FROM         dbo.St_T_Acuerdos RIGHT OUTER JOIN
                      dbo.St_T_Servicios_Combo ON dbo.St_T_Acuerdos.Cod_Acue = dbo.St_T_Servicios_Combo.Cod_Acue LEFT OUTER JOIN
                      TTSERV tb_servicios_1 ON 
                      dbo.St_T_Servicios_Combo.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios_1.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      Descarga.dbo.GQCONTAR14_NT GQCONTAR14_NT_1 ON 
                      dbo.St_T_Servicios_Combo.Dc_Servicio = GQCONTAR14_NT_1.codsbd03 COLLATE Modern_Spanish_CI_AS RIGHT OUTER JOIN
                      dbo.St_T_Combos ON dbo.St_T_Servicios_Combo.Cod_Comb = dbo.St_T_Combos.Cod_Comb
WHERE     (dbo.St_T_Combos.Tip_Comb = 'I') AND (dbo.St_T_Acuerdos.Dc_Centro_Costo_A = 2) AND (GQCONTAR14_NT_1.codcon14 <> 'AFCLM')
ORDER BY dbo.St_T_Combos.Cod_Comb


GO
/****** Object:  View [dbo].[tmp_borrar]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[tmp_borrar]
AS
SELECT     TOP 100 PERCENT dbo.St_T_Acuerdos.Cod_Acue, dbo.AACLIENTESAA.CONTRIBUY, dbo.AACLIENTESAA.NOMBRE, dbo.St_T_Acuerdos.Fec_Acti
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.AACLIENTESAA ON dbo.St_T_Acuerdos.CONTRIBUY = dbo.AACLIENTESAA.CONTRIBUY COLLATE Modern_Spanish_CI_AS
WHERE     (dbo.St_T_Acuerdos.Dc_Servicio = 999) AND (dbo.St_T_Acuerdos.Flg_Tari = 0)
ORDER BY dbo.St_T_Acuerdos.Cod_Acue

GO
/****** Object:  View [dbo].[Servicios_T]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[Servicios_T]
as
select * from 
TTSERV

GO
/****** Object:  View [dbo].[st_V_cu_Acuerdos_Clientes_Dolares]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[st_V_cu_Acuerdos_Clientes_Dolares]
as
SELECT     tb_servicios.dg_servicio AS Dg_Servicio, Tb_centro_costo.dg_centro_costo AS dg_centro_costo_apl, 
                      tb_sucursal_INST_1.dg_sucursal AS dg_sucursal_apl, AACLIENTESAA.NOMBRE AS Cliente, AACLIENTESAA.VENDEDOR as Ejecutivo, ST_T_TARIFARIO_CUBO_1.*
FROM         TMTIEN tb_sucursal_INST_1 RIGHT OUTER JOIN
                      dbo.ST_T_TARIFARIO_CUBO ST_T_TARIFARIO_CUBO_1 ON 
                      tb_sucursal_INST_1.dc_sucursal = ST_T_TARIFARIO_CUBO_1.Dc_Sucursal_a LEFT OUTER JOIN
                      TTSERV tb_servicios ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS = tb_servicios.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TERMINAL.dbo.AACLIENTESAA AACLIENTESAA ON 
                      ST_T_TARIFARIO_CUBO_1.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = AACLIENTESAA.CONTRIBUY COLLATE SQL_Latin1_General_CP1_CI_AS
                       LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON 
                      ST_T_TARIFARIO_CUBO_1.Dc_Centro_Costo_a = Tb_centro_costo.dc_centro_costo
WHERE     (ST_T_TARIFARIO_CUBO_1.Cod_Esta <> 'I') and
ST_T_TARIFARIO_CUBO_1.Contribuy in (select Contribuy from St_T_Clientes_Moneda where Tip_mone='D')


GO
/****** Object:  View [dbo].[AASERINT]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[AASERINT]
AS
SELECT     *
FROM         Terminal.dbo.AASERINT

GO
/****** Object:  View [dbo].[DDCABMAN11]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDCABMAN11]
AS
SELECT     *
FROM         Terminal.dbo.DDCABMAN11

GO
/****** Object:  View [dbo].[DDCARGAS16]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDCARGAS16]
AS
SELECT     *
FROM         Terminal.dbo.DDCARGAS16

GO
/****** Object:  View [dbo].[DDCARTAR22]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDCARTAR22]
AS
SELECT     *
FROM         Terminal.dbo.DDCARTAR22

GO
/****** Object:  View [dbo].[DDCONTAR63]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDCONTAR63]
AS
SELECT     *
FROM         Terminal.dbo.DDCONTAR63

GO
/****** Object:  View [dbo].[DDDESCUE79]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDESCUE79]
AS
SELECT     *
FROM         Terminal.dbo.DDDESCUE79

GO
/****** Object:  View [dbo].[DDDETALL12]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDETALL12]
AS
SELECT     *
FROM         Terminal.dbo.DDDETALL12

GO
/****** Object:  View [dbo].[DDDETDSC80]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDETDSC80]
AS
SELECT     *
FROM         Terminal.dbo.DDDETDSC80

GO
/****** Object:  View [dbo].[DDDETORD43]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDETORD43]
AS
SELECT     *
FROM         Terminal.dbo.DDDETORD43

GO
/****** Object:  View [dbo].[DDDETORS33]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDETORS33]
AS
SELECT     *
FROM         Terminal.dbo.DDDETORS33

GO
/****** Object:  View [dbo].[DDDETTRA68]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDDETTRA68]
AS
SELECT     *
FROM         Terminal.dbo.DDDETTRA68

GO
/****** Object:  View [dbo].[DDFACTUR37]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DDFACTUR37]
AS
SELECT     *
FROM         Terminal.dbo.DDFACTUR37


GO
/****** Object:  View [dbo].[DDORDRET41]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDORDRET41]
AS
SELECT     *
FROM         Terminal.dbo.DDORDRET41

GO
/****** Object:  View [dbo].[DDORDSER32]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDORDSER32]
AS
SELECT     *
FROM         Terminal.dbo.DDORDSER32

GO
/****** Object:  View [dbo].[DDORDTRA67]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDORDTRA67]
AS
SELECT     *
FROM         Terminal.dbo.DDORDTRA67

GO
/****** Object:  View [dbo].[DDVEHICU14]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDVEHICU14]
AS
SELECT     *
FROM         Terminal.dbo.DDVEHICU14

GO
/****** Object:  View [dbo].[DDVOLDES23]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDVOLDES23]
AS
SELECT     *
FROM         Terminal.dbo.DDVOLDES23

GO
/****** Object:  View [dbo].[DQARMADO10]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DQARMADO10]
AS
SELECT     *
FROM         Terminal.dbo.DQARMADO10

GO
/****** Object:  View [dbo].[DQREGIME56]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DQREGIME56]
AS
SELECT     *
FROM         Terminal.dbo.DQREGIME56

GO
/****** Object:  View [dbo].[DRBLCONT15]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DRBLCONT15]
AS
SELECT     *
FROM         Terminal.dbo.DRBLCONT15

GO
/****** Object:  View [dbo].[DRITVODE26]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DRITVODE26]
AS
SELECT     *
FROM         Terminal.dbo.DRITVODE26

GO
/****** Object:  View [dbo].[DRNAVSER31]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DRNAVSER31]
AS
SELECT     *
FROM         Terminal.dbo.DRNAVSER31

GO
/****** Object:  View [dbo].[edauting14]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[edauting14]
as
select * from descarga.dbo.edauting14

GO
/****** Object:  View [dbo].[edbookin13]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[edbookin13]
as
select * from descarga.dbo.edbookin13

GO
/****** Object:  View [dbo].[eddetord51]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[eddetord51]
as
select * from descarga.dbo.eddetord51

GO
/****** Object:  View [dbo].[edllenad16]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[edllenad16] 
as
select * from descarga.dbo.edllenad16 


GO
/****** Object:  View [dbo].[edordser50]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[edordser50]
as
select * from descarga.dbo.edordser50

GO
/****** Object:  View [dbo].[FDDETFAC07]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[FDDETFAC07]
AS
SELECT     *
FROM         Terminal.dbo.FDDETFAC07

GO
/****** Object:  View [dbo].[FQCONTAR14]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[FQCONTAR14]  
AS  
SELECT  codcon14,
descon14,
apligv14,
seccon14,
tipmon14,
desman14,
ordser14,
codusu17,
fecusu00,
tiptar14,
codgru14,
codcue01,
codsbd03,
flgtra99,
fectra99,
cencos14,
activo14,
sucursal,
cencof14,
sucursal14,
flgdtr14,
pordet14,
flgweb14,
flgvac14,
cencob14,
sucursaf14,
sucursab14,
flgena14,
flgmue14,
codsbd03_D,
codsbd03_tmp
FROM  Terminal.dbo.FQCONTAR14  

GO
/****** Object:  View [dbo].[gqcontar14_nt]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[gqcontar14_nt]  
as  
select codcon14,
descon14,
apligv14,
seccon14,
tarmin14,
tipmon14,
desman14,
ordser14,
flgman14,
codcta14,
codsub14,
codgru15,
tiptar14,
tarpro14,
codcue01,
codsbd03,
cencos14,
activo14,
codusu17,
fecusu00,
codgru14,
sucurs14,
sucursal,
flgdtr14,
pordtr14,
flgena14,
codsbd03d
from descarga.dbo.gqcontar14_nt  

GO
/****** Object:  View [dbo].[IMP_FACTURA_SELECCION_MERCADERIA]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[IMP_FACTURA_SELECCION_MERCADERIA]
AS
SELECT     *
FROM         Terminal.dbo.IMP_FACTURA_SELECCION_MERCADERIA

GO
/****** Object:  View [dbo].[St_V_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Aplica]
AS
SELECT     Cod_aplp, Des_Aplp
FROM         dbo.St_T_Aplica

GO
/****** Object:  View [dbo].[St_V_Aplicaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Aplicaciones
    Fecha       : 22/Nov/2005
   JF.
*/
--ALTER VIEW [dbo].[St_V_Aplicaciones]
--AS
--SELECT     Cod_Apli, Des_Apli
--FROM         dbo.St_T_Aplicaciones

--GO
/****** Object:  View [dbo].[ST_V_Buscar_Asignaciones_pruebas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_Buscar_Asignaciones_pruebas]  
as  
SELECT  *from    dbo.St_T_Servicios_Asignados 

GO
/****** Object:  View [dbo].[St_V_Buscar_Usuarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Buscar_Usuarios]
AS
SELECT     dbo.St_T_Usuarios.Pas_Usua, dbo.St_T_Usuarios.Nom_Usua, dbo.St_T_Usuarios.Cod_Usua, dbo.St_T_Usuarios.Cod_Perf, 
                      dbo.St_T_Perfil_Usuario.Des_Porc
FROM         dbo.St_T_Usuarios LEFT OUTER JOIN
                      dbo.St_T_Perfil_Usuario ON dbo.St_T_Usuarios.Cod_Perf = dbo.St_T_Perfil_Usuario.Cod_Perf

GO
/****** Object:  View [dbo].[St_V_Caracteristicas_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Caracteristicas_Acuerdos]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue, dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, 
                      dbo.St_T_Caracteristicas_Acuerdo.Val_Meac, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, dbo.St_T_Caracteristicas_Acuerdo.Cod_Meac, 
                      dbo.St_T_Caracteristicas_Acuerdo.Des_Meac, dbo.St_T_Caracteristicas_Mercaderia.Val_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tam_Merc, 
                      dbo.St_T_Caracteristicas_Acuerdo.flg_proc
FROM         dbo.St_T_Caracteristicas_Mercaderia RIGHT OUTER JOIN
                      dbo.St_T_Caracteristicas_Acuerdo ON dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc = dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc

GO
/****** Object:  View [dbo].[St_V_Caracteristicas_Acuerdos_Combos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Caracteristicas_Acuerdos_Combos]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue, dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Acuerdo.Val_Meac, 
                      dbo.St_T_Caracteristicas_Acuerdo.Des_Meac, dbo.St_T_Caracteristicas_Combo.Cod_Comb, dbo.St_T_Caracteristicas_Combo.Val_Caco
FROM         dbo.St_T_Caracteristicas_Acuerdo LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Combo ON dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc = dbo.St_T_Caracteristicas_Combo.Cod_Merc


GO
/****** Object:  View [dbo].[St_V_Caracteristicas_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Caracteristicas_Combo]
AS
SELECT     dbo.St_T_Caracteristicas_Combo.Cod_Caco, dbo.St_T_Caracteristicas_Combo.Cod_Merc, dbo.St_T_Caracteristicas_Combo.Cod_Comb, 
                      dbo.St_T_Caracteristicas_Combo.Val_Caco, dbo.St_T_Caracteristicas_Combo.Des_Caco, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, dbo.St_T_Caracteristicas_Mercaderia.Val_Merc, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tam_Merc
FROM         dbo.St_T_Caracteristicas_Combo LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Caracteristicas_Combo.Cod_Merc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc

GO
/****** Object:  View [dbo].[St_V_Caracteristicas_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Caracteristicas_Mercaderia]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, 
                      dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Acuerdo.Val_Meac, dbo.St_T_Caracteristicas_Acuerdo.Des_Meac, 
                      dbo.St_T_Caracteristicas_Acuerdo.Cod_Meac, dbo.St_T_Caracteristicas_Acuerdo.flg_proc
FROM         dbo.St_T_Caracteristicas_Acuerdo INNER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc


GO
/****** Object:  View [dbo].[St_V_Caracteristicas_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar caracteristicas de las tarifas
    Fecha       : 26/Nov/2005
   CA.
*/
ALTER VIEW [dbo].[St_V_Caracteristicas_Tarifas]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue, dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, 
                      dbo.St_T_Caracteristicas_Acuerdo.Val_Meac, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, dbo.St_T_Caracteristicas_Acuerdo.Cod_Meac, 
                      dbo.St_T_Caracteristicas_Acuerdo.Des_Meac, dbo.St_T_Caracteristicas_Mercaderia.Val_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tam_Merc, 
                      dbo.St_T_Caracteristicas_Acuerdo.flg_proc
FROM         dbo.St_T_Caracteristicas_Mercaderia RIGHT OUTER JOIN
                      dbo.St_T_Caracteristicas_Acuerdo ON dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc = dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc

GO
/****** Object:  View [dbo].[St_V_CI_Contribuy_expo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Contribuy_expo]
AS
SELECT     nrosec20, tipent03, codent22, entida22
FROM         Descarga.dbo.GRCNDRES22_NT GRCNDRES22_NT
WHERE     (tipent03 = 04)

GO
/****** Object:  View [dbo].[St_V_CI_Expo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Expo]
AS
SELECT     GQCONTAR14_NT.codsbd03, GDTARSER13_NT.codtar13, GDTARSER13_NT.codpro27, GDTARSER13_NT.codemb06, GDTARSER13_NT.codbol03, 
                      GDTARSER13_NT.desimp13, GDTARSER13_NT.valser13, GDTARSER13_NT.codcon14, GDTARSER13_NT.aplica13, GDTARSER13_NT.tipmon13, 
                      GDTARSER13_NT.flgref13, GDTARSER13_NT.tipser13, GDTARSER13_NT.tiptar13, GDTARSER13_NT.flgtra99, GDTARSER13_NT.fectra99, 
                      GDTARSER13_NT.tarmin13, GDTARSER13_NT.tarmax13, GDTARSER13_NT.finvig13, GDTARSER13_NT.inivig13, GDTARSER13_NT.codusu17, 
                      GDTARSER13_NT.fecusu00, GDTARSER13_NT.estado13, GDTARSER13_NT.sucursal
FROM         Descarga.dbo.GDTARSER13_NT GDTARSER13_NT LEFT OUTER JOIN
                      Descarga.dbo.GQCONTAR14_NT GQCONTAR14_NT ON GDTARSER13_NT.sucursal = GQCONTAR14_NT.sucursal AND 
                      GDTARSER13_NT.codcon14 = GQCONTAR14_NT.codcon14
WHERE    (GDTARSER13_NT.sucursal <> 3) AND (GDTARSER13_NT.aplica13 <> 'R')


GO
/****** Object:  View [dbo].[St_V_CI_Expo_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*WHERE     (dbo.St_V_CI_Contribuy_expo.codent22 = '20380336384')
'20342015108'*/
ALTER VIEW [dbo].[St_V_CI_Expo_Acue]
AS
SELECT     GQCONTAR14_NT.codsbd03, GDTARSER13_NT.codtar13, GDTARSER13_NT.codpro27, GDTARSER13_NT.codemb06, GDTARSER13_NT.codbol03, 
                      GDDESPRG21_NT.observ21 AS desimp13, GDTARSER13_NT.valser13, GDTARSER13_NT.codcon14, GDTARSER13_NT.aplica13, 
                      GDTARSER13_NT.tipmon13, GDTARSER13_NT.flgref13, GDTARSER13_NT.tipser13, GDTARSER13_NT.tiptar13, GDTARSER13_NT.flgtra99, 
                      GDTARSER13_NT.fectra99, GDTARSER13_NT.tarmin13, GDTARSER13_NT.tarmax13, GDTARSER13_NT.finvig13, GDTARSER13_NT.inivig13, 
                      GDDESPRG21_NT.codusu17, GDDESPRG21_NT.fecusu00, GDTARSER13_NT.estado13, GDTARSER13_NT.sucursal, GDDESPRG21_NT.nrosec21, 
                      GDDESPRG21_NT.tipdsc21, GDDESPRG21_NT.descto21, GDDESPRG21_NT.dialib21
FROM         Descarga.dbo.GDDESPRG21_NT GDDESPRG21_NT LEFT OUTER JOIN
                      Descarga.dbo.GDTAREMB24_NT GDTAREMB24_NT LEFT OUTER JOIN
                      Descarga.dbo.GQCONTAR14_NT GQCONTAR14_NT RIGHT OUTER JOIN
                      Descarga.dbo.GDTARSER13_NT GDTARSER13_NT ON GQCONTAR14_NT.sucursal = GDTARSER13_NT.sucursal AND 
                      GQCONTAR14_NT.codcon14 = GDTARSER13_NT.codcon14 ON GDTAREMB24_NT.sucursal = GDTARSER13_NT.sucursal AND 
                      GDTAREMB24_NT.codtar13 = GDTARSER13_NT.codtar13 ON GDDESPRG21_NT.sucursal = GDTAREMB24_NT.sucursal AND 
                      GDDESPRG21_NT.nrosec21 = GDTAREMB24_NT.nrosec21

GO
/****** Object:  View [dbo].[St_V_CI_Expo_Acue_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Expo_Acue_old]
AS
SELECT     GQCONTAR14_NT.codsbd03, GDTARSER13_NT.codtar13, GDTARSER13_NT.codpro27, GDTARSER13_NT.codemb06, GDTARSER13_NT.codbol03, 
                      GDDESPRG21_NT.observ21 AS desimp13, GDTARSER13_NT.valser13 - GDDESPRG21_NT.descto21 AS valser13, GDTARSER13_NT.codcon14, 
                      GDTARSER13_NT.aplica13, GDTARSER13_NT.tipmon13, GDTARSER13_NT.flgref13, GDTARSER13_NT.tipser13, GDTARSER13_NT.tiptar13, 
                      GDTARSER13_NT.flgtra99, GDTARSER13_NT.fectra99, GDTARSER13_NT.tarmin13, GDTARSER13_NT.tarmax13, GDTARSER13_NT.finvig13, 
                      GDTARSER13_NT.inivig13, GDDESPRG21_NT.codusu17, GDDESPRG21_NT.fecusu00, GDTARSER13_NT.estado13, GDTARSER13_NT.sucursal, 
                      GDDESPRG21_NT.nrosec21, GDDESPRG21_NT.tipdsc21
FROM         Descarga.dbo.GDDESPRG21_NT GDDESPRG21_NT LEFT OUTER JOIN
                      Descarga.dbo.GDTAREMB24_NT GDTAREMB24_NT LEFT OUTER JOIN
                      Descarga.dbo.GQCONTAR14_NT GQCONTAR14_NT RIGHT OUTER JOIN
                      Descarga.dbo.GDTARSER13_NT GDTARSER13_NT ON GQCONTAR14_NT.sucursal = GDTARSER13_NT.sucursal AND 
                      GQCONTAR14_NT.codcon14 = GDTARSER13_NT.codcon14 ON GDTAREMB24_NT.sucursal = GDTARSER13_NT.sucursal AND 
                      GDTAREMB24_NT.codtar13 = GDTARSER13_NT.codtar13 ON GDDESPRG21_NT.sucursal = GDTAREMB24_NT.sucursal AND 
                      GDDESPRG21_NT.nrosec21 = GDTAREMB24_NT.nrosec21
WHERE     (GDDESPRG21_NT.tipdsc21 = 'D') and   (GDTARSER13_NT.valser13 = 0)


GO
/****** Object:  View [dbo].[St_V_CI_Expo_det]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_CI_Expo_det]
AS
SELECT     GRCNDRES22_NT.nrosec20, GRCNDRES22_NT.tipent03, GRCNDRES22_NT.codent22, GRCNDRES22_NT.entida22, dbo.OQENTIDA03.Cod_Enti
FROM         Descarga.dbo.GRCNDRES22_NT GRCNDRES22_NT LEFT OUTER JOIN
                      dbo.OQENTIDA03 ON GRCNDRES22_NT.tipent03 = dbo.OQENTIDA03.tipent03  COLLATE SQL_Latin1_General_CP1_CI_AS


GO
/****** Object:  View [dbo].[St_V_CI_Impo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Impo]
AS
SELECT     fdtarser13.codtar13, fdtarser13.codpro27, fdtarser13.codemb06, fqcontar14.codsbd03, fdtarser13.codcon14, fdtarser13.codbol03, fdtarser13.desimp13, 
                      fdtarser13.aplica13, fdtarser13.valser13, fdtarser13.tarmin13, fdtarser13.diaal113, fdtarser13.estado13, fdtarser13.fecusu00, fdtarser13.tarmax13, 
                      fdtarser13.diaal213, fdtarser13.codusu17, fdtarser13.finvig13, fdtarser13.inivig13, fdtarser13.sucursal
FROM         Terminal.dbo.FQCONTAR14 fqcontar14 RIGHT OUTER JOIN
                      Terminal.dbo.FDTARSER13 fdtarser13 ON fqcontar14.sucursal = fdtarser13.sucursal AND fqcontar14.codcon14 = fdtarser13.codcon14

GO
/****** Object:  View [dbo].[St_V_CI_Impo_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Impo_Acue]
AS
SELECT     fdtarser13.codtar13, fdtarser13.codpro27, fdtarser13.codemb06, fqcontar14.codsbd03, fdtarser13.codcon14, fdtarser13.codbol03, 
                      Terminal.dbo.FDDESPRG21.observ21 AS desimp13, fdtarser13.aplica13, fdtarser13.valser13, fdtarser13.tarmin13, fdtarser13.diaal113, 
                      fdtarser13.estado13, Terminal.dbo.FDDESPRG21.fecusu00, fdtarser13.tarmax13, fdtarser13.diaal213, Terminal.dbo.FDDESPRG21.codusu17, 
                      fdtarser13.finvig13, fdtarser13.inivig13, fdtarser13.sucursal, Terminal.dbo.FDDESPRG21.nrosec21, Terminal.dbo.FDDESPRG21.descto21, 
                      Terminal.dbo.FDDESPRG21.tipdsc21, Terminal.dbo.FDDESPRG21.dialib21
FROM         Terminal.dbo.FDDESPRG21 LEFT OUTER JOIN
                      Terminal.dbo.FDTARDES23 LEFT OUTER JOIN
                      Terminal.dbo.FDTARSER13 fdtarser13 ON Terminal.dbo.FDTARDES23.sucursal = fdtarser13.sucursal AND 
                      Terminal.dbo.FDTARDES23.codtar13 = fdtarser13.codtar13 LEFT OUTER JOIN
                      Terminal.dbo.FQCONTAR14 fqcontar14 ON fdtarser13.sucursal = fqcontar14.sucursal AND fdtarser13.codcon14 = fqcontar14.codcon14 ON 
                      Terminal.dbo.FDDESPRG21.sucursal = Terminal.dbo.FDTARDES23.sucursal AND 
                      Terminal.dbo.FDDESPRG21.nrosec21 = Terminal.dbo.FDTARDES23.nrosec21

GO
/****** Object:  View [dbo].[St_V_CI_Impo_Acue_deta]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Impo_Acue_deta]
AS
SELECT     Terminal.dbo.FRCNDRES22.nrosec20, Terminal.dbo.FRCNDRES22.tipent03, Terminal.dbo.FRCNDRES22.codent22, dbo.OQENTIDA03.Cod_Enti, 
                      Terminal.dbo.FRCNDRES22.entida22, Terminal.dbo.FRCNDRES22.cantid22, Terminal.dbo.FRCNDRES22.criter22
FROM         Terminal.dbo.FRCNDRES22 LEFT OUTER JOIN
                      dbo.OQENTIDA03 ON Terminal.dbo.FRCNDRES22.tipent03 = dbo.OQENTIDA03.tipent03 COLLATE SQL_Latin1_General_CP1_CI_AS

GO
/****** Object:  View [dbo].[St_V_CI_Impo_acue_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CI_Impo_acue_old]
AS
SELECT     fdtarser13.codtar13, fdtarser13.codpro27, fdtarser13.codemb06, fqcontar14.codsbd03, fdtarser13.codcon14, fdtarser13.codbol03, 
                      Terminal.dbo.FDDESPRG21.observ21 AS desimp13, fdtarser13.aplica13, fdtarser13.valser13 - Terminal.dbo.FDDESPRG21.descto21 AS Valser13, 
                      fdtarser13.tarmin13, fdtarser13.diaal113, fdtarser13.estado13, Terminal.dbo.FDDESPRG21.fecusu00, fdtarser13.tarmax13, fdtarser13.diaal213, 
                      Terminal.dbo.FDDESPRG21.codusu17, fdtarser13.finvig13, fdtarser13.inivig13, fdtarser13.sucursal, Terminal.dbo.FDDESPRG21.nrosec21, 
                      Terminal.dbo.FDDESPRG21.descto21, Terminal.dbo.FDDESPRG21.tipdsc21, fdtarser13.valser13 AS Expr1
FROM         Terminal.dbo.FDDESPRG21 LEFT OUTER JOIN
                      Terminal.dbo.FDTARDES23 LEFT OUTER JOIN
                      Terminal.dbo.FDTARSER13 fdtarser13 ON Terminal.dbo.FDTARDES23.sucursal = fdtarser13.sucursal AND 
                      Terminal.dbo.FDTARDES23.codtar13 = fdtarser13.codtar13 LEFT OUTER JOIN
                      Terminal.dbo.FQCONTAR14 fqcontar14 ON fdtarser13.sucursal = fqcontar14.sucursal AND fdtarser13.codcon14 = fqcontar14.codcon14 ON 
                      Terminal.dbo.FDDESPRG21.sucursal = Terminal.dbo.FDTARDES23.sucursal AND 
                      Terminal.dbo.FDDESPRG21.nrosec21 = Terminal.dbo.FDTARDES23.nrosec21
WHERE     (fdtarser13.valser13 = 0) AND (Terminal.dbo.FDDESPRG21.tipdsc21 = 'D')

GO
/****** Object:  View [dbo].[St_V_CI_Linea_expo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_CI_Linea_expo]
AS
SELECT     GRCNDRES22_NT.nrosec20, DQARMADO10_1.flgfac10
FROM         Descarga.dbo.GRCNDRES22_NT GRCNDRES22_NT LEFT OUTER JOIN
                      Descarga.dbo.DQARMADO10 DQARMADO10_1 ON GRCNDRES22_NT.codent22 = DQARMADO10_1.codarm10
WHERE     (GRCNDRES22_NT.tipent03 = 06)


GO
/****** Object:  View [dbo].[St_V_CI_Vacios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[St_V_CI_Vacios]
--AS
--SELECT     ADTARSER41_1.codser41, ADTARSER41_1.codcon14, ADTARSER41_1.desimp41, ADTARSER41_1.codtam09, ADTARSER41_1.codtip05, 
--                      ADTARSER41_1.import41, ADTARSER41_1.codarm10, ADTARSER41_1.coddep04, ADTARSER41_1.codusu17, ADTARSER41_1.fecusu00, 
--                      ADTARSER41_1.usuupd17, ADTARSER41_1.fecupd00, ADTARSER41_1.codage19, ADTARSER41_1.status41, ADTARSER41_1.tiptar41, 
--                      ADTARSER41_1.codest01, ADTARSER41_1.desing41, ADTARSER41_1.tipmov41, AQCONTAR14_1.codsbd03
--FROM         OCEANICA1.descarga.dbo.ADTARSER41 ADTARSER41_1 LEFT OUTER JOIN
--                      OCEANICA1.descarga.dbo.AQCONTAR14 AQCONTAR14_1 ON ADTARSER41_1.codcon14 = AQCONTAR14_1.codcon14
--WHERE     (ADTARSER41_1.codtip05 = '*') AND (ADTARSER41_1.codarm10 = '*') AND (ADTARSER41_1.codage19 = '*')
--GO
/****** Object:  View [dbo].[St_V_CI_Vacios_acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[St_V_CI_Vacios_acue]
--AS
--SELECT     ADTARSER41_1.codser41, ADTARSER41_1.codcon14, ADTARSER41_1.desimp41, ADTARSER41_1.codtam09, ADTARSER41_1.import41, 
--                      ADTARSER41_1.coddep04, ADTARSER41_1.codusu17, ADTARSER41_1.fecusu00, ADTARSER41_1.usuupd17, ADTARSER41_1.fecupd00, 
--                      ADTARSER41_1.status41, ADTARSER41_1.tiptar41, ADTARSER41_1.codest01, ADTARSER41_1.desing41, ADTARSER41_1.tipmov41, 
--                      AQCONTAR14_1.codsbd03, ADTARSER41_1.codarm10, ADTARSER41_1.codage19, ADTARSER41_1.codtip05
--FROM         OCEANICA1.descarga.dbo.ADTARSER41 ADTARSER41_1 LEFT OUTER JOIN
--                      OCEANICA1.descarga.dbo.AQCONTAR14 AQCONTAR14_1 ON ADTARSER41_1.codcon14 = AQCONTAR14_1.codcon14
--WHERE     (ADTARSER41_1.codarm10 <> '*') OR
--                      (ADTARSER41_1.codage19 <> '*') OR
--                      (ADTARSER41_1.codtip05 <> '*')
--GO
/****** Object:  View [dbo].[St_v_Clientes]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_v_Clientes]
AS
SELECT     dbo.St_T_Clientes_Moneda.Contribuy, dbo.St_T_Clientes_Moneda.Tip_mone, TERMINAL.dbo.AACLIENTESAA.NOMBRE
FROM         TERMINAL.dbo.AACLIENTESAA RIGHT OUTER JOIN
                      dbo.St_T_Clientes_Moneda ON 
                      TERMINAL.dbo.AACLIENTESAA.CONTRIBUY = dbo.St_T_Clientes_Moneda.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS




GO
/****** Object:  View [dbo].[St_V_Combos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Combos]
AS
SELECT     dbo.St_T_Combos.Cod_Comb, dbo.St_T_Combos.Tip_Comb, dbo.St_T_Combos.Mon_Comb, dbo.St_T_Combos.Nom_Comb, 
                      dbo.St_T_Combos.Contribuy, Terminal.dbo.AACLIENTESAA.NOMBRE
FROM         dbo.St_T_Combos LEFT OUTER JOIN
                      Terminal.dbo.AACLIENTESAA ON dbo.St_T_Combos.Contribuy COLLATE SQL_Latin1_General_CP1_CI_AS = Terminal.dbo.AACLIENTESAA.CONTRIBUY

GO
/****** Object:  View [dbo].[St_V_CU_Caracteristicas_acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CU_Caracteristicas_acuerdos]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue, dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Dc_Servicio, 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, 
                      dbo.St_T_Caracteristicas_Acuerdo.Cod_Meac, dbo.St_T_Caracteristicas_Acuerdo.Des_Meac, dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc, 
                      dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Flg_Tari
FROM         dbo.St_T_Caracteristicas_Acuerdo LEFT OUTER JOIN
                      dbo.St_T_Acuerdos ON dbo.St_T_Caracteristicas_Acuerdo.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc



GO
/****** Object:  View [dbo].[St_V_CU_Entidades_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_CU_Entidades_Acuerdos]
as
SELECT     dbo.St_T_Entidades_Acuerdos.Cod_Acue, dbo.St_T_Entidades_Acuerdos.Cod_Enti, dbo.St_T_Entidades.Des_Enti, dbo.St_T_Acuerdos.CONTRIBUY, 
           dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Dc_Servicio, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
           dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Flg_Tari

FROM      dbo.St_T_Entidades RIGHT OUTER JOIN
          dbo.St_T_Entidades_Acuerdos ON dbo.St_T_Entidades.Cod_Enti = dbo.St_T_Entidades_Acuerdos.Cod_Enti
          LEFT OUTER JOIN dbo.St_T_Acuerdos ON dbo.St_T_Entidades_Acuerdos.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue


GO
/****** Object:  View [dbo].[St_V_E_Agencias]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 23/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Agencias]
AS
SELECT     CONTRIBUY AS CODIGO, NOMBRE AS DESCRIPCION
FROM         Terminal.dbo.AACLIENTESAA


GO
/****** Object:  View [dbo].[St_V_E_Agencias_Aduanas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Agencias_Aduanas]
AS
SELECT     CONTRIBUY AS CODIGO, NOMBRE AS DESCRIPCION
FROM         Terminal.dbo.AAAGENTE01


GO
/****** Object:  View [dbo].[St_V_E_Agencias_Maritimas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/

ALTER VIEW  [dbo].[St_V_E_Agencias_Maritimas]
as

SELECT     CONTRIBUY AS CODIGO, NOMBRE AS DESCRIPCION
FROM         Terminal.dbo.AAAGEMAR08



GO
/****** Object:  View [dbo].[St_V_E_Condicion_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Condicion_CTR]
AS
SELECT     codbol03 AS Codigo, desbol03 AS Descripcion
FROM         Terminal.dbo.DQCONDCN03


GO
/****** Object:  View [dbo].[St_V_E_Consignatarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Consignatarios]
AS
SELECT     CONTRIBUY AS CODIGO, NOMBRE AS DESCRIPCION
FROM         Terminal.dbo.AACLIENTESAA


GO
/****** Object:  View [dbo].[St_V_E_Consolidadoras]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Consolidadoras]
AS
SELECT     CONTRIBUY AS Codigo, NOMBRE AS Descripcion
FROM         Terminal.dbo.AACONSOL02


GO
/****** Object:  View [dbo].[St_V_E_Embalajes]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :01/Dic/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Embalajes]
AS
SELECT     codemb06 AS Codigo, desemb06 AS Descripcion
FROM         Terminal.dbo.DQEMBALA06


GO
/****** Object:  View [dbo].[St_V_E_Embarcadores]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_E_Embarcadores]
AS  
SELECT     CONTRIBUY AS CODIGO, NOMBRE AS DESCRIPCION  
FROM         Terminal.dbo.AACLIENTESAA  

GO
/****** Object:  View [dbo].[St_V_E_Lineas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Lineas]
AS
SELECT     codarm10 AS codigo, desarm10 AS Descripcion
FROM         Terminal.dbo.DQARMADO10


GO
/****** Object:  View [dbo].[St_V_E_Naves]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Naves]
AS
SELECT     codnav08 AS Codigo, desnav08 AS Descripcion
FROM         Terminal.dbo.DQNAVIER08


GO
/****** Object:  View [dbo].[ST_V_E_Productos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[ST_V_E_Productos]
AS
select Cod_Subproducto as CODIGO,Des_Subproducto DESCRIPCION from Terminal.dbo.subproducto



GO
/****** Object:  View [dbo].[St_V_E_Puertos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Puertos]
AS
SELECT     codpue02 AS Codigo, despue02 AS Descripcion
FROM         Terminal.dbo.DQPUERTO02


GO
/****** Object:  View [dbo].[St_V_E_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Servicio]
AS
SELECT     codser30 AS Codigo, desser30 AS Descripcion
FROM         Terminal.dbo.DQSERVIC30


GO
/****** Object:  View [dbo].[St_V_E_Tamaño_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Tamaño_CTR]
AS
SELECT     codtam09 AS Codigo, destam09 AS Descripcion
FROM         Terminal.dbo.DQTAMCON09


GO
/****** Object:  View [dbo].[St_V_E_Tipo_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades (codigo, nombre)
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_E_Tipo_CTR]
AS
SELECT     codtip05 AS Codigo, destip05 AS Descripcion
FROM         Terminal.dbo.DQTIPCON05


GO
/****** Object:  View [dbo].[ST_V_Entidades]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Entidades
    Fecha       : 22/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[ST_V_Entidades]
AS
SELECT     dbo.St_T_Entidades.Des_Enti, dbo.St_T_Entidades.Cod_Enti, dbo.St_T_Entidades.Val_Enti, dbo.St_T_Entidades.Tip_Enti, 
                      dbo.St_T_Tipo_Entidad.Des_Tien
FROM         dbo.St_T_Entidades LEFT OUTER JOIN
                      dbo.St_T_Tipo_Entidad ON dbo.St_T_Entidades.Tip_Enti = dbo.St_T_Tipo_Entidad.Cod_Tien


GO
/****** Object:  View [dbo].[St_V_Entidades_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar entidades por acuerdo
    Fecha       : 25/Nov/2005
   CA.
*/
ALTER VIEW [dbo].[St_V_Entidades_Acuerdos]
AS
SELECT     dbo.St_T_Entidades_Acuerdos.Cod_Acue, dbo.St_T_Entidades_Acuerdos.Cod_Enti, dbo.St_T_Entidades.Des_Enti, 
                      dbo.St_T_Entidades_Acuerdos.Val_Enac, dbo.St_T_Entidades.Tip_Enti, dbo.St_T_Entidades_Acuerdos.Cod_Enac, 
                      dbo.St_T_Entidades_Acuerdos.Des_Enac, dbo.St_T_Entidades.Val_Enti, dbo.St_T_Entidades.Tam_enti, dbo.St_T_Entidades_Acuerdos.Flg_Proc
FROM         dbo.St_T_Entidades RIGHT OUTER JOIN
                      dbo.St_T_Entidades_Acuerdos ON dbo.St_T_Entidades.Cod_Enti = dbo.St_T_Entidades_Acuerdos.Cod_Enti

GO
/****** Object:  View [dbo].[St_V_Entidades_Acuerdos_Combos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Entidades_Acuerdos_Combos]
AS
SELECT     dbo.St_T_Entidades_Acuerdos.Cod_Acue, dbo.St_T_Entidades_Combo.Cod_Comb, dbo.St_T_Entidades_Acuerdos.Cod_Enti, 
                      dbo.St_T_Entidades_Acuerdos.Val_Enac, dbo.St_T_Entidades_Combo.Val_Enco, dbo.St_T_Entidades_Acuerdos.Des_Enac
FROM         dbo.St_T_Entidades_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Entidades_Combo ON dbo.St_T_Entidades_Acuerdos.Cod_Enti = dbo.St_T_Entidades_Combo.Cod_Enti


GO
/****** Object:  View [dbo].[St_V_Entidades_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Entidades_Combo]
AS
SELECT     dbo.St_T_Entidades_Combo.Cod_Enco, dbo.St_T_Entidades_Combo.Cod_Enti, dbo.St_T_Entidades_Combo.Cod_Comb, 
                      dbo.St_T_Entidades_Combo.Val_Enco, dbo.St_T_Entidades_Combo.Des_Enco, dbo.St_T_Entidades.Des_Enti, dbo.St_T_Entidades.Tip_Enti, 
                      dbo.St_T_Entidades.Val_Enti, dbo.St_T_Entidades.Tam_enti, dbo.St_T_Entidades.flg_apli
FROM         dbo.St_T_Entidades_Combo LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Entidades_Combo.Cod_Enti = dbo.St_T_Entidades.Cod_Enti

GO
/****** Object:  View [dbo].[St_V_Entidades_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar entidades por tarifa
    Fecha       : 28/Nov/2005
   CA.
*/
ALTER VIEW [dbo].[St_V_Entidades_Tarifas]
AS
SELECT     dbo.St_T_Entidades_Acuerdos.Cod_Acue, dbo.St_T_Entidades_Acuerdos.Cod_Enti, dbo.St_T_Entidades.Des_Enti, 
                      dbo.St_T_Entidades_Acuerdos.Val_Enac, dbo.St_T_Entidades.Tip_Enti, dbo.St_T_Entidades_Acuerdos.Cod_Enac, 
                      dbo.St_T_Entidades_Acuerdos.Des_Enac, dbo.St_T_Entidades.Val_Enti, dbo.St_T_Entidades.Tam_enti, dbo.St_T_Entidades_Acuerdos.Flg_Proc
FROM         dbo.St_T_Entidades RIGHT OUTER JOIN
                      dbo.St_T_Entidades_Acuerdos ON dbo.St_T_Entidades.Cod_Enti = dbo.St_T_Entidades_Acuerdos.Cod_Enti

GO
/****** Object:  View [dbo].[St_V_Estados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar los Estados
    Fecha       : 22/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_Estados]
AS
SELECT     Cod_Esta, Des_Esta
FROM         dbo.St_T_Estados


GO
/****** Object:  View [dbo].[St_V_Mercaderias]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Mercaderias
    Fecha       : 22/Nov/2005
   JF.
*/
ALTER VIEW [dbo].[St_V_Mercaderias]
AS
SELECT     dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc, dbo.St_T_Caracteristicas_Mercaderia.Des_Merc, dbo.St_T_Caracteristicas_Mercaderia.Val_Merc, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, dbo.St_T_Tipo_Entidad.Des_Tien, dbo.St_T_Tipo_Entidad.Cod_Tien
FROM         dbo.St_T_Caracteristicas_Mercaderia LEFT OUTER JOIN
                      dbo.St_T_Tipo_Entidad ON dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara = dbo.St_T_Tipo_Entidad.Cod_Tien

GO
/****** Object:  View [dbo].[St_V_Perfiles]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Perfiles]
AS
SELECT     Des_Porc, Des_Perf, Cod_Perf
FROM         dbo.St_T_Perfil_Usuario

GO
/****** Object:  View [dbo].[St_V_Servicios_Combo_Tipo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Servicios_Combo_Tipo]
AS
SELECT     dbo.St_T_Servicios_Combo.Cod_Comb, dbo.St_T_Servicios_Combo.Cod_Seco, dbo.St_T_Servicios_Combo.Dc_Servicio, 
                      dbo.St_T_Servicios_Combo.Cod_Acue, dbo.St_T_Servicios_Combo.Val_Seco, dbo.St_T_Combos.Tip_Comb
FROM         dbo.St_T_Servicios_Combo LEFT OUTER JOIN
                      dbo.St_T_Combos ON dbo.St_T_Servicios_Combo.Cod_Comb = dbo.St_T_Combos.Cod_Comb

GO
/****** Object:  View [dbo].[St_V_Tarifario_Cubo_Act]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tarifario_Cubo_Act]
AS
SELECT     dbo.ST_T_TARIFARIO_CUBO.Cod_Acue, dbo.ST_T_TARIFARIO_CUBO.Contribuy, dbo.ST_T_TARIFARIO_CUBO.Val_acue, 
                      dbo.St_T_Acuerdos.Cod_Tari
FROM         dbo.ST_T_TARIFARIO_CUBO LEFT OUTER JOIN
                      dbo.St_T_Acuerdos ON dbo.ST_T_TARIFARIO_CUBO.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue


GO
/****** Object:  View [dbo].[ST_V_Tarifas_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ST_V_Tarifas_Servicios]
AS
SELECT     dbo.St_T_Tarifas_Servicios.Db_Servicio, dbo.St_T_Tarifas_Servicios.Dc_Centro_Costo, dbo.St_T_Tarifas_Servicios.dc_sucursal, 
                      dbo.St_T_Tarifas_Servicios.Cod_Tari, dbo.St_T_Tarifas_Servicios.Codpro27, dbo.St_T_Tarifas_Servicios.Codemb06, 
                      dbo.St_T_Tarifas_Servicios.Codbol03, dbo.St_T_Tarifas_Servicios.Des_Serv, dbo.St_T_Tarifas_Servicios.Val_Serv, 
                      dbo.St_T_Tarifas_Servicios.Cod_Apli, dbo.St_T_Tarifas_Servicios.Tar_Mini, dbo.St_T_Tarifas_Servicios.Dia_Inic, dbo.St_T_Tarifas_Servicios.Est_Tari,
                       dbo.St_T_Estados.Des_Esta, dbo.St_T_Tarifas_Servicios.Cod_Usua, dbo.St_T_Tarifas_Servicios.Fec_Crea, dbo.St_T_Tarifas_Servicios.Dia_Fina, 
                      dbo.St_T_Tarifas_Servicios.Tar_Maxi
FROM         dbo.St_T_Tarifas_Servicios LEFT OUTER JOIN
                      dbo.St_T_Estados ON dbo.St_T_Tarifas_Servicios.Est_Tari = dbo.St_T_Estados.Cod_Esta

GO
/****** Object:  View [dbo].[St_V_Tmp_Facturas_2006_impo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tmp_Facturas_2006_impo]
AS
SELECT     ruccli12
FROM         Terminal.dbo.DDFACTUR37
WHERE     (YEAR(fecemi37) = 2006)
GROUP BY ruccli12

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Aut]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Aut]
AS
SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Dc_Servicio, 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Cod_Aplc, dbo.St_T_Acuerdos.Tip_Aplc, 
                      dbo.St_T_Entidades.Tip_Enti AS Tip_Enti_E, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Cod_aplp, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara AS Tip_Enti_C, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Tar_Mini, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Tar_Maxi, 
                      dbo.St_T_Acuerdos.Val_Acus, dbo.St_T_Acuerdos.Tar_Mins, dbo.St_T_Acuerdos.Tar_Maxs
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc LEFT OUTER JOIN
                      dbo.St_T_Tipo_Servicio ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.St_T_Tipo_Servicio.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = dbo.St_T_Tipo_Servicio.Dc_Sucursal AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.St_T_Tipo_Servicio.Dc_Centro_Costo LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Entidades.Cod_Enti
WHERE     (dbo.St_T_Tipo_Servicio.Flg_Serv = 1) AND (dbo.St_T_Acuerdos.Cod_Esta <> 'I') OR
                      (dbo.St_T_Acuerdos.Cod_Esta <> 'I') AND (dbo.St_T_Tipo_Servicio.Flg_SerT = 1) AND (dbo.St_T_Acuerdos.Flg_Tari = 1) OR
                      (dbo.St_T_Acuerdos.Cod_Esta <> 'I') AND (dbo.St_T_Acuerdos.Flg_Tari = 0) AND (dbo.St_T_Tipo_Servicio.Flg_SerA = 1)

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Aut_Sin_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Aut_Sin_Sucursal]
AS
SELECT DISTINCT 
                      dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Dc_Servicio, 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo, dbo.St_T_Acuerdos.Dc_Sucursal, dbo.St_T_Acuerdos.Cod_Aplc, dbo.St_T_Acuerdos.Tip_Aplc, 
                      dbo.St_T_Entidades.Tip_Enti AS Tip_Enti_E, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Cod_aplp, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara AS Tip_Enti_C, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Tar_Mini, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Tar_Maxi, 
                      dbo.St_T_Acuerdos.Val_Acus, dbo.St_T_Acuerdos.Tar_Mins, dbo.St_T_Acuerdos.Tar_Maxs
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc LEFT OUTER JOIN
                      dbo.St_T_Tipo_Servicio ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.St_T_Tipo_Servicio.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.St_T_Tipo_Servicio.Dc_Centro_Costo LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Entidades.Cod_Enti
WHERE     (dbo.St_T_Tipo_Servicio.Flg_Serv = 1) AND (dbo.St_T_Acuerdos.Dc_Sucursal IS NULL) AND (dbo.St_T_Acuerdos.Cod_Esta <> 'I') OR
                      (dbo.St_T_Acuerdos.Dc_Sucursal IS NULL) AND (dbo.St_T_Acuerdos.Cod_Esta <> 'I') AND (dbo.St_T_Tipo_Servicio.Flg_SerT = 1) AND 
                      (dbo.St_T_Acuerdos.Flg_Tari = 1) OR
                      (dbo.St_T_Acuerdos.Dc_Sucursal IS NULL) AND (dbo.St_T_Acuerdos.Cod_Esta <> 'I') AND (dbo.St_T_Acuerdos.Flg_Tari = 0) AND 
                      (dbo.St_T_Tipo_Servicio.Flg_SerA = 1)

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Esp 03-07]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Esp 03-07]
AS
SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Cod_Aplc, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_T_Acuerdos.Flg_Tari, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal, dbo.ST_TR_Servicios_Manuales_Especiales.ID, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.ID_Item, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv, dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv, 0 AS Apl_Igv, 0 AS Apl_Detr, 
                      dbo.St_T_Acuerdos.Des_Acue, dbo.St_T_Acuerdos.Cod_aplp, dbo.St_T_Acuerdos.Flg_Inte
FROM         dbo.St_T_Acuerdos RIGHT OUTER JOIN
                      dbo.ST_TR_Servicios_Manuales_Especiales ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo
WHERE     (dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv <> 0)

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Esp_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Esp_old]
AS
SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Cod_Aplc, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_T_Acuerdos.Flg_Tari, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal, dbo.ST_TR_Servicios_Manuales_Especiales.ID, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.ID_Item, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv, dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv, 0 AS Apl_Igv, 0 AS Apl_Detr, 
                      dbo.St_T_Acuerdos.Des_Acue
FROM         dbo.St_T_Acuerdos RIGHT OUTER JOIN
                      dbo.ST_TR_Servicios_Manuales_Especiales ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo
WHERE     (dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv = 'E')

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Man]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Man]
AS
SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal, dbo.St_T_Acuerdos.Cod_Aplc, dbo.St_T_Acuerdos.Tip_Aplc, 
                      dbo.St_T_Entidades.Tip_Enti AS Tip_Enti_E, dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.Cod_aplp, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.ID, dbo.ST_TR_Servicios_Manuales_Especiales.ID_Item, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv, dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv, 
                      dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara AS Tip_enti_C, dbo.St_T_Acuerdos.Flg_Inte, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Tar_Mini, dbo.St_T_Acuerdos.Cod_Esta, dbo.St_T_Acuerdos.Tar_Maxi, 
                      dbo.St_T_Acuerdos.Val_Acus, dbo.St_T_Acuerdos.Tar_Mins, dbo.St_T_Acuerdos.Tar_Maxs
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc RIGHT OUTER JOIN
                      dbo.ST_TR_Servicios_Manuales_Especiales ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Entidades.Cod_Enti
WHERE     (dbo.ST_TR_Servicios_Manuales_Especiales.Val_Serv = 0) AND (dbo.St_T_Acuerdos.Cod_Esta <> 'I')

GO
/****** Object:  View [dbo].[St_V_Tr_Acuerdos_Man_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Acuerdos_Man_old]
AS
SELECT     dbo.St_T_Acuerdos.Cod_Acue, dbo.St_T_Acuerdos.Val_Acue, dbo.St_T_Acuerdos.CONTRIBUY, dbo.St_T_Acuerdos.Cod_Aplc, 
                      dbo.St_T_Acuerdos.Tip_Aplc, dbo.St_T_Entidades.Tip_Enti, dbo.St_T_Acuerdos.Flg_Tari, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal, dbo.ST_TR_Servicios_Manuales_Especiales.ID, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.ID_Item, dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo, 
                      dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv
FROM         dbo.St_T_Acuerdos RIGHT OUTER JOIN
                      dbo.ST_TR_Servicios_Manuales_Especiales ON dbo.St_T_Acuerdos.Dc_Servicio = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Servicio AND 
                      dbo.St_T_Acuerdos.Dc_Sucursal = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Sucursal AND 
                      dbo.St_T_Acuerdos.Dc_Centro_Costo = dbo.ST_TR_Servicios_Manuales_Especiales.Dc_Centro_Costo LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Acuerdos.Cod_Aplc = dbo.St_T_Entidades.Cod_Enti
WHERE     (dbo.ST_TR_Servicios_Manuales_Especiales.Tip_Serv = 'M')

GO
/****** Object:  View [dbo].[St_V_Tr_Caracteristicas_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tr_Caracteristicas_Activas]
AS
SELECT     dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara
FROM         dbo.St_T_Caracteristicas_Acuerdo LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc
GROUP BY dbo.St_T_Caracteristicas_Acuerdo.Cod_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara


GO
/****** Object:  View [dbo].[St_V_Tr_Detalle]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tr_Detalle]
AS
SELECT     dbo.ST_TR_Detalle.ID, dbo.ST_TR_Detalle.ID_Item, dbo.ST_TR_Documento.Cod_Clie, dbo.ST_TR_Documento.Dc_Centro_Costo, 
                      dbo.ST_TR_Documento.Dc_Sucursal
FROM         dbo.ST_TR_Detalle LEFT OUTER JOIN
                      dbo.ST_TR_Documento ON dbo.ST_TR_Detalle.ID = dbo.ST_TR_Documento.ID


GO
/****** Object:  View [dbo].[St_V_Tr_Detalle_Caracteristicas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Detalle_Caracteristicas]
AS
SELECT     dbo.ST_TR_Detalle.ID, dbo.ST_TR_Detalle.ID_Item, dbo.ST_TR_Caracteristicas_Mercaderia.Cod_Merc, 
                      dbo.ST_TR_Caracteristicas_Mercaderia.Val_Merc, dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara
FROM         dbo.ST_TR_Caracteristicas_Mercaderia LEFT OUTER JOIN
                      dbo.St_T_Caracteristicas_Mercaderia ON 
                      dbo.ST_TR_Caracteristicas_Mercaderia.Cod_Merc = dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc RIGHT OUTER JOIN
                      dbo.ST_TR_Detalle ON dbo.ST_TR_Caracteristicas_Mercaderia.ID = dbo.ST_TR_Detalle.ID AND 
                      dbo.ST_TR_Caracteristicas_Mercaderia.ID_Item = dbo.ST_TR_Detalle.ID_Item

GO
/****** Object:  View [dbo].[St_V_Tr_Detalle_Caracteristicas_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tr_Detalle_Caracteristicas_Activas]
AS
SELECT      dbo.St_TR_Caracteristicas_Mercaderia.ID,  dbo.St_TR_Caracteristicas_Mercaderia.Cod_Merc, 
                       dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara
FROM          dbo.St_TR_Caracteristicas_Mercaderia LEFT OUTER JOIN
                       dbo.St_T_Caracteristicas_Mercaderia ON 
                       dbo.St_TR_Caracteristicas_Mercaderia.Cod_Merc =  dbo.St_T_Caracteristicas_Mercaderia.Cod_Merc
GROUP BY  dbo.St_TR_Caracteristicas_Mercaderia.ID,  dbo.St_T_Caracteristicas_Mercaderia.Tip_Cara, 
                       dbo.St_TR_Caracteristicas_Mercaderia.Cod_Merc



GO
/****** Object:  View [dbo].[St_V_Tr_Detalle_Entidades]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Tr_Detalle_Entidades]
AS
SELECT     dbo.ST_TR_Detalle.ID, dbo.ST_TR_Detalle.ID_Item, dbo.ST_TR_Entidades.Cod_Enti, dbo.ST_TR_Entidades.Val_enti, 
                      dbo.St_T_Entidades.Tip_Enti
FROM         dbo.ST_TR_Entidades LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.ST_TR_Entidades.Cod_Enti = dbo.St_T_Entidades.Cod_Enti RIGHT OUTER JOIN
                      dbo.ST_TR_Detalle ON dbo.ST_TR_Entidades.ID = dbo.ST_TR_Detalle.ID

GO
/****** Object:  View [dbo].[St_V_Tr_Detalle_Entidades_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tr_Detalle_Entidades_Activas]
AS
SELECT      dbo.St_TR_Entidades.ID,  dbo.St_TR_Entidades.Cod_Enti,  dbo.St_T_Entidades.Tip_Enti
FROM          dbo.St_TR_Entidades LEFT OUTER JOIN
                       dbo.St_T_Entidades ON  dbo.St_TR_Entidades.Cod_Enti =  dbo.St_T_Entidades.Cod_Enti
GROUP BY  dbo.St_TR_Entidades.ID,  dbo.St_TR_Entidades.Cod_Enti,  dbo.St_T_Entidades.Tip_Enti



GO
/****** Object:  View [dbo].[St_V_Tr_Entidades_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[St_V_Tr_Entidades_Activas]
AS
SELECT     dbo.St_T_Entidades_Acuerdos.Cod_Enti, 
dbo.St_T_Entidades.Tip_Enti
FROM         dbo.St_T_Entidades_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Entidades ON 
dbo.St_T_Entidades_Acuerdos.Cod_Enti = dbo.St_T_Entidades.Cod_Enti
GROUP BY dbo.St_T_Entidades_Acuerdos.Cod_Enti, 
dbo.St_T_Entidades.Tip_Enti

       


GO
/****** Object:  View [dbo].[St_V_Usuarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Usuarios]
AS
SELECT     Cod_Usua, Nom_Usua, Pas_Usua, Cod_Perf
FROM         dbo.St_T_Usuarios

GO
/****** Object:  View [dbo].[St_V_Usuarios_perfiles]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[St_V_Usuarios_perfiles]
AS
SELECT     dbo.St_T_Perfil_Usuario.Des_Perf, dbo.St_T_Usuarios.Cod_Perf, dbo.St_T_Usuarios.Pas_Usua, dbo.St_T_Usuarios.Nom_Usua, 
                      dbo.St_T_Usuarios.Cod_Usua, dbo.St_T_Perfil_Usuario.Des_Porc
FROM         dbo.St_T_Usuarios LEFT OUTER JOIN
                      dbo.St_T_Perfil_Usuario ON dbo.St_T_Usuarios.Cod_Perf = dbo.St_T_Perfil_Usuario.Cod_Perf

GO
/****** Object:  View [dbo].[syncobj_0x4136454239443633]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[syncobj_0x4136454239443633]as select  [Cod_Acue],[CONTRIBUY],[Dc_Centro_Costo],[Dc_Sucursal],[Dc_Servicio],[Des_Acue],[Fec_Acti],[Usu_Acue],[Val_Acue],[Fec_Crea],[Cod_Esta],[Fec_Apro],[Tar_Mini],[Tar_Maxi],[Flg_Tari],[Flg_Inte],[Flg_Apli],[Val_Proc],[Flg_Proc],[Cod_Ante],[Fec_Term],[Cod_Aplc],[Tip_Aplc],[Cod_Tar13],[Cod_Tari],[Cod_aplp],[Nro_Sec21],[msrepl_tran_version],[Dc_Centro_Costo_A],[Dc_Sucursal_A],[id]  from  [userta].[St_T_Acuerdos_old]  where permissions(1252199511) & 1 = 1  
--GO
--/****** Object:  View [dbo].[syncobj_0x4546463937304143]    Script Date: 07/03/2019 04:16:53 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[syncobj_0x4546463937304143]as select  [Cod_Acue],[CONTRIBUY],[Dc_Centro_Costo],[Dc_Sucursal],[Dc_Servicio],[Des_Acue],[Fec_Acti],[Usu_Acue],[Val_Acue],[Fec_Crea],[Cod_Esta],[Fec_Apro],[Tar_Mini],[Tar_Maxi],[Flg_Tari],[Flg_Inte],[Flg_Apli],[Val_Proc],[Flg_Proc],[Cod_Ante],[Fec_Term],[Cod_Aplc],[Tip_Aplc],[Cod_Tar13],[Cod_Tari],[Cod_aplp],[Nro_Sec21],[msrepl_tran_version],[Dc_Centro_Costo_A],[Dc_Sucursal_A],[id]  from  [userta].[St_T_Acuerdos_old]  where permissions(1252199511) & 1 = 1  
--GO
/****** Object:  View [dbo].[TMUNID_RECA]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TMUNID_RECA] As    
Select [CO_UNID], [CO_EMPR], [DE_UNID], [TI_AUXI_EMPR], [CO_AUXI_EMPR],    
       [SUCCON01], [CODSED01], [FLGACT01],    
       [CO_USUA_CREA], [FE_USUA_CREA], [CO_USUA_MODI], [FE_USUA_MODI]    
From   [SP3TDA-DBSQL02].[OFIRECA].[dbo].[TMUNID_RECA]    
WHERE  [CO_EMPR] = '01'
  


GO
/****** Object:  View [dbo].[V_Carga_Tari]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER VIEW [dbo].[V_Carga_Tari]
--AS
--SELECT     dbo.St_T_Acuerdos.Cod_Acue, userta.St_T_Acuerdos_old.id AS Cod_Tari
--FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
--                      userta.St_T_Acuerdos_old ON dbo.St_T_Acuerdos.Cod_Tari = userta.St_T_Acuerdos_old.Cod_Acue
--GO
/****** Object:  View [dbo].[V_Tempo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[V_Tempo]
AS
SELECT     TOP 100 PERCENT dg_centro_costo_apl AS Operacion, dg_sucursal_apl AS Lugar_de_Cobro, Contribuy AS RUC, Cliente AS Cliente, 
                      Cod_Acue AS Codigo_Acuerdo, combo  AS Servicio_Integral, Dc_Centro_Costo_a AS Centro_de_Costo, Dc_Sucursal_a AS Sucursal, 
                      Dc_Servicio AS Cod_Servicio, dg_Servicio AS Servicio, Val_acue AS Valor_Acuerdo_Dol, importe_S AS Valor_Acuerdo_Sol, Tar_mini AS Tarifa_Min, Tar_maxi AS Tarifa_Max, 
                      E_AG__ADUANA, E_AG__MARITIMO, E_AG__GENERAL, E_EMBARCADOR, E_SERVICIO, E_LINEA, E_NAVE, E_BOOKING, E_PRODUCTO, 
                      E_PUERTO_DESTINO, E_CONSIGNATARIO, E_CONSOLIDADORA, E_TIPO_FLETE, E_PUERTO_EMBARQUE, E_VEHICULO, E_CARGA_SUELTA, 
                      E_EMBARCADOR_IMPO, E_OTRAS_LINEAS, E_CANTIDAD_CTRS_, E_LINEAS_NEPTUNIA, E_DIAS_LIBRES, E_DIAS_ALMACENADOS, 
                      E_CARACTERISTCA_DE_LA_MECADERIA, E_CONDICION, E_RangoHoras, E_dIAS_aLMACENADOS_11__20, E_DIAS_ALMACENADOS_21_MAS, 
                      E_REGIMEN, E_rangocontenedores, E_Calles, E_RANGODIAS, E_TIENE_FACTURA___VIGENCIA, E_UNIDAD_MERCADERIA, C_Peso_Ctrs, 
                      C_Tipo_de_Ctr, C_Tamaño_del_Ctr, C_Condición_del_Ctr, C_Estado_del_Ctr, C_Mercadería_del_Ctr, C_Consolidado, C_Ligado, C_Forrado, 
                      C_Tipo_de_llenado, C_Planta, C_Prorrateado_al_Consolidador, C_Booking, C_Peso_de_Mercaderia, C_Cantidad_de_Mercaderia, 
                      C_Volumen_de_Mercaderia, C_Tipo_de_Mercaderia, C_Tipo_de_Vehiculo, C_Embalaje, C_Cantidad_de_Vehiculos, C_Volumen_Acumulativo, 
                      C_CONDICION_DE_MERCADERIA, C_HORAS, C_CANTIDAD_ETIQUETAS, C_DIAS, C_REEFER_CONECTADO__IMPO_, C_INSPECCIONADO, 
                      C_REEFER_CONECTADO__EXPO_, C_UNIDAD_MERCADERIA, Vendedor
FROM         web.tempo
ORDER BY dg_centro_costo_apl, Lugar_de_Cobro,Contribuy




GO
/****** Object:  View [dbo].[VIEW1]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[VIEW1]
AS
SELECT     dbo.ST_TR_Servicios_Resp.ID, dbo.St_T_Acuerdos.Fec_Crea
FROM         dbo.ST_TR_Servicios_Resp LEFT OUTER JOIN
                      dbo.St_T_Acuerdos ON dbo.ST_TR_Servicios_Resp.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue
WHERE     (dbo.ST_TR_Servicios_Resp.ID = 6664)

GO
/****** Object:  View [dbo].[xxxxx-Verificar acuerdos que tienen entidades de rangos con un solo valor y que generan errores]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[xxxxx-Verificar acuerdos que tienen entidades de rangos con un solo valor y que generan errores]
AS
SELECT     TOP 100 PERCENT dbo.St_T_Entidades_Acuerdos.Cod_Acue, dbo.St_T_Entidades_Acuerdos.Cod_Enti, dbo.St_T_Entidades_Acuerdos.Val_Enac, 
                      dbo.St_T_Entidades_Acuerdos.Cod_Enac, dbo.St_T_Entidades_Acuerdos.Des_Enac, dbo.St_T_Entidades_Acuerdos.Flg_Proc, 
                      dbo.St_T_Entidades.Tip_Enti, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, dbo.St_T_Acuerdos.Dc_Sucursal_A, dbo.St_T_Acuerdos.Dc_Servicio, 
                      dbo.St_T_Acuerdos.Flg_Tari, dbo.St_T_Acuerdos.CONTRIBUY
FROM         dbo.St_T_Entidades_Acuerdos LEFT OUTER JOIN
                      dbo.St_T_Acuerdos ON dbo.St_T_Entidades_Acuerdos.Cod_Acue = dbo.St_T_Acuerdos.Cod_Acue LEFT OUTER JOIN
                      dbo.St_T_Entidades ON dbo.St_T_Entidades_Acuerdos.Cod_Enti = dbo.St_T_Entidades.Cod_Enti
WHERE     (dbo.St_T_Entidades.Tip_Enti = '3') AND (CHARINDEX(',', dbo.St_T_Entidades_Acuerdos.Val_Enac) = 0) AND 
                      (dbo.St_T_Acuerdos.Dc_Centro_Costo_A = 1) AND (dbo.St_T_Acuerdos.Dc_Sucursal_A = 7) AND (dbo.St_T_Acuerdos.CONTRIBUY IS NULL)
ORDER BY dbo.St_T_Acuerdos.Dc_Servicio

GO
/****** Object:  StoredProcedure [dbo].[Impo_Carga_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Impo_Carga_Combo] AS

insert into aaserint 
select distinct NROCOMBO=a.Cod_Comb, c.CONTRIBUY, SUCURSAL='3',SISTEMA='1', 
CONCEPTO=b.codcon14, GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
FECHA=getdate(),USUARIO='dbo', NULL --OJO FMCR  
from 
tarifario..St_T_Servicios_Combo a, 
terminal..fqcontar14 b, 
tarifario..St_T_Acuerdos c
where 
a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03 and
a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1' and
b.codcon14 not in ('MINR2','MINR4','tarja') 
and c.contribuy COLLATE SQL_Latin1_General_CP1_CI_AS not in 
(select contribuy from aaserint where sucursal='3') 
order by a.Cod_Comb, c.CONTRIBUY
GO
/****** Object:  StoredProcedure [dbo].[Impo_Carga_Combo_Cliente]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Impo_Carga_Combo_Cliente] 
@RUCCLI  Char (11)
AS
BEGIN

delete aaserint where contribuy=@RUCCLI
insert into aaserint 
select distinct NROCOMBO=a.Cod_Comb, c.CONTRIBUY, SUCURSAL='3',SISTEMA='1', 
CONCEPTO=b.codcon14, GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
FECHA=getdate(),USUARIO='dbo', null -- FMCR  
from 
tarifario..St_T_Servicios_Combo a, 
terminal..fqcontar14 b, 
tarifario..St_T_Acuerdos c
where 
a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03 and
a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1' and
b.codcon14 not in ('MINR2','MINR4','tarja') 
and c.contribuy=@RUCCLI
order by a.Cod_Comb, c.CONTRIBUY

insert into aaserint 
select distinct NROCOMBO=a.Cod_Comb, c.CONTRIBUY, SUCURSAL='3',SISTEMA='1', 
CONCEPTO=b.codcon14, GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
FECHA=getdate(),USUARIO='dbo', null --FMCR  
from 
tarifario..St_T_Servicios_Combo a, 
terminal..fqcontar14 b, 
tarifario..St_T_Acuerdos c
where 
a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03_D and
a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1' and
b.codcon14 not in ('MINR2','MINR4','tarja') 
and c.contribuy=@RUCCLI
order by a.Cod_Comb, c.CONTRIBUY

insert into aaserint 
select distinct NROCOMBO=a.Cod_Comb, c.CONTRIBUY, SUCURSAL='2',SISTEMA='1', 
CONCEPTO=b.codcon14, GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
FECHA=getdate(),USUARIO='dbo' , null --FMCR 
from 
tarifario..St_T_Servicios_Combo a, 
terminal..fqcontar14 b, 
tarifario..St_T_Acuerdos c
where 
a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03 and
a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1' and
b.codcon14 not in ('MINR2','MINR4','tarja') 
and c.contribuy=@RUCCLI
order by a.Cod_Comb, c.CONTRIBUY

insert into aaserint 
select distinct NROCOMBO=a.Cod_Comb, c.CONTRIBUY, SUCURSAL='2',SISTEMA='1', 
CONCEPTO=b.codcon14, GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
FECHA=getdate(),USUARIO='dbo', null --FMCR  
from 
tarifario..St_T_Servicios_Combo a, 
terminal..fqcontar14 b, 
tarifario..St_T_Acuerdos c
where 
a.Dc_Servicio COLLATE SQL_Latin1_General_CP1_CI_AS=b.codsbd03_D and
a.Cod_Acue=c.Cod_Acue and Dc_Centro_Costo_A = 1 and b.flgmue14='1' and
b.codcon14 not in ('MINR2','MINR4','tarja') 
and c.contribuy=@RUCCLI
order by a.Cod_Comb, c.CONTRIBUY

--=================================0
-- 15/04/2009 Filtro
--=================================0

DECLARE @Min INT, @Max INT, @RETURN VARCHAR(2000), @AUX VARCHAR(2000), @SUCAUX CHAR(1), @NROCOMBO INT

DECLARE @Temp TABLE
(
	Indice INT IDENTITY(1,1) PRIMARY KEY,
	CONCEPTO VARCHAR(2000),
	SUCURSAL CHAR(1)
)

DECLARE @TempReturn TABLE
(
	NROCOMBO INT,
	CONCEPTO VARCHAR(2000),
	SUCURSAL CHAR(1)
)

INSERT @Temp (CONCEPTO,SUCURSAL)
SELECT DISTINCT
	dbo.fn_integracombo(CONTRIBUY,NROCOMBO,SUCURSAL),SUCURSAL
FROM 
	AASERINT
WHERE 
	CONTRIBUY=@RUCCLI


SET @Max = @@RowCount

SET @Min = 1

WHILE @Min <= @Max
	BEGIN
		SELECT @AUX = CONCEPTO, @SUCAUX = SUCURSAL FROM @Temp WHERE Indice = @Min

		SELECT @NROCOMBO = MAX(NROCOMBO) FROM aaserint

		INSERT @TempReturn
		SELECT @NROCOMBO + @Min, value, @SUCAUX FROM dbo.fn_Split(@AUX,'&') where value <> ''

		SET @Min = @Min + 1
	END

DELETE FROM AASERINT WHERE CONTRIBUY = @RUCCLI

INSERT AASERINT
SELECT
	NROCOMBO,
	@RUCCLI AS CONTRIBUY,
	SUCURSAL,
	SISTEMA='1',
	CONCEPTO,
	GLOSA='SERVICIO LOGISTICO DE IMPORTACION',
	FECHA=getdate(),
	USUARIO='dbo',
	null -- FMCR
FROM
	@TempReturn

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ALERTA_DIFERENCIA_TAMAÑO_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ALERTA_DIFERENCIA_TAMAÑO_CTR]  
AS     
  
DECLARE @ASUNTO varchar(200)      
DECLARE @PARA varchar(500)      
DECLARE @CC varchar(500)      
DECLARE @sDescri VarChar(100)  
DECLARE @sSiEnvio int  
DECLARE @sCont int  
  
select @PARA = 'lmalpartida@neptunia.com.pe;aporras@neptunia.com.pe;jsaavedra@neptunia.com.pe'  
                  
declare @msg varchar (8000)      
declare @strama varchar (500)       
select @ASUNTO = 'SP_ALERTA_DIFERENCIA_TAMAÑO_CTR'    
set @msg = ''  
set @sCont=0  
DECLARE cursor_Ctrs CURSOR for               
  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Peso_Ctrs(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Peso_Ctrs (VALORIZ.) :  ' + rtrim(a.c_Peso_Ctrs)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 1  
and   b.des_meac <> a.c_Peso_Ctrs  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Tipo_de_Ctr(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Tipo_de_Ctr(VALORIZ.) :  ' + rtrim(a.c_Tipo_de_Ctr)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 2  
and   b.des_meac <> a.c_Tipo_de_Ctr  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   TAMAÑO CTR(ACUERDO) :  ' + rtrim(b.des_meac) + '   TAMAÑO CTR(VALORIZ.) :  ' + rtrim(a.c_tamaño_del_ctr)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 3  
and   b.des_meac <> a.c_tamaño_del_ctr  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Condición_del_Ctr(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Condición_del_Ctr(VALORIZ.) :  ' + rtrim(a.c_Condición_del_Ctr)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 4  
and   b.des_meac <> a.c_Condición_del_Ctr  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Estado_del_Ctr(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Estado_del_Ctr(VALORIZ.) :  ' + rtrim(a.c_Estado_del_Ctr)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 5  
and   b.des_meac <> a.c_Estado_del_Ctr  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Mercadería_del_Ctr(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Mercadería_del_Ctr(VALORIZ.) :  ' + rtrim(a.c_Mercadería_del_Ctr)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 6  
and   b.des_meac <> a.c_Mercadería_del_Ctr  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Consolidado(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Consolidado(VALORIZ.) :  ' + rtrim(a.c_Consolidado)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 7  
and   b.des_meac <> a.c_Consolidado  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Ligado(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Ligado(VALORIZ.) :  ' + rtrim(a.c_Ligado)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 10  
and   b.des_meac <> a.c_Ligado  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Forrado(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_Forrado(VALORIZ.) :  ' + rtrim(a.c_Forrado)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 11  
and   b.des_meac <> a.c_Forrado  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Tipo_de_llenado(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_Tipo_de_llenado(VALORIZ.) :  ' + rtrim(a.c_Tipo_de_llenado)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 12  
and   b.des_meac <> a.c_Tipo_de_llenado  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Planta(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Planta(VALORIZ.) :  ' + rtrim(a.c_Planta)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 13  
and   b.des_meac <> a.c_Planta  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Prorrateado_al_Consolidador(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_Prorrateado_al_Consolidador(VALORIZ.) :  ' + rtrim(a.c_Prorrateado_al_Consolidador)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 14  
and   b.des_meac <> a.c_Prorrateado_al_Consolidador  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Booking(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Booking(VALORIZ.) :  ' + rtrim(a.c_Booking)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 15  
and   b.des_meac <> a.c_Booking  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Peso_de_Mercaderia(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_Peso_de_Mercaderia(VALORIZ.) :  ' + rtrim(a.c_Peso_de_Mercaderia)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 16  
and   b.des_meac <> a.c_Peso_de_Mercaderia  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Cantidad_de_Mercaderia(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Cantidad_de_Mercaderia(VALORIZ.) :  ' + rtrim(a.c_Cantidad_de_Mercaderia)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 17  
and   b.des_meac <> a.c_Cantidad_de_Mercaderia  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Volumen_de_Mercaderia(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Volumen_de_Mercaderia(VALORIZ.) :  ' + rtrim(a.c_Volumen_de_Mercaderia)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 18  
and   b.des_meac <> a.c_Volumen_de_Mercaderia  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Tipo_de_Mercaderia(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Tipo_de_Mercaderia(VALORIZ.) :  ' + rtrim(a.c_Tipo_de_Mercaderia)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 19  
and   b.des_meac <> a.c_Tipo_de_Mercaderia  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Tipo_de_Vehiculo(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Tipo_de_Vehiculo(VALORIZ.) :  ' + rtrim(a.c_Tipo_de_Vehiculo)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 20  
and   b.des_meac <> a.c_Tipo_de_Vehiculo  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Embalaje(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Embalaje(VALORIZ.) :  ' + rtrim(a.c_Embalaje)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 21  
and   b.des_meac <> a.c_Embalaje  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Cantidad_de_Vehiculos(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Cantidad_de_Vehiculos(VALORIZ.) :  ' + rtrim(a.c_Cantidad_de_Vehiculos)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 22  
and   b.des_meac <> a.c_Cantidad_de_Vehiculos  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_Volumen_Acumulativo(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_Volumen_Acumulativo(VALORIZ.) :  ' + rtrim(a.c_Volumen_Acumulativo)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 23  
and   b.des_meac <> a.c_Volumen_Acumulativo  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_CONDICION_DE_MERCADERIA(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_CONDICION_DE_MERCADERIA(VALORIZ.) :  ' + rtrim(a.c_CONDICION_DE_MERCADERIA)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 24  
and   b.val_meac <> a.c_CONDICION_DE_MERCADERIA  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_HORAS(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_HORAS(VALORIZ.) :  ' + rtrim(a.c_HORAS)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 25  
and   b.des_meac <> a.c_HORAS  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_CANTIDAD_ETIQUETAS(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_CANTIDAD_ETIQUETAS(VALORIZ.) :  ' + rtrim(a.c_CANTIDAD_ETIQUETAS)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 26  
and   b.des_meac <> a.c_CANTIDAD_ETIQUETAS  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_DIAS(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_DIAS(VALORIZ.) :  ' + rtrim(a.c_DIAS)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 27  
and   b.des_meac <> a.c_DIAS  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   C_REEFER_CONECTADO__IMPO_(ACUERDO) :  ' + rtrim(b.des_meac) + '   C_REEFER_CONECTADO__IMPO_(VALORIZ.) :  ' + rtrim(a.C_REEFER_CONECTADO__IMPO_)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 28  
and   b.des_meac <> a.C_REEFER_CONECTADO__IMPO_  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_INSPECCIONADO(ACUERDO) :  ' + rtrim(b.des_meac) + '  c_INSPECCIONADO(VALORIZ.) :  ' + rtrim(a.c_INSPECCIONADO)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 29  
and   b.des_meac <> a.c_INSPECCIONADO  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   C_REEFER_CONECTADO__EXPO_(ACUERDO) :  ' + rtrim(b.des_meac) + '   C_REEFER_CONECTADO__EXPO_(VALORIZ.) :  ' + rtrim(a.C_REEFER_CONECTADO__EXPO_)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 30  
and   b.des_meac <> a.C_REEFER_CONECTADO__EXPO_  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_UNIDAD_MERCADERIA(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_UNIDAD_MERCADERIA(VALORIZ.) :  ' + rtrim(a.c_UNIDAD_MERCADERIA)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and       b.cod_merc = 30  
and   b.des_meac <> a.c_UNIDAD_MERCADERIA  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
union  
select 'CODIGO ACUERDO: ' + convert(char(8),a.cod_acue) + '  FECHA CREACION : ' +  convert(char(8),d.fec_crea,112) + '   c_HORAS_LIBRES(ACUERDO) :  ' + rtrim(b.des_meac) + '   c_HORAS_LIBRES(VALORIZ.) :  ' + rtrim(a.c_HORAS_LIBRES)  
FROM St_T_Tarifario_cubo a,St_T_caracteristicas_Acuerdo b,St_T_acuerdos d  
where   a.cod_acue =  b.cod_acue   
and       d.cod_acue =  b.cod_acue   
and    b.cod_merc = 30  
and   b.des_meac <> a.c_HORAS_LIBRES  
and       convert(char(8),d.fec_crea,112) >= '20060801'  
            OPEN cursor_Ctrs  
            FETCH NEXT FROM cursor_Ctrs  
            INTO @sTrama  
                          
            WHILE @@FETCH_STATUS = 0              
            BEGIN              
  
                        if @sCont>= 0 and @sCont<=80                         
                                   begin   
                                               set @msg= @msg +   CAST(@sCont as char(4))+ @sTrama + char(13)  
                                   end  
                          
            set @sCont=@sCont+1  
            FETCH NEXT FROM cursor_Ctrs  
            INTO @sTrama  
            end              
            CLOSE cursor_Ctrs  
 DEALLOCATE cursor_Ctrs  
  
            set @ASUNTO = @ASUNTO+ 'Total Ctrs: ' + CAST(@sCont  as char(5))  
              
            if @sCont>0   
            begin   
              
                        Execute master.dbo.xp_smtp_sendmail    
                         @FROM   = 'aneptunia@neptunia.com.pe',    
                         @TO   = @PARA,    
                                 @message = @msg ,  
                                 @subject = @ASUNTO,    
                                 @server = 'calw8mail002.neptunia.com.pe'  
            end  
  
    
GO
/****** Object:  StoredProcedure [dbo].[sp_Comercial_Get_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Comercial_Get_Acuerdos]
as
select COD_SERV=a.Dc_Servicio,SERVICIO=Dg_Servicio, RUC=a.Contribuy , NOMBRE=Cliente,  
FEC_CREACION=Fec_Crea, COD_ACUERDO=a.Cod_Acue, VAL_ACUERDO=a.Val_acue 
from  
St_V_Cu_Tarifario_Cubo a (nolock) 
inner join St_T_Acuerdos b (nolock) on (a.Cod_Acue=b.Cod_Acue)
where a.contribuy is not null
order by cliente, COD_ACUERDO, dg_centro_costo_apl, dg_sucursal_apl

GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Active_New_Tarifario]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_Active_New_Tarifario]  
@sRuc char(11),  
@sCenCos varchar(4),  
@sSucur varchar(4)  
AS  
select count(*)  
from St_t_Acuerdos   
where   
--Cod_Esta='A'  and   
Fec_Acti<=getdate() and Fec_Crea>='20060801'  
and Usu_Acue=''  
and  
--contribuy=@sRuc  and   
--Dc_Centro_Costo=@sCenCos and  
--Dc_Sucursal=@sSucur  
Dc_Centro_Costo_A in ('3','1','26') and   
Dc_Sucursal_A in('2','7','1')  


GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Aereo_GenEntidades_Cab_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[sp_Impo_Aereo_GenEntidades_Cab_CS]
--@NROSEC char(6),  
--@RUCCLI char(11),  
--@CODUSU char(20),  
--@CENCOS int,  
--@SUCUR int  
  
--as  
--declare   
  
--@idReg int,  
--@CODAGE char(4),   
--@RUCAGE char(11), 
--@EMBESP char(11),   
--@CODSER char(3),   
--@CODARM char(3),  
--@CODNAV char(4),   
--@CODPUE char(3),  
--@CODCLI char(11),   
--@CODCON char(11),   
--@OL int,   
--@CANBUL int,  
  
--@PREPAI char(1),   
--@COLLEC char(1),  
--@IDCLIE char(11),  
--@FC int ,   
--@LC int,   
--@CLILIN char(11),  
--@DIALIB int,  
--@DIAALM int,  
--@SUC char(1) ,  
--@NROCTR char(11) ,  
--@NAVVIA char(6),   
--@CANCTR int,  
--@HORASCONEX int,  
  
--@codtip05 char(2),   
--@pesbrt63 float,   
--@codtam09 char(2),   
--@codbol03 char(2),

--@NROCAR char(8)

--create table #Tempo01    
--(
--XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--XFECCONEX smalldatetime,
--XFECDESCO smalldatetime,
--XDIFHORAS int
--)  
  
--begin  


--insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
--select distinct a.codcon04, a.navvia11, b.fectra67 
--from 
--neptunia30.terminalaereo.dbo.drblcont15 a, 
--neptunia30.terminalaereo.dbo.ddordtra67 b, 
--neptunia30.terminalaereo.dbo.dddettra68 c
--where 
--a.navvia11=b.navvia11 and
--a.codcon04=c.codcon04 and
--b.nrotra67=c.nrotra67 and
--c.tiptra68='C' and nrosec23=@NROSEC 


--select @idReg =max(id)+1 from st_tr_documento  
  
--/** Insert Table Document **/  
--insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
--(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
--/** Insert Table Entidad **/  
--select @suc=sucursal, @navvia=navvia11 from neptunia30.terminalaereo.dbo.ddvoldes23 where nrosec23=@NROSEC  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56 where codreg56='10' and sucursal=@suc  
  
--select   
--@CODAGE=a.codage19, @CODARM=b.codarm10,   
--@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
--@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
--@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
--@EMBESP=b.embesp12, @CANBUL=b.canmer12  
--from   
--neptunia30.terminalaereo.dbo.ddvoldes23 a  , 
--neptunia30.terminalaereo.dbo.dddetall12 b  , 
--neptunia30.terminalaereo.dbo.ddcabman11 c 
--where   
--a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
--b.navvia11=c.navvia11 and nrosec23=@NROSEC   

--select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
--select @CODSER=codser30 
--from neptunia30.terminalaereo.dbo.drnavser31  where codnav08=@CODNAV  
--if @CODSER is not null OR @CODSER <> NULL  
  
  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


--if @IDCLIE is not null OR @IDCLIE <> NULL  
--begin  
-- select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
--end  
  
--if @EMBESP is not null OR @EMBESP <> NULL  
--begin      
--  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
--end  
  
--if @CODCON IS NOT NULL OR @CODCON <> NULL  
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
--if @PREPAI='1'   
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
--if @COLLEC='1'  

---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
--end  
  
--begin  

--select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) 
--from 
--neptunia30.terminalaereo.dbo.ddvoldes23 a  , 
--neptunia30.terminalaereo.dbo.ddcargas16 b  , 
--neptunia30.terminalaereo.dbo.dqarmado10 c  , 
--neptunia30.terminalaereo.dbo.dddetall12 d 
--where 
--a.navvia11=b.navvia11 and
--a.nrodet12=b.nrodet12 and
--a.codarm10=c.codarm10 and
--a.navvia11=d.navvia11 and
--a.nrodet12=d.nrodet12 and
--c.flgnep10 ='0' and
--b.codcon04 is null and
--a.nrosec23 =@NROSEC
--group by rucesp12

  
--if @OL>0   
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
--end  
  
  
--if @SUCUR= 7   
--begin  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56  where sucursal='3' and codreg56='10'  
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
--end  
  
--if @SUCUR= 14   
--begin  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56   where sucursal='5' and codreg56='10'  
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
--end   
  
  
--select @DIAALM=datediff(day,fecalm12,getdate())+1 
--from 
--neptunia30.terminalaereo.dbo.dddetall12 a  , 
--neptunia30.terminalaereo.dbo.ddvoldes23 b 
--where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
--b.nrosec23 =@NROSEC  
--IF @DIALIB>=@DIAALM
--begin
--set @DIAALM=0
--end
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
--select @CANCTR=count(codcon63) 
--from 
--neptunia30.terminalaereo.dbo.drblcont15 where nrosec23=@nrosec  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
--/** Insert Table Details **/  
  
--insert  into st_tr_detalle    (id, id_item) 
--select distinct @idReg, nrocar16+nrosec22  from   
--neptunia30.terminalaereo.dbo.DDCARTAR22  where nrosec23=@NROSEC
  
--/** Insert Caracteristics Table Details **/  
  
--BEGIN
--DECLARE CursorDetailsCS CURSOR FOR 
--SELECT id_item FROM st_tr_detalle WHERE id=@idReg
--END

--OPEN CursorDetailsCS

--	FETCH next FROM CursorDetailsCS INTO @NROCAR
--	WHILE @@FETCH_STATUS <> -1
--	begin
--		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from neptunia30.terminalaereo.dbo.ddcartar22 where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')			
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19,'11500')			
--		FETCH next FROM CursorDetailsCS  INTO @NROCAR
--	end 

--CLOSE CursorDetailsCS
--DEALLOCATE 	CursorDetailsCS

  
--/** Insert  Servicios Manuales**/  
  
----insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
--insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

--SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    
--FROM st_tr_detalle a  , 
--neptunia30.terminalaereo.dbo.ddordser32 b  , 
--neptunia30.terminalaereo.dbo.dddetors33 c  , 
--neptunia30.terminalaereo.dbo.fqcontar14 d 
--where 
--a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
--b.codcon35=d.codcon14 and
--b.nroors32=c.nroors32 and
--a.id=@idReg and b.navvia11=@navvia and
--d.sucursal=@SUC and
--b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null

--insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
--SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   
--FROM st_tr_detalle a (nolock)  , 
--neptunia30.terminalaereo.dbo.ddordser32 b  , 
--neptunia30.terminalaereo.dbo.dddetors33 c  , 
--neptunia30.terminalaereo.dbo.fqcontar14 d  
--where 
--a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
--b.codcon35=d.codcon14 and
--b.nroors32=c.nroors32 and
--a.id=@idReg and b.navvia11=@navvia and
--d.sucursal=@SUC and
--b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null

--/** Insert  Servicios Manuales**/
--insert into St_TR_Descuentos_Manuales

--(ID,          db_servicio, Tip_Desc,  Val_Desc )
--SELECT  
--@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
--FROM 
--neptunia30.terminalaereo.dbo.DDDESCUE79 a  , 
--neptunia30.terminalaereo.dbo.DDDETDSC80 b  , 
--neptunia30.terminalaereo.dbo.fqcontar14 c 
--where 
--a.nrodes79=b.nrodes79 and
--b.codcon35=c.codcon14 and
--a.nrosec23=@nrosec and
--c.sucursal=@SUC and
--a.nrofac37 is null
  
--/** Insert  Servicios Manuales**/  
--insert into St_TR_Descuentos_Manuales  
--(ID,          db_servicio, Tip_Desc,  Val_Desc )  
--SELECT    
--@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
--FROM   
--neptunia30.terminalaereo.dbo.DDDESCUE79 a  , 
--neptunia30.terminalaereo.dbo.DDDETDSC80 b  , 
--neptunia30.terminalaereo.dbo.fqcontar14 c 
--where   
--a.nrodes79=b.nrodes79 and  
--b.codcon35=c.codcon14 and  
--a.nrosec23=@nrosec and  
--c.sucursal=@SUC and  
--a.nrofac37 is null

--drop table #Tempo01
--GO
--/****** Object:  StoredProcedure [dbo].[sp_Impo_Aereo_GenEntidades_Valoriza_Cab_CS_N]    Script Date: 07/03/2019 04:16:53 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[sp_Impo_Aereo_GenEntidades_Valoriza_Cab_CS_N]
--@NROSEC char(6),  
--@RUCCLI char(11),  
--@CODUSU char(20),  
--@CENCOS int,  
--@SUCUR int,
--@FecProy char(8)  
  
--as  
--declare   
  
--@idReg int,  
--@CODAGE char(4),   
--@RUCAGE char(11),   
--@EMBESP char(11),   
--@CODSER char(3),   
--@CODARM char(3),  
--@CODNAV char(4),   
--@CODPUE char(3),  
--@CODCLI char(11),   
--@CODCON char(11),   
--@OL int,   
--@CANBUL int,  
  
--@PREPAI char(1),   
--@COLLEC char(1),  
--@IDCLIE char(11),  
--@FC int ,   
--@LC int,   
--@CLILIN char(11),  
--@DIALIB int,  
--@DIAALM int,  
--@SUC char(1) ,  
--@NROCTR char(11) ,  
--@NAVVIA char(6),   
--@CANCTR int,  
--@HORASCONEX int,  
  
--@codtip05 char(2),   
--@pesbrt63 float,   
--@codtam09 char(2),   
--@codbol03 char(2),

--@NROCAR char(8)

--create table #Tempo01    
--(
--XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--XFECCONEX smalldatetime,
--XFECDESCO smalldatetime,
--XDIFHORAS int
--)  
  
--begin  


--insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
--select distinct a.codcon04, a.navvia11, b.fectra67 
--from neptunia30.terminalaereo.dbo.drblcont15 a, neptunia30.terminalaereo.dbo.ddordtra67 b, neptunia30.terminalaereo.dbo.dddettra68 c
--where 
--a.navvia11=b.navvia11 and
--a.codcon04=c.codcon04 and
--b.nrotra67=c.nrotra67 and
--c.tiptra68='C' and nrosec23=@NROSEC 


--select @idReg =max(id)+1 from st_tr_documento  
  
--/** Insert Table Document **/  
--insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
--(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
--/** Insert Table Entidad **/  
--select @suc=sucursal, @navvia=navvia11 from neptunia30.terminalaereo.dbo.ddvoldes23 where nrosec23=@NROSEC  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56 where codreg56='10' and sucursal=@suc  
  
--select   
--@CODAGE=a.codage19, @CODARM=b.codarm10,   
--@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
--@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
--@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
--@EMBESP=b.embesp12, @CANBUL=b.canmer12  
--from   
--neptunia30.terminalaereo.dbo.ddvoldes23 a  , neptunia30.terminalaereo.dbo.dddetall12 b  , 
--neptunia30.terminalaereo.dbo.ddcabman11  c 
--where   
--a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
--b.navvia11=c.navvia11 and nrosec23=@NROSEC   

--select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
--select @CODSER=codser30 from neptunia30.terminalaereo.dbo.drnavser31  where codnav08=@CODNAV  
--if @CODSER is not null OR @CODSER <> NULL  
  
  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


--if @IDCLIE is not null OR @IDCLIE <> NULL  
--begin  
-- select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
--end  
  
--if @EMBESP is not null OR @EMBESP <> NULL  
--begin      
--     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
--end  
  
--if @CODCON IS NOT NULL OR @CODCON <> NULL  
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
--if @PREPAI='1'   
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
---- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
--if @COLLEC='1'  

-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
--end  
  
--begin  

--select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) 
--from neptunia30.terminalaereo.dbo.ddvoldes23 a  , neptunia30.terminalaereo.dbo.ddcargas16 b  , 
--neptunia30.terminalaereo.dbo.dqarmado10 c  , neptunia30.terminalaereo.dbo.dddetall12 d 
--where 
--a.navvia11=b.navvia11 and
--a.nrodet12=b.nrodet12 and
--a.codarm10=c.codarm10 and
--a.navvia11=d.navvia11 and
--a.nrodet12=d.nrodet12 and
--c.flgnep10 ='0' and
--b.codcon04 is null and
--a.nrosec23 =@NROSEC
--group by rucesp12

  
--if @OL>0   
---- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
--end  
  
  
--if @SUCUR= 7   
--begin  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56   where sucursal='3' and codreg56='10'  
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
--end  
  
--if @SUCUR= 14   
--begin  
--select @DIALIB=dialib56 from neptunia30.terminalaereo.dbo.DQREGIME56  where sucursal='5' and codreg56='10'  
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
--end   
  
  
--select @DIAALM=datediff(day,@FecProy,getdate())+1 
--from neptunia30.terminalaereo.dbo.dddetall12 a  , neptunia30.terminalaereo.dbo.ddvoldes23 b 
--where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
--b.nrosec23 =@NROSEC  

--IF @DIALIB>=@DIAALM
--begin
--set @DIAALM=0
--end

-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
--select @CANCTR=count(codcon63) from neptunia30.terminalaereo.dbo.drblcont15 where nrosec23=@nrosec  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
--insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
--/** Insert Table Details **/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   neptunia30.terminalaereo.dbo.DDCARTAR22  where nrosec23=@NROSEC 
  
--/** Insert Caracteristics Table Details **/  
  
--BEGIN
--DECLARE CursorDetailsCS CURSOR FOR 
--SELECT id_item FROM st_tr_detalle WHERE id=@idReg
--END

--OPEN CursorDetailsCS

--	FETCH next FROM CursorDetailsCS INTO @NROCAR
--	WHILE @@FETCH_STATUS <> -1
--	begin
--		select @pesbrt63=pestar22, @codtam09=bulalm22  from neptunia30.terminalaereo.dbo.ddcartar22  where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar

--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

--		FETCH next FROM CursorDetailsCS  INTO @NROCAR
--	end 

--CLOSE CursorDetailsCS
--DEALLOCATE 	CursorDetailsCS

  
--/** Insert  Servicios Manuales**/  
  
----insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
--insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

--SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    
--FROM st_tr_detalle a  , neptunia30.terminalaereo.dbo.ddordser32 b  , neptunia30.terminalaereo.dbo.dddetors33 c  , 
--neptunia30.terminalaereo.dbo.fqcontar14 d
--where 
--a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
--b.codcon35=d.codcon14 and
--b.nroors32=c.nroors32 and
--a.id=@idReg and b.navvia11=@navvia and
--d.sucursal=@SUC and
--b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

--insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
--SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   
--FROM st_tr_detalle a  , neptunia30.terminalaereo.dbo.ddordser32 b , neptunia30.terminalaereo.dbo.dddetors33 c  , 
--neptunia30.terminalaereo.dbo.fqcontar14 d 
--where 
--a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
--b.codcon35=d.codcon14 and
--b.nroors32=c.nroors32 and
--a.id=@idReg and b.navvia11=@navvia and
--d.sucursal=@SUC and
--b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

--/** Insert  Servicios Manuales**/
--insert into St_TR_Descuentos_Manuales

--(ID,          db_servicio, Tip_Desc,  Val_Desc )
--SELECT  
--@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
--FROM 
--neptunia30.terminalaereo.dbo.DDDESCUE79 a  , neptunia30.terminalaereo.dbo.DDDETDSC80 b  , neptunia30.terminalaereo.dbo.fqcontar14 c 
--where 
--a.nrodes79=b.nrodes79 and
--b.codcon35=c.codcon14 and
--a.nrosec23=@nrosec and
--c.sucursal=@SUC 
  
--/** Insert  Servicios Manuales**/  
--insert into St_TR_Descuentos_Manuales  
--(ID,          db_servicio, Tip_Desc,  Val_Desc )  
--SELECT    
--@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
--FROM   
--neptunia30.terminalaereo.dbo.DDDESCUE79 a  , neptunia30.terminalaereo.dbo.DDDETDSC80 b  , neptunia30.terminalaereo.dbo.fqcontar14 c 
--where   
--a.nrodes79=b.nrodes79 and  
--b.codcon35=c.codcon14 and  
--a.nrosec23=@nrosec and  
--c.sucursal=@SUC 

--drop table #Tempo01

--select @IdReg
--GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Consulta_id_Generado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Consulta_id_Generado]

@snrofac     char (9)

as

Begin
	select b.ID
	from ddfactur37 a, ST_TR_Documento b
	where 
	a.nrosec23t COLLATE SQL_Latin1_General_CP1_CI_AS = b.cod_docu and
	a.codusu17 COLLATE SQL_Latin1_General_CP1_CI_AS = b.Cod_Usua and
	day(fecemi37)= day(Fec_Docu) and
	nrofac37 = @snrofac

End
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab]    
@NROSEC char(6),    
@RUCCLI char(11),    
@CODUSU char(20),    
@CENCOS int,    
@SUCUR int    
    
as    
declare     
    
@idReg int,    
@CODAGE char(4),     
@RUCAGE char(11),     
@EMBESP char(11),     
@CODSER char(3),     
@CODARM char(3),    
@CODNAV char(4),     
@CODPUE char(3),    
@CODCLI char(11),     
@CODCON char(11),     
@OL int,     
@SI int,
@CANBUL int,    
    
@PREPAI char(1),     
@COLLEC char(1),    
@IDCLIE char(11),    
@FC int ,     
@LC int,     
@CLILIN char(11),    
@DIALIB int,    
@DIAALM int,    
@SUC char(1) ,    
@NROCTR char(11) ,    
@NAVVIA char(6),     
@CANCTR int,    
@HORASCONEX int,    
    
@codtip05 char(2),     
@pesbrt63 float,     
@codtam09 char(2),     
@codbol03 char(2),  
@splanta char(4),  
  
@tipmon char(1),  
  
@iAmpDia int  
  
create table #Tempo01      
(  
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XFECCONEX smalldatetime,  
XFECDESCO smalldatetime,  
XDIFHORAS int  
)    
    
begin    
    
insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)  
select distinct a.navvia11, a.codcon04,  b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
  
  
update #Tempo01 set XFECDESCO=b.fectra67  
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
c.tiptra68='D' and nrosec23=@NROSEC   
  
update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)  
  
  
select @iAmpDia=case when sum(b.ampdia80)  is null then 0 else sum(b.ampdia80) end  from DDDESCUE79 a, DDDETDSC80 b, DDVOLDES23 c where   
a.navvia11=c.navvia11 and  
a.nrodet12=c.nrodet12  and  
a.nrodes79=b.nrodes79 and   
codcon35='DILIB' and c.nrosec23=@NROSEC   
  
begin tran  
select @idReg =max(id)+1 from st_tr_documento    
    
/** Insert Table Document **/    
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values     
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)     

 commit   
    
/** Insert Table Entidad **/    
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC    
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc    
    
select     
@CODAGE=a.codage19, @CODARM=b.codarm10,     
@CODNAV=c.codnav08, @CODPUE=b.codpue02,     
@PREPAI=b.frepre12, @COLLEC=b.frecol12,     
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,    
@EMBESP=b.embesp12, @CANBUL=b.canmer12    
from     
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)      
where     
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and     
b.navvia11=c.navvia11 and nrosec23=@NROSEC     
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)    
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)    
    
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV    
if @CODSER is not null OR @CODSER <> NULL    
      
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')    
    
set @sPlanta=''    
select @sPlanta=cast(CODPLANTA as char(4) ) from terminal..SSI_ORDEN where CODPLANTA is not null and ORD_NUMDOCUMENTO= @NROSEC
and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,38,@sPlanta)    
  
if @IDCLIE is not null OR @IDCLIE <> NULL    
begin    
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)     
end    
    
if @EMBESP is not null OR @EMBESP <> NULL    
begin        
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP    
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)    
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)     
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0    
end    
    
if @CODCON IS NOT NULL OR @CODCON <> NULL    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)      
    
if @PREPAI='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')      
    
if @COLLEC='1'    
  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                                 
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')      
end    
    
select @OL=count(*)     
from ddvoldes23 a (nolock) , dddetall12 b (nolock) ,  dqarmado10 c (nolock)     
where     
a.navvia11=b.navvia11 and    
a.nrodet12=b.nrodet12 and    
b.codarm10=c.codarm10 and    
c.flgnep10 ='0' and    
a.nrosec23 =@NROSEC    
  
if @OL>0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'SI')      
      
if @OL<=0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'NO')      

  
select @SI =count(ORD_CODIGO) from terminal..SSI_ORDEN where ORD_NUMDOCUMENTO = @NROSEC  and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   
if @SI>0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'SI')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'SI')      
end

if @SI<=0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'NO')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'NO')      
end
       
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and    
b.nrosec23 =@NROSEC    
  
IF @DIALIB>=@DIAALM  
begin  
set @DIAALM=0  
end  
  
  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM-@iAmpDia)      
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIAALM-@iAmpDia)        
    
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)    
    
    
    
/** Insert Table Details **/    
    
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC   and codcon63 is not null  
    
/** Insert Caracteristics Table Details **/    
    
BEGIN    
DECLARE CursorDetailsCtrs CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    

    
OPEN CursorDetailsCtrs    
    
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)       
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)      
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)      
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrs    
DEALLOCATE  CursorDetailsCtrs    
  
/** Insert Caracteristics Table Details Horas en conexion **/    
  
  
BEGIN    
DECLARE CursorDetailsCtrsRF CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrsRF    
    
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,32, @HORASCONEX)      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,28, 'SI')      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,27,  @DIAALM)      
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrsRF    
DEALLOCATE  CursorDetailsCtrsRF    
  
  
    
/** Insert  Servicios Manuales**/    
    

select @tipmon=Tip_mone from St_T_Clientes_Moneda where contribuy= @RUCCLI   
    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv,Cod_Orde )       
SELECT distinct 'M', ID, ID_Item, 
case when @tipmon = 'S' then  codsbd03 else codsbd03_D end ,  @SUCUR,  @CENCOS, 0 , b.nroors32  
FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
--b.nrosec23=@NROSEC  and  
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'  and b.nrofac37 is null    
  
if   @tipmon='S'  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null    
  
if   @tipmon='D'    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, '177',  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null    
    
/** Insert  Servicios Manuales**/    
  
if   @tipmon='S'  
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, c.codsbd03, b.tipdsc80, b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)    
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
c.sucursal=@SUC and    
a.nrofac37 is null  
  
if   @tipmon='D'  
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, c.codsbd03_D, b.tipdsc80, b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , terminal..fqcontar14 c (nolock)    
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
c.sucursal=@SUC and    
a.nrofac37 is null  
  
drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Bal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_GenEntXVolante    Script Date: 08-09-2002 08:50:09 PM ******/
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Bal]
@NROCTR char(11),
@RUCCLI char(11),
@CODTIP char(2), 
@CODTAM char(2), 
@CODUSU char(20),
@CODSER char(5),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODCLI char(11), 
@IDCLIE char(11),
@CODULT char(3)

begin

select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROCTR, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@RUCCLI)	

/** Insert Table Details **/

insert  st_tr_detalle    (id, id_item)  Values (@idReg, @NROCTR)

/** Insert Caracteristics Table Details **/

insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip)			
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam)		
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)    

/** Insert  Servicios Manuales**/

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
values
(
'E',@idReg ,@NROCTR, @CODULT,  @SUCUR,  @CENCOS, 0 
)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_GenEntXVolante    Script Date: 08-09-2002 08:50:09 PM ******/  
  
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_CS]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11), 
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  
IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   DDCARTAR22 (nolock) where nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19,'11500')			
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC and
a.nrofac37 is null
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC and  
a.nrofac37 is null

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_CS_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_CS_LC]
@NROSEC char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@RUCAGE char(11),   
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11)

begin
select @idReg =max(id)+1 from st_tr_documento 

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordret41 where nroord41=@NROSEC
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordret41 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 

where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroord41=@NROSEC 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL


--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
--	  insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordret41 a (nolock) , ddcargas16 b (nolock) , ddcartar22 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetord43 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.nroord41=f.nroord41 and
b.nrocar16=c.nrocar16 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
e.codarm10=d.codarm10 and
c.nrocar16=f.nrocar16 and
c.nrosec22=f.nrosec22 and
d.flgnep10 ='0' and
a.nroord41 =@NROSEC 
group by rucesp12

if @OL>0 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end

if @SUCUR= 14 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)		
end 


select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddordret41 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and
b.nroord41 =@NROSEC
IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)		


/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from ddcartar22 a (nolock), ddordret41 b (nolock), dddetord43 c (nolock) 
where 
b.nroord41=c.nroord41 and
a.nrosec22=c.nrosec22 and
a.nrocar16=c.nrocar16 and
b.nroord41=@NROSEC

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05='', @pesbrt63=pestar22, @codtam09='', @codbol03=bulalm22  from ddcartar22 (nolock) where  nrocar16+nrosec22=@NROCTR
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,19, '11500')			
	
		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs

/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

----Inserto el Concepto Reemisión
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, 51,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle  (nolock)
where 
id=@idReg 


insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

/*
SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg 

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
Values
('E', @idReg,  @ID_Item,  51,  @SUCUR , @CENCOS, 0 )
**/
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_CS_LC_AP]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_CS_LC_AP]
@NROSEC char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11)

begin
select @idReg =max(id)+1 from st_tr_documento 

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordret41 where nroord41=@NROSEC
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordret41 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 

where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroord41=@NROSEC 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL


--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
--	  insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordret41 a (nolock) , ddcargas16 b (nolock) , ddcartar22 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetord43 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.nroord41=f.nroord41 and
b.nrocar16=c.nrocar16 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
e.codarm10=d.codarm10 and
c.nrocar16=f.nrocar16 and
c.nrosec22=f.nrosec22 and
d.flgnep10 ='0' and
a.nroord41 =@NROSEC 
group by rucesp12

if @OL>0 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end

if @SUCUR= 14 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)		
end 


select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddordret41 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and
b.nroord41 =@NROSEC
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)		


/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from ddcartar22 a (nolock), ddordret41 b (nolock), dddetord43 c (nolock) 
where 
b.nroord41=c.nroord41 and
a.nrosec22=c.nrosec22 and
a.nrocar16=c.nrocar16 and
b.nroord41=@NROSEC

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05='', @pesbrt63=pestar22, @codtam09='', @codbol03=bulalm22  from ddcartar22 (nolock) where  nrocar16+nrosec22=@NROCTR
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)		
		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs

/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

----Inserto el Concepto Reemisión
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, 51,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle  (nolock)
where 
id=@idReg 


insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

/*
SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg 

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
Values
('E', @idReg,  @ID_Item,  51,  @SUCUR , @CENCOS, 0 )
**/
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Ctr]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_GenEntXVolante    Script Date: 08-09-2002 08:50:09 PM ******/
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Ctr]
@NROCTR char(11),
@RUCCLI char(11),
@CODTIP char(2), 
@CODTAM char(2), 
@CODUSU char(20),
@CODSER char(5),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODCLI char(11), 
@IDCLIE char(11),
@CODULT char(3)

begin

select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROCTR, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@RUCCLI)	

/** Insert Table Details **/

insert  st_tr_detalle    (id, id_item)  Values (@idReg, @NROCTR)

/** Insert Caracteristics Table Details **/

insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip)			
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam)		
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)    

/** Insert  Servicios Manuales**/

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
values
(
'E',@idReg ,@NROCTR, @CODULT,  @SUCUR,  @CENCOS, 0 
)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Manipuleo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Manipuleo]
@NROORS char(6),
@CODCON char(5),
@CODTAM char(2),
@RUCCLI char(11),
@CODUSU char(20),
@NROCTR char(11),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int

begin

begin tran
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROORS, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 

commit

/** Insert Table Entidad **/

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@RUCCLI)	


end

begin

/** Insert Table Details **/

 insert   st_tr_detalle    (id, id_item)  values (@idReg, @NROCTR)


/** Insert Caracteristics Table Details **/

insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')   
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')    
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @CODTAM)		

/** Insert  Servicios Manuales**/

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT 'M', @idReg,@NROCTR,46 ,  @SUCUR,  @CENCOS, 0 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Servicios]
@NROORS char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11)

begin

begin tran
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROORS, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 

commit

/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordser32 where nroors32=@NROORS

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordser32 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 
where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroors32=@NROORS 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordser32 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetors33 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
b.navvia11=c.navvia11 and
b.codcon04=c.codcon04 and
c.codarm10=d.codarm10 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
a.nroors32 =@NROORS
group by rucesp12

if @OL>0 
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end





/** Insert Table Details **/

-- insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from dddetors33 where nroors32=@NROORS

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)		
--		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')    
--	             insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')    
		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs

/** Insert  Servicios Manuales**/

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null and b.nroors32=@NROORS

SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Servicios_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Servicios_CS]
@NROORS char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11),
@NROCAR char(8)

begin
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROORS, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 

/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordser32 where nroors32=@NROORS

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordser32 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 
where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroors32=@NROORS 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,9,'11500')

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordser32 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetors33 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
b.navvia11=c.navvia11 and
b.codcon04=c.codcon04 and
c.codarm10=d.codarm10 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
a.nroors32 =@NROORS
group by rucesp12

if @OL>0 
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end





/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16 + nrosec22 from dddetors33 where nroors32=@NROORS

/** Insert Caracteristics Table Details **/

  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 a (nolock)  , dddetors33 b (nolock)  where 
		a.nrocar16=b.nrocar16 and a.nrosec22=b.nrosec22 and nroors32=@NROORS and a.nrocar16+a.nrosec22=@nrocar
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			



		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

/** Insert  Servicios Manuales**/

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16+c.nrosec22 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null and b.nroors32=@NROORS

SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Servicios_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Servicios_Veh]
@NROORS char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11),
@NROCAR char(8)

begin
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROORS, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 

/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordser32 where nroors32=@NROORS

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordser32 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 
where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroors32=@NROORS 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end





/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14 from dddetors33 where nroors32=@NROORS

/** Insert Caracteristics Table Details **/

  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar14), @codtam09=1  from ddvehicu14 a (nolock)  , dddetors33 b (nolock)  where 
		a.nroveh14=b.nroveh14 and nroors32=@NROORS and a.nroveh14=@nrocar
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

/** Insert  Servicios Manuales**/

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null and b.nroors32=@NROORS



GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Veh]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  
IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC and  
a.nrofac37 is null
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Veh_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Veh_LC]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE  char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHLC')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC and  
a.nrofac37 is null
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Vig]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_GenEntXVolante    Script Date: 08-09-2002 08:50:09 PM ******/
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Vig]
@NROSEC char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11),
@HORASCONEX int

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  


begin
select @idReg =max(id)+1 from st_tr_documento

insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


update #Tempo01 set XFECDESCO=b.fectra67
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
a.navvia11=d.xnavvia11 and
a.codcon04=d.XCODCON63 and
c.tiptra68='D' and nrosec23=@NROSEC 

update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)



/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordret41 where nroord41=@NROSEC
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,31,1)  
select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordret41 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 

where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroord41=@NROSEC 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,33,'SI')

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL



--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
--	  insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

if @PREPAI="1" 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")		

if @COLLEC="1"
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")		
end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordret41 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetord43 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.nroord41=f.nroord41 and
b.codcon63=f.codcon63 and
b.navvia11=c.navvia11 and
b.codcon04=c.codcon04 and
c.codarm10=d.codarm10 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
c.codbol03='FC' and 
d.flgnep10 ='0' and
a.nroord41 =@NROSEC 
group by rucesp12

if @OL>0 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end

if @SUCUR= 14 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)		
end 


select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddordret41 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and
b.nroord41 =@NROSEC
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)		


/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.codcon63  from drblcont15 a (nolock), ddordret41 b (nolock), dddetord43 c (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
b.nroord41=c.nroord41 and
a.codcon63=c.codcon63 and
b.nroord41=@NROSEC

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)		
		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs


/** Insert Caracteristics Table Details Horas en conexion **/  
BEGIN  
DECLARE CursorDetailsCtrsRF CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCtrsRF  
  
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)    
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR  
 end   
  
CLOSE CursorDetailsCtrsRF  
DEALLOCATE  CursorDetailsCtrsRF  


/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

----Inserto el Concepto Reemisión
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, 51,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle  (nolock)
where 
id=@idReg 


insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Vig_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_GenEntXVolante    Script Date: 08-09-2002 08:50:09 PM ******/
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Vig_CS]
@NROSEC char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11)

begin
select @idReg =max(id)+1 from st_tr_documento 

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordret41 where nroord41=@NROSEC
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordret41 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 

where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroord41=@NROSEC 

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,33,'SI')

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL


--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
--	  insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
	 update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordret41 a (nolock) , ddcargas16 b (nolock) , ddcartar22 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetord43 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.nroord41=f.nroord41 and
b.nrocar16=c.nrocar16 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
e.codarm10=d.codarm10 and
c.nrocar16=f.nrocar16 and
c.nrosec22=f.nrosec22 and
d.flgnep10 ='0' and
a.nroord41 =@NROSEC 
group by rucesp12

if @OL>0 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end

if @SUCUR= 14 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)		
end 


select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddordret41 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and
b.nroord41 =@NROSEC
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)		


/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from ddcartar22 a (nolock), ddordret41 b (nolock), dddetord43 c (nolock) 
where 
b.nroord41=c.nroord41 and
a.nrosec22=c.nrosec22 and
a.nrocar16=c.nrocar16 and
b.nroord41=@NROSEC

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05='', @pesbrt63=pestar22, @codtam09='', @codbol03=bulalm22  from ddcartar22 (nolock) where  nrocar16+nrosec22=@NROCTR
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,19, '11500')			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'BUL')		

		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs

/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

----Inserto el Concepto Reemisión
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, 51,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle  (nolock)
where 
id=@idReg 


insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null

/*
SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg 

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
Values
('E', @idReg,  @ID_Item,  51,  @SUCUR , @CENCOS, 0 )
**/
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Cab_Vig_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Cab_Vig_Veh]
@NROSEC char(6),
@RUCCLI char(11),
@CODUSU char(20),
@CENCOS int,
@SUCUR int

as
declare 

@idReg int,
@CODAGE char(4), 
@EMBESP char(11), 
@CODSER char(3), 
@CODARM char(3),
@CODNAV char(4), 
@CODPUE char(3),
@CODCLI char(11), 
@CODCON char(11), 
@OL int, 
@CANBUL int,

@PREPAI char(1), 
@COLLEC char(1),
@IDCLIE char(11),
@FC int , 
@LC int, 
@CLILIN char(11),
@DIALIB int,
@DIAALM int,
@SUC char(1) ,
@NROCTR char(11) ,
@NAVVIA char(6), 

@codtip05 char(2), 
@pesbrt63 float, 
@codtam09 char(2), 
@codbol03 char(2),
@ID_Item char(11) 

begin
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values 
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR) 


/** Insert Table Entidad **/
select @suc=sucursal, @navvia=navvia11 from ddordret41 where nroord41=@NROSEC
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc

select 
@CODAGE=a.codage19, @CODARM=b.codarm10, 
@CODNAV=c.codnav08, @CODPUE=b.codpue02, 
@PREPAI=b.frepre12, @COLLEC=b.frecol12, 
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,
@EMBESP=b.embesp12, @CANBUL=b.canmer12
from 
ddordret41 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock) 

where 
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and 
b.navvia11=c.navvia11 and nroord41=@NROSEC 


insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)

select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV
if @CODSER is not null OR @CODSER <> NULL


insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')

insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,33,'SI')

if @IDCLIE is not null OR @IDCLIE <> NULL
begin
	select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)	
end

if @EMBESP is not null OR @EMBESP <> NULL
begin    
  	  select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP
 	  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)	
 	  update	st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0
end

if @CODCON IS NOT NULL OR @CODCON <> NULL
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)		

end

begin
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*) 
from ddordret41 a (nolock) , ddvehicu14 b (nolock)  , dqarmado10 d (nolock) , dddetall12 e (nolock), dddetord43 f (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.nroord41=f.nroord41 and
b.navvia11=e.navvia11 and 
b.nrodet12=e.nrodet12 and
e.codarm10=d.codarm10 and
b.nroveh14=f.nroveh14 and
d.flgnep10 ='0' and
a.nroord41 =@NROSEC 
group by e.rucesp12

if @OL>0 
--	insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                             
	insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)		
end


if @SUCUR= 7 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)		
end

if @SUCUR= 14 
begin
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)		
end 


select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddordret41 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and
b.nroord41 =@NROSEC
	insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)		


/** Insert Table Details **/

 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nroveh14  from ddvehicu14 a (nolock), ddordret41 b (nolock), dddetord43 c (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
b.nroord41=c.nroord41 and
b.nroord41=@NROSEC

/** Insert Caracteristics Table Details **/

BEGIN
DECLARE CursorDetailsCtrs CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCtrs

	FETCH next FROM CursorDetailsCtrs INTO @NROCTR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @codtip05='', @pesbrt63=pestar14, @codtam09='', @codbol03=1  from ddvehicu14 (nolock) where  nroveh14=@NROCTR
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)		
		FETCH next FROM CursorDetailsCtrs  INTO @NROCTR
	end 

CLOSE CursorDetailsCtrs
DEALLOCATE 	CursorDetailsCtrs

/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC



insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null


----Inserto el Concepto Reemisión
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'M', ID, ID_Item, 51,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle  (nolock)
where 
id=@idReg 

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and 
b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and 
b.nrofac37 is null and b.status32<> 'A'  and b.nrofac37 is null



/*
SELECT  @ID_Item=ID_Item   FROM st_tr_detalle where id=@idReg and ID_Item is not null

insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
Values
('E', @idReg,  @ID_Item,  51,  @SUCUR , @CENCOS, 0 )
*/
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Parcial_Cab]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Parcial_Cab]    
@NROSEC char(6),    
@RUCCLI char(11),    
@CODUSU char(20),    
@CENCOS int,    
@SUCUR int    
    
as    
declare     
    
@idReg int,    
@CODAGE char(4),     
@RUCAGE char(11),     
@EMBESP char(11),     
@CODSER char(3),     
@CODARM char(3),    
@CODNAV char(4),     
@CODPUE char(3),    
@CODCLI char(11),     
@CODCON char(11),     
@OL int,   
@SI int,  
@CANBUL int,    
    
@PREPAI char(1),     
@COLLEC char(1),    
@IDCLIE char(11),    
@FC int ,     
@LC int,     
@CLILIN char(11),    
@DIALIB int,    
@DIAALM int,    
@SUC char(1) ,    
@NROCTR char(11) ,    
@NAVVIA char(6),     
@CANCTR int,    
@HORASCONEX int,    
    
@codtip05 char(2),     
@pesbrt63 float,     
@codtam09 char(2),     
@codbol03 char(2),  
  
@iAmpDia int,  
@tipmon char(1) ,
@sPlanta char(4) 
  
create table #Tempo01      
(  
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XFECCONEX smalldatetime,  
XFECDESCO smalldatetime,  
XDIFHORAS int  
)    
    
begin    
  
/*  
update ddordser32 set nrosec23=b.nrosec23 from ddordser32 a, ddvoldes23 b, DRITVODE26 c       
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23=c.nrosec23 and a.nroitm13=c.nroitm13 and  
a.nrosec23 is null and  b.nrosec23=@NROSEC  
*/  
  
  
insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)  
select distinct a.navvia11, a.codcon04, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
  
  
update #Tempo01 set XFECDESCO=b.fectra67  
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
c.tiptra68='D' and nrosec23=@NROSEC   
  
update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)  
  
  
select @iAmpDia=case when sum(b.ampdia80)  is null then 0 else sum(b.ampdia80) end  from DDDESCUE79 a, DDDETDSC80 b, DDVOLDES23 c where   
a.navvia11=c.navvia11 and  
a.nrodet12=c.nrodet12  and  
a.nrodes79=b.nrodes79 and   
codcon35='DILIB' and c.nrosec23=@NROSEC   
  
  
select @idReg =max(id)+1 from st_tr_documento    
    
/** Insert Table Document **/    
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values     
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)     
    
    
/** Insert Table Entidad **/    
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC    
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc    
    
select     
@CODAGE=a.codage19, @CODARM=b.codarm10,     
@CODNAV=c.codnav08, @CODPUE=b.codpue02,     
@PREPAI=b.frepre12, @COLLEC=b.frecol12,     
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,    
@EMBESP=b.embesp12, @CANBUL=b.canmer12    
from     
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)      
where     
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and     
b.navvia11=c.navvia11 and nrosec23=@NROSEC     
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)    
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)    
    
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV    
if @CODSER is not null OR @CODSER <> NULL    
      
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')    
    
set @sPlanta=''    
select @sPlanta=cast(CODPLANTA as char(4) ) from terminal..SSI_ORDEN where CODPLANTA is not null and ORD_NUMDOCUMENTO= @NROSEC
and isnull(ord_flagEstado,'') <> 'A'  and substring(ORD_CODIGO,1,1)='I'   


insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,38,@sPlanta)    

  
if @IDCLIE is not null OR @IDCLIE <> NULL    
begin    
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)     
end    
    
if @EMBESP is not null OR @EMBESP <> NULL    
begin        
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP    
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)    
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)     
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0    
end    
    
if @CODCON IS NOT NULL OR @CODCON <> NULL    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)      
    
if @PREPAI='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')      
    
if @COLLEC='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                                 
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')      
end    
    
select @OL=count(*)     
from ddvoldes23 a (nolock) , dddetall12 b (nolock) ,  dqarmado10 c (nolock)     
where     
a.navvia11=b.navvia11 and    
a.nrodet12=b.nrodet12 and    
b.codarm10=c.codarm10 and    
c.flgnep10 ='0' and    
a.nrosec23 =@NROSEC    
  
if @OL>0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'SI')      
      
if @OL<=0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'NO')      
  
select @SI =count(ORD_CODIGO) from terminal..SSI_ORDEN where ORD_NUMDOCUMENTO = @NROSEC  
and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   

if @SI>0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'SI')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'SI')      
end

if @SI<=0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'NO')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'NO')      
end  
  
    
--if @SUCUR= 7     
--begin    
--select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'    
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)      
--end    
    
--if @SUCUR= 14     
--begin    
--select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'    
-- insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)      
--end     
    
    
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and    
b.nrosec23 =@NROSEC    
  
IF @DIALIB>=@DIAALM  
begin  
set @DIAALM=0  
end  
  
  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM-@iAmpDia)      
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIAALM-@iAmpDia)        
    
select @CANCTR=count(a.codcon63)  from drblcont15 a (nolock), IMP_FACTURA_SELECCION_MERCADERIA b (nolock)    
where a.nrosec23=b.nrosec23 and a.codcon63=b.codcon63 and a.nrosec23=@NROSEC   and   
a.codcon63 is not null and a.nrotkt28 is null  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)    
    
    
    
/** Insert Table Details **/    
    
-- insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC   and codcon63 is not null  
  
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.codcon63  from drblcont15 a (nolock), IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  where a.nrosec23=b.nrosec23 and a.codcon63=b.codcon63 and a.nrosec23=@NROSEC   and a.codcon63 is not 
null  
    
/** Insert Caracteristics Table Details **/    
    
BEGIN    
DECLARE CursorDetailsCtrs CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrs    
    
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)       
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)      
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)      
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrs    
DEALLOCATE  CursorDetailsCtrs    
  
/** Insert Caracteristics Table Details Horas en conexion **/    
  
  
BEGIN    
DECLARE CursorDetailsCtrsRF CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrsRF    
    
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,32, @HORASCONEX)      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,28, 'SI')      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,27,  @DIAALM)      
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrsRF    
DEALLOCATE  CursorDetailsCtrsRF    
  
  
    
/** Insert  Servicios Manuales**/    
    
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC    

select @tipmon=Tip_mone from St_T_Clientes_Moneda where contribuy= @RUCCLI     
    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
    
SELECT 'M', ID, ID_Item, case when @tipmon = 'S' then  codsbd03 else codsbd03_D end,

@SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.nrosec23=@NROSEC  and  
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'  and b.nrofac37 is null    
    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, case when @tipmon = 'S' then  codsbd03 else codsbd03_D end,  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null    
    
    
/** Insert  Servicios Manuales**/    
insert into St_TR_Descuentos_Manuales    
(ID, db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, case when @tipmon = 'S' then  c.codsbd03 else c.codsbd03_D end, b.tipdsc80, b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)    
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
c.sucursal=@SUC and    
a.nrofac37 is null  
  
/*  
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, c.codsbd03, 'P', b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock), IMP_FACTURA_SELECCION_MERCADERIA  d  (nolock)  
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
a.nrosec23=d.nrosec23 and  
c.sucursal=@SUC and    
a.nrofac37 is null  
*/  
  
drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Parcial_Cab_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Parcial_Cab_CS]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			


		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Parcial_Cab_CS_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Parcial_Cab_CS_LC]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE  char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Parcial_Cab_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Parcial_Cab_Veh]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@SFECHA char(8)  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nroveh14  from   DDVEHICU14  a (nolock),  IMP_FACTURA_SELECCION_MERCADERIA b (nolock) 
where 
a.nrosec23=b.nrosec23 and
a.nroveh14=b.nroveh14 and
a.nrosec23=@NROSEC  and
b.codusu00=@codusu
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC

GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Parcial_Cab_Veh_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Parcial_Cab_Veh_LC]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHLC')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nroveh14  from   DDVEHICU14  a (nolock),  IMP_FACTURA_SELECCION_MERCADERIA b (nolock) 
where 
a.nrosec23=b.nrosec23 and
a.nroveh14=b.nroveh14 and
a.nrosec23=@NROSEC  and
b.codusu00=@codusu

  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)


create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


update #Tempo01 set XFECDESCO=b.fectra67
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
a.navvia11=d.xnavvia11 and
a.codcon04=d.XCODCON63 and
c.tiptra68='D' and nrosec23=@NROSEC 

update #Tempo01 set XFECDESCO=getdate()

update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)


begin tran
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
commit
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  


  
  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,31,1)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  

 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*)   
from ddvoldes23 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
b.navvia11=c.navvia11 and  
b.codcon04=c.codcon04 and  
c.codarm10=d.codarm10 and  
b.navvia11=e.navvia11 and   
b.nrodet12=e.nrodet12 and  
c.codbol03='FC' and   
d.flgnep10 ='0' and  
a.nrosec23 =@NROSEC  
group by rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  


if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIAALM)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIAALM)    
end   


IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCtrs CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCtrs  
  
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')    
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)    
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR  
 end   
  
CLOSE CursorDetailsCtrs  
DEALLOCATE  CursorDetailsCtrs  

/** Insert Caracteristics Table Details Horas en conexion **/  


BEGIN  
DECLARE CursorDetailsCtrsRF CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCtrsRF  
  
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,27,  @DIAALM)    

  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR  
 end   
  
CLOSE CursorDetailsCtrsRF  
DEALLOCATE  CursorDetailsCtrsRF  


  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
--d.sucursal=@SUC and  
b.nrosec23=@NROSEC  and
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and 
b.navvia11=@navvia and  
--d.sucursal=@SUC and  
b.nrosec23=@NROSEC  and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   DDCARTAR22 (nolock) where nrosec23=@NROSEC 
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=pestar22, @codtam09=bulalm22  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_LC]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   DDCARTAR22 (nolock) where nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

	
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_LC_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_LC_N]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy  char(8)
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
 --   insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,@FecProy,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   DDCARTAR22 (nolock) where nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar

		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			
		
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01

select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_CS_N]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy char(8)  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI="1"   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"P")    
  
if @COLLEC="1"  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,"C")    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,@FecProy,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nrocar16+nrosec22  from   DDCARTAR22 (nolock) where nrosec23=@NROSEC 
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=pestar22, @codtam09=bulalm22  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar

		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			

		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01

select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_N]    
@NROSEC char(6),    
@RUCCLI char(11),    
@CODUSU char(20),    
@CENCOS int,    
@SUCUR int,  
@FecProy char(8)    
    
as    
declare     
    
@idReg int,    
@CODAGE char(4),     
@RUCAGE char(11),     
@EMBESP char(11),     
@CODSER char(3),     
@CODARM char(3),    
@CODNAV char(4),     
@CODPUE char(3),    
@CODCLI char(11),     
@CODCON char(11),     
@OL int,     
@SI int,
@CODPLA int,
@CANBUL int,    
    
@PREPAI char(1),     
@COLLEC char(1),    
@IDCLIE char(11),    
@FC int ,     
@LC int,     
@CLILIN char(11),    
@DIALIB int,    
@DIAALM int,    
@SUC char(1) ,    
@NROCTR char(11) ,    
@NAVVIA char(6),     
@CANCTR int,    
@HORASCONEX int,    
    
@codtip05 char(2),     
@pesbrt63 float,     
@codtam09 char(2),     
@codbol03 char(2),  
@iAmpDia int,  
@tipmon char(1),
@sPlanta char(4)  
create table #Tempo01      
(  
XNAVVIA11 varchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XCODCON63 varchar(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XFECCONEX datetime,  
XFECDESCO datetime,  
XDIFHORAS int  
)    
    
begin    
update ddordser32 set nrosec23=b.nrosec23 from ddordser32 a, ddvoldes23 b, DRITVODE26 c       
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23=c.nrosec23 and a.nroitm13=c.nroitm13 and  
a.nrosec23 is null and  b.nrosec23=@NROSEC  
  
  
/*  
insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)  
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
*/  
  
  
insert  into #Tempo01 (XNAVVIA11, XFECCONEX,  XCODCON63)  
select distinct a.navvia11, b.fectra67, a.codcon04 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
  
  
update #Tempo01 set XFECDESCO=b.fectra67  
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
c.tiptra68='D' and nrosec23=@NROSEC   
  
update #Tempo01 set XFECDESCO=getdate()  
from drblcont15 a, #Tempo01 d  
where   
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
XFECDESCO is null and  
a.nrosec23=@NROSEC   
  
update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)  
  
  
select @iAmpDia=case when sum(b.ampdia80)  is null then 0 else sum(b.ampdia80) end  from DDDESCUE79 a, DDDETDSC80 b, DDVOLDES23 c where   
a.navvia11=c.navvia11 and  
a.nrodet12=c.nrodet12  and  
a.nrodes79=b.nrodes79 and   
codcon35='DILIB' and c.nrosec23=@NROSEC   
  
begin tran
select @idReg =max(id)+1 from st_tr_documento    
    
/** Insert Table Document **/    
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values     
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)     
    
commit
    
/** Insert Table Entidad **/    
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC    
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc    
    
select     
@CODAGE=a.codage19, @CODARM=b.codarm10,     
@CODNAV=c.codnav08, @CODPUE=b.codpue02,     
@PREPAI=b.frepre12, @COLLEC=b.frecol12,     
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,    
@EMBESP=b.embesp12, @CANBUL=b.canmer12    
from     
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)      
where     
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and     
b.navvia11=c.navvia11 and nrosec23=@NROSEC     
    
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)    
    
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV    
if @CODSER is not null OR @CODSER <> NULL    
      
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')    

  
if @IDCLIE is not null OR @IDCLIE <> NULL    
begin    
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)     
end    
    
if @EMBESP is not null OR @EMBESP <> NULL    
begin        
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP    
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)    
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)     
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0    
end    
    
if @CODCON IS NOT NULL OR @CODCON <> NULL    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)      
    
if @PREPAI='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')      
    
if @COLLEC='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                                 
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')      
end    
      
set @OL=0  
  
select @OL=count(*)     
from ddvoldes23 a (nolock) , dddetall12 b (nolock) ,  dqarmado10 c (nolock)     
where     
a.navvia11=b.navvia11 and    
a.nrodet12=b.nrodet12 and    
b.codarm10=c.codarm10 and    
c.flgnep10 ='0' and    
a.nrosec23 =@NROSEC    
  
if @OL>0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'SI')      
      
if @OL<=0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'NO')      

select @SI =count(ORD_CODIGO) from terminal..SSI_ORDEN where ORD_NUMDOCUMENTO = @NROSEC  and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   
if @SI>0   
begin     
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'SI')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'SI')      
end
if @SI<=0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'NO')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'NO')      
end

set @sPlanta=''    
select @sPlanta=cast(CODPLANTA as char(4) ) from terminal..SSI_ORDEN where CODPLANTA is not null and ORD_NUMDOCUMENTO= @NROSEC
and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,38,@sPlanta)      

    
select @DIAALM=datediff(day,fecalm12,@fecproy)+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and    
b.nrosec23 =@NROSEC    
    
  
IF @DIALIB>=@DIAALM  
begin  
set @DIAALM=0  
end  

  
  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM-@iAmpDia)      
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIAALM-@iAmpDia)        
    
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)    
    
    
    
/** Insert Table Details **/    
    
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  and codcon63 is not null  
    
/** Insert Caracteristics Table Details **/    
    
BEGIN    
DECLARE CursorDetailsCtrs CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrs    
    
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)       
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)      
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)      
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrs    
DEALLOCATE  CursorDetailsCtrs    
  
/** Insert Caracteristics Table Details Horas en conexion **/    
    
BEGIN    
DECLARE CursorDetailsCtrsRF CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrsRF    
    
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR    
   
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,32, @HORASCONEX)      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,28, 'SI')      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,27,  @DIAALM)      
  
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrsRF    
DEALLOCATE  CursorDetailsCtrsRF    
  
  
    
/** Insert  Servicios Manuales**/    
    
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC    
  
select @tipmon=Tip_mone from St_T_Clientes_Moneda where contribuy= @RUCCLI     

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv, Cod_Orde )      
SELECT 'M', ID, ID_Item, case when @tipmon = 'S' then  codsbd03 else codsbd03_D end,  @SUCUR,  @CENCOS, 0, b.nroors32    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
--b.nrosec23=@NROSEC  and  
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'    
    
if   @tipmon='S'  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.nrosec23=@NROSEC  and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'    
  
if   @tipmon='D'    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, '177',  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null    
    
    
/** Insert  Servicios Manuales**/    
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, case when @tipmon = 'S' then  c.codsbd03 else c.codsbd03_D end , b.tipdsc80, b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)    
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
c.sucursal=@SUC   
--and    
--a.nrofac37 is null  
  
  
/*  
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, c.codsbd03, 'P', b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock), DRBLCONT15 d  (nolock)  
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.sucursal=@SUC   
*/  
  
drop table #Tempo01  
select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_LC]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHLC')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_LC_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_LC_N]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy char(8)  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE  char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHLC')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,@fecproy,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC

select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Cab_Veh_N]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy char(8)  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,@FecProy,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, nroveh14  from   DDVEHICU14  (nolock) where nrosec23=@NROSEC  
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC

select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab]   
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)


create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


update #Tempo01 set XFECDESCO=b.fectra67
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
a.navvia11=d.xnavvia11 and
a.codcon04=d.XCODCON63 and
c.tiptra68='D' and nrosec23=@NROSEC 

update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,31,1)  

--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*)   
from ddvoldes23 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
b.navvia11=c.navvia11 and  
b.codcon04=c.codcon04 and  
c.codarm10=d.codarm10 and  
b.navvia11=e.navvia11 and   
b.nrodet12=e.nrodet12 and  
c.codbol03='FC' and   
d.flgnep10 ='0' and  
a.nrosec23 =@NROSEC  
group by rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.codcon63  from drblcont15 a (nolock), IMP_FACTURA_SELECCION_MERCADERIA b (nolock) 
where 
a.nrosec23=b.nrosec23 and
a.codcon63=b.codcon63 and
a.nrosec23=@NROSEC  and
b.codusu00=@CODUSU
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCtrs CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCtrs  
  
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')    
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)    
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR  
 end   
  
CLOSE CursorDetailsCtrs  
DEALLOCATE  CursorDetailsCtrs  

/** Insert Caracteristics Table Details Horas en conexion **/  


BEGIN  
DECLARE CursorDetailsCtrsRF CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCtrsRF  
  
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,28, 'SI')    
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR  
 end   
  
CLOSE CursorDetailsCtrsRF  
DEALLOCATE  CursorDetailsCtrsRF  


  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, '', b.pordsc80 
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			
	
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  


/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_LC]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  


select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			
	
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_LC_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_LC_N]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy char(8)    
  
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERLC')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  


select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			
	
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_CS_N]
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int , 
@FecProy char(8)    
as  
declare   
  
@idReg int,  
@CODAGE char(4),   
@RUCAGE char(11),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCTR char(11) ,  
@NAVVIA char(6),   
@CANCTR int,  
@HORASCONEX int,  
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2),

@NROCAR char(8)

create table #Tempo01    
(
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XCODCON63 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
XFECCONEX smalldatetime,
XFECDESCO smalldatetime,
XDIFHORAS int
)  
  
begin  


insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c
where 
a.navvia11=b.navvia11 and
a.codcon04=c.codcon04 and
b.nrotra67=c.nrotra67 and
c.tiptra68='C' and nrosec23=@NROSEC 


select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   

select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)  
  
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'MERCS')  
  


if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP  
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)   
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0  
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
if @PREPAI='1'   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')    
  
if @COLLEC='1'  

-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')    
end  
  
begin  

select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*) from ddvoldes23 a (nolock) , ddcargas16 b (nolock) , dqarmado10 c (nolock) , dddetall12 d (nolock) 
where 
a.navvia11=b.navvia11 and
a.nrodet12=b.nrodet12 and
a.codarm10=c.codarm10 and
a.navvia11=d.navvia11 and
a.nrodet12=d.nrodet12 and
c.flgnep10 ='0' and
b.codcon04 is null and
a.nrosec23 =@NROSEC
group by rucesp12

  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
  
  
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)  
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nrocar16+a.nrosec22  from   DDCARTAR22 a (nolock) , IMP_FACTURA_SELECCION_MERCADERIA b (nolock)  
where 
a.nrocar16=b.nrocar16 and
a.nrosec22=b.nrosec22 and
b.codusu00=@CODUSU and
a.nrosec23=@NROSEC
  
/** Insert Caracteristics Table Details **/  
  
BEGIN
DECLARE CursorDetailsCS CURSOR FOR 
SELECT id_item FROM st_tr_detalle WHERE id=@idReg
END

OPEN CursorDetailsCS

	FETCH next FROM CursorDetailsCS INTO @NROCAR
	WHILE @@FETCH_STATUS <> -1
	begin
		select @pesbrt63=SUM(pestar22), @codtam09=sum(bulalm22)  from ddcartar22 (nolock) where nrosec23=@NROSEC and nrocar16+nrosec22=@nrocar
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)		
		--insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,16, @pesbrt63)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtip05)			
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,3, @codtam09)		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,4, @codbol03)	
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'BUL')		
		insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,19, '11500')			
	
		FETCH next FROM CursorDetailsCS  INTO @NROCAR
	end 

CLOSE CursorDetailsCS
DEALLOCATE 	CursorDetailsCS

  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )

SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a (nolock)  , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock) 
where 
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nrocar16 and
b.codcon35=d.codcon14 and
b.nroors32=c.nroors32 and
a.id=@idReg and b.navvia11=@navvia and
d.sucursal=@SUC and
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  


/** Insert  Servicios Manuales**/
insert into St_TR_Descuentos_Manuales

(ID,          db_servicio, Tip_Desc,  Val_Desc )
SELECT  
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80
FROM 
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)
where 
a.nrodes79=b.nrodes79 and
b.codcon35=c.codcon14 and
a.nrosec23=@nrosec and
c.sucursal=@SUC 
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC 

drop table #Tempo01
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_N]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_N]  
@NROSEC char(6),    
@RUCCLI char(11),    
@CODUSU char(20),    
@CENCOS int,    
@SUCUR int,  
@FecProy char(8)    
    
as    
declare     
    
@idReg int,    
@CODAGE char(4),     
@RUCAGE char(11),     
@EMBESP char(11),     
@CODSER char(3),     
@CODARM char(3),    
@CODNAV char(4),     
@CODPUE char(3),    
@CODCLI char(11),     
@CODCON char(11),     
@OL int,     
@SI int,
@CODPLA int,
@CANBUL int,    
    
@PREPAI char(1),     
@COLLEC char(1),    
@IDCLIE char(11),    
@FC int ,     
@LC int,     
@CLILIN char(11),    
@DIALIB int,    
@DIAALM int,    
@SUC char(1) ,    
@NROCTR char(11) ,    
@NAVVIA char(6),     
@CANCTR int,    
@HORASCONEX int,    
    
@codtip05 char(2),     
@pesbrt63 float,     
@codtam09 char(2),     
@codbol03 char(2),  
@iAmpDia int,  
@tipmon char(1) ,
@sPlanta char(4) 
create table #Tempo01      
(  
XNAVVIA11 varchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XCODCON63 varchar(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
XFECCONEX datetime,  
XFECDESCO datetime,  
XDIFHORAS int  
)    
    
begin    
update ddordser32 set nrosec23=b.nrosec23 from ddordser32 a, ddvoldes23 b, DRITVODE26 c       
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23=c.nrosec23 and a.nroitm13=c.nroitm13 and  
a.nrosec23 is null and  b.nrosec23=@NROSEC  
  
  
/*  
insert  into #Tempo01 (XNAVVIA11,  XCODCON63,  XFECCONEX)  
select distinct a.codcon04, a.navvia11, b.fectra67 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
*/  
  
  
insert  into #Tempo01 (XNAVVIA11, XFECCONEX,  XCODCON63)  
select distinct a.navvia11, b.fectra67, a.codcon04 from drblcont15 a, ddordtra67 b, dddettra68 c  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
c.tiptra68='C' and nrosec23=@NROSEC   
  
  
update #Tempo01 set XFECDESCO=b.fectra67  
from drblcont15 a, ddordtra67 b, dddettra68 c, #Tempo01 d  
where   
a.navvia11=b.navvia11 and  
a.codcon04=c.codcon04 and  
b.nrotra67=c.nrotra67 and  
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
c.tiptra68='D' and nrosec23=@NROSEC   
  
update #Tempo01 set XFECDESCO=getdate()  
from drblcont15 a, #Tempo01 d  
where   
a.navvia11=d.xnavvia11 and  
a.codcon04=d.XCODCON63 and  
XFECDESCO is null and  
a.nrosec23=@NROSEC   
  
update #Tempo01 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO)  
  
  
select @iAmpDia=case when sum(b.ampdia80)  is null then 0 else sum(b.ampdia80) end  from DDDESCUE79 a, DDDETDSC80 b, DDVOLDES23 c where   
a.navvia11=c.navvia11 and  
a.nrodet12=c.nrodet12  and  
a.nrodes79=b.nrodes79 and   
codcon35='DILIB' and c.nrosec23=@NROSEC   

begin tran
select @idReg =max(id)+1 from st_tr_documento    
    
/** Insert Table Document **/    
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values     
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)     
    
commit
    
/** Insert Table Entidad **/    
select @suc=sucursal, @navvia=navvia11 from ddvoldes23 where nrosec23=@NROSEC    
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc    
    
select     
@CODAGE=a.codage19, @CODARM=b.codarm10,     
@CODNAV=c.codnav08, @CODPUE=b.codpue02,     
@PREPAI=b.frepre12, @COLLEC=b.frecol12,     
@CODCON=b.ruccli12, @IDCLIE=@RUCCLI,    
@EMBESP=b.embesp12, @CANBUL=b.canmer12    
from     
ddvoldes23 a (nolock) , dddetall12 b (nolock) , ddcabman11  c (nolock)      
where     
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and     
b.navvia11=c.navvia11 and nrosec23=@NROSEC     
    
select @RUCAGE=contribuy from aaclientesaa where cliente=@CODAGE  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,1,@RUCAGE)    
    
select @CODSER=codser30 from drnavser31 (nolock) where codnav08=@CODNAV    
if @CODSER is not null OR @CODSER <> NULL    
      
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)    
    
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'CTRFC')    
    
select @sPlanta=cast(CODPLANTA as char(4) ) from terminal..SSI_ORDEN where CODPLANTA is not null and ORD_NUMDOCUMENTO= @NROSEC and
isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   

insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,38,@sPlanta)    
  
  
if @IDCLIE is not null OR @IDCLIE <> NULL    
begin    
 select @CODCLI=contribuy from AACLIENTESAA (nolock) where contribuy=@IDCLIE    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)     
end    
    
if @EMBESP is not null OR @EMBESP <> NULL    
begin        
     select @CODCLI=contribuy from AACLIENTESAA (nolock)  where contribuy=@EMBESP    
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)    
--    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)     
--  update st_tr_entidades set  Val_enti=null where Cod_Enti=17 and Val_enti=0    
end    
    
if @CODCON IS NOT NULL OR @CODCON <> NULL    
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)      
    
if @PREPAI='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","P")    
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'P')      
    
if @COLLEC='1'     
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"16","C")                                 
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,13,'C')      
end    
    
--begin    
/*  
select @CliLin= case when e.rucesp12  is null then '0' else e.rucesp12 end , @OL=count(*)     
from ddvoldes23 a (nolock) , drblcont15 b (nolock) , ddcontar63 c (nolock) , dqarmado10 d (nolock) , dddetall12 e (nolock)     
where     
a.navvia11=b.navvia11 and    
a.nrodet12=b.nrodet12 and    
b.navvia11=c.navvia11 and    
b.codcon04=c.codcon04 and    
c.codarm10=d.codarm10 and    
b.navvia11=e.navvia11 and     
b.nrodet12=e.nrodet12 and    
c.codbol03='FC' and     
d.flgnep10 ='0' and    
a.nrosec23 =@NROSEC    
group by rucesp12    
*/    
--if @OL>0     
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)      
  
--if @OL>0     
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'SI')      
      
--if @OL<=0     
-- insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'NO')      
  
set @OL=0  
  
select @OL=count(*)     
from ddvoldes23 a (nolock) , dddetall12 b (nolock) ,  dqarmado10 c (nolock)     
where     
a.navvia11=b.navvia11 and    
a.nrodet12=b.nrodet12 and    
b.codarm10=c.codarm10 and    
c.flgnep10 ='0' and    
a.nrosec23 =@NROSEC    
  
if @OL>0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'SI')      
      
if @OL<=0     
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,'NO')      

select @SI =count(ORD_CODIGO) from terminal..SSI_ORDEN where ORD_NUMDOCUMENTO = @NROSEC  and isnull(ord_flagEstado,'') <> 'A' and substring(ORD_CODIGO,1,1)='I'   
if @SI>0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'SI')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'SI')      
end

if @SI<=0        
begin
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,37,'NO')      
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,39,'NO')      
end

  
--end    
    
/*    
if @SUCUR= 7     
begin    
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='3' and codreg56='10'    
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)      
end    
    
if @SUCUR= 14     
begin    
select @DIALIB=dialib56 from DQREGIME56 (nolock)  where sucursal='5' and codreg56='10'    
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)      
end     
*/    
  
select @DIAALM=datediff(day,fecalm12,@fecproy)+1 from dddetall12 a (nolock) , ddvoldes23 b (nolock)  where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and    
b.nrosec23 =@NROSEC    
    
  
IF @DIALIB>=@DIAALM  
begin  
set @DIAALM=0  
end  
  
  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM-@iAmpDia)      
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIAALM-@iAmpDia)        
    
select @CANCTR=count(codcon63) from drblcont15 where nrosec23=@nrosec    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,19,@canctr)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti) values (@idReg,30,@canctr)    
    
    
    
/** Insert Table Details **/    
    
 insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.codcon63  from drblcont15 a 
inner join IMP_FACTURA_SELECCION_MERCADERIA b on (a.nrosec23=b.nrosec23 and a.codcon63=b.codcon63)
where a.nrosec23=@NROSEC  and a.codcon63 is not null  
    
/** Insert Caracteristics Table Details **/    
    
BEGIN    
DECLARE CursorDetailsCtrs CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrs    
    
 FETCH next FROM CursorDetailsCtrs INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @codtip05=codtip05, @pesbrt63=pesbrt63, @codtam09=codtam09, @codbol03=codbol03  from ddcontar63 (nolock) where navvia11=@navvia and codcon63=@NROCTR    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesbrt63)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)       
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,24, 'FC')      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31,1)      
--  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @diaalm)      
  FETCH next FROM CursorDetailsCtrs  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrs    
DEALLOCATE  CursorDetailsCtrs    
  
/** Insert Caracteristics Table Details Horas en conexion **/    
  
  
BEGIN    
DECLARE CursorDetailsCtrsRF CURSOR FOR     
SELECT id_item FROM st_tr_detalle WHERE id=@idReg    
END    
    
OPEN CursorDetailsCtrsRF    
    
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR    
 WHILE @@FETCH_STATUS <> -1    
 begin    
  select @HORASCONEX= XDIFHORAS from #Tempo01 (nolock) where xnavvia11=@navvia and xcodcon63=@NROCTR    
   
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,25, @HORASCONEX)      
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,32, @HORASCONEX)      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,28, 'SI')      
 if @HORASCONEX>0  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,27,  @DIAALM)      
  
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR    
 end     
    
CLOSE CursorDetailsCtrsRF    
DEALLOCATE  CursorDetailsCtrsRF    
  
  
    
/** Insert  Servicios Manuales**/    
    
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC    
  
select @tipmon=Tip_mone from St_T_Clientes_Moneda where contribuy= @RUCCLI     

insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )      
SELECT 'M', ID, ID_Item, case when @tipmon = 'S' then  codsbd03 else codsbd03_D end,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.nrosec23=@NROSEC  and  
b.codcon35 not in ('SERES','SEREO','SERE0')  and b.status32<> 'A'    
    
if   @tipmon='S'  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.nrosec23=@NROSEC  and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'    
  
if   @tipmon='D'    
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )    
SELECT  'E', ID, ID_Item, '177',  @SUCUR,  @CENCOS, valcal33   FROM st_tr_detalle a (nolock) , ddordser32 b (nolock) , dddetors33 c (nolock) , fqcontar14 d (nolock)     
where     
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.codcon63 and    
b.codcon35=d.codcon14 and    
b.nroors32=c.nroors32 and    
a.id=@idReg and b.navvia11=@navvia and    
d.sucursal=@SUC and    
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  and b.nrofac37 is null    
    
    
/** Insert  Servicios Manuales**/    
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, case when @tipmon = 'S' then  c.codsbd03 else c.codsbd03_D end , b.tipdsc80, b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)    
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
c.sucursal=@SUC   
--and    
--a.nrofac37 is null  
  
  
/*  
insert into St_TR_Descuentos_Manuales    
(ID,          db_servicio, Tip_Desc,  Val_Desc )    
SELECT      
@idReg, c.codsbd03, 'P', b.pordsc80*-1  
FROM     
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock), DRBLCONT15 d  (nolock)  
where     
a.nrodes79=b.nrodes79 and    
b.codcon35=c.codcon14 and    
a.nrosec23=@nrosec and    
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.sucursal=@SUC   
*/  
  
drop table #Tempo01  
select @IdReg
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_Veh]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_Veh]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHCS')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
  --  insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nroveh14  from   DDVEHICU14  a (nolock),  IMP_FACTURA_SELECCION_MERCADERIA b (nolock) 
where 
a.nrosec23=b.nrosec23 and
a.nroveh14=b.nroveh14 and
a.nrosec23=@NROSEC  and
b.codusu00=@codusu
  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_Veh_LC]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_GenEntidades_Valoriza_Parcial_Cab_Veh_LC]  
@NROSEC char(6),  
@RUCCLI char(11),  
@CODUSU char(20),  
@CENCOS int,  
@SUCUR int,
@FecProy char(8)  
as  
declare   
  
  
@idReg int,  
@CODAGE char(4),   
@EMBESP char(11),   
@CODSER char(3),   
@CODARM char(3),  
@CODNAV char(4),   
@CODPUE char(3),  
@CODCLI char(11),   
@CODCON char(11),   
@OL int,   
@CANBUL int,  
  
@PREPAI char(1),   
@COLLEC char(1),  
@IDCLIE char(11),  
@FC int ,   
@LC int,   
@CLILIN char(11),  
@DIALIB int,  
@DIAALM int,  
@SUC char(1) ,  
@NROCAR char(6) ,  
@NAVVIA char(6),   
  
@codtip05 char(2),   
@pesbrt63 float,   
@codtam09 char(2),   
@codbol03 char(2)  
  
begin  
select @idReg =max(id)+1 from st_tr_documento  
  
/** Insert Table Document **/  
insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) values   
(@idReg,  @NROSEC, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @SUCUR)   
  
  
/** Insert Table Entidad **/  
select @suc=sucursal, @navvia=navvia11 from ddvoldes23  (nolock)  where nrosec23=@NROSEC  
select @DIALIB=dialib56 from DQREGIME56 where codreg56='10' and sucursal=@suc  
  
select   
@CODAGE=a.codage19, @CODARM=b.codarm10,   
@CODNAV=c.codnav08, @CODPUE=b.codpue02,   
@PREPAI=b.frepre12, @COLLEC=b.frecol12,   
@CODCON=b.ruccli12, @IDCLIE=b.rucesp12,  
@EMBESP=b.embesp12, @CANBUL=b.canmer12  
from   
ddvoldes23 a  (nolock) , dddetall12 b  (nolock) , ddcabman11  c  (nolock)    
where   
a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and   
b.navvia11=c.navvia11 and nrosec23=@NROSEC   
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"01",@CODAGE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,1,@CODAGE)  
  
select @CODSER=codser30 from drnavser31  (nolock)  where codnav08=@CODNAV  
if @CODSER is not null OR @CODSER <> NULL  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"05",@CODSER)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,5,@CODSER)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"06",@CODARM)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,6,@CODARM)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"07",@CODNAV)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,7,@CODNAV)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"17",@CODPUE)  
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,14,@CODPUE)  
  
--insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"22",@CANBUL)    
insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,23,'VEHLC')  
  
if @IDCLIE is not null OR @IDCLIE <> NULL  
begin  
 select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@IDCLIE  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"14",@CODCLI)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,15,@CODCLI)   
end  
  
if @EMBESP is not null OR @EMBESP <> NULL  
begin      
     select @CODCLI=contribuy from AACLIENTESAA  (nolock) where contribuy=@EMBESP  
--   insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"20",@EMBESP)  
    insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,17,@EMBESP)    
end  
  
if @CODCON IS NOT NULL OR @CODCON <> NULL  
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"15",@CODCON)  
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,12,@CODCON)    
  
end  
  
begin  
select @CliLin= case when d.rucesp12  is null then '0' else d.rucesp12 end , @OL=count(*)   
from ddvoldes23 a  (nolock) , ddvehicu14 b  (nolock) ,   
dqarmado10 c  (nolock) , dddetall12 d  (nolock)   
where   
a.navvia11=b.navvia11 and  
a.nrodet12=b.nrodet12 and  
a.codarm10=c.codarm10 and  
a.navvia11=d.navvia11 and  
a.nrodet12=d.nrodet12 and  
c.flgnep10 ='0' and  
b.codcon04 is null and  
a.nrosec23 =@NROSEC  
group by d.rucesp12  
  
if @OL>0   
-- insert frentvol15 (nrosec23, tipent03 ,codent03) values (@NROSEC,"21", @CliLin)                               
 insert st_tr_entidades  (ID, Cod_Enti, Val_enti)  values (@idReg,18,@CliLin)    
end  
    
if @SUCUR= 7   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock)  where sucursal='3' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)  values (@idReg,21,@DIALIB)    
end  
  
if @SUCUR= 14   
begin  
select @DIALIB=dialib56 from DQREGIME56  (nolock) where sucursal='5' and codreg56='10'  
 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,21,@DIALIB)    
end   
  
  
select @DIAALM=datediff(day,fecalm12,getdate())+1 from dddetall12 a  (nolock) , ddvoldes23 b  (nolock) where a.navvia11=b.navvia11 and a.nrodet12=b.nrodet12 and  
b.nrosec23 =@NROSEC  

IF @DIALIB>=@DIAALM
begin
set @DIAALM=0
end

 insert st_tr_entidades   (ID, Cod_Enti, Val_enti)   values (@idReg,22,@DIAALM)    
  
  
  
/** Insert Table Details **/  
  
insert  into st_tr_detalle    (id, id_item) select distinct @idReg, a.nroveh14  from   DDVEHICU14  a (nolock),  IMP_FACTURA_SELECCION_MERCADERIA b (nolock) 
where 
a.nrosec23=b.nrosec23 and
a.nroveh14=b.nroveh14 and
a.nrosec23=@NROSEC  and
b.codusu00=@codusu

  
/** Insert Caracteristics Table Details **/  
  
BEGIN  
DECLARE CursorDetailsCS CURSOR FOR   
SELECT id_item FROM st_tr_detalle WHERE id=@idReg  
END  
  
OPEN CursorDetailsCS  
  
 FETCH next FROM CursorDetailsCS INTO @NROCAR  
 WHILE @@FETCH_STATUS <> -1  
 begin  
  select @pesbrt63=SUM(pestar14), @codtam09=count(nroveh14)  from ddvehicu14  (nolock) where nrosec23=@NROSEC and nroveh14=@nrocar  
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,1, @pesbrt63)    
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,2, @codtam09)     
  insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCAR,21, 'VEH')     
  FETCH next FROM CursorDetailsCS  INTO @NROCAR  
 end   
  
CLOSE CursorDetailsCS  
DEALLOCATE  CursorDetailsCS  
  
/** Insert  Servicios Manuales**/  
  
--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
  
SELECT 'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, 0    FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35 not in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
insert into St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )  
SELECT  'E', ID, ID_Item, codsbd03,  @SUCUR,  @CENCOS, valing32   FROM st_tr_detalle a  (nolock)  , ddordser32 b  (nolock) , dddetors33 c  (nolock) , fqcontar14 d  (nolock)   
where   
a.ID_Item COLLATE SQL_Latin1_General_CP1_CI_AS =c.nroveh14 and  
b.codcon35=d.codcon14 and  
b.nroors32=c.nroors32 and  
a.id=@idReg and b.navvia11=@navvia and  
d.sucursal=@SUC and  
b.codcon35  in ('SERES','SEREO','SERE0') and b.status32<> 'A'  
  
/** Insert  Servicios Manuales**/  
insert into St_TR_Descuentos_Manuales  
(ID,          db_servicio, Tip_Desc,  Val_Desc )  
SELECT    
@idReg, c.codsbd03, b.tipdsc80, b.totdsc80  
FROM   
DDDESCUE79 a (nolock) , DDDETDSC80 b (nolock) , fqcontar14 c (nolock)  
where   
a.nrodes79=b.nrodes79 and  
b.codcon35=c.codcon14 and  
a.nrosec23=@nrosec and  
c.sucursal=@SUC



GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Almac_Cobrados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Almac_Cobrados]
@navvia11 char(6),
@nrodet12 char(3)
  AS

select sum(import07) from ddfactur37 a, fddetfac07 b
where
a.nrofac37=b.nrofac37 and
b.codcon14='ALMAC' and
a.navvia11=@navvia11 and
a.nrodet12=@nrodet12 and
status37<>'A'
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_CodUltra]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_CodUltra]
@sCodSer char(5)
  AS

select distinct codsbd03 from fqcontar14 where codcon14=@sCodSer
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Horas_Libres]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Horas_Libres]
@sRuc char(11),
@sLin char(35)
 AS
select Contribuy, nombre , E_LINEA, rtrim(substring(C_HORAS_LIBRES,3,3)) from ST_V_Tarifario_Cubo where 
contribuy=@sRuc and E_LINEA like @sLin and
dc_servicio in (609,08) and dg_centro_costo='importacion' 
and C_HORAS_LIBRES is not null
union
select Contribuy, nombre , E_LINEA, rtrim(substring(C_HORAS_LIBRES,3,3)) from ST_V_Tarifario_Cubo where 
contribuy is null and E_LINEA like @sLin and 
dc_servicio in (609,08) and dg_centro_costo='importacion' 
and C_HORAS_LIBRES is not null
order by 4 desc
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Key]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Key]
@NRODOC char(6),
@USER varchar(25)
  AS

select ID from st_tr_documento where Cod_Docu = @NRODOC and Cod_Usua=@USER order by id desc
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Servicio_Almac]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Servicio_Almac]
@Key int

 AS
select sum(Val_Serv) from ST_TR_Servicios_Resp where id  = @Key
and Dc_Servicio=14 and Val_Serv>0
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Servicios]
@Key decimal,
@type char(1),
@id decimal

 AS
if @type<>'M' 
select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0 order by  Dc_Servicio
if @type='M' 
select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Dc_Servicio=@id and Val_Serv>0 order by Dc_Servicio
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Servicios_Group]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Servicios_Group]
@Key int,
@type char(1),
@id int
 AS
declare @Total decimal(9,2)

select @Total=sum(Val_Serv)  from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0 group by ID

if @type<>'M' 
	--select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0
	select Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv, sum(Val_Serv) as Val_serv ,sum(Val_Neto) as Val_neto, max(Apl_proc) as apl_proc, max(Apl_igv) as apl_igv, max(Apl_detr) as apl_detr, @Total as Total from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0 group by Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv 
if @type='M' 
	--select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Dc_Servicio=@id and Val_Serv>0
	select Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv, sum(Val_Serv) as Val_serv ,sum(Val_Neto) as Val_neto,max(Apl_proc) as apl_proc ,max(Apl_igv) as apl_igv, max(Apl_detr) as apl_detr, @Total as Total from ST_TR_Servicios_Resp where id  = @Key  and Dc_Servicio=@id and Val_Serv>0 group by Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Servicios_GroupTodos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Servicios_GroupTodos]
@Key int,  
@type char(1),  
@id int  
 AS  
declare @Total decimal(9,2)  

select @Total=sum(Val_Serv)  from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0 group by ID    
if @type<>'M'   
 --select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0  
 select Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv, sum(Val_Serv) as Val_serv ,sum(Val_Neto) as Val_neto, max(Apl_proc) as apl_proc, max(Apl_igv) as apl_igv, max(Apl_detr) as apl_detr, @Total as Total from ST_TR_Servicios_Resp 
where id  = @Key --and Val_Serv>0 
group by Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv   

if @type='M'   
 --select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue, Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto from ST_TR_Servicios_Resp where id  = @Key and Dc_Servicio=@id and Val_Serv>0  
 select Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv, sum(Val_Serv) as Val_serv ,sum(Val_Neto) as Val_neto,max(Apl_proc) as apl_proc ,max(Apl_igv) as apl_igv, max(Apl_detr) as apl_detr, @Total as Total from ST_TR_Servicios_Resp 
where id  = @Key  and Dc_Servicio=@id --and Val_Serv>0 
group by Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Des_Serv

GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_Servicios_Total]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_Servicios_Total]
@Key int,
@type char(1),
@id int

 AS
if @type<>'M' 
select sum(Val_Serv) from ST_TR_Servicios_Resp where id  = @Key 
if @type='M' 
select sum(Val_Serv)  from ST_TR_Servicios_Resp where id  = @Key and Dc_Servicio=@id
GO
/****** Object:  StoredProcedure [dbo].[sp_Impo_Get_ServiciosRes]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_Impo_Get_ServiciosRes]
@Key int,
@type char(1),
@id int

 AS
if @type<>'M' 
select ID,  Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo,  Apl_IGV, Apl_Detr, Apl_Proc, xx=sum(Val_Serv) from 
ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0
group by
 ID, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo,   Apl_IGV, Apl_Detr, Apl_Proc
order by  ID
if @type='M' 
select ID,  Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo,   Apl_IGV, Apl_Detr,  Apl_Proc, xx=sum(Val_Serv) 
from ST_TR_Servicios_Resp where id  = @Key and Dc_Servicio=@id and Val_Serv>0
group by
 ID, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo,   Apl_IGV, Apl_Detr, Apl_Proc
order by  ID
GO
/****** Object:  StoredProcedure [dbo].[sp_NTExpo_GenEntidades_xDua]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_NTExpo_GenEntidades_xDua]    
@ORDEMB varchar(13),          
@RUCCLI char(11),          
@CODUSU varchar(20),          
@CENCOS int,          
@SUCUR int          
          
as          
Declare           
          
@idReg int,          
@CODTIP char(2),          
@CODPRO char(5),          
@CODAGE char(11),           
@CODSER char(3),           
@CODARM char(3),          
@CODNAV char(4),           
@CODPUE char(3),          
@EMBARC char(11),           
@CONSOL char(11),           
@OTRLIN char(2),           
@CANBUL int,          
@CANCTR int,           
@IDCLIE char(11),          
@FC int,           
@LC int,           
@DIALIB int,          
@CODREG char(2),          
@SUC char(1),          
@NROCTR char(11),          
@NAVVIA char(6),           
@codtip05 char(2),           
@pesmer16 float,           
@codtam09 char(2),           
@codbol03 char(2),          
@TipLln16 varchar(35),      
@HORASCONEX int,    
@DIASCONEX int,  
@tipmon char(1)  
      
--Creo Tabla Temporal para Reefers      
create table #Tempo1          
(      
XNAVVIA11 char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,      
XCODCON04 char(11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,      
XFECCONEX smalldatetime,      
XFECDESCO smalldatetime,      
 --Para el Consumo Energia Electrica    
XDIFHORAS int,     
--Para el Monitoreo Reefers    
XDIFDIAS int       
)        
    
          
Begin          
      
select @idReg =max(id)+1 from tarifario.dbo.st_tr_documento          
          
/** Insert Table Entidad **/          
Select distinct          
@NAVVIA=b.navvia11, @CODPRO=b.codpro27, @EMBARC=c.codemc12, @CODARM=d.codarm10, @CODAGE=a.codage19,                
@CODPUE=d.codpue02, @CONSOL=d.ruccli13, @CODNAV=e.codnav08, @SUC=a.sucursal,          
@CANCTR=count(b.codcon04), @CANBUL=sum(b.nrobul16), @CODREG=SUBSTRING(a.notemb16,6,2)              
from           
descarga.dbo.erlleord53 a ,           
descarga.dbo.edllenad16 b ,           
descarga.dbo.edauting14 c ,                 
descarga.dbo.edbookin13 d ,          
descarga.dbo.ddcabman11 e          
where a.nroaut14=b.nroaut14            
and a.nroitm16=b.nroitm16            
and b.nroaut14=c.nroaut14            
and b.genbkg13=d.genbkg13            
and d.navvia11=e.navvia11            
and a.notemb16=@ORDEMB                
and a.codage19=@RUCCLI          
GROUP BY                 
b.navvia11, b.codpro27, c.codemc12, d.codarm10, d.codpue02, d.ruccli13, e.codnav08,          
d.codtip05, d.codarm10, a.notemb16, a.sucursal, a.codage19          
          
          
/** Insert Table Document **/          
Insert tarifario.dbo.st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal)       
values (@idReg,  @ORDEMB, 1, @CODUSU, getdate(), @EMBARC, @CENCOS, @SUCUR)           
      
/** Insert Table Entidades **/             
Insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,1,@CODAGE)          
select @CODSER=codser30 from descarga.dbo.drnavser31 where codnav08=@CODNAV          
          
-- Identificamos si la linea es de neptunia o no          
select @OTRLIN=case when flgfac10='S' THEN 'NO' else 'SI' end from descarga.dbo.dqarmado10 where codarm10=@CODARM          
Insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,4,@EMBARC)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,7,@CODNAV)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,6,@CODARM)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,9,@CODPRO)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,14,@CODPUE)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,18,@OTRLIN)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,19,@CANCTR)          
--insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,30,@CANCTR)          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,29,@CODREG)          
          
if @CODSER is not null OR @CODSER <> NULL          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,5,@CODSER)          
if @CONSOL is not null OR @CONSOL <> NULL          
insert tarifario.dbo.st_tr_entidades (ID, Cod_Enti, Val_Enti) values (@idReg,15,@CONSOL)          
          
      
-- Inserto en Temporal las Horas de Cnx y Dscnx para luego ser evaluadas      
insert into #Tempo1 (XNAVVIA11,  XCODCON04, XFECCONEX)      
Select distinct a.navvia11, c.codcon04, b.fectra60 from descarga.dbo.edauting14 a , descarga.dbo.edordtra60 b , descarga.dbo.eddettra61 c     
where       
a.navvia11=b.navvia11 and      
a.codcon14=c.codcon04 and      
b.nrotra60=c.nrotra60 and      
c.tiptra61='C'     
--and b.nrodoc06 is null     
and b.navvia11=@NAVVIA and b.codage19=@CODAGE       
      
      
update #Tempo1 set XFECDESCO=b.fectra60      
from descarga.dbo.edauting14 a, descarga.dbo.edordtra60 b, descarga.dbo.eddettra61 c, #Tempo1 d      
where       
a.navvia11=b.navvia11 and      
a.codcon14=c.codcon04 and      
b.nrotra60=c.nrotra60 and      
a.navvia11=d.XNAVVIA11 and      
a.codcon14=d.XCODCON04     
--and  b.nrodoc06 is null     
and c.tiptra61='D' and b.navvia11=@NAVVIA and b.codage19=@CODAGE       
      
update #Tempo1 set XDIFHORAS=datediff(hour, XFECCONEX, XFECDESCO),  XDIFDIAS=datediff(Day, XFECCONEX, XFECDESCO)      
      
END          
          
/** Insert Table Details **/          
Insert tarifario.dbo.st_tr_detalle  (id, id_item) select distinct @idReg, codcon04  from descarga.dbo.edllenad16 a , descarga.dbo.edauting14 b     
where a.nroaut14=b.nroaut14 and a.navvia11=@NAVVIA and a.oemadu16=@ORDEMB     
and b.codemc12=@EMBARC          
      
/** Insert Caracteristics Table Details **/          
BEGIN          
DECLARE CursorDetailsCtrs CURSOR FOR           
SELECT id_item FROM tarifario.dbo.st_tr_detalle WHERE id=@idReg          
END          
          
OPEN CursorDetailsCtrs          
            FETCH next FROM CursorDetailsCtrs INTO @NROCTR          
            WHILE @@FETCH_STATUS <> -1          
            begin          
          
                Select distinct @codtip05=b.codtip05, @pesmer16=sum(a.pesmer16), @codtam09=b.codtam09, @codbol03=b.codbol03,       
      @TipLln16=case  when a.flglln16 = '0' then 'SE LLENO'            
        when a.flglln16 = '1' then 'VINO LLENO'            
        when a.flglln16 = '3' then 'VINO LLENO'           
        when a.flglln16 = '2' then 'LLENADO POR EMBARCADOR'  end           
                from descarga.dbo.edllenad16 a, descarga.dbo.edconten04 b  where a.codcon04 COLLATE SQL_Latin1_General_CP1_CI_AS= b.codcon04 COLLATE SQL_Latin1_General_CP1_CI_AS and a.navvia11=@NAVVIA and a.codcon04=@NROCTR       
   group by b.codtip05,b.codtam09,b.codbol03,a.flglln16          
                insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,1, @pesmer16)      
                insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,2, @codtip05)      
                insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,3, @codtam09)      
                insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,4, @codbol03)      
      insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,12, @TipLln16)      
    
                insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,21, 'CTR')      
    --nueva linea agregada - unidad medida = 1 por default    
    insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  values (@idReg,@NROCTR,31, '1')       
                FETCH next FROM CursorDetailsCtrs  INTO @NROCTR          
            end           
          
CLOSE CursorDetailsCtrs          
          
DEALLOCATE CursorDetailsCtrs          
      
--Cursor para los reffers      
BEGIN         
DECLARE CursorDetailsCtrsRF CURSOR FOR         
SELECT id_item FROM tarifario.dbo.st_tr_detalle WHERE id=@idReg        
END        
        
OPEN CursorDetailsCtrsRF        
        
 FETCH next FROM CursorDetailsCtrsRF INTO @NROCTR        
 WHILE @@FETCH_STATUS <> -1        
 begin        
    
  select @HORASCONEX= XDIFHORAS,  @DIASCONEX= XDIFDIAS from #Tempo1 (nolock) where xnavvia11=@NAVVIA and xcodcon04=@NROCTR        
  --horas conexion reffers    
  insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc) values (@idReg,@NROCTR,25, @HORASCONEX)          
  -- dias conexion para monitoreo    
  insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc) values (@idReg,@NROCTR,27, @DIASCONEX)          
  -- flag reefer conectado expo = si    
  insert tarifario.dbo.st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc) values (@idReg,@NROCTR,30, 'SI')          
  FETCH next FROM CursorDetailsCtrsRF  INTO @NROCTR        
    
 end         
        
CLOSE CursorDetailsCtrsRF        
DEALLOCATE  CursorDetailsCtrsRF        
      
          
select @tipmon=Tip_mone from St_T_Clientes_Moneda where contribuy= @EMBARC --@RUCCLI              
--Inserto O.S. Manuales con el Monto Automatico      
Insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )          
SELECT 'E', ID, ID_Item, case when @tipmon = 'S' then  d.codsbd03 else d.codsbd03D end,  @SUCUR,  @CENCOS, 0      
FROM         
tarifario.dbo.st_tr_detalle a ,         
descarga.dbo.edordser50 b ,         
descarga.dbo.eddetord51 c ,         
descarga.dbo.gqcontar14_nt d        
where         
a.ID_Item=c.codent51 COLLATE SQL_Latin1_General_CP1_CI_AS and        
c.codcon14=d.codcon14 COLLATE SQL_Latin1_General_CP1_CI_AS and        
b.nroors50=c.nroors50 COLLATE SQL_Latin1_General_CP1_CI_AS and        
a.id=@idReg and b.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS=@NAVVIA 
and b.codage19=@RUCCLI and         
d.sucursal=@SUC and b.status50 in ('P')            
          
      
--Inserto O.S. Manuales con el Monto Manual      
Insert St_TR_Servicios_Manuales_Especiales (Tip_Serv, ID,  ID_Item,  Dc_Servicio,  Dc_Sucursal, Dc_Centro_Costo, Val_Serv )          
SELECT 'M', ID, ID_Item, case when @tipmon = 'S' then codsbd03 else codsbd03D end,  @SUCUR,  @CENCOS, c.importe51      
FROM         
tarifario.dbo.st_tr_detalle a ,         
descarga.dbo.edordser50 b ,         
descarga.dbo.eddetord51 c ,         
descarga.dbo.gqcontar14_nt d        
where         
a.ID_Item=c.codent51 COLLATE SQL_Latin1_General_CP1_CI_AS and        
c.codcon14=d.codcon14 COLLATE SQL_Latin1_General_CP1_CI_AS and        
b.nroors50=c.nroors50 COLLATE SQL_Latin1_General_CP1_CI_AS and        
a.id=@idReg and b.navvia11 COLLATE SQL_Latin1_General_CP1_CI_AS=@NAVVIA       
and b.codage19=@RUCCLI and  b.genbkg13='999999' and d.sucursal=@SUC       
and b.status50 in ('P')        
      
          
/** Insert  Dsctos Manuales **/          
      
Insert St_TR_Descuentos_Manuales (ID,Db_Servicio,Val_Desc,Tip_Desc)          
SELECT @idReg, case when @tipmon = 'S' then  c.codsbd03 else c.codsbd03D end, b.descto08, b.tipdsc08           
FROM           
descarga.dbo.eddesman08 b ,           
descarga.dbo.gqcontar14_nt c          
where           
b.codcon14 = c.codcon14 COLLATE SQL_Latin1_General_CP1_CI_AS and          
b.sucursal = c.sucursal COLLATE SQL_Latin1_General_CP1_CI_AS and          
b.navvia11 =@NAVVIA and          
b.notemb16= @ORDEMB and          
b.codage19 =@RUCCLI     
---and b.sucursal=@SUC           
      
--Elimino Tabla Temporal Reffers      
drop table #Tempo1    
    
    
SELECT ID_Generado=@idReg  
  



GO
/****** Object:  StoredProcedure [dbo].[SP_SSI_Plantas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SSI_Plantas]   
@filtro varchar(40)  
AS  
 
Select codplanta as codigo, descripcion as Descripcion 
from Terminal.dbo.ssi_planta
where descripcion like '%' + @filtro + '%'
return 0

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Acuerdo]  
@Cod_Acue int,  
@Contribuy varchar(11),  
@Dc_centro_Costo smallint,  
@Dc_Sucursal smallint,  
@Dc_Servicio varchar(20),  
@Des_Acue varchar(50),  
@Fec_Acti smalldatetime,  
@Fec_Term smalldatetime,  
@Usu_Acue varchar(20),  
@Val_Acue decimal(12,6),  
@flg_inte tinyint,  
@cod_Aplc varchar(20),  
@Cod_aplp tinyint,  
@Dc_centro_Costo_A smallint,  
@Dc_Sucursal_A smallint,  
@Tip_Valo char,  
@Des_Seri varchar(50),  
@Cod_Tari int,  
@Tar_Mini decimal(12,6),  
@Tar_Maxi decimal(12,6),  
@Val_Acus decimal(12,6), 
@Tar_Mins decimal(12,6),  
@Tar_Maxs decimal(12,6),  
@Usu_Actu varchar(20)  
  
AS  
  
If @Contribuy=''  
            set @Contribuy = null  
If @Dc_Centro_Costo_A=0  
            set @Dc_Centro_Costo_A=null  
If @Dc_Sucursal_A=0   
            set @DC_Sucursal_A=null  
If @Dc_Sucursal=0  
            set @DC_Sucursal=null  
If @Cod_Aplp=0   
            set @Cod_Aplp=null  
  
UPDATE St_T_Acuerdos   
SET  Contribuy = @Contribuy, Dc_Centro_Costo = @Dc_Centro_Costo, Dc_Sucursal = @Dc_Sucursal,
 Dc_Servicio = @Dc_Servicio, Des_Acue = @Des_Acue,
 Fec_Acti = @Fec_Acti, Fec_Term=@Fec_Term,
 Usu_Acue = @Usu_Acue, 
 Val_Acue = @Val_Acue,
 Val_Acus = @Val_Acus,
 Fec_Crea=getdate(),flg_inte= @flg_inte,
 Cod_aplp=@Cod_aplp,Dc_Centro_Costo_A=@Dc_Centro_Costo_A,
 Dc_Sucursal_A=@Dc_Sucursal_A, Tip_Valo=@Tip_Valo,Des_Seri=@Des_Seri,
 Cod_Tari=@Cod_Tari,Tar_Mini=@Tar_Mini,Tar_Maxi=@Tar_Maxi,
 Tar_Mins=@Tar_Mins,Tar_Maxs=@Tar_Maxs,   
Usu_Actu=@Usu_Actu,Fec_Actu=Getdate()  
WHERE (Cod_Acue=@Cod_Acue)   
SET NOCOUNT ON  

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Procesos Aplicados
    Fecha       : 15/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Aplica]
@Cod_Aplp int,
@Des_Aplp varchar(50)

AS

Update St_T_Aplica set Des_Aplp =@Des_Aplp where Cod_Aplp=@Cod_Aplp

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Aplicacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Aplicaciones
    Fecha       :19/Nov/2005
    JF.
*/

ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Aplicacion]
@Cod_Apli smallint,
@Des_Apli varchar(40)

AS

Update St_T_Aplicaciones set Des_Apli =@Des_Apli where Cod_Apli=@Cod_Apli

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Asignacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Asignacion]

@Cod_Asig smallint,

@Dc_Centro_Costo smallint,

@Dc_Sucursal smallint,

@Dc_Servicio varchar(20),

@Tam_cont smallint,

@Cod_Line char(3),

@Cod_Depo tinyint,

@Es_Inte varchar(2),

@Otr_Line varchar(2),

@Tip_eval tinyint

AS

 

 

update  St_T_Asignaciones set Dc_Centro_Costo=@Dc_Centro_Costo,Dc_Sucursal =@Dc_Sucursal,Dc_Servicio=@Dc_Servicio,Tam_Cont=@Tam_Cont,Cod_line=@Cod_Line, Cod_Depo=@Cod_Depo, Es_Inte=@Es_Inte,Otr_Line=@Otr_Line,Tip_Eval=@Tip_Eval

where Cod_Asig=@Cod_Asig

 

SET NOCOUNT ON

 



GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Caracteristicas_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar mercaderias por Acuerdo
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Caracteristicas_Acuerdo]
@Cod_Meac int,
@Cod_Acue int,
@Cod_Merc tinyint,
@Val_Meac varchar(100),
@Des_Meac varchar(100),
@Flg_Proc tinyint

AS

If @Des_Meac=''
	update St_T_caracteristicas_Acuerdo set Cod_acue=@Cod_acue, Cod_Merc=@Cod_Merc,Val_Meac=@val_Meac,Des_Meac=null,Flg_Proc=@Flg_Proc where Cod_Meac=@Cod_Meac
else
	update St_T_caracteristicas_Acuerdo set Cod_acue=@Cod_acue, Cod_Merc=@Cod_Merc,Val_Meac=@val_Meac,Des_Meac=@Des_Meac,Flg_Proc=@Flg_proc where Cod_Meac=@Cod_Meac


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Caracteristicas_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar mercaderias por Acuerdo
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Caracteristicas_Combo]
@Cod_Caco int,
@Cod_Comb int,
@Cod_Merc tinyint,
@Val_Caco varchar(100),
@Des_Caco varchar(100)

AS

If @Des_Caco=''
	update St_T_caracteristicas_Combo set Cod_Comb=@Cod_Comb, Cod_Merc=@Cod_Merc,Val_Caco=@val_Caco,Des_Caco=null where Cod_Caco=@Cod_Caco
else
	update St_T_caracteristicas_Combo set Cod_comb=@Cod_comb, Cod_Merc=@Cod_Merc,Val_Caco=@val_Caco,Des_Caco=@Des_Caco where Cod_Caco=@Cod_Caco


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Caracteristicas_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar mercaderias por Tarifa
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Caracteristicas_Tarifa]
@Cod_Meac int,
@Cod_Acue int,
@Cod_Merc tinyint,
@Val_Meac varchar(100),
@Des_Meac varchar(100),
@Flg_Proc tinyint

AS

If @Des_Meac=''
	update St_T_caracteristicas_Acuerdo set Cod_acue=@Cod_acue, Cod_Merc=@Cod_Merc,Val_Meac=@val_Meac,Des_Meac=null,Flg_Proc=@Flg_Proc where Cod_Meac=@Cod_Meac
else
	update St_T_caracteristicas_Acuerdo set Cod_acue=@Cod_acue, Cod_Merc=@Cod_Merc,Val_Meac=@val_Meac,Des_Meac=@Des_Meac,Flg_Proc=@Flg_Proc where Cod_Meac=@Cod_Meac


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Centro]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Centro de Costo
    Fecha       : 18/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Centro]
@Dc_Centro_costo smallint,
@Dg_Centro_Costo varchar(50),
@Df_Inicio_Vigencia smalldatetime,
@Df_Termino_Vigencia smalldatetime

AS

Update  St_V_Centros set Dg_Centro_Costo =@Dg_Centro_Costo,Df_Inicio_Vigencia= @Df_Inicio_Vigencia,Df_Termino_Vigencia= @Df_Termino_Vigencia where Dc_Centro_costo=@Dc_Centro_costo

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Cliente_Moneda]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Cliente_Moneda]
@Contribuy varchar(11),
@Tip_mone char(1)
AS

update st_t_clientes_moneda set Tip_mone=@Tip_mone where Contribuy=@Contribuy
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Acuerdo
    Fecha       : 08/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Combo]
@Cod_Comb as int,
@Tip_Comb char,
@Nom_Comb varchar(70)

AS
declare @sRuc char(11)


	UPDATE St_T_Combos
	SET  Tip_Comb=@Tip_Comb,Nom_Comb=@Nom_Comb
	WHERE (Cod_Comb=@Cod_Comb)

select top 1 @sRuc=contribuy from St_T_Combos where Cod_Comb= @Cod_Comb
exec Impo_Carga_Combo_Cliente @sRuc


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Entidad]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Entidades 
    Fecha       : 18/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Entidad]
@Cod_Enti smallint,
@Des_Enti varchar(50),
@Tip_Enti smallint,
@Val_Enti Varchar(100),
@Tam_enti varchar(20),
@flg_apli tinyint

AS

Update St_T_Entidades set Des_Enti =@Des_enti,Tip_Enti= @Tip_Enti,Val_Enti= @Val_Enti, tam_enti=@tam_enti,flg_apli=@flg_apli where Cod_Enti=@Cod_Enti

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Entidad_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Acuerdo
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Entidad_Acuerdo]
@Cod_Enac int,
@Cod_Acue int,
@Cod_Enti tinyint,
@Val_Enac varchar(100),
@Des_Enac varchar(100),
@Flg_Proc tinyint

AS

If @Des_Enac=''
	update St_T_Entidades_Acuerdos set Cod_acue=@Cod_acue, Cod_enti=@Cod_enti,Val_enac=@val_enac,Des_Enac=null,Flg_Proc=@Flg_Proc where Cod_Enac=@cod_enac
else
	update St_T_Entidades_Acuerdos set Cod_acue=@Cod_acue, Cod_enti=@Cod_enti,Val_enac=@val_enac,Des_Enac=@Des_Enac,Flg_Proc=@Flg_Proc where Cod_Enac=@cod_enac


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Entidad_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Acuerdo
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Entidad_Combo]
@Cod_Enco int,
@Cod_Comb int,
@Cod_Enti tinyint,
@Val_Enco varchar(100),
@Des_Enco varchar(100)

AS

If @Des_Enco=''
	update St_T_Entidades_Combo set Cod_Comb=@Cod_comb, Cod_enti=@Cod_enti,Val_enco=@val_enco,Des_Enco=null where Cod_Enco=@cod_enco
else
	update St_T_Entidades_Combo set Cod_Comb=@Cod_comb, Cod_enti=@Cod_enti,Val_enco=@val_enco,Des_Enco=@Des_Enco where Cod_Enco=@cod_enco


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Entidad_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Tarifa
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Entidad_Tarifa]
@Cod_Enac int,
@Cod_Acue int,
@Cod_Enti tinyint,
@Val_Enac varchar(100),
@Des_Enac varchar(100),
@Flg_Proc tinyint

AS

If @Des_Enac=''
	update St_T_Entidades_Acuerdos set Cod_acue=@Cod_acue, Cod_enti=@Cod_enti,Val_enac=@val_enac,Des_Enac=null,Flg_Proc=@Flg_Proc where Cod_Enac=@cod_enac
else
	update St_T_Entidades_Acuerdos set Cod_acue=@Cod_acue, Cod_enti=@Cod_enti,Val_enac=@val_enac,Des_Enac=@Des_Enac,Flg_Proc=@Flg_Proc where Cod_Enac=@cod_enac


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Estado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Estado 
    Fecha       : 18/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Estado]
@Cod_Esta char,
@Des_Esta varchar(40)

AS

Update St_T_Estados set Des_Esta =@Des_Esta where Cod_Esta='@Cod_Esta'

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Factura_Ind]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Factura_Ind]

@ID integer,

@Contribuy varchar(11),

@Dc_Servicio varchar(20)

AS

 

update tarifario.dbo.St_T_Facturas_Independientes

set Dc_servicio = @Dc_Servicio, contribuy=@Contribuy

where ID=@Id

 

 

update tarifario.dbo.St_T_Facturas_Independientes

set Dc_servicio = @Dc_Servicio, contribuy=@Contribuy

where ID=@Id

 

 

 

SET NOCOUNT ON

 


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Mercaderia
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Mercaderia]
@Cod_Merc smallint,
@Des_Merc varchar(50),
@Tip_Cara smallint,
@Val_Merc Varchar(100),
@Tam_Merc smallint,
@flg_apli tinyint

AS

Update St_T_Caracteristicas_Mercaderia set Des_Merc =@Des_Merc,Tip_Cara= @Tip_Cara,Val_merc= @Val_merc,tam_merc=@Tam_Merc, flg_apli=@flg_apli where Cod_Merc=@Cod_Merc

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Parametro]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Parametro
    Fecha       : 19/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Parametro]

@Mes_Term smallint

AS

Update St_T_valores set Mes_term =@mes_term

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Perfil]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Perfil
    Fecha       : 14/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Perfil]
@Cod_perf int,
@Des_perf varchar(50),
@Des_porc decimal

AS

Update St_T_perfil_usuario set Des_perf =@Des_perf,Des_porc= @Des_porc where Cod_perf=@Cod_Perf

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Servicio_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar mercaderias por Acuerdo
    Fecha       : 24/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Servicio_Combo]
@Cod_Seco int,
@Val_Seco decimal(9,2)

AS
declare 
@Cod_comb int,
@Contribuy varchar(11)

	update St_T_servicios_Combo set Val_Seco=@Val_Seco where Cod_Seco=@Cod_Seco



	select @Cod_comb=Cod_Comb from st_t_servicios_combo where Cod_seco=@Cod_seco

	select @Contribuy=contribuy from St_t_combos where Cod_Comb=@Cod_Comb

	exec Impo_Carga_Combo_Cliente  @Contribuy

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Servicios_Asignados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Servicios_Asignados]
@Cod_Seas smallint,
@Cod_Asig smallint,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@por_asig  decimal(9,2)

AS


update  St_T_Servicios_Asignados set Dc_Centro_Costo=@Dc_Centro_Costo,Dc_Sucursal =@Dc_Sucursal,Dc_Servicio=@Dc_Servicio,Por_Asig=@Por_Asig
where Cod_Seas=@Cod_Seas

SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Actualizar Sucursal
    Fecha       :21/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Sucursal]
@Dc_Sucursal smallint,
@Dg_Sucursal varchar(80)

AS

Update St_V_Sucursal set Dg_Sucursal =@Dg_Sucursal where Dc_Sucursal=@Dc_Sucursal

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Actualizar_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito   : Actualizar Tarifa
    Fecha       : 14/Abr/2006
    CM.
*/

ALTER PROCEDURE [dbo].[Sp_St_Actualizar_Tarifa]
@Cod_Acue int,
@Dc_centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@Des_Acue varchar(50),
@Tip_Aplc varchar(20),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Tar_Mini Decimal(12,6),
@Tar_Maxi Decimal(12,6),
@Cod_aplp tinyint,
@Val_Proc decimal(12,6),
@Dc_centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Val_Pros decimal(12,6),
@Val_Acus decimal(12,6),
@Tar_Mins decimal(12,6),
@Tar_Maxs decimal(12,6)


AS

If @Dc_Centro_Costo_A=0
	set @Dc_Centro_Costo_A=null
If @Dc_Sucursal_A=0 
	set @DC_Sucursal_A=null
If @Dc_Sucursal=0
	set @DC_Sucursal=null
If @Cod_Aplp=0
	set @Cod_Aplp=null

	UPDATE St_T_Acuerdos 
	SET  Dc_Centro_Costo_A = @Dc_Centro_Costo_A, Dc_Sucursal_A = @Dc_Sucursal_A, Dc_Centro_Costo = @Dc_Centro_Costo, Dc_Sucursal = @Dc_Sucursal, Dc_Servicio = @Dc_Servicio, Des_Acue = @Des_Acue, Fec_Acti = @Fec_Acti, Fec_Term=@Fec_Term,Usu_Acue = @Usu_Acue, Val_Acue=@Val_Acue,Tar_Mini=@Tar_Mini, Tar_Maxi= @Tar_Maxi, Cod_Aplp=@cod_aplp,val_Proc=@Val_Proc, Val_Pros=@Val_Pros,Val_Acus=@Val_Acus,Tar_Mins=@Tar_Mins,Tar_Maxs=@Tar_Maxs
	WHERE (Cod_Acue=@Cod_Acue)

SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Acuerdo con parametro del Codigo del Acuerdo
    Fecha       : 18/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Acuerdo] 

@Cod_Acue int
AS
select * from St_V_Acuerdos where Cod_Acue=@Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Acuerdos para filtros de codigo de cliente, centro costo, sucursal y servicio
    Fecha       : 21/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Acuerdos]

@Contribuy  varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20)

AS

select * from St_V_Acuerdos where Contribuy=@Contribuy and Dc_Centro_Costo = @Dc_Centro_Costo and Dc_Sucursal = @Dc_Sucursal and Dc_Servicio = @Dc_Servicio order by Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Acuerdos_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :25/05/2006
  PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Acuerdos_Cubo]
AS

Select * from  St_t_Acuerdos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Lista Procesos aplicados
    Fecha       : 15/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Aplica]
@Cod_Aplp  int
AS

select * from  ST_T_Aplica where Cod_Aplp = @Cod_Aplp

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Aplicacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Lista  Aplicacion
    Fecha       : 18/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Aplicacion]
@Cod_Apli smallint
AS

select * from  ST_T_Aplicaciones where Cod_Apli = @Cod_Apli

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Aplicaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplicaciones 
    Fecha       : 17/Nov/2005
    JF.
*/

--ALTER PROCEDURE [dbo].[Sp_St_Aplicaciones]

--AS

--select * from  ST_V_Aplicaciones

--SET NOCOUNT ON
--GO
--/****** Object:  StoredProcedure [dbo].[Sp_St_Aplican]    Script Date: 07/03/2019 04:16:53 PM ******/
--SET ANSI_NULLS OFF
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--/* Autor        : Acecor Business Solutions SAC 
--    Proposito  : Listar Perfiles
--    Fecha       : 14/Dic/2005
--    CM.
--*/

--ALTER PROCEDURE [dbo].[Sp_St_Aplican]

--AS

--select * from  ST_V_Aplica

--SET NOCOUNT ON
--GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Aprobar_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Acuerdos Por Aprobar
    Fecha       : 21/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Aprobar_Acuerdos]

@Cod_Esta char(1)


AS
select * from St_V_Acuerdos where Cod_Esta = @Cod_Esta
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Aprobar_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Tarifas por Aprobar
    Fecha       : 28/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Aprobar_Tarifas]

@Cod_Esta char(1)


AS
select * from St_V_Acuerdos where Cod_Esta = @Cod_Esta
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Asignacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_St_Asignacion]
@Cod_Asig smallint
AS

select * from St_v_Asignaciones where Cod_Asig=@Cod_Asig

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Asignaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_St_Asignaciones] 

AS

select * from St_v_Asignaciones

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Buscar_Usuarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : buscar usuario
    Fecha       : 13/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Buscar_Usuarios]
@nom_usua varchar(20),
@pas_usua varchar(20)

AS
select * from St_V_Buscar_Usuarios where nom_usua=@nom_usua and pas_usua=@pas_usua
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caducar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  :Caducar Acuerdo
    Fecha       : 19/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caducar_Acuerdo]

AS

	Update St_T_Acuerdos 
	SET  Cod_Esta='I'
	WHERE Fec_Term<getdate() and cod_esta='A' and flg_tari=0

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[SP_ST_Calles]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_ST_Calles] 	
@filtro varchar(100)
as
/*LISTADO DE CALLES
*/
If @filtro<>''
select  CAL_CODIGO AS codigo, substring(CAL_DESCRIPCION,1,12)   AS Descripcion from Terminal.dbo.ssi_calles
where 
CAL_ESTADO <>'I'
else
select  CAL_CODIGO AS codigo, substring(CAL_DESCRIPCION,1,12)   AS Descripcion from Terminal.dbo.ssi_calles
where 
CAL_ESTADO <>'I'
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristica_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una caracteristica de un determinado acuerdo
    Fecha       : 23/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristica_Acuerdo]
@Cod_Meac int
AS
select * from St_V_Caracteristicas_Acuerdos where cod_Meac= @Cod_Meac order by Des_Merc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristica_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una caracteristica de un determinado acuerdo
    Fecha       : 23/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristica_Combo]
@Cod_Caco int
AS
select * from St_V_Caracteristicas_Combo where cod_Caco= @Cod_Caco
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristica_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una caracteristica de una determinada tarifa
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristica_Tarifa]
@Cod_Meac int
AS
select * from St_V_Caracteristicas_Tarifas where cod_Meac= @Cod_Meac
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Acuerdo_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Acuerdo_Combo] 
@Cod_Acue int,
@Cod_Comb int
AS
select * from St_t_Caracteristicas_Acuerdo  where Cod_Acue=@Cod_Acue and Cod_Merc not in (select Cod_Merc from St_t_Caracteristicas_combo where Cod_Comb=@Cod_Comb)
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una Caracteristica de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Acuerdos]
@Cod_Acue  int
AS
select * from St_V_Caracteristicas_Acuerdos where cod_acue=@Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una Caracteristica de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Combo]
@Cod_Comb int
AS
select * from St_V_Caracteristicas_Combo where cod_comb=@Cod_Comb
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Caracteristicas de la mercaderia con parametro codigo de acuerdo
    Fecha       : 21/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Mercaderia] 
@Cod_Acue  int
AS
select * from St_V_Caracteristicas_Mercaderia where Cod_Acue=@Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Mercaderia_cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Caracteristicas de la mercaderia con parametro codigo de acuerdo
    Fecha       : 25/May/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Mercaderia_cubo]
AS
select * from St_t_Caracteristicas_Mercaderia
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Sin_Asignar]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplicaciones 
    Fecha       : 25/Nov/2005
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Sin_Asignar]
@Cod_Acue int
AS

select Cod_Merc,Des_Merc  from  St_T_Caracteristicas_Mercaderia  where Cod_Merc not in (select Cod_Merc from st_t_caracteristicas_acuerdo where Cod_acue=@Cod_Acue)
order by des_merc
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Sin_Asignar_combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplicaciones 
    Fecha       : 25/Nov/2005
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Sin_Asignar_combo]
@Cod_Comb int
AS

select Cod_Merc,Des_Merc  from  St_T_Caracteristicas_Mercaderia  where Cod_Merc not in (select Cod_Merc from st_t_caracteristicas_Combo where Cod_Comb=@Cod_Comb)

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Caracteristicas_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una Caracteristica de ua determinada tarifa
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Caracteristicas_Tarifas]
@Cod_Tari  int
AS
select * from St_V_Caracteristicas_Tarifas where cod_acue=@Cod_Tari
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Centro]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Centro 
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Centro]
@Dc_Centro_Costo tinyint
AS

select * from st_v_Centros  where Dc_Centro_Costo = @Dc_Centro_Costo

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_CentroApl_acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APC20080310
ALTER PROCEDURE [dbo].[Sp_St_CentroApl_acuerdo] 
@Cod_Acue int
AS
SELECT     Tb_centro_costo.dg_centro_costo, tb_sucursal_inst.dg_sucursal, dbo.St_T_Acuerdos.Dc_Centro_Costo_A, 
                      dbo.St_T_Acuerdos.Dc_Sucursal_A
FROM         dbo.St_T_Acuerdos LEFT OUTER JOIN
                      TMTIEN tb_sucursal_inst ON dbo.St_T_Acuerdos.Dc_Sucursal_A = tb_sucursal_inst.dc_sucursal LEFT OUTER JOIN
                      TTUNID_NEGO  Tb_centro_costo ON dbo.St_T_Acuerdos.Dc_Centro_Costo_A = Tb_centro_costo.dc_centro_costo
WHERE dbo.St_T_Acuerdos.Cod_Acue=@Cod_Acue


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Centros]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Centros
    Fecha       : 19/Nov/2005
    JF.
*/

ALTER PROCEDURE [dbo].[Sp_St_Centros]

AS

select * from  ST_V_Centros

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Cliente_Moneda]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Cliente_Moneda]
@Contribuy varchar(11)
AS

select * from st_v_Clientes  where contribuy=@contribuy


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Clientes_Moneda]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Clientes_Moneda] 
@Contribuy varchar(11)
AS
Select Tip_Mone from St_T_Clientes_Moneda where Contribuy=@Contribuy
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Combo]

@Cod_Comb int
AS
select * from St_v_Combos where Cod_comb=@Cod_Comb

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Combos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Combos] 
@Tipo char(1)
AS
If @Tipo='T' 
	select * from St_v_Combos
If @Tipo<>'T' 
	select * from St_v_Combos where Tip_Comb=@Tipo


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Combos_Cliente]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Acuerdo con parametro del Codigo del Acuerdo
    Fecha       : 08/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Combos_Cliente]
@Tipo char(1),
@Cliente varchar(11)
AS
If @Tipo='T' 
	select * from St_v_Combos where Contribuy=@Cliente
If @Tipo<>'T' 
	select * from St_v_Combos where Tip_Comb=@Tipo and Contribuy=@Cliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Copiar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Copiar_Acuerdo]
@Cod_Acue_Orig int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@cod_tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Aplc varchar(20),
@Cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Tip_Valo char,
@Des_Seri varchar(50),
@Tar_Mini decimal(9,2),
@Tar_Maxi decimal(9,2),
@Val_Acus decimal(12,6),
@Tar_Mins decimal(12,6),
@Tar_Maxs decimal(12,6)

AS

declare @Cod_Acue int

/*insert St_T_Acuerdos(Cod_Acue,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Des_Acue,Fec_Acti,Usu_Acue,Val_Acue,Tar_Mini,Tar_Maxi,Fec_Crea,Cod_Esta,Flg_Tari,Val_Proc,Flg_Proc,Flg_Apli) 
values(@Cod_Acue,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,@Fec_Acti,@Usu_Acue,@Val_Acue,@Tar_Mini,@Tar_Maxi,getdate(),'P',1,@Val_Proc,@Flg_Proc,@Flg_Apli)*/
exec Sp_St_Grabar_Acuerdo @Contribuy,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@cod_tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_inte,0,@Cod_aplc,@Cod_Aplp,@Dc_Centro_Costo_A,@Dc_Sucursal_A,@Tip_Valo,@Des_Seri,@Tar_Mini,@Tar_Maxi,@Val_Acus,@Tar_Mins,@Tar_Maxs
select @Cod_Acue=max(Cod_Acue) from St_T_Acuerdos

/*Iniciamos cursor */

Declare
@Val_enac varchar(100),
@Cod_Enti smallint,
@Des_Enac varchar(100),
@Flg_Proc tinyint

declare C_Entidades cursor for
select Val_enac,Cod_enti,des_enac,Flg_Proc from St_T_entidades_acuerdos where Cod_Acue=@Cod_Acue_Orig

open C_Entidades

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Val_enac,@Des_Enac,@Flg_Proc

-- Avanzamos otro registro

fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc
end 
-- cerramos el cursor
close C_Entidades
deallocate C_Entidades


/* Caracteristicas Mercaderia */

Declare
@Val_meac varchar(100),
@Cod_merc smallint,
@Des_meac varchar(100)


declare C_Caracteristicas cursor for
select Val_meac,Cod_merc,des_meac,Flg_Proc from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_Acue_Orig

open C_Caracteristicas

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,@Cod_merc,@Val_meac,@Des_meac,@Flg_Proc

-- Avanzamos otro registro

fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc
end 
-- cerramos el cursor
close C_Caracteristicas
deallocate C_Caracteristicas

select @Cod_Acue
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Copiar_Acuerdo_DL]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Copiar Acuerdo cambiando parametros para servicio de almacenaje con dias libres.
    Fecha       : 12/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Copiar_Acuerdo_DL]
@Cod_Acue_Orig int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@cod_tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Aplc varchar(20),
@Cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Tip_Valo char,
@Des_Seri varchar(50),
@Rango varchar(20),
@Rango_DL varchar(20),
@Tam varchar(20)



AS

declare @Cod_Acue int


exec Sp_St_Grabar_Acuerdo @Contribuy,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@cod_tari,@Des_Acue ,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_inte,0,@Cod_aplc,@Cod_Aplp,@Dc_Centro_Costo_A,@Dc_Sucursal_A,@Tip_Valo,@Des_Seri
select @Cod_Acue=max(Cod_Acue) from St_T_Acuerdos

/*Iniciamos cursor */

Declare
@Val_enac varchar(100),
@Cod_Enti smallint,
@Des_Enac varchar(100),
@Flg_Proc tinyint

declare C_Entidades cursor for
select Val_enac,Cod_enti,des_enac,Flg_Proc from St_T_entidades_acuerdos where Cod_Acue=@Cod_Acue_Orig

open C_Entidades

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc

while @@fetch_status = 0
begin

If @Cod_Enti=21
begin
	If @Rango_DL<>''
		exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Rango_DL,@Des_Enac,0
end 
else
begin
	exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Val_enac,@Des_Enac,0
end
-- Avanzamos otro registro

fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc
end 
-- cerramos el cursor
close C_Entidades
deallocate C_Entidades

/*Se adiciona Entidad de Dias Almacenados Manualmente */

exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,22,@Rango,'*',1

/* Caracteristicas Mercaderia */

Declare
@Val_meac varchar(100),
@Cod_merc smallint,
@Des_meac varchar(100)


declare C_Caracteristicas cursor for
select Val_meac,Cod_merc,des_meac,Flg_Proc from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_Acue_Orig

open C_Caracteristicas

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,@Cod_merc,@Val_meac,@Des_meac,@Flg_Proc

-- Avanzamos otro registro

fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc
end 
-- cerramos el cursor
close C_Caracteristicas
deallocate C_Caracteristicas


-- Creacion del registro de tamaño del contenedor.

IF @TAM =20 
	exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,3,@Tam,'20 PIES',0
else
	exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,3,@Tam,'40 PIES',0


select @Cod_Acue
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Copiar_All_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Copiar Todas las Tarifas
    Fecha       : 14/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Copiar_All_Acuerdos]
@Dc_Centro_Costo_A_Buscar smallint,
@Dc_Sucursal_A_Buscar smallint,
@Dc_Centro_Costo_A_Reemplazar smallint,
@Dc_Sucursal_A_Reemplazar smallint

AS
Declare

@Cod_Acue_Orig int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@cod_tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Aplc varchar(20),
@Cod_aplp tinyint,
@Tip_Valo char,
@Des_Seri varchar(50),
@Cod_Acue_Nuevo int


declare C_Acuerdos  cursor for
select  Cod_Acue,contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Cod_Tari,Des_Acue,Fec_Acti,Fec_Term,Usu_Acue,Val_Acue,Flg_Inte,Cod_Aplc, Cod_Aplp,Tip_Valo,Des_Seri from St_t_Acuerdos where 
Flg_Tari=0 and Dc_Centro_Costo_A=@Dc_Centro_Costo_A_Buscar and Dc_Sucursal_A=@Dc_Sucursal_A_Buscar


open C_Acuerdos

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Acuerdos
into @Cod_Acue_orig,@contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Cod_Tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_Inte,@Cod_Aplc, @Cod_Aplp,@Tip_Valo,@Des_Seri

while @@fetch_status = 0
begin

exec Sp_St_Copiar_Acuerdo @Cod_Acue_orig,@contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Cod_Tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_Inte,@Cod_Aplc, @Cod_Aplp,@Dc_Centro_Costo_A_Reemplazar,@Dc_Sucursal_A_Reemplazar,@Tip_Valo,@Des_Seri

-- Avanzamos otro registro

fetch next from C_Acuerdos
into @Cod_Acue_orig,@contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Cod_Tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_Inte,@Cod_Aplc, @Cod_Aplp,@Tip_Valo,@Des_Seri
end 
-- cerramos el cursor
close C_Acuerdos
deallocate C_Acuerdos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Copiar_All_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Copiar Todas las Tarifas
    Fecha       : 14/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Copiar_All_Tarifas]
@Dc_Centro_Costo_A_Buscar smallint,
@Dc_Sucursal_A_Buscar smallint,
@Dc_Centro_Costo_A_Reemplazar smallint,
@Dc_Sucursal_A_Reemplazar smallint

AS
Declare

@Cod_Acue_Orig int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@cod_tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Proc decimal(12,6),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Aplc varchar(20),
@Cod_aplp tinyint,
@Tip_Valo char,
@Tar_Mini decimal(9,2),
@Tar_Maxi decimal(9,2),
@Flg_Proc char,
@Flg_Apli tinyint,
@Cod_Acue_Nuevo int



declare C_Acuerdos  cursor for
select  Cod_Acue,contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Cod_Tari,Des_Acue,Fec_Acti,Fec_Term,Usu_Acue,Val_Acue,Flg_Inte,Cod_Aplc, Cod_Aplp,Tip_Valo,Tar_Mini, Tar_maxi,Flg_Proc,Flg_Apli from St_t_Acuerdos where 
Flg_Tari=1 and Dc_Centro_Costo_A=@Dc_Centro_Costo_A_Buscar and Dc_Sucursal_A=@Dc_Sucursal_A_Buscar

open C_Acuerdos

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Acuerdos
into @Cod_Acue_orig,@contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Cod_Tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_Inte,@Cod_Aplc, @Cod_Aplp,@Tip_Valo,@Tar_Mini,@Tar_Maxi,@Flg_Proc,@Flg_Apli 

while @@fetch_status = 0
begin

exec Sp_St_Copiar_Tarifa @Cod_Acue_orig,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,'',@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Val_Proc,@Tar_Mini,@Tar_Maxi,@Flg_Proc,@Flg_Apli,@Cod_Aplp,@Dc_Centro_Costo_A_Reemplazar,@Dc_Sucursal_A_Reemplazar


select @Cod_Acue_Nuevo=max(Cod_Acue) from st_t_acuerdos

update St_T_Acuerdos set Cod_Tari=@Cod_Acue_Nuevo where Cod_Tari=@Cod_Acue_Orig  and Dc_Centro_Costo_A=@Dc_Centro_Costo_A_reemplazar and Dc_Sucursal_A=@Dc_Sucursal_A_Reemplazar


-- Avanzamos otro registro

fetch next from C_Acuerdos
into @Cod_Acue_orig,@contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Cod_Tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_Inte,@Cod_Aplc, @Cod_Aplp,@Tip_Valo,@Tar_Mini,@Tar_Maxi,@Flg_Proc,@Flg_Apli 
end 
-- cerramos el cursor
close C_Acuerdos
deallocate C_Acuerdos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Copiar_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Copiar Tarifa
    Fecha       : 11/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Copiar_Tarifa]
@Cod_Acue_Orig int,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@Des_Acue varchar(50),
@Tip_Apli varchar(20),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Val_Proc Decimal(12,6),
@Tar_Mini Decimal(12,6),
@Tar_Maxi Decimal(12,6),
@Flg_Proc char,
@Flg_Apli tinyint,
@Cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Val_Acus decimal(12,6),
@Tar_Mins Decimal(12,6),
@Tar_Maxs Decimal(12,6),
@Val_Pros Decimal(12,6)
AS

declare @Cod_Acue int
declare @Flg_Proc_e tinyint

exec Sp_St_Grabar_Tarifa @Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,@tip_apli,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@val_Proc,@Tar_Mini,@Tar_Maxi, @Flg_proc,@flg_Apli, 0,@Cod_aplp,@Dc_centro_Costo_A,@Dc_Sucursal_A,@Val_Acus,@Tar_mins,@Tar_Maxs,@Val_Pros
select @Cod_Acue=max(Cod_Acue) from St_T_Acuerdos



/*Iniciamos cursor */

Declare
@Val_enac varchar(100),
@Cod_Enti smallint,
@Des_Enac varchar(100)

declare C_Entidades cursor for
select Val_enac,Cod_enti,des_enac,Flg_Proc from St_T_entidades_acuerdos where Cod_Acue=@Cod_Acue_Orig

open C_Entidades

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc_e

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Val_enac,@Des_Enac,@Flg_Proc_e

-- Avanzamos otro registro

fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Proc_e
end 
-- cerramos el cursor
close C_Entidades
deallocate C_Entidades


/* Caracteristicas Mercaderia */

Declare
@Val_meac varchar(100),
@Cod_merc smallint,
@Des_meac varchar(100)


declare C_Caracteristicas cursor for
select Val_meac,Cod_merc,des_meac,Flg_Proc from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_Acue_Orig

open C_Caracteristicas

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc_e

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,@Cod_merc,@Val_meac,@Des_meac,@Flg_Proc_e

-- Avanzamos otro registro

fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Proc_e
end 
-- cerramos el cursor
close C_Caracteristicas
deallocate C_Caracteristicas

select @Cod_Acue
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Cu_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Acuerdo con parametro del Codigo del Acuerdo
    Fecha       : 18/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Cu_Acuerdo] 

@Cod_Acue int
AS
select * from St_T_Acuerdos where Cod_Acue=@Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Cu_Caracteristicas_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una Caracteristica de un determinado acuerdo
    Fecha       : 25/May/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Cu_Caracteristicas_Acuerdos]
@Cod_Acue as integer
AS
If @Cod_acue=-1 
	select * from St_V_Caracteristicas_Acuerdos
Else
	select * from St_V_Caracteristicas_Acuerdos where Cod_Acue=@Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Cu_Eliminar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Sp_St_Cu_Eliminar_Acuerdo] 
@Cod_Acue integer
AS
delete St_T_Tarifario_Cubo where Cod_Acue=@Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Cu_Entidades_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 25/May/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Cu_Entidades_Acuerdos]
@Cod_Acue as integer 
AS
If @Cod_acue=-1 
	select * from St_V_Entidades_Acuerdos
else
	select * from St_V_Entidades_Acuerdos where Cod_Acue=@Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Agencias]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       : 23/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Agencias]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Agencias where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Agencias

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Agencias_Aduanas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_E_Agencias_Aduanas]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Agencias_Aduanas where DESCRIPCION like '%' + @filtro + '%'
else
	select * from  St_V_E_Agencias_Aduanas

SET NOCOUNT ON


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Agencias_Maritimas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Agencias_Maritimas]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Agencias_Maritimas where DESCRIPCION like '%' + @filtro + '%'
else
	select * from  St_V_E_Agencias_Maritimas

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Calles]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_E_Calles] 	
@filtro varchar(100)
AS

If @filtro<>''
	select  CAL_CODIGO AS codigo, substring(CAL_DESCRIPCION,1,12)   AS Descripcion from Terminal.dbo.ssi_calles
else
	select  CAL_CODIGO AS codigo, substring(CAL_DESCRIPCION,1,12)   AS Descripcion from Terminal.dbo.ssi_calles
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Condicion_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Condicion_CTR]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Condicion_CTR where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Condicion_CTR

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Consignatarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Consignatarios]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Consignatarios where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Consignatarios

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Consolidadoras]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Consolidadoras]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Consolidadoras where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Consolidadoras

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Embalajes]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       : 1/Dic/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Embalajes]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Embalajes where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Embalajes

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Embarcadores]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_E_Embarcadores]
@filtro varchar(100)  
AS  
If @filtro<>''  
 select * from  St_V_E_Embarcadores where descripcion like '%' + @filtro + '%'  
else  
 select * from  St_V_E_Embarcadores
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Lineas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Lineas como entidades.
    Fecha       : 24/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Lineas]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Lineas where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Lineas

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Naves]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Naves]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Naves where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Naves

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Productos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_E_Productos]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Productos where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Productos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Puertos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Puertos]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Puertos where DESCRIPCION like '%' + @filtro + '%'
else
	select * from  St_V_E_Puertos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       : 30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Servicio]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Servicio where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Servicio

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Tamaño_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Tamaño_CTR]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Tamaño_CTR where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Tamaño_CTR

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_E_Tipo_CTR]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Agencias como entidades.
    Fecha       :30/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_E_Tipo_CTR]
@filtro varchar(100)
AS

If @filtro<>''
	select * from  St_V_E_Tipo_CTR where descripcion like '%' + @filtro + '%'
else
	select * from  St_V_E_Tipo_CTR

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Acuerdo
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Acuerdo]
@Cod_Acue int
AS

--delete  from St_T_Entidades_Acuerdos where Cod_Acue= @Cod_Acue
--delete  from St_T_Caracteristicas_Acuerdo where Cod_Acue= @Cod_Acue
--delete  from St_T_Acuerdos where Cod_Acue= @Cod_Acue
--delete St_t_Tarifario_Cubo where Cod_acue=@Cod_acue

update St_T_Acuerdos set Cod_esta ='I' where Cod_Acue= @Cod_Acue
update St_t_Tarifario_Cubo set cod_Esta='I' where Cod_acue=@Cod_acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_All_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Copiar Todas las Tarifas
    Fecha       : 14/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_All_Tarifas]
AS
Declare @Cod_Acue_Orig int


declare C_Acuerdos  cursor for
select  Cod_Acue from St_t_Acuerdos where 
Cod_Acue>=13292 and Cod_Acue<=13444

open C_Acuerdos

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Acuerdos
into @Cod_Acue_orig

while @@fetch_status = 0
begin

exec Sp_St_Eliminar_Tarifa @Cod_Acue_orig


select @Cod_Acue_Orig
-- Avanzamos otro registro

fetch next from C_Acuerdos
into @Cod_Acue_orig
end 
-- cerramos el cursor
close C_Acuerdos
deallocate C_Acuerdos

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Procesos Aplicados
    Fecha       : 15/Dic/2005
   CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Aplica]
@cod_Aplp int
AS

delete St_T_Aplica where Cod_Aplp=@Cod_Aplp


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Asignacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Asignacion]
@Cod_Asig int
AS
delete St_T_Servicios_Asignados where Cod_asig = @Cod_Asig
delete St_T_Asignaciones where Cod_asig = @Cod_Asig

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Caracteristica_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Caracteristica de Acuerdo
    Fecha       : 01/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Caracteristica_Acuerdo]
@Cod_Acue int,
@Cod_Merc Smallint

AS
delete  from St_T_Caracteristicas_Acuerdo where Cod_Acue= @Cod_Acue  and Cod_Merc=@Cod_Merc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Caracteristica_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Caracteristica de Acuerdo
    Fecha       : 01/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Caracteristica_Combo]
@Cod_Comb int,
@Cod_Merc Smallint

AS
delete  from St_T_Caracteristicas_Combo where Cod_Comb= @Cod_Comb  and Cod_Merc=@Cod_Merc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Caracteristica_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Caracteristica de Tarifa
    Fecha       : 01/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Caracteristica_Tarifa]
@Cod_Tari int,
@Cod_Merc Smallint

AS
delete  from St_T_Caracteristicas_Acuerdo where Cod_Acue= @Cod_Tari  and Cod_Merc=@Cod_Merc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Acuerdo
    Fecha       : 09/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Combo]
@Cod_Comb int
AS
declare @sRuc char(11)

select top 1 @sRuc=contribuy from St_T_Combos where Cod_Comb= @Cod_Comb

delete  from St_T_Entidades_Combo where Cod_Comb= @Cod_Comb
delete  from St_T_Caracteristicas_Combo where Cod_Comb= @Cod_Comb
delete  from St_T_Servicios_Combo where Cod_Comb= @Cod_Comb
delete  from St_T_Combos where Cod_Comb= @Cod_Comb
exec Impo_Carga_Combo_Cliente @sRuc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Entidad]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Entidad.
    Fecha       : 24/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Entidad]
@cod_Enti smallint

AS

delete St_T_Entidades where Cod_Enti=@Cod_Enti


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Entidad_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Entidad de Acuerdo
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Entidad_Acuerdo]
@Cod_Acue int,
@Cod_Enti Smallint

AS
delete  from St_T_Entidades_Acuerdos where Cod_Acue= @Cod_Acue  and Cod_Enti=@Cod_Enti
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Entidad_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Entidad de Acuerdo
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Entidad_Combo]
@Cod_Comb int,
@Cod_Enti Smallint

AS
delete  from St_T_Entidades_Combo where Cod_Comb= @Cod_Comb  and Cod_Enti=@Cod_Enti
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Entidad_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Entidad de Tarifa
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Entidad_Tarifa]
@Cod_Tari int,
@Cod_Enti Smallint

AS
delete  from St_T_Entidades_Acuerdos where Cod_Acue= @Cod_Tari  and Cod_Enti=@Cod_Enti
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Factura_Ind]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Factura_Ind]

@ID integer

AS

 

delete tarifario.dbo.St_T_Facturas_Independientes

where ID=@Id

 

delete tarifario.dbo.St_T_Facturas_Independientes

where ID=@Id

 

 

SET NOCOUNT ON

 


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Caracteristicas de Mercaderia
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Mercaderia]
@Cod_Merc smallint

AS

delete from St_T_Caracteristicas_Mercaderia where Cod_Merc = @Cod_Merc

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Perfil]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Perfil
    Fecha       : 14/Dic/2005
   CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Perfil]
@cod_Perf int
AS

delete St_T_Perfil_Usuario where Cod_Perf=@Cod_Perf


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Servicio_Asignado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Servicio_Asignado]
@Cod_Seas int
AS

delete St_T_Servicios_Asignados where Cod_Seas = @Cod_Seas

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Servicio_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Servicio_Combo]
@Cod_Comb int,
@Dc_Servicio varchar(20)
AS
declare @res int,
@contribuy varchar(11)

delete  from St_T_Servicios_Combo where Cod_comb= @Cod_Comb  and Dc_Servicio=@Dc_Servicio
select @res=count(*) from St_T_Servicios_Combo where Cod_comb= @Cod_Comb  
If @res=0 
begin
            delete  from St_T_Entidades_Combo where Cod_Comb= @Cod_Comb
            delete  from St_T_Caracteristicas_Combo where Cod_Comb= @Cod_Comb 
end

select @Contribuy=contribuy from St_T_combos where Cod_Comb=@Cod_Comb
exec Impo_Carga_Combo_Cliente  @contribuy


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Eliminar_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Eliminar Tarifa en cascada con Entidades y caracteristicas de Tarifa
    Fecha       : 30/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Eliminar_Tarifa]
@Cod_Tari int
AS

delete  from St_T_Entidades_Acuerdos where Cod_Acue= @Cod_Tari 
delete  from St_T_Caracteristicas_Acuerdo where Cod_Acue= @Cod_Tari
delete  from St_T_Acuerdos where Cod_Acue= @Cod_Tari
delete St_T_Tarifario_Cubo where Cod_Acue=@Cod_Tari
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidad]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Lista entidad
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidad]
@Cod_Enti tinyint
AS

select * from  ST_T_Entidades where Cod_Enti = @Cod_enti

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidad_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidad_Acuerdo]
@Cod_enac int
AS
select * from St_V_Entidades_Acuerdos where cod_Enac= @Cod_enac
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidad_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 22/Nov/2005
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidad_Combo]
@Cod_enco  int
AS
select * from St_V_Entidades_Combo where cod_Enco= @Cod_enco
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidad_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de una determinada tarifa
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidad_Tarifa]
@Cod_enac int
AS
select * from St_V_Entidades_Tarifas where cod_Enac= @Cod_Enac
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar entidades 
    Fecha       : 19/Nov/2005
    JF.
*/

ALTER PROCEDURE [dbo].[Sp_St_Entidades]

AS

select * from  ST_V_Entidades order by des_enti

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Acuerdo_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Entidades_Acuerdo_Combo] 
@Cod_Acue int,
@Cod_Comb int
AS
/*select * from St_V_Entidades_Acuerdos_Combos where Cod_Acue=@Cod_Acue and Cod_Comb*/
select * from St_t_Entidades_Acuerdos  where Cod_Acue=@Cod_Acue and Cod_Enti not in (select Cod_Enti from St_t_Entidades_combo where Cod_Comb=@Cod_Comb)
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Acuerdos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidades_Acuerdos]
@Cod_Acue  int
AS
select * from St_V_Entidades_Acuerdos  where cod_acue=@Cod_Acue order by des_enti
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Acuerdos_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 25/May/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidades_Acuerdos_Cubo]
AS
select * from St_V_Entidades_Acuerdos
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidades_Combo]
@Cod_Comb  int
AS
select * from St_V_Entidades_Combo where cod_comb=@Cod_Comb
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar entidades 
    Fecha       : 25/May/2006
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Entidades_Cubo]

AS

select * from  ST_T_Entidades

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Sel]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar entidades 
    Fecha       : 11/May/2006
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Entidades_Sel]

AS

select * from  ST_V_Entidades where Tip_Enti=1 or Tip_Enti=5 order by des_enti

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Sin_Asignar]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplicaciones 
    Fecha       : 25/Nov/2005
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Entidades_Sin_Asignar]
@Cod_Acue int
AS

select * from  St_T_Entidades where Cod_enti not in (select Cod_enti from st_t_entidades_acuerdos where Cod_acue=@Cod_Acue)
order by Des_enti
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Sin_Asignar_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplicaciones 
    Fecha       : 25/Nov/2005
    PA.
*/

ALTER PROCEDURE [dbo].[Sp_St_Entidades_Sin_Asignar_Combo]
@Cod_Comb int
AS

select * from  St_T_Entidades where Cod_enti not in (select Cod_enti from st_t_entidades_Combo where Cod_Comb=@Cod_Comb)

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Entidades_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de una determinada tarifa
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Entidades_Tarifas]
@Cod_Acue  int
AS
select * from St_V_Entidades_Tarifas where cod_acue=@Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Estado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Lista Estado
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Estado]
@Cod_Esta char(1)
AS

select * from  ST_T_Estados where Cod_Esta = @Cod_Esta

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Estados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Estados
    Fecha       : 19/Nov/2005
    JF.
*/

ALTER PROCEDURE [dbo].[Sp_St_Estados]

AS

select * from  ST_V_Estados

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Exist_nuevo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Exist_nuevo]   
@Cod_Acue int  
  
AS  
  
Select Cod_Acue from St_T_Acuerdos where Cod_Ante=@Cod_Acue AND Cod_esta<>'I'

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Factura_Ind]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Sp_St_Factura_Ind]

@ID integer

AS

select * from St_V_Facturas_Independientes where Id=@ID

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Facturas_Ind]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Sp_St_Facturas_Ind]

AS

select * from St_V_Facturas_Independientes

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Acuerdo]
@Contribuy varchar(11),
@Dc_centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@Cod_Tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Ante int,
@cod_Aplc varchar(20),
@cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Tip_Valo char,
@Des_Seri varchar(50),
@Tar_Mini decimal(9,2),
@Tar_Maxi decimal(9,2),
@Val_Acus decimal(12,6),
@Tar_Mins decimal(9,2),
@Tar_Maxs decimal(9,2)


AS

declare @Cod_Acue int

-- Asignacion de null

If @Dc_Centro_Costo_A=0
	set @Dc_Centro_Costo_A=null
If @Dc_Sucursal_A=0 
	set @DC_Sucursal_A=null
If @Dc_Sucursal=0
	set @DC_Sucursal=null
If @cod_aplp =0
	set @Cod_aplp=null	
If @Contribuy=''
	set @Contribuy=null



select @Cod_Acue=max(Cod_Acue)+1 from St_T_Acuerdos
if @Cod_Acue = null 
   set  @Cod_Acue=1

If @cod_ante<>0
	insert St_T_Acuerdos(Cod_Acue,Contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Cod_tari,Des_Acue,Fec_Acti,Fec_Term,Usu_Acue,Val_Acue,Fec_Crea,Cod_Esta,Flg_inte,Flg_Tari,Cod_Ante,Cod_aplp,Dc_Centro_Costo_A,Dc_Sucursal_A,Tip_Valo,Des_Seri,Tar_Mini,Tar_Maxi,Val_Acus,Tar_Mins,Tar_Maxs) values(@Cod_Acue,@Contribuy,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@cod_tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,getdate(),'P',@Flg_inte,0,@Cod_Ante,@Cod_aplp,@Dc_Centro_Costo_A,@Dc_Sucursal_A,@Tip_Valo,@Des_Seri,@Tar_Mini,@Tar_Maxi,@Val_Acus,@Tar_Mins,@Tar_Maxs)
else	
	insert St_T_Acuerdos(Cod_Acue,Contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Cod_Tari,Des_Acue,Fec_Acti,Fec_Term,Usu_Acue,Val_Acue,Fec_Crea,Cod_Esta,Flg_inte,Flg_Tari,Cod_aplp,Dc_Centro_Costo_A,Dc_Sucursal_A,Tip_Valo,Des_Seri,Tar_Mini,Tar_Maxi,Val_Acus,Tar_Mins,Tar_Maxs) values(@Cod_Acue,@Contribuy,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@cod_tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,getdate(),'P',@Flg_inte,0,@Cod_aplp,@Dc_Centro_Costo_A,@Dc_Sucursal_A,@Tip_Valo,@Des_Seri,@Tar_Mini,@Tar_Maxi,@Val_Acus,@Tar_Mins,@Tar_Maxs)

select @Cod_Acue

SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Acuerdo_nuevo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Acuerdo_nuevo]
@Cod_Acue_Orig int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@cod_tari int,
@Des_Acue varchar(50),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Flg_inte tinyint,
@Cod_Aplc varchar(20),
@Cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Tip_Valo char,
@Des_Seri varchar(50),
@Tar_Mini decimal(12,6),
@Tar_Maxi decimal(12,6),
@Val_Acus decimal(12,6),
@Tar_Mins decimal(12,6),
@Tar_Maxs decimal(12,6)

AS

declare @Cod_Acue int

/*insert St_T_Acuerdos(Cod_Acue,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Des_Acue,Fec_Acti,Usu_Acue,Val_Acue,Tar_Mini,Tar_Maxi,Fec_Crea,Cod_Esta,Flg_Tari,Val_Proc,Flg_Proc,Flg_Apli) 
values(@Cod_Acue,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,@Fec_Acti,@Usu_Acue,@Val_Acue,@Tar_Mini,@Tar_Maxi,getdate(),'P',1,@Val_Proc,@Flg_Proc,@Flg_Apli)*/
exec Sp_St_Grabar_Acuerdo @Contribuy,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@cod_tari,@Des_Acue,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Flg_inte,@Cod_Acue_Orig,@Cod_aplc,@Cod_Aplp,@Dc_Centro_Costo_A,@Dc_Sucursal_A,@Tip_Valo,@Des_Seri,@Tar_Mini,@Tar_Maxi,@Val_Acus,@Tar_Mins, @Tar_Maxs
select @Cod_Acue=max(Cod_Acue) from St_T_Acuerdos

/*Iniciamos cursor */

Declare
@Val_enac varchar(100),
@Cod_Enti smallint,
@Des_Enac varchar(100)

declare C_Entidades cursor for
select Val_enac,Cod_enti,des_enac from St_T_entidades_acuerdos where Cod_Acue=@Cod_Acue_Orig

open C_Entidades

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac 

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Val_enac,@Des_Enac

-- Avanzamos otro registro

fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac 
end 
-- cerramos el cursor
close C_Entidades
deallocate C_Entidades


/* Caracteristicas Mercaderia */

Declare
@Val_meac varchar(100),
@Cod_merc smallint,
@Des_meac varchar(100)


declare C_Caracteristicas cursor for
select Val_meac,Cod_merc,des_meac from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_Acue_Orig

open C_Caracteristicas

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac 

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,@Cod_merc,@Val_meac,@Des_meac

-- Avanzamos otro registro

fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac 
end 
-- cerramos el cursor
close C_Caracteristicas
deallocate C_Caracteristicas

select @Cod_Acue
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Acuerdos_Cubo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Acuerdos_Cubo]
@Cod_Acue int,
@Contribuy varchar(11),
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Centro_Costo_a smallint,
@Dc_Sucursal_a smallint,
@Dc_Servicio varchar(20),
@Des_acue varchar(50),
@Val_acue decimal(12,6), --ANTES @Val_acue decimal(9,6)
@Tar_mini decimal(9,2),
@Tar_maxi decimal(9,2),
@Flg_Tari Tinyint,
@Flg_Inte Tinyint,
@Cod_aplc smallint,
@Cod_Aplp smallint,
@Tip_valo char,
@Cod_Esta char,
@Val_acus decimal(12,6),  --ANTES @Val_acus decimal(9,6)
@Tar_mins decimal(9,2),
@Tar_maxs decimal(9,2)

AS
-- Asignacion de null

If @Contribuy=''
            set @Contribuy=null
If @Dc_Centro_Costo_A=0
            set @Dc_Centro_Costo_A=null
If @Dc_Sucursal_A=0 
            set @DC_Sucursal_A=null
If @Dc_Sucursal=0
            set @DC_Sucursal=null
If @Cod_Aplp =0
            If @Cod_Aplc=0 
                Insert into  St_T_Tarifario_cubo(Cod_Acue,Contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Centro_Costo_a,Dc_Sucursal_a,Dc_Servicio,Des_acue,Val_acue,Tar_mini,Tar_maxi,Flg_Tari,Flg_Inte,Tip_valo,Cod_Esta,Val_Acus,Tar_Mins,Tar_maxs)
values(@Cod_Acue,@Contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Centro_Costo_a,@Dc_Sucursal_a,@Dc_Servicio,@Des_acue,@Val_acue,@Tar_mini,@Tar_maxi,@Flg_Tari,@Flg_Inte,@Tip_valo,@Cod_Esta,@Val_Acus,@Tar_mins,@Tar_maxs)
            Else
              Insert into  St_T_Tarifario_cubo(Cod_Acue,Contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Centro_Costo_a,Dc_Sucursal_a,Dc_Servicio,Des_acue,Val_acue,Tar_mini,Tar_maxi,Flg_Tari,Flg_Inte,Cod_aplc,Tip_valo,Cod_Esta,Val_Acus,Tar_Mins,Tar_maxs)
values(@Cod_Acue,@Contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Centro_Costo_a,@Dc_Sucursal_a,@Dc_Servicio,@Des_acue,@Val_acue,@Tar_mini,@Tar_maxi,@Flg_Tari,@Flg_Inte,@Cod_aplc,@Tip_valo,@Cod_Esta,@Val_Acus,@Tar_mins,@Tar_maxs)
else
            Insert into  ST_T_Tarifario_cubo(Cod_Acue,Contribuy,Dc_Centro_Costo,Dc_Sucursal,Dc_Centro_Costo_a,Dc_Sucursal_a,Dc_Servicio,Des_acue,Val_acue,Tar_mini,Tar_maxi,Flg_Tari,Flg_Inte,Cod_Aplp,Tip_valo,Cod_Esta,Val_Acus,Tar_Mins,Tar_maxs)
values(@Cod_Acue,@Contribuy,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Centro_Costo_a,@Dc_Sucursal_a,@Dc_Servicio,@Des_acue,@Val_acue,@Tar_mini,@Tar_maxi,@Flg_Tari,@Flg_Inte,@Cod_Aplp,@Tip_valo,@Cod_Esta,@Val_Acus,@Tar_mins,@Tar_maxs)

 



GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Procesos Aplicados
    Fecha       : 15/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Aplica]
@Des_Aplp  varchar(50)
AS

declare @Cod_Aplp smallint

select @Cod_Aplp=max(Cod_Aplp)+1 from St_T_Aplica
if @Cod_Aplp = null 
   set  @Cod_Aplp=1
insert St_T_Aplica(Cod_Aplp,Des_Aplp) values(@Cod_Aplp,@Des_Aplp)

select @Cod_Aplp

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Aplicacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Aplicacion 
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Aplicacion]
@Des_Apli  varchar(40)

AS

declare @Cod_Apli smallint

select @Cod_Apli=max(Cod_Apli)+1 from St_T_Aplicaciones
if @Cod_Apli= null 
   set  @Cod_Apli=1

insert St_T_Aplicaciones(Cod_Apli,Des_Apli) values(@Cod_Apli,@Des_Apli)
select @Cod_Apli
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Asignacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Asignacion]

@Dc_Centro_Costo smallint,

@Dc_Sucursal smallint,

@Dc_Servicio varchar(20),

@Tam_cont smallint,

@Cod_Line char(3),

@Cod_Depo tinyint,

@Es_Inte varchar(2),

@Otr_Line varchar(2),

@Tip_eval tinyint

AS

 

declare @Cod_Asig smallint

 

Select @Cod_Asig=max(Cod_Asig)+1 from St_T_Asignaciones

 

If isnull(@Cod_Asig,-1)=-1

   set  @Cod_Asig=1
--
 

insert St_T_Asignaciones(Cod_Asig,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Tam_Cont,Cod_line,Cod_Depo,es_Inte,Otr_Line,Tip_Eval) 

values(@Cod_Asig,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Tam_Cont,@Cod_line,@Cod_Depo,@Es_Inte,@Otr_Line,@Tip_Eval) 

 

select @Cod_asig

 

SET NOCOUNT ON

 



GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Caracteristica_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Caracteristica_Acuerdo]
@Cod_Acue int,
@Cod_Merc tinyint,
@Val_Meac varchar(100),
@Des_Meac varchar(100),
@Flg_Proc tinyint
AS

declare @Cod_Meac int

select @Cod_Meac=max(Cod_Meac)+1 from St_T_Caracteristicas_Acuerdo

if @Cod_Meac = null 
   set  @Cod_Meac=1

If @Des_Meac=''
	insert St_T_Caracteristicas_Acuerdo(Cod_Meac,Cod_Acue,Cod_Merc,Val_Meac,Flg_Proc) values(@Cod_Meac,@Cod_Acue,@Cod_Merc,@val_Meac,@Flg_Proc)
else
	insert St_T_Caracteristicas_Acuerdo(Cod_Meac,Cod_Acue,Cod_Merc,Val_Meac,Des_Meac,Flg_Proc) values(@Cod_Meac,@Cod_Acue,@Cod_Merc,@val_Meac,@Des_Meac,@Flg_Proc)
select @Cod_Meac
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Caracteristica_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Caracteristica por acuerdo
    Fecha       : 23/Nov/2005
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Caracteristica_Combo]
@Cod_Comb int,
@Cod_Merc tinyint,
@Val_Caco varchar(100),
@Des_Caco varchar(100)

AS

declare @Cod_Caco int

select @Cod_Caco=max(Cod_Caco)+1 from St_T_Caracteristicas_Combo

if @Cod_Caco = null 
   set  @Cod_Caco=1

If @Des_Caco=''
	insert St_T_Caracteristicas_Combo(Cod_Caco,Cod_Comb,Cod_Merc,Val_Caco) values(@Cod_Caco,@Cod_Comb,@Cod_Merc,@val_Caco)
else
	insert St_T_Caracteristicas_Combo(Cod_Caco,Cod_Comb,Cod_Merc,Val_Caco,Des_Caco) values(@Cod_Caco,@Cod_Comb,@Cod_Merc,@val_caco,@Des_Caco)
select @Cod_Caco
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Caracteristica_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Caracteristica por Tarifa
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Caracteristica_Tarifa]
@Cod_Acue int,
@Cod_Merc tinyint,
@Val_Meac varchar(100),
@Des_Meac varchar(100),
@Flg_Proc tinyint

AS

declare @Cod_Meac int

select @Cod_Meac=max(Cod_Meac)+1 from St_T_Caracteristicas_Acuerdo

if @Cod_Meac = null 
   set  @Cod_Meac=1

If @Des_Meac=''
	insert St_T_Caracteristicas_Acuerdo(Cod_Meac,Cod_Acue,Cod_Merc,Val_Meac,Flg_Proc) values(@Cod_Meac,@Cod_Acue,@Cod_Merc,@val_Meac,@Flg_Proc)
else
	insert St_T_Caracteristicas_Acuerdo(Cod_Meac,Cod_Acue,Cod_Merc,Val_Meac,Des_Meac,Flg_Proc) values(@Cod_Meac,@Cod_Acue,@Cod_Merc,@val_Meac,@Des_Meac,@Flg_Proc)
select @Cod_Meac
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Combo]

@Tip_Comb char,

@Nom_Comb varchar(70),

@Contribuy varchar(11)

AS

 

declare @Cod_Comb int

 

Select @Cod_Comb=max(Cod_Comb)+1 from St_T_Combos

 

If isnull(@Cod_Comb,-1)=-1

   set  @Cod_Comb=1

 

insert St_T_Combos(Cod_Comb,Tip_comb,Nom_comb,Contribuy) 

values(@Cod_comb,@Tip_Comb,@Nom_comb,@Contribuy)

exec Impo_Carga_Combo_Cliente @Contribuy

select @Cod_comb

 

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Entidad]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Entidad
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Entidad]
@Des_Enti  varchar(50),
@Tip_Enti smallint,
@Val_Enti Varchar(100),
@Tam_Enti int,
@flg_apli tinyint

AS

declare @Cod_Enti smallint

select @Cod_enti=max(Cod_Enti)+1 from St_T_Entidades
if @Cod_enti = null 
   set  @Cod_enti=1
insert St_T_Entidades(Cod_Enti,Des_Enti,Tip_Enti,Val_Enti,tam_enti,flg_apli) values(@Cod_Enti,@Des_Enti,@Tip_Enti,@Val_Enti,@Tam_enti,@flg_apli)

select @Cod_Enti

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Entidad_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Acuerdo
    Fecha       : 09/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Entidad_Acuerdo]
@Cod_Acue int,
@Cod_Enti tinyint,
@Val_Enac varchar(100),
@Des_Enac varchar(100),
@Flg_proc tinyint
AS

declare @Cod_Enac int

select @Cod_Enac=max(Cod_Enac)+1 from St_T_Entidades_Acuerdos

if @Cod_Enac = null 
   set  @Cod_Enac=1

If @Des_Enac=''
	insert St_T_Entidades_Acuerdos(Cod_Enac,Cod_Acue,Cod_Enti,Val_Enac,Flg_Proc) values(@Cod_Enac,@Cod_Acue,@Cod_Enti,@val_Enac,@Flg_Proc)
else
	insert St_T_Entidades_Acuerdos(Cod_Enac,Cod_Acue,Cod_Enti,Val_Enac,Des_Enac,Flg_Proc) values(@Cod_Enac,@Cod_Acue,@Cod_Enti,@val_Enac,@Des_Enac,@Flg_Proc)
select @Cod_Enac

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Entidad_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Combo
    Fecha       : 08/06/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Entidad_Combo]
@Cod_Comb int,
@Cod_Enti tinyint,
@Val_Enco varchar(100),
@Des_Enco varchar(100)

AS

declare @Cod_Enco int

select @Cod_Enco=max(Cod_Enco)+1 from St_T_Entidades_Combo

if isnull(@Cod_Enco,-1) = -1
   set  @Cod_Enco=1

If @Des_Enco=''
	insert St_T_Entidades_Combo(Cod_Enco,Cod_comb,Cod_Enti,Val_Enco) values(@Cod_Enco,@Cod_comb,@Cod_Enti,@val_Enco)
else
	insert St_T_Entidades_Combo(Cod_Enco,Cod_Comb,Cod_Enti,Val_Enco,Des_Enco) values(@Cod_Enco,@Cod_Comb,@Cod_Enti,@val_Enco,@Des_Enco)
select @Cod_Enco
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Entidad_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Tarifas
    Fecha       : 26/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Entidad_Tarifa]
@Cod_Acue int,
@Cod_Enti tinyint,
@Val_Enac varchar(100),
@Des_Enac varchar(100),
@Flg_Proc tinyint

AS

declare @Cod_Enac int

select @Cod_Enac=max(Cod_Enac)+1 from St_T_Entidades_Acuerdos

if @Cod_Enac = null 
   set  @Cod_Enac=1

If @Des_Enac=''
	insert St_T_Entidades_Acuerdos(Cod_Enac,Cod_Acue,Cod_Enti,Val_Enac,Flg_Proc) values(@Cod_Enac,@Cod_Acue,@Cod_Enti,@val_Enac,@Flg_Proc)
else
	insert St_T_Entidades_Acuerdos(Cod_Enac,Cod_Acue,Cod_Enti,Val_Enac,Des_Enac,Flg_Proc) values(@Cod_Enac,@Cod_Acue,@Cod_Enti,@val_Enac,@Des_Enac,@Flg_Proc)
select @Cod_Enac
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Estado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Estado
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Estado]

@Des_Esta  varchar(40)

AS

declare @Cod_Esta  char

/*select @Cod_esta=max(Cod_Esta)+1 from St_T_Estados
if @Cod_Esta= null 
   set  @Cod_Esta=1*/

insert St_T_Estados(Cod_Esta,Des_Esta) values(@Cod_Esta,@Des_Esta)
select @Cod_Esta
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Factura_Ind]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Factura_Ind]

@Contribuy varchar(11),

@Dc_Servicio varchar(20)

AS

 

declare @ID int

 

select @Id =max(Id)+1 from St_T_Facturas_Independientes

 

if isnull(@Id,-1) = -1

   set  @ID=1

 

insert tarifario.dbo.St_T_Facturas_Independientes(ID,Dc_servicio,contribuy) values(@Id,@Dc_servicio,@Contribuy)

insert tarifario.dbo.St_T_Facturas_Independientes(ID,Dc_servicio,contribuy) values(@Id,@Dc_servicio,@Contribuy)

 

select @ID

 

SET NOCOUNT ON

 


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Caracteristicas de Mercaderia
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Mercaderia]
@Des_Merc varchar(50),
@Tip_Cara smallint,
@Val_Merc Varchar(100),
@Tam_Merc smallint,
@flg_apli tinyint

AS

declare @Cod_Merc smallint

select @Cod_Merc=max(Cod_Merc)+1 from St_T_Caracteristicas_Mercaderia
if @Cod_Merc= null 
   set  @Cod_Merc=1


	insert St_T_Caracteristicas_Mercaderia (Cod_Merc,Des_Merc,Tip_Cara,Val_Merc,Tam_Merc,flg_apli) values(@Cod_Merc,@Des_Merc,@Tip_Cara,@Val_Merc,@Tam_Merc,@flg_apli)


select @Cod_Merc
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Perfil]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Perfil
    Fecha       : 14/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Perfil]
@Des_Perf  varchar(50),
@des_porc decimal
AS

declare @Cod_Perf smallint

select @Cod_Perf=max(Cod_Perf)+1 from St_T_Perfil_Usuario
if @Cod_Perf = null 
   set  @Cod_Perf=1
insert St_T_Perfil_Usuario(Cod_Perf,Des_Perf,des_porc) values(@Cod_Perf,@Des_Perf,@des_porc)

select @Cod_perf

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Servicio_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar entidades por Acuerdo
    Fecha       : 22/Nov/2005
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Servicio_Combo]
@Cod_Comb int,
@Dc_Servicio varchar(20),
@Cod_Acue int,
@Val_Seco decimal(9,2)
AS

declare 
@Cod_Seco int,
@Contribuy varchar(11)

select @Cod_Seco=max(Cod_Seco)+1 from St_T_Servicios_Combo

if isnull(@Cod_Seco,-1) = -1
   set  @Cod_Seco=1

insert St_T_Servicios_Combo(Cod_Seco,Cod_Comb,Dc_Servicio,Cod_Acue,Val_Seco) values(@Cod_Seco,@Cod_Comb,@Dc_Servicio,@Cod_Acue,@Val_Seco)


select @Contribuy=contribuy from St_T_combos where Cod_Comb=@Cod_Comb

exec Impo_Carga_Combo_Cliente  @contribuy

select @Cod_Seco
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Servicios_Asignados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[Sp_St_Grabar_Servicios_Asignados]
@Cod_Asig smallint,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@por_asig  decimal(9,2)

AS

declare @Cod_Seas smallint

Select @Cod_Seas=max(Cod_Seas)+1 from St_T_Servicios_Asignados

If isnull(@Cod_Seas,-1)=-1
   set  @Cod_Seas=1

insert St_T_Servicios_Asignados(Cod_seas,Cod_Asig,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Por_asig) 
values(@Cod_Seas,@Cod_Asig,@Dc_Centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Por_Asig) 

select @Cod_seas

SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Sucursal
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Sucursal]
@Dg_Sucursal smallint


AS

declare @Dc_Sucursal smallint

select @Dc_sucursal=max(Dc_sucursal)+1 from St_V_sucursal
if @Dc_sucursal= null 
   set  @Dc_Sucursal=1

	insert St_V_sucursal(Dc_sucursal,Dg_Sucursal) values(@Dc_sucursal,@Dg_Sucursal)

	select @Dc_Sucursal

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Tarifa
    Fecha       : 24/Abr/2006
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Tarifa]

@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@Des_Acue varchar(50),
@Tip_Apli varchar(20),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Tar_Mini Decimal(12,6),
@Tar_Maxi Decimal(12,6),
@Val_Proc Decimal(12,6),
@Flg_Proc char(1),
@Flg_Apli tinyint,
@Cod_Ante int,
@Cod_Aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Val_Acus decimal(12,6),
@Tar_Mins decimal(12,6),
@Tar_Maxs decimal(12,6),
@Val_Pros decimal(12,6)
AS

declare @Cod_Acue int

select @Cod_Acue=max(Cod_Acue)+1 from St_T_Acuerdos
if @Cod_Acue = null 
   set  @Cod_Acue=1



If @Dc_Centro_Costo_A=0
	set @Dc_Centro_Costo=null
If @Dc_Sucursal_A=0 
	set @DC_Sucursal_A=null
If @Dc_Sucursal=0
	set @DC_Sucursal=null

If @cod_ante<>0
	insert St_T_Acuerdos(Cod_Acue,Dc_Centro_Costo_A,Dc_Sucursal_A,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Des_Acue,Fec_Crea,Fec_Acti,Fec_Term,Usu_Acue,Cod_Esta,Val_Acue,Val_Proc,Tar_Mini,Tar_Maxi,Flg_Proc,Flg_Apli,Flg_Tari,Cod_Ante,cod_aplp,Val_Acus,Tar_Mins,Tar_Maxs,Val_Pros) values(@Cod_Acue, @Dc_centro_Costo_A,@Dc_Sucursal_A,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,getdate(),@Fec_Acti,@Fec_Term,@Usu_Acue,'P',@Val_Acue,@Val_Proc,@Tar_Mini,@Tar_Maxi,@Flg_Proc,@Flg_Apli,1,@Cod_Ante,@cod_aplp,@Val_Acus,@Tar_Mins,@Tar_Maxs,@Val_Pros)
else
	insert St_T_Acuerdos(Cod_Acue,Dc_Centro_Costo_A,Dc_Sucursal_A,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Des_Acue,Fec_Crea,Fec_Acti,Fec_Term,Usu_Acue,Val_Acue,Tar_Mini,Tar_Maxi,Cod_Esta,Flg_Tari,Flg_Apli,Cod_aplp,Val_Acus,Tar_Mins,Tar_Maxs,Val_Pros) values(@Cod_Acue,@Dc_centro_Costo_A,@Dc_Sucursal_A,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,getdate(),@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@Tar_Mini,@Tar_Maxi,'P',1,0,@Cod_Aplp,@Val_Acus,@Tar_Mins,@Tar_Maxs,@Val_Pros)
select @Cod_Acue
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Tarifa_Impo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Tarifa Importaciones
    Fecha       : 06/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Tarifa_Impo]
@codtar13 INT,
@desimp13 char(60),
@valser13 float,
@aplica13 char(1),
@tarmin13 float,
@estado13 char(1),
@codusu17 char(15),
@tarmax13 float,
@finvig13 datetime,
@sucursal char(2),
@codsbd03 char(5),
@flg_Tari tinyint,
@Dc_Centro_costo tinyint,
@Contribuy varchar(11),
@Cod_Tari int,
@Nrosec21 int
AS

declare @Cod_Acue int,
@cod_aplc smallint,
@Tip_aplc char,
@Cod_aplp smallint

select @Cod_Acue=max(Cod_Acue)+1 from St_T_Acuerdos
if @Cod_Acue = null 
   set  @Cod_Acue=1

select @Cod_aplc=Cod_Enti, @Tip_aplc=Tip_enti,@Cod_aplp=cod_aplp from tr_tmp_aplicacion where cod_apli=@aplica13

If @Tip_Aplc = null 
	insert St_T_Acuerdos  (Cod_Tar13,Dc_Sucursal,Dc_Servicio,Des_Acue,Val_Acue,Usu_Acue,Tar_Mini,Tar_Maxi,Flg_Tari,Cod_Aplp,Cod_Acue,Dc_Centro_Costo,Fec_Crea,Fec_Acti,cod_esta,contribuy,cod_tari,nro_sec21) values (@codtar13, @sucursal, @codsbd03, @desimp13, @valser13,@codusu17,  @tarmin13,@tarmax13,@Flg_Tari, @Cod_aplp,@Cod_Acue,@Dc_Centro_Costo,getdate(),getdate(), @estado13,@contribuy,@Cod_Tari,@Nrosec21)
else
	insert St_T_Acuerdos  (Cod_Tar13,Dc_Sucursal,Dc_Servicio,Des_Acue,Val_Acue,Usu_Acue,Tar_Mini,Tar_Maxi,Flg_Tari,tip_aplc,cod_aplc,Cod_Acue,Dc_Centro_Costo,Fec_Crea,Fec_Acti,cod_esta,contribuy,Cod_Tari,nro_sec21) values (@codtar13, @sucursal, @codsbd03, @desimp13, @valser13,@codusu17,  @tarmin13,@tarmax13,@Flg_Tari, @tip_aplc,@cod_aplc,@Cod_Acue,@Dc_Centro_Costo,getdate(),getdate(), @estado13,@Contribuy,@Cod_Tari,@nrosec21)

select @Cod_Acue
SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_Tarifa_nuevo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Tarifa Nuevo
    Fecha       : 24/Abr/2006
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_Tarifa_nuevo]
@Cod_Acue_Orig int,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio varchar(20),
@Des_Acue varchar(50),
@Tip_Apli varchar(20),
@Fec_Acti smalldatetime,
@Fec_Term smalldatetime,
@Usu_Acue varchar(20),
@Val_Acue decimal(12,6),
@Val_Proc Decimal(12,6),
@Tar_Mini Decimal(12,6),
@Tar_Maxi Decimal(12,6),
@Flg_Proc char,
@Flg_Apli tinyint,
@Cod_aplp tinyint,
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Val_Acus decimal(12,6),
@Tar_Mins Decimal(12,6),
@Tar_Maxs Decimal(12,6),
@Val_Pros Decimal(12,6)


AS

declare @Cod_Acue int

If @Dc_Centro_Costo_A=0
	set @Dc_Centro_Costo=null
If @Dc_Sucursal_A=0 
	set @DC_Sucursal_A=null
If @Dc_Sucursal=0
	set @DC_Sucursal=null

/*insert St_T_Acuerdos(Cod_Acue,Dc_Centro_Costo,Dc_Sucursal,Dc_Servicio,Des_Acue,Fec_Acti,Usu_Acue,Val_Acue,Tar_Mini,Tar_Maxi,Fec_Crea,Cod_Esta,Flg_Tari,Val_Proc,Flg_Proc,Flg_Apli) 
values(@Cod_Acue,@Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,@Fec_Acti,@Usu_Acue,@Val_Acue,@Tar_Mini,@Tar_Maxi,getdate(),'P',1,@Val_Proc,@Flg_Proc,@Flg_Apli)*/
exec Sp_St_Grabar_Tarifa @Dc_centro_Costo,@Dc_Sucursal,@Dc_Servicio,@Des_Acue,@tip_apli,@Fec_Acti,@Fec_Term,@Usu_Acue,@Val_Acue,@val_Proc,@Tar_Mini,@Tar_Maxi, @Flg_proc,@flg_Apli, @Cod_Acue_Orig,@Cod_aplp,@Dc_centro_Costo_A,@Dc_Sucursal_A,@Val_Acus,@Tar_Mins,@Tar_Maxs,@Val_Pros
select @Cod_Acue=max(Cod_Acue) from St_T_Acuerdos



/*Iniciamos cursor */

Declare
@Val_enac varchar(100),
@Cod_Enti smallint,
@Des_Enac varchar(100),
@Flg_Procd tinyint

declare C_Entidades cursor for
select Val_enac,Cod_enti,des_enac,Flg_proc from St_T_entidades_acuerdos where Cod_Acue=@Cod_Acue_Orig

open C_Entidades

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Procd

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Entidad_Acuerdo  @Cod_Acue,@Cod_Enti,@Val_enac,@Des_Enac,@Flg_Procd

-- Avanzamos otro registro

fetch next from C_Entidades
into @Val_enac,@Cod_enti,@des_enac,@Flg_Procd
end 
-- cerramos el cursor
close C_Entidades
deallocate C_Entidades


/* Caracteristicas Mercaderia */

Declare
@Val_meac varchar(100),
@Cod_merc smallint,
@Des_meac varchar(100)


declare C_Caracteristicas cursor for
select Val_meac,Cod_merc,des_meac,Flg_Proc from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_Acue_Orig

open C_Caracteristicas

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Procd

while @@fetch_status = 0
begin

exec Sp_St_Grabar_Caracteristica_Acuerdo  @Cod_Acue,@Cod_merc,@Val_meac,@Des_meac,@Flg_Procd

-- Avanzamos otro registro

fetch next from C_caracteristicas
into @Val_meac,@Cod_merc,@des_meac,@Flg_Procd
end 
-- cerramos el cursor
close C_Caracteristicas
deallocate C_Caracteristicas

select @Cod_Acue
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Grabar_usuarios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar un nuevo usuario
    Fecha       : 13/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Grabar_usuarios]
@nom_usua varchar(20),
@pas_usua varchar(20),
@flg_perf tinyint
AS

insert into st_t_usuarios (nom_usua,pas_usua,cod_perf) values (@nom_usua,@pas_usua,@flg_perf)
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Lineas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Lineas como entidades
    Fecha       : 22/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Lineas]

AS

select * from  St_V_Lineas

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[sp_st_ListaAcuerdosxLineaServicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER PROCEDURE [dbo].[sp_st_ListaAcuerdosxLineaServicio]
@Servicio varchar(8),
@linea varchar(4)
as
select 
a.cod_acue,
e.contribuy,
e.nombre,
c.dc_sucursal,
c.dg_sucursal,
d.dc_centro_costo,
d.dg_centro_costo,
A.DES_ACUE,
case when f.dc_moneda_servicio = '2' then 'Dolares'
else 'Soles' end Moneda,
a.val_acus as Soles,
a.val_acue as Dolares,
f.dg_servicio,
b.val_enac,
g.desarm10
from st_t_acuerdos as a 
inner join St_T_Entidades_Acuerdos as b on a.cod_acue = b.cod_acue
inner join TMTIEN as c on a.dc_sucursal = c.dc_sucursal 
inner join TTUNID_NEGO  as d on a.dc_centro_costo = d.dc_centro_costo 
inner join TTSERV as f on a.dc_servicio = f.dc_servicio COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN terminal.dbo.dqarmado10 as g on b.val_enac = g.codarm10 COLLATE SQL_Latin1_General_CP1_CI_AS
left join terminal.dbo.aaclientesaa as e  on a.contribuy = e.contribuy COLLATE SQL_Latin1_General_CP1_CI_AS
where b.cod_enti =  6 and  b.val_enac = @linea
and a.dc_servicio in (@Servicio)
and a.cod_esta in ('P', 'A')
return 0

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Caracteristicas de Mercaderia
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Mercaderia]
@Cod_Merc tinyint
AS

select * from  St_T_Caracteristicas_Mercaderia where Cod_Merc = @Cod_Merc

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Mercaderias]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Caracteristicas de Mercaderias
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Mercaderias]

AS

select * from  ST_V_Mercaderias

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Mservicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Mservicios] AS
SELECT    *
FROM         St_V_NServicios
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Parametros]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devuelve Parametros
    Fecha       : 19/Dic/2005
    CA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Parametros]

AS

select Mes_Term from  St_T_Valores

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Pase_Combos_Antiguos]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[Sp_St_Pase_Combos_Antiguos] 
--AS
----Declare  @Ultimo int


--delete descarga.dbo.aaserint where isnull(Codcomb,-1)>-1 
----select @ultimo = max(CodComb)  from descarga.dbo.aaserint

--insert into descarga.dbo.aaserint(nrocombo,contribuy,sucursal,sistema,concepto,glosa,fecha,usuario,Codcomb)
--select  Cod_comb,contribuy,'2',2,codcon14, 'SERVICIO LOGISTICO DE EXPORTACION',getdate(),'NT',Cod_Comb from St_V_Carga_combos_Antiguos where cod_comb>0  order by Cod_comb
--GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Perfil]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Lista Perfil
    Fecha       : 14/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Perfil]
@Cod_Perf  int
AS

select * from  ST_T_Perfil_usuario where Cod_Perf = @Cod_Perf

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Perfiles]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Perfiles
    Fecha       : 14/Dic/2005
    CM.
*/

ALTER PROCEDURE [dbo].[Sp_St_Perfiles]

AS

select * from  ST_V_Perfiles

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Procesar_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Procesar Acuerdo
    Fecha       : 02/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Procesar_Acuerdo]
@Cod_Acue int,
@Tip_Proc char(1)
AS

Declare @Cod_ante int
If @Tip_Proc='A'
Begin

	select @Cod_ante=Cod_ante from St_T_Acuerdos where Cod_acue=@cod_Acue

	Update St_T_Acuerdos 
	SET  Cod_Esta='A', Fec_Apro=getdate()
	WHERE (Cod_Acue=@Cod_Acue)


	Update St_T_Acuerdos 
	SET  Cod_esta='I',Fec_Term=Getdate()
	WHERE (Cod_Acue=@Cod_ante)

	-- Cambio 19-07-06 Actualiza el nuevo acuerdo dentro de los combos
	Update st_t_servicios_combo set Cod_Acue=@Cod_Acue where Cod_Acue=@Cod_Ante

	Update St_T_Tarifario_Cubo 
	SET  Cod_Esta='A'
	WHERE (Cod_Acue=@Cod_Acue)


	Update St_T_Tarifario_Cubo 
	SET  Cod_esta='I'
	WHERE (Cod_Acue=@Cod_ante)

end
else
begin
	Update St_T_Acuerdos 
	SET  Cod_Esta='R', Fec_Apro=getdate(), Fec_Term=getdate()
	WHERE (Cod_Acue=@Cod_Acue)
end

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Procesar_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Procesar Tarifa
    Fecha       : 02/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Procesar_Tarifa]
@Cod_Acue int,
@Tip_Proc char(1)
AS

Declare 
@Cod_ante int,
@Flg_Proc char(1),
@Val_Proc decimal(12,6),
@Flg_Apli tinyint

If @Tip_Proc='A'
Begin

	select @Cod_ante=Cod_ante,@Flg_Proc=Flg_Proc, @Val_Proc =Val_Proc from St_T_Acuerdos where Cod_acue=@cod_Acue

	If isnull(@val_proc,-1)=-1
		set @Val_Proc=0
	If isnull(@Cod_ante,0)=0
		set @cod_Ante=0


	If @Flg_Proc='+'
		Update St_T_Acuerdos 	SET  Cod_Esta='A', Fec_Apro=getdate(), Val_Acue=Val_Acue+isnull(Val_Proc,0),Val_Proc=0 WHERE (Cod_Acue=@Cod_Acue)
	Else
		Update St_T_Acuerdos 	SET  Cod_Esta='A', Fec_Apro=getdate(), Val_Acue=Val_Acue-isnull(Val_Proc,0),Val_Proc=0	WHERE (Cod_Acue=@Cod_Acue)


	-- Actualizacion del monto en St_T_Acue	
	If @Flg_Proc='+'
		Update St_T_Tarifario_cubo SET  Cod_Esta='A',Val_Acue=Val_Acue+@Val_Proc  WHERE (Cod_Acue=@Cod_Acue)
	Else
		Update St_T_Tarifario_cubo  SET  Cod_Esta='A',  Val_Acue=Val_Acue-@Val_Proc WHERE (Cod_Acue=@Cod_Acue)


	Update St_T_Acuerdos  	SET  Cod_esta='I',Fec_Term=Getdate() 	WHERE (Cod_Acue=@Cod_ante)


	-- Cambio 19-07-06 Actualiza el nuevo acuerdo dentro de los combos
	Update st_t_servicios_combo set Cod_Acue=@Cod_Acue where Cod_Acue=@Cod_Ante

	Update St_T_Tarifario_Cubo 
	SET  Cod_Esta='A'
	WHERE (Cod_Acue=@Cod_Acue)


	Update St_T_Tarifario_Cubo 
	SET  Cod_esta='I'
	WHERE (Cod_Acue=@Cod_ante)

	--Termino cambio 19-07-06

	Update St_T_Acuerdos  	SET Cod_Tari=@Cod_acue where Cod_Tari=@Cod_ante

	If @Flg_Apli <>0
	BEGIN

		If @Flg_Proc='+'
			BEGIN
				Update St_T_Acuerdos  	SET Val_Acue=Val_Acue+@Val_Proc where Cod_Tari=@Cod_acue and Val_Acue>0

				Update ST_V_TARIFARIO_CUBO_ACT SET Val_Acue=Val_Acue+@Val_Proc where Cod_Tari=@Cod_Acue and Val_Acue>0

			END
		Else
			BEGIN
				Update St_T_Acuerdos  	SET Val_Acue=Val_Acue-@Val_Proc  where Cod_Tari=@Cod_Acue and Val_Acue>0

				Update ST_V_TARIFARIO_CUBO_ACT SET Val_Acue=Val_Acue-@Val_Proc  where Cod_Tari=@Cod_Acue and Val_Acue>0
			END
	END
	
end
else
begin
	Update St_T_Acuerdos 
	SET  Cod_Esta='R', Fec_Apro=getdate(), Fec_Term=getdate()
	WHERE (Cod_Acue=@Cod_Acue)

	Update ST_T_TARIFARIO_CUBO 
	SET  Cod_Esta='R' 
	WHERE (Cod_Acue=@Cod_Acue)
end

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Procesar_Tipo_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar Tipo de Servicio
    Fecha       : 12/Jun/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Procesar_Tipo_Servicio]
@Dc_Servicio varchar(20),
@Dc_Centro_Costo_Imputacion smallint,
@Dc_Sucursal_imputacion smallint,
@Flg_Serv tinyint,
@Flg_SerT tinyint,
@Flg_SerA tinyint,
@Flg_0 tinyint


AS

--Cuando tiene valor

if @Flg_0 = 0
BEGIN
	DELETE FROM St_T_Tipo_Servicio
	where Dc_Servicio=@Dc_Servicio and Dc_Centro_Costo=@Dc_Centro_Costo_Imputacion and Dc_Sucursal=@Dc_Sucursal_imputacion

	INSERT St_T_Tipo_Servicio(Dc_Servicio,Dc_Centro_Costo,Dc_Sucursal,Flg_Serv,Flg_SerT,Flg_SerA) values(@Dc_Servicio,@Dc_Centro_Costo_Imputacion,@Dc_Sucursal_imputacion,@Flg_Serv,@Flg_SerT,@Flg_SerA)

END

--Cuando es ninguno.

ELSE
	DELETE FROM St_T_Tipo_Servicio
	where Dc_Servicio=@Dc_Servicio and Dc_Centro_Costo=@Dc_Centro_Costo_Imputacion and Dc_Sucursal=@Dc_Sucursal_imputacion
SET NOCOUNT ON

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Servicio 
    Fecha       : 19/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Servicio]
@Dc_Centro_Costo_Imputacion smallint,
@Dc_Sucursal_Imputacion smallint,
@Dc_Servicio smallint

AS	
select * from St_V_Tb_Servicios where Dc_Centro_Costo_Imputacion = @Dc_Centro_Costo_Imputacion and
Dc_Sucursal_Imputacion = @Dc_Sucursal_Imputacion and Dc_Servicio =@Dc_Servicio

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicio_Asignado]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_St_Servicio_Asignado]
@Cod_Seas smallint
AS

select * from St_v_Servicios_Asignados where Cod_Seas=@Cod_Seas

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : listar Servicios segun parametros 
    Fecha       : 19/Nov/2005
   CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Servicios]
@Dc_Centro_Costo_Imputacion smallint,
@Dc_Sucursal_Imputacion smallint,
@Dc_Moneda_Servicio smallint

AS	

If @Dc_Centro_Costo_Imputacion>-1 and @Dc_Sucursal_Imputacion>0  and @Dc_Moneda_Servicio >0  
	select * from St_V_Tb_Servicios where Dc_Centro_Costo_Imputacion = @Dc_Centro_Costo_Imputacion and
	Dc_Sucursal_Imputacion = @Dc_Sucursal_Imputacion and Dc_Moneda_servicio =@Dc_Moneda_servicio


If @Dc_Centro_Costo_Imputacion>-1 and @Dc_Sucursal_Imputacion>0  and @Dc_Moneda_Servicio =0  
	select * from St_V_Tb_Servicios where Dc_Centro_Costo_Imputacion = @Dc_Centro_Costo_Imputacion and
	Dc_Sucursal_Imputacion = @Dc_Sucursal_Imputacion 

If @Dc_Centro_Costo_Imputacion>-1 and @Dc_Sucursal_Imputacion=0  and @Dc_Moneda_Servicio =0  
	select * from St_V_Tb_Servicios where Dc_Centro_Costo_Imputacion = @Dc_Centro_Costo_Imputacion 

If @Dc_Centro_Costo_Imputacion=-1 and @Dc_Sucursal_Imputacion=0  and @Dc_Moneda_Servicio =0  
	select * from St_V_Tb_Servicios 

If @Dc_Centro_Costo_Imputacion=-1 and @Dc_Sucursal_Imputacion=0  and @Dc_Moneda_Servicio >0  
	select * from St_V_Tb_Servicios where Dc_Moneda_servicio =@Dc_Moneda_servicio


If @Dc_Centro_Costo_Imputacion=-1 and @Dc_Sucursal_Imputacion>0  and @Dc_Moneda_Servicio >0  
	select * from St_V_Tb_Servicios where Dc_Sucursal_Imputacion = @Dc_Sucursal_Imputacion and  Dc_Moneda_servicio =@Dc_Moneda_servicio

If @Dc_Centro_Costo_Imputacion>-1 and @Dc_Sucursal_Imputacion=0  and @Dc_Moneda_Servicio >0  
	select * from St_V_Tb_Servicios where Dc_Centro_Costo_Imputacion=@Dc_Centro_Costo_Imputacion and Dc_Moneda_servicio =@Dc_Moneda_servicio

If @Dc_Centro_Costo_Imputacion=-1 and @Dc_Sucursal_Imputacion>0  and @Dc_Moneda_Servicio =0  
	select * from St_V_Tb_Servicios where Dc_Sucursal_Imputacion = @Dc_Sucursal_Imputacion 



SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicios_Asignados]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_St_Servicios_Asignados]
@Cod_Asig smallint
AS

select * from St_v_Servicios_Asignados where Cod_Asig=@Cod_Asig

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicios_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una entidad de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Servicios_Combo]
@Cod_Comb  int
AS
select * from St_V_Servicios_Combo where cod_comb=@Cod_Comb
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Servicios_Combo_Evaluacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las tarifas y acuerdos de los combos.
    Fecha       : 11/06/2006
   PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Servicios_Combo_Evaluacion]
AS

	select * from  St_V_Servicios_Combo_Tipo order by cod_comb,Cod_Acue

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devuelve Sucursal
    Fecha       : 21/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Sucursal]
@Dc_sucursal smallint
AS

select * from  ST_V_Sucursal where Dc_Sucursal = @dc_sucursal

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Sucursales]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Sucursales
    Fecha       : 22/Nov/2005
   JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Sucursales]
AS

select * from  St_V_sucursal

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tarifa]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Tarifas con parametro del Codigo del Acuerdo
    Fecha       : 26/Nov/2005
    CM.
*/ALTER PROCEDURE [dbo].[Sp_St_Tarifa]
@Cod_Tari int
AS

select * from St_V_Tarifas where Cod_Acue=@Cod_Tari


SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tarifas_por_Vencer]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Paul Acero  
    Proposito  : Devuelve los acuerdos que estan por vencer para enviarselos por mail.  
    Fecha       : 05/09/2006  
    PA.  
*/  
  
/*  
Mensaje : Estimado Usuario faltan X dias para que el "Acuerdo" o "Tarifa de Lista" (Depende del campo Flg_Tari) del Cliente "Tal" con codigo "Tal" perteneciente al  Servicio "Tal" vensa por favor actualizar la informacion o se procedera a deshabilitar el 
servicio.  
*/  
  
ALTER PROCEDURE [dbo].[Sp_St_Tarifas_por_Vencer]  
AS  
 
SET NOCOUNT ON 
select datediff(day,getdate(),fec_term) as dias_para_el_vencimiento,Cod_Acue as codigo, isnull(Nombre,'TODOS') as Cliente, Fec_Term as Fecha_vencimiento, Flg_Tari as Es_Tarifa, Dg_Servicio as Servicio, Val_Acue as Monto from  St_V_Acuerdos  
where datediff(day,getdate(),fec_term)<=7  
  

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tarifas_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tarifas_Servicios]
@Cc smallint

AS

select * from  ST_T_Tarifas_Servicios where Dc_Centro_Costo=@Cc 

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tipo_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Visualizar Tipo de Servico
    Fecha       : 29/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tipo_Servicio]
@dc_Servicio varchar(20),
@Dc_Centro_Costo_imputacion smallint,
@Dc_Sucursal_imputacion smallint
AS
select * from St_V_Tipo_Servicio where dc_Servicio=@dc_Servicio and Dc_Centro_Costo_imputacion=@Dc_Centro_Costo_imputacion and Dc_Sucursal_imputacion=@Dc_Sucursal_imputacion
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Acuerdo_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Acuerdo_Servicio] 
@Cod_Acue int
AS
declare @Sucursal int
select @Sucursal =Dc_Sucursal from st_t_acuerdos where Cod_acue=@Cod_Acue
	IF isnull(@Sucursal,-1)=-1
		select  Dc_Servicio, Dc_Centro_Costo,Dc_Sucursal,Des_Acue,Val_Acue,Afecto_IGV, Dm_Detraccion,dc_porcentaje_detraccion  from St_v_tr_Acuerdo_servicio_sin_sucursal where Cod_Acue=@Cod_Acue
	else
		select  Dc_Servicio, Dc_Centro_Costo,Dc_Sucursal,Des_Acue,Val_Acue,Afecto_IGV, Dm_Detraccion,dc_porcentaje_detraccion from St_v_tr_Acuerdo_servicio where Cod_Acue=@Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Acuerdos_Aut_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Proposito : Mostrar la informacion de los acuerdos automaticos

ALTER PROCEDURE [dbo].[Sp_St_Tr_Acuerdos_Aut_old]
@Contribuy int
AS
SELECT     Cod_Acue,val_Acue,Contribuy,Dc_Servicio,Dc_Centro_costo,Dc_Sucursal,Cod_apli,Tip_Apli ,Tip_Enti,Flg_Tari
FROM         St_V_Tr_Acuerdos _Aut
WHERE Flg_Serv=1 and contribuy=@contribuy
order by Dc_Servicio,Dc_Centro_Costo,Dc_Sucursal asc,Flg_Tari asc
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Acuerdos_Aut_y_Man]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Acuerdos_Aut_y_Man]  
@Contribuy varchar(12),  
@Dc_Centro_Costo smallint,  
@Dc_Sucursal smallint,  
@ID int  
AS  
SELECT     Cod_Acue,val_Acue,Contribuy,Dc_Servicio,Dc_Centro_costo,Dc_Sucursal,Cod_aplc,Tip_Aplc ,  
case when Tip_aplc='E' then Tip_Enti_E else Tip_Enti_C end  as Tip_Enti  
,Flg_Tari,Cod_Aplp,'A' as Tipo,Flg_Inte as Integral,Tar_Mini,Tar_maxi ,Val_Acus,Tar_Mins,Tar_Maxs
FROM         St_V_Tr_Acuerdos_Aut  
WHERE  isnull(contribuy,@contribuy)=@contribuy and isnull(Dc_Centro_Costo_A,@Dc_Centro_Costo)=@Dc_Centro_Costo and isnull(Dc_Sucursal_A,@Dc_Sucursal)=@Dc_Sucursal  
  
UNION  
  
SELECT     Cod_Acue,val_Acue,Contribuy,Dc_Servicio,Dc_Centro_costo,Dc_Sucursal,Cod_aplc,Tip_Aplc ,  
case when Tip_aplc='E' then Tip_Enti_E else Tip_Enti_C end  as Tip_Enti  
,Flg_Tari,Cod_Aplp,'A' as Tipo,Flg_Inte as Integral,Tar_Mini,Tar_maxi   ,Val_Acus,Tar_Mins,Tar_Maxs
FROM         St_V_Tr_Acuerdos_Aut_Sin_Sucursal  
WHERE  isnull(contribuy,@contribuy)=@contribuy and isnull(Dc_Centro_Costo_A,@Dc_Centro_Costo)=@Dc_Centro_Costo and isnull(Dc_Sucursal_A,@Dc_Sucursal)=@Dc_Sucursal  
  
UNION  
  
SELECT     Cod_Acue,val_Acue,Contribuy,Dc_Servicio,Dc_Centro_costo,Dc_Sucursal,Cod_aplc,Tip_Aplc,  
case when Tip_aplc='E' then Tip_Enti_E else Tip_Enti_C end  as Tip_Enti,  
Flg_Tari,Cod_Aplp,'M' as tipo, Flg_Inte as Integral,Tar_Mini,Tar_maxi   ,Val_Acus,Tar_Mins,Tar_Maxs
FROM         St_V_Tr_Acuerdos_Man  
WHERE ID=@ID and isnull(contribuy,@contribuy)=@contribuy and isnull(Dc_Centro_Costo_A,@Dc_Centro_Costo)=@Dc_Centro_Costo and isnull(Dc_Sucursal_A,@Dc_Sucursal)=@Dc_Sucursal

ORDER BY Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Acuerdos_Man_old]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- Proposito : Mostrar la informacion de los acuerdos automaticos

--ALTER PROCEDURE [dbo].[Sp_St_Tr_Acuerdos_Man_old]
--@Dc_Servicio varchar(20),
--@Dc_Centro_Costo smallint,
--@Dc_Sucursal smallint
--AS
--SELECT     Cod_Acue,val_Acue,Contribuy,Dc_Servicio,Dc_Centro_costo,Dc_Sucursal,Cod_aplc,Tip_Aplc ,Tip_Enti,Flg_Tari
--FROM         St_V_Tr_Acuerdos_Man
--WHERE Dc_Servicio=@Dc_Servicio and Dc_Centro_Costo=@Dc_Centro_Costo and Dc_Sucursal=@Dc_Sucursal
--order by Dc_Servicio,Dc_Centro_Costo,Dc_Sucursal asc,Flg_Tari asc
--GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Buscar_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar los servicios especiales enviados en un documento y grabarlos en la tabla de respuesta ST_Tr_Servicios_Resp
    Fecha       : 21/Nov/2005
    Modificado : Al Porras 24/05/2006
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Buscar_Servicio]
@Id Int
AS
select ID,
Id_Item,
Dc_Servicio,
Dc_Sucursal,
Dc_Centro_Costo,
Cod_Acue,
Des_Acue,
Val_Serv,
(case Apl_Igv when 'SI' then 1 else 0 end) ,
(case Apl_Detr when 'N' then 0 else 1 end),
Flg_Inte,
'E' ,
'',
0,
Val_serv 
from St_V_Tr_Acuerdos_Esp where Id=@ID and Tip_Serv='E'

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Caracteristicas_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Caracteristicas_Activas]  AS
select * from 
St_V_Tr_Caracteristicas_Activas

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Caracteristicas_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Devolver una Caracteristica de un determinado acuerdo
    Fecha       : 22/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Caracteristicas_Acuerdo]
AS
select Cod_Acue, Cod_merc, Val_meac, Tip_cara,Flg_Proc  from St_V_Caracteristicas_Acuerdos
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Caracteristicas_Mercaderia]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Caracteristicas_Mercaderia]  AS
select Cod_Merc, Des_Merc,Tip_Cara  from 
St_T_Caracteristicas_Mercaderia

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Cargar_Servicios_Resp_Esp]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar los servicios especiales enviados en un documento y grabarlos en la tabla de respuesta ST_Tr_Servicios_Resp
    Fecha       : 21/Nov/2005
    Modificado : Al Porras 24/05/2006
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Cargar_Servicios_Resp_Esp]
@Id Int
AS
select ID,
Id_Item,
Dc_Servicio,
Dc_Sucursal,
Dc_Centro_Costo,
Cod_Acue,
Des_Acue,
Val_Serv,
(case Apl_Igv when 'SI' then 1 else 0 end) ,
(case Apl_Detr when 'N' then 0 else 1 end),
Flg_Inte,
'E' ,
'',
0,
Val_serv 
from St_V_Tr_Acuerdos_Esp where Id=@ID and Tip_Serv='E'

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Criterios_valorizar]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Criterios de valorizacion
    Fecha       : 17/Abr/2006
    PA.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Criterios_valorizar]
AS

select * from  ST_TR_Criterios_Valorizar

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Descuentos_Manuales]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Descuentos_Manuales]
@ID integer
AS
select  * from St_tr_Descuentos_manuales where Id=@ID
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Detalle]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Detalle]
@Id integer
AS
Select *  from St_V_Tr_Detalle  where Id=@Id

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Detalle_Caracteristicas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Detalle_Caracteristicas] 
@Id integer
AS
Select *  from St_V_Tr_Detalle_Caracteristicas  where Id=@Id

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Detalle_Caracteristicas_activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Detalle_Caracteristicas_activas]
@Id integer
AS
Select *  from St_V_Tr_Detalle_Caracteristicas_activas  where Id=@Id

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Detalle_Entidades]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Detalle_Entidades]
@Id integer
AS
Select *  from St_V_Tr_Detalle_Entidades  where Id=@Id

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Detalle_entidades_activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Detalle_entidades_activas]
@Id integer
AS
Select *  from St_V_Tr_Detalle_Entidades_activas  where Id=@Id

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Entidades]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Entidades] 

AS

SELECT     Cod_enti,Des_Enti,Tip_enti
FROM         St_V_Entidades

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Entidades_Activas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Entidades_Activas] 

AS

SELECT     *
FROM         St_V_Tr_Entidades_Activas

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Entidades_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Entidades_Acuerdo] AS
Select Cod_Acue, Cod_enti, Val_enac, Tip_enti,Flg_Proc  from St_V_Entidades_Acuerdos order by Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Grabar_Servicios_Resp]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar los servicios valorizados de cada documento
    Fecha       : 21/Nov/2005
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Grabar_Servicios_Resp]
@Id Int,
@Id_Item varchar(20),
@Dc_Servicio varchar(20),
@Dc_Sucursal smallint,
@Dc_Centro_Costo smallint,
@Cod_acue int,
@Des_Serv varchar(100),
@Val_Serv decimal(12,6),
@Apl_Igv tinyint,
@Apl_Detr tinyint,
@Flg_Inte tinyint,
@Tip_Serv char,
@Apl_calc varchar(10),
@Apl_Proc tinyint,
@Val_Neto decimal(12,6),
@Cod_Comb int,
@dc_porcentaje_detraccion decimal(9,2)

AS

Insert St_Tr_Servicios_Resp(ID,Id_Item,Dc_Servicio,Dc_Sucursal,Dc_Centro_Costo,Cod_Acue,Des_Serv,Val_Serv,Apl_Igv,Apl_Detr,Flg_Inte,Tip_Serv, Apl_Calc,Apl_Proc,val_neto,Cod_Comb,dc_porcentaje_detraccion) values(@ID,@Id_Item,@Dc_Servicio,@Dc_Sucursal,@Dc_Centro_Costo,@Cod_Acue,@Des_Serv,@Val_Serv,@Apl_Igv,@Apl_Detr,@Flg_Inte,@Tip_serv,@Apl_Calc,@Apl_Proc,@Val_neto,@Cod_Comb,@dc_porcentaje_detraccion)

--Insert St_Tr_Servicios_Resp(ID,Id_Item,Dc_Servicio,Dc_Sucursal,Dc_Centro_Costo,Cod_Acue,Des_Serv,Val_Serv,Apl_Igv,Apl_Detr,Flg_Inte,Tip_Serv, Apl_Calc,Apl_Proc,val_neto,Cod_Comb,dc_porcentaje_detraccion) values(@ID,@Id_Item,@Dc_Servicio,@Dc_Sucursal,@Dc_Centro_Costo,@Cod_Acue,@Des_Serv,@Val_Serv,@Apl_Igv,@Apl_Detr,@Flg_Inte,@Tip_serv,@Apl_Calc,@Apl_Proc,@Val_neto,@Cod_Comb,0)

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Grabar_Servicios_Resp_Esp]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Grabar los servicios especiales enviados en un documento y grabarlos en la tabla de respuesta ST_Tr_Servicios_Resp
    Fecha       : 21/Nov/2005
    Modificado : Al Porras 24/05/2006
    JF.
*/
ALTER PROCEDURE [dbo].[Sp_St_Tr_Grabar_Servicios_Resp_Esp]
@Id Int
AS
Insert into St_Tr_Servicios_Resp 
(ID,
ID_Item,
Dc_Servicio,
Dc_Sucursal, 
Dc_Centro_Costo, 
Cod_Acue,  
Des_Serv,  
Val_Serv,   
Apl_IGV, 
Apl_Detr, 
Flg_Inte, 
Tip_Serv, 
Apl_Calc,  
Apl_Proc, 
Val_Neto,
dc_porcentaje_detraccion)
select ID,
Id_Item,
Dc_Servicio,
Dc_Sucursal,
Dc_Centro_Costo,
Cod_Acue,
Des_Acue,
Val_Serv,
(case Apl_Igv when 'SI' then 1 else 0 end) ,
(case Apl_Detr when 'N' then 0 else 1 end),
Flg_Inte,
'E' ,
'',
0,
Val_serv ,dc_porcentaje_detraccion
from St_V_Tr_Acuerdos_Esp where Id=@ID and Tip_Serv='E'

SET NOCOUNT ON
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Grabar_Tipo_Moneda]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Grabar_Tipo_Moneda] 
@ID integer,
@Tipo_Moneda varchar(1)
AS

Update St_tr_Documento set Tip_Mone=@Tipo_moneda where ID=@Id
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Procesar_Servicios_Manuales]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Procesar_Servicios_Manuales]
@ID int,
@Id_Item varchar(11),
@Dc_Servicio varchar(20),
@Dc_Sucursal smallint,
@Dc_Centro_costo smallint

AS

Select count(Id_Mov) from st_tr_servicios_manuales_Especiales 
where ID=@Id and Id_Item=@Id_Item and Dc_Servicio=@Dc_Servicio and Dc_Sucursal = @Dc_Sucursal and Dc_Centro_Costo=@Dc_Centro_Costo and Tip_Serv='M'
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Tr_Servicio_Sin_Acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Tr_Servicio_Sin_Acuerdo]
@Dc_Servicio varchar(20),
@Dc_Sucursal smallint,
@Dc_Centro_Costo smallint
AS

SET ANSI_NULLS ON

declare @Sucursal int

		select  Dc_Servicio, Dc_Centro_Costo_imputacion as Dc_Centro_Costo ,Dc_Sucursal_imputacion as Dc_Sucursal , Des_Serv as Des_Acue,Afecto_IGV, Dm_Detraccion,dc_porcentaje_detraccion from  dbo.St_V_Tr_Servicio_Sin_Acuerdo
		where 
		Dc_Servicio=@DC_Servicio and
		Dc_Sucursal_imputacion =@Dc_Sucursal and
		Dc_Centro_Costo_imputacion  =@Dc_Centro_Costo
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Transfer_Tar_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos desde una tarifa a un acuerdo.
--
ALTER PROCEDURE [dbo].[Sp_St_Transfer_Tar_Acue]
@Cod_tari int,
@Cod_Acue int
AS
-- Declaracion variables
Declare
@Cod_Meac int,
@Cod_Merc tinyint,
@Val_Meac varchar(10),
@Des_Meac varchar(100),
@Flg_Proc tinyint
-- Declaracion de Cursor
Declare C_MER cursor for
Select Cod_Meac, Cod_Merc, Val_Meac,Des_Meac,Flg_Proc from St_T_caracteristicas_acuerdo where Cod_Acue=@Cod_tari
Open C_MER
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
	Fetch next from C_MER
	into @Cod_Meac, @Cod_Merc, @Val_Meac,@Des_Meac,@Flg_Proc
	while @@fetch_status = 0
	begin

	exec Sp_St_Grabar_caracteristica_acuerdo  @Cod_Acue,@Cod_merc,@val_meac,@Des_meac,@Flg_Proc

	-- Avanzamos otro registro
	Fetch next from C_MER
	into @Cod_Meac, @Cod_Merc, @Val_Meac,@Des_Meac ,@Flg_Proc

	end 

-- cerramos el cursor
close C_MER
deallocate C_MER

--Declaracion de Variables

Declare 
@val_enac varchar(100),
@Des_Enac varchar(100),
@cod_enti smallint

Declare C_ENT cursor for
Select Val_enac, Des_Enac, Cod_enti ,Flg_Proc from St_T_entidades_acuerdos where Cod_Acue=@Cod_tari
Open C_ENT
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
	Fetch next from C_ENT
	into @Val_enac,@Des_Enac,@cod_enti,@Flg_Proc
	while @@fetch_status = 0
	begin

	exec Sp_St_Grabar_entidad_acuerdo  @Cod_Acue,@Cod_enti,@Val_enac,@Des_Enac,@Flg_Proc

	-- Avanzamos otro registro
	Fetch next from C_ENT
	into @Val_enac,@Des_Enac,@cod_enti,@Flg_proc

	end 
-- cerramos el cursor
close C_ENT
deallocate C_ENT
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Aplica]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Aplican
    Fecha       : 14/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_V_Aplica] AS
Select cod_aplp as Codigo, des_aplp Descripcion from st_v_aplica
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Centro_Costo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER PROCEDURE [dbo].[Sp_St_V_Centro_Costo] AS
Select Dc_Centro_Costo as Codigo, Dg_Centro_Costo Descripcion from TTUNID_NEGO  Tb_Centro_Costo

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Cliente]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_V_Cliente] 
@filtro varchar(40)
AS

Select CONTRIBUY as Codigo, Nombre Descripcion from Terminal.dbo.AACLIENTESAA where Nombre like '%' + @filtro + '%'
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Entidades_Caracteristicas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Entidades y caracteristicas para busqueda 
    Fecha       : 05/Dic/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_V_Entidades_Caracteristicas] AS
Select (tip_apli+convert(char(20), cod_enti)) as Codigo, des_enti Descripcion from st_v_entidades_caracteristicas
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Linea]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_V_Linea]  
@filtro varchar(40)  
AS  
 
Select codarm10 as codigo, desarm10 as Descripcion 
from Terminal.dbo.dqarmado10
where desarm10 like '%' + @filtro + '%'
return 0


GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Servicio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER PROCEDURE [dbo].[Sp_St_V_Servicio]
@filtro varchar(40)
 AS
Select Dc_Servicio as Codigo, Dg_Servicio Descripcion from TTSERV where Dg_Servicio like '%' + @filtro + '%'

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Servicio_acuerdo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar Servicios para busqueda 
    Fecha       : 18/Nov/2005
    CM.
*/
ALTER PROCEDURE [dbo].[Sp_St_V_Servicio_acuerdo]
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@filtro varchar(40)
 AS

Select Dc_Servicio as Codigo, Dg_Servicio Descripcion from St_V_Servicios where Dc_Centro_Costo_imputacion=@Dc_Centro_Costo and Dc_Sucursal_imputacion=@Dc_Sucursal and Dg_Servicio like '%' + @filtro + '%'
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Sucursal]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--APC20080310
ALTER PROCEDURE [dbo].[Sp_St_V_Sucursal] AS
SELECT     dc_sucursal AS Codigo, dg_sucursal AS Descripcion
FROM         TMTIEN tb_sucursal_INST

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Tarifas]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Tarifas para asignarlas a un determinado acuerdo, se muestran las tarifas con cumplen con los filtos recibidos.
    Fecha       : 14/Dic/2005
    PA.
	Obs : Se cambio el tipo de dato de varchar(20) a int, no se visualizaba el resultado.
*/
ALTER PROCEDURE [dbo].[Sp_St_V_Tarifas]

@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio smallint

AS

	If @Dc_Sucursal=0
		select Cod_Acue as Codigo, Des_acue as Descripcion,Val_acue,Val_Acus from St_V_Tarifas where Dc_Centro_Costo = @Dc_Centro_Costo and Dc_Servicio = @Dc_Servicio and Cod_Esta='A' order by Cod_Acue
	Else
		select Cod_Acue as Codigo, Des_acue as Descripcion,Val_acue,Val_Acus from St_V_Tarifas where Dc_Centro_Costo = @Dc_Centro_Costo and Dc_Sucursal = @Dc_Sucursal and Dc_Servicio = @Dc_Servicio and Cod_Esta='A' order by Cod_Acue

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_V_Tarifas_A]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/* Autor        : Acecor Business Solutions SAC 
    Proposito  : Listar las Tarifas para asignarlas a un determinado acuerdo, se muestran las tarifas con cumplen con los filtos recibidos.
    Fecha       : 14/Dic/2005
    PA.
	Obs : Se cambio el tipo de dato de varchar(20) a int, no se visualizaba el resultado.
*/
ALTER PROCEDURE [dbo].[Sp_St_V_Tarifas_A]
@Dc_Centro_Costo_A smallint,
@Dc_Sucursal_A smallint,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint,
@Dc_Servicio smallint

AS

	If @Dc_Sucursal=0
		select Cod_Acue as Codigo, Des_acue as Descripcion,Val_acue from St_V_Tarifas where Dc_Centro_Costo_A = @Dc_Centro_Costo_A and Dc_Sucursal_A = @Dc_Sucursal_A and Dc_Centro_Costo = @Dc_Centro_Costo and Dc_Servicio = @Dc_Servicio and Cod_Esta='A' order by Cod_Acue
	Else
		select Cod_Acue as Codigo, Des_acue as Descripcion,Val_acue from St_V_Tarifas where Dc_Centro_Costo_A = @Dc_Centro_Costo_A and Dc_Sucursal_A = @Dc_Sucursal_A and Dc_Centro_Costo = @Dc_Centro_Costo and Dc_Sucursal = @Dc_Sucursal and Dc_Servicio = @Dc_Servicio and Cod_Esta='A' order by Cod_Acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_validar_combinacion_ultrag]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------STORED_PROCEDURES------------------------------
--APC20080310
ALTER PROCEDURE [dbo].[Sp_St_validar_combinacion_ultrag]
@Dc_Servicio smallint,
@Dc_Centro_Costo smallint,
@Dc_Sucursal smallint
AS
select count(*) from TRUNNE_SERV
where dc_servicio = @Dc_Servicio 
and dc_centro_costo_imputacion = @Dc_Centro_Costo
and dc_sucursal_imputacion = @Dc_Sucursal

GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Verificar_Caracteristicas_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_St_Verificar_Caracteristicas_Combo] 
@Cod_Acue int,
@Cod_Comb int
AS
Declare @Res int
select @Res=count(Cod_Acue) from St_V_caracteristicas_Acuerdos_Combos where Cod_Acue=@Cod_Acue and Cod_Comb=@Cod_Comb and isnull(Val_Caco,'XXX')<>'XXX' and Val_Meac<>Val_Caco
If @Res>0 
	select 0
Else
	Select 1
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Verificar_Entidades_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Verificar_Entidades_Combo] 
@Cod_Acue int,
@Cod_Comb int
AS
Declare @Res int
select @Res=count(Cod_Acue) from St_V_Entidades_Acuerdos_Combos where Cod_Acue=@Cod_Acue and Cod_Comb=@Cod_Comb and isnull(Val_Enco,'XXX')<>'XXX' and Val_Enac<>Val_Enco
If @Res>0 
	select 0
Else
	Select 1
GO
/****** Object:  StoredProcedure [dbo].[Sp_St_Verificar_Servicios_Combo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Sp_St_Verificar_Servicios_Combo] 
@Cod_Comb int,
@Dc_Servicio varchar(20)
AS
Declare @Res int

select @Res=count(Cod_Comb) from St_T_Servicios_Combo where Cod_Comb=@Cod_Comb and Dc_Servicio=@Dc_Servicio
If @Res>0 
	select 0
Else
	Select 1
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_Carga_Inicial]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Realizar la carga Inicial del Sistema de Tarifario integral

ALTER PROCEDURE [dbo].[Sp_T_Carga_Inicial]
AS

delete from St_t_caracteristicas_Acuerdo
delete from st_t_entidades_acuerdos
delete from st_t_acuerdos


exec Sp_T_TEC_Impo
exec Sp_T_TEC_Impo_acue

exec sp_t_Tec_Expo
exec sp_t_Tec_expo_Acue

exec sp_t_tec_vacios
exec sp_t_tec_vacios_acue
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Expo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos Exportaciones Tarifas

ALTER PROCEDURE [dbo].[Sp_T_TEC_Expo]
AS
-- Declaracion de Variables
Declare
@codtar13 int,
@codpro27 varchar(5),
@codemb06 char(3),
@codbol03 char(2),
@desimp13 char(60),
@valser13 float,
@codcon14 char(5),
@aplica13 char(1),
@tipmon13 char (1),
@flgref13 char(1),
@tipser13 char(1),
@tiptar13 char(1),
@flgtra99 char(1),
@fectra99 datetime,
@tarmin13 float,
@tarmax13 float,
@finvig13 datetime,
@inivig13 datetime,
@codusu17 char(15),
@fecusu00 datetime,
@estado13 char(1),
@sucursal char(2),
@codsbd03 char(3),
@Descripcion varchar(100),
@Cod_Acue int
-- Declaracion de Cursor
Declare C_TEC cursor for
Select codtar13,codpro27,codemb06,codbol03,desimp13,valser13,codcon14,aplica13,tipmon13,flgref13,tipser13,tiptar13,flgtra99,fectra99,tarmin13,tarmax13,finvig13,inivig13,codusu17,fecusu00,estado13,sucursal ,codsbd03 from St_V_CI_Expo order by codtar13
Open C_TEC
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@codcon14,@aplica13,@tipmon13,@flgref13,@tipser13,@tiptar13,@flgtra99,@fectra99,@tarmin13,@tarmax13,@finvig13,@inivig13,@codusu17,@fecusu00,@estado13,@sucursal ,@codsbd03

	while @@fetch_status = 0
	begin


	If @Sucursal='2' 
		set @sucursal = '4'
	If @Sucursal='5'
		Set @Sucursal ='14'
	
	If @valser13=0 
		set @estado13='I'	
	else
		set @estado13='A'	

	exec Sp_St_Grabar_Tarifa_impo @codtar13, @desimp13, @valser13, @aplica13, @tarmin13, @estado13, @codusu17, @tarmax13, @finvig13, @sucursal, @codsbd03,1,2,null,null,null


	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

	If @codpro27<>'*'
	begin
		SELECT     @descripcion = despro27 FROM  Descarga.dbo.EQPRODUC27 where CodPro27=@codpro27
		If @codpro27=20 or @codpro27=40
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@Codpro27,@Descripcion	--Tamaño
		Else
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,19,@Codpro27,@Descripcion	--Tipo Mercaderia
	end
	
	If @codemb06<>'*'
	begin
		SELECT     @descripcion=desemb06  FROM  Descarga.dbo.DQEMBALA06 where codemb06=@codemb06
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,21,@Codemb06,@descripcion
	end
	
	If @codbol03<>'*'
	begin
		SELECT     @descripcion=desbol03 FROM Descarga.dbo.DQCONDCN03 where codbol03=@codbol03
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,4,@Codbol03,@descripcion
	end

	-- Avanzamos otro registro

	Fetch next from C_TEC
	--asigno campos para dar valor
	into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@codcon14,@aplica13,@tipmon13,@flgref13,@tipser13,@tiptar13,@flgtra99,@fectra99,@tarmin13,@tarmax13,@finvig13,@inivig13,@codusu17,@fecusu00,@estado13,@sucursal ,@codsbd03
end 

-- cerramos el cursor
close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Expo_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos Exportaciones Acuerdos
ALTER PROCEDURE [dbo].[Sp_T_TEC_Expo_Acue]
AS
-- Declaracion de Variables
Declare
@codtar13 int,
@codpro27 varchar(5),
@codemb06 char(3),
@codbol03 char(2),
@desimp13 char(60),
@valser13 float,
@codcon14 char(5),
@aplica13 char(1),
@tipmon13 char (1),
@flgref13 char(1),
@tipser13 char(1),
@tiptar13 char(1),
@flgtra99 char(1),
@fectra99 datetime,
@tarmin13 float,
@tarmax13 float,
@finvig13 datetime,
@inivig13 datetime,
@codusu17 char(15),
@fecusu00 datetime,
@estado13 char(1),
@sucursal char(2),
@codsbd03 char(3),
@Descripcion varchar(100),
@Cod_Acue int,
@nrosec21 int,
@contribuy varchar(11),
@Cod_Tari int,
@tipdsc21 varchar(1),
@descto21 decimal(9,2),
@dialib21 int,
@flg_nept varchar(3),
@Linea varchar(5),

@cont int
set @cont=0


-- Declaracion de Cursor
Declare C_TEC cursor for
Select codtar13,codpro27,codemb06,codbol03,desimp13,valser13,codcon14,aplica13,tipmon13,flgref13,tipser13,tiptar13,flgtra99,fectra99,tarmin13,tarmax13,finvig13,inivig13,codusu17,fecusu00,estado13,sucursal ,codsbd03,nrosec21,tipdsc21,descto21,dialib21 from St_V_CI_Expo_acue order by nrosec21,codtar13
Open C_TEC
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
--leo todos los campos
into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@codcon14,@aplica13,@tipmon13,@flgref13,@tipser13,@tiptar13,@flgtra99,@fectra99,@tarmin13,@tarmax13,@finvig13,@inivig13,@codusu17,@fecusu00,@estado13,@sucursal ,@codsbd03,@nrosec21,@tipdsc21,@descto21,@dialib21

	while @@fetch_status = 0
	begin

	-- Obtener Codigo del Cliente	
	Select @contribuy=codent22  from St_V_CI_Expo_Det where nrosec20=@nrosec21 and tipent03=04

	-- Obtener codigo 6 para evaluar.
	Select @Linea=isnull(codent22,'X')  from St_V_CI_Expo_Det where nrosec20=@nrosec21 and tipent03=06

	-- Obtener Codigo de la Tarifa
	Select @Cod_Tari=Cod_acue from St_T_Acuerdos  where Cod_Tar13=@Codtar13 and  Dc_Centro_costo=2 and Flg_Tari=1


	if @tipdsc21='P' 
		set @valser13= @Valser13 - (@valser13*(100/@descto21))
	else
		set @Valser13=@Valser13-@descto21

	-- Obtener si es una linea de Neptunia o no , se descuenta 20 dolares adicionales.

		-- Contenedor de 20
		Select @Flg_Nept=isnull(Flgfac10,'X') from St_V_CI_Linea_expo  where nrosec20=@nrosec21

		If @Flg_Nept='S' and @Codcon14='POSIC' and @Codpro27=20
			set @Valser13=@Valser13-25


		-- Contenedor de 40 
		If @Flg_Nept='S' and @Codcon14='POSIC' and @Codpro27=40
			set @Valser13=@Valser13-20

	--  Condicionales fijas -- 

	If @Linea='APL' and @Codcon14='CELEC'
		set @Valser13=0

	If @Linea='CGM' and @Codcon14='CELEC'
		set @Valser13=0

	If @Linea='CMA' and @Codcon14='CELEC'
		set @Valser13=0

	If @Linea='CSA' and @Codcon14='MANEU'
		set @Valser13=0

	If @Linea='CSE' and @Codcon14='MANEU'
		set @Valser13=0

	If @Linea='HSD' and @Codcon14='CELEC'
		set @Valser13=0

	If @Linea='MOL' and @Codcon14='TRACC'
		set @Valser13=@Valser13-25

	If @Linea='MOL' and @Codcon14='CELEC'
		set @Valser13=0
	
	If @Linea='NYK' and @Codcon14='CELEC'
		set @Valser13=0

	If @Linea='PON' and @Codcon14='CELEC'
		set @Valser13=0


	--Identificar la sucursal

	If @Sucursal='2' 
		set @sucursal = '4'
	If @Sucursal='5'
		Set @Sucursal ='14'

	exec Sp_St_Grabar_Tarifa_impo @codtar13, @desimp13, @valser13, @aplica13, @tarmin13, @estado13, @codusu17, @tarmax13, @finvig13, @sucursal, @codsbd03,0,2,@Contribuy,@Cod_Tari,@Nrosec21

	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

	If @codpro27<>'*'
	begin
		SELECT     @descripcion = despro27 FROM  Descarga.dbo.EQPRODUC27 where CodPro27=@codpro27
		If @codpro27=20 or @codpro27=40
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@Codpro27,@Descripcion	--Tamaño
		Else
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,19,@Codpro27,@Descripcion	--Tipo Mercaderia
	end
	
	If @codemb06<>'*'
	begin
		SELECT     @descripcion=desemb06  FROM  Descarga.dbo.DQEMBALA06 where codemb06=@codemb06
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,21,@Codemb06,@descripcion
	end
	
	If @codbol03<>'*'
	begin
		SELECT     @descripcion=desbol03 FROM Descarga.dbo.DQCONDCN03 where codbol03=@codbol03
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,4,@Codbol03,@descripcion
	end


	If isnull(@dialib21,0)<>0
	begin
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,21,@dialib21,'DIAS LIBRES'
	end

	If (@Flg_Nept='N' )
	begin
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,18,'SI','OTRAS LINEAS'		
	end
	else
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,18,'NO','LINEAS NEPTUNIA'		

	Exec Sp_T_TEC_Expo_Det @nrosec21,@Cod_acue

	set @contribuy =null	
	set @Linea=null
	set @Codcon14=null

	-- Imprimir contador
	set @cont=@cont+1
	print 'Registro : ' + convert(varchar(4),@cont)

	-- Avanzamos otro registro

	Fetch next from C_TEC
	into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@codcon14,@aplica13,@tipmon13,@flgref13,@tipser13,@tiptar13,@flgtra99,@fectra99,@tarmin13,@tarmax13,@finvig13,@inivig13,@codusu17,@fecusu00,@estado13,@sucursal ,@codsbd03,@nrosec21,@tipdsc21,@descto21,@dialib21
end 

-- cerramos el cursor
close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Expo_Det]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos detalle Exportaciones  Acuerdos.
--Es llamado por Sp_T_TEC_Expo_Acue

ALTER PROCEDURE [dbo].[Sp_T_TEC_Expo_Det]
@nrosec21 int,
@Cod_acue int

AS

Declare
@nrosec20 int,
@tipent03 char(2),
@Codent22 char(15),
@cod_enti int,
@entida22 char(40),
@registros int,
@cantid22 int,
@criter22 varchar(1),
@valor varchar(5)

Select @registros=count(nrosec20)  from St_V_CI_Expo_Det where nrosec20=@nrosec21

If @registros>0 
BEGIN
		Declare C_TEC_DETA cursor for
		-- Select nrosec20,tipent03,codent22,cod_enti,entida22 from St_V_CI_Expo_Acue_Det where nrosec20=@nrosec21 and  tipent03<>14
		Select nrosec20,tipent03,codent22,cod_enti,entida22 from St_V_CI_Expo_Det where nrosec20=@nrosec21 and  tipent03<>04
		Open C_TEC_DETA

		Fetch next from C_TEC_DETA
		into @nrosec20,@tipent03,@codent22,@Cod_enti,@entida22

		while @@fetch_status = 0
		begin
			If @codent22<>'*'
				If isnull(@Cod_Enti,0)>0
					--exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,@Cod_Enti,@nrosec20,@entida22
					exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,@Cod_Enti,@codent22,@entida22
				else
				begin
					--Cantidad de contenedores
					if @criter22='='
					begin
						select @valor=convert(varchar(3),@cantid22)+','+convert(varchar(3),@cantid22)
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end
					if @criter22='>'
					begin
						select @valor=convert(varchar(3),@cantid22+1)+',999'
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end
					if @criter22='<'
					begin
						select @valor='1,'+convert(varchar(3),(@cantid22-1))
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end

				end

			Fetch next from C_TEC_DETA
			into @nrosec20,@tipent03,@codent22,@Cod_enti,@entida22
		end

		close C_TEC_DETA
		deallocate C_TEC_DETA
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Impo]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos importaciones Tarifas
-- 

ALTER PROCEDURE [dbo].[Sp_T_TEC_Impo]
AS
-- Declaracion de Variables
Declare
@codtar13 int,
@codpro27 char(3),
@codemb06 char(3),
@codbol03 char(2),
@desimp13 char(60),
@valser13 float,
@aplica13 char(1),
@tarmin13 float,
@diaal113 int,
@estado13 char(1),
@codusu17 char(15),
@fecusu00 datetime,
@diaal213 int,
@tarmax13 float,
@finvig13 datetime,
@inivig13 datetime,
@sucursal char(2),
@codcon14 char(5),
@codsbd03 char(3),
@Descripcion varchar(100),
@Cod_Acue int
-- Declaracion de Cursor
Declare C_TEC cursor for
Select codtar13,codpro27,codemb06,codbol03,desimp13,valser13,aplica13,tarmin13,diaal113,estado13,codusu17,fecusu00,diaal213,tarmax13,finvig13,inivig13,sucursal,codcon14,codsbd03 from St_V_CI_Impo
Open C_TEC
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@aplica13,@tarmin13,@diaal113,@estado13,@codusu17,@fecusu00,@diaal213,@tarmax13,@finvig13,@inivig13,@sucursal,@codcon14,@codsbd03
	
	while @@fetch_status = 0
	begin

	-- La sucursal es fija para importaciones....
	If @Sucursal=3 
		set @sucursal = '7'
	else
		Set @Sucursal ='14'
	
	If @valser13=0 
		set @estado13='I'	
	else
		set @estado13='A'	


	-- Verificar si es almacenaje para colocar los dias de almacenajes.
	If @Codcon14='ALMAC'
		set @Aplica13='A'

	exec Sp_St_Grabar_Tarifa_Impo @codtar13, @desimp13, @valser13, @aplica13, @tarmin13, @estado13, @codusu17, @tarmax13, @finvig13, @sucursal, @codsbd03,1,1,null,null,null
	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

	If @codpro27<>'*'
	begin
		SELECT     @descripcion = despro27 FROM  Terminal.dbo.DQPRODUC27 where CodPro27=@codpro27
		If @codpro27=20 or @codpro27=40
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@Codpro27,@Descripcion	--Tamaño
		Else
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,19,@Codpro27,@Descripcion	--Tipo Mercaderia
	end

	
	If @codcon14='Almac'
	begin
		declare 	@str varchar(10)
		If @diaal213=0 
			set @diaal213=9999

		set @Str = convert(varchar(10),@diaal113)+','+convert(varchar(10),@diaal213)
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,22,@str,''
	end


	If @codemb06<>'*'
	begin
		SELECT     @descripcion=desemb06  FROM  Terminal.dbo.DQEMBALA06 where codemb06=@codemb06
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,21,@Codemb06,@descripcion
	end

	If @codbol03<>'*'
	begin
		SELECT     @descripcion=desbol03,@Codbol03=Cod_actu FROM Tr_Tmp_Condicion_Mercaderia where codbol03=@codbol03

		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,24,@Codbol03,@descripcion
	end

	-- Avanzamos otro registro
	Fetch next from C_TEC
	into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@aplica13,@tarmin13,@diaal113,@estado13,@codusu17,@fecusu00,@diaal213,@tarmax13,@finvig13,@inivig13,@sucursal,@codcon14,@codsbd03

	end 

-- cerramos el cursor
close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Impo_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos importaciones Acuerdos
-- Fecha : 10-04.


ALTER PROCEDURE [dbo].[Sp_T_TEC_Impo_Acue]
AS
-- Declaracion de Variables
Declare
@codtar13 int,
@codpro27 char(3),
@codemb06 char(3),
@codbol03 char(2),
@desimp13 char(60),
@valser13 float,
@aplica13 char(1),
@tarmin13 float,
@diaal113 int,
@estado13 char(1),
@codusu17 char(15),
@fecusu00 datetime,
@diaal213 int,
@tarmax13 float,
@finvig13 datetime,
@inivig13 datetime,
@sucursal char(2),
@codcon14 char(5),
@codsbd03 char(3),
@Descripcion varchar(100),
@Cod_Acue int,
@nrosec21 int,

@nrosec20 int,
@tipent03 char(2),
@codent22 char(15),
@entida22 char(40),
@Contribuy varchar(11),
@Cod_Tari int,
@tipdsc21 varchar(1),
@descto21 decimal(9,2),
@dialib21 int,
@cont int

-----------------------------------------

Set @Cont=0

-- Declaracion de Cursor
Declare C_TEC cursor for
Select codtar13,codpro27,codemb06,codbol03,desimp13,valser13,aplica13,tarmin13,diaal113,estado13,codusu17,fecusu00,diaal213,tarmax13,finvig13,inivig13,sucursal,codcon14,codsbd03,nrosec21,tipdsc21,descto21,dialib21 from St_V_CI_Impo_acue  order by nrosec21,codtar13
Open C_TEC

-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@aplica13,@tarmin13,@diaal113,@estado13,@codusu17,@fecusu00,@diaal213,@tarmax13,@finvig13,@inivig13,@sucursal,@codcon14,@codsbd03,@nrosec21,@tipdsc21,@descto21,@dialib21

	while @@fetch_status = 0
	begin


	If @Sucursal='3' 
		set @sucursal = '7'
	If @Sucursal='5'
		Set @Sucursal ='14'
	

	--Obtener el codigo del Cliente
	Select @contribuy=codent22  from St_V_CI_Impo_Acue_Deta where nrosec20=@nrosec21 and tipent03=14

	-- Obtener el codigo de la Tarifa.
	
	Select @Cod_Tari=Cod_acue from St_T_Acuerdos  where Cod_Tar13=@codtar13 and  Dc_Centro_costo=1 and Flg_Tari=1
	
	if @tipdsc21='P' 
		set @valser13= @Valser13 - (@valser13*(100/@descto21))
	else
		set @Valser13=@Valser13-@descto21


	-- Verificar si es almacenaje para colocar los dias de almacenajes.
	If @Codcon14='ALMAC'
		set @Aplica13='A'
		


	
	exec Sp_St_Grabar_Tarifa_Impo @codtar13, @desimp13, @valser13, @aplica13, @tarmin13, @estado13, @codusu17, @tarmax13, @finvig13, @sucursal, @codsbd03,0,1,@contribuy,@Cod_Tari,@NroSec21

	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

	If @codpro27<>'*'
	begin
		SELECT     @descripcion = despro27 FROM  Terminal.dbo.DQPRODUC27 where CodPro27=@codpro27
		If @codpro27=20 or @codpro27=40
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@Codpro27,@Descripcion	--Tamaño
		Else
			exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,19,@Codpro27,@Descripcion	--Tipo Mercaderia
	end

	If @codcon14='Almac'
	begin
		declare 	@str varchar(10)
		set @Str = convert(varchar(10),@diaal113)+','+convert(varchar(10),@diaal213)
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,22,@str,''
	end 

	If isnull(@dialib21,0)<>0
	begin
		exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,21,@dialib21,'DIAS LIBRES'
	end

	If @codemb06<>'*'
	begin
		SELECT     @descripcion=desemb06  FROM  Terminal.dbo.DQEMBALA06 where codemb06=@codemb06
		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,21,@Codemb06,@descripcion
	end

	If @codbol03<>'*'
	begin
		SELECT     @descripcion=desbol03,@Codbol03=Cod_actu FROM Tr_Tmp_Condicion_Mercaderia where codbol03=@codbol03

		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,24,@Codbol03,@descripcion
	end



	Exec Sp_T_TEC_Impo_Det @nrosec21,@Cod_acue

	set @contribuy =null	

	-- Imprimir contador
	set @cont=@cont+1
	print 'Registro : ' + convert(varchar(4),@cont)

	Fetch next from C_TEC
	into @codtar13,@codpro27,@codemb06,@codbol03,@desimp13,@valser13,@aplica13,@tarmin13,@diaal113,@estado13,@codusu17,@fecusu00,@diaal213,@tarmax13,@finvig13,@inivig13,@sucursal,@codcon14,@codsbd03,@nrosec21,@tipdsc21,@descto21,@dialib21
end 

-- cerramos el cursor

close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Impo_Det]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos detalle de los acuerdos de Importaciones..
--Es llamado por Sp_T_TEC_impo_acue

ALTER PROCEDURE [dbo].[Sp_T_TEC_Impo_Det]
@nrosec21 int,
@Cod_acue int

AS

Declare
@nrosec20 int,
@tipent03 char(2),
@Codent22 char(15),
@cod_enti int,
@entida22 char(40),
@registros int,
@cantid22 int,
@criter22 varchar(1),
@valor varchar(5)

Select @registros=count(nrosec20)  from St_V_CI_Impo_Acue_Deta where nrosec20=@nrosec21

If @registros>0 
BEGIN
		Declare C_TEC_DETA cursor for
		Select nrosec20,tipent03,codent22,cod_enti,entida22,cantid22,criter22 from St_V_CI_Impo_Acue_Deta where nrosec20=@nrosec21 and  tipent03<>14
		Open C_TEC_DETA

		Fetch next from C_TEC_DETA
		into @nrosec20,@tipent03,@codent22,@Cod_enti,@entida22,@cantid22,@criter22

		while @@fetch_status = 0
		begin
			If @codent22<>'*'
				If isnull(@Cod_Enti,0)>0
					--exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,@Cod_Enti,@nrosec20,@entida22
					exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,@Cod_Enti,@codent22,@entida22
				else
				begin
					--Cantidad de contenedores
					if @criter22='='
					begin
						select @valor=convert(varchar(3),@cantid22)+','+convert(varchar(3),@cantid22)
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end
					if @criter22='>'
					begin
						select @valor=convert(varchar(3),@cantid22+1)+',999'
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end
					if @criter22='<'
					begin
						select @valor='1,'+convert(varchar(3),(@cantid22-1))
						exec  Sp_St_Grabar_entidad_tarifa  @Cod_Acue,19,@valor,@entida22
					end

				end
			Fetch next from C_TEC_DETA
			into @nrosec20,@tipent03,@codent22,@Cod_enti,@entida22,@cantid22,@criter22
		end

		close C_TEC_DETA
		deallocate C_TEC_DETA
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Vacios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos Vacios
--
--ALTER PROCEDURE [dbo].[Sp_T_TEC_Vacios]
--AS
---- Declaracion de Variables
--Declare
--@Dc_Sucursal  smallint,
--@Codser41 char(6),
--@Codsbd03 char(5),
--@Desimp41 char(50),
--@Codtam09 char(2),
--@Codtip05 char(2),
--@Import41 decimal(12,6),
--@Codarm10 char(3),		
--@Coddep04 char(2),			
--@Codusu17  char(15),
--@codage19 char(18),
--@status41 char(18),
--@cod_acue int,
--@descripcion varchar(100),
--@fecusu00 datetime,
--@fecha_final datetime,
--@Aplica13 varchar(3),
--@Codcon14 varchar(7)

---- Declaracion de Cursor
--Declare C_TEC cursor for
--Select codser41,codsbd03,desimp41,codtam09,codtip05,import41,codarm10,coddep04,codusu17,codage19,status41,fecusu00,Codcon14 from St_V_CI_vacios order by Codser41

--Open C_TEC

---- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
--Fetch next from C_TEC
--into @codser41,@codsbd03,@desimp41,@codtam09,@codtip05,@import41,@codarm10,@coddep04,@codusu17,@codage19,@status41,@fecusu00,@Codcon14

--	while @@fetch_status = 0
--	begin

--	-- Administracion  Codigo de Sucursal
--	If @Coddep04='CO'
--		set @Dc_Sucursal = 2
--	else
--		set @Dc_Sucursal =14

--	--set @fecha_final=dateadd(month,6,@fecusu00)
--	set @fecha_final=null
	
--	-- Verificar si es almacenaje para colocar los dias de almacenajes.
--	If @Codcon14='REMET'
--		set @Aplica13='C26'
--	Else
--		set @Aplica13='E19'


--	exec Sp_St_Grabar_Tarifa 3, @Dc_Sucursal, @codsbd03,@desimp41,@Aplica13,@fecusu00,@fecha_final,@codusu17,@import41,@import41,@import41,0,0,0,0,NULL

--	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

--	If @codtam09<>'*'
--	begin
--		SELECT     @descripcion = destam09 FROM Terminal.dbo.DQTAMCON09 where Codtam09=@codtam09
--		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@codtam09,@Descripcion
--	end

--	If @codtip05<>'*'
--	begin
--		SELECT     @descripcion = destip05 FROM  Terminal.dbo.DQTIPCON05 where codtip05=@codtip05
--		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,2,@codtip05,@Descripcion
--	end

--	If @codarm10<>'*'
--	begin
--		SELECT     @descripcion=desarm10  FROM Terminal.dbo.DQARMADO10 where codarm10=@codarm10
--		exec  Sp_St_Grabar_Entidad_tarifa  @Cod_Acue,6,@codarm10,@descripcion
--	end

--	-- Avanzamos otro registro
--	Fetch next from C_TEC
--	into @codser41,@codsbd03,@desimp41,@codtam09,@codtip05,@import41,@codarm10,@coddep04,@codusu17,@codage19,@status41,@fecusu00,@Codcon14

--	end 

---- cerramos el cursor
--close C_TEC
--deallocate C_TEC
--update St_T_Acuerdos set Cod_Esta='A' Where Dc_Centro_Costo=3
--GO
/****** Object:  StoredProcedure [dbo].[Sp_T_TEC_Vacios_Acue]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos Vacios
--
--ALTER PROCEDURE [dbo].[Sp_T_TEC_Vacios_Acue]
--AS
---- Declaracion de Variables
--Declare
--@Dc_Sucursal  smallint,
--@Codser41 char(6),
--@Codsbd03 char(5),
--@Desimp41 char(50),
--@Codtam09 char(2),
--@Codtip05 char(2),
--@Import41 decimal(12,6),
--@Codarm10 char(3),		
--@Coddep04 char(2),			
--@Codusu17  char(15),
--@codage19 char(18),
--@status41 char(18),
--@cod_acue int,
--@descripcion varchar(100),
--@fecusu00 datetime,
--@fecha_final datetime,
--@Codcon14 varchar(5),
--@Cod_Tari int,
--@Dc_Centro_Costo int

---- Declaracion de Cursor

--set @Dc_Centro_costo=3
--set @Cod_Tari=null

--Declare C_TEC cursor for
--Select codser41,codsbd03,desimp41,codtam09,codtip05,import41,codarm10,coddep04,codusu17,codage19,status41,fecusu00  from St_V_CI_vacios_acue order by Codser41

--Open C_TEC

---- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
--Fetch next from C_TEC
--into @codser41,@codsbd03,@desimp41,@codtam09,@codtip05,@import41,@codarm10,@coddep04,@codusu17,@codage19,@status41,@fecusu00

--	while @@fetch_status = 0
--	begin

--	-- Administracion  Codigo de Sucursal
--	If @Coddep04='CO'
--		set @Dc_Sucursal = 2
--	else
--		set @Dc_Sucursal =14

--	--set @fecha_final=dateadd(month,6,@fecusu00)
--	set @fecha_final=null

--	If @Codage19='*'
--		set @CodAge19=null


--	--Select @Cod_Tari=Cod_acue from St_T_Acuerdos  where Cod_con14=@codcon14 and  Dc_Centro_costo=3 and Flg_Tari=1

--	exec Sp_St_Grabar_acuerdo @codage19,@Dc_Centro_costo, @Dc_Sucursal, @codsbd03, @Cod_tari,@desimp41,@fecusu00,@fecha_final,@codusu17,@import41,0,null,'E19',null,@Dc_Centro_costo, @Dc_Sucursal

--	select @cod_acue=max(cod_Acue) from St_T_Acuerdos

--	If @codtam09<>'*'
--	begin
--		SELECT     @descripcion = destam09 FROM Terminal.dbo.DQTAMCON09 where Codtam09=@codtam09
--		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,3,@codtam09,@Descripcion
--	end

--	If @codtip05<>'*'
--	begin
--		SELECT     @descripcion = destip05 FROM  Terminal.dbo.DQTIPCON05 where codtip05=@codtip05
--		exec  Sp_St_Grabar_Caracteristica_tarifa  @Cod_Acue,2,@codtip05,@Descripcion
--	end

--	If @codarm10<>'*'
--	begin
--		SELECT     @descripcion=desarm10  FROM Terminal.dbo.DQARMADO10 where codarm10=@codarm10
--		exec  Sp_St_Grabar_Entidad_tarifa  @Cod_Acue,6,@codarm10,@descripcion
--	end

--	-- Avanzamos otro registro
--	Fetch next from C_TEC
--	into @codser41,@codsbd03,@desimp41,@codtam09,@codtip05,@import41,@codarm10,@coddep04,@codusu17,@codage19,@status41,@fecusu00

--	end 

---- cerramos el cursor
--close C_TEC
--deallocate C_TEC

--update St_T_Acuerdos set Cod_Esta='A' Where Dc_Centro_Costo=3
--GO
/****** Object:  StoredProcedure [dbo].[Sp_Tmp_Agregar_CM]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos importaciones Tarifas
-- 

ALTER PROCEDURE [dbo].[Sp_Tmp_Agregar_CM]
AS

-- Declaracion de Cursor
Declare
@Cod_Acue int,
@Cod_Aplc int

Declare C_TEC cursor for
Select Cod_Acue,Cod_Aplc from St_T_Acuerdos WHERE COD_APLC=19 and Tip_aplc='E'
Open C_TEC
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
into @cod_acue,@Cod_Aplc
	
	while @@fetch_status = 0
	begin

		EXEC Sp_St_Grabar_Caracteristica_Acuerdo @Cod_Acue, 31,1,NULL,1

		-- Avanzamos otro registro
		Fetch next from C_TEC
		into @cod_acue,@Cod_Aplc
	end 

-- cerramos el cursor
close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[Sp_Tmp_Agregar_CM_2]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Autor : Acecor Business Solutions SAC 
--Objetivo : Transferencia de Datos importaciones Tarifas
-- 

ALTER PROCEDURE [dbo].[Sp_Tmp_Agregar_CM_2]
AS

-- Declaracion de Cursor
Declare
@Cod_Acue int,
@Cod_Aplc int,
@Tip_Aplc char

Declare C_TEC cursor for
Select Cod_Acue,Cod_Aplc,Tip_aplc from St_T_Acuerdos WHERE COD_APLC=25 and Tip_Aplc='C' 
Open C_TEC
-- Avanzamos un registro y cargamos en las variables los valores encontrados en el primer registro
Fetch next from C_TEC
into @cod_acue,@Cod_Aplc,@Tip_Aplc
	
	while @@fetch_status = 0
	begin
	
			EXEC Sp_St_Grabar_Caracteristica_Acuerdo @Cod_Acue, 25,'1,999',NULL,1

		-- Avanzamos otro registro
		Fetch next from C_TEC
		into @cod_acue,@Cod_Aplc,@Tip_Aplc
	end 

-- cerramos el cursor
close C_TEC
deallocate C_TEC
GO
/****** Object:  StoredProcedure [dbo].[SP_Vacios_GenEntidades_Cab]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


-- SP_Vacios_GenEntidades_Cab NULL,null,null,NULL,null,NULL,'XXXX1111111','23','PRENGIFO',3,2,4
--  select * from st_tr_documento order by id desc

-- SP_Vacios_GenEntidades_Cab NULL,'*','*','40','*','*',null,'213','PRENGIFO',3,2

ALTER PROCEDURE [dbo].[SP_Vacios_GenEntidades_Cab]
@RUCCLI char(11),
@RUCCON char(11),
@RUCEMB char(11),
@CODTAM CHAR(2),
@CODTIP CHAR(2),
@CODARM CHAR(3),
@CODCON CHAR(11),
@CODSER CHAR(3),
@CODUSU char(20),
@CENCOS int,
@CODSUC int,
@CANTID INT

as
declare 

@idReg int

BEGIN
--select * from oceanica1.descarga.dbo.adtarser41 

--select max(id)+1 from st_tr_documento
--  select * from st_tr_documento order by id desc
--delete st_tr_documento where id = 53

--  select * from aaclientesaa where contribuy = '20250389591'
select @idReg =max(id)+1 from st_tr_documento

/** Insert Table Document **/

--insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) 
--values (@idReg,  @CODCON, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @CODSUC) 

insert st_tr_documento (ID, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) 
values (@idReg, 1, @CODUSU, getdate(), @RUCCLI, @CENCOS, @CODSUC) 

--sp_help st_tr_documento

--insert st_tr_documento (ID, Cod_Docu, Tip_Docu, Cod_Usua, Fec_Docu,  Cod_Clie,  Dc_Centro_Costo, Dc_Sucursal ) 
--values (55, 'XXXX111111', 1, 'PRENGI', getdate(), null, 3, 2) 

/** Insert Table Entidad **/
-- delete st_tr_entidades where id = 53
--select * from st_tr_entidades where id = 55
-- INSERT RUC DE CLIENTE DE FACTURA
insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,1,@RUCCLI)
-- insert st_tr_entidades (id,cod_enti,val_enti) values (55,1,null)
-- INSERTO RUC DE EMBARCADOR CASO RETIRO DE CLIENTES
insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,4,@RUCEMB)
-- insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,4,null)
--INSERT RUC CONSIGNATARIO CASO DEVOLUCION
insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,11,@RUCCON)
-- insert st_tr_entidades (id,cod_enti,val_enti) values (@55,11,null)
--INSERTO LINEA
insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,6,@CODARM)
-- insert st_tr_entidades (id,cod_enti,val_enti) values (55,6,null)
--INSERTO CONTENEDOR
insert st_tr_entidades (id,cod_enti,val_enti) values (@idReg,23,@CODCON)
-- insert st_tr_entidades (id,cod_enti,val_enti) values (55,23,'XXXX111111')


/** Insert Table Details **/

insert  into st_tr_detalle  (id, id_item) 
VALUES(@idReg,@CODCON)

-- insert  into st_tr_detalle  (id, id_item) 
-- VALUES(55,'XXXX111111')


/** Insert Caracteristics Table Details **/

-- SELECT * FROM st_tr_caracteristicas_mercaderia  where id = 55

-- INSERT CARACTERISTICAS DE TAMAÑO
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  
values (@idReg,@CODCON,3, @CODTAM)		

-- insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  
-- values (55,'XXXX111111',1, '20')		

-- INSERT DE CARACTERISTICAS DE TIPO
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  
values (@idReg,@CODCON,2, @CODTIP)			

-- insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  
-- values (55,'XXXX111111',2, null)		

-- INSERT DE CARACTERISTICAS CANTIDAD DE ETIQUETAS
insert st_tr_caracteristicas_mercaderia  (ID,  ID_Item,  Cod_Merc,Val_Merc)  
values (@idReg,@CODCON,26, @CANTID)			



/** Insert  Servicios Manuales**/

--insert  into st_tr_detalle    (id, id_item) select distinct @idReg, codcon63  from drblcont15 where nrosec23=@NROSEC

-- SELECT * FROM St_TR_Servicios_Manuales_Especiales where id = 56

insert St_TR_Servicios_Manuales_Especiales (dc_servicio,dc_sucursal,id,id_item,dc_centro_costo,tip_serv,val_serv)
VALUES(@CODSER,@CODSUC,@idReg,@CODCON,@CENCOS,'M',0)

-- insert St_TR_Servicios_Manuales_Especiales (dc_servicio,dc_sucursal,id,id_item,dc_centro_costo,tip_serv,val_serv)
-- VALUES(213,2,55,'XXXX111111',3,'M',0)


END



GO
/****** Object:  StoredProcedure [web].[Sp_St_Sa_Enviar_Valorizacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [web].[Sp_St_Sa_Enviar_Valorizacion]
@Id int
AS
update St_Tr_Documento set Flg_Envi=1 where ID=@ID
GO
/****** Object:  StoredProcedure [web].[Sp_St_Sa_ID_Valorizacion]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [web].[Sp_St_Sa_ID_Valorizacion]
@Cod_Docu varchar(15)
AS

select top 1 Id  from st_tr_documento where Cod_Docu=@Cod_docu order by fec_docu desc
GO
/****** Object:  StoredProcedure [web].[Sp_St_Sa_Valorizaciones]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [web].[Sp_St_Sa_Valorizaciones]
@Cod_Docu varchar(15)
AS
declare @Id int,
@Fec_Docu datetime

select top 1 @ID=Id,@Fec_Docu=Fec_Docu from st_tr_documento where Cod_Docu=@Cod_docu order by fec_docu desc

-- Datos de Cabecera de Valorizacion

select @Id as Id,@Fec_Docu as Fec_Docu, notemb16 as Cod_Docu, bookin13, Nave, Viaje, ORD_CODIGO
from descarga.dbo.Se_V_Dua_Datos_Completos where notemb16=@Cod_Docu

--Resultados de Valorizacion.
Select 999 as Dc_Servicio,999 as Dc_Sucursal,999 as Dc_Centro_Costo,'(999) SERVICIO LOGISTICO DE EXPORTACION' as Des_Serv, sum(Val_Serv) as Val_Serv,sum(val_neto) as Val_neto,0 as dc_porcentaje_detraccion ,1 as Apl_IGV
from st_Tr_servicios_Resp 
where ID= @ID and Cod_Comb<>0

union

select Dc_Servicio,Dc_Sucursal,Dc_Centro_Costo,Des_Serv,sum(Val_Serv) as Val_Serv, sum(val_neto) as Val_neto,max(dc_porcentaje_detraccion) as dc_porcentaje_detraccion ,max(Apl_IGV) as Apl_IGV
from st_Tr_servicios_Resp 
where ID= @ID and Cod_Comb=0 
Group by Dc_Servicio,Dc_Sucursal,Dc_Centro_Costo,Des_Serv
having Sum(val_serv)>0


--Relacion de Contenedores
select Id_Item from St_tr_Detalle where ID=@ID
GO
/****** Object:  StoredProcedure [web].[Sp_St_Sa_Valorizaciones_Pendientes_Envio]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [web].[Sp_St_Sa_Valorizaciones_Pendientes_Envio]
@Contribuy varchar(11)
AS

select distinct Cod_docu from st_tr_documento where Dc_centro_costo=2 and cod_Clie=@Contribuy and flg_envi=0 and cod_docu not in (select Cod_Docu from st_tr_documento where cod_Clie=@Contribuy and Flg_Envi=1)
GO
/****** Object:  StoredProcedure [web].[sp_Vacios_Get_Servicios]    Script Date: 07/03/2019 04:16:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Vacios_Get_Servicios]  
@Key integer 
AS  

select ID, ID_Item, Dc_Servicio, Dc_Sucursal, Dc_Centro_Costo, Cod_Acue,
 Des_Serv, Val_Serv, Apl_IGV, Apl_Detr,  Apl_Proc, Val_Neto 
from ST_TR_Servicios_Resp where id  = @Key and Val_Serv>0  

GO