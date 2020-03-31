
USE [OFIAPRO]

CREATE TABLE #TRAPEM_CCOS_TMP
(
	[CO_EMPR] varchar(2) NOT NULL,
	[CO_APRO] varchar(3) NOT NULL,
	[TI_AUXI_EMPR] varchar(1) NOT NULL,
	[CO_AUXI_EMPR] varchar(20) NOT NULL,
	[CO_USUA_CREA] varchar(8) NULL,
	[FE_USUA_CREA] datetime NULL,
	[CO_USUA_MODI] varchar(8) NULL,
	[FE_USUA_MODI] datetime NULL,
) 


INSERT INTO #TRAPEM_CCOS_TMP
--SELECT co_empr, '793', ti_auxi_empr, co_auxi_empr, co_usua_crea, getdate(), co_usua_modi, getdate()
--FROM dbo.TRAPEM_CCOS
--WHERE co_apro = '790'

INSERT INTO TRAPEM_CCOS
SELECT co_empr, [CO_APRO], ti_auxi_empr, co_auxi_empr, co_usua_crea, getdate(), co_usua_modi, getdate()
FROM dbo.#TRAPEM_CCOS_TMP

drop TABLE #TRAPEM_CCOS_TMP

