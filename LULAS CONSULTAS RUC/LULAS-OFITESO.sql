--172.30.20.36
--usrgesfor			pmovrSByWgkOAS5

use OFITESO
select NU_CORR_COMP, * from TMDOCU_PROV
where co_prov = '20600365925'
order by NU_DOCU_PROV

SELECT * FROM TDMOVI_BANC
WHERE CO_ENTI = '20600365925' --and NU_DOCU_ENTI = '0001-0000000102'
order by NU_DOCU_ENTI

SELECT * FROM TDMOBA_DETR
WHERE NU_RUCS_DETR = '20600365925'
ORDER BY NU_DOCU_ENTI