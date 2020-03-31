USE dbneptunia
GO

/****** Object:  StoredProcedure [dbo].[busca_OBJTYPE]    Script Date: 11/14/2018 11:31:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:				EDUARDO MILLA
-- Create date: 
-- Description:	
-- =============================================
CREATE  PROCEDURE [dbo].[busca_OBJTYPE]
@OBJNAME			VARCHAR(250),
@OBJTYPE			VARCHAR(150) OUT,
@OBJSCRP			VARCHAR(MAX) OUT

AS

BEGIN
SET NOCOUNT ON;
	
	SELECT DISTINCT 
		@OBJTYPE = o.type_desc ,
		@OBJSCRP = m.definition 
	FROM sys.sql_modules m  
	INNER JOIN sys.objects  o ON m.object_id=o.object_id 
	WHERE o.name = @OBJNAME
	
END



GO

