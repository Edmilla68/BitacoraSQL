job
-- PASOS

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_TAR_TarifaCotizacion_Ident_Tarifa ON TAR_TarifaCotizacion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_FAC_Operacion ON FAC_Operacion
REORGANIZE; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_TARIFACOTIZACION_Ident_GrupoCotizacion_Ident_Tarifa								   ON	 TAR_GrupoGenCotizacionEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_GRUPOGENCOTIZACIONENTIDAD_Ident_Entidad                                            ON    TAR_GrupoGenCotizacionEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_GRUPOGENCOTIZACIONENTIDAD_Ident_ValorEntidad                                       ON    TAR_Tarifa
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_TAR_Tarifa                                                                              ON    FAC_Cliente
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_Cliente                                                                             ON    TAR_GrupoGenCotizacionCaracteristica
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_GRUPOGENCOTIZACIONCARACTERISTICA_Ident_ValorEntidad                                ON    FAC_CntDocumentoXCondicion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_FAC_CntDocumentoXCondicion_Ident_Documento                                             ON    FAC_Documento
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_FAC_Documento_TipoSustento_Sustento                                                     ON    FAC_Contabilizacion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_Contabilizacion_1                                                                   ON    FAC_Documento
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_FAC_Documento_Serie_Numero                                                              ON    FAC_OrdenRetiroContenedor
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_FAC_OrdenRetiroContenedor                                                               ON    FAC_CntOperacionXCondicion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_CntOperacionXCondicion                                                              ON    TAR_GrupoCotizacionEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_TAR_GrupoCotizacionEntidad                                                              ON    xxtmcliexx
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX NULLO                                                                                      ON    FAC_CntDocumentoXItemDocumento
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_CntDocumentoXItemDocumento                                                          ON    TAR_ValorEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_TAR_ValorEntidad                                                                        ON    TAR_GrupoGenCotizacionEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_GRUPOGENCOTIZACIONENTIDAD_Ident_GrupoGenerarCotizacion_Ident_ValorEntidad          ON    TAR_GrupoCotizacionCaracteristica
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IX_TAR_GrupoCotizacionCaracteristica                                                       ON    TAR_GrupoGenCotizacionCaracteristica
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_TAR_GRUPOGENCOTIZACIONCARACTERISTICA_Ident_GrupoGenerarCotizacion                      ON    FAC_OperacionXServicio
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_OperacionXServicio                                                                  ON    TAR_TarifaCotizacion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_TAR_GrupoCotizacionEntidad                                                              ON    TAR_GrupoCotizacionEntidad
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX UK_FAC_CntOperacion_Codigo                                                                 ON    FAC_CntOperacion
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_CntOperacionXOrdenServicio                                                          ON    FAC_CntOperacionXOrdenServicio
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_OrdenServicio                                                                       ON    FAC_OrdenServicio
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX NULL0                                                                                      ON    FAC_ValorCondicionAuxiliar
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_TAR_GrupoCotizacionCaracteristica                                                       ON    TAR_GrupoCotizacionCaracteristica
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX IDX_FAC_CntDocumentoXItemDocumento_Ident_CntDocumento                                      ON    FAC_CntDocumentoXItemDocumento
REORGANIZE ; 

USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX PK_FAC_CntDocumentoXCondicion                                                              ON    FAC_CntDocumentoXCondicion
REORGANIZE ; 
