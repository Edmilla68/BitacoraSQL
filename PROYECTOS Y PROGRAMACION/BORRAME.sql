DECLARE @NUMFACTURA NVARCHAR(15)                                                      
DECLARE @TIPMONEDA NVARCHAR(3)                                   
DECLARE @RUCCODIGO NVARCHAR(11)


SET @NUMFACTURA = 'F115-0000010446'
SET @TIPMONEDA  = 'DOL'
SET @RUCCODIGO  = '20601691621'



 SELECT  CABDOC.TI_DOCU TIPODOC,                                                             
         CABDOC.NU_DOCU NUMDOCCOMPLETO,                                                             
         MAX(SubString(CABDOC.NU_DOCU,1,4)) SERIEDOC,                                                          
         MAX(SubString(CABDOC.NU_DOCU,6,10)) NUMERODOC,                                                          
         MAX(CABDOC.CO_CLIE) RUCCODIGO,                                                             
         MAX(CABDOC.CO_MONE) MONEDA,                                                             
         DETDOC.CO_SERV CODSERVICIOOFISIS,                                             
         SERV.DE_SERV NOMSERVICIOOFISIS,                                          
         DETDOC.CO_UNNE UNIDADNEGOCIO,                                      
         UNEG.DE_UNNE NOMUNIDADNEGOCIO,                                                         
         DETDOC.CO_TIEN LOCALTIENDA,                                  
         TIEN.DE_TIEN NOMLOCALTIENDA,                                                             
         MAX(CABDOC.CO_IMP1) TIPOIMPUESTO1,                                                             
         --MAX(DETDOC.ST_IMP1) AFECTOIMP1, -- 'S' AFECTOIMP1, --MAX(DETDOC.ST_IMP1) AFECTOIMP1,  GOS(YQM) Modificado por error en el OFISIS // 2011_04_05 modificado no jala como no afecto los no domiciliado                    
		 Case when sum(CABDOC.IM_BRUT_AFEC) > 0 THEN 'S' ELSE 'N' END AFECTOIMP1,                     
		 Case when MAX(CABDOC.FE_DOCU) >= '20110301' THEN MAX(CABDOC.PC_IMP1) ELSE 19 END IMPUESTO1,    --MAX(CABDOC.PC_IMP1) IMPUESTO1,                                                             
         MAX(CABDOC.CO_IMP2) TIPOIMPUESTO2,                                                             
         MAX(DETDOC.ST_IMP2) AFECTOIMP2,                                                             
         MAX(CABDOC.PC_IMP2) IMPUESTO2,                
         MAX(CABDOC.CO_IMP3) TIPOIMPUESTO3,                                   
         MAX(DETDOC.ST_IMP3) AFECTOIMP3,                                                             
         MAX(CABDOC.PC_IMP3) IMPUESTO3,                                                       
         SUM(DETDOC.CA_DOCU) CANTIDAD,                                                           
         SUM(DETDOC.PR_VENT)/count(*) PRECIOVENTASINIMP,                                                             
         SUM(DETDOC.IM_TOTA_DETA) TOTALPORLINEA,                          
         MAX(CABDOC.CO_ESTA_DOCU) ESTADODOC   
 FROM	 [CALW3ERP001].OFIRECA.dbo.TDDOCU_CLIE			AS DETDOC
         INNER JOIN [COSMOS-DB].OFIRECA.dbo.TCDOCU_CLIE AS CABDOC
			 ON	(CABDOC.NU_DOCU = DETDOC.NU_DOCU ) and                                                            
				(CABDOC.TI_DOCU = DETDOC.TI_DOCU ) and                                                            
				(CABDOC.CO_UNID = DETDOC.CO_UNID ) and                                                            
				(CABDOC.CO_EMPR = DETDOC.CO_EMPR )  
         INNER JOIN [COSMOS-DB].OFIRECA.dbo.TTSERV		AS SERV
			 ON		(DETDOC.CO_EMPR = SERV.CO_EMPR)                            
				AND (DETDOC.CO_SERV = SERV.CO_SERV) 
         INNER JOIN [COSMOS-DB].OFIRECA.dbo.TTUNID_NEGO	AS UNEG 
			 ON		(DETDOC.CO_EMPR = UNEG.CO_EMPR)                                          
				AND (DETDOC.CO_UNNE = UNEG.CO_UNNE)
         INNER JOIN [COSMOS-DB].OFIRECA.dbo.TMTIEN		AS TIEN
			 ON		(DETDOC.CO_EMPR = TIEN.CO_EMPR)                                  
				AND (DETDOC.CO_TIEN = TIEN.CO_TIEN)                                  
 WHERE		 CABDOC.CO_EMPR = '01'                                                       0
		 AND CABDOC.TI_DOCU = 'FAC'                                                
         AND(CABDOC.CO_ESTA_DOCU = 'ACT' OR CABDOC.CO_ESTA_DOCU = 'PAG')                                              
         AND CABDOC.NU_DOCU  like '%' + @NUMFACTURA                                                          
         AND CABDOC.CO_MONE = @TIPMONEDA                                                          
         AND CABDOC.CO_CLIE = @RUCCODIGO                   
         AND TIEN.DE_TIEN <>  'OLI PLUSPETROL'                                
GROUP BY	CABDOC.TI_DOCU, 
			CABDOC.NU_DOCU, 
			DETDOC.CO_SERV, 
			DETDOC.CO_UNNE, 
			DETDOC.CO_TIEN,
			SERV.DE_SERV,
			UNEG.DE_UNNE,
			TIEN.DE_TIEN                                
--ORDER BY TTSERV.DE_SERV  



