USE [MAXIMOInterfase]
GO

SET DATEFORMAT dmy

/***
SELECT b05_nuanno [AñoPeriodo], b06_numese [MesPeriodo], 
	YEAR(b37_transdate) [AñoMovimiento]/*year_b37_transdate*/, MONTH(b37_transdate) [MesMovimiento]/*month_b37_transdate*/, 
	DAY(b37_transdate) [DiaMovimiento]/*day_b37_transdate*/, COUNT(*) MaximoCount/*maximo_count*/
FROM [10.100.16.221].max76prd.dbo.coastcontinv
where b05_nuanno = 2019 and b06_numese = 01 and b01_coempr = '16'
GROUP BY b05_nuanno, b06_numese, YEAR(b37_transdate), MONTH(b37_transdate), DAY(b37_transdate)
ORDER BY 3 DESC, 4 DESC, 5 DESC

select nu_anno [AñoPeriodo], nu_mese [MesPeriodo], 
	YEAR(cs_transdate) [AñoMovimiento]/*year_cs_transdate*/, MONTH(cs_transdate) [MesMovimiento]/*month_cs_transdate*/, 
	DAY(cs_transdate) [DiaMovimiento]/*day_cs_transdate*/, COUNT(*) MaximoInterfaseOfisisCount/*maximo_interfase_count*/
--select *	
from TXMVTO_INTE_MAXI 
where nu_anno = 2019 and nu_mese = 01 and co_empr = '16'
GROUP BY nu_anno, nu_mese, YEAR(cs_transdate), MONTH(cs_transdate), DAY(cs_transdate)
ORDER BY 3 DESC, 4 DESC, 5 DESC

SELECT * FROM [10.100.16.221].max76prd.dbo.coastcontinv
where CONVERT(varchar(8),b37_transdate,112) = '20190130' and b01_coempr = '16'
--	AND b36_articulo IN ('101828','101804')
ORDER BY b37_transdate DESC

SELECT cs_transdate c, * FROM [COSMOS-DB\SQL2008].maximointerfase.dbo.TXMVTO_INTE_MAXI 
WHERE CONVERT(varchar(8),cs_transdate,112) = '20190130' and co_empr = '16'
--	AND cs_articulo IN ('101828','101804')

--DELETE FROM [COSMOS-DB\SQL2008].maximointerfase.dbo.TXMVTO_INTE_MAXI WHERE CONVERT(varchar(8),cs_transdate,112) = '20170315' AND st_situ = 'N'

***/

DECLARE @transdate	DATETIME, @year		INT, @month		INT, @empresa VARCHAR(10)

---------------------------------------------------------------
--Variables
SET @transdate = '20190130'			--Fecha de Transferencia 
---------------------------------------------------------------

SET @empresa = '16'
PRINT @transdate

--
/***/
INSERT INTO [COSMOS-DB\SQL2008].maximointerfase.dbo.TXMVTO_INTE_MAXI
(
	CO_EMPR, 	NU_CNTB_EMPR, 	CO_UNID_CNTB, 	CO_OPRC_CNTB, 	NU_ANNO, 	NU_MESE, 	NU_ASTO, 	NU_SECU, 	FE_ASTO_CNTB,
	CO_CNTA_EMPR, 	TI_AUXI_EMPR, 	CO_AUXI_EMPR, 	TI_DOCU, 	NU_DOCU, 	FE_DOCU, 	FE_DOCU_VENC,	TI_CAMB, 	CO_MONE,
	FA_CAMB, 	FA_CAMB_DIAR, 	TI_OPER, 	IM_MVTO_ORIG, 	DE_GLOS, 	TI_DOCU_REFE, 	NU_DOCU_REFE, 	FE_DOCU_REFE, 	NO_GIRA,
	FE_ENTR_CHEQ, 	FE_PROG_CHEQ, 	CO_ORDE_SERV, 	CO_MEPA, 	CO_USUA_CREA, 	ST_SITU, 	NU_ASTO_OFIS,
	cs_doc, cs_articulo, cs_transdate, cs_date_cr
)
/***/
SELECT 
	LEFT(LTRIM(RTRIM(b01_coempr)), 2) b01_coempr, b02_nucntbempr, right(b03_counidcntb, 3) b03_counidcntb, b04_cooprccntb, b05_nuanno, b06_numese,
	REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, DAY(b37_transdate)))) + CONVERT(VARCHAR, DAY(b37_transdate)) +
	REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, DATEPART(HOUR, b37_transdate)))) + CONVERT(VARCHAR, DATEPART(HOUR, b37_transdate)) +
	REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, DATEPART(MINUTE, b37_transdate)))) + CONVERT(VARCHAR, DATEPART(MINUTE, b37_transdate)) +
	SUBSTRING(b07_nuasto, 7, 4) AS 'b07_nuasto',
	ROW_NUMBER() OVER (ORDER BY b01_coempr, b02_nucntbempr, b03_counidcntb, b04_cooprccntb, b05_nuanno, b06_numese, b07_nuasto) AS 'b08_nusecu',
	CASE
		WHEN RIGHT(LTRIM(b09_feastocntb), 4) <> b05_nuanno
			AND SUBSTRING(RTRIM(LTRIM(b09_feastocntb)), PATINDEX('%/%', RTRIM(LTRIM(b09_feastocntb))) + 1, 2) <> b06_numese
		THEN '01/' + CONVERT(VARCHAR, b06_numese) + '/' + CONVERT(VARCHAR, b05_nuanno)
		WHEN SUBSTRING(RTRIM(LTRIM(b09_feastocntb)), PATINDEX('%/%', RTRIM(LTRIM(b09_feastocntb))) + 1, 2) <> b06_numese
		THEN '01/' + CONVERT(VARCHAR, b06_numese) + '/' + CONVERT(VARCHAR, b05_nuanno)
		ELSE b09_feastocntb
	END AS 'b09_feastocntb',
	b10_cocntaempr,
	CASE
		WHEN b10_cocntaempr LIKE '33%' THEN NULL
		ELSE b11_tiauxiempr
	END AS 'b11_tiauxiempr',
	CASE
		WHEN b10_cocntaempr LIKE '33%' THEN NULL
		ELSE b12_coauxiempr
	END AS 'b12_coauxiempr',
	b13_tidocu, b14_nudocu, b15_fedocu, b16_fedocuvenc, b17_ticamb, b18_comone,
	b19_facamb, b20_facambdiar, b21_tioper, b22_immvtoorig, b23_deglos, b24_tidocurefe, b25_nudocurefe, b26_fedocurefe, b27_nogira,
	b28_feentrcheq, b29_feprogcheq,
	CASE
		WHEN b10_cocntaempr LIKE '33%' THEN NULL
		ELSE b30_coordeserv
	END AS 'b30_coordeserv',
	b31_comepa, b32_cousuacrea, ISNULL(b33_stsitu,'N'), b34_nuastoofis,
	b35_doc, b36_articulo, b37_transdate, GETDATE()
FROM [10.100.16.221].max76prd.dbo.coastcontinv
WHERE 
	b37_transdate BETWEEN @transdate AND DATEADD(ss, -1, DATEADD(d, 1, @transdate))
	AND b01_coempr = @empresa
	--
	AND b37_transdate = '20190130 15:11:50.707'
	--
ORDER BY b37_transdate 
