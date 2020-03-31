USE [MAXIMOInterfase]
GO
--SELECT * FROM TXMVTO_INTE_MAXI WHERE nu_anno = 2015 AND nu_mese = 9 AND co_unid_cntb = '001' AND CONVERT(varchar(8),cs_date_cr,112)='20150930' AND st_situ = 'S'
--SELECT * FROM [COSMOS-DB\SQL2008].OFICONT.dbo.TXMVTO_INTE_CNTB
/*
SELECT rsm.co_unid_cntb, rsm.st_situ, rsm.qCount, rsm.qCount/13
FROM (
      SELECT co_unid_cntb, st_situ, COUNT(*) qCount
              FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
              WHERE 1 = 1
                        AND st_situ = 'N'
                        AND co_empr = '16'
                        AND nu_cntb_empr = 1
                        --AND co_unid_cntb = '010'
                        AND nu_anno = '2019'
                        AND nu_mese = '02'
						AND FE_ASTO_CNTB = '20151027'
      --AND nu_asto_ofis IS NOT NULL
      AND nu_asto_ofis IS NULL
      GROUP BY co_unid_cntb, st_situ
      ) rsm
ORDER BY 1
*/
SELECT rsm.co_unid_cntb, rsm.nu_mese, rsm.st_situ, rsm.qCount, rsm.qCount/7500
FROM (
      SELECT co_unid_cntb, nu_mese, st_situ, COUNT(*) qCount
              FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
              WHERE 1 = 1
                        AND st_situ = 'N'	
                        AND co_empr = '16'
                        AND nu_cntb_empr = 1
                        --AND co_unid_cntb = '010'
                        AND nu_anno = '2019'
                        AND nu_mese = '02'
      --AND nu_asto_ofis IS NOT NULL
      AND nu_asto_ofis IS NULL
      GROUP BY co_unid_cntb, nu_mese, st_situ
      ) rsm
ORDER BY 1

	SELECT DAY(cs_transdate) dia, MONTH(cs_transdate) mes, COUNT(*) qCount
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'N'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '011'
		AND nu_anno = '2019'
		AND nu_mese = '02'
		--AND nu_asto_ofis IS NOT NULL
		--AND nu_asto_ofis IS NULL
		--AND cs_articulo = '122519'
	GROUP BY DAY(cs_transdate), MONTH(cs_transdate) 

SELECT rsm.co_unid_cntb, rsm.nu_mese, rsm.st_situ, rsm.qCount, rsm.qCount/7500
FROM (
      SELECT co_unid_cntb, st_situ, nu_mese, COUNT(*) qCount
              FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
              WHERE 1 = 1
                        AND st_situ = 'S'
                        AND co_empr = '16'
                        AND nu_cntb_empr = 1
                        --AND co_unid_cntb = '010'
                        AND nu_anno = '2019'
                        AND nu_mese = '02'
      AND nu_asto_ofis IS NOT NULL
      --AND nu_asto_ofis IS NULL
      GROUP BY co_unid_cntb, st_situ, nu_mese
      ) rsm
ORDER BY 1

SELECT dia, mes, qCount, qCount/2
FROM (
	SELECT DAY(cs_transdate) dia, MONTH(cs_transdate) mes, COUNT(*) qCount
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'S'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '011'
		AND nu_anno = '2019'
		AND nu_mese = '02'
		--AND nu_asto_ofis IS NOT NULL
		--AND nu_asto_ofis IS NULL
		--AND cs_articulo = '122519'
	GROUP BY DAY(cs_transdate), MONTH(cs_transdate) 
	) rsm
ORDER BY 1 DESC

/**
	SELECT DAY(cs_transdate) dia, MONTH(cs_transdate) mes, co_unid_cntb, COUNT(*) qCount
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'S'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '011'
		AND nu_anno = '2019'
		AND nu_mese = '02'
		--AND nu_asto_ofis IS NOT NULL
		--AND nu_asto_ofis IS NULL
		--AND cs_articulo = '122519'
	GROUP BY DAY(cs_transdate), MONTH(cs_transdate), co_unid_cntb
	ORDER BY 1 DESC
**/

