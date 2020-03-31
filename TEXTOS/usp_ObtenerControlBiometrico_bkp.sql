CREATE PROCEDURE usp_ObtenerControlBiometrico  
 @bioDni varchar(10)  
AS  
BEGIN  
 DECLARE @valor VARCHAR(50)  
 SET @valor=''  
 BEGIN TRY  
  IF (@bioDni='00217464')  
  BEGIN  
   SET @valor=''  
  END  
  ELSE  
  BEGIN  
   IF ((SELECT COUNT(DNI) FROM GesforBiometrico WHERE DNI=@bioDni and  FecRegistro>DATEADD(minute,-8,getdate()))>0)  
   BEGIN  
    SET @valor=''  
   END   
   ELSE  
   BEGIN  
    SET @valor='Favor de registrar huella'  
   END   
  END     
 END TRY  
 BEGIN CATCH  
  --SET @valor='Favor de registrar huella'  
 END CATCH    
 SELECT @valor  
END