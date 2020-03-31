USE [ANALITICA]
GO

/****** Object:  StoredProcedure [dbo].[PI_CalculaCarteraTotal]    Script Date: 06/28/2017 10:26:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PI_CalculaCarteraTotal]
@CodFecCorte	    DATE,
@FecCorteRCC    DATE,
@FlgEjecucion    char(20) = 'SSSSSSSSSSSSSSS'

-- =======================================================================================================================
--  Descripción		:	Generar Información de la cartera Total de los Préstamos de Financiera Efectiva
--	Creador			:	Carlos Alberto Paco Vigo
--	Fecha Creación 	:	27/02/2017
--	Parámetros		:	@FecCorte		:	Fecha de Corte; Formato 'AAAAMMDD'
--						@FecCorteRCC	:	Fecha de Corte; Formato 'AAAAMMDD'
-- Tablas Lectura	:	MaestroBI.dbo.CreditosBI
--						PROMETEO_DW..DIM_AGENCIA
--						EFEDW.dbo.Dim_Articulos
--						EfectivaDW.dbo.Dim_Perfil_Riesgos
--						EFECTIVADW.dbo.Dim_Oficio
--						EFECTIVA..Dim_EstadoCivil
--						EFECTIVA.dbo.Personas
--						RCC_ConsolidaObligacionesClientes	
--						MAESTROBI..PlusCmeClientes
--						ANALITICA..EFE_CarteraTotal
-- Tablas Inserta	:	ANALITICA.dbo.EFE_CarteraTotal
-- Tablas Actualiza	:
-- =======================================================================================================================
		
AS

BEGIN 

set nocount on 
	---------------------------------------
	-- Declara variables globales .........
	---------------------------------------
	declare @NroRegistros	int = 0
	Declare @NroPaso		tinyint = 1
	declare @CodPaso		smallint	= 0		-- Por defecto 1 corresponde al paso Inserta Datos
	declare @mensaje		varchar(250)
	Declare @cCadena		varchar(200)
	Declare @CodError		bigint = 0
	Declare @LineaError		varchar(250)
	Declare @MensajeError	varchar(1000)

	Declare @CodTFecCorte	char(6) = substring(cast(@CodFecCorte as char(10)),1,4)+substring(cast(@CodFecCorte as char(10)),6,2)
	Declare @CodProceso		smallint =	PROCESOS.dbo.F_ConsultaCodigoProceso ('PI_CalculaCarteraTotal')
	Declare @NroEjecucion	int			= 0		-- El procedimiento entregará el N°	
	Declare @DecripPaso	varchar(1000)
	
	--Variables para el envio de correo
	Declare @DesAsunto Varchar(300),
			@DesMensaje Varchar(1000),
			@EmailDestino Varchar(200),
			@DesCabecera  Varchar(300),
			@CodNotificacion smallint,
			@tableHTML	varchar(max),
			@Cuentas    varchar(max);

	BEGIN TRY
		SET @NroRegistros = @@ROWCOUNT
		set @CodPaso  = @CodPaso+1
		print '------------------------------------------------------------------------------------------------------------------------'
		exec PROCESOS..P_ExecProcesoInicio	@NroEjecucion output,@CodProceso
		SET @mensaje  = '  1 - Inicio Proceso Cartera Total de Prestamos EFE. ' + @CodTFecCorte  + ' (NroEjecucion: ' + cast(@NroEjecucion as varchar(13)) + ')'
		TRUNCATE TABLE ANALITICA.dbo.EFE_CarteraTotal
		
		set @mensaje = @mensaje + space (97 - len(@mensaje)) + ' - '  + convert (varchar(20), GETDATE(), 113) + '.'
		print(@mensaje)

		------------------------------------------------------------------------------------------------------------------------
		--	2. Carga de archivo temporal #TmpBase ...............
		------------------------------------------------------------------------------------------------------------------------
		
		set @NroPaso = 2
		set	@DecripPaso='Carga de archivo temporal #TmpBase'
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('#TmpBase') IS NOT NULL DROP TABLE #TmpBase	
		
			SELECT DISTINCT 
				LTRIM(RTRIM(CAST(A.num_documento AS VARCHAR(12)))) num_documento,
				CAST(A.cod_tipo_documento AS CHAR(1)) cod_tipo_documento,				
				A.cod_credito, 
				cast(DATEADD(D,-1,DATEADD(M,1,'01/'+LTRIM(MONTH(A.fecha_desembolso))+'/'+LTRIM(YEAR(A.fecha_desembolso)))) as date) FecCorte, 
				cast(DATEADD(D,-1,DATEADD(M,0,'01/'+LTRIM(MONTH(A.fecha_desembolso))+'/'+LTRIM(YEAR(A.fecha_desembolso)))) as date) FecCorteRCC, 
				convert (char(6),A.fecha_desembolso, 112) CodFecDesembolso, 
				CASE WHEN a.cod_tipo_credito in (5,6,7,8,17,19,21,29) THEN 'Motos' 
					 WHEN a.cod_tipo_credito = 9					  THEN 'MejoramientoHogar' 
					 WHEN a.cod_tipo_credito = 10					  THEN 'Construcción' 
					 WHEN a.cod_tipo_credito = 11					  THEN 'Efectivo' 
					 ELSE 'Electro' 
				END TipoCredito, 
				A.fecha_desembolso,
				A.cod_agencia, 
				B.Agencia NomAgencia, 
				ISNULL(C.des_articulo,ISNULL(D.des_articulo,ISNULL(E.des_articulo,ISNULL(F.des_articulo,ISNULL(G.des_articulo,'')))))Nom_Articulo, 
				ISNULL(C.des_sub_grupo,ISNULL(D.des_sub_grupo,ISNULL(E.des_sub_grupo,ISNULL(F.des_sub_grupo,ISNULL(G.des_sub_grupo,'')))))Nom_Subgrupo, 
				C.des_grupo Marca,
				H.des_perfil_riesgos Perfil,
				A.fecha_ultimo_pago, 
				A.dias_atraso, 
				B.Empresa	NomEmpresa,
				A.cod_estado,
				CASE WHEN A.cod_estado IN (2,3) THEN 'VIGENTE' 
					 WHEN A.cod_estado IN (4,5) THEN 'VENCIDO' 
					 WHEN A.cod_estado = 6		THEN 'JUDICIAL'
					 WHEN A.cod_estado = 7		THEN 'CASTIGADO' 
					 WHEN A.cod_estado = 9		THEN 'CANCELADO' 
				END EstCredito,  
				A.monto_capital_01_08 + A.monto_capital_09_30 + A.monto_capital_31_60 + A.monto_capital_61_90 + A.monto_capital_91_120 + A.monto_capital_121_mas + A.monto_capital_vigente Capital,
				A.monto_interes_01_08 + A.monto_interes_09_30 + A.monto_interes_31_60 + A.monto_interes_61_90 + A.monto_interes_91_120 + A.monto_interes_121_mas + A.monto_interes_vigente Interes,
				(A.monto_capital_01_08 + A.monto_capital_09_30 + A.monto_capital_31_60 + A.monto_capital_61_90 + A.monto_capital_91_120 + A.monto_capital_121_mas + A.monto_capital_vigente +
				A.monto_interes_01_08 + A.monto_interes_09_30 + A.monto_interes_31_60 + A.monto_interes_61_90 + A.monto_interes_91_120 + A.monto_interes_121_mas + A.monto_interes_vigente) K_mas_I, 
				A.plazo,
				( case when A.cod_tipo_cuota = 0 then 30 else A.cod_tipo_cuota end) as cod_tipo_cuota,
				CASE WHEN A.cod_tipo_cuota = 7  THEN 'SEMANAL' 
					 WHEN A.cod_tipo_cuota = 30 THEN 'MENSUAL' 
					 ELSE '' 
				END TipoCuota, 
				A.cod_tipo_credito,
				CASE WHEN A.cod_tipo_credito = 9  THEN 'MEJORAMIENTO DE HOGAR'
					 WHEN A.cod_tipo_credito = 10 THEN 'CONSTRUCCION'
					 WHEN A.cod_tipo_credito = 11 THEN 'CREDITO EFECTIVO'
					 WHEN A.cod_tipo_credito = 12 THEN 'CREDITO COMERCIAL'
					 WHEN A.cod_tipo_credito = 13 THEN 'PRESTAMOS MES (MICROEMPRESA)'
					 WHEN A.cod_tipo_credito = 14 THEN 'PRESTAMOS DE CONSUMO (DEPENDIENTES)'
					 WHEN A.cod_tipo_credito = 17 THEN 'CREDITOS CONSUMO MENSUAL'
					 WHEN A.cod_tipo_credito = 19 THEN 'CREDITOS MES MENSUAL'
					 WHEN A.cod_tipo_credito = 21 THEN 'GARANTIA PRENDA VEHICULAR'
					 WHEN A.cod_tipo_credito = 24 THEN 'PRESTAMOS DE CONSUMO SEMANAL (DEPENDIENT'
					 WHEN A.cod_tipo_credito = 33 THEN 'PRESTAMOS MES - NO PREFERIDA' 
					 ELSE '' 
				END DescTipoCredito,
				A.monto_cuota, 
				A.num_cuotas_impagas, 
				A.num_cuotas_pagadas, 
				b.plaza NomPlaza,
				B.Region,
				B.Region_Cobranza,
				B.Region_Comercial,
				B.Region_Credito,
				A.monto_venta, 
				A.monto_inicial, 
				A.monto_tasa_efectiva_anual, 
				A.monto_tasa_efectiva_mensual				
			INTO #TmpBase
			FROM MaestroBI.dbo.CreditosBI					A
				LEFT JOIN PROMETEO_DW..DIM_AGENCIA			    B ON B.cod_agencia = A.cod_agencia
				LEFT JOIN EFEDW.dbo.Dim_Articulos				C ON C.cod_articulo = a.cod_articulo01 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				D ON D.cod_articulo = a.cod_articulo02 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				E ON E.cod_articulo = a.cod_articulo03 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				F ON F.cod_articulo = a.cod_articulo04 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EFEDW.dbo.Dim_Articulos				G ON G.cod_articulo = a.cod_articulo05 and c.cod_empresa=b.cod_empresa
				LEFT JOIN EfectivaDW.dbo.Dim_Perfil_Riesgos	H ON H.Cod_perfil_riesgos = A.cod_perfil_cli
			WHERE A.flag_sistema = 'SFI' AND A.fecha_corte =@CodFecCorte  AND A.fecha_desembolso > = '20130101'  

			
			SET @NroRegistros = @@ROWCOUNT
			exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
			Set @mensaje  = '  2 - Cálculo en Base de Datos - Carga en Tabla Temporal 					 - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
			print(@mensaje)	
			-- Crea indices a la tabla temporal ------------------------------------------------
			create index #TmpBase on #TmpBase(num_documento,cod_tipo_documento,FecCorte)
			create index #TmpBase_01 on #TmpBase(num_documento,cod_tipo_documento,cod_credito)
			------------------------------------------------------------------------------------
			UPDATE #TmpBase 
			SET num_documento = case	when cod_tipo_documento = '1' 
											then
												case when len(num_documento) = 11 then SUBSTRING(num_documento,3,8) ELSE right('00000000' + num_documento, 8) END
										when cod_tipo_documento = '2' 
											then right('000000000' + num_documento, 9)
										ELSE num_documento
								END;
		end

								
		------------------------------------------------------------------------------------------------------------------------
		--	3. Carga de archivo temporal #TmpBase_1 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 3
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('tempdb..#TmpBase_1') IS NOT NULL DROP TABLE #TmpBase_1			
			SELECT
				a.num_documento NumDocumento,
				CAST (A.cod_tipo_documento AS CHAR (1)) CodTipoDocumento,
				A.cod_credito, 
				A.Perfil,
				A.FecCorte, 
				A.FecCorteRCC, 
				DescTipoCredito,
				TipoCredito TipoNegocio,
				A.CodFecDesembolso, 
				A.fecha_desembolso,
				A.cod_agencia, 
				A.NomAgencia, 
				A.Nom_Articulo, 
				A.Nom_Subgrupo, 
				A.Marca,		
				A.fecha_ultimo_pago, 
				A.dias_atraso, 
				A.NomEmpresa, 
				A.cod_estado,
				A.EstCredito,  
				A.Capital,
				A.Interes,
				A.K_mas_I, 
				A.plazo,
				A.cod_tipo_cuota,
				A.TipoCuota, 
				A.monto_cuota, 
				A.num_cuotas_impagas, 
				A.num_cuotas_pagadas, 
				P.EdadActual as edad,
				B.flag_garante, 
				B.cod_oficio, 
				C.Nom_Oficio,
				B.monto_CME_aprobada, 
				B.num_hijos, 
				B.cod_estado_civil,
				D.NomEstadoCivil,
				A.NomPlaza, 
				A.Region,
				A.Region_Cobranza,
				A.Region_Credito,
				A.Region_Comercial, 
				A.monto_venta, 
				A.monto_inicial, 
				B.monto_renta_mensual,
				b.cod_cliente
			INTO #TmpBase_1
			FROM #TmpBase A
				LEFT JOIN MaestroBI.dbo.ClientesBI	B ON B.num_documento = cast(A.num_documento as bigint) AND B.cod_tipo_documento = A.cod_tipo_documento AND B.fecha_corte = A.FecCorte   -- COSR
				LEFT JOIN EFECTIVADW.dbo.Dim_Oficio		C ON C.Cod_Oficio = B.cod_oficio
				LEFT JOIN EFECTIVA..Dim_EstadoCivil	D ON D.CodEstadoCivil = B.cod_estado_civil 
				LEFT JOIN EFECTIVA.dbo.Personas       P ON P.NumDocumento = cast(A.num_documento as varchar(12)) AND P.CodTipoDocumento = A.cod_tipo_documento and P.CodTipoDocumento <>'*'
			SET @NroRegistros = @@ROWCOUNT
			exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
			Set @mensaje  = '  3 - Fin de Cálculo de Datos Personasles de los clientes. 				     - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
			print(@mensaje)	
		end
		
		------------------------------------------------------------------------------------------------------------------------
		--	4. Carga de archivo temporal #TmpBase_2 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 4
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
		
			IF OBJECT_ID('tempdb..#TmpBase_2') IS NOT NULL DROP TABLE #TmpBase_2
				SELECT B.NroOrden, A.* 
				INTO #TmpBase_2 
				FROM #TmpBase_1 A
					LEFT JOIN EFECTIVA.dbo.Personas B ON B.NumDocumento = A.NumDocumento AND B.CodTipoDocumento = A.CodTipoDocumento  and B.CodTipoDocumento <>'*'
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
				Set @mensaje  = '  4 - Carga Nro. de Orden. 												     - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
				print(@mensaje)					
				------- Crea indices a la tabla temporal-----------------
					CREATE  INDEX Idx_NroOrden ON #TmpBase_2 (NroOrden)
				---------------------------------------------------------				
		end
		
		------------------------------------------------------------------------------------------------------------------------
		--	5. Carga de archivo temporal #TmpBase_3 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 5
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('tempdb..#TmpBase_3') IS NOT NULL DROP TABLE #TmpBase_3
				SELECT 
				A.*, 
				ISNULL(B.ImpDeuda,0) ImpDeudaTotal_SF, 
				ISNULL(B.ImpDeudaPrestamoConsumo,0) ImpDeudaConsumo_SF
				INTO #TmpBase_3
				FROM #TmpBase_2 A
				LEFT JOIN RCC.dbo.RCC_ConsolidaObligacionesClientes B ON  B.FecCorteRCC = @FecCorteRCC  AND B.NroOrden = A.NroOrden --
				
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
				Set @mensaje  = '  5 - Cálculo de Deudas Actuales. 											 - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
				print(@mensaje)	
		end	
		------------------------------------------------------------------------------------------------------------------------
		--	6. Carga de archivo temporal #TmpBase_3 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 6
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('tempdb..#TmpBase_4') IS NOT NULL DROP TABLE #TmpBase_4				
				
				SELECT A.*, 
				ISNULL(CASE WHEN D.T2M IN (2,3,4,5,6,7) THEN '1' WHEN D.T2M IN (0,1,8) THEN '0' END, '')CC_2M, 
				ISNULL(CASE WHEN D.T3M IN (2,3,4,5,6,7) THEN '1' WHEN D.T3M IN (0,1,8) THEN '0' END, '')CC_3M, 
				ISNULL(CASE WHEN D.T6M IN (2,3,4,5,6,7) THEN '1' WHEN D.T6M IN (0,1,8) THEN '0' END, '')CC_6M, 
				ISNULL(CASE WHEN D.T9M IN (2,3,4,5,6,7) THEN '1' WHEN D.T9M IN (0,1,8) THEN '0' END, '')CC_9M,
				ISNULL(CASE WHEN D.T12M IN (2,3,4,5,6,7) THEN '1' WHEN D.T12M IN (0,1,8) THEN '0' END, '')CC_12M
				INTO #TmpBase_4
				FROM #TmpBase_3 A
				LEFT JOIN ANALITICA.dbo.Maduracion_Creditos D 
							ON		D.cod_credito = A.cod_credito 
							AND		D.Año = YEAR(A.fecha_desembolso) 
							AND		D.Mes = MONTH(A.fecha_desembolso) 
							AND		D.Sistema = 'SFI'
				 
							
				SET @NroRegistros = @@ROWCOUNT				
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
				Set @mensaje  = '  6 - Cálculo de Calidad de Cartera a 2,3,6,9 y 12 Meses. 			         - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
				print(@mensaje)	
								
		end	


		------------------------------------------------------------------------------------------------------------------------
		--	7. Valida existencia de duplicados ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 7
		if substring (@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('#duplicados') IS NOT NULL DROP TABLE #nulos
			select	cod_cliente CodCliente,
					cod_transaccion CodTrx,
					COUNT(1)	NumReg
			into	#duplicados			
			from	MAESTROBI..PlusCmeClientes
			GROUP BY cod_cliente,cod_transaccion
			HAVING COUNT(1)>1
			set @NroRegistros = @@ROWCOUNT
			if 	@NroRegistros > 0
			begin
				Set @mensaje =  '      Se han encontrado Registros Duplicados en la tabla MAESTROBI..PlusCmeClientes  -                   ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg.'
				print(@mensaje)

				Select @DesAsunto = NP.DesAsunto,
					   @DesMensaje = NP.DesMensaje,
					   @EmailDestino = NP.EmlDestinatario					   
				From PROCESOS..ProcesosNotificacionesPasos NP
				Where CodProceso = @CodProceso And NroPaso = @NroPaso And CodNotificacion = 1;
				
				--Envia Correo con Nro. de registros Duplicados
				Set @DesAsunto = @DesAsunto + ', Fecha de corte: ' + @CodTFecCorte
				Set @Cuentas = @EmailDestino

				SET @tableHTML = N'<H1 style="font-family: Arial, Helvetica, sans-serif; font-size: small">' + @DesMensaje + '</H1>' +
								 N'<table border="1" style="font-family: Tahoma; font-size: 12px"><tr>' +
								 N'<th>Cod. Origen</th><th>Origen</th></tr>' +
								 CAST ( ( SELECT td = A.CodCliente, '',							
								 				 td = A.CodTrx, ''
								 		  FROM #duplicados as A											
								 		  FOR XML PATH('tr'), TYPE
										) AS NVARCHAR(MAX) ) +
								 N'</table>'   +
								 N'<H2></H2>'
								 					

				EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'enviosbi',
				@recipients   = @Cuentas,
				@body         = @tableHTML,
				@body_format  = 'HTML',
				@subject      = @DesAsunto;
			
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, 'I',@CodError, @NroRegistros 
				print '      Reporte de Registros Duplicados, enviado por correo.'	
      		end
			else
			begin
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, 'I',@CodError, @NroRegistros 
				Set @mensaje  = '  7 - Validación satisfactoria de Reg. Duplicados -  PlusCmeClientes.        - ' + right('              ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'				
				print(@mensaje)
			end
		end
		------------------------------------------------------------------------------------------------------------------------
		--	8. Carga de archivo temporal #TmpBase_4 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 8
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin	
			IF OBJECT_ID('tempdb..#TmpCMEPlus') IS NOT NULL DROP TABLE #TmpCMEPlus			
				SELECT cm.cod_cliente as CodCliente, max(cm.cod_transaccion) as NroTransaccion
				into #TmpCMEPlus
				from	MAESTROBI..pluscmeclientes	cm	
				inner join #TmpBase_4 tmp4 on (cm.cod_cliente = tmp4.cod_cliente 
												and cast(cm.fec_corte as date) <= cast(@CodFecCorte as date))  
				group by cm.cod_cliente
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
				Set @mensaje  = '  8 - Cálculo de CMEPlus único por cliente. 							     - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'
				print(@mensaje)
				-- Crea indices a la tabla temporal --------------------
				create index Idx_CodCliente on #TmpCMEPlus (CodCliente)
				--------------------------------------------------------
				
		end	
		------------------------------------------------------------------------------------------------------------------------
		--	9. Carga de archivo temporal #TmpBase_4 ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 9
		if substring(@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
			IF OBJECT_ID('tempdb..#TmpBase_5') IS NOT NULL DROP TABLE #TmpBase_5
				SELECT  A.*, cm.mon_cme_plus as ImpCMEPlus -- elclcpcmep ---> mon_cme_plus
				 INTO #TmpBase_5
				 FROM #TmpBase_4 A left join #TmpCMEPlus tcm on ( a.cod_cliente = tcm.CodCliente ) 
									left join MAESTROBI..pluscmeclientes cm on ( cm.cod_cliente = a.cod_cliente and cm.cod_transaccion = tcm.NroTransaccion )
				SET @NroRegistros = @@ROWCOUNT
				exec PROCESOS..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'I', @CodError, @NroRegistros
				Set @mensaje  = '  9 - Proceso de Asignación de CMEPlus. 					    		     - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'				
				print(@mensaje)					
						
		end
		------------------------------------------------------------------------------------------------------------------------
		--	10. Inserta registros en tabla CONTA..CarteraCastigosMensual ...............
		------------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 10
		if substring (@FlgEjecucion,@NroPaso, 1) = 'S'
		begin
				INSERT INTO ANALITICA.dbo.EFE_CarteraTotal (
					NroOrden,			NumDocumento,		CodTipoDocumento,	FecCorte,			FecCorteRCC,
					FecDesembolso,		FecUltPago,			CodFecDesembolso,	CodCredito,			ImpDesembolso,
					ImpInicial,			ImpCuota,			Perfil,				DescTipoCredito,	TipoNegocio,
					CodAgencia,			NomAgencia,			NomEmpresa,			NomPlaza,			Region,
					Region_Cobranza,	Region_Comercial,	Region_Credito,		NomArticulo,		NomSubgrupo,
					Marca,				NroDiasAtraso,		CodEstCredito,		EstCredito,			Capital,
					Interes,			K_mas_I,			PlazoDias,			PlazoMeses,			CodTipoCuota,
					TipoCuota,			NroCuotasImpagas,	NroCuotasPagadas,	Edad,				FlgAval,
					CodOficio,			NomOficio,			ImpCMEAprobada,		NroHijos,			CodEstCivil,
					NomEstadoCivil,		ImpIngresos,		ImpDeudaTotal_SF,	ImpDeudaConsumo_SF,	CC_2M,
					CC_3M,				CC_6M,				CC_9M,				CC_12M,
					ImpCMEPlus )
				SELECT 
					NroOrden,						NumDocumento,						CodTipoDocumento,					FecCorte,							FecCorteRCC, 
					fecha_desembolso FecDesembolso,	fecha_ultimo_pago FecUltPago,		CodFecDesembolso,					cod_credito ,				monto_venta ImpDesembolso,		
					monto_inicial	ImpInicial,		monto_cuota ImpCuota,				Perfil,								DescTipoCredito,					TipoNegocio,
					cod_agencia CodAgencia,			NomAgencia,							NomEmpresa,							NomPlaza,							Region,	
					Region_Cobranza,				Region_Comercial,					Region_Credito,						Nom_Articulo,						Nom_Subgrupo,
					Marca,							dias_atraso NroDiasAtraso,			cod_estado CodEstCredito,			EstCredito,							Capital,
					Interes,						K_mas_I,							plazo PlazoDias,					(plazo/cod_tipo_cuota) PlazoMeses,	cod_tipo_cuota CodTipoCuota,	
					TipoCuota,						num_cuotas_impagas NroCuotasImpagas,num_cuotas_pagadas NroCuotasPagadas,edad Edad,							flag_garante FlgAval,
					cod_oficio CodOficio,			Nom_Oficio,							monto_CME_aprobada ImpCMEAprobada,	num_hijos NroHijos,					cod_estado_civil CodEstCivil,
					NomEstadoCivil,					monto_renta_mensual ImpIngresos,	ImpDeudaTotal_SF,					ImpDeudaConsumo_SF,					CC_2M,
					CC_3M,							CC_6M,								CC_9M,								CC_12M,
					ImpCMEPlus
				FROM #TmpBase_5
				
				set @NroRegistros = @@ROWCOUNT
				exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso,@NroPaso, 'I',@CodError, @NroRegistros
				exec procesos..P_ExecProcesoFinal @NroEjecucion, @CodProceso
				Set @mensaje  = ' 10 - Inserta registros en tabla ANALITICA.dbo.EFE_CarteraTotal              - ' + right('             ' + LEFT(convert(varchar(20),cast(@NroRegistros as money),1),LEN(convert(varchar(20),cast(@NroRegistros as money),1))-3),13) + ' Reg. - ' + convert (varchar(20), GETDATE(), 113) + '.'								
				print(@mensaje)
		end

		-- ----------------------------------------------------------------------------------------------------------------------
		-- 11. Elimina tablas temporales ...............
		-- ----------------------------------------------------------------------------------------------------------------------
		set @NroPaso = 11
		if substring(@FlgEjecucion, @NroPaso, 1) = 'S'
		begin
			if OBJECT_ID('tempdb..#TmpBase') is not null drop table #TmpBase
			if OBJECT_ID('tempdb..#TmpBase_1') is not null drop table #TmpBase_1
			if OBJECT_ID('tempdb..#TmpBase_2') is not null drop table #TmpBase_2
			if OBJECT_ID('tempdb..#TmpBase_3') is not null drop table #TmpBase_3
			if OBJECT_ID('tempdb..#TmpBase_4') is not null drop table #TmpBase_4			
			if OBJECT_ID('tempdb..#TmpBase_5') is not null drop table #TmpBase_5
			if OBJECT_ID('tempdb.. #TmpCMEPlus') is not null drop table #TmpCMEPlus
			if OBJECT_ID('tempdb..#duplicados') is not null drop table #duplicados



			exec procesos..P_ExecProcesoPaso @NroEjecucion, @CodProceso, @NroPaso, 'D', @CodError, @NroRegistros
			exec PROCESOS..P_ExecProcesoFinal @NroEjecucion, @CodProceso
			Set @mensaje = '  19 - Fin Proceso de Proceso Cartera Total de Prestamos EFE (' + @CodTFecCorte  + ')                                         - '  + convert (varchar(20), GETDATE(), 113) + '.'
			
		end		

	---------------------------------------------------
	
	END TRY
	---------------------------------------------------
	-- Objeto que captura el error
	---------------------------------------------------
	BEGIN CATCH
		Error:
		set @CodError = ERROR_NUMBER()
		set @LineaError = ERROR_LINE()
		set @MensajeError= ERROR_MESSAGE()
		set @Mensaje = '  Error en el Paso Nro.:	' + cast (@NroPaso as varchar(2)) + ' - ' + @DecripPaso
		print @mensaje
		set @mensaje = '  Mensaje de error: ' + @MensajeError
		print @mensaje	
	END CATCH
END



GO

