 BEGIN   
    select   
    @CO_EMPR = '16',   
    @CO_UNID = '002',  
    @CO_NAVE_VIAJ = navvia11,  
    @DE_NAVE_VIAJ =navvia11,  
    @DE_NAVE_VIAJ =DQNAVIER08.desnav08,   
    @CO_USUA_CREA = 'web'  
    from DDCABMAN11  
    LEFT JOIN DQNAVIER08  
     ON DDCABMAN11.codnav08 = DQNAVIER08.codnav08   
    WHERE navvia11 NOT IN   
    (  
    SELECT CO_NAVE_VIA1   
    FROM [cosmos-db].[OFIRECA].[DBO].TTNAVE_VIAJ  
    WHERE  CO_UNID = '002' AND CO_EMPR = '16'
    )  
   END  
   BEGIN  
    INSERT INTO [cosmos-db].[OFIRECA].[DBO].TTNAVE_VIAJ (  
     CO_NAVE_VIAJ,   
     CO_UNID,   
     CO_EMPR,   
     DE_NAVE_VIAJ,   
     CO_NAVE_VIA1,   
     CO_USUA_CREA,   
     FE_USUA_CREA,   
     CO_USUA_MODI,   
     FE_USUA_MODI  
     )  
    VALUES (  
     @CO_NAVE_VIAJ  
     ,@CO_UNID  
     ,@CO_EMPR  
     ,@DE_NAVE_VIAJ  
     ,@CO_NAVE_VIAJ  
     ,@CO_USUA_CREA  
     ,GETDATE()  
     ,@CO_USUA_CREA  
     ,GETDATE()  
     )  
   END  
 END  