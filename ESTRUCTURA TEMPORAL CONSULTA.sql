USE [TERMINAL]
GO
DROP TABLE #dudu
CREATE TABLE #dudu
(
	INTER				VARCHAR(50),
	Nave				CHAR (4),                                        
	NumViaje			CHAR (10),
	Origen				CHAR (10), 
	NroContenedor		CHAR (11),                                        
	TamanioContenedor	CHAR (2),
	CondicionContenedor CHAR (2),                                         
	Destino				CHAR (2),                                        
	EsCargaPeligrosa	CHAR (2),  
	FlagImpoExpo		CHAR (1),   
	NaveViaje			CHAR (6),  
	estadoRegistro		CHAR (1),
	desnav08 			VARCHAR(30)
	) ON [PRIMARY]

GO

Begin                                  
		-- Se enviará la data hasta luego de 5 días de que la nave arribo/llego al puerto del Callao.               --        
		Declare @frecuencia int
		set @frecuencia=@frecuencia-7200        

		Declare @Fecha datetime                                        
		Set @Fecha =dateadd(n, @frecuencia,getdate())                                                                  
		                                   
			-- delete from CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT1 where interface='INTERFACE4' and Estado=1                               
			-- insert into CALW8BDSCOT.SSCO.dbo.Matriz_Interfaces_NPT_NPT1 (Interface,Nave,NumViaje,Origen,NroContenedor,TamanioContenedor,CondicionContenedor,Destino,EsCargaPeligrosa,FlagImpoExpo,NaveViaje,EstadoRegistro,NombreNave)          

		insert into #dudu -- (Interface,Nave,NumViaje,Origen,NroContenedor,TamanioContenedor,CondicionContenedor,Destino,EsCargaPeligrosa,FlagImpoExpo,NaveViaje,EstadoRegistro,NombreNave)          
			 select  DISTINCT        'INTERFACE4',                              
			 a.codnav08 Nave,                                        
			 a.numvia11 NumViaje,                                        
			 (case a.ptoori11 when 'E' then 'PAPM' else 'PDPW' end ) as Origen,                                        
			 b.codcon04 NroContenedor,                                        
			 b.codtam09 TamanioContenedor,                                         
			 (case b.codbol03 when 'MT' then 'VACIO' ELSE 'LLENO' end ) as CondicionContenedor,                                         
			 (case b.codbol03 when 'MT' then 'LVEVA' ELSE 'LVILL' end ) as Destino,                                        
			 (case isnull(b.codimo13,'') when '' then 0 ELSE 1 END) AS EsCargaPeligrosa,  
			 a.tipope11 FlagImpoExpo,a.navvia11  NaveViaje,  
			 CASE b.FLGSTA04 WHEN '0' THEN 1 WHEN '1' THEN 0 END AS estadoRegistro,  
			 D.desnav08  
			from DDCABMAN11 a (nolock)                                         
			 INNER JOIN DDCONTEN04 b (nolock)  ON a.navvia11=b.navvia11          
			 inner join DVCABCON18 d (nolock) ON a.navvia11=d.navvia11          
			
			WHERE                                         
			 a.TIPOPE11='D' and                                        
			 a.feclle11 >= @Fecha   and --'2013-04-30 00:00:00.000'        
			 b.sucursal in ('1','2','3','4') -- 2: Local Vacios                
			 AND b.FLGDES04 ='0'   -- Filtros para solo Neptunia 
End 
DECLARE @FILAS INT
SELECT @FILAS = COUNT(*) FROM #dudu
IF @FILAS > 0 
	BEGIN
	PRINT 'ENTRE...........'
	END
ELSE 
	BEGIN
	PRINT 'NADA...........'
	END

 
