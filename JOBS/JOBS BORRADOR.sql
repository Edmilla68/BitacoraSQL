--********************** 
 --*********************
 
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_CntOperacionXCondicion ON FAC_CntOperacionXCondicion
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IX_TAR_GrupoCotizacionEntidad ON TAR_GrupoCotizacionEntidad
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_CntDocumentoXItemDocumento ON FAC_CntDocumentoXItemDocumento
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IX_TAR_ValorEntidad ON TAR_ValorEntidad
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IDX_TAR_GRUPOGENCOTIZACIONENTIDAD_Ident_GrupoGenerarCotizacion_Ident_ValorEntidad ON TAR_GrupoGenCotizacionEntidad
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IX_TAR_GrupoCotizacionCaracteristica ON TAR_GrupoCotizacionCaracteristica
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IDX_TAR_GRUPOGENCOTIZACIONCARACTERISTICA_Ident_GrupoGenerarCotizacion ON TAR_GrupoGenCotizacionCaracteristica
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_OperacionXServicio ON FAC_OperacionXServicio
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IDX_TAR_TARIFACOTIZACION_Ident_GrupoCotizacion_Ident_Tarifa ON TAR_TarifaCotizacion
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_TAR_GrupoCotizacionEntidad ON TAR_GrupoCotizacionEntidad
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  UK_FAC_CntOperacion_Codigo ON FAC_CntOperacion
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_CntOperacionXOrdenServicio ON FAC_CntOperacionXOrdenServicio
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_OrdenServicio ON FAC_OrdenServicio
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_TAR_GrupoCotizacionCaracteristica ON TAR_GrupoCotizacionCaracteristica
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  IDX_FAC_CntDocumentoXItemDocumento_Ident_CntDocumento ON FAC_CntDocumentoXItemDocumento
REORGANIZE ; 
GO
 
USE Neptunia_SGC_Produccion; 
GO
ALTER INDEX  PK_FAC_CntDocumentoXCondicion ON FAC_CntDocumentoXCondicion
REORGANIZE ; 
GO
 
