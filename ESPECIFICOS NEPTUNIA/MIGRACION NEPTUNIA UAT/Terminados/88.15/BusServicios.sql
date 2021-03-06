USE [BusServicios]
GO
/****** Object:  StoredProcedure [dbo].[TMAN_SP_GUARDAR_ERROR]    Script Date: 07/03/2019 03:00:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TMAN_SP_GUARDAR_ERROR]     
(        
 @int_NumEnvioInterfaz INT,      
 @vch_NombreMetodo VARCHAR(100),    
 @vch_DescripcionError VARCHAR(MAX),        
 @dt_FechaCreacion DATETIME        
)        
AS        
BEGIN        
 INSERT INTO TMAN_TB_ERROR_WS (vch_NombreMetodo, int_NumEnvioInterfaz, vch_DescripcionError, dt_FechaCreacion)        
 VALUES(@vch_NombreMetodo, @int_NumEnvioInterfaz, @vch_DescripcionError, @dt_FechaCreacion)        
END
GO
/****** Object:  StoredProcedure [dbo].[TMAN_SP_GUARDAR_LOG_RECEPCION]    Script Date: 07/03/2019 03:00:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TMAN_SP_GUARDAR_LOG_RECEPCION]       
(            
 @int_NumEnvioInterfaz INT,          
 @vch_NombreMetodo VARCHAR(100),        
 @vch_XmlRecepcion VARCHAR(MAX),            
 @dt_FechaCreacion DATETIME            
)            
AS            
BEGIN            
 INSERT INTO TMAN_TB_LOG_RECEPCION (vch_NombreMetodo, int_NumEnvioInterfaz, vch_XmlRecepcion, dt_FechaCreacion)            
 VALUES(@vch_NombreMetodo, @int_NumEnvioInterfaz, @vch_XmlRecepcion, @dt_FechaCreacion)            
END
GO