SELECT rsm.co_unid_cntb, rsm.st_situ, rsm.qCount, rsm.qCount/7500
FROM (
      SELECT co_unid_cntb, st_situ, COUNT(*) qCount
			  --SELECT *
              FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
			  --UPDATE TXMVTO_INTE_MAXI SET st_situ = 'Z'	
              WHERE 1 = 1
                        AND st_situ = 'X'	
                        AND co_empr = '16'
                        AND nu_cntb_empr = 1
                        --AND co_unid_cntb = '010'
                        AND nu_anno = '2019'
                        AND nu_mese = '02'
      --AND nu_asto_ofis IS NOT NULL
      --AND nu_asto_ofis IS NULL
      GROUP BY co_unid_cntb, st_situ
      ) rsm
ORDER BY 1

SELECT *
FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
WHERE 1 = 1
    AND st_situ = 'X'	
    AND co_empr = '16'
    AND nu_cntb_empr = 1
    --AND co_unid_cntb = '010'
    AND nu_anno = '2019'
    AND nu_mese = '02'

SELECT *
FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
WHERE 1 = 1
    AND st_situ = 'X'	
    AND co_empr = '16'
    AND nu_cntb_empr = 1
    --AND co_unid_cntb = '010'
    AND nu_anno = '2019'
    AND nu_mese = '02'

SELECT *
FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
WHERE 1 = 1
    AND st_situ = 'X'	
    AND co_empr = '16'
    AND nu_cntb_empr = 1
    --AND co_unid_cntb = '010'
    AND nu_anno = '2019'
    AND nu_mese = '02'

/*
SELECT st_situ, * FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
--UPDATE TXMVTO_INTE_MAXI SET st_situ = 'N', fe_asto_cntb = '20160127'
--UPDATE TXMVTO_INTE_MAXI SET st_situ = 'Z'
--UPDATE TXMVTO_INTE_MAXI SET st_situ = 'N'
WHERE 1 = 1
    AND st_situ = 'X'	
    AND co_empr = '16'
    AND nu_cntb_empr = 1
    AND co_unid_cntb = '001'
    AND nu_anno = '2019'
    AND nu_mese = '02'
	AND cs_articulo = '1005736'
	AND fe_asto_cntb = '20161229'
	AND nu_asto = '2912180031'


SELECT TOP 100 st_situ, cs_doc, cs_articulo, nu_asto_ofis, * FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
WHERE convert(date,cs_transdate) = '20160102'

*/

/**
SELECT rsm.co_unid_cntb, FE_ASTO_CNTB, rsm.st_situ, rsm.qCount, rsm.qCount/14
FROM (
      SELECT co_unid_cntb, FE_ASTO_CNTB, st_situ, COUNT(*) qCount
              FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
              WHERE 1 = 1
                        AND st_situ = 'N'
                        AND co_empr = '16'
                        AND nu_cntb_empr = 1
                        --AND co_unid_cntb = '010'
                        AND nu_anno = '2019'
                        AND nu_mese = '02'
      --AND nu_asto_ofis IS NOT NULL
		--	AND FE_ASTO_CNTB = '20150801'
      AND nu_asto_ofis IS NULL
      GROUP BY co_unid_cntb, FE_ASTO_CNTB, st_situ
      ) rsm
ORDER BY 1
**/

/*
SELECT *
FROM TXMVTO_INTE_MAXI WITH(NOLOCK)
WHERE nu_anno = 2015
	AND nu_mese = 10
--	AND co_unid_cntb = '010'
ORDER BY cs_transdate --nu_asto_ofis

SELECT cs_transdate, COUNT(*)
FROM (
	SELECT CONVERT(varchar(8),cs_transdate,112) cs_transdate
	FROM TXMVTO_INTE_MAXI WITH(NOLOCK)
	WHERE nu_anno = 2015
		AND nu_mese = 10
		AND co_unid_cntb = '005'
        --AND st_situ = 'N'
        AND co_empr = '16'
        AND nu_cntb_empr = 1
	) rsm
GROUP BY cs_transdate 
ORDER BY cs_transdate --nu_asto_ofis
*/

