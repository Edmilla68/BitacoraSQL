CREATE procedure Camionaje_InsertaListaResumenbyCircuitosCamionaje_ofisis_MGRCMS        
/********************************************************************************          
Objetivo: Insertar el camionaje en la tabla de ofisis          
          
          
**********************************************************************************/          
@nroCamionaje int,                
@Circuito char(3),                
@Ruc char(11)                  
as        
  
  
SET XACT_ABORT on        
                
if @Circuito <> 'C00'             
 begin            
 insert into  [COSMOS-DATA].OFITESO.dbo.TCINFO_NEPT        
 (CO_EMPR,        
CO_PROV,        
TI_SERV_EXTE,        
ST_IGVS,        
NU_CIRC,        
NU_SECU,        
FE_INIC,        
FE_FINA,        
TI_AUXI_EMPR,        
CO_AUXI_EMPR,        
TI_ITEM_GAST,        
CO_DEST_FINA,        
TI_PROD_PPTO,        
TI_SERV_PPTO,        
CO_TIPO_CCTR,        
CO_COND_CCTR,        
CO_TAMA_CCTR,        
CO_LINE,        
CO_UNID,        
CO_NAVE_VIAJ,        
TI_ENTI_PPTO,        
CO_CLIE,        
NU_CANT,        
CO_UNME,        
IM_STOT,        
PR_UNIT,        
ST_TESO,        
TI_DOCU,        
NU_DOCU,        
FE_ACTU)                
 exec Camionaje_ListaResumenbyCircuitosCamionajeOfisis @nroCamionaje, @Circuito, @Ruc                
 end            
else            
 begin            
 insert into  [COSMOS-DATA].OFITESO.dbo.TCINFO_NEPT        
 (CO_EMPR,        
CO_PROV,        
TI_SERV_EXTE,        
ST_IGVS,        
NU_CIRC,        
NU_SECU,        
FE_INIC,        
FE_FINA,        
TI_AUXI_EMPR,        
CO_AUXI_EMPR,        
TI_ITEM_GAST,        
CO_DEST_FINA,        
TI_PROD_PPTO,        
TI_SERV_PPTO,        
CO_TIPO_CCTR,        
CO_COND_CCTR,        
CO_TAMA_CCTR,        
CO_LINE,        
CO_UNID,        
CO_NAVE_VIAJ,        
TI_ENTI_PPTO,        
CO_CLIE,        
NU_CANT,        
CO_UNME,        
IM_STOT,        
PR_UNIT,        
ST_TESO,        
TI_DOCU,        
NU_DOCU,        
FE_ACTU)                
 exec Camionaje_ListaResumenbyCircuitosCamionajeOfisisExclusivo @nroCamionaje, @Ruc                
 end            
return 0