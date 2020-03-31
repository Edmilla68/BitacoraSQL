CREATE procedure Camionaje_EliminaNoContabilizadasCircuitosCamionaje_ofisis_MGRCMS      
@nroCamionaje int,            
@Circuito char(3),            
@Ruc char(11)              
as            
      
IF @Circuito <> 'C00'          
BEGIN          
   IF rtrim(@Circuito) <> ''          
      begin        
      
  delete from [COSMOS-DATA].OFITESO.dbo.TCINFO_NEPT             
  where NU_SECU = @nroCamionaje and NU_CIRC = @Circuito and CO_PROV = @Ruc      
  and ST_TESO = 'N'  
  and CO_EMPR = '01'        
      
      END         
    ELSE         
      BEGIN         
      
 delete from [COSMOS-DATA].OFITESO.dbo.TCINFO_NEPT             
 where NU_SECU = @nroCamionaje and CO_PROV = @Ruc            
 and ST_TESO = 'N'        
  and CO_EMPR = '01'        
      end         
END         
else          
BEGIN          
 delete from [COSMOS-DATA].OFITESO.dbo.TCINFO_NEPT             
 where NU_SECU = @nroCamionaje and NU_CIRC > 'C50' and CO_PROV = @Ruc       
 and ST_TESO = 'N'        
  and CO_EMPR = '01'        
end          
return 0            
      
/*********************************************************************************************************/      
      
    
  