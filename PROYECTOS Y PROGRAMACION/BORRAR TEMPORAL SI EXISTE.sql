While @x <= @NFilas
Begin

	IF EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'#Temp') AND type in (N'U'))
	BEGIN
		DROP TABLE #Temp
	END

	SELECT	secuencia=IDENTITY(int, 1,1),IdEmpresa, IdOficina,IdSolicitudCompra,
		Cantidad,CantidadFacturada
	INTO	#Temp
	FROM	Cmp_SolicitudCompra
	.
	.
	.
	set @x=@x+1
End