SELECT ROUTINE_NAME, ROUTINE_DEFINITION 
        FROM INFORMATION_SCHEMA.ROUTINES 
        WHERE ROUTINE_DEFINITION LIKE '%carga consolidada%' 
        AND ROUTINE_TYPE='PROCEDURE'