/*
SELECT cs_transdate, co_unid_cntb, COUNT(*)
FROM (
	SELECT CONVERT(varchar(8),cs_transdate,112) cs_transdate, co_unid_cntb 
	FROM TXMVTO_INTE_MAXI WITH(NOLOCK)
	WHERE nu_anno = 2015
		AND nu_mese = 10
	--	AND co_unid_cntb = '010'
        AND st_situ = 'N'
        AND co_empr = '16'
        AND nu_cntb_empr = 1
	) rsm
GROUP BY cs_transdate, co_unid_cntb 
ORDER BY cs_transdate, co_unid_cntb  --nu_asto_ofis
*/

SELECT rsm.co_unid_cntb, rsm.st_situ, rsm.dia, rsm.qCount, rsm.qCount/7500
FROM (
	SELECT co_unid_cntb, st_situ, DAY(fe_asto_cntb) dia, COUNT(*) qCount
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'N'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '011'
		AND nu_anno = '2019'
		AND nu_mese = '02'
		--AND nu_asto_ofis IS NOT NULL
		AND nu_asto_ofis IS NULL
	GROUP BY co_unid_cntb, st_situ, DAY(fe_asto_cntb)
--	ORDER BY DAY(fe_asto_cntb)
      ) rsm
ORDER BY 3


	SELECT DAY(cs_transdate) dia, COUNT(*) qCount
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'N'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '011'
		AND nu_anno = '2019'
		AND nu_mese = '02'
		--AND nu_asto_ofis IS NOT NULL
		--AND nu_asto_ofis IS NULL
		--AND cs_articulo = '122519'
	GROUP BY DAY(cs_transdate)

/*
SELECT TOP 10 * 
FROM [COSMOS-DATA\SQL2008].mx75prd.dbo.coastcontinv
WHERE b36_articulo = '122519'

*/

/*
SELECT * 
FROM (
	SELECT de_glos, cs_transdate, COUNT(*) cuenta
	FROM TXMVTO_INTE_MAXI WITH (NOLOCK)
	WHERE 1 = 1
		AND st_situ = 'S'
		AND co_empr = '16'
		AND nu_cntb_empr = 1
		--AND co_unid_cntb = '010'
		AND nu_anno = '2019'
		AND nu_mese = '02'
	GROUP BY de_glos, cs_transdate
	) rsm
WHERE rsm.cuenta > 2
*/

/*
SELECT *
FROM [COSMOS-DB\SQL2008].maximointerfase.dbo.TXMVTO_INTE_MAXI
WHERE 1 = 1
	AND CONVERT(varchar(8),cs_transdate,112) = '20170131'

SELECT *
FROM [COSMOS-DATA\SQL2008].mx75prd.dbo.coastcontinv
WHERE 1 = 1
	AND CONVERT(varchar(8),b37_transdate,112) = '20170131'
*/

--SELECT * FROM OFITESO..TXMVTO_CNTB WHERE CO_EMPR = '16' AND NU_MESE = 3 AND CO_OPRC_CNTB = '062'

SELECT * FROM [COSMOS-DB\SQL2008].OFICONT.dbo.TTERRO_INTE_MAXI WHERE CO_EMPR = '16' AND NU_ANNO = 2019 AND NU_MESE = 02 AND CO_OPRC_CNTB = '062' --AND FE_ASTO_CNTB = '20180413'
SELECT * FROM [COSMOS-DB\SQL2008].OFICONT.dbo.TTERRO_INTE_MAXI WHERE CO_EMPR = '16' AND NU_ANNO = 2019 AND NU_MESE = 02 AND CO_OPRC_CNTB = '062' --AND FE_ASTO_CNTB = '20180413'
SELECT * FROM [COSMOS-DB\SQL2008].OFICONT.dbo.TTERRO_INTE_MAXI WHERE CO_EMPR = '16' AND NU_ANNO = 2019 AND NU_MESE = 02 AND CO_OPRC_CNTB = '062' --AND FE_ASTO_CNTB = '20180413'

/*
SELECT * 
FROM [COSMOS-DB\SQL2008].OFICONT.dbo.TCFECH_PROC t3 
WHERE 		t3.CO_EMPR = '16'
			And t3.NU_CNTB_EMPR = '1'
--			And t3.CO_UNID_CNTB = '017'
			And t3.CO_OPRC_CNTB = '062'
			And t3.NU_ANNO = 2018
			And t3.NU_MESE = 5
			*/
			