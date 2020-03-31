--Servidor: CALW3ERP001
use OFITESO

declare @USRNUEVO  VARCHAR(200)
declare @USRMODELO VARCHAR(200)

use OFITESO

SET @USRNUEVO    = 'JOVEGA'
SET @USRMODELO   = 'LEVALDE'


INSERT INTO TRTGAS_USUA
SELECT TI_GAST,@USRNUEVO, --NUEVO
            CO_EMPR,
            'OFISIS',
            GETDATE(),
            'OFISIS',
            GETDATE()
FROM TRTGAS_USUA
WHERE CO_EMPR = '02'
and co_usua = @USRMODELO   -- ORIGEN 
and TI_GAST not in ( SELECT TI_GAST
FROM TRTGAS_USUA
WHERE CO_EMPR = '02' 
and co_usua = @USRNUEVO   --NUEVO 
)

INSERT INTO TRAUXI_USUA 
         (CO_USUA,  
           CO_AUXI_EMPR,  
           TI_AUXI_EMPR,  
           CO_EMPR,  
           CO_USUA_CREA,  
           FE_USUA_CREA,  
           CO_USUA_MODI,  
           FE_USUA_MODI ) 

 SELECT @USRNUEVO ,    --Nuevo --
         TRAUXI_USUA.CO_AUXI_EMPR,  
         TRAUXI_USUA.TI_AUXI_EMPR,  
         TRAUXI_USUA.CO_EMPR,  
         TRAUXI_USUA.CO_USUA_CREA,  
         TRAUXI_USUA.FE_USUA_CREA,  
         TRAUXI_USUA.CO_USUA_MODI,  
         TRAUXI_USUA.FE_USUA_MODI 
    FROM TRAUXI_USUA 
   WHERE ( TRAUXI_USUA.CO_EMPR = '02' ) AND 
         ( TRAUXI_USUA.CO_USUA = @USRMODELO )   --origen—