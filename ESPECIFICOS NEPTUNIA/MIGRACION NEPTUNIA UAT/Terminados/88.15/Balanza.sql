USE [Balanza]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_str_token]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_str_token] (
@Cadena as varchar(8000),
@Delimitador as varchar(1),
@Elemento as int
) RETURNS VARCHAR(1000)
AS

BEGIN
	DECLARE @n as INT
	DECLARE @Token VARCHAR(1000)
	SET @n = 1

	WHILE @n < @Elemento
		BEGIN
			SET @Cadena = SUBSTRING(@Cadena, CHARINDEX(@Delimitador, @Cadena)+1,LEN(@Cadena))
			SET @n = @n + 1
		END

	IF CHARINDEX(@Delimitador, @Cadena) = 0
		SET @Token = @Cadena	
	ELSE
		SET @Token = LEFT(@Cadena, CHARINDEX(@Delimitador, @Cadena)-1)
	
	RETURN @Token
END
GO
/****** Object:  View [dbo].[AACLIENTESAA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.AACLIENTESAA    Script Date: 08/09/2002 6:45:27 PM ******/
ALTER VIEW [dbo].[AACLIENTESAA]
AS
SELECT * FROM DESCARGA..AACLIENTESAA
GO
/****** Object:  View [dbo].[AATRANSP05]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[AATRANSP05] AS  
SELECT CLIENTE,NOMBRE,DIRECCION,CONTRIBUY,ACTIVO,TIENECONVE,CONTACTO,CADENA   
FROM  AACLIENTESAA (nolock)  
WHERE   
SUBSTRING(CADENA,5,1)='1'
GO
/****** Object:  View [dbo].[AAAGENTE01]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.AAAGENTE01    Script Date: 08/09/2002 6:45:27 PM ******/
ALTER VIEW [dbo].[AAAGENTE01] AS
SELECT CLIENTE=substring(CLIENTE,1,4),NOMBRE,DIRECCION,CONTRIBUY,ACTIVO,TIENECONVE,CONTACTO,SALDODOLAR,CADENA 
FROM  DESCARGA..AACLIENTESAA
WHERE 
SUBSTRING(CADENA,1,1)='1'
GO
/****** Object:  View [dbo].[AACLIENT03]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.AACLIENT03    Script Date: 08/09/2002 6:45:27 PM ******/
ALTER VIEW [dbo].[AACLIENT03] AS
SELECT CLIENTE,NOMBRE,DIRECCION,CONTRIBUY,ACTIVO,TIENECONVE,CONTACTO,CADENA 
FROM  DESCARGA..AACLIENTESAA
WHERE 
SUBSTRING(CADENA,7,1)='1'
GO
/****** Object:  View [dbo].[DCORDTRA60]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DCORDTRA60    Script Date: 08/09/2002 6:45:27 PM ******/
ALTER VIEW [dbo].[DCORDTRA60] as select * from descarga..ECORDTRA60
GO
/****** Object:  View [dbo].[DCORDTRA67]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DCORDTRA67    Script Date: 08/09/2002 6:45:28 PM ******/
ALTER VIEW [dbo].[DCORDTRA67] as select * from descarga..dcORDTRA67
GO
/****** Object:  View [dbo].[DDBLODES60]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DDBLODES60] AS
SELECT *
FROM  DESCARGA..DDBLODES60

GO
/****** Object:  View [dbo].[DDCABMAN11]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDCABMAN11]
AS
SELECT     *

FROM         descarga.dbo.DDCABMAN11

GO
/****** Object:  View [dbo].[DDCARGAS16]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDCARGAS16    Script Date: 08/09/2002 6:45:28 PM ******/
ALTER VIEW [dbo].[DDCARGAS16] AS
SELECT * FROM DESCARGA..DDCARGAS16
GO
/****** Object:  View [dbo].[DDCARTAR22]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDCARTAR22    Script Date: 08/09/2002 6:45:28 PM ******/
ALTER VIEW [dbo].[DDCARTAR22] AS
SELECT * FROM DESCARGA..DDCARTAR22
GO
/****** Object:  View [dbo].[DDCONTAR63]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDCONTAR63    Script Date: 08/09/2002 6:45:29 PM ******/
ALTER VIEW [dbo].[DDCONTAR63] AS
SELECT * FROM DESCARGA..DDCONTAR63
GO
/****** Object:  View [dbo].[DDCONTEN04]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDCONTEN04    Script Date: 08/09/2002 6:45:29 PM ******/
ALTER VIEW [dbo].[DDCONTEN04] AS
SELECT * FROM DESCARGA..DDCONTEN04
GO
/****** Object:  View [dbo].[DDDETALL12]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DDDETALL12] AS
SELECT *
FROM  DESCARGA..dddetall12

GO
/****** Object:  View [dbo].[DDDETBLD61]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DDDETBLD61] AS
SELECT *
FROM  DESCARGA..DDDETBLD61

GO
/****** Object:  View [dbo].[DDDETORD43]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDDETORD43    Script Date: 08/09/2002 6:45:29 PM ******/
ALTER VIEW [dbo].[DDDETORD43] AS
SELECT * FROM DESCARGA..DDDETORD43
GO
/****** Object:  View [dbo].[DddetTRA68]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DddetTRA68    Script Date: 08/09/2002 6:45:30 PM ******/
ALTER VIEW [dbo].[DddetTRA68] as select * from descarga..dddetTRA68
GO
/****** Object:  View [dbo].[DDISOCOD03]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DDISOCOD03] 
as
select * from terminal.dbo.DDCNDCTR03

GO
/****** Object:  View [dbo].[DDITEMSC13]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDITEMSC13    Script Date: 08/09/2002 6:45:30 PM ******/
ALTER VIEW [dbo].[DDITEMSC13] AS
SELECT * FROM DESCARGA..DDITEMSC13
GO
/****** Object:  View [dbo].[DDORDRET41]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDORDRET41    Script Date: 08/09/2002 6:45:30 PM ******/
ALTER VIEW [dbo].[DDORDRET41] AS
SELECT * FROM DESCARGA..DDORDRET41
GO
/****** Object:  View [dbo].[DdORDTRA67]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DdORDTRA67    Script Date: 08/09/2002 6:45:31 PM ******/
ALTER VIEW [dbo].[DdORDTRA67] as select * from descarga..ddORDTRA67
GO
/****** Object:  View [dbo].[DDPASSWO95]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDPASSWO95    Script Date: 08/09/2002 6:45:31 PM ******/
ALTER VIEW [dbo].[DDPASSWO95] AS
SELECT * FROM DESCARGA..DDPASSWO95
GO
/****** Object:  View [dbo].[DDSALMAC52]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDSALMAC52    Script Date: 08/09/2002 6:45:31 PM ******/
ALTER VIEW [dbo].[DDSALMAC52] AS
SELECT * FROM DESCARGA..DDSALMAC52
GO
/****** Object:  View [dbo].[DDVEHICU14]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DDVEHICU14    Script Date: 08/09/2002 6:45:31 PM ******/
ALTER VIEW [dbo].[DDVEHICU14] AS
SELECT * FROM DESCARGA..DDVEHICU14
GO
/****** Object:  View [dbo].[ddvoldes23]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[ddvoldes23] AS
SELECT *
FROM  DESCARGA..ddvoldes23

GO
/****** Object:  View [dbo].[dqaccweb01]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  View dbo.AAAGENTE01    Script Date: 08-09-2002 08:43:22 PM ******/
ALTER VIEW [dbo].[dqaccweb01] AS
SELECT *
FROM  DESCARGA..dqaccweb01

GO
/****** Object:  View [dbo].[DQARMADO10]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQARMADO10    Script Date: 08/09/2002 6:45:32 PM ******/
ALTER VIEW [dbo].[DQARMADO10] AS
Select * from descarga..dqarmado10
GO
/****** Object:  View [dbo].[DQCONDCN03]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQCONDCN03    Script Date: 08/09/2002 6:45:32 PM ******/
ALTER VIEW [dbo].[DQCONDCN03] AS
select * from descarga..DQCONDCN03
GO
/****** Object:  View [dbo].[DQEMBALA06]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQEMBALA06    Script Date: 08/09/2002 6:45:33 PM ******/
ALTER VIEW [dbo].[DQEMBALA06] AS
select * from descarga..DQEMBALA06
GO
/****** Object:  View [dbo].[DQNAVIER08]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQNAVIER08    Script Date: 08/09/2002 6:45:33 PM ******/
ALTER VIEW [dbo].[DQNAVIER08] AS
select * from descarga..DQNAVIER08
GO
/****** Object:  View [dbo].[dqplaags81]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[dqplaags81]
AS
SELECT     *
FROM         Descarga.dbo.DQPLAAGS81
GO
/****** Object:  View [dbo].[DQPUERTO02]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DQPUERTO02] AS  
Select * from descarga..dqpuerto02
GO
/****** Object:  View [dbo].[DQTAMCON09]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DQTAMCON09] as  
select * from descarga..DQTAMCON09 where codtam09 <> '*'

GO
/****** Object:  View [dbo].[DRBLCONT15]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRBLCONT15    Script Date: 08/09/2002 6:45:34 PM ******/
ALTER VIEW [dbo].[DRBLCONT15] AS
select * from descarga..DRBLCONT15
GO
/****** Object:  View [dbo].[DRITMALM53]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRITMALM53    Script Date: 08/09/2002 6:45:34 PM ******/
ALTER VIEW [dbo].[DRITMALM53] AS
SELECT * FROM DESCARGA..DRITMALM53
GO
/****** Object:  View [dbo].[DRNAVSER31]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRNAVSER31    Script Date: 08/09/2002 6:45:35 PM ******/
ALTER VIEW [dbo].[DRNAVSER31] AS
SELECT * FROM DESCARGA..DRNAVSER31
GO
/****** Object:  View [dbo].[DRORDITM54]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRORDITM54    Script Date: 08/09/2002 6:45:35 PM ******/
ALTER VIEW [dbo].[DRORDITM54] AS
SELECT * FROM DESCARGA..DRORDITM54
GO
/****** Object:  View [dbo].[DRPOLFAC42]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRPOLFAC42    Script Date: 08/09/2002 6:45:35 PM ******/
ALTER VIEW [dbo].[DRPOLFAC42] AS
SELECT * FROM DESCARGA..DRPOLFAC42
GO
/****** Object:  View [dbo].[DRVORSAL69]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DRVORSAL69    Script Date: 08/09/2002 6:45:35 PM ******/
ALTER VIEW [dbo].[DRVORSAL69] AS
SELECT * FROM DESCARGA..DRVORSAL69
GO
/****** Object:  View [dbo].[DTRTEMPO99]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DTRTEMPO99]  
AS  
SELECT     *  
FROM         descarga.dbo.DTRTEMPO99  

GO
/****** Object:  View [dbo].[DVEMPRES01]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVEMPRES01]    
AS    
SELECT * FROM OCEANO..ODEMPRES01 (nolock)
GO
/****** Object:  View [dbo].[DVSYSUSR02]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSYSUSR02    Script Date: 08/09/2002 6:45:37 PM ******/
ALTER VIEW [dbo].[DVSYSUSR02] AS
SELECT * FROM OCEANO..ODSYSUSR02
GO
/****** Object:  View [dbo].[EDAUDTKT00]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EDAUDTKT00]
	as
	select tipope00 as TIP, codusu00 as USUARIO, fecope00 as FECHA_REG, hostid00 as PC, regupd00 as TRAMA 
	from TKTAUDIT00 (nolock) where fecope00>=dateadd(day,-2,getdate())
	
GO
/****** Object:  View [dbo].[EDAUTING14]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EDAUTING14] AS
SELECT * FROM DESCARGA..EDAUTING14
GO
/****** Object:  View [dbo].[EDBOOKIN13]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.EDBOOKIN13    Script Date: 08/09/2002 6:45:37 PM ******/
ALTER VIEW [dbo].[EDBOOKIN13] AS
SELECT * FROM DESCARGA..EDBOOKIN13
GO
/****** Object:  View [dbo].[EDCONTEN04]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.EDCONTEN04    Script Date: 08/09/2002 6:45:38 PM ******/
ALTER VIEW [dbo].[EDCONTEN04] AS
SELECT * FROM DESCARGA..EDCONTEN04 (nolock)
GO
/****** Object:  View [dbo].[EDDETTRA61]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EDDETTRA61] AS
SELECT * FROM Descarga..EDDETTRA61

GO
/****** Object:  View [dbo].[EDLLENAD16]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EDLLENAD16] AS
SELECT A.*, NOMEMB16=B.NOMEMB14 
FROM DESCARGA..EDLLENAD16 A (nolock),  DESCARGA..EDAUTING14 B (nolock)
WHERE A.NROAUT14=B.NROAUT14
GO
/****** Object:  View [dbo].[EDORDTRA60]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EDORDTRA60]  AS
SELECT * FROM Descarga..EDORDTRA60

GO
/****** Object:  View [dbo].[eqbrevet30]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[eqbrevet30]
AS
SELECT     *
FROM         Descarga.dbo.EQBREVET30
GO
/****** Object:  View [dbo].[ERLLEORD53]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ERLLEORD53]
AS
SELECT     *
FROM         descarga.dbo.ERLLEORD53
GO
/****** Object:  View [dbo].[EVCONTEN04]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[EVCONTEN04]
as
select codcon04,codarm10,codtam09,codbol03 from descarga..edconten04 (nolock)
where fecsal04 is null
GO
/****** Object:  View [dbo].[IDREPORT02]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.IDREPORT02    Script Date: 08/09/2002 6:45:38 PM ******/
ALTER VIEW [dbo].[IDREPORT02] as select * from descarga..IDREPORT02
GO
/****** Object:  View [dbo].[IQTIPREP01]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.IQTIPREP01    Script Date: 08/09/2002 6:45:38 PM ******/
ALTER VIEW [dbo].[IQTIPREP01] as select * from descarga..IQTIPREP01
GO
/****** Object:  View [dbo].[ODITEMS06]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.ODITEMS06    Script Date: 08/09/2002 6:45:39 PM ******/
ALTER VIEW [dbo].[ODITEMS06] AS
SELECT * FROM DESCARGA..ODITEMS06 (nolock)
GO
/****** Object:  View [dbo].[ODTAUDIT03]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[ODTAUDIT03]
AS
SELECT     *
FROM         Oceano.dbo.ODTAUDIT03
GO
/****** Object:  View [dbo].[ORUSRITM11]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.ORUSRITM11    Script Date: 08/09/2002 6:45:39 PM ******/
ALTER VIEW [dbo].[ORUSRITM11] AS
SELECT * FROM DESCARGA..ORUSRITM11
GO
/****** Object:  View [dbo].[TABLA_DE_BALANZAS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TABLA_DE_BALANZAS]
AS
SELECT     *
FROM         Descarga.dbo.TABLA_DE_BALANZAS
GO
/****** Object:  View [dbo].[TICKET00]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TICKET00]
as
select  c.navvia11,c.codcon04,d.fecsal18,d.fecing18,d.nropla18,d.nrotkt18 from DRCTRTMC90 c                   
inner join ddticket18 d on c.nrotkt28=d.nrotkt18 and YEAR(d.fecsal18)>=YEAR(GETDATE())-1
where ISNULL(c.nrotkt28,'')<>''
GO
/****** Object:  View [dbo].[TM_CONDICION_CTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_CONDICION_CTR] as  
select * from descarga..TM_CONDICION_CTR where codbol03 <> '*'

GO
/****** Object:  View [dbo].[TM_LINEA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_LINEA] as
select * from descarga..TM_LINEA

GO
/****** Object:  View [dbo].[TM_PUERTO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_PUERTO] as
select * from descarga..TM_PUERTO

GO
/****** Object:  View [dbo].[TM_TIPO_CTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_TIPO_CTR] as    
select * from descarga..TM_TIPO_CTR where codtip05 <> '*'  
GO
/****** Object:  View [dbo].[VW_NP_OPE_RELDETADU]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[VW_NP_OPE_RELDETADU]  
as  
select dn_rda_nroautoriza_ena, dc_rda_navvia11,dc_rda_contenedor  
from descarga.dbo.NP_OPE_RELDETADU  
where dc_rda_estado <> 'A'  

GO
/****** Object:  View [web].[vw_embarque_reporte_envio_linea_E]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [web].[vw_embarque_reporte_envio_linea_E] as

selecT *
from EVENTOS_LINEAS (nolock) 
where fec_Evento >= CONVERT(CHAR(8),GETDATE() ,112)
GO
/****** Object:  StoredProcedure [dbo].[APLICAR_SHOWCONTIG]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[APLICAR_SHOWCONTIG] 
----------------------------------------------------------------
-- Descripcion	: Sp que Aplica ShowContig a todas las tablas
-- Autor	: Jorge Giovanni Chavez Peralta
-- Fecha	: 27/05/2005
---------------------------------------------------------------
As
Declare @tablename varchar(128)
Declare @id int
Declare @indid int
Declare @indname varchar(128)
Declare @tablename_header varchar(255)
Declare tnames_cursor CURSOR

FOR

--Selecciono los objetos indices
Select obj.name, obj.id, idx.indid, idx.name
From sysobjects as obj JOIN sysindexes AS idx
on obj.id=idx.id
Where type = 'U' and uid = 1 and indid < 255

OPEN tnames_cursor

FETCH NEXT FROM tnames_cursor INTO @tablename, @id, @indid, @indname

WHILE (@@fetch_status <> -1)
BEGIN 
IF  (@@fetch_status <> -2)
BEGIN
     IF @indid=0
        Select @tablename_header = 'Chequeando la fragmentacion de la tabla ' + RTRIM(UPPER(@tablename))    
     IF @indid=1
	Select @tablename_header = 'Chequeando la fragmentacion de indices Clustered ' + RTRIM(UPPER(@tablename))    
     IF @indid>1
	Select @tablename_header = 'Chequeando la fragmentacion de indices NonClustered ' + RTRIM(UPPER(@indname)) + 'de la tabla '+ RTRIM(UPPER(@tablename))    
     print ''
     print @tablename_header	
     select @id = object_id(@tablename)
     dbcc showcontig(@id, @indid)
END
FETCH NEXT FROM tnames_cursor INTO @tablename, @id, @indid, @indname	
END

print ''
Select @tablename_header = '---No hay más tablas---'
print @tablename_header 
print ''

print 'Fragmentacion ha chequeado todas las tablas e indices'
DEALLOCATE tnames_cursor
print 'jchp ;)'

GO
/****** Object:  StoredProcedure [dbo].[busca_OBJTYPE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:				EDUARDO MILLA
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[busca_OBJTYPE]
@OBJNAME			VARCHAR(250),
@OBJTYPE			VARCHAR(150) OUT,
@OBJSCRP			VARCHAR(MAX) OUT

AS

BEGIN
SET NOCOUNT ON;
	
	SELECT DISTINCT 
		@OBJTYPE = o.type_desc ,
		@OBJSCRP = m.definition 
	FROM sys.sql_modules m  
	INNER JOIN sys.objects  o ON m.object_id=o.object_id 
	WHERE o.name = @OBJNAME
	
END



GO
/****** Object:  StoredProcedure [dbo].[demo_neptunia]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
--=================================================================================        
-- CREAMOS EL STORED PROCEDURE        
--=================================================================================        
ALTER PROCEDURE [dbo].[demo_neptunia](        
   @SCODEVE    AS CHAR(05),                                                          
   @SCODLIN    AS CHAR(3),                                                          
   @SCODINT    AS CHAR(06),                                                          
   @SNROCTR    AS CHAR(11),                                                          
   @SFECREG    AS CHAR(14),                                                          
   @DPESCTR    DECIMAL(12,2),        
   @ITRM       AS VARCHAR(06),        
   @OPT01      AS VARCHAR(100),
   @OPT02      AS VARCHAR(100),
   @OPT03      AS VARCHAR(100),
   @OPT04      AS VARCHAR(100),
   @OPT05      AS VARCHAR(100),
   @CODIGORET  INT OUTPUT,         
   @RESULTADO  VARCHAR(8000) OUTPUT)        
AS        
        
BEGIN        
   SET NOCOUNT ON        
                                          
   --SET @BOOKINGBL='' /* se obtiene luego */           
  SET @CODIGORET              = 0        
  SET @RESULTADO              = ''        
  
  --LOGICA DE NEGOCIO


  SET @resultado = @resultado + 'LOCAL=LIMATELEDI2' + ';'        
  SET @resultado = @resultado + 'FRANKLIN=VACACIONES'+ ';'        
  
  --SET @CODIGORET = 999        
  --SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'        
   SET NOCOUNT OFF        
END        
/*        
DECLARE @CODIGORET     INT         
DECLARE @RESULTADO     VARCHAR(8000)        
        
EXECUTE usp_gwc_prepara_datos_eventos '0900','MSC','000023','CONTENEDOR','2016-06-06',40000,@CODIGORET OUTPUT, @RESULTADO OUTPUT        
           
PRINT @CODIGORET        
PRINT @RESULTADO        
*/
GO
/****** Object:  StoredProcedure [dbo].[GUIA_REMISION_NEPTUNIA_EXPO_CLOG]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GUIA_REMISION_NEPTUNIA_EXPO_CLOG]
@navvia char(6),
@nroctr char(11)
as
Select a.navvia11,b.codcon63,a.nrogui73, c.ptoori11 from DDGUICON73 a (NOLOCK), DRGUICTR74 b (NOLOCK), DDCABMAN11 c (nolock) 
Where 
a.nrogui73=b.nrogui73
and a.navvia11=c.navvia11 
and a.navvia11=@navvia
and b.codcon63=@nroctr
GO
/****** Object:  StoredProcedure [dbo].[GUIA_REMISION_NEPTUNIA_EXPO_VENT]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GUIA_REMISION_NEPTUNIA_EXPO_VENT]  
@navvia char(6),  
@nroctr char(11)  
as  
  
select a.navvia11,b.codcon04,a.nrogui19, c.ptoori11 from DDGUITPC19 a (nolock), DRGUITPC20 b (nolock), DDCABMAN11 c (nolock)  
where   
a.nrogui19=b.nrogui19 and   
a.navvia11=c.navvia11 and   
a.navvia11=@navvia and   
b.codcon04=@nroctr and   
a.trasla19 in ( 1, 2 )  
GO
/****** Object:  StoredProcedure [dbo].[LIN_CORRIGE_ATASCOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[LIN_CORRIGE_ATASCOS]  
AS  
  
BEGIN  
 DELETE EVENTOS_LINEAS  
 WHERE   
 COD_EVENTO='1000'  
 AND OPERACION='E'  
 AND CODCON04 IN ( SELECT DISTINCT CODCON04 FROM lin_atasco_eventos (NOLOCK)  )  
 
DELETE lin_atasco_eventos 

END  
GO
/****** Object:  StoredProcedure [dbo].[pre_guiaprecinto]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[pre_guiaprecinto](          
--@nrogui varchar(15)    
--)                                    
--as                              
--begin                              
--      
--declare @CTR char(11)      
--declare @navv varchar(10)      
--declare @nrtk varchar(10)      
--    
--    
--select @nrtk=nrotkt18 from ddguitpc19 (nolock) where nrogui19=@nrogui    
--    
--    
--Select distinct     
--  @navv=a.navvia11,    
--  @CTR=b.codcon04      
--  from  ddticket18 a (nolock)                                      
--  inner join drctrtmc90 b (nolock) on a.nrotkt18=b.nrotkt28                                              
--  Where                                       
--  a.tipope18='T'                                         
--  and a.nrotkt18=@nrtk    
--    
--declare @pre varchar(100)    
--set @pre = 'XXXXX'
--                              
--Select --precintolin=isnull(a.numero,'XX')   
----case when a.numero is null then 0 end as precintolin 
-- @pre=isnull(a.numero,'XX')
--from precintos.dbo.pre_precinto a      
--inner join precintos.dbo.pre_contenedor b on a.idcontenedor=b.idcontenedor      
--where a.tipo='Linea'      
-- and b.codigo=@CTR       
-- and b.naveviaje=@navv      
--      
--select     precintolin=@pre    
--                  
--end 
GO



--ACA***************************************************···························##########################


/****** Object:  StoredProcedure [dbo].[REG_COMISION_EXPO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REG_COMISION_EXPO] --'mol','20141001','20141002'
@sCodLin char(3),
@sFecIni char(8),
@sFecFin char(8)
AS
BEGIN
--DECLARE @sCodLin char(3) = 'PIL' --codigo de linea
--DECLARE @sFecIni char(8) = '20140501'
--DECLARE @sFecFin char(8) = '20140820'
DECLARE @codOfisis char(4) = '004' --EXPO
DECLARE @codUnidad char(3) = '002' --001 CALLAO --002 PAITA
--******************************************************************************
IF OBJECT_ID('tempdb..#TMP_EXPORT_FC') IS NOT NULL
BEGIN
	DROP TABLE #TMP_EXPORT_FC
	drop table #TMP_OFISIS_COMPARA_EXPO
	drop table #TMP_EXPORT_FC_total
END

select distinct 
'1000' as CodEvento, 
c.navvia11 as NavVia, 
c.codcon04 as CodContenedor, 
a.fecsal18 as FecOperacion, 
null as FecIngreso, 
null as FecInspeccion, 
'BAL-EXP' as Sistema,
c.navvia11,
d.genbkg13,
d.codarm10
	INTO #TMP_EXPORT_FC --Tabla Data Operativa Expo
from 
	ddticket18 a (nolock) 
	inner join drctrtmc90 b (nolock) on (a.nrotkt18=b.nrotkt28)
	inner join edllenad16 c (nolock) on (a.navvia11=c.navvia11 and b.codcon04=c.codcon04)
	inner join edbookin13 d (nolock) on (c.genbkg13=d.genbkg13)
where 
	a.fecsal18>=@sFecIni and a.fecsal18<=@sFecFin 
	and (d.codarm10=@sCodLin OR @sCodLin ='')

--**************************************************************************************

SELECT DISTINCT 
'1000' as CodEvento,C.CO_NAVB_CCTR,C.CO_CONT,C.FE_OPER_ENVI --C.CO_LINE
	INTO #TMP_OFISIS_COMPARA_EXPO --Tabla del Ofisis Expo
FROM 
	[10.100.88.16].[OFIRECA].[DBO].[TCOPER_COMI] C (nolock)
WHERE 
	C.FE_OPER_ENVI>=@sFecIni AND C.FE_OPER_ENVI <=@sFecFin
    AND C.CO_PROC_LINE=@codOfisis
    AND C.CO_UNID=@codUnidad   
	AND (C.CO_LINE= @sCodLin OR @sCodLin='')
--**************************************************************************************

SELECT 
codarm10,Navvia,codContenedor,fecoperacion,CO_NAVB_CCTR,CO_CONT,FE_OPER_ENVI,
CASE WHEN CONVERT(VARCHAR,a.fecoperacion,112) + ' ' + LEFT(CONVERT(VARCHAR,a.fecoperacion,108),5)<>CONVERT(VARCHAR,b.FE_OPER_ENVI,112) + ' ' + LEFT(CONVERT(VARCHAR,b.FE_OPER_ENVI,108),5) THEN 'DIF FECHA' ELSE '' END as dif_fec,
DATEDIFF(MINUTE,a.fecoperacion,b.FE_OPER_ENVI) as minutos, ROW_NUMBER() over (order by fecoperacion asc) row_id
	into #TMP_EXPORT_FC_total --Tabla con Registros a Regularizar Expo
FROM 
	#TMP_EXPORT_FC a 
	LEFT JOIN #TMP_OFISIS_COMPARA_EXPO b ON a.codcontenedor = b.co_cont AND a.navvia = b.co_navb_cctr
	where CO_NAVB_CCTR is null
	--or ( DATEDIFF(MINUTE,a.fecoperacion,b.FE_OPER_ENVI)<0 or DATEDIFF(MINUTE,a.fecoperacion,b.FE_OPER_ENVI)>5)

--**************************************************************************************

DECLARE @masLinea CHAR(3), @masNavvia CHAR(8),@masContenedor CHAR(11),@masFecOperativo CHAR(20)
declare @contador_total int, @contador int, @flag char(1)
set @contador=1
select @contador_total=COUNT(*) from #TMP_EXPORT_FC_total --where row_id<=10

while @contador < @contador_total + 1
begin

	SELECT  @masLinea=codarm10,@masNavvia=NavVia,@masContenedor=CodContenedor,@masFecOperativo=(CONVERT(VARCHAR,FecOperacion,112)+' '+CONVERT(VARCHAR(5),FecOperacion,14)) 
	FROM #TMP_EXPORT_FC_total where row_id=@contador
	
	if not exists(select *from Auditoria_Eventos_Expo where Contenedor=@masContenedor and Flag_envio=1 and Navvia=@masNavvia and FecOperativo=@masFecOperativo) 
	begin
		BEGIN TRY
			EXECUTE [sp_Comision_Linea_Expo] @masLinea,@masNavvia,@masContenedor,@masFecOperativo  
			set @flag='1'
		END TRY
		BEGIN CATCH
			set @flag='0'	
		END CATCH
	
		if not exists(select *from Auditoria_Eventos_Expo where Contenedor=@masContenedor and Navvia=@masNavvia and FecOperativo=@masFecOperativo)
		begin
			insert into Auditoria_Eventos_Expo(Linea,Navvia,Contenedor,FecOperativo,Flag_envio)
			values(@masLinea,@masNavvia,@masContenedor,@masFecOperativo,@flag)
		end
		else
		begin
			update Auditoria_Eventos_Expo set Flag_envio=@flag
			where Contenedor=@masContenedor and Navvia=@masNavvia and FecOperativo=@masFecOperativo
		end
	end
	
	set @contador = @contador + 1
	
end

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Actualiza_Pwd]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Actualiza_Pwd]  
as  
begin
	update DBPASSTE99 set PASSWORD = CONVERT(INT, CONVERT(CHAR(6), RAND() * 1000000)) 
	where TIPOPER='E' and PASSWORD is null 
	 
	update DBPASSTE99 set PASSWORD = CONVERT(INT, CONVERT(CHAR(6), RAND() * 1000000))
	where TIPOPER='M' and PASSWORD is null
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Actualiza_Suc_Dep_CTR_Arrumaje_CL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- exec SP_Actualiza_Suc_Dep_CTR_Arrumaje_CL 'GATU1184067', 
ALTER PROCEDURE [dbo].[SP_Actualiza_Suc_Dep_CTR_Arrumaje_CL]

	@CodCon04 Char( 11 ),
	@NavVia11 Char(  6 ),
	@NuevaSuc Char(  1 ),
	@NuevoDep Char(  2 )

As

/*
Declare @CodCon04 Char( 11 )
Declare @NavVia11 Char(  6 )
Declare @NuevaSuc Char(  1 )
Declare @NuevoDep Char(  2 )

Set @CodCon04 = 'GATU1184067'
Set @NavVia11 = '027702'
Set @NuevaSuc = '1'
Set @NuevoDep = 'CL'
*/

/*  -- DEPOSITO
--- Select * from descarga..AQDEPOSI04
coddep04 desdep04                       codalm04 
-------- ------------------------------ -------- 
OC       DEPOSITO LLENOS - VENTANILLA   CO       >>> ORIGEN
CL       CENTRO LOGISTICO               CL       
TA       TERMINAL ARG.VILLEGAS          TA       
*/

/*  -- SUCURSALES
--- Select * from descarga..DQSEDNEP01
codsed01 dessed01                                           
-------- ----------------------
2        VENTANILLA LLENOS      >>> ORIGEN
1        CENTRO LOGISTICO      
3        TERMINAL ARGENTINA    
*/


Declare @GenBkg13 Char( 6 )
Declare @NroTkt18 Char( 8 ) 
Declare @NroAut14 Char( 8 )

--- 1. UPDATE EN ERCONASI17 ==> Campo SUCURSAL, CODDEP04
---    Se obtiene el campo GenBkg13
Select @GenBkg13 = A.genbkg13
from descarga..ERCONASI17 A (NOLOCK),  DESCARGA..EDBOOKIN13 B (nolock) 
where CODCON04 = @CodCon04 AND NAVVIA11 = @NavVia11 AND A.GENBKG13=B.GENBKG13

-- select A.SUCURSAL, a.coddep04, * From descarga..ERCONASI17 A (NOLOCK)
Update descarga..ERCONASI17  
Set    SUCURSAL = @NuevaSuc, coddep04 = @NuevoDep
where  CODCON04 = 'GATU1184067' AND GENBKG13 = @GenBkg13

--- 2. UPDATE EN EDBOOKIN13  ==> Campo CODDEP04
---    Se obtiene el Nro de Autorizacion 
Update DESCARGA..EDBOOKIN13 
Set    coddep04 = @NuevoDep
Where  NAVVIA11 = @NavVia11 AND GENBKG13 = @GENBKG13

--- 3. UPDATE EN EDLLENAD16 ==> Campo SUCURSAL 
---    Se obtiene el Nro de Autorizacion y Nro de Ticket
Select @NroTkt18 = nrotkt18, @NroAut14 = NroAut14 
From descarga..EDLLENAD16 (nolock)
Where  CODCON04 = @CodCon04 and genbkg13 = @GenBkg13

Update descarga..EDLLENAD16 
Set    sucursal = @NuevaSuc
Where  CODCON04 = 'GATU1184067' and genbkg13 = '177561'

--- 4. UPDATE EN EDAUTING14 ==> Campo SUCURSAL 
Update descarga..EDAUTING14 
Set    SUCURSAL = @NuevaSuc
Where  nroaut14 = @NroAut14 

--- 5. UPDATE EN DDTICKET18 ==> Campo SUCURSAL 
Update DDTICKET18 
Set    SUCURSAL = @NuevaSuc
Where  Nrotkt18 = @NroTkt18

GO
/****** Object:  StoredProcedure [dbo].[SP_ALERTA_BALANZA_MODIFICACION_PESOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ALERTA_BALANZA_MODIFICACION_PESOS]        
@nrocambio int        
AS          
BEGIN          
          
DECLARE @ASUNTO varchar(200)          
DECLARE @PARA varchar(500)          
DECLARE @CC varchar(500)          
DECLARE @NEWPASS varchar(10)          
DECLARE @USUARIO varchar(40)          
DECLARE @FECHA varchar(40)          
DECLARE @TICKET varchar(40)          
DECLARE @NAVE varchar(60)          
DECLARE @VIAJE varchar(40)          
DECLARE @CONTENEDOR varchar(15)          
DECLARE @PBANTERIOR varchar(10)          
DECLARE @PTANTERIOR varchar(10)          
DECLARE @PNANTERIOR varchar(10)          
DECLARE @PBNUEVO varchar(10)          
DECLARE @PTNUEVO varchar(10)          
DECLARE @PNNUEVO varchar(10)          
        
Select  @usuario = a.usuario,          
 @fecha = a.fecha,          
 @ticket = a.ticket,        
 @nave = b.desnav08,          
 @viaje = a.viaje,          
 @Contenedor = a.Contenedor,          
 @pbanterior = a.pbanterior,        
 @ptanterior = a.ptanterior,        
 @pnanterior = a.pnanterior,        
 @pbnuevo = a.pbnuevo,        
 @ptnuevo = a.ptnuevo,        
 @pnnuevo = a.pnnuevo        
from DBPASSPE98 a (NOLOCK), DQNAVIER08 b (NOLOCK)        
where nrocambio=@nrocambio        
and a.nave=b.codnav08        
        
          
select @PARA = emailsaenviarmod, @NEWPASS = passwordpeso from dbpasspe97 (nolock)        
          
declare @msg varchar (1000)          
declare @crlf varchar(100)          
        
select @ASUNTO = 'ALERTA DE MODIFICACION DE PESOS - BALANZA'        
select @crlf = char(10)+char(13)          
select @msg = 'SE REALIZO UNA MODIFICACION DE PESOS :' + @crlf + 'USUARIO : ' + @usuario + @crlf + 'FECHA : ' + @fecha + @crlf + 'TICKET : ' + @ticket + @crlf + 'NAVE : ' + @nave + @crlf + 'VIAJE : '     
+ @viaje + @crlf + 'CONTENEDOR : ' + @contenedor + @crlf + 'P.BRUTO ANTERIOR : ' + @pbanterior + @crlf +    
 'P.TARA ANTERIOR : ' + @ptanterior + @crlf + 'P.NETO ANTERIOR : ' + @pnanterior + @crlf + 'P.BRUTO NUEVO : ' + @pbnuevo + @crlf + 'P.TARA NUEVO : ' + @ptnuevo + @crlf +    
 'P.NETO NUEVO : ' + @pnnuevo + @crlf + 'EL NUEVO PASSWORD PARA MODIFICAR PESO ES : ' + @newpass + @crlf         
Execute master.dbo.xp_smtp_sendmail        
 @FROM   = 'aneptunia@neptunia.com.pe',        
 @TO   = @PARA,        
-- @BCC   = 'jchavez@neptunia.com.pe;',        
        @message = @msg,          
        @subject = @ASUNTO,        
        @server = 'correo.neptunia.com.pe'        
          
end 
GO
/****** Object:  StoredProcedure [dbo].[SP_ALERTA_BALANZA_REEFERS_EXPO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ALERTA_BALANZA_REEFERS_EXPO]        
@nrocambio int          
AS            
BEGIN            
return;    
            
DECLARE @ASUNTO varchar(200)            
DECLARE @PARA varchar(500)            
DECLARE @CC varchar(500)            
DECLARE @NAVE varchar(50)            
DECLARE @VIAJE varchar(12)            
DECLARE @CONTENEDOR varchar(15)            
DECLARE @FECHA varchar(40)            
DECLARE @BALANZAENVIO varchar(5)            
         
Select  @nave = b.desnav08,            
@viaje = a.viaje,            
@Contenedor = a.Contenedor,            
@fecha = a.fecha,         
@BalanzaEnvio = CASE WHEN c.deposito = 'OC' then 'VLLENOS'        
                             WHEN c.deposito = 'NE' then 'ZONA2'        
                             WHEN c.deposito = 'TA' then 'VILLEGAS'        
                             WHEN c.deposito = 'CL' then 'CENLOG' END        
from EBNEXREF99 a (NOLOCK), DQNAVIER08 b (NOLOCK), IPSBALANZAS c (NOLOCK)        
where nrocambio=@nrocambio          
and a.nave=b.codnav08          
and a.balanzaenvio=c.cod_balanza        
order by 1 asc            
            
select @PARA = emailsenvio FROM EBNEXTEL99 (nolock)        
            
declare @msg varchar (500)            
declare @crlf varchar(10)            
      
         
select @ASUNTO = 'ALERTA REEFERS EXPO'          
select @crlf = char(10)+char(13)            
select @msg = 'NAVE: ' + @nave + @crlf + 'VIAJE: ' + @viaje + @crlf + 'CTR: ' + @contenedor + @crlf + 'FECHA: ' + @fecha + @crlf + 'DEPOT: ' + @Balanzaenvio + @crlf        
Execute master.dbo.xp_smtp_sendmail          
 @FROM   = 'aneptunia@neptunia.com.pe',          
 @TO   = @PARA,          
         @message = @msg,            
         @subject = @ASUNTO,          
         @server = 'correo.neptunia.com.pe'          
           
end 
GO
/****** Object:  StoredProcedure [dbo].[SP_ALERTA_BALANZA_SOBREPESOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ALERTA_BALANZA_SOBREPESOS]    
@nrocambio int    
AS      
BEGIN      
    
      
DECLARE @ASUNTO varchar(200)      
DECLARE @PARA varchar(500)      
DECLARE @CC varchar(500)      
DECLARE @NEWPASS varchar(10)      
DECLARE @USUARIO varchar(40)      
DECLARE @FECHA varchar(40)      
DECLARE @TICKET varchar(40)      
DECLARE @NAVE varchar(60)      
            DECLARE @VIAJE varchar(40)      
DECLARE @CONTENEDOR varchar(15)      
DECLARE @PNANTERIOR varchar(10)      
DECLARE @PNNUEVO varchar(10)      
    
Select   @usuario = a.usuario,      
            @fecha = a.fecha,      
            @ticket = a.ticket,    
            @nave = b.desnav08,      
            @viaje = a.viaje,      
            @Contenedor = a.Contenedor,      
            @pnanterior = a.pnanterior,    
            @pnnuevo = a.pnnuevo    
from DBPASSPE98 a (NOLOCK), DQNAVIER08 b (NOLOCK)    
where nrocambio=@nrocambio    
and a.nave=b.codnav08    
order by 1 asc      
      
select @PARA = emailsaenviaremb, @NEWPASS = passwordpeso from dbpasspe97 (nolock)    
      
declare @msg varchar (1000)      
declare @crlf varchar(100)      
    
select @ASUNTO = 'ALERTA DE EXCESO DE PESO (+-5%)  - BALANZA'    
select @crlf = char(10)+char(13)      
select @msg = 'SE HA REALIZADO UNA DIFERENCIA +-5 % DEL TOTAL DE LLENADO VS EL PESO NETO DEL(0S) CTR(S) A EMBARCAR  :' + @crlf + 'USUARIO : ' + @usuario + @crlf + 'FECHA : ' + @fecha + @crlf + 'TICKET : ' + @ticket + @crlf + 'NAVE : ' + @nave + @crlf + 'V
  
IAJE : ' + @viaje + @crlf + 'CONTENEDOR : ' + @contenedor + @crlf + 'TOTAL LLENADOS DEL(0S) CTR(S)   : ' + @pnanterior + @crlf + 'P.NETO DEL CTR A EMBARCAR : ' + @pnnuevo + @crlf     
Execute master.dbo.xp_smtp_sendmail    
            @FROM                                  = 'aneptunia@neptunia.com.pe',    
            @TO                            = @PARA,    
            @BCC                         = 'sparraga@neptunia.com.pe;cbringas@neptunia.com.pe;gespozzito@neptunia.com.pe',    
        @message = @msg,      
        @subject = @ASUNTO,    
        @server = 'correo.neptunia.com.pe'    
      
end    
    
    
    
GO
/****** Object:  StoredProcedure [dbo].[SP_AUTORIZACION]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_AUTORIZACION    Script Date: 08/09/2002 6:45:40 PM ******/
ALTER PROCEDURE [dbo].[SP_AUTORIZACION]
@NROAUT CHAR (8)
AS
Select a.nropla81,a.fecaut14,b.conten13,a.genbkg13,a.navvia11,a.codage19,
c.nombre,d.desemb06 
from descarga..edauting14 a (nolock), descarga..edbookin13 b (nolock), 
descarga..aaclientesaa c (nolock), descarga..dqembala06 d (nolock) 
Where a.genbkg13 = b.genbkg13 and a.codage19 = c.contribuy 
and a.codemb06 = d.codemb06 and a.nroaut14 = @NROAUT
GO
/****** Object:  StoredProcedure [dbo].[SP_AUTORIZACION_v2]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AUTORIZACION_v2]  
@NROAUT CHAR (8)  
AS  
Select a.nropla81,a.fecaut14,b.conten13,a.genbkg13,a.navvia11,a.codage19,  
c.nombre,d.desemb06, a.codcon14, a.codemb06   
from descarga..edauting14 a (nolock), descarga..edbookin13 b (nolock),   
descarga..aaclientesaa c (nolock), descarga..dqembala06 d (nolock)   
Where a.genbkg13 = b.genbkg13 and a.codage19 = c.contribuy   
and a.codemb06 = d.codemb06 and a.nroaut14 = @NROAUT
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_EXPO_DATOS_BOOKING_LLENADO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_BALANZA_EXPO_DATOS_BOOKING_LLENADO]
@NAVVIA AS CHAR(6),
@TICKET AS CHAR(8)
AS
Select ISNULL(a.bookin13,'') AS bookin13,ISNULL(b.codpro27,'') AS codpro27,
ISNULL(a.ruccli13,'') AS ruccli13 
from edbookin13 a (nolock), edllenad16 b (nolock) 
where a.navvia11 = @NAVVIA and b.nrotkt18 = @TICKET
and a.genbkg13=b.genbkg13 and a.navvia11=b.navvia11 
-----------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[sp_balanzadefra]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_balanzadefra    Script Date: 08/09/2002 6:45:40 PM ******/
ALTER PROCEDURE [dbo].[sp_balanzadefra] AS
dbcc dbreindex (DDBPLACA24,XYX,70,sorted_data_reorg)
dbcc dbreindex (DDGUIARE19,PK___2__32,70,sorted_data_reorg)
dbcc dbreindex (DDTICKET18,PK_DDTICKET18_1__45,70,sorted_data_reorg)
dbcc dbreindex (DRCTRTMC90,PK_DRCTRTMC90_1__23,70,sorted_data_reorg)
dbcc dbreindex (DRGUICTR20,PK___1__32,70,sorted_data_reorg)
dbcc dbreindex (DRORDTKT89,PK___1__33,70,sorted_data_reorg)
dbcc dbreindex (DRPESORP55,PK___1__22,70,sorted_data_reorg)
dbcc dbreindex (DRTICKCS99,PK___1__45,70,sorted_data_reorg)
dbcc dbreindex (DRTICKET18,XYZ,70,sorted_data_reorg)
GO
/****** Object:  StoredProcedure [dbo].[SP_BULPAR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BULPAR    Script Date: 08/09/2002 6:45:40 PM ******/
/****** Object:  Stored Procedure dbo.SP_BULPAR    Script Date: 02/09/2000 3:52:16 PM ******/
ALTER PROCEDURE [dbo].[SP_BULPAR]
@NROSAL char (6)
AS
Select xx = sum(bulret53) from descarga..dritmalm53 (NOLOCK)
where nrosal52 = @NROSAL

GO
/****** Object:  StoredProcedure [dbo].[SP_BULRET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BULRET    Script Date: 08/09/2002 6:45:44 PM ******/
/****** Object:  Stored Procedure dbo.SP_BULRET    Script Date: 02/09/2000 3:52:16 PM ******/
ALTER PROCEDURE [dbo].[SP_BULRET] 
@NROORD char (6)
AS
Select icont = sum(bulret18) from ddticket18 (NOLOCK)
where nroord41 = @NROORD

GO
/****** Object:  StoredProcedure [dbo].[SP_BUSBLOQUEO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSBLOQUEO    Script Date: 08/09/2002 6:45:45 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSBLOQUEO    Script Date: 02/09/2000 3:52:16 PM ******/
--ALTER PROCEDURE [dbo].[SP_BUSBLOQUEO]
/* ---------------------------------------*/
/* RETORNA SI TIENE BLOQUEOS EN LA SALIDA */
/* ---------------------------------------*/
--@ORDENR  Char (6)
--AS
--Select a.pesaut41,a.nrobul41,a.nrofac47,a.navvia11,razage19=b.nombre,c.desemb06,
--a.codemb06, d.glosbl60, d.usublo60, d.fecblo60, d.usudes60 
--from ddordret41 a (NOLOCK), aaagente01 b (NOLOCK), dqembala06 c (NOLOCK), descarga..ddblodes60 d (NOLOCK)
--where a.codage19=b.cliente and a.codemb06=c.codemb06 and 
--a.nroord41*=d.nroord41 and a.nroord41 = @ORDENR
--GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCADOCUMENTACION]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_BUSCADOCUMENTACION]
@nroaut char(8)
as 
Select nroaut14,notemb16 from erlleord53 (nolock)
where nroaut14=@nroaut

GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCASA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSCASA    Script Date: 08/09/2002 6:45:40 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSCASA    Script Date: 02/09/2000 3:52:16 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSCASA]
/* ----------------------------------------------*/
/* RETORNA DATOS DE LA SALIDA DE ALMACEN  - JCHP */
/* ----------------------------------------------*/
@SALIDA char(6)
AS
Select b.nropla52,a.nroord41,b.tipalm52,b.navvia11,b.fecsal52  
from dritmalm53 a (NOLOCK), ddsalmac52 b (NOLOCK)
where a.nrosal52 = b.nrosal52 and a.nrosal52 = @SALIDA
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAUTOR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSCAUTOR    Script Date: 08/09/2002 6:45:45 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSCAUTOR] 
/* ------------------------------------------------------------	*/
/* RETORNA DATOS DEL TICKET YA GENERADO ANTERIORMENTE           */
/* CON LA AUTORIZACION DE INGRESO DE ACUERDO AL LLENADO FC/LC	*/
/* ------------------------------------------------------------ */
/* AUTOR : JORGE CHAVEZ PERALTA        	       FECHA: 08/MAR/97 */
/* ------------------------------------------------------------ */
@splaca char(7),
@sautor char(8)
As
SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,
a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,
c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,d.nroitm16,b.genbkg13
FROM 
balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),
descarga..edllenad16 d (nolock)
WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11) 
AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11) 
AND (b.nroaut14 = d.nroaut14) AND a.nropla18 = @splaca AND a.status18 = 'P' 
AND d.nroaut14 = @sautor AND d.nrotkt18 is null
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAUTORIZ]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************   
--MODULO: BALANZA EXPORTACION   
--Usuario Creador  : JORGE CHAVEZ PERALTA.   
--Fecha Creacion  : ?  
--Usuario Modificador : EDQP  
--Fecha Modificacion : 22/12/2014  
--Descripcion   : RETORNA DATOS DEL TICKET YA GENERADO ANTERIORMENTE               
        CON LA AUTORIZACION DE INGRESO DE ACUERDO AL LLENADO FC/LC  
-- frmbalexsal  
*****************************************/
ALTER PROCEDURE [dbo].[SP_BUSCAUTORIZ] (
	@splaca CHAR(7)
	,@sautor CHAR(8)
	--,@BVERSION INT = 0  
	)
AS
BEGIN
	--SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,    
	--a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,    
	--c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,  
	--d.nroitm16,b.genbkg13,d.codpro27,c.codarm10,c.codtip05  
	--FROM     
	--balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),    
	--descarga..edllenad16 d (nolock)    
	--WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)     
	--AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11)     
	--AND (b.nroaut14 = d.nroaut14) AND a.nropla18 = @splaca AND a.status18 = 'P'      
	--AND d.nroaut14 = @sautor AND d.nrotkt18 is null  
	SELECT a.nrotkt18
		,b.navvia11
		,b.nroaut14
		,a.status18
		,a.nropla18
		,c.codcon04
		,a.pesbrt18
		,b.fecaut14
		,b.codage19
		,b.conten13
		,c.codtam09
		,codbol03 = ISNULL(c.codbol03,'')
		,d.nrobul16
		,d.codemb06
		,nomemb16 = b.nomemb14
		,d.nroitm16
		,b.genbkg13
		,d.codpro27
		,c.codarm10
		,c.codtip05
	FROM balanza..ddticket18 a(NOLOCK)
		,descarga..edauting14 b(NOLOCK)
		,descarga..edconten04 c(NOLOCK)
		,descarga..edllenad16 d(NOLOCK)
	WHERE (a.nropla18 = b.nropla81)
		AND (a.navvia11 = b.navvia11)
		AND (c.codcon04 = d.codcon04)
		AND (b.navvia11 = d.navvia11)
		AND (b.nroaut14 = d.nroaut14)
		AND a.nropla18 = @splaca
		AND a.status18 = 'P'
		AND d.nroaut14 = @sautor --AND d.nrotkt18 is null  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAUTORIZ2]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[SP_BUSCAUTORIZ2]     
/* -------------------------------------------------------------*/  
/* RETORNA DATOS DEL TICKET YA GENERADO ANTERIORMENTE           */    
/* CON LA AUTORIZACION DE INGRESO DE ACUERDO AL LLENADO FC/LC   */    
/* ------------------------------------------------------------ */    
/* AUTOR : JORGE CHAVEZ PERALTA                   */    
/* -------------------------------------------------------------*/    
@splaca char(7),    
@contenedor char(11),    
@sautor char(8)    
AS    
    
--SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,    
--a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,    
--c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,  
--d.nroitm16,b.genbkg13,d.codpro27,c.codarm10,c.codtip05  
--FROM     
--balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),    
--descarga..edllenad16 d (nolock)    
--WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)     
--AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11)     
--AND (b.nroaut14 = d.nroaut14) AND a.nropla18 = @splaca AND a.status18 = 'P'      
--AND d.nroaut14 = @sautor AND d.nrotkt18 is null  
  
  
SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,    
a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,    
c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,  
d.nroitm16,b.genbkg13,d.codpro27,c.codarm10,c.codtip05  
FROM     
balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),    
descarga..edllenad16 d (nolock)    
WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)     
AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11)     
AND (b.nroaut14 = d.nroaut14) AND a.nropla18 = @splaca AND a.status18 = 'S'      -- momentaneo
AND d.nroaut14 = @sautor --AND d.nrotkt18 is null  
and d.codcon04=@contenedor   
  
-------------------------
--
--SELECT TOP 10 a.status18, a.nrotkt18,b.navvia11,b.nroaut14,a.status18,    
--a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,    
--c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,  
--d.nroitm16,b.genbkg13,d.codpro27,c.codarm10,c.codtip05  
--FROM     
--balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),    
--descarga..edllenad16 d (nolock)    
--WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)     
--AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11)     
--AND (b.nroaut14 = d.nroaut14) 
--AND a.nropla18 ='yy0035'--'T3F823'
----and d.codcon04='TRLU2053521'--'SUDU8898106'
----AND a.status18 = 'S'      
----AND d.nroaut14 = @sautor --AND d.nrotkt18 is null  
----
------CRXU9506066
--ORDER BY FECAUT14 DESC
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAVEHCS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************	
--MODULO: BALANZA EXPORTACION 
--Usuario Creador		: JORGE CHAVEZ PERALTA. 
--Fecha Creacion		: ?
--Usuario Modificador	: EDQP
--Fecha Modificacion	: 22/12/2014
--Descripcion			: RETORNA DATOS DEL TICKET YA GENERADO ANTERIORMENTE            
						  CON LA AUTORIZACION DE INGRESO PARA VEHICULOS O CARGA SUELTA
-- frmbalexsal
*****************************************/
ALTER PROCEDURE [dbo].[SP_BUSCAVEHCS](
	@splaca		char(7),  
	@sautor		char(8)
	--,@BVERSION	INT = 0
)
As  
BEGIN
	SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,  
	a.nropla18,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,  
	c.nrobul16,c.codemb06,b.codemc12,c.nroitm16,c.nrocha16,
	c.marcas16,nomemb16=b.nomemb14,b.genbkg13, '' as  codtip05, c.codpro27
	FROM balanza..ddticket18 a (nolock), 
		descarga..edauting14 b (nolock),
		descarga..edllenad16 c (nolock)  
	WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)   
	AND (b.navvia11 = c.navvia11) AND (b.nroaut14 = c.nroaut14)   
	AND a.nropla18 = @splaca AND a.status18 = 'I'   
	AND c.nroaut14 = @sautor AND c.nrotkt18 is null
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSGUIAS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_BUSGUIAS]    
@NROGUIA varchar(10)    
AS    
SELECT a.nrogui73 as Guia,  a.nropla73 as Placa, b.codcon63  as Contenedor 
from terminal.dbo.DDGUICON73 as a     
INNER join terminal.dbo.DRGUICTR74 AS B on a.nrogui73 = b.nrogui73    
where a.nrogui73 = @nroguia    
return 0
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSNCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSNCTR    Script Date: 08/09/2002 6:45:45 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSNCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSNCTR] 
/*-----------------------------------------------*/
/* RETORNA DATOS DEL TICKET DE CTRS.	 - JCHP  */
/*-----------------------------------------------*/
@NAVE char(6),
@SCTR char(11)
AS
Select navvia11,codcon04,nrotkt18 from ddticket18 (NOLOCK)
where codcon04 = @SCTR and navvia11 = @NAVE

GO
/****** Object:  StoredProcedure [dbo].[SP_BUSPLA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSPLA    Script Date: 08/09/2002 6:45:45 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSPLA    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSPLA]
/* ----------------------------------------------*/
/* RETORNA DATOS DE LA PLACA DEL TICKET	  - JCHP */
/* ----------------------------------------------*/
@PLACA char(7)
AS
Select * from ddticket18 (NOLOCK)
where nropla18 =@PLACA and tipope18 not in ('R','E','T') 
and status18 = 'I'

GO
/****** Object:  StoredProcedure [dbo].[SP_BUSRETBUL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSRETBUL    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSRETBUL    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSRETBUL]
@NROSAL char (6)
AS
Select a.codemb06,a.bulalm53,a.bulret53,a.nrocar16,a.nrosec22,
b.desemb06,c.pestar22 
from dritmalm53 a (NOLOCK), dqembala06 b (NOLOCK), ddcartar22 c (NOLOCK)
where a.nrosal52 = @NROSAL and a.codemb06 = b.codemb06 
and a.nrocar16=c.nrocar16 and a.nrosec22=c.nrosec22

GO
/****** Object:  StoredProcedure [dbo].[SP_BUSRETCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSRETCTR    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSRETCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSRETCTR] 
@NROSAL char  (6),
@NAVVIA char  (6)
AS
Select distinct a.codcon63,b.codtam09,b.codtip05,a.nrodet12,
b.navvia11,d.desnav08,c.numvia11 
from dritmalm53 a (NOLOCK), ddcontar63 b (NOLOCK), ddcabman11 c (NOLOCK), dqnavier08 d (NOLOCK)
where a.codcon63 = b.codcon63 and a.nrosal52 = @NROSAL
and b.navvia11 = @NAVVIA and b.fecsal63 is null
and b.navvia11 = c.navvia11 and c.codnav08 = d.codnav08

GO





/****** Object:  StoredProcedure [dbo].[SP_BUSRETVEH]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSRETVEH    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_BUSRETVEH    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSRETVEH]
@NROSAL  char (6),
@NAVVIA  char (6)
AS
Select a.nroveh14,b.chatar14,b.desitm14,c.numvia11,d.desnav08 
from dritmalm53 a (NOLOCK), ddvehicu14 b (NOLOCK), descarga..ddcabman11 c (NOLOCK), descarga..dqnavier08 d (NOLOCK)
where a.nroveh14 = b.nroveh14 and a.nrosal52 = @NROSAL
and b.fecsal14 is null and b.navvia11 = @NAVVIA
and b.navvia11 = c.navvia11 and c.codnav08 = d.codnav08
GO
--/****** Object:  StoredProcedure [dbo].[sp_Comision_Linea_Expo]    Script Date: 07/03/2019 01:34:47 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[sp_Comision_Linea_Expo]                 
--@sCodLin char(3),                        
--@sCodInt char(06),                        
--@sNroCtr char(11),                        
--@sFecOpe char(14)
--as

--/*
--OSI					IMPO/EXPO	
--CLIENTE FINAL		TODOS	
--*/
--declare @sCodUni char(3) --(001:Callao - 002:Paita)
--declare @sCodPro char(10)
--declare @sTamCtr char(2)
--declare @sOpeLog char(11)
--declare @sStaMov char(1) --S/N
--declare @sReEntr char(1) --S/N
--declare @sStSada char(1) --S/N
--declare @sSerInt char(1) --S/N
--------

--declare @iCountStaMov int
--declare @iCountReEntr int
--declare @iCountStSada int
--declare @iCountSerInt int

--set @sCodUni='001'
--set @sCodPro='EXPORT FC'
--set @sOpeLog=''
--set @sStaMov='N'
--set @sReEntr='N'
--set @sStSada='N'

----set @sTamCtr = 'ST'
--select top 1 @sTamCtr=codtam09 from edconten04 (nolock) where codcon04=@sNroCtr

--SELECT @sReEntr=(CASE WHEN ISNULL(flgree15,'0') = '1' THEN 'S' ELSE 'N' END) FROM Oceanica1.Descarga.dbo.adregeir15 WHERE navvia11 =@sCodInt and codcon04 = @sNroCtr

--select @iCountSerInt=count(*) from  
--edbookin13 a (nolock)
--inner join edllenad16 b (nolock) on (a.genbkg13=b.genbkg13)
--inner join terminal.dbo.ssi_orden  c          on (a.bookin13=c.ORD_NUMDOCUMENTO and b.navvia11=c.ORD_NAVVIA)
--where c.ord_codigo like 'E%' and c.ord_flagEstado <>'A' and b.navvia11=@sCodInt and b.codcon04=@sNroCtr

--if @iCountSerInt=0
--	set @sSerInt='N'
--else
--	set @sSerInt='S'

----*** INI - VALIDA DUPLICADOS ***********
--IF NOT EXISTS(SELECT TOP 1 O.CO_CONT FROM [10.100.88.16].[OFIRECA].[dbo].TCOPER_COMI O 
--			   WHERE LTRIM(RTRIM(O.CO_UNID)) = LTRIM(RTRIM(@sCodUni))
--				 AND LTRIM(RTRIM(O.CO_LINE)) = LTRIM(RTRIM(@sCodLin))
--				 AND LTRIM(RTRIM(O.CO_PROC_LINE)) = '004' --EXPO
--				 AND LTRIM(RTRIM(O.CO_CONT)) = @sNroCtr
--				 AND LTRIM(RTRIM(O.CO_NAVB_CCTR)) = @sCodInt
--				 AND CONVERT(VARCHAR,O.FE_OPER,112) = CONVERT(VARCHAR,CONVERT(DATETIME,@sFecOpe),112)
--			  )
--	BEGIN         
--		--select @sCodUni, @sCodLin, @sCodPro,@sNroCtr,@sCodInt,@sTamCtr,@sFecOpe,@sOpeLog,@sStaMov,@sReEntr,@sStSada,@sSerInt
--		exec [10.100.88.16].OFIRECA.dbo.NP_TCOPER_COMI_I01 @sCodUni, @sCodLin, @sCodPro,@sNroCtr,@sCodInt,@sTamCtr,@sFecOpe,@sOpeLog,@sStaMov,@sReEntr,@sStSada,@sSerInt
--	END;
--*** FIN - VALIDA DUPLICADOS ***********
GO
/****** Object:  StoredProcedure [dbo].[SP_CTRLIG]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CTRLIG    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_CTRLIG    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_CTRLIG]
/* ----------------------------------------------*/
/* RETORNA DATOS DEL CTR A BUSCAR 	  - JCHP */
/* ----------------------------------------------*/
@CTR char(11),
@NAV char(6)
AS
Select * from descarga..drblcont15 (NOLOCK)
where codcon04=@CTR and navvia11=@NAV

GO
/****** Object:  StoredProcedure [dbo].[SP_CTRS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CTRS    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_CTRS    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_CTRS]
/* ----------------------------------------------*/
/* RETORNA LA NAVE/VIAJE Y EL CTR A BUSCA - JCHP */
/* ----------------------------------------------*/
@CTR char(11)
AS
Select navvia11,codcon04 from ddconten04 (NOLOCK) where codcon04=@CTR

GO
/****** Object:  StoredProcedure [dbo].[SP_CTRSNAV]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CTRSNAV    Script Date: 08/09/2002 6:45:41 PM ******/
/****** Object:  Stored Procedure dbo.SP_CTRSNAV    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_CTRSNAV]
/* ----------------------------------------------*/
/* RETORNA LA NAVE/VIAJE Y EL CTR A BUSCAR- JCHP */
/* ----------------------------------------------*/
@CTR char(11),
@NAV char(6)
AS
Select * from ddconten04 (NOLOCK) where codcon04=@CTR 
and navvia11=@NAV

GO
/****** Object:  StoredProcedure [dbo].[SP_CTRSXNAVE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CTRSXNAVE    Script Date: 08/09/2002 6:45:42 PM ******/
/****** Object:  Stored Procedure dbo.SP_CTRSXNAVE    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_CTRSXNAVE]
/* -------------------------------------------------*/
/* RETORNA LOS CTRS POR NAVE PARA EVALUARLOS - JCHP */
/* -------------------------------------------------*/
@SNAVIA char(6)
AS
SELECT CODCON04 FROM DDCONTEN04 (NOLOCK) WHERE NAVVIA11 = @SNAVIA

GO
/****** Object:  StoredProcedure [dbo].[SP_DESTARE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_DESTARE    Script Date: 08/09/2002 6:45:46 PM ******/
/****** Object:  Stored Procedure dbo.SP_DESTARE    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_DESTARE] 
/* ---------------------------------------------------*/
/* RETORNA DATOS DE ACUERDO A UNA PLACA Y FECHA- JCHP */
/* ---------------------------------------------------*/
@NPLACA char(7),
@VFECHA char(8)
as
Select tipope18=case when tipope18='D' then 'ING.CTRS.'
when tipope18='M' then 'ING.MERC.'
else 'ING.VEHS.' end, * from ddticket18 (NOLOCK)
where nropla18=@NPLACA and fecing18 >=@VFECHA and 
tipope18 not in ('R','E','T')
order by fecing18

GO
/****** Object:  StoredProcedure [dbo].[SP_EMB_BUSCACTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_EMB_BUSCACTR    Script Date: 08/09/2002 6:45:42 PM ******/
ALTER PROCEDURE [dbo].[SP_EMB_BUSCACTR] 
@sconte char (11)
AS
Select a.codbol03,a.codtam09,b.navvia11,c.feclle11 
from DESCARGA..edconten04 a (nolock), DESCARGA..edllenad16 b (nolock), 
DESCARGA..ddcabman11 c (nolock) 
where a.codcon04 = b.codcon04 and b.codcon04 = @sconte
and b.navvia11 = c.navvia11 order by c.feclle11 desc
GO
/****** Object:  StoredProcedure [dbo].[SP_EMB_CTRTPC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EMB_CTRTPC]         
@nroctr  char(11)        
AS        
Select pesoctr=sum(b.pesmer16),        
--Select pesoctr=case when b.codemb06 = 'CTR' then sum(b.pesmer16) else sum(b.pesmer16)+(a.nrotar04) end,          
a.codbol03,a.codtam09,b.navvia11,c.feclle11,b.genbkg13,b.codemb06,        
a.nrotar04,      
--b.preadu16,      
case when (b.nropre16='' or b.nropre16 is null) then b.preadu16 else b.nropre16 end preadu16,      
b.oemadu16,d.codaut17, e.conten13, e.codpue02, a.codarm10, d.carta, d.flgreefer, e.codTipReefer,
d.fecVenCarta     
from DESCARGA..edconten04 a (nolock), DESCARGA..edllenad16 b (nolock),         
DESCARGA..ddcabman11 c (nolock), DESCARGA..erconasi17 d (nolock), DESCARGA..edbookin13 e (nolock)         
where a.codcon04 = b.codcon04 and b.codcon04 = @nroctr        
and b.navvia11=c.navvia11 and a.codcon04=d.codcon04         
and b.codcon04=d.codcon04 and d.genbkg13=e.genbkg13         
and b.genbkg13=e.genbkg13 and b.genbkg13=d.genbkg13         
and b.navvia11=e.navvia11 and c.navvia11=e.navvia11        
--and a.fecsal04 is null        
group by a.codbol03,a.codtam09,b.navvia11,c.feclle11,b.genbkg13,b.codemb06,          
a.nrotar04,b.nropre16,b.preadu16,b.oemadu16,d.codaut17,e.conten13, e.codpue02, a.codarm10,  
d.carta, d.flgreefer, e.codTipReefer, d.fecVenCarta
order by c.feclle11 desc
GO
/****** Object:  StoredProcedure [dbo].[SP_EMBCTRTMC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_EMBCTRTMC    Script Date: 08/09/2002 6:45:46 PM ******/
ALTER PROCEDURE [dbo].[SP_EMBCTRTMC]
@FECINI char(8),
@FECFIN char(8)
AS
SELECT a.nrotkt28, XX=substring(a.codcon04,1,4), 
YY=substring(a.codcon04,5,11),
b.nrotkt18, b.navvia11, b.nropla18,
b.pesnet18,b.fecing18,b.fecsal18,c.codcon04,c.codtip05,
c.codtam09,payloa04=(c.payloa04 * 1000), d.numvia11, e.desnav08
FROM DRCTRTMC90 a (NOLOCK), DDTICKET18 b (NOLOCK), EDCONTEN04 c (NOLOCK),
DDCABMAN11 d, DQNAVIER08 e
WHERE a.nrotkt28 = b.nrotkt18 
AND a.navvia11 = b.navvia11
AND a.codcon04 = c.codcon04 
AND b.navvia11 = d.navvia11
AND d.codnav08 = e.codnav08
AND b.tipope18 = 'T' 
AND b.status18 = 'S' 
AND b.fecsal18 >= @FECINI
AND b.fecsal18 < @FECFIN
ORDER BY YY
GO
/****** Object:  StoredProcedure [dbo].[SP_EMBREP_GUITPC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_EMBREP_GUITPC] @fecini CHAR(8)
	,@fecfin CHAR(8)
AS
INSERT INTO DTGUITPC99
SELECT A.NROGUI19
	,A.VPLACA19
	,A.NROTKT18
	,A.CODBRE30
	,B.DESNAV08
	,SUBSTRING(C.NUMVIA11,1,7)
	,D.NOMBRE30
	,E.CODCON04
	,E.CODTAM09
	,E.CODBOL03
	,E.NROTAR04
	,E.PREADU16
	,E.OEMADU16
	,E.CODAUT17
	,E.CONTEN13
	,E.MARCAS16
	,HOSTID99 = substring(host_name(), 1, 15)
	,A.FECGUI19
	,SUCURSAL = ''
FROM DDGUITPC19 A(NOLOCK)
	,DESCARGA..DQNAVIER08 B(NOLOCK)
	,DESCARGA..DDCABMAN11 C(NOLOCK)
	,DESCARGA..EQBREVET30 D(NOLOCK)
	,DRGUITPC20 E(NOLOCK)
WHERE A.NAVVIA11 = C.NAVVIA11
	AND B.CODNAV08 = C.CODNAV08
	AND A.CODBRE30 = D.CODBRE30
	AND A.NROGUI19 = E.NROGUI19
	AND A.FECGUI19 >= @fecini
	AND A.FECGUI19 < @fecfin
ORDER BY A.NROGUI19
GO
/****** Object:  StoredProcedure [dbo].[SP_ENAPU_DATOSLLENADO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ENAPU_DATOSLLENADO    Script Date: 08/09/2002 6:45:46 PM ******/
ALTER PROCEDURE [dbo].[SP_ENAPU_DATOSLLENADO]
@TICKET char (8)
AS
Select nrotar18,nroaut14,nropla18,codusu17,pesbrt18,pesnet18,
fecing18,fecsal18,buling18,codcon04,codemb06 
from ddticket18 (nolock) where nrotkt18 = @TICKET
GO
/****** Object:  StoredProcedure [dbo].[SP_ENAPU_DATOSTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ENAPU_DATOSTICKET    Script Date: 08/09/2002 6:45:46 PM ******/
ALTER PROCEDURE [dbo].[SP_ENAPU_DATOSTICKET]
@ticket char(8),
@nviaje char(6)
as
Select a.nropla18,a.codusu17,a.pesbrt18,a.pesnet18,a.fecing18,a.fecsal18,a.codemb06,a.nroord41,
a.nrosal52,a.bulret18,b.codcon63,c.pesbrt63,c.nrotar63,c.codbol03,c.codtip05 
from ddticket18 a (nolock), drblcont15 b (nolock), ddcontar63 c (nolock) 
where a.navvia11=b.navvia11 and a.nrotkt18=b.nrotkt28 
and b.navvia11=c.navvia11 and b.codcon63=c.codcon63 
and a.navvia11=c.navvia11 and a.nrotkt18 = @ticket and a.navvia11 = @nviaje
GO
/****** Object:  StoredProcedure [dbo].[SP_ENAPU_MAE_AUT]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ENAPU_MAE_AUT    Script Date: 08/09/2002 6:45:46 PM ******/
ALTER PROCEDURE [dbo].[SP_ENAPU_MAE_AUT] 
@nroord char(6)
as
Select a.codage19,a.navvia11,a.fecexp41,a.nrofac37,a.nrodet12,a.nrobul41,
a.codemb06,a.pesaut41,b.nropol44,c.numman11,d.nrocon12,d.codarm10
from ddordret41 a (nolock), drpolfac42 b (nolock), 
ddcabman11 c (nolock), dddetall12 d (nolock)
where a.nrofac37=b.nrofac37
and a.navvia11=c.navvia11
and a.navvia11=d.navvia11
and c.navvia11=d.navvia11
and a.nrodet12=d.nrodet12
and a.nroord41 = @nroord

GO
/****** Object:  StoredProcedure [dbo].[sp_envio_correo_edi_hapag_lloyd]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_envio_correo_edi_hapag_lloyd]        
 @para as varchar(500),        
 @copia as varchar(500),        
 @cuerpo as varchar(8000),        
 @asunto as varchar(500),        
 @rutaarchivoadjunto as varchar(500)        
/**********        
 @para    : destino del correo        
 @copia    : si son varias direcciones separadas por comas ejem: jperez@gmail,gzamudio@hotmail.com, si no hay destinatarios         
      se envia cadena vacia.        
 @cuerpo   : Texto del mensaje que será enviado.        
 @asunto   : Asunto del mensaje        
 @rutaarchivoadjunto  : Ruta del archivo adjunto en cualquiera de los siguientes formatos        
      \\nombre_pc\nombre_carpeta_compartida\nombre_archivo.txt        
      \\numero_ip\nombre_carpeta_compartida\nombre_archivo.txt        
Descripción:        
 El stored al ejecutarse correctamente lo cual no implica que el correo llegue al destinatario, devuelve el valor 0 (cero)        
 en caso existiera un error devuelve un valor distinto a 0.        
**********/        
as            
declare @rc int        
declare @_para varchar(255)    
declare @_copia varchar(500)    
declare @_asunto varchar(500)    
declare @_cuerpo varchar(8000)    
      
if rtrim(ltrim(@para)) = ''    
 select @_para = para     
 from descarga.dbo.edi_param where idsucursal = 1    
else    
 set @_para = @para      
    
if rtrim(ltrim(@copia)) = ''    
 select @_copia = copia     
 from descarga.dbo.edi_param    
 where idsucursal = 1    
else    
 set @_copia = @copia     
    
if rtrim(ltrim(@asunto)) = ''    
 select @_asunto = isnull(asunto,'')    
 from descarga.dbo.edi_param    
 where idsucursal = 1    
else    
 set @_asunto = @asunto     
    
if rtrim(ltrim(@cuerpo)) = ''    
 select @_cuerpo = isnull(cuerpo,'')    
 from descarga.dbo.edi_param    
 where idsucursal = 1    
else    
 set @_cuerpo = @cuerpo     
    
--Execute   @rc =   master.dbo.xp_smtp_sendmail            
--          @FROM   = 'aneptunia@neptunia.com.pe',            
--          @TO   = @_para, -- @para,     
--          @CC   = @_copia,     
--          @message = @_cuerpo,     
--          @subject = @_asunto,     
--          @priority   = 'HIGH',        
--          @type       = 'text/html',        
--          @attachments = @rutaarchivoadjunto,     
--          @server = 'calw3mem001.neptunia.com.pe'        
        
 if @@ERROR <> 0 and @rc<> 0        
  select 'Error ocurrido en la Base de datos: ' + @@ERROR as error        
 else        
  select @rc as error        
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_0900_Datos_Operativos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_0900_Datos_Operativos]
@sCodLin char(3),
@sFecIni char(8),
@sFecFin char(8)
as
select distinct '0900' as CodEvento, c.navvia11 as NavVia, a.codcon04 as CodContenedor, min(a.fecing18) as FecOperacion, 
null as FecIngreso, null as FecInspeccion, 'BAL-EXP' as Sistema
from
ddticket18 a (nolock) 
inner join edauting14 b (nolock) on (a.codcon04=b.codcon14 and a.navvia11=b.navvia11)
inner join edbookin13 c (nolock) on (b.genbkg13=c.genbkg13)
where 
a.fecing18>=@sFecIni and a.fecing18<@sFecFin and c.codarm10=@sCodLin
group by c.navvia11, a.codcon04

GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_1000_Datos_Operativos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_1000_Datos_Operativos]
@sCodLin char(3),
@sFecIni char(8),
@sFecFin char(8)
as
select distinct '1000' as CodEvento, c.navvia11 as NavVia, c.codcon04 as CodContenedor, 
a.fecsal18 as FecOperacion, null as FecIngreso, null as FecInspeccion, 'BAL-EXP' as Sistema
from
ddticket18 a (nolock) 
inner join drctrtmc90 b (nolock) on (a.nrotkt18=b.nrotkt28)
inner join edllenad16 c (nolock) on (a.navvia11=c.navvia11 and b.codcon04=c.codcon04)
inner join edbookin13 d (nolock) on (c.genbkg13=d.genbkg13)
where 
a.fecsal18>=@sFecIni and a.fecsal18<@sFecFin and d.codarm10=@sCodLin

GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios] @sCodEve AS CHAR(05)
	,@sCodLin AS CHAR(3)
	,@sCodInt AS CHAR(06)
	,@sNroCtr AS CHAR(11)
	,@sFecReg AS CHAR(14)
	,@dPesCtr DECIMAL(12, 2)
AS
DECLARE @IdRegistro BIGINT
DECLARE @sCodTam CHAR(02)
DECLARE @sCodTip CHAR(02)
DECLARE @sNroBkg VARCHAR(25)
DECLARE @sObserv VARCHAR(50)
DECLARE @iVal BIGINT
DECLARE @sTamTip VARCHAR(4)
DECLARE @iblq INT
DECLARE @NAVVIA AS CHAR(06)
DECLARE @GENBKG AS CHAR(06)
DECLARE @NRODOC AS CHAR(08)
DECLARE @TIPODOC AS VARCHAR(10)
DECLARE @BOOKINGBL AS VARCHAR(30)
DECLARE @SISTEMA AS VARCHAR(30)
DECLARE @SP AS VARCHAR(50)

--SET @BOOKINGBL='' /* se obtiene luego */                                  
SET @SISTEMA = 'BALANZA EXPO'
SET @SP = 'sp_Eventos_Expo_Envios'

INSERT EVENTOS_LINEAS (
	navvia11
	,codcon04
	,cod_evento
	,fec_evento
	,operacion
	,codarm10
	)
VALUES (
	@sCodInt
	,@sNroCtr
	,@sCodEve
	,getdate()
	,'E'
	,@sCodLin
	)

SELECT @iblq = count(*)
FROM descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR
WHERE contenedor = @sNroCtr
	AND estado = 'B'

IF @iblq = 0
BEGIN
	--                                              
	SELECT @iVal = count(codcon04)
	FROM EVENTOS_LINEAS(NOLOCK)
	WHERE navvia11 = @sCodInt
		AND codcon04 = @sNroCtr
		AND cod_evento = @sCodEve
		AND fec_evento >= dateadd(day, - 120, getdate())

	--if @iVal=0                                                            
	IF @iVal >= 0
	BEGIN
		--------- obtiene el navvia y genbkg --------------------------------                                              
		SET @NAVVIA = ''
		SET @GENBKG = ''

		SELECT TOP 1 @NAVVIA = a.NAVVIA11
			,@GENBKG = a.genbkg13
			,@sNroBkg = CASE left(a.bkgcom13, 2)
				WHEN 'BO'
					THEN ''
				ELSE isnull(a.bkgcom13, '')
				END
			,@BOOKINGBL = A.nrocon13
			,@sObserv = substring(a.nomemb13, 1, 50)
		FROM descarga..edbookin13 a(NOLOCK)
			,descarga..erconasi17 b(NOLOCK)
		WHERE a.navvia11 = @sCodInt
			AND a.genbkg13 = b.genbkg13
			AND b.codcon04 = @sNroCtr
		ORDER BY a.navvia11 DESC
			,a.genbkg13 DESC

		DECLARE @EMB VARCHAR(11)

		SELECT TOP 1 @EMB = a.codemc12
		FROM descarga..edbookin13 a(NOLOCK)
			,descarga..erconasi17 b(NOLOCK)
		WHERE a.navvia11 = @sCodInt
			AND a.genbkg13 = b.genbkg13
			AND b.codcon04 = @sNroCtr
		ORDER BY a.navvia11 DESC
			,a.genbkg13 DESC

		--|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD            
		IF LTRIM(RTRIM(@EMB)) <> '20373860736'  
		AND LTRIM(RTRIM(@sCodLin)) = 'HSD'  
		BEGIN  
			RETURN;  
		END  

		--|            
		IF NOT (
				LEN(@NAVVIA) > 0
				AND LEN(@GENBKG) > 0
				)
		BEGIN
			SELECT @NAVVIA = NAVVIA11
				,@GENBKG = genbkg13
				,@BOOKINGBL = nrocon13
			FROM descarga..edbookin13(NOLOCK)
			WHERE genbkg13 = @sCodInt
		END

		---------------------------------------------------------------------                                         
		PRINT 'BOOKING: ' + @sNroBkg + ' ..' + @sNroCtr + '.. ' + @sCodInt

		IF len(@sNroBkg) > 0
		BEGIN
			SELECT @sCodTam = codtam09
				,@sCodTip = codtip05
			FROM edconten04(NOLOCK)
			WHERE codcon04 = @sNroCtr

			SET @sTamTip = @sCodTam + @sCodTip

			IF @sCodEve = '0900'
			BEGIN
				SELECT @NRODOC = nroaut14
				FROM edllenad16(NOLOCK)
				WHERE codcon04 = @sNroCtr
					AND genbkg13 = @GENBKG
					AND navvia11 = @NAVVIA

				SET @TIPODOC = 'AUT'
			END
			ELSE
			BEGIN
				SET @TIPODOC = 'TKT'

				SELECT @NRODOC = g.nrotkt18
				FROM DRCTRTMC90 a(NOLOCK)
				INNER JOIN edllenad16 b(NOLOCK) ON (
						a.navvia11 = b.navvia11
						AND a.codcon04 = b.codcon04
						)
				INNER JOIN edbookin13 e(NOLOCK) ON (
						b.genbkg13 = e.genbkg13
						AND b.navvia11 = e.navvia11
						)
				INNER JOIN ddticket18 g(NOLOCK) ON (
						a.nrotkt28 = g.nrotkt18
						AND a.navvia11 = g.navvia11
						)
				WHERE b.genbkg13 = @GENBKG
					AND b.navvia11 = @NAVVIA
					AND a.codcon04 = @sNroCtr
			END

			--********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                       
			--select top 10 * from edllenad16              
			DECLARE @sFechaCorregida DATETIME

			IF @sCodLin = 'HSD'
				AND @sCodEve = '0900'
			BEGIN
				SET @sFechaCorregida = (
						SELECT MAX(feclln16)
						FROM edllenad16
						WHERE codcon04 = @sNroCtr
							AND navvia11 = @NAVVIA
							AND codemb06 = 'CTR'
						) -- and genbkg13=@GENBKG)                        

				IF LEN(ISNULL(CONVERT(VARCHAR, @sFechaCorregida), '')) > 0
				BEGIN
					SET @sFecReg = CONVERT(VARCHAR(8), @sFechaCorregida, 112) + ' ' + LEFT(CONVERT(VARCHAR, @sFechaCorregida, 108), 5)
				END
			END

			--********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                        
			IF @sCodLin <> 'MSC' -- MSC NO SE ENVIA EN CALLAO, SOLO EN PAITA                                                    
			BEGIN
				IF LEN(@sFecReg) > 7
					AND LEN(@sNroCtr) = 11
					AND LEN(@sCodEve) > 2
					AND LEN(@sCodLin) > 1
				BEGIN
					PRINT 'p'

					EXEC EnvioLineas.dbo.NEP_CrearRegistroEvento @sCodLin
						,@sCodEve
						,@sNroCtr
						,@sFecReg
						,@IdRegistro OUTPUT
						,'EXPO'
						,@NAVVIA
						,'CALLAO'
						,@TIPODOC
						,@NRODOC
						,@BOOKINGBL
						,@SISTEMA
						,@SP

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'CODIGO_INTERNO'
						,@sCodInt

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'TAMA_CTR'
						,@sCodTam

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'TIPO_CTR'
						,@sCodTip

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'PESO_CTR'
						,@dPesCtr

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'FECHA_EVENTO'
						,@sFecReg

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'NRO_BOOKING'
						,@sNroBkg

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'OBSERVACION'
						,@sObserv

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'LOCAL'
						,'LIMATELEDI7'

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'OPERA'
						,'9'

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'LOCAL_ORIGEN'
						,'3'

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'CONDCONT'
						,'5'

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'SIZETYPE'
						,@sTamTip

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'LOCALNPT'
						,'CALLAO'

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'NAVVIA'
						,@NAVVIA

					EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
						,'GENBKG'
						,@GENBKG

					IF @sCodLin = 'MOL'
						OR @sCodLin = 'MSC'
						EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro
							,'LOCALPUERTO'
							,'CLLNE'

					EXEC EnvioLineas.dbo.NEP_CompletarRegistro @IdRegistro

					EXEC EnvioLineas.dbo.NEP_ActualizarRegistro_Completo @IdRegistro
						,@NAVVIA
						,@GENBKG
						,'CALLAO'
						,@TIPODOC
						,@NRODOC
						,@BOOKINGBL
						,@SISTEMA
						,@SP
				END
			END
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_bk]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_bk]
@sCodEve as char(05),                
@sCodLin as char(3),                
@sCodInt as char(06),                
@sNroCtr as char(11),                
@sFecReg as char(14),                
@dPesCtr decimal(12,2)                
as                 
declare @IdRegistro bigint                
declare @sCodTam char(02)                
declare @sCodTip char(02)                
declare @sNroBkg varchar(25)                
declare @sObserv varchar(50)                
declare @iVal bigint                
declare @sTamTip varchar(4)                
declare @iblq int                
                
select @iblq=count(*) from descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR where contenedor=@sNroCtr and estado='B'                
if @iblq=0                
begin                
                
 select @iVal=count(codcon04) from EVENTOS_LINEAS where navvia11=@sCodInt and codcon04=@sNroCtr and cod_evento=@sCodEve                
 --if @iVal=0                
if @iVal>=0                
 begin                
  select top 1 @sNroBkg=Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,@sObserv=substring(a.nomemb13,1,50)  from                 
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                 
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr             
  --and a.codemc12<>'20373860736'              
  order by  a.navvia11 desc, a.genbkg13 desc                
                  
  print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                
                  
  if len(@sNroBkg)>0                 
  begin                 
   select @sCodTam=codtam09, @sCodTip=codtip05 from edconten04 (nolock) where codcon04=@sNroCtr                
   set @sTamTip= @sCodTam+@sCodTip                
        
        
   if @sCodLin<>'MSC' -- MSC NO SE ENVIA EN CALLAO, SOLO EN PAITA        
   BEGIN      
 IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1    
  BEGIN    
   EXEC EnvioLineas.dbo.NEP_CrearRegistro @sCodLin,@sCodEve,@sNroCtr,@sFecReg,@IdRegistro OUTPUT                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CODIGO_INTERNO',@sCodInt                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TAMA_CTR',@sCodTam                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TIPO_CTR',@sCodTip                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'PESO_CTR',@dPesCtr                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'FECHA_EVENTO',@sFecReg                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NRO_BOOKING',@sNroBkg                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OBSERVACION',@sObserv                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL','LIMATELEDI7'                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OPERA','9'                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL_ORIGEN','3'                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CONDCONT','5'                
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'SIZETYPE', @sTamTip              
             
   if @sCodLin='MOL' OR @sCodLin='MSC'        
   EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALPUERTO','CLLNE'             
                      
   EXEC    EnvioLineas.dbo.NEP_CompletarRegistro @IdRegistro                
  END    
   END           
        
              
   Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                 
    values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                
  end                
 end          
end  
-- Actualiza información del MTY  
update TERMINAL.DBO.DDREGMTY96 set   
fecret96=c.fecsal18, tipmov96='S', plaret96=c.nropla18, usuret17=c.codusu17   
from TERMINAL.DBO.DDREGMTY96 a   
inner join descarga.dbo.DRCTRTMC90 b on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)  
inner join descarga.dbo.ddticket18 c on (b.nrotkt28=c.nrotkt18)  
where tipmov96='I' and tipope96='E'  
  
update descarga..edllenad16 set fecsal16=getdate() where fecsal16 is null and codcon04=@sNroCtr
GO




/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_gwc]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================================              
-- CREAMOS EL STORED PROCEDURE              
--=================================================================================              
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_gwc] (
	@SCODEVE AS CHAR(05)
	,@SCODLIN AS CHAR(3)
	,@SCODINT AS CHAR(06)
	,@SNROCTR AS CHAR(11)
	,@SFECREG AS CHAR(14)
	,@DPESCTR DECIMAL(12, 2)
	,@ITRM AS VARCHAR(06)
	,@CODIGORET INT OUTPUT
	,@RESULTADO VARCHAR(8000) OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IDREGISTRO BIGINT
	DECLARE @SCODTAM CHAR(02)
	DECLARE @SCODTIP CHAR(02)
	DECLARE @SNROBKG VARCHAR(25)
	DECLARE @SOBSERV VARCHAR(50)
	DECLARE @IVAL BIGINT
	DECLARE @STAMTIP VARCHAR(4)
	DECLARE @IBLQ INT
	DECLARE @NAVVIA CHAR(06)
	DECLARE @GENBKG CHAR(06)
	DECLARE @NRODOC CHAR(08)
	DECLARE @TIPODOC VARCHAR(10)
	DECLARE @BOOKINGBL VARCHAR(30)
	DECLARE @BOOKING_CPLT VARCHAR(25)
	DECLARE @SISTEMA VARCHAR(30)
	DECLARE @SP VARCHAR(50)
	DECLARE @NUMVIA VARCHAR(10)
	DECLARE @DESC_NAVE VARCHAR(40)
	DECLARE @DISCHARGE_PORT VARCHAR(10)
	DECLARE @FINAL_DESTINATION VARCHAR(10)
	DECLARE @INLANDDEPOT VARCHAR(06)
	DECLARE @CAMPO_PRECINTO VARCHAR(60)
	DECLARE @NADCAVALUE VARCHAR(06)
	DECLARE @ISOEQID VARCHAR(10)
	DECLARE @LOCALPUERTO VARCHAR(6)
	DECLARE @RANDOMNUMBER INT
	DECLARE @PUERTO VARCHAR(3)
	DECLARE @NUMLLOYSISO VARCHAR(15)
	DECLARE @COD_NAVE VARCHAR(4)

	--SET @BOOKINGBL='' /* se obtiene luego */                 
	SET @CODIGORET = 0
	SET @RESULTADO = ''
	SET @SISTEMA = 'BALANZA EXPO'
	SET @SP = 'sp_Eventos_Expo_Envios'
	SET @iVal = 0
	SET @LOCALPUERTO = ''
	SET @ISOEQID = ''
	SET @NADCAVALUE = ''
	SET @CAMPO_PRECINTO = ''
	SET @INLANDDEPOT = ''
	SET @FINAL_DESTINATION = ''
	SET @DISCHARGE_PORT = ''
	SET @DESC_NAVE = ''
	SET @NUMVIA = ''
	SET @BOOKING_CPLT = ''
	SET @PUERTO = ''

	IF (
			@ITRM = 'VIL'
			OR @ITRM = 'VEN'
			)
	BEGIN
		SET @ITRM = 'CO'
	END

	SET @RANDOMNUMBER = CONVERT(INT, RAND() * 10000)

	IF LEN(@SCODEVE) = 0
		OR @SCODEVE IS NULL
		OR (
			@SCODEVE != '0900'
			AND @SCODEVE != '1000'
			)
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CAMPO SCODEVE NO ES CORRECTO'

		RETURN
	END

	IF LEN(@ITRM) = 0
		OR @ITRM IS NULL
		OR (
			@ITRM != 'CO'
			AND @ITRM != 'PAI'
			)
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CAMPO ITRM NO ES CORRECTO'

		RETURN
	END

	--Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)               
	--values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                                
	BEGIN TRY
		SELECT @iblq = count(*)
		FROM descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR
		WHERE contenedor = @sNroCtr
			AND estado = 'B'
	END TRY

	BEGIN CATCH
		SET @CODIGORET = 900
		SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
	END CATCH

	IF @iblq = 0
	BEGIN
		BEGIN TRY
			SELECT @iVal = count(codcon04)
			FROM EVENTOS_LINEAS(NOLOCK)
			WHERE navvia11 = @sCodInt
				AND codcon04 = @sNroCtr
				AND cod_evento = @sCodEve
				AND fec_evento >= dateadd(day, - 120, getdate())
		END TRY

		BEGIN CATCH
			SET @CODIGORET = 900
			SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
		END CATCH

		IF @iVal >= 0
		BEGIN
			--------- obtiene el navvia y genbkg --------------------------------                                                  
			SET @NAVVIA = ''
			SET @GENBKG = ''

			BEGIN TRY
				SELECT TOP 1 @NAVVIA = a.NAVVIA11
					,@GENBKG = a.genbkg13
					,@sNroBkg = CASE left(a.nrocon13, 2)
						WHEN 'BO'
							THEN ''
						ELSE a.nrocon13
						END
					,@BOOKINGBL = A.nrocon13
					,@sObserv = substring(a.nomemb13, 1, 50)
					,@BOOKING_CPLT = LTRIM(RTRIM(ISNULL(A.bkgcom13, '')))
				FROM descarga..edbookin13 a(NOLOCK)
					,descarga..erconasi17 b(NOLOCK)
				WHERE a.navvia11 = @sCodInt
					AND a.genbkg13 = b.genbkg13
					AND b.codcon04 = @sNroCtr
				ORDER BY a.navvia11 DESC
					,a.genbkg13 DESC
			END TRY

			BEGIN CATCH
				SET @CODIGORET = 900
				SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
			END CATCH

			DECLARE @EMB VARCHAR(11)

			BEGIN TRY
				SELECT TOP 1 @EMB = a.codemc12
				FROM descarga..edbookin13 a(NOLOCK)
					,descarga..erconasi17 b(NOLOCK)
				WHERE a.navvia11 = @sCodInt
					AND a.genbkg13 = b.genbkg13
					AND b.codcon04 = @sNroCtr
				ORDER BY a.navvia11 DESC
					,a.genbkg13 DESC
			END TRY

			BEGIN CATCH
				SET @CODIGORET = 900
				SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
			END CATCH

			--|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD                
			IF LTRIM(RTRIM(@EMB)) <> '20373860736'
				AND LTRIM(RTRIM(@sCodLin)) = 'HSD'
			BEGIN
				RETURN;
			END

			IF NOT (
					LEN(@NAVVIA) > 0
					AND LEN(@GENBKG) > 0
					)
			BEGIN
				BEGIN TRY
					SELECT @NAVVIA = NAVVIA11
						,@GENBKG = genbkg13
						,@BOOKINGBL = nrocon13
						,@BOOKING_CPLT = LTRIM(RTRIM(ISNULL(bkgcom13, '')))
					FROM descarga..edbookin13(NOLOCK)
					WHERE genbkg13 = @sCodInt
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH
			END

			---------------------------------------------------------------------                                             
			--print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                     
			IF len(@sNroBkg) > 0
			BEGIN
				BEGIN TRY
					SELECT @SCODTAM = codtam09
						,@SCODTIP = codtip05
					FROM edconten04(NOLOCK)
					WHERE codcon04 = @sNroCtr
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				SET @sTamTip = @sCodTam + @sCodTip

				IF @sCodEve = '0900'
				BEGIN
					BEGIN TRY
						SELECT @NRODOC = nroaut14
						FROM edllenad16(NOLOCK)
						WHERE codcon04 = @sNroCtr
							AND genbkg13 = @GENBKG
							AND navvia11 = @NAVVIA
					END TRY

					BEGIN CATCH
						SET @CODIGORET = 900
						SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
					END CATCH

					SET @TIPODOC = 'AUT'
				END
				ELSE
				BEGIN
					SET @TIPODOC = 'TKT'

					BEGIN TRY
						SELECT @NRODOC = g.nrotkt18
						FROM DRCTRTMC90 a(NOLOCK)
						INNER JOIN edllenad16 b(NOLOCK) ON (
								a.navvia11 = b.navvia11
								AND a.codcon04 = b.codcon04
								)
						INNER JOIN edbookin13 e(NOLOCK) ON (
								b.genbkg13 = e.genbkg13
								AND b.navvia11 = e.navvia11
								)
						INNER JOIN ddticket18 g(NOLOCK) ON (
								a.nrotkt28 = g.nrotkt18
								AND a.navvia11 = g.navvia11
								)
						WHERE b.genbkg13 = @GENBKG
							AND b.navvia11 = @NAVVIA
							AND a.codcon04 = @sNroCtr
					END TRY

					BEGIN CATCH
						SET @CODIGORET = 900
						SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
					END CATCH
				END

				--********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                           
				--select top 10 * from edllenad16                  
				DECLARE @sFechaCorregida DATETIME

				IF @sCodLin = 'HSD'
					AND @sCodEve = '0900'
				BEGIN
					SET @sFechaCorregida = (
							SELECT MAX(feclln16)
							FROM edllenad16
							WHERE codcon04 = @sNroCtr
								AND navvia11 = @NAVVIA
								AND codemb06 = 'CTR'
							) -- and genbkg13=@GENBKG)              

					IF LEN(ISNULL(CONVERT(VARCHAR, @sFechaCorregida), '')) > 0
					BEGIN
						SET @sFecReg = CONVERT(VARCHAR(8), @sFechaCorregida, 112) + ' ' + LEFT(CONVERT(VARCHAR, @sFechaCorregida, 108), 5)
					END
				END

				-- OBTENEMOS @DESC_NAVE              
				BEGIN TRY
					SELECT @NUMVIA = ltrim(rtrim(a.numvia11))
						,@DESC_NAVE = ltrim(rtrim(b.desnav08))
						,@PUERTO = ltrim(rtrim(ptoori11))
						,@COD_NAVE = a.codnav08
					FROM DDCABMAN11 a
					INNER JOIN DQNAVIER08 b ON a.codnav08 = b.codnav08
					WHERE navvia11 = @NAVVIA

					IF LTRIM(RTRIM(@PUERTO)) = 'E'
					BEGIN
						SET @PUERTO = 'APM'
					END

					IF LTRIM(RTRIM(@PUERTO)) = 'D'
					BEGIN
						SET @PUERTO = 'DPW'
					END
					PRINT @COD_NAVE
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				-- OBTENEMOS @DISCHARGE_PORT              
				BEGIN TRY
					SELECT @DISCHARGE_PORT = b.codsol02
					FROM descarga..EDBOOKIN13 a
					INNER JOIN descarga..DQPUERTO02 b ON a.codpue02 = b.codpue02
					WHERE a.genbkg13 = @GENBKG
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				IF (@DISCHARGE_PORT IS NULL)
				BEGIN
					IF (@ITRM = 'CO')
					BEGIN
						SET @DISCHARGE_PORT = 'PECLL'
					END

					IF (@ITRM = 'PAI')
					BEGIN
						SET @DISCHARGE_PORT = 'PEPAI'
					END
				END

				-- OBTENEMOS @FINAL_DESTINATION              
				BEGIN TRY
					SELECT @FINAL_DESTINATION = b.codsol02
					FROM descarga..EDBOOKIN13 a
					INNER JOIN descarga..DQPUERTO02 b ON a.codpue13 = b.codpue02
					WHERE a.genbkg13 = @GENBKG
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				IF (@FINAL_DESTINATION IS NULL)
				BEGIN
					IF (@ITRM = 'CO')
					BEGIN
						SET @FINAL_DESTINATION = 'PECLL'
					END

					IF (@ITRM = 'PAI')
					BEGIN
						SET @FINAL_DESTINATION = 'PEPAI'
					END
				END

				--OBTENEMOS @INLANDDEPOT              
				IF (@ITRM = 'CO')
				BEGIN
					SET @INLANDDEPOT = 'NEC'
					SET @NADCAVALUE = 'NEC'
					SET @LOCALPUERTO = 'CLL'
				END

				IF (@ITRM = 'PAI')
				BEGIN
					SET @INLANDDEPOT = 'NEP'
					SET @NADCAVALUE = 'NEP'
					SET @LOCALPUERTO = 'PAI'
				END

				-- OBTENEMOS EL CODIGO LOYYS DE LA NAVE  
				SELECT @NUMLLOYSISO = LTRIM(RTRIM(NumLloydsISO))
				FROM CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spbmbuque
				WHERE LTRIM(RTRIM(id)) = @COD_NAVE

				-- OBTENEMOS @CAMPO_PRECINTO              
				BEGIN TRY
					SELECT @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))
					FROM descarga..ERCONASI17
					WHERE genbkg13 = @GENBKG
						AND codcon04 = @sNroCtr
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				----------------------------------------------------              
				--OBTENER @ISOEQID CODIGO ISO CONTENEDOR              
				----------------------------------------------------              
				BEGIN TRY
					SELECT @SCODTAM = codtam09
						,@SCODTIP = codtip05
					FROM edconten04(NOLOCK)
					WHERE codcon04 = @sNroCtr

					SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))
					FROM spbmcaracteristicascontenedor
					WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP
						AND Tamanyo = @SCODTAM
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				----------------------------------------------------              
				IF LEN(@sFecReg) > 7
					AND LEN(@sNroCtr) = 11
					AND LEN(@sCodEve) > 2
					AND LEN(@sCodLin) > 1
				BEGIN
					IF SUBSTRING(@BOOKING_CPLT, 1, 6) <> '087LIM'
					BEGIN
						SET @BOOKING_CPLT = '087LIM' + '' + LTRIM(RTRIM(@BOOKING_CPLT))
					END

					/* ------------------------------------------------------------ */
					/*                      RESULTADO GWC                           */
					/* ------------------------------------------------------------ */
					SET @resultado = @resultado + 'LOCAL=LIMATELEDI2' + ';'
					SET @resultado = @resultado + 'ALEATORIO=' + RIGHT('0000000' + CONVERT(VARCHAR, @RANDOMNUMBER), 7) + ';'
					SET @resultado = @resultado + 'OPERA=9' + ';'
					--SET @resultado = @resultado + 'COD_VIAJE=' + @NAVVIA +';'              
					SET @resultado = @resultado + 'COD_VIAJE=' + LTRIM(RTRIM(ISNULL(@NUMVIA, ''))) + ';'
					SET @resultado = @resultado + 'DESC_NAVE=' + LTRIM(RTRIM(ISNULL(@DESC_NAVE, ''))) + ';'
					SET @resultado = @resultado + 'LOCALPUERTO=' + LTRIM(RTRIM(ISNULL(@LOCALPUERTO, ''))) + ';'
					SET @resultado = @resultado + 'CONDCONT=5' + ';'
					SET @resultado = @resultado + 'BOOKING=' + LTRIM(RTRIM(ISNULL(@BOOKING_CPLT, ''))) + ';'
					SET @resultado = @resultado + 'DISCHARGE_PORT=' + LTRIM(RTRIM(ISNULL(@DISCHARGE_PORT, ''))) + ';'
					SET @resultado = @resultado + 'FINAL_DESTINATION=' + LTRIM(RTRIM(ISNULL(@FINAL_DESTINATION, ''))) + ';'
					SET @resultado = @resultado + 'INLANDDEPOT=' + ISNULL(@INLANDDEPOT, '') + ';'
					SET @resultado = @resultado + 'CAMPO_PRECINTO=' + LTRIM(RTRIM(ISNULL(@CAMPO_PRECINTO, ''))) + ';'
					SET @resultado = @resultado + 'PESO_CRT=' + CONVERT(VARCHAR(15), @dPesCtr) + ';'
					SET @resultado = @resultado + 'NADCAVALUE=' + ISNULL(@NADCAVALUE, '') + ';'
					SET @resultado = @resultado + 'ISOEQID=' + ISNULL(@ISOEQID, '') + ';'
					SET @resultado = @resultado + 'LOC99PUERTO=' + ISNULL(@PUERTO, '') + ';'
					SET @resultado = @resultado + 'LOC100PUERTO=' + ISNULL(@PUERTO, '') + ';'
					SET @resultado = @resultado + 'NROTICKET=' + ISNULL(@NRODOC, '') + ';'
					SET @resultado = @resultado + 'NUMLLOYSISO=' + ISNULL(@NUMLLOYSISO, '') + ';'
				END
			END
			ELSE
			BEGIN
				SET @CODIGORET = 999
				SET @RESULTADO = 'NO EXISTE BOOKING PARA LOS DATOS INGRESADOS'

				RETURN
			END
		END
	END
	ELSE
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'
	END

	SET NOCOUNT OFF
END
	/*              
DECLARE @CODIGORET     INT               
DECLARE @RESULTADO     VARCHAR(8000)         
              
EXECUTE usp_gwc_prepara_datos_eventos '0900','MSC','000023','CONTENEDOR','2016-06-06',40000,@CODIGORET OUTPUT, @RESULTADO OUTPUT              
                 
PRINT @CODIGORET              
PRINT @RESULTADO              
*/
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_gwc_new]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
--=================================================================================        
-- CREAMOS EL STORED PROCEDURE        
--=================================================================================        
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_gwc_new](        
   @SCODEVE    AS CHAR(05),                                                          
   @SCODLIN    AS CHAR(3),                                                          
   @SCODINT    AS CHAR(06),                                                          
   @SNROCTR    AS CHAR(11),                                                          
   @SFECREG    AS CHAR(14),                                                          
   @DPESCTR    DECIMAL(12,2),        
   @ITRM       AS VARCHAR(06),        
   @OPT01      AS VARCHAR(100),
   @OPT02      AS VARCHAR(100),
   @OPT03      AS VARCHAR(100),
   @OPT04      AS VARCHAR(100),
   @OPT05      AS VARCHAR(100),
   @CODIGORET  INT OUTPUT,         
   @RESULTADO  VARCHAR(8000) OUTPUT)        
AS        
        
BEGIN        
   SET NOCOUNT ON        
   DECLARE @IDREGISTRO         BIGINT        
   DECLARE @SCODTAM            CHAR(02)        
   DECLARE @SCODTIP            CHAR(02)        
   DECLARE @SNROBKG            VARCHAR(25)        
   DECLARE @SOBSERV            VARCHAR(50)        
   DECLARE @IVAL               BIGINT        
   DECLARE @STAMTIP            VARCHAR(4)        
   DECLARE @IBLQ               INT        
   DECLARE @NAVVIA             CHAR(06)        
   DECLARE @GENBKG             CHAR(06)        
   DECLARE @NRODOC             CHAR(08)        
   DECLARE @TIPODOC            VARCHAR(10)        
   DECLARE @BOOKINGBL          VARCHAR(30)      
   DECLARE @BOOKING_CPLT    VARCHAR(25)      
   DECLARE @SISTEMA            VARCHAR(30)        
   DECLARE @SP                 VARCHAR(50)        
   DECLARE @NUMVIA             VARCHAR(10)        
           
   DECLARE @DESC_NAVE          VARCHAR(40)        
   DECLARE @DISCHARGE_PORT     VARCHAR(10)        
   DECLARE @FINAL_DESTINATION  VARCHAR(10)        
   DECLARE @INLANDDEPOT        VARCHAR(06)        
   DECLARE @CAMPO_PRECINTO     VARCHAR(60)        
   DECLARE @NADCAVALUE         VARCHAR(06)        
   DECLARE @ISOEQID            VARCHAR(10)        
   DECLARE @LOCALPUERTO     VARCHAR(6)        
   DECLARE @RANDOMNUMBER       INT    
   DECLARE @PUERTO   VARCHAR(3)      
                                          
   --SET @BOOKINGBL='' /* se obtiene luego */           
   SET @CODIGORET              = 0        
   SET @RESULTADO              = ''        
   SET @SISTEMA                = 'BALANZA EXPO'                                
   SET @SP                     = 'sp_Eventos_Expo_Envios'           
   SET @iVal                   = 0           
   SET @LOCALPUERTO            = ''        
   SET @ISOEQID                = ''        
   SET @NADCAVALUE             = ''        
   SET @CAMPO_PRECINTO         = ''        
   SET @INLANDDEPOT            = ''        
   SET @FINAL_DESTINATION      = ''        
   SET @DISCHARGE_PORT         = ''        
   SET @DESC_NAVE              = ''        
   SET @NUMVIA                 = ''  
   SET @BOOKING_CPLT     = ''    
   SET @PUERTO       = ''   
           
   IF(@ITRM='VIL' OR @ITRM='VEN')        
    BEGIN        
      SET @ITRM='CO'        
   END        
        
   SET @RANDOMNUMBER = CONVERT(INT,RAND()*10000)        
           
   IF LEN(@SCODEVE)=0 OR @SCODEVE IS NULL OR (@SCODEVE!='0900' AND @SCODEVE!='1000')        
   BEGIN        
   SET @CODIGORET = 999        
   SET @RESULTADO = 'EL CAMPO SCODEVE NO ES CORRECTO'        
   RETURN        
   END        
           
   IF LEN(@ITRM)=0 OR @ITRM IS NULL OR (@ITRM!='CO' AND @ITRM!='PAI')        
   BEGIN        
   SET @CODIGORET = 999        
   SET @RESULTADO = 'EL CAMPO ITRM NO ES CORRECTO'        
   RETURN        
   END        
              
   --Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                                                           
   --values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                          
                                
   BEGIN TRY                                                       
      select        
         @iblq=count(*)        
      from        
         descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR        
      where        
         contenedor=@sNroCtr        
         and estado='B'                                                  
   END TRY        
   BEGIN CATCH        
      SET @CODIGORET = 900        
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
   END CATCH        
           
   if @iblq=0                                                          
   begin        
      BEGIN TRY        
         select        
            @iVal=count(codcon04)        
         from        
            EVENTOS_LINEAS(nolock)        
         where        
            navvia11=@sCodInt         
            and codcon04=@sNroCtr         
            and cod_evento=@sCodEve         
            and fec_evento>=dateadd(day,-120,getdate())                                       
      END TRY        
      BEGIN CATCH        
         SET @CODIGORET = 900        
         SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
      END CATCH        
           
      if @iVal>=0                                                          
      begin                                                                                  
         --------- obtiene el navvia y genbkg --------------------------------                                            
         SET @NAVVIA=''                                          
         SET @GENBKG=''                                          
                 
         BEGIN TRY                 
            select        
               top 1 @NAVVIA  = a.NAVVIA11,         
               @GENBKG        = a.genbkg13,         
               @sNroBkg       = Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,        
               @BOOKINGBL     = A.nrocon13,@sObserv=substring(a.nomemb13,1,50),    
               @BOOKING_CPLT  = LTRIM(RTRIM(ISNULL(A.bkgcom13,'')))    
            from        
               descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                           
            where        
               a.navvia11=@sCodInt        
               and a.genbkg13=b.genbkg13        
               and b.codcon04=@sNroCtr                                                       
            order by        
               a.navvia11 desc,         
               a.genbkg13 desc                                                          
         END TRY        
         BEGIN CATCH        
            SET @CODIGORET = 900        
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
         END CATCH        
                 
         DECLARE @EMB VARCHAR(11)          
         BEGIN TRY        
            select        
               top 1 @EMB=a.codemc12        
            from                                                           
               descarga..edbookin13 a (nolock),         
               descarga..erconasi17 b (nolock)                                                           
            where        
               a.navvia11=@sCodInt         
               and a.genbkg13=b.genbkg13         
               and b.codcon04=@sNroCtr                                                       
            order by        
               a.navvia11 desc,        
               a.genbkg13 desc           
         END TRY        
         BEGIN CATCH        
            SET @CODIGORET = 900        
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
         END CATCH        
        
         --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD          
         IF LTRIM(RTRIM(@EMB))<>'20373860736' AND LTRIM(RTRIM(@sCodLin))='HSD'          
         BEGIN        
            RETURN;          
         END          
        
         IF NOT (LEN(@NAVVIA)>0 AND LEN(@GENBKG)>0)                                          
         BEGIN        
            BEGIN TRY                     select        
                  @NAVVIA=NAVVIA11,         
                  @GENBKG=genbkg13,        
                  @BOOKINGBL=nrocon13,    
                  @BOOKING_CPLT  = LTRIM(RTRIM(ISNULL(bkgcom13,'')))        
               from        
                  descarga..edbookin13(nolock)        
               where        
                  genbkg13=@sCodInt        
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
         END                                            
         ---------------------------------------------------------------------                                       
         --print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                               
                                                   
         if len(@sNroBkg)>0                                                           
         begin        
            BEGIN TRY        
               select        
                  @SCODTAM=codtam09,         
                  @SCODTIP=codtip05         
               from        
                  edconten04 (nolock)        
               where        
                  codcon04=@sNroCtr        
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
            set @sTamTip= @sCodTam+@sCodTip                                                          
                                         
            IF @sCodEve='0900'                                
            BEGIN        
               BEGIN TRY        
                  select        
                     @NRODOC=nroaut14         
                  from        
                     edllenad16(nolock)                           
                  where        
                     codcon04=@sNroCtr         
                     and genbkg13=@GENBKG         
                     and navvia11=@NAVVIA                                
               END TRY        
               BEGIN CATCH        
                  SET @CODIGORET = 900        
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
               END CATCH                         
               SET @TIPODOC='AUT'                                
            END                                
            ELSE                                
            BEGIN                                
               SET @TIPODOC='TKT'        
               BEGIN TRY        
                  SELECT        
                     @NRODOC=g.nrotkt18                                
                  FROM        
                     DRCTRTMC90 a (nolock)                                                                    
                     inner join edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                                
                     inner join edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                                
                     inner join ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                                
                  where        
                     b.genbkg13=@GENBKG         
                     and b.navvia11=@NAVVIA         
                     and a.codcon04=@sNroCtr        
               END TRY        
               BEGIN CATCH        
                  SET @CODIGORET = 900        
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
               END CATCH                          
            END      
            --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                     
            --select top 10 * from edllenad16            
                          
            DECLARE @sFechaCorregida DATETIME                      
            IF @sCodLin = 'HSD' and @sCodEve='0900'                      
            BEGIN                      
               SET @sFechaCorregida = (select        
                                          MAX(feclln16)         
                                       from        
                                          edllenad16        
                                       where        
                                          codcon04=@sNroCtr        
                     and navvia11=@NAVVIA        
                                          and codemb06='CTR')-- and genbkg13=@GENBKG)        
                                                  
               IF LEN(ISNULL(CONVERT(VARCHAR,@sFechaCorregida),'')) > 0                      
               BEGIN                      
                  SET @sFecReg = CONVERT(VARCHAR(8),@sFechaCorregida,112) + ' ' + LEFT(CONVERT(VARCHAR,@sFechaCorregida,108),5)                      
               END                      
            END        
            -- OBTENEMOS @DESC_NAVE        
            BEGIN TRY        
               select        
                  @NUMVIA    = ltrim(rtrim(a.numvia11)),        
                  @DESC_NAVE = ltrim(rtrim(b.desnav08)),  
                  @PUERTO  = ltrim(rtrim(ptoori11))  
               from        
                  DDCABMAN11 a        
                     inner join DQNAVIER08 b on a.codnav08=b.codnav08        
               where        
                  navvia11=@NAVVIA     
                    
               IF LTRIM(RTRIM(@PUERTO)) = 'E'  
               BEGIN  
     SET @PUERTO = 'APM'  
               END  
               IF LTRIM(RTRIM(@PUERTO)) = 'D'  
               BEGIN  
     SET @PUERTO = 'DPW'  
               END  
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
                    
            -- OBTENEMOS @DISCHARGE_PORT        
            BEGIN TRY        
               select        
                  @DISCHARGE_PORT = b.codsol02        
               from        
                  descarga..EDBOOKIN13 a        
                     inner join descarga..DQPUERTO02 b on a.codpue02 = b.codpue02        
               where        
                  a.genbkg13 = @GENBKG        
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH          
                    
            IF (@DISCHARGE_PORT IS NULL)        
            BEGIN        
               IF(@ITRM='CO')        
               BEGIN        
                  SET @DISCHARGE_PORT = 'PECLL'        
               END        
               IF(@ITRM='PAI')        
               BEGIN        
                  SET @DISCHARGE_PORT = 'PEPAI'        
               END        
            END       
                    
            -- OBTENEMOS @FINAL_DESTINATION        
            BEGIN TRY        
               select        
                  @FINAL_DESTINATION = b.codsol02        
               from        
                  descarga..EDBOOKIN13 a        
                     inner join descarga..DQPUERTO02 b on a.codpue13 = b.codpue02        
               where        
                  a.genbkg13 = @GENBKG        
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
                 
            IF (@FINAL_DESTINATION IS NULL)        
            BEGIN        
               IF(@ITRM='CO')        
               BEGIN        
                  SET @FINAL_DESTINATION = 'PECLL'        
               END        
               IF(@ITRM='PAI')        
               BEGIN        
                  SET @FINAL_DESTINATION = 'PEPAI'        
               END        
            END        
                    
            --OBTENEMOS @INLANDDEPOT        
            IF(@ITRM='CO')        
            BEGIN        
               SET @INLANDDEPOT = 'NEC'        
      SET @NADCAVALUE = 'NEC'        
      SET @LOCALPUERTO = 'CLL'        
            END        
            IF(@ITRM='PAI')        
            BEGIN        
               SET @INLANDDEPOT = 'NEP'        
      SET @NADCAVALUE = 'NEP'        
      SET @LOCALPUERTO = 'PAI'        
            END        
                    
            -- OBTENEMOS @CAMPO_PRECINTO        
            BEGIN TRY        
               select        
                  @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))        
               from        
                  descarga..ERCONASI17        
               where        
                  genbkg13=@GENBKG         
                  and codcon04=@sNroCtr        
      END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
           
   ----------------------------------------------------        
   --OBTENER @ISOEQID CODIGO ISO CONTENEDOR        
   ----------------------------------------------------        
   BEGIN TRY        
    SELECT         
      @SCODTAM=codtam09,        
      @SCODTIP=codtip05         
      FROM edconten04 (nolock)         
      WHERE codcon04=@sNroCtr           
          
    SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))         
      FROM spbmcaracteristicascontenedor         
      WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP         
     AND Tamanyo = @SCODTAM        
            END TRY        
            BEGIN CATCH        
               SET @CODIGORET = 900        
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()        
            END CATCH        
   ----------------------------------------------------        
                 
            IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1                                              
            BEGIN  
            
			   IF SUBSTRING(@BOOKING_CPLT,1,6)<> '087LIM'
			   BEGIN
					SET @BOOKING_CPLT = '087LIM' + '' + LTRIM(RTRIM(@BOOKING_CPLT))
			   END
			              
               /* ------------------------------------------------------------ */        
               /*                      RESULTADO GWC                           */        
               /* ------------------------------------------------------------ */        
               SET @resultado = @resultado + 'LOCAL=LIMATELEDI2' + ';'        
               SET @resultado = @resultado + 'ALEATORIO=' + RIGHT('0000000' + CONVERT(VARCHAR,@RANDOMNUMBER),7)+ ';'        
               SET @resultado = @resultado + 'OPERA=9' + ';'        
               --SET @resultado = @resultado + 'COD_VIAJE=' + @NAVVIA +';'        
               SET @resultado = @resultado + 'COD_VIAJE=' + LTRIM(RTRIM(@NUMVIA)) +';'        
               SET @resultado = @resultado + 'DESC_NAVE=' + LTRIM(RTRIM(@DESC_NAVE)) +';'        
               SET @resultado = @resultado + 'LOCALPUERTO='+ LTRIM(RTRIM(@LOCALPUERTO)) + ';'        
               SET @resultado = @resultado + 'CONDCONT=5' + ';'        
               SET @resultado = @resultado + 'BOOKING=' + LTRIM(RTRIM(@BOOKING_CPLT)) + ';'        
               SET @resultado = @resultado + 'DISCHARGE_PORT='+ LTRIM(RTRIM(@DISCHARGE_PORT)) + ';'        
               SET @resultado = @resultado + 'FINAL_DESTINATION=' + LTRIM(RTRIM(@FINAL_DESTINATION)) + ';'        
               SET @resultado = @resultado + 'INLANDDEPOT=' + @INLANDDEPOT + ';'        
               SET @resultado = @resultado + 'CAMPO_PRECINTO=' + LTRIM(RTRIM(@CAMPO_PRECINTO)) + ';'        
               SET @resultado = @resultado + 'PESO_CRT=' + CONVERT(varchar(15),@dPesCtr) + ';'        
      SET @resultado = @resultado + 'NADCAVALUE=' + @NADCAVALUE +';'        
      SET @resultado = @resultado + 'ISOEQID=' + @ISOEQID + ';'        
      SET @resultado = @resultado + 'LOC99PUERTO='+ @PUERTO + ';'       
      SET @resultado = @resultado + 'LOC100PUERTO='+ @PUERTO + ';'        
      SET @resultado = @resultado + 'NROTICKET='+ @NRODOC + ';'        
            END                       
         end        
         ELSE        
         BEGIN        
            SET @CODIGORET = 999        
            SET @RESULTADO = 'NO EXISTE BOOKING PARA LOS DATOS INGRESADOS'        
            RETURN        
         END                 
      end                                                    
   end        
   ELSE        
   BEGIN        
      SET @CODIGORET = 999        
      SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'        
   END                
   SET NOCOUNT OFF        
END        
/*        
DECLARE @CODIGORET     INT         
DECLARE @RESULTADO     VARCHAR(8000)        
        
EXECUTE usp_gwc_prepara_datos_eventos '0900','MSC','000023','CONTENEDOR','2016-06-06',40000,@CODIGORET OUTPUT, @RESULTADO OUTPUT        
           
PRINT @CODIGORET        
PRINT @RESULTADO        
*/
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_PRUEBA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_PRUEBA]                                                      
@sCodEve as char(05),                                                      
@sCodLin as char(3),                                                      
@sCodInt as char(06),                                                      
@sNroCtr as char(11),                                                      
@sFecReg as char(14),                                                      
@dPesCtr decimal(12,2)                                                      
as                  
                  
declare @IdRegistro bigint                                                      
declare @sCodTam char(02)                                                      
declare @sCodTip char(02)                                                      
declare @sNroBkg varchar(25)                                                      
declare @sObserv varchar(50)                                                      
declare @iVal bigint                                                      
declare @sTamTip varchar(4)                                                      
declare @iblq int                                                      
declare @NAVVIA as char(06)                                        
declare @GENBKG as char(06)                              
declare @NRODOC as char(08)                              
declare @TIPODOC as VARchar(10)                            
DECLARE @BOOKINGBL AS VARCHAR(30)                            
DECLARE @SISTEMA AS VARCHAR(30)                            
DECLARE @SP AS VARCHAR(50)                            
                                      
--SET @BOOKINGBL='' /* se obtiene luego */                            
SET @SISTEMA='BALANZA EXPO'                            
SET @SP='sp_Eventos_Expo_Envios'                  
              
               
/*                
Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                                                       
values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                      
*/                            
                                                      
select @iblq=count(*) from descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR where contenedor=@sNroCtr and estado='B'                                                      
if @iblq=0                                                      
begin      
                                                   
 --                                        
 select @iVal=count(codcon04) from EVENTOS_LINEAS(nolock) where navvia11=@sCodInt and codcon04=@sNroCtr and cod_evento=@sCodEve and fec_evento>=dateadd(day,-120,getdate())                                   
 --if @iVal=0                                                      
 if @iVal>=0                                                      
 begin                                                                              
   --------- obtiene el navvia y genbkg --------------------------------                                        
  SET @NAVVIA=''                                      
  SET @GENBKG=''                                      
                                    
  select top 1 @NAVVIA=a.NAVVIA11, @GENBKG=a.genbkg13, @sNroBkg=Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,@BOOKINGBL=A.nrocon13,@sObserv=substring(a.nomemb13,1,50)  from                                                       
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                       
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                                   
  order by  a.navvia11 desc, a.genbkg13 desc                                                      
        
  DECLARE @EMB VARCHAR(11)      
        
  select top 1 @EMB=a.codemc12 from                                                       
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                       
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                                   
  order by  a.navvia11 desc, a.genbkg13 desc       
        
  --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD      
  IF LTRIM(RTRIM(@EMB))<>'20373860736' AND LTRIM(RTRIM(@sCodLin))='HSD'      
  BEGIN    
        
 RETURN;      
  END      
  --|      
                                    
  IF NOT (LEN(@NAVVIA)>0 AND LEN(@GENBKG)>0)                                      
  BEGIN                                        
   select @NAVVIA=NAVVIA11, @GENBKG=genbkg13,@BOOKINGBL=nrocon13 from descarga..edbookin13(nolock) where genbkg13=@sCodInt                                        
  END                                        
  ---------------------------------------------------------------------                                   
  print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                                      
                                        
  if len(@sNroBkg)>0                                                       
  begin                              
    select @sCodTam=codtam09, @sCodTip=codtip05 from edconten04 (nolock) where codcon04=@sNroCtr                                                   
    set @sTamTip= @sCodTam+@sCodTip                                                      
                            
    IF @sCodEve='0900'                            
    BEGIN                            
       select @NRODOC=nroaut14 from edllenad16(nolock)                       
       where codcon04=@sNroCtr and genbkg13=@GENBKG and navvia11=@NAVVIA                            
                            
    SET @TIPODOC='AUT'                            
                            
    END                            
    ELSE                            
    BEGIN                            
       SET @TIPODOC='TKT'                                                
       SELECT @NRODOC=g.nrotkt18                            
       FROM DRCTRTMC90 a (nolock)                                                                
       inner join edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                            
       inner join edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                            
       inner join ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                            
       where b.genbkg13=@GENBKG and b.navvia11=@NAVVIA and a.codcon04=@sNroCtr                            
    END                            
                            
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                 
 --select top 10 * from edllenad16        
          
 DECLARE @sFechaCorregida DATETIME                  
 IF @sCodLin = 'HSD' and @sCodEve='0900'                  
   BEGIN                  
    SET @sFechaCorregida = (select MAX(feclln16) from edllenad16 where codcon04=@sNroCtr and navvia11=@NAVVIA and codemb06='CTR')-- and genbkg13=@GENBKG)                  
    IF LEN(ISNULL(CONVERT(VARCHAR,@sFechaCorregida),'')) > 0                  
    BEGIN                  
       SET @sFecReg = CONVERT(VARCHAR(8),@sFechaCorregida,112) + ' ' + LEFT(CONVERT(VARCHAR,@sFechaCorregida,108),5)                  
    END                  
   END                  
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                  
                   
   --if @sCodLin<>'MSC' -- MSC NO SE ENVIA EN CALLAO, SOLO EN PAITA                                              
   --BEGIN                                            
    IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1                                          
    BEGIN         
     /*   
     print 'p'                                   
     EXEC EnvioLineas.dbo.NEP_CrearRegistroEvento @sCodLin,@sCodEve,@sNroCtr,@sFecReg,@IdRegistro OUTPUT,'EXPO',@NAVVIA,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP                                             
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CODIGO_INTERNO',@sCodInt                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TAMA_CTR',@sCodTam                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TIPO_CTR',@sCodTip                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'PESO_CTR',@dPesCtr                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'FECHA_EVENTO',@sFecReg                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NRO_BOOKING',@sNroBkg                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OBSERVACION',@sObserv                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL','LIMATELEDI7'                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OPERA','9'                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL_ORIGEN','3'                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CONDCONT','5'                                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'SIZETYPE', @sTamTip                                                                              
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALNPT','CALLAO'                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NAVVIA',@NAVVIA                                      
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'GENBKG',@GENBKG                                                    
     */  
       
     SELECT @sCodLin,@sCodEve,@sNroCtr,@sFecReg,@NAVVIA,@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP,@sCodInt,@sCodTam,@sCodTip,@dPesCtr,@dPesCtr,@sFecReg,@sNroBkg,  
     @sObserv,'LIMATELEDI7','9','3','5',@sTamTip,'CALLAO',@NAVVIA,@GENBKG as genbkg13,'CLLNE'  
       
     /*                            
     if @sCodLin='MOL' OR @sCodLin='MSC'                                              
  EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALPUERTO','CLLNE'    
                                            
     EXEC    EnvioLineas.dbo.NEP_CompletarRegistro @IdRegistro                                
     EXEC EnvioLineas.dbo.NEP_ActualizarRegistro_Completo @IdRegistro,@NAVVIA,@GENBKG,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP      
     */                        
    END                   
   --END                                                 
                                                    
  end                                                      
 end                                                
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_prueba_new]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_prueba_new]                                                    
@sCodEve as char(05),                                                    
@sCodLin as char(3),                                                    
@sCodInt as char(06),                                                    
@sNroCtr as char(11),                                                    
@sFecReg as char(14),                                                    
@dPesCtr decimal(12,2)                                                    
as                
                
declare @IdRegistro bigint                                                    
declare @sCodTam char(02)                                                    
declare @sCodTip char(02)                                                    
declare @sNroBkg varchar(25)                                                    
declare @sObserv varchar(50)                                                    
declare @iVal bigint                                                    
declare @sTamTip varchar(4)                                                    
declare @iblq int                                                    
declare @NAVVIA as char(06)                                      
declare @GENBKG as char(06)                            
declare @NRODOC as char(08)                            
declare @TIPODOC as VARchar(10)                          
DECLARE @BOOKINGBL AS VARCHAR(30)                          
DECLARE @SISTEMA AS VARCHAR(30)                          
DECLARE @SP AS VARCHAR(50)                          
                                    
--SET @BOOKINGBL='' /* se obtiene luego */                          
SET @SISTEMA='BALANZA EXPO'                          
SET @SP='sp_Eventos_Expo_Envios'                
            
             
/*              
Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                                                     
values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                    
*/                          
                                                    
select @iblq=count(*) from descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR where contenedor=@sNroCtr and estado='B'                                                    
if @iblq=0                                                    
begin    
                                                 
 --                                      
 select @iVal=count(codcon04) from EVENTOS_LINEAS(nolock) where navvia11=@sCodInt and codcon04=@sNroCtr and cod_evento=@sCodEve and fec_evento>=dateadd(day,-120,getdate())                                 
 --if @iVal=0                                                    
 if @iVal>=0                                                    
 begin                                                                            
   --------- obtiene el navvia y genbkg --------------------------------                                      
  SET @NAVVIA=''                                    
  SET @GENBKG=''                                    
                                  
  select top 1 @NAVVIA=a.NAVVIA11, @GENBKG=a.genbkg13, @sNroBkg=Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,@BOOKINGBL=A.nrocon13,@sObserv=substring(a.nomemb13,1,50)  from                                                     
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                     
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                                 
  order by  a.navvia11 desc, a.genbkg13 desc                                                    
      
  DECLARE @EMB VARCHAR(11)    
      
  select top 1 @EMB=a.codemc12 from                                                     
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                     
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                                 
  order by  a.navvia11 desc, a.genbkg13 desc     
      
  --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD    
  IF LTRIM(RTRIM(@EMB))<>'20373860736' AND LTRIM(RTRIM(@sCodLin))='HSD'    
  BEGIN  
      
 RETURN;    
  END    
  --|    
                                  
  IF NOT (LEN(@NAVVIA)>0 AND LEN(@GENBKG)>0)                                    
  BEGIN                                      
   select @NAVVIA=NAVVIA11, @GENBKG=genbkg13,@BOOKINGBL=nrocon13 from descarga..edbookin13(nolock) where genbkg13=@sCodInt                                      
  END                                      
  ---------------------------------------------------------------------                                 
  print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                                    
                                      
  if len(@sNroBkg)>0                                                     
  begin                            
    select @sCodTam=codtam09, @sCodTip=codtip05 from edconten04 (nolock) where codcon04=@sNroCtr                                                 
    set @sTamTip= @sCodTam+@sCodTip                                                    
                          
    IF @sCodEve='0900'                          
    BEGIN                          
       select @NRODOC=nroaut14 from edllenad16(nolock)                     
       where codcon04=@sNroCtr and genbkg13=@GENBKG and navvia11=@NAVVIA                          
                          
    SET @TIPODOC='AUT'                          
                          
    END                          
    ELSE                          
    BEGIN                          
       SET @TIPODOC='TKT'                                              
       SELECT @NRODOC=g.nrotkt18                          
       FROM DRCTRTMC90 a (nolock)                                                              
       inner join edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                          
       inner join edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                          
       inner join ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                          
       where b.genbkg13=@GENBKG and b.navvia11=@NAVVIA and a.codcon04=@sNroCtr                          
    END                          
                          
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD               
 --select top 10 * from edllenad16      
        
 DECLARE @sFechaCorregida DATETIME                
 IF @sCodLin = 'HSD' and @sCodEve='0900'                
   BEGIN                
    SET @sFechaCorregida = (select MAX(feclln16) from edllenad16 where codcon04=@sNroCtr and navvia11=@NAVVIA and codemb06='CTR')-- and genbkg13=@GENBKG)                
    IF LEN(ISNULL(CONVERT(VARCHAR,@sFechaCorregida),'')) > 0                
    BEGIN                
       SET @sFecReg = CONVERT(VARCHAR(8),@sFechaCorregida,112) + ' ' + LEFT(CONVERT(VARCHAR,@sFechaCorregida,108),5)                
    END                
   END                
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                
                 
   if @sCodLin<>'MSC' -- MSC NO SE ENVIA EN CALLAO, SOLO EN PAITA                                            
   BEGIN                                          
    IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1                                        
    BEGIN   
        
    SELECT 
    @sCodLin AS COD_LINEA,
    @sCodEve AS COD_EVENTO,
    @sNroCtr AS CTR,
    @sCodInt AS CODIGO_INTERNO,
    @sCodTam AS TAMAÑO_CTR,
    @sCodTip AS 'TIPO_CTR',
    @dPesCtr AS PESO_CTR,
    @sFecReg AS FECHA_EVENTO,
    @sNroBkg AS NRO_BOOKING,
    @sObserv AS OBSERVACION,
    'LIMATELEDI7' AS LOCAL,
    '9' AS OPERA,
    '3' AS LOCAL_ORIGEN,  
    '5' AS CONDCONT,
    @sTamTip AS TAMAÑO_TIPO,
    'CALLAO' AS LOCAL_NPT,
    @NAVVIA  AS NAVVIA,
    @GENBKG AS GENBKG,
    ''  AS LOCAL_PUERTO,
    @TIPODOC AS TIPO_DOCUMENTO,
    @NRODOC AS NRO_DOCUMENTO,
    @BOOKINGBL AS BOOKING_LINE,
    @SISTEMA AS NOMBRE_SISTEMA,
    @SP AS NOMBRE_STORED_PROCEDURE
    /*  
    print 'p'                                 
     EXEC EnvioLineas.dbo.NEP_CrearRegistroEvento @sCodLin,@sCodEve,@sNroCtr,@sFecReg,@IdRegistro OUTPUT,'EXPO',@NAVVIA,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP                                           
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CODIGO_INTERNO',@sCodInt                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TAMA_CTR',@sCodTam                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TIPO_CTR',@sCodTip                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'PESO_CTR',@dPesCtr                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'FECHA_EVENTO',@sFecReg                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NRO_BOOKING',@sNroBkg                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OBSERVACION',@sObserv                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL','LIMATELEDI7'                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OPERA','9'                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL_ORIGEN','3'                                
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CONDCONT','5'                                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'SIZETYPE', @sTamTip                                                                            
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALNPT','CALLAO'                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NAVVIA',@NAVVIA                                    
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'GENBKG',@GENBKG                                                  
                               
     if @sCodLin='MOL' OR @sCodLin='MSC'                                            
  EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALPUERTO','CLLNE'                                         
     EXEC    EnvioLineas.dbo.NEP_CompletarRegistro @IdRegistro                              
     EXEC EnvioLineas.dbo.NEP_ActualizarRegistro_Completo @IdRegistro,@NAVVIA,@GENBKG,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP  
     */                        
    END                 
   END                                               
                                                  
  end                                                    
 end                                              
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Eventos_Expo_Envios_TMP]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Eventos_Expo_Envios_TMP]                                                  
@sCodEve as char(05),                                                  
@sCodLin as char(3),                                                  
@sCodInt as char(06),                                                  
@sNroCtr as char(11),                                                  
@sFecReg as char(14),                                                  
@dPesCtr decimal(12,2)                                                  
as              
              
declare @IdRegistro bigint                                                  
declare @sCodTam char(02)                                                  
declare @sCodTip char(02)                                                  
declare @sNroBkg varchar(25)                                                  
declare @sObserv varchar(50)                                                  
declare @iVal bigint                                                  
declare @sTamTip varchar(4)                                                  
declare @iblq int                                                  
declare @NAVVIA as char(06)                                    
declare @GENBKG as char(06)                          
declare @NRODOC as char(08)                          
declare @TIPODOC as VARchar(10)                        
DECLARE @BOOKINGBL AS VARCHAR(30)                        
DECLARE @SISTEMA AS VARCHAR(30)                        
DECLARE @SP AS VARCHAR(50)                        
                                  
--SET @BOOKINGBL='' /* se obtiene luego */                        
SET @SISTEMA='BALANZA EXPO'                        
SET @SP='sp_Eventos_Expo_Envios'              
          
           
            
Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                                                   
values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                  
                        
                                                  
select @iblq=count(*) from descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR where contenedor=@sNroCtr and estado='B'                                                  
if @iblq=0                                                  
begin  
                                               
 --                                    
 select @iVal=count(codcon04) from EVENTOS_LINEAS(nolock) where navvia11=@sCodInt and codcon04=@sNroCtr and cod_evento=@sCodEve and fec_evento>=dateadd(day,-120,getdate())                               
 --if @iVal=0                                                  
 if @iVal>=0                                                  
 begin                                                                          
   --------- obtiene el navvia y genbkg --------------------------------                                    
  SET @NAVVIA=''                                  
  SET @GENBKG=''                                  
                                
  select top 1 @NAVVIA=a.NAVVIA11, @GENBKG=a.genbkg13, @sNroBkg=Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,@BOOKINGBL=A.nrocon13,@sObserv=substring(a.nomemb13,1,50)  from                                                   
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                   
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                               
  order by  a.navvia11 desc, a.genbkg13 desc                                                  
    
  DECLARE @EMB VARCHAR(11)  
    
  select top 1 @EMB=a.codemc12 from                                                   
  descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                   
  where a.navvia11=@sCodInt and a.genbkg13=b.genbkg13 and b.codcon04=@sNroCtr                                               
  order by  a.navvia11 desc, a.genbkg13 desc   
    
  --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD  
  --IF LTRIM(RTRIM(@EMB))<>'20373860736' AND LTRIM(RTRIM(@sCodLin))='HSD'  
  --BEGIN
    
 --RETURN;  
  --END  
  --|  
                                
  IF NOT (LEN(@NAVVIA)>0 AND LEN(@GENBKG)>0)                                  
  BEGIN                                    
   select @NAVVIA=NAVVIA11, @GENBKG=genbkg13,@BOOKINGBL=nrocon13 from descarga..edbookin13(nolock) where genbkg13=@sCodInt                                    
  END                                    
  ---------------------------------------------------------------------                               
  print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                                  
                                    
  if len(@sNroBkg)>0                                                   
  begin                          
    select @sCodTam=codtam09, @sCodTip=codtip05 from edconten04 (nolock) where codcon04=@sNroCtr                                               
    set @sTamTip= @sCodTam+@sCodTip                                                  
                        
    IF @sCodEve='0900'                        
    BEGIN                        
       select @NRODOC=nroaut14 from edllenad16(nolock)                   
       where codcon04=@sNroCtr and genbkg13=@GENBKG and navvia11=@NAVVIA                        
                        
    SET @TIPODOC='AUT'                        
                        
    END                        
    ELSE                        
    BEGIN                        
       SET @TIPODOC='TKT'                                            
       SELECT @NRODOC=g.nrotkt18                        
       FROM DRCTRTMC90 a (nolock)                                                            
       inner join edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                        
       inner join edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                        
       inner join ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                        
       where b.genbkg13=@GENBKG and b.navvia11=@NAVVIA and a.codcon04=@sNroCtr                        
    END                        
                        
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD             
 --select top 10 * from edllenad16    
      
 DECLARE @sFechaCorregida DATETIME              
 IF @sCodLin = 'HSD' and @sCodEve='0900'              
   BEGIN              
    SET @sFechaCorregida = (select MAX(feclln16) from edllenad16 where codcon04=@sNroCtr and navvia11=@NAVVIA and codemb06='CTR')-- and genbkg13=@GENBKG)              
    IF LEN(ISNULL(CONVERT(VARCHAR,@sFechaCorregida),'')) > 0              
    BEGIN              
       SET @sFecReg = CONVERT(VARCHAR(8),@sFechaCorregida,112) + ' ' + LEFT(CONVERT(VARCHAR,@sFechaCorregida,108),5)              
    END              
   END              
 --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD              
               
   if @sCodLin<>'MSC' -- MSC NO SE ENVIA EN CALLAO, SOLO EN PAITA                                          
   BEGIN                                        
    IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1                                      
    BEGIN     
    
    print 'p'                               
     EXEC EnvioLineas.dbo.NEP_CrearRegistroEvento @sCodLin,@sCodEve,@sNroCtr,@sFecReg,@IdRegistro OUTPUT,'EXPO',@NAVVIA,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP                                         
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CODIGO_INTERNO',@sCodInt                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TAMA_CTR',@sCodTam                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'TIPO_CTR',@sCodTip                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'PESO_CTR',@dPesCtr                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'FECHA_EVENTO',@sFecReg                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NRO_BOOKING',@sNroBkg                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OBSERVACION',@sObserv                
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL','LIMATELEDI7'                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'OPERA','9'                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCAL_ORIGEN','3'                              
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'CONDCONT','5'                                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'SIZETYPE', @sTamTip                                                                          
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALNPT','CALLAO'                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'NAVVIA',@NAVVIA                                  
     EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'GENBKG',@GENBKG                                                
                             
     if @sCodLin='MOL' OR @sCodLin='MSC'                                          
  EXEC EnvioLineas.dbo.NEP_AgregarRegistroXCampo @IdRegistro,'LOCALPUERTO','CLLNE'                                       
     EXEC    EnvioLineas.dbo.NEP_CompletarRegistro @IdRegistro                            
     EXEC EnvioLineas.dbo.NEP_ActualizarRegistro_Completo @IdRegistro,@NAVVIA,@GENBKG,'CALLAO',@TIPODOC,@NRODOC,@BOOKINGBL,@SISTEMA,@SP                        
    END               
   END                                             
                                                
  end                                                  
 end                                            
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Balanza_Actualizar_Deposito_Por_Ingreso]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Balanza_Actualizar_Deposito_Por_Ingreso]  
--DECLARE  
@IP as varchar(100),  
@NroAut as char(8)  
AS  
--SET @NroAut = '00669009'  
--SET @IP = '172.16.1.234'   
DECLARE @Deposito char(2), @Flgvia17 char(1)  
  
select @Deposito = DEPOSITO from IPSBALANZAS where ip_balanza = @IP  
  
UPDATE descarga..erconasi17  
SET CODDEP04 = @Deposito,  
FLGVIA17 = CASE WHEN @Deposito = 'TM' THEN '0' ELSE '1' END,  
OTRDEP17 = CASE WHEN @Deposito<>'TM' AND @Deposito<>'OT' THEN '' ELSE OTRDEP17 END  
from descarga..erconasi17 a, EDAUTING14 b   
where a.nroaut14 = b.nroaut14  
and a.nroaut14 = @NroAut  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_AUTORIZACION_CLIENTES]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_AUTORIZACION_CLIENTES]
@NROAUT CHAR (8) 
as
Select isnull(a.codage19,'') as codage19, isnull(a.conten13,'') as conten13, isnull(b.nombre,'') as nombre 
from descarga..edauting14 a (nolock), descarga..aaclientesaa b (nolock) 
Where a.codage19 = b.contribuy And a.nroaut14 = @NROAUT
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_AUTORIZACION_DATOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_AUTORIZACION_DATOS]
@NROAUT CHAR (8) 
as
Select codemc12, nomemb16=isnull(nomemb14,'') from descarga..edauting14 (nolock) Where nroaut14 = @NROAUT
-----------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_AUTORIZACION_v2]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_AUTORIZACION_v2]      
@NROAUT CHAR (8)      
AS      
Select a.nropla81,a.fecaut14,b.conten13,a.genbkg13,a.navvia11,a.codage19,      
c.nombre,d.desemb06, a.codcon14, a.codemb06       
from descarga..edauting14 a (nolock), descarga..edbookin13 b (nolock),       
descarga..aaclientesaa c (nolock), descarga..dqembala06 d (nolock)       
Where a.genbkg13 = b.genbkg13 and a.codage19 = c.contribuy       
and a.codemb06 = d.codemb06 and a.nroaut14 = @NROAUT
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Balanza_Busca_Datos_Autorizacion]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Balanza_Busca_Datos_Autorizacion]       
@splaca char(7),        
@sautor char(8)        
AS        
SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,        
a.nropla18,c.codcon04,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,        
c.codtam09,c.codbol03,d.nrobul16,d.codemb06,nomemb16=b.nomemb14,      
d.nroitm16,b.genbkg13,d.codpro27,c.codarm10,c.codtip05      
FROM         
balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock), descarga..edconten04 c (nolock),        
descarga..edllenad16 d (nolock)        
WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)         
AND (c.codcon04 = d.codcon04) AND (b.navvia11 = d.navvia11)         
AND (b.nroaut14 = d.nroaut14) AND a.nropla18 = @splaca AND a.status18 = 'P'          
AND d.nroaut14 = @sautor --AND d.nrotkt18 is null 
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Balanza_Busca_Nave_Viaje_Descarga]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[sp_Expo_Balanza_Busca_Nave_Viaje_Descarga] 
@NavVia char(6)  
AS  
select ISNULL(codnav08,'') as codnav08,ISNULL(numvia11,'') as numvia11 
from descarga..ddcabman11 (NOLOCK)  
where navvia11 = @NavVia  
------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Balanza_Busca_numvia]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Balanza_Busca_numvia]
@navvia11 varchar(6)
As						
select codnav08,numvia11, 
manifiesto='118-' + cast(anyman11 as char(4)) + '-0'+ numman11
from ddcabman11 
where navvia11=@navvia11
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_BUSCAR_CHOFER]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_BUSCAR_CHOFER]
@LICENCIA VARCHAR(20),
@RUC CHAR(11)
AS
Select a.nombre as nombre from logistica.dbo.sb_conductor a, logistica.dbo.sb_persona b   
where a.persona = b.persona and a.estado = 'A' and b.ruc = @RUC 
and a.numerolicencia = @LICENCIA 
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_BUSCAR_DATOS_TICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_BUSCAR_DATOS_TICKET]
@PLACA CHAR(6)
AS
Select nropla18,nrotkt18,status18,observ18,pestar18 
from ddticket18 (nolock) 
where status18 = 'I' and tipope18 in ('E','T')
and nropla18 = @PLACA
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_BUSCAR_PLACA_RUC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_BUSCAR_PLACA_RUC]
@PLACA CHAR(6)
AS
Select b.ruc as ructransporte,a.placa 
from logistica.dbo.tr_vehiculo a , logistica.dbo.sb_persona b  
where a.persona = b.persona and a.placa = @PLACA and a.estado = 'D' 
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_CTR_TICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_CTR_TICKET]
@TICKET CHAR(8)
AS
Select isnull(a.codcon04,'') as codcon04,isnull(b.codtam09,'') as codtam09,
isnull(b.codbol03,'') as codbol03
from drctrtmc90 a (nolock), edconten04 b (nolock) 
where a.codcon04 = b.codcon04 and a.nrotkt28 = @TICKET
-----------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_DATOS_BALANZA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_DATOS_BALANZA]
@IP CHAR(13)
AS
Select * from IPSBALANZAS (nolock) where IP_BALANZA = @IP
-------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_DATOS_CONTEN04]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_DATOS_CONTEN04]
@CONTENEDOR CHAR(11)
AS
Select isnull(codtam09,'') as codtam09,isnull(codbol03,'') as codbol03,isnull(codtip05,'') as codtip05
from descarga..edconten04 (nolock) where codcon04 = @CONTENEDOR
-------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_DATOS_TICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_DATOS_TICKET]  
/*-----------------------------------------------*/  
/* RETORNA DATOS DEL TICKET DE EXP.-EMB. - JLR   */  
/*-----------------------------------------------*/  
@NTKT char(8)  
AS  
Select status18,Nrotkt18,ISNULL(LTRIM(RTRIM(observ18)),'') AS observ18,ISNULL(codcon04,'') AS codcon04,ISNULL(nrotar18,0) AS nrotar18,
isnull(pesbrt18,0) as pesbrt18,isnull(pestar18,0) as pestar18,isnull(pesnet18,0) as pesnet18,
navvia11,ISNULL(nrocha14,'') AS nrocha14,tipope18,ISNULL(fecing18,'') as fecing18,ISNULL(fecsal18,'') as fecsal18,ISNULL(codemb06,'') as codemb06,
isnull(buling18,0) as buling18,isnull(bulret18,0) as bulret18,ISNULL(nropla18,'') as nropla18,
ISNULL(fimpre18,'') as fimpre18,ISNULL(faduan18,'') as faduan18,isnull(nroaut14,'') as nroaut14,ISNULL(marcas16,'') AS marcas16,ISNULL(nrotra60,'') AS nrotra60
from ddticket18 (nolock) where nrotkt18=@NTKT  
and tipope18 in ('E','T','C')
GO
/****** Object:  StoredProcedure [dbo].[sp_Expo_Balanza_Inserta_Edi_Cosmos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Expo_Balanza_Inserta_Edi_Cosmos]    
@manifest_number  VARCHAR(20), /*numero de manifiesto ej: 127-2008-00070 */    
@container_id     VARCHAR(12), /*ej: SUDU1234567  */    
@event_description VARCHAR(20), /* ej: DIFU */    
@responsable      VARCHAR(10), /* ej: NEPTUNIA, se refiere al responsable del ingreso del registro en su caso sería NEPTUNIA */    
@edi VARCHAR(4000), /* Estructura Edi */    
@op Char(1)    
as  
return  
--EXEC [192.168.0.46].CSMBlueShip.dbo.spu_CSM_insert__csm_tally_events @manifest_number,@container_id,@event_description,@responsable,@edi, @op    
EXEC [192.168.0.59\SQL2005].CSMBlueShip.dbo.spu_CSM_insert__csm_tally_events_neptunia @manifest_number,@container_id,@event_description,@responsable,@edi, @op   
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_VERIFICAR_PASS_PESOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_VERIFICAR_PASS_PESOS]
@PASS VARCHAR(10)
AS
Select nrocambio,passwordpeso,emailsaenviaremb,emailsaenviarmod from DBPASSPE97 (nolock) where passwordpeso =@PASS
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPO_BALANZA_VERIFICAR_PASSWORD]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPO_BALANZA_VERIFICAR_PASSWORD]
@PASS CHAR(10),
@USUARIO CHAR(20)
AS
Select codusu17,codpas99,sucursal from dbpasswo99 (nolock) where codpas99 =@PASS and codusu17=@USUARIO
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTEXPO_EVAL_DESCPROG_X]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_FACTEXPO_EVAL_DESCPROG_X]
@sucursal char(1),
@bookin char(6),  
@servic smallint,  
@tipctr char(2),  
@fecemb smalldatetime,
@flglln char(1)
as  
Select distinct a.nrosec21,a.nrocnd21,b.cantid22,b.criter22,b.codent22,a.flglln21,
b.tipent03,tipentdp=a.tipent03,a.descto21,a.codbol03,a.tipdsc21,a.dialib21,c.*   
from gddesprg21_nt a (nolock), grcndres22_nt b (nolock),   
gdtarser13_nt c (nolock), erentbkg15 d (nolock), gdtaremb24_nt e (nolock)  
where a.nrosec21=b.nrosec20 and a.nrosec21=e.nrosec21  
and b.codent22 in (d.codent03 , '*')   
and b.tipent03=d.tipent03 
and a.sucursal=b.sucursal
and a.sucursal=c.sucursal
and b.sucursal=e.sucursal
and c.sucursal=e.sucursal
and a.sucursal=e.sucursal
and a.sucursal=@sucursal
and genbkg13=@bookin
and e.codtar13=@servic
and a.codtar13=0  
and b.tipcnd22='D' and a.tipent03 in ('01','04')  
and a.codent21 in ( d.codent03 ,'*' ) and dialib21=0  
and c.codtar13=e.codtar13 and a.codtip05 in (@tipctr,'*')   
and convert(char(8),a.fecvig21,112)<=@fecemb
and a.flglln21 in (@flglln,'*')   
union
Select distinct a.nrosec21,a.nrocnd21,b.cantid22,b.criter22,b.codent22,a.flglln21,
b.tipent03,tipentdp=a.tipent03,a.descto21,a.codbol03,a.tipdsc21,a.dialib21,c.*   
from gddesprg21_nt a (nolock), grcndres22_nt b (nolock),   
gdtarser13_nt c (nolock), erentbkg15 d (nolock), gdtaremb24_nt e (nolock)  
where a.nrosec21=b.nrosec20 and a.nrosec21=e.nrosec21  
and b.codent22<>d.codent03
and b.tipent03 in ('06','21')
and b.tipent03=d.tipent03 
and a.sucursal=b.sucursal
and a.sucursal=c.sucursal
and b.sucursal=e.sucursal
and c.sucursal=e.sucursal
and a.sucursal=e.sucursal
and a.sucursal=@sucursal
and genbkg13=@bookin
and e.codtar13=@servic
and a.codtar13=0  
and b.tipcnd22='D' 
and a.codent21 in (d.codent03,'*') 
--and dialib21=0  
and c.codtar13=e.codtar13 and a.codtip05 in (@tipctr,'*')   
and convert(char(8),a.fecvig21,112)<=@fecemb
and a.flglln21 in (@flglln,'*')   
order by a.nrocnd21

GRANT ALL ON SP_FACTEXPO_EVAL_DESCPROG_X TO PUBLIC




GO
/****** Object:  StoredProcedure [dbo].[SP_GETDATA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_GETDATA    Script Date: 08/09/2002 6:45:42 PM ******/
/****** Object:  Stored Procedure dbo.SP_GETDATA    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_GETDATA]
/* ---------------------------------------------------*/
/* RETORNA DATOS DE ACUERDO A UN CRITERIO DADO - JCHP */
/* ---------------------------------------------------*/
	@Campos varchar(250),
	@Tablas varchar(250),
	@Where varchar(240)='',
	@GroupBy varchar(240)='',
	@OrderBy varchar(240)=''
As
	Declare @xWhere varchar(250),  @xGroupBy varchar(250), @xOrderBy varchar(250)
	if @Where<>'' Select @xWhere= " Where " + @Where
	if @GroupBy<>'' Select @xGroupBy = " Group By " + @GroupBy
	if @OrderBy<>'' Select @xOrderBy = " Order By " + @OrderBy
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Execute("Select " + @Campos + " From " + @Tablas + @xWhere + @xGroupBy + @xOrderBy)
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
/****** Object:  StoredProcedure [dbo].[SP_ING_CTRVAC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ING_CTRVAC]  
@NAVVIA VARCHAR(6),  
@CTR VARCHAR(11)  
AS  
BEGIN  
 INSERT INTO descarga..EDINGCTRVAC04(navvia11,codcon04,fecing04,fecusu17,fecusu00)  
 VALUES(@NAVVIA,@CTR,GETDATE(),USER,GETDATE())  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ING_CTRVAC_NEW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ING_CTRVAC_NEW]    
@NAVVIA VARCHAR(6),    
@CTR VARCHAR(11),
@flgArrumaje VARCHAR(1),   
@bkgcom13 VARCHAR(25), 
@codtip05 VARCHAR(2),
@codtam09 VARCHAR(2)
AS    
BEGIN    
	INSERT INTO descarga..EDINGCTRVAC04(navvia11,codcon04,fecing04,fecusu17,fecusu00,flgArrumaje,bkgcom13,codtip05,codtam09)    
	VALUES(@NAVVIA,@CTR,GETDATE(),USER,GETDATE(),@flgArrumaje,@bkgcom13,@codtip05,@codtam09)    
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insertar_Matriz_Eventos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Insertar_Matriz_Eventos]  
(  
@pvc_CodigoInterfaz  varchar (11),  
@pvc_Descripcion_01  varchar(1024),  
@pvc_Descripcion_02  varchar(1024),  
@pvc_Descripcion_03  varchar(1024),  
@pvc_Descripcion_04  varchar(1024),  
@pvc_Descripcion_05  varchar(128),  
@pvc_Descripcion_06  varchar(128),  
@pvc_Descripcion_07  varchar(128),  
@pvc_Descripcion_08  varchar(128),  
@pvc_Descripcion_09  varchar(128),  
@pvc_Descripcion_10  varchar(128),  
@pvc_Descripcion_11  varchar(64),  
@pvc_Descripcion_12  varchar(64),  
@pvc_Descripcion_13  varchar(64),  
@pvc_Descripcion_14  varchar(64),  
@pvc_Descripcion_15  varchar(64),  
@pvc_Descripcion_16  varchar(32),  
@pvc_Descripcion_17  varchar(32),  
@pvc_Descripcion_18  varchar(32),  
@pvc_Descripcion_19  varchar(32),  
@pvc_Descripcion_20  varchar(32),  
@pde_Numero_01   decimal(16,2),  
@pde_Numero_02   decimal(16,2),  
@pde_Numero_03   decimal(16,2),  
@pde_Numero_04   decimal(16,2),  
@pde_Numero_05   decimal(16,2),  
@pde_Numero_06   decimal(16,2),  
@pde_Numero_07   decimal(16,2),  
@pde_Numero_08   decimal(16,2),  
@pde_Numero_09   decimal(16,2),  
@pde_Numero_10   decimal(16,2),  
@pch_flag_01   char(10),  
@pch_flag_02   char(10),  
@pch_flag_03   char(10),  
@pch_flag_04   char(10),  
@pch_flag_05   char(10),  
@pdt_Fecha_01   datetime,  
@pdt_Fecha_02   datetime,  
@pdt_Fecha_03   datetime,  
@pdt_Fecha_04   datetime,  
@pdt_Fecha_05   datetime  
)  
as  
--Begin  
  
  
 /* INSERT INTO [dbo].[Matriz_Eventos]  
       ([vc_CodigoInterfaz]  
       ,[vc_Descripcion_01]  
       ,[vc_Descripcion_02]  
       ,[vc_Descripcion_03]  
       ,[vc_Descripcion_04]  
       ,[vc_Descripcion_05]  
       ,[vc_Descripcion_06]  
       ,[vc_Descripcion_07]  
       ,[vc_Descripcion_08]  
       ,[vc_Descripcion_09]  
       ,[vc_Descripcion_10]  
       ,[vc_Descripcion_11]  
       ,[vc_Descripcion_12]  
       ,[vc_Descripcion_13]  
       ,[vc_Descripcion_14]  
       ,[vc_Descripcion_15]  
       ,[vc_Descripcion_16]  
       ,[vc_Descripcion_17]  
       ,[vc_Descripcion_18]  
       ,[vc_Descripcion_19]  
       ,[vc_Descripcion_20]  
       ,[de_Numero_01]  
       ,[de_Numero_02]  
       ,[de_Numero_03]  
       ,[de_Numero_04]  
       ,[de_Numero_05]  
       ,[de_Numero_06]  
       ,[de_Numero_07]  
       ,[de_Numero_08]  
       ,[de_Numero_09]  
       ,[de_Numero_10]  
       ,[ch_flag_01]  
       ,[ch_flag_02]  
       ,[ch_flag_03]  
       ,[ch_flag_04]  
       ,[ch_flag_05]  
       ,[dt_Fecha_01]  
       ,[dt_Fecha_02]  
       ,[dt_Fecha_03]  
       ,[dt_Fecha_04]  
       ,[dt_Fecha_05]
       ,[ch_EstadoEvento])  
    VALUES  
       (@pvc_CodigoInterfaz,  
       @pvc_Descripcion_01,  
       @pvc_Descripcion_02,  
       @pvc_Descripcion_03,   
       @pvc_Descripcion_04,  
       @pvc_Descripcion_05,  
       @pvc_Descripcion_06,  
       @pvc_Descripcion_07,  
       @pvc_Descripcion_08,   
       @pvc_Descripcion_09,   
       @pvc_Descripcion_10,   
       @pvc_Descripcion_11,   
       @pvc_Descripcion_12,  
       @pvc_Descripcion_13,   
       @pvc_Descripcion_14,   
       @pvc_Descripcion_15,  
       @pvc_Descripcion_16,   
       @pvc_Descripcion_17,   
       @pvc_Descripcion_18,   
       @pvc_Descripcion_19,   
       @pvc_Descripcion_20,   
       @pde_Numero_01,   
       @pde_Numero_02,   
       @pde_Numero_03,   
       @pde_Numero_04,  
       @pde_Numero_05,   
       @pde_Numero_06,   
       @pde_Numero_07,   
       @pde_Numero_08,   
       @pde_Numero_09,  
       @pde_Numero_10,  
       @pch_flag_01,   
       @pch_flag_02,  
       @pch_flag_03,   
       @pch_flag_04,  
       @pch_flag_05,   
       @pdt_Fecha_01,   
       @pdt_Fecha_02,   
       @pdt_Fecha_03,   
       @pdt_Fecha_04,   
       @pdt_Fecha_05,
       'FI')  
  */
--End  

GO
/****** Object:  StoredProcedure [dbo].[Sp_Int2_Int007]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Sp_Int2_Int007]
@NroContendor char(11)
AS
Begin
	Select e.bookin13, b.genbkg13, c.feclle11
	from DESCARGA..edconten04 a (nolock)
	inner join DESCARGA..edllenad16 b (nolock) on b.codcon04 = a.codcon04 
	inner join DESCARGA..ddcabman11 c (nolock) on c.navvia11 = b.navvia11
	inner join DESCARGA..erconasi17 d (nolock) on d.codcon04 = b.codcon04 and a.codcon04 = d.codcon04 and b.genbkg13 = d.genbkg13 
	inner join DESCARGA..edbookin13 e (nolock) on e.genbkg13 = d.genbkg13 and e.genbkg13 = b.genbkg13 and e.navvia11 = b.navvia11
	and c.navvia11 = e.navvia11
	where	b.codcon04 = @NroContendor

	group by e.bookin13, b.genbkg13, c.feclle11
	order by c.feclle11 desc
	
End

GO
/****** Object:  StoredProcedure [dbo].[Sp_Int2_Int007_SalidaCTRBookings]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Sp_Int2_Int007_SalidaCTRBookings]            
@NumeroInternoBooking varchar(6),
@Booking varchar(6)
as
Begin

	EXEC Descarga..Sp_Insertar_Matriz_Eventos 'INT2.INT007',@NumeroInternoBooking,@Booking,'','','','','','','','','','','','','','','','','','',0,0,0,0,0,0,0,0,0,0, '', '', '', '', '',Null,Null,Null,Null,Null

End
GO
/****** Object:  StoredProcedure [dbo].[sp_IntN4_ObtenerValorCosetting]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_IntN4_ObtenerValorCosetting] 
@KeyCosetting VARCHAR(100)
AS
BEGIN
	SET @KeyCosetting = LTRIM(RTRIM(@KeyCosetting))

	SELECT VALUE
	FROM Terminal..COSETTING
	WHERE KEY_COSETTING = @KeyCosetting
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LISTANVCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_LISTANVCTR    Script Date: 08/09/2002 6:45:42 PM ******/
/****** Object:  Stored Procedure dbo.SP_LISTANVCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_LISTANVCTR] 
/* ------------------------------------------------------------	*/
/* RETORNA LISTA DE NAVES / VIAJES DONDE SE REGISTRO EL CTR.    */
/* ANTERIORMENTE DE ACUERDO A UN CRITERIO ESPECIFICO 		*/
/* ------------------------------------------------------------ */
/* AUTOR : JORGE CHAVEZ PERALTA        	       FECHA: 28/DIC/96 */
/* ------------------------------------------------------------ */
@BAN char(11)
As
SELECT 
a.codnav08,a.numvia11,b.codtam09,b.codbol03,b.navvia11,b.nropre04,
b.codarm10,b.codtip05,b.codpue02,b.flgali04,b.flgveh04,b.flgdes04,b.flgsta04
FROM 
ddcabman11 a (NOLOCK), ddconten04 b (NOLOCK)
WHERE 

(a.navvia11 = b.navvia11)
AND b.codcon04 = @BAN ORDER BY 1

GO
/****** Object:  StoredProcedure [dbo].[SP_ORDRETAB]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ORDRETAB    Script Date: 08/09/2002 6:45:46 PM ******/
/****** Object:  Stored Procedure dbo.SP_ORDRETAB    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_ORDRETAB]
/* ----------------------------------------------*/
/* RETORNA ORDENES DE RETIRO EN ABANDONO LEGAL   */
/* ----------------------------------------------*/
@FECINI char (8),
@FECFIN char (8)
AS
SELECT B.FECSAL18, A.NROORD41, B.NROTKT18, B.NROPLA18, B.NROORD41, A.CODEMB06,
C.CODNAV08, C.NUMVIA11, RAZAGE19=D.NOMBRE, A.NROBUL41, A.PESAUT41, B.BULRET18, B.PESNET18, 
A.NAVVIA11,A.NRODET12,B.FECUSU00,B.CODUSU17 
FROM DDORDRET41 A (NOLOCK), DDTICKET18 B (NOLOCK), DDCABMAN11 C (NOLOCK), aaagente01 D (NOLOCK)
WHERE A.NAVVIA11 = B.NAVVIA11 AND A.NAVVIA11 = C.NAVVIA11 
AND A.NROORD41 = B.NROORD41 AND A.CODAGE19 = D.CLIENTE
AND B.FECSAL18 >= @FECINI AND B.FECSAL18 < @FECFIN
AND A.CODAGE19 = 'S077'
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDRETXF]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ORDRETXF    Script Date: 08/09/2002 6:45:47 PM ******/
/****** Object:  Stored Procedure dbo.SP_ORDRETXF    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_ORDRETXF]
@FECINI char (8),
@FECFIN char (8)
AS
SELECT B.FECSAL18, A.NROORD41, B.NROTKT18, B.NROPLA18, B.NROORD41, A.CODEMB06,
C.CODNAV08, C.NUMVIA11, RAZAGE19=D.NOMBRE, A.NROBUL41, A.PESAUT41, B.BULRET18, B.PESNET18, 
A.NAVVIA11,A.NRODET12,B.FECUSU00,B.CODUSU17 
FROM DDORDRET41 A (NOLOCK), DDTICKET18 B (NOLOCK), DDCABMAN11 C (NOLOCK), aaagente01 D (NOLOCK)
WHERE A.NAVVIA11 = B.NAVVIA11 AND A.NAVVIA11 = C.NAVVIA11 
AND A.NROORD41 = B.NROORD41 AND A.CODAGE19 = D.CLIENTE
AND B.FECSAL18 >= @FECINI AND B.FECSAL18 < @FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDTRA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ORDTRA]
/* ------------------------------------------------------------	*/
/* INGRESA DATOS DE LAS TABLAS DE ORDENES DE TRABAJO            */
/* POR CONTENEDOR PARA LA CONEXION DE REFFERS POR BALANZA(ING.) */
/* ------------------------------------------------------------ */
/* AUTOR : JORGE CHAVEZ PERALTA        	       FECHA: 09/JUN/98 */
/* ------------------------------------------------------------ */
@snavia char(6),
@sconte char(11),
@stkt char(8)
As
Declare @Tip Char(1) ,
	@NroFor CHAR(12),
	@Nrobook CHAR(6),
	@codarm CHAR(3),
	@codage CHAR(11),
	@flgbook CHAR(1),
	@sucursal CHAR(1)
SELECT DISTINCT @Nrobook = b.genbkg13, @flgbook = c.flgcon13, 
@codarm = a.codarm10, @codage = d.codage19, @sucursal = d.sucursal
FROM descarga..EDCONTEN04 a (nolock), descarga..ERCONASI17 b (nolock), descarga..EDBOOKIN13 c (nolock), 
descarga..EDAUTING14 d (nolock), descarga..EDLLENAD16 e (nolock)
WHERE 
c.navvia11 = @snavia and a.codcon04 = @sconte 
and a.codcon04 = b.codcon04 and b.genbkg13 = c.genbkg13 
and c.genbkg13 = e.genbkg13 and d.nroaut14 = e.nroaut14 
and a.codcon04 = e.codcon04
and a.codtip05 in ('RF','RH')
IF @@rowcount > 0 
   BEGIN
     SELECT @NroFor = RIGHT('000000' + CONVERT(VARCHAR,CONTAD00 + 1),6) FROM descarga..ECORDTRA60 
     INSERT descarga..EDORDTRA60 (NROTRA60 , FECTRA60, CODAGE19, CODARM10, NAVVIA11 , GENBKG13, FECEMI60, STATUS60, SUCURSAL)
     VALUES (@NroFor , DateAdd(Minute ,30, getdate() ), @codage, @codarm , @snavia , @Nrobook , getdate() , 'E', @sucursal)
     INSERT descarga..EDDETTRA61 (NROTRA60 , CODCON04 , TIPTRA61, SUCURSAL) VALUES (@NroFor , @sconte , 'C', @sucursal)
     UPDATE balanza..DDTICKET18 SET NROTRA60 = @NroFor WHERE nrotkt18 = @stkt
     UPDATE descarga..ECORDTRA60 SET CONTAD00 = convert(int , @NroFor)  
   END
GO
/****** Object:  StoredProcedure [dbo].[SP_PLACA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLACA    Script Date: 08/09/2002 6:45:47 PM ******/
/****** Object:  Stored Procedure dbo.SP_PLACA    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_PLACA] 
/*----------------------------------------------------------------------------*/
/* RETORNA DATOS DEL TICKET POR PLACA 15 DIAS ANTES DE SU ULT. INGRESO - JCHP */
/*----------------------------------------------------------------------------*/
@PLACA char(7),
@FECHA datetime
AS
Select * from ddticket18 (NOLOCK) where nropla18=@PLACA and 
fecing18 >=@FECHA and tipope18 <> 'R'
ORDER BY NROTKT18

GO
/****** Object:  StoredProcedure [dbo].[SP_PLACAS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLACAS    Script Date: 08/09/2002 6:45:47 PM ******/
/****** Object:  Stored Procedure dbo.SP_PLACAS    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_PLACAS]
/*-------------------------------------------------------*/
/* RETORNA DATOS DE LA PLACA A RETIRAR MERCADERIA - JCHP */
/*-------------------------------------------------------*/
@NPLACA char(7)
AS
Select * from ddbplaca24 (NOLOCK) where nropla24=@NPLACA
GO
/****** Object:  StoredProcedure [dbo].[SP_PLAING]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLAING    Script Date: 08/09/2002 6:45:47 PM ******/
/****** Object:  Stored Procedure dbo.SP_PLAING    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_PLAING]
/*-------------------------------------------------------*/
/* RETORNA DATOS DE LA PLACA A RETIRAR MERCADERIA - JCHP */
/*-------------------------------------------------------*/
@NPLACA char(7)
AS
Select * from ddbplaca24 (NOLOCK) where nropla24=@NPLACA
and status24 ='I'
GO
/****** Object:  StoredProcedure [dbo].[SP_PLAINGN]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLAINGN    Script Date: 08/09/2002 6:45:47 PM ******/
ALTER PROCEDURE [dbo].[SP_PLAINGN]
/*-------------------------------------------------------*/
/* RETORNA DATOS DE LA PLACA A RETIRAR MERCADERIA - JCHP */
/*-------------------------------------------------------*/
@NPLACA char(7)
AS
Select * from ddbplaca24 (nolock) where nropla24=@NPLACA
and status24 ='P'                                         
GO
/****** Object:  StoredProcedure [dbo].[SP_PLAINGTARA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLAINGTARA    Script Date: 08/09/2002 6:45:42 PM ******/
ALTER PROCEDURE [dbo].[SP_PLAINGTARA]
/*------------------------------------------------------*/
/* RETORNA DATOS DE LA PLACA DESTARE AUTOMATICO	- JCHP  */
/*------------------------------------------------------*/
@NPLACA char(7)
AS
Select * from ddplacas17 where nropla17=@NPLACA
and status17 ='I'

GO
/****** Object:  StoredProcedure [dbo].[SP_RBDXT_ALL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBDXT_ALL    Script Date: 08/09/2002 6:45:47 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBDXT_ALL    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBDXT_ALL]
@NAVVIA  char (6)
AS
SELECT DISTINCT A.NAVVIA11,XX = SUBSTRING(A.CODCON04,1,4), YY = SUBSTRING(A.CODCON04,5,11),
A.NROTKT18,B.CODTIP05,B.CODTAM09,A.NROPLA18,A.PESENA18,A.PESBRT18,A.PESTAR18,A.PESNET18,
A.NROTAR18,DIFER=A.PESNET18-(A.NROTAR18 * 1000)
FROM DDTICKET18 A (NOLOCK), DDCONTEN04 B (NOLOCK)
WHERE A.NAVVIA11 = @NAVVIA AND A.NAVVIA11=B.NAVVIA11 AND A.CODCON04=B.CODCON63 
AND B.NROTKT18 IS NOT NULL AND A.STATUS18 = 'S' ORDER BY YY
GO
/****** Object:  StoredProcedure [dbo].[SP_RBDXT_BUL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBDXT_BUL    Script Date: 08/09/2002 6:45:48 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBDXT_BUL    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBDXT_BUL] 
@NAVVIA char(6)
AS
SELECT DISTINCT A.NAVVIA11,A.NROTKT18,A.NROPLA18,B.DESITM16,
A.PESBRT18,A.PESTAR18,A.PESNET18,A.NROSEC18,A.BULING18
FROM DDTICKET18 A (NOLOCK), DDCARGAS16 B (NOLOCK)
WHERE A.NAVVIA11 = @NAVVIA AND A.NAVVIA11 = B.NAVVIA11 AND 
A.NROSEC18 = B.NROCAR16 AND STATUS18 = 'S' ORDER BY A.NROTKT18

GO
/****** Object:  StoredProcedure [dbo].[SP_RBDXT_LCL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBDXT_LCL    Script Date: 08/09/2002 6:45:48 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBDXT_LCL    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBDXT_LCL]
@NAVVIA char (6)
AS
SELECT DISTINCT A.NAVVIA11,XX = SUBSTRING(A.CODCON04,1,4), YY = SUBSTRING(A.CODCON04,5,11),B.CODBOL03,
A.NROTKT18,B.CODTIP05,B.CODTAM09,A.NROPLA18,A.PESENA18,A.PESBRT18,A.PESTAR18,A.PESNET18,A.NROTAR18,DIFER=A.PESNET18-(A.NROTAR18 * 1000)
FROM DDTICKET18 A, DDCONTEN04 B 
WHERE A.NAVVIA11 = @NAVVIA AND A.NAVVIA11=B.NAVVIA11 AND A.CODCON04=B.CODCON63 
AND B.NROTKT18 IS NOT NULL AND A.STATUS18 = 'S' AND B.CODBOL03 = 'LC' ORDER BY YY

GO
/****** Object:  StoredProcedure [dbo].[SP_RBDXT_VEH]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBDXT_VEH    Script Date: 08/09/2002 6:45:48 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBDXT_VEH    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBDXT_VEH] 
@NAVVIA char(6)
AS
SELECT DISTINCT A.NAVVIA11,A.NROTKT18,A.NROPLA18,B.DESITM14,
A.PESBRT18,A.PESTAR18,A.PESNET18,A.NROSEC18,A.NROCHA14
FROM DDTICKET18 A (NOLOCK), DDVEHICU14 B (NOLOCK)
WHERE A.NAVVIA11 = @NAVVIA AND A.NAVVIA11 = B.NAVVIA11 AND 
A.NROSEC18 = B.NROVEH14 AND STATUS18 = 'S' ORDER BY A.NROTKT18

GO
/****** Object:  StoredProcedure [dbo].[SP_RBNLBUL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBNLBUL    Script Date: 08/09/2002 6:45:42 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBNLBUL    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBNLBUL]
@NAVVIA char (6)
AS
SELECT NROCAR16,CODCON04,NROBUL16,DESITM16,NROTKT18,NAVVIA11,STALIQ16,CODEMB06
FROM DDCARGAS16 
WHERE NAVVIA11 = @NAVVIA AND NROTKT18 IS NULL 
OR NAVVIA11 = @NAVVIA AND STALIQ16 = 'P' ORDER BY NROCAR16

GO
/****** Object:  StoredProcedure [dbo].[SP_RBNLCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBNLCTR    Script Date: 08/09/2002 6:45:42 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBNLCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBNLCTR] 
@NAVVIA char (6)
AS
SELECT A.CODCON04,A.CODTIP05,A.CODTAM09,B.DESABV03,A.NROTKT18,A.NAVVIA11,A.FLAGCO04 
FROM DDCONTEN04 A (NOLOCK), DQCONDCN03 B (NOLOCK), DRBLCONT15 C (NOLOCK)
WHERE A.NAVVIA11 = @NAVVIA AND A.NAVVIA11 = C.NAVVIA11 AND A.CODBOL03 = B.CODBOL03 
AND NROTKT18 IS NULL AND A.FLAGCO04 = '1' AND C.NROTKT28 IS NULL AND A.FLGSTA04 <> '0' 
AND A.CODCON04 = C.CODCON04 ORDER BY A.CODCON04
GO
/****** Object:  StoredProcedure [dbo].[SP_RBNLVEH]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RBNLVEH    Script Date: 08/09/2002 6:45:43 PM ******/
/****** Object:  Stored Procedure dbo.SP_RBNLVEH    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_RBNLVEH]
@NAVVIA char (6)
AS
SELECT NROVEH14,NROCHA14,DESITM14,NROTKT18,NAVVIA11,FLAGVE14,CODCON04
FROM DDVEHICU14 
WHERE NAVVIA11 = @NAVVIA AND NROTKT18 IS NULL 
AND FLAGVE14 = '1' ORDER BY NROVEH14

GO
/****** Object:  StoredProcedure [dbo].[sp_replsync]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_replsync    Script Date: 08/09/2002 6:45:48 PM ******/
--ALTER PROCEDURE [dbo].[sp_replsync] (	@publisher varchar (30),		/* publication server name */	@publisher_db varchar (30),		/* publication database name */	@publication varchar (30),		/* publication name */	@article varchar (30) = ''             /* article name */	) AS    SET NOCOUNT ON    DECLARE @msg varchar(255)    /*    ** Parameter Check: @publisher.    ** Check to make sure that the publisher exists in the sysservers table    */    IF @publisher IS NULL       BEGIN          RAISERROR 51000 'The publisher''s name was not provided '          RETURN (1)       END    IF NOT EXISTS (SELECT * FROM master..sysservers                   WHERE srvname = @publisher)       BEGIN          select @msg = 'Publisher ' + @publisher          select @msg = @msg + '~~Rush_115~~'          RAISERROR 51001 @msg          RETURN (1)       END    /*    ** Parameter Check:  @publication    ** Check to make sure that the publication is not NULL, you    ** are in a subscriber database, and that MSlast_job_info    ** is waiting on the article sync.    */    IF @publication IS NULL       BEGIN          RAISERROR 51002 ' is not defined in master..sysservers'          RETURN (1)       END     /*    ** Parameter Check:  @article    ** Check to make sure that the article is not NULL, you    ** are in a subscriber database, and that MSlast_job_info    ** is waiting on the article sync.    */    IF @article IS NULL       BEGIN          RAISERROR 51003 'The publication name was not provided'          RETURN (1)       END    IF NOT EXISTS(SELECT * FROM sysobjects                  WHERE name = 'MSlast_job_info')       BEGIN          select @msg = 'The article name was not provided'          select @msg = @msg + DB_NAME()          RAISERROR 51004 @msg          RETURN (1)       END    IF NOT EXISTS(SELECT * from MSlast_job_info		WHERE publisher = @publisher		and publisher_db = @publisher_db		and publication = @publication		and article like @article)       BEGIN         select @msg = 'Table MSlast_job_info was not found in database '         select @msg = @msg + 'Replication table MSlast_job_info contains no entry' + @publication	 IF @article <> ''	    select @msg = @msg + ' waiting on a sync for publication ' + @article         RAISERROR 51005 @msg         RETURN (1)       END    /*    ** All Parameters Check Out.    ** So remove information record for the article in MSlast_job_info.    */    delete from MSlast_job_info		WHERE publisher = @publisher		and publisher_db = @publisher_db		and publication = @publication		and article like @article    /*    ** If there are no more manual synchronizations pending increment then    ** job_id in MSlast_job_info.    */    IF NOT EXISTS(SELECT * from MSlast_job_info		WHERE publisher = @publisher		and publisher_db = @publisher_db		and publication = @publication)       BEGIN	    UPDATE MSlast_job_info	    SET job_id = job_id + 1	    WHERE publisher = @publisher	    and publisher_db = @publisher_db		   IF @@ERROR <> 0	      BEGIN		 select @msg = ' article '		 select @msg = @msg + 'Update of job_id in table MSlast_job_info failed' + @publisher + ', ' + @article		 RAISERROR 51006 @msg		 RETURN (1)	      END       END	   /*   ** Success   */   RETURN (0)
--GO
/****** Object:  StoredProcedure [dbo].[SP_SALMACEN]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALMACEN    Script Date: 08/09/2002 6:45:48 PM ******/
/****** Object:  Stored Procedure dbo.SP_SALMACEN    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_SALMACEN] 
@NROSAL char (6),
@NAVVIA char (6)
AS
Select nrosal52,nrotkt18 from DDTICKET18 (NOLOCK)
where nrosal52 = @NROSAL and navvia11 = @NAVVIA

GO
/****** Object:  StoredProcedure [dbo].[SP_SHIPEROWN]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SHIPEROWN    Script Date: 08/09/2002 6:45:43 PM ******/
/****** Object:  Stored Procedure dbo.SP_SHIPEROWN    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_SHIPEROWN]
/* ---------------------------------------*/
/* RETORNA SI EL CTR ES SHIPER OWN - JCHP */
/* ---------------------------------------*/
@CTR char(11),
@NAV char(6)
AS
Select shiown04,codtip05,codcon04 from ddconten04 (NOLOCK)
where codcon04=@CTR and navvia11=@NAV

GO
/****** Object:  StoredProcedure [dbo].[SP_TARJOCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TARJOCTR    Script Date: 08/09/2002 6:45:43 PM ******/
/****** Object:  Stored Procedure dbo.SP_TARJOCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_TARJOCTR]
/* -----------------------------------------*/
/* RETORNA CTR SI ESTA TARJADO O NO - JCHP  */
/* -----------------------------------------*/
@CTR char(11),
@NAV char(6)
AS
Select codcon63 from ddcontar63 (NOLOCK) where codcon63=@CTR and navvia11=@NAV

GO
/****** Object:  StoredProcedure [dbo].[SP_TKT]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TKT    Script Date: 08/09/2002 6:45:48 PM ******/
/****** Object:  Stored Procedure dbo.SP_TKT    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_TKT] 
/*----------------------------------------------*/
/* RETORNA DATOS DEL TICKET A CONSULTAR - JCHP  */
/*----------------------------------------------*/
@NTKT char(8)
AS
Select * from balanza..ddticket18 (NOLOCK) where nrotkt18=@NTKT

GO
/****** Object:  StoredProcedure [dbo].[SP_TKTEXP]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[SP_TKTEXP]
/*-----------------------------------------------*/
/* RETORNA DATOS DEL TICKET DE EXP.-EMB. - JCHP  */
/*-----------------------------------------------*/
@NTKT char(8)
AS
Select * from ddticket18 (nolock) where nrotkt18=@NTKT
and tipope18 in ('E','T','C')
GO
/****** Object:  StoredProcedure [dbo].[SP_TKTXFEC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TKTXFEC    Script Date: 08/09/2002 6:45:49 PM ******/
/****** Object:  Stored Procedure dbo.SP_TKTXFEC    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_TKTXFEC]
/* ---------------------------------------*/
/* RETORNA TICKETS POR UN RANGO DE FECHAS */
/* ---------------------------------------*/
@FECINI char (8),
@FECFIN char (8)
AS
SELECT DISTINCT A.NROTKT18,A.FECING18,A.NROPLA18,NROTAR18=A.NROTAR18 * 1000,B.DESNAV08,A.CODUSU17,
A.FECUSU00,C.NUMVIA11,A.TIPOPE18,A.CODCON04,A.PESBRT18,A.PESTAR18,A.PESNET18,
A.NROCHA14,A.NROTAR18,A.BULING18,A.STATUS18,A.NAVVIA11
FROM DDTICKET18 A (NOLOCK), DQNAVIER08 B (NOLOCK), DDCABMAN11 C (NOLOCK)
WHERE A.NAVVIA11 = C.NAVVIA11 AND B.CODNAV08 = C.CODNAV08  
AND TIPOPE18 NOT IN ('E','T','R')
AND A.FECING18 >= @FECINI
AND A.FECING18 < @FECFIN
ORDER BY A.NROTKT18

GO
/****** Object:  StoredProcedure [dbo].[SP_TOTRETXF]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TOTRETXF    Script Date: 08/09/2002 6:45:49 PM ******/
/****** Object:  Stored Procedure dbo.SP_TOTRETXF    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_TOTRETXF]
@FECINI char (8),
@FECFIN char (8)
AS
select tipbul="CTR", total=sum(bulret18) from ddticket18 (NOLOCK)
where fecsal18 >= @FECINI and fecsal18 < @FECFIN and
codemb06 = 'ctr'
union
select tipbul="BUL", total=sum(bulret18) from ddticket18 (NOLOCK)
where fecsal18 >= @FECINI and fecsal18 < @FECFIN and 
codemb06 = 'bul'
union
select tipbul="VEH", total=sum(bulret18) from ddticket18 (NOLOCK)
where fecsal18 >= @FECINI and fecsal18 < @FECFIN and 
codemb06 = 'veh'

GO
/****** Object:  StoredProcedure [dbo].[sp_truncatelogbalanza1]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[sp_truncatelogbalanza1]
--AS
--DUMP TRANSACTION BALANZA WITH TRUNCATE_ONLY
--DUMP TRANSACTION BALANZA WITH NO_LOG

GO
/****** Object:  StoredProcedure [dbo].[SP_VAL_ASIG_CTRVACIOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VAL_ASIG_CTRVACIOS]  
@CTR VARCHAR(11)      
AS      
BEGIN      
SET NOCOUNT ON;      
       
 DECLARE @MENSAJE VARCHAR(150), @ICOUNT INT      
 SET @MENSAJE=''      
         
 DECLARE @CODARM VARCHAR(3)      
         
 IF LEN(@CTR)<11      
 BEGIN      
  SET @MENSAJE='El Contenedor Debe tener 11 digitos, Verificar'      
  SELECT @MENSAJE AS 'Mensaje','' AS 'codnav08','' AS 'desnav08','' AS  'numvia11','' AS 'feclle11','' AS 'navvia11'      
  RETURN;      
 END  
   
 SELECT @ICOUNT=COUNT(*)    
 FROM Descarga..EDBOOKIN13 A WITH (NOLOCK)      
 INNER JOIN Descarga..ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13      
 WHERE B.codcon04=@CTR        
   
 IF @ICOUNT=0      
 BEGIN      
  SET @MENSAJE='El Contenedor: ' + @CTR + ' No cuenta con Asignación'      
  SELECT @MENSAJE AS 'Mensaje','' AS 'codnav08','' AS 'desnav08','' AS  'numvia11','' AS 'feclle11','' AS 'navvia11'    
  RETURN;      
 END  
   
 SELECT TOP 1 @MENSAJE AS 'Mensaje',C.codnav08,LTRIM(RTRIM(D.desnav08)) AS desnav08,  
 C.numvia11,C.feclle11,C.navvia11  
 FROM Descarga..EDBOOKIN13 A WITH (NOLOCK)      
 INNER JOIN Descarga..ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13  
 INNER JOIN Descarga..DDCABMAN11 C WITH (NOLOCK) ON A.navvia11=C.navvia11   
 INNER JOIN Descarga..DQNAVIER08 D WITH (NOLOCK) ON D.codnav08=C.codnav08    
 WHERE B.codcon04=@CTR   
 ORDER BY A.fecusu00 DESC  
       
 /*      
 SELECT @ICOUNT=COUNT(*)      
 FROM EDBOOKIN13 A WITH (NOLOCK)      
 INNER JOIN ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13      
 WHERE A.navvia11=@NAVVIA AND B.codcon04=@CTR      
       
 IF @ICOUNT=0      
 BEGIN      
  SET @MENSAJE='El Contenedor no se encuentra Asignado a la Nave/Viaje ingresados'      
  SELECT @MENSAJE AS 'Mensaje','' AS 'linea'      
  RETURN;      
 END      
       
       
 SELECT @ICOUNT=COUNT(*)      
 FROM EDINGCTRVAC04 WITH (NOLOCK)      
 WHERE navvia11=@NAVVIA AND codcon04=@CTR      
       
 IF @ICOUNT > 0      
 BEGIN      
  SET @MENSAJE='Ya existe un ingreso del contenedor Vácio: ' + @CTR + ' Asociado a la Nave/Viaje ingresados'      
  SELECT @MENSAJE AS 'Mensaje','' AS 'linea'      
  RETURN;      
 END      
       
 SELECT @CODARM=A.codarm10      
 FROM EDBOOKIN13 A WITH (NOLOCK)      
 INNER JOIN ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13      
 WHERE A.navvia11=@NAVVIA AND B.codcon04=@CTR      
 */           
    
SET NOCOUNT OFF;      
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VAL_CTRVACIOS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VAL_CTRVACIOS]    
@NAVVIA VARCHAR(6),    
@CTR VARCHAR(11)    
AS    
BEGIN    
SET NOCOUNT ON;    
     
 DECLARE @MENSAJE VARCHAR(150), @ICOUNT INT    
 SET @MENSAJE=''    
  
  
 SELECT @ICOUNT=COUNT(*)    
 FROM Descarga..EDBOOKIN13 A WITH (NOLOCK)    
 INNER JOIN Descarga..ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13    
 WHERE A.navvia11=@NAVVIA AND B.codcon04=@CTR    
     
 IF @ICOUNT=0    
 BEGIN    
  SET @MENSAJE='El Contenedor no se encuentra Asignado a la Nave/Viaje ingresados'    
  SELECT @MENSAJE AS 'Mensaje','' as 'Linea' 
  RETURN;    
 END    
     
     
 SELECT @ICOUNT=COUNT(*)    
 FROM Descarga..EDINGCTRVAC04 WITH (NOLOCK)    
 WHERE navvia11=@NAVVIA AND codcon04=@CTR    
     
 IF @ICOUNT > 0    
 BEGIN    
  SET @MENSAJE='Ya existe un ingreso del contenedor Vácio: ' + @CTR + ' Asociado a la Nave/Viaje ingresados'    
  SELECT @MENSAJE AS 'Mensaje','' as 'Linea'     
  RETURN;    
 END    
 
 DECLARE @CODARM VARCHAr(3)
 
 SELECT @CODARM=A.codarm10    
 FROM Descarga..EDBOOKIN13 A WITH (NOLOCK)    
 INNER JOIN Descarga..ERCONASI17 B WITH (NOLOCK) ON A.genbkg13=B.genbkg13    
 WHERE A.navvia11=@NAVVIA AND B.codcon04=@CTR    
  
 SELECT @MENSAJE AS 'Mensaje',@CODARM as 'Linea'  
  
SET NOCOUNT OFF;    
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDA_CORRELATIVA_BALANZAEXPO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDA_CORRELATIVA_BALANZAEXPO]
@CORRELATIVO VARCHAR(3),
@SUCURSAL VARCHAR(1)
AS
BEGIN
SET NOCOUNT ON;
	SET @CORRELATIVO=LTRIM(RTRIM(@CORRELATIVO))
	DECLARE @NUM_COR INT
	DECLARE @NUM_CORRELATIVO VARCHAR(10) --CORRELATIVO
	DECLARE @NUM_COR_ACT VARCHAR(10) --NUMERO DE GUIA EN EL SISTEMA
	DECLARE @MENSAJE VARCHAR(250)
	
	SET @MENSAJE=''
	
	IF @SUCURSAL='3'
	BEGIN
		--CABECERA DE LAS GUIA
		SELECT @NUM_COR_ACT=MAX(nrogui19) FROM
		DDGUITPC19 WITH (NOLOCK)
		WHERE nrogui19 LIKE + '' + @CORRELATIVO + '%'
		
		IF @CORRELATIVO='048'
		BEGIN
			SELECT @NUM_COR=contad00 FROM DCGUITPC21 WITH (NOLOCK)
			--SELECT NUM_COR=contad00 FROM DCGUITPC21 WITH (NOLOCK)
			SET @NUM_CORRELATIVO = @CORRELATIVO + right('0000000'+ltrim(rtrim(@NUM_COR + 1)),(7))
		END
		IF @CORRELATIVO='065'
		BEGIN
			SELECT @NUM_COR=contad00 FROM DCGUITPB21 WITH (NOLOCK)
			--SELECT NUM_COR=contad00 FROM DCGUITPB21 WITH (NOLOCK)
			SET @NUM_CORRELATIVO = @CORRELATIVO + right('0000000'+ltrim(rtrim(@NUM_COR + 1)),(7))
		END
		
		IF @NUM_CORRELATIVO < @NUM_COR_ACT
		BEGIN
			SET @MENSAJE=CAST(@NUM_COR AS VARCHAR)
			SELECT @MENSAJE AS 'MENSAJE',right(@NUM_COR_ACT +1, 7)  as 'CorreActual'
			RETURN;
		END	
			
		SELECT @NUM_COR_ACT=MAX(nrogui19) FROM
		DRGUITPC20 WITH (NOLOCK)
		WHERE nrogui19 LIKE + '' + @CORRELATIVO + '%' 
			
		IF @NUM_CORRELATIVO < @NUM_COR_ACT
		BEGIN
			SET @MENSAJE=CAST(@NUM_COR AS VARCHAR)
			SELECT @MENSAJE AS 'MENSAJE',right(@NUM_COR_ACT +1, 7)  as 'CorreActual'
			RETURN;
		END					
	END

SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDACION_PESOS_CLIENTE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDACION_PESOS_CLIENTE] @NROTKT VARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DATO VARCHAR(250)
	DECLARE @RUC VARCHAR(11)

	SET @DATO = ''

	DECLARE @NROAUT VARCHAR(8)

	SELECT @NROAUT = nroaut14
	FROM DDTICKET18
	WHERE nrotkt18 = @NROTKT

	SELECT @RUC = LTRIM(RTRIM(codemc12))
	FROM Descarga..EDAUTING14
	WHERE nroaut14 = @NROAUT

	IF LTRIM(RTRIM(@RUC)) = '20100971772'
		OR LTRIM(RTRIM(@RUC)) = '20163901197'
		OR LTRIM(RTRIM(@RUC)) = '20159473148'
		OR LTRIM(RTRIM(@RUC)) = '20327397258'
		OR LTRIM(RTRIM(@RUC)) = '20380336384'
		OR LTRIM(RTRIM(@RUC)) = '20136165667'
		OR LTRIM(RTRIM(@RUC)) = '20502340531'
		OR LTRIM(RTRIM(@RUC)) = '20278966004'
		OR LTRIM(RTRIM(@RUC)) = '20504595863' --OR LTRIM(RTRIM(@RUC))='20257676910'    
	BEGIN
		SET @DATO = '1'
	END
	
	SET @DATO = '1'
	
	SELECT LTRIM(RTRIM(@DATO)) AS 'DATO'

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDACION_SERIE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDACION_SERIE] @NROSERIE VARCHAR(3)
	,@CORRELATIVO VARCHAR(7)
	,@OPCION VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET @CORRELATIVO = LTRIM(RTRIM(@CORRELATIVO))

	DECLARE @NEW_CORRELATIVO VARCHAR(7)
	DECLARE @GUI VARCHAR(12)
	DECLARE @MENSAJE VARCHAR(400)
	DECLARE @NOMBRE VARCHAR(50)

	SET @MENSAJE = ''

	IF @NROSERIE = '048'
	BEGIN
		SET @NOMBRE = 'Neptunia - Villegas'
	END

	IF @NROSERIE = '065'
	BEGIN
		SET @NOMBRE = 'Neptunia - Balanza_Terminal'
	END

	IF @NROSERIE = '073'
	BEGIN
		SET @NOMBRE = 'Neptunia - Balanza_Paramonga'
	END

	IF @NROSERIE = '012'
	BEGIN
		SET @NOMBRE = 'Neptunia - Ventanilla_Llenos'
	END

	IF @NROSERIE = '077'
	BEGIN
		SET @NOMBRE = 'Neptunia - Balanza_8'
	END

	IF @NROSERIE = '078'
	BEGIN
		SET @NOMBRE = 'Neptunia - Balanza_4'
	END
	
	IF @NROSERIE = '021'
	BEGIN
		SET @NOMBRE = 'Neptunia - Centro_Logistico'
	END

	IF EXISTS (
			SELECT *
			FROM DDGUITPC19 WITH (NOLOCK)
			WHERE nrogui19 LIKE @NROSERIE + @CORRELATIVO + '%'
			)
	BEGIN
		SELECT TOP 1 @GUI = nrogui19
		FROM DDGUITPC19 WITH (NOLOCK)
		WHERE nrogui19 LIKE @NROSERIE + @CORRELATIVO + '%'

		SELECT TOP 1 @NEW_CORRELATIVO = SUBSTRING(SUBSTRING(nrogui19, 4, 10), 2, 7) + 1
		FROM DDGUITPC19 WITH (NOLOCK)
		WHERE nrogui19 LIKE @NROSERIE + SUBSTRING(@CORRELATIVO, 1, 3) + '%'
		ORDER BY nrogui19 DESC

		IF @OPCION = '1'
		BEGIN
			SET @MENSAJE = 'El correlativo de la serie: ' + @NROSERIE + ' se encuentra incorrecto ya que cuenta con una GUIA (' + @GUI + '), Para continuar Actualizar el contador de la Guía de ' + @NOMBRE + ' al Nro: ' + LTRIM(RTRIM(@NEW_CORRELATIVO))
		END

		SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'

		RETURN;
	END

	IF @NROSERIE = '065' OR @NROSERIE = '021'
	BEGIN
		IF EXISTS (
				SELECT *
				FROM Terminal.dbo.DDGUICON73 WITH (NOLOCK)
				WHERE nrogui73 LIKE @NROSERIE + @CORRELATIVO + '%'
				)
		BEGIN
			SELECT TOP 1 @GUI = nrogui73
			FROM Terminal.dbo.DDGUICON73 WITH (NOLOCK)
			WHERE nrogui73 LIKE @NROSERIE + @CORRELATIVO + '%'

			SELECT TOP 1 @NEW_CORRELATIVO = SUBSTRING(SUBSTRING(nrogui73, 4, 10), 2, 7) + 1
			FROM Terminal.dbo.DDGUICON73 WITH (NOLOCK)
			WHERE nrogui73 LIKE @NROSERIE + SUBSTRING(@CORRELATIVO, 1, 3) + '%'
			ORDER BY nrogui73 DESC

			IF @OPCION = '1'
			BEGIN
				SET @MENSAJE = 'El correlativo de la serie: ' + @NROSERIE + ' se encuentra incorrecto ya que cuenta con una GUIA (' + @GUI + '), Para continuar Actualizar el contador de la Guía de ' + @NOMBRE + ' al Nro: ' + LTRIM(RTRIM(@NEW_CORRELATIVO))
			END

			SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'

			RETURN;
		END
	END

	SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VERIFCTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_VERIFCTR    Script Date: 08/09/2002 6:45:43 PM ******/
/****** Object:  Stored Procedure dbo.SP_VERIFCTR    Script Date: 02/09/2000 3:52:17 PM ******/
ALTER PROCEDURE [dbo].[SP_VERIFCTR]
/* ----------------------------------------------*/
/* RETORNA LOS CTRS PARECIDOS AL DIGITADO - JCHP */
/* ----------------------------------------------*/
@CTNR char(11),
@SNAVIA char(6)
AS
SELECT CODCON04,XX = DIFFERENCE(@CTNR, CODCON04) 
FROM DDCONTEN04 WHERE NAVVIA11 = @SNAVIA 
AND DIFFERENCE(@CTNR, CODCON04) = 4

GO
/****** Object:  StoredProcedure [dbo].[SP_VISUALIZAR_PWD_USER]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VISUALIZAR_PWD_USER]      
AS      
BEGIN      
 --|CALLAO   
 SELECT UPPER(codusu17) AS 'USUARIO'  
 FROM terminal.dbo.DDUSER_PERF_SIST WITH (NOLOCK)  
 WHERE perfil = 'VISUALIZACION PWD BALANZA'  
 AND tipo = 'A'  
 /*                             
 SELECT 'FRMILLA' AS 'USUARIO'        
 UNION      
 SELECT 'MARAMOS' AS 'USUARIO'        
 UNION        
 SELECT 'KAHARUYAMA' AS 'USUARIO'         
 UNION        
 SELECT 'RGUEVARA' AS 'USUARIO'         
 UNION        
 SELECT 'CABUSTAMANTE' AS 'USUARIO'      
 UNION    
 SELECT 'LUVEGA' AS 'USUARIO'    
 UNION    
 SELECT 'RGUIMAREY' AS 'USUARIO'    
 UNION    
 SELECT 'OSCORI' AS 'USUARIO'    
 UNION    
 SELECT 'JOTELLO' AS 'USUARIO'   
 */ 
  --UNION                                  
  --SELECT 'HEAQUINO' AS 'USUARIO'                                      
  --UNION                                    
  --SELECT 'GIVIDAL' AS 'USUARIO'                                     
  --UNION                                    
  --SELECT 'YVNAMOC' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'RAHUARACHI' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'JEDELCASTILLO' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'GEREYES' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'RVIRTOM' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'IVAGUIRRE' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'HEROJAS' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'BRBUSTOS' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'YOIGLESIAS' AS 'USUARIO'                                    
  --UNION                                    
  --SELECT 'VNAVARRO' AS 'USUARIO'                                   
  --UNION                                    
  --SELECT 'EDGARCIA' AS 'USUARIO'                                  
  --UNION                                    
  --SELECT 'ROVIRTO' AS 'USUARIO'                                  
  --UNION                                    
  --SELECT 'IVVERA' AS 'USUARIO'                                  
  --UNION                                    
  --SELECT 'RIPAREDES' AS 'USUARIO'                                  
  --UNION                                    
  --SELECT 'FCAMPOS' AS 'USUARIO'                                  
  --UNION                                    
  --SELECT 'GIACUNA' AS 'USUARIO'                          
  --UNION                                    
  --SELECT 'FELINARES' AS 'USUARIO'                                
  --UNION                          
  --SELECT 'GURODRIGUEZ' AS 'USUARIO'                    
  --UNION                          
  --SELECT 'JOTELLO' AS 'USUARIO'                     
  ----|VENTANILLA                                
  --UNION                                    
  --SELECT 'CEESPINOZA' AS 'USUARIO'                                 
  --UNION                                    
  --SELECT 'YOQUISPE' AS 'USUARIO'                                 
  --UNION                                    
  --SELECT 'JOCHIROQUE' AS 'USUARIO'                                 
  --UNION                                    
  --SELECT 'ROPACHAS' AS 'USUARIO'                               
  --UNION                              
  --SELECT 'CHVASQUEZN' AS 'USUARIO'                                 
  --UNION                             
  --SELECT 'JOGONZALESH' AS 'USUARIO'                               
  --UNION                    
  --SELECT 'RVIRTO' AS 'USUARIO'                      
  --UNION                    
  --SELECT 'HEBALDARRAGO' AS 'USUARIO'                     
  --UNION                    
  --SELECT 'GCALSIN' AS 'USUARIO'                     
  --UNION                    
  --SELECT 'RORIOS' AS 'USUARIO'                     
  --UNION                    
  --SELECT 'WABONIFACIO' AS 'USUARIO'                
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_VISUALIZAR_REIMP_USER]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VISUALIZAR_REIMP_USER]
@USUARIO VARCHAR(25)
AS
BEGIN
SET NOCOUNT ON;
	SET @USUARIO = LTRIM(RTRIM(@USUARIO))
	/*
	IF @USUARIO='frmilla'
	BEGIN
		SELECT '1' AS resultado, 'frmilla' as usuario
		--UNION
		--SELECT '1' AS resultado, 'ceespinoza' as usuario	
	END
	ELSE
	BEGIN
		SELECT '0' AS resultado, 'frmilla' as usuario
		union
		SELECT '0' AS resultado, 'ceespinoza' as usuario
	END
	*/
	SELECT '1' AS resultado, '' as usuario, '1' as mostrar
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Wmc_ConsultaBloqueoBooking]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Sp_Wmc_ConsultaBloqueoBooking]
@CodigoInternoBooking varchar(6)
as
--Begin
	/*select isnull( BloqueoWms13, '0') as BloqueoWms13 from edbookin13
	where genbkg13 = @CodigoInternoBooking*/

	select '0'
--End

GO
/****** Object:  StoredProcedure [dbo].[Sp_Wms_ConsultaBultos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Sp_Wms_ConsultaBultos]
@Nave varchar(20),
@Viaje varchar(20),
@Contenedor varchar(20),
@Booking varchar(20)
as
Begin
	select 
	cb_a.genbkg13 as CodigoBooking,
	cb_b.bookin13 as Booking,
	cb_a.codcon04 as Contenedor,
	cb_c.CODNAV08 + '/' + cb_c.NUMVIA11 as Nave_Viaje, -- Separadas por un '/', Nave/Viaje
	getdate() as FechaIngreso,
	isnull( cb_b.ruccli13, '') as Consolidador,
	cb_a.codemb06 as TipoBulto,
	dt.nrobul16 as CantidadBulto,
	isnull( cb_d.codemc12, '') as Embarcador,
	dt.pesop16 as Peso,
	dt.marcas16 as MarcaContramarca,
	isnull( dt.nrolpn18, '') as LPN,
	isnull( dt.idPO16, '') as PO,
	isnull( dt.style16, '') as Style,
	dt.longi116 as Largo,
	dt.longi216 as Ancho,
	dt.longi316 as Altura
	from edmarcas18 dt
	inner join edllenad16 cb_a on dt.nroaut14 = cb_a.nroaut14
	inner join edbookin13 cb_b on cb_b.genbkg13 = cb_a.genbkg13
	inner join ddcabman11 cb_c on cb_c.navvia11 = cb_a.navvia11
	inner join EDAUTING14 cb_d on cb_d.nroaut14 = cb_a.nroaut14
	where cb_c.CODNAV08 = @Nave
	and cb_c.NUMVIA11 = @Viaje
	and cb_a.codcon04 = @Contenedor
	and cb_b.bookin13 = @Booking
End

GO
/****** Object:  StoredProcedure [dbo].[spEventos_Expo_gwc]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================================                    
-- CREAMOS EL STORED PROCEDURE                    
--=================================================================================                    
ALTER PROCEDURE [dbo].[spEventos_Expo_gwc] (
	@SCODEVE AS CHAR(05)
	,@SCODLIN AS CHAR(3)
	,@SCODINT AS CHAR(06)
	,@SNROCTR AS CHAR(11)
	,@SFECREG AS CHAR(14)
	,@DPESCTR DECIMAL(12, 2)
	,@ITRM AS VARCHAR(06)
	,@SUBFUNCTION VARCHAR(50)
	,@OPTIONAL01 VARCHAR(50)
	,@OPTIONAL02 VARCHAR(50)
	,@OPTIONAL03 VARCHAR(50)
	,@OPTIONAL04 VARCHAR(50)
	,@CODIGORET INT OUTPUT
	,@RESULTADO VARCHAR(8000) OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IDREGISTRO BIGINT
	DECLARE @SCODTAM CHAR(02)
	DECLARE @SCODTIP CHAR(02)
	DECLARE @SNROBKG VARCHAR(25)
	DECLARE @SOBSERV VARCHAR(50)
	DECLARE @IVAL BIGINT
	DECLARE @STAMTIP VARCHAR(4)
	DECLARE @IBLQ INT
	DECLARE @NAVVIA CHAR(06)
	DECLARE @GENBKG CHAR(06)
	DECLARE @NRODOC CHAR(08)
	DECLARE @TIPODOC VARCHAR(10)
	DECLARE @BOOKINGBL VARCHAR(30)
	DECLARE @BOOKING_CPLT VARCHAR(25)
	DECLARE @SISTEMA VARCHAR(30)
	DECLARE @SP VARCHAR(50)
	DECLARE @NUMVIA VARCHAR(10)
	DECLARE @DESC_NAVE VARCHAR(40)
	DECLARE @DISCHARGE_PORT VARCHAR(10)
	DECLARE @FINAL_DESTINATION VARCHAR(10)
	DECLARE @INLANDDEPOT VARCHAR(06)
	DECLARE @CAMPO_PRECINTO VARCHAR(60)
	DECLARE @NADCAVALUE VARCHAR(06)
	DECLARE @ISOEQID VARCHAR(10)
	DECLARE @LOCALPUERTO VARCHAR(6)
	DECLARE @RANDOMNUMBER INT
	DECLARE @PUERTO VARCHAR(3)
	DECLARE @LOCAL VARCHAR(25)
	DECLARE @ETIQLOC VARCHAR(5)
	DECLARE @PLACA VARCHAR(10)
	DECLARE @NUMLLOYSISO VARCHAR(15)
	DECLARE @COD_NAVE VARCHAR(4)

	--SET @BOOKINGBL='' /* se obtiene luego */                       
	SET @CODIGORET = 0
	SET @RESULTADO = ''
	SET @SISTEMA = 'BALANZA EXPO'
	SET @SP = 'sp_Eventos_Expo_Envios'
	SET @iVal = 0
	SET @LOCALPUERTO = ''
	SET @ISOEQID = ''
	SET @NADCAVALUE = ''
	SET @CAMPO_PRECINTO = ''
	SET @INLANDDEPOT = ''
	SET @FINAL_DESTINATION = ''
	SET @DISCHARGE_PORT = ''
	SET @DESC_NAVE = ''
	SET @NUMVIA = ''
	SET @BOOKING_CPLT = ''
	SET @PUERTO = ''
	SET @NUMLLOYSISO = ''
	SET @COD_NAVE = ''

	IF (
			@ITRM = 'VIL'
			OR @ITRM = 'VEN'
			)
	BEGIN
		SET @ITRM = 'CO'
	END

	SET @RANDOMNUMBER = CONVERT(INT, RAND() * 10000)

	IF LEN(@SCODEVE) = 0
		OR @SCODEVE IS NULL
		OR (
			@SCODEVE != '0900'
			AND @SCODEVE != '1000'
			)
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CAMPO SCODEVE NO ES CORRECTO'

		RETURN
	END

	IF LEN(@ITRM) = 0
		OR @ITRM IS NULL
		OR (
			@ITRM != 'CO'
			AND @ITRM != 'PAI'
			)
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CAMPO ITRM NO ES CORRECTO'

		RETURN
	END

	--Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                     
	--values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                                      
	BEGIN TRY
		SELECT @iblq = count(*)
		FROM descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR
		WHERE contenedor = @sNroCtr
			AND estado = 'B'
	END TRY

	BEGIN CATCH
		SET @CODIGORET = 900
		SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
	END CATCH

	IF @iblq = 0
	BEGIN
		BEGIN TRY
			SELECT @iVal = count(codcon04)
			FROM EVENTOS_LINEAS(NOLOCK)
			WHERE navvia11 = @sCodInt
				AND codcon04 = @sNroCtr
				AND cod_evento = @sCodEve
				AND fec_evento >= dateadd(day, - 120, getdate())
		END TRY

		BEGIN CATCH
			SET @CODIGORET = 900
			SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
		END CATCH

		IF @iVal >= 0
		BEGIN
			--------- obtiene el navvia y genbkg --------------------------------                                                        
			SET @NAVVIA = ''
			SET @GENBKG = ''

			BEGIN TRY
				SELECT TOP 1 @NAVVIA = a.NAVVIA11
					,@GENBKG = a.genbkg13
					,@sNroBkg = CASE left(a.nrocon13, 2)
						WHEN 'BO'
							THEN ''
						ELSE a.nrocon13
						END
					,@BOOKINGBL = A.nrocon13
					,@sObserv = substring(a.nomemb13, 1, 50)
					,@BOOKING_CPLT = LTRIM(RTRIM(ISNULL(A.bkgcom13, '')))
				FROM descarga..edbookin13 a(NOLOCK)
					,descarga..erconasi17 b(NOLOCK)
				WHERE a.navvia11 = @sCodInt
					AND a.genbkg13 = b.genbkg13
					AND b.codcon04 = @sNroCtr
				ORDER BY a.navvia11 DESC
					,a.genbkg13 DESC
			END TRY

			BEGIN CATCH
				SET @CODIGORET = 900
				SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
			END CATCH

			DECLARE @EMB VARCHAR(11)

			BEGIN TRY
				SELECT TOP 1 @EMB = a.codemc12
				FROM descarga..edbookin13 a(NOLOCK)
					,descarga..erconasi17 b(NOLOCK)
				WHERE a.navvia11 = @sCodInt
					AND a.genbkg13 = b.genbkg13
					AND b.codcon04 = @sNroCtr
				ORDER BY a.navvia11 DESC
					,a.genbkg13 DESC
			END TRY

			BEGIN CATCH
				SET @CODIGORET = 900
				SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
			END CATCH

			--|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD                      
			IF LTRIM(RTRIM(@EMB)) <> '20373860736'
				AND LTRIM(RTRIM(@sCodLin)) = 'HSD'
			BEGIN
				RETURN;
			END

			IF NOT (
					LEN(@NAVVIA) > 0
					AND LEN(@GENBKG) > 0
					)
			BEGIN
				BEGIN TRY
					SELECT @NAVVIA = NAVVIA11
						,@GENBKG = genbkg13
						,@BOOKINGBL = nrocon13
						,@BOOKING_CPLT = LTRIM(RTRIM(ISNULL(bkgcom13, '')))
					FROM descarga..edbookin13(NOLOCK)
					WHERE genbkg13 = @sCodInt
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH
			END

			---------------------------------------------------------------------                                                   
			--print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                           
			IF len(@sNroBkg) > 0
			BEGIN
				BEGIN TRY
					SELECT @SCODTAM = codtam09
						,@SCODTIP = codtip05
					FROM edconten04(NOLOCK)
					WHERE codcon04 = @sNroCtr
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				SET @sTamTip = @sCodTam + @sCodTip

				IF @sCodEve = '0900'
				BEGIN
					BEGIN TRY
						SELECT @NRODOC = nroaut14
						FROM edllenad16(NOLOCK)
						WHERE codcon04 = @sNroCtr
							AND genbkg13 = @GENBKG
							AND navvia11 = @NAVVIA

						SELECT @PLACA = nropla18
						FROM DDTICKET18(NOLOCK)
						WHERE nroaut14 = @NRODOC
					END TRY

					BEGIN CATCH
						SET @CODIGORET = 900
						SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
					END CATCH

					SET @TIPODOC = 'AUT'
				END
				ELSE
				BEGIN
					SET @TIPODOC = 'TKT'

					BEGIN TRY
						SELECT @NRODOC = g.nrotkt18
						FROM DRCTRTMC90 a(NOLOCK)
						INNER JOIN edllenad16 b(NOLOCK) ON (
								a.navvia11 = b.navvia11
								AND a.codcon04 = b.codcon04
								)
						INNER JOIN edbookin13 e(NOLOCK) ON (
								b.genbkg13 = e.genbkg13
								AND b.navvia11 = e.navvia11
								)
						INNER JOIN ddticket18 g(NOLOCK) ON (
								a.nrotkt28 = g.nrotkt18
								AND a.navvia11 = g.navvia11
								)
						WHERE b.genbkg13 = @GENBKG
							AND b.navvia11 = @NAVVIA
							AND a.codcon04 = @sNroCtr

						SELECT @PLACA = nropla18
						FROM DDTICKET18(NOLOCK)
						WHERE nrotkt18 = @NRODOC
					END TRY

					BEGIN CATCH
						SET @CODIGORET = 900
						SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
					END CATCH
				END

				--********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                                 
				--select top 10 * from edllenad16                        
				DECLARE @sFechaCorregida DATETIME

				IF @sCodLin = 'HSD'
					AND @sCodEve = '0900'
				BEGIN
					SET @sFechaCorregida = (
							SELECT MAX(feclln16)
							FROM edllenad16
							WHERE codcon04 = @sNroCtr
								AND navvia11 = @NAVVIA
								AND codemb06 = 'CTR'
							) -- and genbkg13=@GENBKG)                    

					IF LEN(ISNULL(CONVERT(VARCHAR, @sFechaCorregida), '')) > 0
					BEGIN
						SET @sFecReg = CONVERT(VARCHAR(8), @sFechaCorregida, 112) + ' ' + LEFT(CONVERT(VARCHAR, @sFechaCorregida, 108), 5)
					END
				END

				-- OBTENEMOS @DESC_NAVE                    
				BEGIN TRY
					SELECT @NUMVIA = ltrim(rtrim(a.numvia11))
						,@DESC_NAVE = ltrim(rtrim(b.desnav08))
						,@PUERTO = ltrim(rtrim(ptoori11))
						,@COD_NAVE = a.codnav08
					FROM DDCABMAN11 a
					INNER JOIN DQNAVIER08 b ON a.codnav08 = b.codnav08
					WHERE navvia11 = @NAVVIA

					IF LTRIM(RTRIM(@PUERTO)) = 'E'
					BEGIN
						SET @PUERTO = 'APM'
					END

					IF LTRIM(RTRIM(@PUERTO)) = 'D'
					BEGIN
						SET @PUERTO = 'DPW'
					END
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				-- OBTENEMOS @DISCHARGE_PORT                    
				BEGIN TRY
					SELECT @DISCHARGE_PORT = b.codsol02
					FROM descarga..EDBOOKIN13 a
					INNER JOIN descarga..DQPUERTO02 b ON a.codpue02 = b.codpue02
					WHERE a.genbkg13 = @GENBKG
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				IF (@DISCHARGE_PORT IS NULL)
				BEGIN
					IF (@ITRM = 'CO')
					BEGIN
						SET @DISCHARGE_PORT = 'PECLL'
					END

					IF (@ITRM = 'PAI')
					BEGIN
						SET @DISCHARGE_PORT = 'PEPAI'
					END
				END

				-- OBTENEMOS @FINAL_DESTINATION                    
				BEGIN TRY
					SELECT @FINAL_DESTINATION = b.codsol02
					FROM descarga..EDBOOKIN13 a
					INNER JOIN descarga..DQPUERTO02 b ON a.codpue13 = b.codpue02
					WHERE a.genbkg13 = @GENBKG
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				IF (@FINAL_DESTINATION IS NULL)
				BEGIN
					IF (@ITRM = 'CO')
					BEGIN
						SET @FINAL_DESTINATION = 'PECLL'
					END

					IF (@ITRM = 'PAI')
					BEGIN
						SET @FINAL_DESTINATION = 'PEPAI'
					END
				END

				--OBTENEMOS @INLANDDEPOT                    
				IF (@ITRM = 'CO')
				BEGIN
					SET @INLANDDEPOT = 'NEC'
					SET @NADCAVALUE = 'NEC'
					SET @LOCALPUERTO = 'CLL'
				END

				IF (@ITRM = 'PAI')
				BEGIN
					SET @INLANDDEPOT = 'NEP'
					SET @NADCAVALUE = 'NEP'
					SET @LOCALPUERTO = 'PAI'
				END

				-- OBTENEMOS @CAMPO_PRECINTO                    
				BEGIN TRY
					SELECT @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))
					FROM descarga..ERCONASI17
					WHERE genbkg13 = @GENBKG
						AND codcon04 = @sNroCtr
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				----------------------------------------------------                   
				--OBTENER @ISOEQID CODIGO ISO CONTENEDOR                    
				----------------------------------------------------                    
				BEGIN TRY
					SELECT @SCODTAM = codtam09
						,@SCODTIP = codtip05
					FROM edconten04(NOLOCK)
					WHERE codcon04 = @sNroCtr

					SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))
					FROM spbmcaracteristicascontenedor
					WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP
						AND Tamanyo = @SCODTAM
				END TRY

				BEGIN CATCH
					SET @CODIGORET = 900
					SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
				END CATCH

				----------------------------------------------------                    
				IF LEN(@sFecReg) > 7
					AND LEN(@sNroCtr) = 11
					AND LEN(@sCodEve) > 2
					AND LEN(@sCodLin) > 1
				BEGIN
					IF SUBSTRING(@BOOKING_CPLT, 1, 6) <> '087LIM'
						AND @SCODLIN = 'MSC'
					BEGIN
						SET @BOOKING_CPLT = '087LIM' + '' + LTRIM(RTRIM(@BOOKING_CPLT))
					END

					--|ETIQUETA UNH - LOCAL        
					IF @SCODLIN = 'PIL'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @LOCAL = 'PECLL32'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @LOCAL = 'PEPAI31'
						END
					END

					IF @SCODLIN = 'CMA'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @LOCAL = 'LIMATELEDI2'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @LOCAL = 'LIMATELEDI7'
						END
					END

					IF @SCODLIN = 'MSC'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @LOCAL = 'LIMATELEDI2'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @LOCAL = 'LIMATELEDI2'
						END
					END
					
					IF @SCODLIN = 'ONE'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @LOCAL = 'PECLLNP'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @LOCAL = 'PEPAINP'
						END
					END

					--|       
					--|FORMATO DE FECHA YYYYMMDDHHMMSS        
					SET @SFECREG = LTRIM(RTRIM(@SFECREG))

					DECLARE @FECHAALTERNA VARCHAR(14)
					DECLARE @FECHA_HEADER VARCHAR(13)

					SET @FECHAALTERNA = CONVERT(VARCHAR, GETDATE(), 112) + '' + replace((CONVERT(VARCHAR(8), GETDATE(), 114)), ':', '')
					SET @FECHA_HEADER = RIGHT(CONVERT(VARCHAR(8), GETDATE(), 112), 6) + ':' + replace((CONVERT(VARCHAR(5), GETDATE(), 114)), ':', '')

					--|        
					--|ETIQUETA TDT        
					DECLARE @ETIQTDT VARCHAR(4)

					IF @SCODLIN = 'PIL'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @ETIQTDT = 'PILN'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @ETIQTDT = 'PILN'
						END
					END

					IF @SCODLIN = 'CMA'
						OR @SCODLIN = 'MSC'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @ETIQTDT = @SCODLIN
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @ETIQTDT = @SCODLIN
						END
					END

					--|        
					--|ETIQUETA LOC+165        
					IF @SCODLIN = 'CMA'
						OR @SCODLIN = 'MSC'
						OR @SCODLIN = 'PIL'
						OR @SCODLIN = 'SBM'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @ETIQLOC = 'PECLL'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @ETIQLOC = 'PEPAI'
						END
					END

					--|        
					--|ETIQUETA NAD+MS        
					DECLARE @ETIQNAD VARCHAR(10)

					IF @SCODLIN = 'CMA'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @ETIQNAD = 'PECLLMNPV'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @ETIQNAD = 'PEPAIMNPV'
						END
					END

					IF @SCODLIN = 'PIL'
						OR @SCODLIN = 'MSC'
					BEGIN
						IF @ITRM = 'CO'
						BEGIN
							SET @ETIQNAD = 'PECLL'
						END

						IF @ITRM = 'PAI'
						BEGIN
							SET @ETIQNAD = 'PEPAI'
						END
					END

					-- OBTENEMOS EL CODIGO LOYYS DE LA NAVE    
					SELECT @NUMLLOYSISO = LTRIM(RTRIM(NumLloydsISO))
					FROM CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spbmbuque
					WHERE LTRIM(RTRIM(id)) = @COD_NAVE

					--|        
					/* ------------------------------------------------------------ */
					/*                      RESULTADO GWC                           */
					/* ------------------------------------------------------------ */
					SET @resultado = @resultado + 'LOCAL=' + LTRIM(RTRIM(ISNULL(@LOCAL, ''))) + ';'
					SET @resultado = @resultado + 'ALEATORIO=' + RIGHT('0000000' + CONVERT(VARCHAR, @RANDOMNUMBER), 7) + ';'
					SET @resultado = @resultado + 'OPERA=9' + ';'
					--SET @resultado = @resultado + 'COD_VIAJE=' + @NAVVIA +';'                    
					SET @resultado = @resultado + 'COD_VIAJE=' + LTRIM(RTRIM(ISNULL(@NUMVIA, ''))) + ';'
					SET @resultado = @resultado + 'DESC_NAVE=' + LTRIM(RTRIM(ISNULL(@DESC_NAVE, ''))) + ';'
					SET @resultado = @resultado + 'LOCALPUERTO=' + LTRIM(RTRIM(ISNULL(@LOCALPUERTO, ''))) + ';'
					SET @resultado = @resultado + 'CONDCONT=5' + ';'
					SET @resultado = @resultado + 'BOOKING=' + LTRIM(RTRIM(ISNULL(@BOOKING_CPLT, ''))) + ';'
					SET @resultado = @resultado + 'DISCHARGE_PORT=' + LTRIM(RTRIM(ISNULL(@DISCHARGE_PORT, ''))) + ';'
					SET @resultado = @resultado + 'FINAL_DESTINATION=' + LTRIM(RTRIM(ISNULL(@FINAL_DESTINATION, ''))) + ';'
					SET @resultado = @resultado + 'INLANDDEPOT=' + ISNULL(@INLANDDEPOT, '') + ';'
					SET @resultado = @resultado + 'CAMPO_PRECINTO=' + LTRIM(RTRIM(ISNULL(@CAMPO_PRECINTO, ''))) + ';'
					SET @resultado = @resultado + 'PESO_CRT=' + CONVERT(VARCHAR(15), @dPesCtr) + ';'
					SET @resultado = @resultado + 'NADCAVALUE=' + ISNULL(@NADCAVALUE, '') + ';'
					SET @resultado = @resultado + 'ISOEQID=' + ISNULL(@ISOEQID, '') + ';'
					SET @resultado = @resultado + 'LOC99PUERTO=' + ISNULL(@PUERTO, '') + ';'
					SET @resultado = @resultado + 'LOC100PUERTO=' + ISNULL(@PUERTO, '') + ';'
					SET @resultado = @resultado + 'NROTICKET=' + ISNULL(@NRODOC, '') + ';'
					SET @RESULTADO = @RESULTADO + 'FECHAALTERNA=' + LTRIM(RTRIM(ISNULL(@FECHAALTERNA, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'DATOCTR=' + LTRIM(RTRIM(ISNULL(@SNROCTR, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'DATOLINEA=' + LTRIM(RTRIM(ISNULL(@SCODLIN, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'ETIQTDT=' + LTRIM(RTRIM(ISNULL(@ETIQTDT, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'ETIQLOC=' + LTRIM(RTRIM(ISNULL(@ETIQLOC, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'ETIQNAD=' + LTRIM(RTRIM(ISNULL(@ETIQNAD, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'FECHA_HEADER=' + LTRIM(RTRIM(ISNULL(@FECHA_HEADER, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'PLACA=' + LTRIM(RTRIM(ISNULL(@PLACA, ''))) + ';'
					SET @RESULTADO = @RESULTADO + 'NUMLLOYSISO=' + ISNULL(@NUMLLOYSISO, '') + ';'
				END
			END
			ELSE
			BEGIN
				SET @CODIGORET = 999
				SET @RESULTADO = 'NO EXISTE BOOKING PARA LOS DATOS INGRESADOS'

				RETURN
			END
		END
	END
	ELSE
	BEGIN
		SET @CODIGORET = 999
		SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'
	END

	SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[spEventos_Expo_gwc_tmp]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spEventos_Expo_gwc_tmp] (
   @SCODEVE AS CHAR(05),
   @SCODLIN AS CHAR(3),
   @SCODINT AS CHAR(06),
   @SNROCTR AS CHAR(11),
   @SFECREG AS CHAR(14),
   @DPESCTR DECIMAL(12, 2),
   @ITRM AS VARCHAR(06),
   @SUBFUNCTION VARCHAR(50),
   @OPTIONAL01 VARCHAR(50),
   @OPTIONAL02 VARCHAR(50),
   @OPTIONAL03 VARCHAR(50),
   @OPTIONAL04 VARCHAR(50),
   @CODIGORET INT OUTPUT,
   @RESULTADO VARCHAR(8000) OUTPUT
   )
AS
BEGIN
   SET NOCOUNT ON

   DECLARE @IDREGISTRO BIGINT
   DECLARE @SCODTAM CHAR(02)
   DECLARE @SCODTIP CHAR(02)
   DECLARE @SNROBKG VARCHAR(25)
   DECLARE @SOBSERV VARCHAR(50)
   DECLARE @IVAL BIGINT
   DECLARE @STAMTIP VARCHAR(4)
   DECLARE @IBLQ INT
   DECLARE @NAVVIA CHAR(06)
   DECLARE @GENBKG CHAR(06)
   DECLARE @NRODOC CHAR(08)
   DECLARE @TIPODOC VARCHAR(10)
   DECLARE @BOOKINGBL VARCHAR(30)
   DECLARE @BOOKING_CPLT VARCHAR(25)
   DECLARE @SISTEMA VARCHAR(30)
   DECLARE @SP VARCHAR(50)
   DECLARE @NUMVIA VARCHAR(10)
   DECLARE @DESC_NAVE VARCHAR(40)
   DECLARE @DISCHARGE_PORT VARCHAR(10)
   DECLARE @FINAL_DESTINATION VARCHAR(10)
   DECLARE @INLANDDEPOT VARCHAR(06)
   DECLARE @CAMPO_PRECINTO VARCHAR(60)
   DECLARE @NADCAVALUE VARCHAR(06)
   DECLARE @ISOEQID VARCHAR(10)
   DECLARE @LOCALPUERTO VARCHAR(6)
   DECLARE @RANDOMNUMBER INT
   DECLARE @PUERTO VARCHAR(3)
   DECLARE @LOCAL VARCHAR(25)
   DECLARE @ETIQLOC VARCHAR(5)
   DECLARE @PLACA VARCHAR(10)
   DECLARE @NUMLLOYSISO VARCHAR(15)
   DECLARE @COD_NAVE VARCHAR(4)

   --SET @BOOKINGBL='' /* se obtiene luego */                       
   SET @CODIGORET = 0
   SET @RESULTADO = ''
   SET @SISTEMA = 'BALANZA EXPO'
   SET @SP = 'sp_Eventos_Expo_Envios'
   SET @iVal = 0
   SET @LOCALPUERTO = ''
   SET @ISOEQID = ''
   SET @NADCAVALUE = ''
   SET @CAMPO_PRECINTO = ''
   SET @INLANDDEPOT = ''
   SET @FINAL_DESTINATION = ''
   SET @DISCHARGE_PORT = ''
   SET @DESC_NAVE = ''
   SET @NUMVIA = ''
   SET @BOOKING_CPLT = ''
   SET @PUERTO = ''
   SET @NUMLLOYSISO = ''
   SET @COD_NAVE = ''

   IF (
         @ITRM = 'VIL'
         OR @ITRM = 'VEN'
         )
   BEGIN
      SET @ITRM = 'CO'
   END

   SET @RANDOMNUMBER = CONVERT(INT, RAND() * 10000)

   IF LEN(@SCODEVE) = 0
      OR @SCODEVE IS NULL
      OR (
         @SCODEVE != '0900'
         AND @SCODEVE != '1000'
         )
   BEGIN
      SET @CODIGORET = 999
      SET @RESULTADO = 'EL CAMPO SCODEVE NO ES CORRECTO'

      RETURN
   END

   IF LEN(@ITRM) = 0
      OR @ITRM IS NULL
      OR (
         @ITRM != 'CO'
         AND @ITRM != 'PAI'
         )
   BEGIN
      SET @CODIGORET = 999
      SET @RESULTADO = 'EL CAMPO ITRM NO ES CORRECTO'

      RETURN
   END

   --Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                     
   --values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                                      
   BEGIN TRY
      SELECT @iblq = count(*)
      FROM descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR
      WHERE contenedor = @sNroCtr
         AND estado = 'B'
   END TRY

   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   IF @iblq = 0
   BEGIN
      BEGIN TRY
         SELECT @iVal = count(codcon04)
         FROM EVENTOS_LINEAS(NOLOCK)
         WHERE navvia11 = @sCodInt
            AND codcon04 = @sNroCtr
            AND cod_evento = @sCodEve
            AND fec_evento >= dateadd(day, - 120, getdate())
      END TRY

      BEGIN CATCH
         SET @CODIGORET = 900
         SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
      END CATCH
      
      IF @iVal >= 0
      BEGIN
         --------- obtiene el navvia y genbkg --------------------------------                                                        
         SET @NAVVIA = ''
         SET @GENBKG = ''

         BEGIN TRY
            SELECT TOP 1 @NAVVIA = a.NAVVIA11,
               @GENBKG = a.genbkg13,
               @sNroBkg = CASE left(a.nrocon13, 2)
                  WHEN 'BO'
                     THEN ''
                  ELSE a.nrocon13
                  END,
               @BOOKINGBL = A.nrocon13,
               @sObserv = substring(a.nomemb13, 1, 50),
               @BOOKING_CPLT = LTRIM(RTRIM(ISNULL(A.bkgcom13, '')))
            FROM descarga..edbookin13 a(NOLOCK),
               descarga..erconasi17 b(NOLOCK)
            WHERE a.navvia11 = @sCodInt
               AND a.genbkg13 = b.genbkg13
               AND b.codcon04 = @sNroCtr
            ORDER BY a.navvia11 DESC,
               a.genbkg13 DESC
         END TRY

         BEGIN CATCH
            SET @CODIGORET = 900
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
         END CATCH

         DECLARE @EMB VARCHAR(11)

         BEGIN TRY
            SELECT TOP 1 @EMB = a.codemc12
            FROM descarga..edbookin13 a(NOLOCK),
               descarga..erconasi17 b(NOLOCK)
            WHERE a.navvia11 = @sCodInt
               AND a.genbkg13 = b.genbkg13
               AND b.codcon04 = @sNroCtr
            ORDER BY a.navvia11 DESC,
               a.genbkg13 DESC
         END TRY

         BEGIN CATCH
            SET @CODIGORET = 900
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
         END CATCH

         --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD                      
         IF LTRIM(RTRIM(@EMB)) <> '20373860736'
            AND LTRIM(RTRIM(@sCodLin)) = 'HSD'
         BEGIN
            RETURN;
         END

         IF NOT (
               LEN(@NAVVIA) > 0
               AND LEN(@GENBKG) > 0
               )
         BEGIN
            BEGIN TRY
               SELECT @NAVVIA = NAVVIA11,
                  @GENBKG = genbkg13,
                  @BOOKINGBL = nrocon13,
                  @BOOKING_CPLT = LTRIM(RTRIM(ISNULL(bkgcom13, '')))
               FROM descarga..edbookin13(NOLOCK)
               WHERE genbkg13 = @sCodInt
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
         END

         ---------------------------------------------------------------------                                                   
         --print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                           
         IF len(@sNroBkg) > 0
         BEGIN
            BEGIN TRY
               SELECT @SCODTAM = codtam09,
                  @SCODTIP = codtip05
               FROM edconten04(NOLOCK)
               WHERE codcon04 = @sNroCtr
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH

            SET @sTamTip = @sCodTam + @sCodTip

            IF @sCodEve = '0900'
            BEGIN
               BEGIN TRY
                  SELECT @NRODOC = nroaut14
                  FROM edllenad16(NOLOCK)
                  WHERE codcon04 = @sNroCtr
                     AND genbkg13 = @GENBKG
                     AND navvia11 = @NAVVIA

                  SELECT @PLACA = nropla18
                  FROM DDTICKET18(NOLOCK)
                  WHERE nroaut14 = @NRODOC
               END TRY

               BEGIN CATCH
                  SET @CODIGORET = 900
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
               END CATCH

               SET @TIPODOC = 'AUT'
            END
            ELSE
            BEGIN
               SET @TIPODOC = 'TKT'

               BEGIN TRY
                  SELECT @NRODOC = g.nrotkt18
                  FROM DRCTRTMC90 a(NOLOCK)
                  INNER JOIN edllenad16 b(NOLOCK) ON (
                        a.navvia11 = b.navvia11
                        AND a.codcon04 = b.codcon04
                        )
                  INNER JOIN edbookin13 e(NOLOCK) ON (
                        b.genbkg13 = e.genbkg13
                        AND b.navvia11 = e.navvia11
                        )
                  INNER JOIN ddticket18 g(NOLOCK) ON (
                        a.nrotkt28 = g.nrotkt18
                        AND a.navvia11 = g.navvia11
                        )
                  WHERE b.genbkg13 = @GENBKG
                     AND b.navvia11 = @NAVVIA
                     AND a.codcon04 = @sNroCtr

                  SELECT @PLACA = nropla18
                  FROM DDTICKET18(NOLOCK)
                  WHERE nrotkt18 = @NRODOC
               END TRY

               BEGIN CATCH
                  SET @CODIGORET = 900
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
               END CATCH
            END

            --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD                                 
            --select top 10 * from edllenad16                        
            DECLARE @sFechaCorregida DATETIME

            IF @sCodLin = 'HSD'
               AND @sCodEve = '0900'
            BEGIN
               SET @sFechaCorregida = (
                     SELECT MAX(feclln16)
                     FROM edllenad16
                     WHERE codcon04 = @sNroCtr
                        AND navvia11 = @NAVVIA
                        AND codemb06 = 'CTR'
                     ) -- and genbkg13=@GENBKG)                    

               IF LEN(ISNULL(CONVERT(VARCHAR, @sFechaCorregida), '')) > 0
               BEGIN
                  SET @sFecReg = CONVERT(VARCHAR(8), @sFechaCorregida, 112) + ' ' + LEFT(CONVERT(VARCHAR, @sFechaCorregida, 108), 5)
               END
            END

            -- OBTENEMOS @DESC_NAVE                    
            BEGIN TRY
               SELECT @NUMVIA = ltrim(rtrim(a.numvia11)),
                  @DESC_NAVE = ltrim(rtrim(b.desnav08)),
                  @PUERTO = ltrim(rtrim(ptoori11)),
                  @COD_NAVE = a.codnav08
               FROM DDCABMAN11 a
               INNER JOIN DQNAVIER08 b ON a.codnav08 = b.codnav08
               WHERE navvia11 = @NAVVIA

               IF LTRIM(RTRIM(@PUERTO)) = 'E'
               BEGIN
                  SET @PUERTO = 'APM'
               END

               IF LTRIM(RTRIM(@PUERTO)) = 'D'
               BEGIN
                  SET @PUERTO = 'DPW'
               END
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
               
            -- OBTENEMOS @DISCHARGE_PORT                    
            BEGIN TRY
               SELECT @DISCHARGE_PORT = b.codsol02
               FROM descarga..EDBOOKIN13 a
               INNER JOIN descarga..DQPUERTO02 b ON a.codpue02 = b.codpue02
               WHERE a.genbkg13 = @GENBKG
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH

            IF (@DISCHARGE_PORT IS NULL)
            BEGIN
               IF (@ITRM = 'CO')
               BEGIN
                  SET @DISCHARGE_PORT = 'PECLL'
               END

               IF (@ITRM = 'PAI')
               BEGIN
                  SET @DISCHARGE_PORT = 'PEPAI'
               END
            END

            -- OBTENEMOS @FINAL_DESTINATION                    
            BEGIN TRY
               SELECT @FINAL_DESTINATION = b.codsol02
               FROM descarga..EDBOOKIN13 a
               INNER JOIN descarga..DQPUERTO02 b ON a.codpue13 = b.codpue02
               WHERE a.genbkg13 = @GENBKG
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH

            IF (@FINAL_DESTINATION IS NULL)
            BEGIN
               IF (@ITRM = 'CO')
               BEGIN
                  SET @FINAL_DESTINATION = 'PECLL'
               END

               IF (@ITRM = 'PAI')
               BEGIN
                  SET @FINAL_DESTINATION = 'PEPAI'
               END
            END

            --OBTENEMOS @INLANDDEPOT                    
            IF (@ITRM = 'CO')
            BEGIN
               SET @INLANDDEPOT = 'NEC'
               SET @NADCAVALUE = 'NEC'
               SET @LOCALPUERTO = 'CLL'
            END

            IF (@ITRM = 'PAI')
            BEGIN
               SET @INLANDDEPOT = 'NEP'
               SET @NADCAVALUE = 'NEP'
               SET @LOCALPUERTO = 'PAI'
            END

            -- OBTENEMOS @CAMPO_PRECINTO                    
            BEGIN TRY
               SELECT @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))
               FROM descarga..ERCONASI17
               WHERE genbkg13 = @GENBKG
                  AND codcon04 = @sNroCtr
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH

            ----------------------------------------------------                   
            --OBTENER @ISOEQID CODIGO ISO CONTENEDOR                    
            ----------------------------------------------------                    
            BEGIN TRY
               SELECT @SCODTAM = codtam09,
                  @SCODTIP = codtip05
               FROM edconten04(NOLOCK)
               WHERE codcon04 = @sNroCtr

               SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))
               FROM spbmcaracteristicascontenedor
               WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP
                  AND Tamanyo = @SCODTAM
            END TRY

            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10), error_number())) + ' - MESSAGE :' + error_message()
            END CATCH

            ----------------------------------------------------                    
            IF LEN(@sFecReg) > 7
               AND LEN(@sNroCtr) = 11
               AND LEN(@sCodEve) > 2
               AND LEN(@sCodLin) > 1
            BEGIN
               IF SUBSTRING(@BOOKING_CPLT, 1, 6) <> '087LIM'
                  AND @SCODLIN = 'MSC'
               BEGIN
                  SET @BOOKING_CPLT = '087LIM' + '' + LTRIM(RTRIM(@BOOKING_CPLT))
               END

               --|ETIQUETA UNH - LOCAL        
               IF @SCODLIN = 'PIL'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @LOCAL = 'PECLL32'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @LOCAL = 'PEPAI31'
                  END
               END

               IF @SCODLIN = 'CMA' OR @SCODLIN = 'HSD'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @LOCAL = 'LIMATELEDI2'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @LOCAL = 'LIMATELEDI7'
                  END
               END

               IF @SCODLIN = 'MSC'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @LOCAL = 'LIMATELEDI2'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @LOCAL = 'LIMATELEDI2'
                  END
               END

               --|       
               --|FORMATO DE FECHA YYYYMMDDHHMMSS        
               SET @SFECREG = LTRIM(RTRIM(@SFECREG))

               DECLARE @FECHAALTERNA VARCHAR(14)
               DECLARE @FECHA_HEADER VARCHAR(13)

               SET @FECHAALTERNA = CONVERT(VARCHAR, GETDATE(), 112) + '' + replace((CONVERT(VARCHAR(8), GETDATE(), 114)), ':', '')
               SET @FECHA_HEADER = RIGHT(CONVERT(VARCHAR(8), GETDATE(), 112), 6) + ':' + replace((CONVERT(VARCHAR(5), GETDATE(), 114)), ':', '')

               --|        
               --|ETIQUETA TDT        
               DECLARE @ETIQTDT VARCHAR(4)

               IF @SCODLIN = 'PIL'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @ETIQTDT = 'PILN'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @ETIQTDT = 'PILN'
                  END
               END

               IF @SCODLIN = 'CMA'
                  OR @SCODLIN = 'MSC'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @ETIQTDT = @SCODLIN
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @ETIQTDT = @SCODLIN
                  END
               END

               --|        
               --|ETIQUETA LOC+165        
               IF @SCODLIN = 'CMA'
                  OR @SCODLIN = 'MSC'
                  OR @SCODLIN = 'PIL'
                  OR @SCODLIN = 'SBM'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @ETIQLOC = 'PECLL'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @ETIQLOC = 'PEPAI'
                  END
               END

               --|        
               --|ETIQUETA NAD+MS        
               DECLARE @ETIQNAD VARCHAR(10)

               IF @SCODLIN = 'CMA'
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @ETIQNAD = 'PECLLMNPV'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @ETIQNAD = 'PEPAIMNPV'
                  END
               END

               IF @SCODLIN = 'PIL'
                  OR @SCODLIN = 'MSC'
                  OR @SCODLIN = 'HSD'  --FMCR
               BEGIN
                  IF @ITRM = 'CO'
                  BEGIN
                     SET @ETIQNAD = 'PECLL'
                  END

                  IF @ITRM = 'PAI'
                  BEGIN
                     SET @ETIQNAD = 'PEPAI'
                  END
               END

               -- OBTENEMOS EL CODIGO LOYYS DE LA NAVE    
               SELECT @NUMLLOYSISO = LTRIM(RTRIM(NumLloydsISO))
               FROM CALW8BDSOLPORT.SpOperations_Paralelo2.DBO.spbmbuque
               WHERE LTRIM(RTRIM(id)) = @COD_NAVE

               --|        
               /* ------------------------------------------------------------ */
               /*                      RESULTADO GWC                           */
               /* ------------------------------------------------------------ */
               SET @resultado = @resultado + 'LOCAL=' + LTRIM(RTRIM(ISNULL(@LOCAL, ''))) + ';'
               SET @resultado = @resultado + 'ALEATORIO=' + RIGHT('0000000' + CONVERT(VARCHAR, @RANDOMNUMBER), 7) + ';'
               SET @resultado = @resultado + 'OPERA=9' + ';'
               --SET @resultado = @resultado + 'COD_VIAJE=' + @NAVVIA +';'                    
               SET @resultado = @resultado + 'COD_VIAJE=' + LTRIM(RTRIM(ISNULL(@NUMVIA, ''))) + ';'
               SET @resultado = @resultado + 'DESC_NAVE=' + LTRIM(RTRIM(ISNULL(@DESC_NAVE, ''))) + ';'
               SET @resultado = @resultado + 'LOCALPUERTO=' + LTRIM(RTRIM(ISNULL(@LOCALPUERTO, ''))) + ';'
               SET @resultado = @resultado + 'CONDCONT=5' + ';'
               SET @resultado = @resultado + 'BOOKING=' + LTRIM(RTRIM(ISNULL(@BOOKING_CPLT, ''))) + ';'
               SET @resultado = @resultado + 'DISCHARGE_PORT=' + LTRIM(RTRIM(ISNULL(@DISCHARGE_PORT, ''))) + ';'
               SET @resultado = @resultado + 'FINAL_DESTINATION=' + LTRIM(RTRIM(ISNULL(@FINAL_DESTINATION, ''))) + ';'
               SET @resultado = @resultado + 'INLANDDEPOT=' + ISNULL(@INLANDDEPOT, '') + ';'
               SET @resultado = @resultado + 'CAMPO_PRECINTO=' + LTRIM(RTRIM(ISNULL(@CAMPO_PRECINTO, ''))) + ';'
               SET @resultado = @resultado + 'PESO_CRT=' + CONVERT(VARCHAR(15), @dPesCtr) + ';'
               SET @resultado = @resultado + 'NADCAVALUE=' + ISNULL(@NADCAVALUE, '') + ';'
               SET @resultado = @resultado + 'ISOEQID=' + ISNULL(@ISOEQID, '') + ';'
               SET @resultado = @resultado + 'LOC99PUERTO=' + ISNULL(@PUERTO, '') + ';'
               SET @resultado = @resultado + 'LOC100PUERTO=' + ISNULL(@PUERTO, '') + ';'
               SET @resultado = @resultado + 'NROTICKET=' + ISNULL(@NRODOC, '') + ';'
               SET @RESULTADO = @RESULTADO + 'FECHAALTERNA=' + LTRIM(RTRIM(ISNULL(@FECHAALTERNA, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'DATOCTR=' + LTRIM(RTRIM(ISNULL(@SNROCTR, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'DATOLINEA=' + LTRIM(RTRIM(ISNULL(@SCODLIN, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'ETIQTDT=' + LTRIM(RTRIM(ISNULL(@ETIQTDT, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'ETIQLOC=' + LTRIM(RTRIM(ISNULL(@ETIQLOC, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'ETIQNAD=' + LTRIM(RTRIM(ISNULL(@ETIQNAD, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'FECHA_HEADER=' + LTRIM(RTRIM(ISNULL(@FECHA_HEADER, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'PLACA=' + LTRIM(RTRIM(ISNULL(@PLACA, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'NUMLLOYSISO=' + ISNULL(@NUMLLOYSISO, '') + ';'
               SET @RESULTADO = @RESULTADO + 'OBSERVACIONES=' + LTRIM(RTRIM(ISNULL(@SOBSERV, ''))) + ';'
               SET @RESULTADO = @RESULTADO + 'SIZE_TYPE=' + ISNULL(@sTamTip, '') + ';'

            END
         END
         ELSE
         BEGIN
            SET @CODIGORET = 999
            SET @RESULTADO = 'NO EXISTE BOOKING PARA LOS DATOS INGRESADOS'

            RETURN
         END
      END
   END
   ELSE
   BEGIN
      SET @CODIGORET = 999
      SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'
   END
   print @resultado
   SET NOCOUNT OFF
END

--select * from EVENTOS_LINEAS where codcon04='HASU1245935'
GO
/****** Object:  StoredProcedure [dbo].[Transporte_Circuito08]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext Transporte_Circuito08    
    
--SP_HELPTEXT Transporte_Circuito08      
-- SELECT * FROM CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2      
      
              
--ALTER PROCEDURE [dbo].[Transporte_Circuito08] (@frecuencia int)                                          
--as                                          
--begin                              
--                             
-- --Validar si criterio and a.tipope18='T'                    
--                    
-- --set nocount on                            
--if @frecuencia=-20    
--set @frecuencia=-720 -- 12horas    
--                              
--    Declare @Fecha datetime                                    
--    Set @Fecha =dateadd(n, @frecuencia,getdate())                                    
--                     
-- delete from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 where interface='INTERFACE7_08' and Estado=1                  
--                  
-- insert into CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 (Interface,Evento,Origen,Destino,TipoOperacion,NaveViaje,Nave,NumViaje,NroTicket,FechaSalida,NroContenedor,TamanioContenedor,CondicionContenedor,Placa,FlagImpoExpo)                  
--                         
--Select distinct  'INTERFACE7_08',                   
--  'SALIDA' Evento,                                          
--  'LVELL' Origen,                                          
--  (case c.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) Destino,                                          
--  'EMBARQUE' TipoOperacion,                                          
--  a.navvia11 as NaveViaje,                                                
--  c.codnav08 as Nave,                                               
--  c.numvia11 as NumViaje,                                        
--  a.nrotkt18 as NroTicket ,                                        
--  a.fecsal18 as FechaSalida,                                                
--  b.codcon04 as NroContenedor,                                          
--  d.codtam09 as TamanioContenedor,                                         
--                                       
--  (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) as CondicionContenedor,                                         
--  a.nropla18 as Placa,'E' FlagImpoExpo                                          
--  from  ddticket18 a (nolock)                                        
--  inner join drctrtmc90 b (nolock) on a.nrotkt18=b.nrotkt28                                                
--  inner join ddcabman11 c (nolock) on a.navvia11=c.navvia11                                                
--  inner join edconten04 d (nolock) on b.codcon04=d.codcon04                                        
--  left join DDGUITPC19 AS I (nolock) ON a.nrotkt18=i.nrotkt18                                            
--  left join edllenad16 j (nolock) on j.navvia11=a.navvia11 and j.codcon04=b.codcon04    
--  left join edauting14 k (nolock) on j.nroaut14=k.nroaut14 and j.navvia11=k.navvia11      
--  
--  Where                                         
--  a.fecsal18>= @Fecha           
--  AND isnull(a.nrosec18,'') =''                                       
--  --and c.ptoori11='E'                                
--  and a.tipope18='T'                                           
--  AND (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) is not null                                        
--  and a.sucursal='2'   --Ventanilla Llenos                                                
--  and substring(b.codcon04,4,1)='U'    
--  and not(k.nropla81 like 'X00%' AND K.nropla81 is not null)    
--
--  and a.nrotkt18 not in (  
--                         select nrotkt18   
--                         FROM TKTAUDIT00(NOLOCK)  
--                         WHERE NOMTAB00='DDTICKET18' and fecope00>=dateadd(day,-2,@Fecha)  
--  )  
--
--end 
--GO
/****** Object:  StoredProcedure [dbo].[Transporte_Circuito09]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sp_helptext Transporte_Circuito09      
  
--ALTER PROCEDURE [dbo].[Transporte_Circuito09] (@frecuencia int)                                       
--as                            
--begin                            
--                                 
----Validar criterio A.tipope18='T'                      
--                      
-- --set nocount on                            
--if @frecuencia=-20        
--set @frecuencia=-720 --12horas        
--        
--                            
-- Declare @Fecha datetime                                  
--    Set @Fecha =dateadd(n, @frecuencia,getdate())                                          
--                         
-- delete from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 where interface='INTERFACE7_09' and Estado=1                     
--                      
-- insert into CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 (Interface,Evento,Origen,Destino,TipoOperacion,NaveViaje,Nave,NumViaje,NroTicket,FechaSalida,NroContenedor,TamanioContenedor,CondicionContenedor,Placa,FlagImpoExpo)                      
--                              
--  Select distinct     'INTERFACE7_09',                
--  'SALIDA' Evento,                                        
--  'LVILL' Origen,                                        
--  (case c.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) Destino,                                        
--  'EMBARQUE' TipoOperacion,                                        
--  a.navvia11 as NaveViaje,                                                
--  c.codnav08 as Nave,                                             
--  c.numvia11 as NumViaje,                                       
--  a.nrotkt18 as NroTicket,                                       
--  a.fecsal18 as FechaSalida,                                                
--  b.codcon04 as NroContenedor,                                        
--  d.codtam09 as TamanioContenedor,                                       
--  (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) as CondicionContenedor,                                      
--  a.nropla18 as Placa,'E' FlagImpoExpo                                        
--  from ddticket18 a (nolock)                                        
--  inner join drctrtmc90 b (nolock) on a.nrotkt18=b.nrotkt28                                         
--  inner join ddcabman11 c (nolock) on a.navvia11=c.navvia11                                                
--  inner join edconten04 d (nolock) on b.codcon04=d.codcon04                                               
--  LEFT JOIN DDGUITPC19 AS I (nolock) ON a.nrotkt18=i.nrotkt18                                            
-- left join edllenad16 j (nolock) on j.navvia11=a.navvia11 and j.codcon04=b.codcon04      
-- left join edauting14 k (nolock) on j.nroaut14=k.nroaut14 and j.navvia11=k.navvia11       
--      
--  Where                                       
--  a.fecsal18>=@Fecha --between dateadd(n, @frecc,getdate()) and getdate()                                        
--  --AND isnull(a.nrosec18,'') =''  -- SE QUITO DADO QUE EL FILTRO NO ES CORRECTO EN VILLEGAS  
--  AND a.nrotkt18<>''  
--  AND A.tipope18='T'                              
--  AND (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) is not null                                      
--  and a.sucursal in ('1','3') --Villegas           
--  and substring(b.codcon04,4,1)='U'      
--  and not(k.nropla81 like 'X00%' AND K.nropla81 is not null)      
--  and a.nrotkt18 not in (  
--                         select nrotkt18   
--                         FROM TKTAUDIT00(NOLOCK)  
--                         WHERE NOMTAB00='DDTICKET18' and fecope00>=dateadd(day,-2,@Fecha)  
--  )  
--
--end 
--GO
/****** Object:  StoredProcedure [dbo].[Transporte_Circuito7_80]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
--ALTER PROCEDURE [dbo].[Transporte_Circuito7_80] (@frecuencia int)                                                  
--as                                                  
--begin                                      
--                                     
-- --Validar si criterio and a.tipope18='T'                            
--                            
-- --set nocount on                                    
--if @frecuencia=-20            
--set @frecuencia=-720 -- 12horas            
--                                      
--    Declare @Fecha datetime                                            
--    Set @Fecha =dateadd(n, @frecuencia,getdate())                                            
--                             
-- delete from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 where interface='INTERFACE7_80' and Estado=1                          
--                          
-- insert into CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2 (Interface,Evento,Origen,Destino,TipoOperacion,NaveViaje,Nave,NumViaje,NroTicket,FechaHoraDestare,NroContenedor,TamanioContenedor,CondicionContenedor,Placa,FlagImpoExpo)                         
-- 
--
--                      
--Select distinct  'INTERFACE7_80',                           
--  'SALIDA' Evento,                                                  
--  '' Origen,          
--  (case c.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) Destino,                                                  
--  'EMBARQUE PATIO' TipoOperacion,                                                  
--  a.navvia11 as NaveViaje,                                                        
--  c.codnav08 as Nave,                                                       
--  c.numvia11 as NumViaje,                                                
--  a.nrotkt18 as NroTicket ,                                                
--  dateadd(minute,2,a.fecing18) as FechaHoraDestare,                                                        
--  b.codcon04 as NroContenedor,                                                  
--  d.codtam09 as TamanioContenedor,                                                 
--  (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) as CondicionContenedor,                                                 
--  a.nropla18 as Placa,'E' FlagImpoExpo                                                  
--  from  ddticket18 a (nolock)                                                
--  inner join ddcabman11 c (nolock) on a.navvia11=c.navvia11                                                        
--  LEFT join drctrtmc90 b (nolock) on a.nrotkt18=b.nrotkt28                                                        
--  left join edconten04 d (nolock) on b.codcon04=d.codcon04                                                
--            
--  Where                                                 
-- a.fecing18>=@Fecha                   
-- and a.tipope18='T'                                                   
-- --AND (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) is not null                                                
-- -- a.sucursal='2'   --Ventanilla Llenos                                                        
-- AND a.status18='I'            
-- --AND A.nrotkt18='01542944'          
-- AND LEN(a.nropla18)>=6       
-- --and a.nropla18='C8Z909'    
-- --ORDER BY  a.fecing18 DESC                
-- and a.nrotkt18 not in (  
--                         select nrotkt18   
--                         FROM TKTAUDIT00(NOLOCK)  
--                         WHERE NOMTAB00='DDTICKET18' and fecope00>=dateadd(day,-2,@Fecha)  
--)  
--    
--end           
--          
-- select * from ddticket18(nolock) where nrotkt18='01548898'    
-- select tipope18,status18,* from ddticket18(nolock) where fecing18 is not null AND NROPLA18='a9s804' order by fecing18 desc    
-- select * from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT2  where interface='INTERFACE7_09' and placa='C8Z909' order by fechasalida desc
GO
/****** Object:  StoredProcedure [dbo].[Transporte_Circuito7_80_tktEliminados]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--ALTER PROCEDURE [dbo].[Transporte_Circuito7_80_tktEliminados] (@frecuencia int)                                                      
--as                                                      
--begin                                          
-----------------------------------
--/* SE EJECUTA CADA 3 MINUTOS */
-----------------------------------
--if @frecuencia=-20  
--set @frecuencia=-720 -- 12horas -6  
--  
--Declare @Fecha datetime  
--Set @Fecha =dateadd(n, @frecuencia,getdate())  
--
-----------------------------------------------  
--/* INSERTAMOS LOS TICKETS EXPO ELIMINADOS */ 
----------------------------------------------- 
-- insert into CALW8BDSCOT.SSCO.dbo.matriz_tkt_npt2(tkt,operacion,fec_insert)  
--  
-- select distinct  
-- nrotkt18 COLLATE SQL_Latin1_General_CP1_CI_AS,  
-- 'BALANZA_EXPO',  
-- getdate()  
-- FROM TKTAUDIT00(NOLOCK)  
-- WHERE NOMTAB00='DDTICKET18' and fecope00>=dateadd(HOUR,-1,@Fecha)  
--
--
--end 
GO
/****** Object:  StoredProcedure [dbo].[Transporte_Circuito70]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Transporte_Circuito70] (@frecuencia int)                   
          
as             
          
begin          
               
  
print 'STORE DEPURADO, AHORA SE INSERTA EN TABLAS DEL SERVIDOR CALW8BDSCOT '   
-- Declare @Fecha datetime                
--    Set @Fecha =dateadd(n, @frecuencia,getdate())                
--                 
--delete from descarga.dbo.Matriz_Interfaces_NPT where interface='INTERFACE7_70' and Estado=1   
--    
--insert into descarga.dbo.Matriz_Interfaces_NPT (Interface,Evento,Origen,Destino,TipoOperacion,NaveViaje,Nave,NumViaje,NroTicket,FechaSalida,NroContenedor,TamanioContenedor,CondicionContenedor,Placa)    
--  
-- Select distinct                        'INTERFACE7_70',   
-- 'SALIDA' Evento,                    
-- 'LVILL' Origen,                       
-- 'PDPW' Destino,                   
-- 'EMBARQUE' TipoOperacion,                  
-- a.navvia11 as NaveViaje,                          
-- c.codnav08 as Nave,                       
-- c.numvia11 as NumViaje,                    
-- a.nrotkt18 as NroTicket ,                  
-- a.fecsal18 as FechaSalida,                          
-- b.codcon04 as NroContenedor,                       
-- d.codtam09 as TamanioContenedor,                  
--                    
-- (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) as CondicionContenedor,                  
-- a.nropla18 as Placa                    
-- from ddticket18 a (nolock)                           
-- inner join drctrtmc90 b (nolock)  on a.nrotkt18=b.nrotkt28                          
-- inner join ddcabman11 c (nolock)  on a.navvia11=c.navvia11                          
-- inner join edconten04 d (nolock)  on b.codcon04=d.codcon04                   
-- LEFT JOIN DDGUITPC19 AS I (nolock)  ON a.nrotkt18=i.nrotkt18                      
-- Where                   
-- a.fecsal18>=@Fecha --between dateadd(n, @frecc,getdate()) and getdate()                     
-- and c.ptoori11='D'                   
-- and a.tipope18='T'             
-- AND (case d.codbol03 when 'FC' then 'Lleno' when 'LC' then 'Lleno' END) is not null                  
-- ORDER BY a.fecsal18 ASC                  
                
                 
end  
  
  
GO
/****** Object:  StoredProcedure [dbo].[Transporte_EXPO_viajestotal]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Transporte_EXPO_viajestotal] (@frecc int)                             
as                        
--begin                        
                        
--select    
--codnav08 Nave,    
--numvia11 NumViaje,    
----numvia11,    
--(case ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) as Destino,    
--numman11 NroManifiesto,    
--anyman11 AnioManifiesto,    
--feclle11 FechaArribo    
--from dbo.DDCABMAN11 (nolock)    
--WHERE     
--feclle11 >= dateadd(n, @frecc,getdate())    
--order by codnav08--feclle11 desc     
--    
--insert into Interfaces_log(Interface,Registros) values('Transporte_EXPO_viajestotal',@@rowcount)                    
--  
--end    
GO
/****** Object:  StoredProcedure [dbo].[UPD_DEPO_X_IP]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UPD_DEPO_X_IP]
--DECLARE
@IP as varchar(100),
@NroAut as char(8)
AS
--SET @NroAut = '00669009'
--SET @IP = '172.16.1.234' 
DECLARE @Deposito char(2), @Flgvia17 char(1)

select @Deposito = DEPOSITO from IPSBALANZAS where ip_balanza = @IP

UPDATE descarga..erconasi17
SET CODDEP04 = @Deposito,
FLGVIA17 = CASE WHEN @Deposito = 'TM' THEN '0' ELSE '1' END,
OTRDEP17 = CASE WHEN @Deposito<>'TM' AND @Deposito<>'OT' THEN '' ELSE OTRDEP17 END
from descarga..erconasi17 a, EDAUTING14 b 
where a.nroaut14 = b.nroaut14
and a.nroaut14 = @NroAut
GO
/****** Object:  StoredProcedure [dbo].[UPS_Eventos_Expo_Envios_VGM_FC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UPS_Eventos_Expo_Envios_VGM_FC] @tipoenvio VARCHAR(1)
	,@fechaevento VARCHAR(15)
	,@linea VARCHAR(3)
	,@navvia VARCHAR(6)
	,@contenedor VARCHAR(11)
	,@pesoneto DECIMAL(15, 3)
	,@autorizacion VARCHAR(8)
	,@g_User VARCHAR(35)
	,@viIPE VARCHAR(30)
	,@SucursalGWC VARCHAR(3)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NAVVIA11 VARCHAR(6)
		,@GENBKG13 VARCHAR(6)
		,@BOOKING_CPL VARCHAR(35)
		,@EMBARCADOR VARCHAR(11)
		,@SCODTAM VARCHAR(3)
		,@SCODTIP VARCHAR(2)
		,@STAMTIP VARCHAR(4)
		,@TIPODOC VARCHAR(3)
		,@NUMVIA VARCHAR(10)
		,@DESC_NAVE VARCHAR(30)
		,@PUERTO VARCHAR(3)
		,@DISCHARGE_PORT VARCHAR(10)
		,@FINAL_DESTINATION VARCHAR(10)
		,@ITRM VARCHAR(3)
		,@INLANDDEPOT VARCHAR(6)
		,@NADCAVALUE VARCHAR(6)
		,@LOCALPUERTO VARCHAR(6)
		,@CAMPO_PRECINTO VARCHAR(60)
		,@ISOEQID VARCHAR(5)
		,@FECLLE DATETIME
		,@FECCUT DATETIME
		,@FECCUTR DATETIME
		,@CODAGE VARCHAR(11)

	IF (
			@SucursalGWC = 'VIL'
			OR @SucursalGWC = 'VEN'
			)
	BEGIN
		SET @ITRM = 'CO'
	END

	IF (@SucursalGWC = 'PAI')
	BEGIN
		SET @ITRM = 'PAI'
	END

	SELECT TOP 1 @NAVVIA = a.NAVVIA11
		,@GENBKG13 = a.genbkg13
		,@BOOKING_CPL = LTRIM(RTRIM(ISNULL(A.bkgcom13, '')))
		,@EMBARCADOR = a.codemc12
		,@SCODTAM = a.codtam09
		,@SCODTIP = a.codtip05
		,@CODAGE = ISNULL(a.rucage19, '')
	FROM descarga..edbookin13 a WITH (NOLOCK)
	INNER JOIN descarga..erconasi17 b WITH (NOLOCK) ON a.genbkg13 = b.genbkg13
	INNER JOIN Descarga..EDAUTING14 c WITH (NOLOCK) ON c.genbkg13 = a.genbkg13
	WHERE a.navvia11 = @navvia
		AND b.codcon04 = @contenedor
		AND C.nroaut14 = @autorizacion
	ORDER BY a.navvia11 DESC
		,a.genbkg13 DESC

	--|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD                  
	--   IF LTRIM(RTRIM(@EMBARCADOR))<>'20373860736' AND LTRIM(RTRIM(@linea))='HSD'                  
	--BEGIN                
	--RETURN;                  
	--END                  
	SET @STAMTIP = @SCODTAM + @SCODTIP
	SET @TIPODOC = 'AUT'

	SELECT @NUMVIA = ltrim(rtrim(a.numvia11))
		,@DESC_NAVE = ltrim(rtrim(b.desnav08))
		,@PUERTO = ltrim(rtrim(ptoori11))
		,@FECLLE = a.feclle11
		,@FECCUT = a.FecCut11
		,@FECCUTR = a.FecCutR11
	FROM descarga..DDCABMAN11 a WITH (NOLOCK)
	INNER JOIN descarga..DQNAVIER08 b WITH (NOLOCK) ON a.codnav08 = b.codnav08
	WHERE a.navvia11 = @navvia

	IF LTRIM(RTRIM(@PUERTO)) = 'E'
	BEGIN
		SET @PUERTO = 'APM'
	END

	IF LTRIM(RTRIM(@PUERTO)) = 'D'
	BEGIN
		SET @PUERTO = 'DPW'
	END

	SELECT @DISCHARGE_PORT = b.codsol02
	FROM descarga..EDBOOKIN13 a WITH (NOLOCK)
	INNER JOIN descarga..DQPUERTO02 b WITH (NOLOCK) ON a.codpue02 = b.codpue02
	WHERE a.genbkg13 = @GENBKG13

	IF (@DISCHARGE_PORT IS NULL)
	BEGIN
		IF (@ITRM = 'CO')
		BEGIN
			SET @DISCHARGE_PORT = 'PECLL'
		END

		IF (@ITRM = 'PAI')
		BEGIN
			SET @DISCHARGE_PORT = 'PEPAI'
		END
	END

	SELECT @FINAL_DESTINATION = b.codsol02
	FROM descarga..EDBOOKIN13 a WITH (NOLOCK)
	INNER JOIN descarga..DQPUERTO02 b WITH (NOLOCK) ON a.codpue13 = b.codpue02
	WHERE a.genbkg13 = @GENBKG13

	IF (@FINAL_DESTINATION IS NULL)
	BEGIN
		IF (@ITRM = 'CO')
		BEGIN
			SET @FINAL_DESTINATION = 'PECLL'
		END

		IF (@ITRM = 'PAI')
		BEGIN
			SET @FINAL_DESTINATION = 'PEPAI'
		END
	END

	IF (@ITRM = 'CO')
	BEGIN
		SET @INLANDDEPOT = 'NEC'
		SET @NADCAVALUE = 'NEC'
		SET @LOCALPUERTO = 'CLL'
	END

	IF (@ITRM = 'PAI')
	BEGIN
		SET @INLANDDEPOT = 'NEP'
		SET @NADCAVALUE = 'NEP'
		SET @LOCALPUERTO = 'PAI'
	END

	SELECT @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))
	FROM descarga..ERCONASI17 WITH (NOLOCK)
	WHERE genbkg13 = @GENBKG13
		AND codcon04 = @contenedor

	SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))
	FROM spbmcaracteristicascontenedor
	WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP
		AND Tamanyo = @SCODTAM

	--|INSERTAR VALORES EN LA TABLA INTERMEDIA        
	/*        
    INSERT INTO LIN_REGISTRO_VGM        
    (line,evento,estado,FechaCreacion,Sistema,usuario,ip_machine,desc_local,idtipoenvio,        
 Contenedor,FechaEvento,navvia,tipo_documento,Nro_Documento,BookinBL,Genbkg,Tamanyo_ctr,        
 Tipo_ctr,Codigo_ISO,Peso_Ctr,Local_Etiqueta,Opera,Condcont,Local_Origen,SIZETYPE,Cod_Viaje,        
 Desc_Nave,Local_Puerto,INLANDDEPOT,DISCHARGE_PORT)        
 VALUES        
 (@linea,'VGM','REG',GETDATE(),'BALANZA',@g_User,@viIPE,null,@tipoenvio,        
 @contenedor,@fechaevento,@navvia,@TIPODOC,@autorizacion,@BOOKING_CPL,@GENBKG13,@SCODTAM,        
 @SCODTIP,@ISOEQID,@pesoneto,'LIMATELEDI2','9','5','3',@STAMTIP,@NUMVIA,        
 @DESC_NAVE,@LOCALPUERTO,@INLANDDEPOT,@DISCHARGE_PORT        
 )        
 */
	EXEC EnvioLineas.DBO.USP_REGISTAR_ENVIOS_VGM @linea
		,'VGM'
		,'REG'
		,'BALANZA'
		,@g_User
		,@viIPE
		,NULL
		,@tipoenvio
		,@contenedor
		,@fechaevento
		,@navvia
		,@TIPODOC
		,@autorizacion
		,@BOOKING_CPL
		,@GENBKG13
		,@SCODTAM
		,@SCODTIP
		,@ISOEQID
		,@pesoneto
		,'LIMATELEDI2'
		,'9'
		,'5'
		,'3'
		,@STAMTIP
		,@NUMVIA
		,@DESC_NAVE
		,@LOCALPUERTO
		,@INLANDDEPOT
		,@DISCHARGE_PORT
		,@FECLLE
		,@FECCUT
		,@FECCUTR

	--|        
	--|ENVIAR CORREO AUTOMATICO PARA CLIENTES CON INFORMACION SOBRE EL VGM  
	exec USP_SEND_VGM @navvia,@GENBKG13,@BOOKING_CPL,@contenedor,@pesoneto,@EMBARCADOR,@CODAGE,@tipoenvio,''  
	--|  
	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Eventos_Expo_Envios_VGM_FC_PRUEBA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UPS_Eventos_Expo_Envios_VGM_FC_PRUEBA]
@tipoenvio VARCHAR(1)
,@fechaevento VARCHAR(15)
,@linea VARCHAR(3)
,@navvia VARCHAR(6)
,@contenedor VARCHAR(11)
,@pesoneto DECIMAL(15,3)
,@autorizacion VARCHAR(8)
,@g_User VARCHAR(35)
,@viIPE VARCHAR(30)
,@SucursalGWC VARCHAR(3)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @NAVVIA11 VARCHAR (6)
	,@GENBKG13 VARCHAR(6)
	,@BOOKING_CPL VARCHAR(35)
	,@EMBARCADOR VARCHAR(11)
	,@SCODTAM VARCHAR(3)
	,@SCODTIP VARCHAR(2)
	,@STAMTIP VARCHAR(4)
	,@TIPODOC VARCHAR(3)
	,@NUMVIA VARCHAR(10)
	,@DESC_NAVE VARCHAR(30)
	,@PUERTO VARCHAR(3)
	,@DISCHARGE_PORT VARCHAR(10)
	,@FINAL_DESTINATION VARCHAR(10)
	,@ITRM VARCHAR(3)
	,@INLANDDEPOT VARCHAR(6)
	,@NADCAVALUE VARCHAR(6)
	,@LOCALPUERTO VARCHAR(6)
	,@CAMPO_PRECINTO varchar(60)
	,@ISOEQID VARCHAR(5)
	,@FECLLE DATETIME
	,@FECCUT DATETIME
	,@FECCUTR DATETIME
	
	IF(@SucursalGWC='VIL' OR @SucursalGWC='VEN')        
    BEGIN        
		SET @ITRM='CO'        
	END 
	IF(@SucursalGWC='PAI')        
    BEGIN        
		SET @ITRM='PAI'        
	END   
	      
	SELECT        
	TOP 1 @NAVVIA  = a.NAVVIA11         
	,@GENBKG13        = a.genbkg13         
	,@BOOKING_CPL  = LTRIM(RTRIM(ISNULL(A.bkgcom13,''))) 
	,@EMBARCADOR = a.codemc12
	,@SCODTAM = a.codtam09
	,@SCODTIP = a.codtip05  
	FROM        
	descarga..edbookin13 a WITH (NOLOCK) 
	INNER JOIN descarga..erconasi17 b WITH (NOLOCK) ON a.genbkg13 = b.genbkg13
	INNER JOIN Descarga..EDAUTING14 c WITH (NOLOCK) ON c.genbkg13 = a.genbkg13                                                           
	where        
	a.navvia11 = @navvia              
	AND b.codcon04 = @contenedor   
	AND C.nroaut14 = @autorizacion                                                    
	order by a.navvia11 desc,a.genbkg13 desc                                                          

	--|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD          
    IF LTRIM(RTRIM(@EMBARCADOR))<>'20373860736' AND LTRIM(RTRIM(@linea))='HSD'          
	BEGIN        
		RETURN;          
	END          

    SET @STAMTIP = @SCODTAM + @SCODTIP                                                          
    SET @TIPODOC='AUT'                                      
                 
	SELECT        
    @NUMVIA = ltrim(rtrim(a.numvia11)),        
    @DESC_NAVE = ltrim(rtrim(b.desnav08)),  
    @PUERTO = ltrim(rtrim(ptoori11)),
    @FECLLE = a.feclle11,
    @FECCUT = a.FecCut11,
    @FECCUTR = a.FecCutR11
    FROM descarga..DDCABMAN11 a WITH (NOLOCK)        
    INNER JOIN descarga..DQNAVIER08 b WITH (NOLOCK) on a.codnav08 = b.codnav08        
    WHERE a.navvia11 = @navvia     
                    
    IF LTRIM(RTRIM(@PUERTO)) = 'E'  
    BEGIN  
		SET @PUERTO = 'APM'  
    END  
    IF LTRIM(RTRIM(@PUERTO)) = 'D'  
    BEGIN  
		SET @PUERTO = 'DPW'  
    END  
        
    SELECT @DISCHARGE_PORT = b.codsol02        
    FROM descarga..EDBOOKIN13 a WITH (NOLOCK)        
    INNER JOIN descarga..DQPUERTO02 b WITH (NOLOCK) on a.codpue02 = b.codpue02        
    WHERE a.genbkg13 = @GENBKG13        
        
    IF (@DISCHARGE_PORT IS NULL)        
    BEGIN        
		IF(@ITRM='CO')        
        BEGIN        
			SET @DISCHARGE_PORT = 'PECLL'        
        END        
        IF(@ITRM='PAI')        
        BEGIN        
			SET @DISCHARGE_PORT = 'PEPAI'        
        END        
	END       
                    
    SELECT @FINAL_DESTINATION = b.codsol02        
    FROM descarga..EDBOOKIN13 a WITH (NOLOCK)        
    INNER JOIN descarga..DQPUERTO02 b WITH (NOLOCK) on a.codpue13 = b.codpue02        
    WHERE a.genbkg13 = @GENBKG13        
    
    IF (@FINAL_DESTINATION IS NULL)        
    BEGIN        
		IF(@ITRM='CO')        
        BEGIN        
			SET @FINAL_DESTINATION = 'PECLL'        
        END        
        IF(@ITRM='PAI')        
        BEGIN        
			SET @FINAL_DESTINATION = 'PEPAI'        
        END        
	END        
                          
    IF(@ITRM='CO')        
    BEGIN        
		SET @INLANDDEPOT = 'NEC'        
		SET @NADCAVALUE = 'NEC'        
		SET @LOCALPUERTO = 'CLL'        
    END        
    IF(@ITRM='PAI')        
    BEGIN        
		SET @INLANDDEPOT = 'NEP'        
		SET @NADCAVALUE = 'NEP'        
		SET @LOCALPUERTO = 'PAI'        
	END        
                    
    SELECT @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))        
    FROM descarga..ERCONASI17 WITH (NOLOCK)       
    WHERE genbkg13 = @GENBKG13         
    and codcon04=@contenedor
               
          
    SELECT @ISOEQID = LTRIM(RTRIM(CodigoInternacional))         
    FROM spbmcaracteristicascontenedor         
    WHERE LTRIM(RTRIM(Tipo)) = @SCODTIP         
    AND Tamanyo = @SCODTAM        
    
    --|INSERTAR VALORES EN LA TABLA INTERMEDIA
    /*
    INSERT INTO EnvioLineas.DBO.LIN_REGISTRO_VGM
    (line,evento,estado,FechaCreacion,Sistema,usuario,ip_machine,desc_local,idtipoenvio,
	Contenedor,FechaEvento,navvia,tipo_documento,Nro_Documento,BookinBL,Genbkg,Tamanyo_ctr,
	Tipo_ctr,Codigo_ISO,Peso_Ctr,Local_Etiqueta,Opera,Condcont,Local_Origen,SIZETYPE,Cod_Viaje,
	Desc_Nave,Local_Puerto,INLANDDEPOT,DISCHARGE_PORT)
	VALUES
	(@linea,'VGM','REG',GETDATE(),'BALANZA',@g_User,@viIPE,null,@tipoenvio,
	@contenedor,@fechaevento,@navvia,@TIPODOC,@autorizacion,@BOOKING_CPL,@GENBKG13,@SCODTAM,
	@SCODTIP,@ISOEQID,@pesoneto,'LIMATELEDI2','9','5','3',@STAMTIP,@NUMVIA,
	@DESC_NAVE,@LOCALPUERTO,@INLANDDEPOT,@DISCHARGE_PORT
	)
	print @BOOKING_CPL
	print @GENBKG13
	print @SCODTAM
	print @SCODTIP
	print @ISOEQID
	*/
	
	EXEC EnvioLineas.DBO.USP_REGISTAR_ENVIOS_VGM_PRUEBA @linea,'VGM','REG','BALANZA',@g_User,@viIPE,null,@tipoenvio,
	@contenedor,@fechaevento,@navvia,@TIPODOC,@autorizacion,@BOOKING_CPL,@GENBKG13,@SCODTAM,
	@SCODTIP,@ISOEQID,@pesoneto,'LIMATELEDI2','9','5','3',@STAMTIP,@NUMVIA,
	@DESC_NAVE,@LOCALPUERTO,@INLANDDEPOT,@DISCHARGE_PORT,@FECLLE,@FECCUT,@FECCUTR
    --|

SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_BLOQUEAR_ETIQ_SPARCS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_BLOQUEAR_ETIQ_SPARCS] @NRTOKT18 VARCHAR(8)
AS
BEGIN
	DECLARE @NAVVIA11 VARCHAR(6)
		,@CODCON04 VARCHAR(11)
		,@TIPOPE VARCHAR(1)

	SELECT @NAVVIA11 = A.navvia11
		,@CODCON04 = B.codcon04
		,@TIPOPE = A.tipope18
	FROM DDTICKET18 A WITH (NOLOCK)
	INNER JOIN DRCTRTMC90 B WITH (NOLOCK) ON A.nrotkt18 = B.nrotkt28
	WHERE A.nrotkt18 = @NRTOKT18

	IF @TIPOPE = 'T'
	BEGIN
		--//BLOQUEAR ETIQUETA LIBERADA, POR UNA ELIMINACION DE TICKET      
		DECLARE @IDETIQUETA INT

		SET @IDETIQUETA = 0

		SELECT @IDETIQUETA = ID_ETIQ001
		FROM DESCARGA..DDTRANSSPARCS001 WITH (NOLOCK)
		WHERE contenedor001 = @CODCON04
			AND navvia001 = @NAVVIA11
			AND ID_ETIQ001 is not null

		IF ISNULL(@IDETIQUETA, 0) > 0
		BEGIN
			UPDATE DESCARGA..DDETIQSPARCS001
			SET SNDISPONIBLE = '1'
			WHERE ID_ETIQ001 = @IDETIQUETA
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DUA_VENCIDA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DUA_VENCIDA] @NAVVIA VARCHAR(6)
	,@CTR VARCHAR(11)
	,@OPCION VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MENSAJE VARCHAR(3000)

	SET @MENSAJE = ''

	SELECT DISTINCT a.navvia11
		,a.genbkg13
		,c.notemb16
		,c.fecnum54
		,descarga.dbo.Fn_Calcula_DiasVencidosF(CONVERT(CHAR(8), DATEADD(D, 30, c.fecnum54), 112), CONVERT(CHAR(8), GETDATE(), 112)) AS FLG_DUA_VENCIDA
		,c.feccad54
		,IDENTITY(INT, 1, 1) AS ID
	INTO #TEMP
	FROM descarga..EDAUTING14 a(NOLOCK)
		,descarga..ERLLEORD53 b(NOLOCK)
		,descarga..EDORDEMB54 c(NOLOCK)
	WHERE a.nroaut14 = b.nroaut14
		AND b.notemb16 = c.notemb16
		AND a.navvia11 = @NAVVIA
		AND a.codcon14 = @CTR
		AND SUBSTRING(b.notemb16, 1, 3) <> '172'
		AND SUBSTRING(b.notemb16, 6, 2) <> '60'
		AND SUBSTRING(b.notemb16, 6, 2) <> '32'
		AND SUBSTRING(b.notemb16, 6, 2) <> '81'
		AND SUBSTRING(b.notemb16, 6, 2) <> '71'

	--|VALIDACION CUANDO LA FECHA DE CADUCIDAD SEA NULL        
	IF EXISTS (
			SELECT *
			FROM #TEMP
			WHERE feccad54 IS NULL
				AND fecnum54 IS NOT NULL
			)
	BEGIN
		--UPDATE EDORDEMB54 SET         
		UPDATE descarga..EDORDEMB54
		SET feccad54 = DATEADD(DAY, 25, A.fecnum54)
		FROM descarga..EDORDEMB54 A
		INNER JOIN #TEMP B ON A.notemb16 = B.notemb16
		WHERE B.feccad54 IS NULL
			AND B.fecnum54 IS NOT NULL
	END

	--|        
	DECLARE @FLG VARCHAR(1)
	DECLARE @ICONT INT
		,@ICOUNT_TOT INT
	DECLARE @NOMT VARCHAR(13)
	DECLARE @FECNUM VARCHAR(10)

	SET @ICONT = 1

	SELECT @ICOUNT_TOT = COUNT(*)
	FROM #TEMP

	IF EXISTS (
			SELECT *
			FROM #TEMP
			WHERE FLG_DUA_VENCIDA = 'S'
			)
	BEGIN
		SET @MENSAJE = @MENSAJE + 'El Contenedor ' + @CTR + ' presenta las siguientes DUAS vencidas:' + CHAR(13)

		WHILE @ICONT <= @ICOUNT_TOT
		BEGIN
			SELECT @NOMT = ISNULL(notemb16, '')
				,@FECNUM = CONVERT(VARCHAR, fecnum54, 103)
			FROM #TEMP
			WHERE ID = @ICONT

			IF EXISTS (
					SELECT *
					FROM #TEMP
					WHERE FLG_DUA_VENCIDA = 'S'
						AND ID = @ICONT
					)
			BEGIN
				SET @MENSAJE = @MENSAJE + 'DUA: ' + @NOMT + ', Fecha Numeración: ' + @FECNUM + CHAR(13)
			END

			SET @ICONT = @ICONT + 1
		END

		SET @MENSAJE = @MENSAJE + 'Coordinar con revision Documentaria'
	END

	SELECT LTRIM(RTRIM(@MENSAJE)) AS 'mensaje'
		,'1' AS flgBlo

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_FINDTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************	
--MODULO: BALANZA EXPORTACION 
--Usuario Creador		: ?
--Fecha Creacion		: ?
--Usuario Modificador	: EDQP
--Fecha Modificacion	: 22/12/2014
--Descripcion			: Consulta los datos Ticket por Numero de Ticket / Consulta de Ticket	
-- frmbalexmq
*****************************************/
ALTER PROCEDURE [dbo].[USP_FINDTICKET](  
	@NROTKT18	VARCHAR(8)
	--,@BVERSION	INT = 0
)  
AS
BEGIN  
	SET NOCOUNT ON;  
	SET ANSI_NULLS ON;  
	SET QUOTED_IDENTIFIER ON;  
---------------------------|
--SET @NROTKT18 = '01674706'
--
IF EXISTS(	SELECT		NROTKT18 
			FROM		dbo.DDTICKET18 AS DTK18 WITH(NOLOCK) 
			INNER JOIN	dbo.DBPASSPE98 AS DP98 WITH(NOLOCK) 
					ON	DTK18.NROTKT18 = DP98.TICKET
			WHERE		DTK18.NROTKT18 = @NROTKT18
			GROUP BY	NROTKT18)
	BEGIN
		--PRINT 'A'		
		SELECT		 DTK.nrotkt18  
					,DTK.NROPLA18  --/ NRO DE PLACA   
					,DTK.CODCON04  --/ NRO DE CONTENEDOR  
					,DTK.NROTAR18  --/ NRO DE TARA  
					,DTK.PESBRT18  --/ PESO BRUTO(MODIFICABLE POR EL USUARIO)  
					,DTK.PESTAR18  --/ PESO TARA(MODIFICABLE POR EL USUARIO)  
					,DTK.PESNET18  --/ PESO NETO   
					,DTK.NAVVIA11  --/ NAVE Y VIAJE  
					,DTK.nrosec18  
					,DTK.NROCHA14  --/ NRO DE CHASIS  
					,DTK.TIPOPE18  --/ TIPO DE OPEACION (E = EXPORTACION , T = TRANSPORTE)  
					,DTK.FECING18  --/ FECHA DE INGRESO  
					,DTK.fecsal18  
					,DTK.codusu17  
					,DTK.fecusu00  
					,DTK.fimprv18  
					,DTK.fimprc18  
					,DTK.fimprm18  
					,DTK.fimpri18  
					,DTK.nrobal18  
					,DTK.STATUS18  --/ ESTADO DEL TICKET ()  
					,DTK.mertot18  
					,DTK.nroord41  
					,DTK.observ18  
					,DTK.codemb06  
					,DTK.nrosal52  
					,DTK.BULING18  --/ BULTOS INGRESADOS  
					,DTK.BULRET18  --/ BULTOS RETIRADOS  
					,DTK.FIMPRE18  --/ **  
					,DTK.fimprt18  
					,DTK.pesacu18  
					,DTK.ftrans18  
					,DTK.fcorre18  
					,DTK.faduan18  
					,DTK.NROAUT14  --/ NRO DE AUTORIZACION  
					,DTK.marcas16  
					,DTK.nrotra60  
					,DTK.traseg18  
					,DTK.pesena18  
					,DTK.fpesen18  
					,DTK.tktkman18  
					,DTK.sbpeso18  
					,DTK.flgtra99  
					,DTK.fectra99  
					,DTK.sucursal  
					,DTK.nrocar18  
					,DTK.CODBRE18  
					,DTK.FLGTRANSITO18
					,DTK.NROTAR18PRE
					,DTK.FECTAR18PRE
					,PBREAL = ISNULL(ORI.PESOBRUTOREAL,DTK.PESBRT18) --/PESO BRUTO REAL   
					,PTREAL = ISNULL(ORI.PESOTARAREAL,DTK.PESTAR18) --/PESO TARA REAL   
		 FROM dbo.DDTICKET18 AS DTK WITH(NOLOCK)   
			INNER JOIN	(  
						SELECT   
						TOP		 1
								 TICKET			= P.TICKET
								,PESOBRUTOREAL	= P.PBANTERIOR
								,PESOTARAREAL	= P.PTANTERIOR
								,PESONETOREAL	= P.PNANTERIOR
						FROM	 dbo.DBPASSPE98 AS P WITH(NOLOCK) 
						WHERE	 TICKET = @NROTKT18
						ORDER BY P.NROCAMBIO ASC
					) AS ORI
				 ON	 DTK.NROTKT18 = ORI.TICKET  
			INNER JOIN	(  
						SELECT   
						TOP		 1
								 TICKET		= P.TICKET
								,PESOBRUTO	= P.PBNUEVO
								,PESOTARA	= P.PTNUEVO
								,PESONETO	= P.PNNUEVO
						FROM	 dbo.DBPASSPE98 AS P WITH(NOLOCK) 
						WHERE	 TICKET = @NROTKT18
						ORDER BY P.NROCAMBIO DESC
					) AS CAM
				ON   DTK.NROTKT18 = CAM.TICKET  
		 WHERE		 DTK.NROTKT18 = @NROTKT18  
		 AND		 DTK.TIPOPE18 IN ('E','T');  	
	END
ELSE
	BEGIN
		--PRINT 'B'
		SELECT   * 
				,PBREAL = PESBRT18		--/PESO BRUTO REAL   
				,PTREAL = PESTAR18		--/PESO TARA REAL   
		FROM	 dbo.DDTICKET18 WITH(NOLOCK)
		WHERE	 1 = 1
		AND		 NROTKT18 = @NROTKT18
		AND      UPPER(RTRIM(LTRIM(TIPOPE18))) IN ('E','T','C');  
	END;
	--|
	-------------------------|
	SET QUOTED_IDENTIFIER OFF;  
	SET ANSI_NULLS OFF;  
	SET NOCOUNT OFF;  
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_FINDTICKET_NEW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************   
--MODULO: BALANZA EXPORTACION   
--Usuario Creador  : ?  
--Fecha Creacion  : ?  
--Usuario Modificador : FML  
--Fecha Modificacion : 11/11/2016  
--Descripcion   : Consulta los datos Ticket asi se encuentre eliminado   
-- frmbalexmq  
*****************************************/
ALTER PROCEDURE [dbo].[USP_FINDTICKET_NEW] (
	@NROTKT18 VARCHAR(8)
	,@FLAG VARCHAR(2) --NO: TICKET ELIMINADO , SI: TICKET NO ELIMINADO 
	)
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER ON;

	---------------------------|  
	--SET @NROTKT18 = '01674706'  
	--  
	IF @FLAG = 'SI'
	BEGIN
		IF EXISTS (
				SELECT NROTKT18
				FROM dbo.DDTICKET18 AS DTK18 WITH (NOLOCK)
				INNER JOIN dbo.DBPASSPE98 AS DP98 WITH (NOLOCK) ON DTK18.NROTKT18 = DP98.TICKET
				WHERE DTK18.NROTKT18 = @NROTKT18
				GROUP BY NROTKT18
				)
		BEGIN
			--PRINT 'A'    
			SELECT DTK.nrotkt18
				,DTK.NROPLA18 --/ NRO DE PLACA     
				,DTK.CODCON04 --/ NRO DE CONTENEDOR    
				,DTK.NROTAR18 --/ NRO DE TARA    
				,DTK.PESBRT18 --/ PESO BRUTO(MODIFICABLE POR EL USUARIO)    
				,DTK.PESTAR18 --/ PESO TARA(MODIFICABLE POR EL USUARIO)    
				,DTK.PESNET18 --/ PESO NETO     
				,DTK.NAVVIA11 --/ NAVE Y VIAJE    
				,DTK.nrosec18
				,DTK.NROCHA14 --/ NRO DE CHASIS    
				,DTK.TIPOPE18 --/ TIPO DE OPEACION (E = EXPORTACION , T = TRANSPORTE)    
				,DTK.FECING18 --/ FECHA DE INGRESO    
				,DTK.fecsal18
				,DTK.codusu17
				,DTK.fecusu00
				,DTK.fimprv18
				,DTK.fimprc18
				,DTK.fimprm18
				,DTK.fimpri18
				,DTK.nrobal18
				,DTK.STATUS18 --/ ESTADO DEL TICKET ()    
				,DTK.mertot18
				,DTK.nroord41
				,DTK.observ18
				,DTK.codemb06
				,DTK.nrosal52
				,DTK.BULING18 --/ BULTOS INGRESADOS    
				,DTK.BULRET18 --/ BULTOS RETIRADOS    
				,DTK.FIMPRE18 --/ **    
				,DTK.fimprt18
				,DTK.pesacu18
				,DTK.ftrans18
				,DTK.fcorre18
				,DTK.faduan18
				,DTK.NROAUT14 --/ NRO DE AUTORIZACION    
				,DTK.marcas16
				,DTK.nrotra60
				,DTK.traseg18
				,DTK.pesena18
				,DTK.fpesen18
				,DTK.tktkman18
				,DTK.sbpeso18
				,DTK.flgtra99
				,DTK.fectra99
				,DTK.sucursal
				,DTK.nrocar18
				,DTK.CODBRE18
				,DTK.FLGTRANSITO18
				,DTK.NROTAR18PRE
				,DTK.FECTAR18PRE
				,PBREAL = ISNULL(ORI.PESOBRUTOREAL, DTK.PESBRT18) --/PESO BRUTO REAL     
				,PTREAL = ISNULL(ORI.PESOTARAREAL, DTK.PESTAR18) --/PESO TARA REAL     
			FROM dbo.DDTICKET18 AS DTK WITH (NOLOCK)
			INNER JOIN (
				SELECT TOP 1 TICKET = P.TICKET
					,PESOBRUTOREAL = P.PBANTERIOR
					,PESOTARAREAL = P.PTANTERIOR
					,PESONETOREAL = P.PNANTERIOR
				FROM dbo.DBPASSPE98 AS P WITH (NOLOCK)
				WHERE TICKET = @NROTKT18
				ORDER BY P.NROCAMBIO ASC
				) AS ORI ON DTK.NROTKT18 = ORI.TICKET
			INNER JOIN (
				SELECT TOP 1 TICKET = P.TICKET
					,PESOBRUTO = P.PBNUEVO
					,PESOTARA = P.PTNUEVO
					,PESONETO = P.PNNUEVO
				FROM dbo.DBPASSPE98 AS P WITH (NOLOCK)
				WHERE TICKET = @NROTKT18
				ORDER BY P.NROCAMBIO DESC
				) AS CAM ON DTK.NROTKT18 = CAM.TICKET
			WHERE DTK.NROTKT18 = @NROTKT18
				AND DTK.TIPOPE18 IN (
					'E'
					,'T'
					);
		END
		ELSE
		BEGIN
			--PRINT 'B'  
			SELECT *
				,PBREAL = PESBRT18 --/PESO BRUTO REAL     
				,PTREAL = PESTAR18 --/PESO TARA REAL     
			FROM dbo.DDTICKET18 WITH (NOLOCK)
			WHERE 1 = 1
				AND NROTKT18 = @NROTKT18
				AND UPPER(RTRIM(LTRIM(TIPOPE18))) IN (
					'E'
					,'T'
					,'C'
					);
		END;
	END
	
	IF @FLAG = 'NO'
	BEGIN
		IF EXISTS (
				SELECT NROTKT18
				FROM dbo.DDTICKET18_AUDIT AS DTK18 WITH (NOLOCK)
				INNER JOIN dbo.DBPASSPE98 AS DP98 WITH (NOLOCK) ON DTK18.NROTKT18 = DP98.TICKET
				WHERE DTK18.NROTKT18 = @NROTKT18
				GROUP BY NROTKT18
				)
		BEGIN
			--PRINT 'A'    
			SELECT DTK.nrotkt18
				,DTK.NROPLA18 --/ NRO DE PLACA     
				,DTK.CODCON04 --/ NRO DE CONTENEDOR    
				,DTK.NROTAR18 --/ NRO DE TARA    
				,DTK.PESBRT18 --/ PESO BRUTO(MODIFICABLE POR EL USUARIO)    
				,DTK.PESTAR18 --/ PESO TARA(MODIFICABLE POR EL USUARIO)    
				,DTK.PESNET18 --/ PESO NETO     
				,DTK.NAVVIA11 --/ NAVE Y VIAJE    
				,DTK.nrosec18
				,DTK.NROCHA14 --/ NRO DE CHASIS    
				,DTK.TIPOPE18 --/ TIPO DE OPEACION (E = EXPORTACION , T = TRANSPORTE)    
				,DTK.FECING18 --/ FECHA DE INGRESO    
				,DTK.fecsal18
				,DTK.codusu17
				,DTK.fecusu00
				,DTK.fimprv18
				,DTK.fimprc18
				,DTK.fimprm18
				,DTK.fimpri18
				,DTK.nrobal18
				,DTK.STATUS18 --/ ESTADO DEL TICKET ()    
				,DTK.mertot18
				,DTK.nroord41
				,DTK.observ18
				,DTK.codemb06
				,DTK.nrosal52
				,DTK.BULING18 --/ BULTOS INGRESADOS    
				,DTK.BULRET18 --/ BULTOS RETIRADOS    
				,DTK.FIMPRE18 --/ **    
				,DTK.fimprt18
				,DTK.pesacu18
				,DTK.ftrans18
				,DTK.fcorre18
				,DTK.faduan18
				,DTK.NROAUT14 --/ NRO DE AUTORIZACION    
				,DTK.marcas16
				,DTK.nrotra60
				,DTK.traseg18
				,DTK.pesena18
				,DTK.fpesen18
				,DTK.tktkman18
				,DTK.sbpeso18
				,DTK.flgtra99
				,DTK.fectra99
				,DTK.sucursal
				,DTK.nrocar18
				,DTK.CODBRE18
				,DTK.FLGTRANSITO18
				,DTK.NROTAR18PRE
				,DTK.FECTAR18PRE
				,PBREAL = ISNULL(ORI.PESOBRUTOREAL, DTK.PESBRT18) --/PESO BRUTO REAL     
				,PTREAL = ISNULL(ORI.PESOTARAREAL, DTK.PESTAR18) --/PESO TARA REAL     
			FROM dbo.DDTICKET18_AUDIT AS DTK WITH (NOLOCK)
			INNER JOIN (
				SELECT TOP 1 TICKET = P.TICKET
					,PESOBRUTOREAL = P.PBANTERIOR
					,PESOTARAREAL = P.PTANTERIOR
					,PESONETOREAL = P.PNANTERIOR
				FROM dbo.DBPASSPE98 AS P WITH (NOLOCK)
				WHERE TICKET = @NROTKT18
				ORDER BY P.NROCAMBIO ASC
				) AS ORI ON DTK.NROTKT18 = ORI.TICKET
			INNER JOIN (
				SELECT TOP 1 TICKET = P.TICKET
					,PESOBRUTO = P.PBNUEVO
					,PESOTARA = P.PTNUEVO
					,PESONETO = P.PNNUEVO
				FROM dbo.DBPASSPE98 AS P WITH (NOLOCK)
				WHERE TICKET = @NROTKT18
				ORDER BY P.NROCAMBIO DESC
				) AS CAM ON DTK.NROTKT18 = CAM.TICKET
			WHERE DTK.NROTKT18 = @NROTKT18
				AND DTK.TIPOPE18 IN (
					'E'
					,'T'
					);
		END
		ELSE
		BEGIN
			--PRINT 'B'  
			SELECT *
				,PBREAL = PESBRT18 --/PESO BRUTO REAL     
				,PTREAL = PESTAR18 --/PESO TARA REAL     
			FROM dbo.DDTICKET18_AUDIT WITH (NOLOCK)
			WHERE 1 = 1
				AND NROTKT18 = @NROTKT18
				AND UPPER(RTRIM(LTRIM(TIPOPE18))) IN (
					'E'
					,'T'
					,'C'
					);
		END;
	END
	--|  
	-------------------------|  
	SET QUOTED_IDENTIFIER OFF;
	SET ANSI_NULLS OFF;
	SET NOCOUNT OFF;
END

--GRANT ALL ON USP_FINDTICKET_NEW TO PUBLIC
GO
/****** Object:  StoredProcedure [dbo].[USP_GENPASSDELTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[USP_GENPASSDELTICKET]  
(  
  @TIPOPER VARCHAR(1)  
)  
AS  
BEGIN  
 IF @TIPOPER = 'M'
 BEGIN
	 UPDATE  dbo.DBPASSTE99   
	 SET   [NROCAMBIO] = [NROCAMBIO] + 1  
	   ,[PASSWORD] = CONVERT(INT,CONVERT(CHAR(6),RAND()*1000000))  
	 WHERE  TIPOPER = 'M';  
 END
 ELSE
 BEGIN
	UPDATE  dbo.DBPASSTE99   
	 SET   [NROCAMBIO] = [NROCAMBIO] + 1  
	   ,[PASSWORD] = CONVERT(INT,CONVERT(CHAR(6),RAND()*1000000))  
	 WHERE  TIPOPER = 'E';
 END
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_GETCONDCONTxAUT]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC dbo.USP_GETCONDCONTxAUT '00657183'
ALTER PROCEDURE [dbo].[USP_GETCONDCONTxAUT]
(
	@NROAUT14	VARCHAR(255)
)
AS
BEGIN
SET NOCOUNT ON;
--------------||
	
	--01469630	042733	00657183
	--|
	DECLARE @GENBKG13	VARCHAR(255);
	DECLARE @CODTIP05	VARCHAR(255);
	DECLARE @CODBOL03	VARCHAR(255);
	DECLARE @ISOTANKE	INT;
	--|
	SET @CODTIP05 = '';
	SET @CODBOL03 = '';
	SET @ISOTANKE = 0;
	--|
	SELECT @GENBKG13 = GENBKG13 FROM dbo.EDAUTING14 WITH(NOLOCK) WHERE NROAUT14 = @NROAUT14
	--|
	SELECT	 @CODTIP05 = CODTIP05 
			,@CODBOL03 = CODBOL03 
	FROM	 dbo.EDBOOKIN13 WITH(NOLOCK) 
	WHERE	 GENBKG13 = @GENBKG13
	--|
	IF (@CODTIP05 = 'TK' AND @CODBOL03 = 'MT' )
		BEGIN
			SET @ISOTANKE = 1;
		END
	ELSE
		BEGIN
			SET @ISOTANKE = 0;
		END;
	
	SELECT @ISOTANKE AS ISOTANKE;
--------------||
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GETPASSDELTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[USP_GETPASSDELTICKET]
(
	  @TIPOPER	VARCHAR(1)
	 ,@PASSWORD	INT
)
AS
BEGIN
	SELECT	 [PASSWORD]
	FROM	 dbo.DBPASSTE99 WITH(NOLOCK)
	WHERE	 TIPOPER = @TIPOPER
	AND		 [PASSWORD] = @PASSWORD;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_grabar_log_error_envios_edi]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_grabar_log_error_envios_edi](              
@error varchar(2000), 
@usuario varchar(30), @sistema varchar(30), 
@pc varchar(20), @tipo int,      
@evento varchar(4), 
@linea varchar(3), 
@contenedor varchar(12), 
@bookingfis varchar(25), 
@fecha_mov varchar(20), 
@peso varchar(6)      
)              
as                      
              
declare @id int              
              
begin              
              
 -- inserto log              
 insert into log_error_envios_edi(              
 log_fecha, log_error, log_usuario, log_sistema, log_pc, log_tipo,      
 edi_evento, edi_linea, edi_contenedor, edi_bookingfis, edi_fecha_mov, edi_peso_kgr)              
 values (getdate(), @error, @usuario, @sistema, @pc, @tipo,      
 @evento, @linea, @contenedor, @bookingfis, @fecha_mov, @peso)              
      
              
 -- Envio de correo              
              
 declare @destinatarios varchar(200)                      
 declare @mensaje varchar(500)                      
 declare @asunto varchar(100)                      
                       
 declare @crlf varchar(100)                      
 declare @fecha char(10)                      
 declare @hora char(8)              
 declare @mailserver varchar(100)               
 declare @hostname varchar(50)           
 declare @tipo_mensaje varchar(20)            
                         
                         
 --inicializo variables                        
 set @crlf = char(10)+char(13)                        
 set @fecha = convert(char(10),getdate(),103)                      
 set @hora = convert(char(8), getdate(),108)                      
 set @mensaje = ''                        
 set @hostname = host_name()          
      
 if @tipo = 1      
  set @tipo_mensaje = 'GENERAR ARCHIVO'      
 if @tipo = 2      
  set @tipo_mensaje = 'ENVIAR CORREO'      
      
                       
 set @asunto = 'ERROR ENVIOS EDI - ' + @linea + ' - ' + @sistema              
 --set @destinatarios = 'jarrue@neptunia.com.pe'                      
      
      
 set @mensaje = 'SE PRODUJO UN ERROR AL ' + @tipo_mensaje + @crlf + @crlf +                      
 'SISTEMA: ' + @sistema + @crlf +               
 'USUARIO: ' + @usuario + @crlf +               
 'PC: ' + @pc + @crlf +               
 'ID: ' + convert(varchar(5),@@IDENTITY) + @crlf +               
 'ERROR: ' + @ERROR + @crlf +               
 'FECHA: ' + @fecha + ' ' + @hora               
              
 -- Servidor de correo              
 select @mailserver = valor, @destinatarios = destinatario_error from tb_parametros_configuracion       
 where parametro = 'MAILSERVER' and sistema = 'ENVIOS EDI'      
                           
 --Llamo al Stored que envia la alerta                          
 exec master.dbo.xp_smtp_sendmail                            
      @FROM  = 'oceanica1@neptunia.com.pe',                            
      @FROM_NAME  = 'OCEANICA1',                            
      @TO  = @destinatarios,                          
 --     @CC          = @CC,                            
      @subject = @asunto,                            
      @message = @mensaje,                          
 --     @type  = 'text/html',                            
      @server   = @mailserver                                            
end 
GO
/****** Object:  StoredProcedure [dbo].[USP_GUIATRITON_BALANZA8]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_GUIATRITON_BALANZA8]  
@RUCTRANS VARCHAR(11)
AS  
BEGIN  
	 IF LTRIM(RTRIM(@RUCTRANS)) = '20138322000'
	 BEGIN
		 SELECT 'No Existe una serie de Triton Asignada para esta opcion (BALANZA 8), no se generara GUÍA' as 'mensaje'  
		 ,'' as 'serie'  
		 ,cast(contad00 as varchar) as contador  
		 FROM DCGUITRBAL8  
	 END
	 ELSE
	 BEGIN
		SELECT '' as 'mensaje'  
		 ,'' as 'serie'
	 END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GUIATRITON_BALANZA8_4]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_GUIATRITON_BALANZA8_4] @RUCTRANS VARCHAR(11)
,@TIPO INT
AS
BEGIN
	IF @TIPO = 4
	BEGIN
		IF LTRIM(RTRIM(@RUCTRANS)) = '20138322000'
		BEGIN
			SELECT 'No Existe una serie de Triton Asignada para esta opcion (BALANZA 8), no se generara GUÍA' AS 'mensaje'
				,'' AS 'serie'
				,cast(contad00 AS VARCHAR) AS contador
			FROM DCGUITRBAL8
		END
		ELSE
		BEGIN
			SELECT '' AS 'mensaje'
				,'' AS 'serie'
		END
	END
	IF @TIPO = 5
	BEGIN
		IF LTRIM(RTRIM(@RUCTRANS)) = '20138322000'
		BEGIN
			SELECT 'No Existe una serie de Triton Asignada para esta opcion (BALANZA 4), no se generara GUÍA' AS 'mensaje'
				,'' AS 'serie'
				,cast(contad00 AS VARCHAR) AS contador
			FROM DCGUITRBAL4
		END
		ELSE
		BEGIN
			SELECT '' AS 'mensaje'
				,'' AS 'serie'
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_prepara_datos_eventos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_prepara_datos_eventos](
   @SCODEVE    AS CHAR(05),                                                  
   @SCODLIN    AS CHAR(3),                                                  
   @SCODINT    AS CHAR(06),                                                  
   @SNROCTR    AS CHAR(11),                                                  
   @SFECREG    AS CHAR(14),                                                  
   @DPESCTR    DECIMAL(12,2),
   @ITRM       AS VARCHAR(06),
   @CODIGORET  INT OUTPUT, 
   @RESULTADO  VARCHAR(8000) OUTPUT)
AS

BEGIN
   SET NOCOUNT ON
   DECLARE @IDREGISTRO         BIGINT
   DECLARE @SCODTAM            CHAR(02)
   DECLARE @SCODTIP            CHAR(02)
   DECLARE @SNROBKG            VARCHAR(25)
   DECLARE @SOBSERV            VARCHAR(50)
   DECLARE @IVAL               BIGINT
   DECLARE @STAMTIP            VARCHAR(4)
   DECLARE @IBLQ               INT
   DECLARE @NAVVIA             CHAR(06)
   DECLARE @GENBKG             CHAR(06)
   DECLARE @NRODOC             CHAR(08)
   DECLARE @TIPODOC            VARCHAR(10)
   DECLARE @BOOKINGBL          VARCHAR(30)
   DECLARE @SISTEMA            VARCHAR(30)
   DECLARE @SP                 VARCHAR(50)
   
   DECLARE @DESC_NAVE          VARCHAR(40)
   DECLARE @DISCHARGE_PORT     VARCHAR(10)
   DECLARE @FINAL_DESTINATION  VARCHAR(10)
   DECLARE @INLANDDEPOT        VARCHAR(06)
   DECLARE @CAMPO_PRECINTO     VARCHAR(60)
                                  
   --SET @BOOKINGBL='' /* se obtiene luego */   
   SET @CODIGORET              = 0
   SET @RESULTADO              = ''
   SET @SISTEMA                = 'BALANZA EXPO'                        
   SET @SP                     = 'sp_Eventos_Expo_Envios'   
   SET @iVal                   = 0   
 
   IF LEN(@SCODEVE)=0 OR @SCODEVE IS NULL OR (@SCODEVE!='0900' AND @SCODEVE!='1000')
   BEGIN
	  SET @CODIGORET = 999
	  SET @RESULTADO = 'EL CAMPO SCODEVE NO ES CORRECTO'
	  RETURN
   END
   
   IF LEN(@ITRM)=0 OR @ITRM IS NULL OR (@ITRM!='CO' AND @ITRM!='PAI')
   BEGIN
	  SET @CODIGORET = 999
	  SET @RESULTADO = 'EL CAMPO ITRM NO ES CORRECTO'
	  RETURN
   END
      
   --Insert EVENTOS_LINEAS (navvia11, codcon04, cod_evento, fec_evento, operacion, codarm10)                                                   
   --values (@sCodInt, @sNroCtr, @sCodEve,getdate(),'E',@sCodLin)                                                  
                        
   BEGIN TRY                                               
      select
         @iblq=count(*)
      from
         descarga..TD_OPERACIONES_BLOQUEO_CONTENEDOR
      where
         contenedor=@sNroCtr
         and estado='B'                                                  
   END TRY
   BEGIN CATCH
      SET @CODIGORET = 900
      SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
   END CATCH
   
   if @iblq=0                                                  
   begin
      BEGIN TRY
         select
            @iVal=count(codcon04)
         from
            EVENTOS_LINEAS(nolock)
         where
            navvia11=@sCodInt 
            and codcon04=@sNroCtr 
            and cod_evento=@sCodEve 
            and fec_evento>=dateadd(day,-120,getdate())                               
      END TRY
      BEGIN CATCH
         SET @CODIGORET = 900
         SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
      END CATCH
   
      if @iVal>=0                                                  
      begin                                                                          
         --------- obtiene el navvia y genbkg --------------------------------                                    
         SET @NAVVIA=''                                  
         SET @GENBKG=''                                  
         
         BEGIN TRY         
            select
               top 1 @NAVVIA  = a.NAVVIA11, 
               @GENBKG        = a.genbkg13, 
               @sNroBkg       = Case left(a.nrocon13,2) when 'BO' then '' else a.nrocon13 End,
               @BOOKINGBL     = A.nrocon13,@sObserv=substring(a.nomemb13,1,50)
            from
               descarga..edbookin13 a (nolock), descarga..erconasi17 b (nolock)                                                   
            where
               a.navvia11=@sCodInt
               and a.genbkg13=b.genbkg13
               and b.codcon04=@sNroCtr                                               
            order by
               a.navvia11 desc, 
               a.genbkg13 desc                                                  
         END TRY
         BEGIN CATCH
            SET @CODIGORET = 900
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
         END CATCH
         
         DECLARE @EMB VARCHAR(11)  
         BEGIN TRY
            select
               top 1 @EMB=a.codemc12
            from                                                   
               descarga..edbookin13 a (nolock), 
               descarga..erconasi17 b (nolock)                                                   
            where
               a.navvia11=@sCodInt 
               and a.genbkg13=b.genbkg13 
               and b.codcon04=@sNroCtr                                               
            order by
               a.navvia11 desc,
               a.genbkg13 desc   
         END TRY
         BEGIN CATCH
            SET @CODIGORET = 900
            SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
         END CATCH
         
         --|MODIFICACION PARA QUE NO ENVIE EVENTOS CUANDO EL CLIENTE SEHA DIFERENTE A VIRU, PARA HSD  
         IF LTRIM(RTRIM(@EMB))<>'20373860736' AND LTRIM(RTRIM(@sCodLin))='HSD'  
         BEGIN
            RETURN;  
         END  

         IF NOT (LEN(@NAVVIA)>0 AND LEN(@GENBKG)>0)                                  
         BEGIN
            BEGIN TRY
               select
                  @NAVVIA=NAVVIA11, 
                  @GENBKG=genbkg13,
                  @BOOKINGBL=nrocon13
               from
                  descarga..edbookin13(nolock)
               where
                  genbkg13=@sCodInt
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
         END                                    
         ---------------------------------------------------------------------                               
         --print  'BOOKING: ' + @sNroBkg + ' ..' +@sNroCtr + '.. ' + @sCodInt                                                  
                                           
         if len(@sNroBkg)>0                                                   
         begin
            BEGIN TRY
               select
                  @sCodTam=codtam09, 
                  @sCodTip=codtip05 
               from
                  edconten04 (nolock)
               where
                  codcon04=@sNroCtr
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
            set @sTamTip= @sCodTam+@sCodTip                                                  
                                 
            IF @sCodEve='0900'                        
            BEGIN
               BEGIN TRY
                  select
                     @NRODOC=nroaut14 
                  from
                     edllenad16(nolock)                   
                  where
                     codcon04=@sNroCtr 
                     and genbkg13=@GENBKG 
                     and navvia11=@NAVVIA                        
               END TRY
               BEGIN CATCH
                  SET @CODIGORET = 900
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
               END CATCH                 
               SET @TIPODOC='AUT'                        
            END                        
            ELSE                        
            BEGIN                        
               SET @TIPODOC='TKT'
               BEGIN TRY
                  SELECT
                     @NRODOC=g.nrotkt18                        
                  FROM
                     DRCTRTMC90 a (nolock)                                                            
                     inner join edllenad16 b (nolock) on (a.navvia11=b.navvia11 and a.codcon04=b.codcon04)                        
                     inner join edbookin13 e (nolock) on (b.genbkg13=e.genbkg13 and b.navvia11=e.navvia11)                        
                     inner join ddticket18 g (nolock) on (a.nrotkt28=g.nrotkt18 and a.navvia11=g.navvia11)                        
                  where
                     b.genbkg13=@GENBKG 
                     and b.navvia11=@NAVVIA 
                     and a.codcon04=@sNroCtr
               END TRY
               BEGIN CATCH
                  SET @CODIGORET = 900
                  SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
               END CATCH                  
            END
            --********VALIDACION PARA NO ENVIAR OTRA FECHA A HSD             
            --select top 10 * from edllenad16    
                  
            DECLARE @sFechaCorregida DATETIME              
            IF @sCodLin = 'HSD' and @sCodEve='0900'              
            BEGIN              
               SET @sFechaCorregida = (select
                                          MAX(feclln16) 
                                       from
                                          edllenad16
                                       where
                                          codcon04=@sNroCtr
                                          and navvia11=@NAVVIA
                                          and codemb06='CTR')-- and genbkg13=@GENBKG)
                                          
               IF LEN(ISNULL(CONVERT(VARCHAR,@sFechaCorregida),'')) > 0              
               BEGIN              
                  SET @sFecReg = CONVERT(VARCHAR(8),@sFechaCorregida,112) + ' ' + LEFT(CONVERT(VARCHAR,@sFechaCorregida,108),5)              
               END              
            END

            -- OBTENEMOS @DESC_NAVE
            BEGIN TRY
               select
                  @DESC_NAVE = b.desnav08
               from
                  DDCABMAN11 a
                     inner join DQNAVIER08 b on a.codnav08=b.codnav08
               where
                  navvia11=@NAVVIA
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
            
            -- OBTENEMOS @DISCHARGE_PORT
            BEGIN TRY
               select
                  @DISCHARGE_PORT = b.codsol02
               from
                  descarga..EDBOOKIN13 a
                     inner join descarga..DQPUERTO02 b on a.codpue02 = b.codpue02
               where
                  a.genbkg13 = @GENBKG
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH  
            
            IF (@DISCHARGE_PORT IS NULL)
            BEGIN
               IF(@ITRM='CO')
               BEGIN
                  SET @DISCHARGE_PORT = 'PECLL'
               END
               IF(@ITRM='PAI')
               BEGIN
                  SET @DISCHARGE_PORT = 'PEPAI'
               END
            END
            
            -- OBTENEMOS @FINAL_DESTINATION
            BEGIN TRY
               select
                  @FINAL_DESTINATION = b.codsol02
               from
                  descarga..EDBOOKIN13 a
                     inner join descarga..DQPUERTO02 b on a.codpue13 = b.codpue02
               where
                  a.genbkg13 = @GENBKG
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
         
            IF (@FINAL_DESTINATION IS NULL)
            BEGIN
               IF(@ITRM='CO')
               BEGIN
                  SET @FINAL_DESTINATION = 'PECLL'
               END
               IF(@ITRM='PAI')
               BEGIN
                  SET @FINAL_DESTINATION = 'PEPAI'
               END
            END
            
            --OBTENEMOS @INLANDDEPOT
            IF(@ITRM='CO')
            BEGIN
               SET @INLANDDEPOT = 'NEC'
            END
            IF(@ITRM='PAI')
            BEGIN
               SET @INLANDDEPOT = 'NEP'
            END
            
            -- OBTENEMOS @CAMPO_PRECINTO
            BEGIN TRY
               select
                  @CAMPO_PRECINTO = RTRIM(LTRIM(nropre16))
               from
                  descarga..ERCONASI17
               where
                  genbkg13=@GENBKG 
                  and codcon04=@sNroCtr
            END TRY
            BEGIN CATCH
               SET @CODIGORET = 900
               SET @RESULTADO = 'ERROR_SQL_EXCEPTION: SQL SERVER ERROR, NUMBER : ' + RTRIM(CONVERT(CHAR(10),error_number())) + ' - MESSAGE :' + error_message()
            END CATCH
         
            IF LEN(@sFecReg)>7 AND LEN(@sNroCtr)=11 AND LEN(@sCodEve)>2 AND LEN(@sCodLin)>1                                      
            BEGIN     
               /* ------------------------------------------------------------ */
               /*                      RESULTADO GWC                           */
               /* ------------------------------------------------------------ */
               SET @resultado = @resultado + 'LOCAL=LIMATELEDI2' + ';'
               SET @resultado = @resultado + 'ALEATORIO=' + ';'
               SET @resultado = @resultado + 'OPERA=9' + ';'
               SET @resultado = @resultado + 'COD_VIAJE=' + @NAVVIA +';'
               SET @resultado = @resultado + 'DESC_NAVE=' + @DESC_NAVE +';'
               SET @resultado = @resultado + 'LOCALPUERTO=CLLNE' + ';'
               SET @resultado = @resultado + 'CONDCONT=5' + ';'
               SET @resultado = @resultado + 'BOOKING=' + @GENBKG + ';'
               SET @resultado = @resultado + 'DISCHARGE_PORT='+ @DISCHARGE_PORT + ';'
               SET @resultado = @resultado + 'FINAL_DESTINATION=' + @FINAL_DESTINATION + ';'
               SET @resultado = @resultado + 'INLANDDEPOT=' + @INLANDDEPOT + ';'
               SET @resultado = @resultado + 'CAMPO_PRECINTO=' + @CAMPO_PRECINTO + ';'
               SET @resultado = @resultado + 'PESO_CRT=' + CONVERT(varchar(15),@dPesCtr) + ';'
            END               
         end
         ELSE
         BEGIN
            SET @CODIGORET = 999
            SET @RESULTADO = 'NO EXISTE BOOKING PARA LOS DATOS INGRESADOS'
            RETURN
         END         
      end                                            
   end
   ELSE
   BEGIN
      SET @CODIGORET = 999
      SET @RESULTADO = 'EL CONTENEDOR INDICADO SE ENCUENTRA BLOQUEADO'
   END        
   SET NOCOUNT OFF
END
/*
DECLARE @CODIGORET     INT 
DECLARE @RESULTADO     VARCHAR(8000)

EXECUTE usp_gwc_prepara_datos_eventos '0900','MSC','000023','CONTENEDOR','2016-06-06',40000,'CO',@CODIGORET OUTPUT, @RESULTADO OUTPUT
   
PRINT @CODIGORET
PRINT @RESULTADO
*/
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPO_CITAPWD_OBTENERCITAS]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_IMPO_CITAPWD_OBTENERCITAS] @FECHA VARCHAR(25)
AS
BEGIN
	SET @FECHA = LTRIM(RTRIM(@FECHA))

	SELECT numcita00
		,numdoc = CASE 
			WHEN numdoc00 NOT IN (
					'3033'
					,'3105'
					)
				THEN ISNULL(ctr00, '')
			ELSE ISNULL(numdoc00, '')
			END
		,feccita00
	FROM Terminal.dbo.DDCTASDPWIMPO00 WITH (NOLOCK)
	WHERE datediff(minute,feccita00,getdate()) <= 720
		AND ISNULL(estadoenvio00, '') = 'R'
	ORDER BY feccita00 ASC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPO_CITAPWD_VALIDAR_NAVEVIAJE]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_IMPO_CITAPWD_VALIDAR_NAVEVIAJE] @NAVVIA VARCHAR(6)
AS
BEGIN
	IF EXISTS (
			SELECT NAVVIA11
			FROM DDCABMAN11 WITH (NOLOCK)
			WHERE NAVVIA11 = @NAVVIA
			)
	BEGIN
		IF EXISTS (
				SELECT NAVVIA11
				FROM DDCABMAN11 WITH (NOLOCK)
				WHERE NAVVIA11 = @NAVVIA
					AND TIPOPE11 = 'D'
				)
		BEGIN
			--SELECT '1' AS dpw
			SELECT '0' AS dpw
		END
		ELSE
		BEGIN
			SELECT '0' AS dpw
		END
	END
	ELSE
	BEGIN
		SELECT '0' AS dpw
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPO_CITAPWD_VALIDAUSODECITA]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_IMPO_CITAPWD_VALIDAUSODECITA]
@NUMCITA VARCHAR(15)
AS
BEGIN
	SET @NUMCITA = LTRIM(RTRIM(@NUMCITA))
	
	SELECT numcita00
	FROM Terminal.dbo.DDCTASDPWIMPO00 WITH (NOLOCK)
	WHERE numcita00 = @NUMCITA
	AND ISNULL(estadoenvio00,'') = 'R'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_DATA_EVENTO_0900_MSC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--grant all on USP_OBTENER_DATA_EVENTO_0900_MSC to public
ALTER PROCEDURE [dbo].[USP_OBTENER_DATA_EVENTO_0900_MSC]  
@nrotkt VARCHAR(8),  
@splaca VARCHAR(8),  
@txtembala VARCHAR(5),  
@sCtr VARCHAR(11),  
@opcion varchar(1)  
AS  
BEGIN  
	
	SET @nrotkt = LTRIM(RTRIM(@nrotkt))
	SET @splaca = LTRIM(RTRIM(@splaca))
	SET @txtembala = LTRIM(RTRIM(@txtembala))
	SET @sCtr = LTRIM(RTRIM(@sCtr))
	
	IF @opcion = '0'
	BEGIN
		SELECT '1' AS mensaje
		RETURN;
	END
	
	IF @opcion = '1'
	BEGIN
		DECLARE @CODARM VARCHAR(3)  
		SELECT  @CODARM = LTRIM(RTRIM(codarm10))  
		FROM EDCONTEN04 WITH (NOLOCK)  
		WHERE codcon04 = @sCtr  
   
		SELECT 'HSD' AS linea,  
		@txtembala as codemb,  
		'000000' as navvia,  
		@sCtr as ctr  
		RETURN;
	END
	
	IF @opcion = '2'
	BEGIN
		DECLARE @CODLINEA VARCHAR(3), @NAVVIA11 VARCHAR(6)
		SELECT DISTINCT @CODLINEA = C.codarm10 , @NAVVIA11 = C.navvia11
		FROM DDTICKET18 A WITH (NOLOCK)
		INNER JOIN Descarga..EDAUTING14 B WITH (NOLOCK) ON A.nroaut14 = B.nroaut14
		INNER JOIN Descarga..EDBOOKIN13 C WITH (NOLOCK) ON C.genbkg13 = B.genbkg13
		WHERE nrotkt18 = @nrotkt
		
		SELECT @CODLINEA AS linea,  
		@txtembala as codemb,  
		@NAVVIA11 as navvia,  
		@sCtr as ctr  
		RETURN;
	END	
 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_DATOSGUIA_065]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_OBTENER_DATOSGUIA_065] 
@NROGUI VARCHAR(10)
AS
BEGIN
	declare @ctr varchar(11)
	declare @ructra varchar(11)
	declare @direccion varchar(100)
	
	select @ctr = b.codcon04 , @ructra = a.ructra19
	from DDGUITPC19 a with (nolock)
	inner join DRGUITPC20 b with (nolock) on a.nrogui19 = b.nrogui19
	where a.nrogui19 = @NROGUI
	
	select @direccion = DIRECCION
	from AATRANSP05 with (nolock)
	where contribuy = @ructra
	
	Select top 1 pesoctr=sum(b.pesmer16),                      
	a.codbol03,a.codtam09,b.navvia11,c.feclle11,b.genbkg13,b.codemb06,          
	a.nrotar04,              
	case when (b.nropre16='' or b.nropre16 is null) then b.preadu16 else b.nropre16 end preadu16,        
	b.oemadu16,d.codaut17, e.conten13, e.codpue02, a.codarm10, d.carta, d.flgreefer, e.codTipReefer,  
	d.fecVenCarta 
	,@direccion as direccion      
	from DESCARGA..edconten04 a (nolock), DESCARGA..edllenad16 b (nolock),           
	DESCARGA..ddcabman11 c (nolock), DESCARGA..erconasi17 d (nolock), DESCARGA..edbookin13 e (nolock)           
	where a.codcon04 = b.codcon04 and b.codcon04 = @ctr          
	and b.navvia11=c.navvia11 and a.codcon04=d.codcon04           
	and b.codcon04=d.codcon04 and d.genbkg13=e.genbkg13           
	and b.genbkg13=e.genbkg13 and b.genbkg13=d.genbkg13           
	and b.navvia11=e.navvia11 and c.navvia11=e.navvia11              
	group by a.codbol03,a.codtam09,b.navvia11,c.feclle11,b.genbkg13,b.codemb06,            
	a.nrotar04,b.nropre16,b.preadu16,b.oemadu16,d.codaut17,e.conten13, e.codpue02, a.codarm10,    
	d.carta, d.flgreefer, e.codTipReefer, d.fecVenCarta  
	order by c.feclle11 desc  
	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_URLGWC]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_URLGWC]
@viTIPO VARCHAR(50)
,@viIP VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;
	SET @viIP = LTRIM(RTRIM(@viIP))
	SET @viTIPO = LTRIM(RTRIM(@viTIPO))
	
	EXEC Descarga..USP_OBTENER_URLGWC @viTIPO,@viIP
	
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerCitaDPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerCitaDPW]      
@CTR VARCHAR(11),      
@NAVVIA VARCHAR(6)      
AS      
BEGIN      
SET NOCOUNT ON;      
  SET @CTR = LTRIM(RTRIM(@CTR))      
  SET @NAVVIA = LTRIM(RTRIM(@NAVVIA))      
        
  select top 1 b.numcita      
  from Descarga..edbookin13 a with (nolock)      
  inner join Descarga..ERCONASI17 b with (nolock) on a.genbkg13 = b.genbkg13     
  inner join Descarga..edllenad16 c with (nolock) on c.navvia11 = a.navvia11 and c.codcon04 = b.codcon04   
  where b.codcon04 = @CTR      
  and a.navvia11 = @NAVVIA
  and isnull(b.numcita,'')<> ''      
  order by c.feclln16 desc  
SET NOCOUNT OFF;      
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerFechaCitaDPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerFechaCitaDPW]      
@CTR VARCHAR(11),      
@NAVVIA VARCHAR(6)      
AS      
BEGIN      
SET NOCOUNT ON;      
  SET @CTR = LTRIM(RTRIM(@CTR))      
  SET @NAVVIA = LTRIM(RTRIM(@NAVVIA))      
        
  select top 1 b.feccita      
  from Descarga..edbookin13 a with (nolock)      
  inner join Descarga..ERCONASI17 b with (nolock) on a.genbkg13 = b.genbkg13     
  inner join Descarga..edllenad16 c with (nolock) on c.navvia11 = a.navvia11 and c.codcon04 = b.codcon04   
  where b.codcon04 = @CTR      
  and a.navvia11 = @NAVVIA 
  and isnull(b.numcita,'')<> ''       
  order by c.feclln16 desc  
SET NOCOUNT OFF;      
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_ObtenerNroAutorizacionAPM]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ObtenerNroAutorizacionAPM] @CTR VARCHAR(11)
	,@NAVVIA VARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;
	SET @CTR = LTRIM(RTRIM(@CTR))
	SET @NAVVIA = LTRIM(RTRIM(@NAVVIA))

	SELECT TOP 1 b.NumAutAPM17, numcita = ISNULL(b.NumAutAPM17,'')
	FROM Descarga..edbookin13 a WITH (NOLOCK)
	INNER JOIN Descarga..ERCONASI17 b WITH (NOLOCK) ON a.genbkg13 = b.genbkg13
	INNER JOIN Descarga..edllenad16 c WITH (NOLOCK) ON c.navvia11 = a.navvia11
		AND c.codcon04 = b.codcon04
	WHERE b.codcon04 = @CTR
		AND a.navvia11 = @NAVVIA
		AND isnull(b.NumAutAPM17, '') <> ''
	ORDER BY c.feclln16 DESC

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REGISTRA_TRANS_DPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_REGISTRA_TRANS_DPW]
@viUserDPW varchar(50),
@viPassDPW varchar(50),
@viNumCita varchar(15),
@viCtr varchar(11),
@viIsoCode varchar(15),
@viPlaca varchar(10),
@viDNI varchar(10),
@viRucEmp varchar(11),
@viPreAdu varchar(200),
@viPrec1 varchar(200),
@viPrec2 varchar(200),
@viPrec3 varchar(200),
@viPesTar varchar(25),
@viPesNet varchar(25),
@viUser varchar(35),
@viIP varchar(25),
@viError varchar(2000),
@viNavvia varchar(6)
AS
BEGIN
	INSERT INTO USP_LOG_SERVICE_DPW
	VALUES(@viUserDPW,@viPassDPW,@viNumCita,@viCtr,@viIsoCode,@viPlaca,@viDNI,@viRucEmp,@viPreAdu,@viPrec1,@viPrec2,@viPrec3,
	@viPesTar,@viPesNet,@viUser,@viIP,GETDATE(),@viError,@viNavvia)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_CAMIONAJE_EMBARQUE_EXPO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REPORT_CAMIONAJE_EMBARQUE_EXPO]
AS
BEGIN
SELECT *
FROM
	(
		select
		b.nrotkt18 AS TICKET,
		a.codcon04 AS CONTENEDOR,
		b.nropla18 AS PLACA,
		b.fecing18 AS FECHA,
		'Ingreso Embarque Expo' AS TIPO_MOV
		from DRCTRTMC90 a WITH (NOLOCK)
		inner join DDTICKET18 b WITH (NOLOCK) on a.nrotkt28=b.nrotkt18
		where b.fecsal18>=CONVERT(VARCHAR(8),DATEADD(MONTH,-2,GETDATE()),112)
		and b.fecsal18<CONVERT(VARCHAR(8),DATEADD(D,1,GETDATE()),112)
		and b.tipope18='T'
		union
		select
		b.nrotkt18 AS TICKET,
		a.codcon04 AS CONTENEDOR,
		b.nropla18 AS PLACA,
		b.fecsal18 AS FECHA,
		'Salida Embarque Expo' AS TIPO_MOV
		from DRCTRTMC90 a WITH (NOLOCK)
		inner join DDTICKET18 b WITH (NOLOCK) on a.nrotkt28=b.nrotkt18
		where b.fecsal18>=CONVERT(VARCHAR(8),DATEADD(MONTH,-2,GETDATE()),112)
		and b.fecsal18<CONVERT(VARCHAR(8),DATEADD(D,1,GETDATE()),112)
		and b.tipope18='T'
	) DATO
ORDER BY DATO.TICKET,DATO.CONTENEDOR,DATO.FECHA ASC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_MERCADERIA_ING_EXPO]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REPORT_MERCADERIA_ING_EXPO]        
@FECINI VARCHAR(8),        
@SUCURSAL VARCHAR(1)        
AS        
BEGIN     
     
 DECLARE @SUCURSAL_NEW VARCHAR(10)    
 IF @SUCURSAL = '3'    
 BEGIN    
 SET @SUCURSAL_NEW = '1'    
 END    
 ELSE    
 BEGIN    
 SET @SUCURSAL_NEW = @SUCURSAL    
 END    
     
 SET @SUCURSAL_NEW = LTRIM(RTRIM(@SUCURSAL_NEW))    
        
 SELECT DISTINCT         
 LTRIM(RTRIM(e.desnav08 )) AS NAVE,        
 D.numvia11 AS VIAJE,        
 a.nrotkt18 AS NRO_TICKET,         
 a.nropla18 AS NRO_PLACA,         
 b.codcon14 AS CTR,         
 a.pesnet18 AS PESO_NETO,         
 a.fecing18 AS FECHA_INGRESO,        
 CASE WHEN a.status18='S'        
   THEN 'CONTENEDOR CON SALIDA'        
   ELSE 'CONTENEDOR SIN SALIDA'        
   END STATUS_DESTARE,         
 a.fecsal18 AS FECHA_SALIDA,        
 a.codemb06 AS TIPO_EMB,         
 a.buling18 AS CNT_BULTOS,         
 b.codage19 AS COD_AGENTE,        
 b.conten13 AS CONTENIDO,         
 c.codtam09 AS TAMAÑO,         
 b.nroaut14 AS NRO_AUTORIZACION,      
 CASE WHEN f.flglln16 = '0' THEN 'SE LLENO'       
   WHEN f.flglln16 = '1' THEN 'VINO LLENO'               
   WHEN f.flglln16 = '2' THEN 'LLENO EMBARC.'      
   WHEN f.flglln16 IS null THEN 'AUN NO TIENE LLENADO'      
   END AS TIPO_LLENADO      
 From         
 DDTICKET18 a with (nolock)        
 inner join EDAUTING14 b with (nolock) on a.nroaut14 = b.nroaut14         
 inner join EDCONTEN04 c with (nolock) on b.codcon14 = c.codcon04         
 inner join DDCABMAN11 d with (nolock) on d.navvia11 = b.navvia11        
 inner join DQNAVIER08 e with (nolock) on e.codnav08 = d.codnav08       
 left join EDLLENAD16 f with (nolock) on f.nroaut14=b.nroaut14 and b.navvia11=f.navvia11 and b.codcon14=f.codcon04       
 Where         
 a.navvia11 = b.navvia11         
 AND a.fecing18 >= @FECINI        
 AND a.fecing18 < CONVERT(VARCHAR,(DATEADD(DAY,1,GETDATE())),112)        
 AND a.tipope18 = 'E'         
 --AND a.status18 = 'S'         
 AND (b.sucursal = @SUCURSAL OR b.sucursal = @SUCURSAL_NEW )  
 AND (a.codemb06 in ('CTR')  OR isnull(a.codemb06 ,'')='')  
 ORDER BY a.fecing18 ASC      
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_VGM]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_REPORT_VGM]
@EMBARCADOR VARCHAR(11),
@FECINICIO VARCHAR(8)
AS
BEGIN
	select 
	d.codarm10 as LINEA,DD.desnav08 as NAVE,cc.numvia11 as VIAJE,a.codcon04 as CTR,
	--a.pesnet18 as PESO_VGM,
	o.bkgcom13 as BOOKING_COMPLETO,cc.feclle11 as ETA
	from DDTICKET18 a
	inner join descarga..EDAUTING14 b on a.nroaut14 = b.nroaut14
	inner join Descarga..EDLLENAD16 c on c.nroaut14 = b.nroaut14
	inner join Descarga..EDCONTEN04 d on d.codcon04=a.codcon04
	inner join Descarga..edbookin13 o on o.genbkg13=b.genbkg13
	LEFT JOIN descarga..DRCTRTMC90 p on p.codcon04 = a.codcon04
	left join DDTICKET18 pp on pp.nrotkt18 = p.nrotkt28 and a.navvia11=pp.navvia11
	inner join Descarga..DDCABMAN11 cc on cc.navvia11 = a.navvia11
	INNER JOIN Descarga..DQNAVIER08 DD ON DD.codnav08=cc.codnav08
	where 
	cc.feclle11>=@FECINICIO
	and p.codcon04 is null
	AND o.codemc12=@EMBARCADOR
	order by cc.feclle11 desc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_RESPOT_PASSINICIALES]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_RESPOT_PASSINICIALES] @FECHAINICIO VARCHAR(8)
	,@FECHAFIN VARCHAR(8)
	,@RUC VARCHAR(11)
	,@OPCION VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET @FECHAINICIO = LTRIM(RTRIM(@FECHAINICIO))
	SET @FECHAFIN = LTRIM(RTRIM(@FECHAFIN))

	DECLARE @MENSAJE VARCHAR(250)

	SET @MENSAJE = ''

	SELECT A.nrotkt18 AS NRO_TICKET
		,A.nroaut14 AS NRO_AUTORIZACION
		,A.nropla18 AS PLACA
		,A.codcon04 AS CONTENEDOR
		,A.fecing18 AS FECHAINGRESO
		,A.fecsal18 AS FECHASALIDA
		,A.pesbrt18 AS PESOBRUTO_FINAL
		,A.pestar18 AS PESOTARA_FINAL
		,A.pesnet18 AS PESONETO_FINAL
		,BB.ID
	INTO #TICKET
	FROM DDTICKET18 A WITH (NOLOCK)
	INNER JOIN (
		SELECT min(B.nrocambio) AS ID
			,B.ticket
		FROM DBPASSPE98 B WITH (NOLOCK)
		GROUP BY B.ticket
		) BB ON BB.ticket = A.nrotkt18
	WHERE A.fecing18 >= @FECHAINICIO
		AND A.fecing18 <= @FECHAFIN
		--|SOLO INGRESO DE CONTENEDORES A EXPORTAR  
		AND A.codcon04 IS NOT NULL
		AND A.fecsal18 IS NOT NULL
		AND A.codemb06 = 'CTR'

	SELECT LTRIM(RTRIM(ISNULL(E.NOMBRE, ''))) AS CLIENTE
		,A.NRO_TICKET
		,A.NRO_AUTORIZACION
		,A.PLACA
		,A.CONTENEDOR
		,A.FECHAINGRESO
		,A.FECHASALIDA
		--|PRIMER PESAJE  
		,C.pbanterior AS PESOBRUTO_INICIO
		,C.ptanterior AS PESOTARA_INICIO
		,C.pnanterior AS PESONETO_ANTERIOR
		--|ULTIMO PESAJE  
		,A.PESOBRUTO_FINAL
		,A.PESOTARA_FINAL
		,A.PESONETO_FINAL
	INTO #TOTAL
	FROM #TICKET A
	INNER JOIN DBPASSPE98 C WITH (NOLOCK) ON C.nrocambio = A.ID
	INNER JOIN EDAUTING14 D WITH (NOLOCK) ON D.nroaut14 = A.NRO_AUTORIZACION
	LEFT JOIN AACLIENTESAA E WITH (NOLOCK) ON E.CONTRIBUY = D.codemc12
	WHERE D.codemc12 LIKE '%' + @RUC + '%'

	DROP TABLE #TICKET

	IF @OPCION = '0'
	BEGIN
		IF NOT EXISTS (
				SELECT *
				FROM #TOTAL
				)
		BEGIN
			SET @MENSAJE = 'No existen Datos con el Criterio a Buscar'

			SELECT @MENSAJE AS 'mensaje'
		END
		ELSE
		BEGIN
			SELECT @MENSAJE AS 'mensaje'
		END
	END

	IF @OPCION = '1'
	BEGIN
		SELECT *
		FROM #TOTAL
	END

	DROP TABLE #TOTAL

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_RESULTADO_DPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_RESULTADO_DPW]
@RESUL VARCHAR(3)
AS
BEGIN
SET NOCOUNT ON;
	SET @RESUL = LTRIM(RTRIM(@RESUL))
	SELECT LTRIM(RTRIM(descripcion)) AS descripcion
	FROM DDDESCDPW00 WHERE codigo = @RESUL
SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SEND_VGM]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_SEND_VGM] @NAVVIA VARCHAR(11)
	,@GENBKG13 VARCHAR(6)
	,@BKGCOM VARCHAR(35)
	,@CTR VARCHAR(11)
	,@PESOVGM DECIMAL(15, 3)
	,@CODEMC VARCHAR(11)
	,@RUCAGE19 VARCHAR(11)
	,@tipoenvio VARCHAR(1)
	,@CONSOLIDADOR VARCHAR(11)
AS
BEGIN
	DECLARE @FECHA VARCHAR(35)
		,@EMBARCADOR VARCHAR(100)
		,@AGENCIA VARCHAR(100)
		,@TO1 VARCHAR(100)
		,@CC1 VARCHAR(100)
		,@FLGENVIO VARCHAR(1)
	
	RETURN;
	
	SET @FLGENVIO = '0'

	SELECT @EMBARCADOR = LTRIM(RTRIM(NOMBRE))
	FROM Descarga..AACLIENTESAA WITH (NOLOCK)
	WHERE CONTRIBUY = @CODEMC

	SELECT @AGENCIA = LTRIM(RTRIM(NOMBRE))
	FROM Descarga..AACLIENTESAA WITH (NOLOCK)
	WHERE CONTRIBUY = @RUCAGE19

	SELECT @FECHA = SUBSTRING(CONVERT(VARCHAR, GETDATE(), 113), 1, (LEN(CONVERT(VARCHAR, GETDATE(), 113)) - 7))

	SET @FECHA = LTRIM(RTRIM(@FECHA))

	DECLARE @BODY VARCHAR(MAX)

	SET @BODY = ''
	SET @BODY = @BODY + '<html>                        
      <body>                        
      <p style="font-family: Calibri; vertical-align: middle;">Estimado Cliente: '
	SET @BODY = @BODY + ISNULL(@AGENCIA, '') + '<br />'
	SET @BODY = @BODY + 'Por medio de la presente informamos       
      que se ha efectuado un Peso VGM con la siguiente Informacion: <br /><br />'
	SET @BODY = @BODY + 'Número de Contenedor: ' + ISNULL(@CTR, '') + '<br />'
	SET @BODY = @BODY + 'Número de Booking: ' + ISNULL(@BKGCOM, '') + '<br />'
	SET @BODY = @BODY + 'Peso VGM (KG): ' + CAST(ISNULL(@PESOVGM, 0) AS VARCHAR) + '<br />'
	SET @BODY = @BODY + 'Fecha y Hora de peso: ' + ISNULL(@FECHA, '') + '<br />'
	SET @BODY = @BODY + 'Embarcador: ' + ISNULL(@EMBARCADOR, '') + '<br /></p>'
	SET @BODY = @BODY + '<p style="font-family: Calibri; vertical-align: middle;">Atte. <br /> NEPTUNIA S.A.</p>'

	--PRINT @BODY            
	--|AGENCIA: Agencia de Aduana Transoceanic      
	IF @tipoenvio = '1'
		AND @RUCAGE19 = '20101409199'
	BEGIN
		SET @FLGENVIO = '1'
		SET @TO1 = 'recepción_vgm@agenciatransoceanic.com'
		SET @CC1 = 'franklin.milla@neptunia.com.pe'
	END

	IF @FLGENVIO = '1'
	BEGIN
		--PRINT 'ENVIANDO CORREO'      
		DECLARE @rc INT

		EXECUTE @rc = master.dbo.xp_smtp_sendmail @FROM = 'aneptunia@neptunia.com.pe'
			,@TO = @TO1
			,@CC = @CC1
			,@BCC = ''
			,@message = @BODY
			,@subject = 'Información VGM - NEPTUNIA S.A.'
			,@priority = 'HIGH'
			,@type = 'text/html'
			,@server = 'correo.neptunia.com.pe'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SENDMAILDELTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[USP_SENDMAILDELTICKET] (
	@TIPOPER VARCHAR(1)
	,@NROTKT18 VARCHAR(255)
	)
AS
BEGIN
	----------------//                      
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER ON;
	----------------//                      
	SET NOCOUNT ON;

	--|        
	DECLARE @CODEMCVGM VARCHAR(11)
		,@CTRVGM VARCHAR(11)
		,@BOOKINVGM VARCHAR(25)
	DECLARE @PESONETOVGM DECIMAL(12, 3)

	SET @CODEMCVGM = ''
	SET @NROTKT18 = LTRIM(RTRIM(@NROTKT18))

	IF @TIPOPER = 'M'
	BEGIN
		SELECT @CODEMCVGM = ISNULL(C.codemc12, '')
			,@PESONETOVGM = A.pesnet18
			,@CTRVGM = B.codcon14
			,@BOOKINVGM = LTRIM(RTRIM(ISNULL(C.bkgcom13, '')))
		FROM DDTICKET18 A WITH (NOLOCK)
		INNER JOIN Descarga..EDAUTING14 B WITH (NOLOCK) ON B.nroaut14 = A.nroaut14
		INNER JOIN Descarga..EDBOOKIN13 C WITH (NOLOCK) ON C.genbkg13 = B.genbkg13
		WHERE nrotkt18 = @NROTKT18
			AND A.fecsal18 IS NOT NULL
			AND A.pestar18 > 0
			AND A.codemb06 = 'CTR'

		IF @CODEMCVGM <> ''
		BEGIN
			EXEC EnvioLineas.DBO.USP_UPDATE_PESOVGM_FC @CODEMCVGM
				,@CTRVGM
				,@PESONETOVGM
				,@BOOKINVGM
		END
	END

	DECLARE @vFrom VARCHAR(255)
		,@vFromName VARCHAR(255)
		,@vTo VARCHAR(255)
		,@vCc VARCHAR(255)
		,@vPriority VARCHAR(255)
		,@vSubject VARCHAR(200)
		,@vTipoOper VARCHAR(200)
		,@vMessage VARCHAR(MAX)
		,@vMessage2 VARCHAR(MAX)
		,@vMessage3 VARCHAR(MAX)
		,@vMsgTit VARCHAR(255);
	--|                    
	DECLARE @DesNav VARCHAR(255)
		,@NumVia VARCHAR(255);
	--|                    
	DECLARE @NROTICKET VARCHAR(255)
		,@PESOBRUTO VARCHAR(255)
		,@PESOTARA VARCHAR(255)
		,@PESONETO VARCHAR(255)
		,@EMBALAJE VARCHAR(255)
		,@OPERACION VARCHAR(255)
		,@PLACA VARCHAR(255)
		,@NAVE VARCHAR(255)
		,@VIAJE VARCHAR(255)
		,@MANIFIESTO VARCHAR(255)
		,@CONTENEDOR VARCHAR(255)
		,@FECHA VARCHAR(255);
	--|                    
	DECLARE @CONT INT
		,@CANT INT;
	--|                    
	DECLARE @PBA VARCHAR(255)
		,@PTA VARCHAR(255)
		,@PNA VARCHAR(255)
		,@USA VARCHAR(255);
	--|                    
	DECLARE @PBN VARCHAR(255)
		,@PTN VARCHAR(255)
		,@PNN VARCHAR(255)
		,@USN VARCHAR(255);
	--|                    
	DECLARE @NewPass VARCHAR(255);
	--|                    
	DECLARE @Horas INT;
	DECLARE @EX INT;

	SET @vMessage = ''

	--|                    
	SELECT @NROTICKET = CONVERT(VARCHAR, TKT.NROTKT18)
		,@PESOBRUTO = CONVERT(VARCHAR, TKT.PESBRT18)
		,@PESOTARA = CONVERT(VARCHAR, TKT.PESTAR18)
		,@PESONETO = CONVERT(VARCHAR, TKT.PESNET18)
		,@EMBALAJE = CONVERT(VARCHAR, ISNULL(TKT.CODEMB06, ''))
		,@OPERACION = CONVERT(VARCHAR, TKT.TIPOPE18)
		,@PLACA = CONVERT(VARCHAR, TKT.NROPLA18)
		,@CONTENEDOR = CONVERT(VARCHAR, TKT.CODCON04)
		-------------                    
		,@NAVE = CONVERT(VARCHAR, NVJ.DESNAVIA)
		,@VIAJE = CONVERT(VARCHAR, NVJ.VIAJE)
		,@MANIFIESTO = CONVERT(VARCHAR, NVJ.NUMMAN11)
	FROM dbo.DDTICKET18 AS TKT WITH (NOLOCK)
	INNER JOIN (
		SELECT DESNAVIA = N.CODNAV08 + '  |  ' + N.DESNAV08
			,VIAJE = V.NUMVIA11
			,NAVVIA11 = V.NAVVIA11
			,NUMMAN11 = V.NUMMAN11
		FROM dbo.DQNAVIER08 AS N WITH (NOLOCK)
		INNER JOIN dbo.DDCABMAN11 AS V WITH (NOLOCK) ON N.CODNAV08 = V.CODNAV08
		) AS NVJ ON TKT.NAVVIA11 = NVJ.NAVVIA11
	WHERE 1 = 1
		AND TKT.NROTKT18 = @NROTKT18

	--|         
	IF @TIPOPER = 'M'
	BEGIN
		SELECT @NewPass = CONVERT(VARCHAR, [PASSWORD])
		FROM dbo.DBPASSTE99 WITH (NOLOCK)
		WHERE TIPOPER = @TIPOPER;
	END
	ELSE
	BEGIN
		SELECT @NewPass = CONVERT(VARCHAR, [PASSWORD])
		FROM dbo.DBPASSTE99 WITH (NOLOCK)
		WHERE TIPOPER = 'E';
	END

	--|                    
	SET @vSubject = N'ALERTA NEPTUNIA || GOP EXPORTACION || BALANZA || TICKET ELIMINADO - NUEVO PASSWORD ';
	SET @vFrom = N'aneptunia@neptunia.com.pe';
	SET @vFromName = N'TIForwarders';
	--SET @vTo = N'yovany.pena@neptunia.com.pe;eyder.hidalgo@neptunia.com.pe;omar.paucarmaita@neptunia.com.pe;simeon.ordonez@neptunia.com.pe;ysidro.more@neptunia.com.pe;javier.caceres@neptunia.com.pe;cesar.gavidia@neptunia.com.pe';  
	SET @vTo = N'catalina.bringas@neptunia.com.pe';
	--SET @vTo  = N'marvin.zambrano@neptunia.com.pe';                      
	SET @vCc = N'franklin.milla@neptunia.com.pe';
	SET @vPriority = N'HIGH';
	--|                    
	--|                    
	SET @Horas = CONVERT(INT, SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2));
	SET @vMessage = N'Estimados, ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';

	--|                    
	IF (
			@Horas > 0
			AND @Horas < 12
			)
	BEGIN
		SET @vMessage = @vMessage + N'Buenos días, ';
	END;

	IF (
			@Horas > 11
			AND @Horas < 19
			)
	BEGIN
		SET @vMessage = @vMessage + N'Buenas tardes, ';
	END;

	IF (
			@Horas > 18
			AND @Horas < 24
			)
	BEGIN
		SET @vMessage = @vMessage + N'Buenas noches, ';
	END;

	IF (@Horas = 0)
	BEGIN
		SET @vMessage = @vMessage + N'Buenas noches, ';
	END;

	----------------------------------------------------------------------------------------                    
	SET @vTipoOper = 'eliminación';

	--                    
	IF (@TIPOPER = 'E')
	BEGIN
		SET @vSubject = N'ALERTA NEPTUNIA || GOP EXPORTACION || BALANZA || TICKET ELIMINADO - NUEVO PASSWORD ';
		SET @vTipoOper = 'eliminación';
		SET @NROTICKET = @NROTKT18

		DECLARE @NAV VARCHAR(6)

		SELECT @NAV = LEFT(regupd00, 6)
			,@CONTENEDOR = codcon04
			,@OPERACION = tipope18
		FROM TKTAUDIT00 WITH (NOLOCK)
		WHERE nrotkt18 = @NROTICKET
			AND nomtab00 = 'DDTICKET18'
			AND tipope00 = 'E'

		SELECT @VIAJE = ISNULL(A.numvia11, '')
			,@NAVE = ISNULL(LTRIM(RTRIM(b.desnav08)), '')
		FROM DDCABMAN11 A
		INNER JOIN DQNAVIER08 b ON A.codnav08 = b.codnav08
		WHERE A.navvia11 = @NAV
	END;

	IF (@TIPOPER = 'M')
	BEGIN
		SET @vSubject = N'ALERTA NEPTUNIA || GOP EXPORTACION || BALANZA || TICKET MODIFICADO - NUEVO PASSWORD ';
		SET @vTipoOper = 'modificacíon';
	END;

	----------------------------------------------------------------------------------------                        
	SET @vMessage = @vMessage + N'se ha realizado una ' + @vTipoOper + ' de Ticket :' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
	--                    
	SET @vMessage = @vMessage + N' 1. Informacion del Ticket : ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
	--|                    
	SET @vMessage = @vMessage + N' - Ticket  : ' + ISNULL(UPPER(@NROTICKET), '') + CHAR(13) + CHAR(10);
	-- SET @vMessage = @vMessage + N' - Fecha  : ' + CONVERT(VARCHAR,GETDATE(),103) + CHAR(13) + CHAR(10);                      
	SET @vMessage = @vMessage + N' - Nave   : ' + ISNULL(UPPER(@NAVE), '') + CHAR(13) + CHAR(10);
	SET @vMessage = @vMessage + N' - Viaje   : ' + ISNULL(UPPER(@VIAJE), '') + CHAR(13) + CHAR(10);
	SET @vMessage = @vMessage + N' - Contenedor  : ' + ISNULL(UPPER(@CONTENEDOR), '') + CHAR(13) + CHAR(10);
	-- SET @vMessage = @vMessage + N' - Manifiesto  : ' + UPPER(@MANIFIESTO) + CHAR(13) + CHAR(10);                    
	SET @vMessage = @vMessage + N' - Operacion  : ' + ISNULL(UPPER(@OPERACION), '') + CHAR(13) + CHAR(10);
	-- SET @vMessage = @vMessage + N' - Embalaje  : ' + UPPER(@EMBALAJE) + CHAR(13) + CHAR(10);                    
	-- SET @vMessage = @vMessage + N' - Placa   : ' + UPPER(@PLACA) + CHAR(13) + CHAR(10);                     
	--|          
	/*                    
 IF (@TIPOPER = 'E')                    
  BEGIN                    
   SET @vMessage = @vMessage + N' - Peso Bruto  : ' + ISNULL(UPPER(@PESOBRUTO),0) + CHAR(13) + CHAR(10);                    
   SET @vMessage = @vMessage + N' - Peso Tara  : ' + ISNULL(UPPER(@PESOTARA),0) + CHAR(13) + CHAR(10);                    
   SET @vMessage = @vMessage + N' - Peso Neto  : ' + ISNULL(UPPER(@PESONETO),0) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';                    
  END;          
 */
	--|                    
	SET @vMessage = @vMessage + N'' + CHAR(13) + CHAR(10) + '';

	--|                    
	IF (@TIPOPER = 'M')
	BEGIN
		--|                    
		SELECT NRO = ROW_NUMBER() OVER (
				ORDER BY P.NROCAMBIO DESC
				)
			,PBANTERIOR = P.PBANTERIOR
			,PTANTERIOR = P.PTANTERIOR
			,PNANTERIOR = P.PNANTERIOR
			,PBNUEVO = P.PBNUEVO
			,PTNUEVO = P.PTNUEVO
			,PNNUEVO = P.PNNUEVO
			,USUARIO = P.USUARIO
			,FECHA = P.FECHA
		INTO #TEMP
		FROM dbo.DBPASSPE98 AS P WITH (NOLOCK)
		WHERE TICKET = @NROTKT18
		ORDER BY P.NROCAMBIO DESC;

		--                    
		--select * from #TEMP                    
		--|                    
		SET @CONT = 1;

		--|                    
		SELECT @CANT = COUNT(*)
		FROM #TEMP

		--|                    
		--| ULTIMA MODIFICACION                    
		SELECT @PBN = CONVERT(VARCHAR, T.PBNUEVO)
			,@PTN = CONVERT(VARCHAR, T.PTNUEVO)
			,@PNN = CONVERT(VARCHAR, T.PNNUEVO)
			,@USN = CONVERT(VARCHAR, T.USUARIO)
			,@FECHA = CONVERT(VARCHAR, T.FECHA, 103)
			,@PBA = CONVERT(VARCHAR, T.PBANTERIOR)
			,@PTA = CONVERT(VARCHAR, T.PTANTERIOR)
			,@PNA = CONVERT(VARCHAR, T.PNANTERIOR)
		FROM #TEMP AS T
		WHERE NRO = @CONT;

		--|                    
		SET @vMessage = @vMessage + N' 1.1 Informacion de la modificación : ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
		SET @vMessage = @vMessage + N' - Peso Bruto  : ' + UPPER(@PBN) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Tara  : ' + UPPER(@PTN) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Neto  : ' + UPPER(@PNN) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Fecha Modi.  : ' + UPPER(@FECHA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Usuario   : ' + UPPER(@USN) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N'' + CHAR(13) + CHAR(10) + '';
		SET @vMessage = @vMessage + N' - Peso Bruto Anterior : ' + UPPER(@PBA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Tara Anterior : ' + UPPER(@PTA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Neto Anterior : ' + UPPER(@PNA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N'' + CHAR(13) + CHAR(10) + '';

		--|                    
		--| PRIMERA MODIFICACIÓN                     
		SELECT @PBA = CONVERT(VARCHAR, T.PBANTERIOR)
			,@PTA = CONVERT(VARCHAR, T.PTANTERIOR)
			,@PNA = CONVERT(VARCHAR, T.PNANTERIOR)
		FROM #TEMP AS T
		WHERE NRO = @CANT;

		--|                    
		SET @vMessage = @vMessage + N' 1.2 Informacion Original : ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
		SET @vMessage = @vMessage + N' - Peso Bruto  : ' + UPPER(@PBA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Tara  : ' + UPPER(@PTA) + CHAR(13) + CHAR(10);
		SET @vMessage = @vMessage + N' - Peso Neto  : ' + UPPER(@PNA) + CHAR(13) + CHAR(10);
		--|                    
		SET @vMessage = @vMessage + N'' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
	END;

	--|                    
	--SET @vMessage = @vMessage + N' 2. Informacion del Password : '  + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';                      
	SET @vMessage = @vMessage + N' - Hora   : ' + CONVERT(VARCHAR, GETDATE(), 108) + CHAR(13) + CHAR(10);
	SET @vMessage = @vMessage + N' - Password  : ' + CONVERT(VARCHAR, @NewPass) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + '';
	--                      
	SET @vMessage = @vMessage + 'Servicios TI' + CHAR(13) + CHAR(10);

	--                     
	EXEC @EX = master.dbo.xp_smtp_sendmail @FROM = @vFrom
		,@FROM_NAME = @vFromName
		,@TO = @vTo
		,@CC = @vCc
		,@priority = @vPriority
		,@subject = @vSubject
		,@message = @vMessage
		,@messagefile = N''
		,@type = N'text/plain'
		,@attachment = N''
		,@attachments = N''
		,@codepage = 0
		,@server = N'correo.neptunia.com.pe'

	SET NOCOUNT OFF;
		----------------//                      
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ticket_ModificacionDatos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ticket_ModificacionDatos]
@nrotkt varchar(8)
,@nroplaca varchar(7)
as
begin
	declare @nroaut varchar(8)
	
	set @nroaut = ''
	
	select @nroaut = nroaut14
	from ddticket18 (nolock)
	where nrotkt18 = @nrotkt and tipope18 = 'E'
	
	if ISNULL(@nroaut,'') <> ''
	begin
		UPDATE DESCARGA..EDAUTING14
			SET nropla81 = @nroplaca
		WHERE nroaut14 = @nroaut
	end
end

GO
/****** Object:  StoredProcedure [dbo].[USP_TRANSACCIONES_DPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_TRANSACCIONES_DPW]
AS
BEGIN
	SELECT 
	A.viUserDPW AS USUARIO_DPW
	,A.viNumCita as NRO_CITA
	,B.codnav08 as COD_NAVE
	,B.numvia11 AS VIAJE
	,A.viCtr as CONTENEDOR
	,A.viIsoCode as ISOCODE
	,A.viPlaca as PLACA
	,A.viDNI as DNI_CHOFER
	,A.viRucEmp as RUC_EMP_TRANS
	,A.viPreAdu as PRECINTO_ADUANA
	,A.viUser as USUARIO
	,A.viIP as IP_MAQUINA
	,A.viError as DESC_WEBSERVICE
	,A.viFec as FECHA_ENVIO
	FROM USP_LOG_SERVICE_DPW A WITH (NOLOCK)
	INNER JOIN Descarga..DDCABMAN11 B WITH (NOLOCK) ON A.viNavvia = B.navvia11
	WHERE YEAR(viFec) >= YEAR(GETDATE())
	AND viUser <> 'frmilla'
	ORDER BY A.viFec ASC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VAL_CONN_DPW]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_VAL_CONN_DPW] @CTR VARCHAR(11)
	,@NAVVIA VARCHAR(6)
	,@PLACA VARCHAR(8)
	,@BREVETE VARCHAR(15)
	,@RUCEMP VARCHAR(11)
	,@TICKETSAL VARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	SET @CTR = LTRIM(RTRIM(@CTR))
	SET @NAVVIA = LTRIM(RTRIM(@NAVVIA))
	SET @PLACA = LTRIM(RTRIM(@PLACA))
	SET @BREVETE = LTRIM(RTRIM(@BREVETE))
	SET @RUCEMP = LTRIM(RTRIM(@BREVETE))
	SET @TICKETSAL = LTRIM(RTRIM(@TICKETSAL))

	DECLARE @RESULTADO VARCHAR(1)

	SET @RESULTADO = '0'

	--|VALIDAR SI LA NAVE/VIAJE EMBARCARA POR DPW                  
	IF NOT EXISTS (
			SELECT navvia11
			FROM DDCABMAN11 WITH (NOLOCK)
			WHERE navvia11 = @NAVVIA
				AND ptoori11 = 'D'
			)
	BEGIN
		SET @RESULTADO = '1'

		SELECT @RESULTADO AS resultado
			,cita = ''
			,isocode = ''
			,dni = ''
			,precinto_adu = ''
			,pestara = ''
			,pesneto = ''

		RETURN;
	END

	--|                  
	DECLARE @DNI VARCHAR(8)
		,@PESOTARA DECIMAL(12, 2)
		,@PESONETO DECIMAL(12, 2)

	SELECT @DNI = DNI
	FROM LOGISTICA.DBO.sb_conductor WITH (NOLOCK)
	WHERE NumeroLicencia = @BREVETE

	SELECT TOP 1 @PESOTARA = nrotar04 * 1000
	FROM DESCARGA..EDCONTEN04 WITH (NOLOCK)
	WHERE codcon04 = @CTR

	SELECT TOP 1 @PESONETO = pesnet18
	FROM DDTICKET18 WITH (NOLOCK)
	WHERE nrotkt18 = @TICKETSAL

	IF NOT EXISTS (
			SELECT TOP 1 pesnet18
			FROM DDTICKET18 WITH (NOLOCK)
			WHERE nrotkt18 = @TICKETSAL
			)
	BEGIN
		SELECT @PESONETO = B.pesnet18
		FROM DRCTRTMC90 A (NOLOCK)
		INNER JOIN DDTICKET18 B (NOLOCK) ON A.nrotkt28 = B.nrotkt18
		WHERE A.codcon04 = @CTR
		AND B.navvia11 = @NAVVIA
		
		IF @PESONETO IS NULL
		BEGIN
			SET @PESONETO = @PESOTARA
		END
	END

	IF ISNULL(@DNI, '') = ''
	BEGIN
		IF LEN(@BREVETE) = 8
		BEGIN
			SET @DNI = @BREVETE
		END
		ELSE
		BEGIN
			SET @DNI = SUBSTRING(@BREVETE, 2, 8)
		END
	END

	DECLARE @numcita VARCHAR(15)
		,@feccita VARCHAR(20)

	SELECT TOP 1 @numcita = b.numcita --, @feccita = b.feccita          
	FROM Descarga..edbookin13 a WITH (NOLOCK)
	INNER JOIN Descarga..ERCONASI17 b WITH (NOLOCK) ON a.genbkg13 = b.genbkg13
	LEFT JOIN Descarga..edllenad16 c WITH (NOLOCK) ON c.navvia11 = a.navvia11
		AND c.codcon04 = b.codcon04
	WHERE b.codcon04 = @CTR
		AND a.navvia11 = @NAVVIA
		AND isnull(b.numcita, '') <> ''
	ORDER BY b.fecasi17 DESC

	SELECT TOP 1 @RESULTADO AS resultado
		,cita = ltrim(rtrim(isnull(@numcita, '')))
		,isocode = ltrim(rtrim(isnull(D.CodigoInternacional, '')))
		,dni = isnull(@DNI, '')
		--,precinto_adu = CASE   
		-- WHEN C.preadu16 IS NOT NULL  
		--  THEN C.preadu16  
		-- ELSE isnull(C.nropre16, '')  
		-- END  
		,precinto_adu = ''
		,pesneto = isnull((CAST((CAST(@PESOTARA AS INT)) AS VARCHAR)), '')
		,pestara = isnull((CAST(@PESONETO AS VARCHAR)), '') --pestara                 
	FROM DESCARGA..EDBOOKIN13 A WITH (NOLOCK)
	INNER JOIN DESCARGA..ERCONASI17 B WITH (NOLOCK) ON A.genbkg13 = B.genbkg13
	LEFT JOIN Descarga..EDLLENAD16 C WITH (NOLOCK) ON C.navvia11 = A.navvia11
		AND C.codcon04 = B.codcon04
		AND C.genbkg13 = A.genbkg13
	INNER JOIN spbmcaracteristicascontenedor D WITH (NOLOCK) ON LTRIM(RTRIM(D.Tipo)) = A.codtip05 COLLATE Modern_Spanish_CI_AS
	WHERE A.navvia11 = @NAVVIA
		AND B.codcon04 = @CTR
		AND isnull(B.numcita, '') <> ''
	ORDER BY B.fecasi17 DESC

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VAL_ELIMTICKET]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_VAL_ELIMTICKET]
@NROTKT VARCHAR(8)
,@OP VARCHAR(1)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @EXISTE VARCHAR(2)
	
	IF @OP = '1'
	BEGIN
		IF EXISTS(
					SELECT *FROM
					DDTICKET18 WHERE nrotkt18 = @NROTKT
				 )
		BEGIN
			SET @EXISTE = 'SI'
		END
		ELSE
		BEGIN
			SET @EXISTE = 'NO'
		END
		SELECT @EXISTE AS 'resultado',
		'mensaje' = CASE WHEN @EXISTE = 'NO' 
						 THEN 'El Ticket (' + @NROTKT + ') se encuentra ELIMINADO, Solo se mostrara la Información'
						 ELSE ''
						 END
	END
	
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDACION_DUA_X_CTR]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec USP_VALIDACION_DUA_X_CTR 'APZU3249589','058884','C'                
ALTER PROCEDURE [dbo].[USP_VALIDACION_DUA_X_CTR] @CTR VARCHAR(11)
	,@NAVVIA VARCHAR(6)
	,@OPCION VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MENSAJE VARCHAR(5000)
	DECLARE @ICOUNT INT
		,@ICOUNT_TOT INT
	DECLARE @DATO VARCHAR(35)
		,@DATO1 VARCHAR(35)

	SET @MENSAJE = ''

	/************************************************/
	--|BOOKING SIN DAM                    
	SELECT DISTINCT B.bookin13
		,A.genbkg13
		,IDENTITY(INT, 1, 1) AS IDD
	INTO #SINDUA
	FROM descarga..EDLLENAD16 A WITH (NOLOCK)
	INNER JOIN Descarga..EDBOOKIN13 B WITH (NOLOCK) ON A.genbkg13 = B.genbkg13
	WHERE A.codcon04 = @CTR
		AND A.navvia11 = @NAVVIA
		AND ISNULL(A.oemadu16, '') = ''

	SET @ICOUNT = 1

	SELECT @ICOUNT_TOT = COUNT(*)
	FROM #SINDUA

	IF EXISTS (
			SELECT *
			FROM #SINDUA
			)
	BEGIN
		WHILE @ICOUNT <= @ICOUNT_TOT
		BEGIN
			SELECT @DATO = bookin13
			FROM #SINDUA
			WHERE IDD = @ICOUNT

			SET @ICOUNT = @ICOUNT + 1
			SET @MENSAJE = @MENSAJE + 'Booking: ' + LTRIM(RTRIM(@DATO)) + ' - No cuenta con DUA asociada y No tiene Canal' + CHAR(13)
		END
	END

	--|                    
	/************************************************/
	--|BOOKING CON DAM                    
	SELECT DISTINCT SUBSTRING(A.oemadu16, 4, 13) AS ID
		,B.bookin13
		,A.genbkg13
		,A.oemadu16
		,IDENTITY(INT, 1, 1) AS IDD
	INTO #CONDUA
	FROM descarga..EDLLENAD16 A WITH (NOLOCK)
	INNER JOIN Descarga..EDBOOKIN13 B WITH (NOLOCK) ON A.genbkg13 = B.genbkg13
	WHERE A.codcon04 = @CTR
		AND A.navvia11 = @NAVVIA
		AND ISNULL(A.oemadu16, '') <> ''
		AND SUBSTRING(A.oemadu16, 1, 3) <> '172'
		AND SUBSTRING(A.oemadu16, 6, 2) <> 'MG'
		AND SUBSTRING(A.oemadu16, 6, 2) <> '60'
		AND SUBSTRING(A.oemadu16, 6, 2) <> '32'
		AND SUBSTRING(A.oemadu16, 6, 2) <> '81'
		AND SUBSTRING(A.oemadu16, 6, 2) <> '71'

	SELECT substring(NroDua, 3, 2) + LTRIM(rtrim(regimen)) + substring(NroDua, 6, 6) AS ID
		,Obs
	INTO #TEMP_NEP1
	FROM terminal.dbo.aduana_LecturaRpt
	WHERE FlagMov = 'E'
		AND fecCrea >= '20150101'

	SELECT A.oemadu16
		,A.bookin13
		,IDENTITY(INT, 1, 1) AS IDD
	INTO #CONSULTAR
	FROM #CONDUA A
	LEFT JOIN #TEMP_NEP1 B ON A.ID = B.ID
	WHERE B.ID IS NULL

	DECLARE @CONT INT
		,@CONT_TOT INT
	DECLARE @BOOK VARCHAR(6)
		,@DUA VARCHAR(15)

	SET @CONT = 1

	SELECT @CONT_TOT = COUNT(*)
	FROM #CONSULTAR

	--SELECT @MENSAJE                    
	IF EXISTS (
			SELECT *
			FROM #CONSULTAR
			)
	BEGIN
		WHILE @CONT <= @CONT_TOT
		BEGIN
			SELECT @BOOK = bookin13
				,@DUA = oemadu16
			FROM #CONSULTAR
			WHERE IDD = @CONT

			SET @CONT = @CONT + 1
			SET @MENSAJE = @MENSAJE + 'Booking: ' + LTRIM(RTRIM(@BOOK)) + ', DUA: ' + LTRIM(RTRIM(@DUA)) + ' - No tiene Canal' + CHAR(13)
		END
	END

	IF LTRIM(RTRIM(@MENSAJE)) <> ''
	BEGIN
		SET @MENSAJE = @MENSAJE + 'Coordinar con Tesorería'
	END

	SELECT ltrim(rtrim(@MENSAJE)) AS 'mensaje'
		,'1' AS flgBlo

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ValidacionPayLoadFCL]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ValidacionPayLoadFCL] @Navvia VARCHAR(6)  
 ,@Contenedor VARCHAR(11)  
 ,@Ticket VARCHAR(8)  
 ,@pesoNeto DECIMAL(10, 3)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @diferencia INT  
  ,@payload DECIMAL(10, 3)  
  ,@tara DECIMAL(10, 3)  
 SELECT @payload = payloa04 * 1000 , @tara= nrotar04 * 1000 
 FROM descarga..EDCONTEN04(NOLOCK)  
 WHERE codcon04 = @Contenedor  
 
 
  
 IF ISNULL(@payload, 0) < @pesoNeto - @tara 
 BEGIN  
  SET @diferencia = @pesoNeto - @payload  - @tara
  
  SELECT resultado = 'EXCESO PESO'  
   ,payload = @payload  
   ,diferencia = @diferencia  
  
  RETURN;  
 END  
 ELSE  
 BEGIN  
  SELECT resultado = ''  
   ,payload = 0  
   ,diferencia = 0  
  
  RETURN;  
 END  
  
 SET NOCOUNT OFF;  
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ValidacionPayLoadFCL_Impresion]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ValidacionPayLoadFCL_Impresion] @Ticket VARCHAR(8)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @diferencia INT  
  ,@payload DECIMAL(10, 3)  
  ,@pesoneto DECIMAL(10, 3)  
  ,@contenedor VARCHAR(11)  
  ,@codemb VARCHAR(3)  
  
 SELECT @contenedor = codcon04  
  ,@pesoneto = pesnet18  - (nrotar18*1000)
  ,@codemb = codemb06  
 FROM DDTICKET18(NOLOCK)  
 WHERE nrotkt18 = @Ticket  
  
 SELECT @payload = payloa04 * 1000  
 FROM descarga..EDCONTEN04(NOLOCK)  
 WHERE codcon04 = @contenedor  
  
 IF ISNULL(@payload, 0) < @pesoNeto  
  AND @codemb = 'CTR'  
 BEGIN  
  SET @diferencia = @pesoNeto - @payload  
  
  SELECT resultado = 'EXCESO PESO'  
   ,payload = @payload  
   ,diferencia = @diferencia  
  
  RETURN;  
 END  
 ELSE  
 BEGIN  
  SELECT resultado = ''  
   ,payload = 0  
   ,diferencia = 0  
  
  RETURN;  
 END  
  
 SET NOCOUNT OFF;  
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDAR_EVENTOS_EDI]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_VALIDAR_EVENTOS_EDI]  
@CODARM10 VARCHAR(3)  
AS  
BEGIN  
 SET @CODARM10 = LTRIM(RTRIM(@CODARM10))  
   
 EXEC Descarga..USP_VALIDAR_EVENTOS_EDI @CODARM10  
   
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarCtrPos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspInsertarCtrPos] (    
@contenedor varchar(12),    
@tipo varchar(2),    
@tamano varchar(2),    
@condicion varchar(2),    
@placa varchar(10),      
@naveviaje varchar(12),    
@navvia varchar(6),      
@linea varchar(3),                         
@puerto varchar(3),                        
@booking varchar(10),                      
@peso varchar(6),                          
@usuario varchar(20),  
@ip varchar(15)  
)      
as    
     
    
begin    
    
insert into tbIngresoCtrPos(contenedor, tipo, tamano, condicion, placa, naveviaje, navvia,    
linea, puerto, booking, peso, usuario, fecha)    
values (@contenedor, @tipo, @tamano, @condicion, @placa, @naveviaje, @navvia,    
@linea, @puerto, @booking, @peso, @usuario, getdate())    

select @@identity as id
    
end    
    
  


GO
/****** Object:  StoredProcedure [web].[GUIA_REMISION_NEPTUNIA_EXPO_VENT]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[GUIA_REMISION_NEPTUNIA_EXPO_VENT]  
@navvia char(6),  
@nroctr char(11)  
as  
  
select a.navvia11,b.codcon04,a.nrogui19, c.ptoori11 from DDGUITPC19 a (nolock), DRGUITPC20 b (nolock), DDCABMAN11 c (nolock)  
where   
a.nrogui19=b.nrogui19 and   
a.navvia11=c.navvia11 and   
a.navvia11=@navvia and   
b.codcon04=@nroctr and   
a.trasla19 in ( 1, 2 )  
GO
/****** Object:  StoredProcedure [web].[PRE_Salida_Expo_Danos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[PRE_Salida_Expo_Danos] 
@Contenedor varchar(11),  
@Navvia varchar(7)  
as
begin
exec Precintos.dbo.IPRE_Salida_Expo_Danos  @Contenedor ,@Navvia
end
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Booking_Ruc_Consolidadora]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Booking_Ruc_Consolidadora]
@navvia11 char(6),
@genbkg13 char(6)
AS
Select bookin13,ruccli13 
from edbookin13 (nolock) 
where navvia11 = @navvia11
and genbkg13 = @genbkg13
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Cliente_Balanza]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Cliente_Balanza]  
@Contribuy varchar(11)  
AS  
Select isnull(nombre,'') as nombre from aaclientesaa (NOLOCK) where contribuy = @Contribuy  
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Datos_Embalaje]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Datos_Embalaje]
@codemb06 char(3)
AS
Select 
codemb06,
desemb06 
from DESCARGA..dqembala06 (NOLOCK) 
where codemb06 = @codemb06
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Datos_Ticket]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Datos_Ticket]
@Placa char(7),
@Estado char(1)
AS
Select nrotkt18,nroaut14 
from ddticket18 (NOLOCK) 
where nropla18 = @Placa 
and status18 = @Estado 
and tipope18 = 'E' 
order by nroaut14 desc
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Datos_Vehiculos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Datos_Vehiculos]      
@splaca char(7),      
@sautor char(8)      
As      
SELECT a.nrotkt18,b.navvia11,b.nroaut14,a.status18,      
a.nropla18,a.pesbrt18,b.fecaut14,b.codage19,b.conten13,      
c.nrobul16,c.codemb06,b.codemc12,c.nroitm16,c.nrocha16,    
c.marcas16,nomemb16=b.nomemb14,b.genbkg13, '' as  codtip05, c.codpro27    
FROM       
balanza..ddticket18 a (nolock), descarga..edauting14 b (nolock),    
descarga..edllenad16 c (nolock)      
WHERE (a.nropla18 = b.nropla81) AND (a.navvia11 = b.navvia11)       
AND (b.navvia11 = c.navvia11) AND (b.nroaut14 = c.nroaut14)       
AND a.nropla18 = @splaca AND a.status18 = 'I'       
AND c.nroaut14 = @sautor AND c.nrotkt18 is null 
GO
/****** Object:  StoredProcedure [web].[sp_Expo_Balanza_Busca_Nave_Viaje]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [web].[sp_Expo_Balanza_Busca_Nave_Viaje]
@NavVia char(6)
AS
Select 
a.desnav08,
b.numvia11,
b.codnav08 
from dqnavier08 a (NOLOCK)
inner join ddcabman11 b (NOLOCK)  on a.codnav08 = b.codnav08
where b.navvia11 = @NavVia
GO
/****** Object:  StoredProcedure [web].[sp_tabla_cosmos]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_tabla_cosmos]
@evento char(4),
@ope   varchar(1)
as
declare @fecini char(8)
declare @fecfin char(8)
declare @cadena varchar(500)      
begin

 set @fecini = CONVERT(CHAR(8),GETDATE() ,112)
 set @fecfin = CONVERT(CHAR(8),GETDATE() ,112)

 --set @fecini = CONVERT(CHAR(8),@fechaini,112)
 --set @fecfin = CONVERT(CHAR(8),@fechafin,112)
-- EXEC [192.168.0.59\SQL2005].CSMBlueship.dbo.spu_csm_get_tally_events_by_neptunia '' ,@fecini,@fecfin, @evento,''


      
DELETE FROM Tabla_Cosmos  WHERE evento =@evento AND LEFT(OPERACION,1) = 'E'

set @cadena = 'INSERT INTO OCEANICA1.DESCARGA.DBO.Tabla_Cosmos  SELECT * FROM OPENQUERY([192.168.0.59\SQL2005],' + '''CSMBlueShip.dbo.spu_csm_get_tally_events_by_neptunia '''''''',''''' + @FecIni + ''''',''''' + @FecFin + ''''','''''''',''''''''''' + ') where (''' + @evento + ''' = '''' or evento = ''' + @evento + ''') and  (''' + @ope + '''  =  '''' or left(operacion,1) = ''' + @ope + ''')  ORDER BY 4,2'    
  
--insert into #Tabla_Cosmos     
--EXEC [192.168.0.46].CSMBlueShip.dbo.spu_csm_get_tally_events_by_neptunia '',@FecIni , @FecFin , 'GIFU'    
    
--   print @cadena
exec (@cadena)      


end
GO
/****** Object:  StoredProcedure [web].[usp_SelectTipoOperacion]    Script Date: 07/03/2019 01:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[usp_SelectTipoOperacion]
AS
select Codigo, Tipo
from TipoOperacion 
GO
